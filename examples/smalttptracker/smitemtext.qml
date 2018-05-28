import QtQuick 2.0

Rectangle {
    id : rect
    color : "grey"
    property alias text : iText.text
    property bool enabled: false

    onEnabledChanged: {
        if (enabled == true)
           color = "orange"
        else
           color = "grey"
    }

    width : iText.contentWidth + 5
    height: iText.contentHeight + 2
    Text {
        id : iText
        font.pointSize: 10
        font.family: "Verdana"
        color : "black"
        horizontalAlignment: Text.Center
    }

}
