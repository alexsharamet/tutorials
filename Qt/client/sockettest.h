#ifndef SOCKETTEST_H
#define SOCKETTEST_H

#include <QObject>
#include <QTcpSocket>
#include <QDebug>

class SocketTest : public QObject
{
    Q_OBJECT
public:
    explicit SocketTest(QObject *parent = 0);
    void connect();
signals:

public slots:

private:
    QTcpSocket *socket;
};

#endif // SOCKETTEST_H
