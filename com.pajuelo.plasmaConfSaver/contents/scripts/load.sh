
configPath=$1
savePath=$2
dataPath=$3
modelData=$4

if [ -d "$savePath/$modelData/icons" ]; then
    mv "$dataPath/icons" "$dataPath/icons.bak"
    cp -r "$savePath/$modelData/icons" "$dataPath"    
fi

if [ -d "$savePath/$modelData/color-schemes" ]; then
    mv "$dataPath/color-schemes" "$dataPath/color-schemes.bak"
    cp -r "$savePath/$modelData/color-schemes" "$dataPath"    
fi

if [ -d "$savePath/$modelData/plasma" ]; then
    mv "$dataPath/plasma" "$dataPath/plasma.bak"
    cp -r "$savePath/$modelData/plasma" "$dataPath"    
fi

if [ -d "$savePath/$modelData/wallpapers" ]; then
    mv "$dataPath/wallpapers" "$dataPath/wallpapers.bak"
    cp -r "$savePath/$modelData/wallpapers" "$dataPath"    
fi

if [ -d "$savePath/$modelData/kfontinst" ]; then
    mv "$dataPath/kfontinst" "$dataPath/kfontinst.bak"
    cp -r "$savePath/$modelData/kfontinst" "$dataPath"    
fi

if [ -d "$savePath/$modelData/yakuake" ]; then
    cp -r "$savePath/$modelData/yakuake" "$dataPath"    
fi

if [ -d "$savePath/$modelData/konsole" ]; then
	mv "$dataPath/konsole/*.profile" "$dataPath/konsole/*.profile.bak"
    cp -r "$savePath/$modelData/konsole" "$dataPath"    
fi

if [ -d "$savePath/$modelData/plasma-workspace/env" ]; then
	mv "$dataPath/plasma-workspace/env" "$dataPath/plasma-workspace/env.bak"
    cp -r "$savePath/$modelData/plasma-workspace/env" "$dataPath/plasma-workspace/env"    
fi

#backups
mv "$configPath/plasma-org.kde.plasma.desktop-appletsrc" "$configPath/plasma-org.kde.plasma.desktop-appletsrc.bak"
mv "$configPath/.config/plasmarc" "$configPath/.config/plasmarc.bak"
mv "$configPath/.config/plasmashellrc" "$configPath/.config/plasmashellrc.bak"

# plasma config files
cp "$savePath/$modelData/plasma-org.kde.plasma.desktop-appletsrc" "$configPath/plasma-org.kde.plasma.desktop-appletsrc"
cp "$savePath/$modelData/plasmarc" "$configPath/plasmarc"
cp "$savePath/$modelData/plasmashellrc" "$configPath/plasmashellrc"
cp "$savePath/$modelData/kdeglobals" "$configPath/kdeglobals"
                                    
#kwin                                    
cp "$savePath/$modelData/kwinrc" "$configPath/kwinrc"
cp "$savePath/$modelData/kwinrulesrc" "$configPath/kwinrulesrc"
                                    
#latte-dock config files                                    
mv "$configPath/lattedockrc" "$configPath/lattedockrc.bak"
mv "$configPath/latte" "$configPath/latte.bak"
mv "$configPath/autostart" "$configPath/autostart.bak"
mv "$configPath/autostart-scripts" "$configPath/autostart-scripts.bak"
mv "$configPath/Kvantum" "$configPath/Kvantum.bak"
cp "$savePath/$modelData/lattedockrc" "$configPath/lattedockrc"
cp -r "$savePath/$modelData/latte" "$configPath"
cp -r "$savePath/$modelData/autostart" "$configPath"
cp -r "$savePath/$modelData/autostart-scripts" "$configPath"
cp -r "$savePath/$modelData/Kvantum" "$configPath"
#kvantum



FILE=$savePath/$modelData/latterun

#dolphin config
cp "$savePath/$modelData/dolphinrc" "$configPath/dolphinrc"
#config session desktop
cp "$savePath/$modelData/ksmserverrc" "$configPath/ksmserverrc"
#config input devices
cp "$savePath/$modelData/kcminputrc" "$configPath/kcminputrc"
#shortcuts
cp "$savePath/$modelData/kglobalshortcutsrc" "$configPath/kglobalshortcutsrc"
#klipper config
cp "$savePath/$modelData/klipperrc" "$configPath/klipperrc"
#konsole config
cp "$savePath/$modelData/konsolerc" "$configPath/konsolerc"
#kscreenlocker config
cp "$savePath/$modelData/kscreenlockerrc" "$configPath/kscreenlockerrc"
#krunner config
cp "$savePath/$modelData/krunnerrc" "$configPath/krunnerrc"
#fonts dpi config
cp "$savePath/$modelData/kcmfonts" "$configPath/kcmfonts"


sync
if [ -f "$FILE" ]; then
    killall latte-dock 
    sleep 1 && nohup latte-dock &
else 
    killall latte-dock
fi


qdbus org.kde.KWin /KWin reconfigure 
konsole -e kquitapp5 plasmashell && kstart5 plasmashell --windowclass plasmashell --window Desktop
                                     
                            
