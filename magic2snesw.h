#ifndef MAGIC2SNESW_H
#define MAGIC2SNESW_H

#include <QMainWindow>
#include <QQuickView>
#include "usb2snes/usb2snes.h"
#include "bit.h"
#include "memory.h"
#include "myqquickview.h"

namespace Ui {
class Magic2Snesw;
}

class Magic2Snesw : public QMainWindow
{
    Q_OBJECT

public:
    explicit Magic2Snesw(QWidget *parent = 0);
    ~Magic2Snesw();
    void    setAndRunScript(QString script);

private slots:
    void    onRecoTimerTick();

    void on_runScriptButton_clicked();

    void on_chooseScriptButton_clicked();

    void on_qmlViewClosing(QQuickCloseEvent*);

    void on_exitButton_clicked();

    void    onUsb2snesStateChanged();

    void    closeEvent(QCloseEvent *event);

    void on_refreshButton_clicked();

private:
    Ui::Magic2Snesw *ui;
    QString         scriptFile;
    MyQQuickView*   qmlViewer;
    USB2snes*       usb2snes;
    Memory*         memory;
    Bit*            bit;
    bool            autoRun;
    QSettings*      m_settings;
    bool            scriptRunning;
    QTimer          reco_timer;
};

#endif // MAGIC2SNESW_H
