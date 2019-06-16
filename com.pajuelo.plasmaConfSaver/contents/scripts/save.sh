configPath=$1
configFolder=$2
dataPath=$3


mkdir $configPath/plasmaConfSaver/
mkdir $configFolder

# screenshot
spectacle -b -n -o $configFolder/screenshot.png

# plasma config files
cp $configPath/plasma-org.kde.plasma.desktop-appletsrc $configFolder/plasma-org.kde.plasma.desktop-appletsrc 
cp $configPath/plasmarc $configFolder/plasmarc
cp $configPath/plasmashellrc $configFolder/plasmashellrc
cp $configPath/kdeglobals $configFolder/kdeglobals

#kwin
cp $configPath/kwinrc $configFolder/kwinrc
cp $configPath/kwinrulesrc $configFolder/kwinrulesrc

#latte-dock config files
cp $configPath/lattedockrc $configFolder/lattedockrc
cp -r $configPath/latte $configFolder/latte

#plasma themes and widgets
cp -r $dataPath/plasma $configFolder/plasma

#wallpapers
cp -r $dataPath/wallpapers $configFolder/wallpapers

#autostart
cp -r $dataPath/autostart $configFolder/autostart

#icons
cp -r $dataPath/icons $configFolder/icons

#color-schemes
cp -r $dataPath/color-schemes $configFolder/color-schemes

#if latte-dock was running when we saved then create a flag file for running it on restore
if pgrep -x latte-dock > /dev/null
then
    touch $configFolder/latterun
fi