import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

DockedPanel {
    id: player

    dock: Dock.Bottom
    //open: audio.playbackState != Audio.StoppedState

    width: parent.width
    height: column.height + Theme.paddingLarge
    contentHeight: height
    flickableDirection: Flickable.VerticalFlick

    property StationsModel stations
    readonly property bool playing: audio.playbackState == Audio.PlayingState
    readonly property int currentStation: _currentStation

    property int _currentStation: -1

    function play(id) {
        var station = player.stations.getById(id)

        if (!station)
            return

        if (audio.playbackState != Audio.StoppedState)
            audio.stop()

        _currentStation = station.stationId

        audio.source = station.url
        audio.play()

        showControls()
    }

    function showControls() {
        if (playing)
            open = true
    }

    function hideControls() {
        open = false
    }

    onOpenChanged: {
        if (!open)
            audio.stop();
    }

    Image {
        width: parent.width
        fillMode: Image.PreserveAspectFit
        source: "image://theme/graphic-gradient-edge"
    }

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
            visible: audio.status == 2 || audio.status == 4
        }
    }

    Audio {
        id: audio

        autoLoad: false
        autoPlay: false

        function toggle() {
            if (playbackState == Audio.StoppedState)
                return;

            if (playbackState == Audio.PlayingState)
                audio.pause();
            else
                audio.play();
        }

        onStatusChanged: {
            switch (status) {
            case Audio.Buffering:
            case Audio.Stalled:
                progress.label = "Buffering..."
                break;

            case 2:
                progress.label = "Loading..."
                break;

            default:
                progress.label = ""
                break;
            }

            console.log("[Audio]", "Status changed:", status)
        }

        onPlaybackStateChanged: {
            console.log("[Audio]", "PlaybackState changed:", playbackState)

            if (playbackState == Audio.StoppedState)
                _currentStation = -1
        }
    }
}
