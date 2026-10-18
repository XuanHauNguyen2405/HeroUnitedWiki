--v3
--[[
meipulu2
1
0
penxue
2
{default,qianjin,0,1,0,8,1.000000}{default,gongji6,1,1,9,112,1.000000}
1
{default,0.000000,0.000000,400.000000,250.000000,0,2,0,1,0.000000,0,0,0,0}
0

0

1
{0,meipulu2,2,0,0.000000,0.000000,103,0}
1
{default,gongji6_teixiao1,1,1,0,103,1.000000}
1
{default,450.000000,250.000000,450.000000,250.000000,2,2,0,1,0.000000,0,0,0,0}
1
{default,1.200000,1.200000,1.200000,1.200000,0,0,1}
0


daiji
]]--
local skillTest = {
attack_type       = "yuangong",
start_p           = {2,0,0},
end_p             = {2,0,0},
anim_sequence    = {{"qianjin",1.000000,0,8,0},{"gongji6",1.000000,9,112,1}}, 
pos_sequence      = {{0.000000,0.000000,400.000000,250.000000,0,2,0,1,0.000000,0,0,0,0}}, 
scale_sequence     = {}, 
fade_sequence      = {}, 
other_sequence      = {{"meipulu2",2,0,0.000000,0.000000,{{"gongji6_teixiao1",1.000000,0,103,1}},{{450.000000,250.000000,450.000000,250.000000,2,2,0,1,0.000000,0,0,0,0}},{{1.200000,1.200000,1.200000,1.200000,0,0,1}},{},0}}, 
bloodNum          = 7,
flyAnim           = "ladeng",
flyAnim_equence   = {{"impact",1}}, 
par               = "",
fly_v             = 100,
fly_h             = 0,
hurtAnim          = "penxue",
hurtAnim_equence  = {{"impact",1}},
skillCallFunc     = function(self,battleSkill,battleTable) 
   local skillData = battleTable.m_currentFrameData; 
   table.foreach(skillData,function(k,v) 
   end); 
   local hpValue = 1;
   local function attackEnd()
   end
   battleSkill:createNormalAttack({skills_table = self,hpValue = skillData.hurt,animEndCallFunc = attackEnd});
end, 
}
return skillTest
