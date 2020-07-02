//contact: vjprema@gmail.com
//GPLv3
import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.6 as Controls1
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: main
    property var brigthnessMax : 0
    property Item seekbar
    property bool dimmed : false
    property var lastReal: -1

    Plasmoid.icon: {
        source: {
            if(plasmoid.configuration.iconWidth != 0) plasmoid.Layout.maximumWidth = plasmoid.configuration.iconWidth;
            return "display-brightness-symbolic"
        }
    }

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.fullRepresentation: Item {
        id: popup
        width: 50
//        height: (Screen.desktopAvailableHeight/4)
        height: 300
        GroupBox {
            anchors.fill: parent
            background: Rectangle {
                    y: bControl.topPadding - bControl.padding
                    width: parent.width
                    height: parent.height - bControl.topPadding + bControl.padding
                    color: "transparent"
                    radius: 2
                }
            Controls1.Slider {
                id: bControl
                anchors.centerIn: parent
                height: parent.height;
                orientation: Qt.Vertical
                value: { cmd.exec("ddcutil getvcp 10 | grep -Po '(current value =)\\s*\\K.*(?=,)'"); }
                stepSize: 10
                minimumValue: 0
                maximumValue: 100
                wheelEnabled: false
                onPressedChanged:
                {
                    if(!pressed) {
                        cmd.exec( "ddcutil setvcp 10 " + Math.round((bControl.value/100)*(plasmoid.configuration.limitBrightnessMax-plasmoid.configuration.limitBrightnessMin)+plasmoid.configuration.limitBrightnessMin) );
                    }
                }

            }
        }
        Component.onCompleted: {
            if(seekbar == null) seekbar = bControl;
        }
    }

    Connections {
        target: cmd
        onExited: {
            if(exitCode == 0 && exitStatus == 0){
                if(stdout != null && stdout.length > 5){
                    if(stdout.substring(0, 6) === "Screen"){
                        var array = stdout.split('\n');
                        if(array.length > 1){
                            var out = array[1].substring(0,  (array[1].indexOf("connected") -1));
                            if(out.length > 0){
                                plasmoid.configuration.output = out;
                            }
                        }
                    }
                }

            }
            if(stderr.indexOf("not found") > -1){
                if( exitCode == 1 && exitStatus == 0){
                    //warning: output ... not found; ignoring
                    //xrandr: Need crtc to set gamma on.
                }
                if( exitCode == 127 && exitStatus == 0) errorDialog.visible = true;
            }
        }
    }

    MessageDialog {
        id: errorDialog
        title: "Component is missing"
        text: "Components xrandr and qdbus are required. Please install the missing one in your package manager."
        icon: StandardIcon.Critical
        onAccepted: {
            console.log("onAccepted")
        }
    }

    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        source: Plasmoid.icon
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: {
                if (mouse.button === Qt.LeftButton) {
                    if (plasmoid.expanded) {
                        plasmoid.expanded = false;
                    } else {
                        plasmoid.expanded = true;
                    }
                }
            }
        }
    }


    PlasmaCore.DataSource {
        id: cmd
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmdstr) {
            connectSource(cmdstr)
        }
        signal exited(int exitCode, int exitStatus, string stdout, string stderr)
    }

    Plasmoid.toolTipSubText: {"Adjust monitor brightness."}

}
