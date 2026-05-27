#pragma once

#include "FactGroup.h"

class VehicleFlowSensorFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact* flowRate    READ flowRate    CONSTANT)
    Q_PROPERTY(Fact* pulseCount  READ pulseCount  CONSTANT)
public:
    explicit VehicleFlowSensorFactGroup(QObject* parent = nullptr);

    Fact* flowRate()   { return &_flowRateFact; }
    Fact* pulseCount() { return &_pulseCountFact; }

    void setFlowRate(double rate);
    void setPulseCount(int count);

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

private:

    void _handleFlowSensor(const mavlink_message_t& message);

    Fact _flowRateFact = Fact(0, QStringLiteral("flowRate"), FactMetaData::valueTypeDouble);
    Fact _pulseCountFact = Fact(0, QStringLiteral("pulseCount"), FactMetaData::valueTypeUint32);
};
