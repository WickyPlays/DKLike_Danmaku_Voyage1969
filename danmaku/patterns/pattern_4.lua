local pattern = {}
local Vector3 = CS.UnityEngine.Vector3

pattern.beatStart = 99
pattern.beatEnd = 159

local exec = false
local exec_bullets = 10

local function shootShuriken()
    for i = 1, exec_bullets + 1 do
        local rot = util.calculateAngleBetween(boss.GetPosition(), player.GetPosition2()) + (i * (360 / exec_bullets))
        DSTAGE:GetBulletBuilder()
            :SetBasicParam(boss.GetPosition(), util.angleToVelocity(rot, 1.2), 0.04, 0, 10)
            :WithSprite(danmaku.Get("blue_shuriken"))
            :WithRotation(rot + 270)
            :WithRotationSpeed(-270)
            :WithSortingOrder(-1)
            :WithDelayFunc(function(b)
                b.Transform.localScale = Vector3(0.15, 0.15, 0.15)
            end, 0)
            :WithUpdateFunc(function(b)
                -- b:SetRotationSpeed(rot + 270)
            end)
            :Build()
    end
end

pattern.update = function(beat)
    if beat % 1 < 0.1 then
        if not exec then
            exec = true
            shootShuriken()
        end
    else
        exec = false
    end
end

return pattern
