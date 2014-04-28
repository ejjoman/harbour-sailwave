import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "../js/DurationFormatter.js" as DurationFormatter

DockedPanel {
    id: player

    Connections {
        target: Qt.inputMethod

        onVisibleChanged: {
            if (Qt.inputMethod.visible) {
                if (player.playing || player.paused) {
                    player.hideControls(false);
                }
            } else {
                player.showControls();
            }
        }
    }

    SleepTimer {
        id: timer

        onSleepTimerTriggered: {
            player.stop();
        }
    }

    dock: Dock.Bottom
    width: parent.width
    height: column.height + Theme.paddingLarge
    contentHeight: height
    flickableDirection: Flickable.VerticalFlick

    property StationsModel stations

    readonly property bool active: open
    readonly property bool playing: audio.playbackState == Audio.PlayingState
    readonly property bool paused: audio.playbackState == Audio.PausedState
    readonly property int currentStation: _currentStation
    readonly property SleepTimer sleepTimer: timer
    property alias durationTimer: _durationTimer
    property alias status: audio.status

    property int _currentStation: -1
    property bool _closedByUser: true
    property bool _isValidateMode: false;
    property int _lastPlayedStation: -1

    signal validationFinished(bool success)

    onCurrentStationChanged: {
        durationTimer.reset();
    }

    function play(id) {
        if (!id) {
            if (paused) {
                audio.play();
            } else {
                player.playNext();
                player.showControls();
            }
        } else {
            var station = player.stations.getById(id)

            if (!station)
                return

            if (audio.playbackState !== Audio.StoppedState)
                player.stop()

            _currentStation = station.stationId

            console.log(station, station.streamUrl)

            audio.source = station.streamUrl
            audio.play()

            player.showControls();
        }
    }

    function stop() {
        if (audio.playbackState !== Audio.StoppedState) {
            audio.stop()
            audio.source = ""
        }
    }

    function pause() {
        audio.pause();
    }

    function toggle() {
        if (audio.playbackState == Audio.StoppedState && stations.count === 0)
            return;

        if (audio.playbackState == Audio.PlayingState)
            player.pause()
        else
            player.play();
    }

    function showControls() {
        if (player.playing || player.paused)
            player.open = true
    }

    function hideControls(stopPlayback) {
        if (!stopPlayback)
            player._closedByUser = false

        player.hide();

        if (!stopPlayback)
            player._closedByUser = true
    }

    function playNext() {
        if (stations.count === 0)
            return;

        var nextStation = null;

        if (currentStation < 0 || stations.indexOf(currentStation) === stations.count - 1)
            nextStation = stations.get(0);
        else
            nextStation = stations.get(stations.indexOf(currentStation) + 1);

        if (nextStation)
            play(nextStation.stationId);
    }

    function validateStream(url) {
        if (player.playing || player.paused) {
            _lastPlayedStation = _currentStation
            player.stop()
        }

        player._isValidateMode = true;
        audio.autoLoad = true;
        audio.source = url;
    }

    function cancelValidation() {
        _endValidation(false);
    }

    function _endValidation(emitSignal) {
        if (!player._isValidateMode)
            return;

        player._isValidateMode = false;

        if (emitSignal)
            player.validationFinished(status == Audio.Loaded)

        audio.autoLoad = false;
        //audio.source = "";

        if (player._lastPlayedStation > -1)
            player.play(_lastPlayedStation);
        else
            audio.source = "";

    }

    onOpenChanged: {
        if (!player.open && player._closedByUser)
            player.stop();
    }

    Column {
        id: column
        width: parent.width

        spacing: Theme.paddingMedium

        IconButton {
            id: playPause
            anchors.horizontalCenter: parent.horizontalCenter
            icon.source: audio.playbackState == Audio.PlayingState ? "image://theme/icon-m-pause?" + Theme.highlightColor : "image://theme/icon-m-play"

            onClicked: player.toggle()
        }

        ProgressBar {
            id: progress
            width: parent.width
            indeterminate: true
            visible: progress.label !== ""
        }

        Label {
            visible: !progress.visible
            text: DurationFormatter.formatPlaybackDuration(durationTimer.duration);
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Timer {
        id: _durationTimer
        running: audio.playbackState === Audio.PlayingState && audio.status === Audio.Buffered
        repeat: true
        interval: 1000

        property date duration: new Date(0, 0, 0, 0, 0, 0, 0)

        onTriggered: {
            duration = new Date(0, 0, 0, duration.getHours(), duration.getMinutes(), duration.getSeconds()+1, 0)
        }

        function reset() {
            stop()
            duration = new Date(0, 0, 0, 0, 0, 0, 0)
        }
    }

    Audio {
        id: audio

        autoLoad: false
        autoPlay: false

        onError: {
            var errorMessage = "";

            switch (error) {
            case Audio.NoError:
                return;

            case Audio.ResourceError:
                errorMessage = qsTr("The stream URL is not valid.")
                break;

            case Audio.FormatError:
                errorMessage = qsTr("The stream format is not supported.")
                break;

            case Audio.NetworkError:
                errorMessage = qsTr("The network is not available.")
                break;

            case Audio.AccessDenied:
                errorMessage = qsTr("No permessions to access the stream.")
                break;

            case Audio.ServiceMissing:
                errorMessage = qsTr("The audio service could not be instantiated.")
                break;

            default:
                errorMessage = qsTr("An unknown error occured.")
                break;
            }

            popup.show(errorMessage, settings.showDetailedErrorMessage ? errorString : "", 5000)
        }

        onStatusChanged: {
            if (player._isValidateMode) {
                console.log("[Audio]", "[Validation]", "Status changed:", status)

                if (status === MediaPlayer.Loading)
                    return;

                _endValidation(true);

            } else {
                console.log("[Audio]", "[Playback]", "Status changed:", status)

                switch (status) {
                case Audio.Buffering:
                case Audio.Stalled:
                    progress.label = qsTr("Buffering...")
                    break;

                case Audio.Loading:
                    progress.label = qsTr("Loading...")
                    //progress.visible = true;
                    break;

                default:
                    progress.label = ""
                    //progress.visible = false;
                    break;
                }
            }
        }

        onPlaybackStateChanged: {
            console.log("[Audio]", "PlaybackState changed:", playbackState)

            if (playbackState == Audio.StoppedState) {
                player._currentStation = -1
                player.hide()
            }
        }
    }
}
