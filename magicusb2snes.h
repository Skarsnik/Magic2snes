#ifndef MAGICUSB2SNES_H
#define MAGICUSB2SNES_H

#include <QObject>
#include "usb2snes/usb2snes.h"

/*
 * This is the real USB2Snes class exposed in QML
 */

class MagicUSB2Snes : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int timer MEMBER m_timer NOTIFY timerChanged READ timer WRITE setTimer)

public:
    explicit    MagicUSB2Snes(QObject *parent = nullptr);
    void        setUSB2Snes(USB2snes* usnes);
    void        startTimer();
    void        stopTimer();

    int timer() const;

signals:

    void    timerChanged(int timer);
    void    timerTick();

public slots:


    void setTimer(int timer);

private:
    USB2snes*   usb2snes;
    int         m_timer;
    QTimer      qtimer;
};

#endif // MAGICUSB2SNES_H
