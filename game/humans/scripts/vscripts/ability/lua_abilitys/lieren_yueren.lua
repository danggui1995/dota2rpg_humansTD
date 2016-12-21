lieren_yueren_one = class({})
LinkLuaModifier( "modifier_lieren_yueren_one_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function lieren_yueren_one:GetIntrinsicModifierName()
	return "modifier_lieren_yueren_one_lua"
end

function lieren_yueren_one:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
		--EmitSoundOn( "Hero_Sven.StormBoltImpact", hTarget )
		local bolt_aoe = self:GetSpecialValueFor( "bolt_aoe" )
		local bolt_damage = self:GetSpecialValueFor( "bolt_damage" )
		local bolt_stun_duration = self:GetSpecialValueFor( "bolt_stun_duration" )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), hTarget, bolt_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = bolt_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}

					ApplyDamage( damage )
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_sven_storm_bolt_lua", { duration = bolt_stun_duration } )
				end
			end
		end
	end

	return true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------