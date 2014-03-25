import QtQuick 2.0

QtObject {
    id: formatter

    function formatPlaybackDuration(duration) {
        if (duration.getHours() > 0)
            return Qt.formatTime(duration, "HH:mm:ss")

        return Qt.formatTime(duration, "mm:ss")
    }

    function formatSleepTimerDuration(duration, small) {
        return small ? _formatSleepTimerDurationSmall(duration) : _formatSleepTimerDurationNormal(duration)
    }

    function _formatSleepTimerDurationSmall(duration) {
        if (duration.getHours() > 0)
            return Qt.formatTime(duration, "HH:mm")

        return Qt.formatTime(duration, "mm:ss")
    }

    function _formatSleepTimerDurationNormal(duration) {
        if (duration.getHours() > 0)
            return Qt.formatTime(duration, "HH'h' mm'm' ss's'")

        return Qt.formatTime(duration, "mm'm' ss's'")
    }
}
