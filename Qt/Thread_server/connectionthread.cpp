#include "connectionthread.h"

connectionThread::connectionThread(qintptr socketDescriptor, QObject *parent) : QThread(parent)
{
    this->socketDescriptor=socketDescriptor;
}

void connectionThread::readyRead()
{
    QByteArray data=socket->readAll();
    qDebug() << socketDescriptor << " Data in: " << data;
    socket->write(data);
}

void connectionThread::disconnected()
{
    qDebug() << "disconnect";
    socket->deleteLater(); //information can come and socket was deleted yet.
    exit(0);
}

void connectionThread::run()
{
    socket = new QTcpSocket();

    if(!socket->setSocketDescriptor(socketDescriptor))
    {
        emit error(socket->error());
        return;
    }

    connect(socket,SIGNAL(disconnected()),this,SLOT(disconnected()));
    connect(socket,SIGNAL(readyRead()),this,SLOT(readyRead()),Qt::ConnectionType::DirectConnection);
    qDebug() << "client connected";

    exec();
}

