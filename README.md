# General information
Docker for Forge Minecraft Server, based on Debian Stretch.
## Fast start
 1. `docker run --name minecraftforge-server --volume /srv/minecraft-forge:/data --publish 25565:25565 --restart unless-stopped --detach theprojectsix/minecraftforge-server:1.12.2`
   - *this will download all server files and run server once*
 2. `docker stop minecraftforge-server`
 3. Configure as needed (manually)
 4. `docker start minecraftforge-server`

# Build/Run information
### Build Arguments
 - PUID = 1000 *- user ID that will run server*
 - PGID = 1000 *- group ID that will run server*

### Enviromental Variables
 - FORGE_VERSION = 1.12.2-14.23.5.2768 *- needed server version, according to [**MinecraftForge**](http://files.minecraftforge.net/) website.*
   - *notice: you can change this variable anytime you want, and that action will download new server. this will hurt your save files. so be aware about that.*
 - MIN_RAM = 1G *- minimal amount RAM that you want to give to server*
 - MAX_RAM = 2G *- maximal amount RAM that you want to give to server*
 - TZ = Europe/Moscow *- built-in feature in Debian - required timezone*

### Exposed Ports
 - 25565 *- standard Minecraft port*

### Mounted Volumes
 - /data *- contains every single file of your server*

# Best usage
For easiest usage of this image, I recommend you to use my manage script. It is available [**here**](https://github.com/Project-Sixth/DOCK-5A/blob/master/manage.sh), at my GitHub. After you download my script (for example, you can use command `curl -sL https://raw.githubusercontent.com/Project-Sixth/DOCK-5A/master/manage.sh > manage.sh; chmod +x manage.sh`), just follow next steps:
 1. Place script in any convinient place and make it executable (`chmod +x manage.sh`)
 2. Edit it with any editor and change mount directory to anywhere you find nessesary.
 3. Create new container by using command `manage.sh create`
 4. If you need to stop, restart or start container - easy as executing `manage.sh start|restart|stop`
 5. You also can use `manage.sh attach` to attach to RCON console. Exiting from it is `Ctrl+p Ctrl+q` keybind
