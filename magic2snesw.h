#ifndef MAGIC2SNESW_H
#define MAGIC2SNESW_H

#include <QMainWindow>
#include <QQuickView>
#include "usb2snes/usb2snes.h"
#include "bit.h"
#include "memory.h"

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
    QQuickView*     qmlViewer;
    USB2snes*       usb2snes;
    Memory*         memory;
    Bit*            bit;
    bool            autoRun;
    QSettings*      m_settings;
};

#endif // MAGIC2SNESW_H
