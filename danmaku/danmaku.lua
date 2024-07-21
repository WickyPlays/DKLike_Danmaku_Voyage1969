danmaku = {}

local bullets = {}

danmaku.Setup = function()
    local _hitboxTex = UTIL:LoadTexture("danmaku/bullets/red_ball.png")
    local _hitboxSprite = UTIL:CreateSprite(_hitboxTex)

    bullets["red_ball"] = _hitboxSprite
    bullets["cyan_kunai"] = UTIL:CreateSprite(UTIL:LoadTexture("danmaku/bullets/kunai_cyan.png"))
    bullets["blue_ball"] = UTIL:CreateSprite(UTIL:LoadTexture("danmaku/bullets/blue_ball.png"))
    bullets["lime_kunai"] = UTIL:CreateSprite(UTIL:LoadTexture("danmaku/bullets/kunai_lime.png"))
    bullets["red_kunai"] = UTIL:CreateSprite(UTIL:LoadTexture("danmaku/bullets/kunai_red.png"))
    bullets["blue_kunai"] = UTIL:CreateSprite(UTIL:LoadTexture("danmaku/bullets/kunai_blue.png"))
    bullets["purple_kunai"] = UTIL:CreateSprite(UTIL:LoadTexture("danmaku/bullets/kunai_purple.png"))
    bullets["blue_shuriken"] = UTIL:CreateSprite(UTIL:LoadTexture("danmaku/bullets/shuriken_blue.png"))

end

danmaku.Get = function(name)
    return bullets[name]
end

return danmaku