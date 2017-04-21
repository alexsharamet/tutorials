#include "slave.h"

Slave::Slave(QObject *parent) : QObject(parent)
{
     qDebug() << "Slave Constructor";
}

Slave::~Slave()
{
    qDebug() << "Slave Destructor";
}

void Slave::send()
{
    emit set(100);
}
