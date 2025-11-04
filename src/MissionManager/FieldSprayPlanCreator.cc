/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "AgriMissionPlanCreator.h"
#include "PlanMasterController.h"
#include "AgriMissionComplexItem.h"

AgriMissionPlanCreator::AgriMissionPlanCreator(PlanMasterController* planMasterController, QObject* parent)
    : PlanCreator(planMasterController, AgriMissionComplexItem::name, QStringLiteral("/qmlimages/PlanCreator/AgriMissionPlanCreator.png"), parent)
{

}

void AgriMissionPlanCreator::createPlan(const QGeoCoordinate& mapCenterCoord)
{
    _planMasterController->removeAll();
    VisualMissionItem* takeoffItem = _missionController->insertTakeoffItem(mapCenterCoord, -1);
    _missionController->insertComplexMissionItem(AgriMissionComplexItem::name, mapCenterCoord, -1)->setWizardMode(true);
    _missionController->insertLandItem(mapCenterCoord, -1);
    _missionController->setCurrentPlanViewSeqNum(takeoffItem->sequenceNumber(), true);
}
