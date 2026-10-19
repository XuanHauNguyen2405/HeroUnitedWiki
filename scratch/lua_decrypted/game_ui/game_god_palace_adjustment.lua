
--- 编队信息 
local game_god_palace_adjustment = {
    m_formation_center_layer = nil,
    m_currentFormationId = nil,
    m_selFormationId = nil,--选择的阵型
    m_changeFlag = nil,
    m_openType = nil,
    m_formation_layer = nil,
    m_root_layer = nil,
    m_formation_label = nil,
    m_selHeroUi = nil,
    m_selEquipUi = nil,
    m_scroll_view_tips = nil,
    m_sel_list_view_item = nil,
    m_combat_label = nil,
    m_guildNode = nil,
    m_back_btn = nil,

    m_life_label = nil,
    m_physical_atk_label = nil,
    m_magic_atk_label = nil,
    m_def_label = nil,
    m_speed_label = nil,
    m_life_label2 = nil,
    m_physical_atk_label2 = nil,
    m_magic_atk_label2 = nil,
    m_def_label2 = nil,
    m_speed_label2 = nil,

    m_equip_layer = nil,
    m_gem_layer = nil,
    m_anim_node = nil,
    m_ccbNode = nil,
    m_posIndex = nil,
    m_tempTeamData = nil,
    m_tempEquipPosData = nil,
    m_teamPosNodeTab = nil,
    m_sel_bg = nil,
    m_fate_node = nil,
    m_fate_detail_node = nil,
    m_fate_label = nil,
    m_fate_detail_label = nil,
    m_openTab = nil,
    m_tempSelIndex = nil,
    m_tempCombatValue = nil,

    m_tab_btn_1 = nil,
    m_tab_btn_2 = nil,
    m_tab_btn_3 = nil,
    m_adjust1 = nil,
    m_adjust2 = nil,
    m_scrollView = nil,
    m_tempFriendData = nil,
    m_tempDestinyData = nil,

    m_teamIndex = nil;
    select_temp_id = nil,
    m_title_node = nil,
    m_chainTab = nil,
    m_chainTabBackUp = nil,
    m_combatNumberChangeNode = nil,
    m_selEquipId = nil,
    m_oneFateScrollView = nil,
    m_tempGemPosData = nil,
    m_selGemPos = nil,
    m_guide_step = nil,
    m_spr_mingyunnode = nil,
    m_node_infodetailBoar = nil,
    m_spr_infoBoar = nil,
    m_activation_node = nil,
    m_fateDataTab = nil,
    m_replace_btn = nil,
    m_assistant_detail_label = nil,
    m_ability2OpenFlag = nil,
    m_teamGemOpenFlag = nil,

    m_btn_index = nil,  --选择的哪个阵型（1，2，3）
    m_teamTab = nil,
    m_EquipPosDataTab = {},
    m_GemPosDataTab = {},
    m_tempTeamData2 = {},
    m_tempTeamData3 = {},
    m_tempTeamData1 = {},
    m_tempEquipPosData1 = {},
    m_tempEquipPosData2 = {},
    m_tempEquipPosData3 = {},
    m_tempGemPosData1 = {},
    m_tempGemPosData2 = {},
    m_tempGemPosData3 = {},
    m_selFormationId1 = {},
    m_selFormationId2 = {},
    m_selFormationId3 = {}, 
    teamflag1 = nil,
    teamflag2 = nil,
    teamflag3 = nil,
    m_teamAllPos = {},
    m_tempEquipData = {},
    is_formation = nil,
    team_index = nil,
    myformation = nil,
    m_MedalPosDataTab = {},
    m_SoulPosDataTab = {},
    m_tempMedalPosData =nil,
    m_tempMedalPosData1 = nil,
    m_tempMedalPosData2 = nil,
    m_tempMedalPosData3 = nil,
    m_tempSoulPosData = nil,
    m_tempSoulPosData1 = nil,
    m_tempSoulPosData2 = nil,
    m_tempSoulPosData3 = nil,
    m_equip_openType = nil,

};
--阵型的配置
-- local formationConfig = {{0,1,0,1,0},{1,1,1,1,1},{0,0,0,0,0},{1,0,1,0,1},{0,1,1,1,0},{1,0,0,0,1}} 
local tipsStrTab = {"点击角色框以更换角色","拖动角色框可以互换位子","主战人员中必须有一位角色"}
local formationPosTab = {{key="position_a",x=0.82,y=0.83},{key="position_b",x=0.82,y=0.5},{key="position_c",x=0.82,y=0.17},{key="position_d",x=0.5,y=0.83},{key="position_e",x=0.5,y=0.5},{key="position_f",x=0.5,y=0.17}};

--[[--
    销毁 game_god_palace_adjustment
]]
function game_god_palace_adjustment.destroy(self)
    -- body
    cclog("-----------------game_god_palace_adjustment destroy-----------------");
    self.m_formation_center_layer = nil;
    self.m_currentFormationId = nil;
    self.m_selFormationId = nil;
    self.m_changeFlag = nil;
    -- self.m_openType = nil;
    self.m_formation_layer = nil;
    self.m_root_layer = nil;
    self.m_formation_label = nil;
    self.m_selHeroUi = nil;
    self.m_selEquipUi = nil;
    self.m_scroll_view_tips = nil;
    self.m_sel_list_view_item = nil;
    self.m_combat_label = nil;
    self.m_guildNode = nil;
    self.m_back_btn = nil;

    self.m_life_label = nil;
    self.m_physical_atk_label = nil;
    self.m_magic_atk_label = nil;
    self.m_def_label = nil;
    self.m_speed_label = nil;
    self.m_life_label2 = nil;
    self.m_physical_atk_label2 = nil;
    self.m_magic_atk_label2 = nil;
    self.m_def_label2 = nil;
    self.m_speed_label2 = nil;
    self.m_equip_layer = nil;
    self.m_anim_node = nil;
    self.m_ccbNode = nil;
    self.m_posIndex = nil;
    self.m_tempTeamData = nil;
    self.m_teamPosNodeTab = nil;
    self.m_sel_bg = nil;
    self.m_fate_node = nil;

    self.m_fate_detail_node = nil;
    self.m_fate_label = nil;
    self.m_fate_detail_label = nil;
    self.m_openTab = nil;
    self.m_tempSelIndex = nil;
    self.m_tempCombatValue = nil;
    self.select_temp_id = nil;
    self.m_title_node = nil;
    self.m_chainTab = nil;
    self.m_chainTabBackUp = nil;
    self.m_combatNumberChangeNode = nil;
    self.m_selEquipId = nil;
    self.m_tempEquipPosData = nil;
    self.m_oneFateScrollView = nil;
    self.m_tempGemPosData = nil;
    self.m_selGemPos = nil;
    self.m_guide_step = nil;
    self.m_gem_layer = nil;
    self.m_spr_mingyunnode = nil;
    self.m_node_infodetailBoar = nil;
    self.m_spr_infoBoar = nil;
    self.m_teamIndex = nil;
    self.m_activation_node = nil;
    self.m_fateDataTab = nil;
    self.m_replace_btn = nil;
    self.m_assistant_detail_label = nil;
    self.m_ability2OpenFlag = nil;
    self.m_teamGemOpenFlag = nil;

    self.m_btn_index = nil;
    self.m_teamTab = nil;
    self.m_EquipPosDataTab = nil;
    self.m_GemPosDataTab = nil;
    self.m_tempTeamData2 = nil;
    self.m_tempTeamData3 = nil;
    self.m_tempTeamData1 = nil;
    self.m_tempEquipPosData1 = nil;
    self.m_tempEquipPosData2 = nil;
    self.m_tempEquipPosData3 = nil;
    self.m_tempGemPosData1 = nil;
    self.m_tempGemPosData2 = nil;
    self.m_tempGemPosData3 = nil;
    self.m_selFormationId1 = nil;
    self.m_selFormationId2 = nil;
    self.m_selFormationId3 = nil;
    self.teamflag1 = nil;
    self.teamflag2 = nil;
    self.teamflag3 = nil;
    self.m_teamAllPos = nil;
    self.m_tempEquipData = nil;
    self.is_formation = nil;
    self.team_index = nil;
    self.myformation = nil;
    self.m_equip_openType = nil;

    self.m_MedalPosDataTab = nil;
    self.m_SoulPosDataTab = nil;
    self.m_tempMedalPosData = nil;
    self.m_tempMedalPosData1 = nil;
    self.m_tempMedalPosData2 = nil;
    self.m_tempMedalPosData3 = nil;
    self.m_tempSoulPosData = nil;
    self.m_tempSoulPosData1 = nil;
    self.m_tempSoulPosData2 = nil;
    self.m_tempSoulPosData3 = nil;
end
--[[--
    返回
]]
function game_god_palace_adjustment.back(self,type)
  
    local function endCallFunc()
        self:destroy();
    end

    local function responseMethod( tag,gameData )
                -- body
        -- cclog2(gameData," game_godfield_arean gameData111 == ")
        local m_GameData = nil;
        local status = nil;
        local time_count_down = nil;
        if gameData ~= nil and tolua.type(gameData) == "util_json" then
            local data = gameData:getNodeWithKey("data");
            m_GameData = json.decode(data:getFormatBuffer()) or {};
            self.is_formation = m_GameData.is_formation or false
            status = m_GameData.status or 0;
            time_count_down = m_GameData.time_count_down or 0;
            local tempCardTab = {}
        else
            m_GameData = {};
        end
        -- cclog2(self.m_openType," self.m_openType   ===")
        if self.is_formation == true then 
            if self.m_openType == "game_godfield_main" then
                -- local function responseMethod( tag,gameData )
                     -- local data = gameData:getNodeWithKey("data");
                         -- data = json.decode(data:getFormatBuffer()) or {};
                         game_scene:enterGameUi("game_godfield_main",{gameData = gameData})
                     -- end
                -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_index"), http_request_method.GET, {},"god_field_index")
            elseif self.m_openType == "game_godfield_Star_zhenxing" then
                local function responseMethod(  tag,gameData )
                    game_scene:addPop("game_godfield_Star_zhenxing",{gameData = gameData,openType = "adjust"})
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("zodiac_god_field_ids"),http_request_method.GET,nil,"zodiac_god_field_ids")
            end
        else
            game_util:addMoveTips({text = "Bố trí chủ tướng cho 3 trận hình"});
        end
    end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_index"), http_request_method.GET, {},"god_field_index")
end

function game_god_palace_adjustment.sendChangedData(self,btnTag,t_params)
        local function tempFunction()
            if btnTag == 1 then--返回
                self:back();
            elseif btnTag == 5071 then
                game_scene:enterGameUi("game_badge_advanced", {gameData = nil})
            elseif btnTag == 100 then
                game_scene:enterGameUi("skills_replacement_scene",{gameData = nil,selPosIndex = t_params.posIndex});
                self:destroy();
            end
        end
        if self.m_changeFlag == true or self.m_selFormationId ~= self.m_currentFormationId then
            local function responseMethod(tag,gameData)
                if gameData ~= nil then
                    local data = gameData:getNodeWithKey("data");
                    -- cclog2(data,"data===3=3==4=4==4=5")
                    game_data:setGodCardsPosByJsonData(data:getNodeWithKey("god_field_ids"));
                    game_data:setGodEquipPosDataByJsonData1(data:getNodeWithKey("equip_pos_1"));
                    game_data:setGodEquipPosDataByJsonData2(data:getNodeWithKey("equip_pos_2"));
                    game_data:setGodEquipPosDataByJsonData3(data:getNodeWithKey("equip_pos_3"));
                    game_data:setGodGemPosDataByJsonData1(data:getNodeWithKey("gem_pos_1"));
                    game_data:setGodGemPosDataByJsonData2(data:getNodeWithKey("gem_pos_2"));
                    game_data:setGodGemPosDataByJsonData3(data:getNodeWithKey("gem_pos_3"));
                    game_data:setGodSoulPosDataByJsonData1(data:getNodeWithKey("soul_pos_1"));
                    game_data:setGodSoulPosDataByJsonData2(data:getNodeWithKey("soul_pos_2"));
                    game_data:setGodSoulPosDataByJsonData3(data:getNodeWithKey("soul_pos_3"));
                    game_data:setGodMedalPosDataByJsonData1(data:getNodeWithKey("medal_pos_1"));
                    game_data:setGodMedalPosDataByJsonData2(data:getNodeWithKey("medal_pos_2"));
                    game_data:setGodMedalPosDataByJsonData3(data:getNodeWithKey("medal_pos_3"));
                    self.m_changeFlag = false;
                    tempFunction();
                else
                    game_util:addMoveTips({text = "Yêu cầu số liệu thất bại, thao tác lại!"});
                end
            end
            -- align_1=1_2&align_2=3_4

            --阵型
            local prarms = {};
            local teamAll = self.m_teamTab;
            local tempPrarms = {};
            local selFormationAll = {self.m_selFormationId1,self.m_selFormationId2,self.m_selFormationId3}
            for i=1,3 do
                local formation = "god_formation_".. i .."=";
                local teamTable = teamAll[tostring(i)];
                if table.getn(teamTable) == 9 then
                    for k,v in pairs(teamTable) do
                        if v == 0 or v == "0" then
                            table.remove(teamTable,k) 
                        end
                    end
                else

                end
                tempPrarms[i] = self:sendChangedTeamDataAll(formation,teamTable,selFormationAll[i])
            end
            prarms = tempPrarms[1] .."&" .. tempPrarms[2] .."&" .. tempPrarms[3];

            local tempEquipPos1 = {};
            local tempEquipPos2 = {};
            local tempEquipPos3 = {};
            local tempGemPos1 = {};
            local tempGemPos2 = {};
            local tempGemPos3 = {};
            local tempSoulPos1 = {};
            local tempSoulPos2 = {};
            local tempSoulPos3 = {};
            local tempMedalPos1 = {};
            local tempMedalPos2 = {};
            local tempMedalPos3 = {};

            local tempEquipAll = {tempEquipPos1,tempEquipPos2,tempEquipPos3}
            local tempGemAll = {tempGemPos1,tempGemPos2,tempGemPos3};
            local tempSoulAll = {tempSoulPos1,tempSoulPos2,tempSoulPos3}
            local tempMedalAll = {tempMedalPos1,tempMedalPos2,tempMedalPos3}

            local SoulAll = game_data:getAllGodSoulPosData();
            local MedalAll = game_data:getAllGodMedalPosData();
            for i=1,3 do
                for j=1,10 do
                    table.insert(tempEquipAll[i],j-1,self.m_EquipPosDataTab[i][tostring(j-1)])
                    table.insert(tempGemAll[i],j-1,self.m_GemPosDataTab[i][tostring(j-1)])
                    table.insert(tempMedalAll[i],j-1,MedalAll[i][tostring(j - 1)])
                    table.insert(tempSoulAll[i],j-1,SoulAll[i][tostring(j - 1)])
                end
                
            end
            
            for j=1,3 do
                for i=1,10 do
                    if i < 6 then
                        prarms = prarms .. "&equip_" .. (j*2+1) .. i .. "="
                    else
                        prarms = prarms .. "&equip_" .. (j*2+2) .. (i-5) .. "="
                    end
                    for k,v in pairs(tempEquipAll[j][tonumber(i-1)]) do
                        prarms = prarms .. v .. (k == 4 and "" or "_")
                    end
                end
            end

            for j=1,3 do
                for i=1,9 do
                    -- if i < 6 then
                        prarms = prarms .. "&gem_" .. (j).. "_" .. i .. "="
                    -- else
                    --     prarms = prarms .. "&gem_" .. (j*2+2) .. (i-5) .. "="
                    -- end
                    for k,v in pairs(tempGemAll[j][tonumber(i-1)]) do
                        prarms = prarms .. v .. (k == 4 and "" or "_")
                    end
                end
            end

            for j=1,3 do
                for i=1,9 do
                    -- if i < 6 then
                        prarms = prarms .. "&medal_" .. (j).. "_" .. i .. "="
                    -- else
                    --     prarms = prarms .. "&gem_" .. (j*2+2) .. (i-5) .. "="
                    -- end
                    for k,v in pairs(tempMedalAll[j][tonumber(i-1)]) do
                        prarms = prarms .. v .. (k == 6 and "" or "_")
                    end
                end
            end
            
            for j=1,3 do
                for i=1,9 do
                    -- if i < 6 then
                        prarms = prarms .. "&soul_" .. (j).. "_" .. i .. "="
                    
                        -- cclog2(tempSoulAll[j][tonumber(i-1)],"tempSoulAll[j][tostring(i)]tempSoulAll[j][tostring(i)]")
                        for k,v in pairs(tempSoulAll[j][tonumber(i-1)]) do
                            prarms = prarms .. v .. (k == 6 and "" or "_")
                        end
                    -- end
                end
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("zodiac_set_adjustment"), http_request_method.POST, prarms,"zodiac_set_adjustment")
        else
            tempFunction();
        end
end

function game_god_palace_adjustment.sendChangedTeamDataAll(self,prarms,teamTable,selFormationNum)
    prarms = tostring(prarms);
    if teamTable then
        table.insert(teamTable,selFormationNum,0)
        for k = 1,9 do
            if teamTable[k] == nil  then
                prarms = prarms .. "-1" .. (k == 9 and "" or "_")
            elseif k == selFormationNum then
                prarms = prarms .. "0" .. (k == 9 and "" or "_")
            else
                prarms = prarms .. teamTable[k] .. (k == 9 and "" or "_")
                -- cclog(" teamTable[k]==" ..  teamTable[k])
            end
        end
    end
    return prarms;
end

--[[--
    读取ccbi创建ui
]]
function game_god_palace_adjustment.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then
            
            self:sendChangedData(btnTag);
        elseif btnTag == 11 then
            if self.m_teamIndex == 1 then
                if self.m_posIndex == -1 or self.m_tempTeamData[self.m_posIndex] == "-1" then return end
                self:addSelHeroUi(self.m_posIndex);
            else
                if self.m_posIndex == -1 or self.m_tempFriendData[self.m_posIndex] == "-1" then return end
                self:addFriendSelHeroUi(self.m_posIndex);                
            end
        elseif btnTag > 20 and btnTag < 26 then
            if self.m_posIndex == -1 then return end;
            local heroData,heroCfg = nil,nil;
            if self.m_teamIndex == 1 then
                heroData,heroCfg = self:getTeamCardDataByPos(self.m_posIndex);
            else
                heroData,heroCfg = self:getFriendCardDataByPos(self.m_posIndex);
            end
            if heroData then
                -- game_scene:addPop("game_hero_attr_pop",{selHeroId = heroData.id,posNode=tagNode,attrType = btnTag-20})
            end
        elseif btnTag == 30 then
            local heroData,heroCfg = nil,nil;
            if self.m_teamIndex == 1 then
                heroData,heroCfg = self:getTeamCardDataByPos(self.m_posIndex);
            else
                heroData,heroCfg = self:getFriendCardDataByPos(self.m_posIndex);
            end
            if heroData and heroCfg then
                local function callBack(typeName)

                end
                -- game_scene:addPop("game_hero_info_pop",{tGameData = heroData,openType = 1,callBack = callBack})
            end
        elseif btnTag == 31 then--一件装备
            -- self:autoMatchEquip(self.m_posIndex)
            -- self:refreshHeroInfo(self.m_posIndex);
            -- self:refreshCombatLabel();
        elseif btnTag == 32 then--助威小伙伴激活
        elseif btnTag == 33 then--属性刷新
        elseif btnTag == 41 then
            -- 点击阵型tab按钮
            self.m_btn_index = 1;
            if self.teamflag1 == false then
                self.m_selFormationId = self.m_selFormationId1; 
            end
            self.m_tempTeamData = self.m_tempTeamData1
            self.m_tempEquipPosData = self.m_tempEquipPosData1
            self.m_tempGemPosData = self.m_tempGemPosData1
            self.m_tempMedalPosData = self.m_tempMedalPosData1
            self.m_tempSoulPosData = game_data:getOneGodSoulPosData(self.m_btn_index);
            self:initTeam();
            self.m_check_index = 1
            self.m_combat_label:setString(tostring(self.m_god_combat[1] or 0))
            self.node_bloodDetal:setVisible(false)
            self.nd_badge:setVisible(false)
            self.btn_badge:setVisible(true)
        elseif btnTag == 42 then--阵型2
            self.m_btn_index = 2;
            if self.teamflag2 == false then
                self.m_selFormationId = self.m_selFormationId2; 
            end
            self.m_tempTeamData = self.m_tempTeamData2
            self.m_tempEquipPosData = self.m_tempEquipPosData2
            self.m_tempGemPosData = self.m_tempGemPosData2
            self.m_tempMedalPosData = self.m_tempMedalPosData2
            self.m_tempSoulPosData = game_data:getOneGodSoulPosData(self.m_btn_index);
            self:initTeam();
            self.m_check_index = 2
            self.m_combat_label:setString(tostring(self.m_god_combat[2] or 0))
            self.node_bloodDetal:setVisible(false)
            self.nd_badge:setVisible(false)
            self.btn_badge:setVisible(true)
        elseif btnTag == 43 then--阵型3
            self.m_btn_index = 3;
            if self.teamflag3 == false then
                self.m_selFormationId = self.m_selFormationId3; 
            end
            self.m_tempTeamData = self.m_tempTeamData3
            self.m_tempEquipPosData = self.m_tempEquipPosData3
            self.m_tempGemPosData = self.m_tempGemPosData3
            self.m_tempMedalPosData = self.m_tempMedalPosData3
            self.m_tempSoulPosData = game_data:getOneGodSoulPosData(self.m_btn_index);
            self:initTeam();
            self.m_check_index = 3  
            self.m_combat_label:setString(tostring(self.m_god_combat[3] or 0))  
            self.node_bloodDetal:setVisible(false) 
            self.nd_badge:setVisible(false)
            self.btn_badge:setVisible(true)
        elseif btnTag == 51 or btnTag == 52 then--命运摘要  命运详情
            -- self:refreshFateTabBtn(btnTag - 50);
        elseif btnTag == 61 then--说明 149
            game_scene:addPop("game_active_limit_detail_pop",{enterType = "167"})

        elseif btnTag == 504 then -- 装备zyz
                -- self.m_magic_layer:setVisible(game_data:isViewShowByID(201))
                -- self.m_magic_layer:setTouchEnabled(game_data:isViewShowByID(201))
                self.m_eq_layer:setVisible(true)
                self.m_eq_layer:setTouchEnabled(true)
                self.m_gem_layer:setVisible(self.m_teamGemOpenFlag)
                self.m_gem_layer:setTouchEnabled(self.m_teamGemOpenFlag)
                self.m_fate_detail_node:setVisible(false)
                self.node_bloodDetal:setVisible(false)
                self.nd_badge:setVisible(false)
        elseif btnTag == 506 then
            self.m_gem_layer:setVisible(false)
            self.m_gem_layer:setTouchEnabled(false)
            self.m_magic_layer:setVisible(false)
            self.m_magic_layer:setTouchEnabled(false)
            self.m_eq_layer:setVisible(false)
            self.m_eq_layer:setTouchEnabled(false)
            self.m_fate_detail_node:setVisible(false)
            self.node_bloodDetal:setVisible(true)
            self.btn_openBloodStone:setVisible(false)
            self.nd_badge:setVisible(false)
        elseif btnTag == 5061 then -- 打开赋能界面
            game_scene:enterGameUi("game_bloodStone_index",{})
            self:destroy();
        elseif btnTag == 507 then -- 徽章
            self.m_fate_detail_node:setVisible(false);
            self.m_magic_layer:setVisible(false)
            self.m_magic_layer:setTouchEnabled(false)
            self.m_eq_layer:setVisible(false)
            self.m_eq_layer:setTouchEnabled(false)
            self.m_gem_layer:setVisible(false)
            self.m_gem_layer:setTouchEnabled(false)
            self.nd_badge:setVisible(true)
            self.node_bloodDetal:setVisible(false)

            if self.m_teamIndex == 2 then
                self.m_activation_node:setVisible(false);
            end

            self:refreshBadge()
        elseif btnTag == 5071 then -- 点击第一个徽章
            local pos = self.m_posIndex -- 当前选中位置
            local cardData,cardCfg = self:getTeamCardDataByPos( pos ); -- 当前选中位置英雄信息,可以为nil
            if not cardData then
                return
            end

            local c_id = cardData.c_id
            local hasCfgBadge = self:checkHeroHasBadgeConfig(c_id)
            if not hasCfgBadge then
                game_util:addMoveTips({text = string_config:getTextByKey("badge_tx_1")});
                return 
            end

            local itemOnClick = function(typeName,id)
                if typeName == "exchanged" then
                    local function responseMethod(tag, gameData)
                        self:refreshHeroInfo(self.m_posIndex)
                    end
                    local params = {}
                    params.badge_id = id
                    params.card_id = cardData.id
                    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("badge_set_badge"), http_request_method.GET,params,"badge_set_badge")
                elseif typeName == "unload" then
                    local function responseMethod(tag, gameData)
                        self:refreshHeroInfo(self.m_posIndex)
                    end
                    local params = {}
                    params.card_id = cardData.id
                    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("badge_down_badge"), http_request_method.GET,params,"badge_down_badge")
                end
            end

            local function callBack(typeName,t_param)
                self:sendChangedData(5071);
            end

            if cardData and cardData.badge and cardData.badge ~= "" then
                game_scene:addPop("game_badge_info",{
                    itemOnClick = itemOnClick,
                    curBadgeId = cardData.badge,
                    cardCid = cardData.c_id,
                    callBack = callBack})
            else
                game_scene:addPop("game_badge_select_pop",{
                    itemOnClick = itemOnClick,
                    curBadgeId = cardData.badge,
                    cardCid = cardData.c_id})
            end
        elseif btnTag == 505 then -- 法宝zyz
                self.m_gem_layer:setVisible(false)
                self.m_gem_layer:setTouchEnabled(false)
                -- self.m_magic_layer:setVisible(false)
                -- self.m_magic_layer:setTouchEnabled(false)
                self.m_eq_layer:setVisible(false)
                self.m_eq_layer:setTouchEnabled(false)
                self.m_fate_detail_node:setVisible(true)
                self.node_bloodDetal:setVisible(false)
                self.nd_badge:setVisible(false)
            -- end
        end

    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_adjustment_formation_god.ccbi");

    self.m_node_infodetailBoar = ccbNode:nodeForName("m_node_infodetailBoar")
    self.m_spr_infoBoar = ccbNode:nodeForName("m_spr_infoBoar")
    self.m_formation_layer = ccbNode:layerColorForName("m_formation_layer")
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    self.m_formation_label = ccbNode:labelTTFForName("m_formation_label")
    self.m_scroll_view_tips = ccbNode:scrollViewForName("m_scroll_view_tips")
    self.m_life_label = ccbNode:labelBMFontForName("m_life_label")
    self.m_physical_atk_label = ccbNode:labelBMFontForName("m_physical_atk_label")
    self.m_magic_atk_label = ccbNode:labelBMFontForName("m_magic_atk_label")
    self.m_def_label = ccbNode:labelBMFontForName("m_def_label")
    self.m_speed_label = ccbNode:labelBMFontForName("m_speed_label")
    self.m_life_label2 = ccbNode:labelBMFontForName("m_life_label2")
    self.m_physical_atk_label2 = ccbNode:labelBMFontForName("m_physical_atk_label2")
    self.m_magic_atk_label2 = ccbNode:labelBMFontForName("m_magic_atk_label2")
    self.m_def_label2 = ccbNode:labelBMFontForName("m_def_label2")
    self.m_speed_label2 = ccbNode:labelBMFontForName("m_speed_label2")
    self.m_spr_mingyunnode = ccbNode:nodeForName("m_spr_mingyunnode")
    self.m_equip_layer = ccbNode:layerForName("m_equip_layer")
    self.m_gem_layer = ccbNode:layerForName("m_gem_layer")
    self.m_activation_node = ccbNode:nodeForName("m_activation_node")
    self.m_anim_node = ccbNode:nodeForName("m_anim_node")
    -- self.m_anim_node:removeAllChildrenWithCleanup(true);
    self.m_sel_bg = ccbNode:spriteForName("m_sel_bg")
    self.m_replace_equip_btn = ccbNode:controlButtonForName("m_replace_equip_btn")
    self.m_replace_equip_btn:setVisible(false)
    self.m_sel_bg:setVisible(false);
    self.m_fate_node = ccbNode:nodeForName("m_fate_node")
    self.m_fate_detail_node = ccbNode:nodeForName("m_fate_detail_node")
    self.nd_badge = ccbNode:nodeForName("nd_badge")
    self.nd_badge:setVisible(false)

    local btn_fate_refresh = ccbNode:controlButtonForName("btn_fate_refresh")
    btn_fate_refresh:setVisible(false)
    local m_explain_btn = ccbNode:controlButtonForName("m_explain_btn")
    m_explain_btn:setVisible(false)
    -- local labelsize = self.m_fate_node:getContentSize();
    -- self.m_fate_label = game_util:createRichLabelTTF({text = "",dimensions = labelsize,textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = nil,color = ccc3(221,221,192)})
    -- self.m_fate_label:setAnchorPoint(ccp(0, 0.25));
    -- self.m_fate_node:addChild(self.m_fate_label)
    local labelsize = CCSizeMake(self.m_fate_detail_node:getContentSize().width, self.m_fate_detail_node:getContentSize().height);
    local scrollView = CCScrollView:create(labelsize);
    scrollView:setDirection(kCCScrollViewDirectionVertical);
    self.m_fate_detail_node:addChild(scrollView,2,2);
    self.m_oneFateScrollView = scrollView;
   
    self.m_equip_layer:setVisible(true);
    -- self.m_fate_label:setVisible(true)
    self.m_activation_node:setVisible(false);
    self.m_fate_detail_node:setVisible(false);

    self.m_combat_label = ccbNode:labelBMFontForName("m_combat_label")
    self.m_combat_label:setVisible(true);
    self.m_combat_label:setString(tostring(self.m_god_combat[self.m_check_index] or 0))
    local pX,pY = self.m_combat_label:getPosition();
    -- self.m_combatNumberChangeNode = game_util:createExtNumberChangeNode({labelType = 2});
    -- self.m_combatNumberChangeNode:setPosition(ccp(pX, pY));
    -- self.m_combatNumberChangeNode:setAnchorPoint(ccp(0, 0.5));
    -- self.m_combat_label:getParent():addChild(self.m_combatNumberChangeNode);
    -- self.m_combatNumberChangeNode:setCurValue(0,false);

    self.m_back_btn = ccbNode:controlButtonForName("m_back_btn")
    
    self.btn_badge = ccbNode:controlButtonForName("btn_badge");
    self.m_tab_btn_1 = ccbNode:controlButtonForName("m_tab_btn_1");
    self.m_tab_btn_2 = ccbNode:controlButtonForName("m_tab_btn_2");
    self.m_tab_btn_3 = ccbNode:controlButtonForName("m_tab_btn_3");
    self.m_replace_btn = ccbNode:controlButtonForName("m_replace_btn");
    self.m_replace_btn:setVisible(false)
    self.m_adjust1 = ccbNode:nodeForName("m_adjust1");
    self.m_adjust2 = ccbNode:nodeForName("m_adjust2");
    self.m_scrollView = ccbNode:scrollViewForName("m_scrollView");
    self.m_title_node = ccbNode:nodeForName("m_title_node");

    self.m_tab_btn_1:setEnabled(true);
    self.m_tab_btn_2:setEnabled(true);
    self.m_tab_btn_3:setEnabled(true);
    local btnTab = {self.m_tab_btn_1,self.m_tab_btn_2,self.m_tab_btn_3}
    if self.team_index then
        btnTab[self.team_index]:setEnabled(false);
    else
        btnTab[1]:setEnabled(false);
    end
    self.m_adjust1:setVisible(true);
    self.m_adjust2:setVisible(false);

    self.m_ccbNode = ccbNode;

    if not self.m_teamGemOpenFlag then 
        self.m_gem_layer:setVisible(false)
        self.m_equip_layer:setPositionY(80)
    end
    -- self:refreshFateTabBtn(1);
    self.m_medal_btn = ccbNode:controlButtonForName("m_medal_btn")
    self.m_medal_btn:setVisible(false)

    self.m_soul_btn = ccbNode:controlButtonForName("m_soul_btn")
    self.m_soul_btn:setVisible(false)

    local m_saint_stone_btn=ccbNode:controlButtonForName("btn_saint_stone")
    m_saint_stone_btn:setVisible(false)
    local m_sp_btn_back=ccbNode:spriteForName("sp_btn_back")
    m_sp_btn_back:setVisible(false)
    local m_btn_show_more=ccbNode:controlButtonForName("btn_show_more")
    m_btn_show_more:setVisible(false)
    self.m_eq_layer = ccbNode:layerForName("m_eq_layer")
    self.m_eq_layer:setVisible(true)
    self.m_magic_layer = ccbNode:layerForName("m_magic_layer")
    self.m_magic_layer:setVisible(false)
    self.m_magic_node = ccbNode:nodeForName("m_magic_btnnode")
    self:createAnim()


    self.node_bloodDetal = ccbNode:nodeForName("node_bloodDetal")
    self.node_bloodDetal:setVisible(false)
    self.btn_openBloodStone = ccbNode:nodeForName("btn_openBloodStone")

    return ccbNode;
end



function game_god_palace_adjustment:createAnim()
    self.m_magic_node:removeAllChildrenWithCleanup(true)
    local onAnimSectionEnd = function(animNode, theId,theLabelName)
        animNode:playSection(theLabelName)
    end
    local anim = game_anim:create("effect_anniu.swf.sam",0,"effect_anniu-hd.plist");
    if anim then
        anim:registerScriptTapHandler(onAnimSectionEnd)
        game_anim:playSection(anim,"effect")
        self.m_magic_node:addChild(anim,1,3)
    end
end

--[[--
    
]]
function game_god_palace_adjustment.getTeamCardDataByPos(self,posIndex)
    local cardId = self.m_tempTeamData[posIndex]
    -- cclog2(cardId,"-=-=-=-=-=-=-=-=-=")
    if cardId == "0" or cardId == "-1" then
        return nil,nil
    end
    if self.m_card_info and self.m_card_info[tostring(cardId)] then
        local cardData = self.m_card_info[tostring(cardId)];
        local character_detail_cfg = getConfig(game_config_field.character_detail);
        local heroCfg = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id));
        return cardData,heroCfg
    else
        local heroData,heroCfg = game_data:getCardDataById(tostring(cardId))
        if heroData and heroCfg then
            return heroData,heroCfg
        else
            return nil,nil
        end
    end
end

--[[--
    创建动画
]]
function game_god_palace_adjustment.createCardAnimByPosIndex(self,posIndex)
    local heroData,heroCfg = self:getTeamCardDataByPos(posIndex)
    return self:createCardAnimByData(heroData,heroCfg);
end

--[[
    获取小伙伴位置上的动画
]]
function game_god_palace_adjustment.createCardAnimByData( self, heroData,heroCfg,animFlag)
    local animNode = nil;
    local character_ID = -1;
    if heroData and heroCfg then
        character_ID = heroCfg:getNodeWithKey("character_ID"):toInt();
        local ainmFile = heroCfg:getNodeWithKey("animation"):toStr();
        animFlag = animFlag == nil and true or animFlag
        if animFlag then
            animNode = game_util:createIdelAnim(ainmFile,0,heroData,heroCfg);
        else
            animNode = game_util:createCardImgByCfg(heroCfg);
        end
        if animNode then
            local itemSize = animNode:getContentSize();
            if animFlag == false then
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_light_down.png")
                if spriteFrame then
                    local tempSprite = CCSprite:createWithSpriteFrame(spriteFrame)
                    tempSprite:setAnchorPoint(ccp(0.5,0.1))
                    tempSprite:setPositionX(itemSize.width*0.5)
                    animNode:addChild(tempSprite)
                end
                local spriteFrame2 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_light_up.png")
                if spriteFrame2 then
                    local tempSprite = CCSprite:createWithSpriteFrame(spriteFrame2)
                    tempSprite:setAnchorPoint(ccp(0.5,0.1))
                    tempSprite:setPositionX(itemSize.width*0.5)
                    animNode:addChild(tempSprite,1000,1000)
                end
            else
                animNode:setRhythm(1);
            end
            animNode:setAnchorPoint(ccp(0.5,0));
            local name_after = heroData.step < 1 and "" or ("+" .. heroData.step);
            local tempLabel = CCLabelTTF:create("Lv." .. heroData.lv .. "/" .. heroData.level_max .. "\n" .. name_after,TYPE_FACE_TABLE.Arial_BoldMT,10);
            tempLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
            tempLabel:setPosition(ccp(itemSize.width*0.5 - 50,97));
            tempLabel:setAnchorPoint(ccp(0,0.5));
            animNode:addChild(tempLabel,100,100)            local occupation_cfg = getConfig(game_config_field.occupation);
            local occupation_item_cfg = occupation_cfg:getNodeWithKey(ainmFile)
            if occupation_item_cfg then
                local occupationType = occupation_item_cfg:toInt();
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    local occupation_icon = CCSprite:createWithSpriteFrame(spriteFrame)
                    occupation_icon:setPosition(ccp(itemSize.width*0.5 + 57,98));
                    occupation_icon:setAnchorPoint(ccp(1,0.5));
                    animNode:addChild(occupation_icon);
                end
            end
            animNode:setScale(0.66);
        end
    end
    return animNode,character_ID
end

--[[--
    初始化编队信息
]]
function game_god_palace_adjustment.initTeamFormation(self,formation_layer)
    self.m_tempSelIndex = -1
    local level = game_data:getUserStatusDataByKey("level");
    local itemIcon = nil;
    local headIconSpr = nil;
    local tempLock = nil;
    local character_detail_cfg = getConfig("character_detail");
    local tempLockIndex,selLevel = -1,100;
    local tempTxt = nil;
    local tempGuildNode = nil;
    for i=1,9 do
        itemIcon = self.m_ccbNode:spriteForName("m_pos_" .. i)
        formation_layer:reorderChild(itemIcon,-1000)
        local headIconBgSize = itemIcon:getContentSize();
        itemIcon:removeAllChildrenWithCleanup(true);
        if self.m_openTab[i] == 1 then
        else
            tempLock = CCSprite:createWithSpriteFrameName("dw_suo.png");
            tempLock:setPosition(ccp(headIconBgSize.width/2,headIconBgSize.height/2));
            itemIcon:addChild(tempLock);
            local openLevel = TEAM_LOCK_TIPS_TAB[i].openLevel
            if level < openLevel then
                local headIconSpr = CCSprite:createWithSpriteFrameName(tostring(TEAM_LOCK_TIPS_TAB[i].lockImg));
                if headIconSpr then
                    local headIconBgSize = itemIcon:getContentSize();
                    headIconSpr:setPosition(ccp(headIconBgSize.width*0.5, headIconBgSize.height*0.5))
                    itemIcon:addChild(headIconSpr,2,2)
                end
            end
        end
        local animNode,character_ID = self:createCardAnimByPosIndex(i)
        -- cclog("animNode ================ " .. tostring(animNode))
        if animNode then
            animNode:setPosition(ccp(headIconBgSize.width*0.5,headIconBgSize.height*0.1));
            itemIcon:addChild(animNode,1,1);
            self:setPositionBg(i,true);
            if self.m_tempSelIndex == -1 then
                self.m_tempSelIndex = i;
            end
        else
            self:setPositionBg(i,false);
        end
    end
    self:formationOpenAnim();

    self:initAdjustmentFormationTouch(self.m_formation_layer);
    self:initEquipLayerTouch(self.m_equip_layer);
    
end


function game_god_palace_adjustment.createFormationOpenAnimByPos(self,pos)
    local itemIcon = self.m_ccbNode:spriteForName("m_pos_" .. pos)
    if itemIcon then
        local function callBackFunc()
            if pos == 5 then
                local addSpr = CCSprite:createWithSpriteFrameName("dw_wenzi_tianjia.png");
                if addSpr then
                    local headIconBgSize = itemIcon:getContentSize();
                    addSpr:setPosition(ccp(headIconBgSize.width*0.5, headIconBgSize.height*0.5))
                    itemIcon:addChild(addSpr,2,2)
                end
            end
        end
        local anim_zhandouli = game_util:createEffectAnimCallBack("animi_zhenxing_split",1.0,false,callBackFunc);
        if anim_zhandouli then
            local pX,pY = itemIcon:getPosition();
            anim_zhandouli:setPosition(ccp(pX,pY))
            itemIcon:getParent():addChild(anim_zhandouli,1000);
            game_sound:playUiSound("zhakai2")
        end
    end
end

function game_god_palace_adjustment.formationOpenAnim(self)
    local cardNumData = game_data:getBattleCardNumData()
    local position_num = math.min(cardNumData.position_num,5)
    local temp_position_num = math.min(cardNumData.temp_position_num,5)
    local alternate_num = math.min(cardNumData.alternate_num,3)
    local temp_alternate_num = math.min(cardNumData.temp_alternate_num,3)
    if position_num > temp_position_num then
        for i=temp_position_num+1,position_num do
            if i == 3 then
                self:createFormationOpenAnimByPos(5);
            elseif i == 4 then
                self:createFormationOpenAnimByPos(6);
            elseif i == 5 then
                self:createFormationOpenAnimByPos(1);
                self:createFormationOpenAnimByPos(4);
            end
        end
    end
    if alternate_num > temp_alternate_num  then
        for i=temp_alternate_num,alternate_num-1 do
            self:createFormationOpenAnimByPos(7+i);
        end
    end
    game_data:resetBattleCardNumData();
end

function game_god_palace_adjustment.getExchangeTeamDataByTwoPosFlag(self,posIndex1,posIndex2)
    local cardNumData = game_data:getBattleCardNumData()
    local maxCount1,maxCount2 = cardNumData.position_num or 2,cardNumData.alternate_num or 0;
    local returnValue = 0;
    if self.m_openTab[posIndex1] == 0 or self.m_openTab[posIndex2] == 0 then
        returnValue = 5;
        game_util:addMoveTips({text = string_config:getTextByKey("m_team_pos_no_open")});
        return returnValue;
    end
    local count1,count2 = 0,0;
    local cardId = nil;
    for i=1,6 do
        cardId = self.m_tempTeamData[i]
        if cardId ~= "-1" then
            count1 = count1 + 1;
        end
    end
    for i=7,9 do
        cardId = self.m_tempTeamData[i]
        if cardId ~= "-1" then
            count2 = count2 + 1;
        end
    end
    if posIndex1 > 0 and posIndex1 < 10 and posIndex2 > 0 and posIndex2 < 10 then
        if posIndex1 < 7 and posIndex2 < 7 then--主站
            returnValue = 0;
        elseif posIndex1 > 6 and posIndex2 > 6 then--替补
            returnValue = 0;
        elseif posIndex1 > 6 and posIndex2 < 7 then--替补主站
            if self.m_tempTeamData[posIndex1] ~= "-1" and self.m_tempTeamData[posIndex2] == "-1" then
                count1 = count1 + 1;
                count2 = count2 - 1;
            end
        elseif posIndex1 < 7 and posIndex2 > 6 then--主站替补
            if self.m_tempTeamData[posIndex1] ~= "-1" and self.m_tempTeamData[posIndex2] == "-1" then
                count1 = count1 - 1;
                count2 = count2 + 1;
            end
        else
            returnValue = 1--
        end
    end
    if count1 ~= 0 then
        if count1 > maxCount1 or count1 > 5 then
            returnValue = 2;
            game_util:addMoveTips({text = string_config:getTextByKey("m_master_is_max")});
        elseif count2 > maxCount2 then
            returnValue = 3;
            game_util:addMoveTips({text = string_config:getTextByKey("m_substitute_is_max")});
        end
    else
        returnValue = 4;
        game_util:addMoveTips({text = string_config:getTextByKey("m_master_at_least_one")});
    end
    -- cclog("getExchangeTeamDataByTwoPosFlag == returnValue =" .. returnValue .. " ; count1 == " .. count1 .. " ; count2 = " .. count2)
    return returnValue;
end

function game_god_palace_adjustment.getUnloadPosFlag(self,posIndex)
    local returnValue = 0;
    local count1 = 0;
    if posIndex < 7 then
        local cardId = nil;
        for i=1,6 do
            cardId = self.m_tempTeamData[i]
            if cardId ~= "-1" then
                count1 = count1 + 1;
            end
        end
        if count1 < 2 and self.m_tempTeamData[posIndex] ~= "-1" then
            returnValue = 2;
            game_util:addMoveTips({text = string_config:getTextByKey("m_master_at_least_one")});
        end
    end
    return returnValue;
end

function game_god_palace_adjustment.updateTeamData(self,posIndex,cardId)
    self.m_tempTeamData[posIndex] = cardId;
    self:setTeamFormationData(self.m_btn_index);
end

function game_god_palace_adjustment.exchangeTeamDataByTwoPos(self,posIndex1,posIndex2)
    self.m_tempTeamData[posIndex1],self.m_tempTeamData[posIndex2] = self.m_tempTeamData[posIndex2],self.m_tempTeamData[posIndex1]
    self.m_tempEquipPosData[posIndex1],self.m_tempEquipPosData[posIndex2] = self.m_tempEquipPosData[posIndex2],self.m_tempEquipPosData[posIndex1]
    self.m_tempGemPosData[posIndex1],self.m_tempGemPosData[posIndex2] = self.m_tempGemPosData[posIndex2],self.m_tempGemPosData[posIndex1]
    self.m_tempMedalPosData[tostring(posIndex1 - 1)],self.m_tempMedalPosData[tostring(posIndex2 - 1)] = self.m_tempMedalPosData[tostring(posIndex2 - 1)],self.m_tempMedalPosData[tostring(posIndex1 - 1)]
    self.m_tempSoulPosData[tostring(posIndex1 - 1)],self.m_tempSoulPosData[tostring(posIndex2 - 1)] = self.m_tempSoulPosData[tostring(posIndex2 - 1)],self.m_tempSoulPosData[tostring(posIndex1 - 1)]
    -- cclog2(self.m_tempEquipPosData,"self.m_tempEquipPosData==23=23==235=5=")
    self:setTeamFormationData(self.m_btn_index);
end

--[[
    英魂基本能力属性加成
]]
function game_god_palace_adjustment.getSoulBaseAttrValue(self,posIndex)
    local attrValueTab = {0,0,0,0,0}
    local attrValueTab2 = {0,0,0,0,0}
    local attrValuePercent = {0,0,0,0,0}
    local combatValue = 0;
    local soulCfg = getConfig(game_config_field.soul_detail);
    local soulPosData = self.m_tempSoulPosData[tostring(posIndex - 1)] or {};
    local soulAllData = game_data:getSoulData()
    for k,v in pairs(soulPosData) do
        -- cclog2(soulPosItemKey,"soulPosItemKey")
        if v ~= "0" and v ~= "-1" then
            local itemSoulData = soulAllData[v]
            local s_id = itemSoulData.s_id
            local itemCfg = soulCfg:getNodeWithKey(tostring(s_id));
            local lv = itemSoulData.lv
            if itemCfg then
                local value = itemCfg:getNodeWithKey("value"):toInt()
                local ability = itemCfg:getNodeWithKey("ability"):toInt()
                local level_add = itemCfg:getNodeWithKey("level_add"):toFloat()
                if itemCfg:getNodeWithKey("value2") and itemCfg:getNodeWithKey("value"):toInt() ~=0 then
                    local value2 = itemCfg:getNodeWithKey("value2"):toInt()
                    local ability2 = itemCfg:getNodeWithKey("ability2"):toInt()
                    local level_add2 = itemCfg:getNodeWithKey("level_add2"):toFloat()
                    if ability2 > 0 and ability2 < 6 then
                        attrValueTab2[ability2] = attrValueTab2[ability2] + math.floor(value2 + level_add2 * lv)
                    end
                end
                if ability > 0 and ability < 6 then
                    attrValueTab[ability] = attrValueTab[ability] + math.floor(value + level_add * lv)
                -- else
                --     attrValueTab[ability] = attrValueTab[ability] + value
                elseif ability > 100 and ability < 106 then--加百分比的
                    local percent = value + level_add * lv
                    attrValuePercent[ability - 100] = percent--家百分比的只能穿一种
                end
            end
        end
    end
    return attrValueTab,attrValuePercent,attrValueTab2;
end

--[[--
    编队位置点击的处理
]]
function game_god_palace_adjustment.initAdjustmentFormationTouch(self,formation_layer)
    local selItem = nil;
    local beganItem = nil;
    local endItem = nil;
    local touchBeginPoint = nil;
    local touchMoveFlag = false;
    local realPos = nil;
    local tempPosIndex = nil;
    local function onTouchBegan(x, y)
        if selItem then
            selItem:removeFromParentAndCleanup(true);
            selItem = nil;
        end
        touchMoveFlag = false;
        --cclog("onTouchBegan: %0.2f, %0.2f", x, y)
        touchBeginPoint = {x = x, y = y}
        realPos = formation_layer:convertToNodeSpace(ccp(x,y));
        -- CCTOUCHBEGAN event must return true
        for tag = 1,9 do
            beganItem = self.m_ccbNode:spriteForName("m_pos_" .. tag)
            if beganItem and beganItem:boundingBox():containsPoint(realPos) then
                tempPosIndex = tag;
                selItem = self:createCardAnimByPosIndex(tempPosIndex)
                if selItem == nil then break end
                local pX,pY = beganItem:getPosition();
                selItem:setPosition(ccp(pX,pY));
                -- selItem:setColor(ccc3(128,128,128));
                formation_layer:addChild(selItem,11,11);
                selItem:setVisible(false);
                break;
            end
        end
        return true
    end
    
    local function onTouchMoved(x, y)
        
        -- cclog("onTouchMoved: %0.2f, %0.2f", x - touchBeginPoint.x, y - touchBeginPoint.y)
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            if selItem then
                realPos = formation_layer:convertToNodeSpace(ccp(x,y));
                selItem:setPosition(realPos);
                selItem:setVisible(true);
            end
            touchMoveFlag = true;
        end
    end
    
    local function onTouchEnded(x, y)
        --cclog("onTouchEnded: %0.2f, %0.2f", x, y)
        realPos = formation_layer:convertToNodeSpace(ccp(x,y));
        self:setPositionBg(self.m_posIndex,true);
        if not touchMoveFlag and tempPosIndex and self.m_posIndex ~= tempPosIndex then
            self:addTeamHeroPop(tempPosIndex);
        end
        if selItem and touchMoveFlag then
            -- self.m_posIndex = -1;
            -- self:refreshHeroInfo(self.m_posIndex);
            for endTag = 1,9 do
                endItem = self.m_ccbNode:spriteForName("m_pos_" .. endTag)
                if endItem and endItem:boundingBox():containsPoint(realPos) then
                    local beganTag = beganItem:getTag();
                    if endTag ~= beganTag and self:getExchangeTeamDataByTwoPosFlag(beganTag,endTag) == 0 then
                        cclog("exchange ----------beganTag = " .. beganTag .. " ; endTag = " .. endTag);
                        self:exchangeTeamDataByTwoPos(beganTag,endTag);
                        self.m_changeFlag = true;
                        local bgSize = endItem:getContentSize();
                        beganItem:removeAllChildrenWithCleanup(true)
                        local animNode = self:createCardAnimByPosIndex(beganTag)
                        if animNode then
                            animNode:setPosition(ccp(bgSize.width*0.5,bgSize.height*0.1));
                            beganItem:addChild(animNode,1,1)
                            self:setPositionBg(beganTag,true);
                        else
                            self:setPositionBg(beganTag,false);
                        end
                        endItem:removeAllChildrenWithCleanup(true)
                        local animNode = self:createCardAnimByPosIndex(endTag)
                        if animNode then
                            animNode:setPosition(ccp(bgSize.width*0.5,bgSize.height*0.1));
                            endItem:addChild(animNode,1,1)
                            self:setPositionBg(endTag,true);
                        else
                            self:setPositionBg(endTag,false);
                        end
                        self.m_posIndex = endTag;
                        self:refreshHeroInfo(endTag);
                        self:refreshCombatLabel();
                    end
                    break;
                end
            end
        end
        if selItem then
            selItem:removeFromParentAndCleanup(true);
            selItem = nil;
        end
        touchBeginPoint = nil;
        beganItem = nil;
        endItem = nil;
        tempPosIndex = nil;
    end
    
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return onTouchBegan(x, y)
            elseif eventType == "moved" then
            return onTouchMoved(x, y)
            else
            return onTouchEnded(x, y)
        end
    end
    formation_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY+131)
    formation_layer:setTouchEnabled(true)
end

--[[--
    
]]
function game_god_palace_adjustment.setPositionBg(self,posIndex,aninFlag)
    if posIndex == -1 then return end
    local bgSprite = tolua.cast(self.m_formation_layer:getChildByTag(posIndex),"CCSprite");
    if bgSprite == nil then return end;
    local bgName = "";
    if aninFlag and self.m_tempTeamData[posIndex] ~= "-1" then
        if posIndex < 7 then
            bgName = "dw_characterBg.png";
        else
            bgName = "dw_characterBgtibu.png";
        end
    else
        if posIndex < 7 then
            bgName = "dw_characterAdd.png";
        else
            bgName = "dw_characterAddtibu.png";
        end
        
    end
    local tempDisplayFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(bgName);
    if tempDisplayFrame then
        bgSprite:setDisplayFrame(tempDisplayFrame);
    end
end

--[[--
    
]]
function game_god_palace_adjustment.setPositionBg2(self,posIndex)
    if posIndex == -1 then return end
    local bgSprite = tolua.cast(self.m_formation_layer:getChildByTag(posIndex),"CCSprite");
    if bgSprite == nil then return end;
    local bgName = "";
    local tempId = self.m_teamIndex == 2 and self.m_tempFriendData[posIndex] or self.m_tempDestinyData[posIndex]
    -- cclog("tempId ======= " .. tempId .. " ; posIndex ======= " .. posIndex)
    if tempId == "-1" then--未开启
        if posIndex < 7 then
            bgName = "dw_qiang_diban_1.png";
        else
            bgName = "dw_chao_diban_2.png";
        end
    elseif tempId == "0" then--
        bgName = "dw_characterAdd.png";
    else
        bgName = "dw_characterBg.png";
    end
    local tempDisplayFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(bgName);
    if tempDisplayFrame then
        bgSprite:setDisplayFrame(tempDisplayFrame);
    end
end

--[[--
    
]]
function game_god_palace_adjustment.setSelPositionBg(self,posIndex)
    if self.m_teamIndex == 1 then
        if posIndex == -1 or self.m_tempTeamData[posIndex] == "-1" then return end
    else
        if posIndex == -1 or self.m_tempFriendData[posIndex] == "-1" then return end
    end    
    local bgSprite = tolua.cast(self.m_formation_layer:getChildByTag(posIndex),"CCSprite");
    if bgSprite == nil then return end
    
        local pX,pY = bgSprite:getPosition();
        local tempPos = self.m_formation_layer:convertToWorldSpace(ccp(pX,pY));
        self.m_sel_bg:setPosition(ccp(pX,pY));
        self.m_sel_bg:setVisible(true);
    -- end
end

--[[--
    刷新卡牌信息
]]
function game_god_palace_adjustment.getPosEquipAttrValue(self,posIndex)
    -- 1物攻 2魔攻 3防御 4速度 5生命
    local equip_set_random = getConfig(game_config_field.equip_set_random)
    local attrValueTab = {0,0,0,0,0};
    local posEquips = nil
    if self.m_teamIndex == 1 then
        posEquips = self.m_tempEquipPosData[posIndex]
    end
    local level,value1,value2;
    local suitTab = {};
    if posEquips and type(posEquips) == "table" then
        for k,v in pairs(posEquips) do
            local equipItemData,itemCfg = game_data:getEquipDataById(v);
            if equipItemData and itemCfg then
                level = equipItemData.lv;
                value1 = itemCfg:getNodeWithKey("value1"):toInt();
                value2 = itemCfg:getNodeWithKey("value2"):toInt();
                local level_add1,level_add2 = itemCfg:getNodeWithKey("level_add1"):toInt(),itemCfg:getNodeWithKey("level_add2"):toInt()
                value1 = value1 + level_add1*(level - 1);
                value2 = value2 + level_add2*(level - 1);
                -- cclog("value1 == " .. value1 .. " ; value2 == " .. value2)
                local ability1 = itemCfg:getNodeWithKey("ability1"):toInt();
                local ability2 = itemCfg:getNodeWithKey("ability2"):toInt();
                local attrName1 = PUBLIC_ABILITY_TABLE["ability_" .. ability1].attrName
                local attrName2 = PUBLIC_ABILITY_TABLE["ability_" .. ability2].attrName
                if equipItemData.equip_refine then
                    if equipItemData.equip_refine[attrName1] then
                        local temp1 = equipItemData.equip_refine[attrName1]
                        value1 = value1 + temp1
                    end
                    if equipItemData.equip_refine[attrName2] then
                        local temp2 = equipItemData.equip_refine[attrName2]
                        value2 = value2 + temp2
                    end
                end
                if attrValueTab[ability1] then
                    attrValueTab[ability1] = attrValueTab[ability1] + value1;
                end
                if attrValueTab[ability2] then
                    attrValueTab[ability2] = attrValueTab[ability2] + value2;
                end
                local suit = itemCfg:getNodeWithKey("suit"):toInt();
                if suitTab[suit] == nil then
                    suitTab[suit] = 0;
                    local suitCount,_,tempAttrValueTab = game_util:getEquipSuit(itemCfg:getNodeWithKey("suit"):toStr(),posEquips);
                    if suitCount > 0 then
                        for i=1,5 do
                            attrValueTab[i] = attrValueTab[i] + tempAttrValueTab[i]
                        end
                    end
                end
                -- --增加锻造属性值
                -- if equipItemData.is_equip_forge == true then
                --     -- local attrname = 
                --     -- local tempValue = {0,0,0,0,0}
                --     for key_type,valueTable in pairs(equipItemData.equip_forge) do
                --         local itemEquipForgeCfg = json.decode(equip_set_random:getNodeWithKey(tostring(key_type)):getFormatBuffer())
                --         local sort = itemEquipForgeCfg.sort
                --         local enemy = itemEquipForgeCfg.enemy[1]
                --         local value = 0
                --         for k,v in pairs(valueTable) do
                --             value = v
                --         end
                --         cclog2(value,"equp forge value")
                --         if sort > 0 and sort <= 5 then
                --             -- tempValue[sort] = value

                --             -- attrValueTab[sort] = attrValueTab[sort] * (1 + value)
                --             --改成加数不用百分比
                --             if enemy ~= -1 then--减敌人的不加
                --                 attrValueTab[sort] = attrValueTab[sort] + value
                --             end
                --         end
                --     end
                                
                -- end


             end
        end
    end
    return attrValueTab
end

--[[
    宝石基本能力属性加成
]]
function game_god_palace_adjustment.getGemBaseAttrValue(self, posIndex)
    local attrValueTab = {0,0,0,0,0}
    local combatValue = 0;
    local gemCfg = getConfig(game_config_field.gem);
    local gemPosItemData = self.m_tempGemPosData[posIndex] or {}
    -- cclog2(gemPosItemData,"gemPosItemData======")
    for k,v in pairs(gemPosItemData) do
        local gemLv,gemId = game_util:getRealGemLvAndCid(tostring(v))
        local itemCfg = gemCfg:getNodeWithKey(tostring(gemId))
        if itemCfg then
            local ability = itemCfg:getNodeWithKey("ability"):toInt();
            local value = itemCfg:getNodeWithKey("value"):toInt();
            local curValue1,curValue2 = game_util:getGemAttrByLv(gemLv, itemCfg:getNodeWithKey("ability"):toInt() )
            if ability > 0 and ability < 6 then
                attrValueTab[ability] = attrValueTab[ability] + value + curValue1
            end
            local ability2 = itemCfg:getNodeWithKey("ability2")
            if ability2 then
                ability2 = ability2:toInt();
                local value2 = itemCfg:getNodeWithKey("value2"):toInt();
                if ability2 > 0 and ability2 < 6 then
                    attrValueTab[ability2] = attrValueTab[ability2] + value2 + curValue2
                end
            end
        end
    end
    -- cclog2(attrValueTab,"attrValueTab=======")
    return attrValueTab;
end


--[[--
    刷新卡牌信息
]]
function game_god_palace_adjustment.refreshHeroInfo(self,posIndex)
    self.m_magic_node:setVisible(false)
    local replaceStr = "替换"
    self.m_sel_bg:setVisible(false);
    self.m_selHeroId = nil;
    self.m_anim_node:removeAllChildrenWithCleanup(true);
    local tempNode = nil;
    for i=1,8 do
        tempNode = self.m_ccbNode:spriteForName("m_equip_" .. i)
        if tempNode then
            tempNode:removeAllChildrenWithCleanup(true);
        end
    end
    local cardData,cardCfg = nil,nil;
    if self.m_teamIndex == 1 then
        cardData,cardCfg = self:getTeamCardDataByPos(posIndex);
    else
        cardData,cardCfg = self:getFriendCardDataByPos(posIndex);
    end
    local fate_detail_label_str = "无";
    local attrValueTab = {0,0,0,0,0};
    if cardData and cardCfg then
        self:setSelPositionBg(posIndex);
        self.m_selHeroId = cardData.id
        self.m_life_label:setString(cardData.hp);
        self.m_physical_atk_label:setString(cardData.patk);
        self.m_magic_atk_label:setString(cardData.matk);
        self.m_def_label:setString(cardData.def);
        self.m_speed_label:setString(cardData.speed);
        local ainmFile = cardCfg:getNodeWithKey("animation"):toStr();
        local animNode = game_util:createHeroListItemByCCB(cardData);
        self.m_anim_node:addChild(animNode);
        -- 1物攻 2魔攻 3防御 4速度 5生命
        local equipAttrValueTab = self:getPosEquipAttrValue(posIndex);--装备属性
        local gemAttrValueTab = self:getGemBaseAttrValue(posIndex);--宝石的基本属性
        -- local gemAttrValueTab = {0,0,0,0,0};
        local medalAttrValueTab = {0,0,0,0,0}
        local badgeAttrValueTab = {0,0,0,0,0}
        local soulAttrValueTab = {0,0,0,0,0};
        local soulPercentValueTab = {0,0,0,0,0};
        local attrValueTab2 = {0,0,0,0,0};
        local soulAttrValueTab2 = {0,0,0,0,0};
        local soulPercentCombatTab = {0,0,0,0,0};
        -- local attrValueTab3 = {0,0,0,0,0};

        if self.m_teamIndex == 1 then
            
            attrValueTab2 = game_util:getCommanderCombatValue();--统帅能力
            medalAttrValueTab = self:getMedalBaseAttrValue(posIndex);--勋章的基本属性
            badgeAttrValueTab = self:getBadgeBaseAttrValue()
            soulAttrValueTab,soulPercentValueTab,soulAttrValueTab2 = self:getSoulBaseAttrValue(posIndex,cardData); --英魂基本属性
            -- attrValueTab3 = game_util:getAssistantCombatValue();--助威加的属性
        end
        local cbmTab = game_util:getCombatBonusMultiplierByCfg(cardCfg,cardData.id,self.m_tempTeamData,self.m_tempEquipPosData);--连协属性
        
        --todo命运刷新
        if  cardData.fate_change and next(cardData.fate_change) then
            cbmTab = game_util:getCombatBonusMultiplierByCfg2(cardCfg,cardData.id,self.m_tempTeamData,self.m_tempEquipPosData);--连协刷新过的属性
        end

        for i=1,5 do
            local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. i] or {}
            local attrValue = cardData[abilityItem.attrName or ""] or 0
            soulPercentCombatTab[i] = attrValue * soulPercentValueTab[i] * 0.01
            attrValueTab[i] = math.floor(equipAttrValueTab[i] + attrValueTab2[i] + attrValue*cbmTab[i] + gemAttrValueTab[i] + medalAttrValueTab[i] + badgeAttrValueTab[i] + soulAttrValueTab[i] + soulAttrValueTab2[i] + soulPercentCombatTab[i])
        end

        if cardData.bind_equip and next(cardData.bind_equip) then
            local fateTempValueTab = {0,0,0,0,0}
            local fateEquipData = {0,0,0,0,0}

            fateEquipData = game_util:getFateEquipValue(cardData.bind_equip)
            fateTempValueTab[5] = math.floor((attrValueTab[5] + cardData.hp) * fateEquipData[5]/100)
            fateTempValueTab[2] = math.floor((attrValueTab[2] + cardData.matk) * fateEquipData[2]/100)
            fateTempValueTab[3] = math.floor((attrValueTab[3] + cardData.def) * fateEquipData[3]/100)
            fateTempValueTab[4] = math.floor((attrValueTab[4] + cardData.speed) * fateEquipData[4]/100)
            fateTempValueTab[1] = math.floor((attrValueTab[1] + cardData.patk) * fateEquipData[1]/100)
            for i=1,5 do
                attrValueTab[i] = attrValueTab[i] + fateTempValueTab[i]
            end
        end
        self.m_life_label2:setString("+" .. attrValueTab[5])
        self.m_physical_atk_label2:setString("+" .. attrValueTab[1])
        self.m_magic_atk_label2:setString("+" .. attrValueTab[2])
        self.m_def_label2:setString("+" .. attrValueTab[3])
        self.m_speed_label2:setString("+" .. attrValueTab[4])

        local chainTab = game_util:cardChainByCfg(cardCfg,cardData.id,nil,self.m_tempTeamData,self.m_tempEquipPosData)
        -- cclog2(chainTab,"chainTab===========")

        --todo命运刷新
        if  cardData.fate_change and next(cardData.fate_change) then
            
             chainTab = game_util:cardChainByCfg2(cardCfg,cardData.id,nil,self.m_tempTeamData,self.m_tempEquipPosData)
        end

        self.m_chainTab = chainTab;

        local is_bright = true
        if #chainTab > 0 then
            local showStr = ""
            local nameStr = "";
            for i=1,#chainTab do
                showStr = showStr .. chainTab[i].detail .. "\n"
                nameStr = nameStr .. "    " .. chainTab[i].name .. (i == 3 and "\n" or "")
                if chainTab[i].openFlag == false then
                    is_bright = false
                end
            end
            -- self.m_fate_label:setString(nameStr);
            fate_detail_label_str = showStr;
        else
            is_bright = false
            -- self.m_fate_label:setString("无");
        end
        self.m_magic_node:setVisible(isVisible)
        -- cclog2(self.m_selHeroId,"self.m_selHeroId ----")
        if game_data:isViewShowByID(182) == true then
            self:autoMatchFateEquip(self.m_selHeroId,posIndex)
        end
        self:refreshEquipPos(posIndex)
        self:refreshGemPos(posIndex)
    else
        self.m_life_label:setString("---");
        self.m_physical_atk_label:setString("---");
        self.m_magic_atk_label:setString("---");
        self.m_def_label:setString("---");
        self.m_speed_label:setString("---");
        self.m_life_label2:setString("---");
        self.m_physical_atk_label2:setString("---");
        self.m_magic_atk_label2:setString("---");
        self.m_def_label2:setString("---");
        self.m_speed_label2:setString("---");
        -- self.m_fate_label:setString("无")
        -- self.m_fate_detail_label:setString("无")
        if self.m_teamIndex == 2 then
            self:setSelPositionBg(posIndex);
        end
        replaceStr = "上阵"
    end
    if self.m_teamIndex == 2 then
        
    end
    game_util:setCCControlButtonTitle(self.m_replace_btn,replaceStr)
    local labelsize = self.m_fate_detail_node:getContentSize();
    self.m_oneFateScrollView:getContainer():removeAllChildrenWithCleanup(true);
    self.m_fate_detail_label = game_util:createRichLabelTTF({text = fate_detail_label_str,dimensions = CCSizeMake(labelsize.width, 0),textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = nil,color = ccc3(221,221,192)})
    self.m_fate_detail_label:setAnchorPoint(ccp(0, 0));
    self.m_oneFateScrollView:addChild(self.m_fate_detail_label)
    local contentSize = self.m_fate_detail_label:getContentSize();
    self.m_oneFateScrollView:setContentSize(CCSizeMake(contentSize.width, math.max(contentSize.height,labelsize.height)));
    if contentSize.height < labelsize.height then
        self.m_fate_detail_label:setPosition(ccp(0, labelsize.height - contentSize.height));
        self.m_oneFateScrollView:setContentOffset(ccp(0, 0),false)
    else
        self.m_oneFateScrollView:setContentOffset(ccp(0, labelsize.height - contentSize.height),false)
    end

        -- btn_bloodStone
    local btn_bloodStone = self.m_ccbNode:controlButtonForName("btn_bloodStone")
    if not game_data:isViewOpenByID(226) then
        btn_bloodStone:setVisible(false)
    else
        btn_bloodStone:setVisible(true)
        self:refreshBloodStone()
    end

    self:refreshBadge()

end

-- 刷新血石
function game_god_palace_adjustment:refreshBloodStone()
    local equipPosData = nil
    if self.m_teamIndex == 1 then
        equipPosData = self.m_tempEquipPosData[self.m_posIndex] or {"0", "0", "0", "0"}
    elseif self.m_teamIndex == 2 then
        equipPosData = self.m_tempAssEquipPosData[tostring(self.m_posIndex+99)] or {"0", "0", "0", "0"}
    end
    for k,v in pairs(equipPosData) do
        if v ~= "0" then
            local equipItemData =  game_data:getEquipDataById(v);
            if equipItemData ~= nil and  equipItemData.bind_card and equipItemData.bind_card ~= "" then
                if equipItemData.bind_card ~= self.m_selHeroId then
                    equipPosData[k] = "0"
                end
            end
        end
    end
    cclog2(self.m_tempEquipPosData, "[血石] self.m_tempEquipPosData -> ")
    cclog2(self.m_tempAssEquipPosData, "[血石] self.m_tempAssEquipPosData -> ")

    local sc_blood = self.m_ccbNode:scrollViewForName("sc_blood")
    -- sc_blood:getContainer():removeAllChildrenWithCleanup(true);

    local ccbNode = self.m_ccbNode

    -- local ccbNode = luaCCBNode:create()            
    -- ccbNode:openCCBFile("ccb/ui_equipBloodSc.ccbi")
    -- ccbNode:setAnchorPoint(ccp(0.5,0.5))
    -- sc_blood:addChild(ccbNode)

    sc_blood:setContentOffset(ccp(0, -ccbNode:getContentSize().height + 130))
    for i=1, 4 do
        -- 获取装备数据
        local _euqipData = equipPosData[i]
        cclog2(_euqipData, "[血石] _euqipData -> ")
        local equipData
        local gem_fateData
        if _euqipData ~= "0" then
            equipData = game_data:getEquipDataById(tostring(_euqipData))
            cclog2(equipData, "[血石] equipData -> ")
            if equipData and equipData.gem_fate then
                gem_fateData = equipData.gem_fate
                cclog2(gem_fateData, "[血石] gem_fateData -> ")
            end
        end
        -- node_item
        local node_item = ccbNode:nodeForName("node_item" .. i)
        -- node_item:setVisible(_euqipData ~= "0")
        -- node_equipIcon
        local node_equipIcon = ccbNode:nodeForName("node_equipIcon" .. i)
        node_equipIcon:removeAllChildrenWithCleanup(true);
        if _euqipData ~= "0" then
            local equipItemData,equipItemCfg = game_data:getEquipDataById(tostring(_euqipData));
            cclog2(equipItemCfg, "[血石] equipItemCfg -> ")
            local equipIcon = game_util:createEquipIcon(equipItemCfg);
            if equipIcon then
                equipIcon:setScale(0.9)
                equipIcon:setPosition(ccp(0, 0))
                node_equipIcon:addChild(equipIcon,10,10)
            end
        end
        -- 赋能
        for j = 1, 4 do
            -- stone icon
            local node_stone = ccbNode:nodeForName("node_" .. i .. "_stone" .. j)
            node_stone:removeAllChildrenWithCleanup(true);
            if gem_fateData and gem_fateData[j] and gem_fateData[j] ~= 0 then
                local icon = game_util:createFateGemIconByCid(gem_fateData[j])
                icon:setScale(0.7)
                node_stone:addChild(icon)
            end
            -- 
        end
        -- effect
        local effects = game_util.bloodStone.getEquipStoneEffect(nil, _euqipData)
        local effect = effects[1]
        -- sp_no
        local sp_no = ccbNode:spriteForName("sp_no" .. i)
        sp_no:setVisible(effect == nil)
        -- sp_effect1
        local sp_effect1 = ccbNode:spriteForName("sp_effect1_" .. i)
        sp_effect1:setVisible(effect ~= nil)
        if effect then
            local sid = effect.effectSid
            local icon1, icon2 = game_util.bloodStone.getSkillEffectIconName(sid)
            sp_effect1:setTexture(CCTextureCache:sharedTextureCache():addImage("icon/" .. icon1))
        end
        -- sp_effect2
        local sp_effect2 = ccbNode:spriteForName("sp_effect2_" .. i)
        sp_effect2:setVisible(effect ~= nil)
        if effect then
            local sid = effect.effectSid
            local icon1, icon2 = game_util.bloodStone.getSkillEffectIconName(sid)
            sp_effect2:setTexture(CCTextureCache:sharedTextureCache():addImage("icon/" .. icon2))
        end
        -- lb_effect
        local lb_effect = ccbNode:labelTTFForName("lb_effect" .. i)
        lb_effect:setVisible(effect ~= nil)
        if lb_effect:isVisible() then
            lb_effect:setString(effect.des)
        end
        -- sc_effect
        local sc_effect = ccbNode:scrollViewForName("sc_effect" .. i)
        if sc_effect then
            lb_effect:removeFromParentAndCleanup(false)
            sc_effect:setContentSize(CCSizeMake(lb_effect:getContentSize().width + 50, lb_effect:getContentSize().height))
            lb_effect:setPositionY(0)
            sc_effect:addChild(lb_effect)
        end
    end
end


--[[
    徽章的属性加成
]]
function game_god_palace_adjustment:getBadgeBaseAttrValue()
    local attrValueTab = {0,0,0,0,0} -- 1物攻 2魔攻 3防御 4速度 5生命
    local pos = self.m_posIndex -- 当前选中位置
    local cardData,cardCfg = self:getTeamCardDataByPos( pos ); -- 当前选中位置英雄信息,可以为nil
    if cardData and cardData.badge and cardData.badge ~= "" then -- 已经佩戴了徽章
        local badge = cardData.badge
        local badgeData,badgeCfg = game_data:getBadgeDataById(badge)
        badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}
        local base_up = badgeCfg.base_up
        for k, v in pairs(base_up) do
            attrValueTab[tonumber(v[1])] = attrValueTab[tonumber(v[1])] + v[2]
        end
    end
    return attrValueTab;
end

--[[
    勋章基本能力属性加成
]]
function game_god_palace_adjustment.getMedalBaseAttrValue(self, posIndex)
    local attrValueTab = {0,0,0,0,0}
    local combatValue = 0;
    local medalCfg = getConfig(game_config_field.medal);
    local medalPosItemData = self.m_tempMedalPosData[tostring(posIndex-1)] or {}
    for k,v in pairs(medalPosItemData) do
        local itemCfg = medalCfg:getNodeWithKey(tostring(v))
        if itemCfg then
            local effect = itemCfg:getNodeWithKey("effect")
            for i=1,3 do
                local itemEffect = effect:getNodeAt(i-1)
                local ability = itemEffect:getNodeAt(0):toInt()
                local value = itemEffect:getNodeAt(1):toInt()

                if ability > 0 and ability < 6 then
                    attrValueTab[ability] = attrValueTab[ability] + value
                end
            end
        end
    end
    return attrValueTab;
end
--[[
    刷新装备
]]
function game_god_palace_adjustment.refreshEquipPos(self,posIndex)
    if posIndex and posIndex > 0 and posIndex < 10 then
        local tempNode = nil;
        local equipPosData = nil
        equipPosData = self.m_EquipPosDataTab[self.m_btn_index][tostring(posIndex-1)]
        if equipPosData then
            local noUseEquipCountTab = self:getNoUseEquipCountTab();

            for i=1,4 do
                tempNode = self.m_ccbNode:spriteForName("m_equip_" .. i)  
                if tempNode then
                    local tempNodeSize = tempNode:getContentSize();
                    local id = equipPosData[i];
                    if id and tostring(id) ~= "0" then
                        local equipItemData,equipItemCfg = game_data:getEquipDataById(tostring(id));
                        local equipIcon = game_util:createEquipIcon(equipItemCfg);
                        if equipIcon then
                            equipIcon:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(equipIcon,10,10)
                            if self.m_selEquipId == id then
                                equipIcon:setScale(2.0);
                                local animArr = CCArray:create();
                                animArr:addObject(CCSpawn:createWithTwoActions(CCEaseIn:create(CCScaleTo:create(0.5,1.0),5),CCFadeIn:create(0.5)));
                                animArr:addObject(CCScaleTo:create(0.1,1.2));
                                animArr:addObject(CCScaleTo:create(0.1,1.0));
                                equipIcon:runAction(CCSequence:create(animArr));
                                self.m_selEquipId = nil;
                            end
                            if equipItemData.bind_card and equipItemData.bind_card ~= "" then
                                local temp = CCSprite:createWithSpriteFrameName("public_icon_ming.png")
                                local tempSize = equipIcon:getContentSize()
                                temp:setPosition(ccp(tempSize.width-5,tempSize.height-5))
                                equipIcon:addChild(temp,10,10)
                            end
                        end
                        if equipItemData then
                            local tempLabel = game_util:createLabelTTF({text = "Lv." .. equipItemData.lv,color = ccc3(250,255,0),fontSize = 16});
                            tempLabel:setPosition(ccp(tempNodeSize.width*0.5,-tempNodeSize.height*0.15))
                            tempNode:addChild(tempLabel,11,11)
                        else
                            -- cclog("equipIndex == " .. i .. " ; equipId == " .. tostring(id));
                        end
                    else
                        if noUseEquipCountTab[i] > 0 then
                            local tempSpri = CCSprite:createWithSpriteFrameName("public_kezhuangbei.png")
                            tempSpri:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempSpri:setVisible(false)
                            tempNode:addChild(tempSpri,10,10)
                        end
                        
                    end
                end
            end
        end
    end 
end

--[[
    获得是否有可装备的
]]
function game_god_palace_adjustment.getNoUseEquipCountTab(self)
    local tempTab = {0,0,0,0}

    for k,v in pairs(self.m_EquipPosDataTab[1]) do
        for index,id in pairs(v) do
            if id ~= "0" and id ~= 0 then
                tempTab[index] = tempTab[index] - 1;
            end
        end
    end
    for k,v in pairs(self.m_EquipPosDataTab[2]) do
        for index,id in pairs(v) do
            if id ~= "0" and id ~= 0 then
                tempTab[index] = tempTab[index] - 1;
            end
        end
    end
    for k,v in pairs(self.m_EquipPosDataTab[3]) do
        for index,id in pairs(v) do
            if id ~= "0" and id ~= 0 then
                tempTab[index] = tempTab[index] - 1;
            end
        end
    end
    local equipCfg = getConfig(game_config_field.equip);
    local equipCfgItem = nil;
    local sort = nil;
    local equip_data = game_data:getEquipData()
    for k,itemData in pairs(equip_data) do
        equipCfgItem = equipCfg:getNodeWithKey(itemData.c_id);
        sort = equipCfgItem:getNodeWithKey("sort"):toInt();
        if sort > 0 and sort < 5 then
            tempTab[sort] = tempTab[sort] + 1;
        end
    end
    -- cclog2(tempTab,"tempTabtempTabtempTabtempTabtempTab")
    -- table.foreach(tempTab,print)
    return tempTab;
end

--[[
    刷新装备
]]
function game_god_palace_adjustment.refreshGemPos(self,posIndex)
    if posIndex and posIndex > 0 and posIndex < 10 then
        local tempNode = nil;
        local gemPosData = self.m_tempGemPosData[posIndex]
        if gemPosData then
            local noUseGemCountTab = game_data:getNoUseGodGemCountTab();
            for i=1,4 do
                tempNode = self.m_ccbNode:spriteForName("m_equip_" .. (4+i))  
                if tempNode then
                    local tempNodeSize = tempNode:getContentSize();
                    local id = gemPosData[i];
                    if id and tostring(id) ~= "0" then
                        local tempIcon,gemName = game_util:createGemIconByCid(id);
                        if tempIcon then
                            tempIcon:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(tempIcon,10,10)
                            if self.m_selGemPos == i then
                                tempIcon:setScale(2.0);
                                local animArr = CCArray:create();
                                animArr:addObject(CCSpawn:createWithTwoActions(CCEaseIn:create(CCScaleTo:create(0.5,1.0),5),CCFadeIn:create(0.5)));
                                animArr:addObject(CCScaleTo:create(0.1,1.2));
                                animArr:addObject(CCScaleTo:create(0.1,1.0));
                                tempIcon:runAction(CCSequence:create(animArr));
                                self.m_selGemPos = nil;
                            end
                        end
                        if gemName then
                            local tempLabel = game_util:createLabelTTF({text = gemName,color = ccc3(250,255,0),fontSize = 16});
                            tempLabel:setPosition(ccp(tempNodeSize.width*0.5,-tempNodeSize.height*0.15))
                            tempNode:addChild(tempLabel,11,11)
                        else
                            -- cclog("equipIndex == " .. i .. " ; equipId == " .. tostring(id));
                        end
                    else
                        if noUseGemCountTab[i] > 0 then
                            local tempSpri = CCSprite:createWithSpriteFrameName("public_kezhuangbei.png")
                            tempSpri:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempSpri:setVisible(false)
                            tempNode:addChild(tempSpri,10,10)
                        end
                        
                    end
                end
            end
        end
    end 
end

--[[--
    装备层
]]
function game_god_palace_adjustment.initEquipLayerTouch(self,formation_layer)
    local touchBeginPoint = nil;
    local touchMoveFlag = false;
    local tempItem = nil;
    local realPos = nil;
    local tag = nil;
    local function onTouchBegan(x, y)
        touchMoveFlag = false;
        touchBeginPoint = {x = x, y = y}
        return true
    end
    
    local function onTouchMoved(x, y)
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            touchMoveFlag = true;
        end
    end
    
    local function onTouchEnded(x, y)
        if formation_layer:isVisible() == true then
            for i = 1,8 do
                tempItem = self.m_ccbNode:spriteForName("m_equip_" .. i) 
                realPos = tempItem:getParent():convertToNodeSpace(ccp(x,y)); 
                if tempItem:boundingBox():containsPoint(realPos) then
                    tag = tempItem:getTag();
                    if self.m_posIndex == -1 or self.m_tempTeamData[self.m_posIndex] == "-1" then
                        game_util:addMoveTips({text = string_config:getTextByKey("m_onclick_team_pos")});
                        return;
                    end
                    if tag < 20 then
                        local openFlag = true;--game_button_open:getOpenFlagByBtnId("705" .. self.m_posIndex .. (tag-10));
                        if openFlag then
                            local tempEquipId = self:getPosEquipId(self.m_posIndex,tag - 10);

                            if tempEquipId == nil or tostring(tempEquipId) == "0" then
                                self:addSelEquipUi(self.m_posIndex,tag - 10);
                            else
                                tempEquipId = tostring(tempEquipId);
                                local itemData = game_data:getEquipDataById(tempEquipId)
                                local function callBack(typeName,t_param)
                                    if typeName == "unload" then
                                        self:addSelEquipUi(self.m_posIndex,tag - 10);
                                    elseif typeName == "strengthen" then
                                        self.m_equip_openType = "equip_strengthen"
                                        self:sendChangedData(1);
                                    elseif typeName == "evolution" then
                                        self.m_equip_openType = "equip_evolution"
                                        self:sendChangedData(1);
                                    elseif typeName == "fateEquipLock" then
                                        self:refreshCombatLabel();
                                        self:refreshEquipPos(self.m_posIndex)
                                        self:refreshHeroInfo(self.m_posIndex)

                                    end
                                end
                                self.select_temp_id = tempEquipId
                                local fateEquipLock  = self:fateEquipLock(itemData,tempEquipId)
                                -- game_scene:addPop("game_equip_info_pop",{tGameData = itemData,posEquipData = self.m_tempEquipPosData[self.m_posIndex],callBack = callBack,openType=2,fateEquipLock = fateEquipLock,selHeroId = self.m_selHeroId});
                            end
                        else
                            game_util:addMoveTips({text = string_config:getTextByKey("m_equip_pos_no_open")});
                        end
                    elseif tag >= 20 then
                        if self.m_teamGemOpenFlag then
                            local tempId = self:getPosGemId(self.m_posIndex,tag - 20);
                            if tempId == nil or tostring(tempId) == "0" then
                                self:addSelGemUi(self.m_posIndex,tag - 20);
                            else
                                tempId = tostring(tempId);
                                local itemData = game_data:getGodGemDataById(tempId)
                                local function callBack(typeName,t_param)
                                    if typeName == "unload" then
                                        self:addSelGemUi(self.m_posIndex,tag - 20);
                                    elseif typeName == "strengthen" then
                                        self.m_openType = "gem_strengthen"
                                        self:sendChangedData(1);
                                    elseif typeName == "synthesis" then
                                        self.m_openType = "gem_synthesis"
                                        self:sendChangedData(1);
                                    end
                                end
                                self.select_temp_id = tempId
                                -- game_scene:addPop("gem_system_info_pop",{tGameData = {count = itemData,c_id = tempId},callBack = callBack,openType=2});
                            end
                        else
                        end
                    end
                    break;
                end
            end
        end
        if touchMoveFlag == false then
            -- self:fateTouchShow(x,y);
        end
    end
    
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return onTouchBegan(x, y)
            elseif eventType == "moved" then
            return onTouchMoved(x, y)
            else
            return onTouchEnded(x, y)
        end
    end
    formation_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY+131)
    formation_layer:setTouchEnabled(true)
end

--[[--
    
]]
function game_god_palace_adjustment.judgeAddHero(self,posIndex)
    local cardNumData = game_data:getBattleCardNumData()
    local maxCount1,maxCount2 = cardNumData.position_num or 2,cardNumData.alternate_num or 0;
    local returnValue = 0;
    if self.m_openTab[posIndex] == 0 then
        returnValue = 5;
        game_util:addMoveTips({text = string_config:getTextByKey("m_team_pos_no_open")});
        return returnValue;
    end
    local count1,count2 = 0,0;
    local cardId = nil;
    for i=1,6 do
        cardId = self.m_tempTeamData[i]
        if cardId ~= "-1" then
            count1 = count1 + 1;
        end
    end
    for i=7,9 do
        cardId = self.m_tempTeamData[i]
        if cardId ~= "-1" then
            count2 = count2 + 1;
        end
    end
    if posIndex < 7 then
        count1 = count1 + 1;
    else
        count2 = count2 + 1;
    end
    if count1 > maxCount1 or count1 > 5 then
        returnValue = 2;
        game_util:addMoveTips({text = string_config:getTextByKey("m_master_is_max")});
    elseif count2 > maxCount2 then
        returnValue = 3;
        game_util:addMoveTips({text = string_config:getTextByKey("m_substitute_is_max")});
    end
    return returnValue;
end

--[[--
    
]]
function game_god_palace_adjustment.addTeamHeroPop(self,posIndex)
    if self.m_tempTeamData[posIndex] == "-1" then
        if self:judgeAddHero(posIndex) == 0 then
            self:addSelHeroUi(posIndex);
        end
    else
        self.m_posIndex = posIndex;
        self:refreshHeroInfo(posIndex);
    end
end

function game_god_palace_adjustment.addSelHeroUi(self,posIndex)
    
    local btnCallFunc = function( target,event )
        
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if (not game_util:heroInTeamById(id,self.m_teamTab["1"])) and (not game_util:heroInTeamById(id,self.m_teamTab["2"])) and (not game_util:heroInTeamById(id,self.m_teamTab["3"])) then
                -- cclog("itemOnClick id ==================== " .. id);
                self:updateTeamData(posIndex,id);
                self.m_changeFlag = true;
                self:initTeamFormation(self.m_formation_layer);
                self.m_posIndex = posIndex;
                self:refreshHeroInfo(posIndex);
                self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                -- self:newChainOpenAnim("card");
                self:refreshCombatLabel();
            end
        elseif typeName == "unload" then
            if self:getUnloadPosFlag(posIndex) == 0 then
                self:updateTeamData(posIndex,"-1");
                self.m_changeFlag = true;
                self:initTeamFormation(self.m_formation_layer);
                self.m_posIndex = -1;
                self:refreshHeroInfo(posIndex);
                self:refreshCombatLabel();
            end
        end
    end
    -- game_scene:addPop("game_god_hero_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,openType = 2 , m_tGodTeamData = self.m_teamTab})
end


--[[--
    判断是否装备上
]]
function game_god_palace_adjustment.equipInEquipPos(self,equipType,equipId)
    local existFlag = false;
    local posIndex = -1;
    local posType = 1
    local teamflag = 1
    local equipPosData1 = self.m_EquipPosDataTab[1]
    local equipPosData2 = self.m_EquipPosDataTab[2]
    local equipPosData3 = self.m_EquipPosDataTab[3]
    if equipType then
        for i=1,10 do

            if tonumber(equipPosData1[tostring(i-1)][equipType]) == tonumber(equipId) then
                teamflag = 1;
                posIndex = i;
                existFlag = true
                break;
            end
            if tonumber(equipPosData2[tostring(i-1)][equipType]) == tonumber(equipId) then
                teamflag = 2;
                posIndex = i;
                existFlag = true
                break;
            end
            if tonumber(equipPosData3[tostring(i-1)][equipType]) == tonumber(equipId) then
                teamflag = 3;
                posIndex = i;
                existFlag = true
                break;
            end
        end
    end
    return existFlag,posIndex,posType,teamflag
end

--[[--
    获得位置上的装备ID
]]
function game_god_palace_adjustment.getPosEquipId(self,equipPos,equipType)
    local tempEquipId = "0";
    if self.m_tempEquipPosData[equipPos] then
        tempEquipId = self.m_tempEquipPosData[equipPos][equipType]
    end
    return tempEquipId;
end

--[[--
    设置阵型相应位置装备数据
]]
function game_god_palace_adjustment.updateEquipPosData(self,equipPos,equipType,equipId)
    if equipPos > 9 or equipPos < 0 or equipType > 4 or equipType < 1 then return end
    -- cclog("updateEquipPosData equipPos = " .. equipPos .. " ; equipType = " .. equipType .. " ; equipId = " .. equipId);

    self.m_tempEquipPosData[equipPos][equipType] = tostring(equipId);
    -- cclog("updateEquipPosData = " .. json.encode(self.m_tempEquipPosData))
    self:setTeamFormationData(self.m_btn_index);
end

function game_god_palace_adjustment.exchangeEquipPosDataByTwoPos(self,posIndex1,posIndex2,equipType)
    if posIndex1 == posIndex2 then return end
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    -- cclog("exchangeEquipPosDataByTwoPos posIndex1 = " .. posIndex1 .. " ; posIndex2 == " .. posIndex2);
    self.m_tempEquipPosData[posIndex1][equipType],self.m_tempEquipPosData[posIndex2][equipType] = self.m_tempEquipPosData[posIndex2][equipType],self.m_tempEquipPosData[posIndex1][equipType]
    self:setTeamFormationData(self.m_btn_index);
end

--[[

]]
function game_god_palace_adjustment.exchangeTeamAndAssEquipPosDataByTwoPos(self,posIndex1,posIndex2,equipType)
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    self.m_tempEquipPosData[posIndex1][equipType],self.m_tempEquipData[tostring(posIndex2-1)][equipType] = self.m_tempEquipData[tostring(posIndex2-1)][equipType],self.m_tempEquipPosData[posIndex1][equipType]
    self:setTeamFormationData(self.m_btn_index)
end

-------------------------------------------------------------------------
--[[--
    判断宝石是否装备上
]]
function game_god_palace_adjustment.gemInGemPos(self,tempType,tempId)
    -- cclog("tempType ====== " .. tostring(tempType) .. " ; tempId ==== " .. tostring(tempId))
    local existFlag = false;
    local posIndex = -1;
    if tempType then
        for i=1,9 do
            if self.m_tempGemPosData[i][tempType] == tempId then
                posIndex = i;
                existFlag = true
                break;
            end
        end
    end
    return existFlag,posIndex;
end
function game_god_palace_adjustment.autoMatchFateEquip( self,heroId,posIndex )
    local cardData,cardCfg = game_data:getCardDataById( heroId );
    if not cardCfg then return end
    local curPosEquip = self.m_tempEquipPosData[tonumber(posIndex)]
    local recommendEquip = {"0","0","0","0"}
    local recommendEquipData = {}
    local equipTable = game_data:getEquipIdTable()
    local equipCfg = getConfig(game_config_field.equip);
    local existFlag,cardName, pos = true, nil, nil
    local itemData, itemCfg = nil, nil
    local toNilFlag = false
    local tempTab = {1,1,1,1}
    if cardData.bind_equip and next(cardData.bind_equip) then
        for i=1,4 do
            if cardData.bind_equip[i] ~= 0 then
                self.m_EquipPosDataTab[self.m_btn_index][tostring(posIndex-1)][i] = cardData.bind_equip[i]
                self.m_tempEquipPosData[tonumber(posIndex)][i] = cardData.bind_equip[i]
            else
                local equipData = game_data:getEquipDataById(curPosEquip[i])
                if equipData and equipData.bind_card  and equipData.bind_card ~= "" then
                    if equipData.bind_card ~= cardData.id then
                        cclog("--111--")
                        self.m_EquipPosDataTab[self.m_btn_index][tostring(posIndex-1)][i] = "0"
                        self.m_tempEquipPosData[tonumber(posIndex)][i] = "0"
                    end
                else
                end
            end
        end
    else
        for sort,Id in pairs(curPosEquip) do
            local equipData = game_data:getEquipDataById(Id)
            if equipData and equipData.bind_card  and equipData.bind_card ~= "" then
                if equipData.bind_card ~= cardData.id then
                      cclog("--222--")
                    self.m_EquipPosDataTab[self.m_btn_index][tostring(posIndex-1)][sort] = "0"
                    self.m_tempEquipPosData[tonumber(posIndex)][i] = "0"
                end
            else

            end
        end
    end
    -- cclog2(self.m_EquipPosDataTab[self.m_btn_index][tostring(posIndex-1)],"self.m_tempEquipPosData ---11111 ")
    -- cclog2(self.m_tempEquipPosData[(posIndex-1)],"self.m_tempEquipPosData ---222222 ")

    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)

end
--判断该装备是否可以命运装备绑定
function game_god_palace_adjustment.fateEquipLock(self,itemData,tempEquipId)
    local fateEquipId = string.sub(itemData.c_id,1,3)
    if tonumber(itemData.c_id) > 100100 then
        fateEquipId = string.sub(itemData.c_id,1,4)
    end
    local fateEquipLock = false
    if self.m_selHeroId then
        local heroData,heroCfg = game_data:getCardDataById(self.m_selHeroId)
        local chain_cfg = getConfig(game_config_field.chain);
        local chain = heroCfg:getNodeWithKey("chain")
        local chainCount = chain:getNodeCount();
        for i=1,chainCount do
            local chainId = chain:getNodeAt(i-1):toStr();
            local chainItemCfg = chain_cfg:getNodeWithKey(chainId);
            local equip_cfg = getConfig(game_config_field.equip);
            if chainItemCfg then
                local data = chainItemCfg:getNodeWithKey("data")
                local dataCount = data:getNodeCount();
                local condition_sort = chainItemCfg:getNodeWithKey("condition_sort"):toInt();
                if dataCount > 0 then
                    if condition_sort == 1 then
                        for i=1,dataCount do
                            local itemCfg = equip_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                itemCfg = json.decode(itemCfg:getFormatBuffer())
                                local chain_id = itemCfg.chain_id
                                cclog2(chain_id,"chain_id    ====")
                                cclog2(tonumber(fateEquipId),"tonumber(fateEquipId)    ====")
                                
                                if chain_id == tonumber(fateEquipId) then
                                    return  true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local heroData,heroCfg = game_data:getCardDataById(self.m_selHeroId)
    local chainEquipDataTab = game_util:cardEquipChainByCfg(heroCfg, heroData.id)
    local equipCfg = getConfig(game_config_field.equip);
    local itemData2, itemCfg2 = game_data:getEquipDataById(tostring(tempEquipId));
    local isThisChainFlag = game_util:isCardChainEquip(itemCfg2, chainEquipDataTab ) or false
    return isThisChainFlag
end

--[[--
    获得位置上的宝石ID
]]
function game_god_palace_adjustment.getPosGemId(self,tempPos,tempType)
    local tempEquipId = 0;
    if self.m_tempGemPosData[tempPos] then
        tempEquipId = self.m_tempGemPosData[tempPos][tempType]
    end
    return tempEquipId;
end

--[[--
    设置阵型相应位置宝石数据
]]
function game_god_palace_adjustment.updateGemPosData(self,tempPos,tempType,tempId)
    if tempPos > 9 or tempPos < 0 or tempType > 4 or tempType < 1 then return end
    cclog("updateGemPosData tempPos = " .. tempPos .. " ; tempType = " .. tempType .. " ; tempId = " .. tempId);
    local posGemId = tostring(self.m_tempGemPosData[tempPos][tempType]);
    tempId = tostring(tempId);
    game_data:addGodGemDataByCid(posGemId,1)
    game_data:minusGodGemDataCid(tempId,1)
    self.m_tempGemPosData[tempPos][tempType] = tempId;
    -- cclog("updateGemPosData = " .. json.encode(self.m_tempGemPosData))
    self:setTeamFormationData(self.m_btn_index);
end

function game_god_palace_adjustment.exchangeGemPosDataByTwoPos(self,posIndex1,posIndex2,tempType)
    if posIndex1 == posIndex2 then return end
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or tempType > 4 or tempType < 1 then return end
    -- cclog("exchangeGemPosDataByTwoPos posIndex1 = " .. posIndex1 .. " ; posIndex2 == " .. posIndex2);
    self.m_tempGemPosData[posIndex1][tempType],self.m_tempGemPosData[posIndex2][tempType] = self.m_tempGemPosData[posIndex2][tempType],self.m_tempGemPosData[posIndex1][tempType]
    self:setTeamFormationData(self.m_btn_index);
end

-------------------------------------------------------------------------

--[[--
    获得阵型相关的数据
]]
function game_god_palace_adjustment.setTeamFormationData(self,index)
    local formationId = 1;
    -- cclog2(index,"index..........")
    -- cclog2(self.m_tempSoulPosData,"self.m_tempSoulPosDataself.m_tempSoulPosData")
    local tempTeamData = {};
    local tempEquipPosData = {};
    local tempGemPosData = {};
    local tempMedalPosData = {}
    local tempSoulPosData = {}
    local emptyFlag = false;
    local tempCardId = nil;
    local tempEquipItem,tempGemItem,tempMedalItem,tempSoulItem = nil,nil,nil,nil
    local tempCount = 1;
    for i=1,9 do
        tempCardId = self.m_tempTeamData[i]
        tempEquipItem = self.m_tempEquipPosData[i];
        tempGemItem = self.m_tempGemPosData[i];
        tempMedalItem = self.m_tempMedalPosData[tostring(i - 1)];
        tempSoulItem = self.m_tempSoulPosData[tostring(i - 1)];
        if tempCardId == "-1" or tempCardId == "0" then
            tempEquipItem = {"0","0","0","0"}
            self.m_tempEquipPosData[i] = tempEquipItem
        end
        if i < 7 then

            if tempCardId == "-1" and emptyFlag == false then
                emptyFlag = true;
                formationId = i;
                -- tempEquipItem = {"0","0","0","0"}
            else
                if tempCount < 7 then
                    tempTeamData[tempCount] = tempCardId
                    tempCount = tempCount + 1;
                end
            end
        else
            tempTeamData[tempCount] = tempCardId
            tempCount = tempCount + 1;
        end

        if i < 7 then
            tempEquipPosData[tostring(i-1)] = util.table_copy(tempEquipItem);
            tempGemPosData[tostring(i-1)] = util.table_copy(tempGemItem);
            tempMedalPosData[tostring(i-1)] = util.table_copy(tempMedalItem)
            tempSoulPosData[tostring(i-1)] = util.table_copy(tempSoulItem)  
        else
            tempEquipPosData[tostring(tempCount-1)] = util.table_copy(tempEquipItem);
            tempGemPosData[tostring(tempCount-1)] = util.table_copy(tempGemItem);
            tempMedalPosData[tostring(tempCount-1)] = util.table_copy(tempMedalItem)
            tempSoulPosData[tostring(tempCount-1)] = util.table_copy(tempSoulItem)
        end
    end
    
        -- tempTeamData[9] = "-1";
    tempEquipPosData[tostring(9)] = {"0","0","0","0"}
    
    
    
    self.m_teamTab[tostring(index)] = tempTeamData;
    
    self.m_EquipPosDataTab[index] = tempEquipPosData;
    self.m_GemPosDataTab[index] = tempGemPosData;
    self.m_MedalPosDataTab[index] = tempMedalPosData;
    self.m_SoulPosDataTab[index] = tempSoulPosData;
    game_data:setAllGodSoulPosData(self.m_SoulPosDataTab)
    game_data:setAllGodMedalPosData(self.m_MedalPosDataTab)
    -- cclog("------------------------------------------",json.encode(tempTeamData))
    -- cclog("------------------------------------------",json.encode(self.m_teamTab))
    
    -- cclog("formationId ================== " .. formationId)
    self.m_selFormationId = formationId;
    if self.m_btn_index == 1 then
        self.m_selFormationId1 = self.m_selFormationId
        self.teamflag1 = true;
    elseif self.m_btn_index == 2 then
        self.m_selFormationId2 = self.m_selFormationId
        self.teamflag2 = true;
    elseif self.m_btn_index == 3 then
        self.m_selFormationId3 = self.m_selFormationId
        self.teamflag3 = true;
    end
end

function game_god_palace_adjustment.exchangeEquipPosAlert(self,posIndex,currPos,sort,id,posType,teamflag)

    local flag = 0;
    for i=1,9 do
        if tostring(self.m_tempEquipPosData[i][sort]) ~= id then
            flag = flag + 1
            -- cclog2(flag,"flag===555=" .. i)
        end
    end

    if flag == 9 then
             posType = 2;
            -- cclog2(posType,"posType===3=3=3=3=4=5=47=55=577==")
    end

    if posType == 1 and posIndex == currPos then  
        game_util:addMoveTips({text = "Trang bị này ở vị trí này!"});
        return 
    end
    local tempText = nil;
    local heroData,heroCfg = nil,nil
    if posType == 1 then
        heroData,heroCfg = self:getTeamCardDataByPos(currPos)
    end
    if heroData and heroCfg then
        tempText = "Trang bị này đang được" .. heroCfg:getNodeWithKey("name"):toStr() .. "dùng, xác nhận đổi?"
    else
        tempText = "Trang bị này đang dùng ở vị trí khác, xác nhận đổi?"
    end
    local t_params = 
    {
        title = string_config.m_title_prompt,
        okBtnCallBack = function(target,event)
            self.m_selEquipId = id;
            local m_tEquipPosData1 = self.m_EquipPosDataTab[1];
            local m_tEquipPosData2 = self.m_EquipPosDataTab[2];
            local m_tEquipPosData3 = self.m_EquipPosDataTab[3];
            for i=1,10 do
                if tostring(m_tEquipPosData1[tostring(i-1)][sort]) == self.m_selEquipId  then 
                    self.m_tempEquipData = m_tEquipPosData1
                end
                if tostring(m_tEquipPosData2[tostring(i-1)][sort]) == self.m_selEquipId then
                    self.m_tempEquipData = m_tEquipPosData2
                end
                if tostring(m_tEquipPosData3[tostring(i-1)][sort]) == self.m_selEquipId then 
                    self.m_tempEquipData = m_tEquipPosData3
                end
                
            end
            self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
            game_scene:removePopByName("game_god_equip_select_pop");
            game_util:closeAlertView();
            if posType == 1 then
                self:exchangeEquipPosDataByTwoPos(posIndex,currPos,sort)
                
            elseif posType == 2 then
                self:exchangeTeamAndAssEquipPosDataByTwoPos(posIndex,currPos,sort);
            end
            self.m_changeFlag = true;
            self:addTeamHeroPop(posIndex);
            -- self:newChainOpenAnim("equip");
        end,   --可缺省
        okBtnText = "Đổi trang bị",       --可缺省
        text = tempText,      --可缺省
    }
    game_util:openAlertView(t_params);
end

--[[--
    
]]
function game_god_palace_adjustment.addSelEquipUi(self,posIndex,sort)

    -- cclog("addSelEquipUi posIndex ==" .. tostring(posIndex))
    local btnCallFunc = function( target,event )
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if id then
                local existFlag,currPos,posType,teamflag = self:equipInEquipPos(sort,id)
                if existFlag then
                    self:exchangeEquipPosAlert(posIndex,currPos,sort,id,posType,teamflag);
                else
                    self.m_selEquipId = id;
                    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                    game_scene:removePopByName("game_god_equip_select_pop");
                    -- cclog("itemOnClick changed id ==================== " .. id);
                    self:updateEquipPosData(posIndex,sort,id);
                    self.m_changeFlag = true;
                    self:addTeamHeroPop(posIndex);
                    -- self:newChainOpenAnim("equip");
                    self:refreshCombatLabel();
                end
            end
        elseif typeName == "unload" then
            self:updateEquipPosData(posIndex,sort,"0");
            -- cclog("itemOnClick remove id ==================== ");
            self.m_changeFlag = true;
            self:addTeamHeroPop(posIndex);
            self:refreshCombatLabel();
        end
    end

    self.m_teamAllPos = {self.m_tempTeamData1,self.m_tempTeamData2,self.m_tempTeamData3}
    -- game_scene:addPop("game_god_equip_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = sort,openType = 2,m_EquipPosDataTab = self.m_EquipPosDataTab,m_tempTeamData = self.m_teamAllPos, m_btn_index=self.m_btn_index})
end
--[[
    
]]
function game_god_palace_adjustment.exchangeGemPosAlert(self,posIndex,currPos,sort,id)
    if posIndex == currPos then 
        game_util:addMoveTips({text = "该宝石在此位置上！"});
        return 
    end
    local tempText = nil;
    local itemData,itemCfg = self:getTeamCardDataByPos(currPos)
    if itemData and itemCfg then
        tempText = "该宝石正在被" .. itemCfg:getNodeWithKey("name"):toStr() .. "使用,确定更换吗？"
    else
        tempText = "该宝石正在其他位置上使用,确定更换吗？"
    end
    local t_params = 
    {
        title = string_config.m_title_prompt,
        okBtnCallBack = function(target,event)
            self.m_selGemPos = currPos;
            game_scene:removePopByName("gem_system_select_pop");
            game_util:closeAlertView();
            self:exchangeGemPosDataByTwoPos(posIndex,currPos,sort);
            self.m_changeFlag = true;
            self:addTeamHeroPop(posIndex);
        end,   --可缺省
        okBtnText = "宝石更换",       --可缺省
        text = tempText,      --可缺省
    }
    game_util:openAlertView(t_params);
end

--[[--
    
]]
function game_god_palace_adjustment.addSelGemUi(self,posIndex,sort)
    
    -- cclog("addSelGemUi posIndex ==" .. tostring(posIndex) .. " ; sort = " .. tostring(sort))
    local btnCallFunc = function( target,event )
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if id then
                -- local existFlag,currPos = self:gemInGemPos(sort,id)
                -- if existFlag then
                    local gemCount,_ = game_data:getGodGemDataById(id);
                if gemCount < 0 then
                    self:exchangeGemPosAlert(posIndex,currPos,sort,id);
                else
                    self.m_selGemPos = sort;
                    game_scene:removePopByName("gem_system_select_pop");
                    cclog("itemOnClick changed id ==================== " .. id);
                    self:updateGemPosData(posIndex,sort,id);
                    self.m_changeFlag = true;
                    self:addTeamHeroPop(posIndex);
                    self:refreshCombatLabel();

                end
            end
        elseif typeName == "unload" then
            self:updateGemPosData(posIndex,sort,"0");
            cclog("itemOnClick remove id ==================== ");
            self.m_changeFlag = true;
            self:addTeamHeroPop(posIndex);
            self:refreshCombatLabel();
        end
    end
    -- game_scene:addPop("gem_system_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = sort,openType = 3})
end

--[[--
    刷新ui
]]
function game_god_palace_adjustment.refreshCombatLabel(self)
    -- if self.m_tempCombatValue == nil then
    --     self.m_tempCombatValue = game_util:getGodCombatValue(self.m_tempTeamData,self.m_EquipPosDataTab[self.m_btn_index],self.m_GemPosDataTab[self.m_btn_index],self.m_tempSoulPosData,self.m_tempMedalPosData);
    --     self.m_combatNumberChangeNode:setCurValue(self.m_tempCombatValue,false);
    -- else
    --     local tempCombatValue = game_util:getGodCombatValue(self.m_tempTeamData,self.m_EquipPosDataTab[self.m_btn_index],self.m_GemPosDataTab[self.m_btn_index],self.m_tempSoulPosData,self.m_tempMedalPosData);
    --     local changeValue = tempCombatValue - self.m_tempCombatValue
    --     self.m_tempCombatValue = tempCombatValue;
    --     game_util:combatChangedValueAnim({combatNode = self.m_combatNumberChangeNode,currentValue = tempCombatValue,changeValue = changeValue});
    -- end
    -- self.m_combatNumberChangeNode:setCurValue(self.m_god_combat[self.m_check_index],false);
    -- game_data:setGodCombat(self.m_tempCombatValue,self.m_btn_index)
end

--[[--
    刷新ui
]]
function game_god_palace_adjustment.refreshUi(self)
    self:initTeamFormation(self.m_formation_layer);
    self:refreshCombatLabel();
    if self.m_posIndex ~= -1 then
        self:refreshHeroInfo(self.m_posIndex);
    else
        self.m_posIndex = self.m_tempSelIndex;
        self:refreshHeroInfo(self.m_tempSelIndex);
    end
end

function game_god_palace_adjustment.refreshBadge(self)
    if self.m_teamIndex ~= 1 then
        return
    end
    local pos = self.m_posIndex -- 当前选中位置
    local cardData,cardCfg = self:getTeamCardDataByPos( pos ); -- 当前选中位置英雄信息,可以为nil
    local m_tempTeamData = self.m_tempTeamData

    local nd_badges = self.m_ccbNode:nodeForName("nd_badges")

    ----------------- 刷新自己的徽章
    local node = nd_badges:getChildByTag(1)
    -- iconNd
    local iconNd = node:getChildByTag(1)
    iconNd:removeAllChildrenWithCleanup(true)
    if cardData and cardData.badge and cardData.badge ~= "" then -- 已经佩戴了徽章
        local badge = cardData.badge
        local badgeData,badgeCfg = game_data:getBadgeDataById(badge)
        badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}
        local image_S = badgeCfg.image_S
        local icon = CCSprite:create("icon/" .. image_S .. ".png")
        if icon then
            icon:setScale(0.8)
            iconNd:addChild(icon)
            icon:setColor(pos > 6 and ccc3(128, 128, 128) or ccc3(255, 255, 255))
        end
    end
    -- btn_curBadge
    local btn_curBadge = self.m_ccbNode:controlButtonForName("btn_curBadge")
    btn_curBadge:setColor(pos > 6 and ccc3(128, 128, 128) or ccc3(255, 255, 255))
    -- sp_curBadgeNotice
    local sp_curBadgeNotice = self.m_ccbNode:spriteForName("sp_curBadgeNotice")
    sp_curBadgeNotice:setColor(pos > 6 and ccc3(128, 128, 128) or ccc3(255, 255, 255))
    
    -- 可装备文本
    local canEquipLb = node:getChildByTag(2)
    if cardData and (not cardData.badge or cardData.badge == "") then -- 可装备
        canEquipLb:setVisible(true)
    else
        canEquipLb:setVisible(false)
    end
    -------------------- 刷新其他已经装备的徽章
    local _data = {}
    local cardId = cardData and cardData.id
    for k, v in ipairs(m_tempTeamData) do
        if v ~= cardId and v ~= "-1" and k <= 6 then 
            local cardData,cardCfg = game_data:getCardDataById(v)
            if cardData and cardData.badge and cardData.badge ~= "" then -- 已经佩戴了徽章
                table.insert(_data, v)
            end
        end
    end
    for i = 2, 5, 1 do
        local id = _data[i - 1]
        local node = nd_badges:getChildByTag(i)
        local iconNd = node:getChildByTag(1)
        iconNd:removeAllChildrenWithCleanup(true)
        if id then
            local cardData,cardCfg = game_data:getCardDataById(id)
            -- iconNd
            if cardData and cardData.badge and cardData.badge ~= "" then -- 已经佩戴了徽章
                local badge = cardData.badge
                local badgeData,badgeCfg = game_data:getBadgeDataById(badge)
                badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}
                local image_S = badgeCfg.image_S
                local icon = CCSprite:create("icon/" .. image_S .. ".png")
                if icon then
                    icon:setScale(0.8)
                    iconNd:addChild(icon)
                end
            end

        end
    end

    ------ 根据相同类型徽章的数量来激活相应组合技能
    local showData = {}
    ----- 先获取徽章中包含的badge_sort合集
    local sorts = {}
    for k, v in ipairs(m_tempTeamData) do
        if v ~= "-1" and k <= 6 then 
            local cardData,cardCfg = game_data:getCardDataById(v)
            if cardData and cardData.badge and cardData.badge ~= "" then -- 已经佩戴了徽章
                local badgeData,badgeCfg = game_data:getBadgeDataById(cardData.badge) -- 获取徽章配置
                if badgeCfg then
                    badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}
                    local badge_sort = badgeCfg.badge_sort
                    if badge_sort then
                        for _, sort in pairs(badge_sort) do
                            if not sorts[sort] then
                                sorts[sort] = 0
                            end
                            sorts[sort] = sorts[sort] + 1
                        end
                    end
                end
            end
        end
    end

    ----- 筛选出符合要求的配置
    local combinationCfgs = {}
    local badge_skill_combination = getConfig(game_config_field.badge_skill_combination)
    badge_skill_combination = json.decode(badge_skill_combination:getFormatBuffer() or "") or {}
    for k, v in pairs(badge_skill_combination) do
        local badge_sort = v.badge_sort
        local num = v.num

        if sorts[badge_sort] and num <= sorts[badge_sort] then
            if combinationCfgs[badge_sort] then
                if v.skill_quality > combinationCfgs[badge_sort].skill_quality then -- 替换成更高级的技能
                    combinationCfgs[badge_sort] = v
                end
            else
                combinationCfgs[badge_sort] = v -- 填入技能
            end
        end
    end

    ----- 放入showData中
    for k, v in pairs(combinationCfgs) do
        table.insert(showData, v)
    end
        
    ----- 最后按badge_sort排序
    table.sort(showData, function(a, b)
        if a.badge_sort ~= b.badge_sort then
            return a.badge_sort < b.badge_sort
        else
            return a.skill_quality > b.skill_quality
        end
    end)
        
    ----- ui渲染
    for i = 1, 3, 1 do
        local node = self.m_ccbNode:nodeForName("nd_badgeAttr" .. i)
        local lb = self.m_ccbNode:labelTTFForName("lb_badgeAttr" .. i)
        local cfg = showData[i]
        if cfg then
            node:setVisible(true)
            lb:setString(cfg.skill_story)
            lb:setColor(HERO_QUALITY_COLOR_TABLE[cfg.skill_quality].color)
            game_util.adaptNodeScaleX(lb, 180)
        else
            node:setVisible(false)
        end
    end
    -- if cardData and cardData.badge and cardData.badge ~= "" then -- 已经佩戴了徽章
    --     local badge = cardData.badge
    --     local badgeData,badgeCfg = game_data:getBadgeDataById(badge)
    --     badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}
    --     local image_S = badgeCfg.image_S
    --     local icon = CCSprite:create("icon/" .. image_S .. ".png")
    --     if icon then
    --         iconNd:addChild(icon)
    --     end
    -- end


    -- for i = 1, 5, 1 do
    --     local node = nd_badges:getChildByTag(i)
    --     -- iconNd
    --     local iconNd = node:getChildByTag(1)
    --     iconNd:removeAllChildrenWithCleanup(true)
    --     if cardData and cardData.badge and cardData.badge ~= "" then -- 已经佩戴了徽章
    --         local badge = cardData.badge
    --         local badgeData,badgeCfg = game_data:getBadgeDataById(badge)
    --         local image_S = badgeCfg.image_S
    --         local icon = CCSprite:create("icon/" .. image_S .. ".png")
    --         if icon then
    --             iconNd:addChild(icon)
    --         end
    --     end
    --     -- 可装备文本
    --     local canEquipLb = node:getChildByTag(2)
    --     if cardData and cardData.badge and cardData.badge == "" then -- 可装备
    --         canEquipLb:setString("可装备")
    --     else
    --         canEquipLb:setString("")
    --     end
    -- end
end


--[[--
    初始化
]]
function game_god_palace_adjustment.init(self,t_params)

    t_params = t_params or {};
    -- cclog2(t_params,"game_god_palace_adjustment t_params ===")
    self.m_teamPosNodeTab = {};
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data");
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
    else
        self.m_tGameData = {};
    end
    -- cclog2(self.m_tGameData,"self.m_tGameData=====")
    local first_time = t_params.first_time or nil
    if first_time ~= nil then
        local function endCallFunc()
        end
        local t_params = {};
        t_params.endCallFunc = endCallFunc;
        t_params.dramaId = 100200;
        -- game_scene:addPop("drama_dialog_pop",t_params);
    end
    self.m_openType = t_params.openType or self.m_openType;
    self.myformation = t_params.myformation or {}
    self.m_changeFlag = t_params.changeFlag or false
    self.is_formation = t_params.is_formation or false
    self.m_posIndex = -1;
    self.m_tempSelIndex = -1;
    self.m_tempTeamData = {};
    self.m_tempTeamData2 = {};
    self.m_tempTeamData3 = {};
    self.m_tempFriendData = {};
    self.m_tempEquipPosData = {};
    self.m_tempEquipPosData2 = {};
    self.m_tempEquipPosData3 = {};
    self.m_tempGemPosData = {};
    self.m_tempGemPosData2 = {};
    self.m_tempGemPosData3 = {};
    self.m_tempEquipData = {};

    self.m_MedalPosDataTab = {};--所有阵型勋章
    self.m_SoulPosDataTab = {};--所有阵型英魂
    self.m_tempMedalPosData = {};
    self.m_tempMedalPosData2 = {};
    self.m_tempMedalPosData3 = {};
    self.m_tempSoulPosData = {};
    self.m_tempSoulPosData2 = {};
    self.m_tempSoulPosData3 = {};

    self.m_teamAllPos = {}; --存所有格式化后的阵型，选择装备时用
    self.teamflag1 = false;
    self.teamflag2 = false;
    self.teamflag3 = false;
    if t_params.team_index then
        self.team_index = t_params.team_index
    else
        self.team_index = 1;
    end

    self.m_teamTab = self.m_tGameData.god_field_ids;
    -- cclog2(self.m_teamTab,"m_teamTab-=-=-=-=-=-=")
    self.m_card_info = self.m_tGameData.cards_info;
    -- cclog2(self.m_card_info,"m_card_info-=-=-=-=-=-=")
    self.m_EquipPosDataTab = {self.m_tGameData.equip_pos_1,self.m_tGameData.equip_pos_2,self.m_tGameData.equip_pos_3};
    self.m_GemPosDataTab = {self.m_tGameData.gem_pos_1,self.m_tGameData.gem_pos_2,self.m_tGameData.gem_pos_3};
    self.m_MedalPosDataTab = {self.m_tGameData.medal_pos_1,self.m_tGameData.medal_pos_2,self.m_tGameData.medal_pos_3};
    self.m_SoulPosDataTab = {self.m_tGameData.soul_pos_1,self.m_tGameData.soul_pos_2,self.m_tGameData.soul_pos_3};
    self.m_btn_index = self.team_index;
    self.m_check_index = self.team_index;
    local formationData = game_data:getFormationData();
    local ownFormation = formationData.own
    local ownFormationCount = #ownFormation
    self.m_currentFormationId = formationData.current
    self.m_selFormationId = self.m_currentFormationId;
    self.m_god_combat = {self.m_tGameData.god_combat_1,self.m_tGameData.god_combat_2,self.m_tGameData.god_combat_3} or {}
    -- self.m_god_combat_2 = self.m_tGameData.god_combat_2 or 0
    -- self.m_god_combat_3 = self.m_tGameData.god_combat_3 or 0
    -- cclog(self.m_god_combat_1,self.m_god_combat_2,self.m_god_combat_2,"-=-=-=-=-=-=-=-=-=-=-=-")
    local teamData ,teamData2, teamData3 = {} ,{} ,{}
    teamData = self.m_teamTab["1"];
    teamData2 = self.m_teamTab["2"];
    teamData3 = self.m_teamTab["3"];
    local tempEquipPosData = {};
    local tempEquipPosData2 = {};
    local tempEquipPosData3 = {};

    local tempGemPosData = {};
    local tempGemPosData2 = {};
    local tempGemPosData3 = {};

    local tempMedalPosData = {};
    local tempMedalPosData2 = {};
    local tempMedalPosData3 = {};

    local tempSoulPosData = {};
    local tempSoulPosData2 = {};
    local tempSoulPosData3 = {};

    local tempEquipPos1 = self.m_EquipPosDataTab[1];
    local tempEquipPos2 = self.m_EquipPosDataTab[2];
    local tempEquipPos3 = self.m_EquipPosDataTab[3];
    
    local tempGemPos1 = self.m_GemPosDataTab[1];
    local tempGemPos2 = self.m_GemPosDataTab[2];
    local tempGemPos3 = self.m_GemPosDataTab[3];

    local tempMedalPos1 = self.m_MedalPosDataTab[1];
    local tempMedalPos2 = self.m_MedalPosDataTab[2];
    local tempMedalPos3 = self.m_MedalPosDataTab[3];

    local tempSoulPos1 = self.m_SoulPosDataTab[1];
    local tempSoulPos2 = self.m_SoulPosDataTab[2];
    local tempSoulPos3 = self.m_SoulPosDataTab[3];
    for i=1,10 do
        table.insert(tempEquipPosData,i-1,tempEquipPos1[tostring(i-1)])
        table.insert(tempEquipPosData2,i-1,tempEquipPos2[tostring(i-1)])
        table.insert(tempEquipPosData3,i-1,tempEquipPos3[tostring(i-1)])
        table.insert(tempGemPosData,i-1,tempGemPos1[tostring(i-1)])
        table.insert(tempGemPosData2,i-1,tempGemPos2[tostring(i-1)])
        table.insert(tempGemPosData3,i-1,tempGemPos3[tostring(i-1)])
        table.insert(tempMedalPosData,i-1,tempMedalPos1[tostring(i-1)])
        table.insert(tempMedalPosData2,i-1,tempMedalPos2[tostring(i-1)])
        table.insert(tempMedalPosData3,i-1,tempMedalPos3[tostring(i-1)])
        table.insert(tempSoulPosData,i-1,tempSoulPos1[tostring(i-1)])
        table.insert(tempSoulPosData2,i-1,tempSoulPos2[tostring(i-1)])
        table.insert(tempSoulPosData3,i-1,tempSoulPos3[tostring(i-1)])
    end
    for i = #teamData,1,-1 do
        if teamData[i]== "0" then
            table.remove(teamData,i)
            -- teamData[i] = "-1"
            -- table.remove(tempEquipPosData,i-1)
            self.m_selFormationId1 = i
        end
    end
    for i = #teamData2,1,-1 do
        if teamData2[i]== "0" then
            table.remove(teamData2,i)
            -- table.remove(tempEquipPosData2,i-1)
            -- teamData[i] = "-1"
            self.m_selFormationId2 = i
        end
    end

    for i = #teamData3,1,-1 do
        if teamData3[i]== "0" then
            table.remove(teamData3,i)
            -- table.remove(tempEquipPosData3,i-1)
            -- teamData[i] = "-1"
            self.m_selFormationId3 = i
        end
    end

    -- cclog2(teamData3,"self.m_teamTab[3]=======")
   
    local formationConfig = getConfig(game_config_field.formation);
    local itemCfg = formationConfig:getNodeWithKey(tostring(self.m_selFormationId1));
    local tempTag = 1;
    local iValue = nil;

    
    if itemCfg ~= nil then
        for i=1,9 do
            self.m_tempEquipPosData[i] = tempEquipPosData[tonumber(i-1)]
            self.m_tempGemPosData[i] = tempGemPosData[tonumber(i-1)]
            self.m_tempMedalPosData[tostring(i-1)] = tempMedalPosData[tonumber(i-1)]
            self.m_tempSoulPosData[tostring(i-1)] = tempSoulPosData[tonumber(i-1)]
        end

        for i=1,#formationPosTab do
            local formationPosTabItem = formationPosTab[i];
            -- cclog(itemCfg:getFormatBuffer())
            -- cclog("formationPosTabItem.key =========" .. formationPosTabItem.key .. " ; itemCfg = " .. tostring(itemCfg))
            iValue = itemCfg:getNodeWithKey(formationPosTabItem.key):toInt();
            -- cclog2(iValue,"iValue====")
            if iValue ~= 0 and tempTag < 7 then
                self.m_tempTeamData[i] = teamData[tempTag]
                -- cclog2(self.m_tempTeamData[i],"self.m_tempTeamData[i]======" .. i)
                -- self.m_tempEquipPosData[i] = util.table_copy(tempEquipPosData[tonumber(tempTag-1)]);
                -- self.m_tempGemPosData[i] = util.table_copy(tempGemPosData[tonumber(tempTag-1)]);
                tempTag = tempTag + 1;
            else
                self.m_tempTeamData[i] = "-1";
                -- self.m_tempEquipPosData[i] = {"0","0","0","0"}
                -- self.m_tempGemPosData[i] = {"0","0","0","0"}
            end
        end
    end
    for i=6,8 do
        self.m_tempTeamData[i+1] = teamData[i];
        -- self.m_tempEquipPosData[i+1] = util.table_copy(tempEquipPosData[tonumber(i-1)]);
        -- self.m_tempGemPosData[i+1] = util.table_copy(tempGemPosData[tonumber(i-1)]);
    end
    local tempTag = 1;
    local iValue = nil;
    local itemCfg2 = formationConfig:getNodeWithKey(tostring(self.m_selFormationId2));
    if itemCfg2 ~= nil then
        for i=1,9 do
            self.m_tempEquipPosData2[i] = tempEquipPosData2[tonumber(i-1)]
            self.m_tempGemPosData2[i] = tempGemPosData2[tonumber(i-1)]
            self.m_tempMedalPosData2[tostring(i-1)] = tempMedalPosData2[tonumber(i-1)]
            self.m_tempSoulPosData2[tostring(i-1)] = tempSoulPosData2[tonumber(i-1)]
        end

        for i=1,#formationPosTab do
            local formationPosTabItem = formationPosTab[i];
            iValue = itemCfg2:getNodeWithKey(formationPosTabItem.key):toInt();
            -- cclog2(iValue,"iValue====")
            if iValue ~= 0 and tempTag < 7 then
                self.m_tempTeamData2[i] = teamData2[tempTag]
                -- self.m_tempEquipPosData2[i] = util.table_copy(tempEquipPosData2[tonumber(tempTag-1)]);
                -- self.m_tempGemPosData2[i] = util.table_copy(tempGemPosData2[tonumber(tempTag-1)]);
                tempTag = tempTag + 1;
            else
                self.m_tempTeamData2[i] = "-1";
                -- self.m_tempEquipPosData2[i] = {"0","0","0","0"}
                -- self.m_tempGemPosData2[i] = {"0","0","0","0"}
            end
        end
    end
    for i=6,8 do
        self.m_tempTeamData2[i+1] = teamData2[i];
        -- self.m_tempEquipPosData2[i+1] = util.table_copy(tempEquipPosData2[tonumber(i-1)]);
        -- self.m_tempGemPosData2[i+1] = util.table_copy(tempGemPosData2[tonumber(i-1)]);
    end


    local tempTag = 1;
    local iValue = nil;
    local itemCfg3 = formationConfig:getNodeWithKey(tostring(self.m_selFormationId3));
    if itemCfg3 ~= nil then
        for i=1,9 do
            self.m_tempEquipPosData3[i] = tempEquipPosData3[tonumber(i-1)]
            self.m_tempGemPosData3[i] = tempGemPosData3[tonumber(i-1)]
            self.m_tempMedalPosData3[tostring(i-1)] = tempMedalPosData3[tonumber(i-1)]
            self.m_tempSoulPosData3[tostring(i-1)] = tempSoulPosData3[tonumber(i-1)]
        end

        for i=1,#formationPosTab do
            local formationPosTabItem = formationPosTab[i];
            -- cclog(itemCfg:getFormatBuffer())
            -- cclog("formationPosTabItem.key =========" .. formationPosTabItem.key .. " ; itemCfg = " .. tostring(itemCfg))
            iValue = itemCfg3:getNodeWithKey(formationPosTabItem.key):toInt();
            -- cclog2(iValue,"iValue====")
            if iValue ~= 0 and tempTag < 7 then
                self.m_tempTeamData3[i] = teamData3[tempTag]
                -- cclog2(self.m_tempTeamData[i],"self.m_tempTeamData[i]======" .. i)
                -- self.m_tempEquipPosData3[i] = util.table_copy(tempEquipPosData3[tonumber(tempTag-1)]);
                -- self.m_tempGemPosData3[i] = util.table_copy(tempGemPosData3[tonumber(tempTag-1)]);
                tempTag = tempTag + 1;
            else
                self.m_tempTeamData3[i] = "-1";
                -- self.m_tempEquipPosData3[i] = {"0","0","0","0"}
                -- self.m_tempGemPosData3[i] = {"0","0","0","0"}
            end
        end
    end
    for i=6,8 do
        self.m_tempTeamData3[i+1] = teamData3[i];
        -- self.m_tempEquipPosData3[i+1] = util.table_copy(tempEquipPosData3[tonumber(i-1)]);
        -- self.m_tempGemPosData3[i+1] = util.table_copy(tempGemPosData3[tonumber(i-1)]);
    end

    self.m_tempTeamData1 = self.m_tempTeamData;  ---暂存第一阵型的数据
    self.m_tempEquipPosData1 = self.m_tempEquipPosData;
    self.m_tempGemPosData1 = self.m_tempGemPosData;
    self.m_tempMedalPosData1 = self.m_tempMedalPosData;
    self.m_tempSoulPosData1 = self.m_tempSoulPosData;

    self.m_selFormationId = self.m_selFormationId1; 
    self.m_teamAllPos = {self.m_tempTeamData1,self.m_tempTeamData2,self.m_tempTeamData3}
    local m_EquipAllPos = {self.m_tempEquipPosData,self.m_tempEquipPosData2,self.m_tempEquipPosData3}
    local m_GemAllPos = {self.m_tempGemPosData,self.m_tempGemPosData2,self.m_tempGemPosData3}
    local m_MedalAllPos = {self.m_tempMedalPosData,self.m_tempMedalPosData2,self.m_tempMedalPosData3}
    local m_SoulAllPos = {self.m_tempSoulPosData,self.m_tempSoulPosData2,self.m_tempSoulPosData3}
    game_data:setAllGodSoulPosData(m_SoulAllPos);  --设置英魂
    game_data:setAllGodMedalPosData(m_MedalAllPos);  --设置勋章
    self.m_tempTeamData = self.m_teamAllPos[self.team_index];
    self.m_tempEquipPosData = m_EquipAllPos[self.team_index];
    self.m_tempGemPosData = m_GemAllPos[self.team_index];
    self.m_tempMedalPosData = m_MedalAllPos[self.team_index];
    self.m_tempSoulPosData = m_SoulAllPos[self.team_index];
    -- local cardNumData = game_data:getBattleCardNumData()
    local maxCount1,maxCount2 = 5,3;
    self.m_openTab = TEAM_POS_OPEN_TAB["open" .. maxCount1 .. maxCount2] or {};
    self.m_tempSelIndex = -1;
    self.m_tempCombatValue = nil;
    self.m_teamIndex = 1;
    self.m_ability2OpenFlag = game_data:isViewShowByID(145)
    self.m_teamGemOpenFlag = game_data:isViewShowByID(181)
end

--[[--
    创建ui入口并初始化数据
]]
function game_god_palace_adjustment.create(self,t_params)
    -- body
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    

    return scene;
end

--[[
    自动穿装备
]]
function game_god_palace_adjustment.autoMatchEquip( self, cardIndex )
    if self.m_teamIndex == 1 then
        local cardData,cardCfg = self:getTeamCardDataByPos( cardIndex );
        if not cardCfg then return end

        local curPosEquip = self.m_tempEquipPosData[tonumber(cardIndex)]
        -- cclog2(curPosEquip, "curPosEquip " .. cardIndex .."   ====    ")
        local recommendEquip = {"0","0","0","0"}
        local recommendEquipData = {}

        local chainEquipDataTab = game_util:cardEquipChainByCfg(cardCfg, cardData.id)
        -- cclog2(chainEquipDataTab, "chainEquipDataTab  =====   ")
        local equipTable = game_data:getEquipIdTable()
        -- cclog2(equipTable, "auto equip all equipTable  =====   ")
        local equipCfg = getConfig(game_config_field.equip);
        local existFlag,cardName, pos = true, nil, nil
        local itemData, itemCfg = nil, nil
        for i,v in ipairs(equipTable) do
            itemData, itemCfg = game_data:getEquipDataById(tostring(v));
            -- cclog2(itemData, tostring(i) .. "auto equip  itemData  =====   ")
            -- cclog2(itemCfg, tostring(i) .. "auto equip  itemCfg  =====   ")
            local equipSort = itemCfg:getNodeWithKey("sort") and itemCfg:getNodeWithKey("sort"):toInt() or 0
            local canUseFlag = true
            local can = self:isEquipCanUse(cardIndex, v, equipSort)
            -- cclog2(can,"can")
            if equipSort and not can then
                -- cclog2(" 这个装备属于 别人装备的")
                canUseFlag = false
            end
            if itemData.bind_card and itemData.bind_card ~= "" then
                canUseFlag = false
            end
            if canUseFlag then -- 可以装备
                if recommendEquip[equipSort] == "0" then  -- 这个位置没有装备任何东西呢
                    recommendEquip[equipSort] = v  
                    recommendEquipData[equipSort] = {itemData = itemData, itemCfg = itemCfg }
                else -- 已经有装备
                    local isThisChainFlag = game_util:isCardChainEquip(itemCfg, chainEquipDataTab ) or false
                    local autoFlag = true
                    if autoFlag and isThisChainFlag == false then
                        local isCurChainFlag = game_util:isCardChainEquip(recommendEquipData[equipSort].itemCfg, chainEquipDataTab ) or false
                        if isCurChainFlag == true then
                            autoFlag = false
                        end
                    elseif autoFlag and isThisChainFlag == true then
                        local isCurChainFlag = game_util:isCardChainEquip(recommendEquipData[equipSort].itemCfg, chainEquipDataTab ) or false
                        if isCurChainFlag == false then
                            autoFlag = false
                            recommendEquip[equipSort] = v  
                            recommendEquipData[equipSort].itemData = itemData
                            recommendEquipData[equipSort].itemCfg = itemCfg
                        end
                    end

                    if autoFlag then 
                        local curEquiplevel = recommendEquipData[equipSort].itemData.lv or 0
                        local curAddHP = game_util:getEquipHPAttributeValue(recommendEquipData[equipSort].itemCfg,curEquiplevel);
                        local thisEquiplevel = itemData.lv or 0
                        local thisAddHP = game_util:getEquipHPAttributeValue(itemCfg,thisEquiplevel);
                        if curAddHP < thisAddHP then
                            recommendEquip[equipSort] = v  
                            recommendEquipData[equipSort].itemData = itemData
                            recommendEquipData[equipSort].itemCfg = itemCfg
                        end
                    end
                end
            end
        end
            self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
            -- self:newChainOpenAnim("equip");
        for i=1,4 do
            if recommendEquip[i] ~= "0" and recommendEquip[i] ~= curPosEquip[i] then
                self.m_selEquipId = curPosEquip[i];
                self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                self:updateEquipPosData(cardIndex,i,recommendEquip[i]);
                self.m_changeFlag = true;
                self:addTeamHeroPop(cardIndex);
            end
        end
    end
end

--[[
    -- 判断装备是否被别人装备上了
    -- poxIndex 卡牌位置
    -- equipId 装备id
    -- equipSortIndex 装备的sort
]]
function game_god_palace_adjustment.isEquipCanUse( self, posIndex, equipId, equipSortIndex )

    local tempEquipPos1 = self.m_EquipPosDataTab[1];
    local tempEquipPos2 = self.m_EquipPosDataTab[2];
    local tempEquipPos3 = self.m_EquipPosDataTab[3];

    for k,v in pairs(tempEquipPos1) do
            v = v or {}
            if tostring(v[equipSortIndex]) == tostring(equipId) then
                return false
            end
    end

    for k,v in pairs(tempEquipPos2) do
            v = v or {}
            if tostring(v[equipSortIndex]) == tostring(equipId) then
                return false
            end
    end

    for k,v in pairs(tempEquipPos3) do
            v = v or {}
            if tostring(v[equipSortIndex]) == tostring(equipId) then
                return false
            end
    end
    return true
end


--[[--
    初始化阵型
]]
function game_god_palace_adjustment:initTeam(  )
    -- body
    if self.m_btn_index == 1 then
        self.m_tab_btn_1:setEnabled(false);
        self.m_tab_btn_2:setEnabled(true);
        self.m_tab_btn_3:setEnabled(true);
    elseif self.m_btn_index == 2 then
        self.m_tab_btn_1:setEnabled(true);
        self.m_tab_btn_2:setEnabled(false);
        self.m_tab_btn_3:setEnabled(true);
    elseif self.m_btn_index == 3 then
        self.m_tab_btn_1:setEnabled(true);
        self.m_tab_btn_2:setEnabled(true);
        self.m_tab_btn_3:setEnabled(false);
    end


    self:refreshCombatLabel();
    self.m_adjust1:setVisible(true);
    self.m_adjust2:setVisible(false);
    
    self.m_equip_layer:setVisible(true);
    if not self.m_teamGemOpenFlag then 
        self.m_gem_layer:setVisible(false);
        self.m_equip_layer:setPositionY(80)
    else
        self.m_gem_layer:setVisible(true);
    end
    self.m_activation_node:setVisible(false);
    self.m_title_node:setVisible(true)
    -- self.m_fate_label:setVisible(true);
    self.m_fate_detail_node:setVisible(false);
    self.m_eq_layer:setVisible(true)
    -- local tempSize = self.m_fate_detail_node:getContentSize();
    -- tempSize = CCSizeMake(tempSize.width,160);
    -- self.m_fate_detail_node:setContentSize(tempSize);
    -- self.m_fate_detail_node:removeAllChildrenWithCleanup(true);
    -- local scrollView = CCScrollView:create(tempSize);
    -- scrollView:setDirection(kCCScrollViewDirectionVertical);
    -- self.m_fate_detail_node:addChild(scrollView,2,2);
    -- self.m_oneFateScrollView = scrollView;
    self:clearFateTabView();
    self.m_teamIndex = 1;
    self:initTeamFormation(self.m_formation_layer);
    self.m_sel_bg:setVisible(true);
    self.m_posIndex = self.m_tempSelIndex;
    self:refreshHeroInfo(self.m_posIndex);
end


function game_god_palace_adjustment:fateTouchShow( x,y )
    if self.m_fate_label:isVisible() == true then
        realPos = self.m_fate_node:getParent():convertToNodeSpace(ccp(x,y));
        if self.m_fate_node:boundingBox():containsPoint(realPos) then
            self.m_fate_label:setVisible(false);
            self.m_equip_layer:setVisible(false);
            if self.m_teamIndex == 1 then
                self.m_gem_layer:setVisible(false)
            else
                self.m_activation_node:setVisible(false);
            end
            self.m_fate_detail_node:setVisible(true);
        end
    elseif self.m_fate_detail_node:isVisible() == true then
        realPos = self.m_fate_detail_node:getParent():convertToNodeSpace(ccp(x,y));
        if self.m_fate_detail_node:boundingBox():containsPoint(realPos) then
            self.m_fate_label:setVisible(true);
            if self.m_teamIndex == 1 then
                if self.m_teamGemOpenFlag then self.m_gem_layer:setVisible(true) end
                self.m_equip_layer:setVisible(true)
            else
                self.m_activation_node:setVisible(true);
                if self.m_ability2OpenFlag then self.m_equip_layer:setVisible(true) end
            end
            self.m_fate_detail_node:setVisible(false);
        end
    end
end

--[[
    
]]
function game_god_palace_adjustment.clearFateTabView(self)
    -- self.m_fate_list_view_bg:removeAllChildrenWithCleanup(true)
    self.m_scrollView:getContainer():removeAllChildrenWithCleanup(true)
end

--[[--------------------连协-------------------------]]

--[[
    根据英雄id检查英雄是否有配置徽章
]]
function game_god_palace_adjustment.checkHeroHasBadgeConfig(self, heroId)
    if not heroId or heroId == "-1" then
        return false
    end

    local badgeCfg = getConfig(game_config_field.badge)
    badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}
    for k, v in pairs(badgeCfg) do
        if v.badge_type_id == heroId then
            return true
        end
    end
    
    return false
end

return game_god_palace_adjustment;
�1