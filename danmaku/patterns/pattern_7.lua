local pattern = {}
local Vector3 = CS.UnityEngine.Vector3
local Vector2 = CS.UnityEngine.Vector2

pattern.beatStart = 133
pattern.beatEnd = 156

local locs = { Vector2(-4, 4), Vector2(4, 4), Vector2(-4, -1), Vector2(4, -1) }

local exec = false
local exec_bullets = 15

local function shoot()
    local offset = math.random(0, 360) + math.random()
    for i = 1, exec_bullets + 1 do
        local rot = offset + (i * (360 / exec_bullets))
        DSTAGE:GetBulletBuilder()
            :SetBasicParam(Vector2(0, -1.5), util.angleToVelocity(rot, 1), 0.04, 0, 5)
            :WithSprite(danmaku.Get("lime_kunai"))
            :WithRotation(rot + 270)
            :WithReleaseType(1)
            :WithSortingOrder(-1)
            :WithDelayFunc(function(b)
                b.Transform.localScale = Vector3(0.15, 0.2, 0.15)
            end, 0)
            :Build()
    end
end

pattern.update = function(beat)
    if beat % 1 < 0.1 then
        if not exec then
            exec = true
            shoot()
        end
    else
        exec = false
    end
end

return pattern
