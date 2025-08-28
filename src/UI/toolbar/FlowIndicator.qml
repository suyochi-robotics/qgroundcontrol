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

    property bool showIndicator: QGroundControl.multiVehicleManager.activeVehicle ? true : false
    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

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
    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            // later you can wire this to FlowIndicatorPage
            console.log("Flow indicator clicked")
        }
    }
}
