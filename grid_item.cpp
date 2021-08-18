#include "grid_item.h"
#include "gridnode.h"

GridItem::GridItem()
{
    setFlag(ItemHasContents, true);
}

QSGNode *GridItem::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    GridNode *n= static_cast<GridNode *>(oldNode);

    QRectF rect = boundingRect();

    if (rect.isEmpty()) {
        delete n;
        return 0;
    }

    if (!n) {
        n = new GridNode();
    }

    n->setRect(rect);

    return n;
}
