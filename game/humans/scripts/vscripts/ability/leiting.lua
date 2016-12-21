
function OnLeitingStart( data )
	local ability = data.ability
	local hCaster = data.caster 
	local target = data.target
	local level = ability:GetLevel()
	local soundName = data.soundName or "Item.Maelstrom.Chain_Lightning"
	local damage = ability:GetLevelSpecialValueFor("chain_damage", level - 1) or 0
	local reduce = ability:GetLevelSpecialValueFor("chain_reduce", level - 1) or 0
	reduce = reduce or 0
	local radius = ability:GetLevelSpecialValueFor("chain_radius", level - 1) or 900
	local delay = ability:GetLevelSpecialValueFor("chain_delay", level - 1) or 0.25
	local victimTable = {}
	local nums = ability:GetLevelSpecialValueFor("chain_strikes", level - 1) or 0
	local effectName = data.effectName
	if not hCaster or not hCaster:IsAlive() then
		return
	end
	table.insert(victimTable,hCaster)
	table.insert(victimTable,target)
	EmitSoundOn(soundName, target)
	local damageTable = {
		victim = target,
        attacker = hCaster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
	}
	ApplyDamage(damageTable)
	damage = damage*(1-reduce)
	local pts = ParticleManager:CreateParticle(effectName, 
			PATTACH_CUSTOMORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts, 0, victimTable[#victimTable-1]:GetAbsOrigin())
	ParticleManager:SetParticleControl(pts, 1, victimTable[#victimTable]:GetAbsOrigin())
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
			function()
				ParticleManager:DestroyParticle(pts,true)
			end,1)
	ability:StartCooldown(level)
	local t_pos = target:GetAbsOrigin()
	if ability then
		ability:SetContextThink("qqq", 
		function()
			OnDgLeiting(effectName,ability,hCaster,t_pos,radius,delay,damage,nums-1,victimTable,reduce)
			return nil
		end,delay)
	end
end

function OnDgLeiting( effectName,ability,hCaster,t_pos,radius,delay,damage,nums,victimTable,reduce )
	local targets = FindUnitsInRadius(hCaster:GetTeam(), t_pos, nil,radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, FIND_CLOSEST, false)
	if #targets == 0 then
		return
	end
	if not hCaster or not hCaster:IsAlive() then
		return
	end
	if nums == 0 then
		return 
	end
	for i=1,#targets do
		if targets[i] and not MyContains(victimTable,targets[i]) then
			target = targets[i]
			table.insert(victimTable,target)
			EmitSoundOn("Item.Maelstrom.Chain_Lightning.Jump", target)
			local pts = ParticleManager:CreateParticle(effectName, 
				PATTACH_CUSTOMORIGIN,hCaster)
			ParticleManager:SetParticleControl(pts, 0, victimTable[#victimTable-1]:GetAbsOrigin())
			ParticleManager:SetParticleControl(pts, 1, victimTable[#victimTable]:GetAbsOrigin())
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
			function()
				ParticleManager:DestroyParticle(pts,true)
			end,1)
			local damageTable = {
				victim = target,
	            attacker = hCaster,
	            damage = damage,
	            damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(damageTable)
			nums = nums - 1
			local t_pos = target:GetAbsOrigin()
			break
		end
	end
	
	if ability then
		ability:SetContextThink("qqq"..nums, 
		function()
			OnDgLeiting(effectName,ability,hCaster,t_pos,radius,delay,damage*(1-reduce),nums,victimTable,reduce)
			return nil
		end,delay)
	end
end

function MyContains( myTable,myValue )
	for i,v in ipairs(myTable) do
		if v == myValue then
			return true
		end
	end
	return false
end