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
            visible:                true   // later bind to sensor available
            spacing:                0

            QGCLabel {
                text: _activeVehicle
                      ? _activeVehicle.distanceSensor.getFact("rotationNone").value.toFixed(2) + " m (Forward)"
                      : "--"
            }
            QGCLabel {
                text: _activeVehicle
                      ? _activeVehicle.distanceSensor.getFact("rotationYaw180").value.toFixed(2) + " m (Rear)"
                      : "--"
            }
            QGCLabel {
                text: _activeVehicle
                      ? _activeVehicle.distanceSensor.getFact("rotationPitch270").value.toFixed(2) + " m (Down)"
                      : "--"
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
