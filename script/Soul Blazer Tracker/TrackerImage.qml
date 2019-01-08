import QtQuick 2.0
import QtGraphicalEffects 1.0
Item {
    property bool owned: false
    property alias source : image.source
    onOwnedChanged: {
        if (owned == true)
            colorEffect.visible = false
        else
            colorEffect.visible = true
    }
    MouseArea {
        anchors.fill : parent
        onClicked: {
            owned = !owned
        }
    }

    Image {
        id : image
        width : parent.width
        height : parent.height
        source : parent.source
        fillMode: Image.PreserveAspectFit
        smooth: false
    }
    Colorize {
        id : colorEffect
        enabled : true
        anchors.fill : image
        source : image
        hue: 0.0
        saturation: 0.0
        lightness: 0.0
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
