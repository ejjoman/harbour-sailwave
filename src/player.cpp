#include "player.h"
#include <QUrl>
#include <QDebug>

Player::Player(QObject *parent) :
    QObject(parent)
{
    //this->timer = new QTimer(this);

    //this->timer->setInterval(10000);
    //this->timer->setSingleShot(false);

    this->player = new QMediaPlayer(this);
    connect(this->player, SIGNAL(metaDataChanged(QString,QVariant)), this, SLOT(metaDataChanged(QString,QVariant)));

    //connect(this->timer, SIGNAL(timeout()), this, SLOT(timerTimeout()));
}

void Player::runTest()
{
    this->player->setMedia(QMediaContent(QUrl("http://sites.89.0rtl.de/streams/mp3_128k.pls"))); //"http://sites.89.0rtl.de/streams/mp3_128k.pls")));
    this->player->play();
    //this->timer->start();
}

void Player::metaDataChanged(QString key, QVariant value)
{
    qDebug() << "Metdadata changed:" << key + ":" << value.toString();
}
