local pattern = {}
local Vector3 = CS.UnityEngine.Vector3

pattern.beatStart = 35
pattern.beatEnd = 64

local exec = false
local exec_bullets = 45

local trigOnce = false
local trigOnce2 = false

local function shootRed()
    for i = 1, exec_bullets + 1 do
        local rot = util.calculateAngleBetween(boss.GetPosition(), player.GetPosition2()) + (i * (360 / exec_bullets))
        DSTAGE:GetBulletBuilder()
            :SetBasicParam(boss.GetPosition(), util.angleToVelocity(rot, 1.2), 0.04, 0, 10)
            :WithSprite(danmaku.Get("red_kunai"))
            :WithRotation(rot + 270)
            :WithSortingOrder(-1)
            :WithDelayFunc(function(b)
                b.Transform.localScale = Vector3(0.15, 0.25, 0.15)
            end, 0)
            :WithUpdateFunc(function(b)
                -- b:SetRotationSpeed(rot + 270)
            end)
            :Build()
    end
end

pattern.update = function(beat)
    local _bullet = danmaku.Get("lime_kunai")

    if beat % 1 < 0.1 then
        if not exec then
            exec = true
            local rand = math.random(0, 45) + math.random()
            for i = 1, exec_bullets + 1 do
                local rot = (i * (360 / exec_bullets)) + rand
                DSTAGE:GetBulletBuilder()
                    :SetBasicParam(util.calculatePoint(boss.GetPosition(), rot, 6), util.angleToVelocity(rot + 180, 1.15),
                        0.04, 0, 10)
                    :WithSprite(_bullet)
                    :WithRotation(rot - 270)
                    :WithReleaseType(1)
                    :WithLifeTime(2.4)
                    :WithSortingOrder(-5)
                    :WithDelayFunc(function(b)
                        b.Transform.localScale = Vector3(0.15, 0.25, 0.15)
                    end, 0)
                    :WithUpdateFunc(function(b)
                        -- b:SetRotationSpeed(rot + 270)
                    end)
                    :Build()
            end
        end
    else
        exec = false
    end

    if beat >= 52 and not trigOnce then
        shootRed()
        trigOnce = true
    end

    if beat >= 60 and not trigOnce2 then
        shootRed()
        trigOnce2 = true
    end
end

return pattern
