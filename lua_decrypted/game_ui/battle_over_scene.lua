---  戰鬥結束

local battle_over_scene = {
    m_tGameData = nil,
    m_popUi = nil,
    m_callFunc = nil,
    returnType = nil,
    m_root_layer = nil,
    m_own_status_icon = nil,
    m_lv_label = nil,
    m_exp_bar_bg = nil,
    m_expBar = nil,
    m_reward_node_1 = nil,
    m_reward_node_2 = nil,
    m_reward_node_3 = nil,
    m_reward_node_4 = nil,
    m_lost_node = nil,
    m_ccbNode = nil,
    m_AtkData = nil,
    m_win_anim_node = nil,
    m_atrr_up_btn = nil,
    m_equip_up_btn = nil,
    m_mask_layer = nil,
    m_skill_up_btn = nil,
    m_retreat_btn = nil,
    m_godgiftTab = nil,
    m_next_step = nil,
    m_countdownLabel = nil,
    m_requestFlag = nil,
    m_total_hurt_label = nil,
    m_boss_node = nil,
    m_gain_node_bg = nil,
    title_sprite = nil,
    m_arena_node = nil,
    m_arena_rank_label = nil,
    arena_count_label = nil,
    m_backGroundName = nil,
    m_buildingId = nil,
    m_cityId = nil,
    m_screenShoot = nil,
    gvg_node = nil,
};
--[[----
    銷毀
]]
function battle_over_scene.destroy(self)
    -- body
    cclog("-----------------battle_over_scene destroy-----------------");
    self.m_tGameData = nil;
    self.m_popUi = nil;
    self.m_callFunc = nil;
    self.returnType = nil;
    self.m_root_layer = nil;
    self.m_own_status_icon = nil;
    self.m_lv_label = nil;
    self.m_exp_bar_bg = nil;
    self.m_expBar = nil;
    self.m_reward_node_1 = nil;
    self.m_reward_node_2 = nil;
    self.m_reward_node_3 = nil;
    self.m_reward_node_4 = nil;
    self.m_lost_node = nil;
    self.m_ccbNode = nil;
    self.m_AtkData = nil;
    self.m_win_anim_node = nil;
    self.m_atrr_up_btn = nil;
    self.m_equip_up_btn = nil;
    self.m_mask_layer = nil;
    self.m_skill_up_btn = nil;
    self.m_retreat_btn = nil;
    self.m_godgiftTab = nil;
    self.m_next_step = nil;
    self.m_countdownLabel = nil;
    self.m_requestFlag = nil;
    self.m_total_hurt_label = nil;
    self.m_boss_node = nil;
    self.m_gain_node_bg = nil;
    self.title_sprite = nil;
    self.m_arena_node = nil;
    self.m_arena_rank_label = nil;
    self.arena_count_label = nil;
    self.m_backGroundName = nil;
    self.m_buildingId = nil;
    self.m_cityId = nil;
    self.m_screenShoot = nil;
    self.gvg_node = nil;
end
--[[----
    返回
]]
function battle_over_scene.back(self,type)
    local battleType = game_data:getBattleType();
    if battleType == "map_building_detail_scene" then
        local function responseMethod(tag,gameData)
            game_data:setSelCityDataByJsonData(gameData:getNodeWithKey("data"));
            local tempData = gameData:getNodeWithKey("data")
            local showDataTips = self:getTipsDataToShow(tempData:getFormatBuffer())
            if ((self.m_cityId ~= nil and self.m_buildingId ~= nil) and self.m_next_step ~= -1) or self.m_battle_result > 5 then
                game_scene:enterGameUi("map_building_detail_scene",{cityId = self.m_cityId,buildingId = self.m_buildingId,next_step = self.m_next_step,gameData = gameData});
            else
                local is_recaptured = self.m_tGameData.is_recaptured;
                local hard_recapture = self.m_tGameData.curt_regain
                if self.m_battle_result < 5 then -- and not game_data:getReMapBattleFlag() 
                    local reward = self.m_tGameData.reward
                    game_scene:enterGameUi("game_small_map_scene",{gameData = gameData,recoverBuildingId = self.m_buildingId,
                        buildingId = self.m_buildingId,is_recaptured = is_recaptured,reward=reward, showDataTips = showDataTips, hard_recapture = hard_recapture});
                -- else
                --     game_scene:enterGameUi("game_small_map_scene",{gameData = gameData,recoverBuildingId = self.m_buildingId,buildingId = self.m_buildingId,is_recaptured = is_recaptured});
                end
            end
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_open"), http_request_method.GET, {city = self.m_cityId},"private_city_open")
    elseif battleType == "game_choose_boss" then
        if self.m_next_step ~= -1 then
            game_scene:enterGameUi("map_building_detail_scene",{next_step = self.m_next_step,openType = "game_choose_boss"});
        else
            local temp = {}
            game_data:setGuildTeamData2({}) 
            game_data:setGuildOtherTeamData({}) 
            game_data:setGuildFormationData({})
            game_data:setGuildSelTeamData({})
            game_data:setGuildGuildCurTeam({})
            local association_id = game_data:getUserStatusDataByKey("association_id");
            if association_id == 0 then
                require("like_oo.oo_controlBase"):openView("guild_join");
            else
                require("like_oo.oo_controlBase"):openView("guild");
            end
        end
    elseif battleType == "game_neutral_city_map" or battleType == "game_neutral_building_detail_pop" then
        local city_id = game_data:getSelNeutralCityId();
        local function responseMethod(tag,gameData)
            local reward = self.m_tGameData.reward or {}
            game_data:setSelNeutralCityDataByJsonData(gameData:getNodeWithKey("data"));
            game_scene:enterGameUi("game_neutral_city_map",{gameData = gameData,city_id = city_id});
            game_util:rewardTipsByDataTable(reward);
            self:destroy();
        end
        -- 公共地圖，打開城市 city_id=10001
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_city_open"), http_request_method.GET, {city_id = city_id},"public_city_open")
    elseif battleType == "game_pirate_precious" then--罗杰的宝藏
        local function responseMethod(tag,gameData)
            local reward = self.m_tGameData.reward or {}
            game_scene:enterGameUi("game_pirate_map",{gameData = gameData})
            --奖励
            game_util:rewardTipsByDataTable(reward);
            self:destroy();
        end
        local treasure = game_data:getTreasure()
        -- cclog2(treasure,"treasure")
        local params = {}
        params.treasure = treasure
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("search_treasure_st_open"), http_request_method.GET, params,"search_treasure_st_open")
    elseif battleType == "help_recapture" then--挖宝救援  回公会
        game_scene:setVisibleBroadcastNode(false);
        local association_id = game_data:getUserStatusDataByKey("association_id");
        if association_id == 0 then
            -- local reward = self.m_tGameData.reward or {}
            require("like_oo.oo_controlBase"):openView("guild_join");
            -- game_util:rewardTipsByDataTable(reward);
        else
            require("like_oo.oo_controlBase"):openView("guild");
        end
    elseif battleType == "game_gvg" then--公会战，回到公会战地图
        local function responseMethod(tag,gameData)
            local occupy_index = nil
            local reward = {}
            if self.m_tGameData then
                reward = self.m_tGameData.reward or {}
                occupy_index = self.m_tGameData.building_id
            end
            local data = gameData:getNodeWithKey("data")
            local sort = data:getNodeWithKey("sort"):toInt()
            if sort == 1 then--外围战布阵开启
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = 1});
            elseif sort == 2 then--外围战战争开始
                game_scene:enterGameUi("game_gvg_war_half",{gameData = gameData,sort = 2,occupy_index = occupy_index});
                game_util:rewardTipsByDataTable(reward);
            elseif sort == 3 then--内城布阵开始
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = 3});
            elseif sort == 4 then--内城战开始
                game_scene:enterGameUi("game_gvg_war_half",{gameData = gameData,sort = 4,occupy_index = occupy_index});
                game_util:rewardTipsByDataTable(reward);
            elseif sort == 5 then
                
            elseif sort == -1 then--公会战未开启
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = -1});
            else
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = sort});
            end
            -- self:destroy()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("guild_gvg_index"), http_request_method.GET, nil,"guild_gvg_index")
    elseif battleType == "game_pk" then
        local function responseMethod(tag,gameData)
            -- game_scene:enterGameUi("game_pk",{pk_flag = "pk",gameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer())});
            game_scene:enterGameUi("game_arena",{pk_flag = "pk",gameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer())});
            self:destroy();
        end
        --  nil
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("arena_index"), http_request_method.GET, {},"arena_index");
    elseif battleType == "zhuanshi" then
        local zhuanshiData = game_data:getZhuanshiTask1Data()
        local card_world_task = zhuanshiData.card_world_task
        -- cclog2(card_world_task,"card_world_task ==")
        local reward = self.m_tGameData.reward or {}
        if card_world_task == 6 then
            game_scene:enterGameUi("game_hero_zhuanshi_task",{gameData = zhuanshiData,falg = true})
            game_util:rewardTipsByDataTable(reward);
        else
            game_scene:enterGameUi("game_hero_zhuanshi_task",{gameData = zhuanshiData})
            game_util:rewardTipsByDataTable(reward);
        end
        self:destroy();

    elseif battleType == "godfield_escort_battle_replay" then   
        local function responseMethod( tag,gameData )
            game_scene:enterGameUi("game_godfield_dart_main",{gameData = gameData})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_dart_mian"),http_request_method.GET,nil,"god_dart_mian") 
    
        --game_data:setZhuanshiTask1Data("") zhuanshiTask2
    elseif battleType == "cosmic_fight" then
        local function responseMethod(tag, gameData)
            game_scene:enterGameUi("game_cosmic_main", {gameData = gameData})
        end
        network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_index"), http_request_method.GET, {}, "battle_over_scene_cosmic_war_index")
    elseif battleType == "zhuanshiTask2" then
        local reward = self.m_tGameData.reward or {}
        game_util:rewardTipsByDataTable(reward);
        local zhuanshiData = game_data:getZhuanshiTask1Data()
        local major = zhuanshiData.id
        local herodata,_ = game_data:getCardDataById(major)
         game_scene:enterGameUi("game_hero_zhuanshi",{gameData = herodata});
        --local major = zhuanshiData.id
        --game_scene:enterGameUi("game_hero_zhuanshi",{gameData = zhuanshiData});
        self:destroy();
    elseif battleType == "nightmare" then 
        local screenShoot = game_util:createScreenShoot();
           screenShoot:retain();
           local gameData = game_data:getGodfieldData()
           local function endCallFunc( )
               -- body
               screenShoot:release();
           end
           game_scene:enterGameUi("game_godfield_battle_result",{gameData = gameData,screenShoot = screenShoot,mType = "nightmare"},{endCallFunc = endCallFunc})
    elseif battleType == "expedition" then 
        local screenShoot = game_util:createScreenShoot();
           screenShoot:retain();
           local gameData = game_data:getGodfieldData()
           local function endCallFunc( )
               -- body
               screenShoot:release();
           end
           game_scene:enterGameUi("game_godfield_battle_result",{gameData = gameData,screenShoot = screenShoot,mType = "expedition"},{endCallFunc = endCallFunc})
    elseif battleType == "game_first_opening" then
        local function sendRequestFunc()
            local function responseMethod(tag,gameData)
                if gameData then
                    game_data:setSelCityDataByJsonData(gameData:getNodeWithKey("data"));
                    game_scene:enterGameUi("game_small_map_scene",{gameData = gameData,bgMusic = "background_singapo"});
                    self:destroy();
                else
                    game_util:closeAlertView();
                    local t_params = 
                    {
                        title = string_config.m_title_prompt,
                        okBtnCallBack = function(target,event)
                            sendRequestFunc();
                            game_util:closeAlertView();
                        end,   --可缺省
                        closeCallBack = function(target,event)
                            game_util:closeAlertView();
                            exitGame();
                        end,
                        okBtnText = "Tải lại",       --可缺省
                        text = "Dữ liệu tải thất bại",      --可缺省
                    }
                    game_util:openAlertView(t_params);
                end
            end
            local params = {}
            params.city = "100"
            params.chapter = "1";
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_open"), http_request_method.GET, params,"private_city_open",true,true);
        end
        sendRequestFunc();
        -- game_scene:enterGameUi("create_role_scene",{});
    elseif battleType == "active_map_building_detail_scene" then--活動地圖
        local activeChapterId = game_data:getSelActiveDataByKey("activeChapterId")
        local activeId = game_data:getSelActiveDataByKey("activeId");
        if (self.m_next_step ~= -1) or self.m_battle_result > 5 then
            local function responseMethod(tag,gameData)
                local data = gameData:getNodeWithKey("data")
                game_data:setDataByKeyAndValue("map_fight_and_enemy",json.decode(data:getFormatBuffer()));
                game_scene:enterGameUi("active_map_building_detail_scene",{activeChapterId = activeChapterId,activeId = activeId,next_step = self.m_next_step});
                self:destroy();
            end
            local params = {chapter = activeChapterId,active_id = activeId,step_n = self.m_next_step}
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_map_fight_and_enemy"), http_request_method.GET, params,"active_map_fight_and_enemy")
        else
            local reward = self.m_tGameData.reward;
            game_scene:enterGameUi("game_main_scene",{gameData = nil, openPop = "game_activity_new_pop"},{endCallFunc = function (  )
                -- game_data:setActiveDataByJsonData(gameData:getNodeWithKey("data"):getNodeWithKey("index"));
                cclog("reward == " .. json.encode(reward))
                -- game_scene:enterGameUi("game_activity",{gameData = gameData})
                game_util:rewardTipsByDataTable(reward);
                game_data_statistics:finishActive({activeId = activeId})
                self:destroy();
            end});
        end
    elseif battleType == "monopoly_boss" then
        local reward= self.m_tGameData.rewards;
        game_scene:enterGameUi("game_main_scene",{gameData = nil, openPop = "game_monopoly_pop"},{endCallFunc = function (  )
                    game_util:rewardTipsByDataTable(reward);
                    self:destroy()
                end})
    elseif battleType == "server_monopoly_boss" then
        local reward= self.m_tGameData.rewards;
        game_scene:enterGameUi("game_main_scene",{gameData = nil, openPop = "game_monopoly_server_pop"},{endCallFunc = function (  )
                    game_util:rewardTipsByDataTable(reward);
                    self:destroy()
                end})    

    elseif battleType == "game_world_boss" then
        local function responseMethod(tag,gameData)
            local reward = self.m_tGameData.reward or {}
            local data = gameData:getNodeWithKey("data")
            local boss_info = data:getNodeWithKey("boss_info");

            cclog("boss_info == " ..boss_info:getFormatBuffer())
            if boss_info:getNodeCount() == 0 then
                local function responseMethod(tag,gameData)
                    game_scene:enterGameUi("game_activity",{gameData = gameData})
                    game_util:addMoveTips({text = "Hoạt động Người khổng lồ tấn công đã kết thúc!"});
                    game_util:rewardTipsByDataTable(reward);
                    self:destroy()
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_index"), http_request_method.GET, nil,"active_index")
            else
                game_scene:enterGameUi("game_world_boss",{gameData = gameData})
                game_util:rewardTipsByDataTable(reward);
                self:destroy()
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_boss_index"), http_request_method.GET, nil,"world_boss_index")
    elseif battleType == "game_guild_boss" then--工會boss
        local function responseMethod(tag,gameData)
            local reward = self.m_tGameData.reward or {}
            local data = gameData:getNodeWithKey("data")
            local boss_info = data:getNodeWithKey("boss_info");
            if boss_info:getNodeCount() == 0 then
                --活動結束，回到公會
                game_scene:setVisibleBroadcastNode(false);
                local association_id = game_data:getUserStatusDataByKey("association_id");
                if association_id == 0 then
                    requireExt("like_oo.oo_controlBase"):openView("guild_join");
                    game_util:rewardTipsByDataTable(reward);
                else
                    requireExt("like_oo.oo_controlBase"):openView("guild");
                end
            else
                local function callBackFunc()
                    self:destroy();
                    static_rootControl = nil;
                end
                game_scene:enterGameUi("game_guild_boss",{gameData = gameData})
                game_util:rewardTipsByDataTable(reward);
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("guildboss_index"), http_request_method.GET, nil,"guildboss_index")
    elseif battleType == "hero_road_pop" then
        local function responseMethod(tag,gameData)
            local reward = self.m_tGameData.sweep_reward or {}
            game_scene:enterGameUi("map_world_scene",{gameData = gameData,bgMusic = "background_home"});
            game_util:rewardTipsByDataTable(reward);
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_world_map"), http_request_method.GET, nil,"private_city_world_map")
    elseif battleType == "game_activity_live" then
        local function responseMethod(tag,gameData)
            local reward = self.m_tGameData.reward or {}
            cclog("reward == " .. json.encode(reward))
            local data = gameData:getNodeWithKey("data")
            local live_data = json.decode(data:getNodeWithKey("active_forever"):getFormatBuffer())
            game_scene:enterGameUi("game_activity_live",{liveData = live_data})
            game_util:rewardTipsByDataTable(reward);
            self:destroy()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_index"), http_request_method.GET, nil,"active_index")
        elseif battleType == "game_topplayer_scene_fight" then -- 最强玩家
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_topplayer_scene",{gameData = gameData, bgMusic = "background_home"})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("playerboss_index"), http_request_method.GET, {},"playerboss_index")    
    elseif battleType == "game_ability_commander_snatch" then
        local tempData = game_data:getCommanderRecipeData();
        -- local function responseMethod(tag,gameData)
            local reward = self.m_tGameData.reward or {}
            local rewardItem = reward.item or {}
            if #rewardItem > 0 or tempData.itemId == nil then
                if not game_button_open:checkButtonOpen(606) then
                    return
                end
                local function responseMethod(tag,gameData)
                    game_scene:enterGameUi("game_ability_commander",{gameData = gameData,recipeId = tempData.recipeId});
                    self:destroy();
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("commander_index"), http_request_method.GET, nil,"commander_index")
            else
                local function responseMethod(tag,gameData)
                    game_scene:enterGameUi("game_ability_commander_snatch",{gameData = gameData,recipeId = tempData.recipeId,itemId = tempData.itemId});
                    self:destroy();
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("commander_search"), http_request_method.GET, {item_id=tempData.itemId},"commander_search")
            end
            -- game_util:rewardTipsByDataTable(reward);
            -- self:destroy();
        -- end
        -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("commander_index"), http_request_method.GET, nil,"commander_index")    
    elseif battleType ==  "game_pyramid_tower_scene" then

        local per_level = self.m_tGameData.before_floor
        local cur_level = self.m_tGameData.battle_floor
        local showFloor = nil
        local showLevelInfo = nil
        if cur_level > 0 and ( per_level < 1 or per_level > cur_level ) then  -- 层数上升
            showFloor = math.max(cur_level - 1, 1)
            showLevelInfo = {floor = showFloor }
        end
        local function responseMethod(tag,gameData)
            -- cclog2(gameData, "gameData   =====    ")
            game_scene:enterGameUi("game_pyramid_tower_scene", {gameData = gameData, battleData =  self.m_tGameData, showLevelInfo = showLevelInfo})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("pyramid_go_fight"), http_request_method.GET, {floor = showFloor},"pyramid_go_fight")
    elseif battleType ==  "game_pyramid_scene" then
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_pyramid_scene",{gameData = gameData,screenShoot = screenShoot, openData = {}});
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("pyramid_index"), http_request_method.GET, nil,"pyramid_index")  
     elseif battleType ==  "game_god_pyramid_palace" then    --星宫战斗

        local function responseMethod(tag,gameData)
            local god_Star_check_msg = game_data:getGod_Star_check_msg("game_god_pyramid_palace")          
            game_scene:enterGameUi("game_god_pyramid_palace",{gameData = gameData , palace_id = god_Star_check_msg.floor})
        end
        local god_Star_check_msg = game_data:getGod_Star_check_msg("game_god_pyramid_palace")
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("zodiac_go_fight"), http_request_method.GET, {floor = god_Star_check_msg.floor},"zodiac_go_fight")
    elseif battleType == "wormhole" then
        local maptype = game_data:getWormtype_battle()
        local function responseMethod( tag,gameData )
            local data = gameData:getNodeWithKey("data");
            data = json.decode(data:getFormatBuffer()) or {}
            game_scene:enterGameUi("game_wormhole_map",{gameData = data,maptype = maptype})
        end
        local params = {}
        params.sort = maptype.maptype
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("wormholes_go_map"), http_request_method.GET, params,"wormholes_go_map")
    elseif battleType ==  "zodiac_battle_replay" then   --战斗回放
        local function responseMethod( tag,gameData )
            game_scene:enterGameUi("game_god_pyramid_main",{gameData = gameData})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("zodiac_index"),http_request_method.GET,nil,"zodiac_index")   
    elseif battleType ==  "zodiac_boss" then   --星宫boss
        local god_Star_check_msg = game_data:getGod_Star_check_msg("game_god_pyramid_palace") 
        local function responseMethod(tag,gameData)              
            game_scene:enterGameUi("game_god_pyramid_palace",{gameData = gameData , palace_id = god_Star_check_msg.floor})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("zodiac_go_fight"), http_request_method.GET, {floor = god_Star_check_msg.floor},"zodiac_go_fight")

    elseif battleType == "open_door_cloister" then--星际回廊
        local isNext = false
        if self.m_battle_result < 5 then--胜利后才确定
            isNext = self.isNext
        end
        local rewardFlag = self.m_tGameData.reward_status or false
        cclog2(self.m_tGameData.reward_status,"self.m_tGameData.reward_status")
         local function responseMethod(tag,gameData)
            game_scene:enterGameUi("open_door_cloister_detail",{gameData = gameData,rewardFlag = rewardFlag,isNext = isNext,lastScore = self.lastScore});
            -- cclog2(gameData, "gameData   =====    ")
         end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("maze_index"), http_request_method.GET, nil,"maze_index")
    elseif battleType == "escort_battle_replay" then--押镖战斗
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_dart_route",{gameData = gameData})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("escort_map_index"), http_request_method.GET, nil,"escort_map_index")
    elseif battleType == "open_door_first_battle" and self.m_battle_result < 5 then--星际穿越的第一场战斗
        game_scene:enterGameUi("open_door_main_scene")
    elseif battleType == "game_neutral_rob_pop" then--新无主之地
        local game_neutral_rob_data = game_data:getDataByKey("game_neutral_rob_data") or {}
        local function responseMethod(tag,gameData)
            local reward = self.m_tGameData.reward or {}
            game_scene:enterGameUi("game_neutral_city_map_new",{gameData = gameData,home_type=game_neutral_rob_data.home_type})
            game_util:rewardTipsByDataTable(reward)
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_go_rob_index"), http_request_method.GET, {uid = game_neutral_rob_data.uid},"public_land_go_rob_index")
    elseif battleType == "public_land_go_revenge" then--新无主之地 复仇
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_neutral_city_map_new",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_index"), http_request_method.GET, nil,"public_land_index")
    elseif battleType == "game_league_main" then--巅峰联赛
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_league_main",{gameData = gameData})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_one_enter_game"), http_request_method.GET, nil,"world_one_enter_game")
    elseif battleType == "godtemple" then
        local screenShoot = game_util:createScreenShoot();
               screenShoot:retain();
               local gameData = game_data:getGodfieldData()
               local function endCallFunc( )
                   -- body
                   screenShoot:release();
               end
               game_scene:enterGameUi("game_godfield_battle_result",{gameData = gameData,screenShoot = screenShoot,mType = "godtemple"},{endCallFunc = endCallFunc})
    elseif battleType == "game_godfield_pvp" or battleType == "god_pvp" then
        local screenShoot = game_util:createScreenShoot();
                screenShoot:retain();
                local gameData = game_data:getGodfieldData()
                local function endCallFunc( )
                    -- body
                    screenShoot:release();
                end
                game_scene:enterGameUi("game_godfield_battle_result",{gameData = gameData,screenShoot = screenShoot,mType = "game_godfield_pvp"},{endCallFunc = endCallFunc})
    elseif battleType == "game_godfield_arena_up" then
        local screenShoot = game_util:createScreenShoot();
                screenShoot:retain();
                local gameData = game_data:getGodfieldData()
                local function endCallFunc( )
                    -- body
                    screenShoot:release();
                end
                game_scene:enterGameUi("game_godfield_battle_result",{gameData = gameData,screenShoot = screenShoot,mType = "game_godfield_arena_up"},{endCallFunc = endCallFunc})
    elseif battleType == "godfield_battle_replay" then
        local function responseMethod( tag,gameData )
            game_scene:enterGameUi("game_godfield_arean",{gameData = gameData})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_index"), http_request_method.GET, {},"god_field_index")
    elseif battleType == "godfield_calendar" then
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local gameData = game_data:getGodfieldData()
        local function endCallFunc( )
            -- body
            screenShoot:release();
        end
        game_scene:enterGameUi("game_godfield_battle_result",{gameData = gameData,screenShoot = screenShoot,mType = "calendar"},{endCallFunc = endCallFunc})
    elseif battleType == "godfield_my_replay" then
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local gameData = game_data:getGodfieldData()
        local function endCallFunc( )
            -- body
            screenShoot:release();
        end
        game_scene:enterGameUi("game_godfield_battle_result",{gameData = gameData,screenShoot = screenShoot},{endCallFunc = endCallFunc})
    elseif battleType ==  "newRichMan" then --新大富翁
        local function responseMethod(tag,gameData)
            local reward = nil;
            local needDonation = nil;
            if self.m_tGameData.reward then
                reward = self.m_tGameData.reward
            end
            -- if self.m_tGameData.building_info then
            --     local sort = self.m_tGameData.building_info.sort
            --     if sort == 3 then
            --         if self.m_tGameData.is_win then
            --             needDonation = false
            --         else
            --             needDonation = true
            --         end
            --     end
            -- end
            game_scene:enterGameUi("game_newRichMan_main",{gameData = gameData,reward = reward});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("monopoly_index"), http_request_method.GET, nil,"monopoly_index")
    elseif battleType == "team_pk_replay" then--组队PK回放
        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            local stage = data:getNodeWithKey("stage"):toInt()
            if stage == 4 then--手动选择路线时间
                game_scene:enterGameUi("game_team_pk_map_prepare",{gameData = gameData});
            elseif stage == 5 then--自动战斗时间
                game_scene:enterGameUi("game_team_pk_map",{gameData = gameData});
            else
                game_scene:setVisibleBroadcastNode(false);
                game_scene:enterGameUi("game_godfield_fenzheng",{gameData = gameData})
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("team_pk_new_index"), http_request_method.GET, nil,"team_pk_new_index")
      elseif battleType == "lookNewCardSkill" then --查看英雄技能
        local indexAndCardIdTab = game_data:getExhcangeSkillIndexAndID()
        cclog2(indexAndCardIdTab,"lookNewCardSkill   lookNewCardSkill ===== ")
        game_scene:enterGameUi("skills_strengthen_scene",{gameData = nil,indexAndCardIdTab = indexAndCardIdTab});
    elseif battleType == "teamTask" then

        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            game_scene:enterGameUi("game_TeamTask_main",{gameData = data})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("team_fight_index"), http_request_method.GET, nil,"team_fight_index")
    elseif battleType == "newRichManHero" then

        local function responseMethod(tag,gameData)
            local reward = nil;
            if self.m_tGameData.reward then
                reward = self.m_tGameData.reward
            end
            if self.m_battle_result < 5 then
                game_scene:enterGameUi("game_newRichMan_main",{gameData = gameData,reward = reward});
            else
                game_scene:enterGameUi("game_newRichMan_main",{gameData = gameData,reward = reward,bigbossdata = self.m_tGameData});
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("monopoly_index"), http_request_method.GET, nil,"monopoly_index")
    elseif battleType == "teamRaid_Battle" then   
        local tab = game_data:getTeamRaidMsg()
        local function responseMethod( tag, gameData )
            if gameData then
                local data = gameData:getNodeWithKey("data")
                local stage = data:getNodeWithKey("stage"):toInt()
                local stage_small = data:getNodeWithKey("stage_small") and data:getNodeWithKey("stage_small"):toInt()
                if stage and stage ~= 0 then
                    if stage == 1 then
                        if stage_small == 1 then
                            game_scene:enterGameUi("game_teamRaid_first_scene",{gameData = gameData,enterFlag = tab.enterFlag,battleType = tab.battleType})
                        elseif stage_small == 2 then
                            game_scene:enterGameUi("game_teamRaid_firstBoss_scene",{gameData = gameData,enterFlag = tab.enterFlag,selectRow = tab.selectRow,selectCol = tab.selectCol })
                        end
                    elseif stage == 2 then
                        if stage_small == 1 then
                            game_scene:enterGameUi("game_teamRaid_last_scene",{gameData = gameData,enterFlag = tab.enterFlag})
                        elseif stage_small == 2 then
                            game_scene:enterGameUi("game_teamRaid_lastBoss_scene",{gameData = gameData,enterFlag = tab.enterFlag,selectRow = tab.selectRow,selectCol = tab.selectCol })
                        end
                    elseif stage == 3 then
                        game_scene:enterGameUi("game_teamRaid_third_scene",{gameData = gameData,enterFlag = tab.enterFlag})
                    elseif stage == 999 then
                        game_scene:addPop("game_teamRaid_result_pop",{gameData = gameData,enterFlag = tab.enterFlag})
                    end
                else
                    game_scene:enterGameUi("game_teamRaid_sec",{gameData = gameData,enterFlag = 1})
                end
            end
        end

        local params = {}
        params.raid_id = tab.raid_id
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("team_raid_persion_raid_index"), http_request_method.GET, params,"team_raid_persion_raid_index")
    elseif battleType == "game_godfield_guild_high_war" then
        local _, battleParams = game_data:getBattleType();
        local function responseMethod( tag,gameData )
            game_scene:enterGameUi("game_godfield_guild_high_war_map",{gameData = gameData, group_id = battleParams.group_id})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("guild_high_war_map_index"), http_request_method.GET, {group_id = battleParams.group_id},"guild_high_war_map_index")
    else
        local function endCallFunc()
            self:destroy();
        end
        game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
    end
end

--[[----
    讀取ccbi創建ui
]]
function battle_over_scene.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick(target,event)
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        cclog("battle_over_scene btnTag ==== " .. btnTag)
        -- if self.m_callFunc and type(self.m_callFunc) == "function" then
            self:removeCountdownLabel();
            if game_guide_controller:getFormationGuideIndex() == 1 then
                game_scene:removeGuidePop()
                local function endCallFunc()
                    -- self.m_callFunc(btnTag);
                    self:onBtnClick(btnTag);
                end
                local t_params = {};
                t_params.dramaId = 1029;
                t_params.endCallFunc = endCallFunc;
                game_scene:addPop("drama_dialog_pop",t_params);
            else
                -- self.m_callFunc(btnTag);
                self:onBtnClick(btnTag);
            end
        -- end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_battle_over.ccbi");

    self.m_root_layer = tolua.cast(ccbNode:objectForName("m_root_layer"), "CCLayer");
    if self.m_screenShoot then
        local tempSize = self.m_root_layer:getContentSize();
        self.m_screenShoot:setPosition(tempSize.width*0.5, tempSize.height*0.5)
        self.m_root_layer:addChild(self.m_screenShoot,-10,-10);
    end
    self.m_mask_layer = ccbNode:layerForName("m_mask_layer")
    self.m_win_anim_node = ccbNode:nodeForName("m_win_anim_node")
    self.m_boss_node = ccbNode:nodeForName("m_boss_node")
    self.m_gain_node_bg = ccbNode:nodeForName("m_gain_node_bg")
    self.m_total_hurt_label = ccbNode:labelBMFontForName("m_total_hurt_label")
    self.title_sprite = ccbNode:spriteForName("title_sprite")
    self.m_arena_node = ccbNode:nodeForName("m_arena_node")
    self.m_arena_rank_label = ccbNode:labelBMFontForName("m_arena_rank_label")

    self.arena_count_label = ccbNode:labelBMFontForName("arena_count_label")
    self.reward_icon = ccbNode:spriteForName("reward_icon")
    --數據解析start
    local user_data = game_data:getUserStatusData()
    local level = user_data["level"]
    local exp_max = user_data["exp_max"]
    local exp = user_data["exp"]
    local battle = self.m_tGameData.battle;
    self.m_battle_result = 100;
    if battle then
        self.m_battle_result = battle.winer or 100;
    end
    cclog("level->"..tostring(level))
    cclog("exp_max->"..tostring(exp_max))
    cclog("exp->"..tostring(exp))
    cclog("m_battle_result->"..tostring(self.m_battle_result))

    local user_data_backup = game_data:getUserStatusDataBackup();
    if user_data_backup.level == nil then
        user_data_backup.level = level;
    end

      --神域星宫boss击杀
    self.boss_iskill = ccbNode:labelTTFForName("boss_iskill")
    self.boss_iskill:setVisible(false)

    --數據解析end
    --第一部分m_reward_node_1——start
    self.m_reward_node_1 = ccbNode:nodeForName("m_reward_node_1")
    self.m_own_status_icon = tolua.cast(ccbNode:objectForName("m_own_status_icon"), "CCSprite");
    --勝負 
    if self.m_battle_result == nil or self.m_battle_result > 5 then--負
        self.m_own_status_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("lose.png"));
    else                            --勝
        self.m_own_status_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("win.png"));
    end
    --級別經驗
    self.m_lv_label = tolua.cast(ccbNode:objectForName("m_lv_label"), "CCLabelTTF");
    self.m_exp_bar_bg = tolua.cast(ccbNode:objectForName("m_exp_bar_bg"), "CCNode");
    self.m_lv_label:setString(tostring(user_data_backup.level))
    self.m_expBar = ExtProgressTime:createWithFrameName("public_diban.png","public_tili.png");
    local bar = self.m_expBar;
    --bar:setCurValue(exp / exp_max * 100,false);
    self.m_exp_bar_bg:addChild(bar,10,10);
    --第一部分m_reward_node_1——end

    --先不顯示這兩部分，然後判斷是否有該獎勵start
    self.m_reward_node_2 = ccbNode:nodeForName("m_reward_node_2")--送卡
    self.m_reward_node_3 = ccbNode:nodeForName("m_reward_node_3")--獎勵
    self.m_reward_node_4 = ccbNode:nodeForName("m_reward_node_4")--搶奪
    self.m_reward_node_4:setVisible(false);
    self.m_lost_node = ccbNode:nodeForName("m_lost_node")
    self.m_reward_node_2:setVisible(false);
    self.m_reward_node_3:setVisible(false);
    self.m_reward_node_1:setVisible(false);
    self.m_lost_node:setVisible(false);


    --gvg新增
    self.gvg_node = ccbNode:nodeForName("gvg_node")
    self.att_node = ccbNode:nodeForName("att_node")
    self.def_node = ccbNode:nodeForName("def_node")
    self.word_label = ccbNode:labelTTFForName("word_label")

    -----------------------------------end
    -----戰鬥勝利結束後調用------animEndCallFunc--start
    local battleType = game_data:getBattleType();
    local function animEndCallFunc(animName)
        if self.m_battle_result < 5 then
            if animName == "enter_anim" then
                game_scene:addPop("game_chest_pop",{godgiftTab = self.m_godgiftTab},{order = 100000})
                self.m_mask_layer:setTouchEnabled(false);
                game_sound:playUiSound("battle_success" .. math.random(1,3))
                local winAnimNode = game_util:createEffectAnim("win",1.0,true)
                if winAnimNode then
                    self.m_win_anim_node:addChild(winAnimNode);
                end
                self:playerWin();
                ccbNode:runAnimations("loop_anim")
                local id = game_guide_controller:getIdByTeam("3");
                if id == 301 then
                    game_guide_controller:gameGuide("show","3",302,{tempNode = ccbNode:controlButtonForName("m_main_btn_3")})
                else
                    local id2 = game_guide_controller:getIdByTeam("5");
                    if id2 == 501 then
                        game_guide_controller:gameGuide("show","5",502,{tempNode = ccbNode:controlButtonForName("m_main_btn_3")})
                    else
                        if battleType == "map_building_detail_scene" and self.m_next_step ~= -1 then
                            self:autoBattleFunc();
                        elseif battleType == "game_choose_boss" and self.m_next_step ~= -1 then
                            self:autoBattleFunc();
                        end
                    end
                end
                if battleType == "game_ability_commander_snatch" then
                    self:abilityCommanderSnatch();
                end
            elseif animName == "loop_anim" then
                ccbNode:runAnimations("loop_anim")
            end
        else
            self.m_mask_layer:setTouchEnabled(false);
            if game_data:getReMapBattleFlag() == false and battleType == "map_building_detail_scene" then -- "10201" 戰鬥失敗後新手引導
                local cardNumData = game_data:getBattleCardNumData()
                local position_num = math.min(cardNumData.position_num,5)
                local teamData = game_data:getTeamData();
                -- cclog("position_num === " .. position_num .. " ;game_data:getCurrentFightId() == " .. game_data:getCurrentFightId() .. " ; teamData[1] == " .. teamData[1] .. " ; teamData[3] == " .. teamData[3] .. " ;teamData[4] == " .. teamData[4])
                if position_num > 2 and game_data:getCurrentFightId() == "10201" and teamData[1] ~= "-1" and teamData[3] == "-1" and teamData[4] ~= "-1" then
                    game_guide_controller:setFormationGuideIndex(1);
                    game_scene:addGuidePop({tempNode = ccbNode:controlButtonForName("m_main_btn_3")})
                end
            end
            if battleType == "game_ability_commander_snatch" then
                self:abilityCommanderSnatch();
            end
        end
    end
    -----戰鬥勝利結束後調用------animEndCallFunc--end

    if self.m_battle_result < 5 then--戰鬥勝利
        cclog("registerAnimFunc animEndCallFunc -----------------------")
        self.m_reward_node_1:setVisible(true);
    else
        game_sound:playUiSound("battle_failed" .. math.random(1,2))
        bar:setCurValue(exp / exp_max * 100,false);
        if battleType ~= "game_ability_commander_snatch" then
            self.m_lost_node:setVisible(true);
        end
    end
    if battleType == "game_world_boss" then
        self.m_gain_node_bg:setVisible(false);
        self.m_boss_node:setVisible(true);
        self.m_lost_node:setVisible(false);
        self.m_total_hurt_label:setString(tostring(self.m_tGameData.hurt or 0))
        local reward = self.m_tGameData.reward
        local arena_point = reward.arena_point 
        self.arena_count_label:setString("×" .. arena_point)
    elseif battleType == "game_pk" then--競技場 勝利
        if self.m_battle_result < 5 then--戰鬥勝利
            self.m_gain_node_bg:setVisible(false);
            self.m_arena_node:setVisible(true);
            self.m_lost_node:setVisible(false);
            self.m_arena_rank_label:setString(tostring(self.m_tGameData.cur_rank or 0))
        end
    
    elseif battleType == "game_gvg" then
        self.m_gain_node_bg:setVisible(false);
        self.m_arena_node:setVisible(false);
        self.m_lost_node:setVisible(false);
        self.gvg_node:setVisible(true);


        self.att_node:removeAllChildrenWithCleanup(true)
        local atk_role = self.m_tGameData.battle.init.atk_role or 1
        local att_head = game_util:createRoleBigImgHalf(atk_role)
        att_head:setAnchorPoint(ccp(0.5,0))
        self.att_node:addChild(att_head)
        local att_name = game_util:createLabelTTF({text = self.m_tGameData.battle.init.atk_name});
        att_name:setPosition(ccp(0,-10))
        self.att_node:addChild(att_name)
        self.def_node:removeAllChildrenWithCleanup(true)
        local dfd_role = self.m_tGameData.battle.init.dfd_role or 1
        if dfd_role < 1 then
            dfd_role = 1
        end
        local def_head = game_util:createRoleBigImgHalf(dfd_role)
        def_head:setAnchorPoint(ccp(0.5,0))
        def_head:setFlipX(true)
        self.def_node:addChild(def_head)
        local def_name = game_util:createLabelTTF({text = self.m_tGameData.battle.init.dfd_name});
        def_name:setPosition(ccp(0,-10))
        self.def_node:addChild(def_name)
        local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("battle_gvg_lose.png")
        local loseIcon = nil
        if spriteFrame then
            loseIcon = CCSprite:createWithSpriteFrameName("battle_gvg_lose.png")
        end
        if loseIcon then loseIcon:setPosition(ccp(0,35)) end
        local text = ""
        if self.m_tGameData.is_win == true then--胜利了
            -- 你战胜了 xxx 占领了他防守的据点
            -- Bạn đã chiến thắng xxx chiếm được cứ điểm phòng thủ của hắn
            text = "Bạn đã chiến thắng " .. self.m_tGameData.battle.init.dfd_name
            if self.m_tGameData.is_alive == false then--对方死了，占领了
                text = text .. "\nchiếm được cứ điểm phòng thủ của hắn"
            end
            def_head:setColor(ccc3(151,151,151))
            if loseIcon then self.def_node:addChild(loseIcon) end
        else
            -- Bạn bị xxx đánh bại, sĩ khí đối phương giảm 10%
            -- 你被 xxx 击败了,对方士气减少 10%
            text = "Bạn bị " .. self.m_tGameData.battle.init.dfd_name .. " đánh bại\n sĩ khí đối phương giảm ".. (self.m_tGameData.diff_morale or 0) .. "%"
            att_head:setColor(ccc3(151,151,151))
            if loseIcon then self.att_node:addChild(loseIcon) end
        end
        self.word_label:setString(text)
     elseif battleType == "zodiac_boss" then
        self.m_gain_node_bg:setVisible(false);
        self.m_boss_node:setVisible(true);
        self.m_lost_node:setVisible(false);
        self.arena_count_label:setVisible(false);
        self.reward_icon:setVisible(false)
        self.m_total_hurt_label:setString(tostring(self.m_tGameData.hurt or 0))
        local reward = self.m_tGameData.kill_reward
        if reward then
            if tolua.type(reward) == "util_json" then
                game_util:rewardTipsByJsonData(reward)
            else
                game_util:rewardTipsByDataTable(reward)
            end
        end
        if self.m_tGameData.kill_boss then
           self.boss_iskill:setVisible(true)
        end
    
    else
        self.m_boss_node:setVisible(false);
    end
    ccbNode:registerAnimFunc(animEndCallFunc)
    ccbNode:runAnimations("enter_anim")
    self.m_atrr_up_btn = ccbNode:controlButtonForName("m_atrr_up_btn")
    self.m_equip_up_btn = ccbNode:controlButtonForName("m_equip_up_btn")
    self.m_skill_up_btn = ccbNode:controlButtonForName("m_skill_up_btn")
    self.m_retreat_btn = ccbNode:controlButtonForName("m_retreat_btn")
    self.m_atrr_up_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.m_equip_up_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.m_skill_up_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.m_retreat_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    
    local m_btn_node = ccbNode:nodeForName("m_btn_node")
    local btn = nil;
    local selCityId = tostring(game_data:getSelCityId())
    local tempId = game_guide_controller:getCurrentId();
    cclog("tempId ===================================== " .. tempId)
    local tempFlag = (battleType == "game_first_opening" or tempId == 7 or tempId == 8 or tempId == 28 or (selCityId == "101" and game_data:getReMapBattleFlag() == false))
    for i = 1,3 do
        btn = ccbNode:controlButtonForName("m_main_btn_" .. i)
        game_util:setControlButtonTitleBMFont(btn)
        btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
        if tempFlag and (i == 1 or i == 2) then
            btn:setColor(ccc3(151,151,151));
            btn:setTouchEnabled(false);
            if tempId == 8 and i == 1 then
                -- game_guide_controller:gameGuide("show","1",10,{tempNode = btn});
                game_guide_controller:gameGuide("send","1",10);
            end
        end
        -- if i == 1 then
        --     btn:setColor(ccc3(151,151,151));
        --     btn:setTouchEnabled(false);
        -- end
    end
    -- btn = tolua.cast(self.m_root_layer:getChildByTag(3),"CCControlButton");
    -- if battleType == "game_first_opening" then
    --     self.returnType = 1;
    -- end
    -- if(self.returnType == 0) then
    --     game_util:setCCControlButtonTitle(btn,"下一場")
    -- else
    --     game_util:setCCControlButtonTitle(btn,"完成")
    -- end

    local function onTouch(eventType, x, y)
        if eventType == "began" then
            self:removeCountdownLabel();
            return true;--intercept event
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY,true);
    self.m_root_layer:setTouchEnabled(true);    
    self.m_mask_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-2,true);
    self.m_mask_layer:setTouchEnabled(true);
    self.m_ccbNode = ccbNode;
    return ccbNode;
end

--[[--
    直接戰鬥
]]
function battle_over_scene.enterBattle(self)
    if self.m_cityId == nil or self.m_buildingId == nil then return end
    local function responseMethod(tag,gameData)
        local mapConfig = getConfig(game_config_field.map_title_detail);
        local buildingCfgData = mapConfig:getNodeWithKey(tostring(self.m_buildingId));
        local background = buildingCfgData:getNodeWithKey("background"):toStr();
        background = game_util:getResName(background);
        local fight_list = buildingCfgData:getNodeWithKey("fight_list");
        local fightItem = fight_list:getNodeAt(self.m_next_step);
        local stageName = ""
        local fight_list_count = 0;
        local fight_boss = "0";
        if fightItem then
            stageName = fightItem:getNodeAt(0):toStr();
            fight_list_count = fight_list:getNodeCount();
            local fightId = fightItem:getNodeAt(1):toStr()
            game_data:setCurrentFightId(fightId);
            local enemyCfg = getConfig(game_config_field.map_fight)
            local mapEnemyCfg = enemyCfg:getNodeWithKey(fightId)
            if mapEnemyCfg then
                fight_boss = mapEnemyCfg:getNodeWithKey("fight_boss"):toStr()
            end
            cclog("fight_boss ======================= " .. fight_boss .. " ;mapEnemyCfg == " .. tostring(mapEnemyCfg) .. " ; fightId == " .. fightId)
        end
        local stageTableData = {name = stageName,step = self.m_next_step+1,totalStep = fight_list_count,fight_boss = fight_boss}
        game_scene:enterGameUi("game_battle_scene",{gameData = gameData,cityId = self.m_cityId,buildingId = self.m_buildingId,next_step = self.m_next_step,stageTableData=stageTableData,backGroundName = background});
    end
    game_data:setUserStatusDataBackup();
    local params = {};
    params.city = self.m_cityId;
    params.building = self.m_buildingId;
    params.step_n = self.m_next_step;
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_recapture"), http_request_method.GET, params,"private_city_recapture")
end

--[[
    
]]
function battle_over_scene.onBtnClick(self,btnTag)
    local battleType = game_data:getBattleType();
    if battleType == "game_first_opening" then
        local m_shared
        m_shared = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_shared);
            m_shared = nil;
            self:back();
        end, 0.1 , false);
        return;
    end
    if btnTag == 1 then--戰鬥統計        
        self:back();
    elseif btnTag == 2 then--戰鬥回放
        game_scene:enterGameUi("game_battle_scene",{gameData = self.m_tGameData,cityId = self.m_cityId,buildingId = self.m_buildingId,next_step = self.m_next_step,backGroundName = self.m_backGroundName});
    elseif btnTag == 3 then--返回  
        local function backFunc()
            local id = game_guide_controller:getIdByTeam("3");
            if id == 302 then -- 技能升級
                game_scene:enterGameUi("game_main_scene");
            else
                local id2 = game_guide_controller:getIdByTeam("5");
                if id2 == 502 then -- 夥伴進階
                    game_scene:enterGameUi("game_main_scene");
                else
                    self:back();
                end
            end
        end
        if battleType == "map_building_detail_scene" or battleType == "game_choose_boss" then
            if self.m_next_step == -1 or self.m_battle_result > 5 then--戰鬥完成 或 失敗
                backFunc();
            else--直接戰鬥
                self:enterBattle();
            end
        elseif battleType == "game_pirate_precious" then--罗杰的宝藏
            -- if self.m_battle_result > 5 then--战斗完成 或 失败
                backFunc();
            -- else--直接战斗
            --     self:quickTreasureBattle();
            -- end
        elseif battleType == "godfield_battle_replay" or battleType == "godfield_my_replay" or battleType == "godfield_calendar" or battleType == "godtemple" then
            self:back();
        elseif battleType == "game_godfield_pvp" or battleType == "game_godfield_arena_up" or battleType == "nightmare" or battleType == "expedition" then
            self:back();
        elseif battleType == "zhuanshi" or battleType == "zhuanshiTask2"  or battleType == "lookNewCardSkill" then
            self:back();
        elseif battleType == "help_recapture" then--挖宝救援
            self:back();
        elseif battleType == "game_godfield_guild_high_war" then 
            self:back();
        else
            backFunc();
        end
    elseif btnTag == 11 then--屬性改造
        if not game_button_open:checkButtonOpen(509) then
            return;
        end
        game_scene:enterGameUi("game_hero_culture_scene",{gameData = nil,openType = "game_battle_scene"});
        self:destroy();
    elseif btnTag == 12 then--裝備強化
        if not game_button_open:checkButtonOpen(602) then
            return;
        end
        game_scene:enterGameUi("equipment_strengthen",{gameData = nil,openType = "game_battle_scene"});
        self:destroy();
    elseif btnTag == 13 then--技能升級
        if not game_button_open:checkButtonOpen(503) then
            return;
        end
        game_scene:enterGameUi("skills_strengthen_scene",{gameData = nil,openType = "game_battle_scene"});
        self:destroy();
    elseif btnTag == 14 then--回到城市地圖
        local function endCallFunc()
            self:destroy();
        end
        game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
    end
end

--[[
    
]]
function battle_over_scene.abilityCommanderSnatch(self)
    local tempData = game_data:getCommanderRecipeData();
    if tempData.itemId == nil then return true end
    local ccbNode = self.m_ccbNode;
    self.m_reward_node_4:setVisible(true);
    local m_item_snatch_spri = ccbNode:spriteForName("m_item_snatch_spri")--
    local m_item_light_spri = ccbNode:spriteForName("m_item_light_spri")--
    local m_gain_item_label = ccbNode:labelTTFForName("m_gain_item_label") 

    local reward = self.m_tGameData.reward or {}
    local rewardItem = reward.item or {}
    if #rewardItem > 0 then--搶奪成功
        m_item_snatch_spri:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("zdjs_wenzi_1.png"));
        m_item_light_spri:setVisible(true);
        
        local tempIcon,tempName = game_util:createItemIconByCid(rewardItem[1]);
        if tempIcon then
            local tempSize = m_item_light_spri:getContentSize();
            tempIcon:setPosition(ccp(tempSize.width*0.5, tempSize.height*0.5))
            m_item_light_spri:addChild(tempIcon,-1)
        end
        if tempName then
            m_gain_item_label:setString(tempName)
        else
            m_gain_item_label:setString("Tên đạo cụ")
        end
    else--搶奪失敗
        m_item_snatch_spri:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("zdjs_wenzi_2.png"));
        m_item_light_spri:setVisible(false);
    end
end
--[[
    
]]
function battle_over_scene.removeCountdownLabel(self)
    if self.m_countdownLabel then
        self.m_countdownLabel:removeFromParentAndCleanup(true);
        self.m_countdownLabel = nil;
    end
end

--[[
    自動下一場戰鬥倒計時
]]
function battle_over_scene.autoBattleFunc(self)
    cclog("battle_over_scene.autoBattleFunc---------------------------")
    local function timeOverCallFun(label,type)
        self:removeCountdownLabel();
        -- if self.m_callFunc then
        --     self.m_callFunc(3);
        -- end
        self:onBtnClick(3);
    end
    self.m_countdownLabel = game_util:createCountdownLabel(5,timeOverCallFun,12,2)
    self.m_countdownLabel:setScale(1.1)
    local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    self.m_countdownLabel:setPosition(ccp(visibleSize.width*0.87, visibleSize.height*0.32))
    self.m_ccbNode:addChild(self.m_countdownLabel,10,10)
end
--[[----
    戰鬥勝利 
]]
function battle_over_scene.playerWin(self)
        local bar = self.m_expBar;
        local ccbNode = self.m_ccbNode;
        local battle_rewards = self.m_tGameData.battle_rewards
        if battle_rewards == nil then 
            cclog("battle_rewards == nil")
            return 
        end
        local user_data = game_data:getUserStatusData()
        local level = user_data["level"]
        local exp_max = user_data["exp_max"]
        local exp = user_data["exp"]
        local reward_exp_player = battle_rewards.reward_exp_player
        local reward_exp_player_count = #reward_exp_player;

        -- 顯示用戶經驗和等級等
        local levelUpFlag = false;
        local reward_exp_player_temp = nil;
        local reward_exp_player_item = nil;
        local levelUpCount = 1;
        local animStep = 1;
        local addExp = 0;
        local oldExp = 0;
        local lvTemp = 0;
        local function levelUpExpAnim(itemData)
            lvTemp = itemData[1]
            local exp_max_temp = itemData[2]
            bar:setMaxValue(exp_max_temp);
            if animStep == 1 then
                -- cclog("up animStep ======1==================" .. animStep .. " ;oldExp = " .. oldExp .. "; exp_max_temp ==" .. exp_max_temp);
                bar:setCurValue(oldExp,false);
            else
                -- cclog("up animStep ======2==================" .. animStep .. " ;oldExp = " .. oldExp .. "; exp_max_temp ==" .. exp_max_temp);
                bar:setCurValue(0,false);
            end
            bar:setCurValue(exp_max_temp,true);
            levelUpFlag = true;
            self.m_lv_label:setString("" .. lvTemp);
            animStep = animStep + 1;
        end
        local function playerLevelUpAnimEnd()
            cclog("playerLevelUpAnimEnd ============================= ");
            levelUpFlag = false;
            if animStep < (levelUpCount) then
                reward_exp_player_item = reward_exp_player_temp[animStep]
                levelUpExpAnim(reward_exp_player_item);
            elseif animStep == (levelUpCount) then
                bar:setMaxValue(exp_max);
                bar:setCurValue(0,false);
                bar:setCurValue(exp,true);
                lvTemp = level;
                self.m_lv_label:setString("" .. tostring(level));
                animStep = animStep + 1;
            end
        end
        local function playerExpAnimEnd(extBar)
            cclog("playerExpAnimEnd --------------levelUpFlag = " .. tostring(levelUpFlag));
            if levelUpFlag == true then
                if levelUpCount == 2 or (levelUpCount > 2 and animStep == (levelUpCount - 1)) then
                    game_scene:addPop("player_level_up_pop",{callBackFunc = playerLevelUpAnimEnd,lv = lvTemp})
                else
                    playerLevelUpAnimEnd();
                end
                -- ccbNode:addChild(game_util:playerLevelUpCCBAnim(playerLevelUpAnimEnd));
            else
               self:playerShowCardExp(); 
            end
        end
        bar:registerScriptBarHandler(playerExpAnimEnd);
        --bar:addLabelTTF(CCLabelTTF:create("0/100",TYPE_FACE_TABLE.Arial_BoldMT,12));
        cclog("reward_exp_player_count ====================" .. reward_exp_player_count);
        if reward_exp_player_count == 3 then
            addExp = reward_exp_player[1]
            oldExp = reward_exp_player[2]
            reward_exp_player_temp = reward_exp_player[3]
            levelUpCount = #reward_exp_player_temp
            -- cclog("levelUpCount ====================" .. levelUpCount);
            if levelUpCount == 1 then--沒有升級
                bar:setMaxValue(exp_max);
                bar:setCurValue(exp - addExp,false);
                bar:setCurValue(exp,true);
                lvTemp = level;
                self.m_lv_label:setString("" .. tostring(level));
                -- m_exp_label:setString(tostring(exp .. "/" .. exp_max));
                animStep = 2;
            elseif levelUpCount > 1 then
                reward_exp_player_item = reward_exp_player_temp[animStep]
                levelUpExpAnim(reward_exp_player_item);
            end
        else
            bar:setMaxValue(exp_max);
            bar:setCurValue(exp,false);
            bar:setCurValue(exp,true);
        end
        self.m_reward_node_1:setVisible(true)
end

--[[----
    卡牌經驗
]]
function battle_over_scene.playerShowCardExp(self)
        local bar = self.m_expBar;
        local ccbNode = self.m_ccbNode;
        local battle_rewards = self.m_tGameData.battle_rewards
        if battle_rewards == nil then 
            cclog("battle_rewards == nil")
            return 
        end
        local reward_exp_character = battle_rewards.reward_exp_character or {};
        local reward_exp_character_count = game_util:getTableLen(reward_exp_character)
        if reward_exp_character_count == 0 then
            self:showRewardCharacter();
            return;
        end
        --顯示戰鬥英雄的經驗等
        local function getShowCardDataByIndex(index,step)
            local lv,oldExp,currExp,maxExp,levelFlag;
            local exp_character_item = reward_exp_character[tostring(self.m_AtkData[index].data_id)]
            if exp_character_item and #exp_character_item == 3 then
                local add_exp = exp_character_item[1]
                oldExp = exp_character_item[2]
                local add_exp_temp = exp_character_item[3]
                local add_exp_temp_count = #add_exp_temp
                if step < add_exp_temp_count then
                    local add_exp_item = add_exp_temp[step+1]
                    lv = add_exp_item[1]
                    maxExp = add_exp_item[2]
                    if add_exp_temp_count == 1 then
                        currExp = add_exp + oldExp;
                        levelFlag = false;
                    elseif add_exp_temp_count > 1 then
                        if step == 0 then
                            currExp = maxExp;
                            levelFlag = true;
                        elseif step < (add_exp_temp_count - 1) then
                            currExp = maxExp;
                            oldExp = 0;
                            levelFlag = true;
                        elseif step == (add_exp_temp_count - 1) then
                            currExp = add_exp + oldExp;
                            cclog("add_exp ============" .. add_exp .. " ; oldExp ==" .. oldExp .. " ; currExp ==" .. currExp)
                            for i = 1,add_exp_temp_count - 1 do
                                add_exp_item = add_exp_temp[i]
                                currExp = currExp - add_exp_item[2]
                                cclog("currExp ======================" .. currExp .. " ; add_exp_item[2] = " .. add_exp_item[2])
                            end
                            oldExp = 0;
                            levelFlag = false;
                        end
                    end
                end
            end
            return lv,oldExp,currExp,maxExp,levelFlag;
        end

        -- 顯示戰鬥英雄的經驗等
        local function heroExpAnim()
            self.m_reward_node_2:setVisible(true)
            cclog("heroExpAnim =================================");
            local cardItemTab = {};
            local function barSchedulerAndActions(pauseFlag)
                if pauseFlag then
                    for k,v in pairs(cardItemTab) do
                        v.heroExpBar:pause()
                    end
                else
                    for k,v in pairs(cardItemTab) do
                        v.heroExpBar:resume()
                    end
                end
            end

            local indexTemp = 0;
            local function playerHeroExpAnimEnd(extBar)
                cclog("playerHeroExpAnimEnd->"..indexTemp)
                local posIndex = extBar:getTag();
                local cardItemTab = cardItemTab[posIndex]
                if cardItemTab then
                    cardItemTab.currentStep = cardItemTab.currentStep + 1;
                    local lv,oldExp,currExp,maxExp,levelFlag = getShowCardDataByIndex(posIndex,cardItemTab.currentStep)
                    if lv then
                        -- cclog("posIndex ==" .. posIndex .. " ; levelFlag ====" .. tostring(levelFlag) .. " ; currentStep = " .. cardItemTab.currentStep)
                        --cclog("lv,oldExp,currExp,maxExp,levelFlag = " .. lv .. ";" .. oldExp .. ";" .. currExp .. ";" .. maxExp .. ";" .. tostring(levelFlag))
                        local function callBackFunc()
                            local heroExpBar = cardItemTab.heroExpBar;
                            heroExpBar:setMaxValue(maxExp);
                            heroExpBar:setCurValue(oldExp,false);
                            heroExpBar:setCurValue(currExp,true);
                            cardItemTab.levelFlag = levelFlag
                            cardItemTab.lvLabel:setString("Lv."..tostring(lv));
                            barSchedulerAndActions(false)
                        end
                        -- if cardItemTab.levelFlag then
                            -- barSchedulerAndActions(true)
                            -- game_scene:getPopContainer():addChild(game_util:createBattleHeroLevelUpByCCB(callBackFunc,cardItemTab.cardId,lv))
                        -- else
                            game_util:addTipsAnimByType(cardItemTab.itemBg,4);                        
                            callBackFunc();
                        -- end
                    else
                        indexTemp = indexTemp - 1;
                    end
                else
                    indexTemp = indexTemp - 1;
                end
                if indexTemp == 0 then
                    self:showRewardCharacter();
                end
            end

            local itemConfig = nil;
            local itemBg = nil;
            local headIconSpr = nil;
            local heroExpBar = nil;
            local showIndex = 1;

            for i = 1,8 do
                itemBg = ccbNode:spriteForName("m_card_" .. i)
                itemBg:setVisible(false)
                if self.m_AtkData[i] ~= nil and self.m_AtkData[i].card_id then
                    itemBg = ccbNode:spriteForName("m_card_" .. showIndex)
                    itemBg:setVisible(true)
                    -- cclog("self.m_AtkData[" .. i .. "] ==========card_id = " .. self.m_AtkData[i].card_id .. " ; data_id = " .. self.m_AtkData[i].data_id .. " ; exp ===" .. self.m_AtkData[i].exp);
                    indexTemp = indexTemp + 1;
                    local headIconSprSize = itemBg:getContentSize();
                    itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(self.m_AtkData[i].card_id);
                    if itemConfig:getNodeWithKey("is_skin") then
                        if itemConfig:getNodeWithKey("is_skin"):toInt() ~= 0 then
                            local skinID = itemConfig:getNodeWithKey("is_skin"):toInt()
                            local flag = game_util:isWearSkin(skinID)
                            if flag then
                                itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(tostring(skinID));
                            end
                        end
                    end
                    headIconSpr = game_util:createIconByName(itemConfig:getNodeWithKey("img"):toStr());
                    if headIconSpr then
                        headIconSpr:setPosition(ccp(headIconSprSize.width * 0.5,headIconSprSize.height * 0.5));
                        headIconSpr:setScale(headIconSprSize.width/headIconSpr:getContentSize().width);
                        itemBg:addChild(headIconSpr,-1);
                    end
                    local lv,oldExp,currExp,maxExp,levelFlag = getShowCardDataByIndex(i,0)
                    cclog("lv,oldExp,currExp,maxExp,levelFlag = " .. lv .. ";" .. oldExp .. ";" .. currExp .. ";" .. maxExp .. ";" .. tostring(levelFlag))
                    if lv then
                        heroExpBar = ExtProgressTime:createWithFrameName("o_public_skillExpBg.png","o_public_skillExp.png");
                        heroExpBar:setAnchorPoint(ccp(0.5,0.5));
                        heroExpBar:setPosition(ccp(headIconSprSize.width*0.5,-headIconSprSize.height * 0.1));
                        heroExpBar:setMaxValue(maxExp);
                        heroExpBar:registerScriptBarHandler(playerHeroExpAnimEnd);
                        heroExpBar:setCurValue(oldExp,false);
                        heroExpBar:setCurValue(currExp,true);
                        heroExpBar:setTag(i);
                        itemBg:addChild(heroExpBar);
                        local label_temp = game_util:createLabel({text = "Lv."..lv}) --CCLabelTTF:create("Lv."..lv,TYPE_FACE_TABLE.Arial_BoldMT,12);
                        label_temp:setAnchorPoint(ccp(0,0.5));
                        -- label_temp:setColor(ccc3(255,255,255));
                        label_temp:setPosition(ccp(0,headIconSprSize.height * 0.1));
                        itemBg:addChild(label_temp,0,10);
                        cardItemTab[i] = {heroExpBar = heroExpBar,lvLabel = label_temp,currentStep = 0,levelFlag=levelFlag,cardId = self.m_AtkData[i].data_id,itemBg = itemBg}
                    end
                    showIndex = showIndex + 1;
                end
                if i == 5 then 
                    showIndex = 6 
                end
            end
        end 
        heroExpAnim();
end

--[[----
    卡牌獎勵
]]
function battle_over_scene.showRewardCharacter(self)
        local bar = self.m_expBar;
        local ccbNode = self.m_ccbNode;
        local battle_rewards = self.m_tGameData.battle_rewards
        if battle_rewards == nil then 
            cclog("battle_rewards == nil")
            return 
        end
        local reward_character = battle_rewards.reward_character or {}
        local reward_character_count = game_util:getTableLen(reward_character)
        -- 顯示戰鬥獎勵
        local function showRewardCharacter()
            cclog("showRewardCharacter =================================");
            cclog("reward_character_count ===================="..reward_character_count);
            if reward_character_count == 0 then 
                return 
            end
            self.m_reward_node_3:setVisible(true)
            local reward_character_item = nil;
            local c_id = nil;
            local itemConfig = nil;
            local img = nil;
            local headIconSpr = nil;
            local characterName = nil;
            local posIndex = 1;
            for k,reward_character_item in pairs(reward_character) do
                headIconSpr = ccbNode:spriteForName("m_props_" .. posIndex)
                if headIconSpr then
                    c_id = reward_character_item.c_id;
                    itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(c_id);
                    img = itemConfig:getNodeWithKey("img"):toStr();
                    characterName = itemConfig:getNodeWithKey("name"):toStr();
                    cclog("characterName img->"..img)
                    cclog("characterName->"..characterName)
                    local headIconSprSize = headIconSpr:getContentSize();
                    local icon = game_util:createIconByName(img);
                    headIconSpr:setDisplayFrame(icon:displayFrame());
                    -- headIconSpr:setScale(headIconSprSize.width / 64);
                    headIconSpr:setColor(ccc3(0,0,0));
                    local label_temp = CCLabelTTF:create(tostring(characterName),TYPE_FACE_TABLE.Arial_BoldMT,10);
                    label_temp:setPosition(ccp(headIconSprSize.width * 0.5,headIconSprSize.height * 0.5));
                    headIconSpr:addChild(label_temp,0,10);
                    label_temp:setVisible(false)
                    local function objectReset( node )
                        --headIconSpr:setColor(ccc3(255,255,255));
                        local sprite = tolua.cast(node,"CCSprite");
                        sprite:setColor(ccc3(255,255,255));

                    end
                    local function addNameLable(node)
                        --label_temp:setVisible(true)
                    end
                    local arr = CCArray:create();
                    arr:addObject(CCOrbitCamera:create(0.5 , 1 , 0 , 0 , 90 , 0, 0));
                    arr:addObject(CCCallFuncN:create(objectReset));
                    arr:addObject(CCOrbitCamera:create(0.5 , 1 , 0 , 90, 90 , 0, 0));
                    arr:addObject(CCCallFuncN:create(addNameLable));
                    headIconSpr:runAction(CCSequence:create(arr));
                end
                posIndex = posIndex + 1;
            end
            for i = posIndex,5 do
                headIconSpr = ccbNode:spriteForName("m_props_" .. i)
                headIconSpr:setVisible(false)
            end
        end
        showRewardCharacter();
end

function battle_over_scene.getTipsDataToShow ( self, data )
    local tipInfo = {}

    local allData = json.decode(data)
    if allData then
        -- print("allData.reward", allData.reward)
        -- print("allData.once", allData.once)
        if allData.reward == true then 
            tipInfo.reward = ture
        end
        if allData.once == true then
            tipInfo.once = true
        end
        if allData.online_award_expire == 0 then
            tipInfo.online_award = true
        end
    end
    return tipInfo
end
--[[----
    刷新ui
]]
function battle_over_scene.refreshUi(self)

end

--[[----
    初始化
]]
function battle_over_scene.init(self,t_params)
    t_params = t_params or {};
    -- body
    self.m_tGameData = t_params.gameData or {};
    self.m_AtkData = {};
    if self.m_tGameData and self.m_tGameData.battle then
        self.m_AtkData = self.m_tGameData.battle.init.atk or {};
        self.m_godgiftTab = self.m_tGameData.godgift or {};
        self.m_next_step = self.m_tGameData.next_step or -1;
        self.m_buildingId = self.m_tGameData.building
        self.m_cityId = self.m_tGameData.city
    end
    self.m_backGroundName = t_params.backGroundName
    self.m_callFunc = t_params.callFunc;
    self.returnType = t_params.returnType;
    -- cclog(json.encode(self.m_AtkData))
    for k,v in pairs(self.m_AtkData) do
        if type(v) == "table" and v["id"] then
            -- cclog("v[\"id\"] ======================== " .. tostring(v["id"]))
            local valueTab = util.stringSplit(tostring(v["id"]),"_");
            v.data_id = valueTab[2];
        else
            self.m_AtkData[k] = {};
        end
    end
    self.m_screenShoot = t_params.screenShoot;
    self.m_requestFlag  = false;
end

--[[----
    創建ui入口並初始化數據
]]
function battle_over_scene.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    local battleType = game_data:getBattleType();
    if battleType == "help_recapture" then
        local reward = self.m_tGameData.reward or {}
        game_util:rewardTipsByDataTable(reward);
    end
    return scene;
end

return battle_over_scene;�6 