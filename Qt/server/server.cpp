#include "server.h"

Server::Server(QObject *parent) : QObject(parent)
{
    server = new QTcpServer(this);
    connect(server,SIGNAL(newConnection()),this,SLOT(newConnection()));

    if(!server->listen(QHostAddress::Any,2345)){
        qDebug() << "server not started";
    }
    else
    {
        qDebug() << "server start";
    }
}

void Server::newConnection(){
    QTcpSocket* socket = server->nextPendingConnection();
    socket->write("Hello Client\n\r");
    socket->waitForBytesWritten(3000);
    socket->flush();

    socket->close();
}
