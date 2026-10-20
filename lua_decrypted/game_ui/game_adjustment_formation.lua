--- 编队信息 

local game_adjustment_formation = {
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
    m_fate_list_view_bg = nil,
    m_fateDataTab = nil,
    m_replace_btn = nil,
    m_assistant_detail_label = nil,
    m_ability2OpenFlag = nil,
    m_teamGemOpenFlag = nil,
    m_medal_btn = nil,

    m_tempMedalPosData = nil,
    m_tempSoulPosData = nil,
    allUniverseEffect = nil,--宇宙属性加成
    m_soul_btn = nil,
    m_zhuanshiData = nil,
    m_saint_stone_btn=nil,
    m_sp_btn_back=nil,
    m_showMore_flag=nil,
    m_btn_show_more=nil,
    m_tempSaintStonePosData=nil,
    btn_node=nil,
    m_node_sp_pos2=nil,
    m_node_sp_pos=nil,
  
};
--阵型的配置
-- local formationConfig = {{0,1,0,1,0},{1,1,1,1,1},{0,0,0,0,0},{1,0,1,0,1},{0,1,1,1,0},{1,0,0,0,1}} 
local tipsStrTab = {"Nhấp khung nhân vật để đổi nhân vật", "Kéo khung nhân vật có thể đổi vị trí", "Trong nhân vật chủ chiến cần có một nhân vật"}
local formationPosTab = {{key="position_a",x=0.82,y=0.83},{key="position_b",x=0.82,y=0.5},{key="position_c",x=0.82,y=0.17},{key="position_d",x=0.5,y=0.83},{key="position_e",x=0.5,y=0.5},{key="position_f",x=0.5,y=0.17}};

--[[--
    销毁
]]
function game_adjustment_formation.destroy(self)
    -- body
    cclog("-----------------game_adjustment_formation destroy-----------------");
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
    self.m_fate_list_view_bg = nil;
    self.m_fateDataTab = nil;
    self.m_replace_btn = nil;
    self.m_assistant_detail_label = nil;
    self.m_ability2OpenFlag = nil;
    self.m_teamGemOpenFlag = nil;
    self.m_medal_btn = nil;

    self.m_tempMedalPosData = nil;
    self.m_tempSoulPosData = nil;
    self.allUniverseEffect = nil;
    self.m_soul_btn = nil;
    self.m_zhuanshiData = nil;
    self.m_saint_stone_btn=nil;
    self.m_sp_btn_back=nil;
    self.m_showMore_flag=nil;
    self.m_btn_show_more=nil;
    self.m_tempSaintStonePosData=nil;
    self.btn_node=nil;
    self.m_node_sp_pos2=nil;
    self.m_node_sp_pos=nil;

end
--[[--
    返回
]]
function game_adjustment_formation.back(self,type)
    -- cclog2(type,"type-=-----------")
    local id = game_guide_controller:getCurrentId();
    if id == 50 then
        local function endCallFunc()
            self:destroy();
        end
        game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
        return;
    end
    if self.m_openType == "game_small_map_scene" then
        local function responseMethod(tag,gameData)
            game_data:setSelCityDataByJsonData(gameData:getNodeWithKey("data"));
            game_scene:enterGameUi("game_small_map_scene",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_open"), http_request_method.GET, {city = game_data:getSelCityId()},"private_city_open")
    elseif self.m_openType == "zhuanshi" then
        game_scene:enterGameUi("game_hero_zhuanshi_task",{gameData = self.m_zhuanshiData})
        self:destroy();
    elseif self.m_openType == "zhuanshiTask2" then
            local major = self.m_zhuanshiData.id
            game_scene:enterGameUi("game_hero_zhuanshiTask_map",{gameData = nil,major = major})
            self:destroy();
    elseif self.m_openType == "map_building_detail_scene" then
        local function responseMethod(tag,gameData)
            game_data:setSelCityDataByJsonData(gameData:getNodeWithKey("data"));
            local lastStep = nil
            local lastStepData = game_data:getDataByKey("ToAdjustBuildLastStep")
            if lastStepData then
                lastStep = lastStepData.next_step
            end
            game_data:setDataByKeyAndValue("ToAdjustBuildLastStep", nil)
            game_scene:enterGameUi("map_building_detail_scene",{cityId = game_data:getSelCityId(),buildingId = game_data:getSelBuildingId(), 
                    next_step = lastStep ,gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_open"), http_request_method.GET, {city = game_data:getSelCityId()},"private_city_open")
    elseif self.m_openType == "active_map_building_detail_scene" then
        local activeChapterId = game_data:getSelActiveDataByKey("activeChapterId")
        local activeId = game_data:getSelActiveDataByKey("activeId");
        local nextStep = game_data:getSelActiveDataByKey("nextStep");
        game_scene:enterGameUi("active_map_building_detail_scene",{activeChapterId = activeChapterId,activeId = activeId,next_step = nextStep});
    elseif self.m_openType == "game_world_boss" then
        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            local boss_info = data:getNodeWithKey("boss_info");

            if boss_info:getNodeCount() == 0 then
                game_scene:enterGameUi("game_main_scene",{gameData = nil, openPop = "game_activity_new_pop"},{endCallFunc = function (  )
                    game_util:addMoveTips({text = "Hoạt động BOSS thế giới đã kết thúc!"});
                    self:destroy()
                end});
            else
                game_scene:enterGameUi("game_world_boss",{gameData = gameData})
                self:destroy()
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_boss_index"), http_request_method.GET, nil,"world_boss_index")
    elseif self.m_openType == "game_guild_boss" then
        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            local boss_info = data:getNodeWithKey("boss_info");
            if boss_info:getNodeCount() == 0 then
                --活动结束，回到公会
                game_scene:setVisibleBroadcastNode(false);
                local association_id = game_data:getUserStatusDataByKey("association_id");
                if association_id == 0 then
                    require("like_oo.oo_controlBase"):openView("guild_join");
                else
                    require("like_oo.oo_controlBase"):openView("guild");
                end
            else
                local function callBackFunc()
                    self:destroy();
                    static_rootControl = nil;
                end
                game_scene:enterGameUi("game_guild_boss",{gameData = gameData})
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("guildboss_index"), http_request_method.GET, nil,"guildboss_index")
    elseif self.m_openType == "game_neutral_city_map" then
        local city_id = game_data:getSelNeutralCityId();
        local function responseMethod(tag,gameData)
            game_data:setSelNeutralCityDataByJsonData(gameData:getNodeWithKey("data"));
            game_scene:enterGameUi("game_neutral_city_map",{gameData = gameData,city_id = city_id});
            self:destroy();
        end
        -- 公共地图，打开城市 city_id=10001
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_city_open"), http_request_method.GET, {city_id = city_id},"public_city_open")
    elseif self.m_openType == "equip_strengthen" then
        -- cclog("self.select_temp_id = " .. self.select_temp_id)
        game_scene:enterGameUi("equipment_strengthen",{selEquipId = self.select_temp_id});
        self:destroy();
    elseif self.m_openType == "equip_evolution" then
        game_scene:enterGameUi("equip_evolution",{selEquipId = self.select_temp_id});
        self:destroy();
    elseif self.m_openType == "game_live" then
        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            local live_data = json.decode(data:getNodeWithKey("active_forever"):getFormatBuffer())
            game_scene:enterGameUi("game_activity_live",{liveData = live_data})
            self:destroy()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_index"), http_request_method.GET, nil,"active_index")
    elseif self.m_openType == "game_pirate_precious" then--罗杰的宝藏
        game_scene:enterGameUi("game_pirate_precious",{})
        self:destroy();
    elseif self.m_openType == "game_topplayer_scene" then
        -- 最牛玩家
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_topplayer_scene",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("playerboss_index"), http_request_method.GET, {},"playerboss_index")
    elseif self.m_openType == "map_world_scene" then
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("map_world_scene",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_world_map"), http_request_method.GET, nil,"private_city_world_map")
    elseif self.m_openType == "gvg" then--gvg
        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            local sort = data:getNodeWithKey("sort"):toInt()
            if sort == 1 then--外围战布阵开启
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = 1});
            elseif sort == 2 then--外围战战争开始
                game_scene:enterGameUi("game_gvg_war_half",{gameData = gameData,sort = 2});
            elseif sort == 3 then--内城布阵开始
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = 3});
            elseif sort == 4 then--内城战开始
                game_scene:enterGameUi("game_gvg_war_half",{gameData = gameData,sort = 4});
            elseif sort == 5 then
                
            elseif sort == -1 then--公会战未开启
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = -1});
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("guild_gvg_index"), http_request_method.GET, nil,"guild_gvg_index")
    elseif self.m_openType == "gem_strengthen" then--升级
        -- cclog("self.select_temp_id = " .. self.select_temp_id)
        game_scene:enterGameUi("gem_system_strengthen_scene",{selGemId = self.select_temp_id});
        self:destroy();
    elseif self.m_openType == "gem_synthesis" then--合成
        game_scene:enterGameUi("gem_system_synthesis",{selGemId = self.select_temp_id});
        self:destroy();
    elseif self.m_openType == "open_door_main_scene" then
        game_scene:enterGameUi("open_door_main_scene",{});
    elseif self.m_openType == "cloister" then
        local function responseMethod(tag,gameData)
            -- game_scene:enterGameUi("open_door_cloister",{gameData = gameData});
            local m_tGameData = nil
            if gameData ~= nil and tolua.type(gameData) == "util_json" then
                local data = gameData:getNodeWithKey("data");
                m_tGameData = json.decode(data:getFormatBuffer()) or {};
            else
                m_tGameData = {};
            end
            game_scene:enterGameUi("open_door_cloister_detail",{gameData = m_tGameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("maze_index"), http_request_method.GET, nil,"maze_index")
    elseif self.m_openType == "game_team_boss_fight" then --组队boss
        local function responseMethod(tag,gameData)
            if gameData then
                local data = gameData:getNodeWithKey("data")
                local rank_result = data:getNodeWithKey("rank_result")
                local team_boss_all_team = data:getNodeWithKey("team_boss_all_team")
                local team_boss_sec_battle = data:getNodeWithKey("team_boss_sec_battle")
                local team_boss_thd_battle = data:getNodeWithKey("team_boss_thd_battle")
                if rank_result then--进入捐献界面
                    game_scene:enterGameUi("game_team_boss_donate",{gameData = gameData})   
                elseif team_boss_all_team then--进入创建队伍界面
                    --再分进入创建队伍，还是直接进入队伍信息
                    local team_id = data:getNodeWithKey("team_id")
                    team_id = (team_id and team_id:toStr()) or ""
                    --遍历是否有队伍
                    if team_id == "" then
                        game_scene:enterGameUi("game_team_boss_create",{gameData = gameData})
                    else
                        local team_boss_all_teamJson = json.decode(team_boss_all_team:getFormatBuffer()) or {};
                        --直接进入队伍
                        local teamInfo = team_boss_all_teamJson[team_id]
                        -- game_scene:enterGameUi("game_team_boss_info",{teamInfo = teamInfo,openType = 1})
                        self.teamInfoData = teamInfo
                        self:refreshUi()
                    end
                elseif team_boss_sec_battle then
                    game_scene:enterGameUi("game_team_boss_fight",{gameData = gameData,stage = 2})
                elseif team_boss_thd_battle then
                    game_scene:enterGameUi("game_team_boss_fight",{gameData = gameData,stage = 3})
                else        
                    game_scene:enterGameUi("game_main_scene",{gameData = nil,  openPop = nil});
                    local msg = data:getNodeWithKey("msg")
                    msg = msg and msg:toStr() or "Đang chia nhóm, xin đợi!"--正在分组，请稍后！
                    self:destroy();
                    game_util:addMoveTips({text = msg})
                end
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("team_boss_index"), http_request_method.GET, nil,"team_boss_index",true,true)
    elseif self.m_openType == "game_team_pk_map" then--组队PK
        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            local stage = data:getNodeWithKey("stage"):toInt()
            if stage == 3 then--手动选择路线时间
                game_scene:enterGameUi("game_team_pk_map_prepare",{gameData = gameData});
            elseif stage == 4 then--自动战斗时间
                game_scene:enterGameUi("game_team_pk_map",{gameData = gameData});
            else
                game_scene:setVisibleBroadcastNode(false);
                local association_id = game_data:getUserStatusDataByKey("association_id");
                if association_id == 0 then
                    require("like_oo.oo_controlBase"):openView("guild_join");
                else
                    require("like_oo.oo_controlBase"):openView("guild");
                end
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("team_pk_new_index"), http_request_method.GET, nil,"team_pk_new_index")
    elseif self.m_openType == "magic_evolution" then
        self:destroy()
        game_scene:enterGameUi("game_magic_evolution",{gameData = nil,openType = "game_function_pop"});
    elseif self.m_openType == "gem_advanced" then
        game_scene:enterGameUi("game_gem_advanced",{})
    -- elseif self.m_openType == "fategem" then 
    --     game_data:resetNewItemIdTab();
    --     local function endCallFunc()
    --         self:destroy();
    --     end
    --     game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
    else
        local function endCallFunc()
            self:destroy();
        end
        cclog("123123123")
        game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
    end
end

function game_adjustment_formation.sendChangedData(self,btnTag,t_params,flag)
        local function tempFunction()
            if btnTag == 1 then--返回
                self:back();
            elseif btnTag == 5071 then
                game_scene:enterGameUi("game_badge_advanced", {gameData = nil})
            elseif btnTag == 62 then

                game_scene:addPop("game_formationBonusMain_pop")
            elseif btnTag == 100 then
                game_scene:enterGameUi("skills_replacement_scene",{gameData = nil,selPosIndex = t_params.posIndex});
                self:destroy();
            end
        end
        if self.m_changeFlag == true or self.m_selFormationId ~= self.m_currentFormationId or flag==true then
            local function responseMethod(tag,gameData)
                if gameData ~= nil then
                    local data = gameData:getNodeWithKey("data");
                    game_data:setTeamByJsonData(data:getNodeWithKey("alignment"));
                    game_data:setFormationDataByJsonData(data:getNodeWithKey("formation"));
                    game_data:setEquipPosDataByJsonData(data:getNodeWithKey("equip_pos"));
                    game_data:setAssistantByJsonData(data:getNodeWithKey("assistant"));
                    game_data:setGemPosDataByJsonData(data:getNodeWithKey("gem_pos"));
                    game_data:setSaintStonePosDataByJsonData(data:getNodeWithKey("god_stone_pos"));
                    game_data:setMedalPosDataByJsonData(data:getNodeWithKey("medal_pos"));
                    game_data:setSoulPosDataByJsonData(data:getNodeWithKey("soul_pos"));
                    game_data:setMagicPosDataByJsonData(data:getNodeWithKey("magic_pos"));
                    local medal_pos = data:getNodeWithKey("medal_pos")
                    -- cclog2(medal_pos,"medal_pos")
                    self.m_changeFlag = false;
                    tempFunction();
                else
                    game_util:addMoveTips({text = "Đọc dữ liệu thất bại, xin thao tác lại! "});--数据请求失败，请重新操作！
                end
            end
            -- align_1=1_2&align_2=3_4
            local teamTable = game_data:getTeamData();
            local prarms = "align_1=";
            for k = 1,5 do
                if teamTable[k] == nil then
                    prarms = prarms .. "-1" .. (k == 5 and "" or "_")
                else
                    prarms = prarms .. teamTable[k] .. (k == 5 and "" or "_")
                end
            end
            prarms = prarms .. "&align_2="
            for k = 6,10 do
                if teamTable[k] == nil then
                    prarms = prarms .. "-1" .. (k == 10 and "" or "_") 
                else
                    prarms = prarms .. teamTable[k] .. (k == 10 and "" or "_") 
                end
            end 
            local equipPosData = game_data:getEquipPosData();
            for i=1,10 do
                -- cclog(" i ================= " .. i)
                -- table.foreach(equipPosData[tostring(i-1)],print)
                if i < 6 then
                    prarms = prarms .. "&equip_1" .. i .. "="
                else
                    prarms = prarms .. "&equip_2" .. (i-5) .. "="
                end
                for k,v in pairs(equipPosData[tostring(i-1)]) do
                    prarms = prarms .. v .. (k == 4 and "" or "_")
                end
            end
            local magicPosData = game_data:getMagicPosData();
            for i=1,10 do
                -- cclog(" i ================= " .. i)
                -- table.foreach(equipPosData[tostring(i-1)],print)
                if i < 6 then
                    prarms = prarms .. "&talisman_1" .. i .. "="
                else
                    prarms = prarms .. "&talisman_2" .. (i-5) .. "="
                end
                if magicPosData and  magicPosData[tostring(i-1)] then
                    for k,v in pairs(magicPosData[tostring(i-1)]) do
                        prarms = prarms .. v .. (k == 4 and "" or "_")
                    end
                else
                    for k=1,4 do
                        prarms = prarms .. "0" .. (k == 4 and "" or "_")
                    end
                end
            end
            local magicAssPosData = game_data:getAssMagicPosData();
            for i=1,10 do
                prarms = prarms .. "&ass_talisman_" .. i .. "="
                if magicAssPosData and  magicAssPosData[tostring(i+99)] then
                    for k,v in pairs(magicAssPosData[tostring(i+99) or {}]) do
                        prarms = prarms .. v .. (k == 4 and "" or "_")
                    end
                else
                    for k=1,4 do
                        prarms = prarms .. "0" .. (k == 4 and "" or "_")
                    end
                end
            end
            local equipPosData = game_data:getAssEquipPosData();
            for i=1,10 do
                prarms = prarms .. "&ass_equip_" .. i .. "="
                for k,v in pairs(equipPosData[tostring(i+99) or {}]) do
                    prarms = prarms .. v .. (k == 4 and "" or "_")
                end
            end
            prarms = prarms .. "&assistant=";
            for i=1,9 do
                prarms = prarms .. tostring(self.m_tempFriendData[i]);
                if(i<9)then
                    prarms = prarms .. "_";
                end
            end
            prarms = prarms .. "&destiny=";
            for i=1,9 do
                prarms = prarms .. tostring(self.m_tempDestinyData[i]);
                if(i<9)then
                    prarms = prarms .. "_";
                end
            end
            local gemPosData = game_data:getGemPosData();
            for i=1,10 do
                -- cclog(" i ================= " .. i)
                -- table.foreach(gemPosData[tostring(i-1)],print)
                if i < 6 then
                    prarms = prarms .. "&gem_1" .. i .. "="
                else
                    prarms = prarms .. "&gem_2" .. (i-5) .. "="
                end
                for k,v in pairs(gemPosData[tostring(i-1)] or {}) do
                    prarms = prarms .. v .. (k == 4 and "" or "_")
                end
            end

            --圣石
             local saintStonePosData = game_data:getSaintStonePosData();
            for i=1,10 do
                -- cclog(" i ================= " .. i)
                -- table.foreach(gemPosData[tostring(i-1)],print)
                if i < 6 then
                    prarms = prarms .. "&god_stone_1" .. i .. "="
                else
                    prarms = prarms .. "&god_stone_2" .. (i-5) .. "="
                end
                for k,v in pairs(saintStonePosData[tostring(i-1)] or {}) do
                    prarms = prarms .. v .. (k == 5 and "" or "_")
                end
            end
            
            --这里再加勋章的东西
            local medalPosData = game_data:getMedalPos()
            for i=1,10 do
                if i < 6 then
                    prarms = prarms .. "&medal_1" .. i .. "="
                else
                    prarms = prarms .. "&medal_2" .. (i - 5) .. "="
                end
                for k,v in pairs(medalPosData[tostring(i-1)] or {}) do
                    prarms = prarms .. v .. (k == 6 and "" or "_")
                end
            end
            --这里再加英魂的东西
            local soulPosData = game_data:getSoulPos()
            -- cclog2(soulPosData,"soulPosData")
            for i=1,10 do
                if i < 6 then
                    prarms = prarms .. "&soul_1" .. i .. "="
                else
                    prarms = prarms .. "&soul_2" .. (i - 5) .. "="
                end
                for k,v in pairs(soulPosData[tostring(i-1)] or {}) do
                    prarms = prarms .. v .. (k == 6 and "" or "_")
                end
            end
            prarms = prarms .. "&formation=" .. self.m_selFormationId;
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_set_alignment"), http_request_method.POST, prarms,"cards_set_alignment")
        else
            tempFunction();
        end
end

--[[--
    读取ccbi创建ui
]]
function game_adjustment_formation.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        -- cclog2(btnTag, "game_adjustment_formation.createUi onMainBtnClick btnTag  ===  ")
        if btnTag == 1 then
            -- cclog2(game_data:getGuideProcess(), "game_data:getGuideProcess()  ===   ")
            if game_data.getGuideProcess and game_data:getGuideProcess() == "second_enter_main_scene" then
                if game_util.statisticsSendUserStep then game_util:statisticsSendUserStep(38) end -- 第一次点击阵型 步骤35
                if game_data.setGuideProcess then game_data:setGuideProcess("third_enter_main_scene") end
            end
            local id = game_guide_controller:getCurrentId();
            if id == 21 then
                game_guide_controller:gameGuide("send","1",22);
            elseif id == 34 then
                if game_util.statisticsSendUserStep then game_util:statisticsSendUserStep(51) end -- 新手引导34步 步骤51
                if game_data.setGuideProcess then game_data:setGuideProcess("") end
                game_guide_controller:gameGuide("send","2",34);
            end
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
                game_scene:addPop("game_hero_attr_pop",{selHeroId = heroData.id,posNode=tagNode,attrType = btnTag-20})
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
                game_scene:addPop("game_hero_info_pop",{tGameData = heroData,openType = 1,callBack = callBack})
            end
        elseif btnTag == 31 then--一件装备
            self:autoMatchEquip(self.m_posIndex)
            self:refreshHeroInfo(self.m_posIndex);
            --self:refreshCombatLabel();
        elseif btnTag == 32 then--助威小伙伴激活
            if self.m_posIndex < 0 then
                game_util:addMoveTips({text = "Xin chọn vị trí xong rồi kích hoạt! "});--请选择位置之后在激活！
                return
            end
            local function okBtnCallBack()
                local function responseMethod(tag,gameData)
                    game_util:addMoveTips({text = "Kích hoạt thành công! "});--成功激活！
                    -- local destinyData = game_data:getDestiny();
                    -- local tempData = util.table_copy(self.m_tempDestinyData)
                    -- self.m_tempDestinyData = destinyData
                    -- for k,v in pairs(tempData) do
                    --     if v ~= "-1" then
                    --         self.m_tempDestinyData[k] = v;
                    --     end
                    -- end
                    -- self:initDestinyFormation(self.m_formation_layer);
                    self:initFriendFormation(self.m_formation_layer);
                    self:refreshHeroInfo(self.m_posIndex);
                    game_scene:removePopByName("game_assistant_activation_pop");
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_activate_assistant_effect"), http_request_method.GET, {position = self.m_posIndex-1},"cards_activate_assistant_effect")
            end
            game_scene:addPop("game_assistant_activation_pop",{index = self.m_posIndex, okBtnCallBack = okBtnCallBack})
        elseif btnTag == 33 then--属性刷新
            local function callBackFunc()
                self:refreshHeroInfo(self.m_posIndex);
                self:refreshCombatLabel("createUi 33");
            end
            game_scene:addPop("adjustment_refresh_pop",{posIndex = self.m_posIndex,callBackFunc = callBackFunc})
        elseif btnTag == 41 then
            -- 点击阵型tab按钮
            self:initTeam();

            -- if zcAnimNode.removeAllUnusing then
            --     zcAnimNode:removeAllUnusing();
            --     CCTextureCache:sharedTextureCache():removeUnusedTextures();
            -- end
        elseif btnTag == 42 then--助威
            game_scene:removeGuidePop();
            self:gameGuide("drama","65",6501)
            self:initFriend();

            self.m_medal_btn:setVisible(false)
            self.m_soul_btn:setVisible(false)
            self.m_saint_stone_btn:setVisible(false)
            self.m_sp_btn_back:setVisible(false)
            self.m_showMore_flag=false
            self.m_btn_show_more:setVisible(false)

            -- if zcAnimNode.removeAllUnusing then
            --     zcAnimNode:removeAllUnusing();
            --     CCTextureCache:sharedTextureCache():removeUnusedTextures();
            -- end
        elseif btnTag == 43 then--命运
            -- 点击小伙伴tab按钮
            self:initDestinyTeam();
            -- if zcAnimNode.removeAllUnusing then
            --     zcAnimNode:removeAllUnusing();
            --     CCTextureCache:sharedTextureCache():removeUnusedTextures();
            -- end
        elseif btnTag == 51 or btnTag == 52 then--命运摘要  命运详情
            self:refreshFateTabBtn(btnTag - 50);
        elseif btnTag==110 then  --命运联协刷新
                if self.m_selHeroId then
                    local cardData,heroCfg=game_data:getCardDataById(self.m_selHeroId)
                    local chain=json.decode(heroCfg:getNodeWithKey("chain"):getFormatBuffer())
                    if chain and next(chain)  then
                        local function callBackFunc()
                            self:refreshHeroInfo(self.m_posIndex);
                            self:refreshCombatLabel("createUi 33");
                        end
                        game_scene:addPop("game_fate_refresh_pop",{id=self.m_selHeroId,callBackFunc = callBackFunc})
                    else
                        game_util:addMoveTips({text="当前卡牌无命运属性"})
                    end
                end

        elseif btnTag == 61 then--说明 149
            game_scene:addPop("game_active_limit_detail_pop",{enterType = "149"})
        elseif btnTag == 62 then
            self:sendChangedData(btnTag)

        elseif btnTag ==998 then --下拉菜单
            if self.m_showMore_flag==true then
                self.m_medal_btn:setVisible(false)
                self.m_soul_btn:setVisible(false)
                self.m_saint_stone_btn:setVisible(false)
                 self.m_sp_btn_back:setVisible(false)
                self.m_showMore_flag=false
            else
                self.m_medal_btn:setVisible(game_data:isViewShowByID(161))
                self.m_soul_btn:setVisible(game_data:isViewShowByID(166))
                self.m_saint_stone_btn:setVisible(game_data:isViewShowByID(197))
                self.m_sp_btn_back:setVisible(true)
                self.m_showMore_flag=true


                local i=0;
                local btn_tab={}
                if game_data:isViewShowByID(197) then
                    i=i+1;
                    btn_tab[i]=self.m_saint_stone_btn
                end
                 if game_data:isViewShowByID(166)  then
                    i=i+1;
                    btn_tab[i]= self.m_soul_btn
                end
                if game_data:isViewShowByID(161) then
                    i=i+1;
                    btn_tab[i]= self.m_medal_btn
                end
               
             
                if i~=0 then
                    for j=1,#btn_tab do
                        local pX,pY=self.btn_node[j]:getPosition()
                        btn_tab[j]:setPosition(ccp(pX,pY))
                    end
                    local x,y=self.m_node_sp_pos:getPosition()
                    self.m_sp_btn_back:setPosition(ccp(x,y))
                    self.m_sp_btn_back:setPreferredSize(CCSizeMake(55*i,40))

                else
                    self.m_sp_btn_back:setVisible(false)

                end
                if i==1 then
                    local x,y=self.btn_node[2]:getPosition()
                    btn_tab[1]:setPosition(ccp(x,y))
                    local x,y=self.m_node_sp_pos2:getPosition()
                    self.m_sp_btn_back:setPosition(ccp(x,y))
                end

            end


        elseif btnTag == 999 then--勋章
            -- cclog2(game_data:getTeamData(),"getTeamData")
            -- cclog2(self.m_posIndex,"self.m_posIndex")
            local heroData,heroCfg = self:getTeamCardDataByPos(self.m_posIndex);
            game_scene:enterGameUi("game_medal_scene",{heroId = heroData.id,posIndex = self.m_posIndex,formationId = self.m_selFormationId,changeFlag = self.m_changeFlag})
        elseif btnTag == 9991 then--英魂
            --应该把change_flag传入下一个界面
            local heroData,heroCfg = self:getTeamCardDataByPos(self.m_posIndex);
            game_scene:enterGameUi("game_append_soul",{heroId = heroData.id,posIndex = self.m_posIndex,formationId = self.m_selFormationId,changeFlag = self.m_changeFlag})
        elseif btnTag==9992 then --圣石
            self:sendChangedData(btnTag,nil,true)
            game_scene:enterGameUi("ui_saint_stone_main",{gameData = nil,selectedId=self.m_selHeroId,posIndex=self.m_posIndex,changeFlag = self.m_changeFlag,formationId = self.m_selFormationId})
        elseif btnTag == 504 then
                self.m_fate_detail_node:setVisible(false);
                self.m_magic_layer:setVisible(game_data:isViewShowByID(201))
                self.m_magic_layer:setTouchEnabled(game_data:isViewShowByID(201))
                self.m_eq_layer:setVisible(true)
                self.m_eq_layer:setTouchEnabled(true)
                self.node_bloodDetal:setVisible(false)
                self.nd_badge:setVisible(false)

                -- if self.m_sel
                if self.m_teamGemOpenFlag then
                    if self.m_teamIndex == 1 then
                        self.m_gem_layer:setVisible(true)
                        self.m_gem_layer:setTouchEnabled(true)
                    end
                end
                if self.m_teamIndex == 2 then
                    self.m_activation_node:setVisible(true);
                end
                
        elseif btnTag == 505 then -- 法宝
                self.m_fate_detail_node:setVisible(true);
                self.m_fate_detail_node:setPosition(self.m_fate_node3:getPosition())
                self.m_magic_layer:setVisible(false)
                self.m_magic_layer:setTouchEnabled(false)
                self.m_eq_layer:setVisible(false)
                self.m_eq_layer:setTouchEnabled(false)
                self.m_gem_layer:setVisible(false)
                self.m_gem_layer:setTouchEnabled(false)
                self.node_bloodDetal:setVisible(false)
                self.nd_badge:setVisible(false)

                if self.m_teamIndex == 2 then
                    self.m_activation_node:setVisible(false);
                end
        elseif btnTag == 506 then -- 血石
            self.m_fate_detail_node:setVisible(false);
            self.m_magic_layer:setVisible(false)
            self.m_magic_layer:setTouchEnabled(false)
            self.m_eq_layer:setVisible(false)
            self.m_eq_layer:setTouchEnabled(false)
            self.m_gem_layer:setVisible(false)
            self.m_gem_layer:setTouchEnabled(false)
            self.nd_badge:setVisible(false)

            if self.m_teamIndex == 2 then
                self.m_activation_node:setVisible(false);
            end

            self.node_bloodDetal:setVisible(true)
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

        elseif btnTag == 5061 then -- 打开赋能界面
            game_scene:enterGameUi("game_bloodStone_index",{})
            self:destroy();
        end

    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_adjustment_formation.ccbi");

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
    self.m_sel_bg = ccbNode:spriteForName("m_sel_bg")
    self.m_sel_bg:setVisible(false);
    self.m_fate_node = ccbNode:nodeForName("m_fate_node")
    self.m_fate_detail_node = ccbNode:nodeForName("m_fate_detail_node")
    self.nd_badge = ccbNode:nodeForName("nd_badge")
    self.nd_badge:setVisible(false)
    self.m_replace_equip_btn = ccbNode:controlButtonForName("m_replace_equip_btn")
    -- local labelsize = self.m_fate_node:getContentSize();
    -- self.m_fate_label = game_util:createRichLabelTTF({text = "",dimensions = labelsize,textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = nil,color = ccc3(221,221,192)})
    -- self.m_fate_label:setAnchorPoint(ccp(0, 0.25));
    -- self.m_fate_node:addChild(self.m_fate_label,-1,-1)
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
    self.m_combat_label:setVisible(false);
    local pX,pY = self.m_combat_label:getPosition();
    -- self.m_combatNumberChangeNode = game_util:createExtNumberChangeNode({labelType = 2});
    self.m_combatNumberChangeNode = CCLabelBMFont:create("","yellow_image_text.fnt")
    self.m_combatNumberChangeNode:setPosition(ccp(pX, pY));
    self.m_combatNumberChangeNode:setAnchorPoint(ccp(0, 0.5));
    self.m_combat_label:getParent():addChild(self.m_combatNumberChangeNode);
    -- self.m_combatNumberChangeNode:setCurValue(0,false);

    self.m_back_btn = ccbNode:controlButtonForName("m_back_btn")
    local id = game_guide_controller:getCurrentId();
    if id == 50 and self.m_guildNode == nil then
        self.m_guildNode = self.m_back_btn;
    end

    self.btn_badge = ccbNode:controlButtonForName("btn_badge");
    self.m_tab_btn_1 = ccbNode:controlButtonForName("m_tab_btn_1");
    self.m_tab_btn_2 = ccbNode:controlButtonForName("m_tab_btn_2");
    self.m_tab_btn_3 = ccbNode:controlButtonForName("m_tab_btn_3");
    self.m_replace_btn = ccbNode:controlButtonForName("m_replace_btn");
    self.m_btn_fate_refresh=ccbNode:controlButtonForName("btn_fate_refresh")
    self.m_adjust1 = ccbNode:nodeForName("m_adjust1");
    self.m_adjust2 = ccbNode:nodeForName("m_adjust2");
    self.m_scrollView = ccbNode:scrollViewForName("m_scrollView");
    self.m_title_node = ccbNode:nodeForName("m_title_node");
    self.m_fate_list_view_bg = ccbNode:nodeForName("m_fate_list_view_bg")
    self.m_tab_btn_1:setEnabled(false);
    self.m_tab_btn_2:setEnabled(true);
    self.m_tab_btn_3:setEnabled(true);

    self.m_adjust1:setVisible(true);
    self.m_adjust2:setVisible(false);
    local m_toBonus_btn = ccbNode:controlButtonForName("m_toBonus_btn")
    m_toBonus_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-1)
    m_toBonus_btn:setVisible(game_data:isViewShowByID(185))
    self.m_ccbNode = ccbNode;

    if not self.m_teamGemOpenFlag then 
        self.m_gem_layer:setVisible(false)
    end
    self:refreshFateTabBtn(1);

    self.m_medal_btn = ccbNode:controlButtonForName("m_medal_btn")
    self.m_medal_btn:setVisible(false)
    --self.m_medal_btn:setVisible(game_data:isViewShowByID(161))

    self.m_soul_btn = ccbNode:controlButtonForName("m_soul_btn")
    self.m_soul_btn:setVisible(false)
    --self.m_soul_btn:setVisible(game_data:isViewShowByID(166))

    self.m_saint_stone_btn=ccbNode:controlButtonForName("btn_saint_stone")
    self.m_saint_stone_btn:setVisible(false)

    self.m_node_sp_pos=ccbNode:nodeForName("node_sp_pos")
    self.m_node_sp_pos2=ccbNode:nodeForName("node_sp_pos2")
    self.m_sp_btn_back=ccbNode:scale9SpriteForName("sp_btn_back")
    self.m_sp_btn_back:setVisible(false)
    self.m_sp_btn_back:setAnchorPoint(ccp(1,1))

    self.m_btn_show_more=ccbNode:controlButtonForName("btn_show_more")

    self.m_btn_fate_refresh:setVisible(game_data:isViewShowByID(196))

    self.btn_node={}
    for i=1,3 do 
        self.btn_node[i]=ccbNode:nodeForName("btn_node"..i)
    end
   
    self.m_magic_btn = ccbNode:controlButtonForName("m_magic_btn")

    self.m_weam_btn = ccbNode:controlButtonForName("m_weam_btn")
    self.m_magic_node = ccbNode:controlButtonForName("m_magic_btnnode")
    self.m_magic_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-1)
    -- self.m_magic_btn:setVisible(game_data:isViewOpenByID(201))
    self.m_magic_btn = ccbNode:controlButtonForName("m_magic_btn")

    self.m_weam_btn = ccbNode:controlButtonForName("m_weam_btn")
    self.m_weam_node = ccbNode:controlButtonForName("m_weam_btnnode")
    self.m_weam_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-1)
    self.m_magic_layer = ccbNode:layerForName("m_magic_layer")
    self.node_bloodDetal = ccbNode:nodeForName("node_bloodDetal")
    self.node_bloodDetal:setVisible(false)
    self.m_eq_layer = ccbNode:layerForName("m_eq_layer")
    self.m_magic_layer:setVisible(game_data:isViewShowByID(201))
    self.m_eq_layer:setVisible(true)
    self.m_fate_node1 = ccbNode:nodeForName("fate_node1")
    self.m_fate_node2 = ccbNode:nodeForName("fate_node2")
    self.m_fate_node3 = ccbNode:nodeForName("fate_node3")
    self.m_fate_node4 = ccbNode:nodeForName("fate_node4")
    self.m_fate_node5 = ccbNode:nodeForName("fate_node5")

    self:createAnim()

    return ccbNode;
end

function game_adjustment_formation:createAnim()
    self.m_weam_node:removeAllChildrenWithCleanup(true)
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
function game_adjustment_formation.getTeamCardDataByPos(self,posIndex)
    return game_data:getCardDataById(self.m_tempTeamData[posIndex])
end

--[[--
    创建动画
]]
function game_adjustment_formation.createCardAnimByPosIndex(self,posIndex)
    local heroData,heroCfg = self:getTeamCardDataByPos(posIndex)
    return self:createCardAnimByData(heroData,heroCfg);
end

--[[
    获取小伙伴位置上的动画
]]
function game_adjustment_formation.createCardAnimByData( self, heroData,heroCfg,animFlag)
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
            -- animNode:setScale(0.7);
            local name_after = heroData.step < 1 and "" or ("+" .. heroData.step);
            local tempLabel = CCLabelTTF:create("Lv." .. heroData.lv .. "/" .. heroData.level_max .. "\n" .. name_after,TYPE_FACE_TABLE.Arial_BoldMT,10);
            tempLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
            tempLabel:setPosition(ccp(itemSize.width*0.5 - 50,97));
            tempLabel:setAnchorPoint(ccp(0,0.5));
            animNode:addChild(tempLabel,100,100)
            -- local tempLabel = CCLabelTTF:create(heroCfg:getNodeWithKey("name"):toStr(),TYPE_FACE_TABLE.Arial_BoldMT,10);
            -- tempLabel:setPosition(ccp(itemSize.width*0.5 + 50,95));
            -- tempLabel:setAnchorPoint(ccp(1,0.5));
            -- animNode:addChild(tempLabel,100,100)
            -- game_util:setHeroNameColorByQuality(tempLabel,heroCfg);
            local occupation_cfg = getConfig(game_config_field.occupation);
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
function game_adjustment_formation.initTeamFormation(self,formation_layer)
    self.m_tempSelIndex = -1
    local level = game_data:getUserStatusDataByKey("level");
    local itemIcon = nil;
    local headIconSpr = nil;
    local tempLock = nil;
    local character_detail_cfg = getConfig("character_detail");
    local tempLockIndex,selLevel = -1,100;
    local tempTxt = nil;
    local tempGuildNode = nil;
    local id = game_guide_controller:getCurrentId();
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
                -- if selLevel > openLevel then
                --     selLevel = openLevel;
                --     tempLockIndex = i;
                --     -- cclog("selLevel ==== " .. selLevel .. " ; tempLockIndex === " .. tempLockIndex)
                -- end
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
            if id == 30 then
                self.m_guide_step = 30
                if self.m_guildNode == nil and character_ID == 53 then
                    self.m_guildNode = itemIcon;
                end
                if tempGuildNode == nil then
                    tempGuildNode = itemIcon;
                end
            end
            if self.m_tempSelIndex == -1 then
                self.m_tempSelIndex = i;
            end
        else
            if id == 19 and self.m_guildNode == nil and self.m_openTab[i] == 1 then
                self.m_guildNode = itemIcon;
            end
            self:setPositionBg(i,false);
        end
    end
    if id == 30 and self.m_guildNode == nil then
        self.m_guildNode = tempGuildNode;
    end
    -- if tempLockIndex ~= -1 then
    --     local itemIcon = self.m_ccbNode:spriteForName("m_pos_" .. tempLockIndex)
    --     local headIconSpr = CCSprite:createWithSpriteFrameName(tostring(TEAM_LOCK_TIPS_TAB[tempLockIndex].lockImg));
    --     if headIconSpr then
    --         local headIconBgSize = itemIcon:getContentSize();
    --         headIconSpr:setPosition(ccp(headIconBgSize.width*0.5, headIconBgSize.height*0.5))
    --         itemIcon:addChild(headIconSpr,2,2)
    --     end
    -- end
    self:formationOpenAnim();

    self:initAdjustmentFormationTouch(self.m_formation_layer);

    self:initEquipLayerTouch(self.m_eq_layer);
    self.m_eq_layer:setTouchEnabled(true)
    self:initMagicLayerTouch(self.m_magic_layer)
    self.m_magic_layer:setTouchEnabled(true)


    -- if self.m_eq_layer:isVisible() then
    --     self.m_eq_layer:setTouchEnabled(true)
    --     self.m_magic_layer:setTouchEnabled(false)
    -- else
    --     self.m_eq_layer:setTouchEnabled(false)
    --     self.m_magic_layer:setTouchEnabled(true)
    -- end
    if not self.m_teamGemOpenFlag then 
        self.m_gem_layer:setVisible(false)
    end
end


function game_adjustment_formation.createFormationOpenAnimByPos(self,pos)
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

function game_adjustment_formation.formationOpenAnim(self)
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

function game_adjustment_formation.getExchangeTeamDataByTwoPosFlag(self,posIndex1,posIndex2)
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
    -- cclog("posIndex1 = " .. posIndex1 .. " ; posIndex2 = " .. posIndex2)
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

function game_adjustment_formation.getUnloadPosFlag(self,posIndex)
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

function game_adjustment_formation.updateTeamData(self,posIndex,cardId)
    self.m_tempTeamData[posIndex] = cardId;
    self:setTeamFormationData();
end

function game_adjustment_formation.exchangeTeamDataByTwoPos(self,posIndex1,posIndex2)
    self.m_tempTeamData[posIndex1],self.m_tempTeamData[posIndex2] = self.m_tempTeamData[posIndex2],self.m_tempTeamData[posIndex1]
    self.m_tempEquipPosData[posIndex1],self.m_tempEquipPosData[posIndex2] = self.m_tempEquipPosData[posIndex2],self.m_tempEquipPosData[posIndex1]
    self.m_tempGemPosData[posIndex1],self.m_tempGemPosData[posIndex2] = self.m_tempGemPosData[posIndex2],self.m_tempGemPosData[posIndex1]
    self.m_tempMedalPosData[posIndex1],self.m_tempMedalPosData[posIndex2] = self.m_tempMedalPosData[posIndex2],self.m_tempMedalPosData[posIndex1]
    self.m_tempSoulPosData[posIndex1],self.m_tempSoulPosData[posIndex2] = self.m_tempSoulPosData[posIndex2],self.m_tempSoulPosData[posIndex1]
    self.m_tempSaintStonePosData[posIndex1],self.m_tempSaintStonePosData[posIndex2] = self.m_tempSaintStonePosData[posIndex2],self.m_tempSaintStonePosData[posIndex1]
    self.m_tempMagicPosData[posIndex1],self.m_tempMagicPosData[posIndex2] = self.m_tempMagicPosData[posIndex2],self.m_tempMagicPosData[posIndex1]
    -- table.foreach(self.m_tempTeamData,print)
    -- for k,v in pairs(self.m_tempEquipPosData) do
    --     table.foreach(v,print)
    -- end
    self:setTeamFormationData();
end

--[[--
    编队位置点击的处理
]]
function game_adjustment_formation.initAdjustmentFormationTouch(self,formation_layer)
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
                        local tempBonusData = game_util:getAllBonusCombat(self.m_tempTeamData)
                        game_data:setRightTeamData(self.m_tempTeamData)
                        -- self:refreshCombatLabel(_,tempBonusData)
                        self:refreshCombatLabel("initAdjustmentFormationTouch",tempBonusData);
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
function game_adjustment_formation.setPositionBg(self,posIndex,aninFlag)
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
function game_adjustment_formation.setPositionBg2(self,posIndex)
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
function game_adjustment_formation.setSelPositionBg(self,posIndex)
    if self.m_teamIndex == 1 then
        if posIndex == -1 or self.m_tempTeamData[posIndex] == "-1" then return end
    else
        if posIndex == -1 or self.m_tempFriendData[posIndex] == "-1" then return end
    end    
    local bgSprite = tolua.cast(self.m_formation_layer:getChildByTag(posIndex),"CCSprite");
    if bgSprite == nil then return end
    -- local tempDisplayFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_characterBgSel.png");
    -- if tempDisplayFrame then
    --     bgSprite:setDisplayFrame(tempDisplayFrame);
        local pX,pY = bgSprite:getPosition();
        local tempPos = self.m_formation_layer:convertToWorldSpace(ccp(pX,pY));
        self.m_sel_bg:setPosition(ccp(pX,pY));
        self.m_sel_bg:setVisible(true);
    -- end
end

--[[--
    刷新卡牌信息
]]
function game_adjustment_formation.getPosEquipAttrValue(self,posIndex)
    -- 1物攻 2魔攻 3防御 4速度 5生命
    local equip_set_random = getConfig(game_config_field.equip_set_random)
    local attrValueTab = {0,0,0,0,0};
    local posEquips = nil
    if self.m_teamIndex == 1 then
        posEquips = self.m_tempEquipPosData[posIndex]
    else
        posEquips = self.m_tempAssEquipPosData[tostring(posIndex+99)]
    end
    -- cclog("posIndex ==== " .. posIndex .. " ;type(posEquips) == " .. type(posEquips))
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
                --增加锻造属性值
                if equipItemData.is_equip_forge == true then
                    -- local attrname = 
                    -- local tempValue = {0,0,0,0,0}
                    for key_type,valueTable in pairs(equipItemData.equip_forge) do
                        local itemEquipForgeCfg = json.decode(equip_set_random:getNodeWithKey(tostring(key_type)):getFormatBuffer())
                        local sort = itemEquipForgeCfg.sort
                        local enemy = itemEquipForgeCfg.enemy[1]
                        local value = 0
                        for k,v in pairs(valueTable) do
                            value = v
                        end
                        -- cclog2(value,"equp forge value")
                        if sort > 0 and sort <= 5 then
                            -- tempValue[sort] = value

                            -- attrValueTab[sort] = attrValueTab[sort] * (1 + value)
                            --改成加数不用百分比
                            if enemy ~= -1 then--减敌人的不加
                                attrValueTab[sort] = attrValueTab[sort] + value
                            end
                        end
                    end
                                
                end


             end
        end
    end
    return attrValueTab
end

function game_adjustment_formation.getPosMagicAttrValue(self,posIndex)
    -- 1物攻 2魔攻 3防御 4速度 5生命
    local TempTable = {
        {
            {base = "patk",},
            {base =  "matk",},
            {base = nil,},
            {base = nil,},
            {base = nil,},
        },
        {
            {base = nil,},
            {base = nil,},
            {base = "def",},
            {base = "speed",},
            {base = "hp",},
        },

    }
    local talisman = getConfig(game_config_field.talisman)
    local attrValueTab = {0,0,0,0,0};
    local posMagic = nil
    if self.m_teamIndex == 1 then
        posMagic = self.m_tempMagicPosData[posIndex]
    else
        posMagic = self.m_tempAssMagicPosData[tostring(posIndex+99)]
    end
    -- cclog("posIndex ==== " .. posIndex .. " ;type(posMagic) == " .. type(posMagic))
    local level,value1,value2;
    local suitTab = {};
    if posMagic and type(posMagic) == "table" then
        for k,v in pairs(posMagic) do
            local ItemData,itemCfg = game_data:getMagicDataById(v);
            if ItemData and itemCfg then
                level = ItemData.lv;
                if itemCfg.talisman_type == 1 or itemCfg.talisman_type == "1" then
                    local table = TempTable[1]
                    for k,v in pairs(table) do
                        if v.base ~= nil then
                            attrValueTab[k] = attrValueTab[k] + itemCfg["base_" .. v.base] + itemCfg["growth_" .. v.base] * level
                        end
                    end
                elseif itemCfg.talisman_type == 0 or itemCfg.talisman_type == "0" then
                    local table = TempTable[2]
                    for k,v in pairs(table) do
                        if v.base ~= nil then
                            attrValueTab[k] = attrValueTab[k] + itemCfg["base_" .. v.base] + itemCfg["growth_" .. v.base] * level
                        end
                    end
                end
            end
        end
    end
    return attrValueTab
end

--[[
    宝石基本能力属性加成
]]
function game_adjustment_formation.getGemBaseAttrValue(self, posIndex)
    local attrValueTab = {0,0,0,0,0}
    local combatValue = 0;
    local gemCfg = getConfig(game_config_field.gem);
    local gemPosItemData = self.m_tempGemPosData[posIndex] or {}
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
    return attrValueTab;
end

--[[
    勋章基本能力属性加成
]]
function game_adjustment_formation.getMedalBaseAttrValue(self, posIndex)
    local attrValueTab = {0,0,0,0,0}
    local combatValue = 0;
    local medalCfg = getConfig(game_config_field.medal);
    local medalPosItemData = self.m_tempMedalPosData[posIndex] or {}

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
    徽章的属性加成
]]
function game_adjustment_formation:getBadgeBaseAttrValue()
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
    英魂基本能力属性加成
]]
function game_adjustment_formation.getSoulBaseAttrValue(self,posIndex)
    local attrValueTab = {0,0,0,0,0}
    local attrValueTab2 = {0,0,0,0,0}
    local attrValuePercent = {0,0,0,0,0}
    local combatValue = 0;
    local soulCfg = getConfig(game_config_field.soul_detail);
    local soulPosData = self.m_tempSoulPosData[posIndex] or {};
    -- cclog2(soulPosData,"soulPosData")
    -- cclog2(posIndex,"posIndex")
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
    刷新卡牌信息
]]
function game_adjustment_formation.refreshHeroInfo(self,posIndex,isFriendEquip)
    if game_data.getGuideProcess and game_data:getGuideProcess() == "guide_second" and self.m_guide_step == 30 then
        if game_util.statisticsSendUserStep then game_util:statisticsSendUserStep(48) end -- 第一次点击伙伴招募 步骤48
    end
    local replaceStr = "Thay đổi"
    self.m_magic_node:setVisible(false)
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
    for i=1,4 do
        tempNode = self.m_ccbNode:spriteForName("m_magic_" .. i)
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
    -- cclog("cardData ========" .. tostring(cardData) .. " ; cardCfg ========" .. tostring(cardCfg))
    local fate_detail_label_str = "Không có";
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
        local magicAttrValueTab = self:getPosMagicAttrValue(posIndex);--装备属性
        local petAttrValueTab = game_util:getPetCombatValue(posIndex)
        local petFollowValueTab = game_util:getPetFollowCombatValue(posIndex)
        local gemAttrValueTab = {0,0,0,0,0};
        local medalAttrValueTab = {0,0,0,0,0}
        local badgeAttrValueTab = {0,0,0,0,0}
        local attrValueTab2 = {0,0,0,0,0};
        local attrValueTab3 = {0,0,0,0,0};
        local universeCombatValue = 0
        local universeAttrValueTab = {0,0,0,0,0}
        local soulAttrValueTab = {0,0,0,0,0};
        local soulAttrValueTab2 = {0,0,0,0,0};
        local soulPercentValueTab = {0,0,0,0,0};
        local rolePropertryValueTab = {0,0,0,0,0}
        local myBonusAddRate = {0,0,0,0,0}
        local xyz = game_util:getFormationBonusAllData(posIndex)

        if self.m_teamIndex == 1 then
            gemAttrValueTab = self:getGemBaseAttrValue(posIndex);--宝石的基本属性
            attrValueTab2 = game_util:getCommanderCombatValue();--统帅能力
            attrValueTab3 = game_util:getAssistantCombatValue();--助威加的属性
            medalAttrValueTab = self:getMedalBaseAttrValue(posIndex);--勋章的基本属性
            badgeAttrValueTab = self:getBadgeBaseAttrValue()
            soulAttrValueTab,soulPercentValueTab,soulAttrValueTab2 = self:getSoulBaseAttrValue(posIndex,cardData); --英魂基本属性
            -- cclog2(soulAttrValueTab,"soulAttrValueTab")
            -- universeCombatValue,universeAttrValueTab = game_util:getUniverseCombatValue(cardData.id,self.allUniverseEffect)--宇宙属性加成
            rolePropertryValueTab = game_util:getRolePropertryValue()
            -- game_util:getFormationBonusAllData()
            -- local tempmyBonusAddRate = game_data:getBonusAddTab()
            -- myBonusAddRate= tempmyBonusAddRate[posIndex] or {0,0,0,0,0}
            -- cclog2(myBonusAddRate,"bo----- ")
        end

        --todo
        local cbmTab=game_util:getCombatBonusMultiplierByCfg(cardCfg,cardData.id); --联协属性
        if  cardData.fate_change and next(cardData.fate_change) then
            cbmTab = game_util:getCombatBonusMultiplierByCfg2(cardCfg,cardData.id);--连协刷新过的属性
        end
       
        local soulPercentCombatTab = {0,0,0,0,0};
        if xyz and next(xyz) then
            myBonusAddRate = xyz
        end
        for i=1,5 do
            local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. i] or {}
            local attrValue = cardData[abilityItem.attrName or ""] or 0
            soulPercentCombatTab[i] = attrValue * soulPercentValueTab[i] * 0.01
            attrValueTab[i] = math.floor(equipAttrValueTab[i] + magicAttrValueTab[i] + attrValueTab2[i] + attrValue*cbmTab[i] + gemAttrValueTab[i] + attrValueTab3[i] + petAttrValueTab[i] + medalAttrValueTab[i]  + badgeAttrValueTab[i] + soulAttrValueTab[i] + soulAttrValueTab2[i] + universeAttrValueTab[i] + petFollowValueTab[i] + soulPercentCombatTab[i] + rolePropertryValueTab[i] + myBonusAddRate[i])
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
            -- if cardData.famous then

            -- end
        end
        local skinCombat = game_util:getSkinCombat(cardData.c_id)
        -- cclog2(skinCombat,"skinCombat ------ ")
        local data = game_data:getFamousAttrs() or {}--名人堂
        local tempTab = cardData.famous or {}
        -- attrValueTab[5] = skinCombat[5] + attrValueTab[5]
        -- attrValueTab[1] = skinCombat[1] + attrValueTab[1]
        -- attrValueTab[2] = skinCombat[2] + attrValueTab[2]
        -- attrValueTab[3] = skinCombat[3] + attrValueTab[3]
        -- attrValueTab[4] = skinCombat[4] + attrValueTab[4]
        attrValueTab[5] = skinCombat[5] + attrValueTab[5] + (tempTab.hp_v or 0) + (self.m_teamIndex == 1 and (data.hp or 0) or 0)
        attrValueTab[1] = skinCombat[1] + attrValueTab[1] + (tempTab.patk_v or 0) + (self.m_teamIndex == 1 and (data.patk or 0) or 0)
        attrValueTab[2] = skinCombat[2] + attrValueTab[2] + (tempTab.matk_v or 0) + (self.m_teamIndex == 1 and (data.matk or 0) or 0)
        attrValueTab[3] = skinCombat[3] + attrValueTab[3] + (tempTab.def_v or 0) + (self.m_teamIndex == 1 and (data.def or 0) or 0)
        attrValueTab[4] = skinCombat[4] + attrValueTab[4] + (tempTab.speed_v or 0) + (self.m_teamIndex == 1 and (data.speed or 0) or 0)
        
        self.m_life_label2:setString("+" .. attrValueTab[5])
        self.m_physical_atk_label2:setString("+" .. attrValueTab[1])
        self.m_magic_atk_label2:setString("+" .. attrValueTab[2])
        self.m_def_label2:setString("+" .. attrValueTab[3])
        self.m_speed_label2:setString("+" .. attrValueTab[4])
        local chainTab=game_util:cardChainByCfg(cardCfg,cardData.id);
 ---命运刷新todo
        if  cardData.fate_change and next(cardData.fate_change) then
            
             chainTab = game_util:cardChainByCfg2(cardCfg,cardData.id)
        end

   ---命运刷新todo      
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
            fate_detail_label_str = showStr;
        else
        end
        self.m_magic_node:setVisible(is_bright)
        if game_data:isViewShowByID(182) == true then
            if isFriendEquip and isFriendEquip == true then

                self:autoMatchFateEquip(self.m_selHeroId,posIndex,isFriendEquip)

            else
                self:autoMatchFateEquip(self.m_selHeroId,posIndex)
            end
        end

        self:refreshEquipPos(posIndex)
        self:refreshMagicPos(posIndex)
        self:refreshGemPos(posIndex)
        -- self:refreshMedalPos(posIndex)--勋章不显示，所以不用加
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
        -- self.m_fate_label:setString("Không")
        -- self.m_fate_detail_label:setString("Không")
        if self.m_teamIndex == 2 then
            self:setSelPositionBg(posIndex);
        end
        replaceStr = "Ra trận"
    end
    if self.m_teamIndex == 2 then
        self.m_adjust1:setVisible(true);
        self.m_adjust2:setVisible(false);
        local m_cost_title = self.m_ccbNode:spriteForName("m_cost_title")
        local m_cost_label = self.m_ccbNode:labelBMFontForName("m_cost_label")
        local m_cost_icon = self.m_ccbNode:spriteForName("m_cost_icon")
        local m_activation_btn = self.m_ccbNode:controlButtonForName("m_activation_btn")
        local m_attr_refresh_btn = self.m_ccbNode:controlButtonForName("m_attr_refresh_btn")
        local m_assistant_detail_node = self.m_ccbNode:labelTTFForName("m_assistant_detail_node")
        m_assistant_detail_node:removeAllChildrenWithCleanup(true)
        local dimensions = m_assistant_detail_node:getContentSize()
        m_cost_icon:setOpacity(0)
        local active_status = -1
        if posIndex ~= -1 then
            local assistantEffect = game_data:getAssistantEffect()
            local assistantEffectItem = assistantEffect[posIndex] or {}
            active_status = assistantEffectItem.active_status or "-1"  -- "-1"未激活 "0" 激活
            local assistant_cfg = getConfig(game_config_field.assistant);
            local assistant_cfg_item = assistant_cfg:getNodeWithKey(tostring(posIndex))
            local cardlimit = assistant_cfg_item:getNodeWithKey("cardlimit")
            cardlimit = cardlimit and cardlimit:toInt() or 0;
            local att_type = assistant_cfg_item:getNodeWithKey("att_type")
            att_type = att_type and att_type:toInt() or 0;
            local actlv = assistant_cfg_item:getNodeWithKey("actlv")
            actlv = actlv and actlv:toInt() or 0;
            local att_value = assistant_cfg_item:getNodeWithKey("att_value")
            att_value = att_value and att_value:toInt() or 0;
            local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. att_type] or {};
            local abilityName = tostring(abilityItem.name)
            local tipsStrTab,tipsStrTab2 = {},{}

            if active_status == "-1" then
                table.insert(tipsStrTab,string.format("Cấp kích hoạt:%d",actlv));--激活等级：
                table.insert(tipsStrTab,string.format("\nThuộc tính kích hoạt:%s+%d%%",abilityName,att_value));--激活属性：
                self.m_assistant_detail_label = game_util:createRichLabelTTF({text = table.concat(tipsStrTab),dimensions = dimensions,textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(221,221,192),fontSize = 8})
                self.m_assistant_detail_label:setAnchorPoint(ccp(0,0))
                m_assistant_detail_node:addChild(self.m_assistant_detail_label)
                self.m_scroll_view_tips:getContainer():removeAllChildrenWithCleanup(true)
            else
                local tempAssistantCardAttrValueTab = {}
                local attrIconAndInfoTab = {}
                local assAttrValueTab,_,_ = game_util:getAssistantAttrTab(posIndex, assistantEffectItem, assistant_cfg_item, false)
                for i=1,#assAttrValueTab do
                    local attrValueItem = assAttrValueTab[i]
                    local att_name = attrValueItem.att_name or ""
                    if att_name ~= "ability2" or (att_name == "ability2" and self.m_ability2OpenFlag) then
                        local temp_att_type = attrValueItem.att_type or 0
                        local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. temp_att_type]
                        if abilityItem and attrValueItem.open > 0 then
                            local temp_value,temp_att_value = 0,attrValueItem.att_value or 0
                            if att_name == "ability1" then
                                table.insert(tipsStrTab2,string.format("Đồng đội xuất chiến%s Đồng đội tăng trợ uy%s%.2f%%",abilityName,abilityName,temp_att_value));
                            end
                            if cardData then
                                temp_value = (attrValueTab[temp_att_type]+(cardData[tostring(abilityItem.attrName)] or 0))*temp_att_value*0.01
                                local evo = cardData.evo or 0--进阶
                                if evo > cardlimit then
                                    if tempAssistantCardAttrValueTab[att_type] == nil then
                                        tempAssistantCardAttrValueTab[att_type] = game_util:getAssistantCardAttrValue(cardData, cardCfg, temp_att_type, cardlimit)
                                    end
                                    if cardData.famous then
                                        local key = {"patk_v","matk_v","def_v","speed_v","hp_v"}
                                        tempAssistantCardAttrValueTab[att_type] = tempAssistantCardAttrValueTab[att_type] + (cardData.famous[key[att_type]] or 0)
                                    end
                                    temp_value = tempAssistantCardAttrValueTab[att_type]*temp_att_value*0.01
                                end
                            end
                            local tempStr = nil
                            if att_name == "card" then
                                if attrValueItem.active > 0 then
                                    if temp_att_type > 5 then
                                        tempStr = "[color=ff00ff00]+" .. tostring(math.floor(att_value)) .. "[/color](Chỉ hạn chế[color=ffffdc00]" .. tostring(attrValueItem.character_name) .. "[/color])"
                                    else
                                        tempStr = "[color=ff00ff00]+" .. tostring(math.floor(temp_value)) .. "[/color](" .. tostring(attrValueItem.att_value) .. "%" .. ",Chỉ hạn chế[color=ffffdc00]" .. tostring(attrValueItem.character_name) .. "[/color])"
                                    end
                                else
                                    if temp_att_type > 5 then
                                        tempStr = "[color=ff8A8A8A]+" .. tostring(math.floor(att_value)) .. "[/color](Chỉ hạn chế[color=ff8A8A8A]" .. tostring(attrValueItem.character_name) .. "[/color])"
                                    else
                                        tempStr = "[color=ff8A8A8A]+" .. tostring(math.floor(temp_value)) .. "[/color](" .. tostring(attrValueItem.att_value) .. "%" .. ",Chỉ hạn chế[color=ff8A8A8A]" .. tostring(attrValueItem.character_name) .. "[/color])"
                                    end
                                end
                            else
                                tempStr = "[color=ff00ff00]+" .. tostring(math.floor(temp_value)) .. "[/color](" .. tostring(temp_att_value) .. "%)"
                            end
                            if #tipsStrTab == 0 then
                                table.insert(tipsStrTab,tempStr)
                            else
                                table.insert(tipsStrTab,"\n" .. tempStr)
                            end
                            table.insert(attrIconAndInfoTab,{icon = tostring(abilityItem.icon),info = tempStr})
                        end
                    end
                end
                -- table.insert(tipsStrTab2,string.format("出战伙伴%s增加助威伙伴%s的%d%%",abilityName,abilityName,att_value));
                -- table.insert(tipsStrTab2,string.format("\n当前全体出战伙伴%s增加%d",abilityName,math.floor(temp_value)));    
                table.insert(tipsStrTab2,string.format("Vị trí này đồng đội chỉ phát huy thực lực Lv%d",cardlimit));--此位置伙伴只能发挥%d阶实力
                local tempCount = #attrIconAndInfoTab
                local startY = dimensions.height*0.5 + 10*tempCount*0.5
                for i=1,tempCount do
                    local itemData = attrIconAndInfoTab[i]
                    local pY = startY - 10*i + 5
                    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tostring(itemData.icon))
                    if tempSpriteFrame then
                        local tempIcon = CCSprite:createWithSpriteFrame(tempSpriteFrame)
                        tempIcon:setScale(0.5)
                        tempIcon:setPosition(ccp(-8,pY))
                        m_assistant_detail_node:addChild(tempIcon)
                    end
                    local m_assistant_detail_label = game_util:createRichLabelTTF({text = itemData.info,textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(221,221,192),fontSize = 8})
                    m_assistant_detail_label:setPosition(ccp(0,pY))
                    m_assistant_detail_label:setAnchorPoint(ccp(0,0.5))
                    m_assistant_detail_node:addChild(m_assistant_detail_label)
                end
                game_util:createScrollViewTips(self.m_scroll_view_tips,tipsStrTab2)
            end
            local activation = assistant_cfg_item:getNodeWithKey("activation")
            if activation and activation:getNodeCount() > 0 then
                local icon,name,count = game_util:getRewardByItem(activation:getNodeAt(0));
                if icon then
                    icon:ignoreAnchorPointForPosition(true)
                    m_cost_icon:addChild(icon)
                end
                m_cost_label:setString(tostring(count))
            end
        end
        m_cost_title:setVisible(active_status == "-1")
        m_cost_label:setVisible(active_status == "-1")
        m_cost_icon:setVisible(active_status == "-1")
        m_activation_btn:setVisible(active_status == "-1")
        if active_status == "-1" then
            -- self.m_scroll_view_tips:setPosition(ccp(0,0))
            -- m_assistant_detail_label:setPosition(ccp(0,0))
        else
            -- self.m_scroll_view_tips:setPosition(ccp(20,-15))
            -- m_assistant_detail_label:setPosition(ccp(0,-12))
        end
        m_attr_refresh_btn:setVisible(active_status ~= "-1")
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
function game_adjustment_formation.autoMatchFateEquip( self,heroId,posIndex,isFriendEquip )
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
    local tempEquipPosData = {}
    if isFriendEquip and isFriendEquip == true then
        tempEquipPosData = self.m_tempAssEquipPosData
        posIndex = tostring(posIndex + 99)
    else
        tempEquipPosData = self.m_tempEquipPosData
    end
    -- cclog2(posIndex,"posIndex ====")
    if cardData.bind_equip and next(cardData.bind_equip) then
        -- cclog2(cardData.bind_equip,"cardData.bind_equip[i]==== ")
        for i=1,4 do
            if cardData.bind_equip[i] ~= 0 then
                tempEquipPosData[posIndex][i] = cardData.bind_equip[i]
            else
                local equipData = game_data:getEquipDataById(curPosEquip[i])
                if equipData and equipData.bind_card and equipData.bind_card ~= ""  then
                    -- cclog2(equipData.bind_card,"equipData.bind_card ===")
                    -- cclog2(cardData.id,"cardData.id ===")
                    if equipData.bind_card ~= cardData.id then
                        tempEquipPosData[posIndex][i] = "0"
                    end
                else
                end
            end
        end
    else
        for sort,Id in pairs(curPosEquip) do
            local equipData = game_data:getEquipDataById(Id)
            if equipData and equipData.bind_card and equipData.bind_card ~= ""  then
                if equipData.bind_card ~= cardData.id then
                    tempEquipPosData[posIndex][sort] = "0"
                end
            else
            end
        end
    end
    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
    -- self:newChainOpenAnim("equip");
end
--[[
    刷新装备
]]
function game_adjustment_formation.refreshEquipPos(self,posIndex)
    if posIndex and posIndex > 0 and posIndex < 10 then
        local tempNode = nil;
        local equipPosData = nil
        if self.m_teamIndex == 1 then
            equipPosData = self.m_tempEquipPosData[posIndex]
        elseif self.m_teamIndex == 2 then
            equipPosData = self.m_tempAssEquipPosData[tostring(posIndex+99)]
        end
        for k,v in pairs(equipPosData) do
            if v ~= "0" then
                local equipItemData =  game_data:getEquipDataById(v);
                if equipItemData.bind_card and equipItemData.bind_card ~= "" then
                    if equipItemData.bind_card ~= self.m_selHeroId then
                        equipPosData[k] = "0"
                    end
                end
            end

        end

        if equipPosData then
            -- cclog("posIndex == " .. posIndex .. " ; equipPosData ======= " .. json.encode(equipPosData))
            local noUseEquipCountTab = game_data:getNoUseEquipCountTab();
            local is_bright = false
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
                            else
                                is_bright = true
                            end
                        end
                        if equipItemData then
                            local tempLabel = game_util:createLabelTTF({text = "Lv." .. equipItemData.lv,color = ccc3(250,255,0),fontSize = 14});
                            tempLabel:setPosition(ccp(tempNodeSize.width*0.5,-tempNodeSize.height*0.1))
                            tempNode:addChild(tempLabel,11,11)
                        else
                            -- cclog("equipIndex == " .. i .. " ; equipId == " .. tostring(id));
                        end
                    else
                        is_bright = true
                        if noUseEquipCountTab[i] > 0 then
                            local tempSpri = CCSprite:createWithSpriteFrameName("public_kezhuangbei.png")
                            tempSpri:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(tempSpri,10,10)
                        end
                        if i == 1 then
                            local id = game_guide_controller:getCurrentId();
                            if id == 31 then
                                self.m_guide_step = 31
                                game_guide_controller:gameGuide("show","2",32,{tempNode = tempNode})
                            end
                        end
                    end
                end
            end
            self.m_replace_equip_btn:setVisible(is_bright)
        end
    end 
end
--[[
    刷新法宝
]]
function game_adjustment_formation.refreshMagicPos(self,posIndex)
    if posIndex and posIndex > 0 and posIndex < 10 then
        local tempNode = nil;
        local magicPosData = nil
        if self.m_teamIndex == 1 then
            magicPosData = self.m_tempMagicPosData[posIndex]
        elseif self.m_teamIndex == 2 then
            magicPosData = self.m_tempAssMagicPosData[tostring(posIndex+99)]
        end
        if magicPosData then
            local noUseMagicCountTab = game_data:getNoUseMagicCountTab();
            -- cclog2(noUseMagicCountTab,"noUseMagicCountTab    -----------")
            for i=1,4 do
                tempNode = self.m_ccbNode:spriteForName("m_magic_" .. i) 
                if tempNode then
                    tempNode:removeAllChildrenWithCleanup(true)
                    local tempNodeSize = tempNode:getContentSize();
                    local id = magicPosData[i];
                    if id and tostring(id) ~= "0" then
                        local magicItemData,magicItemCfg = game_data:getMagicDataById(tostring(id));
                        local magicIcon = game_util:createMagicIcon(magicItemCfg);
                        if magicIcon then
                            magicIcon:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(magicIcon,10,10)
                            if self.m_selMagicId == id then
                                magicIcon:setScale(2.0);
                                local animArr = CCArray:create();
                                animArr:addObject(CCSpawn:createWithTwoActions(CCEaseIn:create(CCScaleTo:create(0.5,1.0),5),CCFadeIn:create(0.5)));
                                animArr:addObject(CCScaleTo:create(0.1,1.2));
                                animArr:addObject(CCScaleTo:create(0.1,1.0));
                                magicIcon:runAction(CCSequence:create(animArr));
                                self.m_selMagicId = nil;
                            end
                        end
                        if magicItemData then
                            local tempLabel = game_util:createLabelTTF({text = "Lv." .. magicItemData.lv,color = ccc3(250,255,0),fontSize = 14});
                            tempLabel:setPosition(ccp(tempNodeSize.width*0.5,-tempNodeSize.height*0.1))
                            tempNode:addChild(tempLabel,11,11)
                        else
                            -- cclog("equipIndex == " .. i .. " ; equipId == " .. tostring(id));
                        end
                    else
                        local temp_type
                        if i < 3 then
                            temp_type = 2
                        else
                            temp_type = 1   
                        end
                        if noUseMagicCountTab[temp_type] > 0 then
                            local tempSpri = CCSprite:createWithSpriteFrameName("public_kezhuangbei.png")
                            tempSpri:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(tempSpri,10,10)
                        end
                    end
                end
            end
        end
    end 
end

--[[
    刷新装备
]]
function game_adjustment_formation.refreshGemPos(self,posIndex)
    if posIndex and posIndex > 0 and posIndex < 10 then
        local tempNode = nil;
        local gemPosData = self.m_tempGemPosData[posIndex]
        if gemPosData then
            -- cclog("posIndex == " .. posIndex .. " ; gemPosData ======= " .. json.encode(gemPosData))
            local noUseGemCountTab = game_data:getNoUseGemCountTab();
            for i=1,4 do
                tempNode = self.m_ccbNode:spriteForName("m_equip_" .. (4+i))  
                if tempNode then
                    local tempNodeSize = tempNode:getContentSize();
                    local id = gemPosData[i];
                    if id and tostring(id) ~= "0" then
                        -- local tempItemData,tempItemCfg = game_data:getGemDataById(tostring(id));
                        -- local tempIcon = game_util:createGemIconByCfg(tempItemCfg);
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
                            local tempLabel = game_util:createLabelTTF({text = gemName,color = ccc3(250,255,0),fontSize = 14});
                            tempLabel:setPosition(ccp(tempNodeSize.width*0.5,-tempNodeSize.height*0.1))
                            tempNode:addChild(tempLabel,11,11)
                        else
                            -- cclog("equipIndex == " .. i .. " ; equipId == " .. tostring(id));
                        end
                    else
                        if noUseGemCountTab[i] > 0 then
                            local tempSpri = CCSprite:createWithSpriteFrameName("public_kezhuangbei.png")
                            tempSpri:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(tempSpri,10,10)
                        end
                        -- if i == 1 then
                        --     local id = game_guide_controller:getCurrentId();
                        --     if id == 31 then
                        --         game_guide_controller:gameGuide("show","2",32,{tempNode = tempNode})
                        --     end
                        -- end
                    end
                end
            end
        end
    end 
end
--判断该装备是否可以命运装备绑定
function game_adjustment_formation.fateEquipLock(self,itemData,tempEquipId)
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
    装备层
]]
function game_adjustment_formation.initEquipLayerTouch(self,formation_layer)
    
    local touchBeginPoint = nil;
    local touchMoveFlag = false;
    local tempItem = nil;
    local realPos = nil;
    local tag = nil;
    local function onTouchBegan(x, y)
        cclog("  ------------  is touching EquipLayer  --------------")
        touchMoveFlag = false;
        -- cclog("onTouchBegan: %0.2f, %0.2f", x, y)
        touchBeginPoint = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    local function onTouchMoved(x, y)
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            cclog(" ------------  is moving EquipLayer  --------------")
            touchMoveFlag = true;
        end
    end
    
    local function onTouchEnded(x, y)
        cclog(" ------------  touch EquipLayer ended --------------")
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
                    -- cclog2(tag, "tag   ===   ")
                    if tag < 20 then
                        -- cclog("sel Equip tag 1=======================" .. tag);
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
                                        self.m_openType = "equip_strengthen"
                                        self:sendChangedData(1);
                                    elseif typeName == "evolution" then
                                        self.m_openType = "equip_evolution"
                                        self:sendChangedData(1);
                                    elseif typeName == "fateEquipLock" then
                                        self:refreshCombatLabel();
                                        self:refreshEquipPos(self.m_posIndex)
                                        self:refreshMagicPos(self.m_posIndex)
                                        self:refreshHeroInfo(self.m_posIndex)

                                    end
                                end
                                self.select_temp_id = tempEquipId
                                local fateEquipLock  = self:fateEquipLock(itemData,tempEquipId)
                                game_scene:addPop("game_equip_info_pop",{tGameData = itemData,posEquipData = self.m_tempEquipPosData[self.m_posIndex],callBack = callBack,openType=2,fateEquipLock = fateEquipLock,selHeroId = self.m_selHeroId});
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
                                local itemData = game_data:getGemDataById(tempId)
                                local function callBack(typeName,t_param)
                                    if typeName == "unload" then
                                        self:addSelGemUi(self.m_posIndex,tag - 20);
                                    elseif typeName == "strengthen" then
                                        self.m_openType = "gem_strengthen"
                                        self:sendChangedData(1);
                                    elseif typeName == "synthesis" then
                                        self.m_openType = "gem_synthesis"
                                        self:sendChangedData(1);
                                    elseif typeName == "advanced" then
                                        self.m_openType = "gem_advanced"
                                        self:sendChangedData(1);
                                    end
                                end
                                self.select_temp_id = tempId
                                game_scene:addPop("gem_system_info_pop",{tGameData = {count = itemData,c_id = tempId},callBack = callBack,openType=2});
                            end
                        else
                        end
                    end
                    break;
                end
            end
        end
        if touchMoveFlag == false then
            cclog2(touchMoveFlag  , " EquipLayer  touchMoveFlag  -------- " )
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
    法宝
]]
function game_adjustment_formation.initMagicLayerTouch(self,formation_layer)

    local touchBeginPoint = nil;
    local touchMoveFlag = false;
    local tempItem = nil;
    local realPos = nil;
    local tag = nil;
    local function onTouchBegan(x, y)
        cclog("  ------------  is touching MagicLayer  --------------")
        touchMoveFlag = false;
        -- cclog("onTouchBegan: %0.2f, %0.2f", x, y)
        touchBeginPoint = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    local function onTouchMoved(x, y)
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            cclog("  ------------  is moving MagicLayer  --------------")
            touchMoveFlag = true;
        end
    end
    
    local function onTouchEnded(x, y)
        cclog("  ------------  touch MagicLayer ended --------------")
        if formation_layer:isVisible() == true then
            for i = 1,8 do
                if i < 5 then
                    tempItem = self.m_ccbNode:spriteForName("m_magic_" .. i)
                else
                    tempItem = self.m_ccbNode:spriteForName("m_equip_" .. i)
                end
                realPos = tempItem:getParent():convertToNodeSpace(ccp(x,y)); 
                if tempItem:boundingBox():containsPoint(realPos) then
                    tag = tempItem:getTag();
                    if self.m_posIndex == -1 or self.m_tempTeamData[self.m_posIndex] == "-1" then
                        game_util:addMoveTips({text = string_config:getTextByKey("m_onclick_team_pos")});
                        return;
                    end
                    -- cclog2(tag, "tag   ===   ")
                    if tag < 20 then
                        local index = tag - 10
                        local openType = 1
                        if index > 2 then
                            openType = 2
                        end
                        -- game_scene:addPop("game_magic_info_pop",{openType = openType })
                        -- cclog("sel Equip tag 1=======================" .. tag);
                        local openFlag = true;
                        if openFlag then
                            local tempMagicId = self:getPosMagicId(self.m_posIndex,tag - 10);
                            if tempMagicId == nil or tostring(tempMagicId) == "0" then
                                self:addSelMagicUi(self.m_posIndex,tag - 10);
                            else
                                tempMagicId = tostring(tempMagicId);
                                local itemData = game_data:getMagicDataById(tempMagicId)
                                local function callBack(typeName,t_param)
                                    if typeName == "unload" then
                                        self:addSelMagicUi(self.m_posIndex,tag - 10);
                                    elseif typeName == "evolution" then
                                        self.m_openType = "magic_evolution"
                                        self:sendChangedData(1);
                                    elseif typeName == "fateEquipLock" then
                                        self:refreshCombatLabel();
                                        self:refreshMagicPos(self.m_posIndex)
                                        self:refreshHeroInfo(self.m_posIndex)
                                    end
                                end
                                local Type
                                if tag - 10 < 3 then
                                    Type = 1 
                                else
                                    Type = 0
                                end
                                self.select_temp_id = tempMagicId
                                game_scene:addPop("game_magic_info_pop",{tGameData = itemData,posMagicData = self.m_tempMagicPosData[self.m_posIndex],callBack = callBack,magicType = Type,openType=2,selHeroId = self.m_selHeroId});
                            end
                        else
                        --     game_util:addMoveTips({text = string_config:getTextByKey("m_pos_no_open")});
                        end
                    elseif tag >= 20 then
                        if self.m_teamGemOpenFlag then
                            local tempId = self:getPosGemId(self.m_posIndex,tag - 20);
                            if tempId == nil or tostring(tempId) == "0" then
                                self:addSelGemUi(self.m_posIndex,tag - 20);
                            else
                                tempId = tostring(tempId);
                                local itemData = game_data:getGemDataById(tempId)
                                local function callBack(typeName,t_param)
                                    if typeName == "unload" then
                                        self:addSelGemUi(self.m_posIndex,tag - 20);
                                    elseif typeName == "strengthen" then
                                        self.m_openType = "gem_strengthen"
                                        self:sendChangedData(1);
                                    elseif typeName == "synthesis" then
                                        self.m_openType = "gem_synthesis"
                                        self:sendChangedData(1);
                                    elseif typeName == "advanced" then
                                        self.m_openType = "gem_advanced"
                                        self:sendChangedData(1);
                                    end
                                end
                                self.select_temp_id = tempId
                                game_scene:addPop("gem_system_info_pop",{tGameData = {count = itemData,c_id = tempId},callBack = callBack,openType=2});
                            end
                        else
                        end
                    end
                    break;
                end
            end
        end
        if touchMoveFlag == false then
            cclog2(touchMoveFlag,"   touchMoveFlag   MagicLayer   ")
            -- self:fateTouchShow(x,y);
        end
    end
    
    local function onTouch(eventType, x, y)
        cclog("   touchMoveFlag   MagicLayer   " .. eventType)
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
function game_adjustment_formation.judgeAddHero(self,posIndex)
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
function game_adjustment_formation.addTeamHeroPop(self,posIndex)
    game_scene:removeGuidePop();
    if self.m_tempTeamData[posIndex] == "-1" then
        cclog("--------addTeamHeroPop--11-----")
        cclog2(posIndex,"posIndex ----")
        if self:judgeAddHero(posIndex) == 0 then
            self:addSelHeroUi(posIndex);
        end
    else
        cclog("--------addTeamHeroPop--2-----")

        self.m_posIndex = posIndex;
        self:refreshHeroInfo(posIndex);
    end
end

--[[--
    
]]
function game_adjustment_formation.addSelHeroUi(self,posIndex)
    cclog("--------addSelHeroUi --------")
    if game_data.getGuideProcess and game_data:getGuideProcess() == "second_enter_main_scene" then
        if game_util.statisticsSendUserStep then game_util:statisticsSendUserStep(36) end -- 第一次进阵型 点击位置 步骤36
    end
    game_scene:removeGuidePop();
    -- cclog("addSelHeroUi posIndex ==" .. tostring(posIndex))
    local btnCallFunc = function( target,event )
        
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if (not game_util:heroInTeamById(id,self.m_tempTeamData)) and (not game_data:heroInAssistantById(id)) and (not game_util:isInFormationBonus(id)) then
                cclog("itemOnClick id ==================== " .. id);
                self:updateTeamData(posIndex,id);
                self.m_changeFlag = true;
                self:initTeamFormation(self.m_formation_layer);
                self.m_posIndex = posIndex;
                self:refreshHeroInfo(posIndex);
                self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                self:newChainOpenAnim("card");
                local id = game_guide_controller:getCurrentId();
                if id == 21 and self.m_back_btn then
                    game_guide_controller:gameGuide("show","1",22,{tempNode = self.m_back_btn})
                end
            end
        elseif typeName == "unload" then
            self.m_magic_node:setVisible(false)
            if self:getUnloadPosFlag(posIndex) == 0 then
                self:updateTeamData(posIndex,"-1");
                local pos = -1
                for i=1,10 do
                    if self.m_tempTeamData[i] ~= "-1" and self.m_tempTeamData[i] ~= "0" and pos == -1 then
                        pos = i
                    end
                end
                cclog2(pos,"  unload   end            ")
                self:refreshEquipPos(pos)
                self:refreshMagicPos(pos)
                self.m_changeFlag = true;
                self:initTeamFormation(self.m_formation_layer);
                self.m_posIndex = pos;
                self:refreshHeroInfo(pos);
                self:refreshCombatLabel("addSelHeroUi");
            end
        end
    end
    if self.m_openType == "zhuanshiTask2" then
        game_scene:addPop("game_hero_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,openType = 4})
    else
        game_scene:addPop("game_hero_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,openType = 2})
    end
end


--[[--
    
]]
function game_adjustment_formation.newChainOpenAnim(self,typeName)
    local animFlag = false;
    local chainTabBackUp = self.m_chainTabBackUp
    local chainNameTab = {};
    if typeName == "card" then
        if chainTabBackUp and #chainTabBackUp > 0 then
            for i=1,#chainTabBackUp do
                if chainTabBackUp[i].openFlag == true then
                    animFlag = true
                    table.insert(chainNameTab,tostring(chainTabBackUp[i].nameExt))
                end
            end
        end
    else
        local chainTab = self.m_chainTab;
        if chainTab and #chainTab and #chainTabBackUp > 0 and #chainTabBackUp > 0 then
            for i=1,#chainTabBackUp do
                if chainTab[i] and chainTab[i].openFlag == true and chainTabBackUp[i] and chainTabBackUp[i].openFlag == false then
                    animFlag = true
                    table.insert(chainNameTab,tostring(chainTabBackUp[i].nameExt))
                end
            end
        end
    end
    if animFlag == true then
        -- 粒子效果
        local function particleMoveEndCallFunc()
            self:refreshCombatLabel("newChainOpenAnim true");
        end
        local tempParticle = game_util:createParticleSystemQuad({fileName = "particle_fly_up"});
        if tempParticle then
            -- if self.m_fate_detail_node and self.m_fate_detail_node:isVisible() == false then
                game_util:addMoveAndRemoveAction({node = tempParticle,startNode = self.m_magic_node,endNode = self.m_combat_label,endCallFunc = particleMoveEndCallFunc,moveTime = 0.5,delayTime = 0.5})
            -- else
            --     game_util:addMoveAndRemoveAction({node = tempParticle,startNode = self.m_fate_detail_node,endNode = self.m_combat_label,endCallFunc = particleMoveEndCallFunc,moveTime = 0.5,delayTime = 0.5})
            -- end
            game_scene:getPopContainer():addChild(tempParticle)
        else
            particleMoveEndCallFunc();
        end
        --改成动画效果
        -- local anim_zhandouli = game_util:createEffectAnim("anim_xinlianxie",2.0,false)
        -- if self.m_fate_label:isVisible() == true then
        --     local viewSize = self.m_fate_node:getContentSize()
        --     anim_zhandouli:setAnchorPoint(ccp(0.5,0.5))
        --     anim_zhandouli:setPosition(ccp(viewSize.width*0.5,viewSize.height*0.5))
        --     self.m_fate_node:addChild(anim_zhandouli)
        -- else
        --     local viewSize = self.m_fate_detail_node:getContentSize()
        --     anim_zhandouli:setAnchorPoint(ccp(0.5,0.5))
        --     anim_zhandouli:setPosition(ccp(viewSize.width*0.5,viewSize.height*0.5))
        --     self.m_fate_detail_node:addChild(anim_zhandouli)
        -- end
        --提示有新的命运开启 chainNameTab 新命运 名称列表
        for i =1,#chainNameTab do  
            local delayTime = (i - 1) * 1.7
            game_util:addQueneOpenTips({text = "Mở vận mệnh <" .. chainNameTab[i] .. "> "},delayTime)
        end
        
    else
        self:refreshCombatLabel("newChainOpenAnim false");
    end
end

--[[--
    判断是否装备上
]]
function game_adjustment_formation.equipInEquipPos(self,equipType,equipId)
    local existFlag = false;
    local posIndex = -1;
    local posType = 1
    if equipType then
        for i=1,9 do
            if self.m_tempEquipPosData[i][equipType] == equipId then
                posIndex = i;
                existFlag = true
                break;
            end
            if self.m_tempAssEquipPosData[tostring(i+99)][equipType] == equipId then
                posIndex = i;
                existFlag = true
                posType = 2
                break;
            end
        end
    end
    return existFlag,posIndex,posType
end


--[[--
    判断是否装备上
]]
function game_adjustment_formation.magicInMagicPos(self,Type,Id)
    local existFlag = false;
    local posIndex = -1;
    local posType = 1
    local change_pos = 1
    -- cclog("  id   ===    " .. Id)
    -- cclog2(self.m_tempMagicPosData," elf.m_tempMagicPosData,elf.m_tempMagicPosData,elf.m_tempMagicPosData,  ")
    -- cclog2(self.m_tempAssMagicPosData," elf.m_tempAssMagicPosData,elf.m_tempAssMagicPosData,elf.m_tempAssMagicPosData,  ")
    if Type then
        for i=1,9 do
            if Type == 1 then
                if self.m_tempMagicPosData[i][1] == Id then
                    posIndex = i;
                    existFlag = true
                    change_pos = 1
                    break;
                elseif self.m_tempMagicPosData[i][2] == Id then
                    posIndex = i;
                    existFlag = true
                    change_pos = 2
                    break;
                end
            elseif  Type == 0 then
                if self.m_tempMagicPosData[i][3] == Id then
                    posIndex = i;
                    existFlag = true
                    change_pos = 3
                    break
                elseif self.m_tempMagicPosData[i][4] == Id then
                    posIndex = i;
                    existFlag = true
                    change_pos = 4
                    break;
                end
            end
            if Type == 1 then
                if self.m_tempAssMagicPosData[tostring(i+99)][1] == Id then
                    posIndex = i;
                    existFlag = true
                    posType = 2
                    change_pos = 1
                    break;
                elseif self.m_tempAssMagicPosData[tostring(i+99)][2] == Id then
                    posIndex = i;
                    existFlag = true
                    posType = 2
                    change_pos = 2
                    break;
                end
            elseif  Type == 0 then
                if self.m_tempAssMagicPosData[tostring(i+99)][3] == Id then
                    posIndex = i;
                    existFlag = true
                    posType = 2
                    change_pos = 3
                    break;
                elseif self.m_tempAssMagicPosData[tostring(i+99)][4] == Id then
                    posIndex = i;
                    existFlag = true
                    posType = 2
                    change_pos = 4
                    break;
                end
            end
        end
    end
    return existFlag,posIndex,posType,change_pos
    -- 是否装备    卡牌位置    主阵(1)或助威(2)    法宝位置
end
--[[--
    获得位置上的装备ID
]]
function game_adjustment_formation.getPosEquipId(self,equipPos,equipType)
    local tempEquipId = "0";
    if self.m_tempEquipPosData[equipPos] then
        tempEquipId = self.m_tempEquipPosData[equipPos][equipType]
    end
    return tempEquipId;
end

--[[
]]
function game_adjustment_formation.getPosMagicId(self,MagicPos,MagicType)
    local tempMagicId = "0";
    if self.m_tempMagicPosData[MagicPos] then
        tempMagicId = self.m_tempMagicPosData[MagicPos][MagicType]
    end
    return tempMagicId;
end

--[[--
    设置阵型相应位置装备数据
]]
function game_adjustment_formation.updateEquipPosData(self,equipPos,equipType,equipId)
    if equipPos > 9 or equipPos < 0 or equipType > 4 or equipType < 1 then return end
    -- cclog("updateEquipPosData equipPos = " .. equipPos .. " ; equipType = " .. equipType .. " ; equipId = " .. equipId);
    self.m_tempEquipPosData[equipPos][equipType] = tostring(equipId);
    -- cclog("updateEquipPosData = " .. json.encode(self.m_tempEquipPosData))
    self:setTeamFormationData();
end
--[[--
    设置阵型相应位置法宝数据
]]
function game_adjustment_formation.updateMagicPosData(self,magicPos,magicType,magicId)
    if magicPos > 9 or magicPos < 0 or magicType > 4 or magicType < 1 then return end
    -- cclog("updateEquipPosData magicPos = " .. magicPos .. " ; magicType = " .. magicType .. " ; magicId = " .. magicId);
    self.m_tempMagicPosData[magicPos][magicType] = tostring(magicId);
    -- cclog("updateEquipPosData = " .. json.encode(self.m_tempEquipPosData))
    self:setTeamFormationData();
end
function game_adjustment_formation.exchangeEquipPosDataByTwoPos(self,posIndex1,posIndex2,equipType)
    if posIndex1 == posIndex2 then return end
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    -- cclog("exchangeEquipPosDataByTwoPos posIndex1 = " .. posIndex1 .. " ; posIndex2 == " .. posIndex2);
    self.m_tempEquipPosData[posIndex1][equipType],self.m_tempEquipPosData[posIndex2][equipType] = self.m_tempEquipPosData[posIndex2][equipType],self.m_tempEquipPosData[posIndex1][equipType]
    self:setTeamFormationData();
end

--[[

]]
function game_adjustment_formation.exchangeTeamAndAssEquipPosDataByTwoPos(self,posIndex1,posIndex2,equipType,change_pos)
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    posIndex2 = tostring(posIndex2+99)
    self.m_tempEquipPosData[posIndex1][equipType],self.m_tempAssEquipPosData[posIndex2][change_pos] = self.m_tempAssEquipPosData[posIndex2][change_pos],self.m_tempEquipPosData[posIndex1][equipType]
    self:setTeamFormationData()
end

--[[
    交换法宝位置
]]

function game_adjustment_formation.exchangeMagicPosDataByTwoPos(self,posIndex1,posIndex2,equipType,change_pos)
    if posIndex1 == posIndex2 then return end
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    -- cclog("exchangeEquipPosDataByTwoPos posIndex1 = " .. posIndex1 .. " ; posIndex2 == " .. posIndex2);
    self.m_tempMagicPosData[posIndex1][equipType],self.m_tempMagicPosData[posIndex2][change_pos] = self.m_tempMagicPosData[posIndex2][change_pos],self.m_tempMagicPosData[posIndex1][equipType]
    self:setTeamFormationData();
end

--[[
    交换法宝位置
]]
function game_adjustment_formation.exchangeTeamAndAssMagicPosDataByTwoPos(self,posIndex1,posIndex2,equipType)
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    posIndex2 = tostring(posIndex2+99)
    self.m_tempMagicPosData[posIndex1][equipType],self.m_tempAssMagicPosData[posIndex2][equipType] = self.m_tempAssMagicPosData[posIndex2][equipType],self.m_tempMagicPosData[posIndex1][equipType]
    self:setTeamFormationData()
end

-------------------------------------------------------------------------
--[[--
    判断宝石是否装备上
]]
function game_adjustment_formation.gemInGemPos(self,tempType,tempId)
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

--[[--
    获得位置上的宝石ID
]]
function game_adjustment_formation.getPosGemId(self,tempPos,tempType)
    local tempEquipId = 0;
    if self.m_tempGemPosData[tempPos] then
        tempEquipId = self.m_tempGemPosData[tempPos][tempType]
    end
    return tempEquipId;
end

--[[--
    设置阵型相应位置宝石数据
]]
function game_adjustment_formation.updateGemPosData(self,tempPos,tempType,tempId)
    if tempPos > 9 or tempPos < 0 or tempType > 4 or tempType < 1 then return end
    cclog("updateGemPosData tempPos = " .. tempPos .. " ; tempType = " .. tempType .. " ; tempId = " .. tempId);
    local posGemId = tostring(self.m_tempGemPosData[tempPos][tempType]);
    tempId = tostring(tempId);
    game_data:addGemDataByCid(posGemId,1)
    game_data:minusGemDataCid(tempId,1)
    self.m_tempGemPosData[tempPos][tempType] = tempId;
    -- cclog("updateGemPosData = " .. json.encode(self.m_tempGemPosData))
    self:setTeamFormationData();
end

function game_adjustment_formation.exchangeGemPosDataByTwoPos(self,posIndex1,posIndex2,tempType)
    if posIndex1 == posIndex2 then return end
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or tempType > 4 or tempType < 1 then return end
    -- cclog("exchangeGemPosDataByTwoPos posIndex1 = " .. posIndex1 .. " ; posIndex2 == " .. posIndex2);
    self.m_tempGemPosData[posIndex1][tempType],self.m_tempGemPosData[posIndex2][tempType] = self.m_tempGemPosData[posIndex2][tempType],self.m_tempGemPosData[posIndex1][tempType]
    self:setTeamFormationData();
end



-------------------------------------------------------------------------

--[[--
    获得阵型相关的数据
]]
function game_adjustment_formation.setTeamFormationData(self)
    local formationId = 1;
    local tempTeamData = {};
    local tempEquipPosData = {};
    local tempGemPosData = {};
    local tempMedalPosData = {}
    local tempSoulPosData = {}
    local tempSaintStonePosData={}
    local tempMagicPosData = {};
    local emptyFlag = false;
    local tempCardId = nil;
    local tempEquipItem,tempGemItem,tempMedalItem,tempSoulItem,tempSaintStoneItem = nil,nil,nil,nil,nil

    local tempCount = 1;
    for i=1,9 do
        tempCardId = self.m_tempTeamData[i]
        tempEquipItem = self.m_tempEquipPosData[i];
        tempGemItem = self.m_tempGemPosData[i];
        tempMedalItem = self.m_tempMedalPosData[i]
        tempSoulItem = self.m_tempSoulPosData[i]
        tempSaintStoneItem = self.m_tempSaintStonePosData[i];
        tempMagicItem = self.m_tempMagicPosData[i]
        if tempCardId == "-1" then
            tempMagicItem = {"0","0","0","0"}
            self.m_tempMagicPosData[i] = {"0","0","0","0"}
        end
        if i < 7 then
            if tempCardId == "-1" and emptyFlag == false then
                emptyFlag = true;
                formationId = i;
            else
                if tempCount < 7 then
                    tempTeamData[tempCount] = tempCardId
                    tempEquipPosData[tostring(tempCount-1)] = util.table_copy(tempEquipItem);
                    tempGemPosData[tostring(tempCount-1)] = util.table_copy(tempGemItem);
                    tempMedalPosData[tostring(tempCount-1)] = util.table_copy(tempMedalItem)
                    tempSoulPosData[tostring(tempCount-1)] = util.table_copy(tempSoulItem)
                    tempSaintStonePosData[tostring(tempCount-1)] = util.table_copy(tempSaintStoneItem);
                    tempMagicPosData[tostring(tempCount-1)] = util.table_copy(tempMagicItem);
                    tempCount = tempCount + 1;
                end
            end
        else
            tempTeamData[tempCount] = tempCardId
            tempEquipPosData[tostring(tempCount-1)] = util.table_copy(tempEquipItem);
            tempGemPosData[tostring(tempCount-1)] = util.table_copy(tempGemItem);
            tempMedalPosData[tostring(tempCount-1)] = util.table_copy(tempMedalItem);
            tempSoulPosData[tostring(tempCount-1)] = util.table_copy(tempSoulItem)
            tempSaintStonePosData[tostring(tempCount-1)] = util.table_copy(tempSaintStoneItem);
            tempMagicPosData[tostring(tempCount-1)] = util.table_copy(tempMagicItem);
            tempCount = tempCount + 1;
        end
    end
    for i=9,10 do
        tempTeamData[i] = "-1";
        tempEquipPosData[tostring(i-1)] = {"0","0","0","0"}
        tempGemPosData[tostring(i-1)] = {"0","0","0","0"}
        tempMedalPosData[tostring(i-1)] = {"0","0","0","0","0","0"}
        tempSoulPosData[tostring(i-1)] = {"0","0","0","0","0","0"}
        tempSaintStonePosData[tostring(i-1)] = {"0","0","0","0","0"}
        tempMagicPosData[tostring(i-1)] = {"0","0","0","0"}
    end
    -- table.foreach(tempTeamData,print)
    -- cclog("-------------- equip -----------------")
    -- for k,v in pairs(tempEquipPosData) do
    --     cclog("k ============ " .. k)
    --     table.foreach(v,print)
    -- end
    -- cclog("-------------- equip -----------------")
    -- cclog("team = " .. json.encode(tempTeamData))
    -- cclog("equip = " .. json.encode(tempEquipPosData))
    -- cclog("------------------------------------------")
    -- cclog("gem = " .. json.encode(tempGemPosData))
    cclog("------------------------------------------")
    -- cclog("team2 = " .. json.encode(self.m_tempTeamData))
    -- cclog("equip2 = " .. json.encode(self.m_tempEquipPosData))
    -- cclog("gem2 = " .. json.encode(self.m_tempGemPosData))
    cclog("formationId ================== " .. formationId)
    self.m_selFormationId = formationId;
    game_data:setTeamData(tempTeamData);
    game_data:setEquipPosData(tempEquipPosData);
    game_data:setGemPosData(tempGemPosData);
    game_data:setMedalPos(tempMedalPosData)
    game_data:setSoulPos(tempSoulPosData)
    game_data:setSaintStonePosData(tempSaintStonePosData)
    game_data:setMagicpPosData(tempMagicPosData)
end

function game_adjustment_formation.exchangeEquipPosAlert(self,posIndex,currPos,sort,id,posType)
    if posType == 1 and posIndex == currPos then 
        game_util:addMoveTips({text = "Trang bị này ở vị trí này!"});
        return 
    end
    local tempText = nil;
    local heroData,heroCfg = nil,nil
    if posType == 1 then
        heroData,heroCfg = self:getTeamCardDataByPos(currPos)
    elseif posType == 2 then
        heroData,heroCfg = self:getFriendCardDataByPos(currPos)
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
            self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
            game_scene:removePopByName("game_magic_select_pop");
            game_util:closeAlertView();
            if posType == 1 then
                self:exchangeEquipPosDataByTwoPos(posIndex,currPos,sort)
            elseif posType == 2 then
                self:exchangeTeamAndAssEquipPosDataByTwoPos(posIndex,currPos,sort)
            end
            self.m_changeFlag = true;
            self:addTeamHeroPop(posIndex);
            self:newChainOpenAnim("equip");
        end,   --可缺省
        okBtnText = "Đổi trang bị",       --可缺省
        text = tempText,      --可缺省
    }
    game_util:openAlertView(t_params);
end

function game_adjustment_formation.exchangeMagicPosAlert(self,posIndex,currPos,sort,id,posType,change_pos)
    if posType == 1 and posIndex == currPos then 
        game_util:addMoveTips({text = "Trang bị này ở vị trí này!"});
        return 
    end
    local tempText = nil;
    local heroData,heroCfg = nil,nil
    if posType == 1 then
        heroData,heroCfg = self:getTeamCardDataByPos(currPos)
    elseif posType == 2 then
        heroData,heroCfg = self:getFriendCardDataByPos(currPos)
    end
    if heroData and heroCfg then
        tempText = "Trang bị này đang được" .. heroCfg:getNodeWithKey("name"):toStr() .. "dùng, xác nhận đổi？"
    else
        tempText = "Trang bị này đang dùng ở vị trí khác, xác nhận đổi?"
    end
    local t_params = 
    {
        title = string_config.m_title_prompt,
        okBtnCallBack = function(target,event)
            self.m_selMagicId = id;
            self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
            game_scene:removePopByName("game_magic_select_pop");
            game_util:closeAlertView();
            if posType == 1 then
                self:exchangeMagicPosDataByTwoPos(posIndex,currPos,sort,change_pos)
            elseif posType == 2 then
                self:exchangeTeamAndAssMagicPosDataByTwoPos(posIndex,currPos,sort,change_pos)
            end
            self.m_changeFlag = true;
            self:addTeamHeroPop(posIndex);
            self:newChainOpenAnim("magic");
        end,   --可缺省
        okBtnText = "Đổi trang bị",       --可缺省
        text = tempText,      --可缺省
    }
    game_util:openAlertView(t_params);
end
--[[--
    
]]
function game_adjustment_formation.addSelEquipUi(self,posIndex,sort)
    cclog("--------addSelEquipUi --------")
    if self.m_guide_step == 31 then
        if game_util.statisticsSendUserStep then game_util:statisticsSendUserStep(49) end-- 选择装备 新手引导32
    end
    game_scene:removeGuidePop();
    cclog("addSelEquipUi posIndex ==" .. tostring(posIndex))
    local btnCallFunc = function( target,event )
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if id then
                local existFlag,currPos,posType = self:equipInEquipPos(sort,id)
                local existFlag2,pos = game_data:equipInBonus(sort,id)
                if existFlag2 then
                    game_util:addMoveTips({text = "Nên ở trận Pháp trong thiết bị Vị trí số " .. pos-199})
                elseif existFlag then
                    -- self:updateEquipPosData(posIndex,sort,0);
                    -- cclog("itemOnClick remove id ==================== " .. id);
                    self:exchangeEquipPosAlert(posIndex,currPos,sort,id,posType);
                else
                    self.m_selEquipId = id;
                    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                    game_scene:removePopByName("game_equip_select_pop");
                    cclog("itemOnClick changed id ==================== " .. id);
                    self:updateEquipPosData(posIndex,sort,id);
                    self.m_changeFlag = true;
                    self:addTeamHeroPop(posIndex);
                    self:newChainOpenAnim("equip");
                    local id = game_guide_controller:getCurrentId();
                    if id == 33 and self.m_back_btn then
                        game_guide_controller:gameGuide("show","2",34,{tempNode = self.m_back_btn})
                    end
                end
            end
        elseif typeName == "unload" then
            self:updateEquipPosData(posIndex,sort,"0");
            cclog("itemOnClick remove id ==================== ");
            self.m_changeFlag = true;
            self:addTeamHeroPop(posIndex);
            self:refreshCombatLabel("addSelEquipUi ");
        end
    end
    game_scene:addPop("game_equip_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = sort,openType = 2})
end


--[[

]]
function game_adjustment_formation.addSelMagicUi(self,posIndex,sort)
    cclog("--------addSelMagicUi --------")
    -- if self.m_guide_step == 31 then
    --     if game_util.statisticsSendUserStep then game_util:statisticsSendUserStep(49) end-- 选择装备 新手引导32
    -- end
    game_scene:removeGuidePop();
    cclog("addSelEquipUi posIndex ==" .. tostring(posIndex))
    local selSort
    if sort < 3 then
        selSort = 1
    else
        selSort = 0
    end
    local btnCallFunc = function( target,event )
    end
    local itemOnClick = function (typeName,id)
        -- cclog("typeName    --------------       " .. typeName)
        if typeName == "exchanged" then
            if id then
                local existFlag,currPos,posType,change_pos = self:magicInMagicPos(selSort,id)
                local existFlag2,pos,Type = game_data:magicInBonus(sort,id)
                if existFlag2 then
                    game_util:addMoveTips({text = "该法宝已在阵法" .. pos .. "号位中装备"}) 
                    return
                elseif existFlag then
                    -- self:updateEquipPosData(posIndex,sort,0);
                    -- cclog("itemOnClick remove id ==================== " .. id);
                    self:exchangeMagicPosAlert(posIndex,currPos,sort,id,posType,change_pos);
                else
                    self.m_selMagicId = id;
                    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                    game_scene:removePopByName("game_magic_select_pop");
                    cclog("itemOnClick changed id ==================== " .. id);
                    self:updateMagicPosData(posIndex,sort,id);
                    self.m_changeFlag = true;
                    self:addTeamHeroPop(posIndex);
                    self:newChainOpenAnim("magic");
                    local id = game_guide_controller:getCurrentId();
                    if id == 33 and self.m_back_btn then
                        game_guide_controller:gameGuide("show","2",34,{tempNode = self.m_back_btn})
                    end
                end
            end
        elseif typeName == "unload" then
            self:updateMagicPosData(posIndex,sort,"0");
            cclog("itemOnClick remove id ==================== ");
            self.m_changeFlag = true;
            self:addTeamHeroPop(posIndex);
            self:refreshCombatLabel("addSelEquipUi ");
        end
    end
    game_scene:addPop("game_magic_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = selSort,openType = 2})
end
--[[
    
]]
function game_adjustment_formation.exchangeGemPosAlert(self,posIndex,currPos,sort,id)
    if posIndex == currPos then 
                game_util:addMoveTips({text = "Đá quý này đang ở vị trí này!"});
        return 
    end
    local tempText = nil;
    local itemData,itemCfg = self:getTeamCardDataByPos(currPos)
    if itemData and itemCfg then
        tempText = "Đá quý này đang được" .. itemCfg:getNodeWithKey("name"):toStr() .. "dùng, xác nhận đổi?"
    else
        tempText = "Đá quý này đang dùng ở vị trí khác, xác nhận đổi?"
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
        okBtnText = "Đổi đá quý",       --可缺省
        text = tempText,      --可缺省
    }
    game_util:openAlertView(t_params);
end

--[[--
    
]]
function game_adjustment_formation.addSelGemUi(self,posIndex,sort)
    game_scene:removeGuidePop();
    cclog("addSelGemUi posIndex ==" .. tostring(posIndex) .. " ; sort = " .. tostring(sort))
    local btnCallFunc = function( target,event )
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if id then
                -- local existFlag,currPos = self:gemInGemPos(sort,id)
                -- if existFlag then
                    local gemCount,_ = game_data:getGemDataById(id);
                if gemCount < 0 then
                    self:exchangeGemPosAlert(posIndex,currPos,sort,id);
                else
                    self.m_selGemPos = sort;
                    game_scene:removePopByName("gem_system_select_pop");
                    cclog("itemOnClick changed id ==================== " .. id);
                    self:updateGemPosData(posIndex,sort,id);
                    self.m_changeFlag = true;
                    self:addTeamHeroPop(posIndex);
                    self:refreshCombatLabel("addSelGemUi exchanged");
                --     local id = game_guide_controller:getCurrentId();
                --     if id == 33 and self.m_back_btn then
                --         game_guide_controller:gameGuide("show","2",34,{tempNode = self.m_back_btn})
                --     end
                end
            end
        elseif typeName == "unload" then
            self:updateGemPosData(posIndex,sort,"0");
            cclog("itemOnClick remove id ==================== ");
            self.m_changeFlag = true;
            self:addTeamHeroPop(posIndex);
            self:refreshCombatLabel(" addSelGemUi unload ");
        end
    end
    game_scene:addPop("gem_system_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = sort,openType = 2})
end

--[[--
    刷新ui
]]
function game_adjustment_formation.refreshCombatLabel(self,source,tempBonusData)
    cclog2(source,"source ===========")
    -- if self.m_tempCombatValue == nil then
    --     self.m_tempCombatValue = game_util:getCombatValue()
    -- else
    --     local tempCombatValue = game_util:getCombatValue();
    --     if self.m_tempCombatValue ~= tempCombatValue then
    --         self.m_combat_label:setVisible(false);
    --         local function callBackFunc()
    --             self.m_combat_label:setVisible(true);
    --         end
    --         local anim_zhandouli = game_util:createEffectAnimCallBack("anim_zhandouli",1.0,false,callBackFunc);
    --         local pX,pY = self.m_combat_label:getPosition();
    --         anim_zhandouli:setPosition(ccp(pX + self.m_combat_label:getContentSize().width*0.5,pY))
    --         self.m_combat_label:getParent():addChild(anim_zhandouli,10);
    --     end
    --     self.m_tempCombatValue = tempCombatValue;
    -- end
    -- self.m_combat_label:setString(tostring(self.m_tempCombatValue));

    cclog2(self.m_tempCombatValue,"self.m_tempCombatValue==== ")
    if self.m_tempCombatValue == nil then
        cclog("-------1------")
        self.m_tempCombatValue = game_util:getCombatValue(tempBonusData)
        self.m_combatNumberChangeNode:setString(self.m_tempCombatValue,false);
    else
        cclog("-------2------")
        local tempCombatValue = game_util:getCombatValue(tempBonusData);
        local changeValue = tempCombatValue - self.m_tempCombatValue
        self.m_tempCombatValue = tempCombatValue;
        self.m_combatNumberChangeNode:setString(self.m_tempCombatValue,false);
        game_util:combatChangedValueAnim({combatNode = self.m_combatNumberChangeNode:getParent(),currentValue = tempCombatValue,changeValue = changeValue});
    end
end

--[[--
    刷新ui
]]
function game_adjustment_formation.refreshUi(self)
    self:initTeamFormation(self.m_formation_layer);
    self:refreshCombatLabel("refreshUi");
    local id = game_guide_controller:getCurrentId();
    if id ~= 30 then
        if self.m_posIndex ~= -1 then
            self:refreshHeroInfo(self.m_posIndex);
        else
            self.m_posIndex = self.m_tempSelIndex;
            self:refreshHeroInfo(self.m_tempSelIndex);
        end
    end
end

-- 刷新血石
function game_adjustment_formation:refreshBloodStone()
    local equipPosData = nil
    cclog2(self.m_teamIndex,"self.m_teamIndex-0------>")
    if self.m_teamIndex == 1 then
        equipPosData = self.m_tempEquipPosData[self.m_posIndex]
    elseif self.m_teamIndex == 2 then
        equipPosData = self.m_tempAssEquipPosData[tostring(self.m_posIndex+99)]
    end
    cclog2(equipPosData,"equipPosData------->")
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

function game_adjustment_formation.refreshBadge(self)
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
function game_adjustment_formation.init(self,t_params)
    t_params = t_params or {};
    self.m_teamPosNodeTab = {};
    -- body
    self.m_openType = t_params.openType or self.m_openType;
    --cclog2(t_params.changeFlag,"t_params.changeFlag")
    cclog2(self.m_openType,"self.m_openType-=-----------")
    cclog2(t_params,"t_params-=-----------")
    self.m_changeFlag = t_params.changeFlag or false
    self.m_posIndex = -1;
    self.m_tempSelIndex = -1;
    self.m_tempTeamData = {};
    self.m_tempFriendData = {}; 
    self.m_tempEquipPosData = {};
    self.m_tempGemPosData = {};
    self.m_tempSaintStonePosData={};
    self.m_tempMedalPosData = {};
    self.m_tempSoulPosData = {};
    self.m_zhuanshiData = t_params.zhuanshiData or {}
    self.m_tempMagicPosData = {};
    local formationData = game_data:getFormationData();
    -- cclog2(formationData,"formationData is")
    local ownFormation = formationData.own
    local ownFormationCount = #ownFormation
    self.m_currentFormationId = formationData.current
    --cclog("self.m_currentFormationId=====" .. self.m_currentFormationId);
    self.m_selFormationId = self.m_currentFormationId;

    local teamData = game_data:getTeamData();
    local friendData = game_data:getAssistant();
    local tempEquipPosData = game_data:getEquipPosData()
    local tempGemPosData = game_data:getGemPosData();
    local tempMedalPosData = game_data:getMedalPos()
    local tempSaintStonePosData=game_data:getSaintStonePosData()
    local tempSoulPosData = game_data:getSoulPos()
    local tempMagicPosData = game_data:getMagicPosData()
    local formationConfig = getConfig(game_config_field.formation);
    -- cclog2(formationConfig,"formationConfig is")
    local itemCfg = formationConfig:getNodeWithKey(tostring(self.m_selFormationId));
     --cclog2(itemCfg,"itemCfg is")
    local tempTag = 1;
    local iValue = nil;
    if itemCfg ~= nil then
        for i=1,#formationPosTab do
            local formationPosTabItem = formationPosTab[i];
            -- cclog(itemCfg:getFormatBuffer())
            -- cclog("formationPosTabItem.key =========" .. formationPosTabItem.key .. " ; itemCfg = " .. tostring(itemCfg))
            iValue = itemCfg:getNodeWithKey(formationPosTabItem.key):toInt();
            if iValue ~= 0 and tempTag < 7 then
                self.m_tempTeamData[i] = teamData[tempTag]
                self.m_tempEquipPosData[i] = util.table_copy(tempEquipPosData[tostring(tempTag-1)]);
                self.m_tempGemPosData[i] = util.table_copy(tempGemPosData[tostring(tempTag-1)]);
                self.m_tempMedalPosData[i] = util.table_copy(tempMedalPosData[tostring(tempTag-1)])
                self.m_tempSoulPosData[i] = util.table_copy(tempSoulPosData[tostring(tempTag-1)])
                self.m_tempSaintStonePosData[i] = util.table_copy(tempSaintStonePosData[tostring(tempTag-1)]);
                self.m_tempMagicPosData[i] = util.table_copy(tempMagicPosData[tostring(tempTag-1)]); 
                tempTag = tempTag + 1;
            else
                self.m_tempTeamData[i] = "-1";
                self.m_tempEquipPosData[i] = {"0","0","0","0"}
                self.m_tempGemPosData[i] = {"0","0","0","0"}
                self.m_tempMedalPosData[i] = {"0","0","0","0","0","0"}
                self.m_tempSoulPosData[i] = {"0","0","0","0","0","0"}
                self.m_tempSaintStonePosData[i] = {"0","0","0","0","0"}
                self.m_tempMagicPosData[i] = {"0","0","0","0"}
            end
        end
    end
    for i=6,8 do
        self.m_tempTeamData[i+1] = teamData[i];
        self.m_tempEquipPosData[i+1] = util.table_copy(tempEquipPosData[tostring(i-1)]);
        self.m_tempGemPosData[i+1] = util.table_copy(tempGemPosData[tostring(i-1)]);
        self.m_tempMedalPosData[i+1] = util.table_copy(tempMedalPosData[tostring(i-1)])
        self.m_tempSoulPosData[i+1] = util.table_copy(tempSoulPosData[tostring(i-1)])
        self.m_tempSaintStonePosData[i+1] = util.table_copy(tempSaintStonePosData[tostring(i-1)]);
        self.m_tempMagicPosData[i+1] = util.table_copy(tempMagicPosData[tostring(i-1)]); 
    end
    game_data:setRightTeamData(self.m_tempTeamData)
    game_util:getFormationPos()
    self.m_tempFriendData = friendData;
    self.m_tempDestinyData = game_data:getDestiny();
    self.m_tempAssEquipPosData = game_data:getAssEquipPosData()
    self.m_tempAssMagicPosData = game_data:getAssMagicPosData()
    local cardNumData = game_data:getBattleCardNumData()
    local maxCount1,maxCount2 = cardNumData.position_num or 2,cardNumData.alternate_num or 0;
    self.m_openTab = TEAM_POS_OPEN_TAB["open" .. maxCount1 .. maxCount2] or {};
    -- table.foreach(self.m_tempTeamData,print)
    -- for i=1,9 do
    --     cclog(" i ================= " .. i)
    --     table.foreach(self.m_tempEquipPosData[i],print)
    -- end
    self.m_tempSelIndex = -1;
    self.m_tempCombatValue = nil;
    self.m_teamIndex = 1;
    self.m_ability2OpenFlag = game_data:isViewShowByID(145)
    self.m_teamGemOpenFlag = game_data:isViewShowByID(129)
    self.allUniverseEffect = game_util:getAllUniverseEffect()

    self.m_showMore_flag=false
end

--[[--
    创建ui入口并初始化数据
]]
function game_adjustment_formation.create(self,t_params)
    -- body
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    local id = game_guide_controller:getCurrentId();
    if id == 19 and self.m_guildNode then
        game_guide_controller:gameGuide("show","1",20,{tempNode = self.m_guildNode})
    elseif id == 30 and self.m_guildNode then
        if game_data.setGuideProcess then game_data:setGuideProcess("guide_second") end
        game_guide_controller:gameGuide("show","2",31,{tempNode = self.m_guildNode})
    elseif id == 47 and self.m_guildNode then
        game_guide_controller:gameGuide("show","3",48,{tempNode = self.m_guildNode})
    elseif id == 50 then
        game_guide_controller:gameGuide("show","3",50,{tempNode = self.m_guildNode})
    else
        if game_guide_controller:getFormationGuideIndex() == 2 then
            cclog("game_guide_controller:getFormationGuideIndex() == 2")
            game_guide_controller:setFormationGuideIndex(3)
            local function onTouch(eventType, x, y)
                if eventType == "began" then
                    return true;--intercept event
                end
            end
            self.m_root_layer:registerScriptTouchHandler(onTouch,false,-999,true);
            self.m_root_layer:setTouchEnabled(true);
            local startNode = self.m_ccbNode:spriteForName("m_pos_5")
            local endNode = self.m_ccbNode:spriteForName("m_pos_3")
            local yindao_shouzhi = game_util:createImpactAnim("yindao_shouzhi",1)
            yindao_shouzhi:pause();
            local pX,pY = startNode:getPosition();
            local startPos = startNode:getParent():convertToWorldSpace(ccp(pX,pY));
            local pX,pY = endNode:getPosition();
            local endPos = endNode:getParent():convertToWorldSpace(ccp(pX,pY));
            local animCount = 0;
            local function moveFunc()
                local function animCallbackFunc(node)
                    if animCount == 0 then
                        moveFunc();
                        self.m_root_layer:setTouchEnabled(false);
                    elseif animCount == 3 then
                        yindao_shouzhi:removeFromParentAndCleanup(true);
                    else
                        moveFunc();
                    end
                    animCount = animCount + 1;
                end
                yindao_shouzhi:setPosition(startPos);
                local animArr = CCArray:create();
                animArr:addObject(CCMoveTo:create(1,endPos));
                animArr:addObject(CCCallFuncN:create(animCallbackFunc));
                yindao_shouzhi:runAction(CCSequence:create(animArr));
            end
            moveFunc();
            game_scene:getPopContainer():addChild(yindao_shouzhi)
        end
    end

    local id = game_guide_controller:getIdByTeam("65");
    -- id = 6501
    -- print("game_guide_controller:getIdByTeam(65)", id)
    if id == 6501 then
        -- self:gameGuide("drama","65",6501)
        game_guide_controller:showGuide("65", 6501,{tempNode = self.m_tab_btn_2})
    end

    return scene;
end

--[[
    自动穿装备
]]
function game_adjustment_formation.autoMatchEquip( self, cardIndex )
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
            if equipSort and not self:isEquipCanUse(cardIndex, v, equipSort) then
                -- cclog2(" 这个装备属于 别人装备的")
                canUseFlag = false
            end
            if itemData.bind_card and itemData.bind_card ~= "" then
                canUseFlag = false
            end
            local existFlag2,pos = game_data:equipInBonus(equipSort,tostring(v))
            if existFlag2 then
                canUseFlag = false
            end 
            --是否是主角装备
            if itemCfg:getNodeWithKey("is_mainhero") and itemCfg:getNodeWithKey("is_mainhero"):toInt() ~= 0 then
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
            self:newChainOpenAnim("equip");

        for i=1,4 do
            if recommendEquip[i] ~= "0" and recommendEquip[i] ~= curPosEquip[i] then
                self.m_selEquipId = curPosEquip[i];
                self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                self:updateEquipPosData(cardIndex,i,recommendEquip[i]);
                self.m_changeFlag = true;
                self:addTeamHeroPop(cardIndex);
                self:newChainOpenAnim("equip");
            end
        end
        -- cclog2(self.m_tempEquipPosData, "all equip info m_tempEquipPosData   ===   ")
        -- cclog2(recommendEquipData, "推荐装备信息是  ==========  ")
    elseif self.m_teamIndex == 2 then
         local cardData,cardCfg = self:getFriendCardDataByPos( cardIndex  );
        if not cardCfg then return end

        local curPosEquip = self.m_tempAssEquipPosData[tostring(cardIndex + 99)]
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
        local noExchangeTab = {1,1,1,1}
        for i,v in ipairs(equipTable) do
            itemData, itemCfg = game_data:getEquipDataById(tostring(v));
            -- cclog2(itemData, tostring(i) .. "auto equip  itemData  =====   ")
            -- cclog2(itemCfg, tostring(i) .. "auto equip  itemCfg  =====   ")
            local equipSort = itemCfg:getNodeWithKey("sort") and itemCfg:getNodeWithKey("sort"):toInt() or 0
            local canUseFlag = true
            if equipSort and not self:isEquipCanUse(cardIndex, v, equipSort) then
                -- cclog2(" 这个装备属于 别人装备的")
                canUseFlag = false
            end
            if itemData.bind_card and itemData.bind_card ~= "" then
                canUseFlag = false
            end
            local existFlag2,pos = game_data:equipInBonus(equipSort,tostring(v))
            if existFlag2 then
                canUseFlag = false
            end
            if itemCfg:getNodeWithKey("is_mainhero") and itemCfg:getNodeWithKey("is_mainhero"):toInt() ~= 0 then
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
        if cardData.bind_equip and next(cardData.bind_equip) then
            for k,v in pairs(cardData.bind_equip) do
                if v ~= 0 then
                    for i=1,4 do
                        if tonumber(curPosEquip[i]) == v then
                            noExchangeTab[i] = 0
                        end
                    end
                end
            end
        end
        for i=1,4 do
            if recommendEquip[i] ~= "0" and recommendEquip[i] ~= curPosEquip[i] and noExchangeTab[i] ~= 0 then
                self.m_selEquipId = curPosEquip[i];
                self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                self:updateAssEquipPosData(cardIndex,i,recommendEquip[i]);
                self.m_changeFlag = true;
                self:addTeamHeroPop(cardIndex);
                self:newChainOpenAnim("equip");
            end
        end
        -- self:autoMatchFateEquip(cardData.id,cardIndex)
    end
end

--[[
    -- 判断装备是否被别人装备上了
    -- poxIndex 卡牌位置
    -- equipId 装备id
    -- equipSortIndex 装备的sort
]]
function game_adjustment_formation.isEquipCanUse( self, posIndex, equipId, equipSortIndex )
    local tempEquipTable = nil
    for k,v in pairs(self.m_tempEquipPosData) do
        -- print(k, v, posIndex, " k   v   posIndex =======   ")
        if self.m_teamIndex == 2 or tostring(k) ~= tostring(posIndex) then
            v = v or {}
            -- cclog2(v[equipSortIndex], "v[equipSortIndex]   ==   ")
            -- cclog2(equipId, "equipId  ====  ")
            if v[equipSortIndex] == equipId then
                return false
            end
        end
    end

    if self.m_teamIndex == 2 then posIndex = tostring(posIndex + 99) end
    for k,v in pairs(self.m_tempAssEquipPosData) do
        -- print(k, v, posIndex, " k   v   posIndex =======   ")
        if self.m_teamIndex == 1 or tostring(k) ~= tostring(posIndex) then
            v = v or {}
            -- cclog2(v[equipSortIndex], "v[equipSortIndex]   ==   ")
            -- cclog2(equipId, "equipId  ====  ")
            if v[equipSortIndex] == equipId then
                return false
            end
        end
    end
    return true
end


--[[
    新手引导
]]
function game_adjustment_formation.gameGuide(self,guideType,guide_team,guide_id,t_params)
    if not game_guide_controller:getGuideCompareFlag(guide_team,guide_id) then return end
    local id = game_guide_controller:getId(guide_team,guide_id);
    -- id = 6501
    t_params = t_params or {};
    if guideType == "drama" then
        if guide_team == "65" and id == 6501 then
            local function endCallFunc()
                game_guide_controller:gameGuide("send","65",6502);
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        end
    end
end

--[[--
    初始化阵型
]]
function game_adjustment_formation:initTeam(  )
    -- body
    self.node_bloodDetal:setVisible(false)
    self.m_tab_btn_1:setEnabled(false);
    self.m_tab_btn_2:setEnabled(true);
    self.m_tab_btn_3:setEnabled(true);

    self.m_adjust1:setVisible(true);
    self.m_medal_btn:setVisible(true)
    self.m_soul_btn:setVisible(true)
    self.nd_badge:setVisible(false)
    self.btn_badge:setVisible(true)

    
    self.m_adjust2:setVisible(false);
    self.m_equip_layer:setVisible(true);

    -- self:createAnim(true)
    self.m_eq_layer:setVisible(true)
    self.m_magic_layer:setVisible(game_data:isViewShowByID(201))
    local wx,wy = self.m_fate_node1:getPosition() 
    self.m_magic_layer:setPositionY(wy)
    if not self.m_teamGemOpenFlag then 
        self.m_gem_layer:setVisible(false);
        -- self.m_equip_layer:setPositionY(80)
    else
        self.m_gem_layer:setVisible(true);
    end
    local _,wy1 = self.m_fate_node1:getPosition()
    local _,wy2 = self.m_fate_node5:getPosition()
    self.m_spr_mingyunnode:setPositionY(wy1+5)
    self.m_fate_node:setPositionY(wy2)
    self.m_activation_node:setVisible(false);
    self.m_title_node:setVisible(true)
    -- self.m_fate_label:setVisible(false);
    self.m_fate_detail_node:setVisible(false);
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

    self.m_medal_btn:setVisible(false)
    self.m_soul_btn:setVisible(false)
    self.m_saint_stone_btn:setVisible(false)
    self.m_sp_btn_back:setVisible(false)
    self.m_btn_show_more:setVisible(true)
    self.m_showMore_flag=false
end

--[[--
    初始化助威
]]
function game_adjustment_formation:initFriend(  )
    -- body
    self.m_tab_btn_1:setEnabled(true);
    self.m_tab_btn_2:setEnabled(false);
    self.m_tab_btn_3:setEnabled(true);
    self.node_bloodDetal:setVisible(false)
    self.nd_badge:setVisible(false)
    self.btn_badge:setVisible(false)

    -- self.m_adjust1:setVisible(true);
    -- self.m_adjust2:setVisible(false);
    if not self.m_ability2OpenFlag then 
        self.m_equip_layer:setVisible(false);
    else
        self.m_equip_layer:setVisible(true);
        self.m_eq_layer:setVisible(true)
        self.m_magic_layer:setVisible(game_data:isViewShowByID(201))
        local wx,wy = self.m_fate_node2:getPosition() 
        self.m_magic_layer:setPositionY(wy)
        -- self:createAnim(true)
    end
    self.m_gem_layer:setVisible(false);
    self.m_activation_node:setVisible(true);
    self.m_title_node:setVisible(false)
    -- self.m_fate_label:setVisible(false);
    self.m_fate_detail_node:setVisible(false);
    -- local tempSize = self.m_fate_detail_node:getContentSize();
    -- tempSize = CCSizeMake(tempSize.width,140);
    -- self.m_fate_detail_node:setContentSize(tempSize);
    -- self.m_fate_detail_node:removeAllChildrenWithCleanup(true);
    -- local scrollView = CCScrollView:create(tempSize);
    -- scrollView:setDirection(kCCScrollViewDirectionVertical);
    -- self.m_fate_detail_node:addChild(scrollView,2,2);
    -- self.m_oneFateScrollView = scrollView;
    self:clearFateTabView();
    self.m_teamIndex = 2;
    self:initFriendFormation(self.m_formation_layer);    
    self.m_sel_bg:setVisible(true);
    self.m_posIndex = self.m_tempSelIndex;
    self:refreshHeroInfo(self.m_posIndex);
    self.m_medal_btn:setVisible(false)
    self.m_soul_btn:setVisible(false)
    if self.m_posIndex == -1 then
        self:refreshFriendScroll();
        self:refreshFateSummaryTableView();
        self.m_adjust1:setVisible(false);
        self.m_adjust2:setVisible(true);
    else
        self.m_adjust1:setVisible(true);
        self.m_adjust2:setVisible(false);
    end
    self.m_saint_stone_btn:setVisible(false)
    self.m_sp_btn_back:setVisible(false)

end

--[[--
    初始化命运小伙伴
]]
function game_adjustment_formation:initDestinyTeam(  )
    -- body
    self.m_tab_btn_1:setEnabled(true);
    self.m_tab_btn_2:setEnabled(true);
    self.m_tab_btn_3:setEnabled(false);
    self.m_adjust1:setVisible(false);
    self.m_adjust2:setVisible(true);
    self.m_title_node:setVisible(false)
    self.node_bloodDetal:setVisible(false)
    self.nd_badge:setVisible(false)
    self.m_teamIndex = 3;
    self:initDestinyFormation(self.m_formation_layer);
    self:refreshFriendScroll();
    self:refreshFateSummaryTableView();
    self.m_equip_layer:setTouchEnabled(false);
    if self.isVisible == nil then 
        self.isVisible = self.m_eq_layer:isVisible()
    end
    self.m_eq_layer:setVisible(false)
    self.m_magic_layer:setVisible(false)
    self.m_sel_bg:setVisible(false);
end

------------------------------------- 助威 start -------------------------------------------
--[[--
    初始化小伙伴页面
]]
function game_adjustment_formation:initFriendFormation( formation_layer )
    self.m_tempSelIndex = -1
    local level = game_data:getUserStatusDataByKey("level");
    local itemIcon = nil;
    local headIconSpr = nil;
    local tempLock = nil;
    local character_detail_cfg = getConfig("character_detail");
    local tempLockIndex,selLevel = -1,100;
    local smallTag1 = 1;
    local smallTag2 = 7;
    local tempTxt = nil;
    local assistant_cfg = getConfig(game_config_field.assistant);
    local sort = 0;
    for i=1,9 do
        local assistant_cfg_item = assistant_cfg:getNodeWithKey(tostring(i))
        sort = assistant_cfg_item:getNodeWithKey('sort'):toInt();
        itemIcon = self.m_ccbNode:spriteForName("m_pos_" .. i)
        formation_layer:reorderChild(itemIcon,-1000)
        local headIconBgSize = itemIcon:getContentSize();
        local pX,pY = headIconBgSize.width/2,headIconBgSize.height/2
        itemIcon:removeAllChildrenWithCleanup(true);
        self:refreshFriendPositionAttr(i, assistant_cfg_item)
        if self.m_tempFriendData[i] ~= "-1" then
            if(sort == 1)then
                smallTag1 = i+1;   
            else
                smallTag2 = i+1;
            end
        else
            tempLock = CCSprite:createWithSpriteFrameName("dw_suo.png");
            tempLock:setPosition(ccp(pX,pY));
            itemIcon:addChild(tempLock);
            if(smallTag1 == i and i < 7)then
                local spriteTxt = CCSprite:createWithSpriteFrameName("dw_dianjiwenzi.png");
                spriteTxt:setPosition(ccp(pX,pY));
                itemIcon:addChild(spriteTxt,3,3);
            end
            if(smallTag2 == i and i > 6)then
                local spriteTxt = CCSprite:createWithSpriteFrameName("dw_dianjiwenzi.png");
                spriteTxt:setPosition(ccp(pX,pY));
                itemIcon:addChild(spriteTxt,3,3);
            end
        end
        --全命运开启效果
        --createCardAnimByFriendPos 是助阵的
        -- local backAnimNode = self:createCardAnimByFriendPos(i)--全命运后面的动画
        local animNode = self:createCardAnimByFriendPos(i,false)
        if animNode then
            -- backAnimNode:setScale(2)
            -- backAnimNode:setPosition(ccp(pX,headIconBgSize.height*0.1));
            -- backAnimNode:setColor(ccc3(255,255,0))
            -- itemIcon:addChild(backAnimNode,1,2)
            animNode:setPosition(ccp(pX,headIconBgSize.height*0.1));
            itemIcon:addChild(animNode,1,1);
            if self.m_tempSelIndex == -1 then
                self.m_tempSelIndex = i;
            end
        end
        self:setPositionBg2(i);
    end
    self:initFriendFormationTouch(self.m_formation_layer);
    self:initFriendEquipLayerTouch(self.m_eq_layer);
    self:initFriendMagicLayerTouch(self.m_magic_layer);
    if self.m_eq_layer:isVisible() then
        self.m_eq_layer:setTouchEnabled(true)
        self.m_magic_layer:setTouchEnabled(true)
    else
        self.m_eq_layer:setTouchEnabled(false)
        self.m_magic_layer:setTouchEnabled(false)
    end
end
--[[
    
]]
function game_adjustment_formation.refreshFriendPositionAttr( self, posIndex, assistant_cfg_item)
    local assistantEffect = game_data:getAssistantEffect()
    local assistantEffectItem = assistantEffect[posIndex] or {}
    local active_status = assistantEffectItem.active_status or "-1" -- "-1"未激活 "0" 激活
    local cardId = self.m_tempFriendData[posIndex] or ""
    if active_status == "-1" or cardId == "0" then return end
    if assistant_cfg_item == nil then
        local assistant_cfg = getConfig(game_config_field.assistant);
        assistant_cfg_item = assistant_cfg:getNodeWithKey(tostring(posIndex))
    end
    local itemIcon = self.m_ccbNode:spriteForName("m_pos_" .. posIndex)
    local headIconBgSize = itemIcon:getContentSize();
    local pX,pY = headIconBgSize.width/2,headIconBgSize.height/2
    -- local att_value = assistant_cfg_item:getNodeWithKey("att_value")
    -- att_value = att_value and att_value:toInt() or 0;
    -- local cardlimit = assistant_cfg_item:getNodeWithKey("cardlimit")
    -- cardlimit = cardlimit and cardlimit:toInt() or 0;
    -- local att_type = assistant_cfg_item:getNodeWithKey("att_type")
    -- att_type = att_type and att_type:toInt() or 0;
    -- local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. att_type] or {};
    -- local tempBg = CCScale9Sprite:createWithSpriteFrameName("public_selectBg.png");
    -- tempBg:setPreferredSize(CCSizeMake(headIconBgSize.width, 14));
    -- tempBg:setPosition(ccp(pX,10))
    -- itemIcon:addChild(tempBg,10,10)
    -- local color = active_status == "-1" and ccc3(177, 177, 177) or ccc3(0, 255, 0)
    -- local tempLabel = game_util:createLabelTTF({text = tostring(abilityItem.name) .. "增加",color = color,fontSize = 8});
    -- tempLabel:setPosition(ccp(pX,10))
    -- itemIcon:addChild(tempLabel,11,11)
    local tempSpriteFrameBg = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_heitiao.png")
    if tempSpriteFrameBg then
        local tempSpriteBg = CCSprite:createWithSpriteFrame(tempSpriteFrameBg)
        tempSpriteBg:setAnchorPoint(ccp(1,0))
        tempSpriteBg:setPosition(ccp(pX*2,0))
        itemIcon:addChild(tempSpriteBg,12,12)
    end
    local assAttrValueTab,_,_ = game_util:getAssistantAttrTab(posIndex, assistantEffectItem, assistant_cfg_item, false)
    local index = 1
    for i=1,#assAttrValueTab do
        local attrValueItem = assAttrValueTab[i]
        local att_name = attrValueItem.att_name or ""
        local open = attrValueItem.open or 0
        local active = attrValueItem.active or 1
        if open > 0 and active > 0 and (att_name ~= "ability2" or (att_name == "ability2" and self.m_ability2OpenFlag)) then
            local temp_att_type = attrValueItem.att_type or 0
            local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_attr_up_" .. temp_att_type .. ".png")
            if tempSpriteFrame then
                local tempSprite = CCSprite:createWithSpriteFrame(tempSpriteFrame)
                tempSprite:setPosition(ccp(pX*2-9,70-18*index))
                itemIcon:addChild(tempSprite,13,13)
                index = index + 1
            end
        end
    end
end

--[[
    助威阵型触摸
]]
function game_adjustment_formation.initFriendFormationTouch( self,formation_layer )
    -- body
    local beganItem,selItem = nil,nil
    local touchBeginPoint = nil
    local touchMoveFlag = false;
    local function onTouchBegan( x,y )
        if selItem then
            selItem:removeFromParentAndCleanup(true);
            selItem = nil;
        end
        touchMoveFlag = false
        touchBeginPoint = {x = x, y = y}
        local realPos = formation_layer:convertToNodeSpace(ccp(x,y));
        -- CCTOUCHBEGAN event must return true
        for tag = 1,9 do
            beganItem = self.m_ccbNode:spriteForName("m_pos_" .. tag)
            if beganItem and beganItem:boundingBox():containsPoint(realPos) then
                selItem = self:createCardAnimByFriendPos(tag,false)
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
    local function onTouchMoved( x,y )
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            if selItem then
                local realPos = formation_layer:convertToNodeSpace(ccp(x,y));
                selItem:setPosition(realPos);
                selItem:setVisible(true);
            end
            touchMoveFlag = true;
        end
    end
    local function onTouchEnded( x,y )
        local realPos = formation_layer:convertToNodeSpace(ccp(x,y));
        local smallTag1 = 9;
        local smallTag2 = 9;
        local assistant_cfg = getConfig(game_config_field.assistant);
        local sort = 0

        for endTag = 1,9 do
            local assistant_cfg_item = assistant_cfg:getNodeWithKey(tostring(endTag))
            sort = assistant_cfg_item:getNodeWithKey('sort'):toInt();
            local tempid = self.m_tempFriendData[endTag]
            if tempid == "-1" then
                if(sort == 1)then
                    smallTag1 = math.min(smallTag1,endTag);
                else
                    smallTag2 = math.min(smallTag2,endTag);
                end
            end
            endItem = self.m_ccbNode:spriteForName("m_pos_" .. endTag)
            if endItem and endItem:boundingBox():containsPoint(realPos) then
                local beganTag = beganItem:getTag();
                if(endTag == beganTag)then
                    if tempid == "-1" then
                        if(smallTag1 == endTag or smallTag2 == endTag)then
                            local t_params = {}
                            t_params.okBtnCallBack = function()
                                local function responseMethod(tag,gameData)
                                    game_util:addMoveTips({text = "Mở thành công!"});--成功开启！
                                    local assistantData = game_data:getAssistant();
                                    local tempData = util.table_copy(self.m_tempFriendData)
                                    self.m_tempFriendData = assistantData
                                    for k,v in pairs(tempData) do
                                        if v ~= "-1" then
                                            self.m_tempFriendData[k] = v;
                                        end
                                    end
                                    self:initFriendFormation(self.m_formation_layer);
                                    game_scene:removePopByName("game_assistant_pop");
                                end
                                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_activate_assistant"), http_request_method.GET, {position = endTag-1},"cards_activate_assistant")
                            end
                            t_params.index = endTag
                            game_scene:addPop("game_assistant_pop",t_params)
                        end
                    -- elseif tempid == "0" then
                    --     self:addFriendSelHeroUi(endTag);
                    else
                        self.m_posIndex = endTag;
                        self:setPositionBg2(endTag,true);
                        self:refreshHeroInfo(endTag);
                    end
                else
                    if selItem then
                        if tempid == "-1" then--未开启
                            game_util:addMoveTips({text = "Vị trí trợ uy chưa mở!"})--助威位置未开启！
                        else
                            self:exchangeFriendDataByTwoPos(beganTag,endTag)
                            self.m_changeFlag = true;
                            local bgSize = endItem:getContentSize();
                            beganItem:removeAllChildrenWithCleanup(true)
                            local animNode = self:createCardAnimByFriendPos(beganTag,false)
                            if animNode then
                                animNode:setPosition(ccp(bgSize.width*0.5,bgSize.height*0.1));
                                beganItem:addChild(animNode,1,1)
                            end
                            self:setPositionBg2(beganTag)
                            self:refreshFriendPositionAttr(beganTag)
                            endItem:removeAllChildrenWithCleanup(true)
                            local animNode = self:createCardAnimByFriendPos(endTag,false)
                            if animNode then
                                animNode:setPosition(ccp(bgSize.width*0.5,bgSize.height*0.1));
                                endItem:addChild(animNode,1,1)
                            end
                            self:setPositionBg2(endTag)
                            self:refreshFriendPositionAttr(endTag)
                            self.m_posIndex = endTag;
                            self:refreshHeroInfo(endTag);
                            self:refreshCombatLabel("initFriendFormationTouch");
                        end
                    end
                end
                break;
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
function game_adjustment_formation.addFriendSelHeroUi(self,posIndex)
    cclog("------addFriendSelHeroUi----")

    game_scene:removeGuidePop();
    cclog("addSelHeroUi posIndex ==" .. tostring(posIndex))
    local btnCallFunc = function( target,event )
        
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if (not game_util:heroInTeamById(id,self.m_tempTeamData)) and (not game_data:heroInAssistantById(id))  and (not game_util:isInFormationBonus(id)) then
                cclog("itemOnClick id ==================== " .. id);
                self:updateFriendData(posIndex,id);
                self.m_changeFlag = true;
                self:initFriendFormation(self.m_formation_layer);
                self.m_posIndex = posIndex;
                self:refreshHeroInfo(posIndex,true);
                self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                self:newChainOpenAnim("card");
            end
        elseif typeName == "unload" then
            self.m_magic_node:setVisible(false)

            local tempId = self.m_tempFriendData[posIndex]
            -- if self:getUnloadPosFlag(posIndex) == 0 then
            if tempId ~= "-1" and tempId ~= "0" then
                self:updateFriendData(posIndex,"0");
                self.m_changeFlag = true;
                self:initFriendFormation(self.m_formation_layer);
                self.m_posIndex = -1;
                self:refreshHeroInfo(posIndex,true);
                self:refreshCombatLabel("addFriendSelHeroUi");
            end
        end

    end
    game_scene:addPop("game_hero_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,openType = 2})
end

function game_adjustment_formation:updateFriendData( posIndex,cardId )
    -- body
    self.m_tempFriendData[posIndex] = cardId;
    if cardId == "0" or cardId == "-1" then
        self.m_tempAssMagicPosData[tostring(posIndex+99)] = {"0","0","0","0"}
    end
    -- self:setFriendFormationData();
end

function game_adjustment_formation:exchangeFriendDataByTwoPos( posIndex1,posIndex2 )
    -- body
    self.m_tempFriendData[posIndex1],self.m_tempFriendData[posIndex2] = self.m_tempFriendData[posIndex2],self.m_tempFriendData[posIndex1];
    posIndex1 = tostring(posIndex1+99)
    posIndex2 = tostring(posIndex2+99)
    self.m_tempAssEquipPosData[posIndex1],self.m_tempAssEquipPosData[posIndex2] = self.m_tempAssEquipPosData[posIndex2],self.m_tempAssEquipPosData[posIndex1]
    -- self:setFriendFormationData();
end

function game_adjustment_formation:setFriendFormationData(  )
    -- body
    -- cclog("self.m_tempFriendData = " .. json.encode(self.m_tempFriendData))
end

--[[--
    获得卡牌配置以及数据
]]
function game_adjustment_formation:getFriendCardDataByPos( posIndex )
    -- body
    return game_data:getCardDataById(self.m_tempFriendData[posIndex])
end
--[[
    获取小伙伴位置上的动画
]]
function game_adjustment_formation:createCardAnimByFriendPos( posIndex , animFlag)
    -- body
    local heroData,heroCfg = self:getFriendCardDataByPos(posIndex);
    return self:createCardAnimByData(heroData,heroCfg,animFlag)
end
--[[--
    助威装备层
]]
function game_adjustment_formation.initFriendEquipLayerTouch(self,formation_layer)
    local touchBeginPoint = nil;
    local touchMoveFlag = false;
    local tempItem = nil;
    local realPos = nil;
    local tag = nil;
    local function onTouchBegan(x, y)
        touchMoveFlag = false;
        -- cclog("onTouchBegan: %0.2f, %0.2f", x, y)
        touchBeginPoint = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    local function onTouchMoved(x, y)
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            touchMoveFlag = true;
        end
    end
    
    local function onTouchEnded(x, y)
        if formation_layer:isVisible() == true then
            realPos = formation_layer:convertToNodeSpace(ccp(x,y));
            for i = 1,8 do
                tempItem = self.m_ccbNode:spriteForName("m_equip_" .. i)  
                if tempItem:boundingBox():containsPoint(realPos) then
                    tag = tempItem:getTag();
                    if self.m_posIndex == -1 or self.m_tempAssEquipPosData[tostring(self.m_posIndex+99)] == "-1" then
                        game_util:addMoveTips({text = string_config:getTextByKey("m_onclick_team_pos")});
                        return;
                    end
                    -- cclog2(tag, "tag   ===   ")
                    if tag < 20 then
                        -- cclog("sel Equip tag 1=======================" .. tag);
                        local openFlag = true;--game_button_open:getOpenFlagByBtnId("705" .. self.m_posIndex .. (tag-10));
                        if openFlag then
                            local tempData = self.m_tempAssEquipPosData[tostring(self.m_posIndex+99)] or {}
                            local tempEquipId = tempData[tag - 10] or "0"--self:getPosEquipId(self.m_posIndex,tag - 10);
                            if tempEquipId == nil or tostring(tempEquipId) == "0" then
                                self:addSelAssEquipUi(self.m_posIndex,tag - 10);
                            else
                                tempEquipId = tostring(tempEquipId);
                                local itemData = game_data:getEquipDataById(tempEquipId)
                                local function callBack(typeName,t_param)
                                    if typeName == "unload" then
                                        self:addSelAssEquipUi(self.m_posIndex,tag - 10);
                                    elseif typeName == "strengthen" then
                                        self.m_openType = "equip_strengthen"
                                        self:sendChangedData(1);
                                    elseif typeName == "evolution" then
                                        self.m_openType = "equip_evolution"
                                        self:sendChangedData(1);
                                    elseif typeName == "fateEquipLock" then
                                        self:refreshCombatLabel();
                                        self:refreshEquipPos(self.m_posIndex)
                                        self:refreshMagicPos(self.m_posIndex)
                                        self:refreshHeroInfo(self.m_posIndex)
                                    end
                                end
                                self.select_temp_id = tempEquipId
                                local fateEquipLock =  self:fateEquipLock(itemData,tempEquipId)
                                game_scene:addPop("game_equip_info_pop",{tGameData = itemData,posEquipData = self.m_tempAssEquipPosData[tostring(self.m_posIndex+99)],fateEquipLock = fateEquipLock,callBack = callBack,openType=2,selHeroId = self.m_selHeroId});
                            end
                        else
                            game_util:addMoveTips({text = string_config:getTextByKey("m_equip_pos_no_open")});
                        end
                    elseif tag >= 20 then
                        -- if self.m_teamGemOpenFlag then
                        --     local tempId = self:getPosGemId(self.m_posIndex,tag - 20);
                        --     if tempId == nil or tostring(tempId) == "0" then
                        --         self:addSelGemUi(self.m_posIndex,tag - 20);
                        --     else
                        --         tempId = tostring(tempId);
                        --         local itemData = game_data:getGemDataById(tempId)
                        --         local function callBack(typeName,t_param)
                        --             if typeName == "unload" then
                        --                 self:addSelGemUi(self.m_posIndex,tag - 20);
                        --             elseif typeName == "strengthen" then
                        --                 self.m_openType = "gem_strengthen"
                        --                 self:sendChangedData(1);
                        --             elseif typeName == "synthesis" then
                        --                 self.m_openType = "gem_synthesis"
                        --                 self:sendChangedData(1);
                        --             end
                        --         end
                        --         self.select_temp_id = tempId
                        --         game_scene:addPop("gem_system_info_pop",{tGameData = {count = itemData,c_id = tempId},callBack = callBack,openType=2});
                        --     end
                        -- else
                        --     cclog2(self.m_teamGemOpenFlag, "self.m_teamGemOpenFlag  ===   ")
                        -- end
                    end
                    break;
                end
            end
        end
        if touchMoveFlag == false then
            -- self:fateTouchShow(x,y)
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
    助威法宝层
]]
function game_adjustment_formation.initFriendMagicLayerTouch(self,formation_layer)
    local touchBeginPoint = nil;
    local touchMoveFlag = false;
    local tempItem = nil;
    local realPos = nil;
    local tag = nil;
    local function onTouchBegan(x, y)
        touchMoveFlag = false;
        -- cclog("onTouchBegan: %0.2f, %0.2f", x, y)
        touchBeginPoint = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    local function onTouchMoved(x, y)
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            touchMoveFlag = true;
        end
    end
    
    local function onTouchEnded(x, y)
        if formation_layer:isVisible() == true then
            realPos = formation_layer:convertToNodeSpace(ccp(x,y));
            for i = 1,8 do
                if i < 5 then
                    tempItem = self.m_ccbNode:spriteForName("m_magic_" .. i)  
                else
                    tempItem = self.m_ccbNode:spriteForName("m_equip_" .. i)  
                end
                if tempItem:boundingBox():containsPoint(realPos) then
                    tag = tempItem:getTag();
                    if self.m_posIndex == -1 or self.m_tempAssMagicPosData[tostring(self.m_posIndex+99)] == "-1" then
                        game_util:addMoveTips({text = string_config:getTextByKey("m_onclick_team_pos")});
                        return;
                    end
                    if tag < 20 then
                        local index = tag - 10
                        local openType = 1
                        if index > 2 then
                            openType = 2
                        end
                        local openFlag = true;--game_button_open:getOpenFlagByBtnId("705" .. self.m_posIndex .. (tag-10));
                        if openFlag then
                            local tempData = self.m_tempAssMagicPosData[tostring(self.m_posIndex+99)] or {}
                            local tempId = tempData[tag - 10] or "0"--self:getPosEquipId(self.m_posIndex,tag - 10);
                            if tempId == nil or tostring(tempId) == "0" then
                                self:addSelAssMagicUi(self.m_posIndex,tag - 10);
                            else
                                tempId = tostring(tempId);
                                local itemData = game_data:getMagicDataById(tempId)
                                local function callBack(typeName,t_param)
                                    if typeName == "unload" then
                                        self:addSelAssMagicUi(self.m_posIndex,tag - 10);
                                    elseif typeName == "evolution" then
                                        self.m_openType = "magic_evolution"
                                        self:sendChangedData(1);
                                    elseif typeName == "fateEquipLock" then
                                        self:refreshCombatLabel();
                                        self:refreshEquipPos(self.m_posIndex)
                                        self:refreshMagicPos(self.m_posIndex)
                                        self:refreshHeroInfo(self.m_posIndex)
                                    end
                                end
                                local Type
                                if tag - 10 < 3 then
                                    Type = 1 
                                else
                                    Type = 0
                                end
                                self.select_temp_id = tempId
                                local fateEquipLock =  self:fateEquipLock(itemData,tempId)
                                game_scene:addPop("game_magic_info_pop",{tGameData = itemData,posMagicData = self.m_tempAssEquipPosData[tostring(self.m_posIndex+99)],callBack = callBack,magicType=Type,selHeroId = self.m_selHeroId});
                            end
                        else
                            game_util:addMoveTips({text = string_config:getTextByKey("m_equip_pos_no_open")});
                        end
                    elseif tag >= 20 then
                    end
                    break;
                end
            end
        end
        if touchMoveFlag == false then
            -- self:fateTouchShow(x,y)
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
function game_adjustment_formation.addFriendTeamHeroPop(self,posIndex)
    game_scene:removeGuidePop();
    if self.m_tempFriendData[posIndex] == "-1" then

    else
        self.m_posIndex = posIndex;
        self:refreshHeroInfo(posIndex);
    end
end

function game_adjustment_formation.exchangeAssEquipPosAlert(self,posIndex,currPos,sort,id,posType)
    if posType == 2 and posIndex == currPos then 
        game_util:addMoveTips({text = "Trang bị này ở vị trí này!"});
        return 
    end
    local tempText = nil;
    local heroData,heroCfg = nil,nil
    if posType == 1 then
        heroData,heroCfg = self:getTeamCardDataByPos(currPos)
    elseif posType == 2 then
        heroData,heroCfg = self:getFriendCardDataByPos(currPos)
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
            self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
            game_scene:removePopByName("game_equip_select_pop");
            game_util:closeAlertView();
            if posType == 1 then
                self:exchangeAssAndTeamEquipPosDataByTwoPos(posIndex,currPos,sort);
            elseif posType == 2 then
                self:exchangeAssEquipPosDataByTwoPos(posIndex,currPos,sort);
            end
            self.m_changeFlag = true;
            self:addFriendTeamHeroPop(posIndex);
            self:newChainOpenAnim("equip");
        end,   --可缺省
        okBtnText = "Đổi trang bị",       --可缺省
        text = tempText,      --可缺省
    }
    game_util:openAlertView(t_params);
end


function game_adjustment_formation.exchangeAssMagicPosAlert(self,posIndex,currPos,sort,id,posType,magicPos)
    --选择卡牌位置,法宝所在卡牌位置，选择位置，id，类型，法宝所在位置
    if posType == 2 and posIndex == currPos then 
        game_util:addMoveTips({text = "Trang bị này ở vị trí này!"});
        return 
    end
    local tempText = nil;
    local heroData,heroCfg = nil,nil
    if posType == 1 then
        heroData,heroCfg = self:getTeamCardDataByPos(currPos)
    elseif posType == 2 then
        heroData,heroCfg = self:getFriendCardDataByPos(currPos)
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
            self.m_selMagicId = id;
            self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
            game_scene:removePopByName("game_magic_select_pop");
            game_util:closeAlertView();
            if posType == 1 then
                self:exchangeAssAndTeamMagicPosDataByTwoPos(posIndex,currPos,sort,magicPos);
            elseif posType == 2 then
                self:exchangeAssMagicPosDataByTwoPos(posIndex,currPos,sort,magicPos);
            end
            self.m_changeFlag = true;
            self:addFriendTeamHeroPop(posIndex);
            self:newChainOpenAnim("equip");
        end,   --可缺省
        okBtnText = "Đổi trang bị",       --可缺省
        text = tempText,      --可缺省
    }
    game_util:openAlertView(t_params);
end


--[[

]]
function game_adjustment_formation.exchangeAssEquipPosDataByTwoPos(self,posIndex1,posIndex2,equipType)
    if posIndex1 == posIndex2 then return end
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    posIndex1 = tostring(posIndex1+99)
    posIndex2 = tostring(posIndex2+99)
    self.m_tempAssEquipPosData[posIndex1][equipType],self.m_tempAssEquipPosData[posIndex2][equipType] = self.m_tempAssEquipPosData[posIndex2][equipType],self.m_tempAssEquipPosData[posIndex1][equipType]
    -- cclog("updateAssEquipPosData = " .. json.encode(self.m_tempAssEquipPosData))
end

--[[
    法宝
]]
function game_adjustment_formation.exchangeAssMagicPosDataByTwoPos(self,posIndex1,posIndex2,Type1,Type2)
    if posIndex1 == posIndex2 then return end
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or Type1 > 4 or Type1 < 1 or Type2 > 4 or Type2 < 1 then return end
    posIndex1 = tostring(posIndex1+99)
    posIndex2 = tostring(posIndex2+99)
    self.m_tempAssEquipPosData[posIndex1][Type1],self.m_tempAssEquipPosData[posIndex2][Type2] = self.m_tempAssEquipPosData[posIndex2][Type2],self.m_tempAssEquipPosData[posIndex1][Type1]
    -- cclog("updateAssEquipPosData = " .. json.encode(self.m_tempAssEquipPosData))
end

--[[

]]
function game_adjustment_formation.exchangeAssAndTeamEquipPosDataByTwoPos(self,posIndex1,posIndex2,equipType)
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    posIndex1 = tostring(posIndex1+99)
    self.m_tempAssEquipPosData[posIndex1][equipType],self.m_tempEquipPosData[posIndex2][equipType] = self.m_tempEquipPosData[posIndex2][equipType],self.m_tempAssEquipPosData[posIndex1][equipType]
    self:setTeamFormationData()
    -- cclog("exchangeAssAndTeamEquipPosDataByTwoPos = " .. json.encode(self.m_tempAssEquipPosData))
end

--[[

]]
function game_adjustment_formation.exchangeAssAndTeamMagicPosDataByTwoPos(self,posIndex1,posIndex2,Type1,Type2)
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or Type1 > 4 or Type1 < 1 or Type2 > 4 or Type2 < 1 then return end
    posIndex1 = tostring(posIndex1+99)
    self.m_tempAssMagicPosData[posIndex1][Type1],self.m_tempMagicPosData[posIndex2][Type2] = self.m_tempMagicPosData[posIndex2][Type2],self.m_tempAssMagicPosData[posIndex1][Type1]
    self:setTeamFormationData()
    -- cclog("exchangeAssAndTeamEquipPosDataByTwoPos = " .. json.encode(self.m_tempAssEquipPosData))
end


--[[--
    设置阵型相应位置装备数据
]]
function game_adjustment_formation.updateAssEquipPosData(self,equipPos,equipType,equipId)
    if equipPos > 9 or equipPos < 0 or equipType > 4 or equipType < 1 then return end
    equipPos = tostring(equipPos+99)
    self.m_tempAssEquipPosData[equipPos][equipType] = tostring(equipId);
    -- cclog("updateAssEquipPosData = " .. json.encode(self.m_tempAssEquipPosData))
end
--[[--
    设置阵型相应位置装备数据
]]
function game_adjustment_formation.updateAssMagicPosData(self,equipPos,equipType,equipId)
    if equipPos > 9 or equipPos < 0 or equipType > 4 or equipType < 1 then return end
    equipPos = tostring(equipPos+99)
    self.m_tempAssMagicPosData[equipPos][equipType] = tostring(equipId);
    -- cclog("updateAssEquipPosData = " .. json.encode(self.m_tempAssEquipPosData))
end
--[[--
    
]]
function game_adjustment_formation.addSelAssEquipUi(self,posIndex,sort)
    game_scene:removeGuidePop();
    cclog("addSelAssEquipUi posIndex ==" .. tostring(posIndex))
    local btnCallFunc = function( target,event )
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if id then
                local existFlag,currPos,posType = self:equipInEquipPos(sort,id)
                local existFlag2,pos = game_data:equipInBonus(sort,id)
                if existFlag2 then
                    game_util:addMoveTips({text = "Trang bị đang ở trận pháp số " .. pos-199})
                elseif existFlag then
                    self:exchangeAssEquipPosAlert(posIndex,currPos,sort,id,posType);
                else
                    self.m_selEquipId = id;
                    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                    game_scene:removePopByName("game_equip_select_pop");
                    cclog("itemOnClick changed id ==================== " .. id);
                    self:updateAssEquipPosData(posIndex,sort,id);
                    self.m_changeFlag = true;
                    self:addFriendTeamHeroPop(posIndex);
                    self:newChainOpenAnim("equip");
                    local id = game_guide_controller:getCurrentId();
                    if id == 33 and self.m_back_btn then
                        game_guide_controller:gameGuide("show","2",34,{tempNode = self.m_back_btn})
                    end
                end
            end
        elseif typeName == "unload" then
            self:updateAssEquipPosData(posIndex,sort,"0");
            cclog("itemOnClick remove id ==================== ");
            self.m_changeFlag = true;
            self:addFriendTeamHeroPop(posIndex);
            self:refreshCombatLabel("addSelAssEquipUi");
        end
    end
    game_scene:addPop("game_equip_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = sort,openType = 2})
end

--[[--
    
]]
function game_adjustment_formation.addSelAssMagicUi(self,posIndex,sort)
    game_scene:removeGuidePop();
    cclog("addSelAssMagicUi posIndex ==" .. tostring(posIndex))
    local selSort
    if sort < 3 then
        selSort = 1
    else
        selSort = 0
    end
    local btnCallFunc = function( target,event )
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if id then
                local existFlag,currPos,posType,magicPos = self:magicInMagicPos(selSort,id)
                -- cclog2(existFlag," addSelAssMagicUi   magicInMagicPos  -- ")
                -- cclog(" addSelAssMagicUi   currPos  -- " .. currPos .. " posType =  " .. posType .. "   magicPos = " .. magicPos)
                -- 是否装备    卡牌位置    主阵(1)或助威(2)    法宝位置
                local existFlag2,pos = game_data:magicInBonus(sort,id)
                if existFlag2 then
                    game_util:addMoveTips({text = "该法宝在阵法" .. pos-199 .. "号位中"})
                elseif existFlag then
                    self:exchangeAssMagicPosAlert(posIndex,currPos,sort,id,posType,magicPos);--选择卡牌位置,法宝所在卡牌位置，选择位置，id，类型，法宝所在位置
                else
                    self.m_selMagicId = id;
                    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                    game_scene:removePopByName("game_magic_select_pop");
                    cclog("itemOnClick changed id ==================== " .. id);
                    self:updateAssMagicPosData(posIndex,sort,id);--
                    self.m_changeFlag = true;
                    self:addFriendTeamHeroPop(posIndex);
                    self:newChainOpenAnim("magic");
                    local id = game_guide_controller:getCurrentId();
                    if id == 33 and self.m_back_btn then
                        game_guide_controller:gameGuide("show","2",34,{tempNode = self.m_back_btn})
                    end
                end
            end
        elseif typeName == "unload" then
            self:updateAssMagicPosData(posIndex,sort,"0");
            cclog("itemOnClick remove id ==================== ");
            self.m_changeFlag = true;
            self:addFriendTeamHeroPop(posIndex);
            self:refreshCombatLabel("addSelAssMagicUi");
        end
    end
    game_scene:addPop("game_magic_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = selSort,openType = 2})
end
function game_adjustment_formation:fateTouchShow( x,y )
    if self.m_fate_label and self.m_fate_label:isVisible() == true then
        realPos = self.m_fate_node:getParent():convertToNodeSpace(ccp(x,y));
        if self.m_fate_node:boundingBox():containsPoint(realPos) then
            local wx,wy = self.m_fate_node2:getPosition()
            self.m_spr_mingyunnode:setPositionY(wy+7)
            self.isVisible = self.m_eq_layer:isVisible()
            -- self.m_fate_label:setVisible(false);
            self.m_equip_layer:setVisible(false);
            self.m_eq_layer:setVisible(false)
            self.m_magic_layer:setVisible(false)
            if self.m_teamIndex == 1 then
                self.m_gem_layer:setVisible(false)
            else
                self.m_activation_node:setVisible(false);
            end
            self.m_fate_detail_node:setVisible(true);
            self.m_fate_detail_node:setPosition(self.m_fate_node2:getPosition())
            --todo
                self.m_medal_btn:setVisible(false)
                self.m_soul_btn:setVisible(false)
                self.m_saint_stone_btn:setVisible(false)
                self.m_sp_btn_back:setVisible(false)
                self.m_showMore_flag=false
        end
    elseif self.m_fate_detail_node:isVisible() == true then
        realPos = self.m_fate_detail_node:getParent():convertToNodeSpace(ccp(x,y));
        if self.m_fate_detail_node:boundingBox():containsPoint(realPos) then
            -- self.m_fate_label:setVisible(true);
            -- self.m_spr_mingyunnode:setPosition(self.m_fate_node1:getPosition())
            
            if self.m_teamIndex == 1 then
                local wx,wy = self.m_fate_node1:getPosition()
                self.m_spr_mingyunnode:setPositionY(wy+7)
                if self.m_teamGemOpenFlag then self.m_gem_layer:setVisible(true) end
                self.m_equip_layer:setVisible(true)
                self.m_eq_layer:setVisible(self.isVisible)
                self.m_magic_layer:setVisible(self.isVisible)
            else
                local wx,wy = self.m_fate_node3:getPosition()
                self.m_spr_mingyunnode:setPositionY(wy)
                self.m_activation_node:setVisible(true);
                if self.m_ability2OpenFlag then 
                    self.m_equip_layer:setVisible(true)
                    self.m_eq_layer:setVisible(self.isVisible)
                    self.m_magic_layer:setVisible(self.isVisible)
                end
            end
            self.m_fate_detail_node:setVisible(false);
        end
    end
end

------------------------------------- 助威 end -------------------------------------------

------------------------------------- 命运 start -------------------------------------------
--[[--
    初始化助威页面
]]
function game_adjustment_formation:initDestinyFormation( formation_layer )
    -- body
    local level = game_data:getUserStatusDataByKey("level");
    local itemIcon = nil;
    local headIconSpr = nil;
    local tempLock = nil;
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local tempLockIndex,selLevel = -1,100;
    local smallTag1 = 1;
    local smallTag2 = 7;
    local tempTxt = nil;

    local assistant_cfg = getConfig(game_config_field.destiny);
    local sort = 0;
    for i=1,9 do
        local assistant_cfg_item = assistant_cfg:getNodeWithKey(tostring(i))
        sort = assistant_cfg_item:getNodeWithKey('sort'):toInt();
        itemIcon = self.m_ccbNode:spriteForName("m_pos_" .. i)
        formation_layer:reorderChild(itemIcon,-1000)
        local headIconBgSize = itemIcon:getContentSize();
        itemIcon:removeAllChildrenWithCleanup(true)
        if self.m_tempDestinyData[i] ~= "-1" then
            if(sort == 1)then
                smallTag1 = i+1;   
            else
                smallTag2 = i+1;
            end
        else
            tempLock = CCSprite:createWithSpriteFrameName("dw_suo.png");
            tempLock:setPosition(ccp(headIconBgSize.width/2,headIconBgSize.height/2));
            itemIcon:addChild(tempLock);
            local limit_lv = assistant_cfg_item:getNodeWithKey("limit_lv"):toInt();
            if level < limit_lv then
                local tempLabel = game_util:createLabelBMFont({text = "Cấp mở khóa：Lv" .. limit_lv,color = ccc3(0, 255, 0)});    
                tempLabel:setScale(0.8)
                tempLabel:setPosition(ccp(headIconBgSize.width/2,10));
                itemIcon:addChild(tempLabel);
            else            
                if(smallTag1 == i and i < 7)then
                    local spriteTxt = CCSprite:createWithSpriteFrameName("dw_dianjiwenzi.png");
                    spriteTxt:setPosition(ccp(headIconBgSize.width/2,headIconBgSize.height/2));
                    itemIcon:addChild(spriteTxt,3,3);
                end
                if(smallTag2 == i and i > 6)then
                    local spriteTxt = CCSprite:createWithSpriteFrameName("dw_dianjiwenzi.png");
                    spriteTxt:setPosition(ccp(headIconBgSize.width/2,headIconBgSize.height/2));
                    itemIcon:addChild(spriteTxt,3,3);
                end
            end
        end
        local animNode = self:createCardAnimByDestinyPos(i,false)
        if animNode then
            animNode:setPosition(ccp(headIconBgSize.width*0.5,headIconBgSize.height*0.1));
            itemIcon:addChild(animNode,1,1);
        end
        self:setPositionBg2(i);
    end
    self:initDestinyFormationTouch(self.m_formation_layer);
end

function game_adjustment_formation.initDestinyFormationTouch( self,formation_layer )
    -- body
    local level = game_data:getUserStatusDataByKey("level");
    local beganItem = nil;
    local touchMoveFlag = false;
    local function onTouchBegan( x,y )
        local touchBeginPoint = {x = x, y = y}
        local realPos = formation_layer:convertToNodeSpace(ccp(x,y));
        -- CCTOUCHBEGAN event must return true
        for tag = 1,9 do
            beganItem = self.m_ccbNode:spriteForName("m_pos_" .. tag)
            if beganItem and beganItem:boundingBox():containsPoint(realPos) then
                break;
            end
        end
        return true
    end
    local function onTouchMoved( x,y )
        -- body
    end
    local function onTouchEnded( x,y )
        local realPos = formation_layer:convertToNodeSpace(ccp(x,y));
        local smallTag1 = 9;
        local smallTag2 = 9;
        local assistant_cfg = getConfig(game_config_field.destiny);
        local sort = 0

        for endTag = 1,9 do
            local assistant_cfg_item = assistant_cfg:getNodeWithKey(tostring(endTag))
            sort = assistant_cfg_item:getNodeWithKey('sort'):toInt();
            if self.m_tempDestinyData[endTag] == "-1" then
                if(sort == 1)then
                    smallTag1 = math.min(smallTag1,endTag);
                else
                    smallTag2 = math.min(smallTag2,endTag);
                end
            end
            endItem = self.m_ccbNode:spriteForName("m_pos_" .. endTag)
            if endItem and endItem:boundingBox():containsPoint(realPos) then
                local beganTag = beganItem:getTag();
                if(endTag == beganTag)then
                    if self.m_tempDestinyData[endTag] == "-1" then
                        if(smallTag1 == endTag or smallTag2 == endTag)then
                            local limit_lv = assistant_cfg_item:getNodeWithKey("limit_lv"):toInt();
                            if level < limit_lv then
                                -- game_util:addMoveTips({text = "等级不够！"})
                                break;
                            end
                            local t_params = {}
                            t_params.okBtnCallBack = function()
                                local function responseMethod(tag,gameData)
                                    game_util:addMoveTips({text = "Mở thành công!"});--成功开启！
                                    local destinyData = game_data:getDestiny();
                                    local tempData = util.table_copy(self.m_tempDestinyData)
                                    self.m_tempDestinyData = destinyData
                                    for k,v in pairs(tempData) do
                                        if v ~= "-1" then
                                            self.m_tempDestinyData[k] = v;
                                        end
                                    end
                                    self:initDestinyFormation(self.m_formation_layer);
                                    game_scene:removePopByName("game_assistant_pop");
                                end
                                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_activate_destiny"), http_request_method.GET, {position = endTag-1},"cards_activate_destiny")
                            end
                            t_params.index = endTag
                            t_params.openType = 2
                            game_scene:addPop("game_assistant_pop",t_params)
                        end
                    else
                        self:addDestinySelHeroUi(endTag);
                    end
                end
                break;
            end
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
function game_adjustment_formation.addDestinySelHeroUi(self,posIndex)
    game_scene:removeGuidePop();
    cclog("addSelHeroUi posIndex ==" .. tostring(posIndex))
    local btnCallFunc = function( target,event )
        
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if (not game_util:heroInTeamById(id,self.m_tempTeamData)) and (not game_data:heroInAssistantById(id))  and (not game_util:isInFormationBonus(id)) then
                self:updateDestinyData(posIndex,id);
                self.m_changeFlag = true;
                self:initDestinyTeam();
                self:refreshCombatLabel("addDestinySelHeroUi exchanged");
            end
        elseif typeName == "unload" then
            self.m_magic_node:setVisible(false)
            
            local tempId = self.m_tempDestinyData[posIndex]
            if tempId ~= "-1" and tempId ~= "0" then
                self:updateDestinyData(posIndex,"0");
                self.m_changeFlag = true;
                self:initDestinyTeam();
                self:refreshCombatLabel("addDestinySelHeroUi unload");
            end
        end
    end
    game_scene:addPop("game_hero_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,openType = 2})
end

function game_adjustment_formation:updateDestinyData( posIndex,cardId )
    -- body
    self.m_tempDestinyData[posIndex] = cardId;
end

--[[
    获取命运小伙伴位置上的动画
]]
function game_adjustment_formation:createCardAnimByDestinyPos( posIndex , animFlag)
    -- body
    local heroData,heroCfg = game_data:getCardDataById(self.m_tempDestinyData[posIndex])
    return self:createCardAnimByData(heroData,heroCfg,animFlag);
end

--[[

]]
function game_adjustment_formation:refreshFateTabBtn( sortIndex )
    sortIndex = sortIndex or 1;
    for i=1,2 do
        local tempBtn = self.m_ccbNode:controlButtonForName("m_fate_tab_btn_" .. i)
        if tempBtn then
            tempBtn:setHighlighted(sortIndex == i);
            tempBtn:setEnabled(sortIndex ~= i);
        end
    end
    if sortIndex == 1 then
        self.m_fate_list_view_bg:setVisible(true)
        self.m_scrollView:setVisible(false)
    elseif sortIndex == 2 then
        self.m_fate_list_view_bg:setVisible(false)
        self.m_scrollView:setVisible(true)
    end
end

--[[
    
]]
function game_adjustment_formation.createFateSummaryTableView(self, viewSize)
    local shwoData = self.m_fateDataTab or {}
    local showCount = #shwoData
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;
    params.column = 2; --列
    params.totalItem = showCount;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-1;
    params.showPoint = false
    params.itemActionFlag = false;
    params.direction = kCCScrollViewDirectionVertical;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local ccbNode = luaCCBNode:create()            
            ccbNode:openCCBFile("ccb/ui_adjustment_fate_item.ccbi")
            ccbNode:setAnchorPoint(ccp(0.5,0.5))
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_node = ccbNode:nodeForName("m_node")
            local m_fate_label = ccbNode:labelTTFForName("m_fate_label")
            m_node:removeAllChildrenWithCleanup(true)
            local itemData = shwoData[showCount - index]
            local cardData,cardCfg = game_data:getCardDataById(itemData.cardId)
            local tempIcon = game_util:createCardIconByCfg(cardCfg,cardData);
            if tempIcon then
                tempIcon:setScale(0.75);
                m_node:addChild(tempIcon);
            end
            m_fate_label:setString(tostring(itemData.openChainCount) .. "/" .. tostring(itemData.chainCount))
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            self:refreshFateTabBtn(2)
            local tempHeight = 0;
            for i=1,math.min(showCount - index,showCount) do
                tempHeight = tempHeight + shwoData[i].itemHeight;
            end
            local contentSize = self.m_scrollView:getContentSize();
            local viewSize = self.m_scrollView:getViewSize();
            if tempHeight < viewSize.height then
                self.m_scrollView:setContentOffset(ccp(0,0),false)
            else
                self.m_scrollView:setContentOffset(ccp(0,math.max(-tempHeight+viewSize.height,-contentSize.height+viewSize.height)),false)
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
    end
    return TableViewHelper:create(params);
end
--[[
    
]]
function game_adjustment_formation:refreshFriendScroll(  )
    self.m_scrollView:getContainer():removeAllChildrenWithCleanup(true)
    local layer = self:initFriendScroll();
    self.m_scrollView:addChild(layer,1024,1024);
end

--[[
    
]]
function game_adjustment_formation:initFriendScroll(  )
    -- body
    self.m_fateDataTab = {};
    local layer = CCLayer:create();
    local scrollContent = self.m_scrollView:getContentSize();
    local offsetY = 0;
    for k,v in pairs(self.m_tempFriendData) do
        local cardData,cardCfg = self:getFriendCardDataByPos(k);
        offsetY = self:addChainItemView(layer, cardData, cardCfg, offsetY);
    end
    for k,v in pairs(self.m_tempTeamData) do
        local cardData,cardCfg = self:getTeamCardDataByPos(k);
        offsetY = self:addChainItemView(layer, cardData, cardCfg, offsetY);
    end
    scrollContent.height = offsetY;
    self.m_scrollView:setContentSize(scrollContent);
    self.m_scrollView:setContentOffset(ccp(0,269-offsetY));
    return layer;
end
--[[

]]
function game_adjustment_formation.addChainItemView(self, layer, cardData, cardCfg, offsetY)
    if cardData and cardCfg then
        --todo 命运联协刷新
        local chainTab,chainCount,openChainCount = game_util:cardChainByCfg(cardCfg,cardData.id)
        if  cardData.fate_change and next(cardData.fate_change) then
            chainTab,chainCount,openChainCount = game_util:cardChainByCfg2(cardCfg,cardData.id)  
        end

        
        local fate_detail = game_util:createRichLabelTTF({text = "",dimensions = CCSizeMake(170,0),textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = nil,color = ccc3(221,221,192)});
        if #chainTab > 0 then
            local showStr = ""
            local nameStr = "";
            for i=1,#chainTab do
                showStr = showStr .. chainTab[i].detail .. "\n"
                nameStr = nameStr .. "    " .. chainTab[i].name .. (i == 3 and "\n" or "")
            end
            fate_detail:setString(showStr)
        else
            fate_detail:setString("Không");
        end
        local fateSz = fate_detail:getContentSize();
        local tempHeight = math.max(fateSz.height,50)
        fate_detail:setPosition(ccp(90,offsetY+tempHeight/2));
        layer:addChild(fate_detail);
        local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_zidi.png")
        if tempSpriteFrame then
            local tempSpri = CCScale9Sprite:createWithSpriteFrame(tempSpriteFrame)
            tempSpri:setPreferredSize(CCSizeMake(100, 18));
            tempSpri:setAnchorPoint(ccp(0.5,0))
            tempSpri:setPosition(ccp(55,offsetY + tempHeight+5));
            layer:addChild(tempSpri);
        end
        local name = cardCfg:getNodeWithKey("name"):toStr();
        local tempLabel = game_util:createLabelTTF({text = name,color = ccc3(250,180,0),fontSize = 12});
        tempLabel:setAnchorPoint(ccp(0.5,0))
        tempLabel:setPosition(ccp(55,offsetY + tempHeight+7));
        layer:addChild(tempLabel);
        offsetY = offsetY+tempHeight+30;
        -- local tempIcon = game_util:createCardIconByCfg(cardCfg);
        -- local iconSz = tempIcon:getContentSize();
        -- tempIcon:setPosition(ccp(30,offsetY-iconSz.height/2 - 10));
        -- layer:addChild(tempIcon);
        table.insert(self.m_fateDataTab,{chainCount = chainCount,openChainCount = openChainCount,cardId = cardData.id, itemHeight = tempHeight+30})
    end
    return offsetY;
end

--[[
    
]]
function game_adjustment_formation.refreshFateSummaryTableView(self)
    self.m_fate_list_view_bg:removeAllChildrenWithCleanup(true)
    local tempTableView = self:createFateSummaryTableView(self.m_fate_list_view_bg:getContentSize())
    self.m_fate_list_view_bg:addChild(tempTableView)
end
--[[
    
]]
function game_adjustment_formation.clearFateTabView(self)
    self.m_fate_list_view_bg:removeAllChildrenWithCleanup(true)
    self.m_scrollView:getContainer():removeAllChildrenWithCleanup(true)
end

------------------------------------- 命运 end -------------------------------------------

--[[
    根据英雄id检查英雄是否有配置徽章
]]
function game_adjustment_formation.checkHeroHasBadgeConfig(self, heroId)
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

return game_adjustment_formation;
 � 