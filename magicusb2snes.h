#ifndef MAGICUSB2SNES_H
#define MAGICUSB2SNES_H

#include <QObject>
#include <QQmlEngine>
#include <QQuickItem>
#include "usb2snes/usb2snes.h"

/*
 * This is the real USB2Snes class exposed in QML
 */

class MagicUSB2Snes : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int timer MEMBER m_timer NOTIFY timerChanged READ timer WRITE setTimer)
    Q_PROPERTY(bool showStatus MEMBER m_showStatus NOTIFY showStatutChanged READ showStatus WRITE setShowStatus)
    Q_PROPERTY(QString windowTitle MEMBER m_windowTitle READ windowTitle MEMBER m_windowTitle WRITE setWindowTitle MEMBER m_windowTitle NOTIFY windowTitleChanged)

public:
    explicit    MagicUSB2Snes(QQuickItem *parent = nullptr);
    virtual     ~MagicUSB2Snes();
    void        setUSB2Snes(USB2snes* usnes);
    void        setEngine(QQmlEngine* engine);
    void        startTimer();
    void        stopTimer();

    int timer() const;

    QString windowTitle() const;


    bool showStatus() const;

signals:

    void    timerChanged(int timer);
    void    timerTick();
    void    init();
    void    end();

    void windowTitleChanged(QString windowTitle);

    void showStatutChanged(bool showStatus);

public slots:


    void setTimer(int timer);

    void setWindowTitle(QString windowTitle);


    void setShowStatus(bool showStatus);

private slots:
    void    m_timerTick();

private:
    bool        stopRunning;
//    USB2snes*   usb2snes;
    int         m_timer;
    QString     m_windowTitle;
    QTimer      qtimer;
    bool        m_showStatus;
    QObject*    statusObj;
};

#endif // MAGICUSB2SNES_H
