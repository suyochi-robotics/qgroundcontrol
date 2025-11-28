/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "FieldSprayPlanCreator.h"
#include "PlanMasterController.h"
#include "FieldSprayComplexItem.h"

FieldSprayPlanCreator::FieldSprayPlanCreator(PlanMasterController* planMasterController, QObject* parent)
    : PlanCreator(planMasterController, FieldSprayComplexItem::name, QStringLiteral("/qmlimages/PlanCreator/FieldSprayPlanCreator.png"), parent)
{

}

void FieldSprayPlanCreator::createPlan(const QGeoCoordinate& mapCenterCoord)
{
    _planMasterController->removeAll();
    VisualMissionItem* takeoffItem = _missionController->insertTakeoffItem(mapCenterCoord, -1);
    _missionController->insertComplexMissionItem(FieldSprayComplexItem::name, mapCenterCoord, -1)->setWizardMode(true);
    _missionController->insertLandItem(mapCenterCoord, -1);
    _missionController->setCurrentPlanViewSeqNum(takeoffItem->sequenceNumber(), true);
}
