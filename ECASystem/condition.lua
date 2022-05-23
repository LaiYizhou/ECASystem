
Condition = DefineClass("Condition")

function Condition:ctor(system, data)
    self._ecaSystem = system
    self._data = data
end

function Condition:getValue()
    -- todo
    return true
end
