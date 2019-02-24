import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: item1
    property int count: 0
    property int countMax : 0
    property alias source : image.source
    property alias color : countText.color
    property alias fontFamily : countText.font.family
    Image {
        id : image
        width: parent.height
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: 0
        fillMode: Image.PreserveAspectFit
        smooth: false
    }
    Text {
        id : countText
        height: parent.height
        width : parent.width - image.width - 2
        color : "white"
        text :  count + "/" + countMax
        verticalAlignment: Text.AlignBottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        font.family: "Gentium Basic"
        fontSizeMode: Text.Fit
        minimumPixelSize: 10
        font.pixelSize: 50
    }
    LinearGradient  {
            anchors.fill: countText
            source: countText
            gradient: Gradient {
                GradientStop { position: 0.0; color: "blue" }
                GradientStop { position: 0.5; color: "white" }
                GradientStop { position: 1.0; color: "blue" }
            }
        }
}
