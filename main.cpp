#include "magic2snesw.h"
#include "debugconsole.h"
#include <QDockWidget>
#include <QApplication>

DebugConsole* debugConsole = NULL;
static QTextStream cout(stdout);


void    myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    if (QString(context.category) == "default")
        if (debugConsole != NULL)
            debugConsole->appendText(msg);
    if (QString(context.category) == "js" || QString(context.category) == "qml")
    {
        /*cout << "For console debug\n";
        cout.flush();*/
        debugConsole->appendText(msg);
    }
    else
    {
        cout << QString("%1 : %2").arg(context.category, 20).arg(msg) << "\n";
        cout.flush();
    }
    /*cout << "End of log\n";
    cout.flush();*/
}

int main(int argc, char *argv[])
{
    QLoggingCategory::setFilterRules("qt.scenegraph.general=true");
    qInstallMessageHandler(myMessageOutput);
    QApplication a(argc, argv);
    Magic2Snesw w;
    QDockWidget dw(&w);
    dw.setObjectName("ConsoleDock");
    debugConsole = new DebugConsole();
    dw.setWidget(debugConsole);
    dw.setWindowTitle("Debug Console");
    w.addDockWidget(Qt::BottomDockWidgetArea, &dw);
    if (a.arguments().size() > 1)
    {
        //w.setAndRunScript("F:/Project/Magic2Snes/script/Soul Blazer Tracker/SoulBlazerTracker.qml");
        w.setAndRunScript(a.arguments().at(1));
    } else {
        w.show();
    }
    return a.exec();
}
