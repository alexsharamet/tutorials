#include "worker.h"

Worker::Worker(QObject *parent) : QObject(parent)
{

}

void Worker::doWork()
{
    qDebug() << "doWork "<<QThread::currentThreadId();
}
