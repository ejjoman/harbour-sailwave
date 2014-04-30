import QtQuick 2.0
import Sailfish.Silica 1.0
import "../common"

Page {
    id: root


    SilicaListView {
        id: listView
        anchors.fill: parent
        model: AboutModel {
            id: aboutModel
        }

        header:  PageHeader {
            title: qsTr("About SailWave")
        }

        delegate: AboutItem {
            label: model.title
            value: model.subTitle

            onClicked: {
                if (!model.pageFile && !model.url)
                    return;

                if (model.onClickedRemorse) {
                    remorseAction(model.onClickedRemorse, function() {
                        if (model.pageFile)
                            pageStack.push(model.pageFile)
                        else
                            Qt.openUrlExternally(model.url)
                    })
                } else {
                    if (model.pageFile)
                        pageStack.push(model.pageFile)
                    else
                        Qt.openUrlExternally(model.url)
                }


            }
        }

        section.property: "group"
        section.criteria: ViewSection.FullString
        section.delegate: SectionHeader { text: section }

        VerticalScrollDecorator {}
    }

/*
    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: content.height

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("About SailWave")
            }

            SectionHeader {
                text: qsTr("Project")
            }

            AboutItem {
                label: qsTr("Project Home")
                value: "GitHub"

                onClicked: {
                    openUrlPopup.openUrl("https://github.com/ejjoman/harbour-sailwave")
                }
            }

            AboutItem {
                label: qsTr("License")
                value: "GNU General Public License v3"

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("LicensePage.qml"))
                }
            }

            AboutItem {
                label: qsTr("Report a bug or send a feature request")
                value: "GitHub Issues"

                onClicked: {
                    openUrlPopup.openUrl("https://github.com/ejjoman/harbour-sailwave/issues")
                }
            }

            AboutItem {
                label: qsTr("Author")
                value: "Michael Neufing <m.neufing@yahoo.de>"

                onClicked: {
                    openUrlPopup.openUrl("mailto:m.neufing@yahoo.de?subject=SailWave", qsTr("Mail app will open"))
                }
            }

            AboutItem {
                label: qsTr("Twitter")
                value: "@ejjoman"

                onClicked: {
                    openUrlPopup.openUrl("https://twitter.com/ejjoman")
                }
            }

            AboutItem {
                label: qsTr("Donate")
                value: "via PayPal"

                onClicked: {
                    openUrlPopup.openUrl("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3KSKM9EACDQRS")
                }
            }
        }

        VerticalScrollDecorator {}
    }
*/
    RemorsePopup {
        id: openUrlPopup

        function openUrl(url, title) {
            openUrlPopup.execute(qsTr(title) || qsTr("Link will open"), function(){
                Qt.openUrlExternally(url);
            })
        }
    }
}
