--[[
Tower Defense AI

These are the valid orders, in case you want to use them (easier here than to find them in the C code):

DOTA_UNIT_ORDER_NONE
DOTA_UNIT_ORDER_MOVE_TO_POSITION 
DOTA_UNIT_ORDER_MOVE_TO_TARGET 
DOTA_UNIT_ORDER_ATTACK_MOVE
DOTA_UNIT_ORDER_ATTACK_TARGET
DOTA_UNIT_ORDER_CAST_POSITION
DOTA_UNIT_ORDER_CAST_TARGET
DOTA_UNIT_ORDER_CAST_TARGET_TREE
DOTA_UNIT_ORDER_CAST_NO_TARGET
DOTA_UNIT_ORDER_CAST_TOGGLE
DOTA_UNIT_ORDER_HOLD_POSITION
DOTA_UNIT_ORDER_TRAIN_ABILITY
DOTA_UNIT_ORDER_DROP_ITEM
DOTA_UNIT_ORDER_GIVE_ITEM
DOTA_UNIT_ORDER_PICKUP_ITEM
DOTA_UNIT_ORDER_PICKUP_RUNE
DOTA_UNIT_ORDER_PURCHASE_ITEM
DOTA_UNIT_ORDER_SELL_ITEM
DOTA_UNIT_ORDER_DISASSEMBLE_ITEM
DOTA_UNIT_ORDER_MOVE_ITEM
DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO
DOTA_UNIT_ORDER_STOP
DOTA_UNIT_ORDER_TAUNT
DOTA_UNIT_ORDER_BUYBACK
DOTA_UNIT_ORDER_GLYPH
DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH
DOTA_UNIT_ORDER_CAST_RUNE
]]

AICore = {}

GameRules.AbilityBehavior = {             
    DOTA_ABILITY_BEHAVIOR_ATTACK,            
    DOTA_ABILITY_BEHAVIOR_AURA,     
    DOTA_ABILITY_BEHAVIOR_AUTOCAST,    
    DOTA_ABILITY_BEHAVIOR_CHANNELLED,   
    DOTA_ABILITY_BEHAVIOR_DIRECTIONAL,    
    DOTA_ABILITY_BEHAVIOR_DONT_ALERT_TARGET,    
    DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT, 
    DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK,   
    DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT,             
    DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING,    
    DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL,      
    DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE,   
    DOTA_ABILITY_BEHAVIOR_IGNORE_TURN ,        
    DOTA_ABILITY_BEHAVIOR_IMMEDIATE,         
    DOTA_ABILITY_BEHAVIOR_ITEM,              
    DOTA_ABILITY_BEHAVIOR_NOASSIST,            
    DOTA_ABILITY_BEHAVIOR_NONE,             
    DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN, 
    DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE,       
    DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES,      
    DOTA_ABILITY_BEHAVIOR_RUNE_TARGET,         
    DOTA_ABILITY_BEHAVIOR_UNRESTRICTED ,  
}

--判断单体技能
function AICore:IsUnitTarget( hAbility )
    local b = hAbility:GetBehavior()

    if hAbility:IsHidden() then b = b - 1 end
    for k,v in pairs(GameRules.AbilityBehavior) do
        repeat
            if v == 0 then break end
            b = b % v
        until true
    end

    if (b - DOTA_ABILITY_BEHAVIOR_AOE) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
        b = b - DOTA_ABILITY_BEHAVIOR_AOE
    end

    if b == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
        return true
    end
    return false
end

--判断点目标技能
function AICore:IsPoint( hAbility )
    local b = hAbility:GetBehavior()

    if hAbility:IsHidden() then b = b - 1 end
    for k,v in pairs(GameRules.AbilityBehavior) do
        repeat
            if v == 0 then break end
            b = b % v
        until true
    end

    if (b - DOTA_ABILITY_BEHAVIOR_AOE) == DOTA_ABILITY_BEHAVIOR_POINT then
        b = b - DOTA_ABILITY_BEHAVIOR_AOE
    end

    if b == DOTA_ABILITY_BEHAVIOR_POINT then
        return true
    end
    return false
end

--判断无目标技能
function AICore:IsNoTarget( hAbility )
    local b = hAbility:GetBehavior()
    
    if hAbility:IsHidden() then b = b - 1 end
    for k,v in pairs(GameRules.AbilityBehavior) do
        repeat
            if v == 0 then break end
            b = b % v
        until true
    end

    if (b - DOTA_ABILITY_BEHAVIOR_AOE) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
        b = b % DOTA_ABILITY_BEHAVIOR_AOE
    end

    if b == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
        return true
    end
    return false
end

function AICore:RandomEnemyHeroInRange( entity, range )
	local enemies = FindUnitsInRadius( entity:GetTeam(), entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	if #enemies > 0 then
		local index = RandomInt( 1, #enemies )
		return enemies[index]
	else
		return nil
	end
end

function AICore:GetNearstUnit( entity,range )
	local enemies = FindUnitsInRadius( entity:GetTeam(), entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
	if enemies[1] and (enemies[1]:GetUnitName()=="npc_dota_base_ltx" or enemies[1]:GetUnitName()=="ent_base") then
		if enemies[2] then
			return enemies[2]
		end
	else
		return enemies[1]
	end
	return nil
end

function AICore:GetUnitInShanXingArea( entity,range1,range2 )
	--这里的扇形区域是用两个圆来模拟的  如果要高精度的可以多几个圆
	local angel = entity:GetForwardVector()
	local enemies1 = FindUnitsInRadius( entity:GetTeam(), entity:GetOrigin()+angel*range1, nil, range1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	local enemies2 = FindUnitsInRadius( entity:GetTeam(), entity:GetOrigin()+angel*(range1+range2), nil, range2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	local enemies = {}
	if #enemies1~=0 then
		for i,v in ipairs(enemies1) do
			table.insert(enemies,v)
		end
	end
	if #enemies2~=0 then
		for i,v in ipairs(enemies2) do
			table.insert(enemies,v)
		end
	end
	return enemies
end

function AICore:GetAllEnermyInRadius( entity, range )
	local enemies = FindUnitsInRadius( entity:GetTeam(), entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	return enemies
end

function AICore:GetFaceAngle( origin_dest,origin_sour )
	-- body
	local dp = origin_dest:GetOrigin()
	local ds = origin_sour:GetOrigin()
	local x = dp.x - ds.x
	local y = dp.y - ds.y
	local z = dp.z - ds.z
	return Vector(x,y,z)
end

function AICore:ForwardLength( entity,length)
	local forwardV = entity:GetForwardVector()
	local pos_old = entity:GetAbsOrigin()
	local x = pos_old.x + length * forwardV.x
	local y = pos_old.y + length * forwardV.y
	local z = pos_old.z + length * forwardV.z
	return Vector(x,y,z)
end

function AICore:ForwardXy( entity,length)
	local forwardV = entity:GetForwardVector()
	local x = length * forwardV.x
	local y = length * forwardV.y
	local z = length * forwardV.z
	return Vector(x,y,z)
end


function AICore:RandomPositionInRange( entity,range )
	local ent_pos = entity:GetAbsOrigin()
	local rd_x = RandomInt(-1*range, range)
	local temp = math.sqrt(range*range - rd_x*rd_x)
	local rd_y = RandomInt(-1*temp,temp)
	local x = ent_pos.x
	local y = ent_pos.y
	local z = ent_pos.z
	x = x + rd_x
	y = y + rd_y
	return Vector(x,y,z)
end

function AICore:WeakestEnemyHeroInRange( entity, range )
	local enemies = FindUnitsInRadius( entity:GetTeam(), entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )

	local minHP = nil
	local target = nil

	for _,enemy in pairs(enemies) do
		local distanceToEnemy = (entity:GetOrigin() - enemy:GetOrigin()):Length()
		local HP = enemy:GetHealth()
		if enemy:IsAlive() and (minHP == nil or HP < minHP) and distanceToEnemy < range then
			minHP = HP
			target = enemy
		end
	end

	return target
end

function AICore:CreateBehaviorSystem( behaviors )
	local BehaviorSystem = {}

	BehaviorSystem.possibleBehaviors = behaviors
	BehaviorSystem.thinkDuration = 1.0
	BehaviorSystem.repeatedlyIssueOrders = true -- if you're paranoid about dropped orders, leave this true

	BehaviorSystem.currentBehavior =
	{
		endTime = 0,
		order = { OrderType = DOTA_UNIT_ORDER_NONE }
	}

	function BehaviorSystem:Think()
		if GameRules:GetGameTime() >= self.currentBehavior.endTime then
			local newBehavior = self:ChooseNextBehavior()
			if newBehavior == nil then 
				-- Do nothing here... this covers possible problems with ChooseNextBehavior
			elseif newBehavior == self.currentBehavior then
				self.currentBehavior:Continue()
			else
				if self.currentBehavior.End then self.currentBehavior:End() end
				self.currentBehavior = newBehavior
				self.currentBehavior:Begin()
			end
		end

		if self.currentBehavior.order and self.currentBehavior.order.OrderType ~= DOTA_UNIT_ORDER_NONE then
			if self.repeatedlyIssueOrders or
				self.previousOrderType ~= self.currentBehavior.order.OrderType or
				self.previousOrderTarget ~= self.currentBehavior.order.TargetIndex or
				self.previousOrderPosition ~= self.currentBehavior.order.Position then

				-- Keep sending the order repeatedly, in case we forgot >.<
				ExecuteOrderFromTable( self.currentBehavior.order )
				self.previousOrderType = self.currentBehavior.order.OrderType
				self.previousOrderTarget = self.currentBehavior.order.TargetIndex
				self.previousOrderPosition = self.currentBehavior.order.Position
			end
		end

		if self.currentBehavior.Think then self.currentBehavior:Think(self.thinkDuration) end

		return self.thinkDuration
	end

	function BehaviorSystem:ChooseNextBehavior()
		local result = nil
		local bestDesire = nil
		for _,behavior in pairs( self.possibleBehaviors ) do
			local thisDesire = behavior:Evaluate()
			if bestDesire == nil or thisDesire > bestDesire then
				result = behavior
				bestDesire = thisDesire
			end
		end

		return result
	end

	function BehaviorSystem:Deactivate()
		print("End")
		if self.currentBehavior.End then self.currentBehavior:End() end
	end

	return BehaviorSystem
end