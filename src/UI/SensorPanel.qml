//SensorPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Window

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FactControls
import QGroundControl.ScreenTools
import QGroundControl.FlightDisplay
import QGroundControl.FlightMap
Rectangle {
    id: sensorPanel
    width: 320
    height: contentColumn.implicitHeight + 24
    radius: 12
    color: "#000000cc"
    border.color: "white"
    border.width: 1

    // Nice shadow for depth
    // layer.enabled: true
    // layer.effect: DropShadow {
    //     color: "#000000"
    //     radius: 8
    //     samples: 16
    //     spread: 0.2
    //     horizontalOffset: 2
    //     verticalOffset: 2
    // }

    // Allow dragging
    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: sensorPanel
    }

    // Content
    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Title row with close
        Row {
            width: parent.width
            spacing: 8

            QGCLabel {
                text: "Sensor Panel"
                color: "white"
                font.pixelSize: 16
                // Layout.fillWidth: true
            }

            Button {
                background: Rectangle { color: "transparent" }
                contentItem: Text {
                    text: "✖"
                    color: "white"
                    font.pixelSize: 18
                }
                onClicked: sensorPanel.visible = false
            }
        }

        // Flow Sensor
        QGCLabel {
            text: "Flow Sensor:"
            color: "white"
        }

        // FactLabel {
        //     fact: QGroundControl.multiVehicleManager.activeVehicle && QGroundControl.multiVehicleManager.activeVehicle.flowSensor
        //         ? QGroundControl.multiVehicleManager.activeVehicle.flowSensor.flowRate
        //         : null
        //     units: "lpm"
        // }

        // Example: Distance Sensors (multiple)
        Repeater {
            model: QGroundControl.multiVehicleManager.activeVehicle
                   ? QGroundControl.multiVehicleManager.activeVehicle.distanceSensors
                   : []

            delegate: Row {
                spacing: 8

                QGCLabel {
                    text: modelData.name + ":"
                    color: "white"
                }

                // FactLabel {
                //     fact: modelData.distance
                //     units: "m"
                // }
            }
        }
    }
}







































































// // src/SensorPanel/SensorPanel.qml
// import QtQuick 2.15
// import QtQuick.Controls 2.15
// /*import QGroundControl.FactSystem 1.0
// import QGroundControl.Controls 1.0*/

// Item {
//     id: root

//     property bool visiblePanel: true

//     Rectangle {
//         id: panel
//         width: 220
//         height: 140
//         radius: 8
//         color: "#00000080"  // semi-transparent
//         border.color: "#ffffff50"
//         border.width: 1
//         visible: root.visiblePanel

//         x: 20
//         y: 20

//         MouseArea {
//             id: dragArea
//             anchors.fill: parent
//             drag.target: panel
//             cursorShape: Qt.OpenHandCursor

//             onPressed: cursorShape = Qt.ClosedHandCursor
//             onReleased: cursorShape = Qt.OpenHandCursor
//         }

//         Column {
//             anchors.centerIn: parent
//             spacing: 6

//             QGCLabel {
//                 text: qsTr("Flow Rate: ")/* +
//                       /* QGroundControl.multiVehicleManager.activeVehicle.flowSensor.flowRate.value.toFixed(2) +
//                       " L/min"*/
//                 color: "white"
//             }

//             QGCLabel {
//                 text: qsTr("Pulse Count: ") /*+
//                       /*QGroundControl.multiVehicleManager.activeVehicle.flowSensor.pulseCount.value*/
//                 color: "white"
//             }

//             // Add more sensors here later:
//             // QGCLabel { text: "Altitude: " + ... }

//             Row {
//                 spacing: 8
//                 anchors.horizontalCenter: parent.horizontalCenter

//                 Button {
//                     text: root.visiblePanel ? qsTr("Hide") : qsTr("Show")
//                     onClicked: root.visiblePanel = !root.visiblePanel
//                 }

//                 Button {
//                     text: qsTr("⚙️ Settings")
//                     onClicked: settingsPopup.open()
//                 }
//             }
//         }
//     }

//     Popup {
//         id: settingsPopup
//         width: 200
//         height: 120
//         modal: true
//         focus: true

//         Rectangle {
//             anchors.fill: parent
//             color: "#333333"
//             radius: 5

//             Column {
//                 anchors.centerIn: parent
//                 spacing: 8

//                 QGCLabel {
//                     text: qsTr("Sensor Panel Settings")
//                     color: "white"
//                 }

//                 // Add your settings here!
//                 Button {
//                     text: qsTr("Close")
//                     onClicked: settingsPopup.close()
//                 }
//             }
//         }
//     }
// }
//

