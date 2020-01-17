#!/bin/bash

software_name=Forge-Minecraft-Server
container_name=minecraftforge
image_name=theprojectsix/minecraftforge-server:1.12.2

case $1 in
    start)
        echo "I will start $software_name"
        docker start $container_name
    ;;
    stop)
        echo "I will stop $software_name"
        docker stop $container_name
    ;;
    restart)
        echo "I will restart $software_name"
        $0 stop
        $0 start
    ;;
    logs)
        echo "There is logs to $software_name"
        docker logs $container_name
    ;;
    connect)
        echo "I will connect to $software_name's shell"
        docker exec -it $container_name sh
    ;;
    attach)
        echo "I will attach to $software_name"
        docker attach $container_name
    ;;
    create|new)
        echo "I will create new $software_name"
        docker run \
        --name $container_name \
        --volume /srv/Minecraft:/data \
        --publish 25565:25565 \
        --restart unless-stopped \
        --detach \
        $image_name
    ;;
    update)
        echo "I will update $software_name"
        $0 remove
        docker image rm $image_name
        docker pull $image_name
        $0 create
    ;;
    delete|remove)
        echo "I will delete $software_name"
        $0 stop
        docker rm $container_name
    ;;
esac