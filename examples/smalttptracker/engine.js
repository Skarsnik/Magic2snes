
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

var lSMSRAM = 0xA16010
var lSMWRAM = 0x7E09A2
var lalttpSRAM = 0xA17B00
var lalttpWRAM = 0x7EF300
var lalttpRunning = 0xA173FE



// https://github.com/tewtal/alttp_sm_combo_randomizer_rom/blob/master/src/z3/items.asm#L99
// Offset by 2 to get the collected stuff and not equiped
 var smitems_location = { "Varia Suit" : {offset : 2, flag : 0x0001},
                        "Gravity Suit" : {offset : 2, flag : 0x0020},
                        "Morphball" : {offset : 2, flag : 0x0004},
                        "Bombs" : {offset : 2, flag : 0x1000},
                        "Springball" : {offset : 2, flag : 0x0002},
                        "Screw Attack" : {offset : 2, flag : 0x0008},

                        "Hi-Jump Boots" : {offset : 2, flag : 0x0100},
                        "Space Jump" : {offset : 2, flag : 0x0200},
                        "Speed Booster" : {offset : 2, flag : 0x2000},

                        "X-Ray" : {offset : 2, flag : 0x8000},
                        "Grapple Beam" : {offset : 2, flag : 0x4000},
                        "Charge Beam" : {offset : 0x06, flag : 0x1000},
                        "Ice Beam" : {offset : 0x06, flag : 0x0002},
                        "Wave Beam" : {offset : 0x06, flag : 0x0001},
                        "Spazer" : {offset : 0x06, flag : 0x0004},
                        "Plasma Beam" : {offset : 0x06, flag : 0x0008}
                      };
var smammos_location = {"E-tank" : {offset : 0x22, div : 100},
                        "Reserve-tank" : {offset : 0x34, div : 100},
                        "Missiles" : {offset : 0x26, div : 5},
                        "Super Missiles" : {offset : 0x2A, div : 5},
                        "Power Bombs" : {offset : 0x2E, div : 5}
                      };

// https://github.com/tewtal/alttp_sm_combo_randomizer_rom/blob/master/src/sm/items.asm#L1440

var alttpitems = { "Regular Bow" : { offset : 0x40, value : 0x0002},
                   "Silver Arrow" : { offset : 0x40, value : 0x0003},
                   "Blue Boomerang" : { offset : 0x41, value : 0x0001},
                   "Red Boomerang" : { offset : 0x41, value : 0x0002},
                   "Hookshot" : { offset : 0x42, value : 0x0001},
                   "Mushroom" : { offset : 0x44, value : 0x0001},
                   "Powder" : { offset : 0x44, value : 0x0002},
                   "Firerod" : { offset : 0x45, value : 0x0001},
                   "Icerod" : { offset : 0x46, value : 0x0001},
                   "Bombos" : { offset : 0x47, value : 0x0001},
                   "Ether" : { offset : 0x48, value : 0x0001},
                   "Quake" : { offset : 0x49, value : 0x0001},
                   "Lantern" : { offset : 0x4A, value : 0x0001},
                   "Hammer" : { offset : 0x4B, value : 0x0001},
                   "Shovel" : { offset : 0x4C, value : 0x0001},
                   "Flute" : { offset : 0x4C, value : 0x0002},
                   "Bug Net" : { offset : 0x4D, value : 0x0001},
                   "Book" : { offset : 0x4E, value : 0x0001},
                   "Bottle" : { offset : 0x4F, value : 0x0002},
                   "Cane of Somaria" : { offset : 0x50, value : 0x0001},
                   "Cane of Bryan" : { offset : 0x51, value : 0x0001},
                   "Cape" : { offset : 0x52, value : 0x0001},
                   "Mirror" : { offset : 0x53, value : 0x0002},
                   "Gloves" : { offset : 0x54, value : 0x0001},
                   "Titan Mitts" : { offset : 0x54, value : 0x0002},
                   "Pegasus Boots" : { offset : 0x55, value : 0x0001},
                   "Flippers" : {offset : 0x56, value : 0x0001},
                   "Moon Pearl" : { offset : 0x57, value : 0x0001},
                   "Fighter Sword" : { offset : 0x59, value : 0x0001},
                   "Master Sword" : { offset : 0x59, value : 0x0002},
                   "Tempered Sword" : { offset : 0x59, value : 0x0003},
                   "Golden Sword" : { offset : 0x59, value : 0x0004},
                   "Blue Tunic" : { offset : 0x5B, value : 0x0001},
                   "Red Mail" : { offset : 0x5B, value : 0x0002},
                   "Shield" : { offset : 0x5A, value : 0x0001},
                   "Red Shield" : { offset : 0x5A, value : 0x0002},
                   "Mirror Shield" : { offset : 0x5A, value : 0x0003},
                   "Half Magic" : { offset : 0x7B, value : 0x0001},
                   "Quarter Magic" : { offset : 0x7B, value : 0x0002}
                         };
var alttpammos = {  "Bombs" : {offsetmax : 0x70, offset : 0x43, base : 10},
                     "Arrows" : {offsetmax : 0x71, offset : 0x77, base : 30},
                     "Rupees" : {offsetmax : 0,  offset : 0x60, base : 0},
                     "Hearts" : {offsetmax : 0x6C, offset : 0x6D, base : 0}
                         };

var bottleContentName = [
    "No Bottle",
    "Nop",
    "Empty Bottle",
    "Red Potion",
    "Green Potion",
    "Blue Potion",
    "Fairy",
    "Bee",
    "Gold Bee"
]

var alttpBottlesArrayOffset = 0x5C

var smLocation
var alttpLocation
var gameRunning

function init() {
    memory.setRomMapping("HiROM")
    memory.addNewCacheRange("SMSRAM", lSMSRAM, 0x100)
    memory.addNewCacheRange("SMWRAM", lSMWRAM, 0x100)

    memory.addNewCacheRange("alttpWRAM", lalttpWRAM, 0x100)
    memory.addNewCacheRange("alttpSRAM", lalttpSRAM, 0x100)
}

function refreshData() {
    var alttprun = memory.readUnsignedWord(lalttpRunning)
    console.log(alttprun)
    if (alttprun === 0) // alttp is running
    {
        smLocation = lSMSRAM
        alttpLocation = lalttpWRAM
        memory.refreshCache("SMSRAM")
        memory.refreshCache("alttpWRAM")
        gameRunning = "Zelda 3"
    } else {
        smLocation = lSMWRAM
        alttpLocation = lalttpSRAM
        memory.refreshCache("SMWRAM")
        memory.refreshCache("alttpSRAM")
        gameRunning = "Super Metroid"
    }
}


function samusHas(what) {
    if (!(what in smitems_location))
    {
        console.error("key not found in sm item tab :", what)
        return;
    }
    var foo = memory.readUnsignedWord(smLocation + smitems_location[what].offset)
    //console.log(Helper.sprintf("Samus has %s : %04X", what, foo))
    return ((foo & smitems_location[what].flag) === smitems_location[what].flag)
}

function samusAmmo(what) {
    if (!(what in smammos_location))
    {
        console.error("key not found in sm item tab :", what)
        return;
    }
    var ammo = { max : memory.readUnsignedWord(smLocation + smammos_location[what].offset),
                 cur : memory.readUnsignedWord(smLocation + smammos_location[what].offset - 2)
    }
    return ammo
}

function linkHas(what) {
    if (!(what in alttpitems))
    {
        console.error("key not found in alttp item tab : ", what)
        return;
    }
    return memory.readUnsignedByte(alttpLocation + alttpitems[what].offset) === alttpitems[what].value
}

function linkAmmo(what) {
    if (!(what in alttpammos))
    {
        console.error("key not found in alttp ammos tab : ", what)
        return;
    }
    var ammo = { max : memory.readUnsignedByte(alttpLocation + alttpammos[what].offsetmax) + alttpammos[what].base,
                 cur : memory.readUnsignedByte(alttpLocation + alttpammos[what].offset)
    }
    return ammo
}

function getAlttpItemValue(what) {
    if (!(what in alttpitems))
    {
        console.error("key not found in alttp item tab : ", what)
        return;
    }
    return memory.readUnsignedByte(alttpLocation + alttpitems[what].offset)
}

function linkBottles() {
    var bottles = new Array(4)
    var pikomem

    for (var i = 0; i < 4; i++)
    {
        pikomem = memory.readUnsignedByte(alttpLocation + alttpBottlesArrayOffset + i)
        bottles[i] = {value : pikomem,
                      text : bottleContentName[pikomem]
        }
    }
    return bottles
}

function getSamusData() {
    var pbammo = samusAmmo("Power Bombs")
    var mammo = samusAmmo("Missiles")
    var smammo = samusAmmo("Super Missiles")
    var energy = samusAmmo("E-tank")
    var reserve = samusAmmo("Reserve-tank")

    var samus = {
    suits : { varia : samusHas("Varia Suit"),
              gravity : samusHas("Gravity Suit")
        },
    bombs : samusHas("Bombs"),
    morphball : samusHas("Morphball"),
    springball : samusHas("Springball"),
    screwattack : samusHas("Screw Attack"),
    xray : samusHas("X-Ray"),

    boots  : { hijump : samusHas("Hi-Jump Boots"),
               spacejump : samusHas("Space Jump"),
               speedbooster : samusHas("Speed Booster")
        },
    beams : { grapple : samusHas("Grapple Beam"),
              charge : samusHas("Charge Beam"),
              spazer : samusHas("Spazer"),
              wave : samusHas("Wave Beam"),
              plasma : samusHas("Plasma Beam"),
              ice : samusHas("Ice Beam")
        },
    ammo : { pb : pbammo.cur,
             pbmax : pbammo.max,
             missiles : mammo.cur,
             missilesmax : mammo.max,
             supers : smammo.cur,
             supersmax : smammo.max,
        },
    energy : energy.cur,
    energymax : energy.max,
    reserve : reserve.cur,
    reservemax : reserve.max
    }

    return samus
}

function getLinkData() {
    var linkArrow = linkAmmo("Arrows")
    var linkBombs = linkAmmo("Bombs")
    var linkHearts = linkAmmo("Hearts")
    //console.log("AZrrow", linkArrow.cur, linkArrow.max)
    var link = {
        swordlvl : getAlttpItemValue("Master Sword"),
        weapons : { bow : getAlttpItemValue("Regular Bow"),
                    hookshot : linkHas("Hookshot"),
                    firerod : linkHas("Firerod"),
                    icerod : linkHas("Icerod"),
                    boomerang : getAlttpItemValue("Blue Boomerang"),
                    hammer : linkHas("Hammer"),
        },
        bottles : 0,
        powdermushroom : getAlttpItemValue("Mushroom"),
        medaillons : { bombos : linkHas("Bombos"),
                      ether : linkHas("Ether"),
                      quake : linkHas("Quake")},
        lantern : linkHas("Lantern"),
        shovel : linkHas("Shovel"),
        flute : linkHas("Flute"),
        bugnet : linkHas("Bug Net"),
        book : linkHas("Book"),
        somaria : linkHas("Cane of Somaria"),
        byrna : linkHas("Cane of Bryan"),
        cape : linkHas("Cape"),
        gloves : getAlttpItemValue("Gloves"),
        boots : linkHas("Pegasus Boots"),
        flippers : linkHas("Flippers"),
        moonpearl : linkHas("Moon Pearl"),
        tunic : getAlttpItemValue("Red Mail"),
        shield : getAlttpItemValue("Shield"),
        halfmagic : getAlttpItemValue("Half Magic"),
        mirror : linkHas("Mirror"),

        rupees : memory.readUnsignedWord(alttpLocation + alttpammos["Rupees"].offset),
        arrows : {max : linkArrow.max, current : linkArrow.cur},
        bombs : {max : linkBombs.max, current : linkBombs.cur},
        hearts : {max : linkHearts.max / 8, current : linkHearts.cur / 8},
        bottles : linkBottles(),
        nbBottles : 0
    }
    var pikocpt = 0
    for (var i = 0; i < 4; i++) {
        if (link.bottles[i].value !== 0)
            pikocpt++
    }
    link.nbBottles = pikocpt
    return link
}

function getAlttpTimer() {
    return memory.readUnsignedWord(0xA17600)
}

function getSMTimer() {
    return memory.readUnsignedWord(0xA17600)
}
