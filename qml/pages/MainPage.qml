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

Page {
    id: page

    SilicaListView {
        id: view

        anchors.fill: parent
        header: PageHeader {
            title: "SailWave WebRadio"
        }

        model: stations

        delegate: ListItem {
            id: listItem
            menu: contextMenu

            readonly property bool isCurrentlyPlaying: player.currentStation >= 0 && player.currentStation == stationId

            Label {
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingMedium

                    right: parent.right
                    rightMargin: Theme.paddingMedium

                    verticalCenter: parent.verticalCenter
                }

                text: name
                font.pixelSize: Theme.fontSizeLarge

                color: isCurrentlyPlaying ? Theme.highlightColor : Theme.primaryColor
            }

            onClicked: player.play(stationId)

            function remove() {
                remorseAction("Deleting", function() {
                    stations.removeStation(stationId)
                });
            }

            Component {
                id: contextMenu

                ContextMenu {
                    MenuItem {
                        text: "Edit"
                        onClicked: {
                            var dialog = pageStack.push("StationEditDialog.qml", {
                                                            "model": stations,
                                                            "station": stations.getStationById(stationId)
                                                        })
                        }
                    }

                    MenuItem {
                        text: "Remove"
                        onClicked: listItem.remove()
                    }
                }
            }
        }

        PullDownMenu {
            MenuItem {
                text: "Add station"

                onClicked: {
                    var dialog = pageStack.push("StationEditDialog.qml", {
                                                    "model": stations
                                                })

//                    dialog.accepted.connect(function() {
//                        //displayedName.text = "My name: " + name
//                    })
                }
            }
        }

        ViewPlaceholder {
            text: "No stations available. Pull down to add a new station."
            enabled: view.count == 0
        }

        //contentHeight: content.height

//        Column {
//            id: content
//            width: parent.width



//            Label {
//                id: favs
//                text: "Favs..."
//            }

//            Item {
//                // spacer to keep page links at bottom when the page isn't full, and always keep a little margin
//                height: Math.max(2*Theme.paddingLarge, page.height - favs.height - actions.height)
//                width: parent.width
//            }

//            Column {
//                id: actions

//                Button {
//                    text: "Lade BigFM"

//                    onClicked: {
//                        player.play("http://217.151.152.245:80/bigfm-mp3-64")
//                    }
//                }

//                Button {
//                    text: "My Stations"
//                }

//                Button {
//                    text: "Find Stations"
//                }
//            }


//        }

        VerticalScrollDecorator {}
    }

    Component {
        id: stationEditDialog

        StationEditDialog {}
    }
}


