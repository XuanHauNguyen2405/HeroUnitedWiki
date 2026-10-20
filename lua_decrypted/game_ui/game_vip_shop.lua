--- VIP商店

local game_vip_shop = {
    m_ccbNode                   = nil,
    m_node_main                 = nil,
    m_lb_cost1 = nil,
    m_lb_cost2 = nil,
    m_layer_coin =nil,
    m_curzuanshiPage = nil,
    m_shop_data = nil,
    m_vip_data = nil,
};

--[[--
    销毁ui
]]
function game_vip_shop.destroy(self)
    cclog("-----------------game_vip_shop destroy-----------------")
    self.m_ccbNode              = nil;
    self.m_node_main            = nil;
    self.m_lb_cost1 = nil;
    self.m_lb_cost2 = nil;
    self.m_layer_coin = nil;
    self.m_curzuanshiPage = nil;
    self.m_shop_data = nil;
    self.m_vip_data = nil;
end
--[[--
    返回
]]
function game_vip_shop.back(self,backType)    

    if backType == "back" then
        local function endCallFunc()

            self:destroy();
        end
        if self.m_shared then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared)
            self.m_shared = nil
            self.lasttime = nil
        end

        if self.m_shared2 then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared2)
            self.m_shared2 = nil
        end
        game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
    end
end
--[[--
    读取ccbi创建ui
]]
function game_vip_shop.createUi(self)
    cclog("-----------------game_vip_shop createUi-----------------");
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then--返回
            if game_data.getGuideProcess and game_data:getGuideProcess() == "first_enter_main_scene" then
                if game_util.statisticsSendUserStep then game_util:statisticsSendUserStep(33) end -- 第一次点击招募后地 点击返回主页 步骤33
                if game_data.setGuideProcess then game_data:setGuideProcess("second_enter_main_scene") end
            end
            self:back("back");
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_game_gacha4.ccbi");
    self.m_ccbNode          = ccbNode;
    self.m_root_layer       = ccbNode:layerForName("m_root_layer")

    self.m_back_btn         = ccbNode:controlButtonForName("m_back_btn")
    self.m_back_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)

    self.m_node_main        = ccbNode:nodeForName("m_node_main")
    self.m_lb_cost1 = ccbNode:labelTTFForName("m_lb_cost1")
    self.m_lb_cost2 = ccbNode:labelTTFForName("m_lb_cost2")

    self.m_layer_coin = ccbNode:layerForName("m_layer_coin")

    -- local function onTouch(eventType, x, y)
    --     if eventType == "began" then
    --         self.m_moveFlag = false;
    --         touchBeginPoint = {x = x, y = y}
    --         return true;--intercept event
    --     elseif eventType == "moved" then
    --         if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 then
    --             self.m_moveFlag = true;
    --         end
    --     elseif eventType == "ended" then
    --         self.m_moveFlag = false;
    --     end
    -- end
    -- self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY,true);
    -- self.m_root_layer:setTouchEnabled(false);
    local function onTouch2(eventType, x, y)
        if eventType == "began" then
            if self.m_page == 3 then
                local pos = self.m_node_main:convertToNodeSpace(ccp(x , y ))
                local x = self.m_node_main:getContentSize().width
                local y = self.m_node_main:getContentSize().height
                if pos.x < 0 or pos.x > x or  pos.y > y or pos.y < 0 then
                    return true
                else
                    return false
                end
            end
            return false;--intercept event
        end
    end
    self.m_layer_coin:registerScriptTouchHandler(onTouch2,false,GLOBAL_TOUCH_PRIORITY + 1,true);
    self.m_layer_coin:setTouchEnabled(true);
    return ccbNode;
end



--[[--
    创建 2 钻石列表
]]
function game_vip_shop.createTableView2(self,viewSize)    
    local shopCfg = getConfig(game_config_field.vip_store);
    local showData = self:getShowShopItemCfg()
    local itemsCount = #showData;
    local totalItem = math.max(itemsCount%8 == 0 and itemsCount or math.floor(itemsCount/8+1)*8,8)
    local function onMainBtnClick(target,event)
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        local shopItemId = tostring(showData[btnTag+1].key);
        if shopItemId then
            local t_params = 
            {
                title = string_config.m_title_prompt,
                okBtnCallBack = function(target,event)
                    game_util:closeAlertView();
                    local function responseMethod(tag,gameData)
                        game_data_statistics:buyItem({shopId = shopItemId,count = 1})
                        local data = gameData:getNodeWithKey("data");
                        game_util:rewardTipsByJsonData(data:getNodeWithKey("goods"));
                        game_util:rewardTipsByJsonData(data:getNodeWithKey("reward"));
                        local m_vip_data = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) 
                        self.m_shop_data = m_vip_data.date or {}
                        self:refreshUi();
                    end
                    local params = {};
                    params.shop_id = shopItemId;
                    params.count = 1;
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("shop_vip_store_buy"), http_request_method.GET, params,"shop_vip_store_buy")
                end,   --可缺省
                closeCallBack = function(target,event)
                    game_util:closeAlertView();
                end,
                cancelBtnText = "Hủy",
                onlyOneBtn = false,
                okBtnText = "Xác nhận",       --可缺省
                text = "Xác nhận mua?",      --可缺省
            }
            game_util:openAlertView(t_params);
        end
    end

    local params = {};
    params.viewSize = viewSize;
    params.row = 2;--行
    params.column = 4; --列
    params.totalItem = totalItem;
    params.showPoint = false
    params.showPageIndex = self.m_curzuanshiPage or 1
    params.touchPriority = GLOBAL_TOUCH_PRIORITY + 2
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create();
            ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
            ccbNode:openCCBFile("ccb/ui_buy_item_list_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
            ccbNode:controlButtonForName("m_buy_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY+2);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_spr_bg_up = ccbNode:spriteForName("m_spr_bg_up");
            local m_buy_btn = ccbNode:controlButtonForName("m_buy_btn")
            m_buy_btn:setTag(index);
            if index < itemsCount then
                m_buy_btn:setVisible(true);
                m_spr_bg_up:setVisible(false);
                local itemCfg = showData[index+1]
                local sell_max = itemCfg.sell_max
                local sell_ref = itemCfg.sell_ref
                local m_name_label = ccbNode:labelTTFForName("m_name_label")
                local m_cost_label = ccbNode:labelBMFontForName("m_cost_label")
                local m_node = ccbNode:nodeForName("m_node");
                m_node:removeAllChildrenWithCleanup(true);
                local icon,name,count = game_util:getRewardByItemTable(itemCfg.shop_item[1])
                if icon then
                    icon:setScale(0.8)
                    m_node:addChild(icon);
                    icon:setPosition(ccp(0,5))
                end
                if name then
                    if sell_max == 0 then
                        m_name_label:setString(name);
                    else
                        m_name_label:setString(name .. "(" .. (sell_max)..")")
                    end
                end
                local m_limit_label = ccbNode:labelBMFontForName("m_limit_label")
                if count > 1 then
                    m_limit_label:setString("×" .. count)
                else
                    m_limit_label:setString("")
                end

                local need_value_count = itemCfg.need_value[1][3]
                if need_value_count > 0 then
                    m_cost_label:setString(tostring(need_value_count));
                else
                    m_cost_label:setString("0");
                end
                local cd_node = ccbNode:nodeForName("cd_node")
                local m_cdTime = ccbNode:labelTTFForName("m_cdTime")
                if sell_max == 0 then
                    cd_node:setVisible(true)
                    if sell_ref == 1 then 
                        m_cdTime:setString("Ngày mai")
                    elseif sell_ref == 2 then 
                        m_cdTime:setString("Tuần sau")
                    elseif sell_ref == 3 then 
                        m_cdTime:setString("Tháng sau")
                    elseif sell_ref == 4 then 
                        m_cdTime:setString("Đã bán hết")
                    end
                else
                    cd_node:setVisible(false)
                end
            else
                m_buy_btn:setVisible(false);
                m_spr_bg_up:setVisible(true);
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if index >= itemsCount then return end;
        if eventType == "ended" and item then
            local itemCfg = showData[index+1]
            local vip_store = getConfig(game_config_field.vip_store);
            local vip_store_cfg = json.decode(vip_store:getFormatBuffer())
            if itemCfg then
                local sell_max = itemCfg.sell_max
                local shop_reward_item = itemCfg.shop_item[1]
                local shop_buy_count = itemCfg.shop_buy_count
                local max_count = sell_max + shop_buy_count
                local key = itemCfg.key
                    if #shop_reward_item > 2 then
                        local tempType = shop_reward_item[1]
                        if tempType == 6 then--道具
                            local itemId = shop_reward_item[2]
                            function buy_call_back(data)
                                game_scene:removePopByName("game_item_info_pop")
                                local m_vip_data = json.decode(data:getNodeWithKey("date"):getFormatBuffer()) 
                                self.m_shop_data = m_vip_data
                                self:refreshUi();
                            end
                            game_scene:addPop("game_item_info_pop",{enterType = "vip_shop",tempId =key,alreadyCount = shop_buy_count,buyUrl = "shop_vip_store_buy",itemId = itemId ,openType = 10,maxCount = max_count,buy_call_back = buy_call_back})
                        end
                    end
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curzuanshiPage = curPage or 1
    end
    return TableViewHelper:createGallery2(params);
end

function game_vip_shop:getShowShopItemCfg( ... )
    local vip_level = game_data:getVipLevel();
    local vip_store = getConfig(game_config_field.vip_store);
    local vip_store_cfg = json.decode(vip_store:getFormatBuffer())
    local showData = {}
    local tempCfg1 = {} -- 可购买的
    local tempCfg2 = {} -- 当前不可购买
    for k,v in pairs(vip_store_cfg) do
        local show_vip = v.show_vip
        local sell_max = v.sell_max
        local shop_buy_count = 0
        if vip_level >= show_vip then 
            if self.m_shop_data[k] then 
                sell_max = sell_max - self.m_shop_data[k]
                shop_buy_count = self.m_shop_data[k]
            end
            v.key = k
            v.sell_max = sell_max
            v.shop_buy_count = shop_buy_count
            if v.sell_max <= 0 then 
                table.insert(tempCfg2,v)
            else
                table.insert(tempCfg1,v)
            end
        end
    end

    local function sortFunc(cfg1,cfg2)
        local key1 = tonumber(cfg1.key)
        local key2 = tonumber(cfg2.key)
        return key1 < key2
    end
    table.sort( tempCfg1, sortFunc )
    table.sort( tempCfg2, sortFunc )

    for i,v in ipairs(tempCfg1) do
        table.insert(showData,v)
    end
    for i,v in ipairs(tempCfg2) do
        table.insert(showData,v)
    end
    return showData
end

--[[--
    刷新ui
]]
function game_vip_shop.refreshUi(self)

    self.m_lb_cost1:setString(game_data:getUserStatusDataByKey("coin") or 0)
    self.m_lb_cost2:setString(game_data:getUserStatusDataByKey("silver") or 0)

    self.m_node_main:removeAllChildrenWithCleanup(true)
   
    local tableview_shop = self:createTableView2(self.m_node_main:getContentSize())
    self.m_node_main:addChild(tableview_shop)
    
end

--[[--
    初始化
]]
function game_vip_shop.init(self,t_params)
    t_params = t_params or {};
    self.m_shop_data = t_params.gameData
end


--[[--
    创建ui入口并初始化数据
]]
function game_vip_shop.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    return scene;
end

return game_vip_shop;7  