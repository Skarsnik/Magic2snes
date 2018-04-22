/*
  QML script are part of the Qt framework. They allow to write graphics interfaces
  in a simple and descriptive way. Read more on http://doc.qt.io/qt-5/gettingstartedqml.html

  This example only use one file, but you could have your code in a separate file
*/

// This is requiered
import QtQuick 2.0
import USB2Snes 1.0
import "qrc:/extrajs.js" as Helper // Some extra javascript function


/*
 * This is the part where you describe you graphics objects
 * You can use the qml editor on qtcreator to have something more wisiwig
 *
 * In this example. We display the Super Metroid in game timer
 * We define a simple black rectangle as background and a white text
*/

Rectangle {
    width: 700
    height: 700
    id : window
    color : "black"
    property bool cachedWram: false

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

    Canvas {
      id: mycanvas
      width : 500
      height: 500
      property var dctx
      x: 200
      y: 200
      function drawBox(x, y, w, h, colorS, colorF) {
        dctx.strokeStyle = colorS;
        if (colorF === undefined)
            colorF = "transparent";
        dctx.fillStyle = colorF
        dctx.strokeRect(x, y, w, h);
      }

      onPaint: {
          if (cachedWram == false)
              return
          var radiusX = memory.readWord(0x7E0AFE)
          var radiusY = memory.readWord(0x7E0B00)
          var topleft = [256 - radiusX, 224 - radiusY]
          var bottomright = [256 + radiusX, 224 + radiusY]

          dctx = mycanvas.getContext("2d")
          dctx.beginPath();
          dctx.clearRect(0, 0, mycanvas.width, mycanvas.height);
          drawBox(topleft[0], topleft[1], bottomright[0] - topleft[0], bottomright[1] - topleft[1], "blue");
          drawBox(topleft[0] + 1, topleft[1] + 1, bottomright[0] - topleft[0] -2, bottomright[1] - topleft[1] - 2, "darkblue");
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
          infoSamus.text = Helper.sprintf("Samus coord : %d,%d\nCamera : %d , %d - %d", samusX, samusY, cameraX, cameraY, width)
          dctx.font = "9px Arial"
          dctx.fillStyle = "white"
          for (y = 0; y < 28; y++)
          {
              for (x = 0; x < 32; x++)
              {
                  var stack = 0
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
                  console.log(Helper.sprintf("Clip : %06X - ", Clip), "Outline IDX", outlineIDX)
                  if (outlineIDX !== 0x00)
                  {
                    drawBox(tileX, tileY, 16, 16, "#AA00AA")
                    dctx.fillStyle = "white"
                    dctx.fillText(Helper.sprintf("%02X", outlineIDX), tileX + 3, tileY - 1)
                  }
                  //gui.text(TileX+3, TileY-1, "N", gui.color(128, 128, 128))
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
      timer : 5000 // The interval timer value in ms. A frame is around 16 ms

      /* Main Code is actually here */

      onTimerTick: {
        memory.cacheWram()
        cachedWram = true
        console.log("==========NEW TICK===============")
        var hours = memory.readUnsignedWord(0x7E09E0)
        var minutes = memory.readUnsignedWord(0x7E09DE)
        var seconds = memory.readUnsignedWord(0x7E09DC)
        igTime.text = Helper.sprintf("%02d:%02d:%02d", hours, minutes, seconds);




        mycanvas.requestPaint()

      }
     }
}
