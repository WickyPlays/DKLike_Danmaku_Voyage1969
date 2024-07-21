player = {}

local UnityEngine = CS.UnityEngine
local Sprite = UnityEngine.Sprite
local SpriteRenderer = UnityEngine.SpriteRenderer
local GameObject = UnityEngine.GameObject
local Vector2 = UnityEngine.Vector2
local Vector3 = UnityEngine.Vector3

local _Player = nil
local _PlayerSprite = nil

player.GetPlayer = function()
    return _Player
end

player.Setup = function()
    local _HitboxSprite = danmaku.Get("red_ball")

    _Player = DSTAGE:GetPlayer()
    _Player:SetSize(0.125)
    _Player:SetSprite(_HitboxSprite)

    local spriteObj = UnityEngine.Resources.FindObjectsOfTypeAll(typeof(Sprite))
    for i=0,spriteObj.Length - 1 do
		if spriteObj[i].name == "yukkuri" then _YukkuriSprite = spriteObj[i] end
	end

    _PlayerSprite = GameObject("PlayerSprite")
    _PlayerSprite.transform.localPosition = Vector3(0, 0, 0)
    _PlayerSprite.transform.localScale = Vector3(0.4, 0.4, 0.4)
    _PlayerSprite.transform.eulerAngles = Vector3(90, 0, 0)
    _PlayerSprite:SetActive(false)
    local SR = _PlayerSprite:AddComponent(typeof(SpriteRenderer))
    SR.sprite = _YukkuriSprite
end

player.Start = function()
    if _PlayerSprite then
        _PlayerSprite:SetActive(true)
    end
end

player.Update = function()
    if _Player then
        local playerPos = _Player:GetTransform().localPosition
        if _PlayerSprite ~= nil then
            _PlayerSprite.transform.localPosition = playerPos
        end
    end
end

player.Stop = function()
    if _PlayerSprite then
        _PlayerSprite:SetActive(false)
    end
end

player.GetPosition2 = function()
    if _Player == nil then return nil end
    local v3 = _Player:GetTransform().localPosition
    return Vector2(v3.x, v3.z)
end

return player