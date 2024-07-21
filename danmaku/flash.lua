local Time = CS.UnityEngine.Time
local Color = CS.UnityEngine.Color

flash = {}

local screen
local startValue
local targetValue
local tweenDuration
local currentValue
local timer = 0
local inited = false

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function lerp(startValue, endValue, t)
    return startValue * (1 - t) + endValue * t
end

local function Flash_ColorRGB(r, g, b, a)
    return Color(r / 255, g / 255, b / 255, a)
end

flash.flash_new = function(nscreen, nstartValue, ntargetValue, ntweenDuration)
    inited = true
    screen = nscreen
    startValue = nstartValue
    targetValue = ntargetValue
    tweenDuration = ntweenDuration
    currentValue = nstartValue
    timer = 0
end

flash.flash_update = function()
    if not inited then return end

    timer = timer + Time.deltaTime
    local t = clamp(timer / tweenDuration, 0, 1)
    currentValue = lerp(startValue, targetValue, t)

    if timer >= tweenDuration then
        currentValue = targetValue
    end
    
    screen.color = Flash_ColorRGB(255, 255, 255, currentValue)
end

flash.flash_stop = function()
    screen = nil
    startValue = nil
    targetValue = nil
    tweenDuration = nil
    currentValue = nil
    timer = 0
    inited = false
end

return flash
