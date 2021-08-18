import QtQuick 2.0
import CustomGeometry 1.0

Item {
    id: line

//    Rectangle {
//        anchors.fill: bezier
//        color: "#FF00FF"
//    }

    BezierCurve {
        id: bezier
        color: "#808080"
        anchors.fill: parent
    }

    function _point_add(p1, p2) {
        return Qt.point(p1.x + p2.x, p1.y + p2.y);
    }

    function _point_sub(p1, p2) {
        return Qt.point(p1.x - p2.x, p1.y - p2.y);
    }

    function _bounding_rect(p1, p2, p3, p4) {
        var xmin = Math.min(p1.x, p2.x, p3.x, p4.x);
        var xmax = Math.max(p1.x, p2.x, p3.x, p4.x);
        var ymin = Math.min(p1.y, p2.y, p3.y, p4.y);
        var ymax = Math.max(p1.y, p2.y, p3.y, p4.y);
        return { origin: Qt.point(xmin, ymin), size: Qt.point(xmax - xmin, ymax - ymin) };
    }

    function _apply_points(points) {
        let p1 = points.p1;
        let p2 = points.p2;
        let p3 = points.p3;
        let p4 = points.p4;

        var dx = p4.x - p1.x;
        var dy = p4.y - p1.y;
        var line_len = Math.sqrt(dx*dx + dy*dy);
        var conrol_len = line_len * 0.5;

        p2 = Qt.point(p1.x + conrol_len, p1.y);
        p3 = Qt.point(p4.x - conrol_len, p4.y);

        var rect = _bounding_rect(p1, p2, p3, p4);

        x = rect.origin.x;
        y = rect.origin.y;
        width = rect.size.x;
        height = rect.size.y;

        bezier.p1 = _point_sub(p1, rect.origin);
        bezier.p2 = _point_sub(p2, rect.origin);
        bezier.p3 = _point_sub(p3, rect.origin);
        bezier.p4 = _point_sub(p4, rect.origin);
    }

    function _get_global_points() {
        var pos = Qt.point(x, y);
        return {
            p1: _point_add(pos, bezier.p1),
            p2: _point_add(pos, bezier.p2),
            p3: _point_add(pos, bezier.p3),
            p4: _point_add(pos, bezier.p4)
        }
    }

    function set_line_start(pos_p) {
        let points = _get_global_points();
        points.p1 = Qt.point(pos_p.x, pos_p.y);

        _apply_points(points);
    }

    function set_line_end(pos_p) {
        let points = _get_global_points();
        points.p4 = Qt.point(pos_p.x, pos_p.y);

        _apply_points(points);
    }
}
