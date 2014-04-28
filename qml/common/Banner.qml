import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea {
    id: popup
    anchors.top: parent.top
    width: parent.width
    height: message.height + Theme.paddingLarge * 2
    visible: opacity > 0
    opacity: 0.0

    property alias title: message.text
    property alias timeout: hideTimer.interval
    property alias background: bg.color

    Behavior on opacity {
        FadeAnimation {}
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.secondaryHighlightColor
        //color: Theme.highlightColor
        opacity: 0.9
    }

    Timer {
        id: hideTimer
        triggeredOnStart: false
        repeat: false
        interval: 5000
        onTriggered: popup.hide()
    }

    function hide() {
        if (hideTimer.running)
            hideTimer.stop()

        popup.opacity = 0.0
    }

    function show() {
        popup.opacity = 1.0
        //hideTimer.restart()
    }

    function notify(text) {
        popup.title = text
        show()
    }

    Label {
        id: message
        anchors.verticalCenter: popup.verticalCenter
        //font.pixelSize: 32

        color: Theme.secondaryColor

        anchors {
            left: parent.left
            leftMargin: Theme.paddingLarge
            right: parent.right
            rightMargin: Theme.paddingLarge
        }

        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        wrapMode: Text.Wrap
    }

    onClicked: hide()
}
