#ifndef MEMORY_H
#define MEMORY_H

#include <QObject>
#include "Savestate2snes/usb2snes.h"
#include "rommapping/rommapping.h"

class Memory : public QObject
{
    Q_OBJECT
public:
    explicit    Memory(QObject *parent = nullptr);
    void        setUsb2snes(USB2snes* usb);

signals:

public slots:
    void            setRomMapping(QString mappingName);
    void            cacheWram();
    qint16          readByte(unsigned int addr);
    quint16         readUnsignedByte(unsigned int addr);
    qint16          readWord(unsigned int addr);
    quint16         readUnsignedWord(unsigned int addr);
    qint32          readLong(unsigned int addr);
    quint32         readUnsignedLong(unsigned int addr);
    QByteArray      readRange(unsigned int addr, unsigned int size);

private:
    USB2snes* usb2snes;

    unsigned int    addrMapping(unsigned int addr);
    enum rom_type   rType;
    QByteArray      wramCache;
    bool            useWramCache;
    template<typename T>
    T readMemory(unsigned int addr, unsigned int n = sizeof(T));
};

#endif // MEMORY_H
