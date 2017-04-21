#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent)
{
    thread = new myThread(this);
    connect(this,SIGNAL(sigStop()),thread,SLOT(stop()),Qt::DirectConnection);
    thread->start();
}

void Controller::stop()
{
    emit sigStop();
}
