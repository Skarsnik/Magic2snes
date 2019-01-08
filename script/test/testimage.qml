import QtQuick 2.0
import USB2Snes 1.0
import "qrc:/extrajs.js" as Helper // Some extra javascript function


Rectangle {
    width: 50
    height: 50


    USB2Snes {
        id : usb2snes
        objectName: "usb2snes" // Don't change this
        timer : 5000
        onTimerTick: {

        }
    }

    Image {
        id: image
        x: 0
        y: 0
        width: 42
        height: 42
        source: "Images/cheer.png"
    }
}
