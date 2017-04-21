#ifndef MYTHREAD_H
#define MYTHREAD_H

#include <QThread>
#include <QDebug>
#include <QTimer>
#include "worker.h"

class myThread : public QThread
{
    Q_OBJECT
public:
    explicit myThread(QObject *parent = 0);
protected:
    void run();
private:
    Worker* worker;

signals:

public slots:
    void stop();
    void dispose();
};

#endif // MYTHREAD_H
