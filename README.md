## WARNING
This widget is for KDE Plasma 5 and is in pre-alpha stage.  Many things are known to be broken.  Use at your own risk.

# DDC KBrightness
Adjust your external monitor brightness using a slider in KDE tray area.

# Requirements
* KDE Plasma 5
* `ddcutil` installed.
* Enable [i2c permissions](https://lexruee.ch/setting-i2c-permissions-for-non-root-users.html). *NOTE: the last instruction says to use `su` for root access. In Ubuntu this doesn't work, try `sudo -s` instead.*
* Monitor/PC must support [DDC](https://en.wikipedia.org/wiki/Display_Data_Channel). Run `ddcutil detect` to check.

# Installation
1. First make sure you have the Requirements set up, as per above
2. Download and extract the zip, or `git clone` to local drive
3. Go into the project directory (containing ddckbrightness directory)
4. Run `kpackagetool5 -t Plasma/Applet -i ddckbrightness` (change `-i` to `-u` to update a previous install)
5. You may need to restart KDE (log out and in again)

# TODO
Suggestions/PRs welcome.
* ~~Fix apply settings without having to restart app~~
* ~~Fix using Display number and Feature code instead of hard-coded values (currently display 1 and feature 10)~~
* Add auto detection of monitor and feature
* Create installer/package
