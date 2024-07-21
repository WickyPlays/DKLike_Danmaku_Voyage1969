local pattern = {}

pattern.beatStart = 67
pattern.beatEnd = 94

local exec5_init = false
local exec5 = false
local exec5_1 = false
local exec5_bullets = 45
local exec5_1_bullets = 6

local Vector2 = CS.UnityEngine.Vector2
local Vector3 = CS.UnityEngine.Vector3
local _bullet_cyankunai = nil
local _bullet_blueball = nil

pattern.update = function(beat)
    if boss.GetBoss():GetLifePoint() <= 0 then return end

    if not exec5_init and beat <= 160 then
        boss.MoveTo(Vector2(0, 3.2), 1)

        _bullet_blueball = danmaku.Get("blue_ball")
        _bullet_cyankunai = danmaku.Get("cyan_kunai")
        exec5_init = true
    end

    if beat >= 54 and beat <= 100 and beat % 1 < 0.1 then
        if not exec5 then
            exec5 = true

            for i = 1, exec5_bullets + 1 do
                local rot = (i * (360 / exec5_bullets))
                DSTAGE:GetBulletBuilder()
                    :SetBasicParam(util.calculatePoint(boss.GetPosition(), rot, 6), util.angleToVelocity(rot + 180, 1), 0.04, 0, 10)
                    :WithSprite(_bullet_cyankunai)
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
        exec5 = false
    end

    if math.floor(beat) % 4 == 0 then
        if not exec5_1 then
            exec5_1 = true

            for i = 1, exec5_1_bullets + 1 do
                local rot = util.calculateAngleBetween(boss.GetPosition(), player.GetPosition2()) + (i * (360 / exec5_1_bullets))
                DSTAGE:GetBulletBuilder()
                    :SetBasicParam(boss.GetPosition(), util.angleToVelocity(rot, 1), 0.85, 2.5, 3)
                    :WithSprite(_bullet_blueball)
                    :WithReleaseType(1)
                    :WithPersistence(true, 0.1)
                    :WithSortingOrder(-1)
                    :WithUpdateFunc(function(b)
                        -- b:SetRotationSpeed(rot + 270)
                    end)
                    :Build()
            end
        end
    else
        exec5_1 = false
    end
end

return pattern