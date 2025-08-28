import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools

ToolIndicatorPage {
    showExpand: true   // allow expansion (like GPS)

    property string na:      qsTr("N/A", "No data to display")
    property string valueNA: qsTr("--.--", "No data to display")

    contentComponent: Component {
        ColumnLayout {
            spacing: ScreenTools.defaultFontPixelHeight / 2

            SettingsGroupLayout {
                heading: qsTr("Optical Flow Sensor Status")

                LabelledLabel {
                    label:      qsTr("Flow Rate")
                    labelText:  "12.3 rad/s"    // placeholder
                }

                LabelledLabel {
                    label:      qsTr("Quality")
                    labelText:  "85 %"          // placeholder
                }

                LabelledLabel {
                    label:      qsTr("Ground Distance")
                    labelText:  "2.45 m"        // placeholder
                }

                LabelledLabel {
                    label:      qsTr("Sensor Status")
                    labelText:  qsTr("OK")      // placeholder
                }
            }
        }
    }

    expandedComponent: Component {
        SettingsGroupLayout {
            heading: qsTr("Optical Flow Settings")

            QGCLabel {
                text: qsTr("Additional flow sensor settings go here")
            }
        }
    }
}
