require('ability/ability_utils')
function GetFrontPoint( caster,distance )
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local front_position = origin + fv * distance
	return front_position
end

function OnZhaoHuanXiong( event )
	local hCaster = event.caster
	local target = event.target
	local point = target:GetAbsOrigin()
	local ability = event.ability
	local ability_lv = ability:GetLevel()
	local duration = ability:GetLevelSpecialValueFor("duration",ability_lv-1)
	local t_gw  ="npc_xiong"..tostring(ability_lv)
	OnZhaoHuan( t_gw,hCaster,point,hCaster:GetTeamNumber(),duration )
end
function OnDiYuHuo(event)
	local hCaster = event.caster
	local target = event.target
	local point = target:GetAbsOrigin()
	local ability = event.ability
	local ability_lv = ability:GetLevel()
	local duration = ability:GetLevelSpecialValueFor("duration",ability_lv-1)
	local t_gw  ="npc_diyuhuo"..tostring(ability_lv)
	OnZhaoHuan( t_gw,hCaster,point,hCaster:GetTeamNumber(),duration )
end

function OnShuRen( event )
	local hCaster = event.caster
	local target = event.target
	local point = target:GetAbsOrigin()
	local ability = event.ability
	local ability_lv = ability:GetLevel()
	local duration = ability:GetLevelSpecialValueFor("duration",ability_lv-1)
	local t_gw  ="npc_shuren1"
	local num = ability:GetLevelSpecialValueFor("num",ability_lv-1)
	for i=1,num do
		OnZhaoHuan( t_gw,hCaster,point,hCaster:GetTeamNumber(),duration )
	end
end

function OnYeShouYouHun( event )
	local hCaster = event.caster
	local target = event.target
	local point = target:GetAbsOrigin()
	local ability = event.ability
	local ability_lv = ability:GetLevel()
	local duration = ability:GetLevelSpecialValueFor("duration",ability_lv-1)
	local t_gw  ="npc_lang"..tostring(ability_lv)
	OnZhaoHuan( t_gw,hCaster,point,hCaster:GetTeamNumber(),duration )
end

function OnLeitingyijiDamage( data )
	local hCaster = data.caster
	local ability = data.ability
	
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local num = ability:GetLevelSpecialValueFor("num", level)
	local opt = data.opt
	if opt == 1 then
		if not ability:IsCooldownReady() then
			return 
		end
		ability:StartCooldown(5)
	end
	if hCaster:HasAbility("gxability_yemanren3") then
		raidus = radius + 300
	end
	local pos_caster = hCaster:GetAbsOrigin()
	local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), pos_caster, nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_CLOSEST,false)
	if #targets==0 then
		return 
	end
	num=math.min(num,#targets)
	hCaster.GX = hCaster.GX or 0
	local damage = (hCaster.GX +16000)*4
	local pts = ParticleManager:CreateParticle(data.effctName, PATTACH_CUSTOMORIGIN, hCaster )
	ParticleManager:SetParticleControl(pts, 0, pos_caster)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
			function()
				ParticleManager:DestroyParticle(pts,true)
			end,1)
	for i=1,num do
		local damageTable = 
	    {
	        victim = targets[i],    --受到伤害的单位
	        attacker = hCaster,          --造成伤害的单位
	        damage = damage,
	        damage_type = DAMAGE_TYPE_MAGICAL
	    }
	    local num = ApplyDamage(damageTable)
	    ability:ApplyDataDrivenModifier(hCaster,targets[i], "modifier_leitingyiji_slow", {})
	end
end

function OnDaGouGunFa( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	if target:HasModifier("modifier_common_boss_strong") then
		ability:ApplyDataDrivenModifier(hCaster,target, "modifier_taozhuang_yemanren_debuff", {duration=3})
	else
		ability:ApplyDataDrivenModifier(hCaster,target, "modifier_taozhuang_yemanren_debuff", {})
	end
end

function OnZhongJiType( event )
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

function OnShiXue( event )
	local hCaster = event.caster
	local ability = event.ability
	local modifierName = event.modifierName
	local duration = event.duration
	local distance = event.distance

	if ability:IsFullyCastable() and ability:GetAutoCastState() then
		local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil,distance,DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,0,FIND_CLOSEST,false)
		for i=1,#targets do
			if not targets[i]:HasModifier(modifierName) then
				local _order =
		        {
		            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		            UnitIndex = hCaster:entindex(),
		            TargetIndex = targets[i]:entindex(),
		            AbilityIndex = ability:entindex()
		        }
		        hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
		        break
			end
		end
		
	end
end