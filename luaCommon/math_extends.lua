-- math库的扩展

local math = math
local math_floor = math.floor
local math_ceil = math.ceil

function math.clamp(val, lower, upper)
    assert(val and lower and upper, "any parameter is nil")
    if lower > upper then
        lower, upper = upper, lower
    end
    return math.max(lower, math.min(upper, val))
end

function math.round(val)
    return val >= 0 and math_floor(val + .5) or math_ceil(val - .5)
end

function math.round5(val)
    return math.floor(val * 100000 + 0.5) / 100000
end

function math.sign(val)
    return val > 0 and 1 or -1
end