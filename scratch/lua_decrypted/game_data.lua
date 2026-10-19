--- 数据缓存
local tostring,os,type,pairs,math,tonumber = tostring,os,type,pairs,math,tonumber
local M = {
    m_tCardsData = {},--卡牌数据
    m_tCardsIdTable = {},--卡牌id对应表
    m_cardSortType2 = {"1","2","3","4","5","6"},
    -- m_tCardsCidTable = {},  --卡牌c_id对应表
    m_tTeamData = {},--编队数据
    m_tEquipData = {},--装备数据
    m_tEquipIdTable = {},--装备id对应表
    m_tEquipPosData = {},--卡牌位置装备数据
    m_tAssEquipPosData = json.decode("{\"100\":[\"0\",\"0\",\"0\",\"0\"],\"101\":[\"0\",\"0\",\"0\",\"0\"],\"102\":[\"0\",\"0\",\"0\",\"0\"],\"103\":[\"0\",\"0\",\"0\",\"0\"],\"104\":[\"0\",\"0\",\"0\",\"0\"],\"105\":[\"0\",\"0\",\"0\",\"0\"],\"106\":[\"0\",\"0\",\"0\",\"0\"],\"107\":[\"0\",\"0\",\"0\",\"0\"],\"108\":[\"0\",\"0\",\"0\",\"0\"],\"109\":[\"0\",\"0\",\"0\",\"0\"]}"),--助威卡牌位置装备数据
    m_tEquipSortData = {},--装备分类数据
    m_tEquipWormholeIdTable = {} , --虫洞装备数据
    m_tFormationData = {},--阵型数据
    m_tUserStatusData = {},--用户基础数据
    m_tUserStatusDataBackup = {},
    m_tBuildingAbilityData = {},--建筑
    m_tResourceData = {},--资源
    m_tPrivateBuildingData = {},
    m_globalSchedulerHandle = nil,
    m_last_request_time = os.time(),
    m_tHarborData = {},--避难所数据
    m_tLaboratoryData = {},--研究所数据
    m_tSchoolData = {},--学校数据
    m_tFactoryData = {},--工厂数据
    m_selCityId = nil,
    m_selBuildingId = nil,
    m_tGachaData = {},
    m_battleType = "",--战斗类型
    m_reMapBattleFlag = false,
    m_selNeutralCityId = nil,--选择的中立城市
    m_selNeutralBuildingId = nil,--选择的中立城市的建筑
    m_selGuildData = {},
    m_guildListData = {},
    m_dailyAwardData = {init = false,data = {}},
    m_itemsData = {},--道具
    m_enterBackgroundTime = os.time(),
    m_action_point_add_time = 180,
    m_openPositionData = {},
    m_leaderSkillData = {},--主角技能
    m_availableSkillTreeData = {},--技能树
    m_availableSkill = {},--开启的技能
    m_serverData = {},
    m_selServerId = "",
    m_tNoticesData = {},
    m_cardSortType = "default",
    m_equipSortType = "default",
    m_activeData = {};
    m_selActiveData = {},
    m_backgroundMusicName = "",
    m_skillIdTreeTab = {},
    m_alertsData = {},
    m_arenaRank = 0,
    m_arenaPoint = 0,                   -- 功勋
    m_online_award_expire = nil,
    m_onlinw_awawrd_id = nil,
    m_active = false,
    m_selCitySweepLogData = {},
    m_chapterTab = {},
    m_tSelCityData = {},
    m_tSelNeutralCityData = {},
    m_tBattleCardNum = {},
    tempCombatValue = 0,
    m_newCardIdTab = {count = 0},
    m_newPetIdTab = {count = 0},--新寵物
    m_newEquipIdTab = {count = 0},
    m_newItemIdTab = {count = 0},
    m_currentFightId = "-1",
    m_currChapterTypeName = "normal",
    buy_ap_times = 0,
    shopData = {},
    -- 消息提醒相关数据
    m_texchangedCardEquip = {},  -- 可以兑换的卡牌或者装备
    m_ttrainfinishCard = {}, -- 训练完成的卡片
    m_tAssistant = {"-1","-1","-1","-1","-1","-1","-1","-1","-1"},       -- 助战小伙伴
    m_tAssistantEffect = {},
    m_tDestiny = {"-1","-1","-1","-1","-1","-1","-1","-1","-1"},  -- 命运小伙伴
    m_talreadyTips = {} , 
    m_commanderData = {},

    m_curValidButton = {},  -- 当前可用的功能

    m_curInReviewButton = {}, -- 当前不开启的按钮
    m_curInReviewOpenButton = {}, -- 当前不开启的按钮

    m_tLocalGameData = nil,     -- 一场游戏中的一些标记

    m_phone_num = "",--手机号
    m_showSthTips = {},  -- 是否限时某些提示
    m_mapWorldData = {},
    openTable = {},--活动开启table
    opening_award_expire = nil,
    m_mapType = nil,

    m_chatData = {maxMsg = 20, world = {curMsg = 0, data = {}}, guild = {curMsg = 0, data = {}}, friend = {curMsg = 0, data = {}}, guild_war = {curMsg = 0, data = {}}},  -- 聊天缓存
    m_chatTime = {world = 0, guild = 0, friend = 0},
    m_sdkAccount = nil,
    m_treasure = nil,--宝藏难度设置
    RecoverFlag = nil,
    m_commander_type = "",
    m_chat = nil,

    m_force_guide_info = nil,
    m_leatestShowActivityIndex = nil,
    m_guildName = nil,
    m_guideProcess = nil,
    m_tGemData = {},--宝石数据
    m_tGemIdTable = {},--宝石id对应表
    m_tGemPosData = {},--卡牌位置宝石数据
    m_newGemIdTab = {count = 0},
    m_gemSortType = "default",

    m_petData = {},--寵物數據
    m_tPetIdTable = {},--寵物id對應表
    m_tPetTeamTable = {"-1","-1","-1","-1","-1","-1","-1","-1","-1"},--寵物陣型表
    m_pet_follow_pos = {"-1","-1","-1","-1","-1","-1","-1","-1","-1"},--宠物跟随表
    pet_follow_abi = nil;

    m_tSoulData = {},--英魂数据
    m_tSoulIdTable = {},--英魂id对应表
    m_tSoulSortData= {}, --英魂分类数据
    m_tSoulPosData ={},--英魂位置
    m_soulSortType = "default",
    m_newSoulIdTab = {count = 0},
    m_godfieldData = {},

    m_tGodEquipData1 = {},--神域装备数据
    m_tGodEquipData2 = {},--神域装备数据
    m_tGodEquipData3 = {},--神域装备数据
    m_tGodGemData1 = {},--神域宝石
    m_tGodGemData2 = {},
    m_tGodGemData3 = {},
    m_tGodTeamData = {},--神域编队数据
    godAllCombat = {},--各阵型战斗力
    m_godTempleCardData = {},-- 圣殿卡牌数据

    m_zhuanshiTask1Data = {},--转世任务一的数据
    m_zhuanshiCardId = nil,--转世卡牌ID

    m_is_new_version = nil,

    m_tMedalPosData = {},--勋章位置
    m_tMedalIdData = {},--所有勋章

    m_nightmare_selectBuild_index = nil,--噩梦之塔当前选择的建筑
    m_nightmare_reward = {},
    m_tCombinerData = {}, --召唤兽数据
    m_tCombinerfightData = {}, --召唤兽出战数据
    m_redEnvelope_jihuoma = nil, --红包


    m_serverGuild_isManage = nil, --新公会战玩家是不是会长 副会长
    --todo 
    m_tGodSoulPosData1 = {},--神域英魂
    m_tGodSoulPosData2 = {},
    m_tGodSoulPosData3 = {},
    m_tAllGodSoulPosData = {},--所有英魂数据

    m_tGodMedalPosData1 = {},--神域勋章
    m_tGodMedalPosData2 = {},
    m_tGodMedalPosData3 = {},
    m_tAllGodMedalPosData = {},--所有勋章数据
    m_tGodMedalIdData = {}, --神域勋章数
    m_tGodGemPosData1 = {},--神域宝石
    m_tGodGemPosData2 = {},
    m_tGodGemPosData3 = {},
    m_tGodGemData = {},--神域宝石
    m_newGodGemIdTab = {count = 0},
    m_tGodGemIdTable = {},--神域宝石

    m_god_Star_check_msg = nil, --神域星宫
    m_god_Boss_battle_team = nil, --神域boss队伍
    m_god_Boss_rank_team = nil, --神域我的排名
    m_check_floor = nil, 


     m_tGuildTeamData = {},--公会招募自己的卡的id
    m_tGuildTeamData2 = {},--公会招募自己的卡的id
    m_tGuildCardsData = {},--公会所有卡的数据(包括uid)
    m_tGuildOtherTeamData = {},--公会招募别人的卡的id
    m_tGuildAllCardsData = {},--公会所有卡的数据(去掉uid)
    m_tGuildSelTeamData = {},--公会所有被选择的卡的数据
    m_tGuildSelTeamId = {},-- 公会所有被选择并上阵的卡
    m_tGuildFormationData = {},-- 公会阵型的数据
    m_tGuildCurTeam = {},-- 当前公会阵型上的卡
    m_guildFormationId = nil,
    m_guildBossId = nil,
    m_tab_exchangeSkill_indexAndId = {},-- 存储卡牌技能切换选中的卡牌的id和在技能强化界面里面的位置

    m_formationBounsData_AddTable = {},-- 阵法的加成数值
    --shengshi 
    m_tSaintStoneData = {},--圣石数据
    m_tSaintStoneIdTable = {},--圣石id对应表
    m_tSaintStonePosData = {},--卡牌位置圣石数据
    m_tAllGodSaintStonePosData={},
    m_newSaintStoneIdTab = {count = 0},
    m_SaintStoneSortType = "default",
    m_tGodSaintStoneData={},
    m_dispatchCard = {},


    m_tMagicData = {},
    m_tTalismanWormholeIdTable = {},
    m_tMagicIdTable = {},
    m_tMagicPosData = {},
    m_magicSortType = "default",
    m_tAssMagicPosData = {},
    m_formationBounsMagicData = {},
    m_formationBloodStoneData = {
        gem_special = {},
        fate_word = {},
        fate_stone = {},
        word_round = {},
    },
    m_tMagicSortData = {},
    m_newMagicIdTab = {},
    m_curCardSkinData = {},--玩家穿戴的皮肤

    m_Famous_attr = {},--名人堂

    m_tGodSaintStoneIdTable = {},
    --雪人
    m_snowman_msg = nil,
    m_snowman_Version = nil,
    m_snow_reward = {},

    m_heroEquip_tab = {},--主角系统 主角带的装备

    m_Famous_detail = {},
    m_famousAllData = {},
    m_wormholes_field = {},
    m_Famous_attr = {},

    m_cardSkinData = {},--玩家拥有的皮肤id
    --命运宝石 
    m_tFateGemData = {},--命运宝石数据
    m_tFateGemIdTable = {},--命运宝石id对应表
    m_tFateGemPosData = {},--卡牌位置命运宝石数据
    m_fateGemSortType = "default",
    m_nEquipDataC_id= {},

    m_wormtype_battle = {},
    m_all_title = {}, --- 称号列表

    m_battleparams = nil,
    m_guild_high_war_version = nil, --以太战场版本号
    m_old_combat = nil,
    m_newCombat = nil,
    m_storeHouseData = {},
    m_cacheData = {},
    m_globalIdx = 0,
    m_godfield_comber = 0,
    m_badgeData = {},
    m_badgeIdTable = {},
};

function M.init(self)
    self.m_skillIdTreeTab = {};

    local leader_skill_tree = getConfig(game_config_field.leader_skill_tree);
    local tree_count = leader_skill_tree:getNodeCount();
    local count;
    local function paramsSkillTree(jsonData,treeId)
        count = jsonData:getNodeCount();
        for i=1,count do
            local item = jsonData:getNodeAt(i - 1);
            local key = item:getKey();
            -- cclog("key ===============" .. key .. " ; treeId = " .. treeId)
            self.m_skillIdTreeTab[key] = tonumber(treeId);
            if item:getNodeCount() ~= 0 then
                paramsSkillTree(item,treeId);
            end
        end
    end
    local itemData = nil;
    for i=1,tree_count do
        itemData = leader_skill_tree:getNodeAt(i-1)
        paramsSkillTree(itemData,itemData:getKey());
    end
    local chapter = getConfig(game_config_field.chapter);
    local chapter_count = chapter:getNodeCount();
    local itemCfg,is_hard = nil,nil;
    local playerLevel = self:getUserStatusDataByKey("level") or 1;
    local normalTab,difficultTab, openDifficultTab = {},{},{}
    local playerLevel = game_data:getUserStatusDataByKey("level") or 1;
    for i=1,chapter_count do
        itemCfg = chapter:getNodeAt(i-1);
        is_hard = itemCfg:getNodeWithKey("is_hard"):toInt();
        local open_level = itemCfg:getNodeWithKey("open_level"):toInt();
        local chapterId = itemCfg:getKey();
        if is_hard == 0 then
            normalTab[#normalTab + 1] = chapterId
        elseif is_hard == 2 and tonumber(chapterId or "0") > 200 then
            difficultTab[#difficultTab + 1] = chapterId
            if playerLevel >= open_level then
                openDifficultTab[chapterId] = true
            end
        end
    end
    local function sortFunc(idOne,idTwo)
        return tonumber(idOne) < tonumber(idTwo);
    end
    table.sort(normalTab,sortFunc);
    table.sort(difficultTab,sortFunc);
    self.m_chapterTab.normal = normalTab
    self.m_chapterTab.difficult = difficultTab
    self.m_chapterTab.openDifficult = openDifficultTab
    self.m_chapterTab.openCityTab = {};
    self.m_chapterTab.newOpenCityTab = {count = 0};
    self:judgeCityOpenChanged(true);

    self:resetOpenButtonList()

    -- 初始化标记
    self.m_tLocalGameData = self:getLocalGameData();           -- 

end
--[[--
    获得技能tree表
]]
function M.getSkillIdTreeTab(self)
    return self.m_skillIdTreeTab or {};
end
--[[--
    获得章节表
]]
function M.getChapterTabByKey(self,key)
    return self.m_chapterTab[key] or {};
end
--[[--
    获取已经记录的已经开启的功能
]]
function M.getOpenButtonList(self)
    return self.m_curValidButton or {};
end

--[[
    重置开启的功能
]]
function M.resetOpenButtonList( self )
    -- 初始化 现在开启功能列表
    self.m_curValidButton = {}
    local curOpen = game_button_open:getOpenButtonIdList()
    for i,v in pairs(curOpen) do
        self.m_curValidButton[i] = v
    end
end


--[[--
    添加已经提示的新功能到记录列表
]]
function M.addOneNewButtonByBtnID(self, btnId)
    -- print("add a new buton", type(btnId), btnId)
    btnId = tostring(btnId)
    self.m_curValidButton[btnId] = true
end

--[[ -- 
    更新小红点提示状态
    key ：    提示的种类  -- cmdr_energy：精力提示， totalStar：星灵提示
    isResetShow = nil
    isResetShow = have_show  查看小红点是否能提示
    isResetShow = reset_show  重置小红点提示状态
]]
function M.updateShowTips( self, key, isResetShow )
    if self.m_showSthTips == nil then self.m_showSthTips = {} end

    print("updateShowTips  == ", json.encode(self.m_showSthTips))

    if self.m_showSthTips[ key ] == nil then
        self.m_showSthTips[key] = {}
        self.m_showSthTips[key] = true
        return true
    end
    if isResetShow == "have_show" then
        self.m_showSthTips[key] = false
        return false
    elseif isResetShow == "reset_show" then
        self.m_showSthTips[key] = nil
    elseif self.m_showSthTips[key] == true then
        return true
    end
    return false
end

--[[--
    
]]
function M.judgeCityOpenChanged(self,initFlag)
    local map_main_story = getConfig(game_config_field.map_main_story);
    local playerLevel = self:getUserStatusDataByKey("level") or 1;
    local showDataTab = self.m_chapterTab.openCityTab
    local newOpenCityTab = self.m_chapterTab.newOpenCityTab
    local tempCount = map_main_story:getNodeCount();
    local selCityId = 100000;
    for i=1,tempCount do
        local itemCfg = map_main_story:getNodeAt(i-1);
        local openId = itemCfg:getKey();
        local stage_id = itemCfg:getNodeWithKey("stage_id"):toInt()
        local open_level = itemCfg:getNodeWithKey("open_level"):toInt()
        if playerLevel >= open_level and tonumber(openId) < 39 then--开启
            if initFlag == true then
                -- cclog("openId ==1== " .. openId .. " ; playerLevel == " .. playerLevel .. " ; open_level == " .. open_level)
                showDataTab[openId] = stage_id;
            else
                -- cclog("openId ==2== " .. openId .. " ; playerLevel == " .. playerLevel .. " ; open_level == " .. open_level)
                if showDataTab[openId] == nil then
                    showDataTab[openId] = stage_id;
                    newOpenCityTab[openId] = stage_id;
                    newOpenCityTab.count = newOpenCityTab.count + 1;
                    if stage_id < selCityId then
                        selCityId = stage_id
                    end
                end
            end
        end
    end
    if selCityId ~= 100000 then
        newOpenCityTab.selCityId = selCityId;
    end
    -- cclog("json.encode(showDataTab) ==== " .. json.encode(showDataTab))
    -- cclog("json.encode(newOpenCityTab) ==== " .. json.encode(newOpenCityTab))
end
--[[--
    
]]
function M.resetNewOpenCityTab(self)
    self.m_chapterTab.newOpenCityTab = {count = 0};
end

--[[--
    
]]
function M.getNewOpenCityTab(self)
    return self.m_chapterTab.newOpenCityTab
end

--[[--
    
]]
function M.getNewOpenCityId(self)
    return self.m_chapterTab.newOpenCityTab.selCityId;
end

--[[------------------------------------卡牌相关 start------------------------------------------- ]]
--[[--
    通过json数据设置cards数据
]]
function M.setCardsByJsonData(self,cardsJsonData)
    if cardsJsonData == nil then
        return;
    end
    self.m_bagCardIdTable = {}
    self.m_tCardsIdTable = {};
    self.m_tkapaiData = {}
    -- self.m_tCardsCidTable = {}
    self.m_tCardsData = json.decode(cardsJsonData:getFormatBuffer()) or {};
    if self.m_tCardsData ~= nil and type(self.m_tCardsData) == "table" then
        for k,v in pairs(self.m_tCardsData) do
            self.m_tCardsIdTable[#self.m_tCardsIdTable + 1] = k;
            -- self.m_tCardsCidTable[#self.m_tCardsCidTable + 1] = v.c_id
        end
        self.m_tkapaiData = self:getKaPaiCidData( )
    end
    -- return self.m_tkapaiData
    -- cclog("setCardsByJsonData ============count = " .. #self.m_tCardsIdTable);
    -- local writablePath = CCFileUtils:sharedFileUtils():getWritablePath();
    -- local ret = util.writeFile(writablePath .. "heroData.temp",cardsJsonData:getFormatBuffer());
    -- self:cardsSortByTypeName(self.m_cardSortType);
    -- self:cardsSortByTypeName2(self.m_cardSortType,self.m_cardSortType2);
        
end

function M.cardsSortByTypeName3(self,typeName)
    -- table.foreach(self.m_tCardsIdTable,print)
-- 默认：1出战状态，2卡牌ID，3卡牌等级
-- 等级：1卡牌等级，2卡牌品质,3卡牌ID
-- 品质：1卡牌品质，2卡牌ID，3卡牌等级
-- 职业：1卡牌职业，2卡牌品质，3卡牌ID，4卡牌等级
self.m_cardSortType = typeName;
self:cardsSortByTypeNameWithTable(typeName,self.m_tCardsIdTable);
end

--[[--
    cards数据排序
]]
function M.cardsSortByTypeName(self,typeName)
    -- table.foreach(self.m_tCardsIdTable,print)
-- 默认：1出战状态，2卡牌ID，3卡牌等级
-- 等级：1卡牌等级，2卡牌品质,3卡牌ID
-- 品质：1卡牌品质，2卡牌ID，3卡牌等级
-- 职业：1卡牌职业，2卡牌品质，3卡牌ID，4卡牌等级
    self.m_cardSortType = typeName;
    -- self:cardsSortByTypeNameWithTable(typeName,self.m_tCardsIdTable);
    self:cardsSortByTypeNameWithTable2(typeName,self.m_tkapaiData);
    -- cclog("----------------------------------")
    -- table.foreach(self.m_tCardsIdTable,print)
end

function M.cardsSortByTypeName2(self,typeName,typeName2)
    -- table.foreach(self.m_tCardsIdTable,print)
    -- 默认：1出战状态，2卡牌ID，3卡牌等级
    -- 等级：1卡牌等级，2卡牌品质,3卡牌ID
    -- 品质：1卡牌品质，2卡牌ID，3卡牌等级
    -- 职业：1卡牌职业，2卡牌品质，3卡牌ID，4卡牌等级
    --cclog2(self.m_tkapaiData,"self.m_tkapaiData")
    self.m_cardSortType = typeName;
    self.m_cardSortType2 = typeName2;
    -- self:cardsSortByTypeNameWithTable(typeName,self.m_tCardsIdTable);
    return self:cardsSortByTypeNameWithTable3(typeName,typeName2,self.m_tkapaiData);
    -- cclog("----------------------------------")
    -- table.foreach(self.m_tCardsIdTable,print)
end

--[[--
    cards数据排序
]]
function M.cardsSortByTypeNameWithTable(self,typeName,idDataTable)
    -- table.foreach(self.m_tCardsIdTable,print)
-- 默认：1出战状态，2卡牌ID，3卡牌等级
-- 等级：1卡牌等级，2卡牌品质,3卡牌ID
-- 品质：1卡牌品质，2卡牌ID，3卡牌等级
-- 职业：1卡牌职业，2卡牌品质，3卡牌ID，4卡牌等级
    local tempTab = self.m_tCardsData;
    local str = tostring;
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroData1,heroData2,heroCfg1,heroCfg2,quality1,quality2,c_ID1,c_ID2,race1,race2
    local tTeamTab = {};
    for k,v in pairs(self.m_tTeamData or {}) do
        tTeamTab[str(v)] = 20;
    end
    for k,v in pairs(self.m_tAssistant or {}) do
        tTeamTab[str(v)] = 10;
        tTeamTab[str(self.m_tDestiny[k])] = 9;
    end
    local flag1,flag2
    local function sortFunc(idOne,idTwo)
        heroData1 = tempTab[str(idOne)]
        heroData2 = tempTab[str(idTwo)]
        heroCfg1 = character_detail_cfg:getNodeWithKey(tostring(heroData1.c_id));
        heroCfg2 = character_detail_cfg:getNodeWithKey(tostring(heroData2.c_id));
        if heroCfg1 and heroCfg2 then
            quality1 = heroCfg1:getNodeWithKey("quality"):toInt() + (heroData1.super_step or 0)
            quality2 = heroCfg2:getNodeWithKey("quality"):toInt() + (heroData2.super_step or 0)
            c_ID1 = tonumber(heroData1.c_id)
            c_ID2 = tonumber(heroData2.c_id)
            if typeName == "default" then
                flag1 = tTeamTab[heroData1.id] or 0
                flag2 = tTeamTab[heroData2.id] or 0
                if flag1 == flag2 then
                        if quality1 == quality2 then
                            if c_ID1 == c_ID2 then
                                return heroData1.lv > heroData2.lv;
                            else
                                return c_ID1 > c_ID2;
                            end
                        else
                            return quality1 > quality2;
                        end
                else
                    return flag1 > flag2;
                end
            elseif typeName == "lv" then
                if heroData1.lv == heroData2.lv then
                    if quality1 == quality2 then
                        return c_ID1 > c_ID2;
                    else
                        return quality1 > quality2;
                    end
                else
                    return heroData1.lv > heroData2.lv;
                end
            elseif typeName == "quality" then
                if quality1 == quality2 then
                    if c_ID1 == c_ID2 then
                        return heroData1.lv > heroData2.lv;
                    else
                        return c_ID1 > c_ID2;
                    end
                else
                    return quality1 > quality2;
                end
            elseif typeName == "profession" then
                race1 = heroCfg1:getNodeWithKey("race"):toInt();
                race2 = heroCfg2:getNodeWithKey("race"):toInt();
                if race1 == race2 then
                    if quality1 == quality2 then
                        if c_ID1 == c_ID2 then
                            return heroData1.lv > heroData2.lv;
                        else
                            return c_ID1 > c_ID2;
                        end
                    else
                        return quality1 > quality2;
                    end
                else
                    return race1 > race2;
                end
            end
        else
            return idOne > idTwo;
        end
    end
    table.sort(idDataTable,sortFunc)
end

function M.cardsSortByTypeNameWithTable2(self,typeName,idDataTable)
    -- table.foreach(self.m_tCardsIdTable,print)
-- 默认：1出战状态，2卡牌ID，3卡牌等级
-- 等级：1卡牌等级，2卡牌品质,3卡牌ID
-- 品质：1卡牌品质，2卡牌ID，3卡牌等级
-- 职业：1卡牌职业，2卡牌品质，3卡牌ID，4卡牌等级

    local tempTab = self.m_tCardsData;
    local str = tostring;
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroData1,heroData2,heroCfg1,heroCfg2,quality1,quality2,c_ID1,c_ID2,race1,race2
    local tTeamTab = {};
    for k,v in pairs(self.m_tTeamData or {}) do
        tTeamTab[str(v)] = 20;
    end
    for k,v in pairs(self.m_tAssistant or {}) do
        tTeamTab[str(v)] = 10;
        tTeamTab[str(self.m_tDestiny[k])] = 9;
    end
    local flag1,flag2
    local function sortFunc(idOne,idTwo)
        heroData1 = tempTab[str(idOne[1])]
        heroData2 = tempTab[str(idTwo[1])]
        heroCfg1 = character_detail_cfg:getNodeWithKey(tostring(heroData1.c_id));
        heroCfg2 = character_detail_cfg:getNodeWithKey(tostring(heroData2.c_id));
        if heroCfg1 and heroCfg2 then
            quality1 = heroCfg1:getNodeWithKey("quality"):toInt() + (heroData1.super_step or 0)
            quality2 = heroCfg2:getNodeWithKey("quality"):toInt() + (heroData2.super_step or 0)
            c_ID1 = tonumber(heroData1.c_id)
            c_ID2 = tonumber(heroData2.c_id)
            if typeName == "default" then
                flag1 = tTeamTab[heroData1.id] or 0
                flag2 = tTeamTab[heroData2.id] or 0
                if flag1 == flag2 then
                        if quality1 == quality2 then
                            if c_ID1 == c_ID2 then
                                return heroData1.lv > heroData2.lv;
                            else
                                return c_ID1 > c_ID2;
                            end
                        else
                            return quality1 > quality2;
                        end
                else
                    return flag1 > flag2;
                end
            elseif typeName == "lv" then
                if heroData1.lv == heroData2.lv then
                    if quality1 == quality2 then
                        return c_ID1 > c_ID2;
                    else
                        return quality1 > quality2;
                    end
                else
                    return heroData1.lv > heroData2.lv;
                end
            elseif typeName == "quality" then
                if quality1 == quality2 then
                    if c_ID1 == c_ID2 then
                        return heroData1.lv > heroData2.lv;
                    else
                        return c_ID1 > c_ID2;
                    end
                else
                    return quality1 > quality2;
                end
            elseif typeName == "profession" then
                race1 = heroCfg1:getNodeWithKey("race"):toInt();
                race2 = heroCfg2:getNodeWithKey("race"):toInt();
                if race1 == race2 then
                    if quality1 == quality2 then
                        if c_ID1 == c_ID2 then
                            return heroData1.lv > heroData2.lv;
                        else
                            return c_ID1 > c_ID2;
                        end
                    else
                        return quality1 > quality2;
                    end
                else
                    return race1 > race2;
                end
            end
        else
            return idOne > idTwo;
        end
    end
    table.sort(idDataTable,sortFunc)
end

function M.cardsSortByTypeNameWithTable3(self,typeName,typeName2,idDataTable)
    -- table.foreach(self.m_tCardsIdTable,print)
-- 默认：1出战状态，2卡牌ID，3卡牌等级
-- 等级：1卡牌等级，2卡牌品质,3卡牌ID
-- 品质：1卡牌品质，2卡牌ID，3卡牌等级
-- 职业：1卡牌职业，2卡牌品质，3卡牌ID，4卡牌等级


    local tempTab = self.m_tCardsData;

    local str = tostring;
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroData1,heroData2,heroCfg1,heroCfg2,quality1,quality2,c_ID1,c_ID2,race1,race2
    local tTeamTab = {};
    for k,v in pairs(self.m_tTeamData or {}) do
        tTeamTab[str(v)] = 20;
    end
    for k,v in pairs(self.m_tAssistant or {}) do
        tTeamTab[str(v)] = 10;
        tTeamTab[str(self.m_tDestiny[k])] = 9;
    end
    local flag1,flag2
    
    
    local heroCfg3,heroData3,quality3
    local cardidData = util.table_copy(idDataTable)


    for k,v in pairs(cardidData) do
        local num = true
        local temp = nil
        temp = k
        heroData3 = tempTab[str(v[1])]
        if heroData3 then
            heroCfg3 = character_detail_cfg:getNodeWithKey(tostring(heroData3.c_id));
            if heroCfg3 then
                quality3 = heroCfg3:getNodeWithKey("quality"):toInt() 
                for k1,v1 in pairs(typeName2) do
                    if quality3.."" == (v1-1).."" then
                        num = false
                        break
                    end
                end
            end
            if num  then
                cardidData[temp] = nil
            end
        end
    end
    local cardidData_n = {}
    for k,v in pairs(cardidData) do
        if v[1] then
            cardidData_n[#cardidData_n + 1] = v
        end
    end
    local heroData3,heroData4,heroCfg3,heroCfg4,flag3,flag4
    local function sortFunc2( idone,idtwo )
        heroData3 = tempTab[str(idone)]
        heroData4 = tempTab[str(idtwo)]
        heroCfg3 = character_detail_cfg:getNodeWithKey(tostring(heroData3.c_id));
        heroCfg4 = character_detail_cfg:getNodeWithKey(tostring(heroData4.c_id));
        if heroCfg3 and heroCfg4 then
            if typeName == "default" then
                flag3 = tTeamTab[heroData3.id] or 0
                flag4 = tTeamTab[heroData4.id] or 0
                if flag3 == flag4 then
                    return heroData3.lv > heroData4.lv;     
                else
                    return flag3 > flag4;
                end
            elseif typeName == "lv" then
                return heroData3.lv > heroData4.lv;
            elseif typeName == "quality" then
                return heroData3.lv > heroData4.lv;
            elseif typeName == "profession" then
                return heroData3.lv > heroData4.lv;               
            end
        else
            return idOne > idTwo; 
        end 
    end
    
    for k,v in pairs(cardidData_n) do
        table.sort(v,sortFunc2)
    end


    local function sortFunc(idOne,idTwo)
        heroData1 = tempTab[str(idOne[1])]
        heroData2 = tempTab[str(idTwo[1])]
        heroCfg1 = character_detail_cfg:getNodeWithKey(tostring(heroData1.c_id));
        heroCfg2 = character_detail_cfg:getNodeWithKey(tostring(heroData2.c_id));
        if heroCfg1 and heroCfg2 then
            quality1 = heroCfg1:getNodeWithKey("quality"):toInt() + (heroData1.super_step or 0) 
            quality2 = heroCfg2:getNodeWithKey("quality"):toInt() + (heroData2.super_step or 0) 
            c_ID1 = tonumber(heroData1.c_id)
            c_ID2 = tonumber(heroData2.c_id)
            if typeName == "default" then
                flag1 = tTeamTab[heroData1.id] or 0

                
                flag2 = tTeamTab[heroData2.id] or 0
                if flag1 == flag2 then
                        if quality1 == quality2 then
                            if c_ID1 == c_ID2 then
                                return heroData1.lv > heroData2.lv;
                            else
                                return c_ID1 > c_ID2;
                            end
                        else
                            return quality1 > quality2;
                        end
                else
                    return flag1 > flag2;
                end
            elseif typeName == "lv" then
                if heroData1.lv == heroData2.lv then
                    if quality1 == quality2 then
                        return c_ID1 > c_ID2;
                    else
                        return quality1 > quality2;
                    end
                else
                    return heroData1.lv > heroData2.lv;
                end
            elseif typeName == "quality" then
                if quality1 == quality2 then
                    if c_ID1 == c_ID2 then
                        return heroData1.lv > heroData2.lv;
                    else
                        return c_ID1 > c_ID2;
                    end
                else
                    return quality1 > quality2;
                end
            elseif typeName == "profession" then
                race1 = heroCfg1:getNodeWithKey("race"):toInt();
                race2 = heroCfg2:getNodeWithKey("race"):toInt();
                if race1 == race2 then
                    if quality1 == quality2 then
                        if c_ID1 == c_ID2 then
                            return heroData1.lv > heroData2.lv;
                        else
                            return c_ID1 > c_ID2;
                        end
                    else
                        return quality1 > quality2;
                    end
                else
                    return race1 > race2;
                end
            end
        else
            return idOne > idTwo;
        end
    end

    table.sort(cardidData_n,sortFunc)

    return cardidData_n
    
end

--[[--
    cards 超进阶数据排序
]]
function M.cardsSuperEvoSortByTypeNameWithTable(self,typeName,idDataTable)
    -- table.foreach(self.m_tCardsIdTable,print)
-- 默认：1出战状态，2卡牌ID，3卡牌等级
-- 等级：1卡牌等级，2卡牌品质,3卡牌ID
-- 品质：1卡牌品质，2卡牌ID，3卡牌等级
-- 职业：1卡牌职业，2卡牌品质，3卡牌ID，4卡牌等级
-- 1、进阶等级最低，2、转生等级最低，3、卡牌等级最低
    local tempTab = self.m_tCardsData;
    local str = tostring;
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroData1,heroData2,heroCfg1,heroCfg2,quality1,quality2,c_ID1,c_ID2,step1,step2,bre1,bre2
    local tTeamTab = {};
    for k,v in pairs(self.m_tTeamData or {}) do
        tTeamTab[str(v)] = 20;
    end
    for k,v in pairs(self.m_tAssistant or {}) do
        tTeamTab[str(v)] = 10;
        tTeamTab[str(self.m_tDestiny[k])] = 9;
    end
    local flag1,flag2
    local function sortFunc(idOne,idTwo)
        heroData1 = tempTab[str(idOne)]
        heroData2 = tempTab[str(idTwo)]
        heroCfg1 = character_detail_cfg:getNodeWithKey(tostring(heroData1.c_id));
        heroCfg2 = character_detail_cfg:getNodeWithKey(tostring(heroData2.c_id));
        if heroCfg1 and heroCfg2 then
            quality1 = heroCfg1:getNodeWithKey("quality"):toInt() + (heroData1.super_step or 0)
            quality2 = heroCfg2:getNodeWithKey("quality"):toInt() + (heroData2.super_step or 0)
            c_ID1 = tonumber(heroData1.c_id)
            c_ID2 = tonumber(heroData2.c_id)
            if typeName == "default" then
                flag1 = tTeamTab[heroData1.id] or 0
                flag2 = tTeamTab[heroData2.id] or 0
                if flag1 == flag2 then
                    if quality1 == quality2 then
                        if c_ID1 == c_ID2 then
                            return heroData1.lv > heroData2.lv;
                        else
                            return c_ID1 > c_ID2;
                        end
                    else
                        return quality1 > quality2;
                    end
                else
                    return flag1 > flag2;
                end
            end
        else
            return idOne > idTwo;
        end
    end
    table.sort(idDataTable,sortFunc)
end

--[[--
    cards数据排序类型
]]
function M.getCardSortType(self)
    -- cclog2(self.m_cardSortType,"///////////////")
    return self.m_cardSortType;

end

function M.getCardSortType2(self)
    -- cclog2(self.m_cardSortType2,"///////////////")
    return self.m_cardSortType2;
end

--[[--
    获得卡牌的数量
]]
function M.getCardsCount(self)
    return #self.m_tCardsIdTable;
end

--[[--
    卡牌数量
]]
function M.getCardCountByCid(self,cId,selId)
    local tempCount = 0;
    local tostring = tostring;
    cId = tostring(cId);
    selId = tostring(selId);
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    for k,v in pairs(self.m_tCardsData) do
        if tostring(v.c_id) == cId and tostring(k) ~= selId then
            local itemCfg = character_detail_cfg:getNodeWithKey(tostring(v.c_id));
            if itemCfg then
                local existFlag1 = self:heroInTeamById(v.id)
                local existFlag2 = self:heroInAssistantById(v.id)
                local godflag3 = game_data:godheroInTeamById(v.id)
                if not (existFlag1 or existFlag2 or godflag3) then
                    tempCount = tempCount + 1;
                end
            end
        end
    end
    return tempCount;
end

--[[--
    卡牌数量 要求返回可被消耗的数量
]]
function M.getCostCardCountByCid(self,cId,selId)
    local tempCount = 0;
    local tostring = tostring;
    cId = tostring(cId);
    selId = tostring(selId);
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    for k,v in pairs(self.m_tCardsData) do
        if tostring(v.c_id) == cId and tostring(k) ~= selId then
            local itemCfg = character_detail_cfg:getNodeWithKey(tostring(v.c_id));
            if itemCfg then
                local canAdd = true
                -- 编队中
                local existFlag1 = self:heroInTeamById(v.id)
                if existFlag1 then
                    canAdd = false
                end
                -- 判断助阵
                local existFlag2 = self:heroInAssistantById(v.id)
                if existFlag2 then
                    canAdd = false
                end
                -- god 编队中
                local godflag3 = game_data:godheroInTeamById(v.id)
                if godflag3 then
                    canAdd = false
                end
                -- 判断名人堂
                if self.m_famousAllData[v.id] then
                    canAdd = false
                end
                -- 饰品
                local ornaments = v.ornaments or {}
                local hasSp = false
                for k, v in pairs(ornaments) do
                    if v ~= "0" then
                        hasSp = true
                    end
                end
                if hasSp then
                    canAdd = false
                end

                -- 判断是否被进阶过
                if v.step >= 1 then
                    canAdd = false
                end

                --[[
                    判断是否在阵容中
                    remove_avail是个列表，里面可能存放  'sys', 'user', 'train', 'dispatch'
                    分别代表 出战中、被玩家锁定、训练中、派遣中
                ]]
                local remove_avail = v.remove_avail or {}
                if #remove_avail > 0 then
                    canAdd = false
                end

                -- 虫洞阵型中
                for k1, v1 in pairs(self.m_wormholes_field) do
                    local wormholes_formation = v1.wormholes_formation or {}
                    for k2, v2 in pairs(wormholes_formation) do
                        if v2 == v.id then
                            canAdd = false
                        end
                    end
                end

                if canAdd then
                    tempCount = tempCount + 1;
                end
            end
        end
    end
    return tempCount;
end
--[[--
    获得cards数据表
]]
function M.getTableCardsData(self)
    return self.m_tCardsData;
end

--[[--
    通过id获得card数据
]]
function M.getCardDataById(self,cardId)
    local cardData = self.m_tCardsData[tostring(cardId)];
    if cardData == nil then return nil,nil end
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroCfg = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id));
    local skinHeroCfg = heroCfg
    -- local heroCfg2 = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id));
    if heroCfg:getNodeWithKey("is_skin") then
        if heroCfg:getNodeWithKey("is_skin"):toInt() ~= 0 then
            local skinID = heroCfg:getNodeWithKey("is_skin"):toInt()
            local flag = game_util:isWearSkin(skinID)
            if flag then
                skinHeroCfg = character_detail_cfg:getNodeWithKey(tostring(skinID));
            end
        end
    end
    return cardData,skinHeroCfg,heroCfg;
    -- return cardData,heroCfg;
end

--[[
    通过index获得card数据
]]--
function M.getCardDataByIndex(self,index)
    if index > 0 and index <= #self.m_tCardsIdTable then
        return self:getCardDataById(self.m_tCardsIdTable[index]);
    end
    return nil,nil;
end
--[[ 
    返回符合要求的card数据   --品质返回    --专给分解用的，exchange_id > 0 才给用
]]--
function M.getCardsDataByQuality(self,quality)
    -- local cardsTable = self:getTableCardsData();
    local tempIdTable = {};
    for k,v in pairs(self.m_tCardsData) do
        local cardData,heroCfg = self:getCardDataById(tostring(k));
        local my_quality = heroCfg:getNodeWithKey("quality"):toInt();
        local exchange_id = heroCfg:getNodeWithKey("exchange_id"):toInt()
        if my_quality >= quality and exchange_id > 0 then
            table.insert(tempIdTable,tostring(k));
            -- tempIdTable[tostring(k)] = v;
        end
    end
    return tempIdTable;
end
--[[ 
    返回符合要求的card数据   --专一品质返回    品质是紫卡以上才有效，  品质大于3，返回特定品质的卡牌，如quality=3返回紫卡
]]--
function M.getCardsDataByQualityUnique(self,quality,cardsTable)
    -- local cardsTable = self:getTableCardsData();
    local tempIdTable = {};
    for i=1,#cardsTable do
        local cardData,heroCfg = self:getCardDataById(tostring(cardsTable[i]));
        local my_quality = heroCfg:getNodeWithKey("quality"):toInt();
        local exchange_id = heroCfg:getNodeWithKey("exchange_id"):toInt()
        if quality >= 3 then
            if my_quality == quality and exchange_id > 0 then
                table.insert(tempIdTable,tostring(cardsTable[i]));
            end
        else
            table.insert(tempIdTable,tostring(cardsTable[i]));
        end
    end
    return tempIdTable;
end
--[[--
    获取指定品质以上的卡牌数据，剔除名人堂和助威阵法中的角色
]]
function M.getCardsDataByQualityFiltered(self,quality)
    -- 先获取原始数据
    local tempIdTable = self:getCardsDataByQuality(quality)
    
    -- 获取名人堂数据
    local famousAllData = game_data:getFamousAllData() or {}
    
    -- 剔除在名人堂和阵法加成中的角色
    local filteredTab = {}
    for _, id in ipairs(tempIdTable) do
        -- 检查是否在名人堂中
        local inFamous = false
        if famousAllData[id] then
            if type(famousAllData[id]) == "table" then
                -- 如果是table类型，检查第二个元素是否存在且不为空
                inFamous = famousAllData[id][2] and famousAllData[id][2] ~= ""
            elseif famousAllData[id] == 1 then
                inFamous = true
            end
        end
        
        -- 检查是否在阵法加成中
        local inFormationBonus = game_util:isInFormationBonus2(id)
        
        if not inFamous and not inFormationBonus then
            table.insert(filteredTab, id)
        else
            -- -- 输出被剔除的角色信息
            -- local _, cardCfg = game_data:getCardDataById(id)
            -- local cardName = cardCfg and cardCfg:getNodeWithKey("name"):toStr() or "未知"
            -- local reason = ""
            -- if inFamous then
                --     reason = reason .. "名人堂"
            -- end
            -- if inFormationBonus then
                --     if reason ~= "" then
                    --         reason = reason .. "+"
                --     end
                --     reason = reason .. "阵法(" .. tostring(inFormationBonus) .. ")"
            -- end
            -- cclog("[getCardsDataByQualityFiltered] 剔除角色ID: " .. id .. ", 名字: " .. cardName .. ", 原因: " .. reason)
        end
    end
    
    return filteredTab
end

function M.getDispatchCard(self)
    return self.m_dispatchCard
end

function M.setDispatchCard(self, dispatchCard )
    self.m_dispatchCard = dispatchCard
end



--[[--
    通过id获得  裁剪过的 card数据
]]
-- function M.getCardDataByIdWithQuality(self,cardId,quality)
--     local tempIdTable = self:getCardsDataByQuality(quality);
--     local cardData = tempIdTable[tostring(cardId)];
--     if cardData == nil then return nil,nil end
--     local character_detail_cfg = getConfig(game_config_field.character_detail);
--     local heroCfg = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id));
--     return cardData,heroCfg;
-- end
--[[
    通过index获得  裁剪过的 card 表数据
]]--
-- function M.getCardDataByIndexWithQuality(self,index,quality)
--     local tempIdTable = self:getCardsDataByQuality(quality);
--     if index > 0 and index <= #tempIdTable then
--         return self:getCardDataByIdWithQuality(self.m_tCardsIdTable[index]);
--     end
--     return nil,nil;
-- end
--[[--
    通过index获得card id
]]

--[[ 
    返回符合要求的card数据   --转生和进阶    --专给转世用的
]]--
function M.getCardsDataByEvoAndJinjie(self)
    -- local cardsTable = self:getTableCardsData();
    local tempIdTable = {};
    for k,v in pairs(self.m_tCardsData) do
        local cardData,heroCfg = self:getCardDataById(tostring(k));
        --cclog2(cardData,"ddddd ==== ")
        local bre = cardData.bre
        local evo = cardData.evo
        if bre >=7 and evo >= 35 then
            local cardid = tostring(cardData.c_id)
            local afterlife = getConfig(game_config_field.afterlife)
            afterlife = json.decode(afterlife:getFormatBuffer())
            if afterlife[cardid] ~= nil then 
                table.insert(tempIdTable,v);
            end
        end
    end
    return tempIdTable;
end
function M.getCardIdByIndex(self,index)
    if index > 0 and index <= #self.m_tCardsIdTable then
        return self.m_tCardsIdTable[index];
    end
    return nil;
end
--[[
    通过card id 得到index
]]--
function M.getIndexByCardId(self,cardId)
    for i=1,#self.m_tCardsIdTable do
        local card_id = self:getCardIdByIndex(i)
        if tostring(card_id) == tostring(cardId) then 
            return i;
        end
    end
    return nil;
end
--[[--
    更新卡牌数据
]]
function M.updateOneCardDataByJsonData(self,cardJsonData)
    if cardJsonData == nil then return end
    local cardData = json.decode(cardJsonData:getFormatBuffer());
    local cardId = tostring(cardData.id);
    if self.m_tCardsData[cardId] == nil then
        self.m_tCardsIdTable[#self.m_tCardsIdTable + 1] = cardId
        local character_detail_cfg = getConfig(game_config_field.character_detail);
        local heroCfg = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id));
        if heroCfg and heroCfg:getNodeWithKey("quality"):toInt() > 3 then
            self.m_newCardIdTab[cardId] = 1;
            self.m_newCardIdTab.count = self.m_newCardIdTab.count + 1;
        end
    end
    self.m_tCardsData[cardId] = cardData;
end
--[[--
    更新卡牌数据
]]
function M.updateMoreCardDataByJsonData(self,cardsJsonData)
    if cardsJsonData == nil then return end
    local cardsCount = cardsJsonData:getNodeCount();
    for i=1,cardsCount do
         self:updateOneCardDataByJsonData(cardsJsonData:getNodeAt(i-1));
    end
    self.m_tkapaiData = self:getKaPaiCidData( )
    self:cardsSortByTypeName(self.m_cardSortType);
    self:cardsSortByTypeName2(self.m_cardSortType,self.m_cardSortType2)
    self:cardsSortByTypeName3(self.m_cardSortType);
    -- cclog("updateMoreCardDataByJsonData ================cardsCount " .. cardsCount);
end

--[[--
    通过id移除卡牌数据
]]
function M.removeOneCardDataById(self,cardId)
    cardId = tostring(cardId);
    local removeIndex = nil;
    local removeIndex2 = nil;

    for k,v in pairs(self.m_tCardsIdTable) do
        if v == cardId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tCardsIdTable,removeIndex);
        if self.m_tCardsData[cardId] then
            self.m_tCardsData[cardId] = nil;
        end 
    end
    for k,v in pairs(self.m_tkapaiData) do
        for k1,v1 in pairs(v) do
            if v1 == cardId then 
                removeIndex2 = v1
                break;
            end
        end
        if removeIndex2 ~= nil then
            table.remove(v,tonumber(removeIndex2))
            break;
        end
    end
    if self.m_newCardIdTab[cardId] then
        self.m_newCardIdTab[cardId] = nil;
        self.m_newCardIdTab.count = self.m_newCardIdTab.count - 1;
    end

end

--[[--
    通过id表格移出卡牌数据
]]
function M.removeMoreCardDataByIdTable(self,tCardIds)
    if tCardIds == nil or type(tCardIds) ~= "table" then return end
    for k,v in pairs(tCardIds) do
        self:removeOneCardDataById(v);
    end
end

--[[--
    通过json数据设置编队数据
]]
function M.setTeamByJsonData(self,teamJsonData)
    if teamJsonData == nil then return end
    self.m_tTeamData = {};
    local alignmentData = teamJsonData:getNodeAt(0);
    local attackerCount = alignmentData:getNodeCount();
    local itemId = nil;
    for i=1,5 do
        if i <= attackerCount then
            itemId = alignmentData:getNodeAt(i-1);
            self.m_tTeamData[i] = itemId:toStr();
        else
            self.m_tTeamData[i] = "-1";
        end
    end

    alignmentData = teamJsonData:getNodeAt(1);
    attackerCount = alignmentData:getNodeCount();
    for i=1,5 do
        if i <= attackerCount and i < 4 then
            itemId = alignmentData:getNodeAt(i-1);
            self.m_tTeamData[i+5] = itemId:toStr();
        else
            self.m_tTeamData[i+5] = "-1";
        end
    end
    cclog("setTeamByJsonData ================ " .. #self.m_tTeamData);
end

--[[--
    通过pos和卡牌id改变编队数据
]]
function M.setTeamByPosAndCardId(self,posIndex,cardId)
    if posIndex > 0 and posIndex < 11 then
        self.m_tTeamData[posIndex] = tostring(cardId);
    end
end

--[[--
    通过pos编队数据
]]
function M.exchangeTeamDataByTwoPos(self,posIndex1,posIndex2)
    if posIndex1 > 0 and posIndex1 < 11 and posIndex2 > 0 and posIndex2 < 11 then
        self.m_tTeamData[posIndex1],self.m_tTeamData[posIndex2] = self.m_tTeamData[posIndex2],self.m_tTeamData[posIndex1]
        self.m_tEquipPosData[tostring(posIndex1-1)],self.m_tEquipPosData[tostring(posIndex2-1)] = self.m_tEquipPosData[tostring(posIndex2-1)],self.m_tEquipPosData[tostring(posIndex1-1)]
        cclog("exchangeTeamDataByTwoPos = " .. json.encode(self.m_tEquipPosData))
    end
end

--[[--
    通过pos获得位置的卡牌数据
]]
function M.getTeamCardDataByPos(self,posIndex)
    local cardId = self.m_tTeamData[posIndex];
    if cardId and cardId ~= "-1" then
        return self:getCardDataById(cardId);
    end
    return nil,nil;
end

--[[--
    通过pos获得助威位置的卡牌数据
]]
function M.getAssTeamCardDataByPos(self,posIndex)
    local cardId = self.m_tAssistant[posIndex] or "-1"
    return self:getCardDataById(cardId);
end

--[[--
    获得编队数据
]]
function M.getTeamData(self)
    return self.m_tTeamData;
end

--[[--
    设置编队数据
]]
function M.setTeamData(self,tempData)
    self.m_tTeamData = tempData;
end

--[[--
    获得编队中前排卡牌个数
]]
function M.getTeamFrontRowCount(self)
    local tempCount = 0;
    for i=1,5 do
        if self.m_tTeamData[i] ~= "-1" then
            tempCount = tempCount + 1;
        end
    end
    return tempCount;
end

--[[--
    判断是否可以替换
]]
function M.getExchangeTeamDataByTwoPosFlag(self,posIndex1,posIndex2)
    local returnFlag = false;
    if posIndex1 > 0 and posIndex1 < 11 and posIndex2 > 0 and posIndex2 < 11 then
        if posIndex1 < 6 and posIndex2 < 6 then
            returnFlag = true;
        elseif posIndex1 > 5 and posIndex2 > 5 then
            returnFlag = true;
        else
            local tempCount = 0;
            for i=1,5 do
                if self.m_tTeamData[i] ~= "-1" and i ~= posIndex1 then
                    tempCount = tempCount + 1;
                end
            end
            if posIndex2 > 5 then
                if self.m_tTeamData[posIndex2] ~= "-1" then
                    tempCount = tempCount + 1;
                end
            end
            if tempCount > 0 then
                returnFlag = true;
            end
        end
    end
    return returnFlag;
end

--[[--
    判断英雄是否在编队中
]]
function M.heroInTeamById(self,heroId)
    for k,v in pairs(self.m_tTeamData) do
        if v ~= "-1" and tostring(v) == tostring(heroId) then
            return true;
        end
    end
    return false;
end

--[[--
    获得英雄在编队中的位置
]]
function M.getHeroInTeamIndexById(self,heroId)
    for k,v in pairs(self.m_tTeamData) do
        if v ~= "-1" and tostring(v) == tostring(heroId) then
            return k;
        end
    end
    return -1;
end

--[[--
    判断英雄是否在助阵中
]]
function M.heroInAssistantById(self,heroId)
    for k,v in pairs(self.m_tAssistant) do
        if v ~= "-1" and tostring(v) == tostring(heroId) then
            return true;
        end
    end
    for k,v in pairs(self.m_tDestiny) do
        if v ~= "-1" and tostring(v) == tostring(heroId) then
            return true;
        end
    end
    return false;
end

--[[--
    激活卡牌技能
]]
function M.activationCardSkill(self,cardId,skillPos)
    local cardData,_ = self:getCardDataById(tostring(cardId));
    local skillItem = cardData["s_" .. skillPos];
    -- 'avail': 1   # 0表示未解锁，1表示解锁未激活，2表示激活
    skillItem.avail = 2;
end



--[[------------------------------------卡牌相关 end------------------------------------------- ]]

--[[------------------------------------寵物相关 begin------------------------------------------- ]]
--[[        寵物      ]]
--[[--
    通過json數據設置pet數據
]]
function M.setPetByJsonData(self,petJsonData)
    if petJsonData == nil then
        return;
    end
    self.m_tPetIdTable = {}
    self.m_petData = json.decode(petJsonData:getFormatBuffer()) or {}
    if self.m_petData ~= nil and type(self.m_petData) == "table" then
        for k,v in pairs(self.m_petData) do
            self.m_tPetIdTable[#self.m_tPetIdTable + 1] = k;
        end
    end
    -- self:cardsSortByTypeName(self.m_cardSortType);
end

--[[--
    獲得寵物的數量
]]
function M.getPetCount(self)
    return #self.m_tPetIdTable;
end

--[[--
    獲得寵物的ID
]]
function M.getPetIdTable(self)
    return self.m_tPetIdTable;
end
--[[
    獲得寵物數據
]]
function M.getPetTableData(self)
    return self.m_petData;
end
--[[
    通過index獲得pet數據
]]--
function M.getPetDataByIndex(self,index)
    if index > 0 and index <= #self.m_tPetIdTable then
        return self:getPetDataById(self.m_tPetIdTable[index]);
    end
    return nil,nil;
end
--[[
    通過id獲得寵物數據
]]
function M.getPetDataById(self,petId)
    local petData = self.m_petData[tostring(petId)];
    if petData == nil then return nil,nil end
    local pet_detail = getConfig(game_config_field.pet_detail);
    local petCfg = pet_detail:getNodeWithKey(tostring(petData.c_id));
    return petData,petCfg;
end

--[[--
    更新寵物數據
]]
function M.updateOnePetDataByJsonData(self,petJsonData)
    if petJsonData == nil then return end
    local petData = json.decode(petJsonData:getFormatBuffer());
    local petId = tostring(petData.id);
    if self.m_petData[petId] == nil then
        self.m_tPetIdTable[#self.m_tPetIdTable + 1] = petId
        local pet_detail_cfg = getConfig(game_config_field.pet_detail);
        local petCfg = pet_detail_cfg:getNodeWithKey(tostring(petData.c_id));
        if petCfg and petCfg:getNodeWithKey("quality"):toInt() > 3 then
            self.m_newPetIdTab[petId] = 1;
            self.m_newPetIdTab.count = self.m_newPetIdTab.count + 1;
        end
    end
    self.m_petData[petId] = petData;
end
--[[--
    更新寵物數據
]]
function M.updateMorePetDataByJsonData(self,petsJsonData)
    if petsJsonData == nil then return end
    local petsCount = petsJsonData:getNodeCount();
    for i=1,petsCount do
        self:updateOnePetDataByJsonData(petsJsonData:getNodeAt(i-1));
    end
    -- self:cardsSortByTypeName(self.m_cardSortType);
end
--[[--
    通過id移除寵物數據
]]
function M.removeOnePetDataById(self,petId)
    petId = tostring(petId);
    local removeIndex = nil;
    for k,v in pairs(self.m_tPetIdTable) do
        if v == petId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tPetIdTable,removeIndex);
        self.m_petData[petId] = nil;
    end
    if self.m_newPetIdTab[petId] then
        self.m_newPetIdTab[petId] = nil;
        self.m_newPetIdTab.count = self.m_newPetIdTab.count - 1;
    end
end
--[[--
    通過id表格移出寵物數據
]]
function M.removeMorePetDataByIdTable(self,tPetsIds)
    if tPetsIds == nil or type(tPetsIds) ~= "table" then return end
    for k,v in pairs(tPetsIds) do
        self:removeOnePetDataById(v);
    end
end
--[[--
    通過json數據設置寵物陣型
]]
function M.setPetTeamByJsonData(self,teamJsonData)
    if teamJsonData == nil then return end
    self.m_tPetTeamTable = {};
    local alignmentData = teamJsonData
    local attackerCount = alignmentData:getNodeCount();
    local itemId = nil;
    for i=1,9 do
        if i <= attackerCount then
            itemId = alignmentData:getNodeAt(i-1)
            self.m_tPetTeamTable[i] = itemId:toStr();
        else
            self.m_tPetTeamTable[i] = "-1";
        end
    end
end

--[[
    设置宠物跟随
]]
function M.setPetFollowPos(self,petFollowData)
    if petFollowData == nil then return end
    self.m_pet_follow_pos = json.decode(petFollowData:getFormatBuffer())
end
--[[
    得到宠物跟随数据
]]
function M.getPetFollowPos(self)
    return self.m_pet_follow_pos
end

--[[
    设置宠物跟随属性
]]
function M.setPetFollowAbi(self,value)
    if value == nil then return end
    self.pet_follow_abi = value
end
--[[
    得到宠物跟随属性
]]
function M.getPetFollowAbi(self,value)
    return self.pet_follow_abi;
end

--[[--
    通過pos獲得位置的卡牌數據
]]
function M.getPetTeamCardDataByPos(self,posIndex)
    local cardId = self.m_tPetTeamTable[posIndex];
    if cardId and cardId ~= "-1" then
        return self:getPetDataById(cardId);
    end
    return nil,nil;
end
--[[--
    獲得寵物編隊
]]
function M.getPetTeamData(self)
    return self.m_tPetTeamTable;
end

--[[--
    設置寵物編隊
]]
function M.setPetTeamData(self,tempData)
    self.m_tPetTeamTable = tempData;
end
--[[--
    判斷寵物是否在編隊中
]]
function M.petInTeamById(self,petId) 
    -- for k,v in pairs(self.m_tPetTeamTable  ) do 
    --     if v ~= "-1" and tostring(v) == tostring(petId) then
    --         return true;
    --     end
    -- end
    --寵物是否出戰只判斷第一個格子的
    local inTeamId = self.m_tPetTeamTable[1]
    if inTeamId ~= "-1" and tostring(inTeamId) == tostring(petId) then
        return true
    end
    return false;
end
--[[--
    獲得寵物在編隊中的位置
]]
function M.getPetInTeamIndexById(self,petId)
    for k,v in pairs(self.m_tPetTeamTable) do
        if v ~= "-1" and tostring(v) == tostring(petId) then
            return k;
        end
    end
    return -1;
end
--[[------------------------------------寵物相关 end------------------------------------------- ]]
--[[------------------------------------装备相关 start------------------------------------------- ]]

function M.equipInBonus( self,equipType,equipId )
    -- equipId = tostring(equipId);
    local existFlag = false;
    local pos = nil
    local bonusEquip = self:getFormationBonusEquipData()
    if equipType then
        for i=200,209 do
            if bonusEquip[tostring(i)][equipType] == tonumber(equipId) then
                existFlag = true
                local equipData,_ = game_data:getEquipDataById(tostring(equipId))
                pos = equipData.pos
                break
            end
        end
    end
    return existFlag,pos
end
--[[--
    equip数据排序
]]
function M.equipSortByTypeName(self,typeName,equipData)

    -- 默认：1装备是否装备状态，2装备ID，3卡牌等级
    -- 等级：1装备等级，2装备品质,3装备ID
    -- 品质：1装备品质，2装备ID，3装备等级
    -- 类型：1装备类型，2装备品质，3装备ID，4装备等级
    
    self.m_equipSortType = typeName;
    typeName = typeName or "default";
    local table_ten = {}--重铸过的
    local table_ten1 = {}--未重铸过的
    local table_ming1 = {}
    local table_ming2 = {}
    local table_normal = {}

    local datatable = {}
    local datatableOut = {}
    if equipData then
        datatable = equipData
    else
        datatable = self.m_tEquipIdTable
    end

    local equip_recast_table = getConfig(game_config_field.equip_recast) and json.decode(getConfig(game_config_field.equip_recast):getFormatBuffer()) or {}
    local equip_chain_table = getConfig(game_config_field.chain_equip) and json.decode(getConfig(game_config_field.chain_equip):getFormatBuffer()) or {}

    for k,v in pairs(datatable) do
        if equip_recast_table[""..self.m_tEquipData[v].c_id] ~=nil and self.m_tEquipData[v].is_equip_recast then
            table.insert(table_ten,v)
        elseif equip_recast_table[""..self.m_tEquipData[v].c_id] ~=nil  then
            table.insert(table_ten1,v)
        elseif equip_chain_table[""..self.m_tEquipData[v].c_id ] ~= nil and self.m_tEquipData[v].bind_card~=nil and self.m_tEquipData[v].bind_card ~= "" then
            table.insert(table_ming1,v)
        elseif equip_chain_table[""..self.m_tEquipData[v].c_id ] ~= nil  then
            table.insert(table_ming2,v)
        else
            table.insert(table_normal,v)
        end
    end
    table_ten = self:equipSortByTypeNameWithTable(typeName,table_ten);
    table_ten1 = self:equipSortByTypeNameWithTable(typeName,table_ten1);
    table_ming1 = self:equipSortByTypeNameWithTable(typeName,table_ming1);
    table_ming2 = self:equipSortByTypeNameWithTable(typeName,table_ming2);
    table_normal = self:equipSortByTypeNameWithTable(typeName,table_normal);
    
    for i=1,#table_ten do
        table.insert(datatableOut,table_ten[i])
    end
    for i=1,#table_ten1 do
        table.insert(datatableOut,table_ten1[i])
    end
    for i=1,#table_ming1 do
        table.insert(datatableOut,table_ming1[i])
    end
    for i=1,#table_ming2 do
        table.insert(datatableOut,table_ming2[i])
    end
    for i=1,#table_normal do
        table.insert(datatableOut,table_normal[i])
    end

    if  equipData == nil then
        self.m_tEquipIdTable = datatableOut
    end
    return datatableOut
end

--根据筛选出的装备数据，再排序
function M.equipSortByTypeNameWithTable(self,typeName,idDataTable)
    local tempTab = self.m_tEquipData;
    local str = tostring;
    local equipCfg = getConfig(game_config_field.equip);
    local itemData1,itemData2,itemCfg1,itemCfg2,quality1,quality2,c_ID1,c_ID2,sort1,sort2

    local tTeamTab = {};
    local tempItem = nil;
    for i=1,9 do
        tempItem = self.m_tEquipPosData[tostring(i-1)]
        if tempItem then
            for j=1,4 do
                if tempItem[j] then
                    tTeamTab[str(tempItem[j])] = 10;
                end
            end
        end
        tempItem = self.m_tAssEquipPosData[tostring(i+99)]
        if tempItem then
            for j=1,4 do
                if tempItem[j] then
                    tTeamTab[str(tempItem[j])] = 5;
                end
            end
        end
    end
    local flag1,flag2;
    local function sortFunc(idOne,idTwo)
        itemData1 = tempTab[str(idOne)]
        itemData2 = tempTab[str(idTwo)]
        itemCfg1 = equipCfg:getNodeWithKey(tostring(itemData1.c_id));
        itemCfg2 = equipCfg:getNodeWithKey(tostring(itemData2.c_id));
        if itemCfg1 and itemCfg2 then
            quality1,quality2 = itemCfg1:getNodeWithKey("quality"):toInt(),itemCfg2:getNodeWithKey("quality"):toInt();
            c_ID1,c_ID2 = tonumber(itemData1.c_id),tonumber(itemData2.c_id)
            if typeName == "default" then
                flag1 = tTeamTab[str(itemData1.id)] or 0
                flag2 = tTeamTab[str(itemData2.id)] or 0
                if flag1 == flag2 then
                    if quality1 == quality2 then
                        return itemData1.id > itemData2.id;
                    else
                        return quality1 > quality2
                    end
                else
                    return flag1 > flag2
                end
            elseif typeName == "lv" then
                if itemData1.lv == itemData2.lv then
                    if quality1 == quality2 then
                        return c_ID1 > c_ID2
                    else
                        return quality1 > quality2
                    end
                else
                    return itemData1.lv > itemData2.lv
                end
            elseif typeName == "quality" then
                if quality1 == quality2 then
                    if c_ID1 == c_ID2 then
                        return itemData1.lv > itemData2.lv
                    else
                        return c_ID1 > c_ID2
                    end
                else
                    return quality1 > quality2
                end
            elseif typeName == "sort" then
                sort1,sort2 = itemCfg1:getNodeWithKey("sort"):toInt(),itemCfg2:getNodeWithKey("sort"):toInt();
                if sort1 == sort2 then
                    if quality1 == quality2 then
                        if c_ID1 == c_ID2 then
                            return itemData1.lv > itemData2.lv
                        else
                            return c_ID1 > c_ID2
                        end
                    else
                        return quality1 > quality2;
                    end
                else
                    return sort1 > sort2
                end
            end

        else
            return idOne > idTwo;
        end
    end
    table.sort(idDataTable,sortFunc)
    cclog("equipSortByTypeName ----------------------------------" .. typeName)
    return idDataTable
    -- table.foreach(self.m_tEquipData,print)
end

--[[--
    获得当前排序
]]
function M.getEquipSortType(self)
    return self.m_equipSortType;
end

--[[--
    通过json数据设置装备数据
]]
function M.setEquipDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tEquipData = json.decode(jsonData:getFormatBuffer()) or {};
    if self.m_tEquipData ~= nil and type(self.m_tEquipData) == "table" then
        for k,v in pairs(self.m_tEquipData) do
            self.m_tEquipIdTable[#self.m_tEquipIdTable + 1] = k;
        end
    end
    self:equipSortByTypeName(self.m_equipSortType);
    cclog("setEquipDataByJsonData ================ count " .. #self.m_tEquipIdTable);
end

--[[--
    通过装备数据
]]
function M.getEquipData(self)
    return self.m_tEquipData;
end

--[[--
    装备数量
]]
function M.getEquipCount(self)
    return #self.m_tEquipIdTable;
end

--[[--
    装备数量
]]
function M.getEquipCountByCid(self,cId,selEquipId)
    local tempCount = 0;
    local tostring = tostring;
    cId = tostring(cId);
    selEquipId = tostring(selEquipId);
    local equipCfg = getConfig(game_config_field.equip);
    for k,v in pairs(self.m_tEquipData) do
        if tostring(v.c_id) == cId and tostring(k) ~= selEquipId then
            local itemCfg = equipCfg:getNodeWithKey(tostring(v.c_id));
            if itemCfg then
                local existFlag,_ = self:equipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),k)
                local godexistFlag = self:godequipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),k)
                if not (existFlag or godexistFlag) then
                    tempCount = tempCount + 1;
                end
            end
        end
    end
    return tempCount;
end


--[[--
    装备
]]
function M.getEquipIdTable(self)
    return self.m_tEquipIdTable or {};
end

--[[--
    通过id获得装备数据
]]
function M.getEquipDataById(self,equipId)
    equipId = tostring(equipId)
    local equipData = self.m_tEquipData[equipId];
    if equipData == nil then
        if equipId ~= "0" then
            -- cclog("equipId = " .. equipId .. " ; type(equipId) == " .. tostring(type(equipId)) .. " ; self.m_tEquipData == " .. json.encode(self.m_tEquipData))
        end
        return nil,nil
    end
    local equipCfg = getConfig(game_config_field.equip);
    local equipItemCfg = equipCfg:getNodeWithKey(tostring(equipData.c_id));
    return equipData,equipItemCfg;
end

function M.getEquipIDByFate(self)
    local tempIdTable = {};
    for k,v in pairs(self.m_tEquipData) do
        local equipData,equipCfg = self:getEquipDataById(tostring(k));

        if equipData.bind_card and equipData.bind_card ~="" then
            table.insert(tempIdTable,tostring(k));
            -- tempIdTable[tostring(k)] = v;
        end
    end
    return tempIdTable;
end

--[[--
    通过id, 在装备池获得装备数据
]]
function M.getEquipDataByIdFromPool(self,equipId, gameData)
    equipId = tostring(equipId)
    local equipData = gameData[equipId];
    if equipData == nil then
        if equipId ~= "0" then
            cclog("equipId = " .. equipId .. " ; type(equipId) == " .. tostring(type(equipId)) .. " ; self.m_tEquipData == " .. json.encode(self.m_tEquipData))
        end
        return nil,nil
    end
    local equipCfg = getConfig(game_config_field.equip);
    local equipItemCfg = equipCfg:getNodeWithKey(tostring(equipData.c_id));
    return equipData,equipItemCfg;
end

--[[--
    通过 index 获得装备数据
]]
function M.getEquipDataByIndex(self,index)
    if index > 0 and index <= #self.m_tEquipIdTable then
        return self:getEquipDataById(self.m_tEquipIdTable[index]);
    end
    return nil,nil;
end

--[[--
    通过json数据设置卡牌位置装备数据
]]
function M.setEquipPosDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    -- self.m_tEquipPosData = json.decode(jsonData:getFormatBuffer()) or {};
    local temp_count = jsonData:getNodeCount();
    for i=1,temp_count do
        local itemData = jsonData:getNodeAt(i-1)
        local tempItemData = {};
        for j=1,4 do
            table.insert(tempItemData,itemData:getNodeAt(j-1):toStr())
        end
        self.m_tEquipPosData[itemData:getKey()] = tempItemData;
    end
    cclog("setEquipPosDataByJsonData ================ " .. json.encode(self.m_tEquipPosData));
end

--[[--
    得到卡牌位置装备数据
]]
function M.getEquipPosData(self)
    return self.m_tEquipPosData;
end

--[[--
    设置卡牌位置装备数据
]]
function M.setEquipPosData(self,tempData)
    self.m_tEquipPosData = tempData;
end

--[[--
    通过json数据设置助威卡牌位置装备数据
]]
function M.setAssEquipPosDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tAssEquipPosData = json.decode(jsonData:getFormatBuffer()) or {};
    local temp_count = jsonData:getNodeCount();
    for i=1,temp_count do
        local itemData = jsonData:getNodeAt(i-1)
        local tempItemData = {};
        for j=1,4 do
            table.insert(tempItemData,itemData:getNodeAt(j-1):toStr())
        end
        self.m_tAssEquipPosData[itemData:getKey()] = tempItemData;
    end
    -- cclog("setAssEquipPosDataByJsonData ================ " .. json.encode(self.m_tAssEquipPosData));
end

--[[--
    得到助威卡牌位置装备数据
]]
function M.getAssEquipPosData(self)
    return self.m_tAssEquipPosData or {}
end

--[[--
    设置助威卡牌位置装备数据
]]
function M.setAssEquipPosData(self,tempData)
    self.m_tAssEquipPosData = tempData;
end

--[[--
    设置阵型相应位置装备数据
]]
function M.updateEquipPosData(self,equipPos,equipType,equipId)
    if equipPos > 9 or equipPos < 0 or equipType > 4 or equipType < 1 then return end
    cclog("updateEquipPosData equipPos = " .. equipPos .. " ; equipType = " .. equipType .. " ; equipId = " .. equipId);
    self.m_tEquipPosData[tostring(equipPos)][equipType] = tostring(equipId);
    cclog("updateEquipPosData = " .. json.encode(self.m_tEquipPosData))
end

--[[--
    判断是否装备上
]]
function M.equipInEquipPos(self,equipType,equipId)
    equipId = tostring(equipId);
    local existFlag = false;
    local cardName = "";
    local posEquipData = nil;
    if equipType then
        for i=1,10 do
            if self.m_tEquipPosData[tostring(i-1)][equipType] == equipId then
                posEquipData = self.m_tEquipPosData[tostring(i-1)];
                existFlag = true
                local _,itemCfg = self:getTeamCardDataByPos(i);
                if itemCfg then
                    cardName = itemCfg:getNodeWithKey("name"):toStr();
                else
                    cardName =  "Vị trí" .. i
                end
                break;
            end
            if self.m_tAssEquipPosData[tostring(i+99)][equipType] == equipId then
                posEquipData = self.m_tAssEquipPosData[tostring(i-1)];
                existFlag = true
                local _,itemCfg = self:getAssTeamCardDataByPos(i);
                if itemCfg then
                    cardName = "Trợ uy:" .. itemCfg:getNodeWithKey("name"):toStr();
                else
                    cardName = "Trợ uy:" .. "Vị trí" .. i
                end
                break;
            end
        end
    end
    return existFlag,cardName,posEquipData
end

--[[--
    通过json数据设置装备分类数据
]]
function M.setEquipSortDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tEquipSortData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setEquipSortDataByJsonData ================ ");
end


--[[--
    更新装备数据
]]
function M.updateOneEquipDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemData = json.decode(jsonData:getFormatBuffer());
    local equipId = jsonData:getKey();
    if self.m_tEquipData[equipId] == nil then
        self.m_tEquipIdTable[#self.m_tEquipIdTable + 1] = equipId
        local equipCfg = getConfig(game_config_field.equip);
        local equipItemCfg = equipCfg:getNodeWithKey(tostring(itemData.c_id));
        if equipItemCfg and equipItemCfg:getNodeWithKey("quality"):toInt() > 2  then
            self.m_newEquipIdTab[equipId] = 1;
            self.m_newEquipIdTab.count = self.m_newEquipIdTab.count + 1;
        end
    end
    self.m_tEquipData[equipId] = itemData;
end
--[[--
    更新装备数据
]]
function M.updateMoreEquipDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemCount = jsonData:getNodeCount();
    for i=1,itemCount do
        self:updateOneEquipDataByJsonData(jsonData:getNodeAt(i-1));
    end
    self:equipSortByTypeName(self.m_equipSortType);
    cclog("updateMoreEquipDataByJsonData ================itemCount " .. itemCount .. " ; #self.m_tEquipIdTable == " .. #self.m_tEquipIdTable);
    -- cclog(json.encode(self.m_tEquipData))
    -- cclog(json.encode(self.m_tEquipIdTable))
end
--[[--
    通过id移除装备数据
]]
function M.removeOneEquipDataById(self,itemId)
    itemId = tostring(itemId);
    local removeIndex = nil;
    for k,v in pairs(self.m_tEquipIdTable) do
        if v == itemId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tEquipIdTable,removeIndex);
        self.m_tEquipData[itemId] = nil;
    end
    if self.m_newEquipIdTab[itemId] then
        self.m_newEquipIdTab[itemId] = nil;
        self.m_newEquipIdTab.count = self.m_newEquipIdTab.count - 1;
    end
end
--[[--
    通过id表格移出装备数据
]]
function M.removeMoreEquipDataByIdTable(self,itemIds)
    for k,v in pairs(itemIds) do
        self:removeOneEquipDataById(v);
    end
    cclog("removeMoreEquipDataByIdTable #self.m_tEquipIdTable ===== " .. #self.m_tEquipIdTable)
end


--[[--
    通过 equipType 获得装备数据
]]
function M.getEquipDataByEquipType(self,equipType)
    local tempTab = {};
    local equipCfg = getConfig(game_config_field.equip);
    local equipCfgItem = nil;
    local sort = nil;
    local itemData = nil;
    for k,v in pairs(self.m_tEquipIdTable) do
        v = tostring(v)
        itemData = self.m_tEquipData[v];
        -- cclog("id ==================== " .. v)
        if itemData then
            equipCfgItem = equipCfg:getNodeWithKey(itemData.c_id);
            sort = equipCfgItem:getNodeWithKey("sort"):toInt();
            if equipCfgItem ~= nil and sort ~= 0 then
                if equipType == nil then
                    tempTab[#tempTab + 1] = v;
                else
                    equipType = tonumber(equipType);
                    if equipType == -1 then
                        tempTab[#tempTab + 1] = v;
                    elseif sort == equipType then
                        tempTab[#tempTab + 1] = v;
                    end
                end
            end
        end
    end
    return tempTab;
end

--[[------------------------------------装备相关 end------------------------------------------- ]]


--[[--
    通过json数据设置阵型数据
]]
function M.setFormationDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tFormationData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setFormationDataByJsonData ================ ");
    if not self:getRightTeamData() then   -- zyz   初始化真实阵容信息
        self:setRightFormation()
    end
end

--[[--
    获得阵型数据
]]
function M.getFormationData(self)
    return self.m_tFormationData;
end

--[[--
    通过json数据更新阵型数据
]]
function M.updateOwnFormationDataByJsonData(self,jsonData)
    if jsonData == nil or jsonData:getNodeWithKey("own") == nil then return end
    self.m_tFormationData.own = json.decode(jsonData:getNodeWithKey("own"):getFormatBuffer()) or {};
    cclog("updateOwnFormationDataByJsonData ================ ");
end

--[[--
    通过json数据设置用户基础数据
]]
function M.setUserStatusDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tUserStatusData = json.decode(jsonData:getFormatBuffer()) or {};
    self.m_action_point_add_time = self.m_tUserStatusData["action_point_rate"] or 360
    self:resetServerTime( self.m_tUserStatusData.server_time)
end

--[[--
    获得用户基础数据
]]
function M.getUserStatusData(self)
    return self.m_tUserStatusData or {};
end

--[[--
   
]]
function M.setUserStatusDataBackup(self)
    self.m_tUserStatusDataBackup = util.table_copy(self.m_tUserStatusData)
end

--[[--
    
]]
function M.getUserStatusDataBackup(self)
    return self.m_tUserStatusDataBackup or {};
end

--[[--
    
]]
function M.getActionPointTime(self,key)
    local point = 0;
    if self.m_tUserStatusData.action_point_max then
        point = self.m_tUserStatusData.action_point_max - self.m_tUserStatusData.action_point;
    end
    return point*self.m_action_point_add_time;
end
--[[
    获得行动力
]]
function M.getActionPointValue(self)
    return self.m_tUserStatusData.action_point;
end
--[[--
    获得
]]
function M.getMaxGuideIndex(self)
    local guide = self.m_tUserStatusData["guide"] or {};
    local maxGuideIndex = -1;
    for k,v in pairs(guide) do
        maxGuideIndex = math.max(maxGuideIndex,v);
    end
    return maxGuideIndex;
end

--[[--
    通过json数据设置建筑数据
]]
function M.setBuildingAbilityDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tBuildingAbilityData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setBuildingAbilityDataByJsonData ================ ");
end

--[[--
   获得建筑数据
]]
function M.getBuildingAbilityData(self)
    return self.m_tBuildingAbilityData;
end

--设置 m_nEquipDataC_id{c_id{c_id,id}}  m_nEquipDataidtoC_id{id{c_id}}
function M.setCidEquipDataByJsonData(self,equipData)
    self.m_nEquipDataidtoC_id = {}
    self.m_nEquipDataC_id = {}
    local nequipData =  json.decode(equipData:getFormatBuffer()) or {};
    for k,v in pairs(nequipData) do
        -- self.m_nEquipDataC_id[v.c_id] = v
        table.insert(self.m_nEquipDataC_id,{v.c_id,v.id})
        self.m_nEquipDataidtoC_id[""..v.id] = v.c_id
    end
end



--设置 m_nEquipDataC_id{c_id{c_id,id}}  m_nEquipDataidtoC_id{id{c_id}}
function M.setCidEquipDataByEquipData(self,equipData)
    self.m_nEquipDataidtoC_id = {}
    self.m_nEquipDataC_id = {}
    for k,v in pairs(equipData) do
        -- self.m_nEquipDataC_id[v.c_id] = v
        table.insert(self.m_nEquipDataC_id,{v.c_id,v.id})
        self.m_nEquipDataidtoC_id[""..v.id] = v.c_id
    end
end

--[[--
   通过key获得建筑数据
]]
function M.getBuildingAbilityDataByKey(self,key)
    return self.m_tBuildingAbilityData[key];
end

--[[--
    通过json数据设置资源数据
]]
function M.setResourceDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tResourceData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setResourceDataByJsonData ================ ");
end

--[[--
   获得资源数据
]]
function M.getResourceData(self)
    return self.m_tResourceData;
end

--[[--
   通过key获得资源数据
]]
function M.getResourceDataByKey(self,key)
    return self.m_tResourceData[key];
end

--[[--
    通过json数据设置建筑数据
]]
function M.setPrivateBuildingDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tPrivateBuildingData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setPrivateBuildingDataByJsonData ================ ");
end

--[[--
   获得建筑数据
]]
function M.getPrivateBuildingData(self)
    return self.m_tPrivateBuildingData;
end
--[[--
    全局计时器
]]
function M.initGlobalScheduler(self)
    if self.m_globalSchedulerHandle ~= nil then
        scheduler.unschedule(self.m_globalSchedulerHandle);
        self.m_globalSchedulerHandle = nil;
    end
    local durTime = 0;
    local actionDurTime = 0;
    local function globalSchedulerFunc(dt)
        durTime = durTime + dt;
        -- cclog("globalSchedulerFunc ==================dt = " .. tostring(dt) .. " ; durTime = " .. durTime);
        if durTime >= 60 then
            -- cclog("globalSchedulerFunc ==================" .. tostring(dt));
            if self.m_tResourceData.food_ability ~= nil then
                self.m_tResourceData.food_pool = self.m_tResourceData.food_pool + self.m_tResourceData.food_ability
            end
            if self.m_tResourceData.metal_ability ~= nil then
                self.m_tResourceData.metal_pool = self.m_tResourceData.metal_pool + self.m_tResourceData.metal_ability
            end
            if self.m_tResourceData.energy_ability ~= nil then
                self.m_tResourceData.energy_pool = self.m_tResourceData.energy_pool + self.m_tResourceData.energy_ability
            end
            durTime = 0;
        end
        self:resourceStep( dt )
        -- actionDurTime = actionDurTime + dt;
        -- if actionDurTime >= self.m_action_point_add_time then
        --     local action_point = self.m_tUserStatusData.action_point
        --     if action_point ~= nil and action_point < self.m_tUserStatusData.action_point_max then
        --         self.m_tUserStatusData.action_point = action_point + 1;
        --         game_scene:fillPropertyBarData();
        --     end
        --     actionDurTime = 0;
        -- end
    end
    self.m_globalSchedulerHandle = scheduler.schedule(globalSchedulerFunc,1.0,false,false);
end

function M:resourceStep( dt )
    self:upVirtualServerTime( dt )
end

function M.resetServerTime( self, server_time )
    -- assert( server_time ~= nil, " server_time must not nil" )
    if server_time == nil then
        return 
    end
    self.m_virtual_server_time = server_time
end

function M.upVirtualServerTime( self, dt )
    if self.m_virtual_server_time == nil then
        return 
    end
    local s = CCDirector:sharedDirector():getScheduler()
    local timeScale = 1
    if s then
        timeScale = s:getTimeScale()
    end
    self.m_virtual_server_time = self.m_virtual_server_time + dt / timeScale
end

function M.getVirtualServerTime( self )
    return self.m_virtual_server_time
end

function M.setLastRequestTime(self)
    self.m_last_request_time = os.time();
end

function M.getLastRequestTime(self)
    return self.m_last_request_time;
end

--[[--
   通过json数据设置避难所数据
]]
function M.setHarborDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tHarborData = json.decode(jsonData:getFormatBuffer()) or {};
    self.m_tHarborData.dataTime = os.time();
    cclog("setHarborDataByJsonData ================ ");
    self:setLeaderSkillDataByJsonData(jsonData:getNodeWithKey("leader_skill"))
    self:setAvailableSkillTreeDataByJsonData(jsonData:getNodeWithKey("available_tree"))
    self:setAvailableSkillDataByJsonData(jsonData:getNodeWithKey("available_skill"))
end

--[[--
   获得避难所数据
]]
function M.getHarborData(self)
    return self.m_tHarborData;
end

--[[--
   通过json数据设置避难所数据
]]
function M.setLaboratoryDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tLaboratoryData = json.decode(jsonData:getFormatBuffer()) or {};
    self.m_tLaboratoryData.dataTime = os.time();
    cclog("setLaboratoryDataByJsonData ================ ");
end

--[[--
   获得避难所数据
]]
function M.getLaboratoryData(self)
    return self.m_tLaboratoryData;
end

--[[--
   通过json数据设置避难所数据
]]
function M.setSchoolDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tSchoolData = json.decode(jsonData:getFormatBuffer()) or {};
    self.m_tSchoolData.dataTime = os.time();
    cclog("setSchoolDataByJsonData ================ ");
end

--[[--
   获得避难所数据
]]
function M.getSchoolData(self)
    return self.m_tSchoolData;
end

--[[--
   通过json数据设置避难所数据
]]
function M.setFactoryDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tFactoryData = json.decode(jsonData:getFormatBuffer()) or {};
    self.m_tFactoryData.dataTime = os.time();
    cclog("setFactoryDataByJsonData ================ ");
end

--[[--
   获得避难所数据
]]
function M.getFactoryData(self)
    return self.m_tFactoryData;
end

--[[--
   设置选择的城市id
]]
function M.setSelCityId(self,cityId)
    self.m_selCityId = cityId;
end

--[[--
   获得选择的城市id
]]
function M.getSelCityId(self)
    -- print_lua_table(self, 5)
    return self.m_selCityId;
end

--[[--
   设置选择的城市id
]]
function M.setSelBuildingId(self,cityId)
    self.m_selBuildingId = cityId;
end

--[[--
   获得选择的城市id
]]
function M.getSelBuildingId(self)
    return self.m_selBuildingId;
end

--[[--
   获得时间差
]]
function M.getTimeDifference(self,time)
    time = time or self:getLastRequestTime();
    return os.time() - time;
end

--[[--
   通过json数据设置Gacha数据
]]
function M.setGachaDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tGachaData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setGachaDataByJsonData ================ ");
end

--[[--
   获得Gacha数据
]]
function M.getGachaData(self)
    return self.m_tGachaData;
end


--[[--
   设置战斗类型
]]
function M.setBattleType(self,battleType,battleparams)
    self.m_battleType = battleType;
    self.m_battleparams = battleparams
end

--[[--
   获得战斗类型
]]
function M.getBattleType(self)
    return self.m_battleType , self.m_battleparams
end

--[[--
    设置地图类型
    "normal", 普通关卡
    "hard", 精英团契啊
    nil, 重置之后
]]
function M.setMapType( self, type )
    self.m_mapType = type
end

--[[--
    获取地图类型
]]
function M.getMapType( self )
    return self.m_mapType
end



--[[--
   设置选择的中立城市
]]
function M.setSelNeutralCityId(self,selNeutralCityId)
    self.m_selNeutralCityId = selNeutralCityId;
end

--[[--
   获得选择的中立城市
]]
function M.getSelNeutralCityId(self)
    return self.m_selNeutralCityId;
end

--[[--
   设置选择的中立城市的建筑
]]
function M.setSelNeutralBuildingId(self,selNeutralBuildingId)
    self.m_selNeutralBuildingId = selNeutralBuildingId;
end

--[[--
   获得选择的中立城市的建筑
]]
function M.getSelNeutralBuildingId(self)
    return self.m_selNeutralBuildingId;
end

--[[--
   通过json数据设置选择的公会数据
]]
function M.setSelGuildDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_selGuildData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setSelGuildDataByJsonData ================ ");
end

--[[--
   获得选择的公会数据
]]
function M.getSelGuildData(self)
    return self.m_selGuildData;
end

--[[--
   通过json数据设置选择的公会列表数据
]]
function M.setGuildListDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_guildListData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setGuildListDataByJsonData ================ ");
end

--[[--
   获得选择的公会列表数据
]]
function M.getGuildListData(self)
    return self.m_guildListData;
end

--[[--
   通过json数据设置每日奖励数据
]]
function M.setDailyAwardDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_dailyAwardData.data = json.decode(jsonData:getFormatBuffer()) or {};
    self.m_dailyAwardData.init = true
    cclog("setDailyAwardDataByJsonData ================ ");
end

--[[--
   获得每日奖励数据
]]
function M.getDailyAwardData(self)
    return self.m_dailyAwardData.data;
end

--[[--
   获得每日奖励init
]]
function M.getDailyAwardDataInit(self)
    return self.m_dailyAwardData.init;
end

--[[--
   缓存更新
]]
function M.clientCacheUpdate(self,jsonData)
    if jsonData == nil then return end
    local tempCards = jsonData:getNodeWithKey("cards");
    if tempCards then
        local cards = tempCards:getNodeWithKey("cards");
        if cards then
            local cardsUpdate = cards:getNodeWithKey("update");
            local cardsRemove = cards:getNodeWithKey("remove");
            if cardsRemove:getNodeCount() ~= 0 then
                self:removeMoreCardDataByIdTable(json.decode(cardsRemove:getFormatBuffer()));
            end
            self:updateMoreCardDataByJsonData(cardsUpdate);
            if tempCards:getNodeWithKey("open_position") then
                cclog("----------client cache update open_position");
                local updateData = tempCards:getNodeWithKey("open_position"):getNodeWithKey("update");
                self:setOpenPositionDataByJsonData(updateData);
            end
            if tempCards:getNodeWithKey("formation") then
                cclog("----------client cache update formation");
                local updateData = tempCards:getNodeWithKey("formation"):getNodeWithKey("update");
                self:updateOwnFormationDataByJsonData(updateData);
            end
        end
        if tempCards:getNodeWithKey("skin") then
            cclog("----------client cache update  skin");
            local updateData = tempCards:getNodeWithKey("skin"):getNodeWithKey("update");
            self:updateCardSkinData(updateData);
        end
        if tempCards:getNodeWithKey("used_skin") then
            cclog("----------client cache update used_skin");
            local updateData = tempCards:getNodeWithKey("used_skin"):getNodeWithKey("update");
            self:setCurCardSkinData(updateData);
        end

        local position_num = tempCards:getNodeWithKey("position_num");
        if position_num then
            self.m_tBattleCardNum.position_num = position_num:getNodeWithKey("update"):toInt();
        end
        local alternate_num = tempCards:getNodeWithKey("alternate_num");
        if alternate_num then
            self.m_tBattleCardNum.alternate_num = alternate_num:getNodeWithKey("update"):toInt();
        end
        local assistant = tempCards:getNodeWithKey("assistant");
        if assistant then
            self:setAssistantByJsonData(assistant:getNodeWithKey("update"));
        end
        local destiny = tempCards:getNodeWithKey("destiny");
        if destiny then
            self:setDestinyByJsonData(destiny:getNodeWithKey("update"));
        end
        local assistant_effect = tempCards:getNodeWithKey("assistant_effect");
        if assistant_effect then
            self:setAssistantEffectByJsonData(assistant_effect:getNodeWithKey("update"));
        end
        local temp_famous_detail = tempCards:getNodeWithKey("famous_detail");
        if temp_famous_detail then
            local famous_detail_update = temp_famous_detail:getNodeWithKey("update")
            self:updateFamousDetailByData(json.decode(famous_detail_update:getFormatBuffer()))
        end
        if temp_famous_all then
            local famous_all_update = temp_famous_all:getNodeWithKey("update")
            local famous_all_remove = temp_famous_all:getNodeWithKey("remove")
            self:addFamousAllDataByData(json.decode(famous_all_update:getFormatBuffer()))
            self:removeFamousAllByTab(json.decode(famous_all_remove:getFormatBuffer()))
        end

        local temp_famous_attrs = tempCards:getNodeWithKey("famous_attrs");
        if temp_famous_attrs then
            self:setFamousAttrsByJsonData(temp_famous_attrs:getNodeWithKey("update"))
            self:resetFamousAttrsByJsonData(temp_famous_attrs:getNodeWithKey("remove"))
        end


    end
    local wormholes = jsonData:getNodeWithKey("wormholes")
    if wormholes then
        local wormholes_field = wormholes:getNodeWithKey("wormholes_field")
        if wormholes_field then
            local removeData = wormholes_field:getNodeWithKey("remove")
            if removeData and json.decode(removeData:getFormatBuffer()) then
                for k, v in pairs(json.decode(removeData:getFormatBuffer())) do
                    self.m_wormholes_field[k] = nil
                end
            end
            local updateData = wormholes_field:getNodeWithKey("update")
            if updateData and json.decode(updateData:getFormatBuffer()) then
                for k, v in pairs(json.decode(updateData:getFormatBuffer())) do
                    self.m_wormholes_field[k] = v
                end
            end
        end
    end
    --pets
    local tempPets = jsonData:getNodeWithKey("pets");
    if tempPets then
        local pets = tempPets:getNodeWithKey("pets");
        if pets then
            local petsUpdate = pets:getNodeWithKey("update");
            local petsRemove = pets:getNodeWithKey("remove");
            self:updateMorePetDataByJsonData(petsUpdate);
            if petsRemove:getNodeCount() ~= 0 then
                self:removeMorePetDataByIdTable(json.decode(petsRemove:getFormatBuffer()));
            end
        end
        local pet_pos = tempPets:getNodeWithKey("pet_pos")
        if pet_pos then
            self:setPetTeamByJsonData(pet_pos:getNodeWithKey("update"));
        end
        local pet_follow_pos = tempPets:getNodeWithKey("pet_follow_pos")
        if pet_follow_pos then
            self:setPetFollowPos(pet_follow_pos:getNodeWithKey("update"))
        end
    end
    if jsonData:getNodeWithKey("equip") then
        local equips = jsonData:getNodeWithKey("equip"):getNodeWithKey("_equip")
        if equips then
            local updateData = equips:getNodeWithKey("update")
            local removeData = equips:getNodeWithKey("remove")
            self:updateMoreEquipDataByJsonData(updateData)
            if removeData:getNodeCount() > 0 then
                self:removeMoreEquipDataByIdTable(json.decode(removeData:getFormatBuffer()));
            end
        end
    end
    -- 徽章
    if jsonData:getNodeWithKey("badge") then
        local badges = jsonData:getNodeWithKey("badge"):getNodeWithKey("_badges")
        if badges then
            local updateData = badges:getNodeWithKey("update")
            local removeData = badges:getNodeWithKey("remove")
            self:updateMoreBadgeDataByJsonData(updateData)
            if removeData:getNodeCount() > 0 then
                self:removeMoreBadgeDataByIdTable(json.decode(removeData:getFormatBuffer()));
            end
        end
    end

    if jsonData:getNodeWithKey("gem") then
        local equips = jsonData:getNodeWithKey("gem"):getNodeWithKey("_gem")
        if equips then
            local updateData = equips:getNodeWithKey("update")
            local removeData = equips:getNodeWithKey("remove")
            self:updateMoreGemDataByJsonData(updateData)
            if removeData:getNodeCount() > 0 then
                self:removeMoreGemDataByIdTable(json.decode(removeData:getFormatBuffer()));
            end
        end
    end
--todo 圣石
      if jsonData:getNodeWithKey("god_stone") then
        local equips = jsonData:getNodeWithKey("god_stone"):getNodeWithKey("_god_stone")
        if equips then
            local updateData = equips:getNodeWithKey("update")
            local removeData = equips:getNodeWithKey("remove")
            self:updateMoreSaintStoneDataByJsonData(updateData)
            if removeData:getNodeCount() > 0 then
                self:removeMoreSaintStoneDataByIdTable(json.decode(removeData:getFormatBuffer()));
            end
        end
    end

    if jsonData:getNodeWithKey("item")then
        cclog("----------client cache update item");
        local items = jsonData:getNodeWithKey("item"):getNodeWithKey("items");
        if items then
            local updateData = items:getNodeWithKey("update");
            local removeData = items:getNodeWithKey("remove");
            self:updateMoreItemDataByJsonData(updateData);
            if removeData:getNodeCount()>0 then
                self:removeMoreItemDataById(removeData);
            end
        end
    end

    cclog("clientCacheUpdate ================ ");
    --英魂
    local tempSoul =jsonData:getNodeWithKey("soul")
    if tempSoul then
        local _soul = tempSoul:getNodeWithKey("_souls");
        if _soul then
            local soulUpdate = _soul:getNodeWithKey("update");
            local soulRemove = _soul:getNodeWithKey("remove");
            self:updateMoreSoulDataByJsonData(soulUpdate);
            if soulRemove:getNodeCount() ~= 0 then
                self:removeMoreSoulDataByIdTable(json.decode(soulRemove:getFormatBuffer()));
            end
        end
    end
    --勋章东西
    local tempMedal = jsonData:getNodeWithKey("medal")
    if tempMedal then
        local _medal = tempMedal:getNodeWithKey("_medal");
        if _medal then
            local medalUpdate = _medal:getNodeWithKey("update");
            local medalRemove = _medal:getNodeWithKey("remove");
            self:updateMoreMedalDataByJsonData(medalUpdate);
            if medalRemove:getNodeCount() ~= 0 then
                self:removeMoreMedalDataByIdTable(json.decode(medalRemove:getFormatBuffer()));
            end
        end
    end
    --神域宝石
    if jsonData:getNodeWithKey("gem") then
        local godGem = jsonData:getNodeWithKey("gem"):getNodeWithKey("god_field_gem")
        if godGem then
            local GodGemUpdata = godGem:getNodeWithKey("update")
            local GodGemremoveData = godGem:getNodeWithKey("remove")
            self:updateMoreGodGemDataByJsonData(GodGemUpdata)
            if GodGemremoveData:getNodeCount() > 0 then
                self:removeMoreGodGemDataByIdTable(json.decode(GodGemremoveData:getFormatBuffer()));
            end
        end
    end
    --神域勋章
    local tempGodMedal = jsonData:getNodeWithKey("medal")
    if tempGodMedal then
        local _medal = tempGodMedal:getNodeWithKey("god_field_medal");
        if _medal then
            local medalGodUpdate = _medal:getNodeWithKey("update");
            local medalGodRemove = _medal:getNodeWithKey("remove");
            self:updateMoreGodMedalDataByJsonData(medalGodUpdate);
            if medalGodRemove:getNodeCount() ~= 0 then
                self:removeMoreGodMedalDataByIdTable(json.decode(medalGodRemove:getFormatBuffer()));
            end
        end
    end

    local tempTalisman = jsonData:getNodeWithKey("talisman")
    if tempTalisman then
        local _talisman = tempTalisman:getNodeWithKey("_talisman")
        local talismanUpdate = _talisman:getNodeWithKey("update")
        local talismanRemove = _talisman:getNodeWithKey("remove")
        self:updateMoreMagicDataByJsonData(talismanUpdate)
        if talismanRemove:getNodeCount() ~= 0 then
            self:removeMoreMagicDataByIdTable(json.decode(talismanRemove:getFormatBuffer()))
        end
    end
    local gem_fate = jsonData:getNodeWithKey("gem_fate")
    if gem_fate then
        local _gem_fate = gem_fate:getNodeWithKey("_gem_fate")
        if _gem_fate then
            local gem_fateUpdate = json.decode(_gem_fate:getNodeWithKey("update"):getFormatBuffer())
            local gem_fateRemove = json.decode(_gem_fate:getNodeWithKey("remove"):getFormatBuffer())
            self:updateFateGemDataByCid(gem_fateUpdate,gem_fateRemove)
        end

        local fate_word = gem_fate:getNodeWithKey("_fate_word")
        if fate_word then
            local update = json.decode(fate_word:getNodeWithKey("update"):getFormatBuffer())
            local remove = json.decode(fate_word:getNodeWithKey("remove"):getFormatBuffer())
            local _tb = self.m_formationBloodStoneData.fate_word
            if update then
                for k,v in pairs(update) do
                    _tb[k] = v
                end
            end
            if remove then
                for k,v in pairs(remove) do
                    if _tb[tostring(v)] then
                        _tb[tostring(v)] = nil
                        table.remove(_tb,k)
                     end 
                end
            end
        end

        local gem_special = gem_fate:getNodeWithKey("_gem_special")
        if gem_special then
            local update = json.decode(gem_special:getNodeWithKey("update"):getFormatBuffer())
            local remove = json.decode(gem_special:getNodeWithKey("remove"):getFormatBuffer())
            local _tb = self.m_formationBloodStoneData.gem_special
            if update then
                for k,v in pairs(update) do
                    _tb[k] = v
                end
            end
            if remove then
                for k,v in pairs(remove) do
                    if _tb[tostring(v)] then
                        _tb[tostring(v)] = nil
                        table.remove(_tb,k)
                     end 
                end
            end
        end

        local fate_stone = gem_fate:getNodeWithKey("_fate_stone")
        if fate_stone then
            local update = json.decode(fate_stone:getNodeWithKey("update"):getFormatBuffer())
            local remove = json.decode(fate_stone:getNodeWithKey("remove"):getFormatBuffer())
            local _tb = self.m_formationBloodStoneData.fate_stone
            if update then
                for k,v in pairs(update) do
                    _tb[k] = v
                end
            end
            if remove then
                for k,v in pairs(remove) do
                    if _tb[tostring(v)] then
                        _tb[tostring(v)] = nil
                        table.remove(_tb,k)
                     end 
                end
            end
        end

        local word_round = gem_fate:getNodeWithKey("word_round")
        if word_round then
            local update = json.decode(word_round:getNodeWithKey("update"):getFormatBuffer())
            local remove = json.decode(word_round:getNodeWithKey("remove"):getFormatBuffer())
            local _tb = self.m_formationBloodStoneData.word_round
            if update then
                for k,v in pairs(update) do
                    _tb[k] = v
                end
            end
            if remove then
                for k,v in pairs(remove) do
                    if _tb[tostring(v)] then
                        _tb[tostring(v)] = nil
                        table.remove(_tb,k)
                     end 
                end
            end
        end
    end

    -- 超级仓库
    local storeHouse = jsonData:getNodeWithKey("storehouse")
    if storeHouse then
        -- cards
        if not self.m_storeHouseData.cards then
            self.m_storeHouseData.cards = {}
        end
        local cards = storeHouse:getNodeWithKey("cards")
        if cards then
            local update = cards:getNodeWithKey("update")
            local remove = cards:getNodeWithKey("remove")
            local _isDirty = false
            if update:getNodeCount() ~= 0 then
                local _data = json.decode(update:getFormatBuffer())
                for k,v in pairs(_data) do
                    self.m_storeHouseData.cards[k] = v
                end
                _isDirty = true
            end
            if remove:getNodeCount() ~= 0 then
                local _data = json.decode(remove:getFormatBuffer())
                for k,v in pairs(_data) do
                    self.m_storeHouseData.cards[v] = nil
                end
                _isDirty = true
            end
            if  _isDirty then
                self:cardsSortByTypeNameWithTable2(self.m_cardSortType, self.m_storeHouseData.cards)
                self:cardsSortByTypeNameWithTable3(self.m_cardSortType,self.m_cardSortType2, self.m_storeHouseData.cards)
                self:cardsSortByTypeNameWithTable(self.m_cardSortType,self.m_storeHouseData.cards);
            end
        end

        -- items
        if not self.m_storeHouseData.items then
            self.m_storeHouseData.items = {}
        end
        local items = storeHouse:getNodeWithKey("items")
        if items then
            local update = items:getNodeWithKey("update")
            local remove = items:getNodeWithKey("remove")
            if update:getNodeCount() ~= 0 then
                local _data = json.decode(update:getFormatBuffer())
                for k,v in pairs(_data) do
                    self.m_storeHouseData.items[k] = v
                end
            end
            if remove:getNodeCount() ~= 0 then
                local _data = json.decode(remove:getFormatBuffer())
                for k,v in pairs(_data) do
                    self.m_storeHouseData.items[tostring(v)] = nil
                end
            end
        end

        -- 法宝
        local talismans = storeHouse:getNodeWithKey("talismans")
        if talismans then
            local update = talismans:getNodeWithKey("update")
            local remove = talismans:getNodeWithKey("remove")
            if update:getNodeCount() ~= 0 then
                local _data = json.decode(update:getFormatBuffer())
                for k,v in pairs(_data) do
                    self.m_storeHouseData.talismans[k] = v
                end
            end
            if remove:getNodeCount() ~= 0 then
                local _data = json.decode(remove:getFormatBuffer())
                for k,v in pairs(_data) do
                    self.m_storeHouseData.talismans[v] = nil
                end
            end
        end

        -- 装备
        local equips = storeHouse:getNodeWithKey("equips")
        if equips then
            local update = equips:getNodeWithKey("update")
            local remove = equips:getNodeWithKey("remove")
            if update:getNodeCount() ~= 0 then
                local _data = json.decode(update:getFormatBuffer())
                for k,v in pairs(_data) do
                    self.m_storeHouseData.equips[k] = v
                end
            end
            if remove:getNodeCount() ~= 0 then
                local _data = json.decode(remove:getFormatBuffer())
                for k,v in pairs(_data) do
                    self.m_storeHouseData.equips[v] = nil
                end
            end
        end
        
        -- 背包上限额外
        local extends = storeHouse:getNodeWithKey("extends")
        if extends then
            local update = extends:getNodeWithKey("update")
            if update:getNodeCount() ~= 0 then
                local _data = json.decode(update:getFormatBuffer())
                for k,v in pairs(_data) do
                    self.m_storeHouseData.extends[k] = v
                end
            end
        end
    end
end
--[[--
    接口返回的数据
]]
function M.responseGameData(self,gameData)
    self:setLastRequestTime();
    local data = gameData:getNodeWithKey("data")
    self:updateInreviewByJsonData(data:getNodeWithKey("inreview"))
    self:updateServerInreviewByJsonData(data:getNodeWithKey("server_inreview_close"))
    self:updateActiveInreviewByJsonData(data:getNodeWithKey("active_switch"))
    self:setUserStatusDataByJsonData(gameData:getNodeWithKey("user_status"));
    self:clientCacheUpdate(data:getNodeWithKey("_client_cache_update"));


end
--[[--
    获取卡牌的装备数据
]]
function M.getEquipDataByCardId(self,cardId)
    local equipData = {"0","0","0","0"};
    for k,v in pairs(self.m_tTeamData) do
        if tostring(v) == tostring(cardId) then
            local equipPosIndex = k - 1;
            local equipPosData = self.m_tEquipPosData[tostring(equipPosIndex)];
            if equipPosData then
                for i=1,4 do
                    local eId = equipPosData[i];
                    if eId and eId ~= "0" then
                        equipData[i] = self.m_tEquipData[tostring(eId)];
                    end
                end
            end
            break;
        end
    end
    return equipData;
end

--[[--
   通过json数据设置道具数据
]]
function M.setItemsDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_itemsData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setItemsDataByJsonData ================ ");
end

--[[--
    更新单个道具消息
]]

function M.updateOneItemDataByJsonData( self,jsonData )
    -- body
    if jsonData==nil then return end
    
    -- local itemData = json.decode(cardJsonData:getFormatBuffer());
    -- if self.m_tCardsData[tostring(cardData.id)] == nil then
    --     self.m_tCardsIdTable[#self.m_tCardsIdTable + 1] = tostring(cardData.id);
    -- end
    -- self.m_tCardsData[tostring(cardData.id)] = cardData;
    local itemKey = jsonData:getKey();
    local itemValue = {};
    local nodeCount = jsonData:getNodeCount();
    for i=1,nodeCount do
        itemValue[i] = jsonData:getNodeAt(i-1):toInt();
    end
    -- if self.m_itemsData[itemKey] == nil and (tonumber(itemKey) < 1000 or tonumber(itemKey) >= 3000) then
    --     self.m_newItemIdTab[itemKey] = 1;
    --     self.m_newItemIdTab.count = self.m_newItemIdTab.count + 1;
    -- end
    self.m_itemsData[itemKey]=itemValue;
end

--[[--
    更新多个道具消息
]]
function M.updateMoreItemDataByJsonData( self,jsonData )
    -- body
    if(jsonData == nil)then return end
    local nodeCount = jsonData:getNodeCount();
    -- cclog("1 = " .. json.encode(self.m_itemsData))
    for i=1,nodeCount do
        self:updateOneItemDataByJsonData(jsonData:getNodeAt(i-1));
    end
    -- cclog("2 = " .. json.encode(self.m_itemsData))
end

--[[--
    移出单个道具
]]
function M.removeMoreItemDataById( self,jsonData )
    -- body
    if(jsonData == nil)then return end
    local nodeCount = jsonData:getNodeCount();
    for i=1,nodeCount do
        self.m_itemsData[jsonData:getNodeAt(i-1):toStr()] = nil;
    end
end

--[[--
   获得道具数据
]]
function M.getItemsData(self)
    return self.m_itemsData;
end
--[[--
    获得道具数量
]]
function M.getItemsCount( self )
    -- body
    -- util.printf(self.m_itemsData);
    local i = 0;
    for k,v in pairs(self.m_itemsData) do
        i=i + (#v);
    end
    cclog(" --------- getItemsCount -----------" .. i)
    return i;
    -- return #self.m_itemsData;
end

--[[--
    获得制定道具数量
]]
function M.getItemCountByCid( self ,cId)
    local tempData = self.m_itemsData[tostring(cId)] or {}
    local count = 0;
    for k,v in pairs(tempData) do
        if type(v) == "table" then
            count=count + (#v);
        else
            count=count + v;
        end
    end
    if count > 0 then
        cclog(" --------- getItemCountByCid -----------" .. count .. " ; cId = " .. cId)
    end
    return count;
end

function M.getItemIdAndCountAt( self,index )
    -- body
    
    local i=0;
    -- cclog("---------------------item index----------" .. tostring(index) .. "i:" .. tostring(i));
    local cid,count = 0,0;
    for k,v in pairs(self.m_itemsData) do
        for j,u in pairs(v) do
            i=i+1;
            if(i>=index)then
                cid=k;
                count=u;
                return cid,count;
            end
        end
    end
    return cid,count;
end

--[[--
   游戏进入后台
]]
function M.didEnterBackground(self)
    self.m_enterBackgroundTime = os.time();
end

--[[--
   游戏从后台唤醒
]]
function M.willEnterForeground(self)
    if self.m_tUserStatusData.action_point == nil then return end
    local diffTime = os.time() - self.m_enterBackgroundTime;
    local action_point = self.m_tUserStatusData.action_point;
    self.m_tUserStatusData.action_point = math.min(self.m_tUserStatusData.action_point_max,action_point + math.floor(diffTime/self.m_action_point_add_time))
    cclog("action_point ===" .. action_point .. " ; self.m_tUserStatusData.action_point =====" .. self.m_tUserStatusData.action_point)
end

--[[--
    通过json数据设置位置数据
]]
function M.setOpenPositionDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_openPositionData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setOpenPositionDataByJsonData ================ ");
end

--[[--
   获得位置数据
]]
function M.getOpenPositionData(self)
    return self.m_openPositionData;
end

--[[--
   获得位置数据
]]
function M.getOpenPositionFlagByIndex(self,index)
    local flag = false;
    if self.m_openPositionData and type(self.m_openPositionData) == "table" then
        for k,v in pairs(self.m_openPositionData) do
            if tostring(v) == tostring(index) then
                flag = true;
            end
        end
    end
    return flag;
end

--[[--
   通过json数据设置主角技能数据
]]
function M.setLeaderSkillDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_leaderSkillData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setLeaderSkillDataByJsonData ================ ");
end

--[[--
   获得主角技能
]]
function M.getLeaderSkillData(self)
    return self.m_leaderSkillData or {};
end

--[[--
   通过json数据设置主角技能树数据
]]
function M.setAvailableSkillTreeDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_availableSkillTreeData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setAvailableSkillTreeDataByJsonData ================ ");
end

--[[--
   获得技能树数据
]]
function M.getAvailableSkillTreeData(self)
    return self.m_availableSkillTreeData or {};
end
     
--[[--
   通过json数据设置主角开启的技能数据
]]
function M.setAvailableSkillDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_availableSkill = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setAvailableSkillDataByJsonData ================ ");
end

--[[--
   获得主角开启的技能
]]
function M.getAvailableSkillData(self)
    return self.m_availableSkill or {};
end

--[[--
   设置再次探险标记
]]
function M.setReMapBattleFlag(self,flag)
    self.m_reMapBattleFlag = flag;
    cclog("setReMapBattleFlag ================ ");
end
--[[
    
]]
function M.setRecoverFlag( self,flag )
    self.RecoverFlag = flag
end
function M.getRecoverFlag( self)
    return self.RecoverFlag
end
--[[--
   获得再次探险标记
]]
function M.getReMapBattleFlag(self)
    return self.m_reMapBattleFlag;
end

--[[--
   通过json数据设置服务器数据
]]
function M.setServerDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    if game_util.statisticsSendUserStep then game_util:statisticsSendUserStep(3) end -- 获取到服务列表数据
    self.m_serverData = json.decode(jsonData:getFormatBuffer()) or {};
    local function sortFunc(data1,data2)
        return data1.sort_id > data2.sort_id
    end
    table.sort(self.m_serverData,sortFunc)
    cclog("setServerDataByJsonData ================ ");
end

--[[--
   获得服务器数据
]]
function M.getServerData(self)
    return self.m_serverData or {};
end

--[[
    获取开服时间戳
]]
function M.getServerOpenTime( self )
    local serData = self:getServer() or {}
    return serData.open_time 
end

--[[--
   通过json数据设置服务器id
]]
function M.setServerId(self,serverId)
    self.m_selServerId = serverId;
    CCUserDefault:sharedUserDefault():setStringForKey("server_id",self.m_selServerId);
    CCUserDefault:sharedUserDefault():flush();
    cclog("setServerId ==================" .. serverId)
end

--[[--
   通过json数据获得选择的服务器id
]]
function M.getServerId(self)
    local serverId = CCUserDefault:sharedUserDefault():getStringForKey("server_id")
    serverId = serverId ~= "" and serverId or self.m_selServerId;
    return serverId;
end

--[[--
   获得服务器数据
]]
function M.getServer(self)
    if self.m_selServerId == nil or self.m_selServerId == "" then
        self.m_selServerId = CCUserDefault:sharedUserDefault():getStringForKey("server_id");
    end
    local selServerData = nil;
    local index = 1;
    for k,v in pairs(self.m_serverData) do
        if tostring(v.server) == tostring(self.m_selServerId) then
            selServerData = v;
            index = k;
            break;
        end
    end
    if selServerData == nil and self.m_serverData[index] then
        selServerData = self.m_serverData[index];
        self.m_selServerId = self.m_serverData[index].server;
        self:setServerId(self.m_selServerId);
    end
    -- cclog("getServer ==================" .. tostring(self.m_selServerId) .. " ; selServerData = " .. tostring(selServerData))
    -- cclog("selServerData == " .. json.encode(selServerData))
    -- selServerData.open_time = 1402156800 - 2 * 24 * 3600  - 10 * 3600
    return selServerData,index;
end

--[[--
    获取 opeing 天数
]]
function M.getOpeningDayNum( self )
    -- return 2
    return self.opening_award_expire 
end

--[[--
    通过key获得用户基础数据
]]
function M.getUserStatusDataByKey(self,key)
    -- if key == "server_time" then
    --     return 140215680 + 1 * 24 * 3600 + 1
    -- end
    return self.m_tUserStatusData[key];
end

function M.printUserStatusData( self )
    if type(cclog3) == "function" then
        cclog3( self.m_tUserStatusData )
    end
end

--[[--
   设置公告数据
]]
function M.setNoticesDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tNoticesData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setNoticesDataByJsonData ================ ");
end

--[[--
   获得公告数据
]]
function M.getNoticesData(self)
    return self.m_tNoticesData;
end

--[[--
    设置小伙伴数据
]]
function M.setAssistantByJsonData( self,jsonData )
    -- body
    if jsonData==nil then
        return;
    end
    self.m_tAssistant = json.decode(jsonData:getFormatBuffer());
end

--[[--
    获取小伙伴数据
]]
function M.getAssistant( self )
    -- body
    return self.m_tAssistant or {};
end

--[[--
    设置小伙伴数据
]]
function M.setAssistantEffectByJsonData( self,jsonData )
    -- body
    if jsonData == nil then return end
    self.m_tAssistantEffect = json.decode(jsonData:getFormatBuffer());
end

--[[--
    获取小伙伴数据
]]
function M.getAssistantEffect( self )
    -- body
    return self.m_tAssistantEffect or {};
end

--[[--
    设置命运小伙伴数据
]]
function M.setDestinyByJsonData( self,jsonData )
    -- body
    if jsonData == nil then return end
    self.m_tDestiny = json.decode(jsonData:getFormatBuffer());
end

--[[--
    获取命运小伙伴数据
]]
function M.getDestiny( self )
    -- body
    return self.m_tDestiny or {};
end

--[[
    设置运营活动开启接口 -- 限时神将， 限时积分
]]
function M.setActiveOpenData(self,jsonData)
    cclog("setActiveOpenData --------------- ")
    if jsonData == nil then return end
    self.openTable = json.decode(jsonData:getFormatBuffer()) or {};
end
function M.getActiveOpenData( self )
    return self.openTable or {}
end


--[[--
   更新MainPage接口数据
]]
function M.updateMainPageByJsonData(self,jsonData)
    if jsonData == nil then return end
    self:updateInreviewByJsonData(jsonData:getNodeWithKey("inreview"))
    self:updateServerInreviewByJsonData(jsonData:getNodeWithKey("server_inreview_close"))
    self:setActiveOpenData(jsonData:getNodeWithKey("actives"))
    self:setBuildingAbilityDataByJsonData(jsonData:getNodeWithKey("building_ability"))
    self:setPrivateBuildingDataByJsonData(jsonData:getNodeWithKey("private_building"))
    self:setResourceDataByJsonData(jsonData:getNodeWithKey("resource"))
    self:setNoticesDataByJsonData(jsonData:getNodeWithKey("notices"))
    self:setAlertsDataByJsonData(jsonData:getNodeWithKey("alerts"));
    self.m_arenaRank = jsonData:getNodeWithKey("arena_rank"):toInt();
    self.m_arenaPoint = jsonData:getNodeWithKey("arena_point"):toInt();
    self:setIsNewVersion(jsonData);

    self:updateTitleDataByJsonData(jsonData:getNodeWithKey("all_title"))
    local foundation_status = jsonData:getNodeWithKey("foundation_status")
    if foundation_status then
        self.foundation_status = foundation_status:toBool();
    end
    local server_foundation_status = jsonData:getNodeWithKey("server_foundation_status")
    if server_foundation_status then
        self.server_foundation_status = server_foundation_status:toBool();
    end

    local month_foundation_status = jsonData:getNodeWithKey("month_foundation_status")
    if month_foundation_status then
        self.month_foundation_status = month_foundation_status:toBool();
    end
    if jsonData:getNodeWithKey("online_award_expire") then
        self.m_online_award_expire = jsonData:getNodeWithKey("online_award_expire"):toInt();--在线领奖时间
    end
    if jsonData:getNodeWithKey("onlinw_awawrd_id") then
        self.m_onlinw_awawrd_id = jsonData:getNodeWithKey("onlinw_awawrd_id"):toInt();--第几次领取
    end
    self.buy_ap_times = jsonData:getNodeWithKey("buy_ap_times"):toInt();--第几次购买体力
    local tempShop = jsonData:getNodeWithKey("shop")
    if tempShop then
        self.shopData = json.decode(tempShop:getFormatBuffer()) or {};
    end
    -- if jsonData:getNodeWithKey("opening_award_expire") then
    --     self.opening_award_expire = jsonData:getNodeWithKey("opening_award_expire"):toInt() or 14
    -- end
    if jsonData:getNodeWithKey("opening_award_expire") then 
        self.opening_award_expire = jsonData:getNodeWithKey("opening_award_expire"):toInt() or 14
    end 
    if jsonData:getNodeWithKey("combat") then
        local temp = jsonData:getNodeWithKey("combat")
        self:setNewCombat(tonumber(temp:toStr()))
    end
    -- cclog("jsonData == " .. jsonData:getFormatBuffer())
    -- self.is_double = jsonData:getNodeWithKey("is_double")
    local alerts = jsonData:getNodeWithKey("alerts")
    self.is_double = alerts:getNodeWithKey("is_double")

    self.timezone = jsonData:getNodeWithKey("timezone"):toInt();
end

--[[--
    更新inreview数据
]]
function M.updateInreviewByJsonData(self,jsonData)
    if not ( jsonData and jsonData:getFormatBuffer() ) then return end
    -- print("   updateInreviewByJsonData  info ", jsonData:getFormatBuffer())
    local info = json.decode(jsonData:getFormatBuffer()) or {}
    -- print_lua_table( info or {}, 8)
    self.m_curInReviewButton = nil
    self.m_curInReviewButton = {}
    for i,v in ipairs(info) do
        -- print("updateInreviewByJsonData ==== ", i,v)
        if v ~= nil then
            self.m_curInReviewButton["in_review_" .. tostring(v)] = "close"
        end
    end
    -- self.is_double = jsonData:getNodeWithKey("is_double")

    -- self.m_curInReviewButton["37"] = "close"  -- 测试
    -- self.m_curInReviewButton["41"] = "close"
    -- self.m_curInReviewButton["36"] = "close"
    -- self.m_curInReviewButton["38"] = "close"
end

--[[--
    更新server_inreview数据
]]
function M.updateServerInreviewByJsonData(self, jsonData)

    if not ( jsonData and jsonData:getFormatBuffer() ) then return end
    local info = json.decode(jsonData:getFormatBuffer()) or {}
    for i,v in pairs(info) do
        if v ~= nil then
            self.m_curInReviewButton["in_review_" .. tostring(v)] = "close"
        end
    end

end

--[[--
    检查按钮是否开启    
]]
--[[--
    检查按钮是否开启    
]]
function M.isViewOpenByID( self, viewID )
    -- print("will check is view open ", viewID, "value is ", self.m_curInReviewButton[tostring(viewID)])
    if self.m_curInReviewButton["in_review_" .. tostring(viewID)] == "close" then
        return false
    end
    -- 先查找inview表 default 决定默认显示  show_lv 决定是显示需要等级
    local inreview_cfg = getConfig(game_config_field.inreview)
    local btnInfo = inreview_cfg:getNodeWithKey( tostring(viewID) )

    if btnInfo then
        -- local default = btnInfo:getNodeWithKey("default") and btnInfo:getNodeWithKey("default"):toInt() or nil
        -- if default ~= 1 then return false end  --  default为1才显示
        local playerLevel = self:getUserStatusDataByKey("level") or 1;
        local showLevel = btnInfo:getNodeWithKey("show_lv") and btnInfo:getNodeWithKey("show_lv"):toInt() or 1
        if showLevel > playerLevel then return false end  --  等级大于显示等级才显示
    end
    -- 查找server_inreview表  通inreview表
    local server_inreview_cfg = getConfig(game_config_field.server_inreview)
    local btnInfo = server_inreview_cfg:getNodeWithKey( tostring(viewID) )
    if viewID == 906 then
        cclog("viewID ======= 906")
        cclog2(btnInfo,"btnInfo")
    end
    if btnInfo then 
        -- local default = btnInfo:getNodeWithKey("default") and btnInfo:getNodeWithKey("default"):toInt() or nil
        -- if default ~= 1 then return false end  --  default为1才显示
        local playerLevel = self:getUserStatusDataByKey("level") or 1;
        local showLevel = btnInfo:getNodeWithKey("show_lv") and btnInfo:getNodeWithKey("show_lv"):toInt() or 1
        if showLevel > playerLevel then return false end  --  等级大于显示等级才显示
    end
    return true
end

--[[--
    检查按钮显示等级   
    -- 根据inview表 show_lv 决定是否显示某些按钮
]]
function M.isViewShowByID( self, viewID )
    -- if viewID == 129 then return false end
    if not self:isViewOpenByID(viewID) then return false end  -- 功能被是被关闭的，直接隐藏
    local inreview_cfg = getConfig(game_config_field.inreview)
    local btnInfo = inreview_cfg:getNodeWithKey( tostring(viewID) )
    if btnInfo then
        local playerLevel = self:getUserStatusDataByKey("level") or 1;
        local showLevel = btnInfo:getNodeWithKey("show_lv") and btnInfo:getNodeWithKey("show_lv"):toInt() or 1
        if showLevel > playerLevel then return false end
    end
    return true
end


--[[--
    更新server_inreview数据
]]
function M.updateActiveInreviewByJsonData(self, jsonData)
    if not ( jsonData and jsonData:getFormatBuffer() ) then return end
    local info = json.decode(jsonData:getFormatBuffer()) or {}
    self.m_curInReviewOpenButton = {}
    for i,v in pairs(info) do
        self.m_curInReviewOpenButton["in_review_" .. tostring(i)] = {level = v}
    end
end

--[[--
    检查可多次活动按钮显示   
    -- 根据active_inview表
]]
function M.isActiveOpenByID( self, viewID )
    -- 列表有 活动按钮显示  
    -- do return true end
    -- cclog2(self.m_curInReviewOpenButton, "self.m_curInReviewOpenButton  ========   ")
    local info = self.m_curInReviewOpenButton["in_review_" .. tostring(viewID)]
    -- cclog2(info, "info  ========   ")
    if info then
        local playerLevel = self:getUserStatusDataByKey("level") or 1;
        if playerLevel >= tonumber(info.level or 0) then
            return true
        end
    end
    return false
end

--[[--
   更新CardsOpen接口数据
]]
function M.updateCardsOpenByJsonData(self,jsonData)
    if jsonData == nil then return end
    self:setAssistantByJsonData(jsonData:getNodeWithKey("assistant"));
    self:setAssistantEffectByJsonData(jsonData:getNodeWithKey("assistant_effect"));
    self:setDestinyByJsonData(jsonData:getNodeWithKey("destiny"));
    self:setTeamByJsonData(jsonData:getNodeWithKey("alignment"));
    self:setPetTeamByJsonData(jsonData:getNodeWithKey("pet_pos"));
    self:setEquipPosDataByJsonData(jsonData:getNodeWithKey("equip_pos"));
    self:setAssEquipPosDataByJsonData(jsonData:getNodeWithKey("ass_equip_pos"));
    self:setEquipSortDataByJsonData(jsonData:getNodeWithKey("equip_sort"));
    self:setFormationDataByJsonData(jsonData:getNodeWithKey("formation"));
    self:setItemsDataByJsonData(jsonData:getNodeWithKey("items"));
    self:setOpenPositionDataByJsonData(jsonData:getNodeWithKey("open_position"));
    self:setLeaderSkillDataByJsonData(jsonData:getNodeWithKey("leader_skill"))
    self:setAvailableSkillTreeDataByJsonData(jsonData:getNodeWithKey("available_tree"))
    self:setAvailableSkillDataByJsonData(jsonData:getNodeWithKey("available_skill"))
    self:setCardsByJsonData(jsonData:getNodeWithKey("cards"));
    self:setBadgeByJsonData(jsonData:getNodeWithKey("badges")); --徽章
    self:setPetByJsonData(jsonData:getNodeWithKey("pet"));
    self:setEquipDataByJsonData(jsonData:getNodeWithKey("equip"));
    self:setBattleCardNumByJsonData(jsonData:getNodeWithKey("battle_card_num"));
    self:setCommanderAttrsByJsonData(jsonData:getNodeWithKey("commander_attrs"))
    self:setGemPosDataByJsonData(jsonData:getNodeWithKey("gem_pos"));
    self:setGemDataByJsonData(jsonData:getNodeWithKey("gem"));
    self:setSoulPosDataByJsonData(jsonData:getNodeWithKey("soul_pos"));
    self:setSoulDataByJsonData(jsonData:getNodeWithKey("soul"));
    self:setPetFollowPos(jsonData:getNodeWithKey("pet_follow_pos"))
    self:setGodEquipPosDataByJsonData1(jsonData:getNodeWithKey("equip_pos_1"));
    self:setGodEquipPosDataByJsonData2(jsonData:getNodeWithKey("equip_pos_2"));
    self:setGodEquipPosDataByJsonData3(jsonData:getNodeWithKey("equip_pos_3"));
    self:setGodCardsPosByJsonData(jsonData:getNodeWithKey("god_field_ids"));
    self:setMedalPosDataByJsonData(jsonData:getNodeWithKey("medal_pos"));
    self:setMedalDataByJsonData(jsonData:getNodeWithKey("_medal"));

    --神域勋章、宝石、英魂
     self:setCommanderAvailableSkillByJsonData(jsonData:getNodeWithKey("commander_available_skill"))
    self:setGodSoulPosDataByJsonData1(jsonData:getNodeWithKey("soul_pos_1"));
    self:setGodSoulPosDataByJsonData2(jsonData:getNodeWithKey("soul_pos_2"));
    self:setGodSoulPosDataByJsonData3(jsonData:getNodeWithKey("soul_pos_3"));
    self:setGodMedalPosDataByJsonData1(jsonData:getNodeWithKey("medal_pos_1"));
    self:setGodMedalPosDataByJsonData2(jsonData:getNodeWithKey("medal_pos_2"));
    self:setGodMedalPosDataByJsonData3(jsonData:getNodeWithKey("medal_pos_3"));
    self:setGodGemPosDataByJsonData1(jsonData:getNodeWithKey("Gem_pos_1"));
    self:setGodGemPosDataByJsonData2(jsonData:getNodeWithKey("Gem_pos_2"));
    self:setGodGemPosDataByJsonData3(jsonData:getNodeWithKey("Gem_pos_3"));
    self:setGodMedalDataByJsonData(jsonData:getNodeWithKey("all_medal"));--神域勋章
    self:setGodGemDataByJsonData(jsonData:getNodeWithKey("all_gem"));--神域宝石

    self:setFormationBonusByJsonData(jsonData:getNodeWithKey("formation_bonus")) --新助威
    self:setFormationBonusAdditionByJsonData(jsonData:getNodeWithKey("formation_bonus_addition")) --新助威阵法卡牌
    self:setFormationBonusEquipDataByJsonData(jsonData:getNodeWithKey("bonus_equip_pos")) --新助威装备

    self:setMagicDataByJsonData(jsonData:getNodeWithKey("talisman")); -- 1
    self:setMagicPosDataByJsonData(jsonData:getNodeWithKey("talisman_pos")); -- 1
    self:setAssMagicPosDataByJsonData(jsonData:getNodeWithKey("ass_talisman_pos")); -- 1
    self:setGodMagicPosDataByJsonData1(jsonData:getNodeWithKey("talisman_pos_1")); -- 0
    self:setGodMagicPosDataByJsonData2(jsonData:getNodeWithKey("talisman_pos_2")); -- 0
    self:setGodMagicPosDataByJsonData3(jsonData:getNodeWithKey("talisman_pos_3")); -- 0
    self:setFormationBonusMagicDataByJsonData(jsonData:getNodeWithKey("bonus_talisman_pos")) --新助威装备
    self:setFormationbloodStoneData(jsonData)
    self:setMagicSortDataByJsonData(jsonData:getNodeWithKey("talisman_sort"));

    --圣石
    self:setSaintStonePosDataByJsonData(jsonData:getNodeWithKey("god_stone_pos"));
    self:setSaintStoneDataByJsonData(jsonData:getNodeWithKey("god_stone"))


    self:setGodSaintStoneDataByJsonData(jsonData:getNodeWithKey("all_god_stone"));--神域圣石

    self:setGodSaintStonePosDataByJsonData1(jsonData:getNodeWithKey("god_stone_pos_1"));
    self:setGodSaintStonePosDataByJsonData2(jsonData:getNodeWithKey("god_stone_pos_2"));
    self:setGodSaintStonePosDataByJsonData3(jsonData:getNodeWithKey("god_stone_pos_3"));

    --神域圣石
    --名人堂
    self:setFamousDeatilDataByJsonData(jsonData:getNodeWithKey("famous_detail")) -- 名人堂信息
    if jsonData:getNodeWithKey("wormholes_field") then
        self.m_wormholes_field = json.decode(jsonData:getNodeWithKey("wormholes_field"):getFormatBuffer());
    end
    self:setFamousAttrsByJsonData(jsonData:getNodeWithKey("famous_attrs")) 
    self:setFamousAllDataByJsonData(jsonData:getNodeWithKey("famous_all"))-- 名人堂卡牌id

    self:setCardSkinData(jsonData:getNodeWithKey("skin")) --玩家拥有的所有皮肤
    self:setCurCardSkinData(jsonData:getNodeWithKey("used_skin")) --玩家当前穿戴的所有皮肤
    self:setStoreHouseData(jsonData:getNodeWithKey("storehouse"))
     --命运宝石
    self:setFateGemDataByJsonData(jsonData:getNodeWithKey("gem_fate"));
    -- self.is_double = jsonData:getNodeWithKey("is_double")

    self:setTalismanWormholeByJsonData(jsonData:getNodeWithKey("talisman_wormhole"));   -- 虫洞法宝
    self:setEquipWormholeByJsonData(jsonData:getNodeWithKey("equip_wormholes"));   -- 虫洞装备
end

--[[--
   设置按钮提示数据
]]
function M.setAlertsDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_alertsData = json.decode(jsonData:getFormatBuffer()) or {};
end
function M.setIsNewVersion(self,jsonData)
 if jsonData == nil then return end
    self.m_is_new_version = ""
    self.m_is_new_version = json.decode(jsonData:getFormatBuffer()) or {};
    self.m_is_new_version = self.m_is_new_version.is_new_version
    -- cclog2(jsonData,"jsonData ==  ")
    

end
function M.getIsNewVersion( self )
    -- body
    return self.m_is_new_version 
end

--[[--
   获得按钮提示数据
]]
function M.getAlertsData(self)
    return self.m_alertsData or {};
end

--[[--
   获得排名
]]
function M.getArenaRank(self)
    return self.m_arenaRank or 0;
end

--[[--
   获得竞技场点
]]
function M.getArenaPoint(self)
    return self.m_arenaPoint or 0;
end

--[[
    获得领奖时间
]]
function M.getOnlineExpire(self)
    return self.m_online_award_expire or -2;
end
--[[
    第几次领取
]]
function M.getOnlineExpireTimes(self)
    return self.m_onlinw_awawrd_id or -2;
end
--[[
    第几次购买体力
]]
function M.getBuyActionTimes(self)
    return self.buy_ap_times or 0;
end
--[[
    设置购买体力次数
]]
function M.setBuyActionTimes(self,times)
    self.buy_ap_times = times
end
--[[--
   获取所有的按钮提示标记
]]
function M.getAllAlertsData(self)
    return self.m_alertsData;
end
--[[--
   打印所有的按钮提示标记
]]
function M.printAllAlertsData(self)
    print("all alert data is ")
    print_lua_table(self.m_alertsData, "5")
end
--[[--
   通过key获得按钮提示标记
]]
function M.getAlertsDataByKey(self,key)
    local atertFalg = self.m_alertsData[key]
    -- if atertFalg == nil then atertFalg = false end
    return atertFalg;
end
--[[--
    强制使用等级礼包
]]
function M.useLevelGiftByLevel(self, level)
    -- print("  use gift level ", level, self.m_alertsData["level_gift"])
    if self.m_alertsData["level_gift"] then
        self.m_alertsData["level_gift"][tostring(level)] = nil
        local num  = 0
        for i,v in pairs(self.m_alertsData["level_gift"]) do
            num = num + 1
        end
        if num <= 0 then
           self.m_alertsData["level_gift"] = nil
       end  
    end
end

--[[--
   设置活动数据
]]
function M.setActiveDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_activeData = json.decode(jsonData:getFormatBuffer()) or {};
end

--[[--
   获得活动数据
]]
function M.getActiveData(self)
    return self.m_activeData or {};
end

--[[--
   设置选择的活动数据
]]
function M.setSelActiveDataByKeyAndValue(self,key,value)
    self.m_selActiveData[tostring(key)] = value;
end

--[[--
   获得选择的活动数据
]]
function M.getSelActiveDataByKey(self,key)
    return self.m_selActiveData[tostring(key)];
end

--[[--
   设置背景音乐名称
]]
function M.setBackgroundMusicName(self,musicName)
    if musicName == nil then musicName = "" end
    self.m_backgroundMusicName = musicName;
end

--[[--
   获得背景音乐名称
]]
function M.getBackgroundMusicName(self)
    return self.m_backgroundMusicName;
end

--[[--
    获得可用的背包个数
]]
function M.getAvailableCardBackpackNum(self)
    local card_max = self.m_tUserStatusData["card_max"] or 0;
    local card_num = self:getCardsCount();
    return card_max - card_num;
end
--[[
    获得经验球的经验
]]
function M.getBallExp(self)
    local ballExp = self.m_tUserStatusData["exp_ball"] or 9999;
    return ballExp
end
--[[
    获得装备可用的背包个数
]]
function M.getAvailableEquipBackpackNum(self)
    local equip_max = self.m_tUserStatusData["equip_max"] or 0;
    local equip_num = self:getEquipCount();
    return equip_max - equip_num;
end
--[[--
   获得选中城市自动战斗次数
]]
function M.getSelCitySweepLogData(self)
    self.m_selCitySweepLogData = self.m_tSelCityData.sweep_log
    return self.m_selCitySweepLogData or {};
end
--[[
    通过city id 修改扫荡次数
]]
function M.setSweepLogData(self,buildingId,count)
    self.m_selCitySweepLogData[tostring(buildingId)] = count
end
--[[--
   增加自动战斗的次数
]]
function M.addSelCitySweepLogDataByBuildingId(self,buildingId)
    buildingId = tostring(buildingId);
    self.m_selCitySweepLogData = self.m_tSelCityData.sweep_log
    if self.m_selCitySweepLogData[buildingId] == nil then
        self.m_selCitySweepLogData[buildingId] = 1;
    else
        self.m_selCitySweepLogData[buildingId] = self.m_selCitySweepLogData[buildingId] + 1;
    end
end

--[[--
   设置选中城市数据
]]
function M.setSelCityDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tSelCityData = json.decode(jsonData:getFormatBuffer()) or {};
end

--[[--
   获得选中城市数据
]]
function M.getSelCityData(self)
    return self.m_tSelCityData or {};
end

--[[--
   设置选中城市数据
]]
function M.setSelNeutralCityDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tSelNeutralCityData = json.decode(jsonData:getFormatBuffer()) or {};
end

--[[--
   获得选中城市数据
]]
function M.getSelNeutralCityData(self)
    return self.m_tSelNeutralCityData or {};
end

--[[--
   设置阵型中的出战的数量
]]
function M.setBattleCardNumByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tBattleCardNum = json.decode(jsonData:getFormatBuffer()) or {};
    self:resetBattleCardNumData();
end

--[[--
   获得阵型中的出战的数量
]]
function M.getBattleCardNumData(self)
    return self.m_tBattleCardNum or {};
end

--[[--
   获得阵型位置开启提示
]]
function M.getOpenFormationAlertFlag(self)
    local tempFlag = false;
    if self.m_tBattleCardNum.position_num > self.m_tBattleCardNum.temp_position_num or self.m_tBattleCardNum.alternate_num > self.m_tBattleCardNum.temp_alternate_num then
        tempFlag = true;
    end
    return tempFlag, self.m_tBattleCardNum.position_num
end
--[[
    获得活动开启提示
]]
function M.openActiveAlertFlag(self)
    local tempFlag = false
    if self.m_active == 1 then
        tempFlag = true
    end
    return tempFlag
end
--[[--
   
]]
function M.resetBattleCardNumData(self)
    self.m_tBattleCardNum.temp_position_num = self.m_tBattleCardNum.position_num
    self.m_tBattleCardNum.temp_alternate_num = self.m_tBattleCardNum.alternate_num
end

--[[
    获得vip等级
]]
function M.getVipLevel(self)
    return self.m_tUserStatusData.vip;
end
--[[
    获得当前vip经验
]]
function M.getVipExp( self )
    return self.m_tUserStatusData.vip_exp;
end
--[[
    获得免费训练次数
]]
function M.getFreeTrainTimes(self)
    return self.m_tUserStatusData.free_train_times;
end

--[[--
   设置临时战斗力
]]
function M.setTempCombatValue(self,value)
    self.tempCombatValue = value
end

--[[--
   获得临时战斗力
]]
function M.getTempCombatValue(self)
    return self.tempCombatValue or 0;
end

--[[--
   重置新卡牌id表
]]
function M.resetNewCardIdTab(self)
    self.m_newCardIdTab = {count = 0};
end

--[[--
   重置新装备id表
]]
function M.resetNewEquipIdTab(self)
    self.m_newEquipIdTab = {count = 0};
end

--[[--
   重置新道具id表
]]
function M.resetNewItemIdTab(self)
    self.m_newItemIdTab = {count = 0};
end

--[[--
   判断是否是新卡牌
]]
function M.isNewCardFlagById(self,tempId)
    return self.m_newCardIdTab[tostring(tempId)] ~= nil;
end

--[[--
    判断是否是新装备
]]
function M.isNewEquipFlagById(self,tempId)
    return self.m_newEquipIdTab[tostring(tempId)] ~= nil;
end

--[[--
    判断是否是新道具
]]
function M.isNewItemFlagById(self,tempId)
    return self.m_newItemIdTab[tostring(tempId)] ~= nil;
end

--[[--
   获得新卡牌标记
]]
function M.getNewCardFlag(self)
    if self.m_newCardIdTab.count > 0 then
        return true
    end
    return false
end

--[[--
   获得新装备标记
]]
function M.getNewEquipFlag(self)
    if self.m_newEquipIdTab.count > 0 then
        return true
    end
    return false
end

--[[--
    获得新道具标记
]]
function M.getNewItemFlag(self)
    return self.m_newItemIdTab.count > 0;
end

--[[--
   设置当前战斗id
]]
function M.setCurrentFightId(self,tempId)
    self.m_currentFightId = tostring(tempId);
end

--[[--
    获得当前战斗id
]]
function M.getCurrentFightId(self)
    return self.m_currentFightId
end

--[[--
   设置
]]
function M.setCurrChapterTypeName(self,chapterTypeName)
    self.m_currChapterTypeName = chapterTypeName;
end

--[[--
    获得
]]
function M.getCurrChapterTypeName(self)
    return self.m_currChapterTypeName
end
--[[--

]]
function M.getEvolutionCfgByHeroCfg(self,itemCfg)
    local evo_kind = nil;
    if itemCfg then
        evo_kind = itemCfg:getNodeWithKey("evo_kind")
        if evo_kind then
            evo_kind = evo_kind:toInt();
        else
            evo_kind = itemCfg:getNodeWithKey("quality"):toInt();
        end
    end
    return self:getEvolutionCfgByQuality(evo_kind);
end
--[[--

]]
function M.getEvolutionCfgByQuality(self,quality)
    local evolutionCfg = nil;
    quality = quality or 0;
    if quality < 3 then
        evolutionCfg = getConfig(game_config_field.evolution);
    elseif quality == 3 then
        evolutionCfg = getConfig(game_config_field.evolution_3);
    elseif quality == 4 then
        evolutionCfg = getConfig(game_config_field.evolution_4);
    elseif quality > 4 then
        evolutionCfg = getConfig(game_config_field.evolution_5);
    end
    return evolutionCfg;
end

--[[--
    获得
]]
function M.getMaxLvCardFlag(self)
    local tempFlag = false;
    local maxFlag = false;
    local tempCount = 0;
    for k,v in pairs(self.m_tCardsIdTable) do
        local itemData,itemCfg = self:getCardDataById(v)
        if itemCfg:getNodeWithKey("character_ID"):toInt() == 38 and itemCfg:getKey() == "3800" then
            tempCount = tempCount + 1;
            -- local quality = itemCfg:getNodeWithKey("quality"):toInt();
            local evolutionCfg = self:getEvolutionCfgByHeroCfg(itemCfg)--self:getEvolutionCfgByQuality(quality);
            if evolutionCfg then
                local evo = itemData.evo
                local tempEvoItem = evolutionCfg:getNodeWithKey(tostring(evo+1))
                if tempEvoItem then
                    if itemData.lv >= tempEvoItem:getNodeWithKey("need_level"):toInt() then
                        maxFlag = true;
                    end
                end
            end
            if tempCount > 1 and maxFlag == true then
                tempFlag = true;
                break;
            end
        end
    end
    return tempFlag;
end
--[[
    获得商店的数据
]]
function M.getShopData(self)
    return self.shopData
end
--[[
    设置商店购买数据
]]
function M.setShopData(self,shopId,bought)
    self.shopData.items[tostring(shopId)].bought = bought
end
--[[
    获得
]]
function M.getNoUseEquipCountTab(self)
    local tempTab = {0,0,0,0}
    for k,v in pairs(self.m_tEquipPosData) do
        for index,id in pairs(v) do
            if id ~= "0" then
                tempTab[index] = tempTab[index] - 1;
            end
        end
    end
    for k,v in pairs(self.m_tAssEquipPosData) do
        for index,id in pairs(v) do
            if id ~= "0" then
                tempTab[index] = tempTab[index] - 1;
            end
        end
    end
    local equipCfg = getConfig(game_config_field.equip);
    local equipCfgItem = nil;
    local sort = nil;
    for k,itemData in pairs(self.m_tEquipData) do
        equipCfgItem = equipCfg:getNodeWithKey(itemData.c_id);
        sort = equipCfgItem:getNodeWithKey("sort"):toInt();
        if sort > 0 and sort < 5 then
            tempTab[sort] = tempTab[sort] + 1;
        end
    end
    -- table.foreach(tempTab,print)
    return tempTab;
end

--[[--
    stageID 与 chapter 对应关系
]]
function M.getChapterByStage( self, stageID )
    local cityid_cityorderid_cfg = getConfig(game_config_field.cityid_cityorderid);
    local map_main_story_cfg = getConfig(game_config_field.map_main_story);
    local cityOrderId = cityid_cityorderid_cfg:getNodeWithKey(tostring(stageID)):toStr();
    local main_story_item = map_main_story_cfg:getNodeWithKey(cityOrderId);
    local chapterId = main_story_item:getNodeWithKey("chapter"):toStr();
    return chapterId
end




--[[--
   设置 recipeId  itemId
]]
function M.setCommanderRecipeData(self,key,tempId)
    self.m_commanderData[tostring(key)] = tempId;
end

--[[--
    获得
]]
function M.getCommanderRecipeData(self)
    return self.m_commanderData
end

--[[--
   设置 
]]
function M.setCommanderAttrsByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_commanderData.commanderAttrs = json.decode(jsonData:getFormatBuffer()) or {};
end

--[[--
    获得
]]
function M.getCommanderAttrsData(self)
    return self.m_commanderData.commanderAttrs or {};
end

--[[--
    读取保存在本地的数据
]]
function M.getLocalGameData( self )
    local localData = {}
    -- local filePath = CCFileUtils:sharedFileUtils():getWritablePath() .. "other/";
    -- local data_json = util.readFile(filePath .. "local.configtea")
    -- if data_json then
    --     print(" local data is ", data_json)
    --     localData = json.decode(data_json) or {}
    -- end
    localData["m_task_btn_date"] = CCUserDefault:sharedUserDefault():getStringForKey("m_task_btn_date")
    localData["shencundakaoyan"] = CCUserDefault:sharedUserDefault():getStringForKey("shencundakaoyan")
    -- print("localData[m_task_btn_date]  -- ", localData["m_task_btn_date"] , " -- this is the info -- tonumber is ", tonumber(localData["m_task_btn_date"]), "end")
    if localData["m_task_btn_date"] == nil then
        -- print("localData[m_task_btn_date]  -- ", "is nil")
    end

    return localData 
end

function M.updateLocalData( self, key, data, isNew)
    if key == nil or type(key) ~= "string" then return end
    if data or isNew then
        if type(data) == "table" then data = json.encode(data) or data end
        self.m_tLocalGameData[key] = data 
        CCUserDefault:sharedUserDefault():setStringForKey(key, tostring(data))
        CCUserDefault:sharedUserDefault():flush();
        -- self:saveLocaData()
    end
    if self.m_tLocalGameData[key] then
        return self.m_tLocalGameData[key]
    end
    self.m_tLocalGameData[key] = CCUserDefault:sharedUserDefault():getStringForKey(tostring(key))
    return self.m_tLocalGameData[key]
end

-- function M.saveLocaData( self )
--     local teaKey = getGameTeaKey()
--     local filePath = CCFileUtils:sharedFileUtils():getWritablePath() .. "other/";
--     local tempText = json.encode( self.m_tLocalGameData )
--     -- local tempText = CCCrypto:encryptXXTEALua(tempText,string.len(tempText),teaKey,string.len(teaKey));
--     local fullpath = filePath .. "local.configtea"
--     local ret = util.writeFile(fullpath,tempText);
-- end


--[[--
    获取用户本地数据
]]
function M.getUserLocalData( self )
    local key = "local_" .. ( self:getUserStatusDataByKey("uid") or "default" )
    local userdatas = CCUserDefault:sharedUserDefault():getStringForKey( key )
    -- cclog2(key, "will check this one data ==== ")
    -- cclog2(userdatas, "check this one userdatas ==== ")
    if type(userdatas) ~= "string" or userdatas == "" then 
        local defaultUserData = json.encode( {} )
        CCUserDefault:sharedUserDefault():setStringForKey(key, defaultUserData)
        CCUserDefault:sharedUserDefault():flush();
        return {}
    end
    return json.decode( userdatas )
end

--[[--
    根据key获取用户本地数据
]]
function M.getUserLocalDataByKey( self, key )
    local localUserData = self:getUserLocalData() or {}
    return localUserData[key]
end

--[[--
    根据key保存用户本地数据
]]
function M.setUserLocalDataByKey( self, key, data )
    local localUserData = self:getUserLocalData()
    -- cclog2(data, "will setUserLocalDataByKey ")
    -- cclog2(key, "will setUserLocalDataByKey  key  ===  ")
    if data == nil then
        localUserData[key] = data
    elseif type(data) == "table" then
        localUserData[key] = data
    elseif type(data) ~= "userdata" and type(data) ~= "function" then 
        localUserData[key] = data
    end 
    
    local user_key = "local_" .. ( self:getUserStatusDataByKey("uid") or "default" )
    local defaultUserData = json.encode( localUserData )
    -- cclog2(user_key, "will check this one data ==== ")
    -- cclog2(localUserData, "check this one localUserData ==== ")
    CCUserDefault:sharedUserDefault():setStringForKey(user_key, defaultUserData)
    CCUserDefault:sharedUserDefault():flush();
end


--[[--
    
]]
function M.getEquipGuideFlag(self)
    local tempFlag = true;
    for k,v in pairs(self.m_tEquipPosData) do
        if v[1] ~= "0" then
            tempFlag = false;
            break;
        end
    end
    return tempFlag;        
end
--[[
    保存手机号
]]
function M.setPhoneNum(self,phoneNum)
    self.m_phone_num = phoneNum
end
--[[
    得到手机号
]]
function M.getPhoneNum(self)
    return self.m_phone_num
end

--[[--
    通过json数据设置数据
]]
function M.setMapWorldByJsonData(self,jsonData)
    if jsonData == nil then
        return;
    end
    self.m_mapWorldData = json.decode(jsonData:getFormatBuffer()) or {};
end

--[[--
    通过json数据设置数据
]]
function M.getMapWorldData(self)
    return self.m_mapWorldData;
end

--[[--
    聊天数据
]]
function M.addOneChat( self, msg )
    local maxMsg = self.m_chatData.maxMsg
    if not msg or type(msg) ~= "table" then return end
    local kqgFlag = msg.kqgFlag
    local key = nil
    if kqgFlag == 'world' or kqgFlag == "system" or kqgFlag == 'guild' or kqgFlag == 'friend' then
        key = "world"
        self:insertOneChat(key, msg)
    end

    if kqgFlag == "outdoor" or kqgFlag == "system" or kqgFlag == 'friend'then
        key = "outdoor"
        self:insertOneChat(key, msg)
    end

    if kqgFlag == 'guild' then
        key = "guild"
        self:insertOneChat(key, msg)
    end
    if kqgFlag == 'friend' then
        key = "friend"
        self:insertOneChat(key, msg)
    end
    if kqgFlag == "guild_war" then
        key = "guild_war"
        self:insertOneChat(key, msg)
    end

    -- print("kqgFlag =======  ", kqgFlag, " key ==== ", key)

    -- -- print("msg data == ", json.encode(msg))
    -- if not key or not self.m_chatData[key] then return end

    -- local msgData = self.m_chatData[key].data
    -- local flag = false
    -- for i=1, #msgData do
    --     if msgData[i] and msgData[i].user == msg.user then
    --         if msg.dsign and msg.dsign ==  msgData[i].dsign then return end
    --         if msg.content == msgData[i].content  then
    --             print(msg.content == msgData[i].content)
    --             for j = i, #msgData - 1 do
    --                 self.m_chatData[key].data[j] = self.m_chatData[key].data[j + 1]
    --                 if j+ 1 == #msgData then
    --                      self.m_chatData[key].data[j + 1] = msg
    --                      return
    --                 end
    --             end
    --         end
    --     end
    -- end



    -- if(self.m_chatData[key].curMsg>=maxMsg)then
    -- for i=1, maxMsg-1 do
    --     self.m_chatData[key].data[i] = self.m_chatData[key].data[i + 1]
    -- end
    --     self.m_chatData[key].data[self.m_chatData[key].curMsg] = msg
    -- else
    --     self.m_chatData[key].curMsg = self.m_chatData[key].curMsg + 1
    --     self.m_chatData[key].data[self.m_chatData[key].curMsg] = msg
    -- end
    -- print("get one msg type == ", key, " all data is ", key and json.encode(self.m_chatData[key]), "end")
end

function M.insertOneChat( self, key, msg )
    local maxMsg = self.m_chatData.maxMsg
    -- body
    -- print("msg data == ", json.encode(msg))
    if not key or not self.m_chatData[key] then return end

    local msgData = self.m_chatData[key].data
    local flag = false
    for i=1, #msgData do
        if msgData[i] and msgData[i].user == msg.user then
            if msg.dsign and msg.dsign ==  msgData[i].dsign then return end
            if msg.content == msgData[i].content  then
                print(msg.content == msgData[i].content)
                for j = i, #msgData - 1 do
                    self.m_chatData[key].data[j] = self.m_chatData[key].data[j + 1]
                    if j+ 1 == #msgData then
                         self.m_chatData[key].data[j + 1] = msg
                         return
                    end
                end
            end
        end
    end

    if(self.m_chatData[key].curMsg>=maxMsg)then
    for i=1, maxMsg-1 do
        self.m_chatData[key].data[i] = self.m_chatData[key].data[i + 1]
    end
        self.m_chatData[key].data[self.m_chatData[key].curMsg] = msg
    else
        self.m_chatData[key].curMsg = self.m_chatData[key].curMsg + 1
        self.m_chatData[key].data[self.m_chatData[key].curMsg] = msg
    end
end

--[[
    宝藏难度
]]
function M.setTreasure(self,treasure)
    self.m_treasure = treasure
end
--[[
    
]]
function M.getTreasure(self)
    return self.m_treasure
end
--[[--
    查看是否可以发送消息    
]]
function M.isCanChat( self, key )
   local lastTime = self.m_chatTime[key] 
   if not lastTime or os.time() - lastTime >= 10 then
        return true
    end
    return false
end

--[[ --
    更新说话时间
]]
function M.updateChatTime( self, key )
    self.m_chatTime[key] = os.time()
end

--[[--
    获取聊天数据
]]
function M.getChats( self, key )
    return self.m_chatData[key]
end

--[[
    记录SDKAccount
]]
function M.setSDKAccount( self, account )
    self.m_sdkAccount = account
end

--[[
    获取SDKAccount
]]
function M.getSDKAccount( self )
    return self.m_sdkAccount
end
--[[
    设置数据
]]
function M.setDataByKeyAndValue( self, key , value)
    self[tostring(key)] = value;
end
--[[
    获取数据
]]
function M.getDataByKey( self , key)
    return self[tostring(key)]
end

--[[--
    通用
]]
function M.getMetalByJsonData(self,jsonData)
    if jsonData == nil then return end
    return self:rewardTipsByDataTable(json.decode(jsonData:getFormatBuffer()));
end

--[[
    判断是否在训练中
]]
function M.getCardTrainingFlag(self,itemData)
    local trainingFlag = false;
    if itemData and itemData.remove_avail then
        for k,v in pairs(itemData.remove_avail) do
            if tostring(v) == "train" then
                trainingFlag = true;
                break;
            end
        end
    end
    return trainingFlag;
end
--stepleve 卡牌或者装备等级  breakleve 卡牌转生等级或者装备精炼等级
function M.getMetalByTable(self,dataTable,stepleve,breakleve,material_type)
    material_type = material_type or 0
    local equipCfg = getConfig(game_config_field.equip);
    local materialData = {};
    local count = 0;
    local typeValue = 0;
    if dataTable then
        typeValue = dataTable[1]
        local tempId = dataTable[2];
        if typeValue == 1 then--食品，占位，参数数量；[1,0,100]
            count = self.m_tUserStatusData.food or 0;
        elseif typeValue == 2 then--金属，占位，参数数量；[2,0,100]
            count = self.m_tUserStatusData.metal or 0;
        elseif typeValue == 3 then--能源，占位，能源数量；[3,0,100]
            count = self.m_tUserStatusData.energy or 0;
        elseif typeValue == 4 then--能晶，占位，能晶数量；[4,0,100]
            count = self.m_tUserStatusData.crystal or 0;
        elseif typeValue == 5 then--卡牌，卡牌ID,数量；[5,4,1]
            for k,v in pairs(self.m_tCardsData) do
                --进阶>=5的不显示
                if (material_type == 0 and v.evo < 5) or material_type == 1 then
                    local ishave = self:heroInTeamById(v.id) or self:heroInAssistantById(v.id) or self:getCardTrainingFlag(v) or game_util:godheroInTeamById(v.id)
                    if tempId == tonumber(v.c_id) and not ishave and stepleve <= tonumber(v.step)  then
                        cclog("v.step)== " .. v.step .. "tonumber(v.bre) = " .. v.bre)
                    end
                    if tempId == tonumber(v.c_id) and not ishave and stepleve <= tonumber(v.step) and breakleve <= tonumber(v.bre) then
                    -- if tempId == tonumber(v.c_id)  then
                        table.insert(materialData,k)
                        cclog("v.step1)== " .. v.step .. "tonumber(v.bre1) = " .. v.bre)
                    end
                end
            end
            count = #materialData;
        elseif typeValue == 6 then--道具，ID,数量；[6,4,1]
            count = self:getItemCountByCid(tempId);
        elseif typeValue == 7 then--装备,ID，数量；[7,4,1]
            for k,v in pairs(self.m_tEquipData) do
                local itemCfg = equipCfg:getNodeWithKey(v.c_id)
                local existFlag,_ = self:equipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),v.id)
                local godflag = self:godequipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),v.id)
                if tempId == tonumber(v.c_id) and existFlag == false and stepleve <= tonumber(v.lv) and breakleve <= tonumber(v.st_lv) and godflag == false then
                    table.insert(materialData,k)
                    cclog("m_tEquipData ==== " .. json.encode(v))
                end
            end
            count = #materialData;
        elseif typeValue == 8 then--玩家经验，占位，数值;[8,0,100]
            count = self.m_tUserStatusData.exp or 0;
        elseif typeValue == 9 then--钻石,占位，数量;[9,0,1]
            count = self.m_tUserStatusData.coin or 0;
        elseif typeValue == 10 then--强能之尘,占位，数量;[10,0,1]
            count = self.m_tUserStatusData.dirt_silver or 0;
        elseif typeValue == 11 then--超能之尘,占位，数量;[11,0,1]
            count = self.m_tUserStatusData.dirt_gold or 0;
        elseif typeValue == 12 then--阵石,占位，数量;[12,0,1]
            count = 0;
        elseif typeValue == 13 then--行动力,占位，数量;[13,0,1]
            count = self.m_tUserStatusData.action_point or 0;
        elseif typeValue == 14 then--星灵,占位，数量;[14,0,1]
            count = self.m_tUserStatusData.star or 0;
        elseif typeValue == 15 then--金币,占位，数量;[15,0,1]
            count = self.m_tUserStatusData.silver or 0;
        elseif typeValue == 16 then--精炼石
            count = self.m_tUserStatusData.metalcore or 0;
        elseif typeValue == 17 then--神恩
            count = self.m_tUserStatusData.grace or 0 
        elseif typeValue == 18 then--高級神恩
            count = self.m_tUserStatusData.grace_high or 0
        elseif typeValue == 20 then--高級neng'ji
            count = self.m_tUserStatusData.adv_crystal or 0
        elseif typeValue == 24 then -- 宠物能晶
            count = self.m_tUserStatusData.pet_crystal or 0
        elseif typeValue == 36 then
            local allsoul = self:getSoulData()
            for k,v in pairs(allsoul) do
                local me,_,_ = self:soulInSoulPos(k)
                if me == false  then
                    if  tempId == tonumber(v.s_id) then
                        table.insert(materialData,k)
                    end
                end
            end
            count = #materialData;
        elseif typeValue == 49 then --法宝
                -- count = 
                local allmagic = self:getMagicData()
                -- cclog2(allmagic,"allmagic-=------------")
                for k,v in pairs(allmagic) do
                    local me,_,_ = self:getMagicDataById(k)
                    -- if me == false  then
                        if  tempId == tonumber(v.c_id)  then
                        -- cclog("111111111")
                        if v.pos == -1  and v.lv == 0  then 
                            table.insert(materialData,k)
                            end
                        end
                    -- end
                    -- print(k,v)
                end
            count = #materialData;
        elseif typeValue == 40 then -- 超级能晶
            count = self.m_tUserStatusData.super_crystal or 0
        elseif typeValue == 100 then--功勋,占位,数量；[100,0,1]
            count = 0; 
        end
    end
    --cclog("materialData count == " .. #materialData)
    local function sortFunc(data1,data2)
        if typeValue == 5 then
            local itemData1,_ = self.m_tCardsData[data1];
            local itemData2,_ = self.m_tCardsData[data2];
            if itemData1 and itemData2 then
                -- return itemData1.evo < itemData2.evo;--先按进阶排序，再按等级排序
                if itemData1.evo == itemData2.evo then
                    return itemData1.lv < itemData2.lv
                else
                    return itemData1.evo < itemData2.evo
                end
            else
                 return false;
            end
        elseif typeValue == 7 then
            local itemData1,_ = self.m_tEquipData[data1];
            local itemData2,_ = self.m_tEquipData[data2];
            if itemData1 and itemData2 then
                return itemData1.lv < itemData2.lv;
            else
                 return false;
            end
        elseif typeValue == 36 then
            local itemData1,_ = self.m_tSoulData[data1];
            local itemData2,_ = self.m_tSoulData[data2];
            if itemData1 and itemData2 then
                return itemData1.lv < itemData2.lv;
            else
                return false;
            end
        end
    end
    table.sort(materialData,sortFunc)
    return materialData,count;
end

function M.startChat( self )
    if not self.m_chat then
        self.m_chat = require("chat_data")
        self.m_chat:startChat()
    else 
        self.m_chat:updateState()
    end
end

function M.getChatObserver( self )
    return self.m_chat
end

function M.resetChatObserver( self )
    if self.m_chat then 
        self.m_chat:close()
    end
    self.m_chat = nil
end

function M.removeChatLinster( self, name )
    if self.m_chat then 
        self.m_chat:removeOneLinster( name ) 
    end
end

function M.updateChatRoom( self, room )
    if self.m_chat then 
        self.m_chat:updateChatRoom( room ) 
    end
end

function M.setForceGuideInfo( self, guide_info)
    self.m_force_guide_info = guide_info
end

function M.resetForceGuideInfo( self, key)
    if self.m_force_guide_info and self.m_force_guide_info.guide_team == key then
        self.m_force_guide_info = nil
    end
end


function M.getForceGuideInfo( self )
    return self.m_force_guide_info
end

--[[
    设置上一个打开的活动的 chapterid
]]
function M.setLeatestActivityIndex( self, index )
    -- cclog2(index, "setLeatestActivityIndex  index ====== ")
    self.m_leatestShowActivityIndex = index
end

--[[
    获取上一个打开的活动的 chapterid
]]
function M.getLeatestActivityIndex( self )
    return self.m_leatestShowActivityIndex
end


function M.updateGuildName( self, guildName )
    cclog2(updateGuildName, "updateGuildName guildName")
    if guildName and guildName ~= self.m_guildName then
        self.m_guildName = guildName 
    end
    return self.m_guildName
end


--[[--
   设置引导过程阶段
]]
function M.setGuideProcess(self, guideProcess)
    self.m_guideProcess = guideProcess;
end

--[[--
   获得引导过程阶段
]]
function M.getGuideProcess(self)
    return self.m_guideProcess;
end
--[[------------------------------------宝石相关 start------------------------------------------- ]]
--[[--
    gem数据排序

    m_tGemData = {},--宝石数据
    m_tGemIdTable = {},--宝石id对应表
    m_tGemPosData = {},--卡牌位置宝石数据
    m_newGemIdTab = {count = 0},
    m_gemSortType = "default",

]]
function M.gemSortByTypeName(self,typeName,flag)

-- 默认：1宝石是否宝石状态，2宝石ID，3宝石等级
-- 等级：1宝石等级，2宝石品质,3宝石ID
-- 品质：1宝石品质，2宝石ID，3宝石等级
-- 类型：1宝石类型，2宝石品质，3宝石ID，4宝石等级

    self.m_gemSortType = typeName;
    self:gemSortByTypeNameWithTable(typeName,self.m_tGemIdTable,flag)
    cclog("gemSortByTypeName ----------------------------------" .. typeName)
    -- table.foreach(self.m_tGemData,print)
end

--圣石
function M.saintStoneSortByTypeName(self,typeName,flag)

-- 默认：1宝石是否宝石状态，2宝石ID，3宝石等级
-- 等级：1宝石等级，2宝石品质,3宝石ID
-- 品质：1宝石品质，2宝石ID，3宝石等级
-- 类型：1宝石类型，2宝石品质，3宝石ID，4宝石等级

    self.m_SaintStoneSortType = typeName;
    self:saintStoneSortByTypeNameWithTable(typeName,self.m_tSaintStoneIdTable,flag)
    cclog("saintStoneSortByTypeName ----------------------------------" .. typeName)
    -- table.foreach(self.m_tGemData,print)
end

function M.gemSortByTypeNameWithTable(self,typeName,idDataTable,flag)
    typeName = typeName or "default";
    local tempTab = self.m_tGemData;
    if flag == true then
        tempTab = self.m_tGodGemData;
    end
    local tostring = tostring;
    local tempCfg = getConfig(game_config_field.gem);
    local itemData1,itemData2,itemCfg1,itemCfg2,quality1,quality2,c_ID1,c_ID2,sort1,sort2

    local tTeamTab = {};
    local tempItem = nil;
    for i=1,8 do
        tempItem = self.m_tGemPosData[tostring(i-1)]
        if tempItem then
            for j=1,4 do
                if tempItem[j] then
                    tTeamTab[tostring(tempItem[j])] = 1;
                end
            end
        end
    end
    local flag1,flag2;
    local function sortFunc(idOne,idTwo)
        itemData1 = tempTab[tostring(idOne)] or 0
        itemData2 = tempTab[tostring(idTwo)] or 0
        itemCfg1 = tempCfg:getNodeWithKey(tostring(idOne));
        itemCfg2 = tempCfg:getNodeWithKey(tostring(idTwo));
        if itemCfg1 and itemCfg2 then
            quality1,quality2 = itemCfg1:getNodeWithKey("quality"):toInt(),itemCfg2:getNodeWithKey("quality"):toInt();
            c_ID1,c_ID2 = tonumber(idOne),tonumber(idTwo)
            if typeName == "default" then
                flag1 = tTeamTab[tostring(idOne)] or 0
                flag2 = tTeamTab[tostring(idTwo)] or 0
                if flag1 == flag2 then
                    if quality1 == quality2 then
                        return itemData1 > itemData2
                    else
                        return quality1 > quality2
                    end
                else
                    return flag1 > flag2
                end
            elseif typeName == "count" then
                if itemData1 == itemData2 then
                    if quality1 == quality2 then
                        return c_ID1 > c_ID2
                    else
                        return quality1 > quality2
                    end
                else
                    return itemData1 > itemData2
                end
            elseif typeName == "quality" then
                if quality1 == quality2 then
                    if c_ID1 == c_ID2 then
                        return itemData1 > itemData2
                    else
                        return c_ID1 > c_ID2
                    end
                else
                    return quality1 > quality2
                end
            elseif typeName == "career" then
                sort1,sort2 = itemCfg1:getNodeWithKey("career"):toInt(),itemCfg2:getNodeWithKey("career"):toInt();
                if sort1 == sort2 then
                    if quality1 == quality2 then
                        if c_ID1 == c_ID2 then
                            return itemData1 > itemData2
                        else
                            return c_ID1 > c_ID2
                        end
                    else
                        return quality1 > quality2;
                    end
                else
                    return sort1 > sort2
                end
            end

        else
            return idOne > idTwo;
        end
    end
    table.sort(idDataTable,sortFunc)
end
--圣石排序

function M.saintStoneSortByTypeNameWithTable(self,typeName,idDataTable,flag)
    typeName = typeName or "default";
    local tempTab = self.m_tSaintStoneData;
    if flag == true then
        tempTab = self.m_tGodSaintStoneData;
    end
    local tostring = tostring;
    local tempCfg = getConfig(game_config_field.god_stone);
    local itemData1,itemData2,itemCfg1,itemCfg2,quality1,quality2,c_ID1,c_ID2,sort1,sort2

    local tTeamTab = {};
    local tempItem = nil;
    for i=1,8 do
        tempItem = self.m_tSaintStonePosData[tostring(i-1)]
        if tempItem then
            for j=1,4 do
                if tempItem[j] then
                    tTeamTab[tostring(tempItem[j])] = 1;
                end
            end
        end
    end
    local flag1,flag2;
    local function sortFunc(idOne,idTwo)
        itemData1 = tempTab[tostring(idOne)] or 0
        itemData2 = tempTab[tostring(idTwo)] or 0
        itemCfg1 = tempCfg:getNodeWithKey(tostring(idOne));
        itemCfg2 = tempCfg:getNodeWithKey(tostring(idTwo));
        if itemCfg1 and itemCfg2 then
            quality1,quality2 = itemCfg1:getNodeWithKey("quality"):toInt(),itemCfg2:getNodeWithKey("quality"):toInt();
            c_ID1,c_ID2 = tonumber(idOne),tonumber(idTwo)
            if typeName == "default" then
                flag1 = tTeamTab[tostring(idOne)] or 0
                flag2 = tTeamTab[tostring(idTwo)] or 0
                if flag1 == flag2 then
                    if quality1 == quality2 then
                        return itemData1 > itemData2
                    else
                        return quality1 > quality2
                    end
                else
                    return flag1 > flag2
                end
            elseif typeName == "count" then
                if itemData1 == itemData2 then
                    if quality1 == quality2 then
                        return c_ID1 > c_ID2
                    else
                        return quality1 > quality2
                    end
                else
                    return itemData1 > itemData2
                end
            elseif typeName == "quality" then
                if quality1 == quality2 then
                    if c_ID1 == c_ID2 then
                        return itemData1 > itemData2
                    else
                        return c_ID1 > c_ID2
                    end
                else
                    return quality1 > quality2
                end
            elseif typeName == "career" then
                sort1,sort2 = itemCfg1:getNodeWithKey("career"):toInt(),itemCfg2:getNodeWithKey("career"):toInt();
                if sort1 == sort2 then
                    if quality1 == quality2 then
                        if c_ID1 == c_ID2 then
                            return itemData1 > itemData2
                        else
                            return c_ID1 > c_ID2
                        end
                    else
                        return quality1 > quality2;
                    end
                else
                    return sort1 > sort2
                end
            end

        else
            return idOne > idTwo;
        end
    end
    table.sort(idDataTable,sortFunc)
end

--[[--
    获得当前排序
]]
function M.getGemSortType(self)
    return self.m_gemSortType;
end
--[[--
    获得当前圣石排序
]]
function M.getSortType(self)
    return self.m_SaintStoneSortType;
end
--[[--
    通过json数据设置宝石数据
]]
function M.setGemDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tGemData = json.decode(jsonData:getFormatBuffer()) or {};
    if self.m_tGemData ~= nil and type(self.m_tGemData) == "table" then
        for k,v in pairs(self.m_tGemData) do
            self.m_tGemIdTable[#self.m_tGemIdTable + 1] = k;
        end
    end
    self:gemSortByTypeName(self.m_gemSortType);
    cclog("setGemDataByJsonData ================ count " .. #self.m_tGemIdTable);
end
--[[--
    通过json数据设置圣石数据
]]
function M.setSaintStoneDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tSaintStoneData = json.decode(jsonData:getFormatBuffer()) or {};
    --cclog2(self.m_tSaintStoneData,"self.m_tSaintStoneData")
    if self.m_tSaintStoneData ~= nil and type(self.m_tSaintStoneData) == "table" then
        for k,v in pairs(self.m_tSaintStoneData) do
            self.m_tSaintStoneIdTable[#self.m_tSaintStoneIdTable + 1] = k;
        end
    end
    -- cclog("setSaintStoneDataByJsonData ================ count " .. #self.m_tSaintStoneIdTable);
    self:saintStoneSortByTypeName(self.m_SaintStoneSortType);
    
end
--[[--
    通过json数据设置神域宝石数据
]]
function M.setGodGemDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodGemData = json.decode(jsonData:getFormatBuffer()) or {};
    if self.m_tGodGemData ~= nil and type(self.m_tGodGemData) == "table" then
        for k,v in pairs(self.m_tGodGemData) do
            self.m_tGodGemIdTable[#self.m_tGodGemIdTable + 1] = k;
        end
    end
    self:gemSortByTypeName(self.m_gemSortType,true);
    cclog("setGodGemDataByJsonData ================ count " .. #self.m_tGodGemIdTable);
end
--[[--
    通过json数据设置圣石数据
]]
function M.setGodSaintStoneDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodSaintStoneData = json.decode(jsonData:getFormatBuffer()) or {};
    if self.m_tGodSaintStoneData ~= nil and type(self.m_tGodSaintStoneData) == "table" then
        for k,v in pairs(self.m_tGodSaintStoneData) do
            self.m_tGodSaintStoneIdTable[#self.m_tGodSaintStoneIdTable + 1] = k;
        end
    end
    self:saintStoneSortByTypeName(self.m_SaintStoneSortType,true);
    cclog("setGodGemDataByJsonData ================ count " .. #self.m_tGodGemIdTable);
end
--[[--
    通过宝石数据
]]
function M.getGodGemData(self)
    return self.m_tGodGemData;
end
--[[--
    通过圣石数据
]]
function M.getSaintStoneData(self)
    return self.m_tSaintStoneData;
end
--[[--
    通过宝石数据
]]
function M.getGemData(self)
    return self.m_tGemData;
end

function M.addGemDataByCid(self, c_id, count)
    c_id = tostring(c_id)
    if c_id == "0" then return end
    count = count or 1;
    if self.m_tGemData[c_id] then
        self.m_tGemData[c_id] = math.max(0,self.m_tGemData[c_id] + count)
    else
        self.m_tGemData[c_id] = count;
    end
end
--圣石
function M.addSaintStoneDataByCid(self, c_id, count)
    c_id = tostring(c_id)
    if c_id == "0" then return end
    count = count or 1;
    if self.m_tSaintStoneData[c_id] then
        self.m_tSaintStoneData[c_id] = math.max(0,self.m_tSaintStoneData[c_id] + count)
    else
        self.m_tSaintStoneData[c_id] = count;
    end
end
--神域宝石
function M.addGodGemDataByCid(self, c_id, count)
    c_id = tostring(c_id)
    if c_id == "0" then return end
    count = count or 1;
    if self.m_tGodGemData[c_id] then
        self.m_tGodGemData[c_id] = math.max(0,self.m_tGodGemData[c_id] + count)
    else
        self.m_tGodGemData[c_id] = count;
    end
end

function M.minusGemDataCid(self, c_id, count)
    c_id = tostring(c_id)
    count = count or 1;
    if self.m_tGemData[c_id] then
        self.m_tGemData[c_id] = math.max(0,self.m_tGemData[c_id] - count)
    end
end
--圣石
function M.minusSaintStoneDataCid(self, c_id, count)
    c_id = tostring(c_id)
    count = count or 1;
    if self.m_tSaintStoneData[c_id] then
        self.m_tSaintStoneData[c_id] = math.max(0,self.m_tSaintStoneData[c_id] - count)
    end
end
--神域宝石
function M.minusGodGemDataCid(self, c_id, count)
    c_id = tostring(c_id)
    count = count or 1;
    if self.m_tGodGemData[c_id] then
        self.m_tGodGemData[c_id] = math.max(0,self.m_tGodGemData[c_id] - count)
    end
end


function M.addGodSaintStoneGemDataByCid(self, c_id, count)
    c_id = tostring(c_id)
    if c_id == "0" then return end
    count = count or 1;
    if self.m_tGodSaintStoneData[c_id] then
        self.m_tGodSaintStoneData[c_id] = math.max(0,self.m_tGodSaintStoneData[c_id] + count)
    else
        self.m_tGodSaintStoneData[c_id] = count;
    end
end

--神域圣石
function M.addSaintStoneGemDataByCid(self, c_id, count)
    c_id = tostring(c_id)
    if c_id == "0" then return end
    count = count or 1;
    if self.m_tGodSaintStoneData[c_id] then
        self.m_tGodSaintStoneData[c_id] = math.max(0,self.m_tGodSaintStoneData[c_id] + count)
    else
        self.m_tGodSaintStoneData[c_id] = count;
    end
end
function M.minusGodSaintStoneDataCid(self, c_id, count)
    c_id = tostring(c_id)
    count = count or 1;
    if self.m_tGodSaintStoneData[c_id] then
        self.m_tGodSaintStoneData[c_id] = math.max(0,self.m_tGodSaintStoneData[c_id] - count)
    end
end

--[[--
    宝石数量
]]
function M.getGemCount(self)
    return #self.m_tGemIdTable;
end

--[[--
    宝石数量
]]
function M.getGemCountByCid(self,cId,selTmepId)
    local tempCount = 0;
    local tostring = tostring;
    cId = tostring(cId);
    selTmepId = tostring(selTmepId);
    local tempCfg = getConfig(game_config_field.gem);
    for k,v in pairs(self.m_tGemData) do
        if tostring(v.c_id) == cId and tostring(k) ~= selTmepId then
            local itemCfg = tempCfg:getNodeWithKey(tostring(v.c_id));
            if itemCfg then
                local existFlag,_ = self:gemInGemPos(itemCfg:getNodeWithKey("career"):toInt(),k)
                if not existFlag then
                    tempCount = tempCount + 1;
                end
            end
        end
    end
    return tempCount;
end


--[[--
    宝石
]]
function M.getGemIdTable(self)
    return self.m_tGemIdTable or {};
end

--[[--
    通过id获得宝石数据
]]
function M.getGemDataById(self,tempId)
    tempId = tostring(tempId)
    local tempData = self.m_tGemData[tempId];
    if tempData == nil then
        if tempId ~= "0" then
            cclog("tempId = " .. tempId .. " ; type(tempId) == " .. tostring(type(tempId)) .. " ; self.m_tGemData == " .. json.encode(self.m_tGemData))
        end
        return nil,nil
    end
    local tempCfg = getConfig(game_config_field.gem);
    local _,gemid = game_util:getRealGemLvAndCid(tempId)-----changedByzjr
    local tempItemCfg = tempCfg:getNodeWithKey(tostring(gemid));
    return tempData,tempItemCfg;
end
--[[--
    通过id获得宝石数据
]]
function M.getSaintStoneDataById(self,tempId)
    tempId = tostring(tempId)
    local tempData = self.m_tSaintStoneData[tempId];
    if tempData == nil then
        if tempId ~= "0" then
            -- cclog("tempId = " .. tempId .. " ; type(tempId) == " .. tostring(type(tempId)) .. " ; self.m_tGemData == " .. json.encode(self.m_tGemData))
        end
        return nil,nil
    end
    local tempCfg = getConfig(game_config_field.god_stone);
    local tempItemCfg = tempCfg:getNodeWithKey(tostring(tempId));
    return tempData,tempItemCfg;
end

--[[--
    通过id获得神域宝石数据
]]
function M.getGodGemDataById(self,tempId)
    tempId = tostring(tempId)
    local tempData = self.m_tGodGemData[tempId];
    if tempData == nil then
        if tempId ~= "0" then
            cclog("tempId = " .. tempId .. " ; type(tempId) == " .. tostring(type(tempId)) .. " ; self.m_tGodGemData == " .. json.encode(self.m_tGodGemData))
        end
        return nil,nil
    end
    local tempCfg = getConfig(game_config_field.gem);
    local tempItemCfg = tempCfg:getNodeWithKey(tostring(tempId));
    return tempData,tempItemCfg;
end
--[[--
    通过id获得神域圣石数据
]]
function M.getGodSaintStoneDataById(self,tempId)
    tempId = tostring(tempId)
    local tempData = self.m_tGodSaintStoneData[tempId];
    if tempData == nil then
        if tempId ~= "0" then
            -- cclog("tempId = " .. tempId .. " ; type(tempId) == " .. tostring(type(tempId)) .. " ; self.m_tGodGemData == " .. json.encode(self.m_tGodGemData))
        end
        return nil,nil
    end
    local tempCfg = getConfig(game_config_field.god_stone);
    local tempItemCfg = tempCfg:getNodeWithKey(tostring(tempId));
    return tempData,tempItemCfg;
end
--[[--
    通过id, 在宝石池获得宝石数据
]]
function M.getGemDataByIdFromPool(self,tempId, gameData)
    tempId = tostring(tempId)
    local tempData = gameData[tempId];
    if tempData == nil then
        if tempId ~= "0" then
            cclog("tempId = " .. tempId .. " ; type(tempId) == " .. tostring(type(tempId)) .. " ; self.m_tGemData == " .. json.encode(self.m_tGemData))
        end
        return nil,nil
    end
    local tempCfg = getConfig(game_config_field.gem);
    local tempItemCfg = tempCfg:getNodeWithKey(tostring(tempId));
    return tempData,tempItemCfg;
end

--[[--
    通过 index 获得宝石数据
]]
function M.getGemDataByIndex(self,index)
    if index > 0 and index <= #self.m_tGemIdTable then
        return self:getGemDataById(self.m_tGemIdTable[index]);
    end
    return nil,nil;
end

--[[--
    通过json数据设置卡牌位置宝石数据
]]
function M.setGemPosDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tGemPosData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setGemPosDataByJsonData ================ " .. json.encode(self.m_tGemPosData));
end
--[[--
    通过json数据设置卡牌位置圣石数据
]]
function M.setSaintStonePosDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tSaintStonePosData = json.decode(jsonData:getFormatBuffer()) or {};

    --cclog("setSaintStonePosDataByJsonData ================ " .. json.encode(self.m_tSaintStonePosData));
end

--[[--
    得到卡牌位置宝石数据
]]
function M.getGemPosData(self)
    return self.m_tGemPosData;
end
--[[--
    得到卡牌位置圣石数据
]]
function M.getSaintStonePosData(self)
    return self.m_tSaintStonePosData;
end
--[[--
    设置卡牌位置宝石数据
]]
function M.setGemPosData(self,tempData)
    self.m_tGemPosData = tempData;
end
--[[--
    设置卡牌位置圣石数据
]]
function M.setSaintStonePosData(self,tempData)
    self.m_tSaintStonePosData = tempData;
    --cclog2(tempData,"tempData  is")
end
--[[--
    设置阵型相应位置宝石数据
]]
function M.updateGemPosData(self,tempPos,tempType,tempId)
    if tempPos > 9 or tempPos < 0 or tempPos > 4 or tempType < 1 then return end
    cclog("updateGemPosData tempPos = " .. tempPos .. " ; tempType = " .. tempType .. " ; tempId = " .. tempId);
    self.m_tGemPosData[tostring(tempPos)][tempType] = tostring(tempId);
    cclog("updateGemPosData = " .. json.encode(self.m_tGemPosData))
end
--[[--
    设置阵型相应位置圣石数据
]]
function M.updateSaintStonePosData(self,tempPos,tempType,tempId)
    if tempPos > 9 or tempPos < 0 or tempPos > 4 or tempType < 1 then return end
    cclog("updateSaintStonePosData tempPos = " .. tempPos .. " ; tempType = " .. tempType .. " ; tempId = " .. tempId);
    self.m_tSaintStonePosData[tostring(tempPos)][tempType] = tostring(tempId);
    cclog("updateSaintStonePosData = " .. json.encode(self.m_tSaintStonePosData))
end

--[[--
    判断是否宝石上
]]
function M.gemInGemPos(self,tempType,tempId)
    tempId = tostring(tempId);
    local existFlag = false;
    local cardName = "";
    local tempPosData = nil;
    if tempType then
        for i=1,10 do
            if tempType == 1 then
                if self.m_tGemPosData[tostring(i-1)][tempType] == tempId then
                    tempPosData = self.m_tGemPosData[tostring(i-1)];
                    existFlag = true
                    local _,itemCfg = self:getTeamCardDataByPos(i);
                    if itemCfg then
                        cardName = itemCfg:getNodeWithKey("name"):toStr();
                    else
                        cardName = i 
                    end
                    break;
                end
            else
                for j=2,4 do
                    if self.m_tGemPosData[tostring(i-1)][j] == tempId then
                        tempPosData = self.m_tGemPosData[tostring(i-1)];
                        existFlag = true
                        local _,itemCfg = self:getTeamCardDataByPos(i);
                        if itemCfg then
                            cardName = itemCfg:getNodeWithKey("name"):toStr();
                        else
                            cardName = i 
                        end
                        break;
                    end
                end
            end
            if cardName ~= "" then
                break;
            end
        end
    end
    return existFlag,cardName,tempPosData
end


--[[--
    更新宝石数据
]]
function M.updateOneGemDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    -- local itemData = json.decode(jsonData:getFormatBuffer());
    local itemData = jsonData:toInt();
    local tempId = jsonData:getKey();
    if self.m_tGemData[tempId] == nil then
        -- self.m_tGemIdTable[#self.m_tGemIdTable + 1] = tempId
        self.m_newGemIdTab[tempId] = 1;
        self.m_newGemIdTab.count = self.m_newGemIdTab.count + 1;
    end
    self.m_tGemData[tempId] = itemData;
    local existFlag = false;
    for k,v in pairs(self.m_tGemIdTable) do
        if v == tempId then
            existFlag = true;
            break;
        end
    end
    if existFlag == false then
        self.m_tGemIdTable[#self.m_tGemIdTable + 1] = tempId;
    end
end
--[[--
    更新圣石数据
]]
function M.updateOneSaintStoneDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    -- local itemData = json.decode(jsonData:getFormatBuffer());
    local itemData = jsonData:toInt();
    local tempId = jsonData:getKey();
    if self.m_tSaintStoneData[tempId] == nil then
        -- self.m_tGemIdTable[#self.m_tGemIdTable + 1] = tempId
        self.m_newSaintStoneIdTab[tempId] = 1;
        self.m_newSaintStoneIdTab.count = self.m_newSaintStoneIdTab.count + 1;
    end
    self.m_tSaintStoneData[tempId] = itemData;
    local existFlag = false;
    for k,v in pairs(self.m_tSaintStoneIdTable) do
        if v == tempId then
            existFlag = true;
            break;
        end
    end
    if existFlag == false then
        self.m_tSaintStoneIdTable[#self.m_tSaintStoneIdTable + 1] = tempId;
    end
end
--[[--
    更新宝石数据
]]
function M.updateMoreGemDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemCount = jsonData:getNodeCount();
    for i=1,itemCount do
        self:updateOneGemDataByJsonData(jsonData:getNodeAt(i-1));
    end
    self:gemSortByTypeName(self.m_gemSortType);
    cclog("updateMoreGemDataByJsonData ================itemCount " .. itemCount .. " ; #self.m_tGemIdTable == " .. #self.m_tGemIdTable);
    cclog(json.encode(self.m_tGemData))
    cclog(json.encode(self.m_tGemIdTable))
end
--[[--
    更新圣石数据
]]
function M.updateMoreSaintStoneDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemCount = jsonData:getNodeCount();
    for i=1,itemCount do
        self:updateOneSaintStoneDataByJsonData(jsonData:getNodeAt(i-1));
    end
    self:saintStoneSortByTypeName(self.m_gemSortType);
    cclog("updateMoreSaintStoneDataByJsonData ================itemCount " .. itemCount .. " ; #self.m_tGemIdTable == " .. #self.m_tGemIdTable);
    cclog(json.encode(self.m_tSaintStoneData))
    cclog(json.encode(self.m_tSaintStoneIdTable))
end
--[[--
    通过id移除宝石数据
]]
function M.removeOneGemDataById(self,itemId)
    itemId = tostring(itemId);
    local removeIndex = nil;
    for k,v in pairs(self.m_tGemIdTable) do
        if v == itemId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tGemIdTable,removeIndex);
        self.m_tGemData[itemId] = nil;
    end
    if self.m_newGemIdTab[itemId] then
        self.m_newGemIdTab[itemId] = nil;
        self.m_newGemIdTab.count = self.m_newGemIdTab.count - 1;
    end
end
--[[--
    通过id移除圣石数据
]]
function M.removeOneSaintStoneDataById(self,itemId)
    itemId = tostring(itemId);
    local removeIndex = nil;
    for k,v in pairs(self.m_tSaintStoneIdTable) do
        if v == itemId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tSaintStoneIdTable,removeIndex);
        self.m_tSaintStoneData[itemId] = nil;
    end
    if self.m_newSaintStoneIdTab[itemId] then
        self.m_newSaintStoneIdTab[itemId] = nil;
        self.m_newSaintStoneIdTab.count = self.m_newSaintStoneIdTab.count - 1;
    end
end
--[[--
    通过id表格移出宝石数据
]]
function M.removeMoreGemDataByIdTable(self,itemIds)
    for k,v in pairs(itemIds) do
        self:removeOneGemDataById(v);
    end
    cclog("removeMoreGemDataByIdTable #self.m_tGemIdTable ===== " .. #self.m_tGemIdTable)
end

--[[--
    通过id表格移出圣石数据
]]
function M.removeMoreSaintStoneDataByIdTable(self,itemIds)
    -- cclog2(itemIds,"itemIds")
    for k,v in pairs(itemIds) do
        self:removeOneSaintStoneDataById(v);
    end
    -- cclog("removeMoreSaintStoneDataByIdTable #self.m_tGemIdTable ===== " .. #self.m_tGemIdTable)
end
--[[--
    通过 gemType 获得宝石数据
]]
function M.getGemDataByGemType(self,gemType)
    local tempTab = {};
    local tempCfg = getConfig(game_config_field.gem);
    local tempCfgItem = nil;
    local career = nil;
    local itemData = nil;
    gemType = tonumber(gemType or -1)
    gemType = gemType > 2 and 2 or gemType;
    for k,v in pairs(self.m_tGemData) do
        k = tostring(k)
        if v > 0 then
            local _,gemid = game_util:getRealGemLvAndCid(k)
            tempCfgItem = tempCfg:getNodeWithKey(gemid);
            if tempCfgItem then
                career = tempCfgItem:getNodeWithKey("career"):toInt();
                if career ~= 0 then
                    if gemType == -1 then
                        table.insert(tempTab,k)
                    elseif career == gemType then
                        table.insert(tempTab,k)
                    end
                end
            end
        end
    end
    return tempTab;
end
--[[--
    通过 gemType 获得圣石数据
]]
function M.getSaintStoneDataByGemType(self,gemType)
    local tempTab = {};
    local tempCfg = getConfig(game_config_field.god_stone);
    local tempCfgItem = nil;
    local career = nil;
    local itemData = nil;
    gemType = tonumber(gemType or -1)
    gemType = gemType > 2 and 2 or gemType;
    for k,v in pairs(self.m_tSaintStoneData) do
        k = tostring(k)
        if v > 0 then
            -- cclog("id ==================== " .. k)
            tempCfgItem = tempCfg:getNodeWithKey(k);
            if tempCfgItem then
                career = tempCfgItem:getNodeWithKey("career"):toInt();
                if career ~= 0 then
                    if gemType == -1 then
                        table.insert(tempTab,k)
                    elseif career == gemType then
                        table.insert(tempTab,k)
                    end
                end
            end
        end
    end
    return tempTab;
end
--[[--
    通过 gemType 获得神域宝石数据
]]
function M.getGodGemDataByGemType(self,gemType)
    local tempTab = {};
    local tempCfg = getConfig(game_config_field.gem);
    local tempCfgItem = nil;
    local career = nil;
    local itemData = nil;
    gemType = tonumber(gemType or -1)
    gemType = gemType > 2 and 2 or gemType;
    for k,v in pairs(self.m_tGodGemData) do
        k = tostring(k)
        if v > 0 then
            -- cclog("id ==================== " .. k)
            local _,gemid = game_util:getRealGemLvAndCid(k)-----changedByzjr
            tempCfgItem = tempCfg:getNodeWithKey(gemid);
            if tempCfgItem then
                career = tempCfgItem:getNodeWithKey("career"):toInt();
                if career ~= 0 then
                    if gemType == -1 then
                        table.insert(tempTab,k)
                    elseif career == gemType then
                        table.insert(tempTab,k)
                    end
                end
            end
        end
    end
    return tempTab;
end
--圣石
--[[
    获得
]]
function M.getNoUseSaintStoneCountTab(self)
    local tempTab = {0,0,0,0,0}
    -- cclog2(self.m_tGemPosData, "self.m_tGemPosData  ====  ")
    -- cclog2(self.m_tGemData, "self.m_tGemPosData  ====  ")
    -- for k,v in pairs(self.m_tGemPosData) do
    --     for index,id in pairs(v) do
    --         if id ~= "0" then
    --             if index == 1 then
    --                 tempTab[1] = tempTab[1] - 1;
    --             else
    --                 tempTab[2] = tempTab[2] - 1;
    --             end
    --         end
    --     end
    -- end
    local gemCfg = getConfig(game_config_field.god_stone);
    local gemCfgItem = nil;
    local sort = nil;
    for k,itemData in pairs(self.m_tSaintStoneData) do
        gemCfgItem = gemCfg:getNodeWithKey(tostring(k));
        if gemCfgItem then
            sort = gemCfgItem:getNodeWithKey("career"):toInt();
            if sort > 0 and sort < 6 then
                tempTab[sort] = tempTab[sort] + itemData;
            end
        end
    end
   
    tempTab[3] = tempTab[2];
    tempTab[4] = tempTab[2];
    tempTab[5] = tempTab[2];
    -- table.foreach(tempTab,print)
    return tempTab;
end


--[[--
    通过 gemType 获得神域圣石数据
]]
function M.getGodSaintStoneDataByGemType(self,gemType)
    local tempTab = {};
    local tempCfg = getConfig(game_config_field.god_stone);
    local tempCfgItem = nil;
    local career = nil;
    local itemData = nil;
    gemType = tonumber(gemType or -1)
    gemType = gemType > 2 and 2 or gemType;
    for k,v in pairs(self.m_tGodSaintStoneData) do
        k = tostring(k)
        if v > 0 then
            -- cclog("id ==================== " .. k)
            tempCfgItem = tempCfg:getNodeWithKey(k);
            if tempCfgItem then
                career = tempCfgItem:getNodeWithKey("career"):toInt();
                if career ~= 0 then
                    if gemType == -1 then
                        table.insert(tempTab,k)
                    elseif career == gemType then
                        table.insert(tempTab,k)
                    end
                end
            end
        end
    end
    return tempTab;
end
--[[
    获得
]]
function M.getNoUseGemCountTab(self)
    local tempTab = {0,0,0,0}
    -- cclog2(self.m_tGemPosData, "self.m_tGemPosData  ====  ")
    -- cclog2(self.m_tGemData, "self.m_tGemPosData  ====  ")
    -- for k,v in pairs(self.m_tGemPosData) do
    --     for index,id in pairs(v) do
    --         if id ~= "0" then
    --             if index == 1 then
    --                 tempTab[1] = tempTab[1] - 1;
    --             else
    --                 tempTab[2] = tempTab[2] - 1;
    --             end
    --         end
    --     end
    -- end
    local gemCfg = getConfig(game_config_field.gem);
    local gemCfgItem = nil;
    local sort = nil;
    for k,itemData in pairs(self.m_tGemData) do
        local _,gemid = game_util:getRealGemLvAndCid(k)-----changedByzjr
        gemCfgItem = gemCfg:getNodeWithKey(tostring(gemid));
        if gemCfgItem then
            sort = gemCfgItem:getNodeWithKey("career"):toInt();
            if sort > 0 and sort < 5 then
                tempTab[sort] = tempTab[sort] + itemData;
            end
        end
    end
    tempTab[3] = tempTab[2];
    tempTab[4] = tempTab[2];
    -- table.foreach(tempTab,print)
    return tempTab;
end

--[[
    获得神域宝石
]]
function M.getNoUseGodGemCountTab(self)
    local tempTab = {0,0,0,0}
    -- cclog2(self.m_tGemPosData, "self.m_tGemPosData  ====  ")
    -- cclog2(self.m_tGemData, "self.m_tGemPosData  ====  ")
    -- for k,v in pairs(self.m_tGemPosData) do
    --     for index,id in pairs(v) do
    --         if id ~= "0" then
    --             if index == 1 then
    --                 tempTab[1] = tempTab[1] - 1;
    --             else
    --                 tempTab[2] = tempTab[2] - 1;
    --             end
    --         end
    --     end
    -- end
    local gemCfg = getConfig(game_config_field.gem);
    local gemCfgItem = nil;
    local sort = nil;
    for k,itemData in pairs(self.m_tGodGemData) do
        gemCfgItem = gemCfg:getNodeWithKey(tostring(k));
        if gemCfgItem then
            sort = gemCfgItem:getNodeWithKey("career"):toInt();
            if sort > 0 and sort < 5 then
                tempTab[sort] = tempTab[sort] + itemData;
            end
        end
    end
    tempTab[3] = tempTab[2];
    tempTab[4] = tempTab[2];
    -- table.foreach(tempTab,print)
    return tempTab;
end
--[[------------------------------------宝石相关 end------------------------------------------- ]]

--[[------------------------------------英魂相关 start------------------------------------------- ]]
--[[
    设置英魂位置信息
]]
function M.setSoulPosDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tSoulPosData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setSoulPosDataByJsonData ================ " .. json.encode(self.m_tSoulPosData));
end

--[[
    获取英魂位置信息
]]
function M.getSoulPos(self)
    return self.m_tSoulPosData
end

--[[
    设置英魂位置信息
]]
function M.setSoulPos(self,tempPos)
    self.m_tSoulPosData = tempPos
end
--[[
    设置英魂信息
]]
function M.setSoulDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tSoulData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setSoulDataByJsonData ================ " .. json.encode(self.m_tSoulData));
end
--[[--
    通过json数据设置英魂分类数据
]]
function M.setSoulSortDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tSoulSortData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setSoulSortDataByJsonData ================ ");
end

--[[
    获取英魂信息
]]
function M.getSoulData(self)
    return self.m_tSoulData
end
--[[
    设置英魂信息
]]
function M.setSoulData(self,tempData)
    self.m_tSoulData = tempData
end

--[[--
    更新英魂数据
]]
function M.updateOneSoulDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemData = json.decode(jsonData:getFormatBuffer());
    local soulId = jsonData:getKey();
    if self.m_tSoulData[soulId] == nil then
        self.m_tSoulIdTable[#self.m_tSoulIdTable + 1] = soulId
        local soulCfg = getConfig(game_config_field.soul_detail);
        local soulItemCfg = soulCfg:getNodeWithKey(tostring(itemData.soul_id));
        if soulItemCfg and soulItemCfg:getNodeWithKey("quality"):toInt() > 2  then
            self.m_newSoulIdTab[soulId] = 1;
            self.m_newSoulIdTab.count = self.m_newSoulIdTab.count + 1;
        end
    end
    self.m_tSoulData[soulId] = itemData;
end
--[[--
    更新英魂数据
]]
function M.updateMoreSoulDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemCount = jsonData:getNodeCount();
    for i=1,itemCount do
        self:updateOneSoulDataByJsonData(jsonData:getNodeAt(i-1));
    end
    self:soulSortByTypeName(self.m_soulSortType);
    cclog("updateMoreSoulDataByJsonData ================itemCount " .. itemCount .. " ; #self.m_tSoulIdTable == " .. #self.m_tSoulIdTable);
    -- cclog(json.encode(self.m_tEquipData))
    -- cclog(json.encode(self.m_tEquipIdTable))
end
--[[--
    soul数据排序
]]
function M.soulSortByTypeName(self,typeName)

-- 默认：1宝石是否宝石状态，2宝石ID，3宝石等级
-- 等级：1宝石等级，2宝石品质,3宝石ID
-- 品质：1宝石品质，2宝石ID，3宝石等级
-- 类型：1宝石类型，2宝石品质，3宝石ID，4宝石等级

    self.m_soulSortType = typeName;
    self:soulSortByTypeNameWithTable(typeName,self.m_tSoulIdTable)
    cclog("soulSortByTypeName ----------------------------------" .. typeName)
    -- table.foreach(self.m_tGemData,print)
end

--根据筛选出的装备数据，再排序
function M.soulSortByTypeNameWithTable(self,typeName,idDataTable)
    
end

--[[--
    获得当前排序
]]
function M.getSoulSortType(self)
    return self.m_soulSortType;
end
--[[--
    通过id移除英魂数据
]]
function M.removeOneSoulDataById(self,itemId)
    itemId = tostring(itemId);
    local removeIndex = nil;
    for k,v in pairs(self.m_tSoulIdTable) do
        if v == itemId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tSoulIdTable,removeIndex);
        self.m_tSoulData[itemId] = nil;
    end
    if self.m_newSoulIdTab[itemId] then
        self.m_newSoulIdTab[itemId] = nil;
        self.m_newSoulIdTab.count = self.m_newSoulIdTab.count - 1;
    end
end
--[[--
    通过id表格移出英魂数据
]]
function M.removeMoreSoulDataByIdTable(self,itemIds)
    for k,v in pairs(itemIds) do
        self:removeOneSoulDataById(v);
    end
    cclog("removeMoreSoulDataByIdTable #self.m_tSoulIdTable ===== " .. #self.m_tSoulIdTable)
end

--[[--
    通过json数据设置英魂数据
]]
function M.setSoulDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tSoulData = json.decode(jsonData:getFormatBuffer()) or {};
    if self.m_tSoulData ~= nil and type(self.m_tSoulData) == "table" then
        for k,v in pairs(self.m_tSoulData) do
            self.m_tSoulIdTable[#self.m_tSoulIdTable + 1] = k;
        end
    end
    self:soulSortByTypeName(self.m_gemSortType);
    --cclog("setSoulDataByJsonData ================ count " .. #self.m_tSoulIdTable);
end

--[[--
    通过 soulType 获得英魂数据
]]
function M.getSoulDataByEquipType(self,soulType)
    local tempTab = {};
    local soulCfg = getConfig(game_config_field.soul);
    local soulCfgItem = nil;
    local sort = nil;
    local itemData = nil;
    for k,v in pairs(self.m_tSoulIdTable) do
        v = tostring(v)
        itemData = self.m_tSoulData[v];
        -- cclog("id ==================== " .. v)
        if itemData then
            soulCfgItem = soulCfg:getNodeWithKey(itemData.c_id);
            sort = soulCfgItem:getNodeWithKey("sort"):toInt();
            if soulCfgItem ~= nil and sort ~= 0 then
                if soulType == nil then
                    tempTab[#tempTab + 1] = v;
                else
                    soulType = tonumber(soulType);
                    if soulType == -1 then
                        tempTab[#tempTab + 1] = v;
                    elseif sort == equipType then
                        tempTab[#tempTab + 1] = v;
                    end
                end
            end
        end
    end
    return tempTab;
end
--[[
    英魂数量
]]
function M.getSoulCount( self )
    return #self.m_tSoulIdTable;
end

--[[
    英魂
]]
function M.getSoulIdTable( self )
    return self.m_tSoulIdTable or {};
end

--[[
    通过id获得英魂数据
]]
function M.getSoulDataById(self,soulId)
    soulId = tostring(soulId)
    -- cclog2(self.m_tSoulData, "m_tSoulData  ====  ")
    local soulData = self.m_tSoulData[soulId];
    if soulData == nil then
        return nil,nil
    end
    local soulCfg = getConfig(game_config_field.soul_detail);
    local soulItemCfg = soulCfg:getNodeWithKey(tostring(soulData.s_id));
    return soulData,soulItemCfg;
end

--[[
    通过 index 获得英魂数据
]]
function M.getSoulDataByIndex( self,index )
    if index >0 and index <= #self.m_tSoulIdTable then
        return self:getSoulDataById(self.m_tSoulIdTable[index]);
    end
    return nil,nil;
end

--[[
    获得英魂容器的大小
]]
function M.getSoulBackpackNum( self )
    local soul_max=self.m_tUserStatusData["soul_max"] or 0;
    return soul_max;
end
--[[
    获得英魂容器的可用个数
]]
function M.getAvailableSoulBackpackNum( self )
    local soul_max=self.m_tUserStatusData["soul_max"] or 0;
    local soul_num=self:getSoulCount();
    return soul_max - soul_num;
end

--[[--
    判断英魂是否装备上
]]
function M.soulInSoulPos(self,soulId,flag)
    soulId = tostring(soulId);
    local existFlag = false;
    local cardName = "";
    local soulPosData = {}
    -- local formationId = self.m_tFormationData.current
    local soulPosData = game_data:getSoulPos()
    cclog2(soulPosData,"soulPosData~~~=")
    for pos,soulData in pairs(soulPosData) do
        for k,v in pairs(soulData) do
            if soulId == v then
                -- cclog2(self.m_tTeamData,"self.m_tTeamData")
                -- cclog2(k,"k")
                existFlag = true
                local key = tonumber(pos) + 1
                 cclog2(key,"key~~~=")
                local cardId = self.m_tTeamData[key]
                cclog2(cardId,"cardi~~~=")
                -- cclog2(cardId,"cardId")
                local cardData,cardCfg = self:getCardDataById(cardId);
                cclog2(cardCfg,"cardCfg~~~~")
                cclog2(cardData,"cardData~~~~")
                if cardCfg then
                    cardName = cardCfg:getNodeWithKey("name"):toStr();
                    cclog2(cardName,"cardName~~")
                else
                    cardName = "Đã trang bị"  --Đã trang bị
                end
                break
            end
        end
    end
    return existFlag,cardName,posEquipData
end


--[[------------------------------------英魂相关 end------------------------------------------- ]]

--[[------------------------------------转世 start------------------------------------------- ]]

function M.setZhuanshiTask1Data( self,zhuanshiData )
    -- body
    self.m_zhuanshiTask1Data = zhuanshiData
end
function M.getZhuanshiTask1Data( self )
    -- body
    return self.m_zhuanshiTask1Data
end
function M.setZhuanshiCardId( self,zhuanshiId )
    self.zhuanshiId = zhuanshiId
end
function M.getZhuanshiCardId( self)
    return self.zhuanshiId
end
--[[------------------------------------转世相关 end------------------------------------------- ]]


--[[------------------------------------神域相关 start------------------------------------------- ]]
function M.setGodfieldData( self,m_godfieldData )
    self.m_godfieldData = m_godfieldData
    --cclog2(self.m_godfieldData,"self.m_godfieldData == ")
end
function M.getGodfieldData( self )
    return self.m_godfieldData
end
--[[-- 
    通过json数据设置神域卡牌位置数据
]]
function M.setGodCardsPosByJsonData( self,jsonData )
    -- body
    if jsonData == nil then return end
    self.m_tGodTeamData = json.decode(jsonData:getFormatBuffer()) or {};
    --cclog("setGodCardsPosByJsonData ================ " .. json.encode(self.m_tGodTeamData));
end

--[[-- 
    通过json数据设置神域阵型1卡牌位置装备数据
]]
function M.setGodEquipPosDataByJsonData1( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodEquipData1 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodEquipPosDataByJsonData1 ================ " .. json.encode(self.m_tGodEquipData1));

end

--[[-- 
    通过json数据设置神域阵型2卡牌位置装备数据
]]
function M.setGodEquipPosDataByJsonData2( self,jsonData)
    if jsonData == nil then return end
    self.m_tGodEquipData2 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodEquipPosDataByJsonData2 ================ " .. json.encode(self.m_tGodEquipData2));

end

--[[-- 
    通过json数据设置神域阵型2卡牌位置装备数据
]]
function M.setGodEquipPosDataByJsonData3( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodEquipData3 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodEquipPosDataByJsonData3 ================ " .. json.encode(self.m_tGodEquipData3));

end

--[[-- 
    通过json数据设置神域阵型1卡牌位置宝石数据
]]
function M.setGodGemPosDataByJsonData1( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodGemData1 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodGemPosDataByJsonData1 ================ " .. json.encode(self.m_tGodGemData1));

end
--[[-- 
    通过json数据设置神域阵型1卡牌位置圣石数据
]]
function M.setGodSaintStonePosDataByJsonData1( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodSaintStoneData1 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodGemPosDataByJsonData1 ================ " .. json.encode(self.m_tGodGemData1));

end
--[[-- 
    通过json数据设置神域阵型2卡牌位置宝石数据
]]
function M.setGodGemPosDataByJsonData2( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodGemData2 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodGemPosDataByJsonData2 ================ " .. json.encode(self.m_tGodGemData2));

end
--[[-- 
    通过json数据设置神域阵型2卡牌位置圣石数据
]]
function M.setGodSaintStonePosDataByJsonData2( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodSaintStoneData2 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodGemPosDataByJsonData1 ================ " .. json.encode(self.m_tGodGemData1));

end

--[[-- 
    通过json数据设置神域阵型3卡牌位置宝石数据
]]
function M.setGodGemPosDataByJsonData3( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodGemData3 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodGemPosDataByJsonData3 ================ " .. json.encode(self.m_tGodGemData3));

end
--[[-- 
    通过json数据设置神域阵型3卡牌位置圣石数据
]]
function M.setGodSaintStonePosDataByJsonData3( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodSaintStoneData3 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodGemPosDataByJsonData1 ================ " .. json.encode(self.m_tGodGemData1));

end
function M.getGodGemIdTab( self)
    -- body
    local GemIdTab = {};
    if self.m_tGodGemData1 == nil or self.m_tGodGemData2 == nil or self.m_tGodGemData3 == nil then
        return
    end
    GemIdTab{self.m_tGodGemData1,self.m_tGodGemData2,self.m_tGodGemData3}
    return GemIdTab;
end
--[[--
    得到神域卡牌位置数据
]]
function M.getGodCardsPosData( self )
    return self.m_tGodTeamData;
end

--[[--
    得到神域阵型1卡牌位置装备数据
]]
function M.getGodEquipPosData1( self )
    return self.m_tGodEquipData1;
end

--[[--
    得到神域阵型2卡牌位置装备数据
]]
function M.getGodEquipPosData2( self )
    return self.m_tGodEquipData2;
end

--[[--
    得到神域卡牌位置装备数据
]]
function M.getGodEquipPosData3( self )
    return self.m_tGodEquipData3;
end

--[[--
    得到神域阵型1卡牌位置宝石数据
]]
function M.getGodGemPosData1( self )
    return self.m_tGodGemData1;
end
--[[--
    得到神域阵型1卡牌位置宝石数据
]]
function M.getGodGemPosData2( self )
    return self.m_tGodGemData2;
end
--[[--
    得到神域阵型1卡牌位置宝石数据
]]
function M.getGodGemPosData3( self )
    return self.m_tGodGemData3;
end

--[[--
    判断是否装备上
]]
function M.godequipInEquipPos(self,equipType,equipId)
    equipId = tostring(equipId);
    local godexistFlag = false;
    local posEquipData = nil;
    local m_tEquipPosData1 = self:getGodEquipPosData1();
    local m_tEquipPosData2 = self:getGodEquipPosData2();
    local m_tEquipPosData3 = self:getGodEquipPosData3();
    
    if equipType ~= nil and equipId ~= nil then
        for i=1,10 do
            if tostring(m_tEquipPosData1[tostring(i-1)][equipType]) == equipId  then
                godexistFlag = true
                break;
            end

            if tostring(m_tEquipPosData2[tostring(i-1)][equipType]) == equipId then
                godexistFlag = true
                break;
            end
            if tostring(m_tEquipPosData3[tostring(i-1)][equipType]) == equipId then
                godexistFlag = true
                break;
            end
        end   
    end
    return godexistFlag
end

--[[--
    圣殿卡牌数据
]]
function M.setGodTempleCard( self,cardTab )
    self.m_godTempleCardData = cardTab
    -- body
end
function M.getGodTempleCard( self )
    return self.m_godTempleCardData
    -- body
end

--[[--
    判断英雄是否在圣殿里面
]]
function M.godTempleheroInTeamById(self,heroId)
    if self.m_godTempleCardData and next(self.m_godTempleCardData) then
        for k,v in pairs(self.m_godTempleCardData) do
            -- cclog2(self.m_tGodTeamData[i],"self.m_tGodTeamData[i]====22=333=")
            if tostring(v) == tostring(heroId) then
                return true;
            end
        end
        return false;
    else
        return false;
    end
    
end

--[[--
    缓存战斗力
]]
function M.setGodCombat( self,jsonData ,index)
    if jsonData == nil then return end
    local godCombat = jsonData or {};
    self.godAllCombat[tonumber(index)] = godCombat;
    cclog("setgodCombatsetgodCombatsetgodCombat ================ " .. json.encode(self.godAllCombat));

end

--[[--
    获取战斗力
]]
function M.getGodCombat( self )
    return self.godAllCombat;
end

function M.getCardsDataSimple( self,cardsTable,falg )
    local newCardTab = {}
    local purpleTab = {}
    local orangeTab = {}
    local redTab = {}
    local goldTab = {} 
    local yuanTab = {}
    local shenTab = {}
    local myTab = {}
    if cardsTable and next(cardsTable) then
        myTab = cardsTable
    else
        myTab = self.m_tCardsIdTable
    end

    local i = 1
    for k,v in pairs(myTab) do
        local uid = string.sub(v,1,3)
        if game_data:heroInTeamById(v) or game_data:heroInAssistantById(v) or game_data:godheroInTeamById(v) or game_data:godTempleheroInTeamById(v) then
        elseif uid == "50-" then
            table.insert(purpleTab,v)
        elseif uid == "51-" then 

            table.insert(orangeTab,v)

        elseif uid == "52-" then
            -- redTab[v] = v
            table.insert(redTab,v)

        elseif uid == "53-" then
            -- goldTab[v] = v
            table.insert(goldTab,v)

        elseif uid == "54-" then 
            -- yuanTab[v] = v
            table.insert(yuanTab,v)

        elseif uid == "55-" then
            -- shenTab[v] = v
            table.insert(shenTab,v)

        else
            newCardTab[i] = v
            i = i+1
        end
    end
    for k,v in pairs(myTab) do
        if game_data:heroInTeamById(v) or game_data:heroInAssistantById(v) or game_data:godheroInTeamById(v) or  game_data:godTempleheroInTeamById(v) then
            table.insert(newCardTab,v)
        end
    end
    if falg == true then

        if next(purpleTab) then
            table.insert(newCardTab,purpleTab[1])
        end
        if next(orangeTab) then
            table.insert(newCardTab,orangeTab[1])
        end
        if next(redTab) then
            table.insert(newCardTab,redTab[1])
        end
        if next(goldTab) then
            table.insert(newCardTab,goldTab[1])
        end
        if next(yuanTab) then
            table.insert(newCardTab,yuanTab[1])
        end
        if next(shenTab) then
            table.insert(newCardTab,shenTab[1])
        end
    end
    self:cardsSortByTypeNameWithTable("default",newCardTab);
    return newCardTab,#purpleTab,#orangeTab,#redTab,#goldTab,#yuanTab,#shenTab

    -- body
end

--[[--
    获取卡牌数据，剔除名人堂和助威阵法中的角色
]]
function M.getCardsDataSimpleFiltered( self,cardsTable,falg )
    -- 先获取原始数据
    local newCardsTab, purpleCount, orangeCount, redCount, goldCount, yuanCount, shenCount = self:getCardsDataSimple(cardsTable, falg)
    
    -- 获取名人堂数据
    local famousAllData = game_data:getFamousAllData() or {}
    
    -- 剔除在名人堂和阵法加成中的角色
    local filteredTab = {}
    for _, id in ipairs(newCardsTab) do
        -- 检查是否在名人堂中
        local inFamous = false
        if famousAllData[id] then
            if type(famousAllData[id]) == "table" then
                -- 如果是table类型，检查第二个元素是否不为空
                inFamous = famousAllData[id][2] and famousAllData[id][2] ~= ""
            elseif famousAllData[id] == 1 then
                inFamous = true
            end
        end
        -- 检查是否在阵法add加成中
        local inFormationBonus = game_util:isInFormationBonusAdd(id)
        
        if not inFamous and not inFormationBonus then
            filteredTab[#filteredTab + 1] = id
        else
            -- -- 输出被剔除的角色信息
            -- local _, cardCfg = game_data:getCardDataById(id)
            -- local cardName = cardCfg and cardCfg:getNodeWithKey("name"):toStr() or "未知"
            -- local reason = ""
            -- if inFamous then
                --     reason = reason .. "名人堂"
            -- end
            -- if inFormationBonus then
                --     if reason ~= "" then
                    --         reason = reason .. "+"
                --     end
                --     reason = reason .. "阵法(" .. tostring(inFormationBonus) .. ")"
            -- end
            -- cclog("[getCardsDataSimpleFiltered] 剔除角色ID: " .. id .. ", 名字: " .. cardName .. ", 原因: " .. reason)
        end
    end
    
    return filteredTab, purpleCount, orangeCount, redCount, goldCount, yuanCount, shenCount
end

function M.setCailiaoCardTab(  self,tab,sortType,sortType2 )
    self.m_cailiaoTempCard = tab
    cclog2(self.m_cailiaoTempCard,"11111111111111111111")
    if sortType then
        -- self:cardsSortByTypeNameWithTable(sortType,self.m_cailiaoTempCard);
        self:cardsSortByTypeNameWithTable2(sortType,self.m_cailiaoTempCard);
    elseif sortType and sortType2 then
        self:cardsSortByTypeNameWithTable3(sortType,sortType,self.m_cailiaoTempCard);
    end
end
function M.getCailiaoCardTab( self,sortType,sortType2)
    
    if sortType then
        -- self:cardsSortByTypeNameWithTable(sortType,self.m_cailiaoTempCard);
        self:cardsSortByTypeNameWithTable2(sortType,self.m_tkapaiData);
    elseif sortType and sortType2 then
        self:cardsSortByTypeNameWithTable3(sortType,sortType,self.m_tkapaiData);
    end

    return self.m_tkapaiData
end

-- 噩梦之塔
function M.setNightmareSelectBuildIndex( self,m_nightmare_selectBuild_index )
    self.m_nightmare_selectBuild_index = m_nightmare_selectBuild_index
end

function M.getNightmareSelectBuildIndex( self,m_nightmare_selectBuild_index )
    return self.m_nightmare_selectBuild_index
end

function M.setNightmareReward( self,reward )
    self.m_nightmare_reward = reward  or {}
end

function M.getNightmareReward( self)
    return self.m_nightmare_reward
end

--[[
    设置神域英魂位置信息
]]
function M.setGodSoulPosDataByJsonData1(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodSoulPosData1 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodSoulPosDataByJsonData1 ================ " .. json.encode(self.m_tGodSoulPosData1));
end
--[[
    设置神域英魂位置信息
]]
function M.setGodSoulPosDataByJsonData2(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodSoulPosData2 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodSoulPosDataByJsonData2 ================ " .. json.encode(self.m_tGodSoulPosData2));
end
--[[
    设置神域英魂位置信息
]]
function M.setGodSoulPosDataByJsonData3(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodSoulPosData3 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodSoulPosDataByJsonData3 ================ " .. json.encode(self.m_tGodSoulPosData3));
end

--[[
    设置神域勋章位置信息
]]
function M.setGodMedalPosDataByJsonData1(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodMedalPosData1 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodMedalPosDataByJsonData1 ================ " .. json.encode(self.m_tGodMedalPosData1));
end

--[[
    设置神域勋章位置信息
]]
function M.setGodMedalPosDataByJsonData2(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodMedalPosData2 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodMedalPosDataByJsonData2 ================ " .. json.encode(self.m_tGodMedalPosData2));
end
--[[
    设置神域勋章位置信息
]]
function M.setGodMedalPosDataByJsonData3(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodMedalPosData3 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodMedalPosDataByJsonData3 ================ " .. json.encode(self.m_tGodMedalPosData3));
end

--[[
    设置神域宝石位置信息
]]
function M.setGodGemPosDataByJsonData1(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodGemPosData1 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("m_tGodGemPosData1 ================ " .. json.encode(self.m_tGodGemPosData1));
end

--[[
    设置神域宝石位置信息
]]
function M.setGodGemPosDataByJsonData2(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodGemPosData2 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodGemPosDataByJsonData2 ================ " .. json.encode(self.m_tGodGemPosData2));
end
--[[
    设置神域宝石位置信息
]]
function M.setGodGemPosDataByJsonData3(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodGemPosData3 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodGemPosDataByJsonData3 ================ " .. json.encode(self.m_tGodGemPosData3));
end
--[[--
    得到神域阵型1卡牌位置英魂数据
]]
function M.getGodSoulPosData1( self )
    return self.m_tGodSoulPosData1;
end

--[[--
    得到神域阵型2卡牌位置英魂数据
]]
function M.getGodSoulPosData2( self )
    return self.m_tGodSoulPosData2;
end

--[[--
    得到神域阵型3卡牌位置英魂数据
]]
function M.getGodSoulPosData3( self )
    return self.m_tGodSoulPosData3;
end

--[[--
    得到神域阵型1卡牌位置勋章数据
]]
function M.getGodMedalPosData1( self )
    return self.m_tGodMedalPosData1;
end

--[[--
    得到神域阵型2卡牌位置勋章数据
]]
function M.getGodMedalPosData2( self )
    return self.m_tGodMedalPosData2;
end
--[[--
    得到神域阵型3卡牌位置勋章数据
]]
function M.getGodMedalPosData3( self )
    return self.m_tGodMedalPosData3;
end
--[[--
    设置神域所有英魂数据
]]
function M.setAllGodSoulPosData( self,tempData )
    self.m_tAllGodSoulPosData = tempData;
end

--[[--
    设置神域所有勋章数据
]]
function M.setAllGodMedalPosData( self,tempData )
    self.m_tAllGodMedalPosData = tempData;
end
--[[--
    设置神域所有圣石数据
]]
function M.setAllGodSaintStonePosData( self,tempData )
    self.m_tAllGodSaintStonePosData = tempData;
end
--[[--
    设置神域所有圣石数据
]]
function M.getAllGodSaintStonePosData( self )
    return self.m_tAllGodSaintStonePosData;
end

--[[--
    设置神域所有圣石数据
]]
function M.getAllGodGemPosData( self )
    return self.m_tAllGodGemPosData;
end


--[[--
    设置神域所有英魂数据
]]
function M.setOneGodSoulPosData( self,tempData,index)
    self.m_tAllGodSoulPosData[index] = tempData;
end

--[[--
    设置神域所有勋章数据
]]
function M.setOneGodMedalPosData( self,tempData,index)
    self.m_tAllGodMedalPosData[index] = tempData;
end

--[[--
    得到神域所有英魂数据
]]
function M.getAllGodSoulPosData( self )
    return self.m_tAllGodSoulPosData;
end
--[[--
    得到神域所有勋章数据
]]
function M.getAllGodMedalPosData( self )
    return self.m_tAllGodMedalPosData;
end
--[[--
    得到神域所有英魂数据
]]
function M.getOneGodSoulPosData( self,index )
    return self.m_tAllGodSoulPosData[index];
end

--[[--
    得到神域所有勋章数据
]]
function M.getOneGodMedalPosData( self,index )
    return self.m_tAllGodMedalPosData[index];
end

--[[--
    判断英魂是否装备上
]]
function M.soulInGodSoulPos(self,soulId)
    soulId = tostring(soulId);
    local existFlag = false;
    local cardName = "";
    local soulPosData2 = {}
    local soulPosData2 = game_data:getAllGodSoulPosData();
    -- local Numtab = {"一","二","三"}
    local Numtab = {"1","2","3"}

    for i=1,3 do
        for pos,soulData in pairs(soulPosData2[i]) do
            for k,v in pairs(soulData) do
                if soulId == v then
                    -- cclog2(self.m_tTeamData,"self.m_tTeamData")
                    -- cclog2(k,"k")
                    existFlag = true
                    local key = tonumber(pos) + 1
                    local cardId = self.m_tGodTeamData[tostring(i)][key]
                    local cardData,cardCfg = self:getCardDataById(cardId);
                    if cardCfg then
                        cardName = cardCfg:getNodeWithKey("name"):toStr();
                    else
                        -- cardName = "阵型"..Numtab[i].. " " .. key .."号位".."\n     已装备"
                        cardName = "Trận hình"..Numtab[i].. " " .. key .."Số".."\n     Đã trang bị"
                    end
                    break
                end
            end
        end
    end
    
    return existFlag,cardName,posEquipData
end

--[[--
    更新宝石数据
]]
function M.updateOneGodGemDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    -- local itemData = json.decode(jsonData:getFormatBuffer());
    local itemData = jsonData:toInt();
    local tempId = jsonData:getKey();
    if self.m_tGodGemData[tempId] == nil then
        -- self.m_tGemIdTable[#self.m_tGemIdTable + 1] = tempId
        self.m_newGodGemIdTab[tempId] = 1;
        self.m_newGodGemIdTab.count = self.m_newGodGemIdTab.count + 1;
    end
    self.m_tGodGemData[tempId] = itemData;
    local existFlag = false;
    for k,v in pairs(self.m_tGodGemIdTable) do
        if v == tempId then
            existFlag = true;
            break;
        end
    end
    if existFlag == false then
        self.m_tGodGemIdTable[#self.m_tGodGemIdTable + 1] = tempId;
    end
end
--[[--
    更新圣石数据
]]
function M.updateOneGodSaintStoneDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    -- local itemData = json.decode(jsonData:getFormatBuffer());
    local itemData = jsonData:toInt();
    local tempId = jsonData:getKey();
    if self.m_tGodSaintStoneData[tempId] == nil then
        -- self.m_tGemIdTable[#self.m_tGemIdTable + 1] = tempId
        self.m_newGodSaintStoneIdTab[tempId] = 1;
        self.m_newGodSaintStoneIdTab.count = self.m_newGodSaintStoneIdTab.count + 1;
    end
    self.m_tGodSaintStoneData[tempId] = itemData;
    local existFlag = false;
    for k,v in pairs(self.m_tGodSaintStoneIdTable) do
        if v == tempId then
            existFlag = true;
            break;
        end
    end
    if existFlag == false then
        self.m_tGodSaintStoneIdTable[#self.m_tGodSaintStoneIdTable + 1] = tempId;
    end
end
--[[--
    更新宝石数据
]]
function M.updateMoreGodGemDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemCount = jsonData:getNodeCount();
    for i=1,itemCount do
        self:updateOneGodGemDataByJsonData(jsonData:getNodeAt(i-1));
    end
    self:gemSortByTypeName(self.m_gemSortType);
    cclog("updateMoreGodGemDataByJsonData ================itemCount " .. itemCount .. " ; #self.m_tGodGemIdTable == " .. #self.m_tGodGemIdTable);
    cclog(json.encode(self.m_tGodGemData))
    cclog(json.encode(self.m_tGodGemIdTable))
end
--[[--
    更新圣石数据
]]
function M.updateMoreGodSaintStoneDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemCount = jsonData:getNodeCount();
    for i=1,itemCount do
        self:updateOneGodSaintStoneDataByJsonData(jsonData:getNodeAt(i-1));
    end
    self:saintStoneSortByTypeName(self.m_SaintStoneSortType);
    cclog("updateMoreGodGemDataByJsonData ================itemCount " .. itemCount .. " ; #self.m_tGodGemIdTable == " .. #self.m_tGodGemIdTable);
   
end
--[[--
    通过id移除宝石数据
]]
function M.removeOneGodGemDataById(self,itemId)
    itemId = tostring(itemId);
    local removeIndex = nil;
    for k,v in pairs(self.m_tGodGemIdTable) do
        if v == itemId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tGodGemIdTable,removeIndex);
        self.m_tGodGemData[itemId] = nil;
    end
    if self.m_newGodGemIdTab[itemId] then
        self.m_newGodGemIdTab[itemId] = nil;
        self.m_newGodGemIdTab.count = self.m_newGodGemIdTab.count - 1;
    end
end
--[[--
    通过id表格移出宝石数据
]]
function M.removeMoreGodGemDataByIdTable(self,itemIds)
    cclog2(itemIds,"itemIds")
    for k,v in pairs(itemIds) do
        self:removeOneGodGemDataById(v);
    end
    cclog("removeMoreGodGemDataByIdTable #self.m_tGemIdTable ===== " .. #self.m_tGodGemIdTable)
end

--[[--
    更新神域勋章数据
]]
function M.updateMoreGodMedalDataByJsonData(self,medalJsonData)
    if medalJsonData == nil then return end
    -- local medalCount = medalJsonData:getNodeCount();
    local medalData = json.decode(medalJsonData:getFormatBuffer())
    for k,v in pairs(medalData) do
        self.m_tGodMedalIdData[tostring(k)] = v
    end
    -- cclog2(medalJsonData:getNodeAt(0),"kkk")
    -- for i=1,medalCount do
    --     self:updateOneMedalDataByJsonData(medalJsonData:getNodeAt(i-1));
    -- end
end

--[[--
    更新神域勋章数据
]]
function M.updateOneGodMedalDataByJsonData(self,medalJsonData)
    if medalJsonData == nil then return end
    local medalKey = medalJsonData:getKey()
    self.m_tGodMedalIdData[tostring(medalKey)] = medalJsonData:getNodeWithKey(tostring(medalKey)):toInt()
end

--[[--
    通过id表格移出神域勋章数据  暂时无勋章的消耗功能
]]
function M.removeMoreGodMedalDataByIdTable(self,tMedalIds)
    -- cclog2(tMedalIds,"tMedalIds")
    for k,v in pairs(tMedalIds) do
        -- self:removeOneMedalDataById(v);
        --直接置为nil
        self.m_tGodMedalIdData[tostring(k)] = nil
    end
    cclog("removeMoreGodMedalDataByIdTable #self.m_tGodMedalIdData ===== " .. #self.m_tGodMedalIdData)
end

--[[--
    通过id移除神域勋章数据
]]
function M.removeOneGodMedalDataById(self,medalId)
    medalId = tostring(medalId);
    local removeIndex = nil;
    for k,v in pairs(self.m_tGodMedalIdData) do
        if v == medalId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tGodMedalIdData,removeIndex);
    end
end


--[[ 
    返回符合要求的card数据   --神域圣殿  
]]--
function M.getCardsDataByGodTemple(self)
    -- local cardsTable = self:getTableCardsData();
    local tempIdTable = {};
    for k,v in pairs(self.m_tCardsData) do
        local cardData,heroCfg = self:getCardDataById(tostring(k));
        if self:heroInTeamById(cardData.id) or self:heroInAssistantById(cardData.id) or self:godheroInTeamById(cardData.id) then
        
        else
            table.insert(tempIdTable,cardData.id);
        end
    end
    return tempIdTable;
end

--[[ 
    返回符合要求的card数据   --品质返回    --专给召唤兽升级的，exchange_id > 0 才给用
]]--
function M.getCardsDataByCombinerQuality(self,quality)
    -- local cardsTable = self:getTableCardsData();
    local tempIdTable = {};
    for k,v in pairs(self.m_tCardsData) do
        local cardData,heroCfg = self:getCardDataById(tostring(k));
        local my_quality = heroCfg:getNodeWithKey("quality"):toInt();
        local exchange_id = heroCfg:getNodeWithKey("exchange_id"):toInt()
        if self:heroInTeamById(cardData.id) or self:heroInAssistantById(cardData.id) or self:godheroInTeamById(cardData.id) or game_util:getCardUserLockFlag(cardData)then

        else
            if my_quality >= quality and exchange_id > 0 then
            table.insert(tempIdTable,tostring(k));
            -- tempIdTable[tostring(k)] = v;
            end
        end
        
    end
    return tempIdTable;
end

--[[ 
    返回符合要求的card数据   --召唤兽材料卡 
]]--
function M.getCardsDataByCombinerTemple(self,cardid)
    -- local cardsTable = self:getTableCardsData();
    local tempIdTable = {};
    for k,v in pairs(self.m_tCardsData) do
        local cardData,heroCfg = self:getCardDataById(tostring(k));
        if self:heroInTeamById(cardData.id) or self:heroInAssistantById(cardData.id) or self:godheroInTeamById(cardData.id) or game_util:getCardUserLockFlag(cardData) or self.m_famousAllData[cardData.id] then
            
        else
            if tostring(cardData.c_id) == tostring(cardid) then
                table.insert(tempIdTable,cardData.id);
            end
        end
    end
    return tempIdTable;
end
--[[--
    判断英雄是否在编队中
]]
function M.godheroInTeamById(self,heroId)
    for i=1,3 do
        for k,v in pairs(self.m_tGodTeamData[tostring(i)]) do
            -- cclog2(self.m_tGodTeamData[i],"self.m_tGodTeamData[i]====22=333=")
            if v ~= "-1" and tostring(v) == tostring(heroId) then
                -- cclog2(i,"i======")
                return true , i;
            end
        end
    end
    
    return false;
end

-- 噩梦之塔
function M.setNightmareSelectBuildIndex( self,m_nightmare_selectBuild_index )
    self.m_nightmare_selectBuild_index = m_nightmare_selectBuild_index
end

function M.getNightmareSelectBuildIndex( self,m_nightmare_selectBuild_index )
    return self.m_nightmare_selectBuild_index
end

function M.setNightmareReward( self,reward )
    self.m_nightmare_reward = reward  or {}
end

function M.getNightmareReward( self)
    return self.m_nightmare_reward
end
   
--[[------------------------------------神域相关 end------------------------------------------- ]]
--[[------------------------------------勋章相关 start------------------------------------------- ]]
--[[
    设置勋章位置信息
]]
function M.setMedalPosDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tMedalPosData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setMedalPosDataByJsonData ================ " .. json.encode(self.m_tMedalPosData));
end

--[[
    获取勋章位置信息
]]
function M.getMedalPos(self)
    return self.m_tMedalPosData
end

--[[
    设置勋章位置信息
]]
function M.setMedalPos(self,tempPos)
    self.m_tMedalPosData = tempPos
end

--[[
    设置勋章信息
]]
function M.setMedalDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tMedalIdData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setMedalDataByJsonData ================ " .. json.encode(self.m_tMedalIdData));
end

--[[
    设置神域勋章信息
]]
function M.setGodMedalDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tGodMedalIdData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("m_tGodMedalIdData ================ " .. json.encode(self.m_tGodMedalIdData));
end

--[[
    获取勋章信息
]]
function M.getMedalData(self)
    return self.m_tMedalIdData
end
--[[
    设置勋章信息
]]
function M.setMedalData(self,tempData)
    self.m_tMedalIdData = tempData
end
--[[
    获取神域勋章信息
]]
function M.getGodMedalData(self)
    return self.m_tGodMedalIdData
end
--[[
    设置神域勋章信息
]]
function M.setGodMedalData(self,tempData)
    self.m_tGodMedalIdData = tempData
end
--[[--
    更新勋章数据
]]
function M.updateMoreMedalDataByJsonData(self,medalJsonData)
    if medalJsonData == nil then return end
    -- local medalCount = medalJsonData:getNodeCount();
    local medalData = json.decode(medalJsonData:getFormatBuffer())
    for k,v in pairs(medalData) do
        self.m_tMedalIdData[tostring(k)] = v
    end
    -- cclog2(medalJsonData:getNodeAt(0),"kkk")
    -- for i=1,medalCount do
    --     self:updateOneMedalDataByJsonData(medalJsonData:getNodeAt(i-1));
    -- end
end

--[[--
    更新勋章数据
]]
function M.updateOneMedalDataByJsonData(self,medalJsonData)
    if medalJsonData == nil then return end
    local medalKey = medalJsonData:getKey()
    self.m_tMedalIdData[tostring(medalKey)] = medalJsonData:getNodeWithKey(tostring(medalKey)):toInt()
end

--[[--
    通过id表格移出勋章数据  暂时无勋章的消耗功能
]]
function M.removeMoreMedalDataByIdTable(self,tMedalIds)
    cclog2(tMedalIds,"tMedalIds")
    for k,v in pairs(tMedalIds) do
        -- self:removeOneMedalDataById(v);
        --直接置为nil
        self.m_tMedalIdData[tostring(k)] = nil
    end
    cclog("removeMoreGemDataByIdTable #self.m_tMedalIdData ===== " .. #self.m_tMedalIdData)
end

--[[--
    通过id移除勋章数据
]]
function M.removeOneMedalDataById(self,medalId)
    medalId = tostring(medalId);
    local removeIndex = nil;
    for k,v in pairs(self.m_tMedalIdData) do
        if v == medalId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tMedalIdData,removeIndex);
    end
end
--[[------------------------------------勋章相关 end------------------------------------------- ]]
--[[------------------------------------新年红包的激活码 start------------------------------------------- ]]
function M.setRedEnvelopeJihuoma( self,jihuoma )
    self.m_redEnvelope_jihuoma = jihuoma
    -- body
end

function M.getRedEnvelopeJihuoma( self )
    -- body
    return self.m_redEnvelope_jihuoma
end

--[[
    随便返回一个符合要求的装备id
]]
function M.getEquipCountByCid2(self,cId,selEquipId)
    local tempCount = 0;
    local tostring = tostring;
    cId = tostring(cId);
    selEquipId = tostring(selEquipId);
    local equipCfg = getConfig(game_config_field.equip);
    for k,v in pairs(self.m_tEquipData) do
        if tostring(v.c_id) == cId and tostring(k) ~= selEquipId then
            local itemCfg = equipCfg:getNodeWithKey(tostring(v.c_id));
            if itemCfg then
                local existFlag,_ = self:equipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),k)
                if not existFlag then
                    -- tempCount = tempCount + 1;
                    return v.id
                end
            end
        end
    end
    return nil;
end

--[[
    获取召唤兽信息
]]
function M.getCombinerData(self)
    return self.m_tCombinerData
end
--[[
    获取召唤兽出战信息
]]
function M.getCombinerfightData(self)
    return self.m_tCombinerfightData
end

--[[
    设置召唤兽出战信息
]]
function M.setCombinerfightData(self,tempData)
    self.m_tCombinerfightData = tempData
end
--[[
    设置所有召唤兽信息
]]
function M.setCombinerData(self,tempData)
    self.m_tCombinerData = tempData
end

--[[
    设置当前召唤兽信息
]]
function M.setOneCombinerData(self,tempData,selnum)
    self.m_tCombinerData[tostring(selnum)] = tempData
end
--[[-------------------------------------  神域星宫 start -------------------------------------]]
function M:setGod_Star_check_msg( checkData,where )
    self.m_god_Star_check_msg = checkData
    -- cclog(where," --------------------- set")
    -- cclog2(self.god_Star_check_msg)
end
function M:getGod_Star_check_msg( where )
    -- cclog(where," --------------------- get")
    -- cclog2(self.god_Star_check_msg)
    return self.m_god_Star_check_msg
end


--  floor (星宫)        squad (阵型)      team (队伍)
function M:setGod_Boss_battle_msg( team,where )
    self.m_god_Boss_battle_team = team
    -- cclog(where," --------------------- set")
    -- cclog2(self.god_Boss_battle_team)
end

function M:getGod_Boss_battle_msg( where )
    -- cclog(where," --------------------- get")
    -- cclog2(self.god_Boss_battle_team)
    return self.m_god_Boss_battle_team
end

function M:setGod_Boss_rank_msg( team,check_floor,where )
    self.m_god_Boss_rank_team = team
    self.m_check_floor = check_floor
    -- cclog(where," --------------------- set")
    -- cclog2(self.god_Boss_battle_team)
end

function M:getGod_Boss_rank_msg( where )
    -- cclog(where," --------------------- get")
    -- cclog2(self.god_Boss_rank_team)
    return self.m_god_Boss_rank_team,self.m_check_floor
end


--[[-------------------------------------  神域星宫 end -------------------------------------]]
--[[------------------------------------公会副本相关 start------------------------------------------- ]]
--[[--
    设置公会编队id
]]

function M.setGuildTeamData(self,tempData,where)
    cclog2(where,"where ===== ")
    self.m_tGuildTeamData = tempData;
end

--[[--
    获得公会自己编队id
]]
function M.getGuildTeamData(self)
    return self.m_tGuildTeamData;
end
function M.setGuildTeamData2(self,tempData,where)
    cclog2(where,"where ===== ")
    self.m_tGuildTeamData2 = tempData;
end

--[[--
    获得公会自己编队id
]]
function M.getGuildTeamData2(self)
    return self.m_tGuildTeamData2;
end
--[[--
    判断工会雇佣英雄是否在编队中 
]]
function M.heroInGuildTeamById(self,heroId)
    local tempIdTab = self:getGuildSelTeamId()
    for k,v in pairs(tempIdTab) do
        if v ~= "-1" and tostring(v) == tostring(heroId) then
            return true;
        end
    end
    return false;
end
--[[--
    判断工会招募英雄是否在编队中 
]]
function M.heroInGuildTeamById2(self,heroId)
    local tempIdTab = self:getGuildTeamData() --自己出战的卡的id
    cclog2(tempIdTab,"tempIdTab=====")
    for k,v in pairs(tempIdTab) do
        if v ~= "-1" and tostring(v) == tostring(heroId) then
            return true;
        end
    end
    return false;
end
--[[--
    获得编队中卡牌个数
]]
function M.getTeamCount(self)
    local tempCount = 0;
    for i=1,#self.m_tTeamData do
        if self.m_tTeamData[i] ~= "-1" then
            tempCount = tempCount + 1;
        end
    end
    return tempCount;
end
--[[--
    设置公会其他人编队id
]]
function M.setGuildOtherTeamData(self,tempData)
    self.m_tGuildOtherTeamData = tempData;
    cclog2(tempData,"tempData === ")
end

--[[--
    获得编队id
]]
function M.getGuildOtherTeamData(self)
    cclog2(self.m_tGuildOtherTeamData,"get =--- ")
    return self.m_tGuildOtherTeamData;
end

--[[--
    设置公会选择上阵的卡牌数据
]]
function M.setGuildSelTeamData(self,tempData)
    self.m_tGuildSelTeamData = tempData;
end

--[[--
    获得公会选择上阵的卡牌数据
]]
function M.getGuildSelTeamData(self)
    return self.m_tGuildSelTeamData;
end

--[[--
    设置公会选择上阵的卡牌id
]]
function M.setGuildSelTeamId(self,temp)
    cclog2( temp, "setGuildSelTeamId  temp =========  " )
    -- if not next(setGuildSelTeamId) then
    --     -- assert(false, "error ")
    --     cclog2("-------------  temp nil  ")
    -- end
    self.m_tGuildSelTeamId = temp;
end

--[[--
    获得公会选择上阵的卡牌id
]]
function M.getGuildSelTeamId(self)
    return self.m_tGuildSelTeamId;
end

--[[--
    获得公会所有卡选中的卡的id
]]
function M.getGuildSelectTeamId( self )
    local OtherTeamId = self:getGuildOtherTeamData() or {}
    local MyTeamId = self:getGuildTeamData() or {}
    cclog2(MyTeamId,"MyTeamId======")
    local AllSelectId = {}
    if OtherTeamId and MyTeamId then
        for k,v in pairs(OtherTeamId) do
            table.insert(AllSelectId,v)
        end
        for k,v in pairs(MyTeamId) do
            table.insert(AllSelectId,v)
        end
    end
    return AllSelectId;
end

--[[--
    获得公会cards数据表
]]
function M.getGuildTableCardsData(self)
    return self.m_tGuildCardsData;
end

--[[--
    设置公会cards数据表
]]
function M.setGuildTableCardsData(self,tempData)
    self.m_tGuildCardsData = tempData;
end

--[[--
    获得公会所有人cards数据表
]]
function M.getGuildAllCardsData(self)
    return self.m_tGuildAllCardsData;
end

--[[--
    设置公会所有人cards数据表
]]
function M.setGuildAllCardsData(self,tempData)
    self.m_tGuildAllCardsData = tempData;
end

--[[--
    通过id获得公会card数据
]]
function M.getGuildCardDataById(self,cardId)
    local cardData = self.m_tGuildSelTeamData[tostring(cardId)];
    -- cclog2
    if cardData == nil then return nil,nil end
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroCfg = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id));
    local skinHeroCfg = heroCfg
    -- local heroCfg2 = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id));
    if heroCfg:getNodeWithKey("is_skin") then
        if heroCfg:getNodeWithKey("is_skin"):toInt() ~= 0 then
            local skinID = heroCfg:getNodeWithKey("is_skin"):toInt()
            local flag = game_util:isWearSkin(skinID)
            if flag then
                skinHeroCfg = character_detail_cfg:getNodeWithKey(tostring(skinID));
            end
        end
    end
    return cardData,skinHeroCfg,heroCfg;
    -- return cardData,heroCfg;
end

--[[
    通过公会index获得card数据
]]--
function M.getGuildCardDataByIndex(self,index)
    local cardsIdTable = self:getGuildSelectTeamId();
    if index > 0 and index <= #cardsIdTable then
        return self:getGuildCardDataById(cardsIdTable[index]);
    end
    return nil,nil;
end
--[[--
    获得公会所有人cards数据表
]]
function M.getGuildFormationData(self)
    return self.m_tGuildFormationData;
end
--[[
    设置战争学院数据
]]
function M.setCommanderAvailableSkillByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_commander_available_skill = json.decode(jsonData:getFormatBuffer()) or {};
end
--[[
    获得战争学院数据
]]
function M.getCommanderAvailableSkill(self)
    return self.m_commander_available_skill or {}
end

--[[--
    设置公会所有人cards数据表
]]
function M.setGuildFormationData(self,tempData)
    self.m_tGuildFormationData = tempData;
end
--[[--
    获得当前阵型上的卡
]]
function M.getGuildGuildCurTeam(self)
    return self.m_tGuildCurTeam;
end

--[[--
    获得当前阵型上的卡
]]
function M.setGuildGuildCurTeam(self,tempData)
    self.m_tGuildCurTeam = tempData;
end
 
--记录当前的阵型id
function M.setguildFormationId( self,Id )
    self.m_guildFormationId = Id
    -- body
end
function M.getguildFormationId( self,Id )
    return self.m_guildFormationId
    -- body
end
function M.setGuildBossId( self,bossId )
    self.m_guildBossId = bossId or 1
end
function M.getGuildBossId( self )
    return self.m_guildBossId
    -- body
end
--[[------------------------------------公会副本相关 end------------------------------------------- ]]
--卡牌技能切换

function M.setExhcangeSkillIndexAndID( self,indexAndCardIdTab )
    self.m_tab_exchangeSkill_indexAndId = indexAndCardIdTab or {}
end
function M.getExhcangeSkillIndexAndID( self )
    return self.m_tab_exchangeSkill_indexAndId
end


function M:setSnowManMsg(data,where)
    self.m_snowman_msg = data
end
function M:getSnowManMsg(where)
    return self.m_snowman_msg
end


--[[-------------------------------------新助威 start------------------------------------------ ]]
function M.setFormationBonusByJsonData( self,jsonData )
    if jsonData == nil then return end
    if tolua.type(jsonData) == "table" then
        self.m_formationBounsData = jsonData
    elseif tolua.type(jsonData) == "util_json" then
        self.m_formationBounsData = json.decode(jsonData:getFormatBuffer());
    end
end
function M.setFormationBonusAdditionByJsonData( self,jsonData )
    if jsonData == nil then return end
    if tolua.type(jsonData) == "table" then
        self.m_formationBounsAdditionData = jsonData
    elseif tolua.type(jsonData) == "util_json" then
        self.m_formationBounsAdditionData = json.decode(jsonData:getFormatBuffer());
    end
    -- cclog2(self.m_formationBounsAdditionData,"self.m_formationBounsAdditionData === ")
end
function M.setFormationBonusEquipDataByJsonData( self,jsonData )
    if jsonData == nil then return end
    if tolua.type(jsonData) == "table" then
        self.m_formationBounsEquipData = jsonData
    elseif tolua.type(jsonData) == "util_json" then
        self.m_formationBounsEquipData = json.decode(jsonData:getFormatBuffer());
    end
end
function M.getFormationBonusByJsonData( self )
    return self.m_formationBounsData 
end
function M.getFormationBonusAdditionByJsonData( self )
    return self.m_formationBounsAdditionData
end
function M.getFormationBonusEquipData( self )
    return self.m_formationBounsEquipData
end
function M.setFormationBounsData_AddTable( self,m_formationBounsData_AddTable,m_pos )
    self.m_formationBounsData_AddTable[m_pos] = m_formationBounsData_AddTable or {}
end
function M.getFormationBounsData_AddTable(self)
    return self.m_formationBounsData_AddTable
end


function M.setBonusAddTab( self,m_bonusAddTab)
    self.m_bonusAddTab = m_bonusAddTab
end
function M.getBonusAddTab( self )
    return self.m_bonusAddTab
end
--[[-------------------------------------新助威 end------------------------------------------ ]]

--[[
    法宝相关    -------------- start   zyz
]]
function M:setMagicDataByJsonData(jsonData)
    -- cclog2(jsonData,"   setMagicDataByJsonData   ")
    if jsonData == nil then return end
    self.m_tMagicData = json.decode(jsonData:getFormatBuffer()) or {};
    if self.m_tMagicData ~= nil and type(self.m_tMagicData) == "table" then
        for k,v in pairs(self.m_tMagicData) do
            self.m_tMagicIdTable[#self.m_tMagicIdTable + 1] = k;
        end
    end
    -- cclog2(self.m_tMagicData,"self.m_tMagicData    --------  =======")
    -- cclog2(self.m_tMagicIdTable)
    self:magicSortByTypeName(self.m_magicSortType);
    -- cclog("setEquipDataByJsonData ================ count " .. #self.m_tMagicIdTable);
end
--  法宝数量
function M:getMagicCount()
    return #self.m_tMagicIdTable
end
 -- 法宝id
function M:getMagicIdTable()
    return self.m_tMagicIdTable
end

 -- 法宝id
function M:getMagicIdTablefilterbyRedQ()
    local temptb = {}
    local Cfgtalisman = json.decode(getConfig(game_config_field.talisman):getFormatBuffer()) or {}
    for k,v in pairs(self.m_tMagicIdTable) do
        if Cfgtalisman[self.m_tMagicData[v].c_id..""] and Cfgtalisman[self.m_tMagicData[v].c_id..""].quality >= 5 then
            table.insert(temptb,v)
        end
    end
    return temptb
end

-- 法宝详细信息
function M:getMagicData()
    return self.m_tMagicData
end
-- 通过id获取法宝信息
function M:getMagicDataById(magicId)
    magicId = tostring(magicId)
    local magicData = self.m_tMagicData[magicId];
    if magicData == nil then
        if magicId ~= "0" then
            cclog("error  >>>>>>>> " .. magicId .. " can't find it ")
        end
        return nil,nil
    end
    local talisman = getConfig(game_config_field.talisman);
    local magicItemCfg = talisman:getNodeWithKey(tostring(magicData.c_id));
    if magicItemCfg == nil then
        cclog("error  >>>>>>>> "  .. magicData.c_id .. "  config  can't find it  ")
        return nil,nil
    end
    return magicData,json.decode(magicItemCfg:getFormatBuffer());
end

--[[--
    获得法宝当前排序
]]
function M.getMagicSortType(self)
    return self.m_magicSortType;
end
--[[--
    法宝数据排序
]]
function M.magicSortByTypeName(self,typeName)

-- 默认：1装备是否装备状态，2装备ID，3卡牌等级
-- 等级：1装备等级，2装备品质,3装备ID
-- 品质：1装备品质，2装备ID，3装备等级
-- 类型：1装备类型，2装备品质，3装备ID，4装备等级

    self.m_magicSortType = typeName;
    typeName = typeName or "default";
    self:magicSortByTypeNameWithTable(typeName,self.m_tMagicIdTable);
end
--[[ 
    排序
]]

function M.magicSortByTypeNameWithTable(self,typeName,idDataTable)
    local tempTab = self.m_tMagicData;
    local str = tostring;
    local talismanCfg = getConfig(game_config_field.talisman);
    local itemData1,itemData2,itemCfg1,itemCfg2,quality1,quality2,c_ID1,c_ID2,sort1,sort2

    local tTeamTab = {};
    local tempItem = nil;
    for i=1,9 do
        tempItem = self.m_tMagicPosData[tostring(i-1)]
        if tempItem then
            for j=1,4 do
                if tempItem[j] then
                    tTeamTab[str(tempItem[j])] = 10;
                end
            end
        end
        tempItem = self.m_tAssMagicPosData[tostring(i+99)]
        if tempItem then
            for j=1,4 do
                if tempItem[j] then
                    tTeamTab[str(tempItem[j])] = 5;
                end
            end
        end
    end
    local flag1,flag2;
    local function sortFunc(idOne,idTwo)
        itemData1 = tempTab[str(idOne)]
        itemData2 = tempTab[str(idTwo)]
        itemCfg1 = talismanCfg:getNodeWithKey(tostring(itemData1.c_id));
        itemCfg2 = talismanCfg:getNodeWithKey(tostring(itemData2.c_id));
        if itemCfg1 and itemCfg2 then
            quality1,quality2 = itemCfg1:getNodeWithKey("quality"):toInt(),itemCfg2:getNodeWithKey("quality"):toInt();
            c_ID1,c_ID2 = tonumber(itemData1.c_id),tonumber(itemData2.c_id)
            if typeName == "default" then
                flag1 = tTeamTab[str(itemData1.id)] or 0
                flag2 = tTeamTab[str(itemData2.id)] or 0
                if flag1 == flag2 then
                    if quality1 == quality2 then
                        return c_ID1 > c_ID2
                    else
                        return quality1 > quality2
                    end
                else
                    return flag1 > flag2
                end
            elseif typeName == "lv" then
                if itemData1.lv == itemData2.lv then
                    if quality1 == quality2 then
                        return c_ID1 > c_ID2
                    else
                        return quality1 > quality2
                    end
                else
                    return itemData1.lv > itemData2.lv
                end
            elseif typeName == "quality" then
                if quality1 == quality2 then
                    if c_ID1 == c_ID2 then
                        return itemData1.lv > itemData2.lv
                    else
                        return c_ID1 > c_ID2
                    end
                else
                    return quality1 > quality2
                end
            elseif typeName == "sort" then
                sort1,sort2 = itemCfg1:getNodeWithKey("talisman_type"):toInt(),itemCfg2:getNodeWithKey("talisman_type"):toInt();
                if sort1 == sort2 then
                    if quality1 == quality2 then
                        if c_ID1 == c_ID2 then
                            return itemData1.lv > itemData2.lv
                        else
                            return c_ID1 > c_ID2
                        end
                    else
                        return quality1 > quality2;
                    end
                else
                    return sort1 > sort2
                end
            end

        else
            return idOne > idTwo;
        end
    end
    table.sort(idDataTable,sortFunc)
    cclog("magicSortByTypeName ----------------------------------" .. typeName)
    -- table.foreach(self.m_tEquipData,print)
end

function M:setTalismanWormholeByJsonData(jsonData)
    if jsonData == nil then return end
    local temp = json.decode(jsonData:getFormatBuffer()) or {};
    self.m_tTalismanWormholeIdTable = {}
    if temp ~= nil and type(temp) == "table" then
        for k,v in pairs(temp) do
            self.m_tTalismanWormholeIdTable[v..""] = 1
        end
    end
end

function M:getTalismanWormhole()
    return self.m_tTalismanWormholeIdTable or {}
end
function M:isinTalismanWormholeByid(id)
    return self.m_tTalismanWormholeIdTable[id..""] and true or false
end

function M:addTalismanWormholeBytable(data)
    for k,v in pairs(data) do
        if self.m_tTalismanWormholeIdTable ~= nil and type(self.m_tTalismanWormholeIdTable) == "table" then
            self.m_tTalismanWormholeIdTable[k..""]=1
        end
    end
end

function M:removeTalismanWormholeBytable(data)
    for k,v in pairs(data) do
        if self.m_tTalismanWormholeIdTable ~= nil and type(self.m_tTalismanWormholeIdTable) == "table" then
            self.m_tTalismanWormholeIdTable[k..""] = nil
        end
    end
end

------------------------  虫洞装备
function M:setEquipWormholeByJsonData(jsonData)
    if jsonData == nil then return end
    local temp = json.decode(jsonData:getFormatBuffer()) or {};
    self.m_tEquipWormholeIdTable = {}
    if temp ~= nil and type(temp) == "table" then
        for k,v in pairs(temp) do
            self.m_tEquipWormholeIdTable[v..""] = 1
        end
    end
end

function M:getEquipWormhole()
    return self.m_tEquipWormholeIdTable or {}
end
function M:isinEquipWormholeByid(id)
    return self.m_tEquipWormholeIdTable[id..""] and true or false
end

function M:addEquipWormholeBytable(data)
    for k,v in pairs(data) do
        if self.m_tEquipWormholeIdTable ~= nil and type(self.m_tEquipWormholeIdTable) == "table" then
            self.m_tEquipWormholeIdTable[k..""]=1
        end
    end
end

function M:removeEquipWormholeBytable(data)
    for k,v in pairs(data) do
        if self.m_tEquipWormholeIdTable ~= nil and type(self.m_tEquipWormholeIdTable) == "table" then
            self.m_tEquipWormholeIdTable[k..""] = nil
        end
    end
end

------------------------ 

function M.updateMoreMagicDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local data = json.decode(jsonData:getFormatBuffer())
    local itemCount = jsonData:getNodeCount();
    for i=1,itemCount do
        self:updateOneMagicDataByJsonData(jsonData:getNodeAt(i-1));
    end
    self:magicSortByTypeName(self.m_magicSortType);
    cclog("updateMoreMagicDataByJsonData ================itemCount " .. itemCount .. " ; #self.m_tEquipIdTable == " .. #self.m_tEquipIdTable);
end


function M.updateOneMagicDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemData = json.decode(jsonData:getFormatBuffer());
    local magicId = jsonData:getKey();
    if self.m_tMagicData[magicId] == nil then
        self.m_tMagicIdTable[#self.m_tMagicIdTable + 1] = magicId
        local talisman = getConfig(game_config_field.talisman);
        local magicItemCfg = talisman:getNodeWithKey(tostring(itemData.c_id));
        if magicItemCfg and magicItemCfg:getNodeWithKey("quality"):toInt() > 2  then
            self.m_newMagicIdTab[magicId] = 1;
            self.m_newMagicIdTab.count = self.m_newEquipIdTab.count + 1;
        end
    end
    self.m_tMagicData[magicId] = itemData;
end


function M.removeOneMagicDataById(self,itemId)
    itemId = tostring(itemId);
    local removeIndex = nil;
    for k,v in pairs(self.m_tMagicIdTable) do
        if v == itemId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_tMagicIdTable,removeIndex);
        self.m_tMagicData[itemId] = nil;
    end
    if self.m_newMagicIdTab[itemId] then
        self.m_newMagicIdTab[itemId] = nil;
        self.m_newMagicIdTab.count = self.m_newMagicIdTab.count - 1;
    end
end


--[[ 重置新法宝]]
function M.resetNewMagicIdTab(self)
    self.m_newMagicIdTab = {count = 0};
end


function M.isNewMagicFlagById(self,tempId)
    return self.m_newMagicIdTab[tostring(tempId)] ~= nil;
end


function M.setMagicPosDataByJsonData(self,jsonData)--setEquipPosDataByJsonData
    -- cclog2(jsonData,"setMagicPosDataByJsonData   ----------- >>>")
    if jsonData == nil then return end
    -- self.m_tEquipPosData = json.decode(jsonData:getFormatBuffer()) or {};
    local temp_count = jsonData:getNodeCount();
    for i=1,temp_count do
        local itemData = jsonData:getNodeAt(i-1)
        local tempItemData = {};
        for j=1,4 do
            table.insert(tempItemData,itemData:getNodeAt(j-1):toStr())
        end
        self.m_tMagicPosData[itemData:getKey()] = tempItemData;
    end
    --cclog("setEquipPosDataByJsonData ================ " .. json.encode(self.m_tEquipPosData));
end

--[[--
    设置卡牌位置装备数据
]]
function M.setMagicpPosData(self,tempData) -- setEquipPosData
    self.m_tMagicPosData = tempData;
end

--[[--
    得到卡牌位置装备数据
]]
function M.getMagicPosData(self)
    return self.m_tMagicPosData;
end


--[[-- 
    通过json数据设置神域阵型1卡牌位置装备数据
]]
function M.setGodMagicPosDataByJsonData1( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodMagicData1 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodEquipPosDataByJsonData1 ================ " .. json.encode(self.m_tGodMagicData1));

end

--[[-- 
    通过json数据设置神域阵型2卡牌位置装备数据
]]
function M.setGodMagicPosDataByJsonData2( self,jsonData)
    if jsonData == nil then return end
    self.m_tGodMagicData2 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodEquipPosDataByJsonData2 ================ " .. json.encode(self.m_tGodMagicData2));

end

--[[-- 
    通过json数据设置神域阵型2卡牌位置装备数据
]]
function M.setGodMagicPosDataByJsonData3( self,jsonData )
    if jsonData == nil then return end
    self.m_tGodMagicData3 = json.decode(jsonData:getFormatBuffer()) or {};
    -- cclog("setGodEquipPosDataByJsonData3 ================ " .. json.encode(self.m_tGodMagicData3));

end


--[[--
    得到神域阵型1卡牌位置装备数据
]]
function M.getGodMagicPosData1( self ) -- getGodEquipPosData1
    return self.m_tGodMagicData1;
end

--[[--
    得到神域阵型2卡牌位置装备数据
]]
function M.getGodMagicPosData2( self )
    return self.m_tGodMagicData2;
end

--[[--
    得到神域卡牌位置装备数据
]]
function M.getGodMagicPosData3( self )
    return self.m_tGodMagicData3;
end


--[[--
    通过json数据设置助威卡牌位置装备数据
]]
function M.setAssMagicPosDataByJsonData(self,jsonData) --setAssEquipPosDataByJsonData
    if jsonData == nil then return end
    self.m_tAssMagicPosData = json.decode(jsonData:getFormatBuffer()) or {}; -- m_tAssEquipPosData
    local temp_count = jsonData:getNodeCount();
    for i=1,temp_count do
        local itemData = jsonData:getNodeAt(i-1)
        local tempItemData = {};
        for j=1,4 do
            table.insert(tempItemData,itemData:getNodeAt(j-1):toStr())
        end
        self.m_tAssMagicPosData[itemData:getKey()] = tempItemData;
    end
    -- cclog("setAssEquipPosDataByJsonData ================ " .. json.encode(self.m_tAssEquipPosData));
end

--[[--
    得到助威卡牌位置装备数据
]]
function M.getAssMagicPosData(self)  -- getAssEquipPosData
    return self.m_tAssMagicPosData or {}
end

--[[--
    设置助威卡牌位置装备数据
]]
function M.setAssMagicPosData(self,tempData) -- setAssEquipPosData
    self.m_tAssMagicPosData = tempData;
end

--[[--
    设置阵型相应位置装备数据
]]

function M.updateMagicPosData(self,Pos,Type,magicId) -- updateEquipPosData
    if Pos > 9 or Pos < 0 or Type > 4 or Type < 1 then return end
    -- cclog("updateEquipPosData Pos = " .. equipPos .. " ; Type = " .. Type .. " ; equipId = " .. equipId);
    self.m_tMagicPosData[tostring(Pos)][Type] = tostring(magicId);
    -- cclog("updateEquipPosData = " .. json.encode(self.m_tMagicPosData))
end



--[[--
    判断是否装备上
]]
function M.godmagicInMagicPos(self,Type,Id)
    Id = tostring(Id);
    local godexistFlag = false;
    local posEquipData = nil;
    local m_tMagicPosData1 = self:getGodMagicPosData1();
    local m_tMagicPosData2 = self:getGodMagicPosData2();
    local m_tMagicPosData3 = self:getGodMagicPosData3();
    
    if Type ~= nil and Id ~= nil then
        for i=1,10 do
            if Type == 1 or Type == "1" then
                if tostring(m_tMagicPosData1[tostring(i-1)][1]) == Id or tostring(m_tMagicPosData2[tostring(i-1)][1]) == Id or tostring(m_tMagicPosData3[tostring(i-1)][1]) == Id or  tostring(m_tMagicPosData1[tostring(i-1)][2]) == Id or tostring(m_tMagicPosData2[tostring(i-1)][2]) == Id or tostring(m_tMagicPosData3[tostring(i-1)][2]) == Id then
                    godexistFlag = true
                    break;
                end
            elseif Type == 0 or Type == "0" then
                 if tostring(m_tMagicPosData1[tostring(i-1)][3]) == Id or tostring(m_tMagicPosData2[tostring(i-1)][3]) == Id or tostring(m_tMagicPosData3[tostring(i-1)][3]) == Id or  tostring(m_tMagicPosData1[tostring(i-1)][4]) == Id or tostring(m_tMagicPosData2[tostring(i-1)][4]) == Id or tostring(m_tMagicPosData3[tostring(i-1)][4]) == Id then
                    godexistFlag = true
                    break;
                end
            end
        end   
    end
    return godexistFlag
end

--[[--
    判断是否装备上
]]
function M.magicInMagicPos(self,magicType,magicId)
    magicId = tostring(magicId);
    -- cclog("magicInMagicPos      magicType  -->" .. magicType .. "   magicId  --> " .. magicId)
    local existFlag = false;
    local cardName = "";
    local posMagicData = nil;
    -- cclog2(self.m_tMagicPosData)
    -- cclog2(self.m_tAssMagicPosData)
    if magicType then
        for i=1,10 do
            local flag1,flag2
            if magicType == 1 or magicType == "1" then
                flag1 = (self.m_tMagicPosData[tostring(i-1)][1] == magicId) or (self.m_tMagicPosData[tostring(i-1)][2] == magicId)
                flag2 = (self.m_tAssMagicPosData[tostring(i+99)][1] == magicId) or (self.m_tAssMagicPosData[tostring(i+99)][2] == magicId)
            elseif magicType == 0 or magicType == "0" then
                flag1 = (self.m_tMagicPosData[tostring(i-1)][3] == magicId) or (self.m_tMagicPosData[tostring(i-1)][4] == magicId)
                flag2 = (self.m_tAssMagicPosData[tostring(i+99)][3] == magicId) or (self.m_tAssMagicPosData[tostring(i+99)][4] == magicId)
            end
            if flag1 then
                posMagicData = self.m_tMagicPosData[tostring(i-1)];
                existFlag = true
                local _,itemCfg = self:getTeamCardDataByPos(i);
                if itemCfg then
                    cardName = itemCfg:getNodeWithKey("name"):toStr();
                else
                    cardName = i .. "Thứ tự"
                end
                break;
            end
            if flag2 then
                posMagicData = self.m_tAssMagicPosData[tostring(i+99)];
                existFlag = true
                local _,itemCfg = self:getAssTeamCardDataByPos(i);
                if itemCfg then
                    cardName = "Trợ uy:" .. itemCfg:getNodeWithKey("name"):toStr();
                else
                    cardName = "Trợ uy:" .. i .. "Thứ tự"
                end
                break;
            end
        end
    end
    return existFlag,cardName,posMagicData
end



--[[--
    得到助威卡牌位置装备数据
]]
function M.getAssMagicPosData(self)
    return self.m_tAssMagicPosData or {}
end

--[[--
    设置助威卡牌位置装备数据
]]
function M.setAssMagicPosData(self,tempData)
    self.m_tAssMagicPosData = tempData;
end
--[[
    新助威
]]
function M.setFormationBonusMagicDataByJsonData( self,jsonData ) -- setFormationBonusEquipDataByJsonData
    if jsonData == nil then return end
    if tolua.type(jsonData) == "table" then
        self.m_formationBounsMagicData = jsonData
    elseif tolua.type(jsonData) == "util_json" then
        self.m_formationBounsMagicData = json.decode(jsonData:getFormatBuffer());
    end
end


--[[
    血石赋能
]]
function M.setFormationbloodStoneData( self, jsonData )
    if jsonData == nil then return end

    local fate_stone = jsonData:getNodeWithKey("fate_stone")
    if fate_stone then
        self.m_formationBloodStoneData.fate_stone = json.decode(fate_stone:getFormatBuffer()) or {};
    end

    local fate_word = jsonData:getNodeWithKey("fate_word")
    if fate_word then
        self.m_formationBloodStoneData.fate_word = json.decode(fate_word:getFormatBuffer()) or {};
    end

    local gem_special = jsonData:getNodeWithKey("gem_special")
    if gem_special then
        self.m_formationBloodStoneData.gem_special = json.decode(gem_special:getFormatBuffer());
    end

    local word_round = jsonData:getNodeWithKey("word_round")
    if word_round then
        self.m_formationBloodStoneData.word_round = json.decode(word_round:getFormatBuffer());
    end
end

--[[

]]

function M:setFormationBonusMagicData( jsonData )
    if jsonData == nil then return end
    if tolua.type(jsonData) == "table" then
        self.m_formationBounsMagicData = jsonData
    elseif tolua.type(jsonData) == "util_json" then
        self.m_formationBounsMagicData = json.decode(jsonData:getFormatBuffer());
    end
end

function M.getFormationBonusMagicData( self )
    return self.m_formationBounsMagicData  -- m_formationBounsEquipData
end


function M.getMagicGuideFlag(self)
    local tempFlag = true;
    for k,v in pairs(self.m_tMagicPosData) do
        if v[1] ~= "0" then
            tempFlag = false;
            break;
        end
    end
    return tempFlag;        
end


--[[--
    装备数量
]]
function M.getMagicCountByCid(self,cId,selMagicId)
    local tempCount = 0;
    local tostring = tostring;
    cId = tostring(cId);
    selMagicId = tostring(selMagicId);
    local talisman = getConfig(game_config_field.talisman);
    for k,v in pairs(self.m_tMagicData) do
        if tostring(v.c_id) == cId and tostring(k) ~= selMagicId and ( v.bind_card == nil or v.bind_card == "" ) then
            local itemCfg = talisman:getNodeWithKey(tostring(v.c_id));
            if itemCfg then
                local existFlag,_ = self:magicInMagicPos(itemCfg:getNodeWithKey("talisman_type"):toInt(),k)
                local godexistFlag = self:godmagicInMagicPos(itemCfg:getNodeWithKey("talisman_type"):toInt(),k)
                local BonusFlag,_ = self:magicInBonus2(itemCfg:getNodeWithKey("talisman_type"):toInt(),k)
                local existFlag_wormhole = self:isinEquipWormholeByid(k)
                if not (existFlag or godexistFlag or BonusFlag or existFlag_wormhole) then
                    tempCount = tempCount + 1;
                end
            end
        end
    end
    return tempCount;
end



--[[
    判断是否在新助威里面的装备
]]
function M.magicInBonus( self,magicType,magicId )--equipInBonus
    -- equipId = tostring(equipId);
    local existFlag = false;
    local pos = nil
    local bonusData = self:getFormationBonusMagicData()
    if magicType then
        for i=200,209 do
            if magicType < 3 then   
                if bonusData[tostring(i)][1] == tostring(magicId) then
                    existFlag = true
                    local equipData,_ = game_data:getMagicDataById(tostring(magicId))
                    pos = i - 199
                    Type = 1
                    break
                elseif bonusData[tostring(i)][2] == tostring(magicId) then
                    existFlag = true
                    local equipData,_ = game_data:getMagicDataById(tostring(magicId))
                    pos = i - 199
                    Type = 2
                    break
                end
            else
                if bonusData[tostring(i)][3] == tostring(magicId) then
                    existFlag = true
                    local equipData,_ = game_data:getMagicDataById(tostring(magicId))
                    pos = i - 199
                    Type = 3
                    break
                elseif bonusData[tostring(i)][4] == tostring(magicId) then
                    existFlag = true
                    local equipData,_ = game_data:getMagicDataById(tostring(magicId))
                    pos = i - 199
                    Type = 4
                    break
                end
            end
        end
    end
    return existFlag,pos,Type
end
--[[
    判断是否在新助威里面的装备
]]
function M.magicInBonus2( self,magicType,magicId )--equipInBonus
    -- equipId = tostring(equipId);
    local existFlag = false;
    local pos = nil
    local bonusData = self:getFormationBonusMagicData()
    if magicType then
        for i=200,209 do
            if magicType == 1 then   
                if bonusData[tostring(i)][1] == tostring(magicId) then
                    existFlag = true
                    local equipData,_ = game_data:getMagicDataById(tostring(magicId))
                    pos = i - 199
                    Type = 1
                    break
                elseif bonusData[tostring(i)][2] == tostring(magicId) then
                    existFlag = true
                    local equipData,_ = game_data:getMagicDataById(tostring(magicId))
                    pos = i - 199
                    Type = 2
                    break
                end
            elseif magicType == 0 then  
                if bonusData[tostring(i)][3] == tostring(magicId) then
                    existFlag = true
                    local equipData,_ = game_data:getMagicDataById(tostring(magicId))
                    pos = i - 199
                    Type = 3
                    break
                elseif bonusData[tostring(i)][4] == tostring(magicId) then
                    existFlag = true
                    local equipData,_ = game_data:getMagicDataById(tostring(magicId))
                    pos = i - 199
                    Type = 4
                    break
                end
            end
        end
    end
    return existFlag,pos,Type
end
--[[--
    通过id表格移出装备数据
]]
function M.removeMoreMagicDataByIdTable(self,itemIds)
    for k,v in pairs(itemIds) do
        self:removeOneMagicDataById(v);
    end
    cclog("removeMoreEquipDataByIdTable #self.m_tEquipIdTable ===== " .. #self.m_tMagicIdTable)
end
--[[--
    通过json数据设置装备分类数据
]]
function M.setMagicSortDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tMagicSortData = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setEquipSortDataByJsonData ================ ");
end

function M.setMasterEquipDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_heroEquip_tab = json.decode(jsonData:getFormatBuffer()) or {};
    cclog("setMasterEquipDataByJsonData ================ ");
end

--[[ 
    返回符合要求的装备数据   --品质返回    --专给分解用的，exchange_id > 0 才给用
]]--
function M.getMagicDataByQuality(self,quality)     --未完成
    local tempIdTable = {};
    for k,v in pairs(self.m_tEquipData) do
        local magicData,magicCfg = self:getMagicDataById(tostring(k));
        local my_quality = magicCfg:getNodeWithKey("quality"):toInt();
        local exchange_id = magicCfg:getNodeWithKey("exchange_id"):toInt()
        if my_quality >= quality and exchange_id > 0 then
            table.insert(tempIdTable,tostring(k));
            -- tempIdTable[tostring(k)] = v;
        end
    end
    return tempIdTable;
end
--[[ 
    返回符合要求的装备数据   --品质返回    --专给分解用的，exchange_id > 0 才给用
]]--
function M.getMagicDataByQuality2(self,quality, material_id)--getEquipDataByQuality2   --未完成
    local tempIdTable = {};
    local full_cfg = getConfig(game_config_field.talisman):getNodeWithKey(material_id);
    local equip_id = full_cfg:getNodeWithKey("equip_id"):toInt();
    for k,v in pairs(self.m_tEquipData) do
        local magicData,magicCfg = self:getEquipDataById(tostring(k));
        local my_quality = magicCfg:getNodeWithKey("quality"):toInt();
        local exchange_id = magicCfg:getNodeWithKey("exchange_id"):toInt();
        local equip_id1 = magicCfg:getNodeWithKey("equip_id"):toInt();
        if my_quality < quality and equip_id == equip_id1 then
            table.insert(tempIdTable,tostring(k));
        end
    end
    return tempIdTable;
end

--[[--
    通过 index 获得装备数据
]]
function M.getMagicDataByIndex(self,index)    --未完成
    if index > 0 and index <= #self.m_tEquipIdTable then
        return self:getMagicDataById(self.m_tMagicIdTable[index]);
    end
    return nil,nil;
end

--[[
    通过  获得装备数据
]]
function M:getMagicIDByType(itemData,sel_id)    --未完成
    local selMagicId = itemData.id
    local type_id = sel_id
    local magicTable = self.m_tMagicData
    local templv = 10
    local id = nil
    local talisman = getConfig(game_config_field.talisman);
    local count = 0
    for k,v in pairs(self.m_tMagicData) do
        if v.c_id == type_id and tostring(k) ~= selMagicId then
            local itemCfg = talisman:getNodeWithKey(tostring(v.c_id));
            if itemCfg then
                local existFlag,_ = self:magicInMagicPos(itemCfg:getNodeWithKey("talisman_type"):toInt(),k)
                local godexistFlag = self:godmagicInMagicPos(itemCfg:getNodeWithKey("talisman_type"):toInt(),k)
                local existFlag_bonus = self:magicInBonus2(itemCfg:getNodeWithKey("talisman_type"):toInt(),k)
                local existFlag_wormhole = self:isinTalismanWormholeByid(k)
                if not (existFlag or existFlag_bonus or godexistFlag or existFlag_wormhole) then
                    count = count + 1
                    if v.lv < templv or v.lv == templv then
                        templv = v.lv
                        id = v.id
                    end
                end
            end
        end
    end

    return id,count
end

function M.getMagicDataByMagicType(self,magicType)
    local tempTab = {};
    local talismanCfg = getConfig(game_config_field.talisman);
    local talismanCfgItem = nil;
    local talisman_type = nil;
    local itemData = nil;
    for k,v in pairs(self.m_tMagicIdTable) do
        v = tostring(v)
        itemData = self.m_tMagicData[v];
        -- cclog("id ==================== " .. v)
        if itemData then
            talismanCfgItem = talismanCfg:getNodeWithKey(itemData.c_id);
            talisman_type = talismanCfgItem:getNodeWithKey("talisman_type"):toInt();
            if talismanCfgItem ~= nil and talisman_type ~= nil then
                if magicType == nil then
                    tempTab[#tempTab + 1] = v;
                else
                    magicType = tonumber(magicType);
                    if magicType == -1 then
                        tempTab[#tempTab + 1] = v;
                    elseif talisman_type == magicType then
                        tempTab[#tempTab + 1] = v;
                    end
                end
            end
        end
    end
    return tempTab;
end

--[[
    获得
]]
function M.getNoUseMagicCountTab(self)
    local tempTab = {0,0}
    for k,v in pairs(self.m_tMagicPosData) do
        for index,id in pairs(v) do
            if id ~= "0" then
                if index < 3 then
                    tempTab[1] = tempTab[1] - 1;
                else
                    tempTab[2] = tempTab[2] - 1;
                end
            end
        end
    end
    for k,v in pairs(self.m_tAssMagicPosData) do
        for index,id in pairs(v) do
            if id ~= "0" then
                if index < 3 then
                    tempTab[1] = tempTab[1] - 1;
                else
                    tempTab[2] = tempTab[2] - 1;
                end
            end
        end
    end
    local talismanCfg = getConfig(game_config_field.talisman);
    local talismanCfgItem = nil;
    local sort = nil;
    for k,itemData in pairs(self.m_tMagicData) do
        talismanCfgItem = talismanCfg:getNodeWithKey(itemData.c_id);
        sort = talismanCfgItem:getNodeWithKey("talisman_type"):toInt();
        if sort > -1 and sort < 2 then
            tempTab[sort+1] = tempTab[sort+1] + 1;
        end
    end
    -- table.foreach(tempTab,print)
    return tempTab;
end

function M.getHeroEquipData(self) --主角带的装备
    return  self.m_heroEquip_tab

end

function M.setHeroEquipData(self,heroEquipTab)
    self.m_heroEquip_tab = heroEquipTab;
end

function M.isEquipInHeroEquipTab( self,equipId )
    local existFlag = false
    for k,v in pairs(self.m_heroEquip_tab) do
        -- cclog("isEquipInHeroEquipTab ---- 1")
        if tostring(v) == tostring(equipId) then
        -- cclog("isEquipInHeroEquipTab ---- 2")
            return true
        end
    end
    return existFlag
end

--[[
       12406 = {
        crit = 27
      }
    重铸通过返回的data获取数据
]]
function M.getEquipgetconfirmPropTable(self,data,bind_id)

    if data == nil then
        return nil
    else
        local num = 0
        for k,v in pairs(data) do
            num = num +1 
        end
        if num <1 then
            return nil
        end
    end

    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local chain_equip_table = getConfig(game_config_field.chain_equip) and json.decode(getConfig(game_config_field.chain_equip):getFormatBuffer()) or {}
    local _name = ""
    local _type = ""
    local _num = ""
    local cId = ""
    local itemConfig ,cardid1  = nil
    local outTable = {}
    local outTabletemp = {}

    for k,v in pairs(data) do
        cId = k..""
        cardid1 = chain_equip_table[cId].card_id[1]

        itemConfig = character_detail_cfg:getNodeWithKey(tostring(cardid1));
        _name = itemConfig:getNodeWithKey("name"):toStr() or "" --材料卡名字

        if cId == bind_id.."" then
            for k1,v1 in pairs(v) do

                if k1.."" == "subhurt" or k1.."" == "subAttrHurt" then 
                    table.insert(outTable ,  {_name .. "装备时","增加".. v1 .."%".. PUBLIC_ABILITY_NAME_TABLE[k1..""].name,k})
                else
                    table.insert(outTable ,  {_name .. "装备时","增加".. v1 .. PUBLIC_ABILITY_NAME_TABLE[k1..""].name,k})
                end
            end
        else
            for k1,v1 in pairs(v) do

                if k1.."" == "subhurt" or k1.."" == "subAttrHurt" then 
                    table.insert(outTabletemp ,  {_name .. "装备时","增加".. v1  .."%".. PUBLIC_ABILITY_NAME_TABLE[k1..""].name,k})
                else
                    table.insert(outTabletemp ,  {_name .. "装备时","增加".. v1 .. PUBLIC_ABILITY_NAME_TABLE[k1..""].name,k})
                end
            end
        end
    end
  
    for i=1,#outTabletemp do
        table.insert(outTable ,outTabletemp[i])
    end

    return outTable
end

--[[
    判断十倍属性套装备是不是在正确的人身上穿着
]]
function M.isTenEquipInHeroEquipTab( self,equipId, tar_equipcid )
    if self:getTenEquipPosFromZhen( equipId ,tar_equipcid,self.m_tEquipPosData ,self.m_tTeamData) then 
 return true
    elseif self:getTenEquipPosFromZhen( equipId ,tar_equipcid,self.m_tAssEquipPosData,self.m_tAssistant ) then 
 return true
    elseif  self:getTenEquipPosFromZhen( equipId ,tar_equipcid, self.m_formationBounsEquipData ,self.m_formationBounsData) then  return true
    elseif  self:getTenEquipPosFromZhen( equipId ,tar_equipcid, self.m_tGodEquipData1,self.m_tGodTeamData["1"] ) then  return true
    elseif  self:getTenEquipPosFromZhen( equipId ,tar_equipcid, self.m_tGodEquipData2,self.m_tGodTeamData["2"] ) then   return true
    elseif  self:getTenEquipPosFromZhen( equipId ,tar_equipcid, self.m_tGodEquipData3,self.m_tGodTeamData["3"] ) then  return true
    else 
        return false
    end
end

--[[
    判断 特殊属性装备是不是在正确的人身上穿着
]]
function M.isEquipInAllHeroEquipTab( self,equipId ,params)
    if self:getEquipPosFromAllZhen( equipId ,self.m_tEquipPosData ,self.m_tTeamData,params) then return true
    elseif self:getEquipPosFromAllZhen( equipId ,self.m_tAssEquipPosData,self.m_tAssistant ,params) then return true
    elseif  self:getEquipPosFromAllZhen( equipId , self.m_formationBounsEquipData ,self.m_formationBounsData,params) then  return true
    elseif  self:getEquipPosFromAllZhen( equipId , self.m_tGodEquipData1,self.m_tGodTeamData["1"] ,params) then  return true
    elseif  self:getEquipPosFromAllZhen( equipId , self.m_tGodEquipData2,self.m_tGodTeamData["2"] ,params) then   return true
    elseif  self:getEquipPosFromAllZhen( equipId , self.m_tGodEquipData3,self.m_tGodTeamData["3"] ,params) then  return true
    else 
        return false
    end
end

 --params  职业 -->>> occupation1 occupation_shade occupation
function M.getEquipPosFromAllZhen( self,equipId,quipPosData , teamdata ,params)
    cclog("  =============        getEquipPosFromAllZhen  getEquipPosFromAllZhen")
    local _find = false
    local _pos = 0
    for k,v in pairs(quipPosData) do 
        if _find then
            break
        end
        if tonumber(k)> 199 then 
            k = k - 200
        elseif tonumber(k) > 99  then
            k = k - 100
        end

        for k1,v1 in pairs(v) do 
            if v1.."" == equipId.."" then 
                _find = true
                _pos =tonumber(k)+1
                break
            end
        end
    end

    if not _find then
        return false
    end

    local equip_table = getConfig(game_config_field.equip) and json.decode(getConfig(game_config_field.equip):getFormatBuffer()) or {}
    local cd_table = getConfig(game_config_field.character_detail) and json.decode(getConfig(game_config_field.character_detail):getFormatBuffer()) or {}

    local temptable = {}
    for k, v in pairs(teamdata) do
        temptable[k..""] = v
    end

    local card_cid = self.m_tCardsData[temptable[_pos..""]].c_id -- 主阵卡牌的ID

    local cardcfg = cd_table[card_cid..""]
    if cardcfg == nil then
        return false
    end

    local flag = false
    if cardcfg.occupation_shade.."" == "-1" then
        local oc_table = getConfig(game_config_field.occupation) and json.decode(getConfig(game_config_field.occupation):getFormatBuffer()) or {}
        local ani = cd_table[card_cid..""].animation
        if oc_table and oc_table.ani then
            for k,v in pairs(params) do
                if oc_table.ani.."" == v.."" then
                    flag = true
                end
            end
            return flag
        else
            return false
        end
    else
        for k,v in pairs(params) do
            if v.."" == cardcfg.occupation_shade.."" then
                flag = true
            end
        end
        return flag
    end
end

--[[
   初始化真实阵容信息  zyz 
]]
function M:setRightFormation()
    local formationData = self:getFormationData();
    local ownFormation = formationData.own
    local ownFormationCount = #ownFormation
    local currentFormationId = formationData.current
    local teamData = self:getTeamData();
    local formationConfig = getConfig(game_config_field.formation);
    local itemCfg = formationConfig:getNodeWithKey(tostring(currentFormationId));
    local tempTag = 1;
    local iValue = nil;
    local tempTeamData = {}
    local formationPosTab = {{key="position_a"},{key="position_b"},{key="position_c"},{key="position_d"},{key="position_e"},{key="position_f"}};
    if itemCfg ~= nil then
        for i=1,#formationPosTab do
            local formationPosTabItem = formationPosTab[i];
            iValue = itemCfg:getNodeWithKey(formationPosTabItem.key):toInt();
            if iValue ~= 0 and tempTag < 7 then
                tempTeamData[i] = teamData[tempTag]
                tempTag = tempTag + 1;
            else
                tempTeamData[i] = "-1";
            end
        end
    end
    for i=6,8 do
        tempTeamData[i+1] = teamData[i];
    end
    -- cclog2(tempTeamData)
    self:setRightTeamData(tempTeamData)
end


--[[    
    真实阵容位置信息   zyz
]]
function M:setRightTeamData(tempData)
    self.m_tRightTeamData = tempData;
end

function M:getRightTeamData()
    return self.m_tRightTeamData 
end

function M:isInFamousById(id)
    if self.m_famousAllData[id] ~= 0 and  self.m_famousAllData[id] ~= nil then
        return true
    end
    return false
end

--[[
    法宝相关    -------------- end     zyz   
]]
-- 给阵法用的
function M.getCardsDataByBonus(self,i)
    -- local cardsTable = self:getTableCardsData();
    local tempIdTable = {};
    for k,v in pairs(self.m_tCardsData) do
        local formation_bonus = getConfig(game_config_field.formation_bonus);
        formation_bonus = json.decode(formation_bonus:getFormatBuffer()) or {}
        local StarData = formation_bonus[tostring(i)].card
        local cardData,heroCfg = self:getCardDataById(tostring(k));
        -- cclog2(cardData,"ddddd ==== ")
        for index,id in pairs(StarData) do
            if tostring(id) == tostring(cardData.c_id)   then
                if (not game_util:heroInTeamById(cardData.id,game_data:getTeamData())) and (not game_data:heroInAssistantById(cardData.id)) and (not game_util:heroInTeamById(cardData.id,game_data:getDestiny())) and (not game_util:isInFormationBonus(cardData.id)) then
                    table.insert(tempIdTable,cardData.id);
                end
            end
        end
    end
    return tempIdTable;
end

--[[
    当前所有的皮肤数据
]]
function M:setCardSkinData( data )
    if data == nil then return end
    local jsonData = json.decode(data:getFormatBuffer())
    self.m_cardSkinData = jsonData
end


function M:updateCardSkinData( data )
    if data == nil then return end
    local jsonData = json.decode(data:getFormatBuffer())
    for k,v in pairs(jsonData) do
        self.m_cardSkinData[k] = v
    end
end

function M:getCardSkinData( )

    return self.m_cardSkinData
end

--[[
    当前穿戴的皮肤
]]
function M:setCurCardSkinData( data )
    if data == nil then return end
    local jsonData = json.decode(data:getFormatBuffer())
    self.m_curCardSkinData = jsonData
end

function M:getCurCardSkinData( )
    return self.m_curCardSkinData
end
--[[
    名人堂
]]
-- function M:getFamousAttrs()
--     return self.m_Famous_attr
-- end


function M:updateFateGemDataByCid(update,remove)
    --[[
        cclog2(update,"   updateFateGemDataByCid  ----------- update  ")
        cclog2(remove,"   updateFateGemDataByCid  -----------  remove ")
        cclog2(self.m_tFateGemData,"  updateFateGemDataByCid   self.m_tFateGemData 1111111 ")
        cclog2(self.m_tFateGemData,"  updateFateGemDataByCid   self.m_tFateGemData 22222222 ")
        cclog2(self.m_tFateGemData,"  updateFateGemDataByCid   self.m_tFateGemData 333333333 ")
    ]]
    if update then
        for k,v in pairs(update) do
            if self.m_tFateGemData[k] then
                self.m_tFateGemData[k] = v
            else
                self.m_tFateGemData[k] = v
            end
        end
    end
    if remove then
        for k,v in pairs(remove) do
            -- cclog(v)
            -- cclog2(self.m_tFateGemData[tostring(v)])
            if self.m_tFateGemData[tostring(v)] then
               self.m_tFateGemData[tostring(v)] = nil
               table.remove(self.m_tFateGemIdTable,tostring(v))
            end 
        end
    end
end
-- 雪人相关  
function M:setSnowManMsg(data,where)
    self.m_snowman_msg = data
end
function M:getSnowManMsg(where)
    return self.m_snowman_msg
end

function M:setSnowManVersion(data,where)
    self.m_snowman_Version = data
end
function M:getSnowManVersion(where)
    return self.m_snowman_Version
end

function M:setSnowReward(data ,where)
    self.m_snow_reward = data
end

function M:getSnowReward(where)
    return self.m_snow_reward
end
--[[
    名人堂
]]

function M:setFamousDeatilDataByJsonData(data)
    if data then
        data = json.decode(data:getFormatBuffer())
        self.m_Famous_detail = data
        for k,v in pairs(data) do
            if v.card_id and v.card_id ~= "" then
                self.m_tCardsData[v.card_id].famous = util.table_copy(v.strengthen_v)
            end
        end
 
     end
end


function M:updateFamousDetailByData(data)
    if data == nil then return end
    for k,v in pairs(data) do
        self.m_Famous_detail[k] = util.table_copy(v)
        if v.card_id and v.card_id ~= "" then
            self.m_tCardsData[v.card_id].famous = util.table_copy(v.strengthen_v)
        end
    end

end


function M:setFamousAllDataByJsonData(data)
    if data == nil then return end
    local jsonData = json.decode(data:getFormatBuffer())
    self.m_famousAllData = jsonData
end


function M:addFamousAllDataByData( data )
    if data == nil then return end
    for k,v in pairs(data) do
        self.m_famousAllData[k] = v
    end
end


function M:getFamousAllData()
    return self.m_famousAllData
end

function M:removeFamousAllByTab(tempTab)
    if tempTab then
        for k,v in pairs(tempTab) do
            self:removeOneDataFromFamousAllData(v)
        end
    end
end

function M:removeOneDataFromFamousAllData(Id)
    self.m_famousAllData[Id] = nil
    self.m_tCardsData[Id].famous = nil
end

function M:setFamousAttrsByJsonData(data)
    self.m_Famous_attr = self.m_Famous_attr or {}
    if data then
        data = json.decode(data:getFormatBuffer())
        for k,v in pairs(data) do
            self.m_Famous_attr[k] = v
        end
    end
end
function M:resetFamousAttrsByJsonData(data)
    self.m_Famous_attr = self.m_Famous_attr or {}
    if data then
        data = json.decode(data:getFormatBuffer())
        for k,v in pairs(data) do
            self.m_Famous_attr[v] = 0
        end
    end
end

function M:setFamousAttrsByTableData(data)
    if data then
        self.m_Famous_attr = data
    end
end

function M:getFamousAttrs()
    return self.m_Famous_attr
end

function M:getCardTabById(cardId_Tab)
    local tempTab = {}
    for k,v in pairs(self.m_tCardsData) do
        if cardId_Tab[tostring(v.c_id)] == 1 then
            if not self.m_famousAllData[k] or self.m_famousAllData[v] == 0 then
                tempTab[#tempTab+1] = k
            end
        end
    end
    return tempTab
end


function M.setServerGuildIsManage( self,isManage )
    self.m_serverGuild_isManage = isManage or false
end
function M.getServerGuildIsManage( self )
    return self.m_serverGuild_isManage
    -- body
end

function M:getBagCardsIdTable()
    local tempTab = {}
    for k,v in pairs(self.m_tCardsIdTable) do
        if not self.m_famousAllData[v] or self.m_famousAllData[v] == 0 then
            table.insert(tempTab,v)
        end
    end
    return tempTab
end
function M:getBagCardsIdTable2()
    local character_detail = getConfig(game_config_field.character_detail)
    local tempTab = {}
    for k,v in pairs(self.m_tCardsIdTable) do
        if not self.m_famousAllData[v] or self.m_famousAllData[v] == 0 then
            local isinBonus = game_util:isInFormationBonus2(v)
            local team_flag = game_data:heroInTeamById(v)
            local ass_flag = game_data:heroInAssistantById(v)
            local god_flag = game_data:godheroInTeamById(v)
            local guild_flag = game_data:heroInGuildTeamById2(v)
            if not isinBonus and not team_flag and not ass_flag and not god_flag and not guild_flag then
                local cardData,cfg = game_data:getCardDataById(v)
                local dis_flag = false
                if cardData.remove_avail then
                    for k,v in pairs(cardData.remove_avail) do
                        if v == "dispatch" then
                            dis_flag = true
                        end
                    end
                end
                local streng = cfg:getNodeWithKey("streng") and cfg:getNodeWithKey("streng"):toInt() or 0                
                if (not dis_flag) and streng > 0 and (tonumber(cardData.c_id) ~= 50 and tonumber(cardData.c_id) ~= 51 and tonumber(cardData.c_id) ~= 52 and tonumber(cardData.c_id) ~= 53 and tonumber(cardData.c_id) ~= 54 and tonumber(cardData.c_id) ~= 55 and tonumber(cardData.c_id) ~= 56) then
                    table.insert(tempTab,v)
                end
            end
        end
    end
    return tempTab
end


function M:insertOneDataToFamous(id)
    self.m_famousAllData[id] = 1
end

--[[
    星域竞技场
]]
function M:setGodPvpBattleResult(data)
    self.m_god_PVP_new_battleResult = data
end


function M:getGodPvpBattleResult()
    return self.m_god_PVP_new_battleResult
end
--名人堂

function M:getFamousDetailByF_id(id)
    cclog2(self.m_Famous_detail[tostring(id)],"self.m_Famous_detail[tostring(id)]-=----------")
    return self.m_Famous_detail[tostring(id)]
end

function M:getAttrsDataByFame_Id(fame_id,tempDetail)
    local famousCfg = getConfig(game_config_field.famous)
    local tempCfg = famousCfg:getNodeWithKey(tostring(fame_id))
    local attrs = {0,0,0,0,0}
    local tempDetail = tempDetail
    if not tempDetail then
        tempDetail = self.m_Famous_detail[tostring(fame_id)] or {}
    end
    if tempDetail.card_id and tempDetail.card_id ~= "" then
        for k,v in pairs(tempDetail.gate) do
            if v ~= "" then
                local _,cardCfg = self:getCardDataById(v)
                local data = self:getFamousPosAtt(fame_id,k,cardCfg)
                if data then
                    attrs[data[1]] = attrs[data[1]] + data[2]
                end
            end
        end
    end
    local attrsMAX = {0,0,0,0,0}
    return attrs,attrsMAX
end

function M:getFamousPosAtt(fame_id,gate,cardCfg)
    local famousCfg = getConfig(game_config_field.famous)
    local tempCfg = famousCfg:getNodeWithKey(tostring(fame_id))
    local data2 = json.decode(tempCfg:getNodeWithKey(gate .. "_" .. 3):getFormatBuffer())
    if cardCfg then
        local streng_lv = cardCfg:getNodeWithKey("streng") and cardCfg:getNodeWithKey("streng"):toInt() or 0
        if streng_lv and streng_lv > 0 then
            local data1 = json.decode(tempCfg:getNodeWithKey(gate .. "_" .. streng_lv):getFormatBuffer())
            
            return data1,data2
        end
    end
    return nil,data2
end

--[[--
    获取命运宝石数据
]]
function M.getFateGemData(self)
    return self.m_tFateGemData;
end

--[[--
    通过id获得命运宝石数据
]]
function M.fateGemSortByTypeNameWithTable(self,tempId)
    tempId = tostring(tempId)
    local tempData = self.m_tFateGemData[tempId];
    if tempData == nil then
        if tempId ~= "0" then
            -- cclog("tempId = " .. tempId .. " ; type(tempId) == " .. tostring(type(tempId)) .. " ; self.m_tGemData == " .. json.encode(self.m_tGemData))
        end
        return nil,nil
    end
    local tempCfg = getConfig(game_config_field.equip_gem_fate);
    local tempItemCfg = tempCfg:getNodeWithKey(tostring(tempId));
    return tempData,tempItemCfg;
end

--[[--
    通过json数据设置宝石数据
]]
function M.setFateGemDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    self.m_tFateGemData = json.decode(jsonData:getFormatBuffer()) or {};
    if self.m_tFateGemData ~= nil and type(self.m_tFateGemData) == "table" then
        for k,v in pairs(self.m_tFateGemData) do
            self.m_tFateGemIdTable[#self.m_tFateGemIdTable + 1] = k;
        end
    end
    self:fateGemSortByTypeName(self.m_gemSortType);
    cclog("setGemDataByJsonData ================ count " .. #self.m_tFateGemIdTable);
end
function M.addFateGemDataByCid(self, c_id, count)
    c_id = tostring(c_id)
    if c_id == "0" then return end
    count = count or 1;
    if self.m_tFateGemData[c_id] then
        self.m_tFateGemData[c_id] = math.max(0,self.m_tFateGemData[c_id] + count)
    else
        self.m_tFateGemData[c_id] = count;
    end
end
function M.minusFateGemDataCid(self, c_id, count)
    c_id = tostring(c_id)
    count = count or 1;
    if self.m_tFateGemData[c_id] then
        self.m_tFateGemData[c_id] = math.max(0,self.m_tFateGemData[c_id] - count)
    end
end
--[[--
    通过 gemType 获得命运宝石数据
]]
function M.getFateGemDataByGemType(self,gemType)
    local tempTab = {};
    local tempCfg = getConfig(game_config_field.equip_gem_fate);
    local tempCfgItem = nil;
    local team = nil;
    local itemData = nil;
    gemType = tonumber(gemType or -1)
    -- gemType = gemType > 2 and 2 or gemType;

    for k,v in pairs(self.m_tFateGemData) do
        k = tostring(k)
        if v > 0 then
            -- cclog("id ==================== " .. k)
            tempCfgItem = tempCfg:getNodeWithKey(k);
            if tempCfgItem then
                team = tempCfgItem:getNodeWithKey("team"):toInt();
                if team ~= 0 then
                    if gemType == -1 then
                        table.insert(tempTab,k)
                    elseif team == gemType then
                        table.insert(tempTab,k)
                    end
                end
            end
        end
    end
    return tempTab;
end

--[[
    超级仓库 数据
]]
function M:setStoreHouseData( data )
    if data == nil then return end
    local jsonData = json.decode(data:getFormatBuffer())
    self.m_storeHouseData = jsonData
end

function M:getStoreHouseData( )
    return self.m_storeHouseData
end

--[[--
    通过id获得命运宝石数据
]]
function M.getFateGemDataById(self,tempId)
    tempId = tostring(tempId)
    local tempData = self.m_tFateGemData[tempId];
    if tempData == nil then
        if tempId ~= "0" then
            -- cclog("tempId = " .. tempId .. " ; type(tempId) == " .. tostring(type(tempId)) .. " ; self.m_tGemData == " .. json.encode(self.m_tGemData))
        end
        return nil,nil
    end
    local tempCfg = getConfig(game_config_field.equip_gem_fate);
    local tempItemCfg = tempCfg:getNodeWithKey(tostring(tempId));
    return tempData,tempItemCfg;
end

--[[
    装备打造
]]
function M:getNotCanBuildEquipId()
    local tempTab = {}
    for i,v in ipairs(self.m_tEquipIdTable) do
        local itemData,cfg = self:getEquipDataById(v)
        if not itemData.is_building and cfg:getNodeWithKey("equip_building_old"):toInt() == 1 then
            tempTab[#tempTab+1] = v
        end
    end
    return tempTab
end
--[[
    装备打造
]]
function M:getIsCanBuildEquipId()
    local tempTab = {}
    for i,v in ipairs(self.m_tEquipIdTable) do
        local itemData,cfg = self:getEquipDataById(v)
        if itemData.is_building then
            tempTab[#tempTab+1] = v
        end
    end
    return tempTab
end

--[[--
    装备重铸 返回十倍属性套
]]
function M.getTenEquipIdTable(self)
    -- cclog2(self.m_tEquipData ,  "  self.m_tEquipData   ")
    local TenEquipIdTable = {}
    local equip_recast_table = getConfig(game_config_field.equip_recast) and json.decode(getConfig(game_config_field.equip_recast):getFormatBuffer()) or {}
    local equipflag = nil
    local exposflag , expos_= nil
    local bonusposflag , expos_= nil
    local godposflag = nil
    local temptb = {}
    local equipCfg = getConfig(game_config_field.equip);
    local itemCfg =nil
    if self.m_nEquipDataC_id or #self.m_nEquipDataC_id ~= 0 then
        for k,v in pairs(self.m_nEquipDataC_id) do
            itemCfg = equipCfg:getNodeWithKey(""..v[1])
            if itemCfg then 
                equipflag = self:isEquipInHeroEquipTab(""..v[2])
                exposflag , expos_= self:equipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),""..v[2])
                bonusposflag , expos_= self:equipInBonus(itemCfg:getNodeWithKey("sort"):toInt(),""..v[2])
                godposflag = self:godequipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),""..v[2])
                
                -- if equip_recast_table[""..v[1]] and not equipflag and not exposflag and not bonusposflag and not godposflag then 
                --1是否在重铸配置表 2是否已装备 3是否上阵 4是否在阵法 5是否在神域
                if equip_recast_table[""..v[1]] then
                    if   equipflag or exposflag or  bonusposflag or godposflag  then 
                        table.insert(TenEquipIdTable,v[2])
                    else
                        table.insert(temptb,v[2])
                    end
                end
            end
        end
    end
    for i=1,#temptb do
        table.insert(TenEquipIdTable,temptb[i])
    end
    return TenEquipIdTable
end

--[[--
    装备复炼 返回十倍属性套
]]
function M.getTenEquipIdTable2(self)
    local TenEquipIdTable = {}
    local equip_recast_table = getConfig(game_config_field.equip_recast) and json.decode(getConfig(game_config_field.equip_recast):getFormatBuffer()) or {}
    local equip_again_table = getConfig(game_config_field.equip_recast) and json.decode(getConfig(game_config_field.equip_building_again):getFormatBuffer()) or {}
    local equipflag = nil
    local exposflag , expos_= nil
    local bonusposflag , expos_= nil
    local godposflag = nil
    local temptb = {}
    local equipCfg = getConfig(game_config_field.equip);
    local itemCfg =nil
    if self.m_nEquipDataC_id or #self.m_nEquipDataC_id ~= 0 then
        for k,v in pairs(self.m_nEquipDataC_id) do
            itemCfg = equipCfg:getNodeWithKey(""..v[1])
            if itemCfg then 
                equipflag = self:isEquipInHeroEquipTab(""..v[2])
                exposflag , expos_= self:equipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),""..v[2])
                bonusposflag , expos_= self:equipInBonus(itemCfg:getNodeWithKey("sort"):toInt(),""..v[2])
                godposflag = self:godequipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),""..v[2])
                -- if equip_recast_table[""..v[1]] and not equipflag and not exposflag and not bonusposflag and not godposflag then 
                --1是否在重铸配置表 2是否已装备 3是否上阵 4是否在阵法 5是否在神域
                if equip_recast_table[""..v[1]] and self.m_tEquipData[""..v[2]].is_building and equip_again_table[""..v[1]] then
                    if   equipflag or exposflag or  bonusposflag or godposflag  then 
                        table.insert(TenEquipIdTable,v[2])
                    else
                        table.insert(temptb,v[2])
                    end
                end
            end
        end
    end
    for i=1,#temptb do
        table.insert(TenEquipIdTable,temptb[i])
    end
    return TenEquipIdTable
end

--[[--
    装备重铸 通过返回对应的命运属性套
]]
function M.getFateEquipIdTable(self,TenEquipCId ,TenEquipId)
    local  FateEquipIdTable = {}

    local equip_recast_table = getConfig(game_config_field.equip_recast) and json.decode(getConfig(game_config_field.equip_recast):getFormatBuffer()) or {}
    local equip_chain_table = getConfig(game_config_field.chain_equip) and json.decode(getConfig(game_config_field.chain_equip):getFormatBuffer()) or {}
    local sort = equip_recast_table[TenEquipCId..""].sort

    local equipflag = nil
    local exposflag , expos_= nil
    local bonusposflag , expos_= nil
    local godposflag = nil
    local equipCfg = getConfig(game_config_field.equip);
    local itemCfg =nil
 
    local attr1 = equip_recast_table[TenEquipCId..""].attr

    if self.m_nEquipDataC_id or #self.m_nEquipDataC_id ~= 0 then
        for k,v in pairs(self.m_nEquipDataC_id) do
            tb1 = {}
            itemCfg = equipCfg:getNodeWithKey(""..v[1])
            if itemCfg then 
                equipflag = self:isEquipInHeroEquipTab(""..v[2])
                exposflag , expos_= self:equipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),""..v[2])
                bonusposflag , expos_= self:equipInBonus(itemCfg:getNodeWithKey("sort"):toInt(),""..v[2])
                godposflag = self:godequipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),""..v[2])
                ismingflag = self.m_tEquipData[""..v[2]].bind_card and self.m_tEquipData[""..v[2]].bind_card ~= ""
                
                if equip_chain_table[""..v[1]]~=nil and equip_chain_table[""..v[1]].sort == sort and not equipflag and not exposflag and not bonusposflag and not godposflag and not ismingflag and equip_chain_table[""..v[1]].attr == attr1 then 
                    --1是否在重铸配置表 2sort是否一致 3是否已装备 4是否上阵 5是否在阵法 6是否在神域 7是否命运绑定 8 attr是否一致

                    if self.m_tEquipData[TenEquipId..""].recast_bind ~= nil and self.m_tEquipData[TenEquipId..""].recast_bind ~= "" then 
                    --主装备已经重铸的 需要判断recast_bind 和 build_atts  
                        if self.m_tEquipData[TenEquipId..""].recast_bind.."" == v[1].."" then
                            table.insert(FateEquipIdTable,v[2])
                        end
                    else
                    --主装备没有重铸过  好像没有什么可判断的了
                        table.insert(FateEquipIdTable,v[2])
                    end
                end
            end
            
        end
    end
    return FateEquipIdTable
end

function M.fateGemSortByTypeName(self,typeName,flag)

-- 默认：1宝石是否宝石状态，2宝石ID，3宝石等级
-- 等级：1宝石等级，2宝石品质,3宝石ID
-- 品质：1宝石品质，2宝石ID，3宝石等级
-- 类型：1宝石类型，2宝石品质，3宝石ID，4宝石等级

    self.m_gemSortType = typeName;
    self:gemSortByTypeNameWithTable(typeName,self.m_tFateGemIdTable,flag)
    -- cclog("gemSortByTypeName ----------------------------------" .. typeName)
    -- table.foreach(self.m_tGemData,print)
end
function M.getIsdoubleValue(self )
    -- body
    -- cclog("222222222")
    -- cclog2(self.is_double ,"self.is_double -=-------------")
    if self.is_double:toBool() then 
        return self.is_double:toBool();
    else
        return false ;
    end
end
function M:setGuildStarPos(pos,index)
    self.m_guildStar_pos = pos
    self.m_guildStar_index = index
end
function M:setGuildStarShopMsg(shop_id_list,shopType)
    shop_id_list = shop_id_list and json.decode(shop_id_list:getFormatBuffer())
    self.m_shop_id_list = shop_id_list and util.table_copy(shop_id_list) or nil
    self.m_shopType = shopType
    cclog2(self.m_shopType , "-------------------- setGuildStarShopMsg  --------------  ")
    cclog2(self.m_shop_id_list , "-------------------- setGuildStarShopMsg  --------------  ")

end

function M:setWormtype_battle(s)
    m_wormtype_battle = s
end

function M:getWormtype_battle(s)
    return m_wormtype_battle
end


-- 团队副本
function M:setTeamRaidMsg( key,value )
    -- body
    self.m_teamRaid = self.m_teamRaid or {}
    self.m_teamRaid[key] = value
end


function M:getTeamRaidMsg(  )
    return self.m_teamRaid
end

-- function M:getKaPaiCidNum(  )
--     self.m_tkapaiCid = {}
--     for k,v in pairs(self.m_tCardsData ) do
--         self.m_tkapaiCid[#self.m_tkapaiCid + 1] = v.c_id
--     end
--     local sortFun = function ( data1,data2 )
--      return tonumber(data1) < tonumber(data2)
--     end
--     table.sort(self.m_tkapaiCid,sortFun)
--     self.m_tKapaiCid = {}
--     for i=1,#self.m_tkapaiCid do
--         if i <= 1 then
--             self.m_tKapaiCid[#self.m_tKapaiCid + 1] = self.m_tkapaiCid[1]
--         elseif i > 1 and self.m_tKapaiCid[#self.m_tKapaiCid] ~= self.m_tkapaiCid[i] then
--             self.m_tKapaiCid[#self.m_tKapaiCid + 1] = self.m_tkapaiCid[i]
--         end
--     end
--     return self.m_tKapaiCid
-- end

function M:getKaPaiCidData(  )
    self.m_tkapaiCid = {}
    for k,v in pairs(self.m_tCardsData ) do
        self.m_tkapaiCid[#self.m_tkapaiCid + 1] = v.c_id
    end
    local sortFun = function ( data1,data2 )
     return tonumber(data1) < tonumber(data2)
    end
    table.sort(self.m_tkapaiCid,sortFun)
    -- cclog2(self.m_tkapaiCid,"self.m_tkapaiCid-=--=-=-============")
    cclog2(game_util:getTableLen(self.m_tkapaiCid),"self.m_tkapaiCid-=--=-=-============")
    game_util:getTableLen(self.m_tkapaiCid)
    self.m_tKapaiCid = {}
    for i=1,#self.m_tkapaiCid do
        if i <= 1 then
            self.m_tKapaiCid[#self.m_tKapaiCid + 1] = self.m_tkapaiCid[1]
        elseif i > 1 and self.m_tKapaiCid[#self.m_tKapaiCid] ~= self.m_tkapaiCid[i] then
            self.m_tKapaiCid[#self.m_tKapaiCid + 1] = self.m_tkapaiCid[i]
        end
    end
    -- cclog2(self.m_tKapaiCid,"self.m_tKapaiCid-==*************")
    cclog2(game_util:getTableLen(self.m_tKapaiCid),"self.m_tkapaiCid-=--=-=-============")
    self.m_tkapaiDatas = {} 
    for i=1, game_util:getTableLen(self.m_tKapaiCid) do
        local kapai = {}
        local index = 0
        for k,v in pairs(self.m_tCardsData ) do   
            if self.m_tKapaiCid[i] == v.c_id then
                index = index + 1
                kapai[index] = v.id
            end
        end
        table.insert(self.m_tkapaiDatas,kapai)
    end
    
    return self.m_tkapaiDatas
end

--[[
    将数组形式的id列表转成用cid做key的二级table
]]
function M:cidsToDatas(oldIds)
    local cids = {}
    for k,v in pairs(self.m_tCardsData ) do
        for k1, v1 in pairs(oldIds) do
            if v1 == v.id then
                cids[#cids + 1] = v.c_id
                break
            end
        end
    end
    local sortFun = function ( data1,data2 )
        return tonumber(data1) < tonumber(data2)
    end
    table.sort(cids,sortFun)

    local datas = {}
    for i=1,#cids do
        if i <= 1 then
            datas[#datas + 1] = cids[1]
        elseif i > 1 and datas[#datas] ~= cids[i] then
            datas[#datas + 1] = cids[i]
        end
    end
    local newDatas = {}
    for i=1, game_util:getTableLen(datas) do
        local kapai = {}
        local index = 0
        for k,v in pairs(self.m_tCardsData ) do   
            if datas[i] == v.c_id and game_util:idInTableById(v.id, oldIds) then
                index = index + 1
                kapai[index] = v.id
            end
        end
        table.insert(newDatas,kapai)
    end
    
    return newDatas


end

function M:getYingHunSidData(  )
    local soulCfg = getConfig(game_config_field.soul_detail)
    self.s_id_table = {} --取detail表里的id
    for k,v in pairs(self.m_tSoulData ) do
        self.s_id_table[#self.s_id_table + 1] = v.s_id
    end
    local sortFun = function ( data1,data2 )
     return tonumber(data1) < tonumber(data2)
    end
    table.sort(self.s_id_table,sortFun)
    -- cclog2(self.s_id_table,"7897979797979")
    self.s_Id_table = {}
    for i=1,#self.s_id_table do
        if i <= 1 then
            self.s_Id_table[#self.s_Id_table + 1] = self.s_id_table[1]
        elseif i > 1 and self.s_Id_table[#self.s_Id_table] ~= self.s_id_table[i] then
            self.s_Id_table[#self.s_Id_table + 1] = self.s_id_table[i]
        end
    end
    -- cclog2(self.s_Id_table,"4546464564646")
    self.m_tsidData = {} 
    for i=1, game_util:getTableLen(self.s_Id_table) do
        local kapai = {}
        local index = 0
        for k,v in pairs(self.m_tSoulData ) do
            if self.s_Id_table[i] == v.s_id then
                kapai[ index+ 1] = v.id
                index = index + 1
            end
        end
        table.insert(self.m_tsidData,kapai)
    end
    -- cclog2(self.m_tsidData,"12313456464789")


    local soulPos = {}
    for key,soulTable in pairs(self.m_tSoulPosData) do
        for k,v in pairs(soulTable) do
            if v ~= "0" and v ~= "-1" then
                soulPos[v] = 1
            end
        end
    end

    local flag1,flag2
    local function sortFunc(data1,data2)
        local itemData1 = self.m_tSoulData[tostring(data1[1])]
        local itemData2 = self.m_tSoulData[tostring(data2[1])]
        local s_id1 = itemData1.s_id
        local s_id2 = itemData2.s_id
        local itemCfg1 = soulCfg:getNodeWithKey(tostring(s_id1))
        local itemCfg2 = soulCfg:getNodeWithKey(tostring(s_id2))
        -- local quality1 = itemCfg1:getNodeWithKey("quality"):toInt()
        -- local quality2 = itemCfg2:getNodeWithKey("quality"):toInt()
        
        local exp1 = self.m_tSoulData[tostring(data1[1])].exp + self.m_tSoulData[tostring(data1[1])].pre_exp
        local exp2 = self.m_tSoulData[tostring(data2[1])].exp + self.m_tSoulData[tostring(data2[1])].pre_exp

        flag1 = soulPos[tostring(data1[1])] or 0
        flag2 = soulPos[tostring(data2[1])] or 0
        if flag1 == flag2 then
            if s_id1 == s_id2 then
                -- if s_id1 == s_id2 then
                --     return tonumber(s_id1) > tonumber(s_id2)
                -- else
                    return tonumber(exp1) > tonumber(exp2)
                -- end
            else
                return s_id1 > s_id2
            end
        else
            return flag1 > flag2
        end
    end
    table.sort( self.m_tsidData, sortFunc )
    return self.m_tsidData,soulPos
end

function M:getYingHunSidData2(  )
    local soulCfg = getConfig(game_config_field.soul_detail)
    self.s_id_table = {} --取detail表里的id
    for k,v in pairs(self.m_tSoulData ) do
        self.s_id_table[#self.s_id_table + 1] = v.s_id
    end
    local sortFun = function ( data1,data2 )
     return tonumber(data1) < tonumber(data2)
    end
    table.sort(self.s_id_table,sortFun)
    cclog2(self.s_id_table,"7897979797979")
    self.s_Id_table = {}
    for i=1,#self.s_id_table do
        if i <= 1 then
            self.s_Id_table[#self.s_Id_table + 1] = self.s_id_table[1]
        elseif i > 1 and self.s_Id_table[#self.s_Id_table] ~= self.s_id_table[i] then
            self.s_Id_table[#self.s_Id_table + 1] = self.s_id_table[i]
        end
    end
    cclog2(self.s_Id_table,"4546464564646")
    self.m_tsidData = {} 
    for i=1, game_util:getTableLen(self.s_Id_table) do
        local kapai = {}
        local index = 0
        for k,v in pairs(self.m_tSoulData ) do
            if self.s_Id_table[i] == v.s_id then
                kapai[ index+ 1] = v.id
                index = index + 1
            end
        end
        table.insert(self.m_tsidData,kapai)
    end
    


    -- self.soulIdPos = {}
    -- local tempAllsoul = game_data:getAllGodSoulPosData();
    -- for i=1,3 do
    --     for key,soulTable in pairs(tempAllsoul[i]) do
    --         for k,v in pairs(soulTable) do
    --             if v ~= "0" and v ~= "-1" then
    --                 self.soulIdPos[v] = 1
    --             end
    --         end
    --     end
    -- end

    -- local flag1,flag2
    -- local function sortFunc(data1,data2)
    --     local itemData1 = self.m_tSoulData[tostring(data1[1])]
    --     local itemData2 = self.m_tSoulData[tostring(data2[1])]
    --     local s_id1 = itemData1.s_id
    --     local s_id2 = itemData2.s_id
    --     local itemCfg1 = soulCfg:getNodeWithKey(tostring(s_id1))
    --     local itemCfg2 = soulCfg:getNodeWithKey(tostring(s_id2))
    --     -- local quality1 = itemCfg1:getNodeWithKey("quality"):toInt()
    --     -- local quality2 = itemCfg2:getNodeWithKey("quality"):toInt()
        
    --     local exp1 = self.m_tSoulData[tostring(data1[1])].exp + self.m_tSoulData[tostring(data1[1])].pre_exp
    --     local exp2 = self.m_tSoulData[tostring(data2[1])].exp + self.m_tSoulData[tostring(data2[1])].pre_exp

    --     flag1 = self.soulIdPos[tostring(data1[1])] or 0
    --     flag2 = self.soulIdPos[tostring(data2[1])] or 0
    --     if flag1 == flag2 then
    --         if s_id1 == s_id2 then
    --             -- if s_id1 == s_id2 then
    --             --     return tonumber(s_id1) > tonumber(s_id2)
    --             -- else
    --                 return tonumber(exp1) > tonumber(exp2)
    --             -- end
    --         else
    --             return s_id1 > s_id2
    --         end
    --     else
    --         return flag1 > flag2
    --     end
    -- end
    -- table.sort( self.m_tsidData, sortFunc )
    -- cclog2(self.m_tsidData,"12313456464789")
    return self.m_tsidData
end


--[[--
    更新称号数据
]]
function M.updateTitleDataByJsonData(self, jsonData)
    if not ( jsonData and jsonData:getFormatBuffer() ) then return end
    self.m_all_title = json.decode(jsonData:getFormatBuffer()) or {}
end

--[[--
   获得称号数据
]]
function M.getAllTitle(self)
    return self.m_all_title
end

--[[--
   设置战斗类型
]]
function M.setGuildHighWarVersion(self, version)
    self.m_guild_high_war_version = version;
end

--[[--
   获得战斗类型
]]
function M.getGuildHighWarVersion(self)
    return self.m_guild_high_war_version
end

function M:setNewCombat(combat)
    self.m_old_combat = self.m_newCombat or 0
    self.m_newCombat = math.floor(combat)
end

function M:getChangedCombat()
    return self.m_newCombat,self.m_old_combat, self.m_newCombat - self.m_old_combat
end

---@param self M类的实例
---@param id number 法宝ID
---@return boolean 检查法宝是否正在使用中
function M.checkMagicInUsing(self, id)
    local itemData,itemCfg = self:getMagicDataById(id)
    -- 获取不同位置的法宝数据
    local m_tMagicPosData1 = self:getGodMagicPosData1()
    local m_tMagicPosData2 = self:getGodMagicPosData2()
    local m_tMagicPosData3 = self:getGodMagicPosData3()
    
    -- 检查id是否在各位置的法宝数据中
    local godflag1 = game_util:godEquipeidInTableById(id, m_tMagicPosData1)
    local godflag2 = game_util:godEquipeidInTableById(id, m_tMagicPosData2)
    local godflag3 = game_util:godEquipeidInTableById(id, m_tMagicPosData3)

    -- 检查法宝是否在指定位置，此处忽略了返回的第二个参数
    local existFlag, _ = self:magicInMagicPos(tonumber(itemCfg.talisman_type), id)
    -- 检查神魔法宝是否在指定位置
    local godexistFlag = self:godmagicInMagicPos(tonumber(itemCfg.talisman_type), id)
    -- 检查法宝是否在加成中
    local BonusFlag, _ = self:magicInBonus2(tonumber(itemCfg.talisman_type), id)
    
    -- 检查虫洞
    local existFlag_wormhole = self:isinTalismanWormholeByid(id)
    
    -- 如果id在任何位置的法宝数据中，或法宝在指定位置或加成中，则返回true，否则返回false
    if godflag1 == true or godflag2 == true or godflag3 == true or (existFlag or godexistFlag or BonusFlag) or existFlag_wormhole then
        return true
    else
        return false
    end
end

function M.getGlobalIdx(self)
    self.m_globalIdx =  self.m_globalIdx + 1
    return self.m_globalIdx
end

--[[
    神域战场首页战斗力保存
]]

function M.getGodfieldComber( self )
    return self.m_godfield_comber
end
--[[
    神域战场首页战斗力保存
]]

function M.setGodfieldComber( self,combat )
    self.m_godfield_comber = combat
end

--[[--
    通过json数据设置bagde数据  徽章
]]
function M.setBadgeByJsonData(self,jsonData )
    if jsonData == nil then return end

    self.m_badgeData = json.decode(jsonData:getFormatBuffer()) or {};
    if self.m_badgeData ~= nil and type(self.m_badgeData) == "table" then
        for k,v in pairs(self.m_badgeData) do
            self.m_badgeIdTable[#self.m_badgeIdTable + 1] = k;
        end
    end
end

--[[--
    更新徽章数据
]]
function M.updateOneBadgeDataByJsonData(self,jsonData)
    if jsonData == nil then return end
    local itemData = json.decode(jsonData:getFormatBuffer());
    local badgeId = jsonData:getKey();
    if self.m_badgeData[badgeId] == nil then
        self.m_badgeIdTable[#self.m_badgeIdTable + 1] = badgeId
    end
    self.m_badgeData[badgeId] = itemData;
end
--[[--
    更新徽章数据
]]
function M.updateMoreBadgeDataByJsonData(self,jsonData)

    if jsonData == nil then return end
    local itemCount = jsonData:getNodeCount();
    for i=1,itemCount do
        self:updateOneBadgeDataByJsonData(jsonData:getNodeAt(i-1));
    end
end


--[[--
    通过id移除装备数据
]]
function M.removeOneBadegDataById(self,itemId)
    itemId = tostring(itemId);
    local removeIndex = nil;
    for k,v in pairs(self.m_badgeIdTable) do
        if v == itemId then
            removeIndex = k;
            break;
        end
    end
    if removeIndex ~= nil then
        table.remove(self.m_badgeIdTable,removeIndex);
        self.m_badgeData[itemId] = nil;
    end
end
--[[--
    通过id表格移出装备数据
]]
function M.removeMoreBadgeDataByIdTable(self,itemIds)
    for k,v in pairs(itemIds) do
        self:removeOneBadegDataById(v);
    end
end

--[[--
   获得全部徽章
]]
function M.getAllBadgeData(self)
    return self.m_badgeData
end

--[[--
   获得全部徽章Id
]]
function M.getAllBadgeIdData(self)
    return self.m_badgeIdTable
end

--[[
    获取指定徽章数据
]]
function M.getBadgeDataById( self,badgeId )
    local badgeData = self.m_badgeData[tostring(badgeId)];
    if badgeData == nil then return nil,nil end
    local badge_cfg = getConfig(game_config_field.badge);
    local badgeCfg = badge_cfg:getNodeWithKey(tostring(badgeData.c_id));
    return badgeData,badgeCfg
end

--离线派遣
function M.setDispatchTab( self,dispatchTab )
    self.m_dispatch_tab = dispatchTab or {}
end
function M.getDispatchTab( self )
    return self.m_dispatch_tab
end

return M;��