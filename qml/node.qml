import QtQuick 2.0
import "node_logic.js" as NodeLogic

Rectangle {
    id: node_square
    width: 150; height: childrenRect.height
    z: 1
    x: 10; y: 10
    radius: 4
    border.color: "#808080"
    border.width: 1
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#90444444" }
        GradientStop { position: 1.0; color: "#90383838" }
    }

    MouseArea {
        id: nodes_mouse_area
        anchors.fill: parent
        drag.target: node_square
        drag.axis: Drag.XAndYAxis
        hoverEnabled: true
        cursorShape: Qt.DragMoveCursor
        onPressed: {
            node_activated();
        }
    }

    Column {
        width: parent.width
        height: childrenRect.height
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.bottomMargin: 1

        // title_block
        Rectangle {
            id: title_block
            color: nodes_mouse_area.containsMouse ? "#79cf1d" : "#48652a"
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width-2; height: childrenRect.height + 2
            radius: 2
            clip:true
            Text {
                text: node_name
                font.family: "Verdana"
                font.pixelSize: 13
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 2
                color: "white"
            }
        }

        Column {
            width: parent.width
            id: out_block


        }
        Column {
            width: parent.width
            id: in_vars_block
        }
        Column {
            width: parent.width
            id: in_block
        }

    }

   MouseArea {
       id: mouseAreaLeft
       z: 1
       property int oldMouseX

       anchors.right: parent.right
       anchors.bottom: parent.bottom
       width: 5
       height: parent.height
       hoverEnabled: true
       cursorShape: Qt.SizeHorCursor
       onPressed: {
           oldMouseX = mouseX
       }

       onPositionChanged: {
           if (pressed) {
               node_square.width = Math.max(50, node_square.width + (mouseX - oldMouseX))
           }
       }
   }

   property string node_name: "node name"
   signal drag_line_started(variant node, int slot_index)
   signal drag_line_ended(variant node, int slot_index)
   signal node_activated()

   function init_node_type(node_type) {
       node_name = node_type.type

       // outs
       if('out_events' in node_type) {
           function create_func_for_start(index) {
               return function() {
                   drag_line_started(node_square, index);
               }
           }

           var out_block_component = Qt.createComponent("out_item.qml")
           for(var i = 0; i < node_type.out_events.length; i++) {
               var out_node = out_block_component.createObject(out_block);
               out_node.label = node_type.out_events[i];
               out_node.drag_started.connect(create_func_for_start(i));

               NodeLogic.register_out_node(out_node);
           }
       }

       // vars
       if('args' in node_type) {
           var arg_block_component = Qt.createComponent("arg_item.qml")
           for(var arg in node_type.args) {
               var arg_node = arg_block_component.createObject(in_block);
               arg_node.label = arg;
               if (node_type.args[arg] === "float") {
                   arg_node.port_color = "#0000FF";
               }
           }
       }

       // input events
       if('in_events' in node_type) {
           function create_func_for_end(index) {
               return function() {
                   drag_line_ended(node_square, index);
               }
           }

           var in_block_component = Qt.createComponent("in_item.qml")
           for(i = 0; i < node_type.in_events.length; i++) {
               var in_node = in_block_component.createObject(in_block);
               in_node.label = node_type.in_events[i];
               in_node.drag_ended.connect(create_func_for_end(i));
               NodeLogic.register_in_node(in_node);
           }
       }
   }

   onXChanged: NodeLogic.update_all_slots();
   onYChanged: NodeLogic.update_all_slots();
   onHeightChanged: NodeLogic.update_all_slots();
   onWidthChanged: NodeLogic.update_all_slots();

   function connect_to_out_port(func, port_ind) {
       NodeLogic.connect_to_out_port(func, port_ind);
   }

   function connect_to_in_port(func, port_ind) {
       NodeLogic.connect_to_in_port(func, port_ind);
   }
}
