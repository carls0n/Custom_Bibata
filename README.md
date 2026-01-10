

### Custom Bibata Cursor</h4>

Custom Bibata Cursor lets you to create your own Bibata Cursor Theme by specifying
any name and any color. There are also some predefined themes. See `./build.sh
--help` for details.

I found this script in non working condition at https://github.com/pascal-huber/Bibata_RGB_Cursor<br>
I changed a few things in order to get the script working, namely the commands for inkscape have
since changed. Those were fixed.


I also added the rounded, more modern Bibata cursor as default, along with the ability to choose
which cursor you want to use via the -s (--style) option using -s classic (modern is default)

I added options for -b $RGB to change the color of the cursor border. For example -b #000000. Use -b none for no border.<br>

### Usage Example</h4>

In this example we will create a BlackMagic cursor theme to match my BlackMagic theme for xfce. https://github.com/carls0n/BlackMagic

### Build your custom Bibata cursors</h4>

```shell
   git clone https://github.com/carls0n/Custom_Bibata.git
   cd Custom_Bibatahttps://github.com/KaizIqbal/Bibata_Cursor/blob/master/README.md
   chmod 755 build.sh
   ./build.sh -n "BlackMagic" -c "#161616" -b "#d3d3d3"
```


### Install your custom cursor theme</h4>
```shell
   mkdir  ~/.icons/
   cp -r BlackMagic ~/.icons/
```

   ###  Activate your custom Bibata cursor theme</h4>
   Example: Menu -> Applications -> Settings -> Mouse and Touchpad -> Theme -> BlackMagic
   
   You can also set the cursor theme and cursor size from the command line once it's moved into ~/.icons
   ```shell
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "BlackMagic"
```
```shell
xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s "36"
```
   ***
Custom Bibata Cursor is based on 
[Bibata Cursor](https://github.com/KaizIqbal/Bibata_Cursor/blob/master/README.md) All
credit goes to the author @KaizIqbal.<br><br>
![BlackMagic screenshot](https://github.com/carls0n/Custom_Bibata/blob/main/ssnew.png)
