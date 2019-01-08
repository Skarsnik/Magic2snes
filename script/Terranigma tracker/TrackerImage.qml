import QtQuick 2.0
import QtGraphicalEffects 1.0

Image {
    id : image
    property bool owned: false
    fillMode: Image.PreserveAspectFit
    smooth: false
    onOwnedChanged: {
        if (owned == true)
            colorEffect.visible = false
        else
            colorEffect.visible = true
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
