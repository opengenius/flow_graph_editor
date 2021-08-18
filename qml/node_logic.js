var out_items = []
var in_items = []

function register_out_node(node) {
    var item_el = {};
    item_el.node = node;
    item_el.pos_listeners = [];
    out_items.push(item_el);
}

function register_in_node(node) {
    var item_el = {};
    item_el.node = node;
    item_el.pos_listeners = [];
    in_items.push(item_el);
}

function update_all_slots() {
   for(var i = 0; i < out_items.length; i++) {
       var pos_in_node = out_items[i].node.get_slot_position();
       var pos = out_items[i].node.mapToItem(field, pos_in_node.x, pos_in_node.y);
        for(var j = 0; j < out_items[i].pos_listeners.length; j++) {
            out_items[i].pos_listeners[j](pos);
        }
   }
   for(i = 0; i < in_items.length; i++) {
       pos_in_node = in_items[i].node.get_slot_position();
       pos = in_items[i].node.mapToItem(field, pos_in_node.x, pos_in_node.y);
        for(j = 0; j < in_items[i].pos_listeners.length; j++) {
            in_items[i].pos_listeners[j](pos);
        }
   }
}

function connect_to_out_port(func, port_ind) {
    out_items[port_ind].pos_listeners.push(func)
    var pos_in_node = out_items[port_ind].node.get_slot_position();
    var pos = out_items[port_ind].node.mapToItem(field, pos_in_node.x, pos_in_node.y);
    func(pos)
}

function connect_to_in_port(func, port_ind) {
    in_items[port_ind].pos_listeners.push(func)
    var pos_in_node = in_items[port_ind].node.get_slot_position();
    var pos = in_items[port_ind].node.mapToItem(field, pos_in_node.x, pos_in_node.y);
    func(pos)
}
