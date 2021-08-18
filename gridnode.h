#ifndef GRIDNODE_H
#define GRIDNODE_H

#include <QtQuick/QSGGeometryNode>
#include <QtQuick/QSGFlatColorMaterial>

class GridNode : public QSGGeometryNode
{
public:
    GridNode();

    void setRect(const QRectF &rect);

private:
    QSGFlatColorMaterial m_material;
    QSGGeometry m_geometry;
};

#endif // GRIDNODE_H