local pattern = {}
local Vector2 = CS.UnityEngine.Vector2
local Vector3 = CS.UnityEngine.Vector3

pattern.beatStart = 3
pattern.beatEnd = 33

local exec = false
local exec2 = false
local exec_bullets = 45
local exec_bullets_2 = 10

local function shootBlue()
    local loc = Vector2(math.random(-3, 3) + math.random(), util.randomDecimalInRange(3, 3.5, 2))
    for i = 1, exec_bullets_2 + 1 do
        local rot = i * (360 / exec_bullets_2)
        DSTAGE:GetBulletBuilder()
            :SetBasicParam(loc, util.angleToVelocity(rot, 1.2), 0.04, 0, 10)
            :WithSprite(danmaku.Get("blue_ball"))
            :WithRotation(rot + 270)
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
    local _bullet = danmaku.Get("lime_kunai")

    if beat % 2 < 0.1 then
        if not exec then
            exec = true
            local rand = math.random(0, 45) + math.random()
            for i = 1, exec_bullets + 1 do
                local rot = (i * (360 / exec_bullets)) + rand
                DSTAGE:GetBulletBuilder()
                    :SetBasicParam(util.calculatePoint(boss.GetPosition(), rot, 6), util.angleToVelocity(rot + 180, 1),
                        0.04, 0, 10)
                    :WithSprite(_bullet)
                    :WithRotation(rot - 270)
                    :WithReleaseType(1)
                    :WithLifeTime(3)
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

    if beat >= 3 and beat % 2 < 0.1 then
        if not exec2 then
            exec2 = true
            shootBlue()
        end
    else
        exec2 = false
    end
end

return pattern
