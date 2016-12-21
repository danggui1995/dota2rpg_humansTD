if modifier_ltx_cleave_attack == nil then
    modifier_ltx_cleave_attack = class({})
end

function modifier_ltx_cleave_attack:OnCreated(kv)
	self.cleave_radius = kv.radius or 300
	self.cleave_radius2 = kv.radius2 or self.cleave_radius
	self.cleave_percent = kv.cleave or 30
	self.cleave_distance = kv.distance or 300
	self.cleave_particle = kv.particle or "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf"
	self.cleave_sound = kv.sound or "DOTA_Item.BattleFury"
end


function modifier_ltx_cleave_attack:IsHidden()
	return true
end

function modifier_ltx_cleave_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end


function modifier_ltx_cleave_attack:OnAttackLanded(params)
	if IsServer() then
		local hCaster = self:GetParent()
        if params.attacker == hCaster and ( not hCaster:IsIllusion() ) and (not hCaster:IsRangedAttacker()) then
            if self:GetParent():PassivesDisabled() then
                   return 0
            end

            local target = params.target
            if target ~= nil and target:GetTeamNumber() ~= hCaster:GetTeamNumber() then
                local cleaveDamage = ( self.cleave_percent * params.damage ) / 100.0
                DoCleaveAttack( hCaster, target, self:GetAbility(), cleaveDamage,self.cleave_distance, self.cleave_radius,self.cleave_radius2, self.cleave_particle )
            end
        end
	end

	return 0
end