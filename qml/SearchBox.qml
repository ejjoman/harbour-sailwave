import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root

    property bool active: false
    property alias placeholderText: searchField.placeholderText

    width: parent.width
    height: 0
    opacity: 0

    states: State {
        name: "active"
        when: root.active

        PropertyChanges {
            target: root
            height: searchField.height
            opacity: 1.0
        }
    }

    transitions: Transition {
        NumberAnimation { properties: "height, opacity"; duration: 250 }
    }


    SearchField {
        id: searchField
        width: parent.width
        height: implicitHeight
        enabled: root.active
        //focus: root.active
        //focusOutBehavior: FocusBehavior.KeepFocus
    }
}
