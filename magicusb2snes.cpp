#include "magicusb2snes.h"

Q_LOGGING_CATEGORY(log_magic2snes, "Magic2Snes")
#define sDebug() qCDebug(log_magic2snes)

MagicUSB2Snes::MagicUSB2Snes(QObject *parent) : QObject(parent)
{
    //usb2snes = NULL;
    connect(&qtimer, SIGNAL(timeout()), this, SLOT(m_timerTick()));
    m_timer = 100;
    stopRunning = false;
    sDebug() << "Magic2usbsnes created";
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

void MagicUSB2Snes::startTimer()
{
    sDebug() << "Init";
    emit init();
    sDebug() << "Starting timer";
    qtimer.setInterval(m_timer);
    qtimer.start(m_timer);
}

void MagicUSB2Snes::stopTimer()
{
    stopRunning = true;
    qtimer.stop();
    emit end();
}

int MagicUSB2Snes::timer() const
{
    return m_timer;
}

QString MagicUSB2Snes::windowTitle() const
{
    return m_windowTitle;
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

void MagicUSB2Snes::m_timerTick()
{
    sDebug() << "==========================TIMER TICK==================";
    if (stopRunning == false)
        emit timerTick();
}



