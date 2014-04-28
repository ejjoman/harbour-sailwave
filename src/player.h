#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <QtMultimedia>

class Player : public QObject
{
    Q_OBJECT
public:
    explicit Player(QObject *parent = 0);
    void runTest();

signals:

public slots:
    void metaDataChanged(QString, QVariant);
    //void timerTimeout();

private:
    QMediaPlayer *player;
    //QTimer *timer;

};

#endif // PLAYER_H
