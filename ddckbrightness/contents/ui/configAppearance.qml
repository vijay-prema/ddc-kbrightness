//contact: piotr4@gmail.com
//GPLv3
import QtQuick 2.5
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2

Item {
    id: settings
    signal configurationChanged

    function saveConfig() {
        plasmoid.configuration.limitBrightnessMax = limitBrightnessMax.value
        plasmoid.configuration.limitBrightnessMin = limitBrightnessMin.value
        plasmoid.configuration.limitDimness = limitDimness.value
        plasmoid.configuration.iconWidth = iconWidth.value;
        plasmoid.configuration.displayNumber = displayNumber.value;
        plasmoid.configuration.featureCode = featureCode.value;
    }

    ColumnLayout {

        id: layout
        spacing: 20
        x: 5

        GroupBox {
            title:  "Safe limits"
            font.underline: true
            Layout.fillWidth: true

            ColumnLayout {

                RowLayout {    //limitBrightnessMax

                    spacing: 20
                    Label {
                        text: "Limit maximal brightness:"
                    }

                    Item {
                         Layout.fillWidth: true
                    }

                    Controls1.SpinBox {
                        id: limitBrightnessMax
                        value: plasmoid.configuration.limitBrightnessMax
                        minimumValue: 2
                        maximumValue: 9999
                        stepSize: 1
                        implicitWidth: 80
                    }
                }

                RowLayout {  //limitBrightnessMin


                    spacing: 20
                    Label {
                        text: "Limit minimal brightness (when slider is at 0 position):"
                    }

                    Item {
                         Layout.fillWidth: true
                    }

                    Controls1.SpinBox {
                        id: limitBrightnessMin
                        value: plasmoid.configuration.limitBrightnessMin
                        minimumValue: 1
                        maximumValue: 9998
                        stepSize: 1
                        implicitWidth: 80
                    }
                }
            }
        }

        GroupBox {
            title:  "Appearance"
            font.underline: true
            Layout.fillWidth: true

            ColumnLayout {

                RowLayout {  //iconWidth

                    spacing: 20

                    Label {
                        text: "Icon Width (enter 0 for auto-width):"
                    }

                    Item {
                         Layout.fillWidth: true
                    }

                    Controls1.SpinBox {
                        id: iconWidth
                        value: 0
                        minimumValue: 0
                        maximumValue: 128
                        stepSize: 1
                        implicitWidth: 80
                    }
                }

            }
        }

        GroupBox {
            title:  "Display Settings"
            font.underline: true
            Layout.fillWidth: true

            ColumnLayout {
                RowLayout {  //displayNumber

                    spacing: 20

                    Label {
                        text: "Display number (run 'ddcutil detect' to find it)"
                    }

                    Item {
                         Layout.fillWidth: true
                    }

                    Controls1.SpinBox {
                        id: displayNumber
                        value: 1
                        minimumValue: 1
                        maximumValue: 32
                        stepSize: 1
                        implicitWidth: 80
                    }
                }

                RowLayout {  //featureCode

                    spacing: 20

                    Label {
                        text: "Feature Code (run 'ddcutil -d {DisplayNumber} capabilities' and look for 'Brightness')"
                    }

                    Item {
                         Layout.fillWidth: true
                    }

                    Controls1.TextField {
                        id: featureCode
                        text: "10"
                        maximumLength: 2
                        implicitWidth: 80
                    }
                }

            }
        }

    }
}
