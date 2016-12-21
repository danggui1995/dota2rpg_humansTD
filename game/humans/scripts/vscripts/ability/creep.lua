function OnAttacked( data )
	local hCaster = data.caster
	local ability = data.ability
	local level = ability:GetLevel()
	local cd = ability:GetCooldown(level)
	local duration = data.duration
	if hCaster:GetHealth()<10 then
		hCaster:RemoveModifierByName("modifier_creep_reborn")
		ability:StartCooldown(cd)
		hCaster:AddNewModifier(nil, nil, "modifier_stunned",{duration=duration})
		hCaster:AddNoDraw()
		hCaster:AddAbility("dota_ability_dummy")
		hCaster:SetHealth(hCaster:GetMaxHealth())
	else
		return 
	end


	hCaster.pts = ParticleManager:CreateParticle("aaa",
		PATTACH_CUSTOMORIGIN,hCaster)
	ParticleManager:SetParticleControl(hCaster,0,hCaster:GetAbsOrigin())


	hCaster.StartTime = math.floor(GameRules:GetGameTime())
	hCaster:SetContextThink("reborn",
		function ()
			if math.floor(GameRules:GetGameTime())>=hCaster.StartTime+duration then
				hCaster:RemoveNoDraw()
				ParticleManager:DestroyParticle(hCaster.pts,false )
				hCaster:RemoveAbility("dota_ability_dummy")
				return nil
			else
				return 1
			end
		end,duration)
	hCaster:SetContextThink("cooldown", 
		function ()
			if math.floor(GameRules:GetGameTime())>=hCaster.StartTime+cd then
				hCaster:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_creep_reborn", {})
				return nil
			else
				return 1
			end
		end,cd)
end

function OnDeathSplit( data )
	local hCaster = data.caster
	local ability = data.ability
	local pos = hCaster:GetAbsOrigin()
	local num = data.num

	local pts = ParticleManager:CreateParticle("aaa",PATTACH_CUSTOMORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts,0, pos)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
			function()
				ParticleManager:DestroyParticle(pts,true)
			end,5)
	local ent_path1 = GameRules.path1[(hCaster.type)]
	local ent_path2 = GameRules.path2[(hCaster.type)]
	local ent_path3 = GameRules.path3[(hCaster.type)]
	local ent_path4 = GameRules.path_ent2[(hCaster.type)]
	for i=1,num do
		local tUnit = CreateUnitByName("npc_dota_fk_child_17",pos, false,nil,nil,DOTA_TEAM_BADGUYS)
		tUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		tUnit.type = hCaster.type
		tUnit.p = hCaster.p

		tUnit:SetContextThink("movetoplace", 
		function()
			if tUnit.p==1 then
				if (tUnit:GetAbsOrigin()-ent_path1:GetAbsOrigin()):Length2D()<300 then
					tUnit.p = 2
				end
				local t_order = 
			    {                                       
			        UnitIndex = tUnit:entindex(), 
			        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			        TargetIndex = nil, 
			        AbilityIndex = 0, 
			        Position = ent_path1:GetAbsOrigin(),
			        Queue = 0 
			    }
			    tUnit:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.1)
			elseif tUnit.p==2 then
				if (tUnit:GetAbsOrigin()-ent_path2:GetAbsOrigin()):Length2D()<300 then
					tUnit.p = 3
				end
				local t_order = 
			    {                                       
			        UnitIndex = tUnit:entindex(), 
			        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			        TargetIndex = nil, 
			        AbilityIndex = 0, 
			        Position = ent_path2:GetAbsOrigin(),
			        Queue = 0 
			    }
			    tUnit:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.1)
			elseif tUnit.p==3 then
				if (tUnit:GetAbsOrigin()-ent_path3:GetAbsOrigin()):Length2D()<300 then
					tUnit.p = 4
				end
				local t_order = 
			    {                                       
			        UnitIndex = tUnit:entindex(), 
			        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			        TargetIndex = nil, 
			        AbilityIndex = 0, 
			        Position = ent_path3:GetAbsOrigin(),
			        Queue = 0 
			    }
			    tUnit:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.1)
			elseif tUnit.p==4 then
				local t_order = 
			    {                                       
			        UnitIndex = tUnit:entindex(), 
			        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			        TargetIndex = nil, 
			        AbilityIndex = 0, 
			        Position = ent_path4:GetAbsOrigin(),
			        Queue = 0 
			    }
			    tUnit:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.1)
			end
			return 0.6
		end,0)
	end
end