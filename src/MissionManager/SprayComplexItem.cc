/****************************************************************************
 * (c) 2026 QGROUNDCONTROL PROJECT
 ****************************************************************************/

#include "SprayComplexItem.h"
#include "MissionItem.h"
#include "QGroundControlQmlGlobal.h"
#include "QGCLoggingCategory.h"

#include <QtCore/QtMath>

QGC_LOGGING_CATEGORY(SprayComplexItemLog, "SprayComplexItemLog")

const QString SprayComplexItem::name(SprayComplexItem::tr("Spray"));

SprayComplexItem::SprayComplexItem(PlanMasterController* masterController, bool flyView, const QString& kmlOrShpFile)
    : SurveyComplexItem(masterController, flyView, kmlOrShpFile)
    , _sprayMetaDataMap(FactMetaData::createMapFromJsonFile(QStringLiteral(":/json/Spray.SettingsGroup.json"), this))
    , _altitudeFact(settingsGroup, _sprayMetaDataMap["Altitude"])
    , _spacingFact(settingsGroup, _sprayMetaDataMap["Spacing"])
    , _flowRateFact(settingsGroup, _sprayMetaDataMap["FlowRate"])
    , _sprayAroundTurnsFact(settingsGroup, _sprayMetaDataMap["SprayAroundTurns"])
{
    _editorQml = "qrc:/qml/QGroundControl/Controls/SprayItemEditor.qml";

    if (kmlOrShpFile.isEmpty()) {
        _surveyAreaPolygon.clear();
    }

    _altitudeFact.setRawValue(cameraCalc()->distanceToSurface()->rawValue());
    connect(&_altitudeFact, &Fact::rawValueChanged, this, [this](const QVariant& value) {
        cameraCalc()->distanceToSurface()->setRawValue(value);
    });
    connect(cameraCalc()->distanceToSurface(), &Fact::rawValueChanged, this, [this](const QVariant& value) {
        if (_altitudeFact.rawValue() != value) {
            _altitudeFact.setRawValue(value);
        }
    });
    connect(&_spacingFact, &Fact::valueChanged, this, &SprayComplexItem::_rebuildTransects);
    connect(&_spacingFact, &Fact::valueChanged, this, &SprayComplexItem::_setDirty);
    connect(&_flowRateFact, &Fact::valueChanged, this, &SprayComplexItem::_setDirty);
    connect(&_flowRateFact, &Fact::valueChanged, this, &SprayComplexItem::_emitStatisticsChanged);
    connect(&_sprayAroundTurnsFact, &Fact::valueChanged, this, &SprayComplexItem::_setDirty);
    connect(&_sprayAroundTurnsFact, &Fact::valueChanged, this, &SprayComplexItem::_emitStatisticsChanged);
    connect(&_sprayAroundTurnsFact, &Fact::valueChanged, this, [this](const QVariant&) { emit lastSequenceNumberChanged(lastSequenceNumber()); });
    connect(this, &SprayComplexItem::complexDistanceChanged, this, &SprayComplexItem::_emitStatisticsChanged, Qt::QueuedConnection);
}

void SprayComplexItem::_emitStatisticsChanged()
{
    emit activeSprayDistanceChanged();
}

void SprayComplexItem::_saveExtra(QJsonObject& saveObject) const
{
    QJsonObject sprayObject;
    sprayObject["altitude"] = _altitudeFact.rawValue().toDouble();
    sprayObject["spacing"] = _spacingFact.rawValue().toDouble();
    sprayObject["flowRate"] = _flowRateFact.rawValue().toDouble();
    sprayObject["sprayAroundTurns"] = _sprayAroundTurnsFact.rawValue().toBool();
    saveObject["Spray"] = sprayObject;
}

bool SprayComplexItem::_loadExtra(const QJsonObject& complexObject, QString& errorString)
{
    const QJsonObject sprayObject = complexObject["Spray"].toObject();
    if (sprayObject.isEmpty()) {
        errorString = tr("Spray mission is missing spray settings");
        return false;
    }
    _altitudeFact.setRawValue(sprayObject["altitude"].toDouble());
    _spacingFact.setRawValue(sprayObject["spacing"].toDouble());
    _flowRateFact.setRawValue(sprayObject["flowRate"].toDouble());
    _sprayAroundTurnsFact.setRawValue(sprayObject["sprayAroundTurns"].toBool());
    return true;
}

double SprayComplexItem::_transectSpacing() const
{
    return _spacingFact.rawValue().toDouble();
}

int SprayComplexItem::lastSequenceNumber() const
{
    if (_loadedMissionItems.count() || _rgFlightPathCoordInfo.isEmpty()) {
        return TransectStyleComplexItem::lastSequenceNumber();
    }

    int itemCount = _rgFlightPathCoordInfo.count() + 1; // one waypoint per coordinate, plus final sprayer disable
    const bool sprayTurns = _sprayAroundTurnsFact.rawValue().toBool();
    bool spraying = false;
    for (const CoordInfo_t& coordInfo : _rgFlightPathCoordInfo) {
        if (coordInfo.coordType == CoordTypeSurveyEntry && !spraying) {
            ++itemCount;
            spraying = true;
        }
        if (coordInfo.coordType == CoordTypeTurnaround && spraying && !sprayTurns) {
            ++itemCount;
            spraying = false;
        }
        if (coordInfo.coordType == CoordTypeSurveyExit && spraying && !sprayTurns) {
            ++itemCount;
            spraying = false;
        }
    }
    return _sequenceNumber + itemCount - 1;
}

double SprayComplexItem::_activeSprayDistance(bool includeTurnSegments) const
{
    double distance = 0;
    bool spraying = false;
    QGeoCoordinate previous;

    if (includeTurnSegments) {
        bool havePrevious = false;
        for (const CoordInfo_t& coordInfo : _rgFlightPathCoordInfo) {
            if (coordInfo.coordType == CoordTypeSurveyEntry && !spraying) {
                spraying = true;
            }

            if (havePrevious && spraying) {
                distance += previous.distanceTo(coordInfo.coord);
            }

            previous = coordInfo.coord;
            havePrevious = true;
        }
        return distance;
    }

    for (const CoordInfo_t& coordInfo : _rgFlightPathCoordInfo) {
        if (coordInfo.coordType == CoordTypeSurveyEntry) {
            spraying = true;
            previous = coordInfo.coord;
        } else if (spraying) {
            distance += previous.distanceTo(coordInfo.coord);
            previous = coordInfo.coord;
            if (coordInfo.coordType == CoordTypeSurveyExit) {
                spraying = false;
            }
        }
    }
    return distance;
}

double SprayComplexItem::activeSprayDistance() const
{
    return _activeSprayDistance(true /* includeTurnSegments */);
}

double SprayComplexItem::activeSprayArea() const
{
    return activeSprayDistance() * _spacingFact.rawValue().toDouble();
}

double SprayComplexItem::sprayTime() const
{
    return _vehicleSpeed == 0 ? 0 : activeSprayDistance() / _vehicleSpeed;
}

double SprayComplexItem::sprayVolume() const
{
    const double volumeDistance = _activeSprayDistance(_sprayAroundTurnsFact.rawValue().toBool());
    const double volumeTime = _vehicleSpeed == 0 ? 0 : volumeDistance / _vehicleSpeed;
    return volumeTime / 60.0 * _flowRateFact.rawValue().toDouble();
}

MAV_FRAME SprayComplexItem::_mavFrame() const
{
    switch (_cameraCalc.distanceMode()) {
    case QGroundControlQmlGlobal::AltitudeModeRelative:
        return MAV_FRAME_GLOBAL_RELATIVE_ALT;
    case QGroundControlQmlGlobal::AltitudeModeTerrainFrame:
        return MAV_FRAME_GLOBAL_TERRAIN_ALT;
    default:
        return MAV_FRAME_GLOBAL;
    }
}

void SprayComplexItem::_appendSprayerCommand(QList<MissionItem*>& items, QObject* missionItemParent, int& seqNum, bool enable)
{
    items.append(new MissionItem(seqNum++, MAV_CMD_SUYOCHI_DO_SPRAYER, MAV_FRAME_MISSION,
                                 enable ? 1.0 : 0.0, qQNaN(), qQNaN(), 0, 0, 0, 0,
                                 true, false, missionItemParent));
}

void SprayComplexItem::_buildAndAppendMissionItems(QList<MissionItem*>& items, QObject* missionItemParent)
{
    int seqNum = _sequenceNumber;
    const MAV_FRAME frame = _mavFrame();
    const bool sprayTurns = _sprayAroundTurnsFact.rawValue().toBool();
    bool spraying = false;

    for (const CoordInfo_t& coordInfo : _rgFlightPathCoordInfo) {
        if (coordInfo.coordType == CoordTypeSurveyEntry && !spraying) {
            _appendSprayerCommand(items, missionItemParent, seqNum, true);
            spraying = true;
        }
        if (coordInfo.coordType == CoordTypeTurnaround && spraying && !sprayTurns) {
            _appendSprayerCommand(items, missionItemParent, seqNum, false);
            spraying = false;
        }

        _appendWaypoint(items, missionItemParent, seqNum, frame, 0, coordInfo.coord);

        if (coordInfo.coordType == CoordTypeSurveyExit && !sprayTurns && spraying) {
            _appendSprayerCommand(items, missionItemParent, seqNum, false);
            spraying = false;
        }
    }

    // Always leave the vehicle in a safe, non-spraying state.
    _appendSprayerCommand(items, missionItemParent, seqNum, false);
}
