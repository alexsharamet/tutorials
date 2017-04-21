#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <QDebug>
#include <QThread>

class Worker : public QObject
{
    Q_OBJECT
public:
    explicit Worker(QObject *parent = 0);

signals:

public slots:
    void doWork();
};

#endif // WORKER_H
