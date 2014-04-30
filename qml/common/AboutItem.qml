import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: root

    width: parent ? parent.width : 0
    height: contentItem.height
    contentHeight: visible ? content.height + 2 * Theme.paddingSmall : 0 // Math.max(Theme.itemSizeMedium, content.height) : 0
    opacity: enabled ? 1.0 : 0.4

    property alias label: titleText.text
    property alias value: valueText.text

    function remorseAction(text, action, timeout) {
        // null parent because a reference is held by RemorseItem until
        // it either triggers or is cancelled.
        var remorse = remorseComponent.createObject(null)
        remorse.execute(contentItem, text, action, timeout)
    }

    Column {
        id: content

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: Theme.paddingLarge
            rightMargin: Theme.paddingLarge

            //topMargin: Theme.paddingMedium
            //bottomMargin: Theme.paddingMedium
        }

        Label {
            id: titleText
            width: parent.width
            color: root.down ? Theme.highlightColor : Theme.primaryColor
            truncationMode: TruncationMode.Elide
            maximumLineCount: 2
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Label {
            id: valueText
            width: parent.width
            color: Theme.highlightColor
            truncationMode: TruncationMode.Elide
            maximumLineCount: 2
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }

    Component {
        id: remorseComponent
        RemorseItem { }
    }
}
