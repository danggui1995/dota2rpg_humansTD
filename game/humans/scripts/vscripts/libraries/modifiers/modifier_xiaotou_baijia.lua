modifier_xiaotou_baijia = class({})
require('../../ability/ability_utils')
--------------------------------------------------------------------------------
function modifier_xiaotou_baijia:OnCreated( kv )
    if IsServer() then
        EmitSoundOn("General.CoinsBig", self:GetParent())
        self:OnIntervalThink()
        self:StartIntervalThink( 0.5 )
    end
end
function modifier_xiaotou_baijia:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        if hero.resGold >=1 then 
        	ModifyGoldLtx( hero,-1 )
    	end
    end
end

function modifier_xiaotou_baijia:GetTexture()
	return "xiaotou_baijia"
end
