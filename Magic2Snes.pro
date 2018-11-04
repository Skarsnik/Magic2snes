#-------------------------------------------------
#
# Project created by QtCreator 2018-01-20T14:24:06
#
#-------------------------------------------------

QT       += core gui quick websockets

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Magic2Snes
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


SOURCES += \
        main.cpp \
        magic2snesw.cpp \
        usb2snes\usb2snes.cpp \
    magicusb2snes.cpp \
    memory.cpp \
    rommapping/rommapping.c \
    rommapping/mapping_hirom.c \
    rommapping/mapping_lorom.c \
    debugconsole.cpp \
    bit.cpp

HEADERS += \
        magic2snesw.h \
        usb2snes\usb2snes.h \
    magicusb2snes.h \
    rommapping/rommapping.h \
    memory.h \
    debugconsole.h \
    bit.h

FORMS += \
        magic2snesw.ui \
    debugconsole.ui

RC_FILE = magic2snes.rc

RESOURCES += \
    jshelper.qrc \
    qmlfiles.qrc

DISTFILES += \
    magic2snes.rc \
    USB2SnesStatus.qml

