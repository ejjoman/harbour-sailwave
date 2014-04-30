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
}
