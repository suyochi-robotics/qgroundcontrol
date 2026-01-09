#pragma once

#include "FactGroup.h"

#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(FlowSensorLog)

class VehicleFlowSensorFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact* flowRate    READ flowRate    CONSTANT)
    Q_PROPERTY(Fact* pulseCount  READ pulseCount  CONSTANT)
public:
    explicit VehicleFlowSensorFactGroup(QObject* parent = nullptr);

    static constexpr const char* _flowSensorFactGroupName = "flowSensor";
    static constexpr const char* _flowRateFactName        = "flowRate";
    static constexpr const char* _pulseCountFactName      = "pulseCount";

    Fact* flowRate()   { return &_flowRateFact; }
    Fact* pulseCount() { return &_pulseCountFact; }

    // ✅ These are your explicit setters:
    void setFlowRate(double rate);
    void setPulseCount(int count);

    //Overrides from FactGroup
    void handleMessage(Vehicle* vehicle, const mavlink_message_t& message) final;
    
private:

    void _handleFlowSensor(const mavlink_message_t& message);



    
    Fact _flowRateFact = Fact(0, QStringLiteral("flowRate"), FactMetaData::valueTypeDouble);
    Fact _pulseCountFact = Fact(0, QStringLiteral("pulseCount"), FactMetaData::valueTypeUint32);
};
