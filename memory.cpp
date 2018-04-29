#include "memory.h"

Memory::Memory(QObject *parent) : QObject(parent)
{
    rType = LoROM;
    useWramCache = false;
    wramCache.fill(0, 0x20000);
}

void Memory::setUsb2snes(USB2snes *usb)
{
    usb2snes = usb;
}

void Memory::setRomMapping(QString mappingName)
{
    if (mappingName.compare("LoROM", Qt::CaseInsensitive) == 0)
        rType = LoROM;
    if (mappingName.compare("HiROM", Qt::CaseInsensitive) == 0)
        rType = HiROM;
}

void Memory::cacheWram()
{
    useWramCache = true;
    wramCache = usb2snes->getAddress(0xF50000, 0x20000);
}


qint16 Memory::readByte(unsigned int addr)
{
    return readMemory<qint8>(addr);
}

quint16 Memory::readUnsignedByte(unsigned int addr)
{
    return (quint8) readByte(addr);
}

qint16 Memory::readWord(unsigned int addr)
{
    return readMemory<qint16>(addr);
}

quint16 Memory::readUnsignedWord(unsigned int addr)
{
    return (quint16) readWord(addr);
}

qint32 Memory::readLong(unsigned int addr)
{
    return readMemory<qint32>(addr, 3);
}

quint32 Memory::readUnsignedLong(unsigned int addr)
{
    return (quint32) readLong(addr);
}

QByteArray Memory::readRange(unsigned int addr, unsigned int size)
{
    return usb2snes->getAddress(addr, size);
}

unsigned int Memory::addrMapping(unsigned int addr)
{
    int pc_addr = rommapping_snes_to_pc(addr, rType, false);
    if (pc_addr > 0)
        return pc_addr;
    if (pc_addr == ROMMAPPING_LOCATION_WRAM)
    {
        return addr < 0x7E0000 ? 0xF50000 + addr : 0xF50000 + (addr - 0x7E0000);
    }
    if (pc_addr == ROMMAPPING_LOCATION_SRAM)
    {
        return 0xE00000 + rommapping_sram_snes_to_pc(addr, rType, false);
    }
}

template<typename T> T Memory::readMemory(unsigned int addr, unsigned int n) {
    T toret = 0;
    bool    wram = false;
    //qDebug() << "-------------------------------";
    //qDebug() << "Want to read" << QString::number(addr, 16);
    int pc_addr = rommapping_snes_to_pc(addr, rType, false);
    if (pc_addr > 0)
        addr = pc_addr;
    if (pc_addr == ROMMAPPING_LOCATION_WRAM)
    {
        wram = true;
        if (addr < 0x7E0000)
            addr = 0xF50000 + addr;
        else
            addr = 0xF50000 + (addr - 0x7E0000);
        /*if (addr >= 0x7F0000)
            addr = 0xF50000 + addr -*/
    }
    if (pc_addr == ROMMAPPING_LOCATION_SRAM)
    {
        addr = 0xE00000 + rommapping_sram_snes_to_pc(addr, rType, false);
    }
    QByteArray data;
    if (pc_addr > 0)
    {
        unsigned char b = ((unsigned int) pc_addr) >> 16;
        unsigned int l = pc_addr - ((unsigned int) (b << 16));
        if (cacheRom.contains(b))
            data = cacheRom[b].mid(l, n);
        else
        {
            cacheRom[b] = usb2snes->getAddress((b << 4) & 0xFF0000, 0x10000);
            data = cacheRom[b].mid(l, n);
        }
    }

    if (wram && useWramCache)
        data = wramCache.mid(addr - 0xF50000, n);
    if (data.isNull())
        data = usb2snes->getAddress(addr, n);
    if (n == 1)
        return (T) data.at(0);
    //qDebug() << "data are : " << data.toHex();
    if (n == 2)
        toret = ((unsigned char) data.at(1)) << 8 | ((unsigned char) data.at(0));
    if (n == 3)
        toret = ((unsigned char) data.at(2)) << 16 | ((unsigned char) data.at(1)) << 8 | ((unsigned char) data.at(0));
    //qDebug() << "Returning " << toret;
    //qDebug() << "-------------------------------";
    return toret;
}
