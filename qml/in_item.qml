import QtQuick 2.0

Item {
    id: in_slot_1
    width: parent.width-4; height: 16
    clip:true

    property string label: "qwe"

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 5
        spacing: 5
        Rectangle {
            id: slot_point
             width: 8
             height: width
             color: "#808080"
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

    signal drag_ended()

    DropArea {
        anchors.fill: parent
//        onEntered: { console.log("red-enter") }
        onDropped: {
            drag_ended();
        }
    }

    function get_slot_position() {
        return slot_point.mapToItem(in_slot_1, slot_point.width * 0.5, slot_point.height * 0.5);
    }
}
