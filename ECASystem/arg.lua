Arg = DefineClass("Arg")

function Arg:ctor(system, key, data)
    self._ecaSystem = system
    self._key = key
    self._data = data
    self._argValueDict = {}
    self._argDict = {}
end

function Arg:getValue()
    self:_calcArgValue()
    return self:_getValue()
end

function Arg:_getIndent(count)
    local res = {}
    for i = 1, count do
        res[#res +  1] = "\t"
    end
    return table.concat(res, " ")
end

function Arg:_init()
    for key, data in pairs(self._data) do
        if key ~= "TYPE" then
            print(self:_getIndent(self.indent), "### init()", self._key, self.__cname)
            if type(data) ~= "table" or data.TYPE == nil then
                self._argDict[key] = self
                self._argValueDict[key] = data
            else
                local _arg = buildArg(data.TYPE, self._ecaSystem, key, data)
                _arg.indent = self.indent + 1
                _arg:_init()
                self._argDict[key] = _arg
            end
        end
    end
end

function Arg:_calcArgValue()
    for key, arg in pairs(self._argDict) do
        if not self._argValueDict[key] then
            local _value = arg:getValue()
            print(self:_getIndent(self.indent), "### _calcArgValue()", key, arg.__cname, table.tostring(_value))
            self._argValueDict[key] = _value
        end
    end
end

local argClassDic = {}
function registerArg(type, classModule)
    argClassDic[type] = classModule
end

function buildArg(type, system, key, data)
    local module = argClassDic[type]
    local _arg = module.new(system, key, data)
    return _arg
end
