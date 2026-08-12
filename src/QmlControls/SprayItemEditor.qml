import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Controls
import QGroundControl.FactControls
import QGroundControl.Palette

Rectangle {
    id: root
    width: availableWidth
    height: childrenRect.y + childrenRect.height + margin
    color: qgcPal.windowShadeDark
    radius: ScreenTools.defaultFontPixelWidth / 2

    property real margin: ScreenTools.defaultFontPixelWidth / 2
    property real labelWidth: Math.min(ScreenTools.defaultFontPixelWidth * 12, root.width * 0.48)
    property var _missionItem: missionItem
    readonly property bool transectAreaDefinitionComplete: _missionItem.surveyAreaPolygon.isValid

    function polygonCaptureStarted() { missionItem.clearPolygon() }
    function polygonCaptureFinished(coordinates) {
        for (var i = 0; i < coordinates.length; i++) {
            missionItem.addPolygonCoordinate(coordinates[i])
        }
    }
    function polygonAdjustVertex(vertexIndex, vertexCoordinate) {
        missionItem.adjustPolygonCoordinate(vertexIndex, vertexCoordinate)
    }
    function polygonAdjustStarted() {}
    function polygonAdjustFinished() {}

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    ColumnLayout {
        id: editorColumn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: root.margin
        spacing: root.margin

        QGCLabel {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("Use the Polygon Tools to create the polygon which outlines the spray area.")
            visible: !root.transectAreaDefinitionComplete || root._missionItem.wizardMode
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: root.margin
            visible: root.transectAreaDefinitionComplete && !root._missionItem.wizardMode

            SectionHeader {
                id: sprayHeader
                Layout.fillWidth: true
                text: qsTr("Spray")
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: root.margin
                rowSpacing: root.margin
                visible: sprayHeader.checked

                QGCLabel { text: qsTr("Altitude"); Layout.preferredWidth: root.labelWidth; Layout.maximumWidth: root.labelWidth; wrapMode: Text.WordWrap }
                FactTextField { fact: missionItem.altitude; Layout.fillWidth: true }
                QGCLabel { text: qsTr("Spacing"); Layout.preferredWidth: root.labelWidth; Layout.maximumWidth: root.labelWidth; wrapMode: Text.WordWrap }
                FactTextField { fact: missionItem.spacing; Layout.fillWidth: true }
                QGCLabel { text: qsTr("Flow rate"); Layout.preferredWidth: root.labelWidth; Layout.maximumWidth: root.labelWidth; wrapMode: Text.WordWrap }
                FactTextField { fact: missionItem.flowRate; Layout.fillWidth: true }
            }

            SectionHeader {
                id: transectsHeader
                Layout.fillWidth: true
                text: qsTr("Transects")
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: root.margin
                rowSpacing: root.margin
                visible: transectsHeader.checked

                QGCLabel { text: qsTr("Angle"); Layout.preferredWidth: root.labelWidth; Layout.maximumWidth: root.labelWidth; wrapMode: Text.WordWrap }
                FactTextField {
                    fact: missionItem.gridAngle
                    Layout.fillWidth: true
                    onUpdated: angleSlider.value = missionItem.gridAngle.value
                }

                QGCSlider {
                    id: angleSlider
                    from: 0
                    to: 359
                    stepSize: 1
                    tickmarksEnabled: false
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 1.5
                    onValueChanged: missionItem.gridAngle.value = value
                    Component.onCompleted: value = missionItem.gridAngle.value
                    live: true
                }
                QGCLabel { text: qsTr("Turnaround dist"); Layout.preferredWidth: root.labelWidth; Layout.maximumWidth: root.labelWidth; wrapMode: Text.WordWrap }
                FactTextField { fact: missionItem.turnAroundDistance; Layout.fillWidth: true }
            }

            QGCCheckBox {
                Layout.fillWidth: true
                text: qsTr("Spray around turns")
                checked: missionItem.sprayAroundTurns.rawValue
                onClicked: missionItem.sprayAroundTurns.rawValue = checked
            }

            QGCButton {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Rotate Entry Point")
                onClicked: missionItem.rotateEntryPoint()
            }

            SectionHeader {
                id: statsHeader
                Layout.fillWidth: true
                text: qsTr("Statistics")
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: root.margin
                rowSpacing: root.margin
                visible: statsHeader.checked

                QGCLabel { text: qsTr("Area"); Layout.preferredWidth: root.labelWidth; Layout.maximumWidth: root.labelWidth; wrapMode: Text.WordWrap }
                QGCLabel { Layout.fillWidth: true; wrapMode: Text.WordWrap; text: QGroundControl.unitsConversion.squareMetersToAppSettingsAreaUnits(missionItem.activeSprayArea).toFixed(2) + " " + QGroundControl.unitsConversion.appSettingsAreaUnitsString }
                QGCLabel { text: qsTr("Active distance"); Layout.preferredWidth: root.labelWidth; Layout.maximumWidth: root.labelWidth; wrapMode: Text.WordWrap }
                QGCLabel { Layout.fillWidth: true; wrapMode: Text.WordWrap; text: QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(missionItem.activeSprayDistance).toFixed(1) + " " + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString }
                QGCLabel { text: qsTr("Time"); Layout.preferredWidth: root.labelWidth; Layout.maximumWidth: root.labelWidth; wrapMode: Text.WordWrap }
                QGCLabel { Layout.fillWidth: true; wrapMode: Text.WordWrap; text: qsTr("%1 min").arg((missionItem.sprayTime / 60).toFixed(1)) }
                QGCLabel { text: qsTr("Volume"); Layout.preferredWidth: root.labelWidth; Layout.maximumWidth: root.labelWidth; wrapMode: Text.WordWrap }
                QGCLabel { Layout.fillWidth: true; wrapMode: Text.WordWrap; text: qsTr("%1 L").arg(missionItem.sprayVolume.toFixed(1)) }
            }
        }
    }
}
