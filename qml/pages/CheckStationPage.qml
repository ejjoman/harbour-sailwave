import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root

    PageHeader {
        title: qsTr("Checking station")
    }

    BusyIndicator {
        running: true
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
    }
}
