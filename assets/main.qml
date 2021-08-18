import QtQuick 2.15
import Qt.labs.platform 1.1
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Grid 1.0
import "scene_logic.js" as Logic

ApplicationWindow {
    width: 800
    height: 600
    visible: true

    FileDialog {
        id: file_load_dialog
        nameFilters: [ "Flow file (*.flow.json)" ]
        title: "Please choose a file to load"
        onAccepted: {
            Logic.load_scene(file_load_dialog.file);
        }
        onRejected: {
            console.log("Canceled");
        }
    }

    FileDialog {
        id: file_save_dialog
        fileMode: FileDialog.SaveFile
        nameFilters: [ "Flow file (*.flow.json)" ]
        title: "Please choose a file to save"
        onAccepted: {
            Logic.write_scene(file_save_dialog.file);
        }
        onRejected: {
            console.log("Canceled");
        }
    }

    Menu {
        id: create_node_menu
    }

    Component {
        id: menuItem
        MenuItem { }
    }

    Component.onCompleted: {
        Logic.loadNodeTypes(create_node_menu, menuItem);
    }

    ToolBar {
        id: menu_block
        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: qsTr("new")
                onClicked: {
                    Logic.reset_scene();
                }
            }
            ToolButton {
                text: qsTr("load")
                onClicked: {
                    file_load_dialog.visible = true;
                }
            }
            ToolButton {
                text: qsTr("save")
                onClicked: {
                    file_save_dialog.visible = true;
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: menu_block.bottom
        anchors.bottom: parent.bottom
        color: "#606060"
    }

    Flickable {
        id: flick_item
        boundsBehavior: Flickable.StopAtBounds
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: menu_block.bottom
        anchors.bottom: parent.bottom
        clip: true

        contentWidth: field_base.width * field_base.scale
        contentHeight: field_base.height * field_base.scale

        Item {
            id: field_base
            width: field.width + field.x
            height: field.height + field.y
            transformOrigin: Item.TopLeft

            Grid {
                id: graph
                anchors.fill: field
            }

            MouseArea {
                anchors.fill: field_base
                hoverEnabled: true
                onClicked: {
                    var mouse_pos = mapToItem(field, mouseX, mouseY);
                    Logic.set_mouse_pos(mouse_pos.x, mouse_pos.y);
                    create_node_menu.open();
                }

                onWheel: {
                    var off_x = (flick_item.contentX + flick_item.width * 0.5) / parent.scale;
                    var off_y = (flick_item.contentY + flick_item.height * 0.5) / parent.scale;

                    var min_scale = Math.max(flick_item.width / field_base.width, flick_item.height / field_base.height);
                    parent.scale = Math.min(Math.max(min_scale, parent.scale + wheel.angleDelta.y / 120 * 0.05), 1.0);

                    flick_item.contentX = Math.min(Math.max(0, off_x * parent.scale - flick_item.width * 0.5), flick_item.contentWidth - flick_item.width);
                    flick_item.contentY = Math.min(Math.max(0, off_y * parent.scale - flick_item.height * 0.5), flick_item.contentHeight - flick_item.height);
                }
            }

            Item {
                id: field
                width: childrenRect.width + childrenRect.x + flick_item.width
                height: childrenRect.height + childrenRect.y + flick_item.height

//                onChildrenRectChanged: {
//                    var new_f_x = -childrenRect.x + flick_item.width
//                    var new_f_y = -childrenRect.y + flick_item.height
//                    var dx = field.x - new_f_x
//                    var dy = field.y - new_f_y
//                    field.x = new_f_x
//                    field.y = new_f_y
//                    flick_item.contentX = flick_item.contentX - dx * field_base.scale
//                    flick_item.contentY = flick_item.contentY - dy * field_base.scale
//                }
            }
        }
    }
}




