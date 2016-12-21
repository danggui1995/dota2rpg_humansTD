require( "AI/ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
	
    behaviorSystem = AICore:CreateBehaviorSystem( {BehaviorAbilityq,BehaviorAttack} ) 
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
       return behaviorSystem:Think()
end
--------------------------------------------------------------------------------------------------------
BehaviorAbilityq = {}

function BehaviorAbilityq:Evaluate()
	local desire = 0
	if currentBehavior == self then return desire end
	self.qAbility = thisEntity:GetAbilityByIndex(0)
	if self.qAbility and self.qAbility:IsFullyCastable() and self.qAbility:GetBehavior() ~= 2 then
		local rd = RandomInt(1,10)
		if rd>5 then
			desire = 5
		end
	end
	return desire
end

function BehaviorAbilityq:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.qAbility:entindex()
	}
end

BehaviorAbilityq.Continue = BehaviorAbilityq.Begin
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
BehaviorAttack = {}

function BehaviorAttack:Evaluate()
	local desire = 0
	if currentBehavior == self then return desire end
	self.qAbility = thisEntity:GetAbilityByIndex(0)
	if not self.qAbility:IsFullyCastable() then
		desire = 2
	end
	return desire
end

function BehaviorAttack:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE ,
		Position = thisEntity:GetAbsOrigin()
	}
end

BehaviorAttack.Continue = BehaviorAttack.Begin
--------------------------------------------------------------------------------------------------------
AICore.possibleBehaviors = {BehaviorAbilityq,BehaviorAttack}