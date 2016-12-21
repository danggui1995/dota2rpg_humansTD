require('libraries/timers')
require('ability/ability_utils')
require('ability/leiting')
function march_of_the_machines_spawn( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = keys.target:GetAbsOrigin()
	local duration = 2
	local distance = 1800
	local radius = 900
	local collision_radius = 100
	local projectile_speed = 600
	local machines_per_sec = 11
	--local forwardVec = targetLoc - casterLoc
	local forwardVec = caster:GetForwardVector()
	local effectName = keys.effectName
	forwardVec = forwardVec:Normalized()
	
	-- Find backward vector
	local backwardVec = -forwardVec
	backwardVec = backwardVec:Normalized()
	
	-- Find middle point of the spawning line
	local middlePoint = casterLoc + ( radius * backwardVec )
	
	-- Find perpendicular vector
	local v = middlePoint - casterLoc
	local dx = -v.y
	local dy = v.x
	local perpendicularVec = Vector( dx, dy, v.z )
	perpendicularVec = perpendicularVec:Normalized()
	
	-- Create dummy to store data in case of multiple instances are called
	local dummy = OnZhaoHuan( "npc_dummy_caster",caster,caster:GetAbsOrigin(),caster:GetTeamNumber(),-1 )
	dummy.march_of_the_machines_num = 0
	
	-- Create timer to spawn projectile
	Timers:CreateTimer( function()
			-- Get random location for projectile
			local random_distance = RandomInt( -radius, radius )
			local spawn_location = middlePoint + perpendicularVec * random_distance
			
			local velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )
			
			-- Spawn projectiles
			local projectileTable = {
				Ability = ability,
				EffectName = effectName,
				vSpawnOrigin = spawn_location,
				fDistance = distance,
				fStartRadius = collision_radius,
				fEndRadius = collision_radius,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				bProvidesVision = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				vVelocity = velocityVec * projectile_speed
			}
			ProjectileManager:CreateLinearProjectile( projectileTable )
			
			-- Increment the counter
			dummy.march_of_the_machines_num = dummy.march_of_the_machines_num + 1
			
			-- Check if the number of machines have been reached
			if dummy.march_of_the_machines_num == machines_per_sec * duration then
				dummy:Destroy()
				return nil
			else
				return 1 / machines_per_sec
			end
		end
	)
end
function OnYueRenStart( data )
	local ability = data.ability
	local hCaster = data.caster 
	local target = data.target
	local reduce = ability:GetLevelSpecialValueFor("attack_reduce", ability:GetLevel() - 1) or 0
	local num = ability:GetLevelSpecialValueFor("num", ability:GetLevel() - 1)
	local damage = hCaster:GetAttackDamage()*(100-reduce)/100
	local radius = 500
	local delay = 0.1
	local victimTable = {}
	local effectName = data.effectName
	table.insert(victimTable,target)
	if data.soundName then
		EmitSoundOn(data.sound, target)
		
	end
	local damageTable = {
			victim = target,
	        attacker = hCaster,
	        damage = damage,
	        damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(damageTable)
	--[[
	local pts = ParticleManager:CreateParticle(effectName, 
			PATTACH_CUSTOMORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts, 0, victimTable[#victimTable-1]:GetAbsOrigin())
	ParticleManager:SetParticleControl(pts, 1, victimTable[#victimTable]:GetAbsOrigin())]]
	local t_pos = target:GetAbsOrigin()
	if ability then
		ability:SetContextThink("qqq", 
		function()
			OnDgYueRen(effectName,ability,hCaster,t_pos,radius,delay,damage,num-1,victimTable,reduce,data.soundName)
			return nil
		end,delay)
	end
end

function OnDgYueRen( effectName,ability,hCaster,t_pos,radius,delay,damage,nums,victimTable,reduce,sound )
	local targets = FindUnitsInRadius(hCaster:GetTeam(), t_pos, nil,radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, FIND_CLOSEST, false)
	if #targets == 0 then
		return
	end
	if nums == 0 then
		return 
	end
	for i=1,#targets do
		if targets[i] and not MyContains(victimTable,targets[i]) then
			target = targets[i]
			table.insert(victimTable,target)
			if sound then
				EmitSoundOn(sound, target)
			end
			
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
	            damage = damage*(100-reduce)/100,
	            damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(damageTable)
			nums = nums - 1
			t_pos = target:GetAbsOrigin()
			break
		end
	end
	
	if ability then
		ability:SetContextThink("qqq"..nums, 
		function()
			OnDgYueRen(effectName,ability,hCaster,t_pos,radius,delay,damage,nums,victimTable,reduce,sound)
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

function OnQunBu( data )
	local hCaster = data.caster
	local target = data.target
	local ability = data.ability
	local num = 0
	if hCaster.GX then
		num = hCaster.GX
	end
	local damage = (num+15000)*2
	local damageTable = {
		victim = target,
        attacker = hCaster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL
	}
	ApplyDamage(damageTable)
end

function OnLianSuoShanDian( event )
	OnLeitingStart( event )
end

function Turn( event )
	local hCaster = event.caster
	local angle_now = hCaster:GetAnglesAsVector()
	angle_now = angle_now+Vector(0,90,0)
	hCaster:SetAngles(angle_now.x,angle_now.y, angle_now.z)
end

function OnDouShiZhiGuang( event )
	local hCaster = event.caster
	local radius = event.radius
	local ability = event.ability
	local modifierName = event.modifierName
	local duration = event.duration
	if not hCaster.t_pos then
		hCaster.t_pos = hCaster:GetAbsOrigin()
	end
	if not ability:IsFullyCastable() or not ability:GetAutoCastState() then
		return 
	end
	local units = FindUnitsInRadius(hCaster:GetTeam(), hCaster.t_pos, nil,radius,
					DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, FIND_CLOSEST, false)
	for i=1,#units do
		
		if not units[i]:HasModifier(modifierName) and units[i]~=hCaster and not units[i]:IsRealHero() then
			ability:ApplyDataDrivenModifier(hCaster,units[i],modifierName, {duration=duration})
			ability:StartCooldown(ability:GetCooldown(1))
			break 
		end
	end
end

function OnChanRao( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	local modifierName = event.modifierName
	local duration = event.duration_normal
	if target:HasModifier("modifier_common_boss_strong") then
		duration = event.duration_boss
	end
	if ability:IsCooldownReady() and ability:GetAutoCastState() then
		ability:ApplyDataDrivenModifier(hCaster, target, modifierName,{duration=duration})
		ability:StartCooldown(ability:GetCooldown(1))
	end
end

function OnChanRaoZD( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	local modifierName = event.modifierName
	local duration = event.duration_normal
	if target:HasModifier("modifier_common_boss_strong") then
		duration = event.duration_boss
	end
	ability:ApplyDataDrivenModifier(hCaster, target, modifierName,{duration=duration})
end

function OnBuZhuo( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = event.duration_basic
	local modifierName = event.modifierName
	if target:HasModifier("modifier_common_boss_strong") then
		duration = event.duration_hero
	end
	ability:ApplyDataDrivenModifier(hCaster, target, modifierName,{duration=duration})
end

function OnBanYZ( event )
	local hCaster = event.caster
	local ability = event.ability
	local distance = event.distance
	local particleName = "particles/generic_gameplay/generic_manaburn.vpcf"
	local cleave = event.cleave
	local forwardVec = hCaster:GetForwardVector():Normalized()
	local post = hCaster:GetAbsOrigin()+forwardVec*distance
	
	local damage = hCaster:GetAttackDamage()*cleave/100

	local units = FindUnitsInLine(hCaster:GetTeam(),hCaster:GetAbsOrigin(),post,nil,distance,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL , 0)

	for i=1,#units do
		local pts = ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN_FOLLOW,units[i])
		ParticleManager:SetParticleControl(pts,0,units[i]:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pts)
		local damageTable = {
			victim = units[i],
	        attacker = hCaster,
	        damage = damage,
	        damage_type = DAMAGE_TYPE_PURE
		}
		ApplyDamage(damageTable)
	end
	
end

function OnXueRuo( event )
    local hCaster = event.caster
    local ability = event.ability 
    local radius = event.radius
    local posc = hCaster:GetAbsOrigin()
    local modifierName = "modifier_gxability_lieren2"
    local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,0,FIND_CLOSEST,false)
	for i=1,#targets do
		if not targets[i]:HasModifier(modifierName) then
			if ability:IsFullyCastable() and ability:GetAutoCastState() then
		        local _order =
		        {
		            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		            UnitIndex = hCaster:entindex(),
		            TargetIndex = targets[i]:entindex(),
		            AbilityIndex = ability:entindex()
		        }
		        hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
		    end
		    return
		end
	end
end