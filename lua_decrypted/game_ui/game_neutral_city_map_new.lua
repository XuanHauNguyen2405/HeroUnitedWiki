---  新中立城市地图

local game_neutral_city_map_new = {
    m_land_map_layer = nil,
    m_land_map_layer_2 = nil,
    m_ccbNode = nil,
    m_visit_layer = nil,
    m_visit_list_view_bg = nil,
    m_visit_node_btn = nil,
    m_bar_1 = nil,
    m_bar_label_1 = nil,
    m_bar_2 = nil,
    m_bar_label_2 = nil,
    m_own_node = nil,
    m_ohter_node = nil,
    m_ohter_node_2 = nil,
    m_name_node = nil,
    m_home_type = nil,
    m_home_name_label = nil,
    m_player_icon_node = nil,
    m_pos_land_node_tab = nil,
    m_tickFlag = nil,
    m_autoRefreshScheduler = nil,
    m_auto_time = nil,
    m_countdown_node = nil,
    m_time_node = nil,
};

local AUTO_REFRESH_TIME = 5

--[[--
    销毁
]]
function game_neutral_city_map_new.destroy(self)
    cclog("-----------------game_neutral_city_map_new destroy-----------------");
    self.m_land_map_layer = nil
    self.m_land_map_layer_2 = nil
    self.m_ccbNode = nil
    self.m_visit_layer = nil
    self.m_visit_list_view_bg = nil
    self.m_visit_node_btn = nil
    self.m_bar_1 = nil
    self.m_bar_label_1 = nil
    self.m_bar_2 = nil
    self.m_bar_label_2 = nil
    self.m_own_node = nil
    self.m_ohter_node = nil
    self.m_ohter_node_2 = nil
    self.m_name_node = nil
    self.m_home_type = nil
    self.m_home_name_label = nil
    self.m_player_icon_node = nil
    self.m_pos_land_node_tab = nil
    self.m_tickFlag = nil
    if self.m_autoRefreshScheduler ~= nil then
        scheduler.unschedule(self.m_autoRefreshScheduler)
        self.m_autoRefreshScheduler = nil;
    end
    self.m_auto_time = nil
    self.m_countdown_node = nil
    self.m_time_node = nil
end

--[[--
    返回
]]
function game_neutral_city_map_new.back(self,type)
    self.m_tickFlag = false
    game_scene:enterGameUi("game_main_scene",{gameData = nil, openPop = "game_activity_new_pop"});
end

--[[--
    读取ccbi创建ui
]]
function game_neutral_city_map_new.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then --返回
            self:back();
        elseif btnTag == 2 or btnTag == 22 then --拜访
            self:visitLayerShow()
        elseif btnTag == 3 or btnTag == 12 then --掠夺
            self.m_tickFlag = false
            local function responseMethod(tag,gameData)
                self.m_tickFlag = true
                if gameData == nil then return end
                local data = gameData:getNodeWithKey("data")
                game_data:setDataByKeyAndValue("public_land_data",json.decode(data:getFormatBuffer()))
                game_data:setDataByKeyAndValue("public_land_data_time",os.time())
                self.m_home_type = 2
                self:refreshUi()
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_go_rob_index"), http_request_method.GET, nil,"public_land_go_rob_index",true,true)
        elseif btnTag == 4 then --战报
            self.m_tickFlag = false
            local function responseMethod(tag,gameData)
                self.m_tickFlag = true
                if gameData == nil then return end
                game_data:setSelNeutralBuildingId(self.m_selBuildingId);
                local data = gameData:getNodeWithKey("data")
                local rob_log = json.decode(data:getNodeWithKey("log"):getFormatBuffer())
                local function callBackFunc(typeValue,params)
                    if typeValue == "visit" then
                        self:visitPlayerByUid(params.uid,params.index)
                    end
                end
                game_scene:addPop("ui_batter_info_pop",{log_info = rob_log,openType = 4,callBackFunc = callBackFunc});
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_get_battle_log"), http_request_method.GET, nil,"public_land_get_battle_log",true,true)
        elseif btnTag == 5 then --拜访弹出按钮
            self:visitLayerHide()
        elseif btnTag == 11 or btnTag == 21 then--回家
            self.m_tickFlag = false
            local function responseMethod(tag,gameData)
                self.m_tickFlag = true
                if gameData == nil then return end
                local data = gameData:getNodeWithKey("data")
                game_data:setDataByKeyAndValue("public_land_data",json.decode(data:getFormatBuffer()))
                game_data:setDataByKeyAndValue("public_land_data_time",os.time())
                self.m_home_type = 1
                self:refreshUi()
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_index"), http_request_method.GET, nil,"public_land_index",true,true)

        elseif btnTag == 31 then -- 点击
            local m_itemId = 9101148
            local _, name = game_util:getRewardByItemTable({3, m_itemId, 1})
            local count = game_data:getItemCountByCid(m_itemId)

            if count == 0 then
                return game_util:addMoveTips({text = "Hiện chưa có thêm vật phẩm này " .. name})
            end

            local itemCount = game_data:getItemCountByCid(tostring(m_itemId))
            local t_params = 
            {
                okBtnCallBack = function(count)
                    local function responseMethod(tag,gameData)
                        game_data_statistics:useItem({itemId = m_itemId,count = count})
                        local config_date = getConfig(game_config_field.item):getNodeWithKey(tostring(m_itemId));
                        local itemName = config_date:getNodeWithKey("name"):toStr();
                        local rewardCount = game_util:rewardTipsByJsonData(gameData:getNodeWithKey("data"):getNodeWithKey("effect"));
                        if rewardCount and rewardCount == 0 then
                            game_util:addMoveTips({text = tostring(itemName) .. "Dùng thành công!"});
                        end
                        self:refreshUi()
                    end
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("item_use"), http_request_method.GET, {item_id = m_itemId,num = count},"item_use___game_neutral_city_map_new")
                end,
                shopItemId = m_itemId,
                maxCount = itemCount,
                alreadyCount = 1,
                times_limit = 1,
                touchPriority = GLOBAL_TOUCH_PRIORITY - 1,
                falg = "show",
            }
            game_scene:addPop("game_use_pop",t_params)


        elseif btnTag == 101 then--祝福加

        elseif btnTag == 102 then--掠夺加
        elseif btnTag == 103 then -- 详情
            game_scene:addPop("game_active_limit_detail_pop",{enterType = "205"})
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
    ccbNode:openCCBFile("ccb/ui_game_neutral_city_map_new.ccbi");
    self.m_land_map_layer = ccbNode:layerForName("m_land_map_layer")
    self.m_land_map_layer_2 = ccbNode:layerForName("m_land_map_layer_2")
    self.m_visit_layer = ccbNode:layerForName("m_visit_layer")
    self.m_visit_list_view_bg = ccbNode:nodeForName("m_visit_list_view_bg")
    self.m_visit_node_btn = ccbNode:controlButtonForName("m_visit_node_btn")
    self.m_own_node = ccbNode:nodeForName("m_own_node")
    self.m_ohter_node = ccbNode:nodeForName("m_ohter_node")
    self.m_ohter_node_2 = ccbNode:nodeForName("m_ohter_node_2")
    self.m_name_node = ccbNode:nodeForName("m_name_node")
    self.m_player_icon_node = ccbNode:nodeForName("m_player_icon_node")
    self.m_home_name_label = ccbNode:labelTTFForName("m_home_name_label")
    local m_bar_bg_1 = ccbNode:spriteForName("m_bar_bg_1")
    self.m_bar_label_1 = ccbNode:labelBMFontForName("m_bar_label_1")
    local m_bar_bg_2 = ccbNode:spriteForName("m_bar_bg_2")
    self.m_bar_label_2 = ccbNode:labelBMFontForName("m_bar_label_2")
    self.m_countdown_node = ccbNode:nodeForName("m_countdown_node")
    self.m_time_node = ccbNode:nodeForName("m_time_node")
    local bar_bg_size = m_bar_bg_1:getContentSize();
    self.m_bar_1 = game_util:createProgressTimer({fileName = "zldt_tiao1.png",percentage = 0})
    self.m_bar_1:setPosition(ccp(bar_bg_size.width*0.5,bar_bg_size.height*0.5))
    m_bar_bg_1:addChild(self.m_bar_1,10,10)
    self.m_bar_2 = game_util:createProgressTimer({fileName = "zldt_tiao2.png",percentage = 0})
    self.m_bar_2:setPosition(ccp(bar_bg_size.width*0.5,bar_bg_size.height*0.5))
    m_bar_bg_2:addChild(self.m_bar_2,10,10)
    self.m_visit_node_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    self:initLandMapTouch(self.m_land_map_layer)
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;
        end
    end
    self.m_visit_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY,true)
    self.m_visit_layer:setTouchEnabled(false)
    self.m_visit_layer:setVisible(false)
    self.m_ccbNode = ccbNode
    for i=1,12 do
        local landItem = self.m_ccbNode:spriteForName("m_land_" .. tostring(i))
        if landItem then
            local tempNode = CCNode:create()
            local pX,pY = landItem:getPosition()
            tempNode:setPosition(ccp(pX,pY))
            self.m_land_map_layer_2:addChild(tempNode)
            self.m_pos_land_node_tab[i] = tempNode
        end
    end

    return ccbNode;
end

function game_neutral_city_map_new.visitLayerShow(self)
    self.m_tickFlag = false
    local function responseMethod(tag,gameData)
        self.m_tickFlag = true
        if gameData == nil then return end
        local data = gameData:getNodeWithKey("data");
        local friends = data:getNodeWithKey("friends");
        local friendsTab = json.decode(friends:getFormatBuffer()) or {}
        self.m_visit_layer:setTouchEnabled(true)
        local visibleSize = CCDirector:sharedDirector():getVisibleSize()
        local tempSize = self.m_visit_layer:getContentSize()
        local pX,pY = self.m_visit_layer:getPosition()
        -- self.m_visit_layer:setPositionX(visibleSize.width-tempSize.width)
        local arr = CCArray:create()
        arr:addObject(CCEaseIn:create(CCMoveTo:create(0.2,ccp(visibleSize.width-tempSize.width,pY)),5))
        arr:addObject(CCShow:create())
        self.m_visit_layer:runAction(CCSequence:create(arr))
        self:refreshVisitPlayerTableView(friendsTab)
    end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_visit_friend_list"), http_request_method.GET, nil,"public_land_visit_friend_list",true,true)
end

function game_neutral_city_map_new.visitLayerHide(self)
    self.m_visit_layer:setTouchEnabled(false)
    local visibleSize = CCDirector:sharedDirector():getVisibleSize()
    local tempSize = self.m_visit_layer:getContentSize()
    local pX,pY = self.m_visit_layer:getPosition()
    -- self.m_visit_layer:setPositionX(visibleSize.width+tempSize.width+10)
    local function callBackFunc(node)
        self.m_visit_list_view_bg:removeAllChildrenWithCleanup(true)
    end
    local removeCallFunc = CCCallFuncN:create(callBackFunc);
    local arr = CCArray:create()
    arr:addObject(CCEaseIn:create(CCMoveTo:create(0.2,ccp(visibleSize.width+tempSize.width+10,pY)),5))
    arr:addObject(CCHide:create())
    arr:addObject(removeCallFunc)
    self.m_visit_layer:runAction(CCSequence:create(arr))
end

--[[--
    点击的处理
]]
function game_neutral_city_map_new.initLandMapTouch(self,formation_layer)
    local touchBeginPoint = nil;
    local touchMoveFlag = false;
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
        --cclog("onTouchEnded: %0.2f, %0.2f", x, y)
        local realPos = formation_layer:convertToNodeSpace(ccp(x,y));
        if not touchMoveFlag then
            for endTag = 1,12 do
                local endItem = self.m_ccbNode:spriteForName("m_land_" .. endTag)
                if endItem and endItem:boundingBox():containsPoint(realPos) then
                    local tempPos = endItem:convertToNodeSpace(ccp(x,y));
                    local tempSize = endItem:getContentSize();
                    local alpha = getImageAlphaByFileNameAndPoint("building_img/zldt_land.png",ccp(tempPos.x*display.contentScaleFactor,(tempSize.height - tempPos.y)*display.contentScaleFactor))
                    -- cclog("alpha ====================" .. tostring(alpha) .. "display.contentScaleFactor ==" .. display.contentScaleFactor)
                    if alpha ~= 0 then
                        self:landOnclick(endTag)
                        break;
                    end
                end
            end
        end
        touchBeginPoint = nil;
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

function game_neutral_city_map_new.landOnclick(self,map_id)
    local gameData = game_data:getDataByKey("public_land_data") or {}
    local map = gameData.map or {}
    local itemData = map[tostring(map_id)] or {}
    local seed_id = itemData.seed_id or 0
    local plant_time = itemData.plant_time or 0
    local is_harvest = itemData.is_harvest or false
    if itemData.is_own then
        if self.m_home_type == 1 then
            local function callBackFunc()
                self:refreshUi()
            end
            if seed_id <= 0 then--没种植
                game_scene:addPop("game_neutral_produce_pop",{map_id = map_id,callBackFunc = callBackFunc})
            else
                if is_harvest then--可收获
                    self.m_tickFlag = false
                    local function responseMethod(tag,gameData)
                        self.m_tickFlag = true
                        if gameData == nil then return end
                        local data = gameData:getNodeWithKey("data")
                        local public_land_data = json.decode(data:getFormatBuffer())
                        game_data:setDataByKeyAndValue("public_land_data",public_land_data)
                        game_data:setDataByKeyAndValue("public_land_data_time",os.time())
                        game_util:rewardTipsByDataTable(public_land_data.reward)
                        self:refreshUi()
                    end
                    -- map_id=3
                    local params = {}
                    params.map_id = map_id
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_get_harvest_reward"), http_request_method.GET, params,"public_land_get_harvest_reward",true,true)
                else--查看地块种植信息
                    game_scene:addPop("game_neutral_land_pop",{map_id = map_id,callBackFunc = callBackFunc})
                end
            end
        elseif self.m_home_type == 2 then--掠夺
            if seed_id > 0 and is_harvest then
                game_scene:addPop("game_neutral_rob_pop",{map_id = map_id})
            end
        elseif self.m_home_type == 3 then--祝福
            if seed_id > 0 and not is_harvest then
                local uid = game_data:getUserStatusDataByKey("uid") or ""
                local blessing_list = itemData.blessing_list or {}
                if game_util:valueInTeam(uid,blessing_list) then
                    return  
                end
                local friend_uid = gameData.friend_uid
                -- cclog("self.m_home_type 3 blessing" .. tostring(friend_uid))
                self.m_tickFlag = false
                local function responseMethod(tag,gameData)
                    self.m_tickFlag = true
                    if gameData == nil then return end
                    local data = gameData:getNodeWithKey("data")
                    local public_land_data = json.decode(data:getFormatBuffer())
                    game_data:setDataByKeyAndValue("public_land_data",public_land_data)
                    game_util:rewardTipsByDataTable(public_land_data.reward)
                    self:refreshUi()
                    game_util:addMoveTips({text = "Lời chúc thành công"})
                end
                -- uid=&map_id=
                local params = {}
                params.map_id = map_id
                params.uid = friend_uid
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_send_blessing"), http_request_method.GET, params,"public_land_send_blessing",true,true)
            elseif seed_id > 0 and is_harvest then  -- 好友可收取
                local seed_cfg = getConfig(game_config_field.seed)
                seed_cfg = json.decode(seed_cfg:getFormatBuffer())
                local Steal = seed_cfg[tostring(seed_id)].Steal or 0
                local steal_times = itemData.steal_times or 0
                local rob_times = itemData.rob_times or 0
                local friend_uid = gameData.friend_uid
                local worker_id = itemData.worker_id -- 工人id
                local worker_cfg = getConfig(game_config_field.worker)
                worker_cfg = json.decode(worker_cfg:getFormatBuffer())
                local worker_sort = 0
                if worker_id > 0 then
                    worker_sort = worker_cfg[tostring(worker_id)].sort
                end
                if worker_sort == 6 then 
                    game_util:addMoveTips({text = "Người lao động không thể lấy sản phẩm khi đang làm việc"})
                    return
                end

                if steal_times + rob_times < Steal then  -- 可偷取
                    local function responseMethod(tag,gameData)
                        local data = gameData:getNodeWithKey("data")
                        local public_land_data = json.decode(data:getFormatBuffer())
                        game_data:setDataByKeyAndValue("public_land_data",public_land_data)
                        game_data:setDataByKeyAndValue("public_land_data_time",os.time())
                        local rewardCount = game_util:rewardTipsByDataTable(public_land_data.reward)
                        local typeValue = public_land_data.type or 1
                        if typeValue == 1 and rewardCount == 0 then
                            game_util:addMoveTips({text = "Ăn trộm thất bại"})
                        end
                        self:refreshUi()
                    end
                    local params = {}
                    params.map_id = map_id
                    params.type = 1
                    params.uid = friend_uid
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_go_steal_rob"), http_request_method.GET, params,"public_land_go_steal_rob")
                end
            end
        end
    end
end

--[[--
    
]]
function game_neutral_city_map_new.createVisitPlayerTableView(self,viewSize,showData)
    showData = showData or {}
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;
    params.column = 1; --列
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 1;
    params.totalItem = #showData;
    params.direction = kCCScrollViewDirectionVertical;--纵向
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local ccbNode = luaCCBNode:create();
            ccbNode:openCCBFile("ccb/ui_game_neutral_visit_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5))
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));          
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode")
            local m_icon_node = ccbNode:nodeForName("m_icon_node")
            m_icon_node:removeAllChildrenWithCleanup(true)
            local m_blessing_icon = ccbNode:spriteForName("m_blessing_icon")
            local m_name_label = ccbNode:labelTTFForName("m_name_label")
            local m_level_label = ccbNode:labelTTFForName("m_level_label")
            local m_guild_name_label = ccbNode:labelTTFForName("m_guild_name_label")
            local m_steal_icon = ccbNode:spriteForName("m_steal_icon")
            local itemData = showData[index+1] or {}
            m_name_label:setString(tostring(itemData.name))
            m_level_label:setString(tostring(itemData.level))
            local association_name = itemData.association_name or ""
            association_name = association_name == "" and "không có" or association_name
            m_guild_name_label:setString(tostring(association_name))
            local tempNode = game_util:createPlayerIconByRoleId(itemData.role)
            if tempNode then
                tempNode:setScale(0.7)
                m_icon_node:addChild(tempNode)
            end
            local is_blessing = itemData.is_blessing
            is_blessing = is_blessing ~= nil and is_blessing or false
            m_blessing_icon:setVisible(is_blessing)
            local can_steal = itemData.can_steal
            m_steal_icon:setVisible(can_steal)
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            local itemData = showData[index+1] or {}
            local uid = itemData.uid
            self:visitPlayerByUid(uid)
        end
    end
    return TableViewHelper:create(params);
end
--[[
    拜访
]]
function game_neutral_city_map_new.visitPlayerByUid(self,uid,index)
    self.m_tickFlag = false
    local function responseMethod(tag,gameData)
        self.m_tickFlag = true
        if gameData == nil then return end
        self.m_home_type = 3
        local data = gameData:getNodeWithKey("data")
        game_data:setDataByKeyAndValue("public_land_data",json.decode(data:getFormatBuffer()))
        game_data:setDataByKeyAndValue("public_land_data_time",os.time())
        self:visitLayerHide()
        self:refreshUi()
    end
    -- uid
    local params = {}
    params.uid = uid
    params.index = index
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_visit_one_friend"), http_request_method.GET, params,"public_land_visit_one_friend",true,true)
end

function game_neutral_city_map_new.refreshVisitPlayerTableView(self,showData)
    self.m_visit_list_view_bg:removeAllChildrenWithCleanup(true)
    local tempView = self:createVisitPlayerTableView(self.m_visit_list_view_bg:getContentSize(),showData)
    self.m_visit_list_view_bg:addChild(tempView)
end

--[[--
    刷新ui
]]
function game_neutral_city_map_new.refreshLandItem(self,map_id)
    local landItem = self.m_pos_land_node_tab[map_id]
    if landItem then
        landItem:removeAllChildrenWithCleanup(true)
        local farm_open_cfg = getConfig(game_config_field.farm_open)
        local seed_cfg = getConfig(game_config_field.seed)
        local gameData = game_data:getDataByKey("public_land_data") or {}
        local map = gameData.map or {}
        local itemData = map[tostring(map_id)]
        if itemData and itemData.is_own then
            local seed_id = itemData.seed_id or 0
            if seed_id > 0 then
                local seed_cfg_item = seed_cfg:getNodeWithKey(tostring(seed_id))
                if seed_cfg_item then
                    local building = seed_cfg_item:getNodeWithKey("building"):toStr()
                    local buildingSprite = CCSprite:create("building_img/" .. building)
                    if buildingSprite then
                        landItem:addChild(buildingSprite)
                    end
                end
                local plant_time = itemData.plant_time or 0
                local function timeEndFunc(label)
                    label:getParent():removeFromParentAndCleanup(true)
                    itemData.is_harvest = true
                    self:refreshHarvestStatus(landItem,itemData)
                end
                if plant_time > 0 then
                    local tempBg = CCScale9Sprite:createWithSpriteFrameName("zldt_xiaogezi.png");
                    local tempBgSize = tempBg:getContentSize()
                    local countdownLabel = game_util:createCountdownLabel(plant_time,timeEndFunc,8, 1);
                    countdownLabel:setScale(0.8)
                    countdownLabel:setColor(ccc3(0, 255, 0))
                    countdownLabel:setPosition(ccp(tempBgSize.width*0.5,tempBgSize.height*0.5))
                    tempBg:addChild(countdownLabel,10,10)
                    landItem:addChild(tempBg,10,10)
                end
                self:refreshHarvestStatus(landItem,itemData)
                -- local tempSprite = CCScale9Sprite:createWithSpriteFrameName(math.random(10)%2==0 and "zldt_weilveduo.png" or "zldt_lueduoguo.png")
                -- landItem:addChild(tempSprite,1,1)
            else
                local noPlantSprite = CCScale9Sprite:createWithSpriteFrameName("zldt_kaishishengchan.png")
                landItem:addChild(noPlantSprite,2,2)
            end
        else
            local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("zldt_dikuai_weikaiqi.png")
            if tempSpriteFrame then
                local tempSprite = CCSprite:createWithSpriteFrame(tempSpriteFrame)
                landItem:addChild(tempSprite)
            end
            local lockStr = "Chưa mở"
            local farm_open_item_cfg = farm_open_cfg:getNodeWithKey(tostring(map_id))
            if self.m_home_type == 1 and farm_open_item_cfg then
                lockStr = farm_open_item_cfg:getNodeWithKey("name"):toStr()
            end
            local tempLabel = game_util:createLabelBMFont({text = lockStr,fontSize = 10,color = ccc3(200,200,200)})
            landItem:addChild(tempLabel)
        end
    end
end

function game_neutral_city_map_new.refreshHarvestStatus(self,landItem,itemData)
    local tempNode = landItem:getChildByTag(3)
    if tempNode then
        tempNode:removeFromParentAndCleanup(true)
    end
    local is_harvest = itemData.is_harvest
    local tempSpriteName = ""
    if is_harvest then
        if self.m_home_type == 1 then
            tempSpriteName = "zldt_shouqu.png"
        elseif self.m_home_type == 2 then
            local rob_times = itemData.rob_times or -1
            if rob_times ~= -1 then
                local steal_times = itemData.steal_times or -1
                local rob_times = itemData.rob_times or -1
                local gameData = game_data:getDataByKey("public_land_data") or {}
                local seed_id = itemData.seed_id
                local seed_cfg = getConfig(game_config_field.seed)
                seed_cfg = json.decode(seed_cfg:getFormatBuffer())
                local Steal = seed_cfg[tostring(seed_id)].Steal or 0
                local steal_times = itemData.steal_times or 0
                local rob_times = itemData.rob_times or 0

                if Steal > (steal_times + rob_times) then
                    tempSpriteName = "zldt_lueduoan.png"
                else
                    tempSpriteName = "zldt_lueduoan2.png"
                end
            end
        elseif self.m_home_type == 3 then  -- 好友可收取（偷取）
            local seed_id = itemData.seed_id
            local seed_cfg = getConfig(game_config_field.seed)
            seed_cfg = json.decode(seed_cfg:getFormatBuffer())
            local Steal = seed_cfg[tostring(seed_id)].Steal or 0
            local steal_times = itemData.steal_times or 0
            local rob_times = itemData.rob_times or 0
            if Steal > steal_times + rob_times then 
                tempSpriteName = "wzzd_hytc.png"
            end
        end
    else
        local plant_time = itemData.plant_time or 0
        if plant_time > 0 then  -- 收获倒计时大于0  
            if self.m_home_type == 1 then
            elseif self.m_home_type == 2 then    
            elseif self.m_home_type == 3 then -- 显示祝福
                local uid = game_data:getUserStatusDataByKey("uid") or ""
                local blessing_list = itemData.blessing_list or {}
                if not game_util:valueInTeam(uid,blessing_list) then
                    tempSpriteName = "zldt_zhufuanniu.png"
                end
            end
        end
    end
    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tempSpriteName)
    if tempSpriteFrame then
        local tempSprite = CCSprite:createWithSpriteFrame(tempSpriteFrame)
        tempSprite:setAnchorPoint(ccp(0.5,0))
        landItem:addChild(tempSprite,3,3)
    end
end

--[[--
    自动刷新
]]
function game_neutral_city_map_new.autoRefreshUi(self)
    if self.m_home_type == 1 then
        self.m_tickFlag = false
        local function responseMethod(tag,gameData)
            self.m_tickFlag = true
            if gameData == nil then return end
            local data = gameData:getNodeWithKey("data");
            game_data:setDataByKeyAndValue("public_land_data",json.decode(data:getFormatBuffer()))
            game_data:setDataByKeyAndValue("public_land_data_time",os.time())
            self:refreshUi()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_index"), http_request_method.GET, nil,"public_land_index",false,true)
    else
        local gameData = game_data:getDataByKey("public_land_data") or {}
        local uid = gameData.friend_uid
        if uid then
            self.m_tickFlag = false
            local function responseMethod(tag,gameData)
                self.m_tickFlag = true
                if gameData == nil then return end
                local data = gameData:getNodeWithKey("data");
                game_data:setDataByKeyAndValue("public_land_data",json.decode(data:getFormatBuffer()))
                game_data:setDataByKeyAndValue("public_land_data_time",os.time())
                self:refreshUi()
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("public_land_refresh_map_info"), http_request_method.GET, {uid = uid},"public_land_refresh_map_info",false,true)
        end
    end
end

--[[
    倒计时
]]
function game_neutral_city_map_new.setCountdownTime(self)
    self.m_countdown_node:setVisible(self.m_home_type == 2)
    local gameData = game_data:getDataByKey("public_land_data") or {}
    local countdownTime = gameData.time_count_down or 0
    self.m_time_node:removeAllChildrenWithCleanup(true)
    local function timeEndFunc()
       self.m_time_node:removeAllChildrenWithCleanup(true)
       local tipsLabel = game_util:createLabelTTF({text = "00:00:00",color = ccc3(0,255,0),fontSize = 10});
        tipsLabel:setAnchorPoint(ccp(0.5,0.5))
        self.m_time_node:addChild(tipsLabel,10,12)
    end
    if countdownTime > 0 then
        local countdownLabel = game_util:createCountdownLabel(countdownTime,timeEndFunc,8, 1);
        countdownLabel:setColor(ccc3(0, 255, 0))
        countdownLabel:setAnchorPoint(ccp(0.5,0.5))
        self.m_time_node:addChild(countdownLabel,10,10)
    else
        timeEndFunc();
    end
end

--[[--
    刷新ui
]]
function game_neutral_city_map_new.refreshUi(self)
    local vip = game_data:getUserStatusDataByKey("vip") or 0
    local level = game_data:getUserStatusDataByKey("level") or 1
    local gameData = game_data:getDataByKey("public_land_data") or {}
    for i=1,12 do
        self:refreshLandItem(i)
    end
    local send_max_bless_times = gameData.send_max_bless_times or 1
    local send_bless_times = gameData.send_bless_times or 0
    local max_steal_rob_times = gameData.max_steal_rob_times or 1
    local steal_rob_times = gameData.steal_rob_times or 0
    local extra_times = gameData.extra_times or 0
    self.m_bar_label_1:setString(tostring(send_max_bless_times - send_bless_times) .. "/" .. tostring(send_max_bless_times))
    self.m_bar_label_2:setString(tostring(max_steal_rob_times + extra_times - steal_rob_times) .. "/" .. tostring(max_steal_rob_times))
    self.m_bar_1:setPercentage(math.max(0,math.min(100,100*(send_max_bless_times - send_bless_times)/math.max(send_max_bless_times,1))))
    self.m_bar_2:setPercentage(math.max(0,math.min(100,100*(max_steal_rob_times + extra_times - steal_rob_times)/math.max(max_steal_rob_times,1))))
    self.m_own_node:setVisible(self.m_home_type == 1)--自己家
    self.m_ohter_node:setVisible(self.m_home_type == 2)--掠夺
    self.m_ohter_node_2:setVisible(self.m_home_type == 3)--拜访
    self.m_name_node:setVisible(self.m_home_type ~= 1)
    if self.m_home_type ~= 1 then
        self.m_home_name_label:setString(tostring(gameData.friend_name))
        self.m_player_icon_node:removeAllChildrenWithCleanup(true)
        local tempNode = game_util:createPlayerIconByRoleId(gameData.role)
        if tempNode then
            tempNode:setScale(0.5)
            self.m_player_icon_node:addChild(tempNode)
        end
    end
    if self.m_autoRefreshScheduler == nil then
        function tick( dt )
            if self.m_visit_layer:isVisible() then return end
            if self.m_tickFlag == false then return end
            if self.m_auto_time > 0 then
                self.m_auto_time = self.m_auto_time - 1
            else
                self.m_auto_time = AUTO_REFRESH_TIME
                self:autoRefreshUi()
            end
        end
        self.m_autoRefreshScheduler = scheduler.schedule(tick, 1, false)
    end
    -- self:setCountdownTime()
    self.m_countdown_node:setVisible(false)
end
--[[--
    初始化
]]
function game_neutral_city_map_new.init(self,t_params)
    t_params = t_params or {}
    if t_params.gameData and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        game_data:setDataByKeyAndValue("public_land_data",json.decode(data:getFormatBuffer()))
        game_data:setDataByKeyAndValue("public_land_data_time",os.time())
    end
    self.m_home_type = t_params.home_type or 1
    self.m_pos_land_node_tab = {}
    self.m_clickFlag = true
    self.m_auto_time = AUTO_REFRESH_TIME
end

--[[--
    创建入口
]]
function game_neutral_city_map_new.create(self,t_params)
    self:init(t_params);
    local rootScene = CCScene:create();
    rootScene:addChild(self:createUi());
    self:refreshUi();
    return rootScene;
end

return game_neutral_city_map_new;   5�  