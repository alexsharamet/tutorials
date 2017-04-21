#include <QCoreApplication>
#include "master.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    Master* master =  new Master();

    qDebug() << "n="<<master->n << "k="<<master->k;
    master->send();
    qDebug() << "n="<<master->n << "k="<<master->k;

    delete master;

    return a.exec();
}
