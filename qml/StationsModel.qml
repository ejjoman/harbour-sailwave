import QtQuick 2.0

ListModel {
    id: root

    ListElement {
        stationId: 1
        name: "BigFM"
        url: "http://217.151.152.245:80/bigfm-mp3-64"
    }

    ListElement {
        stationId: 2
        name: "RPR1"
        url: "http://rpr1.fmstreams.de/stream1"
    }

    function getById(id) {
        for(var i=0; i < root.count; i++)
            if (id == root.get(i).stationId)
                return root.get(i)

        return null;
    }
}
