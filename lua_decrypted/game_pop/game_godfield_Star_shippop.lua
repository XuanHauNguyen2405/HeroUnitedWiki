--- 飞船信息弹出
local game_godfield_Star_shippop = {
    table_view_node = nil,
    m_ship_sp = nil,
    name_lable = nil,
    lv_lable = nil,
    qufu_lable = nil,
    combat_lable = nil,
    union_lable = nil,
    m_chexiao_btn = nil,
};

--[[--
    销毁
]]
function game_godfield_Star_shippop:destroy()
    -- body
    cclog("-----------------game_godfield_Star_shippop destroy-----------------");
    self.table_view_node = nil;
    self.m_ship_sp = nil;
    self.name_lable = nil;
    self.lv_lable = nil;
    self.qufu_lable = nil;
    self.combat_lable = nil;
    self.union_lable = nil;
end
--[[--
    返回
]]
function game_godfield_Star_shippop:back(type)
    game_scene:removePopByName("game_godfield_Star_shippop");
    local check = game_data:getGod_Star_check_msg("game_god_Star_employ")
    local function responseMethod( tag,gameData )
        game_scene:enterGameUi("game_god_pyramid_palace",{gameData = gameData,palace_id = check.floor})
    end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("zodiac_go_fight"),http_request_method.GET,{floor = check.floor},"zodiac_go_fight")
   
end
--[[--
    读取ccbi创建ui
]]
function game_godfield_Star_shippop:createUi()
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        -- cclog(btnTag,"-------------btnTag" .. btnTag .. "-------------")
        if btnTag == 1 then
            self:back();
        elseif btnTag == 5 then
            local function responseMethod(  tag,gameData )
                game_scene:addPop("game_godfield_Star_zhenxing",{gameData = gameData,openType = "palace_battle"})
            end
        	network.sendHttpRequest(responseMethod,game_url.getUrlForKey("zodiac_god_field_ids"),http_request_method.GET,nil,"zodiac_god_field_ids")
        elseif btnTag == 6 then
            local god_Star_check_msg = game_data:getGod_Star_check_msg("game_god_pyramid_palace")
            local t_params = {
                    title = string_config.m_title_prompt,
                    okBtnCallBack = function(target,event)
                        game_util:closeAlertView();
                        local function responseMethod( tag,gameData )
                            if gameData and tolua.type(gameData) == "util_json" then
                                game_util:addMoveTips({text="Đã hủy nhóm này"})
                                 game_scene:enterGameUi("game_god_pyramid_palace",{gameData = gameData,palace_id = god_Star_check_msg.floor})
                                -- self:back()
                            end
                        end
                        
                        local params = {}
                        params.team = self.m_tGameData.team_id
                        params.floor = god_Star_check_msg.floor
                        params.pos = god_Star_check_msg.pos
                        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("zodiac_remove_floor_pos2"), http_request_method.GET, params,"zodiac_remove_floor_pos")
                    end,   --可缺省
                    cancelBtnCallBack = function(target,event)
                        game_util:closeAlertView();
                    end,
                    okBtnText = "Xác nhận",       --可缺省
                    cancelBtnText = "Hủy",
                    onlyOneBtn = false,
                    text ="    Xác định muốn hủy nhóm?",      --可缺省
                    touchPriority = GLOBAL_TOUCH_PRIORITY-12,
                }
                game_util:openAlertView(t_params);
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_godfield_Star_ship_pop.ccbi");
    self.table_view_node=ccbNode:nodeForName("table_view_node")
    self.name_lable = ccbNode:labelTTFForName("name_lable")
    self.lv_lable = ccbNode:labelTTFForName("lv_lable")
    self.qufu_lable = ccbNode:labelTTFForName("qufu_lable")
    self.combat_lable = ccbNode:labelTTFForName("combat_lable")
    self.union_lable = ccbNode:labelTTFForName("union_lable") 
    self.m_sp_node = ccbNode:nodeForName("L_sp_node")
    self.m_sprite_lucksign = ccbNode:spriteForName("m_sprite_lucksign")   
    self.m_root_layer = ccbNode:layerForName('m_root_layer')
    self.rob_btn = ccbNode:controlButtonForName("rob_btn")
    self.m_close_btn = ccbNode:controlButtonForName("m_close_btn")
    self.m_chexiao_btn = ccbNode:controlButtonForName("m_chexiao_btn")
    self.chousha_sp = ccbNode:spriteForName("chousha_sp")
    if self.isEnemy then
        self.chousha_sp:setVisible(true)
    else
        self.chousha_sp:setVisible(false)
    end
    if self.isMine then
        self.rob_btn:setVisible(false)
        self.m_chexiao_btn:setVisible(true)
    else
        self.rob_btn:setVisible(true)
        self.m_chexiao_btn:setVisible(false)
    end
    self.m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-7)
    self.rob_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-7)
    self.m_chexiao_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-7)
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;
        elseif eventType == "ended" then

        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-6,true)
    self.m_root_layer:setTouchEnabled(true)
    self.m_ccbNode = ccbNode;
    return ccbNode;
end

function game_godfield_Star_shippop:refreshUi()
    self.qufu_lable:setString(self.m_tGameData["server"] or "")
    self.name_lable:setString(self.m_tGameData["name"] or "")
    self.lv_lable:setString(self.m_tGameData["level"] or "")
    self.combat_lable:setString(self.m_tGameData["combat"] or "")
    self.union_lable:setString(self.m_tGameData["guild"] or "")
    self.m_sprite_lucksign:setVisible(self.isLucky)
    local roleId = self.m_tGameData.role or math.random(1, 5)
    local img = self:createBigImg(roleId)
    img:setAnchorPoint(ccp(0.5, 0.5))
    img:setPositionX(self.m_sp_node:getContentSize().width * 0.5)
    img:setScale(0.4)
    self.m_sp_node:addChild(img)
    self.table_view_node:removeAllChildrenWithCleanup(true)
    if self.m_tGameData["server"] == "NPC" then
        self.table_view_node:addChild(self:createNpcZhenRongList(self.table_view_node:getContentSize()))
    else
        self.table_view_node:addChild(self:createZhenRongList(self.table_view_node:getContentSize()))
    end
end

function game_godfield_Star_shippop:createBigImg(roleId)
    local role_detail_cfg = getConfig(game_config_field.role_detail);
    local itemCfg = role_detail_cfg:getNodeWithKey(tostring(roleId))
    return game_util:createPlayerBigImgByCfg(itemCfg);
end

function game_godfield_Star_shippop:createZhenRongList(viewSize)
    local character_detail_cfg = getConfig("character_detail")
    local heroCfg = nil
    local team = self.m_tGameData.alignment_info
    local showData = {}
    for k,v in pairs(team) do
        if v.c_id then
            table.insert(showData,v)
        end
    end
    -- cclog2(showData,"showData")
    local itemCount =game_util:getTableLen(showData)
    local params = {};
    params.viewSize = viewSize;
    params.row = 1;
    if itemCount > 5 then
        params.column = 5;
    else
        params.column = itemCount;
    end 
    params.direction = kCCScrollViewDirectionHorizontal;
    params.totalItem = itemCount;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 8;
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height/params.row);
    self.m_cellSize = itemSize
    self.m_cellCount = itemCount
    params.newCell = function ( tableView, index )
        local cell = tableView:dequeueCell();
        if cell == nil then 
            cell = CCTableViewCell:new()
            cell:autorelease();
        end
        if cell then  
            cell:removeAllChildrenWithCleanup(true)
            local itemData = showData[index + 1]
            -- cclog2(itemData,"itemCount------------")
            if itemData and itemData.c_id then
                heroCfg = character_detail_cfg:getNodeWithKey(itemData.c_id);
                -- cclog2(heroCfg,"heightfdnsajkfhbdbgndflskbhvdas" .. index + 1)
                if itemData and heroCfg then
                    headIconSpr = game_util:createCardIconByCfg(heroCfg,itemData);
                    if headIconSpr then
                        headIconSpr:setScale(0.8);
                        headIconSpr:setPosition(itemSize.width * 0.5, itemSize.height * 0.5);
                        cell:addChild(headIconSpr,1,1);

                        local node = headIconSpr:getChildByTag(1)
                        if node then
                            node:setVisible(false)
                        end

                        local sprBoard = CCSprite:createWithSpriteFrameName("ui_pyramid_n_kuang3.png")
                        if sprBoard then
                            sprBoard:setPosition(itemSize.width * 0.5, itemSize.height * 0.5)
                            sprBoard:setScale(0.8);
                            cell:addChild(sprBoard, 20, 20)
                        end
                    end
                end
            end
        end
        return cell
    end
    params.itemOnClick = function ( eventType, index, cell )
        if eventType == "ended" then
            local itemData = showData[index + 1]
            if itemData then
                game_scene:addPop("game_hero_info_pop",{tGameData = itemData,openType = 3})
            else 
                game_util:addMoveTips({text = "Thông tin thẻ sai!"})
            end
        end
    end
    return TableViewHelper:create(params) 
end

function game_godfield_Star_shippop:createNpcZhenRongList(viewSize)
    local character_detail_cfg = getConfig("constellation_enemy")
    local heroCfg = nil
    local team = self.m_tGameData.alignment_info
    local showData = {}
    for k,v in pairs(team) do
        if v.c_id then
            table.insert(showData,v)
        end
    end
    local itemCount =game_util:getTableLen(showData) 
    local params = {};
    params.viewSize = viewSize;
    params.row = 1;
    if itemCount > 5 then
        params.column = 5;
    else
        params.column = itemCount;
    end  
    params.direction = kCCScrollViewDirectionHorizontal;
    params.totalItem = itemCount;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 8;
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height/params.row);
    self.m_cellSize = itemSize
    self.m_cellCount = itemCount
    params.newCell = function ( tableView, index )
        local cell = tableView:dequeueCell();
        if cell == nil then 
            cell = CCTableViewCell:new()
            cell:autorelease();
        end
        if cell then  
            cell:removeAllChildrenWithCleanup(true)
            local itemData = showData[index + 1]
            if itemData and itemData.c_id then
                heroCfg = character_detail_cfg:getNodeWithKey(tostring(itemData.c_id));
                if itemData and heroCfg then
                    headIconSpr = game_util:createCardIconByCfg(heroCfg,heroCfg);
                    if headIconSpr then
                        headIconSpr:setScale(0.8);
                        headIconSpr:setPosition(itemSize.width * 0.5, itemSize.height * 0.5);
                        cell:addChild(headIconSpr,1,1);

                        local node = headIconSpr:getChildByTag(1)
                        if node then
                            node:setVisible(false)
                        end

                        local sprBoard = CCSprite:createWithSpriteFrameName("ui_pyramid_n_kuang3.png")
                        if sprBoard then
                            sprBoard:setPosition(itemSize.width * 0.5, itemSize.height * 0.5)
                            sprBoard:setScale(0.8);
                            cell:addChild(sprBoard, 20, 20)
                        end
                    end
                end
            end
        end
        return cell
    end
    params.itemOnClick = function ( eventType, index, cell )
        if eventType == "ended" then
            local itemData = showData[index + 1]
            heroCfg = character_detail_cfg:getNodeWithKey(itemData.c_id);
            local heroData = heroCfg
            if tolua.type(heroData) == "util_json" then
               heroData = json.decode(heroData:getFormatBuffer()) or {};
            end  
            game_scene:addPop("game_hero_info_pop",{tGameData = heroData,openType = 3})
        end
    end
    return TableViewHelper:create(params) 
end

--[[--
    初始化
]]
function game_godfield_Star_shippop:init(t_params)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_server_pyramid_n_res.plist");
    t_params = t_params or {}
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {}
        self.isMine = t_params.isMine or false
        self.isLucky = t_params.isLucky or false
        self.isEnemy = t_params.isEnemy or false
        -- cclog(self.isEnemy)
    end
    -- cclog2(self.m_tGameData,"game_godfield_Star_shippop ----------------- self.m_tGameData ")
end

--[[--
    创建ui入口并初始化数据
]]
function game_godfield_Star_shippop:create(t_params)
    self:init(t_params);
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

return game_godfield_Star_shippop;�5  