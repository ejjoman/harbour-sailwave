import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: root

    width: parent ? parent.width : 0
    height: contentItem.height
    contentHeight: visible ? Theme.itemSizeMedium : 0
    opacity: enabled ? 1.0 : 0.4

    property alias label: titleText.text
    property alias value: valueText.text

    Column {
        id: content

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: Theme.paddingLarge
            rightMargin: Theme.paddingLarge
        }

        Label {
            id: titleText
            width: parent.width
            color: root.down ? Theme.highlightColor : Theme.primaryColor
            truncationMode: TruncationMode.Fade
        }

        Label {
            id: valueText
            width: parent.width
            color: Theme.highlightColor
            truncationMode: TruncationMode.Fade
        }
    }
}
