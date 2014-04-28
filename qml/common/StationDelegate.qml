import QtQuick 2.0
import Sailfish.Silica 1.0

import "."

ListItem {
    id: listItem
    menu: contextMenu

    property StationsModel stationsModel
    property Page successDestination

    readonly property bool isCurrentlyPlaying: player.currentStation >= 0 && player.currentStation == stationId

    function remove() {
        //: Station gets deleted through context menu (remorse)
        remorseAction(qsTr("Deleting"), function() {
            stations.removeStation(stationId)
        });
    }

    onClicked: player.play(stationId)

    Label {
        anchors {
            left: parent.left
            leftMargin: Theme.paddingLarge

            right: parent.right
            rightMargin: Theme.paddingLarge

            verticalCenter: parent.verticalCenter
        }

        text: !listItem.filtering ? name : Theme.highlightText(name, view.searchField.text, Theme.highlightColor)
        font.pixelSize: Theme.fontSizeLarge

        color: isCurrentlyPlaying ? Theme.highlightColor : Theme.primaryColor
    }

    ListView.onAdd: AddAnimation {
        target: listItem
    }

    ListView.onRemove: RemoveAnimation {
        target: listItem
    }

    Component {
        id: contextMenu

        ContextMenu {
            MenuItem {
                text: qsTr("Edit")
                onClicked: {
                    var dialog = pageStack.push("../pages/StationEditDialog.qml", {
                                                    "model": stationsModel,
                                                    "station": stationsModel.getStationById(stationId),
                                                    "successDestination": successDestination
                                                })
                }
            }

            MenuItem {
                text: qsTr("Remove")
                onClicked: listItem.remove()
            }
        }
    }
}
