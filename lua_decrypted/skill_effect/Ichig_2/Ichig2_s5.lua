--v3
--[[
Ichig_2
1
0
penxue
1
{default,gongji6,1,0,0,63,1.000000}
1
{default,0.000000,0.000000,-350.000000,0.000000,0,1,0,1,0.000000,0,0,0,0}
0

0

1
{0,Ichig_2,2,0,0.000000,0.000000,63,0}
1
{default,texiao1,1,0,0,63,1.000000}
1
{default,500.000000,200.000000,500.000000,200.000000,2,2,0,1,0.000000,0,0,0,0}
1
{default,1.200000,1.200000,1.200000,1.200000,0,0,1}
0


daiji
]]--
local skillTest = {
attack_type       = "yuangong",
start_p           = {2,0,0},
end_p             = {2,0,0},
anim_sequence    = {{"gongji6",1.000000,0,63,1}}, 
pos_sequence      = {{0.000000,0.000000,-350.000000,0.000000,0,1,0,1,0.000000,0,0,0,0}}, 
scale_sequence     = {}, 
fade_sequence      = {}, 
other_sequence      = {{"Ichig_2",2,0,0.000000,0.000000,{{"texiao1",1.000000,0,63,1}},{{500.000000,200.000000,500.000000,200.000000,2,2,0,1,0.000000,0,0,0,0}},{{1.200000,1.200000,1.200000,1.200000,0,0,1}},{},0}}, 
bloodNum          = 5,
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
