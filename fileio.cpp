#include "fileio.h"
#include <QFile>
#include <QUrl>
#include <QTextStream>

bool FileIO::write(const QString& source_url, const QString& data) {
    QUrl url(source_url);
    QString source = url.toLocalFile();
    if (source.isEmpty())
        return false;
    QFile file(source);
    if (!file.open(QFile::WriteOnly))
        return false;
    QTextStream out(&file);
    out << data;
    file.close();
    return true;
}

QString FileIO::read(const QString& source_url) {
    if(source_url.isEmpty()) {
        return "";
    }

    QUrl url(source_url);
    QString source = url.toLocalFile();

    QFile file(source);
    if(!file.exists()) {
        return "";
    }

    QString text;
    if(file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        text = stream.readAll();
    }

    return text;
}

