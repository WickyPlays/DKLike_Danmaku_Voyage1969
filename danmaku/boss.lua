boss = {}

boss.MAX_HP = 51000
boss.HP = boss.MAX_HP
boss.NAME = "Eirin"
boss.RING_SPEED = 2
boss.RING_OPACITY = .7
boss.SIZE = .25
local _Enemy = nil

local UnityEngine = CS.UnityEngine
local Vector2 = UnityEngine.Vector2
local Vector3 = UnityEngine.Vector3
local GameObject = UnityEngine.GameObject
local SpriteRenderer = UnityEngine.SpriteRenderer

local _enemyRingSprite = nil
local SRE = nil
local _enemyRingOpened = false
local _enemyRingSize = .7
local _enemyRingTime = .8

boss.GetBoss = function()
    return _Enemy
end

boss.Setup = function()
    _Enemy = DSTAGE:GetEnemy()
    _Enemy:SetCharacter(26) --Eirin
    _Enemy:SetMaxLifePoint(boss.MAX_HP)
    _Enemy:SetLifePoint(boss.MAX_HP)
    _Enemy:SetSize(boss.SIZE)

    --Center boss
    _Enemy:SetPosition(Vector2(0, 3.5))

    --Building ring
    local ringTex = UTIL:LoadTexture("danmaku/textures/Enemy_Ring.png")
    local enemyPos = _Enemy:GetTransform().localPosition
    _enemyRingSprite = GameObject("EnemyRingSprite")
    _enemyRingSprite.transform.localPosition = Vector3(enemyPos.x, 0, enemyPos.y)
    _enemyRingSprite.transform.localScale = Vector3(0, 0, 0)
    _enemyRingSprite.transform.eulerAngles = Vector3(90, 0, 0)
    _enemyRingSprite:SetActive(true)
    SRE = _enemyRingSprite:AddComponent(typeof(SpriteRenderer))
    SRE.sprite = UTIL:CreateSprite(ringTex)
    SRE.color = util.ColorRGB(255, 255, 255, 0)
end

boss.Start = function()
    if SRE then
        SRE.color = util.ColorRGB(255, 74, 74, boss.RING_OPACITY)
    end
end

boss.Update = function()
    if _enemyRingSprite and _Enemy then
        _enemyRingSprite.transform.localPosition = _Enemy:GetTransform().localPosition
        _enemyRingSprite.transform.eulerAngles = _enemyRingSprite.transform.eulerAngles + Vector3(0, boss.RING_SPEED, 0)
    end

    if _Enemy then
        boss.UpdateBossBar(_Enemy:GetLifePoint(), boss.MAX_HP)

        if _Enemy:GetLifePoint() <= 0 then
            boss.Kill()
        end
    end
end

boss.Stop = function()
    if SRE then
        SRE.color = util.ColorRGB(255, 74, 74, 0)
    end
end

boss.UpdateBossBar = function(currHP, maxHP)
    if _BossBarFill ~= nil then
        _BossBarFill.transform.anchorMax = Vector2(currHP / maxHP, 1)
    end
end

boss.Damage = function(hp)
    boss.HP = boss.HP - hp
end

boss.Kill = function()

end

boss.GetPosition = function()
    if _Enemy == nil then return nil end
    local v3 = _Enemy:GetTransform().localPosition
    return Vector2(v3.x, v3.z)
end

boss.MoveTo = function(v2, delay)
    if _Enemy == nil then return end
    _Enemy:GetTransform():DOLocalMove(Vector3(v2.x, 0, v2.y), delay)
end


boss.OpenEnemyRing = function()
    if _enemyRingSprite == nil then return end
    if _enemyRingOpened then return end
    _enemyRingOpened = true
    _enemyRingSprite.transform.localScale = Vector3(0, 0, 0)
    _enemyRingSprite.transform:DOScale(Vector3(_enemyRingSize, _enemyRingSize, _enemyRingSize), _enemyRingTime):SetEase(
        CS.DG
        .Tweening.Ease.InOutQuad)
end

boss.CloseEnemyRing = function()
    if _enemyRingSprite == nil then return end
    if not _enemyRingOpened then return end
    _enemyRingOpened = false
    _enemyRingSprite.transform.localScale = Vector3(_enemyRingSize, _enemyRingSize, _enemyRingSize)
    _enemyRingSprite.transform:DOScale(Vector3(0, 0, 0), _enemyRingTime):SetEase(CS.DG.Tweening.Ease.InOutQuad)
end

return boss