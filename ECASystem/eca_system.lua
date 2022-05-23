require_ex("ECASystem.arg")
require_ex("ECASystem.event")
require_ex("ECASystem.condition")
local actionModule = require_ex("ECASystem.action")

ECASystem = DefineClass("ECASystem")

function ECASystem:ctor(owner)
    self.owner = owner
    -- {eventId, {condition1, condition2}, {trueAction1, trueAction2}, {falseAction1, falseAction2} }
    self._eca = nil
end

function ECASystem:initFromData(ecaData)
    self._data = ecaData
    self._eca = self:_buildECA(ecaData)
end

function ECASystem:start()
    -- todo
    local conditionList = self._eca.conditionList or {}
    local res = true
    for _, condition in pairs(conditionList) do
        if not condition:getValue() then
            res = false
            break
        end
    end
    local actionList
    if res then
        actionList = self._eca.trueActionList or {}
    else
        actionList = self._eca.falseActionList or {}
    end
    for _, action in pairs(actionList) do
        action:execute()
    end
end

function ECASystem:_buildECA(ecaData)
    local res = {}
    res.eventId = self:_buildEvent(ecaData)
    res.conditionList = self:_buildConditionList(ecaData.conditionList)
    res.trueActionList = self:_buildActionList(ecaData.trueActionList)
    res.falseActionList = self:_buildActionList(ecaData.falseActionList)
    return res
end

function ECASystem:_buildEvent(data)
    return data.eventId
end

function ECASystem:_buildConditionList(conditionList)
    if not conditionList then
        return
    end
    if next(conditionList) == nil then
        return
    end
    local res = {}
    for _, _data in pairs(conditionList) do
        res[#res + 1] = Condition.new(self, _data)
    end
    return res
end

function ECASystem:_buildActionList(actionList)
    if not actionList then
        return
    end
    if next(actionList) == nil then
        return
    end
    local res = {}
    for _, _actionData in pairs(actionList) do
        local action = actionModule.buildAction(_actionData.TYPE, self, _actionData)
        action:_init()
        res[#res + 1] = action
    end
    return res
end
