cmake_minimum_required(VERSION 3.16.0)

project(QmlFlowNode VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED Quick Qml)

file(GLOB sources
    src/*.h
    src/*.cpp
)

add_executable(${CMAKE_PROJECT_NAME} WIN32 ${sources} ${qrc})
target_link_libraries(
    ${CMAKE_PROJECT_NAME}
PRIVATE
    Qt::Quick Qt::Qml
)

file(GLOB resource_files
    qml/*.qml
    qml/*.js
)

qt_add_resources(${CMAKE_PROJECT_NAME} "resources"
    PREFIX "/"
    BASE "qml"
    FILES ${resource_files}
)

configure_file(node_types.json ${CMAKE_CURRENT_BINARY_DIR}/node_types.json COPYONLY)

