-- string模块的扩展函数

local string = string
local string_find = string.find
local string_gsub = string.gsub
local string_upper = string.upper
local string_sub = string.sub
local table_insert = table.insert
local string_byte = string.byte
local string_char = string.char
local string_format = string.format
local string_len = string.len
local string_lower = string.lower
local tonumber = tonumber
local tostring = tostring
local tblConcat = table.concat

function string.trim(str)
    str = string.gsub(str, "^[ \t\n\r]+", "")
    return string.gsub(str, "[ \t\n\r]+$", "")
end

function string.utf8len(input)
    local len = string.len(input)
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

local function chsize(char)
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}

    if not char then
        print("not char")
        return 0
    else
        for i = #arr, 1, -1 do
            if char >= arr[i] then
                return i
            end
        end
    end
end

function string.utf8sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + chsize(char)
        startChar = startChar - 1
    end
    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        numChars = numChars -1
    end
    return str:sub(startIndex, currentIndex - 1)
end

function string.random(length)
    local bytes = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"
    if length > 0 then
        local ret = ""
        local i = 1
        local len, math_random, stringChar, stringByte = #bytes, math.random, string.char, string.byte
        while i <= length do
            ret = ret .. stringChar(stringByte(bytes, math_random(1, len)))
            i = i + 1
        end
        return ret
    else
        return ""
    end
end

local strFormatFunc = string.format

function string.formatExt(str, ...)
    local idx = 1
    local paramList = {...}
    local newParamList = {}
    local origin = str
    str = str:gsub("{(%d+):(%%.-)}",
        function(x, y)
            x = tonumber(x)
            newParamList[idx] = paramList[x]
            idx = idx + 1
            return y
        end)

    if #paramList ~= #newParamList then
        return strFormatFunc(origin, ...)
    else
        return strFormatFunc(str, unpack(newParamList))
    end
end

function string.notNilOrEmpty(str)
    return str and string.len(str) > 0
end

function string.lcfirst(input)
    return string_lower(string_sub(input, 1, 1)) .. string_sub(input, 2)
end

function string.starts(str, startStr)
   return string_sub(str,1,string_len(startStr))==startStr
end

function string.ends(str, endStr)
    return endStr == '' or string_sub(str,-string_len(endStr))==endStr
end


string._htmlspecialchars_set = {}
string._htmlspecialchars_set["&"] = "&amp;"
string._htmlspecialchars_set["\""] = "&quot;"
string._htmlspecialchars_set["'"] = "&#039;"
string._htmlspecialchars_set["<"] = "&lt;"
string._htmlspecialchars_set[">"] = "&gt;"

function string.htmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string_gsub(input, k, v)
    end
    return input
end

function string.restorehtmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string_gsub(input, v, k)
    end
    return input
end

function string.nl2br(input)
    return string_gsub(input, "\n", "<br />")
end

function string.text2html(input)
    input = string_gsub(input, "\t", "    ")
    input = string.htmlspecialchars(input)
    input = string_gsub(input, " ", "&nbsp;")
    input = string.nl2br(input)
    return input
end

function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    while true do
        local st, sp = string_find(input, delimiter, pos, true)
        if not st then
            break
        end
        table_insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end

    table_insert(arr, string.sub(input, pos))
    return arr
end

function string.ltrim(input)
    return string_gsub(input, "^[ \t\n\r]+", "")
end

function string.rtrim(input)
    return string_gsub(input, "[ \t\n\r]+$", "")
end

function string.trim(input)
    input = string_gsub(input, "^[ \t\n\r]+", "")
    return string_gsub(input, "[ \t\n\r]+$", "")
end

function string.ucfirst(input)
    return string_upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end

local function urlencodechar(char)
    return "%" .. string_format("%02X", string_byte(char))
end
function string.urlencode(input)
    -- convert line endings
    input = string_gsub(tostring(input), "\n", "\r\n")
    -- escape all characters but alphanumeric, '.' and '-'
    input = string_gsub(input, "([^%w%.%- ])", urlencodechar)
    -- convert spaces to "+" symbols
    return string_gsub(input, " ", "+")
end

local function checknumber(value, base)
    return tonumber(value, base) or 0
end
function string.urldecode(input)
    input = string_gsub (input, "+", " ")
    input = string_gsub (input, "%%(%x%x)", function(h) return string_char(checknumber(h,16)) end)
    input = string_gsub (input, "\r\n", "\n")
    return input
end

function string.setchar(input, index, char)
    return string.sub(input, 1, index - 1) .. char .. string.sub(input, index + 1, string.len(input))
end


function string.formatnumberthousands(num)
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string_gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end


function string.mongoEscape(input)
    return input:gsub("%$", "\xFF\x04"):gsub("%.", "\xFF\x0E")
end

function string.mongoUnescape(input)
    return input:gsub("\xFF\x04", "$"):gsub("\xFF\x0E", ".")
end

--- 有低概率玩家sdkuid里也包含@字符，需要考虑这种情况
-- @param input string, unisdk认证后返回的accountId
-- @return sdkuid, platform，是2个返回值
function string.parseEmailAddress(input)
    local strs = input:split("@")
    local sdkuid = tblConcat(strs, "@", 1, #strs - 1)
    local platform = strs[#strs]
    return sdkuid, platform
end

function string.isEmpty(input)
    return input == nil or input == ""
end