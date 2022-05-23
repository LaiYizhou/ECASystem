
local ecaType = require_ex("ECASystem.ECA_TYPE")
local actionModule = require_ex("ECASystem.action")

OffsetAction = DefineClass("OffsetAction", Action)
actionModule.registerAction(ecaType.OFFSET_ACTION, OffsetAction)
function OffsetAction:_execute()
    local unit = self._argValueDict.unit
    local speed = self._argValueDict.speed
    local targetPos = self._argValueDict.targetPos
    print("### OffsetAction", unit.name, speed, targetPos[1], targetPos[2], targetPos[3])
end
