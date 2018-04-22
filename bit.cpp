#include "bit.h"

Bit::Bit(QObject *parent) : QObject(parent)
{

}

int Bit::band(int l, int r)
{
    return l & r;
}

int Bit::bor(int l, int r)
{
    return l | r;
}

int Bit::bnot(int n)
{
    return n;
}

int Bit::lshift(int t, int n)
{
    return t << n;
}

int Bit::lrshift(int l, int s)
{
    return l >> s;
}
