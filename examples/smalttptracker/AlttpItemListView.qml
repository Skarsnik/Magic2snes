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
    }
    delegate: Text {
        id : delegateText
        style : Text.Outline
        color : owned ? "white" : "grey"
        styleColor : owned ? "blue" : "black"
        font.pointSize: 10
        font.family: "Verdana"
        text : name
    }

}
