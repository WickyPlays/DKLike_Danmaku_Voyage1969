local pattern = {}
local Vector3 = CS.UnityEngine.Vector3
local Vector2 = CS.UnityEngine.Vector2

pattern.beatStart = 124
pattern.beatEnd = 156

local locs = { Vector2(-4, 4), Vector2(4, 4), Vector2(-4, -1), Vector2(4, -1) }

local exec = false
local exec_bullets = 15

local function shootRed()
    local offset = math.random(0, 360) + math.random()

    for i = 1, exec_bullets + 1 do
        local rot = offset + (i * (360 / exec_bullets))
        for _, loc in ipairs(locs) do
            DSTAGE:GetBulletBuilder()
                :SetBasicParam(loc, util.angleToVelocity(rot, 1), 0.04, 0, 5)
                :WithSprite(danmaku.Get("red_ball"))
                :WithRotation(rot + 270)
                :WithSortingOrder(-1)
                :WithReleaseType(1)
                :WithDelayFunc(function(b)
                    b.Transform.localScale = Vector3(0.2, 0.2, 0.2)
                end, 0)
                :WithUpdateFunc(function(b)
                    -- b:SetRotationSpeed(rot + 270)
                end)
                :Build()
        end
    end
end

pattern.update = function(beat)
    if beat % 2 < 0.1 then
        if not exec then
            exec = true
            shootRed()
        end
    else
        exec = false
    end
end

return pattern
