modifier_lieren_yueren_one_lua = class({})

--------------------------------------------------------------------------------

function modifier_lieren_yueren_one_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_lieren_yueren_one_lua:OnCreated( kv )
	self.reduce = self:GetAbility():GetSpecialValueFor( "attack_reduce" )
	self.num = self:GetAbility():GetSpecialValueFor( "num" )
end

--------------------------------------------------------------------------------

function modifier_lieren_yueren_one_lua:OnRefresh( kv )
	self.reduce = self:GetAbility():GetSpecialValueFor( "attack_reduce" )
	self.num = self:GetAbility():GetSpecialValueFor( "num" )
end

--------------------------------------------------------------------------------

function modifier_lieren_yueren_one_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_lieren_yueren_one_lua:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self.great_cleave_damage * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.great_cleave_radius, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
			end
		end
	end
	
	return 0
end
