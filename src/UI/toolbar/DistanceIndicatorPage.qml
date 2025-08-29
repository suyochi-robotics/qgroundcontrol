import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools

ToolIndicatorPage {
    showExpand: true   // allow expansion (like GPS)

    property var    _activeVehicle:      QGroundControl.multiVehicleManager.activeVehicle
    property string na:      qsTr("N/A", "No data to display")
    property string valueNA: qsTr("--.--", "No data to display")

    contentComponent: Component {
        ColumnLayout {
            spacing: ScreenTools.defaultFontPixelHeight / 2

            SettingsGroupLayout {
                heading: qsTr(" Flow Sensor Status")

                LabelledLabel {
                    label:      qsTr("Forward")
                    labelText:  activeVehicle
                                ? _activeVehicle.distanceSensor.getFact("rotationNone").value.toFixed(2) + " m (Forward)"
                                : "--"
                }
                LabelledLabel {
                    label:      qsTr("Backward")
                    labelText:  _activeVehicle
                                ? _activeVehicle.distanceSensor.getFact("rotationYaw180").value.toFixed(2) + " m (Rear)"
                                : "--"
                }
                LabelledLabel {
                    label:      qsTr("Terrain")
                    labelText:  _activeVehicle
                                ? _activeVehicle.distanceSensor.getFact("rotationPitch270").value.toFixed(2) + " m (Down)"
                                : "--"          // placeholder
                }


            }
        }
    }

    expandedComponent: Component {
        SettingsGroupLayout {
            heading: qsTr("Distance Sensor Settings")

            QGCLabel {
                text: qsTr("Additional Distance sensor settings go here")
            }
        }
    }
}
