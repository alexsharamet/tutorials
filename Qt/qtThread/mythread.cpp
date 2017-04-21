#include "mythread.h"

myThread::myThread(QObject *parent) : QThread(parent)
{

}

void myThread::run()
{
    qDebug()<<"thread running ..."<< QThread::currentThreadId();
    connect(this,SIGNAL(finished()),this,SLOT(dispose()));
    QTimer timer;
    worker = new Worker(); // add code here
    connect(&timer,SIGNAL(timeout()),worker,SLOT(doWork()));

    timer.start(1000);

    exec();
}

void myThread::stop()
{
    qDebug()<<"thread stop"<< QThread::currentThreadId();
    exit(0);
}

void myThread::dispose()
{
    qDebug() << "dispose";
    delete worker;
}
