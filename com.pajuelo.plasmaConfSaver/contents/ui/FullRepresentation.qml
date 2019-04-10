/*
 * Copyright 2019 Alberto Pajuelo (paju1986@gmail.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: "parentItem"
    property real mediumSpacing: 1.5*units.smallSpacing
    property real textHeight: theme.defaultFont.pixelSize + theme.smallestFont.pixelSize + units.smallSpacing
    property real itemHeight: Math.max(units.iconSizes.medium, textHeight)
    property string savePath: null
    property string loadPath: null

    Layout.minimumWidth: widgetWidth + 100
    Layout.minimumHeight: (itemHeight + 2*mediumSpacing) * 10//listView.count

    Layout.maximumWidth: Layout.minimumWidth
    Layout.maximumHeight: Layout.minimumHeight

    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

  
    
    PlasmaCore.DataSource {
		id: executeSource
		engine: "executable"
		connectedSources: []
		onNewData: {
			var exitCode = data["exit code"]
			var exitStatus = data["exit status"]
			var stdout = data["stdout"]
			var stderr = data["stderr"]
			exited(sourceName, exitCode, exitStatus, stdout, stderr)
			disconnectSource(sourceName) // cmd finished
		}
		function exec(cmd) {
			if (cmd) {
				connectSource(cmd)
			}
		}
		signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
	}
	

    

    
    PlasmaCore.DataSource {
        id: placesSource
        engine: 'filebrowser'
        interval: 500
        Component.onCompleted: {
            executeSource.connectSource("pwd")
        }
    }
    

 
    Column {
        id: col1
         anchors.fill: parent
         Row {
             id: row1
             height:text1.height
             anchors.right: col1.right
             anchors.left: col1.left
           PlasmaComponents.TextField {
             id: text1
             text: ""
             width: parent.width * 0.8
             
                               
           }
           PlasmaComponents.Button {
             id: button1
             text: ""
             PlasmaCore.IconItem {
                                    anchors.fill: parent
                                    source: "document-save"
                                    active: isHovered
                            }
             width: parent.width * 0.1
             
             onClicked: {
                  //     var pwd = executeSource.data["pwd"]["stdout"]
                        
                        if(text1.text == "" || text1.text == null || text1.text == undefined) {
                            text1.text = "default"
                        }
                        var configFolder = "$(pwd)/.config/plasmaConfSaver/" + text1.text
                        
                        
                        
                        executeSource.connectSource("mkdir $(pwd)/.config/plasmaConfSaver/")
                        executeSource.connectSource("mkdir " + configFolder);
                        
                        //plasma config files
                        executeSource.connectSource("cp $(pwd)/.config/plasma-org.kde.plasma.desktop-appletsrc " + configFolder + "/plasma-org.kde.plasma.desktop-appletsrc") 
                        executeSource.connectSource("cp $(pwd)/.config/plasmarc " + configFolder + "/plasmarc")
                        executeSource.connectSource("cp $(pwd)/.config/plasmashellrc " + configFolder + "/plasmashellrcc")
                        
                        //latte-dock config files
                        executeSource.connectSource("cp $(pwd)/.config/lattedockrc " + configFolder + "/lattedockrc")
                        executeSource.connectSource("cp -r $(pwd)/.config/latte " + configFolder + "/latte")
                       
                        executeSource.connectSource("pidof latte-dock")

                        
                        
                        
                        
                      listView.forceLayout()
                      
                        
                    }
                    Connections {
                        target: executeSource
                        onExited : {
                            
                    var configFolder = "$(pwd)/.config/plasmaConfSaver/" + text1.text
                   
                            if(cmd == "pidof latte-dock") {
                                
                                    var latteDockRunning = stdout
                                    
                                    
                                            
                                //if latte-dock was running when we saved then create a flag file for running it on restore            
                                if(latteDockRunning != "") {
                                    executeSource.connectSource("touch " + configFolder + "/latterun")
                                
                                }
                                text1.text = ""
                                
                            }
                            
                            if(cmd == "pwd") {
                                
                                console.log("entra en pwd")
                                savePath = stdout.trim() + "/.config/plasmaConfSaver" ;
                                console.log(savePath)
                                placesSource.connectSource(savePath)
                                
                            }
                            
                            if(cmd.indexOf("/latterun|grep -i latterun") != -1) {
                                 var latteDockRunning = stdout
                                    console.log(cmd)
                                    console.log(stdout)
                                    //if latte-dock was running when we saved then create a flag file for running it on restore            
                                    if(latteDockRunning != "") {
                                        console.log("exe")
                                        executeSource.connectSource("killall latte-dock")
                                        executeSource.connectSource("sleep 1 && latte-dock")
                                    } else{
                                        executeSource.connectSource("killall latte-dock")
                                    }
                                    executeSource.connectSource("killall plasmashell && kstart5 plasmashell --window 5") 
                                
                            }
                            
                            
                            
                           
                            
                
                            
                
                
                
                        }
                    }
                               
                }
        }
         
         
         PlasmaExtras.ScrollArea {
       anchors.bottom: col1.bottom
       anchors.top: row1.bottom
       width: widgetWidth + 100
        
        ListView {
            id: listView
            anchors.fill: parent
            model: 
                if(placesSource.data[savePath] != undefined) {
                    return placesSource.data[savePath]["directories.all"]
                } else {
                    return ""
                }
            
            
            highlight: PlasmaComponents.Highlight {}
            highlightMoveDuration: 0
            highlightResizeDuration: 0

            delegate: Item {
                width: parent.width
                height: itemHeight + 2*mediumSpacing

                property bool isHovered: false
                property bool isEjectHovered: false

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        listView.currentIndex = index
                        isHovered = true
                    }
                    onExited: {
                        isHovered = false
                    }
                    onClicked: {
                        //expanded = false
                        text1.text = listView.currentIndex.text
                        
                    }

                    Row {
                        x: mediumSpacing
                        y: mediumSpacing
                        width: parent.width - 2*mediumSpacing
                        height: itemHeight
                        spacing: mediumSpacing
                        
//                         Item { // Hack - since setting the dimensions of PlasmaCore.IconItem won't work
//                             height: units.iconSizes.medium
//                             width: height
//                             anchors.verticalCenter: parent.verticalCenter
// 
//                             PlasmaCore.IconItem {
//                                 anchors.fill: parent
//                                 source: jsGetIcon(model.modelData)
//                                 active: isHovered
//                             }
//                         }
                            

                       
                        PlasmaComponents.Label {
                                text: model.modelData
                                width: parent.width - (btnLoad.width + mediumSpacing *2 + btnDelete.width)
                                height: theme.defaultFont.pixelSize
                                elide: Text.ElideRight
                            }
                        PlasmaComponents.Button {
                                width: 40
                                id: btnLoad
                                text: ""
                                 PlasmaCore.IconItem {
                                    anchors.fill: parent
                                    source: "checkmark"
                                    active: isHovered
                                }
                                onClicked: {
                                    executeSource.connectSource("rm -Rf $(pwd)/.config/plasma-org.kde.plasma.desktop-appletsrc")
                                    executeSource.connectSource("rm -Rf $(pwd)/.config/plasmarc")
                                    executeSource.connectSource("rm -Rf $(pwd)/.config/plasmashellrc")
                                    
                                    //plasma config files
                                    executeSource.connectSource("cp " + savePath + "/" + model.modelData + "/plasma-org.kde.plasma.desktop-appletsrc $(pwd)/.config/plasma-org.kde.plasma.desktop-appletsrc") 
                                    executeSource.connectSource("cp " + savePath + "/" + model.modelData + "/plasmarc $(pwd)/.config/plasmarc")
                                    executeSource.connectSource("cp " + savePath + "/" + model.modelData + "/plasmashellrcc $(pwd)/.config/plasmashellrc")
                                    
                                    //latte-dock config files
                                    executeSource.connectSource("rm -Rf $(pwd)/.config/lattedockrc")
                                    executeSource.connectSource("rm -Rf $(pwd)/.config/latte")
                                    executeSource.connectSource("cp "+savePath + "/" + model.modelData + "/lattedockrc $(pwd)/.config/lattedockrc ")
                                    executeSource.connectSource("cp -r "+savePath + "/" + model.modelData + "/latte $(pwd)/.config/latte")
                                    
                                    
                                     executeSource.connectSource("ls "+savePath + "/" + model.modelData + "/latterun|grep -i latterun")
                                     
                            
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                            
                                
                            }
                             PlasmaComponents.Button {
                                 width: 40
                                id: btnDelete
                                text: ""
                                PlasmaCore.IconItem {
                                    anchors.fill: parent
                                    source: "albumfolder-user-trash"
                                    active: isHovered
                                }
                                onClicked:{
                                    executeSource.connectSource("rm -Rf " + savePath + "/" + model.modelData)
                                    listView.forceLayout()
                                }
                            }
                    }
                }
            }
        }
    }
    }

   
     

}
