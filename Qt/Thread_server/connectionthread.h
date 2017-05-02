#ifndef CONNECTIONTHREAD_H
#define CONNECTIONTHREAD_H

#include <QThread>
#include <QTcpSocket>
#include <QDebug>

class connectionThread : public QThread
{
    Q_OBJECT
public:
    explicit connectionThread(qintptr socketDescriptor,QObject *parent = 0);

signals:
    void error(QTcpSocket::SocketError socketerror);
public slots:
    void readyRead();
    void disconnected();
protected:
    void run();
private:
    qintptr socketDescriptor;
    QTcpSocket* socket;
};

#endif // CONNECTIONTHREAD_H
