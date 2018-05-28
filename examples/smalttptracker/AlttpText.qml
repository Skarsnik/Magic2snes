import QtQuick 2.0

Text {
    color : "grey"
    style: Text.Outline
    styleColor : "black"
    property bool enabled: false
    font.pointSize: 10
    font.family: "Verdana"

    onEnabledChanged: {
        if (enabled == true)
        {
            color =  "white"
            styleColor = "blue"
        } else {
            color = "grey"
            styleColor = "black"
        }
    }
}
