/*
  QML script are part of the Qt framework. They allow to write graphics interfaces
  in a simple and descriptive way. Read more on http://doc.qt.io/qt-5/gettingstartedqml.html

  This example only use one file, but you could have your code in a separate file
*/

// This is requiered
import QtQuick 2.0
import USB2Snes 1.0
import "qrc:/extrajs.js" as Helper // Some extra javascript function
import QtQuick.Controls 1.6
import QtQuick.Controls.Styles 1.4




Rectangle {
    width: 700
    height: 700
    id : window
    color : "black"
    property bool cachedWram: false
    property int mapId : 0

    Text {
      id : igTime
      x: 0
      y: 0
      color : "white"
      text : "00:00:00"
      font.pixelSize: 28
    }
    Text {
        id : infoSamus
        x: 0
        y: 46
        color : "white"
        text: "PIKO"
        font.pixelSize: 20
    }
    Text {
        id : tmapId
        x : 400
        y : 0
        color : "white"
        text: "PIKO"
        font.pixelSize: 20
    }

    Canvas {
      id: mycanvas
      width : 500
      height: 500
      // probably should move that in another file
      property var doors : {
                               0x88FE : true, 0x890A : true, 0x8916 : true, 0x8922 : true, 0x892E : true, 0x893A : true, 0x8946 : true, 0x8952 : true,
                               0x895E : true, 0x896A : true, 0x8976 : true, 0x8982 : true, 0x898E : true, 0x899A : true, 0x89A6 : true, 0x89B2 : true,
                               0x89BE : true, 0x89CA : true, 0x89D6 : true, 0x89E2 : true, 0x89EE : true, 0x89FA : true, 0x8A06 : true, 0x8A12 : true,
                               0x8A1E : true, 0x8A2A : true, 0x8A36 : true, 0x8A42 : true, 0x8A4E : true, 0x8A5A : true, 0x8A66 : true, 0x8A72 : true,
                               0x8A7E : true, 0x8A8A : true, 0x8A96 : true, 0x8AA2 : true, 0x8AAE : true, 0x8ABA : true, 0x8AC6 : true, 0x8AD2 : true,
                               0x8ADE : true, 0x8AEA : true, 0x8AF6 : true, 0x8B02 : true, 0x8B0E : true, 0x8B1A : true, 0x8B26 : true, 0x8B32 : true,
                               0x8B3E : true, 0x8B4A : true, 0x8B56 : true, 0x8B62 : true, 0x8B6E : true, 0x8B7A : true, 0x8B86 : true, 0x8B92 : true,
                               0x8B9E : true, 0x8BAA : true, 0x8BB6 : true, 0x8BC2 : true, 0x8BCE : true, 0x8BDA : true, 0x8BE6 : true, 0x8BF2 : true,
                               0x8BFE : true, 0x8C0A : true, 0x8C16 : true, 0x8C22 : true, 0x8C2E : true, 0x8C3A : true, 0x8C46 : true, 0x8C52 : true,
                               0x8C5E : true, 0x8C6A : true, 0x8C76 : true, 0x8C82 : true, 0x8C8E : true, 0x8C9A : true, 0x8CA6 : true, 0x8CB2 : true,
                               0x8CBE : true, 0x8CCA : true, 0x8CD6 : true, 0x8CE2 : true, 0x8CEE : true, 0x8CFA : true, 0x8D06 : true, 0x8D12 : true,
                               0x8D1E : true, 0x8D2A : true, 0x8D36 : true, 0x8D42 : true, 0x8D4E : true, 0x8D5A : true, 0x8D66 : true, 0x8D72 : true,
                               0x8D7E : true, 0x8D8A : true, 0x8D96 : true, 0x8DA2 : true, 0x8DAE : true, 0x8DBA : true, 0x8DC6 : true, 0x8DD2 : true,
                               0x8DDE : true, 0x8DEA : true, 0x8DF6 : true, 0x8E02 : true, 0x8E0E : true, 0x8E1A : true, 0x8E26 : true, 0x8E32 : true,
                               0x8E3E : true, 0x8E4A : true, 0x8E56 : true, 0x8E62 : true, 0x8E6E : true, 0x8E7A : true, 0x8E86 : true, 0x8E92 : true,
                               0x8E9E : true, 0x8EAA : true, 0x8EB6 : true, 0x8EC2 : true, 0x8ECE : true, 0x8EDA : true, 0x8EE6 : true, 0x8EF2 : true,
                               0x8EFE : true, 0x8F0A : true, 0x8F16 : true, 0x8F22 : true, 0x8F2E : true, 0x8F3A : true, 0x8F46 : true, 0x8F52 : true,
                               0x8F5E : true, 0x8F6A : true, 0x8F76 : true, 0x8F82 : true, 0x8F8E : true, 0x8F9A : true, 0x8FA6 : true, 0x8FB2 : true,
                               0x8FBE : true, 0x8FCA : true, 0x8FD6 : true, 0x8FE2 : true, 0x8FEE : true, 0x8FFA : true, 0x9006 : true, 0x9012 : true,
                               0x901E : true, 0x902A : true, 0x9036 : true, 0x9042 : true, 0x904E : true, 0x905A : true, 0x9066 : true, 0x9072 : true,
                               0x907E : true, 0x908A : true, 0x9096 : true, 0x90A2 : true, 0x90AE : true, 0x90BA : true, 0x90C6 : true, 0x90D2 : true,
                               0x90DE : true, 0x90EA : true, 0x90F6 : true, 0x9102 : true, 0x910E : true, 0x911A : true, 0x9126 : true, 0x9132 : true,
                               0x913E : true, 0x914A : true, 0x9156 : true, 0x9162 : true, 0x916E : true, 0x917A : true, 0x9186 : true, 0x9192 : true,
                               0x919E : true, 0x91AA : true, 0x91B6 : true, 0x91C2 : true, 0x91CE : true, 0x91DA : true, 0x91E6 : true, 0x91F2 : true,
                               0x91FE : true, 0x920A : true, 0x9216 : true, 0x9222 : true, 0x922E : true, 0x923A : true, 0x9246 : true, 0x9252 : true,
                               0x925E : true, 0x926A : true, 0x9276 : true, 0x9282 : true, 0x928E : true, 0x929A : true, 0x92A6 : true, 0x92B2 : true,
                               0x92BE : true, 0x92CA : true, 0x92D6 : true, 0x92E2 : true, 0x92EE : true, 0x92FA : true, 0x9306 : true, 0x9312 : true,
                               0x931E : true, 0x932A : true, 0x9336 : true, 0x9342 : true, 0x934E : true, 0x935A : true, 0x9366 : true, 0x9372 : true,
                               0x937E : true, 0x938A : true, 0x9396 : true, 0x93A2 : true, 0x93AE : true, 0x93BA : true, 0x93C6 : true, 0x93D2 : true,
                               0x93DE : true, 0x93EA : true, 0x93F6 : true, 0x9402 : true, 0x940E : true, 0x941A : true, 0x9426 : true, 0x9432 : true,
                               0x943E : true, 0x944A : true, 0x9456 : true, 0x9462 : true, 0x946E : true, 0x947A : true, 0x9486 : true, 0x9492 : true,
                               0x949E : true, 0x94AA : true, 0x94B6 : true, 0x94C2 : true, 0x94CE : true, 0x94DA : true, 0x94E6 : true, 0x94F2 : true,
                               0x94FE : true, 0x950A : true, 0x9516 : true, 0x9522 : true, 0x952E : true, 0x953A : true, 0x9546 : true, 0x9552 : true,
                               0x955E : true, 0x956A : true, 0x9576 : true, 0x9582 : true, 0x958E : true, 0x959A : true, 0x95A6 : true, 0x95B2 : true,
                               0x95BE : true, 0x95CA : true, 0x95D6 : true, 0x95E2 : true, 0x95EE : true, 0x95FA : true, 0x9606 : true, 0x9612 : true,
                               0x961E : true, 0x962A : true, 0x9636 : true, 0x9642 : true, 0x964E : true, 0x965A : true, 0x9666 : true, 0x9672 : true,
                               0x967E : true, 0x968A : true, 0x9696 : true, 0x96A2 : true, 0x96AE : true, 0x96BA : true, 0x96C6 : true, 0x96D2 : true,
                               0x96DE : true, 0x96EA : true, 0x96F6 : true, 0x9702 : true, 0x970E : true, 0x971A : true, 0x9726 : true, 0x9732 : true,
                               0x973E : true, 0x974A : true, 0x9756 : true, 0x9762 : true, 0x976E : true, 0x977A : true, 0x9786 : true, 0x9792 : true,
                               0x979E : true, 0x97AA : true, 0x97B6 : true, 0x97C2 : true, 0x97CE : true, 0x97DA : true, 0x97E6 : true, 0x97F2 : true,
                               0x97FE : true, 0x980A : true, 0x9816 : true, 0x9822 : true, 0x982E : true, 0x983A : true, 0x9846 : true, 0x9852 : true,
                               0x985E : true, 0x986A : true, 0x9876 : true, 0x9882 : true, 0x988E : true, 0x989A : true, 0x98A6 : true, 0x98B2 : true,
                               0x98BE : true, 0x98CA : true, 0x98D6 : true, 0x98E2 : true, 0x98EE : true, 0x98FA : true, 0x9906 : true, 0x9912 : true,
                               0x991E : true, 0x992A : true, 0x9936 : true, 0x9942 : true, 0x994E : true, 0x995A : true, 0x9966 : true, 0x9972 : true,
                               0x997E : true, 0x998A : true, 0x9996 : true, 0x99A2 : true, 0x99AE : true, 0x99BA : true, 0x99C6 : true, 0x99D2 : true,
                               0x99DE : true, 0x99EA : true, 0x99F6 : true, 0x9A02 : true, 0x9A0E : true, 0x9A1A : true, 0x9A26 : true, 0x9A32 : true,
                               0x9A3E : true, 0x9A4A : true, 0x9A56 : true, 0x9A62 : true, 0x9A6E : true, 0x9A7A : true, 0x9A86 : true, 0x9A92 : true,
                               0x9A9E : true, 0x9AAA : true, 0x9AB6 : true, 0xA18C : true, 0xA198 : true, 0xA1A4 : true, 0xA1B0 : true, 0xA1BC : true,
                               0xA1C8 : true, 0xA1D4 : true, 0xA1E0 : true, 0xA1EC : true, 0xA1F8 : true, 0xA204 : true, 0xA210 : true, 0xA21C : true,
                               0xA228 : true, 0xA234 : true, 0xA240 : true, 0xA24C : true, 0xA258 : true, 0xA264 : true, 0xA270 : true, 0xA27C : true,
                               0xA288 : true, 0xA294 : true, 0xA2A0 : true, 0xA2AC : true, 0xA2B8 : true, 0xA2C4 : true, 0xA2D0 : true, 0xA2DC : true,
                               0xA2E8 : true, 0xA2F4 : true, 0xA300 : true, 0xA30C : true, 0xA318 : true, 0xA324 : true, 0xA330 : true, 0xA33C : true,
                               0xA348 : true, 0xA354 : true, 0xA360 : true, 0xA36C : true, 0xA378 : true, 0xA384 : true, 0xA390 : true, 0xA39C : true,
                               0xA3A8 : true, 0xA3B4 : true, 0xA3C0 : true, 0xA3CC : true, 0xA3D8 : true, 0xA3E4 : true, 0xA3F0 : true, 0xA3FC : true,
                               0xA408 : true, 0xA414 : true, 0xA420 : true, 0xA42C : true, 0xA438 : true, 0xA444 : true, 0xA450 : true, 0xA45C : true,
                               0xA468 : true, 0xA474 : true, 0xA480 : true, 0xA48C : true, 0xA498 : true, 0xA4A4 : true, 0xA4B0 : true, 0xA4BC : true,
                               0xA4C8 : true, 0xA4D4 : true, 0xA4E0 : true, 0xA4EC : true, 0xA4F8 : true, 0xA504 : true, 0xA510 : true, 0xA51C : true,
                               0xA528 : true, 0xA534 : true, 0xA540 : true, 0xA54C : true, 0xA558 : true, 0xA564 : true, 0xA570 : true, 0xA57C : true,
                               0xA588 : true, 0xA594 : true, 0xA5A0 : true, 0xA5AC : true, 0xA5B8 : true, 0xA5C4 : true, 0xA5D0 : true, 0xA5DC : true,
                               0xA5E8 : true, 0xA5F4 : true, 0xA600 : true, 0xA60C : true, 0xA618 : true, 0xA624 : true, 0xA630 : true, 0xA63C : true,
                               0xA648 : true, 0xA654 : true, 0xA660 : true, 0xA66C : true, 0xA678 : true, 0xA684 : true, 0xA690 : true, 0xA69C : true,
                               0xA6A8 : true, 0xA6B4 : true, 0xA6C0 : true, 0xA6CC : true, 0xA6D8 : true, 0xA6E4 : true, 0xA6F0 : true, 0xA6FC : true,
                               0xA708 : true, 0xA714 : true, 0xA720 : true, 0xA72C : true, 0xA738 : true, 0xA744 : true, 0xA750 : true, 0xA75C : true,
                               0xA768 : true, 0xA774 : true, 0xA780 : true, 0xA78C : true, 0xA798 : true, 0xA7A4 : true, 0xA7B0 : true, 0xA7BC : true,
                               0xA7C8 : true, 0xA7D4 : true, 0xA7E0 : true, 0xA7EC : true, 0xA7F8 : true, 0xA810 : true, 0xA828 : true, 0xA834 : true,
                               0xA840 : true, 0xA84C : true, 0xA858 : true, 0xA864 : true, 0xA870 : true, 0xA87C : true, 0xA888 : true, 0xA894 : true,
                               0xA8A0 : true, 0xA8AC : true, 0xA8B8 : true, 0xA8C4 : true, 0xA8D0 : true, 0xA8DC : true, 0xA8E8 : true, 0xA8F4 : true,
                               0xA900 : true, 0xA90C : true, 0xA918 : true, 0xA924 : true, 0xA930 : true, 0xA93C : true, 0xA948 : true, 0xA954 : true,
                               0xA960 : true, 0xA96C : true, 0xA978 : true, 0xA984 : true, 0xA990 : true, 0xA99C : true, 0xA9A8 : true, 0xA9B4 : true,
                               0xA9C0 : true, 0xA9CC : true, 0xA9D8 : true, 0xA9E4 : true, 0xA9F0 : true, 0xA9FC : true, 0xAA08 : true, 0xAA14 : true,
                               0xAA20 : true, 0xAA2C : true, 0xAA38 : true, 0xAA44 : true, 0xAA50 : true, 0xAA5C : true, 0xAA68 : true, 0xAA74 : true,
                               0xAA80 : true, 0xAA8C : true, 0xAA98 : true, 0xAAA4 : true, 0xAAB0 : true, 0xAABC : true, 0xAAC8 : true, 0xAAD4 : true,
                               0xAAE0 : true, 0xAAEC : true, 0xAAF8 : true, 0xAB04 : true, 0xAB10 : true, 0xAB1C : true, 0xAB28 : true, 0xAB34 : true,
                               0xAB40 : true, 0xAB4C : true, 0xAB58 : true, 0xAB64 : true, 0xAB70 : true, 0xAB7C : true, 0xAB88 : true, 0xAB94 : true,
                               0xABA0 : true, 0xABAC : true, 0xABB8 : true, 0xABC4 : true, 0xABCF : true, 0xABDA : true, 0xABE5 : true
                           }
      property var stack
      property var dctx
      // This are the slopes drawing function
      property var slopes: {
          0x00 : function(tileX, tileY, HFlip, VFlip) {
              drawBox(tileX + 16 * HFlip, tileY + 8 + 24 * VFlip, 16, 8, 'light green', 'grey')
          },
          0x12 : function(tileX, tileY, HFlip, VFlip) { // Proper drawing of slopes using the canvas API
              dctx.strokeStyle = "light green"
              dctx.fillStyle = "grey"
              dctx.moveTo(tileX, tileY + 16 * VFlip)
              dctx.lineTo(tileX + 16 * HFlip, tileY, tileY)
              dctx.lineTo(tileX + 16 * HFlip, tileY + 16 * VFlip)
              dctx.lineTo(tileX, tileY + 16 * VFlip)
              dctx.fill()
              dctx.stroke()
              return // or you just want the outline
              drawLine(tileX, tileY + 16 * VFlip, tileX + 16 * HFlip, tileY, "green")
              drawLine(tileX + 16 * HFlip, tileY, tileX + 16 * HFlip, tileY + 16 * VFlip, "green")
              drawLine(tileX, tileY + 16 * VFlip, tileX + 16 * HFlip, tileY + 16 * VFlip, "green")
          },
          0x13 : function(tileX, tileY, HFlip, VFlip) {
              drawBox(tileX + 16*HFlip, tileY + 16*VFlip, 16, 16, "light green", "grey")
          }
      }
      property var outline : {
          0x00 : function(tileX, tileY) {
              },
          0x01 : function(tileX, tileY, BTS, Clip, BTSValue) { // Slope
              var VFlip = 0
              var HFlip = 0
              var newTileX = tileX
              var newTileY = tileY
              if (bit.band(BTSValue, 0x40) !== 0) {
                  newTileX += 16
                  HFlip = -1
              } else {
                  HFlip = 1
              }
              if (bit.band(BTSValue, 0x80) !== 0) {
                  newTileY += 16
                  VFlip = -1
              } else {
                  VFlip = 1
              }
              var slopeId = bit.band(BTSValue, 0x1F)
              if (slopeId === 0x13 || slopeId === 0x00 || slopeId === 0x01 || slopeId === 0x02 || slopeId === 0x07) {
                  if (VFlip == 1)
                      VFlip = 0
                  if (HFlip == 1)
                      HFlip = 0
              }
              if (slopeId in slopes)
                  slopes[slopeId](newTileX, newTileY, HFlip, VFlip)
              else {
                  drawBox(tileX, tileY, 16, 16, "green")
                  drawText(Helper.sprintf("%02X", slopeId), tileX + 1, tileY - 1, "green")
              }

          },
          0x02 : function(tileX, tileY) { // X-ray air
              if (solidCheckBox.checked)
                  return
              drawBox(tileX, tileY, 16, 16, "red")
              drawText("X", tileX + 4, tileY - 1, "red")
          },
          0x03 : function(tileX, tileY) { // Threadmill
              drawBox(tileX, tileY, 16, 16, 'rgb(170, 0, 0)', 'rgb(85, 0, 0)')
              drawText("T", tileX + 4, tileY - 1, "rgb(128, 128, 128)")
          },
          0x04 : function(tileX, tileY) { // Shootable Air
              if (solidCheckBox.checked)
                  return
              drawBox(tileX, tileY, 16, 16, 'rgb(0, 170, 0)')
              drawText("A", tileX + 4, tileY - 1, 'rgb(128, 128, 128)')
          },
          0x05 : function(tileX, tileY, BTS, Clip) { // Horizontal extension
              drawBox(tileX, tileY, 16, 16, 'rgb(170, 0, 170)')
              drawText("H", tileX + 4, tileY - 1, 'rgb(128, 128, 128)')
              return // This does not work properly?
              stack = stack + 1
              var b = memory.readByte(BTS)
              if (stack < 16 && b !== 0) {
                  var newClip = Clip + bit.lrshift(b, -1)
                  var newIdx = bit.lrshift(memory.readUnsignedWord(newClip), 12);
                  if  (newIdx in outline)
                      outline[newIdx](tileX, tileY, BTS + b, newClip)
                  else
                      drawBox(tileX, tileY, 16, 16, 'rbg(170, 0,170)')
              } else {
                  drawBox(tileX, tileY, 16, 16, 1, 'rgb(170, 0, 170)') // useless?
              }
          },
          0x06 : function(tileX, tileY) { // Denied X-ray
            if (solidCheckBox.checked)
                  return
            drawBox(tileX, tileY, 16, 16, 'rgb(180, 180, 180)', 'rgb(85, 85, 85)')
            drawText('F', tileX + 4, tileY - 1,  'rgb(128, 128, 128)')
          },
          0x07 : function(tileX, tileY) { // Bombable Air? dafuq
              if (solidCheckBox.checked)
                  return
              drawBox(tileX, tileY, 16, 16, 1, 'rgb(0, 170, 170)', 'rgb(0, 85, 85)')
              drawText('S', tileX + 4, tileY - 1, 'rgb(128, 128, 128)')
          },
          0x08 : function(tileX, tileY) { // Solid
              drawBox(tileX, tileY, 16, 16, "white", 'rgb(200, 200, 200)')
          },
          0x09 : function(tileX, tileY, BTS, Clip, BTSValue) { // Door/transitions
              var door = memory.readUnsignedWord(0x8F0000 + memory.readUnsignedWord(0x7E07B5) + 2 * bit.band(BTSValue, 0x7F))
              drawBox(tileX, tileY, 16, 16, "red", "pink")
              drawText(Helper.sprintf("%02X", BTSValue), tileX + 1, tileY, "red")
              return // Need to fix the rest
              //console.log(Helper.sprintf("%04X", door))
              if (door === 0x8000) {
                  drawBox(tileX, tileY, 16, 16, 'red', dctx.createPattern('#800000', Qt.DiagCrossPattern))
                  return
              }
              if (door in doors) {
                  drawBox(tileX, tileY, 16, 16, 'rgb(255, 0, 255)', dctx.createPattern("#800080", Qt.DiagCrossPattern))
              } else {
                  drawBox(tileX, tileY, 16, 16, 'rgb(255, 255, 0)')
                  drawText('E', tileX + 4, tileY - 1, 'rgb(0, 255, 255)')
              }
          },
          0x0A : function(tileX, tileY) { // Spike
              drawBox(tileX, tileY, 16, 16, 'grey', dctx.createPattern("grey", Qt.DiagCrossPattern))
              drawText('S', tileX + 4, tileY - 1, 'yellow')
          },
          0x0B : function(tileX, tileY) { // Crumble
              drawBox(tileX, tileY, 16, 16, 'grey', dctx.createPattern("grey", Qt.DiagCrossPattern))
              drawText('C', tileX + 4, tileY - 1, 'white')
          },
          0x0C : function(tileX, tileY, BTS) { // shot block
              drawBox(tileX, tileY, 16, 16, "#b51dc3", dctx.createPattern("#b51dc3", Qt.DiagCrossPattern))
              var b = memory.readUnsignedByte(BTS)
              //drawText(Helper.sprintf("%02X", b), tileX, tileY, "#f4d8f6")
              switch (b) {
              case 0x04:
                     drawText("S", tileX + 4, tileY - 1, "#f4d8f6");
                  break;
              case 0x09:
                  drawText("P", tileX + 4, tileY - 1, "#f4d8f6")
                  break;
              case 0x40:
                  drawText("RD", tileX, tileY - 1, "#f4d8f6")
                  break;
              case 0x41:
                  drawText("LD", tileX, tileY - 1, "#f4d8f6")
                  break;
              case 0x44:
                  drawText("M", tileX + 4, tileY - 1, "#f4d8f6")
                  break;
              default:
                  drawText(Helper.sprintf("%02X", b), tileX, tileY, "#f4d8f6")
              }
          },
          0x0D : function(tileX, tileY, BTS, Clip) { // Vertical Extend
              drawBox(tileX, tileY, 16, 16, "grey")
              drawText("V", tileX + 4, tileY - 1, "grey")
              return // THiS look weird
              stack = stack + 1
              var b = memory.readByte(BTS)
              console.log(Helper.sprintf("stack : %d - BTS Value : %02X", stack, b))
              if (stack  < 16 && b !== 0) {
                  var w = memory.readWord(0x7E07A5)
                  var newClip = Clip + bit.lrshift(b * w, -1)
                  var newIDX = bit.lrshift(memory.readUnsignedWord(newClip), 12)
                  console.log(Helper.sprintf("Clip : %06X - New clip : %06X - New IDX : %02X", Clip, newClip, newIDX))
                  if (newIDX in outline)
                      outline[newIDX](tileX, tileY, BTS + b * w, newClip)
                  else
                      drawBox(tileX, tileY, 16, 16, 'rbg(170, 0, 170)', 'rgb(85, 0, 85)')
              } else {
                   drawBox(tileX, tileY, 16, 16, 1, 'rgb(170, 0, 170)', 'rgb(85, 0, 85)')
              }
          },
          0x0E : function(tileX, tileY) { // Grapple block
              drawBox(tileX, tileY, 16, 16, 'light blue', dctx.createPattern("grey", Qt.DiagCrossPattern))
              drawText('G', tileX + 4, tileY - 1, 'light blue')
          },

          0x0F : function(tileX, tileY) { // Bomb block
              drawBox(tileX, tileY, 16, 16, "grey", dctx.createPattern("grey", Qt.DiagCrossPattern))
              drawText("B", tileX + 4, tileY - 1, "white")
          }
      }
      function drawBox(x, y, w, h, colorS, colorF) {
        dctx.strokeStyle = colorS;
        if (colorF === undefined)
            colorF = "transparent";
        else {
            dctx.fillStyle = colorF;
            dctx.fillRect(x, y, w, h);
        }
        dctx.strokeRect(x, y, w, h);
      }
      function drawLine(x1, y1, x2, y2, color) {
         dctx.strokeStyle = color
         dctx.moveTo(x1, y1)
         dctx.lineTo(x2, y2)
         dctx.stroke()
      }

      function drawText(text, x, y, color) {
        if (color === undefined)
            color = "white";
        dctx.fillStyle = color;
        dctx.fillText(text, x, y + 13); // FIXME
      }

      onPaint: {
          console.time("Drawing")
          if (cachedWram == false)
              return
          var radiusX = memory.readWord(0x7E0AFE)
          var radiusY = memory.readWord(0x7E0B00)
          var topleft = [256 - radiusX, 224 - radiusY]
          var bottomright = [256 + radiusX, 224 + radiusY]

          dctx = mycanvas.getContext("2d")
          // The canvas is actually the whole window, to set position we just need to translate the context
          dctx.reset()
          dctx.translate(0, 100)

          dctx.beginPath();
          dctx.clearRect(0, 0, mycanvas.width, mycanvas.height);
          var p = dctx.createPattern("aqua", Qt.DiagCrossPattern)
          //drawBox(topleft[0] + 1, topleft[1] + 1, bottomright[0] - topleft[0] -2, bottomright[1] - topleft[1] - 2, "darkblue", "darkblue");
          var samusX = memory.readUnsignedWord(0x7E0AF6)
          var samusY = memory.readUnsignedWord(0x7E0AFA)
          var cameraX = (samusX - 256) & 0xFFFF
          var cameraY = (samusY - 224) & 0xFFFF
          console.log("cameraX :", cameraX, " - CameraY", cameraY)
          if (cameraX >= 10000)
              cameraX = cameraX - 65535
          if (cameraY >= 10000)
              cameraY = cameraY - 65535
          var width = memory.readUnsignedWord(0x7E07A5)
          infoSamus.text = Helper.sprintf("Samus coord : %d,%d\nCamera : %d , %d - Width : %d", samusX, samusY, cameraX, cameraY, width)
          dctx.font = "12px Arial"
          dctx.fillStyle = "white"
          for (y = 0; y < 28; y++)
          {
              for (x = 0; x < 32; x++)
              {
                  stack = 0
                  var tileX = x * 16 - (cameraX & 0x000F)
                  var tileY = y * 16 - (cameraY & 0x000F)
                  var a = bit.lrshift(bit.band(cameraX+x*16, 0xFFFF), 4) + bit.band(bit.lrshift(bit.band(cameraY+y*16, 0xFFF), 4)*width, 0xFFFF)
                  //var a = ((cameraX + x * 16) & 0xFFFF) >>> 4 + ((((cameraY + y * 16) & 0xFFF) >>> 4) * width) & 0xFFFF
                  var BTS = 0x7F0000 + ((0x6402 + a) % 0x10000)
                  var BTSvalue = memory.readUnsignedByte(BTS);
                  //console.log(Helper.sprintf("x, y : (%d, %d)", x, y), "tileX : ", tileX, " - tileY : ", tileY, " - a : ", a, Helper.sprintf(" - BTS : %X - value : %X", BTS, BTSvalue))

                  var Clip = 0x7F0000 + ((0x0002 + a * 2) % 0x10000)
                  var ClipValue = memory.readUnsignedWord(Clip)
                  var outlineIDX = bit.lrshift(ClipValue, 12)
                  //console.log(Helper.sprintf("Clip : %06X - ", Clip), "Outline IDX", outlineIDX)
                  if (outlineIDX in outline)
                  {
                    outline[outlineIDX](tileX, tileY, BTS, Clip, BTSvalue);
                  } else {
                    drawBox(tileX, tileY, 16, 16, "#AA00AA")
                    drawText(Helper.sprintf("%02X", outlineIDX), tileX + 3 , tileY - 1)
                  }
                  //gui.text(TileX+3, TileY-1, "N", gui.color(128, 128, 128))
              }
          }
          drawBox(topleft[0], topleft[1], bottomright[0] - topleft[0], bottomright[1] - topleft[1], "aqua", p);
          console.timeEnd("Drawing")
      }

      CheckBox {
          id: solidCheckBox
          x: 404
          y: 39
          style: CheckBoxStyle {
              label : Text {
                  color : "white"
                  font.pixelSize: 20
                  text : "Hide all no solid"
              }
          }
      }
    }

    /* You need this object. It will call the OnTimerTick part every time the timer 'tick'
     * You can change the timer interval by setting the timer property
    */
    USB2Snes {
      id : usb2snes
      objectName: "usb2snes" // Don't change this
      timer : 100 // The interval timer value in ms. A frame is around 16 ms

      onInit: {
          memory.addNewCacheRange("misc", 0x7E0790, 900)
          memory.addNewCacheRange("mapinfos", 0x7F0000,  0x10000)
          //memory.addNewCacheRange("btsmap", 0x7F6402, 0x7F9602 - 0x7F6402)
          //memory.addNewCacheRange("tilemap", 0x7F0002, 0x6400)
          memory.readByte(0x8F8000) // Force to cache this rom bank
          //memory.refreshCache("mapinfos")
          memory.refreshCache()
      }

      /* Main Code is actually here */

      onTimerTick: {
        console.time("tick")
        console.time("Getting Cache")
        memory.refreshCache("misc")
        //memory.refreshCache("tilemap")
        //memory.refreshCache("btsmap")
        console.timeEnd("Getting Cache")
        cachedWram = true
        console.info("==========NEW TICK===============")
        var hours = memory.readUnsignedWord(0x7E09E0)
        var minutes = memory.readUnsignedWord(0x7E09DE)
        var seconds = memory.readUnsignedWord(0x7E09DC)
        igTime.text = Helper.sprintf("%02d:%02d:%02d", hours, minutes, seconds);

        if (memory.readUnsignedByte(0x7E079B) !== mapId)
        {
          if (memory.readUnsignedByte(0x7E0998) === 0x08)
          {
            mapId = memory.readUnsignedByte(0x7E079B)
            memory.refreshCache("mapinfos")
            tmapId.text = Helper.sprintf("Map ID : %04X", mapId)
          } else {
            return ;
          }
        }
        // Calling for a redraw
        mycanvas.requestPaint()
        console.timeEnd("tick")
      }
      onEnd: {
          //memory.printStats()
      }
     }
}
