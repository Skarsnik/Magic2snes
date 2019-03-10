#include "magicusb2snes.h"
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQmlContext>

Q_LOGGING_CATEGORY(log_magic2snes, "Magic2Snes")
#define sDebug() qCDebug(log_magic2snes)

MagicUSB2Snes::MagicUSB2Snes(QQuickItem *parent) : QQuickItem(parent)
{
    //usb2snes = NULL;
    connect(&qtimer, SIGNAL(timeout()), this, SLOT(m_timerTick()));
    m_timer = 100;
    stopRunning = false;
    sDebug() << "Magic2usbsnes created";
    m_showStatus = true;
}

MagicUSB2Snes::~MagicUSB2Snes()
{
    sDebug() << "Delete Magicusb2snes";
}

void MagicUSB2Snes::setUSB2Snes(USB2snes *usnes)
{
    sDebug() << "Set USB2snes";
    //usb2snes = usnes;
}

void MagicUSB2Snes::setEngine(QQmlEngine *engine)
{
    sDebug() << "Creating component";
    QQmlComponent component(qmlContext(this)->engine(), QUrl("qrc:///qml/USB2SnesStatus.qml"));
    sDebug() << component.errorString();
    statusObj = component.create(qmlContext(parentItem()));
    sDebug() << parentItem()->property("color");
    //statusObj->setProperty("visible", true);
    statusObj->setProperty("width", parentItem()->property("width").toInt());
    statusObj->setProperty("height", parentItem()->property("height").toInt());
    sDebug() <<  statusObj->property("width");
}

void MagicUSB2Snes::startTimer()
{
    sDebug() << "Init";
    emit init();
    sDebug() << "Starting timer";
    stopRunning = false;
    qtimer.setInterval(m_timer);
    qtimer.start(m_timer);
}

void MagicUSB2Snes::stopTimer()
{
    stopRunning = true;
    qtimer.stop();
    emit end();
}

void MagicUSB2Snes::pauseTimer()
{
    qtimer.stop();
}

void MagicUSB2Snes::resumeTimer()
{
    qtimer.start();
}

int MagicUSB2Snes::timer() const
{
    return m_timer;
}

QString MagicUSB2Snes::windowTitle() const
{
    return m_windowTitle;
}

bool MagicUSB2Snes::showStatus() const
{
    return m_showStatus;
}

void MagicUSB2Snes::setTimer(int timer)
{
    if (m_timer == timer)
        return;

    m_timer = timer;
    emit timerChanged(m_timer);
}

void MagicUSB2Snes::setWindowTitle(QString windowTitle)
{
    {
        if (m_windowTitle == windowTitle)
            return;

        m_windowTitle = windowTitle;
        emit windowTitleChanged(m_windowTitle);
    }
}

void MagicUSB2Snes::setShowStatus(bool showStatus)
{
    if (m_showStatus == showStatus)
        return;

    m_showStatus = showStatus;
    emit showStatutChanged(m_showStatus);
}

void MagicUSB2Snes::m_timerTick()
{
    sDebug() << "==========================TIMER TICK==================";
    if (stopRunning == false)
        emit timerTick();
}



