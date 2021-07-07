FROM debian:bullseye-slim

ENV VERSION 21.05

RUN apt-get update && apt-get install -y wget gnupg2 gnupg1 && \
    wget -q -O- https://debian.koha-community.org/koha/gpg.asc | apt-key add - && \
    echo "deb http://debian.koha-community.org/koha ${VERSION} main" | tee /etc/apt/sources.list.d/koha.list && \
    apt-get update && \
    apt-get install koha-common -y && \
    apt-get clean

RUN a2enmod cgi && a2enmod rewrite && \
    mkdir -p /usr/koha && \
    echo "library:root:root:library:mysql" > /etc/koha/passwd && \
    echo "Create instance" && \
    koha-create --use-db library && \
    echo "Create db" && \
    koha-create --populate-db library && \
    echo "Disable site 000-default" && \
    a2dissite 000-default

# koha-create --request-db mylibrary 
# koha-create --populate-db mylibrary

CMD ["apachectl", "-D", "FOREGROUND", "-k", "start"]
