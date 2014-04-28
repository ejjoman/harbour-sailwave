.pragma library

function formatPlaybackDuration(duration) {
    //: Time format for playback time, Hours > 0.
    if (duration.getHours() > 0)
        return Qt.formatTime(duration, qsTr("HH:mm:ss"))

    //: Time format for playback time, Hours = 0.
    return Qt.formatTime(duration, qsTr("mm:ss"))
}

function formatSleepTimerDuration(duration, small) {
    return small ? _formatSleepTimerDurationSmall(duration) : _formatSleepTimerDurationNormal(duration)
}

function _formatSleepTimerDurationSmall(duration) {
    //: Time format for small sized labels, Hours > 0.
    if (duration.getHours() > 0)
        return Qt.formatTime(duration, qsTr("HH:mm"))

    //: Time format for small sized labels, Hours = 0.
    return Qt.formatTime(duration, qsTr("mm:ss"))
}

function _formatSleepTimerDurationNormal(duration) {
    //: Time format for normal (large) sized labels, Hours > 0.
    if (duration.getHours() > 0)
        return Qt.formatTime(duration, qsTr("HH'h' mm'm' ss's'"))


    //: Time format for normal (large) sized labels, Hours = 0.
    return Qt.formatTime(duration, qsTr("mm'm' ss's'"))
}
