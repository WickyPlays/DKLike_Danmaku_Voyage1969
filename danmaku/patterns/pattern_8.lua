local pattern = {}
local Vector3 = CS.UnityEngine.Vector3

pattern.beatStart = 164
pattern.beatEnd = 196

local exec = false
local exec_bullets = 30

local function shootBlue()
    local offset = math.random(0, 360) + math.random()

    for i = 1, exec_bullets + 1 do
        local rot = offset + (i * (360 / exec_bullets))
        DSTAGE:GetBulletBuilder()
            :SetBasicParam(boss.GetPosition(), util.angleToVelocity(rot, 1.2), 0.04, 0, 5)
            :WithSprite(danmaku.Get("blue_kunai"))
            :WithRotation(rot + 270)
            :WithAngularVelocity(25)
            :WithRotationSpeed(25)
            :WithSortingOrder(-1)
            :WithDelayFunc(function(b)
                b.Transform.localScale = Vector3(0.15, 0.2, 0.15)
            end, 0)
            :WithUpdateFunc(function(b)
                -- b:SetRotationSpeed(rot + 270)
            end)
            :Build()

        DSTAGE:GetBulletBuilder()
            :SetBasicParam(boss.GetPosition(), util.angleToVelocity(rot, 1.2), 0.04, 0, 5)
            :WithSprite(danmaku.Get("blue_kunai"))
            :WithRotation(rot + 270)
            :WithAngularVelocity(-25)
            :WithRotationSpeed(-25)
            :WithSortingOrder(-1)
            :WithDelayFunc(function(b)
                b.Transform.localScale = Vector3(0.15, 0.2, 0.15)
            end, 0)
            :WithUpdateFunc(function(b)
                -- b:SetRotationSpeed(rot + 270)
            end)
            :Build()
    end
end

pattern.update = function(beat)
    if math.floor(beat) % 2 == 0 then
        if not exec then
            exec = true
            shootBlue()
        end
    else
        exec = false
    end
end

return pattern
