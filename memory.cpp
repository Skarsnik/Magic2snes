#include "debugconsole.h"
#include "memory.h"

Q_LOGGING_CATEGORY(log_memory, "Memory")
#define sDebug() qCDebug(log_memory)

extern DebugConsole* debugConsole;

Memory::Memory(QObject *parent) : QObject(parent)
{
    rType = LoROM;
    useWramCache = false;
    wramCache.fill(0, 0x20000);
    m_stopOp = false;
}

void Memory::setUsb2snes(USB2snes *usb)
{
    usb2snes = usb;
}

void Memory::clearCache()
{
    cachedStuff.clear();
    cachedStuff.clear();
    toCache.clear();
}

void Memory::stopWork()
{
    m_stopOp = true;
}

void Memory::resumeWork()
{
    m_stopOp = false;
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

bool Memory::addNewCacheRange(QString name, unsigned int start, unsigned int size)
{
    sDebug() << "Adding new cache " << name << QString::number(start, 16) << size;
    toCache[name] = QPair<unsigned int, unsigned int>(start, size);
    return true;
}

unsigned int    Memory::usb2snesLocation(unsigned int addr)
{
    int pc_addr = rommapping_snes_to_pc(addr, rType, false);
    if (pc_addr > 0)
        return pc_addr;
    if (pc_addr == ROMMAPPING_LOCATION_WRAM)
    {
        if (addr < 0x7E0000)
            return 0xF50000 + addr;
        return 0xF50000 + (addr - 0x7E0000);
    }
    if (pc_addr == ROMMAPPING_LOCATION_SRAM)
    {
        addr = 0xE00000 + rommapping_sram_snes_to_pc(addr, rType, false);
    }
    return addr;
}

void Memory::refreshCache(QString name)
{
    if (!name.isNull())
    {
        if (toCache.contains(name))
        {
            sDebug() << "== Get Cache for : " << name << " - " << QString::number(toCache[name].first, 16) << "-" << toCache[name].second;
            cachedStuff[name] = usb2snes->getAddress(usb2snesLocation(toCache[name].first), toCache[name].second);
        }
    } else {
        QMapIterator<QString, QPair<unsigned int, unsigned int> > i(toCache);
        while (i.hasNext()) {
            i.next();
            sDebug() << "== Get Cache for : " << name << " - " << QString::number(i.value().first, 16) << "-" << i.value().second;
            cachedStuff[i.key()] = usb2snes->getAddress(usb2snesLocation(i.value().first), i.value().second);
        }
    }
}


qint16 Memory::readByte(unsigned int addr)
{
    return readMemory<qint8>(addr);
}

qint16 Memory::readSignedByte(unsigned int addr)
{
    return readMemory<qint8>(addr);
}

quint16 Memory::readUnsignedByte(unsigned int addr)
{
    return (quint8) readByte(addr);
}

quint16 Memory::readBCDByte(unsigned int addr)
{
    quint16 value = readUnsignedByte(addr);
    quint16 toret = value & 0x0F;
    toret += (value >> 4) * 10;
    return toret;
}

qint16 Memory::readWord(unsigned int addr)
{
    return readMemory<qint16>(addr);
}

qint16 Memory::readSignedWord(unsigned int addr)
{
    return readMemory<qint16>(addr);
}

quint16 Memory::readUnsignedWord(unsigned int addr)
{
    return (quint16) readWord(addr);
}

qint32 Memory::readLong(unsigned int addr)
{
    return readMemory<qint16>(addr);
}

qint32 Memory::readSignedLong(unsigned int addr)
{
    return readMemory<qint16>(addr);
}

quint32 Memory::readUnsignedLong(unsigned int addr)
{
    return (quint32) readLong(addr);
}

QByteArray Memory::readRange(unsigned int addr, unsigned int size)
{
    return usb2snes->getAddress(usb2snesLocation(addr), size);
}



void Memory::printStats()
{
    QMapIterator<unsigned int, unsigned int> i(memoryStat);
    while (i.hasNext()) {
        i.next();
        debugConsole->appendText(QString("%1 : %2").arg(i.key(), 6, 16).arg(i.value()));
    }
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
    T       toret = 0;

    if (m_stopOp)
        return toret;
    bool    wram = false;
    bool    sram = false;
    int     wramAddr = -1;
    unsigned int origAddr = addr;
    //sDebug() << "-------------------------------";
    //sDebug() << "Want to read" << QString::number(addr, 16);
    memoryStat[addr]++;
    int pc_addr = rommapping_snes_to_pc(addr, rType, false);
    if (pc_addr > 0)
        addr = pc_addr;
    if (pc_addr == ROMMAPPING_LOCATION_WRAM)
    {
        wram = true;
        wramAddr = addr;
        addr = usb2snesLocation(addr);
    }
    if (pc_addr == ROMMAPPING_LOCATION_SRAM)
    {
        //sDebug() << "Reading SRAM addr" << QString::number(origAddr, 16);
        addr = 0xE00000 + rommapping_sram_snes_to_pc(addr, rType, false);
        sram = true;
    }
    QByteArray data;
    if (pc_addr > 0) // ROM
    {
        unsigned char b = ((unsigned int) pc_addr) >> 16;
        unsigned int l = pc_addr - ((unsigned int) (b << 16));
        if (cacheRom.contains(b))
            data = cacheRom[b].mid(l, n);
        else
        {
            sDebug() << "Getting a rom address and caching the range" << QString::number(origAddr, 16);
            cacheRom[b] = usb2snes->getAddress((b << 4) & 0xFF0000, 0x10000);
            data = cacheRom[b].mid(l, n);
        }
    }
    if ((wram || sram) && !cachedStuff.isEmpty()) {
        QMapIterator<QString, QPair<unsigned int, unsigned int> > i(toCache);
        while (i.hasNext()) {
            i.next();
            QPair<unsigned int, unsigned int> p = i.value();
            if (origAddr >= p.first && origAddr <= p.first + p.second)
            {
                data = cachedStuff[i.key()].mid(origAddr - p.first, n);
                break;
            }
        }
    }
    if (wram && useWramCache)
        data = wramCache.mid(addr - 0xF50000, n);
    if (data.isNull()) {
        sDebug() << "Reading to usb2snes : " << QString::number(origAddr, 16) << n;
        data = usb2snes->getAddress(addr, n);
        if (data.isNull())
            return toret;
    }
    if (n == 1)
        return (T) data.at(0);
    //sDebug() << "data are : " << data.toHex();
    if (n == 2)
        toret = ((unsigned char) data.at(1)) << 8 | ((unsigned char) data.at(0));
    if (n == 3)
        toret = ((unsigned char) data.at(2)) << 16 | ((unsigned char) data.at(1)) << 8 | ((unsigned char) data.at(0));
    //sDebug() << "Returning " << toret;
    //sDebug() << "-------------------------------";
    return toret;
}
