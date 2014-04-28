import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root

    SilicaFlickable {
        clip: true
        contentHeight: column.height

        anchors.fill: parent

        Column {
            id: column
            width: parent.width

            spacing: Theme.paddingLarge

            PageHeader {
                id: header
                title: qsTr("License")
            }

            Image {
                id: aboutCover
                fillMode: Image.PreserveAspectFit
                source: "../images/GPLv3.png"

                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
            }

            Label {
                wrapMode: Text.WordWrap

                anchors {
                    left: parent.left
                    right: parent.right
                    //margins: Theme.paddingLarge
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                }

                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                linkColor: Theme.primaryColor

                text: "<p>This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.</p>
<p>This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.</p>
<p>You should have received a copy of the GNU General Public License
along with this program. If not, see <a href=\"http://www.gnu.org/licenses/\">http://www.gnu.org/licenses/</a>.</p>"
            }
        }

        VerticalScrollDecorator {}
    }
}
