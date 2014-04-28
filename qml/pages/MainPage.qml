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
import "../common"
import "../js/DurationFormatter.js" as DurationFormatter

Page {
    id: mainPage

    SilicaListView {
        id: list
        anchors.fill: parent

        PullDownMenu {
            //busy: player.sleepTimer.active

            MenuItem {
                text: qsTr("About")
                onClicked: {
                    pageStack.push("AboutPage.qml")
                }
            }

            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    pageStack.push("SettingsDialog.qml")
                }
            }

            MenuItem {
                text: qsTr("Sleep timer") + (player.sleepTimer.active ?
                                                 ": <b>" + DurationFormatter.formatSleepTimerDuration(player.sleepTimer.timeTillTriggering) + "</b>"
                                               : "")

                onClicked: {
                    if (player.sleepTimer.active) {
                        remorse.execute(qsTr("Sleep timer gets stopped"), function() {
                            player.sleepTimer.stopSleepTimer();
                        })
                    } else {
                        pageStack.push(sleepTimerDialog)
                    }
                }
            }

            MenuItem {
                text: qsTr("Add station")
                onClicked: {
                    var dialog = pageStack.push(stationEditDialog)
                }
            }
        }

        model: stations

        delegate: StationDelegate {
            stationsModel: stations
            successDestination: mainPage
        }

        header: PageHeader {
            id: header
            title: qsTr("Stations")
        }

        ViewPlaceholder {
            text: "No stations available. Pull down to add a new station."
            enabled: list.count == 0
        }

        VerticalScrollDecorator {}
    }

    RemorsePopup {
        id: remorse
    }
}


