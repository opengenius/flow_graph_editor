#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "grid_item.h"
#include "beziercurve.h"
#include "fileio.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    FileIO fileIO;

    qmlRegisterType<GridItem>("Grid", 1, 0, "Grid");
    qmlRegisterType<BezierCurve>("CustomGeometry", 1, 0, "BezierCurve");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("fileio", &fileIO);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
