import QtQuick 2.0
import QtQuick.LocalStorage 2.0

ListModel {
    id: root

    function __db() {
        var db = LocalStorage.openDatabaseSync("sailwave", "", "SailWave database", 1000000, function(db) {
            db.transaction(function(tx) {
                var createTable =
                    'CREATE TABLE "MyStations" ( \
                        "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL DEFAULT (0), \
                        "name" TEXT NOT NULL, \
                        "stream" TEXT NOT NULL \
                    );'

                tx.executeSql(createTable);
            })
        });

        return db;
    }

    function load(update) {
        console.log("loading model")

        __db().transaction(function(tx) {
            if (!update)
                root.clear();

            var results = tx.executeSql("SELECT * FROM MyStations ORDER BY name")

            for (var i=0; i<results.rows.length; i++) {
                var row = results.rows.item(i)

                var component = Qt.createComponent("Station.qml") //new Station()

                if (component.status === Component.Ready) {
                    var stationId = row.id;

                    var updated = false;

                    if (update) {
                        var index = root.indexOf(stationId);

                        if (index > -1) {
                            var station = root.get(root.indexOf(stationId));
                            station.name = row.name;
                            station.streamUrl = row.stream;

                            updated = true;
                        }
                    }

                    if (!updated) {
                        var s = component.createObject(null, {
                                                           stationId: row.id,
                                                           name: row.name,
                                                           streamUrl: row.stream
                                                       })
                        if (update)
                            root.insert(i, s)
                        else
                            root.append(s);
                    }


                }
            }
        })

        console.log("model loaded:", root.count)
    }

    function _isStation(station) {
        return station.hasOwnProperty("__station")
    }

    function _add(station) {
        if (!_isStation(station) || station.stationId >= 0)
            return

        console.log("add station", station)

        __db().transaction(function(tx) {
            var insert = 'INSERT INTO MyStations (name, stream) VALUES (?, ?)'
            tx.executeSql(insert, [station.name, station.streamUrl])
        })

        console.log("station added", station)

        root.load(true);
    }

    function _update(station) {
        if (!_isStation(station) || station.stationId < 0)
            return

        console.log("update station", station)

        __db().transaction(function(tx) {
            var update = 'UPDATE MyStations SET name=?, stream=? WHERE id=?'
            tx.executeSql(update, [station.name, station.streamUrl, station.stationId])

            console.log("station updated", station)

            root.load(true);
        })
    }

    function addOrUpdateWithStation(station) {
        console.log("addOrUpdate", station)

        if (!_isStation(station))
            return

        if (station.stationId < 0)
            root._add(station)
        else
            root._update(station)

    }

    function removeStation(station) {
        if (!_isStation(station)) {
            station = root.getById(station)
        }

        if (!station)
            return

        if (station.stationId < 0)
            return;

        if (player.currentStation > -1 && player.currentStation === station.stationId)
            player.stop()

        __db().transaction(function(tx) {
            var del = 'DELETE FROM MyStations WHERE id=?'
            tx.executeSql(del, [station.stationId])

            root.remove(root.indexOf(station.stationId))
        })
    }

    function indexOf(id) {
        for(var i=0; i < root.count; i++) {
            var item = root.get(i)

            if (item.stationId === id)
                return i
        }

        return -1;
    }

    function getById(id) {
        var index = root.indexOf(id);

        if (index > -1)
            return root.get(index);

        return null;
    }

    function getStationById(id) {
        var item = getById(id)

        if (!item)
            return null;

        var component = Qt.createComponent("Station.qml") //new Station()

        if (component.status == Component.Ready) {
            var s = component.createObject(null, {
                                               stationId: item.stationId,
                                               name: item.name,
                                               streamUrl: item.streamUrl
                                           })

            return s;
        }
    }

    Component.onCompleted: root.load(false)
}
