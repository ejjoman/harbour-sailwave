# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-sailwave

CONFIG += sailfishapp

SOURCES += src/harbour-sailwave.cpp

OTHER_FILES += qml/harbour-sailwave.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-sailwave.spec \
    rpm/harbour-sailwave.yaml \
    harbour-sailwave.desktop \
    qml/pages/MainPage.qml \
    qml/js/Dirble.js \
    qml/js/ajaxmee.js \
    qml/BigFM.pls \
    qml/AudioPlayer.qml \
    qml/StationsModel.qml \
    qml/pages/StationEditDialog.qml \
    qml/Station.qml

