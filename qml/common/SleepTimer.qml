import QtQuick 2.0

Item {
    id: root

    property date time // new Date(year, month, day, hours, minutes, seconds, milliseconds)
    readonly property date timeTillTriggering: new Date(0, 0, 0, 0, 0, 0, root.time - timer._elapsed)
    readonly property bool active: timer.running || _isResetting

    signal sleepTimerTriggered;

    // used for active flag...
    property bool _isResetting: false

    function startSleepTimer() {
        // ignore if timer is already running or no time was set
        if (timer.running || !root.time || root.time.getHours()+root.time.getMinutes() == 0)
            return;

        // Just use hours and minutes
        root.time = new Date(0, 0, 0, root.time.getHours(), root.time.getMinutes(), 0, 0);
        timer._elapsed = new Date(0, 0, 0, 0, 0, 0, 0)
        timer.start();
    }

    function stopSleepTimer() {
        if (!timer.running)
            return;

        timer.stop();
    }

    function reset() {
        _isResetting = true;

        timer.restart();
        timer._elapsed = new Date(0, 0, 0, 0, 0, 0, 0)

        _isResetting = false;
    }

    Timer {
        id: timer

        property date _elapsed

        interval: 1000
        repeat: true

        onTriggered: {
            timer._elapsed = new Date(0, 0, 0, timer._elapsed.getHours(), timer._elapsed.getMinutes(), timer._elapsed.getSeconds()+1, 0)

            if (timer._elapsed.getTime() != root.time.getTime())
                return;

            root.stopSleepTimer();
            root.sleepTimerTriggered();
        }
    }
}
