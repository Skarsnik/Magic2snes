import QtQuick 2.0

ListView {
    id: alttpView
    interactive: false
    property string headerText : "None"
    header : Text {
        color : "white"
        text :  headerText
        font.pixelSize: 12
        font.family: "Verdana"
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        height: contentHeight + 5
    }
    delegate:
        Rectangle {
            id : rect
            color : owned ?  "orange" : "grey"
            width : iText.contentWidth + 5
            height: iText.contentHeight + 2
            Text {
                id : iText
                color : "black"
                font.pointSize: 10
                font.family: "Verdana"
                horizontalAlignment: Text.Center
                text : name
            }

        }
}
