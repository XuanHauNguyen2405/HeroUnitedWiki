--- 神域竞技场

local game_godfield_pvp = {
    m_tGameData = nil,
    m_close_btn = nil,
    m_ccbNode = nil,
    my_level_icon = nil,
    m_reward_list_node_1 = nil,
    m_my_rank_lab = nil,
    m_hero_icon_1 = nil,
    m_hero_icon_2 = nil,
    m_hero_icon_3 = nil,
    m_pipei_lab_1 = nil,
    m_pipei_lab_2 = nil,
    m_pipei_lab_3 = nil,
    m_hero_name_lab1 = nil,
    m_hero_name_lab2 = nil,
    m_hero_name_lab3 = nil,
    m_hero_zhanli1 = nil,
    m_hero_zhanli2 = nil,
    m_hero_zhanli3 = nil,
    m_shengyu_lab = nil,
    m_enmy_battle_lab = nil,
    m_shop_btn = nil,
    m_rank_btn = nil,
    m_battle_info_btn = nil,
    m_rule_btn = nil,
    m_xiuxian_btn = nil,
    m_jingji_btn = nil,
    m_jinji_btn = nil,
    hero_name_tab = nil,
    hero_battle_tab = nil,
    hero_icon_tab = nil,
    enemy_info = nil,
    enemy_index = nil,
    battle_flag = nil,
    m_jifen_lab = nil,
    m_num_lab = nil,
    m_coin_sp = nil,
    btnFlag = nil,
    m_root_layer = nil,
};
--[[--
    销毁
]]
function game_godfield_pvp.destroy(self)
    -- body
    cclog("-----------------game_godfield_pvp destroy-----------------");
    self.m_tGameData = nil;
    self.m_close_btn = nil;
    self.m_ccbNode = nil;
    self.my_level_icon = nil;
    self.m_reward_list_node_1 = nil;
    self.m_my_rank_lab = nil;
    self.m_hero_icon_1 = nil;
    self.m_hero_icon_2 = nil;
    self.m_hero_icon_3 = nil;
    self.m_pipei_lab_1 = nil;
    self.m_pipei_lab_2 = nil;
    self.m_pipei_lab_3 = nil;
    self.m_hero_name_lab1 = nil;
    self.m_hero_name_lab2 = nil;
    self.m_hero_name_lab3 = nil;
    self.m_hero_zhanli1 = nil;
    self.m_hero_zhanli2 = nil;
    self.m_hero_zhanli3 = nil;
    self.m_shengyu_lab = nil;
    self.m_enmy_battle_lab = nil;
    self.m_shop_btn = nil;
    self.m_rank_btn = nil;
    self.m_battle_info_btn = nil;
    self.m_rule_btn = nil;
    self.m_xiuxian_btn = nil;
    self.m_jingji_btn = nil;
    self.m_jinji_btn = nil;
    self.hero_name_tab = {};
    self.hero_battle_tab = {};
    self.hero_icon_tab = {};
    self.enemy_info = {};
    self.enemy_index = nil;
    self.battle_flag = nil;
    self.m_jifen_lab = nil;
    self.m_num_lab = nil;
    self.m_coin_sp = nil;
    self.btnFlag = nil;
    self.m_root_layer = nil;
end
--[[--
    返回
]]
function game_godfield_pvp.back(self,type)
    local function responseMethod(tag,gameData)
        game_scene:enterGameUi("game_homeLand_main",{gameData = gameData});
    end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_index"), http_request_method.GET, nil,"homeland_index") 
end
--[[--
    读取ccbi创建ui
]]
function game_godfield_pvp.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then--关闭
            if self.m_shared then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared);
            end
            self:back();
        elseif btnTag == 11 then --规则
            if self.m_shared then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared);
            end
            local activeCfg = getConfig(game_config_field.notice_active)
            local itemCfg = activeCfg:getNodeWithKey( tostring(173) )
            itemCfg = json.decode(itemCfg:getFormatBuffer())
            local openMsg = itemCfg.word
            game_scene:addPop("game_godfield_detail_pop",{openMsg = openMsg})
        
        elseif btnTag == 12 then -- 战报
            if self.m_shared then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared);
            end
            local function responseMethod( tag,gameData )
                game_scene:addPop("game_godfield_battleNews",{gameData = gameData});
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_get_own_logs"), http_request_method.GET, params,"god_arena_get_own_logs")
        
        elseif btnTag == 13 then --商店
            if self.m_shared then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared);
            end
            local function responseMethod( tag,gameData )
                local my_flag = "game_godfield_pvp_shop"
                game_scene:enterGameUi("game_godfield_pvp_shop",{gameData = gameData,openType = my_flag});  
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_shop_index"), http_request_method.GET, params,"god_arena_shop_index")
         
        elseif btnTag == 14 then --排行榜
            if self.m_shared then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared);
            end
            local gameData = self.m_tGameData.god_integration_rank
            local function responseMethod( tag,gameData )
                local my_flag = "game_godfield_pvp"
                game_scene:enterGameUi("game_godfield_arena_rank",{gameData = gameData,my_flag = my_flag});  
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_top"), http_request_method.GET, params,"god_arena_top")
         
        elseif btnTag == 15 then --休闲匹配
            local params = {}
            params.sort = 1

            local function responseMethod( tag,gameData )
                 if gameData ~= nil and tolua.type(gameData) == "util_json" then
                    local sort = 1
                   local data1 = gameData:getNodeWithKey("data");
                   data1 = json.decode(data1:getFormatBuffer())
                   self.m_tGameData = data1
                  end
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_leisure_match"), http_request_method.GET, params,"god_arena_leisure_match")
            self:runEnemyIcon();
            
        elseif btnTag == 16 then --竞技匹配
            if self.btnFlag == true then
                self.btnFlag = false;
                local params = {}
                params.sort = 1
                local function responseMethod( tag,gameData )
                     if gameData ~= nil and tolua.type(gameData) == "util_json" then
                        local sort = 1
                        local data1 = gameData:getNodeWithKey("data");
                        data1 = json.decode(data1:getFormatBuffer())
                        self.m_tGameData = data1
                        -- game_util:setCCControlButtonBackground(self.m_jingji_btn,"god_pvp_restart.png")
                        self:refreshLabel()
                        self:runEnemyIcon();
                      end
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_leisure_match"), http_request_method.GET, params,"god_arena_leisure_match")
            end
        elseif btnTag == 17 then --第一个人
            if self.battle_flag == true then
                local params = {}
                params.sort = 1;
                local enemyRank = self.m_tGameData.chosen_three[1].rank;
                params.rank = enemyRank;
                local function responseMethod( tag,gameData )
                     if gameData ~= nil and tolua.type(gameData) == "util_json" then
                        local sort = 1;
                        local enemyRank = self.m_tGameData.chosen_three[1].rank;
                        game_scene:addPop("game_godfield_pvp_pop",{gameData = gameData,sort = sort,enemyRank = enemyRank})
                    end
                    
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_show_enemy_detail"), http_request_method.GET, params,"god_arena_show_enemy_detail")
            end
        elseif btnTag == 18 then --第二个人
            local params = {}
            params.sort = 1;
            local enemyRank = self.m_tGameData.chosen_three[2].rank;
            params.rank = enemyRank;
            if self.battle_flag == true then
                local function responseMethod( tag,gameData )
                     if gameData ~= nil and tolua.type(gameData) == "util_json" then
                        local sort = 2;
                        local enemyRank = self.m_tGameData.chosen_three[2].rank;
                        game_scene:addPop("game_godfield_pvp_pop",{gameData = gameData,sort = sort,enemyRank = enemyRank})
                    end
                    
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_show_enemy_detail"), http_request_method.GET, params,"god_arena_show_enemy_detail")
            end
        elseif btnTag == 19 then --第三个人
            local params = {}
            params.sort = 1;
            local enemyRank = self.m_tGameData.chosen_three[3].rank;
            params.rank = enemyRank;
            if self.battle_flag == true then
                local function responseMethod( tag,gameData )
                     if gameData ~= nil and tolua.type(gameData) == "util_json" then
                        local sort = 3;
                        local enemyRank = self.m_tGameData.chosen_three[3].rank;
                        game_scene:addPop("game_godfield_pvp_pop",{gameData = gameData,sort = sort,enemyRank = enemyRank})
                    end
                    
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_show_enemy_detail"), http_request_method.GET, params,"god_arena_show_enemy_detail")
            end
        elseif btnTag == 20 then --晋级 
            if self.m_shared then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared);
            end
            local function responseMethod( tag,gameData )
                local my_flag = "game_godfield_pvp"
                game_scene:addPop("game_godfield_arena_up", {gameData = gameData,flag = my_flag});  
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_show_stage_up_enemy"), http_request_method.GET, params,"god_arena_show_stage_up_enemy")
         
        elseif btnTag == 110 then
            local vipCfg = getConfig(game_config_field.vip);
            local vip_level = game_data:getVipLevel();
            local nowCfg = vipCfg:getNodeWithKey(tostring(vip_level));
            local buy_limit = nowCfg:getNodeWithKey("buy_arena"):toInt()
            if buy_limit > self.m_tGameData.buy_count then
                local payCfg = getConfig(game_config_field.pay)
                local reviveCfg = payCfg:getNodeWithKey("3"):getNodeWithKey("coin")
                local time = self.m_tGameData.buy_count
                if time >= reviveCfg:getNodeCount() then
                    time = reviveCfg:getNodeCount() - 1
                end
                local coin = reviveCfg:getNodeAt(time):toInt()
                local t_params = 
                {
                    title = string_config.m_title_prompt,
                    okBtnCallBack = function(target,event)
                        game_util:closeAlertView();
                        local function responseMethod( tag,gameData )
                            if gameData then 
                                local function responseMethod( tag,gameData )
                                    game_util:addMoveTips({text = "Đã mua khiêu chiến!"});
                                    local data = gameData:getNodeWithKey("data");
                                    data = json.decode(data:getFormatBuffer())
                                    self.m_tGameData = data
                                    self:refreshLabel()
                                end
                                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena"), http_request_method.GET, {},"god_arena")
                            end
                        end
                        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena_buy_count"), http_request_method.GET, {},"god_arena_buy_count")
                    end,   --可缺省
                    cancelBtnCallBack = function(target,event)
                        game_util:closeAlertView();
                    end,
                    okBtnText = "Xác nhận",       --可缺省
                    cancelBtnText = "Hủy",
                    onlyOneBtn = false,

                    text ="    Tốn" .. coin .. "Xu mua 1 lần chiến đấu? (Nếu dùng Giấy khiêu chiến Thần Vực Đấu sẽ trừ Giấy khiêu chiến, không tốn Xu)",      --可缺省
                    touchPriority = GLOBAL_TOUCH_PRIORITY-2,
                }
                game_util:openAlertView(t_params);
                end
            else
                game_util:addMoveTips({text = "Số lần mua hôm nay đã max!"})
            end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_godfield_Arena.ccbi");
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/god_pvp.plist");
    self.m_root_layer = ccbNode:layerForName("m_root_layer");
    self.m_close_btn = ccbNode:controlButtonForName("m_close_btn");
    self.my_level_icon = ccbNode:nodeForName("my_level_icon");
    self.m_reward_list_node_1 = ccbNode:nodeForName("m_reward_list_node_1");
    self.m_my_rank_lab = ccbNode:labelTTFForName("m_my_rank_lab");
    self.m_hero_icon_1 = ccbNode:nodeForName("m_hero_icon_1");
    self.m_hero_icon_2 = ccbNode:nodeForName("m_hero_icon_2");
    self.m_hero_icon_3 = ccbNode:nodeForName("m_hero_icon_3");
    self.m_pipei_lab_1 = ccbNode:labelTTFForName("m_pipei_lab_1");
    self.m_pipei_lab_2 = ccbNode:labelTTFForName("m_pipei_lab_2");
    self.m_pipei_lab_3 = ccbNode:labelTTFForName("m_pipei_lab_3");
    self.m_hero_name_lab1 = ccbNode:labelTTFForName("m_hero_name_lab1");
    self.m_hero_name_lab2 = ccbNode:labelTTFForName("m_hero_name_lab2")
    self.m_hero_name_lab3 = ccbNode:labelTTFForName("m_hero_name_lab3");
    self.m_hero_zhanli1 = ccbNode:labelTTFForName("m_hero_zhanli1");
    self.m_hero_zhanli2 = ccbNode:labelTTFForName("m_hero_zhanli2");
    self.m_hero_zhanli3 = ccbNode:labelTTFForName("m_hero_zhanli3");
    self.m_shengyu_lab = ccbNode:labelTTFForName("m_shengyu_lab");
    self.m_enmy_battle_lab = ccbNode:labelTTFForName("m_enmy_battle_lab");
    self.m_shop_btn = ccbNode:controlButtonForName("m_shop_btn"); --商店
    self.m_rank_btn = ccbNode:controlButtonForName("m_rank_btn"); --排行榜
    self.m_battle_info_btn = ccbNode:controlButtonForName("m_battle_info_btn"); --战报
    self.m_rule_btn = ccbNode:controlButtonForName("m_rule_btn");--规则
    self.m_xiuxian_btn = ccbNode:controlButtonForName("m_xiuxian_btn"); --休闲匹配
    self.m_jingji_btn = ccbNode:controlButtonForName("m_jingji_btn"); --竞技匹配
    self.m_jinji_btn = ccbNode:controlButtonForName("m_jinji_btn"); -- 晋级
    self.m_jifen_lab = ccbNode:labelTTFForName("m_jifen_lab");
    self.m_num_lab = ccbNode:labelTTFForName("m_num_lab");
    self.m_coin_sp = ccbNode:spriteForName("m_coin_sp");
    local btn_buchong = ccbNode:spriteForName("btn_buchong");
    self.hero_name_tab = {self.m_hero_name_lab1,self.m_hero_name_lab2,self.m_hero_name_lab3};
    self.hero_battle_tab = {self.m_hero_zhanli1,self.m_hero_zhanli2,self.m_hero_zhanli3};
    self.hero_icon_tab = {self.m_hero_icon_1,self.m_hero_icon_2,self.m_hero_icon_3};
    self.hero_paiming = {self.m_pipei_lab_1,self.m_pipei_lab_2,self.m_pipei_lab_3};
    
    local m_bg_sprite = ccbNode:spriteForName("m_bg_sprite")
    m_bg_sprite:setScaleX(resolution_config:getScale())

    for i=1,3 do
        self.hero_name_tab[i]:setVisible(false)
        self.hero_battle_tab[i]:setVisible(false)
        local enemyIcon = CCSprite:createWithSpriteFrameName("god_pvp_wenhao.png");
        if enemyIcon then
            -- cclog2(i,"i---------s")
            local enemyIconSize = self.my_level_icon:getContentSize();
            enemyIcon:setPosition(ccp(enemyIconSize.width*0.5,enemyIconSize.height*0.5));
            self.hero_icon_tab[i]:addChild(enemyIcon);
        end
    end

    local animName = "enter_anim"
    local function animCallFunc(animName)
        ccbNode:runAnimations(animName)
    end
    ccbNode:registerAnimFunc(animCallFunc);
    ccbNode:runAnimations(animName)
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;
        elseif eventType == "ended" then
            return false;
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY,true);
    self.m_root_layer:setTouchEnabled(true);
    self.m_ccbNode = ccbNode;
    return ccbNode;
end

function game_godfield_pvp.runEnemyIcon( self )
    self.enemy_info = self.m_tGameData.chosen_three
    -- cclog2(self.enemy_info,"self.enemy_infoself.enemy_info")
    self.m_shared = nil;
    local count = 100;
    function tick( dt )
        count = count - 1
        -- cclog2(count,"count-------")
        if count >= 90  then
            self:addEnemyIcon(1);
            if count == 90 then
                self.hero_paiming[1]:setString("Hạng" .. self.enemy_info[1]["rank"]);
                self.hero_name_tab[1]:setString(self.enemy_info[1]["name"]);
                self.hero_name_tab[1]:setVisible(true);
                self.hero_battle_tab[1]:setString("Lực chiến：" .. self.enemy_info[1]["combat"]);
                self.hero_battle_tab[1]:setVisible(true);
                -- self.hero_paiming[1]:setcolor(ccc3(255,198,0));
                self.hero_icon_tab[1]:removeAllChildrenWithCleanup(true);
                local enemyIconSize = self.hero_icon_tab[1]:getContentSize();
                local tempIcon = game_util:createPlayerIconByRoleId(self.enemy_info[1]["role"])
                if tempIcon then
                    tempIcon:setPosition(ccp(enemyIconSize.width*0.5, enemyIconSize.height*0.5))
                    self.hero_icon_tab[1]:addChild(tempIcon);
                end

            end
        end
        if count >= 80 then
            self:addEnemyIcon(2);
            if count == 80 then
                self.hero_paiming[2]:setString("Hạng" .. self.enemy_info[2]["rank"]);
                self.hero_name_tab[2]:setString(self.enemy_info[2]["name"]);
                self.hero_name_tab[2]:setVisible(true);
                self.hero_battle_tab[2]:setString("Lực chiến：" .. self.enemy_info[2]["combat"]);
                self.hero_battle_tab[2]:setVisible(true);
                -- self.hero_paiming[2]:setcolor(ccc3(255,198,0));
                self.hero_icon_tab[2]:removeAllChildrenWithCleanup(true);
                local enemyIconSize = self.hero_icon_tab[2]:getContentSize();
                local tempIcon = game_util:createPlayerIconByRoleId(self.enemy_info[2]["role"])
                if tempIcon then
                    tempIcon:setPosition(ccp(enemyIconSize.width*0.5, enemyIconSize.height*0.5))
                    self.hero_icon_tab[2]:addChild(tempIcon);
                end
            end
        end
        if count >= 70 then
            self:addEnemyIcon(3);
            if count == 70 then
                self.hero_paiming[3]:setString("Hạng" .. self.enemy_info[3]["rank"]);
                self.hero_name_tab[3]:setString(self.enemy_info[3]["name"]);
                self.hero_name_tab[3]:setVisible(true);
                self.hero_battle_tab[3]:setString("Lực chiến：" .. self.enemy_info[3]["combat"]);
                self.hero_battle_tab[3]:setVisible(true);
                -- self.hero_paiming[3]:setcolor(ccc3(255,198,0));
                self.hero_icon_tab[3]:removeAllChildrenWithCleanup(true);
                local enemyIconSize = self.hero_icon_tab[3]:getContentSize();
                local tempIcon = game_util:createPlayerIconByRoleId(self.enemy_info[3]["role"])
                if tempIcon then
                    tempIcon:setPosition(ccp(enemyIconSize.width*0.5, enemyIconSize.height*0.5))
                    self.hero_icon_tab[3]:addChild(tempIcon);
                end
            end
        else 
            self.battle_flag = true;
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared);
            self.btnFlag = true;
            self.m_root_layer:setTouchEnabled(false);
        end
        
    end
    self.m_shared = scheduler.schedule(tick, 1/10, false)
end

function game_godfield_pvp.addEnemyIcon( self,num )
    self.hero_icon_tab[num]:removeAllChildrenWithCleanup(true);
    local enemyIconSize = self.hero_icon_tab[num]:getContentSize();
    local count = math.random(1,4);
    local adAnimition = CCSprite:createWithSpriteFrameName("icon_hero" .. count ..".png");
    adAnimition:setPosition(ccp(enemyIconSize.width*0.5, enemyIconSize.height*0.5))
    self.hero_icon_tab[num]:addChild(adAnimition);
end

function game_godfield_pvp.addRankIcon( self )
    -- body
    local rank_icon_tab = {"god_pvp_Bronze","god_pvp_Silver","god_pvp_Gold","god_pvp_Platnum","god_pvp_Diamond","god_pvp_Challenger"};
    local rank_name_tab = {"god_pvp_qingtong","god_pvp_baiyin","god_pvp_huangjin","god_pvp_baijin","god_pvp_zuanshi","god_pvp_wangzhe"};
    -- local rank = self.m_game_data.current_stage;
    local rank = self.m_tGameData.current_stage;
    rank = math.max(1,rank)
    
    -- cclog2(rank,"rank=2=2=2==2=2=")
    local rankIconSpr = CCSprite:createWithSpriteFrameName(rank_icon_tab[tonumber(rank)] .. ".png");
    local rank_label = CCSprite:createWithSpriteFrameName(rank_name_tab[tonumber(rank)] .. ".png");
    if rankIconSpr then
        local rankIconBgSize = self.my_level_icon:getContentSize();
        rankIconSpr:setPosition(ccp(rankIconBgSize.width*0.5, rankIconBgSize.height*0.5))
        rank_label:setPosition(ccp(rankIconBgSize.width*0.5, rankIconBgSize.height*0.1 - 12))
        self.my_level_icon:addChild(rankIconSpr);
        self.my_level_icon:addChild(rank_label);
    end
end
function game_godfield_pvp.refreshLabel( self )
    local godfield_arena_rewardcfg = getConfig(game_config_field.godfield_arena_reward)
    local num = self.m_tGameData.current_stage; --当前阶段
    godfield_arena_rewardcfg = json.decode(godfield_arena_rewardcfg:getNodeWithKey(num):getFormatBuffer())
    -- godfield_arena_rewardcfg = json.decode(godfield_arena_rewardcfg:getFormatBuffer()) or {};

    local currentNum = godfield_arena_rewardcfg.refresh_times - self.m_tGameData.refresh_times
    if currentNum > 0 then
        self.m_num_lab:setString(tostring("Số lần:" .. currentNum))
        self.m_coin_sp:setVisible(false)
    else
        self.m_num_lab:setString(godfield_arena_rewardcfg.refresh_coins)
        self.m_coin_sp:setVisible(true)
    end
    local can_battle_times = self.m_tGameData.can_battle_times;
    self.m_shengyu_lab:setString(can_battle_times .. "/" .."10" );
    -- body
end
function game_godfield_pvp.refreshUi( self )
    -- body
    self:refreshLabel()
    self:addRankIcon();
    self:runEnemyIcon();
    self.m_reward_list_node_1:removeAllChildrenWithCleanup(true);
    local tableViewTemp = self:createRewardTableView(self.m_reward_list_node_1:getContentSize());
    self.m_reward_list_node_1:addChild(tableViewTemp);
    local rank = self.m_tGameData.rank;
    self.m_jinji_btn:setVisible(true);
    if rank > 50 then
        self.m_jinji_btn:setVisible(false);
    else
        self.m_jinji_btn:setVisible(true);
    end
    local can_battle_times = self.m_tGameData.can_battle_times;
    local combat = self.m_tGameData.combat;
    self.m_my_rank_lab:setString("Hạng".. rank);
    self.m_shengyu_lab:setString(can_battle_times .. "/" .."10" );
    self.m_enmy_battle_lab:setString(combat);
    self.m_jifen_lab:setString(tostring(self.m_tGameData.point))

    
end

--[[--
    创建列表
]]
function game_godfield_pvp.createRewardTableView(self,viewSize)
    -- local showData = {{1,0,1000},{1,0,1000},{1,0,1000},{1,0,1000},{1,0,1000},{1,0,1000},{1,0,1000},{1,0,1000}}
    local godfield_arena_rewardcfg = getConfig(game_config_field.godfield_arena_reward)
    local num = self.m_tGameData.current_stage; --当前阶段
    godfield_arena_rewardcfg = json.decode(godfield_arena_rewardcfg:getNodeWithKey(num):getNodeWithKey("daily_reward"):getFormatBuffer())
    -- cclog2(team_pk_rewardcfg,"team_pk_rewardcfg === ")
    
    local showData = godfield_arena_rewardcfg or {}
    local params = {};
    params.viewSize = viewSize;
    params.row = 2;--行
    params.column = 3; --列
    params.totalItem = #showData
    params.touchPriority = GLOBAL_TOUCH_PRIORITY+1;
    
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            -- cclog("new index ================================" .. index);
            cell = CCTableViewCell:new()
            cell:autorelease()
        end
        if cell then
            cell:removeAllChildrenWithCleanup(true);
            local icon,name,count = game_util:getRewardByItemTable(showData[index+1],false)
            if icon then
                icon:setScale(0.6);
                icon:setPosition(ccp(itemSize.width*0.5, itemSize.height*0.25))
                cell:addChild(icon)
            end
            if count then
                local tempLabel = game_util:createLabelBMFont({text = "×" .. count,color = ccc3(255,255,255),fontSize = 8});
                tempLabel:setPosition(ccp(itemSize.width*0.5, itemSize.height*0.1 - 16))
                cell:addChild(tempLabel)
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  item = " .. tolua.type(item));
            game_util:lookItemDetal(showData[index+1])
        end
    end
    return TableViewHelper:create(params);
end



--[[--
    初始化
]]
function game_godfield_pvp.init(self,t_params)
    t_params = t_params or {};
    if t_params.pvp_reward then
        local pvp_reward = t_params.pvp_reward
        game_util:rewardTipsByDataTable(pvp_reward);
    else
        local pvp_reward = game_data:getNightmareReward();
        if pvp_reward then
            game_util:rewardTipsByDataTable(pvp_reward);
            game_data:setNightmareReward();
        end
    end
    
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data");
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
    else
        self.m_tGameData = {};
    end
    self.enemy_info = {}
    self.battle_flag = false;
    self.btnFlag = false;
    
end

--[[--
    创建ui入口并初始化数据
]]
function game_godfield_pvp.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    return scene;
end

return game_godfield_pvp;   �j