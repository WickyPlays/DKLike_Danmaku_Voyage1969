local Directory = CS.System.IO.Directory
local Path = CS.System.IO.Path

local modulePatterns = {}
local moduleName = {}

function onloaded()
    util = require("danmaku/util.lua")
    player = require("danmaku/player.lua")
    boss = require("danmaku/boss.lua")
    danmaku = require("danmaku/danmaku.lua")
    stage = require("danmaku/stage.lua")
    flash = require("danmaku/flash.lua")

    local files = Directory.GetFiles(SONGMAN:GetSongDir() .. "/danmaku/patterns", "*.lua")

    --Load all patterns
    for i = 0, files.Length - 1 do
        local file = files[i]
        local fileName = 'danmaku/patterns/' .. Path.GetFileName(file)
        local module = require(fileName)
        table.insert(modulePatterns, module)
        table.insert(moduleName, fileName)
    end

    stage.Setup()
end

function start()
    stage.Start()
    -- boss.Start()
end

function update()
    local beat = GAMESTATE:GetSongBeat()

    stage.Update()

    if boss and boss:GetBoss():GetLifePoint() > 0 then
        for _, pattern in ipairs(modulePatterns) do
            if beat >= pattern.beatStart and beat <= pattern.beatEnd then
                pattern.update(beat)
            end
        end
    end

    if flash then
        flash.flash_update()
    end
end

function finish()
    if flash then
        flash.flash_stop()
    end
end

function ondestroy()
    for _, moduleName in ipairs(moduleName) do
		package.loaded[moduleName] = nil
        _G[moduleName] = nil
	end

    package.loaded['danmaku/util.lua'] = nil
	_G['danmaku/util.lua'] = nil

    package.loaded['danmaku/player.lua'] = nil
    _G['danmaku/player.lua'] = nil

    package.loaded['danmaku/boss.lua'] = nil
    _G['danmaku/boss.lua'] = nil

    package.loaded['danmaku/danmaku.lua'] = nil
    _G['danmaku/danmaku.lua'] = nil

    package.loaded['danmaku/stage.lua'] = nil
    _G['danmaku/stage.lua'] = nil

    package.loaded['danmaku/flash.lua'] = nil
    _G['danmaku/flash.lua'] = nil
end
