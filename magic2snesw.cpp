#include <QQmlError>
#include <QMessageBox>
#include <QQuickItem>
#include <QQmlContext>
#include <QQmlEngine>
#include <QFileDialog>

#include "memory.h"
#include "magic2snesw.h"
#include "ui_magic2snesw.h"
#include "magicusb2snes.h"

Q_LOGGING_CATEGORY(log_mainui, "MainUI")
#define sDebug() qCDebug(log_mainui)

Magic2Snesw::Magic2Snesw(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::Magic2Snesw)
{
    ui->setupUi(this);
    m_settings = new QSettings("skarsnik.nyo.fr", "Magic2SNES");
    qmlViewer = new QQuickView();
    qmlViewer->engine()->addImportPath(qApp->applicationDirPath() + "/extrajs/");
    usb2snes = new USB2snes();
    usb2snes->connect();
    qmlRegisterType<MagicUSB2Snes>("USB2Snes", 1, 0, "USB2Snes");
    if (!m_settings->value("lastScriptFile").toString().isEmpty())
    {
        scriptFile = m_settings->value("lastScriptFile").toString();
        ui->scriptLineEdit->setText(scriptFile);
        //ui->runScriptButton->setEnabled(true);
    }
    if (m_settings->contains("windowGeometry"))
    {
         restoreGeometry(m_settings->value("windowGeometry").toByteArray());
         restoreState(m_settings->value("windowState").toByteArray());
    }
    //scriptFile = "D:/Project/Magic2snes/examples/smigtimer.qml";
    reco_timer.setInterval(3000);
    connect(&reco_timer, SIGNAL(timeout()), this, SLOT(onRecoTimerTick()));
    connect(qmlViewer, SIGNAL(closing(QQuickCloseEvent*)), this, SLOT(on_qmlViewClosing(QQuickCloseEvent*)));
    connect(usb2snes, SIGNAL(stateChanged()), this, SLOT(onUsb2snesStateChanged()));
    memory = new Memory();
    memory->setUsb2snes(usb2snes);
    bit = new Bit();
    autoRun = false;
    scriptRunning = false;
}

Magic2Snesw::~Magic2Snesw()
{
    delete ui;
}

void Magic2Snesw::setAndRunScript(QString script)
{
    scriptFile = script;
    autoRun = true;
}

void Magic2Snesw::onRecoTimerTick()
{
    usb2snes->connect();
}

void Magic2Snesw::on_runScriptButton_clicked()
{
    if (scriptFile.isNull())
        return ;
    QUrl tmp = qmlViewer->source();
    if (tmp == QUrl::fromLocalFile(scriptFile))
    {
        qmlViewer->setSource(QUrl());
        qmlViewer->engine()->clearComponentCache();
    }
    QFileInfo fi(scriptFile);
    /*qmlViewer->engine()->addImportPath(fi.absolutePath());
    qDebug() << qmlViewer->engine()->importPathList();*/
    qmlViewer->setSource(QUrl::fromLocalFile(scriptFile));
    if (!qmlViewer->errors().empty())
    {
        QMessageBox mbox;
        mbox.setText(qmlViewer->errors().first().description());
        QString errmsg;
        foreach(QQmlError err, qmlViewer->errors())
        {
            errmsg.append(err.toString() + "\n");
        }
        mbox.setInformativeText(errmsg);
        mbox.exec();
        return;
    }

    QQuickItem* obj = qmlViewer->rootObject();
    qmlViewer->rootContext()->setContextProperty("memory", memory);
    qmlViewer->rootContext()->setContextProperty("bit", bit);
    qmlViewer->setTitle("Magic2snes - " + scriptFile);
    MagicUSB2Snes* musb = obj->findChild<MagicUSB2Snes*>("usb2snes");
    //musb->setUSB2Snes(usb2snes);
    //musb->setEngine(qmlViewer->engine());
    if (!musb->windowTitle().isEmpty())
        qmlViewer->setTitle(musb->windowTitle());
    memory->clearCache();
    memory->resumeWork();
    musb->startTimer();
    scriptRunning = true;
    qmlViewer->show();
}

void Magic2Snesw::on_chooseScriptButton_clicked()
{
    QString file = QFileDialog::getOpenFileName(this, tr("Choose a file"), QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation), tr("QML file (*.qml)"));
    if (!file.isEmpty())
    {
        scriptFile = file;
        ui->scriptLineEdit->setText(file);
        ui->runScriptButton->setEnabled(true);
        m_settings->setValue("lastScriptFile", scriptFile);
    }
}

void Magic2Snesw::on_qmlViewClosing(QQuickCloseEvent *)
{
    sDebug() << "Closing event";
    QQuickItem* obj = qmlViewer->rootObject();
    MagicUSB2Snes* musb = obj->findChild<MagicUSB2Snes*>("usb2snes");
    usb2snes->abortOp();
    memory->stopWork();
    musb->stopTimer();
    scriptRunning = false;
    QThread::usleep(200);
    obj->deleteLater();

}

void Magic2Snesw::on_exitButton_clicked()
{
    close();
}

void Magic2Snesw::onUsb2snesStateChanged()
{
    if (usb2snes->state() == USB2snes::Connected)
    {
        ui->statusLabel->setText("Connected to usb2snes webserver");
    }
    if (usb2snes->state() == USB2snes::Ready)
    {
        ui->runScriptButton->setEnabled(true);
        ui->statusLabel->setText("READY - " + usb2snes->firmwareString() + " - " + usb2snes->infos()[2]);
        usb2snes->setAppName("Magic2Snes");
        if (scriptRunning)
        {
            QQuickItem* obj = qmlViewer->rootObject();
            MagicUSB2Snes* musb = obj->findChild<MagicUSB2Snes*>("usb2snes");
            memory->clearCache();
            memory->resumeWork();
            musb->startTimer();
        }
        if (autoRun && !scriptRunning)
            on_runScriptButton_clicked();
    }
    if (usb2snes->state() == USB2snes::None)
    {
        ui->runScriptButton->setEnabled(false);
        ui->statusLabel->setText("Not connected to USB2Snes webserver");
        if (scriptRunning)
        {
            QQuickItem* obj = qmlViewer->rootObject();
            MagicUSB2Snes* musb = obj->findChild<MagicUSB2Snes*>("usb2snes");
            usb2snes->abortOp();
            memory->stopWork();
            musb->stopTimer();
        }
        if (autoRun)
            reco_timer.start();
    }
}

void Magic2Snesw::closeEvent(QCloseEvent *event)
{
    sDebug() << "Closing Event";
    Q_UNUSED(event)
    m_settings->setValue("windowState", saveState());
    m_settings->setValue("windowGeometry", saveGeometry());
}

void Magic2Snesw::on_refreshButton_clicked()
{
    if (usb2snes->state() == USB2snes::None)
        usb2snes->connect();
    if (usb2snes->state() == USB2snes::Ready)
      ui->statusLabel->setText("READY - " + usb2snes->firmwareString() + " - " + usb2snes->infos()[2]);
}
