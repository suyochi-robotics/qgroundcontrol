import QtQuick
import QtQuick.Layouts
import QGroundControl

import QGroundControl.Controls
import QGroundControl.FactSystem
import QGroundControl.ScreenTools

Item {
    id:             control
    width:          flowIndicatorRow.width
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool _parametersReady: QGroundControl.multiVehicleManager.parameterReadyVehicleAvailable
    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    FactPanelController { id: controller }

    property Fact _nullFact:        Fact { }
    property Fact _flowCapEnableFact: _parametersReady && controller.parameterExists(-1, "FLOW_CAP_ENABLE") ? controller.getParameterFact(-1, "FLOW_CAP_ENABLE") : _nullFact
    property bool showIndicator: _parametersReady && controller.parameterExists(-1, "FLOW_CAP_ENABLE") && _flowCapEnableFact.rawValue === 1

    Row {
        id:             flowIndicatorRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        spacing:        ScreenTools.defaultFontPixelWidth / 2

        QGCColoredImage {
            id:                 flowIcon
            width:              height
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             "/qmlimages/flow.svg"
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            opacity:            _activeVehicle ? 1 : 0.5
            color:              qgcPal.buttonText
        }

        Column {
            id:                     flowValuesColumn
            anchors.verticalCenter: parent.verticalCenter
            visible:                true   // later bind to sensor available
            spacing:                0

           QGCLabel {
               color: qgcPal.buttonText
               text: _activeVehicle && !isNaN(_activeVehicle.flowSensor.flowRate.value)
                     ? _activeVehicle.flowSensor.flowRate.value.toFixed(2)
                     : "--"
            }
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked:      mainWindow.showIndicatorDrawer(flowIndicatorPage, control)
    }

    Component {
        id: flowIndicatorPage

        FlowIndicatorPage { }
    }
}