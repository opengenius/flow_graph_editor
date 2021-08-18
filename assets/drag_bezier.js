var line_component = null
var line_object = null

function startDrag(mouse) {
    if (line_component == null) {
        line_component = Qt.createComponent("line.qml");
    }

    var pos = slot_point.mapToItem(field, slot_point.width *0.5, slot_point.height *0.5);

    line_object = line_component.createObject(field);
    line_object.z = 2;
    line_object.set_line_start(pos);
    line_object.set_line_end(pos);
}

function continueDrag(mouse) {
    if(line_object !== null) {
        var pos = out_block_1.mapToItem(field, mouse.x, mouse.y);
        line_object.set_line_end(pos);
    }
}

function endDrag(mouse) {
    line_object.destroy();
    line_object = null
}
