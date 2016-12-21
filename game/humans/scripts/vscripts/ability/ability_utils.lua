
function OnLinePro( forward_v,effectName,center,source,radius1,radius2,speed,ability,distance )
	local fissure_projectile1 = {
	Ability             = ability,
	EffectName          = effectName,
	vSpawnOrigin        = center,
	fDistance           = distance,
	fStartRadius        = radius1,
	fEndRadius          = radius2,
	Source              = source,
	bHasFrontalCone     = false,
	bReplaceExisting    = false,
	iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
	--  iUnitTargetFlags    = ,
	iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	--  fExpireTime         = ,
	bDeleteOnHit        = false,
	vVelocity           = speed*forward_v,
	bProvidesVision     = true,
	iVisionRadius       = 10,
	--  iVisionTeamNumber   = caster:GetTeamNumber(),
	}
	ProjectileManager:CreateLinearProjectile( fissure_projectile1 )
end

function OnTrackPro( effectName,speed,target,source,ability,team,attach )
	local _attach = attach or DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	local info = {
        Target = target,
        Source = source,
        Ability = ability,
        EffectName = effectName,
        bDodgeable = false,
        bProvidesVision = true,
        iMoveSpeed = speed,
        iVisionRadius = 0,
        iVisionTeamNumber = team,
        iSourceAttachment = _attach
    }
    ProjectileManager:CreateTrackingProjectile( info )
end

function OnZhaoHuan( unitname,owner,pos,team,duration )
	local _temp = owner
	while (not owner:IsRealHero())
	do
		owner = owner:GetOwnerEntity()
	end
	local tUnit = CreateUnitByName( unitname, pos, false, owner, owner, team )
	tUnit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	tUnit._owner = _temp
	tUnit:SetOwner(owner)
	tUnit:SetControllableByPlayer(owner:GetPlayerOwnerID(), true)
	tUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	if duration~=-1 then
		tUnit:AddNewModifier(nil, nil, "modifier_kill", {duration=duration})
	end
	return tUnit
end

function onZhaoHuanGround( unitname,owner,pos,team,duration )
	local _temp = owner
	while (not owner:IsRealHero())
	do
		owner = owner:GetOwnerEntity()
	end
	local tUnit = CreateUnitByName( unitname, pos, false, owner, owner, team )
	tUnit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	tUnit._owner = _temp
	tUnit:SetOwner(owner)
	tUnit:SetControllableByPlayer(owner:GetPlayerOwnerID(), true)
	tUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	if duration~=-1 then
		tUnit:AddNewModifier(nil, nil, "modifier_kill", {duration=duration})
	end
	return tUnit
end

function getParent( owner )
	while (not owner:IsRealHero())
	do
		owner = owner:GetOwnerEntity()
	end
	return owner
end
function getAncient( owner )
	while (not owner:IsRealHero())
	do
		owner = owner:GetOwnerEntity()
	end
	return owner
end


function ModifyGoldLtx( unit,gold )
	if not unit.resGold then
		unit.resGold = 0
	end
	if unit.resGold+gold >=0 and unit.resGold+gold<=9999999 then
		unit.resGold = unit.resGold + gold
	elseif unit.resGold+gold <0 then
		unit.resGold = 0
	elseif unit.resGold+gold >9999999 then
		unit.resGold = 9999999
	end
	
	local id = unit:GetPlayerOwnerID()

	local goldInfo = {}
	for i=1,4 do
		if PlayerResource:IsValidPlayerID(i-1) then
			local t = {}
			t.id = i-1
			local hero = PlayerResource:GetSelectedHeroEntity(i-1)
			if hero then
				t.gold = hero.resGold
			end
			table.insert(goldInfo ,t)
		end
	end
	CustomNetTables:SetTableValue("gold", "GoldInfo", goldInfo)

	--sendToUiLtx(id)
end

function GetGoldByIdLtx( id )
	local hero = PlayerResource:GetSelectedHeroEntity(id)
	return hero.resGold
end

function sendToUiLtx( id )
	local hPlayer = PlayerResource:GetPlayer(id)
	local hero = PlayerResource:GetSelectedHeroEntity(id)
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__refresh__gold",{gold=hero.resGold})
end