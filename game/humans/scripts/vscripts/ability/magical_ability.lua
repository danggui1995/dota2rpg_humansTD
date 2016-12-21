require('utils/msg')
function Blink(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	FindClearSpaceForUnit(caster, point, false)	
end
function GetFrontPoint( caster,point,distance )
	local fv = (point - caster:GetAbsOrigin()):Normalized()
	local origin = caster:GetAbsOrigin()
	local front_position = origin + fv * distance
	return front_position
end
function OnCommonSplit( event )
	local hCaster = event.caster
	
	for i=1,2 do
		local tUnit = CreateUnitByName("npc_dota_fk_child_17",hCaster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)
		tUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		tUnit.type = hCaster.type
		local ent_path1 = Entities:FindByName(nil,"ent_path_"..tostring(tUnit.type*2-1).."1")
		local ent_path2 = Entities:FindByName(nil,"ent_path_"..tostring(tUnit.type*2-1).."2")
		local ent_path3 = Entities:FindByName(nil,"ent_path_"..tostring(tUnit.type*2-1).."3")
		local ent_path4 = GameRules.path_ent2[tUnit.type]
		tUnit.p = hCaster.p
		tUnit:SetContextThink("movetoplace_child", 
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

function OnCreepRebornDestroyed( event )
	local hCaster = event.caster
	hCaster:SetHealth(hCaster:GetMaxHealth())
	hCaster:RemoveEffects(EF_NODRAW)

end

function OnCreepRebornCreated( event )
	local hCaster = event.caster
	hCaster:AddEffects(EF_NODRAW)
	hCaster:Purge(true, true, false, true,false)
	local particleName = event.particleName
	local duration = event.duration
	local pts = ParticleManager:CreateParticle(particleName,PATTACH_WORLDORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts,0,hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pts,2,Vector(duration,0,0))
	ParticleManager:ReleaseParticleIndex(pts)
end

function OnGifted( event )
	local hCaster = event.caster
	local killed = event.unit
	local rd_int = RandomInt(1, 100)
	local ability = event.ability

	if rd_int<=2 and hCaster:GetLevel()<4 and ability:IsCooldownReady() then
		hCaster:CreatureLevelUp(1)
		for i=0,7 do
			local __ability = hCaster:GetAbilityByIndex(i)
			if __ability then
				local __level = __ability:GetLevel()
				local __maxlv = __ability:GetMaxLevel()
				if __level<__maxlv then
					__ability:SetLevel(__level+1)
				end
			end
		end

		if hCaster:GetLevel() ==4 then
			hCaster:RemoveAbility("common_gifted")
			hCaster:RemoveModifierByName("modifier_common_gifted")
		end
		ability:StartCooldown(60)
	end
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