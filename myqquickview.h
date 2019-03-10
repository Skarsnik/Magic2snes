#ifndef MYQQUICKVIEW_H
#define MYQQUICKVIEW_H

#include "magicusb2snes.h"

#include <QObject>
#include <QQuickView>

class MyQQuickView : public QQuickView
{
    Q_OBJECT
public:
    MyQQuickView();
    void    setMagic(MagicUSB2Snes* m);


    // QWindow interface
protected:
    void moveEvent(QMoveEvent *);

private:
    QTimer         timer;
    MagicUSB2Snes* magic;

};

#endif // MYQQUICKVIEW_H
