util = {}

local Color = CS.UnityEngine.Color
local Vector2 = CS.UnityEngine.Vector2

util.ColorRGB = function(r, g, b, a)
    return Color(r / 255, g / 255, b / 255, a)
end


util.randomDecimalInRange = function(min, max, decimalPlaces)
    local rand = math.random()
    local range = max - min
    local scaled = rand * range + min
    local power = 10 ^ decimalPlaces
    return math.floor(scaled * power + 0.5) / power
end

util.angleToVelocity = function(angleDegrees, magnitude)
    local angleRadians = math.rad(angleDegrees)
    local vx = magnitude * math.cos(angleRadians)
    local vy = magnitude * math.sin(angleRadians)

    return Vector2(vx, vy) * magnitude
end

util.calculatePoint = function(center, angleDegrees, distance)
    local angleRadians = math.rad(angleDegrees)

    local newX = center.x + distance * math.cos(angleRadians)
    local newY = center.y + distance * math.sin(angleRadians)

    return Vector2(newX, newY)
end

util.calculateAngleBetween = function(center, vector)
    local dx = vector.x - center.x
    local dy = vector.y - center.y

    local angle = math.atan(dy / dx)

    angle = math.deg(angle)

    if angle < 0 then
        angle = angle + 360
    end

    return angle + 180
end

return util