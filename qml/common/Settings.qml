import QtQuick 2.0
import harbour.sailwave 1.0

QtObject {
    id: root

    property bool showDetailedErrorMessage: false
    property bool validateStreamUrl: true

    function _getSettings() {
        var settings = [];

        for (var prop in root) {
            if (prop.substring(0, 2) === "on" || prop.indexOf('Changed') >= 0)
                continue;

            if (prop === "objectName")
                continue;

            if (typeof root[prop] === 'function')
                continue;

            settings[prop] = root[prop];
        }

        return settings
    }

    function loadSettings() {
        console.log("[Settings]", "Load settings")

        var settings = _getSettings();

        for (var setting in settings) {
            root[setting] = Sailwave.loadSetting("settings/" + setting, settings[setting]);
            console.log("[Settings]", "[Loaded]", "Key: '" + setting + "'", "Value: '" + root[setting] + "'", "Default: '" + settings[setting] + "'")
        }
    }

    function saveSettings() {
        console.log("[Settings]", "Save settings")

        var settings = _getSettings();

        for (var setting in settings) {
            Sailwave.saveSetting("settings/" + setting, settings[setting]);
            console.log("[Settings]", "[Saved]", "Key: '" + setting + "'", "Value: '" + settings[setting] + "'")
        }
    }

    Component.onCompleted: loadSettings()
}
