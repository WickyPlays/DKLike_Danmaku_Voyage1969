local pattern = {}
local Vector3 = CS.UnityEngine.Vector3
local Vector2 = CS.UnityEngine.Vector2

pattern.beatStart = 114
pattern.beatEnd = 156

local exec = false
local exec_bullets = 15

local function shoot()
    local offset = math.random(0, 360) + math.random()

    for i = 1, exec_bullets + 1 do
        local rot = offset + (i * (360 / exec_bullets))
        DSTAGE:GetBulletBuilder()
            :SetBasicParam(boss.GetPosition(), util.angleToVelocity(rot, 1.1), 0.04, 0, 10)
            :WithSprite(danmaku.Get("blue_ball"))
            :WithRotation(rot + 270)
            :WithSortingOrder(-1)
            :WithDelayFunc(function(b)
                b.Transform.localScale = Vector3(0.3, 0.3, 0.3)
            end, 0)
            :WithUpdateFunc(function(b)
                -- b:SetRotationSpeed(rot + 270)
            end)
            :Build()
    end
end

pattern.update = function(beat)
    if beat % 4 < 0.1 then
        if not exec then
            exec = true
            shoot()
        end
    else
        exec = false
    end
end

return pattern
