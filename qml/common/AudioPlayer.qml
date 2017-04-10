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

    background: Rectangle {
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.7; color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity) }
        }
    }

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
        if (!stations.hasStations())
            return;

        var nextStation = null;

        if (currentStation < 0 || stations.indexOf(currentStation) === stations.count - 1)
            nextStation = stations.get(0);
        else
            nextStation = stations.get(stations.indexOf(currentStation) + 1);

        if (nextStation)
            player.play(nextStation.stationId);
    }

    function playPrevious() {
        if (!stations.hasStations())
            return;

        var prevStation = null;

        if (currentStation < 0 || stations.indexOf(currentStation) === 0) //stations.count - 1)
            prevStation = stations.get(stations.count - 1);
        else
            prevStation = stations.get(stations.indexOf(currentStation) - 1);

        if (prevStation)
            player.play(prevStation.stationId);
    }

    function validateStream(url) {
        if (player.playing || player.paused) {
            _lastPlayedStation = _currentStation
            player.stop()
        } else {
            _lastPlayedStation = -1
        }

        _hadErrorWhileValidation = false

        player._isValidateMode = true;
        audio.autoLoad = true;
        audio.source = url;
    }

    function cancelValidation() {
        endValidation(false);
    }

    function resumePlayback() {
        if (player._lastPlayedStation > -1)
            player.play(_lastPlayedStation);
    }

    property bool _hadErrorWhileValidation: false

    function endValidation(emitSignal) {
        if (!player._isValidateMode)
            return;

        player._isValidateMode = false;

        if (emitSignal)
            player.validationFinished(status === Audio.Loaded)

        //audio.source = "";
        audio.autoLoad = false;
        audio.stop()
    }

    onOpenChanged: {
        if (!player.open && player._closedByUser)
            player.stop();
    }

    Column {
        id: column
        width: parent.width

        spacing: Theme.paddingMedium

        ProgressBar {
            id: progress
            width: parent.width
            indeterminate: audio.status === Audio.Loading
            value: audio.bufferProgress
            visible: progress.label !== ""

            Behavior on value {
                NumberAnimation {}
            }

            label: {
                switch (audio.status) {
                case Audio.Buffering:
                case Audio.Stalled:
                    return qsTr("Buffering...")

                case Audio.Loading:
                    return qsTr("Loading...")

                default:
                    return ""
                }
            }
        }

        Column {
            width: parent.width

            Label {
                id: titleLabel

                width: Math.min(parent.width - 2*Theme.paddingMedium, implicitWidth)
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor
                truncationMode: TruncationMode.Fade
                visible: text.length > 0
            }

            Label {
                id: publisherLabel

                width: Math.min(parent.width - 2*Theme.paddingMedium, implicitWidth)
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                truncationMode: TruncationMode.Fade
                visible: text.length > 0
            }
        }


        Label {
            visible: !progress.visible
            text: DurationFormatter.formatPlaybackDuration(durationTimer.duration);
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            width: parent.width
            height: playPause.height

            IconButton {
                id: playPrev
                width: parent.width / 3
                icon.source: "image://theme/icon-m-previous"
                onClicked: player.playPrevious()
                enabled: stations.count > 1
            }

            IconButton {
                id: playPause
                width: parent.width / 3
                icon.source: audio.playbackState == Audio.PlayingState ? "image://theme/icon-m-pause?" + Theme.highlightColor : "image://theme/icon-m-play"

                onClicked: player.toggle()
            }

            IconButton {
                id: playNext
                width: parent.width / 3
                icon.source: "image://theme/icon-m-next"
                onClicked: player.playNext()
                enabled: stations.count > 1
            }
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

        property bool _hadInvalidMedia: false

        autoLoad: false
        autoPlay: false

        onError: {
            console.log("[Audio]", "Error", error, errorString)

            // Suppress "wrong" errors
            if (!audio._hadInvalidMedia)
                return;

            audio._hadInvalidMedia = false

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

        function updateMetaData() {
            console.log("Title:", metaData["title"])
            console.log("Publisher:", metaData["publisher"])

            titleLabel.text = metaData["title"] || ""
            publisherLabel.text = metaData["publisher"] || ""
        }

        onStatusChanged: {
            console.log("[Audio]", "Status changed:", status)
            console.log("[Audio]", "Validate mode:", player._isValidateMode)

            if (status === Audio.InvalidMedia || status === Audio.UnknownStatus)
                _hadInvalidMedia = true

            if (player._isValidateMode && status !== MediaPlayer.Loading)
                endValidation(true);
        }

        onPlaybackStateChanged: {
            console.log("[Audio]", "PlaybackState changed:", playbackState)

            if (playbackState == Audio.StoppedState) {
                player._currentStation = -1
                player.hide()
            }
        }

        metaData.onMetaDataChanged: updateMetaData()
    }
}
