GameRules.gx={}
for i=1,61 do
	GameRules.gx["npc_dota_fk"..i]=2+i
	GameRules.gx["npc_dota_fk_child_17"] = 10
end
GameRules.gx["npc_dota_fk11"] = 50
GameRules.gx["npc_dota_fk22"] = 130
GameRules.gx["npc_dota_fk33"] = 200
GameRules.gx["npc_dota_fk46"] = 300
GameRules.gx["npc_dota_fk61"] = 500
GameRules.jn = 1000
GameRules.sj={{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1}}
for i=12,14 do
	GameRules.sj[i][1] = 150
	GameRules.sj[i][2] = 250
end
for i=1,4 do
	GameRules.sj[i][1]=150
	GameRules.sj[i][2]=250
end

for i=5,8 do
	GameRules.sj[i][1]=250
	GameRules.sj[i][2]=400
end
for i=9,10 do
	GameRules.sj[i][1]=400
	GameRules.sj[i][2]=600
end

GameRules.lto4={
	["youxia7"] = 6500,
	["youxia7_2"] = 6500,
	["youxia7_3"] = 6500,
	["youxia8"] = 7500,
	["youxia8_2"] = 7500,
	["youxia8_3"] = 7500,
	["youxia10_3"] = 9000,
	["youxia10"] = 9000,
	["youxia10_2"] = 9000,
	["yemanren7"] = 6500,
	["yemanren7_2"] = 6500,
	["yemanren7_3"] = 6500,
	["yemanren8"] = 7500,
	["yemanren8_2"] = 7500,
	["yemanren8_3"] = 7500,
	["yemanren10"] = 9000,
	["yemanren10_2"] = 9000,
	["yemanren10_3"] = 9000,
	["xiaotou7"] = 6500,
	["xiaotou7_2"] = 6500,
	["xiaotou7_3"] = 6500,
	["xiaotou8"] = 7500,
	["xiaotou8_2"] = 7500,
	["xiaotou8_3"] = 7500,
	["xiaotou10"] = 9000,
	["xiaotou10_2"] = 9000,
	["xiaotou10_3"] = 9000,
	["lieren7"] = 6500,
	["lieren7_2"] = 6500,
	["lieren7_3"] = 6500,
	["lieren8"] = 7500,
	["lieren8_2"] = 7500,
	["lieren8_3"] = 7500,
	["lieren10"] = 9000,
	["lieren10_2"] = 9000,
	["lieren10_3"] = 9000,
	["mojianshi7"] = 6500,
	["mojianshi7_2"] = 6500,
	["mojianshi7_3"] = 6500,
	["mojianshi8"] = 7500,
	["mojianshi8_2"] = 7500,
	["mojianshi8_3"] = 7500,
	["mojianshi10"] = 9000,
	["mojianshi10_2"] = 9000,
	["mojianshi10_3"] = 9000,
	["shushi7"] =6500,
	["shushi7_2"] =6500,
	["shushi7_3"] =6500,
	["shushi8"] = 7500,
	["shushi8_2"] = 7500,
	["shushi8_3"] = 7500,
	["shushi10"] = 9000,
	["shushi10_2"] = 9000,
	["shushi10_3"] = 9000
}

GameRules.drop=
{
	"item_youxia12",
	"item_youxia13",
	"item_youxia14",

	"item_yemanren12",
	"item_yemanren13",
	"item_yemanren14",

	"item_mojianshi12",
	"item_mojianshi13",
	"item_mojianshi14",

	"item_lieren12",
	"item_lieren13",
	"item_lieren14",

	"item_xiaotou12",
	"item_xiaotou13",
	"item_xiaotou14",

	"item_shushi12",
	"item_shushi13",
	"item_shushi14"
}
