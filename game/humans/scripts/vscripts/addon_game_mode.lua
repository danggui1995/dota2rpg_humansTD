-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
	_G.CAddonTemplateGameMode = CAddonTemplateGameMode
end
require('gxTable')
require('ability/ability_utils')
require("libraries/buildinghelper")
require('libraries/notifications')
require('libraries/timers')
require('libraries/popups')
require('gamemode')
require('musicsystem')

function Precache( context )
	--[[ Model ghost and grid particles
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
	PrecacheResource("particle_folder", "particles/econ/items/earthshaker/earthshaker_gravelmaw/", context)

	-- Resources used
	PrecacheUnitByNameSync("peasant", context)
	PrecacheUnitByNameSync("tower", context)
	PrecacheUnitByNameSync("tower_tier2", context)
	PrecacheUnitByNameSync("city_center", context)
	PrecacheUnitByNameSync("city_center_tier2", context)
	PrecacheUnitByNameSync("tech_center", context)
	PrecacheUnitByNameSync("dragon_tower", context)
	PrecacheUnitByNameSync("dark_tower", context)
	PrecacheUnitByNameSync("wall", context)

	PrecacheItemByNameSync("item_apply_modifiers", context)
	]]
	--PrecacheEveryThingFromKV( context )
	PrecacheLtx(context)
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
end
--[[
function PrecacheEveryThingFromKV( context )
    local kv_files = 
    {
	    "scripts/npc/npc_units_custom.txt",
	    "scripts/npc/npc_abilities_custom.txt",
	    "scripts/npc/npc_heroes_custom.txt"
	    --"npc_items_custom.txt"
	}
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
            PrecacheEverythingFromTable( context, kvs)
        end
    end
    local sp = 
	{
		"models/items/drow/weapon_howling_wind.vmdl",
		"models/items/drow/anuxi_wurm_booties/anuxi_wurm_booties.vmdl",
		"models/items/drow/black_wind_shoulders/black_wind_shoulders.vmdl",
		"models/items/drow/dragonstouch_arms/dragonstouch_arms.vmdl",
		"models/items/drow/black_wind_back/black_wind_back.vmdl",
		"models/items/drow/black_wind_legs/black_wind_legs.vmdl",
		"models/items/drow/anuxi_wurm_head/anuxi_wurm_head.vmdl",

		"models/items/clinkz/bone_fletcher_head_helmet/bone_fletcher_head_helmet.vmdl",
		"models/items/clinkz/clinkz_shoulders_goc/clinkz_shoulders_goc.vmdl",
		"models/items/clinkz/molten_genesis/molten_genesis.vmdl",
		"models/items/clinkz/redbull_clinkz_gloves/redbull_clinkz_gloves.vmdl",

		"models/items/phantom_assassin/kiss_of_crows_weapon/kiss_of_crows_weapon.vmdl",
		"models/items/phantom_assassin/phantom_knight_shoulder/phantom_knight_shoulder.vmdl",
		"models/items/phantom_assassin/kiss_of_crows_head/kiss_of_crows_head.vmdl",
		"models/items/phantom_assassin/phantom_knight_belt/phantom_knight_belt.vmdl",
		"models/items/phantom_assassin/phantom_knight_back/phantom_knight_back.vmdl",

		"models/items/enchantress/enchantress_crown.vmdl",
		"models/items/enchantress/meadows_mercy/meadows_mercy.vmdl",

		"models/items/lina/feathery_soul_belt/feathery_soul_belt.vmdl",
		"models/items/lina/scales_of_the_burning_dragon_head/scales_of_the_burning_dragon_head.vmdl",
		"models/items/lina/bewitching_flame_belt/bewitching_flame_belt.vmdl",
		"models/items/lina/hwang_jin_yiarms/hwang_jin_yiarms.vmdl",

		"models/items/windrunner/armaments_of_the_wind_head/armaments_of_the_wind_head.vmdl",
		"models/items/windrunner/rainmaker_bow/rainmaker_bow.vmdl",
		"models/items/windrunner/sparrowhawk_cape/sparrowhawk_cape.vmdl",
		"models/items/windrunner/orchid_flowersong_shoulder/orchid_flowersong_shoulder.vmdl",

		"models/items/medusa/blueice_weapon/blueice_weapon.vmdl",
		"models/items/medusa/blueice_armor/blueice_armor.vmdl",
		"models/items/medusa/forsaken_beauty_tail/forsaken_beauty_tail.vmdl",

		"models/items/mirana/warden_of_the_eternal_night_mount/warden_of_the_eternal_night_mount.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_weapon/warden_of_the_eternal_night_weapon.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_shoulder/warden_of_the_eternal_night_shoulder.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_misc/warden_of_the_eternal_night_misc.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_head/warden_of_the_eternal_night_head.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_back/warden_of_the_eternal_night_back.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_arms/warden_of_the_eternal_night_arms.vmdl",

		"models/heroes/spirit_breaker/spirit_breaker_head.vmdl",
		"models/items/spirit_breaker/elemental_realms_shoulder/elemental_realms_shoulder.vmdl",
		"models/items/spirit_breaker/elemental_realms_head/elemental_realms_head.vmdl",
		"models/items/spirit_breaker/elemental_realms_weapon/elemental_realms_weapon.vmdl",

		"models/items/ursa/hat_alpine.vmdl",
		"models/items/ursa/gloves_alpine.vmdl",
		"models/items/ursa/pants_alpine.vmdl",
		"models/items/ursa/swift_claw_ursa_arms/ursa_swift_claw.vmdl",
		"models/items/ursa/fierce_heart_belt/fierce_heart_belt.vmdl",

		"models/items/furion/flowerstaff.vmdl",
		"models/items/furion/sovereign_beard/sovereign_beard.vmdl",
		"models/items/furion/horns_moose_1.vmdl",
		"models/items/furion/fungal_lord_arms/fungal_lord_arms.vmdl",
		"models/items/furion/primeval_back/primeval_back.vmdl",

		"models/items/bounty_hunter/corruption_shoulder/corruption_shoulder.vmdl",
		"models/heroes/bounty_hunter/bounty_hunter_pads.vmdl",
		"models/items/bounty_hunter/bounty_scout_back/bounty_scout_back.vmdl",
		"models/items/bounty_hunter/hunternoname_head/hunternoname_head.vmdl",
		"models/items/bounty_hunter/hunternoname_armor/hunternoname_armor.vmdl",

		"models/items/lycan/ambry_belt/ambry_belt.vmdl",
		"models/items/lycan/ambry_armor/ambry_armor.vmdl",
		"models/heroes/lycan/lycan_head.vmdl",
		"models/items/lycan/ambry_head/ambry_head.vmdl",
		"models/items/lycan/ambry_shoulder/ambry_shoulder.vmdl",
		"models/items/lycan/ambry_weapon/ambry_weapon.vmdl",

		"models/items/chaos_knight/discordia_mount/discordia_mount.vmdl",
		"models/items/chaos_knight/weapon_sordo/weapon_sordo.vmdl",
		"models/items/chaos_knight/chaos_legion_helm/chaos_legion_helm.vmdl",
		"models/items/chaos_knight/chaos_legion_drapes/chaos_legion_drapes.vmdl",
		"models/items/chaos_knight/dark_shield/dark_shield.vmdl",

		"models/heroes/luna/luna_head.vmdl",
		"models/items/luna/headress_of_the_crescent_moon/headress_of_the_crescent_moon.vmdl",
		"models/items/luna/umbra_rider_weapon/umbra_rider_weapon.vmdl",
		"models/items/luna/selemenes_eclipse_mount/selemenes_eclipse_mount.vmdl",
		"models/items/luna/selemenes_eclipse_shield/selemenes_eclipse_shield.vmdl",

		"models/items/disruptor/lightning_strike_legs/lightning_strike_legs.vmdl",
		"models/items/disruptor/thunder_ram_shoulder/thunder_ram_shoulder.vmdl",
		"models/items/disruptor/thunder_ram_head/thunder_ram_head.vmdl",
		"models/items/disruptor/stormlands_back/stormlands_back.vmdl",
		"models/items/disruptor/stormlands_arms/stormlands_arms.vmdl",

		"models/items/dragon_knight/wurmblood_head/wurmblood_head.vmdl",
		"models/items/dragon_knight/wurmblood_back/wurmblood_back.vmdl",
		"models/items/dragon_knight/fireborn_shield/fireborn_shield.vmdl",
		"models/items/dragon_knight/dragon_lord_arms/dragon_lord_arms.vmdl",
		"models/items/dragon_knight/wurmblood_shoulder/wurmblood_shoulder.vmdl",

		"models/items/sniper/cunning_trappers_weapon/cunning_trappers_weapon.vmdl",
		"models/items/sniper/wolf_hat_dark/wolf_hat_dark.vmdl",

		"models/items/lanaya/hiddenflower_armor/hiddenflower_armor.vmdl",
		"models/heroes/lanaya/lanaya_cowl_shoulder.vmdl",
		"models/items/lanaya/hiddenflower_head/hiddenflower_head.vmdl",

		"models/items/silencer/bts_final_utterance_head/bts_final_utterance_head.vmdl",
		"models/items/silencer/bts_final_utterance_shoulder/bts_final_utterance_shoulder.vmdl",
		"models/items/silencer/bts_final_utterance_offhand/bts_final_utterance_offhand.vmdl",
		"models/items/silencer/bts_final_utterance_belt/bts_final_utterance_belt.vmdl",

		"models/items/juggernaut/dc_legsupdate5/dc_legsupdate5.vmdl",
		"models/items/juggernaut/dc_backupdate4/dc_backupdate4.vmdl",
		"models/items/juggernaut/dc_headupdate/dc_headupdate.vmdl",
		"models/items/juggernaut/fire_of_the_exiled_ronin/fire_of_the_exiled_ronin.vmdl",

		"models/heroes/techies/techies_squee_costume.vmdl",
		"models/heroes/techies/techies_cart.vmdl",
		"models/heroes/techies/techies_spleen_costume.vmdl",
		"models/heroes/techies/techies_spleen_weapon.vmdl",

		"models/items/kunkka/kunkka_shadow_blade/kunkka_shadow_blade.vmdl",
		"models/items/kunkka/pw_kraken_hat/kunkka_hair.vmdl",
		"models/items/kunkka/treds_of_the_kunkkistadore/treds_of_the_kunkkistadore.vmdl",
		"models/items/kunkka/claddish_gloves/claddish_gloves.vmdl",

		"models/items/juggernaut/generic_wep_broadsword.vmdl",
		"models/items/juggernaut/esl_dashing_bladelord_legs/esl_dashing_bladelord_legs.vmdl",
		"models/items/juggernaut/gifts_of_the_vanished_head/gifts_of_the_vanished_head.vmdl",
		"models/items/juggernaut/armor_of_kogu/armor_of_kogu.vmdl",

		"models/items/ember_spirit/rapier_burning_god_offhand/rapier_burning_god_offhand.vmdl",
		"models/items/ember_spirit/rapier_burning_god_weapon/rapier_burning_god_weapon.vmdl",
		"models/items/ember_spirit/blazearmor_belt/blazearmor_belt.vmdl",
		"models/items/ember_spirit/rekindled_ashes_head/rekindled_ashes_head.vmdl",
		"models/items/ember_spirit/rekindled_ashes_shoulder/rekindled_ashes_shoulder.vmdl",

		"models/items/rattletrap/eternal_machine_head/eternal_machine_head.vmdl",

		"models/heroes/alchemist/alchemist_ogre_head.vmdl",
		"models/heroes/alchemist/alchemist_goblin_body.vmdl",
		"models/heroes/alchemist/alchemist_goblin_head.vmdl",
		"models/items/alchemist/toxic_siege_blades/toxic_siege_blades.vmdl",
		"models/items/alchemist/convict_trophy_armor/convict_trophy_armor.vmdl",

		"models/items/witchdoctor/witchstaff_weapon/witchstaff_weapon.vmdl",
		"models/items/witchdoctor/twilights_rest_head/twilights_rest_head.vmdl",
		"models/items/witchdoctor/bonkers_the_mad/bonkers_the_mad.vmdl",

		"models/items/antimage/tarrasque_scale_head/tarrasque_scale_head.vmdl",
		"models/items/antimage/tarrasque_scale_belt/tarrasque_scale_belt.vmdl",
		"models/items/antimage/tarrasque_scale_armor/tarrasque_scale_armor.vmdl",
		"models/items/antimage/tarrasque_scale_arms/tarrasque_scale_arms.vmdl",

		"models/items/doom/crown_of_omoz/crown_of_omoz.vmdl",
		"models/items/doom/blazing_lord_shoulder/blazing_lord_shoulder.vmdl",
		"models/items/doom/blazing_lord_belt/blazing_lord_belt.vmdl",
		"models/items/doom/fallen_sword/fallen_sword.vmdl",

		"models/items/rubick/puppet_master_doll/puppet_master_doll.vmdl",
		"models/items/rubick/puppet_master_head/puppet_master_head.vmdl",
		"models/items/rubick/puppet_master_weapon/puppet_master_weapon.vmdl",
		"models/items/rubick/puppet_master_back/puppet_master_back.vmdl",

		"models/heroes/treant_protector/hands.vmdl",
		"models/heroes/treant_protector/legs.vmdl",

		"models/items/tuskarr/barrierrogue_tusk_head/barrierrogue_tusk_head.vmdl",
		"models/items/tuskarr/barrierrogue_tusk_weapon/barrierrogue_tusk_weapon.vmdl",
		"models/heroes/tuskarr/tusk_armor_glove.vmdl",

		"models/items/razor/empire_of_the_lightning_lord_belt/empire_of_the_lightning_lord_belt.vmdl",
		"models/items/razor/empire_of_the_lightning_head/empire_of_the_lightning_head.vmdl",
		"models/items/razor/empire_of_the_lightning_lord_armor/empire_of_the_lightning_lord_armor.vmdl",

		"models/items/slardar/magma_manta_head/magma_manta_head.vmdl",
		"models/items/slardar/magma_manta_weapon/magma_manta_weapon.vmdl",
		"models/items/slardar/magma_manta_back/magma_manta_back.vmdl",

		"models/items/vengefulspirit/echoes_eyrie_shoulder/echoes_eyrie_shoulder.vmdl",
		"models/items/vengefulspirit/forsaken_wings_weapon/forsaken_wings_weapon.vmdl",
		"models/items/vengefulspirit/echoes_eyrie_legs/echoes_eyrie_legs.vmdl",
		"models/items/vengefulspirit/dreadhawk_head/dreadhawk_head.vmdl",

		"models/items/crystal_maiden/belle_head_hair/belle_head_hair.vmdl",
		"models/items/crystal_maiden/frostbringer_shoulders/frostbringer_shoulders.vmdl",
		"models/items/crystal_maiden/euls_scepterdivinity.vmdl",

		"models/items/huskar/armor_of_reckless_vigor_head/armor_of_reckless_vigor_head.vmdl",
		"models/items/huskar/burning_spear/burning_spear.vmdl",
		"models/heroes/huskar/huskar_dagger.vmdl",

		"models/heroes/omniknight/head.vmdl",
		"models/items/omniknight/grey_night_back/grey_night_back.vmdl",
		"models/items/omniknight/grey_night_head/grey_night_head.vmdl",
		"models/items/omniknight/gusa_maul/gusa_maul.vmdl",

		"models/items/magnataur/rage_of_volcano_natives_head/rage_of_volcano_natives_head.vmdl",
		"models/items/magnataur/rage_of_volcano_natives_misc/rage_of_volcano_natives_misc.vmdl",

		"models/heroes/tiny_01/tiny_01_head.vmdl",
		"models/heroes/tiny_01/tiny_01_left_arm.vmdl",
		"models/heroes/tiny_01/tiny_01_right_arm.vmdl",
		"models/heroes/tiny_01/tiny_01_body.vmdl",

		"models/items/warlock/grimoires_shoulder/grimoires_shoulder.vmdl",
		"models/items/warlock/hood_of_the_conjurer/hood_of_the_conjurer.vmdl",
		"models/items/warlock/mdl_warlock_back/mdl_warlock_back.vmdl",

		"models/items/batrider/dotapit_s3_firefly/dotapit_s3_firefly.vmdl",

		"models/items/axe/demon_blood_helm.vmdl",
		"models/items/axe/axe_practos_weapon/axe_practos_weapon.vmdl",

		"models/items/lion/hells_bat_arm/hells_bat_arm.vmdl",
		"models/items/lion/fish_stick/fish_stick.vmdl",
		"models/items/lion/ancient_evil_helm/ancient_evil_helm.vmdl",

		"models/items/keeper_of_the_light/ainidul_the_eternal_retex/ainidul_the_eternal_retex.vmdl",
		"models/heroes/keeper_of_the_light/kotl_hood.vmdl",

		"models/items/skywrath_mage/blessing_of_the_crested_dawn_back/blessing_of_the_crested_dawn_back.vmdl",
		"models/items/skywrath_mage/guiding_lights_weapon1/guiding_lights_weapon1.vmdl",

		"models/items/siren/arms_of_the_captive_princess_armor/arms_of_the_captive_princess_armor.vmdl",
		"models/items/siren/arms_of_the_captive_princess_head/arms_of_the_captive_princess_head.vmdl",

		"models/items/leshrac/bts_ethereal_guardian_head/bts_ethereal_guardian_head.vmdl",

		"models/heroes/invoker/invoker_head.vmdl",
		"models/items/invoker/dark_artistry/dark_artistry_hair_model.vmdl",
		"models/items/invoker/sempiternal_revelations_belt/sempiternal_revelations_belt.vmdl",

		"models/items/storm_spirit/esl_harmony_armor/esl_harmony_armor.vmdl",
		"models/items/storm_spirit/esl_harmony_arms/esl_harmony_arms.vmdl",
		"models/items/storm_spirit/anuxi_ring_of_storm/anuxi_ring_of_storm.vmdl",

		"models/items/death_prophet/fatal_blossom_armor/fatal_blossom_armor.vmdl",
		"models/items/death_prophet/coronet_of_the_mortal_coil/coronet_of_the_mortal_coil.vmdl",
		"models/items/death_prophet/fatal_blossom_skirt/fatal_blossom_skirt.vmdl",

		"models/items/obsidian_destroyer/herald_of_measureless_ruin_head/herald_of_measureless_ruin_head.vmdl",
		"models/items/obsidian_destroyer/herald_of_measureless_ruin_back/herald_of_measureless_ruin_back.vmdl",
		"models/items/obsidian_destroyer/immortal_weapon_1/immortal_weapon_1.vmdl",
		"models/items/obsidian_destroyer/herald_of_measureless_ruin_armor/herald_of_measureless_ruin_armor.vmdl",

		"models/items/dazzle/shadowflame_weapon/shadowflame_weapon.vmdl",
		"models/items/dazzle/shadowflame_legs/shadowflame_legs.vmdl",
		"models/items/dazzle/shadowflame_misc/shadowflame_misc.vmdl",
		"models/heroes/dazzle/dazzle_mohawk.vmdl",

		"models/items/nightstalker/black_nihility/black_nihility_night_back.vmdl",

		"models/heroes/troll_warlord/troll_warlord_head.vmdl",
		"models/heroes/troll_warlord/troll_warlord_axe_melee_l.vmdl",
		"models/heroes/troll_warlord/troll_warlord_axe_ranged_r.vmdl",

		"models/items/antimage/pw_tustarkuri_weapon/antimage_weapon_lod0.vmdl",
		"models/items/antimage/pw_tustarkuri_weapon_offhand/antimage_weapon_offhand_lod0.vmdl",
		"models/items/antimage/leggings_of_the_awakened/leggings_of_the_awakened.vmdl"
	}
	local t = #sp
	for i=1,t do
		PrecacheResource("model", sp[i], context)
		print("PrecacheResource:",sp[i])
	end

	local task_part_ltx = 
	{
		"particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash_water9b.vpcf",
		"particles/units/heroes/hero_dazzle/dazzle_base_attack.vpcf",
		"particles/units/heroes/hero_huskar/huskar_base_attack.vpcf",
		"particles/units/heroes/hero_invoker/invoker_base_attack.vpcf",
		"particles/units/heroes/hero_lina/lina_base_attack.vpcf",
		"particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
		"particles/units/heroes/hero_razor/razor_base_attack.vpcf",
		"particles/units/heroes/hero_shadow_demon/shadow_demon_base_attack.vpcf",
		"particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf",
		"particles/econ/items/sniper/sniper_charlie/sniper_base_attack_bulletcase_charlie.vpcf",
		"particles/units/heroes/hero_tinker/tinker_base_attack.vpcf",
		"particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf",
		"particles/econ/items/witch_doctor/witch_doctor_ribbitar/witchdoctor_ward_cast_staff_fire_ribbitar_c.vpcf",
		"particles/econ/items/zeus/lightning_weapon_fx/zuus_base_attack_arc_immortal_lightning.vpcf",
		"particles/items_fx/desolator_projectile.vpcf",
		"particles/econ/items/keeper_of_the_light/kotl_weapon_arcane_staff/keeper_base_attack_arcane_staff.vpcf",
		"particles/units/heroes/hero_viper/viper_base_attack.vpcf",
		"particles/heroes/shikieiki/ability_eirin_04_light_c.vpcf",			--accept task particle
		"particles/items2_fx/refresher.vpcf",
		"particles/myprojectile/mojianshi_baseattack.vpcf",
		"particles/levelup.vpcf",
		"particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf",
		--taozhuang texiao
		"particles/taozhuang/lieren.vpcf",
		"particles/taozhuang/yemanren.vpcf",
		"particles/taozhuang/mojianshi.vpcf",
		"particles/taozhuang/youxia.vpcf",
		"particles/taozhuang/xiaotou.vpcf",
		"particles/taozhuang/shushi.vpcf"
	}
	--[[
	local npart_ltx = #task_part_ltx
	for i=1,npart_ltx do
		PrecacheResource("particle", task_part_ltx[i], context)

		print("PrecacheResource:",task_part_ltx[i])
	end

	local sound_ltx = 
	{
		"soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lich.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_chen.vsndevts",
		"soundevents/custom_sound_events.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts",
		"soundevents/voscripts/game_sounds_vo_secretshop.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_viper.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_slark.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lion.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts"
	}
	local nsound_ltx = #sound_ltx
	for i=1,nsound_ltx do
		PrecacheResource("soundfile", sound_ltx[i], context)
		print("PrecacheResource:",sound_ltx[i])
	end
	
end
]]
function PrecacheLtx(context)
	local modelstr={
		"models/courier/lockjaw/lockjaw_flying.vmdl",
		"models/items/drow/black_wind_legs/black_wind_legs.vmdl",
		"models/items/medusa/blueice_weapon/blueice_weapon.vmdl",
		"models/items/furion/treant/father_treant/father_treant.vmdl",
		"models/items/alchemist/toxic_siege_blades/toxic_siege_blades.vmdl",
		"models/items/courier/faceless_rex/faceless_rex.vmdl",
		"models/courier/smeevil/smeevil_flying.vmdl",
		"models/items/windrunner/orchid_flowersong_shoulder/orchid_flowersong_shoulder.vmdl",
		"models/items/vengefulspirit/forsaken_wings_weapon/forsaken_wings_weapon.vmdl",
		"models/items/ursa/pants_alpine.vmdl",
		"models/items/omniknight/grey_night_back/grey_night_back.vmdl",
		"models/heroes/tuskarr/tuskarr.vmdl",
		"models/items/lycan/ambry_head/ambry_head.vmdl",
		"models/heroes/treant_protector/hands.vmdl",
		"models/items/lanaya/hiddenflower_head/hiddenflower_head.vmdl",
		"models/heroes/tiny_01/tiny_01_left_arm.vmdl",
		"models/items/phantom_assassin/phantom_knight_belt/phantom_knight_belt.vmdl",
		"models/items/invoker/sempiternal_revelations_belt/sempiternal_revelations_belt.vmdl",
		"models/items/leshrac/bts_ethereal_guardian_head/bts_ethereal_guardian_head.vmdl",
		"models/items/furion/flowerstaff.vmdl",
		"models/items/tuskarr/barrierrogue_tusk_weapon/barrierrogue_tusk_weapon.vmdl",
		"models/items/courier/blotto_and_stick/blotto.vmdl",
		"models/items/courier/snapjaw/snapjaw_flying.vmdl",
		"models/items/rubick/puppet_master_head/puppet_master_head.vmdl",
		"models/items/spirit_breaker/elemental_realms_head/elemental_realms_head.vmdl",
		"models/items/luna/selemenes_eclipse_mount/selemenes_eclipse_mount.vmdl",
		"models/heroes/alchemist/alchemist_goblin_body.vmdl",
		"models/heroes/windrunner/windrunner.vmdl",
		"models/items/spirit_breaker/elemental_realms_shoulder/elemental_realms_shoulder.vmdl",
		"models/heroes/phantom_assassin/phantom_assassin.vmdl",
		"models/heroes/bounty_hunter/bounty_hunter_pads.vmdl",
		"models/items/rubick/puppet_master_doll/puppet_master_doll.vmdl",
		"models/items/furion/horns_moose_1.vmdl",
		"models/items/lion/fish_stick/fish_stick.vmdl",
		"models/items/dragon_knight/wurmblood_back/wurmblood_back.vmdl",
		"models/items/axe/demon_blood_helm.vmdl",
		"models/courier/juggernaut_dog/juggernaut_dog.vmdl",
		"models/items/slardar/magma_manta_back/magma_manta_back.vmdl",
		"models/heroes/huskar/huskar_dagger.vmdl",
		"models/courier/smeevil_crab/smeevil_crab.vmdl",
		"models/items/lina/hwang_jin_yiarms/hwang_jin_yiarms.vmdl",
		"models/courier/badger/courier_badger.vmdl",
		"models/items/courier/coco_the_courageous/coco_the_courageous.vmdl",
		"models/items/courier/courier_faun/courier_faun.vmdl",
		"models/items/disruptor/lightning_strike_legs/lightning_strike_legs.vmdl",
		"models/items/huskar/armor_of_reckless_vigor_head/armor_of_reckless_vigor_head.vmdl",
		"models/items/slardar/magma_manta_head/magma_manta_head.vmdl",
		"models/heroes/keeper_of_the_light/kotl_hood.vmdl",
		"models/items/lycan/ambry_armor/ambry_armor.vmdl",
		"models/items/dazzle/shadowflame_misc/shadowflame_misc.vmdl",
		"models/items/ursa/swift_claw_ursa_arms/ursa_swift_claw.vmdl",
		"models/items/courier/carty_dire/carty_dire.vmdl",
		"models/items/bounty_hunter/hunternoname_head/hunternoname_head.vmdl",
		"models/items/clinkz/bone_fletcher_head_helmet/bone_fletcher_head_helmet.vmdl",
		"models/items/lycan/ambry_weapon/ambry_weapon.vmdl",
		"models/items/enchantress/enchantress_crown.vmdl",
		"models/items/courier/d2l_steambear/d2l_steambear.vmdl",
		"models/heroes/pedestal/effigy_pedestal_ti5.vmdl",
		"models/heroes/sniper/sniper.vmdl",
		"models/items/kunkka/kunkka_shadow_blade/kunkka_shadow_blade.vmdl",
		"models/heroes/death_prophet/death_prophet.vmdl",
		"models/heroes/rikimaru/rikimaru.vmdl",
		"models/items/dragon_knight/fireborn_shield/fireborn_shield.vmdl",
		"models/items/spirit_breaker/elemental_realms_weapon/elemental_realms_weapon.vmdl",
		"models/items/drow/black_wind_shoulders/black_wind_shoulders.vmdl",
		"models/heroes/twin_headed_dragon/twin_headed_dragon.vmdl",
		"models/heroes/razor/razor.vmdl",
		"models/items/courier/fei_lian_blue/fei_lian_blue.vmdl",
		"models/heroes/luna/luna_head.vmdl",
		"models/items/witchdoctor/bonkers_the_mad/bonkers_the_mad.vmdl",
		"models/heroes/warlock/warlock_demon.vmdl",
		"models/items/courier/pumpkin_courier/pumpkin_courier.vmdl",
		"models/items/clinkz/redbull_clinkz_gloves/redbull_clinkz_gloves.vmdl",
		"models/courier/f2p_courier/f2p_courier.vmdl",
		"models/items/clinkz/clinkz_shoulders_goc/clinkz_shoulders_goc.vmdl",
		"models/items/courier/mok/mok.vmdl",
		"models/items/antimage/tarrasque_scale_arms/tarrasque_scale_arms.vmdl",
		"models/heroes/arc_warden/mesh/spark_wraith.vmdl",
		"models/items/warlock/hood_of_the_conjurer/hood_of_the_conjurer.vmdl",
		"models/items/lina/feathery_soul_belt/feathery_soul_belt.vmdl",
		"models/heroes/crystal_maiden/crystal_maiden_arcana.vmdl",
		"models/courier/venoling/venoling.vmdl",
		"models/items/furion/treant/eternalseasons_treant/eternalseasons_treant.vmdl",
		"models/items/courier/bookwyrm/bookwyrm.vmdl",
		"models/items/drow/anuxi_wurm_booties/anuxi_wurm_booties.vmdl",
		"models/items/antimage/tarrasque_scale_armor/tarrasque_scale_armor.vmdl",
		"models/heroes/rattletrap/rattletrap.vmdl",
		"models/items/phantom_assassin/kiss_of_crows_head/kiss_of_crows_head.vmdl",
		"models/heroes/life_stealer/life_stealer.vmdl",
		"models/items/luna/selemenes_eclipse_shield/selemenes_eclipse_shield.vmdl",
		"models/items/courier/deathripper/deathripper.vmdl",
		"models/heroes/techies/techies_spleen_weapon.vmdl",
		"models/items/storm_spirit/anuxi_ring_of_storm/anuxi_ring_of_storm.vmdl",
		"models/items/drow/weapon_howling_wind.vmdl",
		"models/items/disruptor/thunder_ram_shoulder/thunder_ram_shoulder.vmdl",
		"models/items/storm_spirit/esl_harmony_arms/esl_harmony_arms.vmdl",
		"models/courier/gold_mega_greevil/gold_mega_greevil.vmdl",
		"models/items/courier/bajie_pig/bajie_pig.vmdl",
		"models/items/windrunner/rainmaker_bow/rainmaker_bow.vmdl",
		"models/items/dragon_knight/dragon_lord_arms/dragon_lord_arms.vmdl",
		"models/items/courier/bearzky/bearzky.vmdl",
		"models/items/courier/corsair_ship/corsair_ship.vmdl",
		"models/items/phantom_assassin/kiss_of_crows_weapon/kiss_of_crows_weapon.vmdl",
		"models/heroes/keeper_of_the_light/keeper_of_the_light.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_arms/warden_of_the_eternal_night_arms.vmdl",
		"models/items/courier/bucktooth_jerry/bucktooth_jerry.vmdl",
		"models/heroes/zeus/zeus.vmdl",
		"models/items/disruptor/thunder_ram_head/thunder_ram_head.vmdl",
		"models/items/alchemist/convict_trophy_armor/convict_trophy_armor.vmdl",
		"models/heroes/lycan/lycan.vmdl",
		"models/heroes/luna/luna.vmdl",
		"models/items/silencer/bts_final_utterance_head/bts_final_utterance_head.vmdl",
		"models/items/courier/dokkaebi_nexon_courier/dokkaebi_nexon_courier.vmdl",
		"models/heroes/morphling/morphling.vmdl",
		"models/items/enchantress/meadows_mercy/meadows_mercy.vmdl",
		"models/heroes/pedestal/pedestal_effigy_jade.vmdl",
		"models/heroes/storm_spirit/storm_spirit.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_shoulder/warden_of_the_eternal_night_shoulder.vmdl",
		"models/heroes/spirit_breaker/spirit_breaker.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_misc/warden_of_the_eternal_night_misc.vmdl",
		"models/heroes/tidehunter/tidehunter.vmdl",
		"models/heroes/dragon_knight/dragon_knight.vmdl",
		"models/items/phantom_assassin/phantom_knight_back/phantom_knight_back.vmdl",
		"models/items/antimage/leggings_of_the_awakened/leggings_of_the_awakened.vmdl",
		"models/items/razor/empire_of_the_lightning_lord_belt/empire_of_the_lightning_lord_belt.vmdl",
		"models/items/warlock/mdl_warlock_back/mdl_warlock_back.vmdl",
		"models/heroes/invoker/invoker.vmdl",
		"models/items/courier/axolotl/axolotl.vmdl",
		"models/items/lone_druid/true_form/dark_wood_true_form/dark_wood_true_form.vmdl",
		"models/items/ursa/fierce_heart_belt/fierce_heart_belt.vmdl",
		"models/items/silencer/bts_final_utterance_shoulder/bts_final_utterance_shoulder.vmdl",
		"models/items/juggernaut/generic_wep_broadsword.vmdl",
		"models/heroes/witchdoctor/witchdoctor.vmdl",
		"models/items/storm_spirit/esl_harmony_armor/esl_harmony_armor.vmdl",
		"models/heroes/mirana/mirana.vmdl",
		"models/courier/imp/imp.vmdl",
		"models/items/juggernaut/armor_of_kogu/armor_of_kogu.vmdl",
		"models/items/ember_spirit/rapier_burning_god_offhand/rapier_burning_god_offhand.vmdl",
		"models/heroes/lion/lion.vmdl",
		"models/items/rubick/puppet_master_weapon/puppet_master_weapon.vmdl",
		"models/heroes/beastmaster/beastmaster.vmdl",
		"models/props_structures/tower_dragon_white.vmdl",
		"models/heroes/huskar/huskar.vmdl",
		"models/development/invisiblebox.vmdl",
		"models/heroes/spirit_breaker/spirit_breaker_head.vmdl",
		"models/items/ursa/gloves_alpine.vmdl",
		"models/items/sniper/cunning_trappers_weapon/cunning_trappers_weapon.vmdl",
		"models/items/lycan/ambry_shoulder/ambry_shoulder.vmdl",
		"models/heroes/lanaya/lanaya.vmdl",
		"models/heroes/alchemist/alchemist_goblin_head.vmdl",
		"models/items/windrunner/sparrowhawk_cape/sparrowhawk_cape.vmdl",
		"models/items/juggernaut/dc_legsupdate5/dc_legsupdate5.vmdl",
		"models/items/courier/deathbringer/deathbringer.vmdl",
		"models/items/razor/empire_of_the_lightning_head/empire_of_the_lightning_head.vmdl",
		"models/items/lanaya/hiddenflower_armor/hiddenflower_armor.vmdl",
		"models/items/courier/chocobo/chocobo.vmdl",
		"models/heroes/kunkka/kunkka.vmdl",
		"models/courier/mighty_boar/mighty_boar.vmdl",
		"models/heroes/ursa/ursa.vmdl",
		"models/heroes/drow/drow.vmdl",
		"models/heroes/medusa/medusa.vmdl",
		"models/courier/ram/ram_flying.vmdl",
		"models/heroes/alchemist/alchemist.vmdl",
		"models/heroes/ember_spirit/ember_spirit.vmdl",
		"models/items/doom/blazing_lord_belt/blazing_lord_belt.vmdl",
		"models/items/courier/boooofus_courier/boooofus_courier_flying.vmdl",
		"models/items/furion/primeval_back/primeval_back.vmdl",
		"models/items/clinkz/molten_genesis/molten_genesis.vmdl",
		"models/courier/drodo/drodo.vmdl",
		"models/items/dazzle/shadowflame_legs/shadowflame_legs.vmdl",
		"models/items/chaos_knight/weapon_sordo/weapon_sordo.vmdl",
		"models/heroes/lycan/lycan_head.vmdl",
		"models/heroes/dazzle/dazzle.vmdl",
		"models/items/luna/headress_of_the_crescent_moon/headress_of_the_crescent_moon.vmdl",
		"models/heroes/obsidian_destroyer/obsidian_destroyer.vmdl",
		"models/props_debris/barrel002.vmdl",
		"models/items/chaos_knight/chaos_legion_helm/chaos_legion_helm.vmdl",
		"models/heroes/vengeful/vengeful.vmdl",
		"models/heroes/phoenix/phoenix_bird.vmdl",
		"models/courier/smeevil_bird/smeevil_bird.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_weapon/warden_of_the_eternal_night_weapon.vmdl",
		"models/heroes/earthshaker/earthshaker.vmdl",
		"models/courier/flopjaw/flopjaw.vmdl",
		"models/items/witchdoctor/witchstaff_weapon/witchstaff_weapon.vmdl",
		"models/items/lina/scales_of_the_burning_dragon_head/scales_of_the_burning_dragon_head.vmdl",
		"models/heroes/furion/furion.vmdl",
		"models/items/courier/dc_demon/dc_demon.vmdl",
		"models/items/warlock/golem/obsidian_golem/obsidian_golem.vmdl",
		"models/items/doom/fallen_sword/fallen_sword.vmdl",
		"models/items/antimage/pw_tustarkuri_weapon_offhand/antimage_weapon_offhand_lod0.vmdl",
		"models/heroes/axe/axe.vmdl",
		"models/items/antimage/pw_tustarkuri_weapon/antimage_weapon_lod0.vmdl",
		"models/heroes/silencer/silencer.vmdl",
		"models/heroes/leshrac/leshrac.vmdl",
		"models/items/nightstalker/black_nihility/black_nihility_night_back.vmdl",
		"models/items/juggernaut/gifts_of_the_vanished_head/gifts_of_the_vanished_head.vmdl",
		"models/items/silencer/bts_final_utterance_offhand/bts_final_utterance_offhand.vmdl",
		"models/heroes/troll_warlord/troll_warlord_axe_melee_l.vmdl",
		"models/items/dragon_knight/wurmblood_shoulder/wurmblood_shoulder.vmdl",
		"models/items/dazzle/shadowflame_weapon/shadowflame_weapon.vmdl",
		"models/items/obsidian_destroyer/herald_of_measureless_ruin_armor/herald_of_measureless_ruin_armor.vmdl",
		"models/items/obsidian_destroyer/herald_of_measureless_ruin_head/herald_of_measureless_ruin_head.vmdl",
		"models/items/huskar/burning_spear/burning_spear.vmdl",
		"models/courier/courier_mech/courier_mech.vmdl",
		"models/items/doom/blazing_lord_shoulder/blazing_lord_shoulder.vmdl",
		"models/items/obsidian_destroyer/immortal_weapon_1/immortal_weapon_1.vmdl",
		"models/items/death_prophet/fatal_blossom_skirt/fatal_blossom_skirt.vmdl",
		"models/items/death_prophet/coronet_of_the_mortal_coil/coronet_of_the_mortal_coil.vmdl",
		"models/items/death_prophet/fatal_blossom_armor/fatal_blossom_armor.vmdl",
		"models/items/invoker/dark_artistry/dark_artistry_hair_model.vmdl",
		"models/heroes/invoker/invoker_head.vmdl",
		"models/items/siren/arms_of_the_captive_princess_head/arms_of_the_captive_princess_head.vmdl",
		"models/items/courier/coral_furryfish/coral_furryfish.vmdl",
		"models/items/kunkka/treds_of_the_kunkkistadore/treds_of_the_kunkkistadore.vmdl",
		"models/items/siren/arms_of_the_captive_princess_armor/arms_of_the_captive_princess_armor.vmdl",
		"models/items/skywrath_mage/guiding_lights_weapon1/guiding_lights_weapon1.vmdl",
		"models/items/drow/anuxi_wurm_head/anuxi_wurm_head.vmdl",
		"models/items/crystal_maiden/frostbringer_shoulders/frostbringer_shoulders.vmdl",
		"models/items/courier/duskie/duskie.vmdl",
		"models/items/skywrath_mage/blessing_of_the_crested_dawn_back/blessing_of_the_crested_dawn_back.vmdl",
		"models/items/keeper_of_the_light/ainidul_the_eternal_retex/ainidul_the_eternal_retex.vmdl",
		"models/items/lion/ancient_evil_helm/ancient_evil_helm.vmdl",
		"models/heroes/omniknight/head.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_head/warden_of_the_eternal_night_head.vmdl",
		"models/items/ember_spirit/rapier_burning_god_weapon/rapier_burning_god_weapon.vmdl",
		"models/heroes/slardar/slardar.vmdl",
		"models/heroes/pedestal/effigy_pedestal_frost_radiant.vmdl",
		"models/items/omniknight/grey_night_head/grey_night_head.vmdl",
		"models/items/wards/esl_wardchest_radling_ward/esl_wardchest_radling_ward.vmdl",
		"models/items/lion/hells_bat_arm/hells_bat_arm.vmdl",
		"models/courier/defense3_sheep/defense3_sheep.vmdl",
		"models/items/axe/axe_practos_weapon/axe_practos_weapon.vmdl",
		"models/items/furion/sovereign_beard/sovereign_beard.vmdl",
		"models/items/warlock/grimoires_shoulder/grimoires_shoulder.vmdl",
		"models/heroes/tiny_01/tiny_01_body.vmdl",
		"models/heroes/tiny_01/tiny_01_right_arm.vmdl",
		"models/items/ursa/hat_alpine.vmdl",
		"models/items/antimage/tarrasque_scale_head/tarrasque_scale_head.vmdl",
		"models/heroes/tiny_01/tiny_01_head.vmdl",
		"models/items/magnataur/rage_of_volcano_natives_misc/rage_of_volcano_natives_misc.vmdl",
		"models/items/magnataur/rage_of_volcano_natives_head/rage_of_volcano_natives_head.vmdl",
		"models/items/courier/grim_wolf_radiant/grim_wolf_radiant.vmdl",
		"models/items/courier/devourling/devourling.vmdl",
		"models/items/omniknight/gusa_maul/gusa_maul.vmdl",
		"models/items/crystal_maiden/euls_scepterdivinity.vmdl",
		"models/items/courier/arneyb_rabbit/arneyb_rabbit.vmdl",
		"models/items/vengefulspirit/dreadhawk_head/dreadhawk_head.vmdl",
		"models/heroes/siren/siren.vmdl",
		"models/items/vengefulspirit/echoes_eyrie_shoulder/echoes_eyrie_shoulder.vmdl",
		"models/items/slardar/magma_manta_weapon/magma_manta_weapon.vmdl",
		"models/items/courier/billy_bounceback/billy_bounceback.vmdl",
		"models/items/ember_spirit/blazearmor_belt/blazearmor_belt.vmdl",
		"models/items/invoker/forge_spirit/arsenal_magus_forged_spirit/arsenal_magus_forged_spirit.vmdl",
		"models/heroes/phantom_assassin/arcana_pedestal.vmdl",
		"models/heroes/shredder/shredder_body.vmdl",
		"models/heroes/tuskarr/tusk_armor_glove.vmdl",
		"models/items/furion/fungal_lord_arms/fungal_lord_arms.vmdl",
		"models/heroes/magnataur/magnataur.vmdl",
		"models/heroes/techies/techies.vmdl",
		"models/heroes/treant_protector/legs.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_mount/warden_of_the_eternal_night_mount.vmdl",
		"models/items/medusa/forsaken_beauty_tail/forsaken_beauty_tail.vmdl",
		"models/items/doom/crown_of_omoz/crown_of_omoz.vmdl",
		"models/heroes/techies/techies_squee_costume.vmdl",
		"models/items/chaos_knight/dark_shield/dark_shield.vmdl",
		"models/items/antimage/tarrasque_scale_belt/tarrasque_scale_belt.vmdl",
		"models/items/witchdoctor/twilights_rest_head/twilights_rest_head.vmdl",
		"models/heroes/alchemist/alchemist_ogre_head.vmdl",
		"models/items/dragon_knight/wurmblood_head/wurmblood_head.vmdl",
		"models/items/rattletrap/eternal_machine_head/eternal_machine_head.vmdl",
		"models/items/ember_spirit/rekindled_ashes_shoulder/rekindled_ashes_shoulder.vmdl",
		"models/items/ember_spirit/rekindled_ashes_head/rekindled_ashes_head.vmdl",
		"models/heroes/omniknight/omniknight.vmdl",
		"models/items/razor/empire_of_the_lightning_lord_armor/empire_of_the_lightning_lord_armor.vmdl",
		"models/heroes/nightstalker/nightstalker.vmdl",
		"models/items/courier/el_gato_hero/el_gato_hero.vmdl",
		"models/heroes/enchantress/enchantress.vmdl",
		"models/courier/stump/stump.vmdl",
		"models/heroes/antimage/antimage.vmdl",
		"models/items/disruptor/stormlands_back/stormlands_back.vmdl",
		"models/items/juggernaut/ward/dc_wardupate/dc_wardupate.vmdl",
		"models/heroes/batrider/batrider.vmdl",
		"models/heroes/lina/lina.vmdl",
		"models/courier/yak/yak.vmdl",
		"models/items/juggernaut/esl_dashing_bladelord_legs/esl_dashing_bladelord_legs.vmdl",
		"models/courier/mech_donkey/mech_donkey.vmdl",
		"models/items/kunkka/claddish_gloves/claddish_gloves.vmdl",
		"models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl",
		"models/courier/octopus/octopus.vmdl",
		"models/items/kunkka/pw_kraken_hat/kunkka_hair.vmdl",
		"models/items/chaos_knight/discordia_mount/discordia_mount.vmdl",
		"models/items/lycan/ambry_belt/ambry_belt.vmdl",
		"models/items/bounty_hunter/hunternoname_armor/hunternoname_armor.vmdl",
		"models/items/juggernaut/dc_backupdate4/dc_backupdate4.vmdl",
		"models/heroes/techies/techies_spleen_costume.vmdl",
		"models/items/lone_druid/bear/dark_wood_bear/dark_wood_bear.vmdl",
		"models/items/bounty_hunter/bounty_scout_back/bounty_scout_back.vmdl",
		"models/heroes/techies/techies_cart.vmdl",
		"models/heroes/tiny_01/tiny_01.vmdl",
		"models/heroes/bounty_hunter/bounty_hunter.vmdl",
		"models/items/juggernaut/fire_of_the_exiled_ronin/fire_of_the_exiled_ronin.vmdl",
		"models/items/juggernaut/dc_headupdate/dc_headupdate.vmdl",
		"models/items/crystal_maiden/belle_head_hair/belle_head_hair.vmdl",
		"models/items/silencer/bts_final_utterance_belt/bts_final_utterance_belt.vmdl",
		"models/heroes/troll_warlord/troll_warlord_head.vmdl",
		"models/items/tuskarr/barrierrogue_tusk_head/barrierrogue_tusk_head.vmdl",
		"models/heroes/pedestal/effigy_pedestal_radiant.vmdl",
		"models/items/vengefulspirit/echoes_eyrie_legs/echoes_eyrie_legs.vmdl",
		"models/heroes/rubick/rubick.vmdl",
		"models/heroes/disruptor/disruptor.vmdl",
		"models/heroes/slark/slark.vmdl",
		"models/items/courier/captain_bamboo/captain_bamboo.vmdl",
		"models/heroes/lanaya/lanaya_cowl_shoulder.vmdl",
		"models/items/sniper/wolf_hat_dark/wolf_hat_dark.vmdl",
		"models/heroes/chaos_knight/chaos_knight.vmdl",
		"models/heroes/dazzle/dazzle_mohawk.vmdl",
		"models/items/bounty_hunter/corruption_shoulder/corruption_shoulder.vmdl",
		"models/items/drow/black_wind_back/black_wind_back.vmdl",
		"models/courier/trapjaw/trapjaw.vmdl",
		"models/items/courier/courier_mvp_redkita/courier_mvp_redkita.vmdl",
		"models/items/drow/dragonstouch_arms/dragonstouch_arms.vmdl",
		"models/items/courier/dc_angel/dc_angel.vmdl",
		"models/items/windrunner/armaments_of_the_wind_head/armaments_of_the_wind_head.vmdl",
		"models/items/lina/bewitching_flame_belt/bewitching_flame_belt.vmdl",
		"models/heroes/treant_protector/treant_protector.vmdl",
		"models/heroes/juggernaut/juggernaut.vmdl",
		"models/items/luna/umbra_rider_weapon/umbra_rider_weapon.vmdl",
		"models/items/chaos_knight/chaos_legion_drapes/chaos_legion_drapes.vmdl",
		"models/heroes/troll_warlord/troll_warlord.vmdl",
		"models/heroes/pedestal/mesh/effigy_pedestal_wm16.vmdl",
		"models/items/courier/ig_dragon/ig_dragon.vmdl",
		"models/items/disruptor/stormlands_arms/stormlands_arms.vmdl",
		"models/items/rubick/puppet_master_back/puppet_master_back.vmdl",
		"models/items/courier/defense4_dire/defense4_dire.vmdl",
		"models/items/batrider/dotapit_s3_firefly/dotapit_s3_firefly.vmdl",
		"models/items/courier/jumo_dire/jumo_dire.vmdl",
		"models/heroes/lone_druid/lone_druid.vmdl",
		"models/heroes/warlock/warlock.vmdl",
		"models/items/courier/guardians_of_justice_enix/guardians_of_justice_enix.vmdl",
		"models/items/mirana/warden_of_the_eternal_night_back/warden_of_the_eternal_night_back.vmdl",
		"models/items/courier/blue_lightning_horse/blue_lightning_horse.vmdl",
		"models/heroes/lycan/summon_wolves.vmdl",
		"models/courier/frog/frog.vmdl",
		"models/heroes/troll_warlord/troll_warlord_axe_ranged_r.vmdl",
		"models/items/medusa/blueice_armor/blueice_armor.vmdl",
		"models/items/phantom_assassin/phantom_knight_shoulder/phantom_knight_shoulder.vmdl",
		"models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_skeleton_melee.vmdl",
		"models/heroes/skywrath_mage/skywrath_mage.vmdl",
		"models/heroes/clinkz/clinkz.vmdl",
		"models/items/courier/courier_janjou/courier_janjou.vmdl",
		"models/items/obsidian_destroyer/herald_of_measureless_ruin_back/herald_of_measureless_ruin_back.vmdl",
		"models/heroes/doom/doom.vmdl",
		"models/items/lone_druid/bear/iron_claw_spirit_bear/iron_claw_spirit_bear.vmdl"
	}

	local particlestr={
		"particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf",
		"particles/youxia/fire_rain.vpcf",
		"particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf",
		"particles/base_attacks/ranged_tower_bad.vpcf",
		"particles/units/heroes/hero_crystalmaiden/maiden_base_attack.vpcf",
		"particles/econ/items/keeper_of_the_light/kotl_weapon_arcane_staff/keeper_base_attack_arcane_staff.vpcf",
		"particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash_water9b.vpcf",
		"particles/mojianshi/longpaojishe/longpaojishe.vpcf",
		"particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf",
		"particles/mojianshi/wanjianjue/clinkz_base_attack.vpcf",
		"particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf",
		"particles/units/heroes/hero_rubick/rubick_fade_bolt_link.vpcf",
		"particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf",
		"particles/yemanren/brewmaster_thunder_clap.vpcf",
		"particles/units/heroes/hero_treant/treant_livingarmor.vpcf",
		"particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf",
		"particles/youxia/thunder_shield.vpcf",
		"particles/taozhuang/xiaotou.vpcf",
		"particles/units/heroes/hero_pudge/pudge_rot.vpcf",
		"particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf",
		"particles/lieren/eat.vpcf",
		"particles/neutral_fx/gnoll_base_attack.vpcf",
		"particles/yemanren/fensui.vpcf",
		"particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
		"particles/units/heroes/hero_beastmaster/beastmaster_primal_target.vpcf",
		"particles/units/heroes/hero_chaos_knight/chaos_knight_weapon_blur_critical.vpcf",
		"particles/yemanren/earthshaker_echoslam_start_fallback_low.vpcf",
		"particles/units/heroes/hero_drow/drow_base_attack.vpcf",
		"particles/generic_gameplay/generic_manaburn.vpcf",
		"particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf",
		"particles/generic_hero_status/death_tombstone.vpcf",
		"particles/econ/items/natures_prophet/natures_prophet_weapon_sufferwood/furion_teleport_end_team_model_freeze_sufferwood.vpcf",
		"particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf",
		"particles/units/heroes/hero_antimage/antimage_blink_start.vpcf",
		"particles/gold_attack.vpcf",
		"particles/econ/items/drow/drow_bow_monarch/drow_frost_arrow_monarch.vpcf",
		"particles/econ/items/sven/sven_cyclopean_marauder/sven_cyclopean_warcry.vpcf",
		"particles/econ/items/zeus/lightning_weapon_fx/zuus_base_attack_arc_immortal_lightning.vpcf",
		"particles/status_fx/status_effect_shaman_shackle.vpcf",
		"particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pu_ti6_heal_hammers.vpcf",
		"particles/myprojectile/lieren_baseattack.vpcf",
		"particles/lieren/jingxia/2.vpcf",
		"particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf",
		"particles/econ/items/axe/axe_armor_molten_claw/axe_molten_claw_ambient.vpcf",
		"particles/shushi/bolanghongji.vpcf",
		"particles/youxia/ice_ball1.vpcf",
		"particles/xiaotou/shalu/qiangjie.vpcf",
		"particles/items2_fx/hand_of_midas.vpcf",
		"particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf",
		"particles/units/heroes/hero_tinker/tinker_base_attack.vpcf",
		"particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf",
		"particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_lvl3_marker_dire.vpcf",
		"particles/shushi/baofengxue.vpcf",
		"particles/units/heroes/hero_shadow_demon/shadow_demon_base_attack.vpcf",
		"particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf",
		"particles/units/heroes/hero_viper/viper_base_attack.vpcf",
		"particles/units/heroes/hero_lina/lina_base_attack.vpcf",
		"particles/shushi/bingxueluanwu_debuff.vpcf",
		"particles/xiaotou/jianrenfengbao/juggernaut_blade_fury_grand_claive.vpcf",
		"particles/units/heroes/hero_dazzle/dazzle_base_attack.vpcf",
		"particles/shushi/skadi_projectile.vpcf",
		"particles/lieren/tinker_laser.vpcf",
		"particles/units/heroes/hero_batrider/batrider_base_attack.vpcf",
		"particles/units/heroes/hero_huskar/huskar_base_attack.vpcf",
		"particles/units/heroes/hero_treant/treant_overgrowth_vines_mid.vpcf",
		"particles/myprojectile/mojianshi_baseattack.vpcf",
		"particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf",
		"particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf",
		"particles/units/heroes/hero_juggernaut/juggernaut_ward_create.vpcf",
		"particles/units/heroes/hero_warlock/warlock_rain_of_chaos_explosion.vpcf",
		"particles/units/heroes/hero_invoker/invoker_alacrity_buff.vpcf",
		"particles/units/heroes/hero_medusa/medusa_base_attack.vpcf",
		"particles/shushi/fenghuangniepan.vpcf",
		"particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire_.vpcf",
		"particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf",
		"particles/taozhuang/shushi.vpcf",
		"particles/heroes/shikieiki/ability_eirin_04_light_c.vpcf",
		"particles/taozhuang/youxia.vpcf",
		"particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf",
		"particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf",
		"particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas_n.vpcf",
		"particles/lieren/liansuoshandian/furion_wrath_of_nature.vpcf",
		"particles/econ/items/alchemist/alchemist_midas_knuckles/alch_hand_of_midas.vpcf",
		"particles/taozhuang/mojianshi.vpcf",
		"particles/units/heroes/hero_meepo/meepo_earthbind.vpcf",
		"particles/econ/items/sven/sven_warcry_ti5/sven_warcry_buff_b_ti_5.vpcf",
		"particles/status_fx/status_effect_alacrity.vpcf",
		"particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf",
		"particles/xiaotou/shachongji.vpcf",
		"particles/units/heroes/hero_lion/lion_spell_impale.vpcf",
		"particles/status_fx/status_effect_enchantress_untouchable.vpcf",
		"particles/items_fx/desolator_projectile.vpcf",
		"particles/mojianshi/nihongshandian/nh.vpcf",
		"particles/units/heroes/hero_arc_warden/arc_warden_tempest_buff.vpcf",
		"particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf",
		"particles/taozhuang/lieren.vpcf",
		"particles/items2_fx/medallion_of_courage.vpcf",
		"particles/levelup.vpcf",
		"particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf",
		"particles/mojianshi/lingguang/magnataur_shockwave.vpcf",
		"particles/items2_fx/refresher.vpcf",
		"particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf",
		"particles/shushi/fenghuanghuoyan.vpcf",
		"particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
		"particles/econ/items/juggernaut/bladekeeper_bladefury/_dc_juggernaut_blade_fury.vpcf",
		"particles/econ/items/sniper/sniper_charlie/sniper_base_attack_bulletcase_charlie.vpcf",
		"particles/units/heroes/hero_invoker/invoker_base_attack.vpcf",
		"particles/xiaotou/anyingtouxi/queen_shadow_strike.vpcf",
		"particles/mojianshi/wanjianguizong/clinkz_searing_arrow.vpcf",
		"particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf",
		"particles/units/heroes/hero_antimage/antimage_blink_end.vpcf",
		"particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf",
		"particles/shushi/taozhuang/dark_smoke_test.vpcf",
		"particles/econ/items/witch_doctor/witch_doctor_ribbitar/witchdoctor_ward_cast_staff_fire_ribbitar_c.vpcf",
		"particles/yemanren/pojia.vpcf",
		"particles/taozhuang/yemanren.vpcf",
		"particles/generic_gameplay/generic_stunned.vpcf",
		"particles/econ/generic/generic_buff_1/generic_buff_1.vpcf",
		"particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf",
		"particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_debuff.vpcf",
		"particles/neutral_fx/satyr_hellcaller.vpcf",
		"particles/units/heroes/hero_tusk/tusk_frozen_sigil.vpcf",
		"particles/shushi/deathward/deathward_area.vpcf",
		"particles/upgrade.vpcf",
		"particles/mojianshi/jianshu/jianshu.vpcf",
		"particles/xiaotou/shandianfengbao/sven_warcry_cast_arc_lightning.vpcf",
		"particles/youxia/ice_arrow.vpcf",
		"particles/youxia/dark_arrow.vpcf",
		"particles/units/heroes/hero_razor/razor_base_attack.vpcf"
	}

	local soundstr={
		"soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_treant.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lion.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_slark.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_rubick.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lich.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_viper.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_chen.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts",
		"soundevents/game_sounds_creeps.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts",
		"soundevents/custom_sound_events.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts",
		"soundevents/voscripts/game_sounds_vo_secretshop.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_furion.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_sven.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts"
	}

	for i=1,#modelstr do
		PrecacheResource( "model",  modelstr[i], context)
	end

	for i=1,#particlestr do
		PrecacheResource( "particle",  particlestr[i], context)
	end

	for i=1,#soundstr do
		PrecacheResource( "soundfile",  soundstr[i], context)
	end

end
 
function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            PrecacheEverythingFromTable( context, value )
        else
            if string.find(value, "vpcf") then
                PrecacheResource( "particle",  value, context)
                print("PRECACHE PARTICLE RESOURCE", value)
            end
            if string.find(value, "vmdl") then  
                PrecacheResource( "model",  value, context)
                print("PRECACHE vmdl RESOURCE", value)
            end
            if string.find(value, "vsndevts") then
                PrecacheResource( "soundfile",  value, context)
                print("PRECACHE SOUND RESOURCE", value)
            end
        end
    end    
end
-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end
--[[
if true then
	debug.sethook(function(...)
		local info = debug.getinfo(2)
		local src = tostring(info.short_src)
		local name = tostring(info.name)
		if name~= "__index" and name ~="nil" then
			print("Call: "..src.." -- "..name)
		end
	end,"c")
	debug.bHookIsSet = true
end
]]

GameRules.gw_lv = 1
_G.cur_gw = 0
GameRules.win = 0
GameRules.life_num = 50
GameRules.wood = {16,16,16,16,16}
GameRules.food = {24,24,24,24,24}
GameRules.role = {}
GameRules.diff = 1
GameRules.cgkg = {1,1,1,1,1,1,1,1,1}
GameRules.suit = {0,0,0,0}
GameRules.gz_flag = 0
GameRules.playerState = {}
GameRules.flag_hero = 0
GameRules.max_gw = 40

GameRules.tPlayer = {}
GameRules.hPlayer = {}
GameRules.stSwitch = {true,true,true,true,true}
GameRules.jinjie = {
	{["1"]=1,["2"]=1,["3"]=1,["4"]=1,["5"]=0,["6"]=0,["7"]=0,["_4"]=0,["8"]=0,["9"]=0,["10"]=0,["11"]=0},
	{["1"]=1,["2"]=1,["3"]=1,["4"]=1,["5"]=0,["6"]=0,["7"]=0,["_4"]=0,["8"]=0,["9"]=0,["10"]=0,["11"]=0},
	{["1"]=1,["2"]=1,["3"]=1,["4"]=1,["5"]=0,["6"]=0,["7"]=0,["_4"]=0,["8"]=0,["9"]=0,["10"]=0,["11"]=0},
	{["1"]=1,["2"]=1,["3"]=1,["4"]=1,["5"]=0,["6"]=0,["7"]=0,["_4"]=0,["8"]=0,["9"]=0,["10"]=0,["11"]=0}
}
GameRules.tzp = 
{
	["youxia"] = "particles/taozhuang/youxia.vpcf",
	["yemanren"] = "particles/taozhuang/yemanren.vpcf",
	["lieren"] = "particles/taozhuang/lieren.vpcf",
	["mojianshi"] = "particles/taozhuang/mojianshi.vpcf",
	["xiaotou"] = "particles/taozhuang/xiaotou.vpcf",
	["shushi"] = "particles/taozhuang/shushi.vpcf"
}

GameRules.global_time = 60
GameRules.global_cdTime = 30

--[[
function GameMode:ModifyGoldFilter(event)
    
    if event.reason_const == DOTA_ModifyGold_HeroKill then
      return false
    end
    if event.reason_const == DOTA_ModifyGold_Death then
      return false
    end
  return true
end
]]
DEBUG_SPEW = 1
_G.time_start = 0
_G.flag = 0
-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if _G.flag==0 then
			--InitBackGroundMusic()
			PlayBGM()
			CustomUI:DynamicHud_Create(0,"haha",
			"file://{resources}/layout/custom_game/diff_xz.xml",nil)
			_G.time_start = math.floor(GameRules:GetGameTime())
			local woodInfo = {}
			for i=1,4 do
				local t = {}
				t.id = i-1
				t.wood = GameRules.wood[i]
				table.insert(woodInfo ,t)
			end
			CustomNetTables:SetTableValue("wood", "WoodInfo", woodInfo)
			local foodInfo = {}
			for i=1,4 do
				local t = {}
				t.id = i-1
				t.food = GameRules.food[i]
				table.insert(foodInfo ,t)
			end
			CustomNetTables:SetTableValue("food", "FoodInfo", foodInfo)
			CustomGameEventManager:Send_ServerToAllClients("__refresh",{})
			_G.flag = 1

			GameRules.path_ent = 
			{
				Entities:FindByName(nil, "ent_gw_csd1"),
				Entities:FindByName(nil, "ent_gw_csd3"),
				Entities:FindByName(nil, "ent_gw_csd5"),
				Entities:FindByName(nil, "ent_gw_csd7")
			} 
			GameRules.path_ent2 = 
			{
				Entities:FindByName(nil, "ent_gw_csd6"),
				Entities:FindByName(nil, "ent_gw_csd8"),
				Entities:FindByName(nil, "ent_gw_csd2"),
				Entities:FindByName(nil, "ent_gw_csd4")
			} 
			GameRules.path1 = 
			{
				Entities:FindByName(nil,"ent_path_"..tostring(1*2-1).."1"),
				Entities:FindByName(nil,"ent_path_"..tostring(2*2-1).."1"),
				Entities:FindByName(nil,"ent_path_"..tostring(3*2-1).."1"),
				Entities:FindByName(nil,"ent_path_"..tostring(4*2-1).."1")
			}
			GameRules.path2 = 
			{
				Entities:FindByName(nil,"ent_path_"..tostring(1*2-1).."2"),
				Entities:FindByName(nil,"ent_path_"..tostring(2*2-1).."2"),
				Entities:FindByName(nil,"ent_path_"..tostring(3*2-1).."2"),
				Entities:FindByName(nil,"ent_path_"..tostring(4*2-1).."2")
			}
			GameRules.path3 = 
			{
				Entities:FindByName(nil,"ent_path_"..tostring(1*2-1).."3"),
				Entities:FindByName(nil,"ent_path_"..tostring(2*2-1).."3"),
				Entities:FindByName(nil,"ent_path_"..tostring(3*2-1).."3"),
				Entities:FindByName(nil,"ent_path_"..tostring(4*2-1).."3")
			}
			jsq_deathJudge()
		end

		local time_now = math.floor(GameRules:GetGameTime())-_G.time_start
		sendCountDownBarInfo(time_now)
		if time_now == 2 then
			
			--[[
			local sum = 4
			for i=1,4 do
				if not PlayerResource:IsValidPlayer(i-1) then
					sum = sum - 1
				end
			end
			local __gold = 150*(4-sum)
			Notifications:TopToAll( {text="#playernum", style={color='#00EE00'}, duration=2})
			Notifications:TopToAll( {text=sum, style={color='#00EE00'}, duration=2,continue=true})
			Notifications:TopToAll( {text="#addextragold", style={color='#00EE00'}, duration=2,continue=true})
			Notifications:TopToAll( {text=__gold, style={color='#00EE00'}, duration=2,continue=true})]]
			

			--[[
			local hCaster = PlayerResource:GetSelectedHeroEntity(0)
			local pos = hCaster:GetAbsOrigin()

			local unit = CreateUnitByName("npc_unit_test",pos, true, nil, nil, DOTA_TEAM_BADGUYS)
			unit:AddNewModifier(nil,nil, "modifier_phased",{duration=0.1})
			]]

		end

	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

_G.cdId = 0;
function sendCountDownBarInfo(curTime)
	--[[
		what place here is wave count down time
		0<(time-100)%130<=30

		10-30
	]]
	if (curTime<0) then
		return 
	end
	local subTime = GameRules.global_time - GameRules.global_cdTime
	local curTimeIndex = (curTime-subTime)%GameRules.global_time
	if curTimeIndex>0 and curTimeIndex<=GameRules.global_cdTime  then
		CustomGameEventManager:Send_ServerToAllClients("refresh_countDownBar",{id=_G.cdId,curTime=curTimeIndex,name="no{0}wave",total=GameRules.global_cdTime,params={GameRules.gw_lv}})
	end

	ShowDiffcult()
	--[[加入]]
	--[[todo other count down bar]]
end
function ShowDiffcult()
	CustomGameEventManager:Send_ServerToAllClients("addPermanentBar",{id=_G.cdId+1,name="currentDiffcult{0}",params={'diff'..GameRules.diff}})
end

_G.t_downtime = 0
function ShowQuestBar( data )
	-- local __time = data or 30
	-- if _G._entCountDown == nil then
	-- 	_G.t_downtime = GameRules:GetGameTime() + __time - _G.time_start
	-- 	_G._entCountDown = SpawnEntityFromTableSynchronous( "quest", {
	-- 		--name = "#CFRoundCountingDown",
	-- 		name = "CountingDown",
	-- 		title =  "nextwave"
	-- 	})
	-- 	_G._entCountDown:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_ROUND, GameRules.gw_lv+1)

	-- 	_G._entCountDownBar = SpawnEntityFromTableSynchronous( "subquest_base", {
	-- 		show_progress_bar = true,
	-- 		progress_bar_hue_shift = -100
	-- 	} )
	-- 	_G._entCountDown:AddSubquest( _G._entCountDownBar )
	-- 	_G._entCountDownBar:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, __time)
	-- 	CountDownThink()
	-- end
	-- if _G._entCountDown2 == nil then
	-- 	_G._entCountDown2 = SpawnEntityFromTableSynchronous( "quest", {
	-- 		--name = "#CFRoundCountingDown",
	-- 		name = "CountingDown2",
	-- 		title =  "wavenum"
	-- 	})
	-- 	_G._entCountDownBar2 = SpawnEntityFromTableSynchronous( "subquest_base", {
	-- 		show_progress_bar = true,
	-- 		progress_bar_hue_shift = -100
	-- 	} )
	-- 	_G._entCountDown2:AddSubquest( _G._entCountDownBar2 )
	-- end
	
	-- _G._entCountDownBar2:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 61)
	-- _G._entCountDown2:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.gw_lv)
	-- _G._entCountDownBar2:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE,GameRules.gw_lv)
end




function creepMove( tUnit,j )
	local ent_path1 = GameRules.path1[j]
	local ent_path2 = GameRules.path2[j]
	local ent_path3 = GameRules.path3[j]
	local ent_path4 = GameRules.path_ent2[j]
	tUnit:SetContextThink("movetoplace", 
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

function OnShuaGuai(  )
	if _G._entCountDown then
		UTIL_Remove(_G._entCountDown)
		_G._entCountDown = nil 
	end
	EmitGlobalSound("GameStart.RadiantAncient")
	local biaoji = 0
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("sg_think"),
	function(  )
		--3 up 1 right 7 down 5 left
		for j=1,4 do
			if GameRules:IsGamePaused() then
				return 1
			end
			if GameRules.cgkg[j]~=0 then
				if GameRules.gw_lv==11 or GameRules.gw_lv==22 or GameRules.gw_lv==33 or GameRules.gw_lv==46 or GameRules.gw_lv==61 then
					biaoji = 1
				end
				local timeNow = math.floor(GameRules:GetGameTime())
				local unitName = "npc_dota_fk"..tostring(GameRules.gw_lv)
				local tUnit = CreateUnitByName(unitName,GameRules.path_ent[j]:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)
				tUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
				tUnit.type = j
				tUnit.p = 1
				SetCreepProperty(tUnit,1+(0.5)*(GameRules.diff-1),1)
				creepMove(tUnit,j)
				
			end
		end
		if biaoji == 0 then
			_G.cur_gw = _G.cur_gw + 1
			if(_G.cur_gw<GameRules.max_gw) then
				return 1
			else 
				GameRules.gw_lv = GameRules.gw_lv + 1
				_G.cur_gw=0
				
				return nil
			end
		else
			GameRules.gw_lv = GameRules.gw_lv + 1
			return nil
		end
		
	end , 0) 
end

function SetCreepProperty( unit,hp,armor )
	unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*armor)
	local maxHealth = unit:GetMaxHealth()*hp
	unit:SetBaseMaxHealth(maxHealth)
	unit:SetMaxHealth(maxHealth)
	unit:SetHealth(maxHealth)
end



function CountDownThink(  )
	-- body
	-- if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	-- 	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("start_sg"),
	-- 		function(  )
	-- 			-- body
	-- 			local t_Time = _G.t_downtime - GameRules:GetGameTime()+_G.time_start 
	-- 			if _G._entCountDownBar~=nil then
	-- 				_G._entCountDownBar:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE,
	-- 				 t_Time)
	-- 			end
	-- 			return 1
	-- 		end,0)
	-- end
end

function jsq_deathJudge( )
	-- Timers:CreateTimer(30, 
	-- function()
	-- 	if GameRules.gw_lv <= 61 then
	-- 		ShowQuestBar()
	-- 		return 60
	-- 	end
	-- 	return nil
	-- end)

	Timers:CreateTimer(60, 
	function()
		if GameRules.gw_lv <= 61 then
			OnShuaGuai()
			AwardEveryWave()
			--checkOnline()
			return 60
		end
		return nil
	end)
	--[[
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("death_Judge"),
	function(  )
		if GameRules:IsGamePaused() then
			return 1
		end
		local timeNow = math.floor(GameRules:GetGameTime())
		if (timeNow - _G.time_start +30 ) == GameRules.sg_time[GameRules.gw_lv] and timeNow~=_G.time_start and GameRules.gw_lv <=61 then
			
		end
		if (timeNow-_G.time_start) ~= GameRules.sg_time[GameRules.gw_lv] and timeNow~=_G.time_start then

			return 1
		end
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and GameRules.gw_lv <=61 then
		--	if (GameRules.gz_flag==0) then
				GameRules.gz_flag = 1
				
		--	end
			return 1
		else
			return nil
		end
	end , 1)]]
end

function checkKills()
	local min = PlayerResource:GetLastHits(0)
	local biaoji = 0
	for i=1,3 do
		if PlayerResource:IsValidPlayer(i) then
			local num = PlayerResource:GetLastHits(i)
			if num<min then
				min=num
				biaoji = i
			end
		end
	end
	return biaoji
end
--[[
function checkOnline()
	for i=0,3 do
		if PlayerResource:IsValidPlayerID(i) then
			local player = PlayerResource:GetPlayer(i)
			if not Contain(GameRules.tPlayer,player) then
			
				local money = PlayerResource:GetGold(i)
				local name = PlayerResource:GetPlayerName(i)
				local hero = PlayerResource:GetSelectedHeroEntity(i)
				if hero then
					hero:SpendGold(money, false)
				end
				splitMoney(money,name)
			end
		end
	end
end

function splitMoney(money,name)
	local num = #GameRules.tPlayer
	if num==0 then
		return
	end
	local temp = math.floor(money/num)
	Notifications:TopToAll({text="#splited", style={color='#00EE00'}, duration=12})
	Notifications:TopToAll({text=name, style={color='#00EE00'}, duration=12,continue=true})
	Notifications:TopToAll({text="getgold", style={color='#00EE00'}, duration=12,continue=true})
	Notifications:TopToAll({text=temp, style={color='#00EE00'}, duration=12,continue=true})
	for k,v in pairs(GameRules.tPlayer) do
		
		local playerId = v:GetPlayerID()
		if IsValidPlayerID(playerId) then
			local hero = PlayerResource:GetSelectedHeroEntity(playerId)
			local heroName = hero:GetUnitName()
			Notifications:TopToAll({text=heroName, style={color='#00EE00'}, duration=12})
			Notifications:TopToAll({text=playerId, style={color='#00EE00'}, duration=12,continue=true})
			if hero then
				hero:ModifyGold(temp, false, 0)
			end
		end
		
	end
end

function Contain(table,pat)
	for k,v in pairs(table) do
		if v==pat then
			return true
		end
	end
	return false
end
]]
function AwardEveryWave()
	local min = checkKills()
	for i=1,4 do
		local id = i -1
		if PlayerResource:IsValidPlayer(id) then
			local hero = PlayerResource:GetSelectedHeroEntity(id)
			if hero then
				local gold = 0
				if GameRules.gw_lv~=1 then
					if id==min then
						gold = (GameRules.gw_lv)*12
						Notifications:Bottom(id, {text="#gethuilu", style={color='#E62020'}, duration=2})
						Notifications:Bottom(id, {text=gold, style={color='#E62020'}, duration=2,continue=true})
						Notifications:Bottom(id, {text="#gold", style={color='#E62020'}, duration=2,continue=true})
					else
						gold = (GameRules.gw_lv)*6
						Notifications:Bottom(id, {text="#wavegold", style={color='#00EE00'}, duration=2})
						Notifications:Bottom(id, {text=gold, style={color='#00EE00'}, duration=2,continue=true})
						Notifications:Bottom(id, {text="#gold", style={color='#00EE00'}, duration=2,continue=true})
					end
					EmitSoundOn("General.CoinsBig", hero)
					--hero:ModifyGold(gold, false, 0)
					ModifyGoldLtx( hero,gold )
				end
				if GameRules.gw_lv>=40 then
					if GameRules.role[i]=="xiaotou" then
						if hero:HasModifier("modifier_gaolidai_hero") then
							local __gold = math.min(math.floor(hero.resGold * 0.1),4000)
							--hero:ModifyGold(__gold, false,0)
							ModifyGoldLtx( hero,__gold )
							Notifications:Bottom(id, {text="#getgaolidai", style={color='#00EE00'}, duration=2})
							Notifications:Bottom(id, {text=__gold, style={color='#00EE00'}, duration=2,continue=true})
							Notifications:Bottom(id, {text="#gold", style={color='#00EE00'}, duration=2,continue=true})
						end
					end
				end
			end
			
		end
	end
end