#include <QCoreApplication>
#include "controller.h"
#include <chrono>
#include <thread>


int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    qDebug()<<"Main thread "<<QThread::currentThreadId();
    Controller control;
    std::this_thread::sleep_for(std::chrono::milliseconds(5000));
    control.stop();

    return a.exec();
}
