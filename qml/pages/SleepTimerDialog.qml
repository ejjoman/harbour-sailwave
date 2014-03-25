import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

TimePickerDialog {
    id: root

    property AudioPlayer player: null

    timeText: qsTr("Sleep timer")

    onAccepted: {
        if (!player || (hour === 0 && minute === 0))
            return;

        player.sleepTimer.time = new Date(0, 0, 0, root.hour, root.minute, 0, 0);
        player.sleepTimer.startSleepTimer();
    }
}
