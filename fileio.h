#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>

class FileIO : public QObject
{
    Q_OBJECT

public slots:
    bool write(const QString& source_url, const QString& data);
    QString read(const QString& source_url);

public:
    FileIO() {}
};

#endif // FILEIO_H
