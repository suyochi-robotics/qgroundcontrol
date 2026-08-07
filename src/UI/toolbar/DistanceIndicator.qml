import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools


import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools

Item {
    id:             control
    width:          flowIndicatorRow.width
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property bool showIndicator: _activeVehicle && _activeVehicle.distanceSensors &&
                                 (!isNaN(_activeVehicle.distanceSensors.rotationNone.value) ||
                                  !isNaN(_activeVehicle.distanceSensors.rotationYaw180.value) ||
                                  !isNaN(_activeVehicle.distanceSensors.rotationPitch270.value))
    property var _distanceEntries: _activeVehicle && _activeVehicle.distanceSensors ? [
        { fact: _activeVehicle.distanceSensors.rotationNone, arrow: "→" },
        { fact: _activeVehicle.distanceSensors.rotationYaw180, arrow: "←" },
        { fact: _activeVehicle.distanceSensors.rotationPitch270, arrow: "⇩" }
    ] : []

    function formatDistance(distanceFact) {
        if (!distanceFact || isNaN(distanceFact.value)) {
            return "--"
        }

        return distanceFact.valueString + " " + distanceFact.units
    }

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
            source:             "/qmlimages/obs_distance.svg"
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            opacity:            _activeVehicle ? 1 : 0.5
            color:              qgcPal.buttonText
        }

        Column {
            id:                     flowValuesColumn
            anchors.verticalCenter: parent.verticalCenter
            visible:                _activeVehicle && _activeVehicle.distanceSensors ? true : false  // later bind to sensor available
            spacing:                0

            Repeater {
                model: control._distanceEntries

                QGCLabel {
                    visible: !isNaN(modelData.fact.value)
                    text: control.formatDistance(modelData.fact) + " (" + modelData.arrow + ")"
                }
            }

        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked:      mainWindow.showIndicatorDrawer(distanceIndicatorPage, control)
    }

    Component {
        id: distanceIndicatorPage

        DistanceIndicatorPage { }
    }
}
