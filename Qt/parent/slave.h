#ifndef SLAVE_H
#define SLAVE_H

#include <QObject>
#include <QDebug>

class Slave : public QObject
{
    Q_OBJECT
public:
    explicit Slave(QObject *parent = 0);
    ~Slave();
    void send();
signals:
    void set(int);

public slots:
};

#endif // SLAVE_H
