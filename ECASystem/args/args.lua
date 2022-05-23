
local ecaType = require_ex("ECASystem.ECA_TYPE")
local argModule = require_ex("ECASystem.arg")

SkillOwnerArg = DefineClass("SkillOwnerArg", Arg)
argModule.registerArg(ecaType.SKILL_OWNER_ARG, SkillOwnerArg)
function SkillOwnerArg:_getValue()
    return self._ecaSystem.owner.owner
end

PuppetOfUnitArg = DefineClass("PuppetOfUnitArg", Arg)
argModule.registerArg(ecaType.PUPPET_OF_UNIT_ARG, PuppetOfUnitArg)
function PuppetOfUnitArg:_getValue()
    return self._ecaSystem.owner.owner.puppet
end


Vector3ConstArg = DefineClass("Vector3ConstArg", Arg)
argModule.registerArg(ecaType.VECTOR3_CONST_ARG, Vector3ConstArg)
function Vector3ConstArg:_getValue()
    return { self._argValueDict.x, self._argValueDict.y, self._argValueDict.z }
end

Vector3AddArg = DefineClass("Vector3AddArg", Arg)
argModule.registerArg(ecaType.VECTOR3_ADD_ARG, Vector3AddArg)
function Vector3AddArg:_getValue()
    local leftValue = self._argValueDict.leftVal
    local rightValue = self._argValueDict.rightVal
    return { leftValue[1] + rightValue[1], leftValue[2] + rightValue[2], leftValue[3] + rightValue[3] }
end

PositionOfUnitArg = DefineClass("PositionOfUnitArg", Arg)
argModule.registerArg(ecaType.POSITION_OF_UNIT_ARG, PositionOfUnitArg)
function PositionOfUnitArg:_getValue()
    local unit = self._argValueDict.unit
    return unit.position
end

FloatConstArg = DefineClass("FloatConstArg", Arg)
argModule.registerArg(ecaType.FLOAT_CONST_ARG, FloatConstArg)
function FloatConstArg:_getValue()
    return self._argValueDict.val
end


SkillSelfArg = DefineClass("SkillSelfArg", Arg)
argModule.registerArg(ecaType.SKILL_SELF_ARG, SkillSelfArg)
function SkillSelfArg:_getValue()
    return self._ecaSystem.owner
end




