# DDC KBrightness
A KDE Plasmoid to adjust your external monitor brightness using a slider in KDE tray area.  Consider this a beta quality plasmoid.  It works fine for me so far but has not been tested on other setups.  Let me know if you run into issues.


# Requirements
* KDE Plasma 5
* `ddcutil` installed.
* Enable [i2c permissions](https://lexruee.ch/setting-i2c-permissions-for-non-root-users.html). *NOTE: the last instruction says to use `su` for root access. In Ubuntu this doesn't work, try `sudo -s` instead.*
* Monitor/PC must support [DDC](https://en.wikipedia.org/wiki/Display_Data_Channel). Run `ddcutil detect` to check.

# Installation
1. First make sure you have the Requirements set up, as per above
2. Download and extract the zip, or `git clone` to local drive
3. Go into the project directory (the one containing the `README` and `ddckbrightness` directory)
4. Install by running `kpackagetool5 -t Plasma/Applet -i ddckbrightness` (change `-i` to `-u` to update a previous install)
5. You may need to restart KDE (log out and in again) in order to refresh the Plasmoid cache
6. Right click on your panel and add the DDC KBrightness widget.
7. Follow the **Configuration** steps listed below. **WARNING** In some rare cases, if you move the slider without the correct configuration, you can mess up your monitor hardware settings and require resetting them via the OSD!
7. Try adjusting the slider.

# Configuration
1. Verify [i2c permissions](https://lexruee.ch/setting-i2c-permissions-for-non-root-users.html) are setup and `ddcutil` is installed.
2. Run `ddcutil detect` and find out your monitors **Display Number**.
3. Run `ddcutil -d {YOUR-DISPLAY-NUMBER} capabilities | grep Brightness` to find out the **Feature Code**
4. Right click on the DDC KBrightness widget and go to Configure.
5. Enter your **Display Number** and **Feature Code** under Display Settings and click OK
6. Try the slider again

# TODO
Suggestions/PRs welcome.
* ~~Fix apply settings without having to restart app~~
* ~~Fix using Display number and Feature code instead of hard-coded values (currently display 1 and feature 10)~~
* Add auto detection of monitor and features
* Create installer/package
* Add support more than one monitor
* Add support for other monitor settings like contrast and input port
