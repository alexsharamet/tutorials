#ifndef MYSERVER_H
#define MYSERVER_H

#include <QTcpServer>
#include <QThreadPool>
#include <QDebug>
#include "serveranswer.h"

class MyServer : public QTcpServer
{
    Q_OBJECT
public:
    explicit MyServer(QObject *parent = 0);
    void startServer();
protected:
    void incomingConnection(qintptr socketDescriptor);
private:
    QThreadPool* pool;
signals:

public slots:
};

#endif // MYSERVER_H
