#!/bin/bash

software_name=Forge-Minecraft-Server
container_name=minecraft-forge-server
image_name=theprojectsix/minecraftforge-server:1.12.2-stable
restart_type=always

main_mountpoint=/srv/minecraft-forge-1.12.2
main_port=25565

min_ram=1G
max_ram=2G
tz=Europe/Moscow

case $1 in
    create|new)
        echo "I will create new container from ${software_name}'s image."
        docker run \
        --name $container_name \
        --env MIN_RAM=${min_ram} \
        --env MAX_RAM=${max_ram} \
        --env TZ=${tz} \
        --publish ${main_port}:25565 \
        --volume ${main_mountpoint}:/data \
        --restart ${restart_type} \
        --interactive \
        --tty \
        --detach \
        $image_name
    ;;
    recreate|renew)
        echo "I will recreate new container from ${software_name}'s image."
        $0 update
        $0 new
    ;;
    start)
        echo "I will start ${software_name}'s container."
        docker start $container_name
    ;;
    logs)
        echo "====== Logs to ${software_name}'s container ======"
        docker logs $container_name
    ;;
    restart)
        echo "I will restart ${software_name}'s container."
        $0 stop
        $0 start
    ;;
    stop)
        echo "I will stop ${software_name}'s container."
        docker stop $container_name
    ;;
    shell)
        echo "I will connect to ${software_name}'s container shell."
        docker exec -it $container_name sh
    ;;
    attach)
        echo "I will attach to ${software_name}'s stdin/stdout/stderr."
        docker attach $container_name
    ;;
    delete|remove)
        echo "I will delete ${software_name}'s container."
        $0 stop
        docker rm $container_name
    ;;
    pull)
        echo "I will pull new image of ${software_name}."
        docker pull $image_name
    ;;
    update|upgrade)
        echo "I will update image of ${software_name}."
        $0 purge
        $0 pull
    ;;
    purge)
        echo "I will delete the image of ${software_name}."
        $0 delete
        docker image rm $image_name
    ;;
esac