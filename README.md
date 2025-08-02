

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

### Build your custom Bibata cursors</h4>
   git clone https://github.com/carls0n/Custom_Bibata.git<br>
   cd Custom_Bibata<br>
   ./build.sh -n Orange_Cream -c "#ff8c00"


### Install your custom cursor theme</h4>
   mkdir  ~/.icons/<br>
   cp -r Orange_Cream ~/.icons/

   ###  Activate your custom Bibata cursor theme
   Example: Menu -> Applications -> Settings -> Mouse and Touchpad -> Theme -> Orange_Cream
   
---

Custom Bibata Cursor is based on [Bibata
Cursor](https://github.com/KaizIqbal/Bibata_Cursor/blob/master/README.md). All
credit goes to the author @KaizIqbal.
 
