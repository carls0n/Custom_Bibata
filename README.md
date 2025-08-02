

### Custom Bibata Cursor</h4>

Custom Bibata Cursor lets you to create your own Bibata Cursor Theme by specifying
any name and any color. There are also some predefined themes. See `./build.sh
--help` for details.

I found this script in non working condition at https://github.com/pascal-huber/Bibata_RGB_Cursor.
I changed a few things in order to get the script working, namely the commands for inkscape have
since changed. Those were fixed.


I also added the rounded, more modern Bibata cursor as default, along with the ability to choose
which cursor you want to use via the -s (--style) option using -s classic (modern is default)

I added options for -b $RGB to change the color of the cursor
border. Use -b none for no border.<br>

### Usage Example

In this example we will create an orange_cream cursor theme.

1. Build
   ```shell
   git clone https://github.com/carls0n/Custom_Bibata.git
   cd Custom_Bibata
   ./build.sh -n Orange_Cream -c "#ff8c00"
   ```

2. Install for current user. Settings may be different for your desktop environment, window manager.
   ```shell
   mkdir  ~/.icons/
   cp -r Orange_Cream ~/.icons/
   ```

3. Use your distro's tool to change cursors. i.e, Menu -> Applications -> Settings -> Mouse And Touchpaad<br><br>
#

Custom Bibata Cursor is based on [Bibata
Cursor](https://github.com/KaizIqbal/Bibata_Cursor/blob/master/README.md). All
credit goes to the author @KaizIqbal.
 
