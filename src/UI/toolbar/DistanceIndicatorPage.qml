import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools

// ToolIndicatorPage {
//     showExpand: true   // allow expansion (like GPS)

//     property var    _activeVehicle:      QGroundControl.multiVehicleManager.activeVehicle
//     property string na:      qsTr("N/A", "No data to display")
//     property string valueNA: qsTr("--.--", "No data to display")

//     contentComponent: Component {
//         ColumnLayout {
//             spacing: ScreenTools.defaultFontPixelHeight / 2

//             SettingsGroupLayout {
//                 heading: qsTr(" Dist Sensor Status")

//                 LabelledLabel {
//                     label:      qsTr("Forward")
//                     labelText:  activeVehicle
//                                 ? _activeVehicle.distanceSensors.getFact("rotationNone").value.toFixed(2) + " m (Forward)"
//                                 : "--"
//                 }
//                 LabelledLabel {
//                     label:      qsTr("Backward")
//                     labelText:  _activeVehicle
//                                 ? _activeVehicle.distanceSensors.getFact("rotationYaw180").value.toFixed(2) + " m (Rear)"
//                                 : "--"
//                 }
//                 LabelledLabel {
//                     label:      qsTr("Terrain")
//                     labelText:  _activeVehicle
//                                 ? _activeVehicle.distanceSensors.getFact("rotationPitch270").value.toFixed(2) + " m (Down)"
//                                 : "--"          // placeholder
//                 }


//             }
//         }
//     }
ToolIndicatorPage {
    showExpand: true

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    contentComponent: Component {
        ColumnLayout {
            spacing: ScreenTools.defaultFontPixelHeight / 4

            SettingsGroupLayout {
                heading: qsTr("Distance Sensor Debug - All Orientations")

                Repeater {
                    model: [
                        { key: "rotationNone",     label: "Forward (0°)" },
                        { key: "rotationYaw45",    label: "Forward/Right (45°)" },
                        { key: "rotationYaw90",    label: "Right (90°)" },
                        { key: "rotationYaw135",   label: "Rear/Right (135°)" },
                        { key: "rotationYaw180",   label: "Rear (180°)" },
                        { key: "rotationYaw225",   label: "Rear/Left (225°)" },
                        { key: "rotationYaw270",   label: "Left (270°)" },
                        { key: "rotationYaw315",   label: "Forward/Left (315°)" },
                        { key: "rotationPitch90",  label: "Up (Pitch 90°)" },
                        { key: "rotationPitch270", label: "Down (Pitch 270°)" }
                    ]
                     delegate: LabelledLabel {
                        label: modelData.label
                        labelText: _activeVehicle && _activeVehicle.distanceSensors
                                   ? (_activeVehicle.distanceSensors.getFact(modelData.key).value === undefined
                                      ? "--"
                                      : _activeVehicle.distanceSensors.getFact(modelData.key).value.toFixed(2) + " m")
                                   : "--"
                    }
                }
            }
        }
    }
// }

    expandedComponent: Component {
        SettingsGroupLayout {
            heading: qsTr("Distance Sensor Settings")

            QGCLabel {
                text: qsTr("Additional Distance sensor settings go here")
            }
        }
    }
}
