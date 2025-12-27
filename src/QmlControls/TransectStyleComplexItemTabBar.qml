import QtQuick

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Controls

QGCTabBar {
    id: tabBar
    property var missionItem

    property bool isFieldSpraySelected: {
        return missionItem &&
               missionItem.commandName !== null &&
               missionItem.commandName === "Field Spray"
    }

    Component.onCompleted: currentIndex = QGroundControl.settingsManager.planViewSettings.displayPresetsTabFirst.rawValue ? (isFieldSpraySelected ? 1 : 2) : 0

    QGCTabButton { icon.source: "/qmlimages/PatternGrid.png"; icon.height: ScreenTools.defaultFontPixelHeight }
    Loader {
        active: !isFieldSpraySelected
        sourceComponent: QGCTabButton {
            icon.source: "/qmlimages/PatternCamera.png"
            icon.height: ScreenTools.defaultFontPixelHeight
        }
    }
    QGCTabButton { icon.source: "/qmlimages/PatternTerrain.png"; icon.height: ScreenTools.defaultFontPixelHeight }
    QGCTabButton { icon.source: "/qmlimages/PatternPresets.png"; icon.height: ScreenTools.defaultFontPixelHeight }
}
