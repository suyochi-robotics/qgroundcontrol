/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "SprayPlanCreator.h"
#include "PlanMasterController.h"
#include "SprayComplexItem.h"

SprayPlanCreator::SprayPlanCreator(PlanMasterController* planMasterController, QObject* parent)
    : PlanCreator(planMasterController, SprayComplexItem::name, QStringLiteral("/qmlimages/PlanCreator/SurveyPlanCreator.png"), parent)
{

}

void SprayPlanCreator::createPlan(const QGeoCoordinate& mapCenterCoord)
{
    _planMasterController->removeAll();
    VisualMissionItem* takeoffItem = _missionController->insertTakeoffItem(mapCenterCoord, -1);
    _missionController->insertComplexMissionItem(SprayComplexItem::name, mapCenterCoord, -1);
    _missionController->insertLandItem(mapCenterCoord, -1);
    _missionController->setCurrentPlanViewSeqNum(takeoffItem->sequenceNumber(), true);
}
