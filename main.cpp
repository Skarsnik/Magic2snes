#include "magic2snesw.h"
#include "debugconsole.h"
#include <QApplication>

DebugConsole* debugConsole;
static QTextStream cout(stdout);


void    myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
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
    qInstallMessageHandler(myMessageOutput);
    QApplication a(argc, argv);
    Magic2Snesw w;
    debugConsole = new DebugConsole();
    debugConsole->show();
    w.show();
    return a.exec();
}