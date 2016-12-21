require('ability/ability_utils')
function DuoChongGongJi( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if caster:IsRangedAttacker() then
        local radius = caster:GetAttackRange() +100
        local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local types = DOTA_UNIT_TARGET_ALL
        local flags = DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
        local group = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,radius,teams,types,flags,FIND_CLOSEST,true)
        local attack_count = keys.attack_count or 0
        local attack_unit = {}
        local unitname = caster:GetUnitName()
        for i,unit in pairs(group) do
            if (#attack_unit)==attack_count then
                break
            end
            if unit~=target then
                if unit:IsAlive() then
                    table.insert(attack_unit,unit)
                end
            end
        end
        local attack_effect = keys.attack_effect or GameRules.dandao[unitname]
        for i,unit in pairs(attack_unit) do
            local info =
            {
                Target = unit,
                Source = caster,
                Ability = ability,
                EffectName = attack_effect,
                bDodgeable = false,
                iMoveSpeed = 1800,
                bProvidesVision = false,
                iVisionRadius = 0,
                iVisionTeamNumber = caster:GetTeamNumber(),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
            }
            projectile = ProjectileManager:CreateTrackingProjectile(info)
        end
    end
end

function OnGiveAura( event )
    local hCaster = event.caster
    local ability = event.ability
    local modifierName = event.modifierName
    local radius = 8000
    local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),hCaster:GetAbsOrigin() , nil
    ,radius,DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,0,0,false)
    for i=1,#targets do
        local id = targets[i]:GetPlayerOwnerID()
        if GameRules.role[id+1]=="youxia" then
            ability:ApplyDataDrivenModifier(hCaster,targets[i],modifierName,{})
        end
    end  
end
function GivePowershot( event )
    local hCaster = event.caster
    local ability = event.ability
    local modifierName = event.modifierName
    local radius = event.radius
    local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),hCaster:GetAbsOrigin() , nil
    ,radius,DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,0,0,false)
    for i=1,#targets do
        local id = targets[i]:GetPlayerOwnerID()
        if GameRules.role[id]~="lieren" then
            ability:ApplyDataDrivenModifier(hCaster,targets[i],modifierName,{})
        end
    end  
end
function getAncient( unit )
    while not unit:IsRealHero() do
        unit = unit:GetOwner()
    end
    return unit
end

function DuoChongGongJiDamage( keys )
    local caster = keys.caster
    local target = keys.target
    local attack_damage_lose = keys.attack_damage_lose or 0
    local attack_damage = caster:GetAttackDamage() * ((100-attack_damage_lose)/100)
    local damageType = DAMAGE_TYPE_PHYSICAL
    if caster:HasModifier("modifier_chuancishu1_buff") then
        attack_damage = attack_damage*1.5
    end
    local damageTable = {victim=target,
    attacker=caster,
    damage_type=damageType,
    damage=attack_damage}
    ApplyDamage(damageTable)
end

function OnDarkArrow( data )
    local target = data.unit
    local hCaster = data.caster
    local ability = data.ability
    local kl_damage = ability:GetLevelSpecialValueFor("kl_damage", (ability:GetLevel() - 1))
    local position = target:GetAbsOrigin()
    local kulou = OnZhaoHuan( "npc_kulou",hCaster,position,hCaster:GetTeamNumber(),5 )
    kulou:SetBaseDamageMax(kl_damage)
    kulou:SetBaseDamageMin(kl_damage-5)
end

function OnDaoLunZhan( data )
    local ability = data.ability
    local targets   = data.target_entities
    local hCaster = data.caster
    local particle_name = "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
    local projectile_speed = 1000
    for k,v in pairs(targets) do
        local info = {
            Target = v,
            Source = hCaster,
            Ability = ability,
            EffectName = particle_name,
            bDodgeable = false,
            bProvidesVision = true,
            iMoveSpeed = projectile_speed,
            iVisionRadius = 0,
            iVisionTeamNumber = hCaster:GetTeamNumber(),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
        }
        ProjectileManager:CreateTrackingProjectile( info )
    end
end



function OnIceArrow( data )
    local hCaster = data.caster
    local ability = data.ability
    local target = data.target
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local hit = ability:GetLevelSpecialValueFor("hit", (ability:GetLevel() - 1))
    local num = ability:GetLevelSpecialValueFor("num", (ability:GetLevel() - 1))
    local particle_fissure = data.particleName
    local center = hCaster:GetAbsOrigin()
    local point = target:GetAbsOrigin()
    local movespeed = 1200
    local biaoji = 1
    hCaster:SetContextThink("ice_arrow", 
    function()
        if not hCaster or not hCaster:IsAlive() then
            return nil
        end
        local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),hCaster:GetAbsOrigin() , nil
    ,1500,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)        
        if biaoji > num then
            return nil
        end
        local tpoint = point+RandomVector(radius)
        local distance = (tpoint-center):Length2D()
        biaoji = biaoji + 1
        local forward_v = (tpoint-center):Normalized()
        local fissure_projectile1 = {
        Ability             = ability,
        EffectName          = particle_fissure,
        vSpawnOrigin        = center+Vector(0,0,100),
        fDistance           = distance,
        fStartRadius        = hit,
        fEndRadius          = hit,
        Source              = hCaster,
        bHasFrontalCone     = false,
        bReplaceExisting    = false,
        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
    --  iUnitTargetFlags    = ,
        iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    --  fExpireTime         = ,
        bDeleteOnHit        = false,
        vVelocity           = movespeed*forward_v,
        bProvidesVision     = true,
        iVisionRadius       = 10,
    --  iVisionTeamNumber   = caster:GetTeamNumber(),
        }
        ProjectileManager:CreateLinearProjectile( fissure_projectile1 )
        hCaster:EmitSound("Hero_DrowRanger.ProjectileImpact")
        return 0.1
    end,0)
end

function OnFireRain(data)
    local hCaster = data.caster
    local ability = data.ability
    local target = data.target
    local num = ability:GetLevelSpecialValueFor("num", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local damage_init = ability:GetLevelSpecialValueFor("damage_init", (ability:GetLevel() - 1))
    local distance = radius
    local movespeed = 1800
    local biaoji = 1
    local vvv = 
    {
        Vector(-radius/2,radius*0.85,0),Vector(radius/2,radius*0.85,0),
        Vector(-radius,0,0),Vector(0,0,0),Vector(radius,0,0),
        Vector(-radius/2,-radius*0.85,0),Vector(radius/2,-radius*0.85,0)
    }
    --local dd = math.floor(radius/200)
    local pos_t = target:GetAbsOrigin()
    hCaster:SetContextThink("fire_rain", 
    function()
        if not hCaster or not hCaster:IsAlive() or biaoji>num then
            return nil
        end
        biaoji = biaoji + 1
        for i=1,7 do
            local pts = ParticleManager:CreateParticle("particles/youxia/fire_rain.vpcf",
             PATTACH_CUSTOMORIGIN, hCaster)
            local __pos = vvv[i]+pos_t
            ParticleManager:SetParticleControl(pts,0,__pos)
            GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
            function()
                ParticleManager:DestroyParticle(pts,true)
            end,1)
        end
        hCaster:SetContextThink("cause_Damage",
        function()
            if not hCaster or not hCaster:IsAlive() then
                return
            end
            local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),pos_t , nil
            ,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_CLOSEST,false)
            for k,v in pairs(targets) do
                ability:ApplyDataDrivenModifier(hCaster, v, "modifier_fire_rain_debuff", {})
                local damageTable = 
                {
                    victim = v,    --受到伤害的单位
                    attacker = hCaster,          --造成伤害的单位
                    damage = damage_init,
                    damage_type = DAMAGE_TYPE_MAGICAL
                }
                local num = ApplyDamage(damageTable)
            end
            return nil
        end,0.4)
        EmitSoundOn("Hero_Jakiro.LiquidFire",hCaster)
        return 0.7
    end, 0)
end

function OnFireNet(data)
    local hCaster = data.caster
    local ability = data.ability
    local target = data.target
    local abilityLevel = ability:GetLevel() - 1
    local num = ability:GetLevelSpecialValueFor("num", abilityLevel)
    local radius = ability:GetLevelSpecialValueFor("radius",abilityLevel)
    local duration = ability:GetLevelSpecialValueFor("duration",abilityLevel)
    local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),target:GetAbsOrigin() ,
     nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,FIND_CLOSEST,false)
    if #targets==0 then
        return 
    end
    --print("start fireNet")
    local modifierName = data.modifierName
    num = math.min(num,#targets)
    --[[
    if not hCaster.targets then
        hCaster.targets = {}
    end
    local targetsNumber = #hCaster.targets
    for i=targetsNumber,1,-1 do
        table.remove(hCaster.targets, i)
    end ]]
    for i=1,num do
        --table.insert(hCaster.targets, targets[i])
        ability:ApplyDataDrivenModifier(hCaster, targets[i],modifierName , {duration = duration })
    end
    --ability:StartCooldown(6)
    --ability:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_fire_net_debuff_caster", {})
end

function OnInterrupt(event)
    local hCaster = event.caster
    local targetsNum = #hCaster.targets
    local modifierName = event.modifierName
    for i=targetsNum,1,-1 do
        if hCaster.targets[i]:HasModifier(modifierName) then
            local hModifier = hCaster.targets[i]:FindModifierByNameAndCaster(modifierName,hCaster)
            if hModifier and not hCaster.targets[i]:IsNull() then
                hCaster.targets[i]:RemoveModifierByNameAndCaster(modifierName,hCaster)
            end
        end
    end

end

function YouXiaCheckAutocastTarget( event )
    local hCaster = event.caster
    local ability = event.ability 
    local target = event.target
    local radius = event.radius
    local post = target:GetAbsOrigin()
    local posc = hCaster:GetAbsOrigin()
    if (post-posc):Length2D()>=radius then
        return 
    end
    if ability:IsFullyCastable() and ability:GetAutoCastState() then
        local _order =
        {
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            UnitIndex = hCaster:entindex(),
            TargetIndex = target:entindex(),
            AbilityIndex = ability:entindex()
        }
        hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
    end
end

function YouXiaCheckAutocastNoTarget( event )
    local hCaster = event.caster
    local ability = event.ability 
    
    if ability:IsFullyCastable() and ability:GetAutoCastState() then
        local _order =
        {
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            UnitIndex = hCaster:entindex(),
            AbilityIndex = ability:entindex()
        }
        hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
    end
end

function OnThunderShield(data)
    local ability = data.ability
    local hCaster = data.caster
    local target = data.target
    local damage = ability:GetAbilityDamage()
    local radius = data.radius
    local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),target:GetAbsOrigin() ,
    nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,FIND_CLOSEST,false)
    
    for k,v in pairs(targets) do
        if not v:HasFlyMovementCapability() and v~=target then
            local damageTable = 
            {
                victim = v,    --受到伤害的单位
                attacker = hCaster,          --造成伤害的单位
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL
            }
            local num = ApplyDamage(damageTable)
        end
    end
end

function OnIceBall( data )
    local hCaster = data.caster
    local ability = data.ability
    local target = data.target
    local num = ability:GetLevelSpecialValueFor("num", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),target:GetAbsOrigin() , nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,0,FIND_CLOSEST,false)
    if #targets==0 then
        return 
    end
    local particle_name = data.particleName
    local projectile_speed = 1000
    local teamNumber = hCaster:GetTeamNumber()
    num = math.min(num,#targets)
    for i=1,num do
        local info = {
            Target = targets[i],
            Source = hCaster,
            Ability = ability,
            EffectName = particle_name,
            bDodgeable = false,
            bProvidesVision = true,
            iMoveSpeed = projectile_speed,
            iVisionRadius = 10,
            iVisionTeamNumber = teamNumber,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
        }
        ProjectileManager:CreateTrackingProjectile( info )
    end
end

function OnIceBallDamage(data)
    local hCaster = data.caster
    local id = hCaster:GetPlayerOwnerID()
    local damage = (PlayerResource:GetLastHits(id))*GameRules.gw_lv*2
    local ability = data.ability
    local target = data.target
    local damageTable = 
    {
        victim = target,    --受到伤害的单位
        attacker = hCaster,          --造成伤害的单位
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    local num = ApplyDamage(damageTable)
    local rd = RandomInt(40, 80)
    local armor_stack = math.floor(target:GetPhysicalArmorValue()*(100-rd)/100)
    ability:ApplyDataDrivenModifier(hCaster, target, data.modifierName,{})
    target:SetModifierStackCount( data.modifierName, ability, armor_stack )
end
--游侠技能 测试 ：注意两个相同单位同时释放技能时的特效问题

function OnDuWudamage(event)
    local hCaster = event.caster
    local target = event.target
    local ability = event.ability
    local damage = ability:GetAbilityDamage()

    local damage_table = {}
    damage_table.attacker = hCaster
    damage_table.victim = target
    damage_table.damage_type = ability:GetAbilityDamageType()
    damage_table.ability = ability
    damage_table.damage = damage
    damage_table.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL

    ApplyDamage(damage_table)
end