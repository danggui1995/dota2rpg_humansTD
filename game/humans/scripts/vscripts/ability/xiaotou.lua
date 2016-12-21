require('ability/ability_utils')
require('ability/leiting')
require('utils/msg')
function OnShanDianFengBao( event )
	local hCaster = event.caster 
	local oo = hCaster
	while (not hCaster:IsRealHero())
	do
		hCaster = hCaster:GetOwner()
	end
	local ability = event.ability
	--if hCaster.resGold % 7==0 then
	if hCaster.resGold%7==0 then	
		local target = event.target
		local tt = CreateUnitByName("npc_dummy_caster", target:GetAbsOrigin(),true,hCaster, hCaster,hCaster:GetTeamNumber() )
		ability:ApplyDataDrivenModifier(oo, tt, "modifier_shandianfengbao_thinker", {})
		tt:AddNewModifier(tt, nil,"modifier_kill", {duration = event.duration+0.2})
		ability:ApplyDataDrivenModifier(oo, oo, "modifier_xiaotou_shandianfengbao_cast", {})
		--[[if hCaster.resGold >0 then
			hCaster:SpendGold(1, 0)
		end]]
		if hCaster.resGold>0 then
			
			ModifyGoldLtx(hCaster,-1)
		end
		
	end
end

function damageOnCritetion( event )
	local hCaster = event.caster
	local target = event.target 
	local attack_damage = event.attack_damage
	local crit = event.crit
	local damageTable=
	{
		victim = target,
        attacker = hCaster,
        damage = attack_damage*crit,
        damage_type = DAMAGE_TYPE_PURE
	}

	local tt = ApplyDamage(damageTable)


end

function OnBaiJiaTrans( event )
	local hCaster = event.caster
	local ability = event.ability
	local pts = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", 
			PATTACH_CUSTOMORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts, 1, hCaster:GetAbsOrigin())
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
			function()
				ParticleManager:DestroyParticle(pts,true)
			end,1)
	if hCaster:HasModifier("modifier_xiaotou_baijia") then
		hCaster:RemoveModifierByName("modifier_xiaotou_baijia")
	else
		ability:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_xiaotou_baijia",{})
	end
end

function OnBaiJia( event )
	local hCaster = event.caster
	--hCaster:SpendGold(1, 0)
	ModifyGoldLtx(hCaster,-1)
end

function OnLveDuo( event )
	local hCaster = event.attacker
	local target = event.unit
	local ability = event.ability
	if ability:GetCaster()==hCaster then
		GoldPar(hCaster)
		local oo = hCaster
		local num = math.ceil((GameRules.gw_lv+2)/3)
		if oo:HasModifier("modifier_taozhuang_xiaotou_buff") then
			num = math.ceil(num*1.5)
		end
		while not hCaster:IsRealHero() do
			hCaster = hCaster:GetOwnerEntity()
		end
		ModifyGoldLtx(hCaster,num)
		--hCaster:ModifyGold(num, false,0)
		PopupGoldGain(oo,num)
	end
	--print(hCaster:GetUnitName()..target:GetUnitName())
end

function GoldPar( hCaster )
	local pts = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf",PATTACH_CUSTOMORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts,0,hCaster:GetAbsOrigin())
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
		function()
			ParticleManager:DestroyParticle(pts,true)
		end,1)
end

function OnTouShu( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability
	local id = hCaster:GetPlayerOwnerID() 
	if GameRules.role[id+1]~="xiaotou" then
		return
	end
	GoldPar(hCaster)
	local oo = hCaster
	local num = math.ceil((GameRules.gw_lv+2)/3)
	if oo:HasModifier("modifier_taozhuang_xiaotou_buff") then
		num = math.ceil(num*1.5)
	end
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwnerEntity()
	end
	ModifyGoldLtx(hCaster,num)
	--hCaster:ModifyGold(num, false,0)
	PopupGoldGain(oo,num)
end

function OnShaLu( event )
	local hCaster = event.caster
	local target = event.target
	local ability = event.ability

	local id = hCaster:GetPlayerOwnerID() 
	if GameRules.role[id+1]~="xiaotou" then
		return
	end
	if ability:GetLevel()==3 and not target:HasModifier("modifier_common_boss_strong") then
		if target and target:IsAlive() then
			local damage = 99999999
			local damageTable=
			{
				victim = target,
		        attacker = hCaster,
		        damage = damage,
		        damage_type = DAMAGE_TYPE_PURE
			}
			local tt = ApplyDamage(damageTable)
		end
	end
end

function OnQiangJie( event )
	local hCaster = event.caster
	local id = hCaster:GetPlayerOwnerID() 
	if GameRules.role[id+1]~="xiaotou" then
		return
	end
	local target = event.target
	local ability = event.ability
	local oo = hCaster
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwnerEntity()
	end
	local gold = event.gold
	ModifyGoldLtx(hCaster,gold)
	--hCaster:ModifyGold(gold, false, 0)
	GoldPar(oo)
	PopupGoldGain(oo,gold)
end


function OnQiangJiePas( event )
	local hCaster = event.caster
	local ability = event.ability 
	local target = event.target 

	if ability:IsFullyCastable() and ability:GetAutoCastState() then
		local _order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = hCaster:entindex(),
			TargetIndex = target:entindex(),
			AbilityIndex = ability:entindex()
		}
		hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
	end
end

function OnLveDuoDamagePar( event )
	local hCaster = event.caster
	local ability = event.ability
	local damage = event.damage
	PopupCriticalDamage(hCaster,damage*19)
end
function PrintTable (t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= 'table' then return end
	
	done = done or {}
	done[t] = true
	indent = indent or 0
	
	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end
	
	table.sort(l)
	for k, v in ipairs(l) do
		local value = t[v]
		
		if type(value) == "table" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..":")
			PrintTable (value, indent + 1, done)
		elseif type(value) == "userdata" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
			PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		else
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		end
	end
end

function OnBingGongChang( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local oo = hCaster

	if ability:IsCooldownReady() then
		while not hCaster:IsRealHero() do
			hCaster = hCaster:GetOwner()
		end
		if hCaster.resGold >1 then
			ModifyGoldLtx(hCaster,-2)
		end
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		local cj = onZhaoHuanGround( "npc_xiaotou_chejian",hCaster,target:GetAbsOrigin(),hCaster:GetTeamNumber(),event.duration1 )
		ability:ApplyDataDrivenModifier(oo, cj, "modifier_xiaotou_binggongchang_thinker", {})
	end
end

function OnAddMingBing( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	if not hCaster or hCaster:IsNull() then
		return
	end
	local cj = OnZhaoHuan( "npc_mingbing",hCaster,target:GetAbsOrigin(),hCaster:GetTeamNumber(),event.duration2 )
	ability:ApplyDataDrivenModifier(hCaster, cj, "modifier_xiaotou_binggongchang_attr", {})
end

function OnShaChongJi( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local oo = hCaster
	local point = target:GetAbsOrigin()
	while not hCaster:IsRealHero() 
	do
		hCaster = hCaster:GetOwner()
	end
	if hCaster.resGold %7 ==0 then
		if hCaster.resGold >1 then
			ModifyGoldLtx(hCaster,-2)
		end
		local radius = event.radius
	    local particle_fissure = event.effectName
	    local center = oo:GetAbsOrigin()
	    local movespeed = 700
	    local biaoji = 1
	    local num = 12
	    hCaster:SetContextThink("shachongji", 
	    function()
	        if not oo or not oo:IsAlive() then
	            return nil
	        end
	      	if biaoji > num then
	            return nil
	        end
	        local tpoint = point+RandomVector(radius)
	        local distance = (tpoint-center):Length2D()
	        biaoji = biaoji + 1
	        local forward_v = (tpoint-center):Normalized()
	        OnLinePro(forward_v,particle_fissure,center,oo,150,150,2000,ability,distance)
	        EmitSoundOn("Hero_DrowRanger.ProjectileImpact",oo)
	        return 0.1
	    end,0)
	end
end

function OnChanRao( event )
	local hCaster = event.caster
	local ability = event.ability
	local radius = event.radius
	local oo = hCaster
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwner()
	end
	if hCaster.resGold%10==0 then
		if hCaster.resGold>2 then
			ModifyGoldLtx(hCaster,-3)
		end
		local targets = FindUnitsInRadius(oo:GetTeamNumber(),oo:GetAbsOrigin() , nil
	    ,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)        
	    for k,v in pairs(targets) do
	    	ability:ApplyDataDrivenModifier(oo,v, "modifier_xiaotou_chanrao_debuff",{}) 
	    end
	    oo:EmitSound("Hero_Treant.Overgrowth.Cast")
	end
end

function OnLingHunSuo( event )
	local hCaster = event.caster
	local ability = event.ability
	hCaster:GiveMana(1)
	PopupCriticalDamage(hCaster,hCaster:GetMana())
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwner()
	end
	if hCaster.resGold%6==0 then
		OnLeitingStart(event)
		if hCaster.resGold >3 then
			ModifyGoldLtx(hCaster,-4)
		end
	end
end

function OnAnYingTouXi( event )
	local hCaster = event.caster
	local ability = event.ability
	local oo = hCaster
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwner()
	end
	if hCaster.resGold % 9 ==0 then
		local level = ability:GetLevel() -1
		local speed = ability:GetLevelSpecialValueFor("projectile_speed",level)
		if hCaster.resGold >4 then
			ModifyGoldLtx(hCaster,-5)
		end
		local targets = FindUnitsInRadius(oo:GetTeamNumber(),oo:GetAbsOrigin() , nil
	    ,event.radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)        
	    for k,v in pairs(targets) do
	    	OnTrackPro(event.effectName,speed,v,oo,ability,oo:GetTeamNumber())
	    end
	    oo:EmitSound("Hero_QueenOfPain.ShadowStrike")
	end
end

function OnMoRiShenPan( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local oo = hCaster
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwner()
	end
	if hCaster.resGold % 8 ==0 then
		if hCaster.resGold>5 then
			ModifyGoldLtx(hCaster,-6)
		end
		ability:ApplyDataDrivenModifier(oo, target,"modifier_xiaotou_morishenpan_debuff",{})
	end
end

function OnAddDoom( event )
	local hCaster = event.caster
	local killed = event.unit
	local ability = event.ability
	local level = ability:GetLevel()
	local duration = ability:GetLevelSpecialValueFor("duration",level-1)
	local t_gw  = "npc_morishenpan"
	local point = killed:GetAbsOrigin()
	local tunit = OnZhaoHuan( t_gw,hCaster,point,hCaster:GetTeamNumber(),duration )
	ability:ApplyDataDrivenModifier(hCaster,tunit, "modifier_xiaotou_morishenpan_buff",{})
end

function OnJianRenFengBao( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local oo = hCaster
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwner()
	end
	if hCaster.resGold % 6 == 0 then
		if hCaster.resGold >9 then
			ModifyGoldLtx(hCaster,-10)
		end

		ability:ApplyDataDrivenModifier(oo, oo,"modifier_xiaotou_jianrenfengbao_cast",{})
	end
end

function OnDsDamage( event )
	local hCaster = event.caster
	local target = event.target
	local oo = hCaster
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwner()
	end
	oo.GX = oo.GX or 0
	local damage = (oo.GX + hCaster.resGold * 2)*2
	local damageTable = 
	{
		victim = target,
        attacker = oo,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
	}
	ApplyDamage(damageTable)
end

function AddGaolidaiModifier( event )
	local hCaster = event.caster
	local ability = event.ability
	local hero = hCaster:GetOwner()
	local modifierName = event.modifierName
	if hero then
		ability:ApplyDataDrivenModifier(hCaster,hero,modifierName,{})
	end
end

function RemoveGaolidaiModifier( event )
	local hCaster = event.caster
	local ability = event.ability
	local hero = hCaster:GetOwner()
	local modifierName = event.modifierName
	if hero and hero:HasModifier(modifierName) then
		hero:RemoveModifierByName(modifierName)
	end
end

function OnShenTou( event )
	local hCaster = event.caster
	local target = event.target
	local gold = event.gold
	hCaster = getAncient(hCaster)
	if hCaster then
		ModifyGoldLtx(hCaster,gold)
		PopupGoldGain(target,gold)
	end
end

function getAncient( unit )
	while not unit:IsRealHero() do
		unit = unit:GetOwner()
	end
	return unit
end