#ifndef HELPER_H
#define HELPER_H

#include <QObject>
#include <QSettings>

class Sailwave : public QObject
{
    Q_OBJECT

public:
    explicit Sailwave(QObject *parent = 0);
    Q_INVOKABLE bool validateUrl(QString url);

private:
    QSettings *_settings;

signals:

public slots:
    Q_INVOKABLE void saveSetting(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant loadSetting(const QString &key, const QVariant &defaultValue = QVariant());

};

#endif // HELPER_H
