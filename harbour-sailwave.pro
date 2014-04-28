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
QT += multimedia

SOURCES += src/harbour-sailwave.cpp \
    src/sailwave.cpp

OTHER_FILES += qml/harbour-sailwave.qml \
    qml/pages/MainPage.qml \
    qml/pages/StationEditDialog.qml \
    qml/pages/SleepTimerDialog.qml \
    qml/pages/CheckStationPage.qml \
    qml/cover/CoverPage.qml \
    qml/common/AudioPlayer.qml \
    qml/common/StationsModel.qml \
    qml/common/Station.qml \
    qml/common/StationDelegate.qml \
    qml/common/SleepTimer.qml \
    qml/common/PulseAnimation.qml \
    qml/images/radio.png \
    rpm/harbour-sailwave.spec \
    rpm/harbour-sailwave.yaml \
    harbour-sailwave.desktop \
    translations/*.ts \
    qml/common/Banner.qml \
    qml/common/Settings.qml \
    qml/pages/SettingsDialog.qml \
    qml/pages/AboutPage.qml \
    qml/common/AboutItem.qml \
    qml/pages/LicensePage.qml \
    qml/images/GPLv3.png \
    qml/js/DurationFormatter.js \
    qml/common/InfoPopup.qml

CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-sailwave-de.ts

HEADERS += \
    src/sailwave.h
