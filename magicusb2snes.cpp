#include "magicusb2snes.h"

MagicUSB2Snes::MagicUSB2Snes(QObject *parent) : QObject(parent)
{
    usb2snes = NULL;
    connect(&qtimer, SIGNAL(timeout()), this, SIGNAL(timerTick()));
    m_timer = 100;
}

void MagicUSB2Snes::setUSB2Snes(USB2snes *usnes)
{
    qDebug() << "Set USB2snes";
    usb2snes = usnes;
}

void MagicUSB2Snes::startTimer()
{
    qDebug() << "Starting timer";
    qtimer.setInterval(m_timer);
    qtimer.start(m_timer);
}

void MagicUSB2Snes::stopTimer()
{
    qtimer.stop();
}

int MagicUSB2Snes::timer() const
{
    return m_timer;
}

void MagicUSB2Snes::setTimer(int timer)
{
    if (m_timer == timer)
        return;

    m_timer = timer;
    emit timerChanged(m_timer);
}



