#ifndef BIT_H
#define BIT_H

#include <QObject>

class Bit : public QObject
{
    Q_OBJECT
public:
    explicit Bit(QObject *parent = nullptr);

public slots:
    int     band(int l , int r);
    int     bor(int l, int r);
    int     bnot(int n);
    int     lshift(int t, int n);
    int     lrshift(int l, int s);

};

#endif // BIT_H
