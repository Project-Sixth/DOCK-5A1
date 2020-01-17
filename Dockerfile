FROM debian:stretch

ARG PUID=1000
ARG PGID=1000

ENV FORGE_VERSION=1.12.2-14.23.5.2768 \
    MINECRAFT_VERSION=1.12.2 \
    MIN_RAM=1G \
    MAX_RAM=2G \
    TZ=Europe/Moscow

RUN apt update; \
    apt upgrade -y; \
    apt install -y curl openjdk-8-jre-headless; \
    mkdir /app /data; \
    groupadd -g $PGID minecraft; \
    useradd -M -u $PUID -g minecraft minecraft

RUN echo '#!/bin/bash' > /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '# update system completely.' >> /docker-entrypoint.sh; \
    echo 'apt update' >> /docker-entrypoint.sh; \
    echo 'apt upgrade -y' >> /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '#if /data/server do not exist, download it.' >> /docker-entrypoint.sh; \
    echo 'if [ ! -e /data/forge-${FORGE_VERSION}-universal.jar ]' >> /docker-entrypoint.sh; \
    echo 'then' >> /docker-entrypoint.sh; \
    echo '    echo "Forge server with version ${FORGE_VERSION} not found in /data! Installing now..."' >> /docker-entrypoint.sh; \
    echo '    curl -sL "https://files.minecraftforge.net/maven/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar" > /app/forgeinstaller' >> /docker-entrypoint.sh; \
    echo '    cd /data' >> /docker-entrypoint.sh; \
    echo '    java -jar /app/forgeinstaller --installServer' >> /docker-entrypoint.sh; \
    echo '    rm /app/forgeinstaller' >> /docker-entrypoint.sh; \
    echo '    echo "Forge server version ${FORGE_VERSION} installed."' >> /docker-entrypoint.sh; \
    echo 'fi' >> /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '# if /data/eula.txt do not exist, create it.' >> /docker-entrypoint.sh; \
    echo 'if [ ! -e /data/eula.txt ]' >> /docker-entrypoint.sh; \
    echo 'then' >> /docker-entrypoint.sh; \
    echo '    echo "Agreeing with EULA automatically :D"' >> /docker-entrypoint.sh; \
    echo '    echo eula=true > /data/eula.txt' >> /docker-entrypoint.sh; \
    echo 'fi' >> /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '# fix permissions' >> /docker-entrypoint.sh; \
    echo 'chown -R minecraft:minecraft /app /data' >> /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '#run server.' >> /docker-entrypoint.sh; \
    echo 'cd /data' >> /docker-entrypoint.sh; \
    echo 'runuser -p -u minecraft -c "java -Xms${MIN_RAM} -Xmx${MAX_RAM} -jar /data/forge-${FORGE_VERSION}-universal.jar nogui"' >> /docker-entrypoint.sh; \
    chmod +x /docker-entrypoint.sh

VOLUME /data
EXPOSE 25565

CMD /docker-entrypoint.sh