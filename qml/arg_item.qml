import QtQuick 2.0

Item {
    id: in_arg_slot_1
    width: parent.width-4; height: 16
    clip:true

    property string label: "arg name"
    property color port_color: "#808080"

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 5
        spacing: 5
        Rectangle {
             width: 8
             height: width
             color: port_color
             anchors.verticalCenter: parent.verticalCenter
             radius: width*0.5
        }
        Text {
            text: label
            color: "#808080"
            font.family: "Verdana"
            font.pixelSize: 13
        }
    }
}
