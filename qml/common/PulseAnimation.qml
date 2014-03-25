import QtQuick 2.0

SequentialAnimation {
    id: root

    property QtObject target: parent ? parent : undefined
    property int duration: 1000

    running: false
    alwaysRunToEnd: true
    loops: Animation.Infinite

    PropertyAnimation {
        target: root.target
        property: "opacity"
        to: 0
        duration: root.duration / 2
    }

    PropertyAnimation {
        target: root.target
        property: "opacity"
        to: 1
        duration: root.duration / 2
    }
}
