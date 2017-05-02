#include "myserver.h"

MyServer::MyServer(QObject *parent) : QTcpServer(parent)
{
    pool = new QThreadPool(this);
    pool->setMaxThreadCount(4);
}

void MyServer::startServer()
{
    int port = 1234;
    if(listen(QHostAddress::Any,port))
    {
        qDebug() << "Listen...";
    }
    else
    {
        qDebug() << "server not started";
    }

}

void MyServer::incomingConnection(qintptr socketDescriptor)
{
    qDebug() << "incoming connection "<<socketDescriptor;
    ServerAnswer* answer = new ServerAnswer(socketDescriptor);
    answer->setAutoDelete(true);
    pool->start(answer);
}
