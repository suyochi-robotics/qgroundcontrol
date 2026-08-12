/****************************************************************************
 * (c) 2026 QGROUNDCONTROL PROJECT
 ****************************************************************************/
#pragma once

#include "SurveyComplexItem.h"

class SprayComplexItem : public SurveyComplexItem
{
    Q_OBJECT

public:
    SprayComplexItem(PlanMasterController* masterController, bool flyView, const QString& kmlOrShpFile);

    Q_PROPERTY(Fact* altitude READ altitude CONSTANT)
    Q_PROPERTY(Fact* spacing READ spacing CONSTANT)
    Q_PROPERTY(Fact* flowRate READ flowRate CONSTANT)
    Q_PROPERTY(Fact* sprayAroundTurns READ sprayAroundTurns CONSTANT)
    Q_PROPERTY(double activeSprayArea READ activeSprayArea NOTIFY activeSprayDistanceChanged)
    Q_PROPERTY(double activeSprayDistance READ activeSprayDistance NOTIFY activeSprayDistanceChanged)
    Q_PROPERTY(double sprayTime READ sprayTime NOTIFY activeSprayDistanceChanged)
    Q_PROPERTY(double sprayVolume READ sprayVolume NOTIFY activeSprayDistanceChanged)

    Fact* altitude() { return &_altitudeFact; }
    Fact* spacing() { return &_spacingFact; }
    Fact* flowRate() { return &_flowRateFact; }
    Fact* sprayAroundTurns() { return &_sprayAroundTurnsFact; }
    double activeSprayArea() const;
    double activeSprayDistance() const;
    double sprayTime() const;
    double sprayVolume() const;

    QString patternName() const override { return name; }
    int lastSequenceNumber() const override;
    QString mapVisualQML() const override { return QStringLiteral("SurveyMapVisual.qml"); }
    QString commandDescription() const override { return tr("Spray"); }
    QString commandName() const override { return tr("Spray"); }
    QString abbreviation() const override { return tr("Sp"); }

    static const QString name;
    static constexpr const char* jsonComplexItemTypeValue = "spray";
    static constexpr const char* settingsGroup = "Spray";

signals:
    void activeSprayDistanceChanged();

private slots:
    void _emitStatisticsChanged();

protected:
    QString _complexItemType() const override { return QString::fromLatin1(jsonComplexItemTypeValue); }
    void _saveExtra(QJsonObject& saveObject) const override;
    bool _loadExtra(const QJsonObject& complexObject, QString& errorString) override;
    double _transectSpacing() const override;
    bool _hasCameraData() const override { return false; }
    void _buildAndAppendMissionItems(QList<MissionItem*>& items, QObject* missionItemParent) override;

private:
    double _activeSprayDistance(bool includeTurnSegments) const;
    void _appendSprayerCommand(QList<MissionItem*>& items, QObject* missionItemParent, int& seqNum, bool enable);
    MAV_FRAME _mavFrame() const;

    QMap<QString, FactMetaData*> _sprayMetaDataMap;
    SettingsFact _altitudeFact;
    SettingsFact _spacingFact;
    SettingsFact _flowRateFact;
    SettingsFact _sprayAroundTurnsFact;
};
