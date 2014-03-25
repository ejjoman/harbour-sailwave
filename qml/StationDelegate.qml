import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: listItem

    //readonly property bool filtering: view.searchField.text != ""
    readonly property bool isCurrentlyPlaying: player.currentStation >= 0 && player.currentStation == stationId

    ListView.onAdd: AddAnimation {
        target: listItem
    }

    ListView.onRemove: RemoveAnimation {
        target: listItem
    }

    //visible: !filtering || name.toLowerCase().indexOf(view.searchField.text.toLowerCase()) > -1
    menu: contextMenu

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

    onClicked: player.play(stationId)

    function remove() {
        remorseAction("Deleting", function() {
            stations.removeStation(stationId)
        });
    }

    Component {
        id: contextMenu

        ContextMenu {
            MenuItem {
                text: "Edit"
                onClicked: {
                    var dialog = pageStack.push("pages/StationEditDialog.qml", {
                                                    "model": stations,
                                                    "station": stations.getStationById(stationId)
                                                })
                }
            }

            MenuItem {
                text: "Remove"
                onClicked: listItem.remove()
            }
        }
    }
}
