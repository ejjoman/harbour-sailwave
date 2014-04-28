import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: root

    onAccepted: {
        settings.validateStreamUrl = validateStreamUrlSwitch.checked
        settings.showDetailedErrorMessage = showDetailedErrorMessageSwitch.checked

        settings.saveSettings()
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: content.height

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            DialogHeader {
                title: qsTr("Settings")
                acceptText: qsTr("Save")
                cancelText: qsTr("Cancel")
            }

            TextSwitch {
                id: validateStreamUrlSwitch
                checked: settings.validateStreamUrl
                text: qsTr("Validate the stream URL")
                description: qsTr("On adding or changing a station, check if the stream is valid and has a supported format.")
            }

            TextSwitch {
                id: showDetailedErrorMessageSwitch
                checked: settings.showDetailedErrorMessage
                text: qsTr("Show detailed error messages")
                description: qsTr("Show detailed error messages in notifications, reveived from phones multimedia engine.")
            }
        }

        VerticalScrollDecorator {}
    }
}
