#include "serveranswer.h"

ServerAnswer::ServerAnswer(qintptr socketDescriptor)
{
    this->socketDescriptor=socketDescriptor;
}


void ServerAnswer::run(){
    QTcpSocket* socket = new QTcpSocket();
    socket->setSocketDescriptor(socketDescriptor);
    socket->write("Hello Client!");
    socket->waitForBytesWritten();
    socket->flush();
}
