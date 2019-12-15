import QtQuick 2.0
import USB2Snes 1.0
import "qrc:/extrajs.js" as Helper // Some extra javascript function
import "engine.js" as Engine
import QtQuick.Layouts 1.0

//import "AlttpItemListView.qml" // This please the designer, should not be needed
//import "SMItemListView.qml"


Rectangle {
    id : mainWin;
    width : 262
    height: 579

    color: "black"


    ListModel {
        id : smMisc
        ListElement {
            name : "Morphing ball"
            owned : false
        }
        ListElement {
            name : "Bombs"
            owned : false
        }
        ListElement {
            name : "Spring Ball"
            owned : false
        }
        ListElement {
            name : "Screw Attack"
            owned : false
        }
        ListElement {
            name : "X-Ray"
            owned : false
        }
    }

    ListModel {
        id : smBeams
        ListElement {
            name  : "Charge"
            owned : false
        }
        ListElement {
            name : "Ice"
            owned : false
        }
        ListElement {
            name : "Wave"
            owned : false
        }
        ListElement {
            name : "Spazer"
            owned : false
        }
        ListElement {
            name : "Plasma"
            owned : false
        }
        ListElement {
            name : "Grapple Beam"
            owned : false
        }
    }

    ListModel {
        id : smBoots
        ListElement {
            name : "Hi-Jump Boots"
            owned : false
        }
        ListElement {
            name : "Space Jump"
            owned : false
        }
        ListElement {
            name : "Speed Booster"
            owned : false
        }
    }
    ListModel {
        id : smSuits
        ListElement {
            name :  "Varia Suit"
            owned : false
        }
        ListElement {
            name : "Gravity Suit"
            owned : false
        }
    }

    ListModel {
        id : medaillonModel
        ListElement {
            name : "Quake"
            owned : false
        }
        ListElement {
            name : "Ether"
            owned : false
        }
        ListElement {
            name : "Bombos"
            owned : false
        }
    }

    ListModel {
        id : alttpWeaponModel
        ListElement {
            name : "No sword"
            owned : false
        }
        ListElement {
            name : "No Boomerang"
            owned : false
        }
        ListElement {
            name : "No Bow"
            owned : false
        }
        ListElement {
            name : "Hammer"
            owned : false
        }
        ListElement {
            name : "Firerod"
            owned : false
        }
        ListElement {
            name : "Icerod"
            owned : false
        }
        ListElement {
            name : "Hookshot"
            owned : false
        }
        ListElement {
            name : "Cane of Somaria"
            owned : false
        }
    }

    ListModel {
        id : alttpUtilities
        ListElement {
            name : "Pegasus boot"
            owned : false
        }
        ListElement {
            name : "Lantern"
            owned : false
        }
        ListElement {
            name : "Book"
            owned : false
        }
        ListElement {
            name : "No Gloves"
            owned : false
        }
        ListElement {
            name : "Flippers"
            owned : false
        }
        ListElement {
            name : "Moon Pearl"
            owned : false
        }
        ListElement {
            name : "Mirror"
            owned : false
        }

        ListElement {
            name : "Flute"
            owned : false
        }
        ListElement {
            name : "Shovel"
            owned : false
        }
        ListElement {
            name : "Bug Net"
            owned : false
        }
    }

    ListModel {
        id : alttpDefence
        ListElement {
            name : "No shield"
            owned : false
        }
        ListElement {
            name : "Green Tunic"
            owned : true
        }
    }

    Text {
        id: ammoText
        x: 0
        y: 27
        width: 262
        height: 14
        color: "#ffffff"
        text: qsTr("Ammo")
        horizontalAlignment: Text.AlignHCenter
        font.family: "Verdana"
        font.pixelSize: 12
    }



    USB2Snes {
        id : usb2snes
        objectName: "usb2snes" // Don't change this
        timer : 1000 // The interval timer value in ms. A frame is around 16 ms

        windowTitle : "SMAlttp Tracker"
        onInit: {
            Engine.init()
            //memory.refreshCache()
        }

        /* Main Code is actually here */

        onTimerTick: {
            Engine.refreshData()
            //gameRunning.text = Helper.sprintf("Current game running is %s", Engine.gameRunning)

            var samus = Engine.getSamusData()
            smMisc.setProperty(0, "owned", samus.morphball)
            smMisc.setProperty(1, "owned", samus.bombs)
            smMisc.setProperty(2, "owned", samus.springball)
            smMisc.setProperty(3, "owned", samus.screwattack)
            smMisc.setProperty(4, "owned", samus.xray)

            smBoots.setProperty(0, "owned", samus.boots.hijump)
            smBoots.setProperty(1, "owned", samus.boots.spacejump)
            smBoots.setProperty(2, "owned", samus.boots.speedbooster)

            smBeams.setProperty(0, "owned", samus.beams.charge)
            smBeams.setProperty(1, "owned", samus.beams.ice)
            smBeams.setProperty(2, "owned", samus.beams.wave)
            smBeams.setProperty(3, "owned", samus.beams.spazer)
            smBeams.setProperty(4, "owned", samus.beams.plasma)
            smBeams.setProperty(5, "owned", samus.beams.grapple)

            smSuits.setProperty(0, "owned", samus.suits.varia)
            smSuits.setProperty(1, "owned", samus.suits.gravity)

            energyText.text = Helper.sprintf("%d/%d   <font color='yellow'>R</font> %d/%d", samus.energy, samus.energymax, samus.reservemax, samus.reserve)
            ammoText.text = Helper.sprintf("M: %d/%03d    SM: %02d/%02d    PB: %02d/%02d", samus.ammo.missiles, samus.ammo.missilesmax,
                                           samus.ammo.supers, samus.ammo.supersmax,
                                           samus.ammo.pb, samus.ammo.pbmax)

            var link = Engine.getLinkData()
            var swordT = ["Fighter Sword", "Master Sword", "Tempered Sword", "Golden Sword"]
            if (link.swordlvl !== 0)
            {
                alttpWeaponModel.setProperty(0, "owned", true)
                alttpWeaponModel.setProperty(0, "name", swordT[link.swordlvl - 1])
            }
            if (link.weapons.boomerang !== 0)
            {
                var boomT = ["Blue Boomerang", "Red Boomerang"]
                alttpWeaponModel.setProperty(1, "owned", true)
                alttpWeaponModel.setProperty(1, "name", boomT[link.weapons.boomerang - 1])
            }
            if (link.weapons.bow !== 0)
            {
                var bowT = ["Regular Bow", "Silver Arrow"]
                alttpWeaponModel.setProperty(2, "owned", true)
                alttpWeaponModel.setProperty(2, "name", bowT[link.weapons.bow - 1])
            }

            alttpWeaponModel.setProperty(3, "owned", link.weapons.hammer)
            alttpWeaponModel.setProperty(4, "owned", link.weapons.firerod)
            alttpWeaponModel.setProperty(5, "owned", link.weapons.icerod)
            alttpWeaponModel.setProperty(6, "owned", link.weapons.hookshot)
            alttpWeaponModel.setProperty(7, "owned", link.somaria)

            medaillonModel.setProperty(0, "owned", link.medaillons.quake)
            medaillonModel.setProperty(1, "owned", link.medaillons.ether)
            medaillonModel.setProperty(2, "owned", link.medaillons.bombos)

            alttpUtilities.setProperty(0, "owned", link.boots)
            alttpUtilities.setProperty(1, "owned", link.lantern)
            alttpUtilities.setProperty(2, "owned", link.book)
            if (link.gloves !== 0)
            {
                var glovesT = ["Gloves", "Titan Mitts"]
                alttpUtilities.setProperty(3, "owned", true)
                alttpUtilities.setProperty(3, "name", glovesT[link.gloves - 1])
            }
            alttpUtilities.setProperty(4, "owned", link.flippers)
            alttpUtilities.setProperty(5, "owned", link.moonpearl)
            alttpUtilities.setProperty(6, "owned", link.mirror)
            alttpUtilities.setProperty(7, "owned", link.flute)
            alttpUtilities.setProperty(8, "owned", link.shovel)
            alttpUtilities.setProperty(9, "owned", link.bugnet)

            if (link.shield !== 0)
            {
                var shieldT = ["Shield", "Red Shield", "Mirror Shield"]
                alttpDefence.setProperty(0, "owned", true)
                alttpDefence.setProperty(0, "name", shieldT[link.shield - 1])
            }
            var tunicT = ["Green Tunic", "Blue Tunic", "Red Mail"]
            alttpDefence.setProperty(1, "name", tunicT[link.tunic])
            hpAmmoText.text = Helper.sprintf("HP: %02d/%02d   B: %02d/%02d   A: %02d/%02d",
                                             link.hearts.current, link.hearts.max,
                                             link.bombs.current, link.bombs.max,
                                             link.arrows.current, link.arrows.max)
            if (link.nbBottles !== 0)
                botteText.text = Helper.sprintf("Bottles : %d", link.nbBottles)


        }
        onEnd: {

        }
    }


    Text {
        id: text6
        x: 0
        y: 0
        width: 262
        height: 22
        color: "#ffffff"
        text: qsTr("Samus")
        horizontalAlignment: Text.AlignHCenter
        font.family: "Verdana"
        font.pixelSize: 18
    }

    Text {
        id: text7
        x: 0
        y: 277
        width: 262
        height: 22
        color: "#ffffff"
        text: qsTr("Link")
        horizontalAlignment: Text.AlignHCenter
        font.family: "Verdana"
        font.pixelSize: 18
    }
    Rectangle {
        id: lineRectangle
        x: 0
        y: 272
        width: 263
        height: 2
        color: "#ffffff"
        visible: true
    }

    AlttpItemListView {
        id: medaillonView
        headerText: "- Medaillon -"
        x: 11
        y: 474
        width: 74
        height: 64
        interactive: false
        model: medaillonModel
    }

    AlttpItemListView {
        id: alttpWeaponView
        headerText: "- Weapons -"
        x: 11
        y: 329
        width: 115
        height: 139
        model : alttpWeaponModel
    }

    SMItemListView {
        id: smMiscView
        x : 11
        y: 74
        width: 115
        height: 107
        headerText: "- Misc -"
        model : smMisc
    }

    SMItemListView {
        id: smBeamView
        x: 123
        y: 74
        width: 104
        height: 133
        headerText: "- Beam -"
        model : smBeams
    }

    SMItemListView {
        id: smBootsView
        x: 11
        y: 195
        width: 119
        height: 71
        headerText: "- Boots -"
        model : smBoots
    }

    SMItemListView {
        id: smSuitsView
        x: 123
        y: 211
        width: 87
        height: 52
        headerText: "- Suits -"
        model : smSuits
    }

    AlttpItemListView {
        id: alttpUtilityView
        x: 143
        y: 329
        width: 98
        height: 178
        headerText: "- Utility -"
        model : alttpUtilities
    }

    RowLayout {
        x: 59
        y: 45
        width: 200
        height: 16

        Rectangle {
            id: energyRectangle
            x: 0
            color: "#ffffff"
            Layout.rowSpan: 1
            transformOrigin: Item.Center
            Layout.preferredHeight: 10
            Layout.preferredWidth: 10

            Rectangle {
                id: rectangle2
                x: 2
                y: 2
                width: 8
                height: 8
                color: "#dd94ce"
            }
        }
        Text {
            id: energyText
            x: 12
            width: 200
            color: "#ffffff"
            text: qsTr("")
            Layout.fillWidth: true
            Layout.preferredHeight: 16
            Layout.preferredWidth: 262
            horizontalAlignment: Text.AlignLeft
            font.family: "Verdana"
            font.pixelSize: 13
        }
    }

    AlttpItemListView {
        id: alttpItemListView
        x: 143
        y: 513
        width: 98
        height: 49
        headerText: "- Defence -"
        model: alttpDefence
    }

       Text {
            id: hpAmmoText
            x: 24
            y: 310
            width: 208
            height: 13
            color: "#ffffff"
            text: qsTr("HP: 00/00   B:  00/00    A:  00/00")
            font.family: "Verdana"
            font.pixelSize: 12
       }

        Text {
            id: botteText
            x: 11
            y: 548
            color: "#ffffff"
            text: qsTr("No Bottle")
            font.family: "Verdana"
            font.pixelSize: 12
        }
}
