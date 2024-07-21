local pattern = {}

pattern.beatStart = 31
pattern.beatEnd = 500

pattern.update = function(beat)
    if beat >= 300 then
        boss.CloseEnemyRing()
    else
        boss.OpenEnemyRing()
    end
end

return pattern