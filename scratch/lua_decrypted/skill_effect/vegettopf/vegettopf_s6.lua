--v3
--[[
vegettopf
1
0
penxue
2
{default,qianjin,0,0,0,8,1.000000}{default,gongji7,1,1,9,107,1.000000}
1
{default,0.000000,0.000000,400.000000,250.000000,0,2,0,1,0.000000,0,0,0,0}
0

0

1
{0,vegettopf,2,0,0.000000,0.000000,98,0}
1
{default,gongji7_teixao1,1,1,0,98,1.000000}
1
{default,400.000000,200.000000,400.000000,200.000000,2,2,0,1,0.000000,0,0,0,0}
1
{default,1.300000,1.300000,1.300000,1.300000,0,0,1}
0


daiji
]]--
local skillTest = {
attack_type       = "yuangong",
start_p           = {2,0,0},
end_p             = {2,0,0},
anim_sequence    = {{"qianjin",1.000000,0,8,0},{"gongji7",1.000000,9,107,1}}, 
pos_sequence      = {{0.000000,0.000000,400.000000,250.000000,0,2,0,1,0.000000,0,0,0,0}}, 
scale_sequence     = {}, 
fade_sequence      = {}, 
other_sequence      = {{"vegettopf",2,0,0.000000,0.000000,{{"gongji7_teixao1",1.000000,0,98,1}},{{400.000000,200.000000,400.000000,200.000000,2,2,0,1,0.000000,0,0,0,0}},{{1.300000,1.300000,1.300000,1.300000,0,0,1}},{},0}}, 
bloodNum          = 4,
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
