#ifndef MASTER_H
#define MASTER_H

#include <QObject>
#include "slave.h"

class Master : public QObject
{
    Q_OBJECT
public:
    explicit Master(QObject *parent = 0);
    void send();
signals:

public slots:
    void setN(int n);
    void setK(int k);
private:
    Slave* slave;

public:
    int n;
    int k;
};

#endif // MASTER_H
