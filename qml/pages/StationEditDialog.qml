import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sailwave 1.0
import "../common"

Dialog {
    id: dialog
    property Station station
    readonly property bool isNew: station ? false : true

    acceptDestination: settings.validateStreamUrl ? checkStationPage : null
    canAccept: nameField.text.length > 0 && streamUrl.text.length > 0 && Sailwave.validateUrl(streamUrl.text);

    onAccepted: {
        //checkStationPage.source = streamUrl.text

        var component = Qt.createComponent("../common/Station.qml") //new Station()
        var s = component.createObject(null, {
                                           "stationId": (isNew ? -1 : station.stationId),
                                           "name": nameField.text,
                                           "streamUrl": streamUrl.text
                                       })

        if (component.status === Component.Ready) {
            if (settings.validateStreamUrl) {
                acceptDestinationInstance.station = s
            } else {
                stations.addOrUpdateWithStation(s)
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            spacing: Theme.paddingMedium

            DialogHeader {
                acceptText: isNew ? qsTr("Add") : qsTr("Save")
                title: nameField.text
            }

            TextField {
                id: nameField
                anchors {
                    left: parent.left
                    right: parent.right
                }

                text: station ? station.name : ''
                placeholderText: qsTr("Name")
                label: placeholderText
            }

            TextField {
                id: streamUrl
                anchors {
                    left: parent.left
                    right: parent.right
                }

                text: station ? station.streamUrl : ''
                inputMethodHints: Qt.ImhUrlCharactersOnly
                placeholderText: qsTr("Stream URL")
                label: placeholderText
            }
        }

        VerticalScrollDecorator {}
    }
}
