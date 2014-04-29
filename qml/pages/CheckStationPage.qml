import QtQuick 2.0
import Sailfish.Silica 1.0
import "../common"

Dialog {
    id: root

    property Station station

    forwardNavigation: false

    onStatusChanged: {
        if (status === PageStatus.Active)
            player.validateStream(root.station.streamUrl)
        else if(status === PageStatus.Inactive)
            player.resumePlayback()
    }

    onRejected: player.cancelValidation()

    DialogHeader {
        title: qsTr("Validating station")
        cancelText: qsTr("Cancel")
    }

    BusyIndicator {
        id: busyIndicator
        running: !!root.station
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
    }

    Connections {
        target: player

        onValidationFinished: {
            console.log("[CheckStation]", "onValidationFinished", success)

            root.forwardNavigation = true

            root.acceptDestinationAction = PageStackAction.Pop
            root.acceptDestination = mainPage

            if (success) {
                stations.addOrUpdateWithStation(root.station)
                root.accept()
            } else {
                root.reject()
            }
        }
    }
}
