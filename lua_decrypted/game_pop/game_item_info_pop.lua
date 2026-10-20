--- 信息

local game_item_info_pop = {
    m_popUi = nil,
    m_root_layer = nil,
    m_ccbNode = nil,
    m_itemId = nil,
    m_callBackFunc = nil,
    m_openType = nil,
    m_look_flag = nil,
    maxCount = nil,
    alreadyCount = nil,
    tempId = nil,
    buy_call_back = nil,
    m_flag = nil,

};

--[[--
    销毁
]]
function game_item_info_pop.destroy(self)
    -- body
    cclog("-----------------game_item_info_pop destroy-----------------");
    self.m_popUi = nil;
    self.m_root_layer = nil;
    self.m_ccbNode = nil;
    self.m_itemId = nil;
    self.m_callBackFunc = nil;
    self.m_openType = nil;
    self.m_look_flag = nil;
    self.maxCount = nil;
    self.alreadyCount = nil;
    self.tempId = nil;
    self.buy_call_back = nil;
    self.m_flag = nil;
end
--[[--
    返回
]]
local boxID = {7,8,9,20,21,22,23,27,28}
function game_item_info_pop.back(self,type)
 --    if self.m_popUi then
 --        self.m_popUi:removeFromParentAndCleanup(true);
 --        self.m_popUi = nil;
 --    end
    -- self:destroy();
    game_scene:removePopByName("game_item_info_pop");
end
--[[--
    读取ccbi创建ui
]]
function game_item_info_pop.createUi(self)
    local config_date = getConfig(game_config_field.item):getNodeWithKey(tostring(self.m_itemId));
    local itemName = ""
    local itemStory = ""
    local is_use = 0
    if config_date then
        itemName = config_date:getNodeWithKey("name"):toStr();
        itemStory = config_date:getNodeWithKey("story"):toStr();
        is_use = config_date:getNodeWithKey("is_use"):toInt();
    end
    local ccbNode = luaCCBNode:create();
    local itemCount = count;
    local function responseMethod(tag,gameData)
        -- body
        -- itemCount=itemCount-1;
        -- if(itemCount<=0)then
            
        -- end
        game_data_statistics:useItem({itemId = self.m_itemId,count = 1})
        if self.m_callBackFunc then
            self.m_callBackFunc();
        end
        local rewardCount = game_util:rewardTipsByJsonData(gameData:getNodeWithKey("data"):getNodeWithKey("effect"));
        if rewardCount and rewardCount == 0 then
            game_util:addMoveTips({text = tostring(itemName) .. "Dùng thành công!"});
        end
        self:back();
    end
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        cclog("btnTag = " .. btnTag)
        if self.m_enterType == "storeHouse_get" and btnTag ~= 1 and btnTag ~= 311 then
            game_util:addMoveTips({text = "Không thể thao tác trong kho"});
            return
        end
        if btnTag == 1 then
            self:back();
        elseif btnTag == 2 then
            -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("item_use"), http_request_method.GET, {item_id = self.m_itemId,num = 1},"item_use")
            game_scene:addPop("game_box_inside_pop",{itemId = self.m_itemId})
        elseif btnTag == 3 then
            -- if self.m_look_flag == true then addUsePop
                -- game_scene:addPop("game_box_inside_pop",{itemId = self.m_itemId})
                --批量使用
            self:addUsePop(self.m_itemId)
            -- else
                -- self:back();
            -- end
        elseif btnTag == 10 then
            game_scene:addPop("game_box_inside_pop",{itemId = self.m_itemId})
        elseif btnTag == 5 then
            --批量购买
             if self.m_openType == 101 then
                self:addOptionalBuyPop()
            elseif self.m_openType == 11 then 
                local tree_shop_cfg = getConfig(game_config_field.shop_recycle);
                local bought = self.alreadyCount
                local itemCfg = tree_shop_cfg:getNodeWithKey(self.tempId)
                local itemCfgNew = json.decode(itemCfg:getFormatBuffer())
                if itemCfgNew.max_num - bought <= 0 then 
                    game_util:addMoveTips({text = "Không Đủ Lượt Thu Hồi Đạo Cụ Này!"})
                    return
                end

                local my_item_count= game_data:getItemCountByCid(itemCfgNew.cost[1][2])  --自身道具数量
                local need_value_count = itemCfgNew.cost[1][3]  -- 需要回收道具数量
                if my_item_count < need_value_count then 
                    game_util:addMoveTips({text = "Không Đủ Đạo Cụ, Thu Hồi Thất Bại"})
                    return
                end
                self:addBuyPop(self.tempId)
            else
                self:addBuyPop(self.tempId)
            end
        elseif btnTag == 6 then--去扫荡
            local vipLevel = game_data:getUserStatusDataByKey("vip") or 0
            local level = game_data:getUserStatusDataByKey("level") or 0
            if not((vipLevel >= 5 and level >= 35) or level >= 45) then  -- 
                local tip = ""
                if vipLevel < 5 then 
                    tip = "Lv45 trở lên dùng được" 
                else
                    tip = "Lv35 trở lên dùng được" 
                end
                game_util:addMoveTips({text = tip});
                return;
            end
            local function responseMethod(tag,gameData)
                game_data:setMapType("normal")
                game_scene:enterGameUi("map_world_scene",{gameData = gameData,itemId = self.m_itemId});
                self:destroy();
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_world_map"), http_request_method.GET, nil,"private_city_world_map")
        elseif btnTag == 311 then -- 存入仓库
            if self.m_enterType == "storeHouse_get" then
                cclog("[storeHouse] 点击取出道具")
                local item_id = self.m_itemId
                local itemsData = game_data.m_storeHouseData and game_data.m_storeHouseData.items or {}
                local itemCount = itemsData[tostring(item_id)] or 0
                local t_params = 
                {
                    okBtnCallBack = function(count)
                        cclog("[storeHouse] 存入道具 - 点击确定,数量:" .. count)
                        game_util:addMoveTips({text = "Lấy ra thành công!"})
                        if self.m_callBackFunc then
                            self.m_callBackFunc();
                        end
                        self:back();
                    end,
                    shopItemId = item_id,
                    maxCount = itemCount,
                    alreadyCount = 1,
                    times_limit = 1,
                    touchPriority = GLOBAL_TOUCH_PRIORITY - 60,
                    enterType = "storeHouse_get",
                    falg = "show",
                }
                game_scene:addPop("storeHouseStore",t_params)
            elseif self.m_enterType == "storeHouse_save" then
                cclog("[storeHouse] 点击存入道具")
                local item_id = self.m_itemId
                local itemCount = game_data:getItemCountByCid(tostring(item_id))
                local t_params = 
                {
                    okBtnCallBack = function(count)
                        cclog("[storeHouse] 存入道具 - 点击确定,数量:" .. count)
                        game_util:addMoveTips({text = "Cất vào thành công!"})
                        if self.m_callBackFunc then
                            self.m_callBackFunc();
                        end
                        self:back();
                    end,
                    shopItemId = item_id,
                    maxCount = itemCount,
                    alreadyCount = 1,
                    times_limit = 1,
                    touchPriority = GLOBAL_TOUCH_PRIORITY - 60,
                    enterType = "storeHouse_save",
                    falg = "show",
                }
                game_scene:addPop("storeHouseStore",t_params)
            end
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_items_dialog.ccbi");
    ccbNode:controlButtonForName("btn_storeToHouse"):setVisible(false)
    local m_title_label = tolua.cast(ccbNode:objectForName("m_title_label"),"CCLabelTTF");
    local m_story_label = tolua.cast(ccbNode:objectForName("m_story_label"),"CCLabelTTF");
    local m_root_layer = tolua.cast(ccbNode:objectForName("m_root_layer"),"CCLayer");
    local m_info_btn = ccbNode:controlButtonForName("m_info_btn")
    local m_icon_spr = ccbNode:spriteForName("m_icon_spr")
    m_info_btn:setVisible(false)
    local icon = game_util:createItemIconByCfg(config_date)
    if icon then
        m_icon_spr:removeAllChildrenWithCleanup(true)
        icon:setAnchorPoint(ccp(0.5,0.5))
        local size = m_icon_spr:getContentSize();
        icon:setPosition(ccp(size.width*0.5,size.height*0.5));
        m_icon_spr:addChild(icon,10)
    end

    local boardSize = m_story_label:getDimensions()
    local tempNode = CCNode:create()
    tempNode:setContentSize(boardSize)
    m_story_label:getParent():addChild(tempNode)
    tempNode:setAnchorPoint(ccp(0.5,0.5))
    tempNode:setPosition(m_story_label:getPosition())
    local sc = game_util:createMulitLabel(tempNode, {text = tostring(itemStory) ,color = ccc3(225,225,225)}, true, GLOBAL_TOUCH_PRIORITY  - 100)

    local function onTouch( eventType,x,y )
        -- body
        if(eventType == "began")then
            if sc then
                local realPos = tempNode:getParent():convertToNodeSpace(ccp(x,y));
                if tempNode:boundingBox():containsPoint(realPos) then
                    return false
                end
            end
            -- cclog2("  0000000000000000000  ")
            self:back();
            return true;
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-10,true);
    m_root_layer:setTouchEnabled(true);
    m_title_label:setString(itemName);
    m_story_label:setString("")

    local touchLayer = CCLayer:create()
    m_root_layer:addChild(touchLayer)
    local function onTouch( eventType,x,y )
        if(eventType == "began")then
            return true;
        end
    end
    touchLayer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-9,true);
    touchLayer:setTouchEnabled(true);

    -- m_story_label:setString(itemStory);
    local m_close_btn = tolua.cast(ccbNode:objectForName("m_close_btn"),"CCControlButton");
    local m_left_btn = tolua.cast(ccbNode:objectForName("m_left_btn"),"CCControlButton");
    local m_right_btn = tolua.cast(ccbNode:objectForName("m_right_btn"),"CCControlButton");
    local m_batch_btn = ccbNode:controlButtonForName("m_batch_btn");
    
    game_util:setCCControlButtonTitle(m_right_btn,"Dùng sỉ");
    m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 11);
    m_left_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-11);
    m_right_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-11);
    m_info_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-11);
    m_batch_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-11);

    m_batch_btn:setPosition(ccp(150,30))
    m_batch_btn:setVisible(false)
    local buy_falg = false
    if(is_use==0) or self.m_openType ~= 1  or  (is_use==18) then
        cclog("item not be use %d",self.m_itemId);
        m_left_btn:setVisible(false)
        -- m_batch_btn:setPosition(ccp(213,30))
        m_right_btn:setVisible(false)
        buy_falg = true
    end
    if is_use == 15 then--可选使用不显示批量使用
        m_right_btn:setVisible(false)
    end
    if self.m_openType == 10 then
        m_batch_btn:setVisible(true)
        game_util:setCCControlButtonTitle(m_batch_btn,"Mua sỉ");
    end
    if self.m_openType == 11 then
        m_batch_btn:setVisible(true)
        game_util:setCCControlButtonTitle(m_batch_btn,"Thu hồi loạt");
    end
    if self.m_openType == 101 then
        m_batch_btn:setVisible(true)
        game_util:setCCControlButtonTitle(m_batch_btn,"Dùng hàng loạt");
    end
    ---- 固定的几个宝箱的ID 是查看宝箱具体内容的 -----
    self.m_look_flag = false
    for i=1,#boxID do
        if self.m_itemId == boxID[i] then
            self.m_look_flag = true
            -- m_info_btn:setVisible(true)
            -- game_util:setCCControlButtonTitle(m_batch_btn,"批量購買");
            break;
        end
    end
    if self.m_look_flag == true then
        m_left_btn:setVisible(true)
        m_batch_btn:setPosition(ccp(213,30))
        m_right_btn:setPosition(ccp(213,30))
    else
        m_left_btn:setVisible(false)
        m_batch_btn:setPosition(ccp(150,30))
        m_right_btn:setPosition(ccp(150,30))
    end
    cclog("self.m_openType == " .. self.m_openType)
    if self.m_openType == 1 or self.m_openType == 2 then
        if buy_falg == false then
            m_left_btn:setPosition(ccp(86,30))
        else
            m_left_btn:setPosition(ccp(150,30))
        end
    elseif self.m_openType == 3 then--转生材料
        if self.m_itemId then
            local tempId = tonumber(self.m_itemId)
            if tempId >= 900000 and tempId <= 920004 then
                m_left_btn:setVisible(true)
                m_left_btn:setPosition(ccp(150,30))
                m_left_btn:setTag(6);
                game_util:setCCControlButtonTitle(m_left_btn,"Đi càn quét");
            end
        end
    elseif self.m_openType == 10 or self.m_openType == 11 then
        if m_batch_btn:isVisible() then--放到左边
            m_left_btn:setPosition(ccp(86,30))
        else
            m_left_btn:setPosition(ccp(150,30))
        end
    end
    self.m_ccbNode = ccbNode;

    -- 仓库
    local btn_storeToHouse = ccbNode:controlButtonForName("btn_storeToHouse")
    btn_storeToHouse:setTouchPriority(GLOBAL_TOUCH_PRIORITY-11)
    if self.m_enterType == "storeHouse_get" then
        btn_storeToHouse:setVisible(false)
        game_util:setCCControlButtonBackground(btn_storeToHouse, "storeHouse_4.png")
        m_batch_btn:setVisible(true)
        game_util:setCCControlButtonTitle(m_batch_btn,"Lấy ra hàng loạt");
        m_batch_btn:setTag(311)
    elseif self.m_enterType == "storeHouse_save" then
        btn_storeToHouse:setVisible(true)
        game_util:setCCControlButtonBackground(btn_storeToHouse, "storeHouse_2.png")
    else
        btn_storeToHouse:setVisible(false)
    end


    return ccbNode;
end
function game_item_info_pop.useFunc(self)
    
end
--[[
    批量使用
]]
function game_item_info_pop.addUsePop(self,shopId)
    local itemCount = game_data:getItemCountByCid(tostring(self.m_itemId))
    local t_params = 
    {
        okBtnCallBack = function(count)
            local function responseMethod(tag,gameData)
                game_data_statistics:useItem({itemId = self.m_itemId,count = count})
                if self.m_callBackFunc then
                    self.m_callBackFunc();
                end
                local config_date = getConfig(game_config_field.item):getNodeWithKey(tostring(self.m_itemId));
                local itemName = config_date:getNodeWithKey("name"):toStr();
                local rewardCount = game_util:rewardTipsByJsonData(gameData:getNodeWithKey("data"):getNodeWithKey("effect"));
                if rewardCount and rewardCount == 0 then
                    game_util:addMoveTips({text = tostring(itemName) .. "Dùng thành công!"});
                end
                self:back();
            end
            if self.m_itemId == 9101148 then
                game_util:addMoveTips({text = "Vui lòng sử dụng vật phẩm này trong Đất không người."})
                return
            end 
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("item_use"), http_request_method.GET, {item_id = self.m_itemId,num = count},"item_use")
        end,
        shopItemId = self.m_itemId,
        maxCount = itemCount,
        alreadyCount = 1,
        times_limit = 1,
        touchPriority = GLOBAL_TOUCH_PRIORITY - 25,
        enterType = "game_buy_item_scene",
        falg = self.m_flag,
    }
    game_scene:addPop("game_use_pop",t_params)
end
function game_item_info_pop.removePop(self)
    if self.m_popUi then
        self.m_popUi:removeFromParentAndCleanup(true);
        self.m_popUi = nil;
    end
end
--[[
    批量使用 is_use = 15

]]

function game_item_info_pop:addOptionalBuyPop( )

    local itemCount = game_data:getItemCountByCid(tostring(self.m_itemId))
    local t_params = 
    {
        item_id = self.m_itemId,
        maxCount = itemCount,
        callBackFunc = self.m_callBackFunc,
    }

     game_scene:addPop("game_item_info_pop_ext_new",t_params)
     self:back()
end
--[[--
    批量购买函数
]]
function game_item_info_pop.addBuyPop(self,shopId)
    -- local shopCfg = getConfig(game_config_field.shop);
    -- local itemCfg = shopCfg:getNodeWithKey(shopId)
    local shopItemId = tostring(shopId)
    print( "t_params.isShowMoneyIcon == ", self.m_isShowMoneyIcon)
    local t_params = 
    {
        okBtnCallBack = function(count)
            -- self:removePop();
            cclog("createPropsTableView item click = " .. shopItemId);
            local function responseMethod(tag,gameData)
                game_data_statistics:buyItem({shopId = shopItemId,count = count})
                local data = gameData:getNodeWithKey("data");
                -- cclog("data == " .. data:getFormatBuffer())
                game_util:rewardTipsByJsonData(data:getNodeWithKey("goods"));
                game_util:rewardTipsByJsonData(data:getNodeWithKey("reward"));
                -- self.m_tGameData[shopId].bought = data:getNodeWithKey("bought"):toInt();
                -- self.buy_call_back(data:getNodeWithKey("bought"):toInt(),shopId)
                local score = data:getNodeWithKey("score")
                score = score and score:toInt() or 0
                local bought = data:getNodeWithKey("bought")
                if self.m_buyUrl == "shop_vip_store_buy" or self.m_buyUrl == "sacrifice_recycle_buy" then
                    self.buy_call_back(data)
                else
                    if bought then
                        self.buy_call_back(bought:toInt(),shopId, score)
                    else
                        self.buy_call_back(count,shopId, score)
                    end
                end
                
            end
            local params = {};
            params.shop_id = shopItemId;
            params.count = count;
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey(self.m_buyUrl or "shop_buy"), http_request_method.GET, params,self.m_buyUrl or "shop_buy")
        end,
        shopItemId = shopItemId,
        maxCount = self.maxCount,
        alreadyCount = self.alreadyCount,
        times_limit = 1,
        touchPriority = GLOBAL_TOUCH_PRIORITY - 25,
        -- isShowMoneyIcon = self.m_isShowMoneyIcon or "yes",
        enterType = self.m_enterType or "game_buy_item_scene",
    }
    game_scene:addPop("game_shop_pop",t_params)
end
--[[--
    刷新ui
]]
function game_item_info_pop.refreshUi(self)

end

--[[--
    初始化
]]
function game_item_info_pop.init(self,t_params)
    t_params = t_params or {};
    -- body
    self.m_itemId = t_params.itemId;
    self.m_callBackFunc = t_params.callBackFunc;
    self.m_openType = t_params.openType or 1;
    self.maxCount = t_params.maxCount or 1;
    self.alreadyCount = t_params.alreadyCount or 1;
    self.tempId = t_params.tempId or 1;
    self.buy_call_back = t_params.buy_call_back or nil;

    self.m_flag = t_params.flag or ""
    self.m_buyUrl = t_params.buyUrl or "shop_buy"
    self.m_isShowMoneyIcon = t_params.isShowMoneyIcon or true
    self.m_enterType = t_params.enterType
    print( "t_params.isShowMoneyIcon == ", t_params.isShowMoneyIcon)
end

--[[--
    创建ui入口并初始化数据
]]
function game_item_info_pop.create(self,t_params)
    -- if self.m_popUi then return end
    self:init(t_params);
    if self.m_itemId == nil then return end
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

return game_item_info_pop;   �N  