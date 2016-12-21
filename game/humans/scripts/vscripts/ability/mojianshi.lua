require('ability/leiting')
require('utils/msg')
require('libraries/timers')
require('libraries/physics')
require('ability/ability_utils')
function OnJianShuFaShe( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local particle_fissure = event.particle_fissure
	local center = target:GetAbsOrigin()
	local distance = ability:GetLevelSpecialValueFor("deep", ability:GetLevel()-1)
	local radius = ability:GetLevelSpecialValueFor("radius",ability:GetLevel()-1)
	local forward_v = (center-hCaster:GetAbsOrigin()):Normalized()
	OnLinePro(forward_v,particle_fissure,center,hCaster,radius,radius,2000,ability,distance)
end

function OnJianShuDamage( event )
	local target = event.target
	local hCaster = event.caster
	local damage = hCaster:GetAttackDamage()
	local damageTable = 
    {
        victim = target,    --受到伤害的单位
        attacker = hCaster,          --造成伤害的单位
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL
    }
    local num = ApplyDamage(damageTable)
end

function OnNiHongThunder( event )
	local hCaster = event.caster
	local ability = event.ability
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	if hCaster:GetMana()==7 then
		OnLeitingStart(event)
		hCaster:SpendMana(7, ability)
	end
end

function OnLingGuang( event )
	local hCaster = event.caster
	local ability = event.ability
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	if hCaster:GetMana()==7 then
		local forward_v = (hCaster:GetForwardVector():Normalized())
		OnLinePro(forward_v,event.effectName,hCaster:GetAbsOrigin(),hCaster,event.radius,event.radius,700,ability,2000)
		hCaster:SpendMana(7, ability)
	end
end



function OnLongPaoJiShe( event )
	local ability = event.ability
	local hCaster = event.caster
	local target = event.target
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	local point = target:GetAbsOrigin()
	if hCaster:GetMana()==10 then
		local radius = event.radius
	    local particle_fissure = event.effectName
	    local center = hCaster:GetAbsOrigin()
	    local movespeed = 700
	    local biaoji = 1
	    hCaster:SetContextThink("longpaojishe", 
	    function()
	        if not hCaster or not hCaster:IsAlive() then
	            return nil
	        end
	               
	        if biaoji > 9 then
	            return nil
	        end
	        local tpoint = point+RandomVector(radius)
	        local distance = (tpoint-center):Length2D()
	        biaoji = biaoji + 1
	        local forward_v = (tpoint-center):Normalized()
	        OnLinePro(forward_v,particle_fissure,center,hCaster,150,150,2000,ability,distance)
	        EmitSoundOn("Hero_DrowRanger.ProjectileImpact",hCaster)
	        return 0.1
	    end,0)
		hCaster:SpendMana(10, ability)
	end
end

function OnSiWangSuoLian( event )
	local hCaster = event.caster
	local ability = event.ability
	local radius = event.radius
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	if hCaster:GetMana()==10 then
		ability:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_mojianshi_siwangsuolian_buff", {})
		local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),hCaster:GetAbsOrigin() , nil
	    ,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)        
        for i=1,#targets do
        	ability:ApplyDataDrivenModifier(hCaster, targets[i], "modifier_mojianshi_siwangsuolian_debuff", {})
        end
		hCaster:SpendMana(10, ability)
	end
end


function OnWanJianJue( keys )
	
	local hCaster = keys.caster
	local ability = keys.ability
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	if hCaster:GetMana()==8 then
		local casterLoc = hCaster:GetAbsOrigin()
		local targetLoc = keys.target:GetAbsOrigin()
		local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)
		local distance = 1800
		local radius = 900
		local collision_radius = 150
		local projectile_speed = 700
		local machines_per_sec = 14
		local forwardVec = targetLoc - casterLoc
		local effectName = keys.effectName
		forwardVec = forwardVec:Normalized()
		
		-- Find backward vector
		local backwardVec = casterLoc - targetLoc
		backwardVec = backwardVec:Normalized()
		
		-- Find middle point of the spawning line
		local middlePoint = casterLoc + ( radius * backwardVec )
		ability:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_mojianshi_wanjianjue_debuff",{})
		local v = middlePoint - casterLoc
		local dx = -v.y
		local dy = v.x
		local perpendicularVec = Vector( dx, dy, v.z )
		perpendicularVec = perpendicularVec:Normalized()
		
		-- Create dummy to store data in case of multiple instances are called
		local dummy = OnZhaoHuan( "npc_dummy_caster",hCaster,hCaster:GetAbsOrigin(),hCaster:GetTeamNumber(),-1 )
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
					Source = hCaster,
					bHasFrontalCone = false,
					bReplaceExisting = false,
					bDeleteOnHit        = true,
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
		hCaster:SpendMana(8, ability)
	end
end

function OnGuiHuoLuanWu( event )
	local hCaster = event.caster
	local ability = event.ability
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	if hCaster:GetMana()==20 then
		hCaster:RemoveModifierByName("modifier_guihuoluanwu_buff")
		ability:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_guihuoluanwu_buff", {}) 
		--ExorcismStart(event)
		hCaster:SpendMana(20, ability)
	end
end

--[[
	Author: Noya, physics by BMD
	Date: 02.02.2015.
	Spawns spirits for exorcism and applies the modifier that takes care of its logic
]]


function ExorcismStart( event )
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local spirits = ability:GetLevelSpecialValueFor( "spirits", ability:GetLevel() - 1 )
	local delay_between_spirits = ability:GetLevelSpecialValueFor( "delay_between_spirits", ability:GetLevel() - 1 )
	local unit_name = "npc_dummy_caster_ghlw"
	-- Initialize the table to keep track of all spirits
	caster.spirits = {}
	for i=1,spirits do
		Timers:CreateTimer(i * delay_between_spirits, function()
			local unit = OnZhaoHuan( unit_name,caster,caster:GetAbsOrigin(),caster:GetTeamNumber(),-1 )
			unit:SetOriginalModel(event.modelName)
			-- The modifier takes care of the physics and logic
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_mojianshi_guihuoluanwu_spirit", {})
			
			-- Add the spawned unit to the table
			table.insert(caster.spirits, unit)

			-- Initialize the number of hits, to define the heal done after the ability ends
			unit.numberOfHits = 0

			-- Double check to kill the units, remove this later
			Timers:CreateTimer(duration+10, function() if unit and IsValidEntity(unit) then unit:RemoveSelf() end end)
		end)
	end
end

-- Movement logic for each spirit
-- Units have 4 states: 
	-- acquiring: transition after completing one target-return cycle.
	-- target_acquired: tracking an enemy or point to collide
	-- returning: After colliding with an enemy, move back to the casters location
	-- end: moving back to the caster to be destroyed and heal
function ExorcismPhysics( event )
	local caster = event.caster
	local unit = event.target
	local ability = event.ability
	local radius = 900
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local stun_hero = ability:GetLevelSpecialValueFor( "stun_hero", ability:GetLevel() - 1 )
	local stun_basic = ability:GetLevelSpecialValueFor( "stun_basic", ability:GetLevel() - 1 )
	local spirit_speed = 400
	local min_damage = ability:GetAbilityDamage()
	local max_damage = ability:GetAbilityDamage()
	local average_damage = ability:GetAbilityDamage()
	local give_up_distance = 1500
	local max_distance = 1500
	local heal_percent = 0
	local min_time_between_attacks = 0.7
	local abilityDamageType = DAMAGE_TYPE_PHYSICAL
	local abilityTargetType = DOTA_UNIT_TARGET_BASIC
	local particleDamage = "particles/units/heroes/hero_death_prophet/death_prophet_exorcism_attack.vpcf"
	local particleDamageBuilding = "particles/units/heroes/hero_death_prophet/death_prophet_exorcism_attack_building.vpcf"
	--local particleNameHeal = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_start_sparks_b.vpcf"

	-- Make the spirit a physics unit
	Physics:Unit(unit)

	-- General properties
	unit:PreventDI(true)
	unit:SetAutoUnstuck(false)
	unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	unit:FollowNavMesh(false)
	unit:SetPhysicsVelocityMax(spirit_speed)
	unit:SetPhysicsVelocity(spirit_speed * RandomVector(1))
	unit:SetPhysicsFriction(0)
	unit:Hibernate(false)
	unit:SetGroundBehavior(PHYSICS_GROUND_LOCK)

	-- Initial default state
	unit.state = "acquiring"

	-- This is to skip frames
	local frameCount = 0

	-- Store the damage done
	unit.damage_done = 0

	-- Store the interval between attacks, starting at min_time_between_attacks
	unit.last_attack_time = GameRules:GetGameTime() - min_time_between_attacks

	-- Color Debugging for points and paths. Turn it false later!
	local Debug = false
	local pathColor = Vector(255,255,255) -- White to draw path
	local targetColor = Vector(255,0,0) -- Red for enemy targets
	local idleColor = Vector(0,255,0) -- Green for moving to idling points
	local returnColor = Vector(0,0,255) -- Blue for the return
	local endColor = Vector(0,0,0) -- Back when returning to the caster to end
	local draw_duration = 3

	-- Find one target point at random which will be used for the first acquisition.
	local point = caster:GetAbsOrigin() + RandomVector(RandomInt(radius/2, radius))

	-- This is set to repeat on each frame
	unit:OnPhysicsFrame(function(unit)

		-- Move the unit orientation to adjust the particle
		unit:SetForwardVector( ( unit:GetPhysicsVelocity() ):Normalized() )

		-- Current positions
		local source = caster:GetAbsOrigin()
		local current_position = unit:GetAbsOrigin()

		-- Print the path on Debug mode
		if Debug then DebugDrawCircle(current_position, pathColor, 0, 2, true, draw_duration) end

		local enemies = nil

		-- Use this if skipping frames is needed (--if frameCount == 0 then..)
		frameCount = (frameCount + 1) % 3

		-- Movement and Collision detection are state independent

		-- MOVEMENT	
		-- Get the direction
		local diff = point - unit:GetAbsOrigin()
        diff.z = 0
        local direction = diff:Normalized()

		-- Calculate the angle difference
		local angle_difference = RotationDelta(VectorToAngles(unit:GetPhysicsVelocity():Normalized()), VectorToAngles(direction)).y
		
		-- Set the new velocity
		if math.abs(angle_difference) < 5 then
			-- CLAMP
			local newVel = unit:GetPhysicsVelocity():Length() * direction
			unit:SetPhysicsVelocity(newVel)
		elseif angle_difference > 0 then
			local newVel = RotatePosition(Vector(0,0,0), QAngle(0,10,0), unit:GetPhysicsVelocity())
			unit:SetPhysicsVelocity(newVel)
		else		
			local newVel = RotatePosition(Vector(0,0,0), QAngle(0,-10,0), unit:GetPhysicsVelocity())
			unit:SetPhysicsVelocity(newVel)
		end

		-- COLLISION CHECK
		local distance = (point - current_position):Length()
		local collision = distance < 50

		-- MAX DISTANCE CHECK
		local distance_to_caster = (source - current_position):Length()
		if distance > max_distance then 
			unit:SetAbsOrigin(source)
			unit.state = "acquiring" 
		end

		-- STATE DEPENDENT LOGIC
		-- Damage, Healing and Targeting are state dependent.
		-- Update the point in all frames

		-- Acquiring...
		-- Acquiring -> Target Acquired (enemy or idle point)
		-- Target Acquired... if collision -> Acquiring or Return
		-- Return... if collision -> Acquiring

		-- Acquiring finds new targets and changes state to target_acquired with a current_target if it finds enemies or nil and a random point if there are no enemies
		if unit.state == "acquiring" then

			-- This is to prevent attacking the same target very fast
			local time_between_last_attack = GameRules:GetGameTime() - unit.last_attack_time
			--print("Time Between Last Attack: "..time_between_last_attack)

			-- If enough time has passed since the last attack, attempt to acquire an enemy
			if time_between_last_attack >= min_time_between_attacks then
				-- If the unit doesn't have a target locked, find enemies near the caster
				enemies = FindUnitsInRadius(caster:GetTeamNumber(), source, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
											  abilityTargetType, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				-- Check the possible enemies
				-- Focus the last attacked target if there's any
				local last_targeted = caster.last_targeted
				local target_enemy = nil
				for _,enemy in pairs(enemies) do

					-- If the caster has a last_targeted and this is in range of the ghost acquisition, set to attack it
					if last_targeted and enemy == last_targeted then
						target_enemy = enemy
					end
				end

				-- Else if we don't have a target_enemy from the last_targeted, get one at random
				if not target_enemy then
					target_enemy = enemies[RandomInt(1, #enemies)]
				end
				
				-- Keep track of it, set the state to target_acquired
				if target_enemy then
					unit.state = "target_acquired"
					unit.current_target = target_enemy
					point = unit.current_target:GetAbsOrigin()

				-- If no enemies, set the unit to collide with a random idle point.
				else
					unit.state = "target_acquired"
					unit.current_target = nil
					unit.idling = true
					point = source + RandomVector(RandomInt(radius/2, radius))
					--print("Acquiring -> Random Point Target acquired")
					if Debug then DebugDrawCircle(point, idleColor, 100, 25, true, draw_duration) end
				end

			-- not enough time since the last attack, get a random point
			else
				unit.state = "target_acquired"
				unit.current_target = nil
				unit.idling = true
				point = source + RandomVector(RandomInt(radius/2, radius))
				if Debug then DebugDrawCircle(point, idleColor, 100, 25, true, draw_duration) end
			end

		-- If the state was to follow a target enemy, it means the unit can perform an attack. 		
		elseif unit.state == "target_acquired" then

			-- Update the point of the target's current position
			if unit.current_target then
				point = unit.current_target:GetAbsOrigin()
				if Debug then DebugDrawCircle(point, targetColor, 100, 25, true, draw_duration) end
			end

			-- Give up on the target if the distance goes over the give_up_distance
			if distance_to_caster > give_up_distance then
				unit.state = "acquiring"
				--print("Gave up on the target, acquiring a new target.")

			end

			-- Do physical damage here, and increase hit counter. 
			if collision then

				-- If the target was an enemy and not a point, the unit collided with it
				if unit.current_target ~= nil then
					
					-- Damage, units will still try to collide with attack immune targets but the damage wont be applied
					if not unit.current_target:IsAttackImmune() then
						local damage_table = {}

						local spirit_damage = RandomInt(min_damage,max_damage)
						damage_table.victim = unit.current_target
						damage_table.attacker = caster					
						damage_table.damage_type = abilityDamageType
						damage_table.damage = spirit_damage
						local randomInt = RandomInt(1, 100)
						if randomInt<20 then
							if unit.current_target:HasModifier("modifier_common_boss_strong") then
								stun_basic = stun_hero
							end
							ability:ApplyDataDrivenModifier(unit, unit.current_target, "modifier_guihuoluanwu_debuff", {duration=stun_basic})
						end
						ApplyDamage(damage_table)

						-- Calculate how much physical damage was dealt
						local targetArmor = unit.current_target:GetPhysicalArmorValue()
						local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
						local damagePostReduction = spirit_damage * (1 - damageReduction)

						unit.damage_done = unit.damage_done + damagePostReduction

						-- Damage particle, different for buildings
						if unit.current_target.InvulCount == 0 then
							local particle = ParticleManager:CreateParticle(particleDamageBuilding, PATTACH_ABSORIGIN, unit.current_target)
							ParticleManager:SetParticleControl(particle, 0, unit.current_target:GetAbsOrigin())
							ParticleManager:SetParticleControlEnt(particle, 1, unit.current_target, PATTACH_POINT_FOLLOW, "attach_hitloc", unit.current_target:GetAbsOrigin(), true)
						elseif unit.damage_done > 0 then
							local particle = ParticleManager:CreateParticle(particleDamage, PATTACH_ABSORIGIN, unit.current_target)
							ParticleManager:SetParticleControl(particle, 0, unit.current_target:GetAbsOrigin())
							ParticleManager:SetParticleControlEnt(particle, 1, unit.current_target, PATTACH_POINT_FOLLOW, "attach_hitloc", unit.current_target:GetAbsOrigin(), true)
						end

						-- Increase the numberOfHits for this unit
						unit.numberOfHits = unit.numberOfHits + 1 

						-- Fire Sound on the target unit
						unit.current_target:EmitSound("Hero_DeathProphet.Exorcism.Damage")
						
						-- Set to return
						unit.state = "returning"
						point = source
						--print("Returning to caster after dealing ",unit.damage_done)

						-- Update the attack time of the unit.
						unit.last_attack_time = GameRules:GetGameTime()
						--unit.enemy_collision = true

					end

				-- In other case, its a point, reacquire target or return to the caster (50/50)
				else
					if RollPercentage(50) then
						unit.state = "acquiring"
						--print("Attempting to acquire a new target")
					else
						unit.state = "returning"
						point = source
						--print("Returning to caster after idling")
					end
				end
			end

		-- If it was a collision on a return (meaning it reached the caster), change to acquiring so it finds a new target
		elseif unit.state == "returning" then
			
			-- Update the point to the caster's current position
			point = source
			if Debug then DebugDrawCircle(point, returnColor, 100, 25, true, draw_duration) end

			if collision then 
				unit.state = "acquiring"
			end	

		-- if set the state to end, the point is also the caster position, but the units will be removed on collision
		elseif unit.state == "end" then
			point = source
			if Debug then DebugDrawCircle(point, endColor, 100, 25, true, 2) end

			-- Last collision ends the unit
			if collision then 

				-- Heal is calculated as: a percentage of the units average attack damage multiplied by the amount of attacks the spirit did.
				local heal_done =  unit.numberOfHits * average_damage* heal_percent
				caster:Heal(heal_done, ability)
				caster:EmitSound("Hero_DeathProphet.Exorcism.Heal")
				--print("Healed ",heal_done)

				unit:SetPhysicsVelocity(Vector(0,0,0))
	        	unit:OnPhysicsFrame(nil)
	        	unit:ForceKill(false)

	        end
	    end
    end)
end

-- Change the state to end when the modifier is removed
function ExorcismEnd( event )
	local caster = event.caster
	local targets = caster.spirits

	for _,unit in pairs(targets) do		
	   	if unit and IsValidEntity(unit) then
    	  	unit.state = "end"
    	end
	end

	-- Reset the last_targeted
	caster.last_targeted = nil
end

-- Updates the last_targeted enemy, to focus the ghosts on it.
function ExorcismAttack( event )
	local caster = event.caster
	local target = event.target

	caster.last_targeted = target
	--print("LAST TARGET: "..target:GetUnitName())
end

-- Kill all units when the owner dies or the spell is cast while the first one is still going
function ExorcismDeath( event )
	local caster = event.caster
	local targets = caster.spirits or {}

	for _,unit in pairs(targets) do		
	   	if unit and IsValidEntity(unit) then
    	  	unit:SetPhysicsVelocity(Vector(0,0,0))
	        unit:OnPhysicsFrame(nil)

			-- Kill
	        unit:ForceKill(false)
    	end
	end
end

function OnRenLunWu( event )
	local hCaster = event.caster
	local ability = event.ability
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	if hCaster:GetMana()==15 then
		ability:ApplyDataDrivenModifier(hCaster,hCaster,"modifier_bm_blade_fury_ltx",{})
		hCaster:SpendMana(15, ability)
	end
end

function OnWanJianGuiZong( event )
	local hCaster = event.caster
	local ability = event.ability
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	
	if hCaster:GetMana()>=5 and ability:GetAutoCastState() and ability:IsCooldownReady() then
		OnWJJStart(event)
	end
end

function OnWJJStart( data )
	local distance = data.distance
	local vision_range = 200
	local movespeed = data.speed
	local radius = 280
	local hCaster = data.caster
	local ability = data.ability
	local particle_fissure = data.effectName
	local center = hCaster:GetAbsOrigin()
	local number = 15
	local foward = hCaster:GetForwardVector()
	local x = foward.x
	local y = foward.y
	local z = foward.z
	hCaster._mana = hCaster:GetMana()
	hCaster:SpendMana(hCaster:GetMana(), ability)
	for i=1,number do
		local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
		local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
		local xl_new = Vector(x_new,y_new,z)

		local l_point = center+xl_new*radius
	
		local fissure_projectile1 = {
        Ability             = ability,
        EffectName          = particle_fissure,
        vSpawnOrigin        = center,
        fDistance           = distance,
        fStartRadius        = 200,
        fEndRadius          = 200,
        Source              = hCaster,
        bHasFrontalCone     = false,
        bReplaceExisting    = false,
        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
    --  iUnitTargetFlags    = ,
        iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    --  fExpireTime         = ,
        bDeleteOnHit        = false,
        vVelocity           = movespeed*xl_new,
        bProvidesVision     = true,
    	iVisionRadius       = vision_range,
    --  iVisionTeamNumber   = caster:GetTeamNumber(),
    	}
		local pod = ProjectileManager:CreateLinearProjectile( fissure_projectile1 )
		
	end
	ability:StartCooldown(6)
end

function OnWanJianGuiZongDamage( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	hCaster.GX = hCaster.GX or 0
	local damage = (hCaster.GX + 8000)*hCaster._mana*0.8
	local damageTable = 
	{
		victim = target,
        attacker = hCaster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
	}
	ApplyDamage(damageTable)
end

function OnZhaoHuanYanMo( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = event.duration
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	if hCaster:GetMana()==10 then
		local t = OnZhaoHuan( "npc_yanmo",hCaster,target:GetAbsOrigin(),hCaster:GetTeamNumber(),duration )
		ability:ApplyDataDrivenModifier(hCaster,t, "modifier_zhaohuanyanmo_buff",{})
		hCaster:SpendMana(10, ability)
	end
end

function OnZhenWu( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	if hCaster:GetMana()==10 then
		OnTrackPro(event.effectName,1500,target,hCaster,ability,hCaster:GetTeamNumber())
		hCaster:SpendMana(10, ability)
	end
end

function OnLongYin( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	if hCaster:GetMana()==10 then
		local pts = ParticleManager:CreateParticle(event.effectName,PATTACH_ABSORIGIN,target)
		ParticleManager:SetParticleControl(pts,0,target:GetAbsOrigin())
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
			function()
				ParticleManager:DestroyParticle(pts,true)
			end,1)
		local units = FindUnitsInRadius(hCaster:GetTeamNumber(), target:GetAbsOrigin(), nil,400,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_CLOSEST,false)
		for i=1,#units do
			ability:ApplyDataDrivenModifier(hCaster,units[i], event.modifierName,{duration=event.duration})
			local damageTable = 
			{
				victim = units[i],
		        attacker = hCaster,
		        damage = ability:GetAbilityDamage(),
		        damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(damageTable)
		end
		hCaster:SpendMana(10, ability)
	end
end


function OnMyStun( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	local level = ability:GetLevel() - 1
	local modifierName = event.modifierName
	local duration_hero = ability:GetLevelSpecialValueFor("duration_hero", level)
	local duration = ability:GetLevelSpecialValueFor("duration_basic", level)
	if target:HasModifier("modifier_common_boss_strong") then
		duration = duration_hero
	end
	ability:ApplyDataDrivenModifier(hCaster,target, modifierName, {duration = duration})
end

function onMoLiQS( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	local oldMana = target:GetMana()
	local number = event.number
	local totalMana = target:GetMaxMana()
	local particleName = event.particleName
	local result = math.min(totalMana,oldMana+number)
	target:SetMana(result)
	local pts = ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN_FOLLOW,target)
	ParticleManager:SetParticleControl(pts,1,target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pts)
end

function AutoCastMLQS( event )
	local distance = event.radius
	local hCaster = event.caster
	local ability = event.ability

	if ability:IsFullyCastable() and ability:GetAutoCastState() then
		local units = FindUnitsInRadius(hCaster:GetTeamNumber(),hCaster:GetAbsOrigin() , nil
	    ,distance,DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,0,0,false)
	    for i=1,#units do
	    	if units[i]:GetMana()~=units[i]:GetMaxMana() then
	    		local _order =
				{
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					UnitIndex = hCaster:entindex(),
					TargetIndex = units[i]:entindex(),
					AbilityIndex = ability:entindex()
				}
				hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
	    		break
	    	end
	    end
	end
end

function OnIncreaseMana( event )
	local hCaster = event.caster
	local mana = event.mana
	local oldMana = hCaster:GetMana()
	local result =  math.min(oldMana+mana,hCaster:GetMaxMana())
	hCaster:SetMana(result)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
end