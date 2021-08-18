import QtQuick 2.0
import "drag_bezier.js" as Code

Item {
    id: out_block_1
    width: parent.width-4; height: 16
    clip:true

    property string label: "qwe"
    signal drag_started()

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 3
        spacing: 5
        Text {
            text: label
            color: "#808080"
            font.family: "Verdana"
            font.pixelSize: 13
        }
        Rectangle {
            id: slot_point
            width: 10
            height: width
            color: "#808080"
            anchors.verticalCenter: parent.verticalCenter
            radius: width*0.5
        }
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        onPressed: {
            drag_started();
            Code.startDrag(mouse);
        }
        onPositionChanged: Code.continueDrag(mouse);
        onReleased: {
            dragItem.Drag.drop()
            Code.endDrag(mouse);
        }
        drag.target: dragItem
        Rectangle {
            id: dragItem
            x: mousearea.mouseX
            y: mousearea.mouseY
            width: 1; height: 1
            Drag.active: mousearea.drag.active
            Drag.hotSpot.x: 1
            Drag.hotSpot.y: 1
        }
    }

    function get_slot_position() {
        return slot_point.mapToItem(out_block_1, slot_point.width * 0.5, slot_point.height * 0.5);
    }
}
