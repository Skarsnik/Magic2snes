#include "debugconsole.h"
#include "ui_debugconsole.h"

DebugConsole::DebugConsole(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::DebugConsole)
{
    ui->setupUi(this);
}

DebugConsole::~DebugConsole()
{
    delete ui;
}

void DebugConsole::appendText(QString str)
{
    ui->outputEdit->appendPlainText(str);
}
