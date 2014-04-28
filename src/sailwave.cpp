#include "sailwave.h"
#include <QUrl>
#include <QStringList>
#include <QDebug>

Sailwave::Sailwave(QObject *parent) :
    QObject(parent)
{
    this->_settings = new QSettings("harbour-sailwave", "Sailwave", this);
}

bool Sailwave::validateUrl(QString url)
{
    return QUrl(url).isValid();
}

void Sailwave::saveSetting(const QString &key, const QVariant &value)
{
    this->_settings->setValue(key, value);
    this->_settings->sync();
}

QVariant Sailwave::loadSetting(const QString &key, const QVariant &defaultValue)
{
    this->_settings->sync();

    QVariant value = this->_settings->value(key, defaultValue);

    // Ugly hack. Type of value is not correct - so use type of defaultValue, assuming that this is the correct type...
    switch (defaultValue.type()) {
    case QVariant::Bool:
        return value.toBool();

    case QVariant::Double:
        return value.toDouble();

    case QVariant::Int:
        return value.toInt();

    case QVariant::String:
        return value.toString();

    case QVariant::StringList:
        return value.toStringList();

    case QVariant::List:
        return value.toList();

    default:
        return value;

    }
}
