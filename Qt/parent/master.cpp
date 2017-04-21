#include "master.h"

Master::Master(QObject *parent) : QObject(parent)
{
     qDebug() << "Master Constructor";
     slave = new Slave(this); //set Parent!
     n = 0;
     k = 0;
     connect(slave,SIGNAL(set(int)),this,SLOT(setN(int)));
     connect(slave,SIGNAL(set(int)),this,SLOT(setK(int)));
}

void Master::send()
{
    slave->send();
}

void Master::setN(int n)
{
    this->n=n;
}

void Master::setK(int k)
{
    this->k=k;
}
