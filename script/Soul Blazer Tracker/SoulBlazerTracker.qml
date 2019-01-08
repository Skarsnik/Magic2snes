import QtQuick 2.0
import QtGraphicalEffects 1.0
import USB2Snes 1.0
import "qrc:/extrajs.js" as Helper // Some extra javascript function
import QtQuick.Layouts 1.3


Rectangle {
    width: 300
    height: 300
    id : window
    color : "black"

    property var idToObject: {
        1 : swordOfLife,
                2 : psychoSword,
                3 : criticalSword,
                4 : luckyBlade,
                5 : zantetsuSword,
                6 : spiritSword,
                7 : recoverySword,
                8 : soulBlade,

                9 : ironArmor,
                0xA : iceArmor,
                0xB : bubbleArmor,
                0xC : magicArmor,
                0xD : mysticArmor,
                0xE : lightArmor,
                0xF : elementalMail,
                0x10 : soulArmor,
                0x18 : magicPhoenix,
                0x22 : mushroomShoes,

                0x1C : dreamRod,
                0x1D : leoBrush,
                0x1E : greenLeaves,
                0x28 : platinumCard,
                0x29 : vipCard,

                0x32 : redHotMirror,
                0x33 : redHotBall,
                0x34 : redHotStick,
                0x35 : powerBracelet,
                0x36 : shieldBracelet,
                0x37 : superBracelet,

                0x3A : brownStone,
                0x3B : greenStone,
                0x3C : blueStone,
                0x3D : silverStone,
                0x3E : purpleStone,
                0x3F : blackStone
    }


    function setMinimalMode()
    {
        braceletRow.visible = false;
        luckyBlade.parent = miniItemRow;
        zantetsuSword.parent = miniItemRow;
        spiritSword.parent = miniItemRow;
        soulBlade.parent = miniItemRow;
        bubbleArmor.parent = miniItemRow;
        soulArmor.parent = miniItemRow;

        redHotBall.parent = phoenixRow;
        redHotMirror.parent = phoenixRow;
        redHotStick.parent = phoenixRow;
        magicPhoenix.parent = phoenixRow;
        grandMa1.parent = phoenixRow;
        grandMa2.parent = phoenixRow;
        mountainKing.parent = phoenixRow;

        dreamRod.parent = miniStuffRow;
        leoBrush.parent = miniStuffRow;
        greenLeaves.parent = miniStuffRow;
        mushroomShoes.parent = miniStuffRow;
        platinumCard.parent = miniStuffRow;
        vipCard.parent = miniStuffRow;

        villageChief.parent = npcRow;
        greenGuardian.parent = npcRow;
        mermaidQueen.parent = npcRow;
        nome.parent = npcRow;
        marie.parent = npcRow;
        kingMagridd.parent = npcRow;

        miniItemRow.parent = miniCol;
        phoenixRow.parent = miniCol;
        stoneRow.parent = miniCol;
        miniStuffRow.parent = miniCol;
        npcRow.parent = miniCol;



    }

    USB2Snes {
        id : usb2snes
        objectName: "usb2snes" // Don't change this
        windowTitle: "Soul Blazer Tracker" // The WindowTitle
        timer : 1000 // The interval timer value in ms. A frame is around 16 ms

        onInit: {
            setMinimalMode();
        }

        /* Main Code is actually here */

        onTimerTick: {
            var inventoryData = memory.readRange(0x7E1B1E, 64)
            var inventory = new Uint8Array(inventoryData)
            var items = {}
            var cpt = 0
            for (cpt = 0; cpt < 64; cpt += 1)
            {
                if (inventory[cpt] > 128)
                    inventory[cpt] -= 128
                items[inventory[cpt]] = 1
            }
            for (var p in idToObject)
            {
                idToObject[p].owned = false;
            }

            for (var k in items)
            {
                if (idToObject.hasOwnProperty(k))
                    idToObject[k].owned = true
            }
        }
    }
    Row {
        id: miniItemRow
        height: 45
        spacing: 2
    }
    Row {
        id: miniStuffRow
        height: 45
        spacing: 2
    }

    Column {
        id: miniCol
        spacing: 4
    }
    TrackerImage {
        id: grandMa1
        Layout.alignment: Qt.AlignHCenter
        height: 35
        width: 20
        source: "Images/grandma.png"
    }
    TrackerImage {
        id: grandMa2
        Layout.alignment: Qt.AlignHCenter
        height: 35
        width: 20
        source: "Images/grandma.png"
    }
    TrackerImage {
        id: mountainKing
        height: 45
        width: 45
        source: "Images/Mountain King.png"
    }
    Row {
        id: npcRow
        spacing: 2
    }

    TrackerImage {
        id: villageChief
        height: 45
        width : 45
        source: "Images/Village Chief.png"
    }
    TrackerImage {
        id: greenGuardian
        height: 45
        width : 45
        source: "Images/GGuardian.png"
    }
    TrackerImage {
        id: mermaidQueen
        height: 45
        width : 45
        source: "Images/Mermaid Queen.png"
    }
    TrackerImage {
        id: nome
        height: 45
        width : 45
        source: "Images/Nome.png"
    }
    TrackerImage {
        id: marie
        height: 45
        width : 45
        source: "Images/Marie.png"
    }
    TrackerImage {
        id: kingMagridd
        height: 45
        width : 45
        source: "Images/King Magridd.png"
    }

    Row {
        id: stoneRow
        height: 45
        spacing: 2

        TrackerImage {
            id: brownStone
            width: 45
            height: 45
            source: "Images/SB_Items_Brown_Stone.png"
        }

        TrackerImage {
            id: greenStone
            width: 45
            height: 45
            source: "Images/SB_Items_Green_Stone.png"
        }
        TrackerImage {
            id: blueStone
            width: 45
            height: 45
            source: "Images/SB_Items_Blue_Stone.png"
        }
        TrackerImage {
            id: silverStone
            width: 45
            height: 45
            source: "Images/SB_Items_Silver_Stone.png"
        }
        TrackerImage {
            id: purpleStone
            width: 45
            height: 45
            owned: false
            source: "Images/SB_Items_Purple_Stone.png"
        }
        Item {
            id : pikoItem
            width : 45
            height: 45
        TrackerImage {
            id: blackStone
            width: 45
            height: 45
            owned: false
            source: "Images/SB_Items_Black_Stone.png"
            onOwnedChanged: {
                console.debug("Piko")
                if (owned)
                    blackStoneEffect.visible = true;
                else
                    blackStoneEffect.visible = false;
            }
        }
        BrightnessContrast {
            anchors.fill: blackStone
            id : blackStoneEffect
            brightness: -0.5
            source : blackStone
            visible: false
        }
        }
    }

    Row {
        id: swordRow
        width: 380
        height: 58
        spacing: 2
    }

        TrackerImage {
            id: swordOfLife
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Weapon_Sword_of_Life.png"
        }
        TrackerImage {
            id: psychoSword
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Weapon_Psycho_Sword.png"
        }
        TrackerImage {
            id: criticalSword
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Weapon_Critical_Sword.png"
        }
        TrackerImage {
            id: luckyBlade
            width: 45
            height: 45
            source: "Images/SB_Weapon_Lucky_Blade.png"
        }
        TrackerImage {
            id: zantetsuSword
            width: 45
            height: 45
            source: "Images/SB_Weapon_Zantetsu_Sword.png"
        }
        TrackerImage {
            id: spiritSword
            width: 45
            height: 45
            source: "Images/SB_Weapon_Spirit_Sword.png"
        }
        TrackerImage {
            id: recoverySword
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Weapon_Recovery_Sword.png"
        }
        TrackerImage {
            id: soulBlade
            width: 45
            height: 45
            source: "Images/SB_Weapon_The_Soul_Blade.png"
        }


    Row {
        id: armorRow
        width: 371
        height: 55
        spacing: 2

    }
    TrackerImage {
            id: ironArmor
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Armor_Iron_Armor.png"
        }
        TrackerImage {
            id: iceArmor
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Armor_Ice_Armor.png"
        }
        TrackerImage {
            id: bubbleArmor
            width: 45
            height: 45
            source: "Images/SB_Armor_Bubble_Armor.png"
        }
        TrackerImage {
            id: magicArmor
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Armor_Magic_Armor.png"
        }
        TrackerImage {
            id: mysticArmor
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Armor_Mystic_Armor.png"
        }
        TrackerImage {
            id: lightArmor
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Armor_Light_Armor.png"
        }
        TrackerImage {
            id: elementalMail
            width: 45
            height: 45
            visible: false
            source: "Images/SB_Armor_Elemental_Mail.png"
        }
        TrackerImage {
            id: soulArmor
            width: 45
            height: 45
            source: "Images/SB_Armor_Soul_Armor.png"
        }

    TrackerImage {
        id: magicPhoenix
        width: 45
        height: 45
        source: "Images/SB_Magic_Phoenix.png"
    }
    Row {
        id: itemRow
        width: 310
        height: 45
        spacing: 2
    }
        TrackerImage {
            id: dreamRod
            width: 45
            height: 45
            source: "Images/SB_Items_Dream_Rod.png"
        }
        TrackerImage {
            id: greenLeaves
            width: 45
            height: 45
            source: "Images/SB_Items_Leaves.png"
        }
        TrackerImage {
            id: leoBrush
            width: 45
            height: 45
            source: "Images/SB_Items_Leos_Brush.png"
        }
        TrackerImage {
            id: mushroomShoes
            width: 45
            height: 45
            source: "Images/SB_Items_Mushroom_Shoes.png"
        }
        TrackerImage {
            id: platinumCard
            width: 45
            height: 45
            source: "Images/SB_Items_Platinum_Card.png"
        }
        TrackerImage {
            id: vipCard
            width: 45
            height: 45
            source: "Images/SB_Items_VIP_Card.png"
        }

    Row {
        id: phoenixRow
        width: 252
        height: 45
        spacing: 2
    }
        TrackerImage {
            id: redHotMirror
            width: 45
            height: 45
            source: "Images/SB_Items_Red-Hot_Mirror.png"
        }
        TrackerImage {
            id: redHotStick
            width: 45
            height: 45
            source: "Images/SB_Items_Red-Hot_Stick.png"
        }
        TrackerImage {
            id: redHotBall
            width: 45
            height: 45
            source: "Images/SB_Items_Red-Hot_Ball.png"
        }

    Row {
        id: braceletRow
        width: 225
        height: 61
        spacing: 2
        TrackerImage {
            id: powerBracelet
            width: 45
            height: 45
            source: "Images/SB_Items_Power_Bracelet.png"
        }
        TrackerImage {
            id: shieldBracelet
            width: 45
            height: 45
            source: "Images/SB_Items_Shield_Bracelet.png"
        }
        TrackerImage {
            id: superBracelet
            width: 45
            height: 45
            source: "Images/SB_Items_Super_Bracelet.png"
        }
    }


}

/*##^## Designer {
    D{i:13;invisible:true}D{i:14;invisible:true}D{i:15;invisible:true}D{i:31;invisible:true}
D{i:42;invisible:true}
}
 ##^##*/
