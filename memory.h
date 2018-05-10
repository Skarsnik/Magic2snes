#ifndef MEMORY_H
#define MEMORY_H

#include <QObject>
#include "usb2snes/usb2snes.h"
#include "rommapping/rommapping.h"

class Memory : public QObject
{
    Q_OBJECT
public:
    explicit    Memory(QObject *parent = nullptr);
    void        setUsb2snes(USB2snes* usb);
    void        clearCache();
    void        stopWork();
    void        resumeWork();

signals:

public slots:
    void            setRomMapping(QString mappingName);
    void            cacheWram();
    void            refreshCache(QString name = QString());
    qint16          readByte(unsigned int addr);
    quint16         readUnsignedByte(unsigned int addr);
    qint16          readWord(unsigned int addr);
    quint16         readUnsignedWord(unsigned int addr);
    qint32          readLong(unsigned int addr);
    quint32         readUnsignedLong(unsigned int addr);
    QByteArray      readRange(unsigned int addr, unsigned int size);
    bool            addNewCacheRange(QString name, unsigned int start, unsigned int size);
    void            printStats();

private:
    USB2snes* usb2snes;

    bool        m_stopOp;
    QMap<QString, QPair<unsigned int, unsigned int> >   toCache;
    QMap<QString, QByteArray>                           cachedStuff;
    unsigned int    addrMapping(unsigned int addr);
    enum rom_type   rType;
    QByteArray      wramCache;
    QMap<unsigned char, QByteArray>      cacheRom;
    bool            useWramCache;
    template<typename T>
    T readMemory(unsigned int addr, unsigned int n = sizeof(T));
    QMap<unsigned int, unsigned int>    memoryStat;
};

#endif // MEMORY_H
