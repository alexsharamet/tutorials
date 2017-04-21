#include "sockettest.h"

SocketTest::SocketTest(QObject *parent) : QObject(parent)
{

}

void SocketTest::connect(){
    //connect
    socket = new QTcpSocket(this);
    socket->connectToHost("www.ya.ru",80);
    //socket->connectToHost("localhost",2345);

    if(socket->waitForConnected())
    {
        qDebug() << "Connect!";

        socket->write("HEAD / HTTP/1.0\r\n\r\n\r\n");
        socket->waitForBytesWritten(1000);

        socket->waitForReadyRead();
        qDebug() <<"Reading:" << socket->bytesAvailable();
        qDebug() <<socket->readAll();

        socket->close();
    }
    else
    {
        qDebug() << "Not Connected!";
    }
}
