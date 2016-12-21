music_table={
	{"ent_gw_csd1","bgm.dahanzhiqi",86.0,true},
	{"ent_gw_csd1","bgm.tianlongbabu",147.0,true},
	{"ent_gw_csd1","bgm.jianbanuzhang",52.0,true},
	{"ent_gw_csd1","bgm.moshui",236.0,true},
	{"ent_gw_csd1","bgm.zhaoyunchuji",118.0,true},
	{"ent_gw_csd1","bgm.emocheng",52.0,true},
	{"ent_gw_csd1","bgm.zhongzhuangjibing",132.0,true}
}
GameRules.bgm_index = RandomInt(1,7)
GameRules.bgm_switch = false
function InitBackGroundMusic()
	local v = music_table[GameRules.bgm_index]
	local ent = Entities:FindByName(nil, v[1])
	if ent ~= nil then
		ent:SetContextThink(v[1],
			function ()
				v = music_table[GameRules.bgm_index]
				EmitSoundOn(v[2],ent)
				if v[4] then
					if GameRules.bgm_index == #music_table then
						GameRules.bgm_index = 1
					else
						GameRules.bgm_index = (GameRules.bgm_index + 1)
					end
					return v[3]
				else
					return nil
				end
			end, 
		0.1)
	end
end

function EmitSoundBackGroundMusic(strMusic)
	for k,v in ipairs(music_table) do
		if v[1] == strMusic then
			local ent = Entities:FindByName(nil, v[1])
			if ent ~= nil then
				ent:SetContextThink(v[1],
					function ()
						EmitSoundOn(v[2],ent)
						v[4] = true
						return v[3]
					end, 
				0.1)
			end
		end
	end
end

function PlayBGM()
	if not GameRules.bgm_switch then
		GameRules.bgm_switch = true
		local v = music_table[GameRules.bgm_index]
		local ent = Entities:FindByName(nil, v[1])
		if ent ~= nil then
			ent:SetContextThink(v[1],
				function ()
					if not GameRules.bgm_switch then
						return nil
					end
					v = music_table[GameRules.bgm_index]
					EmitSoundOn(v[2],ent)

					if v[4] then
						if GameRules.bgm_index == #music_table then
							GameRules.bgm_index = 1
						else
							GameRules.bgm_index = (GameRules.bgm_index + 1)
						end
						return v[3]
					else
						return nil
					end
				end, 
			0.1)
		end
	end
end

function StopBGM(  )
	if GameRules.bgm_switch then
		GameRules.bgm_switch = false
		--StopSoundBackGroundMusic(music_table[GameRules.bgm_index][2])
		for k,v in pairs(music_table) do
			local ent = Entities:FindByName(nil, v[1])
			if ent ~= nil then
				StopSoundOn(v[2],ent)
				--[[
				ent:SetContextThink(v[1],
					function ()
						StopSoundOn(v[2],ent)
						v[4] = false
						return nil
					end, 
				0.1)]]
			end
		end
	end
	
end


function StopSoundBackGroundMusic(strMusic)
	for k,v in ipairs(music_table) do
		if v[1] == strMusic then
			local ent = Entities:FindByName(nil, v[1])
			if ent ~= nil then
				ent:SetContextThink(v[1],
					function ()
						StopSoundOn(v[2],ent)
						v[4] = false
						return nil
					end, 
				0.1)
			end
		end
	end
end
