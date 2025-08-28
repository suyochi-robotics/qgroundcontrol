import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools

// Item {
//     id: control
//     width: flowIcon.width
//     height: flowIcon.height

//     property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

//     signal clicked   // standard

//     QGCColoredImage {
//         id: flowIcon
//         source: "/qmlimages/flow.svg"   // use qrc so it's packaged
//         width: ScreenTools.defaultFontPixelHeight * 1.2
//         height: width
//         fillMode: Image.PreserveAspectFit
//         opacity: _activeVehicle ? 1 : 0.5
//         color: qgcPal.buttonText
//     }

//     MouseArea {
//         anchors.fill: parent
//         onClicked: control.clicked()
//     }

//     ToolIndicatorPage {
//         id: pageLoader
//         pageComponent: "qrc:/qml/QGroundControl/Toolbar/FlowIndicatorPage.qml"
//         indicator: control
//     }
// }
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
                anchors.horizontalCenter: flowValue.horizontalCenter
                color:  qgcPal.buttonText
                text:   "85%"   // placeholder (quality)
            }

            QGCLabel {
                id:     flowValue
                color:  qgcPal.buttonText
                text:   "2.45m" // placeholder (ground distance)
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