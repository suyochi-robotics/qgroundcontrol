/****************************************************************************
 *
 * (c) 2026 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FactSystem
import QGroundControl.ScreenTools

Item {
    id:             control
    width:          sprayIcon.width
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool _parametersReady: QGroundControl.multiVehicleManager.parameterReadyVehicleAvailable

    FactPanelController { id: controller }

    property Fact _nullFact:          Fact { }
    property Fact _sprayModeFact:     _parametersReady && controller.parameterExists(-1, "SPRAY_EN_MODE") ? controller.getParameterFact(-1, "SPRAY_EN_MODE") : _nullFact
    property Fact _sprayManualFact:   _parametersReady && controller.parameterExists(-1, "SPRAY_EN_MAN") ? controller.getParameterFact(-1, "SPRAY_EN_MAN") : _nullFact
    property Fact _pumpSpeedFact:     _parametersReady && controller.parameterExists(-1, "PUMP_EXP_SPD") ? controller.getParameterFact(-1, "PUMP_EXP_SPD") : _nullFact
    property Fact _sprayerSpeedFact:  _parametersReady && controller.parameterExists(-1, "SPRYAER_EXP_SPD") ? controller.getParameterFact(-1, "SPRYAER_EXP_SPD") : _nullFact

    property bool showIndicator: _parametersReady &&
                                 controller.parameterExists(-1, "SPRAY_EN_MODE") &&
                                 controller.parameterExists(-1, "PUMP_EXP_SPD") &&
                                 controller.parameterExists(-1, "SPRYAER_EXP_SPD") &&
                                 _sprayModeFact.rawValue > 0

    function clamp(value, minimum, maximum) {
        return Math.max(minimum, Math.min(maximum, value))
    }

    function setPumpSpeed(value) {
        value = Math.round(value / 5) * 5
        _pumpSpeedFact.rawValue = clamp(value, 0, 100)
    }

    function setSprayerSpeed(value) {
        value = Math.round(value / 10) * 10
        _sprayerSpeedFact.rawValue = clamp(value, 0, 100)
    }

    QGCColoredImage {
        id:                     sprayIcon
        width:                  height
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        source:                 "/qmlimages/Spray.svg"
        fillMode:               Image.PreserveAspectFit
        sourceSize.height:      height
        color:                  _sprayManualFact.rawValue === 1 ? qgcPal.colorGreen : qgcPal.buttonText
    }

    QGCMouseArea {
        anchors.fill: parent
        onClicked: mainWindow.showIndicatorDrawer(sprayerControlsPage, control)
    }

    Component {
        id: sprayerControlsPage

        ToolIndicatorPage {
            waitForParameters: true

            contentComponent: ColumnLayout {
                spacing: ScreenTools.defaultFontPixelHeight / 2

                QGCLabel {
                    text:           qsTr("Sprayer Controls")
                    font.weight:    Font.DemiBold
                    font.pointSize: ScreenTools.mediumFontPointSize
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: ScreenTools.defaultFontPixelWidth
                    visible: _sprayModeFact.rawValue === 4 && controller.parameterExists(-1, "SPRAY_EN_MAN")

                    QGCButton {
                        Layout.fillWidth: true
                        text: qsTr("SPRAY ON")
                        enabled: _sprayManualFact.rawValue !== 1
                        onClicked: _sprayManualFact.rawValue = 1
                    }

                    QGCButton {
                        Layout.fillWidth: true
                        text: qsTr("SPRAY OFF")
                        enabled: _sprayManualFact.rawValue !== 0
                        onClicked: _sprayManualFact.rawValue = 0
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: ScreenTools.defaultFontPixelWidth
                    rowSpacing: ScreenTools.defaultFontPixelHeight / 2

                    QGCLabel {
                        Layout.columnSpan: 3
                        text: qsTr("Pump speed: %1%").arg(Math.round(_pumpSpeedFact.rawValue))
                    }

                    QGCButton {
                        text: "−"
                        enabled: _pumpSpeedFact.rawValue > 0
                        onClicked: control.setPumpSpeed(_pumpSpeedFact.rawValue - 5)
                    }

                    QGCSlider {
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        stepSize: 5
                        snapMode: Slider.SnapAlways
                        value: _pumpSpeedFact.rawValue
                        onMoved: control.setPumpSpeed(value)
                    }

                    QGCButton {
                        text: "+"
                        enabled: _pumpSpeedFact.rawValue < 100
                        onClicked: control.setPumpSpeed(_pumpSpeedFact.rawValue + 5)
                    }

                    QGCLabel {
                        Layout.columnSpan: 3
                        text: qsTr("Sprayer speed: %1%").arg(_sprayerSpeedFact.rawValue)
                    }

                    QGCButton {
                        text: "−"
                        enabled: _sprayerSpeedFact.rawValue > 0
                        onClicked: control.setSprayerSpeed(_sprayerSpeedFact.rawValue - 10)
                    }

                    QGCSlider {
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        stepSize: 10
                        snapMode: Slider.SnapAlways
                        value: _sprayerSpeedFact.rawValue
                        onMoved: control.setSprayerSpeed(value)
                    }

                    QGCButton {
                        text: "+"
                        enabled: _sprayerSpeedFact.rawValue < 100
                        onClicked: control.setSprayerSpeed(_sprayerSpeedFact.rawValue + 10)
                    }
                }
            }
        }
    }
}
