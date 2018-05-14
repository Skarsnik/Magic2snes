import QtQuick 2.0
import USB2Snes 1.0
import "qrc:/extrajs.js" as Helper // Some extra javascript function

/*
autotracking that can be a bit tricky because the games doesn't write directly to SRAM
so you gotta detect what game is active
and read the correct RAM addresses
For example when ALTTP is active, the current ALTTP items is at $7EF340 and up, and SM items are written directly to SRAM at $A16010 and up
But when SM is active it's the other way around
with SM items sitting at 7E09A2 and up, and ALTTP items at A17B00 and up
You can detect the currently running game though by reading SRAM $A173FE
$0000 is ALTTP, anything else is SM
  */

Rectangle {
    width : 400
    height: 500

    color: "black"

    property int lSMSRAM: 0xA16010
    property int lSMWRAM: 0x7E09A2
    property int lalttpSRAM : 0xA17B00
    property int lalttpWRAM : 0x7EF300
    property int lalttpRunning : 0xA173FE

    // https://github.com/tewtal/alttp_sm_combo_randomizer_rom/blob/master/src/z3/items.asm#L99
    // Offset by 2 to get the collected stuff and not equiped
    property var smitems_location : [
                            {name : "Varia Suit", offset : 2, flag : 0x0001},
                            {name : "Gravity Suit", offset : 2, flag : 0x0020},

                            {name : "Morphball", offset : 2, flag : 0x0004},
                            {name : "Bombs", offset : 2, flag : 0x1000},
                            {name : "Springball", offset : 2, flag : 0x0002},
                            {name : "Screw Attack", offset : 2, flag : 0x0008},

                            {name : "Hi-Jump Boots", offset : 2, flag : 0x0100},
                            {name : "Space Jump", offset : 2, flag : 0x0200},
                            {name : "Speed Booster", offset : 2, flag : 0x2000},

                            {name : "X-ray", offset : 2, flag : 0x8000},
                            {name : "Grapple beam", offset : 2, flag : 0x4000},
                            {name : "Charge Beam", offset : 0x06, flag : 0x1000},
                            {name : "Ice Beam", offset : 0x06, flag : 0x0002},
                            {name : "Wave Beam", offset : 0x06, flag : 0x0001},
                            {name : "Spazer", offset : 0x06, flag : 0x0004},
                            {name : "Plasma", offset : 0x06, flag : 0x0008}
                          ];
    property var smammos_location: [ {name : "E-tank", offset : 0x22, div : 100},
                            {name : "Reserve-tank", offset : 0x34, div : 100},
                            {name : "Missiles", offset : 0x26, div : 5},
                            {name : "Super Missiles", offset : 0x2A, div : 5},
                            {name : "Power bombs", offset : 0x2E, div : 5}
                          ];

    // https://github.com/tewtal/alttp_sm_combo_randomizer_rom/blob/master/src/sm/items.asm#L1440

    property var alttpitems: [{name : "Regular Bow", offset : 0x40, value : 0x0002},
                              {name : "Silver Arrow", offset : 0x40, value : 0x0003},
                              {name : "Blue Boomerang", offset : 0x41, value : 0x0001},
                              {name : "Red Boomerang", offset : 0x41, value : 0x0002},
                              {name : "Hookshot", offset : 0x42, value : 0x0001},
                              {name : "Mushroom", offset : 0x44, value : 0x0001},
                              {name : "Powder", offset : 0x44, value : 0x0002},
                              {name : "Firerod", offset : 0x45, value : 0x0001},
                              {name : "Icerod", offset : 0x46, value : 0x0001},
                              {name : "Bombos", offset : 0x47, value : 0x0001},
                              {name : "Ether", offset : 0x48, value : 0x0001},
                              {name : "Quake", offset : 0x49, value : 0x0001},
                              {name : "Lantern", offset : 0x4A, value : 0x0001},
                              {name : "Hammer", offset : 0x4B, value : 0x0001},
                              {name : "Shovel", offset : 0x4C, value : 0x0001},
                              {name : "Flute", offset : 0x4C, value : 0x0002},
                              {name : "Bug Net", offset : 0x4D, value : 0x0001},
                              {name : "Book", offset : 0x4E, value : 0x0001},
                              {name : "Bottle", offset : 0x4F, value : 0x0002},
                              {name : "Red Potion", offset : 0x4F, value : 0x0003},
                              {name : "Green Potion", offset : 0x4F, value : 0x0004},
                              {name : "Fairy", offset : 0x4F, value : 0x0005},
                              {name : "Bee", offset : 0x4F, value : 0x0006},
                              {name : "Gold Bee", offset : 0x4F, value : 0x0007},
                              {name : "Cane of Somaria", offset : 0x50, value : 0x0001},
                              {name : "Cane of Bryan", offset : 0x51, value : 0x0001},
                              {name : "Cape", offset : 0x52, value : 0x0001},
                              {name : "Mirror", offset : 0x53, value : 0x0001},
                              {name : "Gloves", offset : 0x54, value : 0x0001},
                              {name : "Titan Mitts", offset : 0x54, value : 0x0002},
                              {name : "Pegasus Boots", offset : 0x55, value : 0x0001},
                              {name : "Flippers", offset : 0x56, value : 0x0001},
                              {name : "Moon Pearl", offset : 0x57, value : 0x0001},
                              {name : "Fighter Sword", offset : 0x59, value : 0x0001},
                              {name : "Master Sword", offset : 0x59, value : 0x0002},
                              {name : "Tempered Sword", offset : 0x59, value : 0x0003},
                              {name : "Golden Sword", offset : 0x59, value : 0x0004},
                              {name : "Blue Tunic", offset : 0x5B, value : 0x0001},
                              {name : "Red Mail", offset : 0x5B, value : 0x0002},
                              {name : "Shield", offset : 0x5A, value : 0x0001},
                              {name : "Red Shield", offset : 0x5A, value : 0x0002},
                              {name : "Mirror Shield", offset : 0x5A, value : 0x0003},
                              {name : "Half Magic", offset : 0x7B, value : 0x0001},
                              {name : "Quarter Magic", offset : 0x7B, value : 0x0002}
                             ];
    property var alttpammos: [ { name : "Bombs", offsetmax : 0x70, offset : 0x75, base : 10},
                               { name : "Arrows", offsetmax : 0x71, offset : 0x76, base : 30},
                               { name : "Rupees", offsetmax : 0,  offset : 0x60, base : 0}
                             ];



    Text {
        id : gameRunning
        x : 50
        y : 0
        color : "white"
        text : ""
        font.pixelSize: 16
    }

    Text {
      id : smItem
      x: 0
      y: 40
      color : "white"
      text : ""
      font.pixelSize: 16
    }
    Text {
      id : smAmmo
      x: 150
      y: 40
      color : "white"
      text : ""
      font.pixelSize: 16
    }
    Text {
      id : alttpItem
      x: 0
      y: 200
      color : "white"
      text : ""
      font.pixelSize: 16
    }
    Text {
      id : alttpAmmo
      x: 150
      y: 200
      color : "white"
      text : ""
      font.pixelSize: 16
    }


    USB2Snes {
      id : usb2snes
      objectName: "usb2snes" // Don't change this
      timer : 1000 // The interval timer value in ms. A frame is around 16 ms

      onInit: {
          memory.setRomMapping("HiROM")
          memory.addNewCacheRange("SMSRAM", lSMSRAM, 0x100)
          memory.addNewCacheRange("SMWRAM", lSMWRAM, 0x100)

          memory.addNewCacheRange("alttpWRAM", lalttpWRAM, 0x100)
          memory.addNewCacheRange("alttpSRAM", lalttpSRAM, 0x100)
          //memory.refreshCache()
      }

      /* Main Code is actually here */

      onTimerTick: {
          var alttprun = memory.readUnsignedWord(lalttpRunning)
          var smLocation
          var alttpLocation
          if (alttprun === 0) // alttp is running
          {
              smLocation = lSMSRAM
              alttpLocation = lalttpWRAM
              memory.refreshCache("SMSRAM")
              memory.refreshCache("alttpWRAM")
              gameRunning.text = "Current game running is Zelda 3"
          } else {
              smLocation = lSMWRAM
              alttpLocation = lalttpSRAM
              memory.refreshCache("SMWRAM")
              memory.refreshCache("alttpSRAM")
              gameRunning.text = "Current game running is Super Metroid"
          }

          // SM item check
          var smTextItem = ""
          var smAmmoText = ""
          var i
          for(i = 0; i < smitems.length; i++)
          {
              var item = smitems[i]
              var foo = memory.readUnsignedWord(smLocation + item.offset)
              if ((foo & item.flag) === item.flag)
                  smTextItem += item.name + "\n"
          }
          smItem.text = smTextItem
          for (i = 0; i < smammos.length; i++)
          {
              var ammo = smammos[i]
              var foo2 = memory.readUnsignedWord(smLocation + ammo.offset)
              foo = memory.readUnsignedWord(smLocation + ammo.offset - 2)
              smAmmoText += Helper.sprintf("%s : %d / %d\n", ammo.name, foo, foo2)
          }
          smAmmo.text = smAmmoText

          // Alttp stuff
          var alttpTextItem = ""
          for(i = 0; i < alttpitems.length; i++)
          {
              item = alttpitems[i]
              foo = memory.readUnsignedByte(alttpLocation + item.offset)
              if (foo === item.value)
                  alttpTextItem += item.name + "\n"
          }
          alttpItem.text = alttpTextItem
          var alttpAmmoText = ""
          for (i = 0; i < alttpammos.length; i ++)
          {
              ammo = alttpammos[i]
              var ammomax = memory.readUnsignedByte(alttpLocation + ammo.offsetmax) + ammo.base
              var cur = memory.readUnsignedByte(alttpLocation + ammo.offset)
              if (ammo.offsetmax === 0)
                  alttpAmmoText += Helper.sprintf("Rupees : %d", cur)
              else
                  alttpAmmoText += Helper.sprintf("%s : %d / %d\n", ammo.name, cur, ammomax)
          }
          alttpAmmo.text = alttpAmmoText
      }
      onEnd: {
          //memory.printStats()
      }
     }

}
