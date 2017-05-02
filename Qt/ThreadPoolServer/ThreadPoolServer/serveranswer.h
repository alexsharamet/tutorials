#ifndef SERVERANSWER_H
#define SERVERANSWER_H

#include <QTcpSocket>
#include <QRunnable>
#include <QDebug>

class ServerAnswer : public QRunnable
{
public:
    ServerAnswer(qintptr socketDescriptor);
    void run();

private:
    qintptr socketDescriptor;


};

#endif // SERVERANSWER_H
