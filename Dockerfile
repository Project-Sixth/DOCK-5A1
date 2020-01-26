FROM debian:9

ARG PUID=1000
ARG PGID=1000
ARG MINECRAFT_VERSION=1.12.2
ARG FORGE_VERSION=14.23.5.2768

ENV MIN_RAM=1G \
    MAX_RAM=2G \
    TZ=Europe/Moscow

RUN apt update; \
    apt upgrade -y; \
    apt install -y curl openjdk-8-jre-headless; \
    curl -sL https://github.com/songdongsheng/su-exec/releases/download/1.3/su-exec-musl-static > /bin/su-exec && chmod +x /bin/su-exec; \
    mkdir /app /data /default; \
    groupadd -g $PGID minecraft; \
    useradd -M -u $PUID -g minecraft minecraft; \
    curl -sL "https://files.minecraftforge.net/maven/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar" > /app/forgeinstaller; \
    cd /default; \
    java -jar /app/forgeinstaller --installServer; \
    rm /app/forgeinstaller; \
    mv /default/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-universal.jar /default/forge-server.jar

RUN { \
        echo '#!/bin/bash'; \
        echo ''; \
        echo '#if server do not exist, copy whole defaults folder to data.'; \
        echo 'if [ ! -e /data/forge-server.jar ]'; \
        echo 'then'; \
        echo '    echo "Forge server version '${FORGE_VERSION}' for minecraft version '${MINECRAFT_VERSION}' not found in /data! Installing now..."'; \
        echo '    cp -r /default/* /data'; \
        echo '    echo "Forge server version '${FORGE_VERSION}' for minecraft version '${MINECRAFT_VERSION}' installed."'; \
        echo 'fi'; \
        echo ''; \
        echo '# fix eula automatically.'; \
        echo 'echo eula=true > /data/eula.txt'; \
        echo ''; \
        echo '# fix permissions.'; \
        echo 'chown -R minecraft:minecraft /data'; \
        echo ''; \
        echo '# run server.'; \
        echo 'cd /data'; \
        echo 'exec su-exec minecraft java -Xms${MIN_RAM} -Xmx${MAX_RAM} -jar /data/forge-server.jar nogui'; \
    } > /docker-entrypoint.sh; \
    chmod +x /docker-entrypoint.sh

VOLUME /data
EXPOSE 25565

CMD ["/docker-entrypoint.sh"]