import QtQuick 2.15
import QGroundControl
import QGroundControl.Controls

Rectangle {
    id: myMovablePanel
    width: 300
    height: 200
    radius: 8
    color: "#00000080"   // semi-transparent black
    border.color: "white"
    border.width: 1

    // Position on screen
    x: 100
    y: 100

    // ✅ Dragging whole panel
    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: myMovablePanel
        cursorShape: Qt.OpenHandCursor

        onPressed: cursorShape = Qt.ClosedHandCursor
        onReleased: cursorShape = Qt.OpenHandCursor
    }

    // ✅ Content inside the panel
    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // ✅ Title + Close Button row
        Row {
            width: parent.width
            spacing: 10

            QGCLabel {
                text: qsTr("Sensor Panel")
                color: "white"
                font.pixelSize: Math.max(12, myMovablePanel.width * 0.04)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Button {
                background: Rectangle { color: "transparent" }
                contentItem: Text {
                    text: "✖"
                    color: "white"
                    font.pixelSize: 18
                }
                onClicked: myMovablePanel.visible = false
            }
        }

        // ✅ Example Fact Value
        QGCLabel {
            text: "Altitude: " +
                (QGroundControl.multiVehicleManager.activeVehicle ?
                 QGroundControl.multiVehicleManager.activeVehicle.altitudeRelative.value.toFixed(1) + " m" : "N/A")
            color: "white"
            wrapMode: Text.WordWrap
            width: parent.width
            font.pixelSize: Math.max(12, myMovablePanel.width * 0.04)
        }

        QGCLabel {
            text: qsTr("Second Value: Example")
            color: "white"
            wrapMode: Text.WordWrap
            width: parent.width
            font.pixelSize: Math.max(12, myMovablePanel.width * 0.04)
        }

        QGCLabel {
            text: qsTr("Third Value: Demo")
            color: "white"
            wrapMode: Text.WordWrap
            width: parent.width
            font.pixelSize: Math.max(12, myMovablePanel.width * 0.04)
        }
    }

    // ✅ Resize handle at corner
    Rectangle {
        id: resizeHandle
        width: 16
        height: 16
        color: "white"
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        MouseArea {
            anchors.fill: parent
            drag.target: myMovablePanel
            drag.minimumWidth: 200
            drag.minimumHeight: 150
            drag.axis: Drag.XAndYAxis
            onPositionChanged: {
                myMovablePanel.width = Math.max(200, myMovablePanel.width + mouse.x - dragArea.mouseX)
                myMovablePanel.height = Math.max(150, myMovablePanel.height + mouse.y - dragArea.mouseY)
            }
        }
    }
}
