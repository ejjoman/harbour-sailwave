import QtQuick 2.0

ListModel {
    id: model

    Component.onCompleted: {
        var items = [
                    {
                        title: qsTr("Project Home"),
                        subTitle: qsTr("on GitHub"),
                        group: qsTr("Project"),
                        onClickedRemorse: qsTr("Link will open"),
                        url: "https://github.com/ejjoman/harbour-sailwave"
                    },
                    {
                        title: qsTr("License"),
                        subTitle: "GNU General Public License v3",
                        group: qsTr("Project"),
                        pageFile: Qt.resolvedUrl("../pages/LicensePage.qml")
                    },
                    {
                        title: qsTr("Report a bug or send a feature request"),
                        subTitle: qsTr("on GitHub Issues"),
                        group: qsTr("Project"),
                        onClickedRemorse: qsTr("Link will open"),
                        url: "https://github.com/ejjoman/harbour-sailwave/issues"
                    },
                    {
                        title: qsTr("Author"),
                        subTitle: "Michael Neufing <m.neufing@yahoo.de>",
                        group: qsTr("Author"),
                        onClickedRemorse: qsTr("Mail app will open"),
                        url: "mailto:m.neufing@yahoo.de?subject=SailWave"
                    },
                    {
                        title: qsTr("Twitter"),
                        subTitle: "@ejjoman",
                        group: qsTr("Author"),
                        onClickedRemorse: qsTr("Link will open"),
                        url: "https://twitter.com/ejjoman"
                    },
                    {
                        title: qsTr("Donate"),
                        subTitle: qsTr("via PayPal"),
                        group: qsTr("Author"),
                        onClickedRemorse: qsTr("Link will open"),
                        url: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3KSKM9EACDQRS"
                    },
                    {
                        //: Use your current language instead of 'English'
                        title: qsTr("English translation provided by"),

                        //: Insert the Name(s) of the translator(s) here
                        subTitle: qsTr("Michael Neufing"),
                        group: qsTr("Translation")
                    },
                    {
                        title: qsTr("Translate this app"),
                        subTitle: qsTr("on Transifex"),
                        group: qsTr("Translation"),
                        onClickedRemorse: qsTr("Link will open"),
                        url: "https://www.transifex.com/projects/p/harbour-sailwave/"
                    },
                    {
                        title: qsTr("Radio icon created by"),
                        subTitle: "Icons8",
                        group: qsTr("Other"),
                        onClickedRemorse: qsTr("Link will open"),
                        url: "http://icons8.com"
                    }
                ]

        for (var item in items) {
            model.append(items[item]);
        }
    }
}
