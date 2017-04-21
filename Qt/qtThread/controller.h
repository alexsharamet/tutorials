#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include "mythread.h"

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = 0);
    void stop();
private:
    myThread* thread;
signals:
    void sigStop();
public slots:
};

#endif // CONTROLLER_H
