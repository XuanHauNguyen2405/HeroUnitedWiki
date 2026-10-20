---  献祭

local game_offering_sacrifices_shop = {
    m_tGameData = nil,
    m_point_label_1 = nil,
    m_point_label_2 = nil,
    m_ccbNode = nil,
    m_curPage = nil,
    m_moveFlag = nil,
    m_list_view_bg = nil,
    m_shwoIdTab = nil,
    m_openType = nil,
};
--[[--
    销毁ui
]]
function game_offering_sacrifices_shop.destroy(self)
    -- body
    cclog("-----------------game_offering_sacrifices_shop destroy-----------------");
    self.m_tGameData = nil;
    self.m_point_label_1 = nil;
    self.m_point_label_2 = nil;
    self.m_ccbNode = nil;
    self.m_curPage = nil;
    self.m_moveFlag = nil;
    self.m_list_view_bg = nil;
    self.m_shwoIdTab = nil;
    self.m_openType = nil;
end
--[[--
    返回
]]
function game_offering_sacrifices_shop.back(self,backType)
    if self.m_openType == "game_offering_sacrifices" then
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_offering_sacrifices",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("sacrifice_index"), http_request_method.GET, nil,"sacrifice_index")
    elseif self.m_openType == "game_hero_breakthrough" then
        game_scene:enterGameUi("game_hero_breakthrough",{gameData = nil});
    else
        game_scene:enterGameUi("game_main_scene");
    end
end
--[[--
    读取ccbi创建ui
]]
function game_offering_sacrifices_shop.createUi(self)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/activity_add.plist")
    if luaCCBNode.addPublicResource then
        luaCCBNode:addPublicResource("ccbResources/public_res_add.plist");
    end
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then--关闭
            self:back();
        elseif btnTag == 102 then 
            local function responseMethod(tag,gameData)
                game_scene:enterGameUi("game_offering_sacrifices_shop",{gameData = gameData,openType = self.m_openType});
                self:destroy()
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("sacrifice_open_shop"), http_request_method.GET, nil,"sacrifice_open_shop")
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_offering_sacrifices_shop1.ccbi");
    self.m_point_label_1 = ccbNode:labelTTFForName("m_point_label_1")
    self.m_point_label_2 = ccbNode:labelTTFForName("m_point_label_2")
    self.m_list_view_bg = ccbNode:layerForName("m_list_view_bg")
    local m_shop_btn = ccbNode:controlButtonForName("m_shop_btn")
    game_util:setControlButtonTitleBMFont(m_shop_btn)

    local touchBeginPoint = nil;
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            self.m_moveFlag = false;
            touchBeginPoint = {x = x, y = y}
            return true;--intercept event
        elseif eventType == "moved" then
            if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 then
                self.m_moveFlag = true;
            end
        end
    end
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY);
    self.m_root_layer:setTouchEnabled(true);
    self.m_ccbNode = ccbNode
    return ccbNode;
end

--[[--
    创建英雄列表
]]
function game_offering_sacrifices_shop.createTableView(self,viewSize)
    local shopData = self.m_tGameData.buy_record or {}
    local tree_shop_cfg = getConfig(game_config_field.shop_recycle);
    local itemsCount = #self.m_shwoIdTab
    local totalItem = math.max(itemsCount%8 == 0 and itemsCount or math.floor(itemsCount/8+1)*8,8)
    local function onMainBtnClick(target,event)
        if self.m_moveFlag == false and event == 32 then
            local tagNode = tolua.cast(target, "CCNode");
            local btnTag = tagNode:getTag();
            local shopId = self.m_shwoIdTab[btnTag + 1];

            local bought = self:getByIdBuyRecordCount(shopId,shopData) --已购买次数
            local itemCfg = tree_shop_cfg:getNodeWithKey(shopId)
            local itemCfgNew = json.decode(itemCfg:getFormatBuffer())
            if itemCfgNew.max_num - bought > 0 then 
                if shopId then
                    local reward = itemCfgNew.reward
                    local my_item_count= game_data:getItemCountByCid(itemCfgNew.cost[1][2])  --自身道具数量
                    local need_value_count = itemCfgNew.cost[1][3]  -- 需要回收道具数量
                    if my_item_count >= need_value_count then 
                        local function responseMethod(tag,gameData)
                            local data = gameData:getNodeWithKey("data");
                            local buy_record_data = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) 
                            self.m_tGameData.buy_record = buy_record_data.buy_record
                            self:refreshUi();
                            game_util:rewardTipsByJsonData(data:getNodeWithKey("reward"));
                        end
                        local params = {};
                        params.shop_id = shopId;
                        params.count = 1;
                        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("sacrifice_recycle_buy"), http_request_method.GET, params,"sacrifice_recycle_buy")    
                    else
                        game_util:addMoveTips({text = "Không Đủ Đạo Cụ, Thu Hồi Thất Bại"})
                    end
                end
            else
                game_util:addMoveTips({text = "Không Đủ Lượt Thu Hồi Đạo Cụ Này!"})
            end
            
        end
    end
    local params = {};
    params.viewSize = viewSize;
    params.row = 2;--行
    params.column = 4; --列
    params.totalItem = totalItem;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY+1;
    params.showPageIndex = self.m_curPage;
    params.itemActionFlag = true;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            -- cclog("new index ================================" .. index);
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create();
            ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
            ccbNode:openCCBFile("ccb/ui_buy_item_list_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
            local m_buy_btn = ccbNode:controlButtonForName("m_buy_btn")
            m_buy_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY+1);
            game_util:setCCControlButtonTitle(m_buy_btn,"Thu Hồi");
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_spr_bg_up = ccbNode:spriteForName("m_spr_bg_up");
            local m_buy_btn = ccbNode:controlButtonForName("m_buy_btn")
            m_buy_btn:setVisible(true)
            if index < itemsCount then
                m_spr_bg_up:setVisible(false);
                local shopId = self.m_shwoIdTab[index + 1];
                local itemCfg = tree_shop_cfg:getNodeWithKey(shopId)
                local itemCfgNew = json.decode(itemCfg:getFormatBuffer())
                local m_node = ccbNode:nodeForName("m_node");
                m_node:removeAllChildrenWithCleanup(true);
                local m_cost_label = ccbNode:labelBMFontForName("m_cost_label")
                local m_name_label = ccbNode:labelTTFForName("m_name_label")
                local m_limit_label = ccbNode:labelBMFontForName("m_limit_label")
                local m_cost_icon_spr = ccbNode:spriteForName("m_cost_icon_spr")
                m_buy_btn:setTag(index);

                local reward = itemCfgNew.reward
                if reward[1][1] == 17 then
                    m_cost_icon_spr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_shenen_d.png"));
                elseif reward[1][1] == 18 then
                    m_cost_icon_spr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_shenen_g.png"));
                end
                local bought = self:getByIdBuyRecordCount(shopId,shopData)
                local need_value_count = reward[1][3]
                if need_value_count > 0 then
                    m_cost_label:setString(need_value_count);
                else
                    m_cost_label:setString("0");
                end
                local shop_reward = itemCfg:getNodeWithKey("cost")
                local item_reward = shop_reward:getNodeAt(0)

                local my_item_count= game_data:getItemCountByCid(itemCfgNew.cost[1][2])
                local icon,name,count,rewardType = game_util:getRewardByItem(item_reward);
                if icon then
                    m_node:addChild(icon);
                end
                local sell_max = itemCfg:getNodeWithKey("max_num"):toInt();


                if name then
                    if sell_max == 0 then
                        m_name_label:setString(name);
                    else
                        m_name_label:setString(name .. "(" .. (sell_max-bought)..")")
                    end
                else
                    m_name_label:setString("");
                end
                if count then
                    m_limit_label:setString("×" .. count)
                else
                    m_limit_label:setString("×0")
                end
                local cd_node = ccbNode:nodeForName("cd_node")
                local m_cdTime = ccbNode:labelTTFForName("m_cdTime")
                local sell_sort = itemCfg:getNodeWithKey("sell_sort"):toInt()
                if sell_sort == 1 then
                    if sell_max-bought == 0 then
                        cd_node:setVisible(true)
                        m_cdTime:setString("Ngày mai tạo mới ")
                    else
                        cd_node:setVisible(false)
                    end
                elseif sell_sort == 2 then
                    if sell_max-bought == 0 then
                        cd_node:setVisible(true)
                        m_cdTime:setString("Tuần sau tạo")
                    end
                else--不限次数
                    cd_node:setVisible(false)
                end
            else
                m_spr_bg_up:setVisible(true);
                m_buy_btn:setVisible(false)
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  item = " .. tolua.type(item));
        if index >= itemsCount then return end;
        if eventType == "ended" and item then
            local tempId = self.m_shwoIdTab[index + 1];
            local itemCfg = tree_shop_cfg:getNodeWithKey(tempId)
            local shop_reward = itemCfg:getNodeWithKey("cost")
            local item_reward = shop_reward:getNodeAt(0)

            if item_reward then
                -- local itemData = shopData[tempId] or {}
                local sell_max = itemCfg:getNodeWithKey("max_num"):toInt();
                local reward = json.decode(item_reward:getFormatBuffer())
                local tempType = reward[1]
                local bought = self:getByIdBuyRecordCount(tempId,shopData) --已购买次数
                if tempType == 6 then--道具
                    local itemId = reward[2]
                    function buy_call_back(gameData)
                        game_scene:removePopByName("game_item_info_pop");
                        local buy_record_data = json.decode(gameData:getNodeWithKey("buy_record"):getFormatBuffer()) 
                        self.m_tGameData.buy_record =buy_record_data
                        self:refreshUi();
                    end
                    game_scene:addPop("game_item_info_pop",{itemId = itemId,openType = 11,maxCount = sell_max,alreadyCount = bought,tempId = tempId,buy_call_back = buy_call_back,enterType = "game_offering_sacrifices_shop_new",buyUrl = "sacrifice_recycle_buy"})
                else
                    game_util:lookItemDetal(reward)
                end
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curPage = curPage;
    end
    return TableViewHelper:createGallery2(params);
end

--
function game_offering_sacrifices_shop.getByIdBuyRecordCount( self, id, data)
    for k,v in pairs(data) do
        if k == id then 
            return v
        end
    end
    return 0
end

--[[--

]]
function game_offering_sacrifices_shop.refreshTableView(self)
    self.m_list_view_bg:removeAllChildrenWithCleanup(true);
    self.m_tableView = self:createTableView(self.m_list_view_bg:getContentSize());
    self.m_list_view_bg:addChild(self.m_tableView);
end

--[[--
    刷新ui
]]
function game_offering_sacrifices_shop.refreshUi(self)
    local grace = game_data:getUserStatusDataByKey("grace") or 0
    local grace_high = game_data:getUserStatusDataByKey("grace_high") or 0
    self.m_point_label_1:setString(grace)
    self.m_point_label_2:setString(grace_high)
    self:refreshTableView();
end
--[[--
    初始化
]]
function game_offering_sacrifices_shop.init(self,t_params)
    t_params = t_params or {};
    if t_params.gameData and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        self.m_tGameData = json.decode(data:getFormatBuffer())
    else
        self.m_tGameData = {};
    end
    self.m_shwoIdTab = {}
    -- local tree_shop_cfg = getConfig(game_config_field.tree_shop);
    -- local tempCount = tree_shop_cfg:getNodeCount();
    -- for i=1,tempCount do
    --     local itemCfg = tree_shop_cfg:getNodeAt(i-1)
    --     table.insert(self.m_shwoIdTab,itemCfg:getKey())
    -- end
    local tree_shop_cfg = getConfig(game_config_field.shop_recycle);
    local tree_shop_cfg = json.decode(tree_shop_cfg:getFormatBuffer())

    for k,v in pairs(tree_shop_cfg) do
        table.insert(self.m_shwoIdTab,k)
    end
    table.sort(self.m_shwoIdTab,function(data1,data2) return tonumber(data1)<tonumber(data2) end)
    self.m_openType = t_params.openType or ""
end

--[[--
    创建ui入口并初始化数据
]]
function game_offering_sacrifices_shop.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    return scene;
end

return game_offering_sacrifices_shop; �:  