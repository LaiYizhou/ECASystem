local argModule = require_ex("ECASystem.arg")

Action = DefineClass("Action")

function Action:ctor(system, data)
    self._ecaSystem = system
    self._data = data
    self._argValueDict = {}
    self._argDict = {}
end

function Action:execute()
    self:_calcArgValue()
    self:_execute()
end

function Action:_init()
    for key, data in pairs(self._data) do
        if key ~= "TYPE" then
            if type(data) ~= "table" or data.TYPE == nil then
                self._argDict[key] = data
                self._argValueDict[key] = data
            else
                local _arg = argModule.buildArg(data.TYPE, self._ecaSystem, key, data)
                _arg.indent = 0
                _arg:_init()
                self._argDict[key] = _arg
            end
        end
    end
end

function Action:_calcArgValue()
    for key, arg in pairs(self._argDict) do
        local _val = arg:getValue()
        self._argValueDict[key] = _val
    end
end

local ActionClassDic = {}
function registerAction(type, classModule)
    ActionClassDic[type] = classModule
end

function buildAction(type, system, data)
    local module = ActionClassDic[type]
    local _action = module.new(system, data)
    return _action
end