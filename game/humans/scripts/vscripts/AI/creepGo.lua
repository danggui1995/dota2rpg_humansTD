require( "AI/ai_core" )

behaviorSystem = {}

function Spawn( entityKeyValues )
	
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
	
    behaviorSystem = AICore:CreateBehaviorSystem( {BehaviorNone, BehaviorMoveTo} ) 
end

function AIThink()
       return behaviorSystem:Think()
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	if AICore.currentBehavior == self then return 1 end
	desire = 0
	if Spawn_p == nil then
		local Spawn_pos = thisEntity:GetAbsOrigin()
		if (Spawn_pos-Vector(-7250.25 ,-4749.87 ,136.999)):Length2D()<300 then
			Spawn_p = 5
		elseif (Spawn_pos-Vector(7104 ,-4736 ,137)):Length2D()<300 then
			Spawn_p = 8
		elseif (Spawn_pos-Vector(7256.94 ,4805.64 ,137)):Length2D()<300 then
			Spawn_p = 1
		elseif (Spawn_pos-Vector(-4480 ,7213 ,136.999)):Length2D()<300 then
			Spawn_p = 3
		end
	end
	return desire
end

function BehaviorNone:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_NONE
	}
end

function BehaviorNone:Continue()
	self.endTime = GameRules:GetGameTime() + 5
end

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
BehaviorMoveTo = {}

function BehaviorMoveTo:Evaluate()
	if AICore.currentBehavior == self then return 6 end
	desire = 0
	local 
	if not Spawn_p then
		return desire
	end
	if (thisEntity:GetAbsOrigin() - Spawn_pos):Length2D()>700 then
		desire = 6
	end

	return desire
end

function BehaviorMoveTo:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION ,
		Position = Spawn_pos
	}
end

function BehaviorMoveTo:Continue()
	self.endTime = GameRules:GetGameTime() + 1
end

--------------------------------------------------------------------------------------------------------
AICore.possibleBehaviors = {BehaviorNone, BehaviorMoveTo}