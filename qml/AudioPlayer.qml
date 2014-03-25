import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

DockedPanel {
    id: player

    Connections {
        target: Qt.inputMethod

        onVisibleChanged: {
            if (Qt.inputMethod.visible) {
                if (player.playing || player.paused) {
                    player._closedByUser = false
                    player.hide();
                    player._closedByUser = true
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
    //open: audio.playbackState != Audio.StoppedState

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

    onCurrentStationChanged: {
        durationTimer.reset();
    }

    function play(id) {
        var station = player.stations.getById(id)

        if (!station)
            return

        if (audio.playbackState !== Audio.StoppedState)
            player.stop()

        _currentStation = station.stationId

        console.log(station, station.streamUrl)

        audio.source = station.streamUrl
        audio.play()

        player.showControls()
    }

    function stop() {
        if (audio.playbackState !== Audio.StoppedState) {
            // stop playback
            audio.stop()

            // stop streaming
            audio.source = ""
        }
    }

    function toggle() {
        if (audio.playbackState == Audio.StoppedState && stations.count === 0)
            return;

        if (audio.playbackState == Audio.PlayingState) {
            audio.pause();
        } else {
            if (currentStation < 0)
                playNext(); // Play first station
            else
                audio.play();
        }
    }

    function showControls() {
        if (player.playing || player.paused)
            player.open = true
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

    onOpenChanged: {
        // stop playback when player is closed by user...

        if (!player.open && player._closedByUser)
            player.stop();
    }

//    Image {
//        width: parent.width
//        fillMode: Image.PreserveAspectFit
//        source: "image://theme/graphic-gradient-edge"
//        //source: "image://theme/graphic-gradient-home-top"
//    }

    Column {
        id: column
        width: parent.width
        //height: playPause.height

        spacing: Theme.paddingMedium

        IconButton {
            id: playPause
            anchors.horizontalCenter: parent.horizontalCenter
            icon.source: audio.playbackState == Audio.PlayingState ? "image://theme/icon-m-pause?" + Theme.highlightColor : "image://theme/icon-m-play"

            onClicked: audio.toggle()
        }

        ProgressBar {
            id: progress
            width: parent.width
            indeterminate: true
            visible: label !== ""
        }

        Label {
            visible: !progress.visible
            text: durationFormatter.formatPlaybackDuration(durationTimer.duration);
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

        onStatusChanged: {
            switch (status) {
            case Audio.Buffering:
            case Audio.Stalled:
                progress.label = qsTr("Buffering...")
                break;

            case Audio.Loading:
                progress.label = qsTr("Loading...")
                break;

            default:
                progress.label = ""
                break;
            }

            console.log("[Audio]", "Status changed:", status)
        }

        onPlaybackStateChanged: {
            console.log("[Audio]", "PlaybackState changed:", playbackState)

            if (playbackState == Audio.StoppedState) {
                player._currentStation = -1
                player.hide()
            }
        }
    }

    Timer {
        interval: 5000
        running: player.playing
        repeat: true

        onTriggered: {
            console.log("[Player]", "[Metadata]");

            for (var m in audio.metaData) {
                //if (!audio.metaData[m] || typeof audio.metaData[m] == "function")
                //    continue;

                console.log("\t", "[Player]", "[Metadata]", m, audio.metaData[m]);
            }
        }
    }
}
