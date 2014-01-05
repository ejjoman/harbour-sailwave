import QtQuick 2.0
import Sailfish.Silica 1.0
import "../"

//import "../StationsModel.qml"

Dialog {
    id: dialog

    //property int stationId: -1
    property StationsModel model

    property Station station //: stationId >= 0 && model ? model.getStationById(stationId) : null
    readonly property bool isNew: station ? false : true

    canAccept: nameField.text.length > 0 && streamUrl.text.length > 0

    onAccepted: {
        console.log("Create component...")

        var component = Qt.createComponent("../Station.qml") //new Station()

        console.log("Component created.")
        console.log("create object")

        if (component.status == Component.Ready) {
            var s = component.createObject(null, {
                                               stationId: isNew ? -1 : station.stationId,
                                               name: nameField.text,
                                               streamUrl: streamUrl.text
                                           })

            console.log("object created:", s)

            dialog.model.addOrUpdate(s)
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
                acceptText: isNew ? "Add" : "Save"
                title: nameField.text
            }

            TextField {
                id: nameField
                anchors {
                    left: parent.left
                    right: parent.right
                }

                text: station ? station.name : ''
                placeholderText: "Name"
                label: placeholderText
            }

            TextField {
                id: streamUrl
                anchors {
                    left: parent.left
                    right: parent.right
                }

                text: station ? station.streamUrl : '' // "http://217.151.152.245:80/bigfm-mp3-64"

                placeholderText: "Stream URL"
                label: placeholderText
            }
        }
    }


}
