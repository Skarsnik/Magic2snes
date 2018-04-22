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
        ui->runScriptButton->setEnabled(true);
    }
    //scriptFile = "D:/Project/Magic2snes/examples/smigtimer.qml";
    connect(qmlViewer, SIGNAL(closing(QQuickCloseEvent*)), this, SLOT(on_qmlViewClosing(QQuickCloseEvent*)));
    memory = new Memory();
    memory->setUsb2snes(usb2snes);
    bit = new Bit();
}

Magic2Snesw::~Magic2Snesw()
{
    delete ui;
}

void Magic2Snesw::on_runScriptButton_clicked()
{
    QUrl tmp = qmlViewer->source();
    if (tmp == QUrl::fromLocalFile(scriptFile))
    {
        qmlViewer->setSource(QUrl());
        qmlViewer->engine()->clearComponentCache();
    }
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
    MagicUSB2Snes* musb = obj->findChild<MagicUSB2Snes*>("usb2snes");
    qDebug() << musb;
    qDebug() << musb->timer();
    musb->setUSB2Snes(usb2snes);
    musb->startTimer();
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
    QQuickItem* obj = qmlViewer->rootObject();
    MagicUSB2Snes* musb = obj->findChild<MagicUSB2Snes*>("usb2snes");
    musb->stopTimer();
    obj->deleteLater();

}

void Magic2Snesw::on_exitButton_clicked()
{
    close();
}
