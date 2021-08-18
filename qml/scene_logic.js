var node_component = null
var line_component = null

var node_types = null

// scene vars
var nodes = []
var connections = []

var _mouse_x = 0, _mouse_y = 0
var _node_drag_Started;
var _node_drag_started_slot_index;
var _active_node = null;

function reset_scene() {
    _mouse_x = 0;
    _mouse_y = 0;
    _node_drag_Started = null;
    _active_node = null;
    _node_drag_started_slot_index = 0;

    for(let connection of connections) {
        connection.obj.destroy();
    }
    connections = [];

    for(let node of nodes) {
        node.destroy();
    }
    nodes = [];
}

function create_node(x_pos, y_pos, node_type) {
    if (node_component == null) {
        node_component = Qt.createComponent("node.qml");
    }
    var node = node_component.createObject(field, {"x": x_pos, "y": y_pos});

    node.init_node_type(node_type);
    node.drag_line_started.connect(function(node_target, slot_index) {
        _node_drag_Started = node_target;
        _node_drag_started_slot_index = slot_index;
    });
    node.drag_line_ended.connect(function(node_target, slot_index) {
        if(_node_drag_Started !== null) {
            create_connection(_node_drag_Started, _node_drag_started_slot_index, node_target, slot_index);
            _node_drag_Started = null;
        }
    });
    node.node_activated.connect(function() {
        _makeActive(node);
    });
    nodes.push(node);

    return node;
}

function _print_nodes() {
    var nodes_for_save = nodes.map(node =>
        ({
           "type": node.node_name,
           "x": node.x,
           "y": node.y,
           "width": node.width
        })
    );

    var coneections_for_save = connections.map(
                connection => {
        var conn_data = {
            out_slot: connection.out_slot,
            in_slot: connection.in_slot
        };

        var found = 0;
        for(let node_index = 0; node_index < nodes.length; node_index++) {
            if (nodes[node_index] === connection.out_node) {
                conn_data.out_node = node_index;
                found = found + 1;
            }
            if (nodes[node_index] === connection.in_node) {
                conn_data.in_node = node_index;
                found = found + 1;
            }
            if(found == 2) {
                break;
            }
        }
        return conn_data;
    });

    var json_for_save = {nodes: nodes_for_save, connections: coneections_for_save};

    return JSON.stringify(json_for_save, null, 4);
}

function _makeActive(obj) {
    if(_active_node !== obj) {
        obj.border.color = "#FF8080";
        if (_active_node != null) {
            _active_node.border.color = "#808080";
        }
        _active_node = obj;
    }
}

function loadNodeTypes(menu, menuItemComponent) {
    node_types = JSON.parse(fileio.read("file:node_types.json"));

    function func_generator(node_type) {
        return function() {
            create_node(_mouse_x, _mouse_y, node_type);
        }
    }

    for (var i = 0; i < node_types.length; ++i) {
        var item = menuItemComponent.createObject(menu, {text: node_types[i].type});
        item.onTriggered.connect(func_generator(node_types[i]));
        menu.addItem(item);
    }
}

function set_mouse_pos(x, y) {
    _mouse_x = x;
    _mouse_y = y;
}

function create_connection(out_node, out_port_index, in_node, in_port_index) {
    if (line_component == null) {
        line_component = Qt.createComponent("line.qml");
    }

    for(var i = 0; i < connections.length; i++) {
        if(connections[i].out_node === out_node && connections[i].out_slot === out_port_index &&
                connections[i].in_node === in_node && connections[i].in_slot === in_port_index) {
            console.log("conection exists skipping");
            return;
        }
    }

    var line_object = line_component.createObject(field);
    out_node.connect_to_out_port(line_object.set_line_start, out_port_index);
    in_node.connect_to_in_port(line_object.set_line_end, in_port_index);

    var conn_obj = {};
    conn_obj.obj = line_object;
    conn_obj.out_node = out_node;
    conn_obj.out_slot = out_port_index;
    conn_obj.in_node = in_node;
    conn_obj.in_slot = in_port_index;
    connections.push(conn_obj);
}

String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
};

function write_scene(file_url) {
    var filename = file_url.toString();
    if(!filename.endsWith(".flow.json")) {
        filename = filename + ".flow.json";
    }

    fileio.write(filename, Logic._print_nodes());
}

function load_scene(file_url) {
    reset_scene();

    var filename = file_url.toString();
    if(!filename.endsWith(".flow.json")) {
        filename = filename + ".flow.json";
    }

    var scene_data = JSON.parse(fileio.read(filename));

    if( 'nodes' in scene_data) {
        function find_nodetype_by_typename(name) {
            return node_types.find(node_type => node_type.type === name);
        }

        for(var i = 0; i < scene_data.nodes.length; i++) {
            var type = find_nodetype_by_typename(scene_data.nodes[i].type);
            if(type) {
                var node = create_node(scene_data.nodes[i].x, scene_data.nodes[i].y, type);
                node.width = scene_data.nodes[i].width;
            }
        }
    }

    if('connections' in scene_data) {
        for(i = 0; i < scene_data.connections.length; i++) {
            var conn_data = scene_data.connections[i];
            create_connection(nodes[conn_data.out_node], conn_data.out_slot, nodes[conn_data.in_node], conn_data.in_slot);
        }
    }
}
