#include "myserver.h"

MyServer::MyServer(QObject *parent) : QTcpServer(parent)
{

}

void MyServer::start()
{
    int port = 1234;

    if(this->listen(QHostAddress::Any,port))
    {
        qDebug() << "Listen ..." << port;
    }
    else
    {
        qDebug() << "Connection Failed";
    }
}

void MyServer::incomingConnection(qintptr socketDescriptor)
{
    qDebug() << "Connecting ... " << socketDescriptor;
    connectionThread* thread = new connectionThread(socketDescriptor,this);
    connect(thread,SIGNAL(finished()),thread,SLOT(deleteLater()));
    thread->start();
}
