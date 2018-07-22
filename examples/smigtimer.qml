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
    width: 150
    height: 100
    id : window
    color : "black"

    Text {
      id : igTime
      color : "white"
      text : "00:00:00"
      font.pixelSize: 28
    }

    /* You need this object. It will call the OnTimerTick part every time the timer 'tick'
     * You can change the timer interval by setting the timer property
    */
    USB2Snes {
      id : usb2snes
      objectName: "usb2snes" // Don't change this
      windowTitle: "Super Metroid - In game timer" // The WindowTitle
      timer : 100 // The interval timer value in ms. A frame is around 16 ms

      /* Main Code is actually here */

      onTimerTick: {
        var hours = memory.readUnsignedWord(0x7E09E0)
        var minutes = memory.readUnsignedWord(0x7E09DE)
        var seconds = memory.readUnsignedWord(0x7E09DC)
        igTime.text = Helper.sprintf("%02d:%02d:%02d", hours, minutes, seconds);
      }
     }
}
