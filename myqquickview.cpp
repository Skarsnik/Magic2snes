#include "myqquickview.h"

MyQQuickView::MyQQuickView()
{
    timer.setInterval(100);
    timer.setSingleShot(true);
    connect(&timer, &QTimer::timeout, [this] {magic->resumeTimer();});
}

void MyQQuickView::setMagic(MagicUSB2Snes *m)
{
    magic = m;
}


void MyQQuickView::moveEvent(QMoveEvent *)
{
    //qDebug() << "Move event";
    magic->pauseTimer();
    timer.start();
}
