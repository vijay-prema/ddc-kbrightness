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
//    property Item seekbar
    property bool dimmed : false

	readonly property int brightnessMax: plasmoid.configuration.limitBrightnessMax
	readonly property int brightnessMin: plasmoid.configuration.limitBrightnessMin
	readonly property string featureCode: plasmoid.configuration.featureCode
	readonly property int displayNumber: plasmoid.configuration.displayNumber
	readonly property int iconWidth: plasmoid.configuration.iconWidth

    Plasmoid.icon: {
        source: {
            if(iconWidth != 0)
                plasmoid.Layout.maximumWidth = iconWidth;
            return "display-brightness-symbolic";
        }
    }

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.fullRepresentation: Item {
        id: popup
        width: 30
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
//                value: 0
                stepSize: 10
                minimumValue: 0
                maximumValue: 100
                wheelEnabled: false
                onPressedChanged:
                {
                    if(!pressed) {
                        cmd.exec( "ddcutil -d " + displayNumber + " setvcp " + featureCode + " " + Math.round((bControl.value/100)*(brightnessMax-brightnessMin)+brightnessMin) );
                    }
                }

            }
        }

        Component.onCompleted: {
//            if(seekbar == null) seekbar = bControl;
            cmd.exec("ddcutil -d " + displayNumber + "getvcp " + featureCode + " | grep -Po '(current value =)\\s*\\K.*(?=,)'");
        }

    }


    MessageDialog {
        id: errorDialog
        title: "Component is missing"
        text: "Components xrandr and qdbus are required. Please install the missing one in your package manager."
        icon: StandardIcon.Critical
        onAccepted: {
            console.log("onAccepted");
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

    Plasmoid.toolTipSubText: {"Adjust monitor brightness."}

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

    Connections {
        target: cmd
        onExited: {
            if(exitCode == 0 && exitStatus == 0) {
                var tryInt = parseInt(stdout);
                if(stdout != null && stdout.length < 4 && tryInt != NaN ) {
                    bControl.value = tryInt;
                }
            }
        }
    }


}
