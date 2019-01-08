
import QtQuick 2.0
import QtGraphicalEffects 1.0
import USB2Snes 1.0
import "qrc:/extrajs.js" as Helper // Some extra javascript function

Rectangle {
    width: 400
    height: 400
    color: "#000000"
    property var idToObject: {
        125 : sharpClaws,
                126 : airHerb,
                124 : giantLeaves,
                123 : speedShoes
    }

    USB2Snes {
        id : usb2snes
        objectName: "usb2snes" // Don't change this
        timer : 2000
        onTimerTick: {
            var iventoryData = memory.readRange(0x7F8000, 64)
            var inventory = new Uint8Array(iventoryData)
            var items = {}
            var cpt = 0
            for (cpt = 0; cpt < 64; cpt += 2)
            {
                if (inventory[cpt] !== 0)
                    items[inventory[cpt]] = inventory[cpt + 1]
            }
            for (var k in items)
            {
                if (idToObject.hasOwnProperty(k))
                    idToObject[k].owned = true
            }
        }
    }

    Grid {
        id: grid
        x: 0
        y: 0
        width: 400
        height: 400

        TrackerImage {
            id: airHerb
            width: 73
            height: 72
            source: "Images/airherb.png"
        }

        TrackerImage {
            id: giantLeaves
            width: 71
            height: 74
            source: "Images/giantleaves.png"
        }

        TrackerImage {
            id: speedShoes
            width: 77
            height: 70
            source: "Images/speedshoes.png"
        }

        TrackerImage {
            id: sharpClaws
            width: 82
            height: 86
            source: "Images/sharpclaws.png"
        }
    }

}

