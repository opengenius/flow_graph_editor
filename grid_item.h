#ifndef GRAPH_H
#define GRAPH_H

#include <QQuickItem>

class GridItem : public QQuickItem
{
    Q_OBJECT
public:
    GridItem();

protected:
    QSGNode *updatePaintNode(QSGNode *, UpdatePaintNodeData *);
};

#endif // GRAPH_H
