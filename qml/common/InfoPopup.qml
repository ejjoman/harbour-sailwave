/***************************************************************************
**
** Copyright (C) 2013-2014 Marko Koschak (marko.koschak@tisno.de)
** All rights reserved.
**
** This file is part of ownKeepass.
**
** ownKeepass is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 2 of the License, or
** (at your option) any later version.
**
** ownKeepass is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with ownKeepass. If not, see <http://www.gnu.org/licenses/>.
**
***************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea {
    id: infoPopup

    property alias popupTitle: titleLabel.text
    property alias popupMessage: messageLabel.text

    function show(title, message, timeout) {
        popupTitle = title
        popupMessage = message

        _timeout = timeout || 0

        if (_timeout !== 0) {
            countdown.restart()
        }

        state = "active"
    }

    function cancel() {
        _close()
    }

    function _close() {
        if (_timeout !== 0)
            countdown.stop()

        state = ""

        closed()
    }

    property int _timeout: 0

    signal closed

    opacity: 0.0
    visible: opacity > 0
    width: parent ? parent.width : Screen.width
    height: column.height + Theme.paddingMedium * 2 + colorShadow.height
    z: 1

    onClicked: cancel()

    states: State {
        name: "active"
        PropertyChanges { target: infoPopup; opacity: 1.0}
    }

    transitions: [
        Transition {
            to: "active"

            SequentialAnimation {
                PropertyAction { target: infoPopup; property: "visible" }
                FadeAnimation {}
            }
        },
        Transition {
            SequentialAnimation {
                FadeAnimation {}
                PropertyAction { target: infoPopup; property: "visible" }
            }
        }
    ]

    Rectangle {
        id: infoPopupBackground
        anchors.top: parent.top
        width: parent.width
        height: column.height + Theme.paddingMedium * 2
        color: Theme.highlightBackgroundColor
    }

    Rectangle {
        id: colorShadow
        anchors.top: infoPopupBackground.bottom
        width: parent.width
        height: 100
        color: Theme.highlightBackgroundColor
    }

    OpacityRampEffect {
        sourceItem: colorShadow
        slope: 0.5
        offset: 0.0
        clampFactor: -0.5
        direction: 2 // TtB
    }

    Column {
        id: column

        anchors {
            top: parent.top
            topMargin: Theme.paddingMedium

            left: parent.left
            leftMargin: Theme.paddingMedium

            right: parent.right
            rightMargin: Theme.paddingMedium
        }

        Label {
            id: titleLabel
            width: parent.width
            horizontalAlignment: Text.AlignLeft

            font {
                family: Theme.fontFamilyHeading
                pixelSize: Theme.fontSizeLarge
            }

            color: "black"
            opacity: 0.6
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            visible: titleLabel.text !== ""
        }

        Label {
            id: messageLabel
            width: parent.width
            horizontalAlignment: Text.AlignLeft

            font {
                family: Theme.fontFamily
                pixelSize: Theme.fontSizeExtraSmall
            }

            color: "black"
            opacity: 0.5
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            visible: messageLabel.text !== ""
        }
    }

    Timer {
        id: countdown
        running: false
        repeat: false
        interval: _timeout

        onTriggered: _close()
    }
}
