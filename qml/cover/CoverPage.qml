/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "../common"
import "../js/DurationFormatter.js" as DurationFormatter

CoverBackground {
    Image {
        source: "../images/radio.png"
        anchors {
            right: parent.right
            bottom: parent.bottom

            rightMargin: Theme.paddingMedium
            bottomMargin: Theme.paddingMedium
        }

        fillMode: Image.PreserveAspectFit
        height: 2/3 * parent.height


        opacity: .15
    }

    function _updateSlideshow() {
        console.log("[Cover]", "_updateSlideshow")
        console.log("[Cover]", "player.active:", player.active)
        console.log("[Cover]", "player.sleepTimer.active", player.sleepTimer.active)

        if (player.active === player.sleepTimer.active)
            return;

        timersSlideshowView.currentIndex = player.active ? 0 : 1;
    }

    Connections {
        target: player
        onActiveChanged: _updateSlideshow()
    }

    Connections {
        target: player.sleepTimer
        onActiveChanged: _updateSlideshow()
    }

    Connections {
        target: player
        onStatusChanged: {
            switch (player.status) {
            case Audio.Buffering:
            case Audio.Stalled:
                statusLabel.text = qsTr("Buffering...")
                break;

            case Audio.Loading:
                statusLabel.text =  qsTr("Loading...")
                break;

            default:
                statusLabel.text = ""
                break;

            }
        }
    }

    Column {
        x: Theme.paddingMedium
        y: Theme.paddingMedium
        width: parent.width - 2*Theme.paddingMedium

        spacing: Theme.paddingSmall

        SlideshowView {
            id: timersSlideshowView

            path: Path {
                id: path

                startX: timersSlideshowView.itemWidth / 2
                startY: -(timersSlideshowView.itemHeight * timersSlideshowView._multiplier - timersSlideshowView.height/2)

                PathLine {
                    x: timersSlideshowView.itemWidth / 2
                    y: (timersSlideshowView.pathItemCount * timersSlideshowView.itemHeight) + path.startY
                }
            }

            currentIndex: 0

            model: VisualItemModel {
                Label {
                    id: playbackDurationLabel

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    horizontalAlignment: contentWidth > width ? Text.AlignLeft : Text.AlignHCenter

                    font.pixelSize: Theme.fontSizeHuge
                    text: DurationFormatter.formatPlaybackDuration(player.durationTimer.duration)

                    opacity: player.playing ? 1 : 0.4
                }

                Label {
                    id: sleeptimerDurationLabel

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    PulseAnimation {
                        target: sleeptimerDurationLabel
                        running: !sleepTimerResetTimer.timeout
                    }

                    font.pixelSize: Theme.fontSizeHuge
                    color: Theme.highlightColor
                    truncationMode: TruncationMode.Fade
                    horizontalAlignment: contentWidth > width ? Text.AlignLeft : Text.AlignHCenter

                    text: DurationFormatter.formatSleepTimerDuration(player.sleepTimer.timeTillTriggering, true)
                }
            }

            interactive: false
            clip: true
            height: Theme.fontSizeHuge
            itemHeight: height
            itemWidth: width
            visible: !statusLabel.visible && (player.active || player.sleepTimer.active)
        }

        Label {
            id: currentStation

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 3
            font.pixelSize: Theme.fontSizeLarge
            lineHeightMode: Text.FixedHeight
            lineHeight: Theme.itemSizeMedium / 2

            text: player.currentStation > -1 ? stations.getById(player.currentStation).name : ""
            visible: player.currentStation > -1 && !statusLabel.visible && player.active
        }

        Label {
            id: statusLabel
            width: parent.width
            visible: player.status === Audio.Buffering || player.status === Audio.Stalled || player.status === Audio.Loading

            truncationMode: TruncationMode.Fade
            horizontalAlignment: contentWidth > width ? Text.AlignLeft : Text.AlignHCenter

            PulseAnimation {
                target: statusLabel
                running: statusLabel.visible
            }
        }
    }

    Timer {
        id: timer

        interval: 5000
        running: player.active && player.sleepTimer.active
        repeat: true

        onTriggered: {
            console.log("[Cover]", "Timer", "triggered")
            timersSlideshowView.decrementCurrentIndex();
        }

        function goTo(index) {
            if (!running)
                return;

            restart();

            // just restart the timer, when index is already the current index
            if (timersSlideshowView.currentIndex === index)
                return;

            timersSlideshowView.currentIndex = index;
        }
    }

    CoverActionList {
        id: noStationsCoverActionList
        enabled: !stations.hasStations()

        CoverAction {
            iconSource: "image://theme/icon-cover-new"

            onTriggered: {
                window.activate()
                pageStack.push(stationEditDialog)
            }
        }
    }

    CoverActionList {
        id: notPlayingNoSleeptimerCoverActionList

        enabled: (!player.active || stations.count < 2) && !player.sleepTimer.active && !noStationsCoverActionList.enabled

        CoverAction {
            iconSource: player.playing ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: {
                player.toggle();
            }
        }
    }

    CoverActionList {
        id: playingCoverActionList

        enabled: !notPlayingNoSleeptimerCoverActionList.enabled && !noStationsCoverActionList.enabled

        CoverAction {
            iconSource: player.playing ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: {
                sleepTimerResetTimer.reset();

                timer.goTo(0);
                player.toggle();
            }
        }

        CoverAction {
            iconSource: {
                if (player.sleepTimer.active)
                    return sleepTimerResetTimer.timeout ? "image://theme/icon-cover-refresh" : "image://theme/icon-cover-cancel"

                return "image://theme/icon-cover-next-song"
            }

            onTriggered: {
                if (player.sleepTimer.active) {
                    if (!sleepTimerResetTimer.timeout) {
                        sleepTimerResetTimer.reset();
                        player.sleepTimer.stopSleepTimer();
                    } else {
                        timer.goTo(1);

                        player.sleepTimer.reset();
                        sleepTimerResetTimer.run();
                    }
                } else {
                    timer.goTo(0);
                    player.playNext()
                }
            }
        }
    }

    Timer {
        id: sleepTimerResetTimer

        interval: 3000
        property bool timeout: true

        function run() {
            timeout = false
            start()
        }

        function reset() {
            stop()
            timeout = true;
        }

        onTriggered: {
            timeout = true;
        }
    }
}


