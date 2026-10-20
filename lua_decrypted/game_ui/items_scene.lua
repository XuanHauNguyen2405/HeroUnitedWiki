---  道具列表

local items_scene = {
    m_title_label = nil,
    m_list_view_bg = nil,
    m_back_btn = nil,
    m_sort_btn = nil,
    m_tableView = nil,
    m_btnCallFunc = nil,
    m_itemOnClick = nil,
    m_popUi = nil,
    m_curPage = nil,
    m_func_btn = nil,
};
--[[--
    销毁ui
]]
function items_scene.destroy(self)
    -- body
    cclog("-----------------items_scene destroy-----------------");
    self.m_title_label = nil;
    self.m_list_view_bg = nil;
    self.m_back_btn = nil;
    self.m_sort_btn = nil;
    self.m_tableView = nil;
    self.m_btnCallFunc = nil;
    self.m_itemOnClick = nil;
    self.m_popUi = nil;
    self.m_curPage = nil;
    self.m_func_btn = nil;
end
--[[--
    返回
]]
function items_scene.back(self,backType)
    game_data:resetNewItemIdTab();
        local function endCallFunc()
            self:destroy();
        end
        game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
end
--[[--
    读取ccbi创建ui
]]
function items_scene.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then
            if self.m_btnCallFunc then
                self.m_btnCallFunc(target,event)
            else
                self:back();
            end
        elseif btnTag == 2 then
        elseif btnTag == 101 then--查看装备
            game_scene:enterGameUi("equipment_list",{gameData = nil,openType = "items_scene"});
            self:destroy();
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_hero_list.ccbi");
    self.m_list_view_bg = tolua.cast(ccbNode:objectForName("m_list_view_bg"), "CCLayerColor");--
    self.m_back_btn = ccbNode:controlButtonForName("m_back_btn")
    self.m_sort_btn = ccbNode:controlButtonForName("m_sort_btn")
    self.m_func_btn = ccbNode:controlButtonForName("m_func_btn")
    self.m_func_btn:setVisible(true)
    local title = CCString:create(tostring("Xem trang bị"));
    self.m_func_btn:setTitleForState(title,CCControlStateNormal)

    self.m_back_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.m_sort_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.m_title_label = ccbNode:labelBMFontForName("m_title_label")
    self.m_title_label:setString("Danh sách đạo cụ")
    game_util:setControlButtonTitleBMFont(self.m_sort_btn)
    self.m_sort_btn:setVisible(false)
    return ccbNode;
end

--[[--
    刷新ui
]]
function items_scene.refreshUi(self)
    if self.m_tableView then
        self.m_lastTableViewPosX = self.m_tableView:getChildByTag(10):getContentOffset().x
    end
    self.m_list_view_bg:removeAllChildrenWithCleanup(true);
    self.m_tableView = self:createTableView(self.m_list_view_bg:getContentSize());
    self.m_list_view_bg:addChild(self.m_tableView);

    -- 重置位置
    if self.m_lastTableViewPosX then
        local contentSize = self.m_tableView:getChildByTag(10):getContentSize()
        self.m_lastTableViewPosX = math.max(-1 * contentSize.width, self.m_lastTableViewPosX)
        self.m_tableView:getChildByTag(10):setContentOffset(ccp(math.min(self.m_lastTableViewPosX, 0), 0 ));
        self.m_lastTableViewPosX = nil
    end
end
--[[--
    初始化
]]
function items_scene.init(self,t_params)
    t_params = t_params or {};
    self.m_tableView_offsetX = t_params.tableView_offsetX
    -- body
end

--[[--
    创建ui入口并初始化数据
]]
function items_scene.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    return scene;
end


--[[--
    创建道具列表
]]
function items_scene.createTableView(self,viewSize)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/public_res.plist");
    local config_date = getConfig(game_config_field.item);
    local itemsData = game_data:getItemsData() or {}
    local itemCfg,cfgId = nil;
    local showDataTable = {};
    for k,v in pairs(itemsData) do
        itemCfg = config_date:getNodeWithKey(k)
        cfgId = tonumber(k)
        if itemCfg then
            local is_show = itemCfg:getNodeWithKey("is_show")
            if is_show then
                is_show = is_show:toInt();
            else
                -- cclog("cfg is_show not found !")
                is_show = 1;
            end
            if (cfgId < 1000 or cfgId >= 3000) and is_show == 1 then
                for k,v in pairs(v) do
                    showDataTable[#showDataTable+1] = {key = cfgId,itemCfg = itemCfg,count = v}
                end
            end
        end
    end
    --根据道具ID排序
    local tonumber = tonumber;
    local function sortFunc(data1,data2)
        local cfgId1 = data1.key
        local cfgId2 = data2.key
        local is_use1 = data1.itemCfg:getNodeWithKey("is_use"):toInt()
        local is_use2 = data2.itemCfg:getNodeWithKey("is_use"):toInt()
        local quality1 = data1.itemCfg:getNodeWithKey("quality"):toInt()
        local quality2 = data2.itemCfg:getNodeWithKey("quality"):toInt()
        if is_use1 == is_use2 then
            if quality1 == quality2 then
                return tonumber(cfgId1) < tonumber(cfgId2)
            else
                return tonumber(quality1) > tonumber(quality2)
            end
        else
            return is_use1 > is_use2
        end
    end
    table.sort(showDataTable,sortFunc)

    local function onCellBtnClick( target,event )
        local tagNode = tolua.cast(target,"CCNode");
        local btnTag = tagNode:getTag();
        local index = btnTag - 100
        local itemData = showDataTable[index];
        local item_id = itemData.key

        local itemsCfg = getConfig(game_config_field.item)
        local config_date = itemsCfg:getNodeWithKey(tostring(item_id));

        local function responseMethod(tag,gameData)
            self:refreshUi();
            local itemName = config_date:getNodeWithKey("name"):toStr();
            local rewardCount = game_util:rewardTipsByJsonData(gameData:getNodeWithKey("data"):getNodeWithKey("effect"));
            if is_use == 19 then
                local item_config_date = json.decode(config_date:getFormatBuffer())
                local str = string.format("Bóng Exp Truyền Thừa + %s kinh nghiệm ",tostring(item_config_date.use_effect[1]))
                game_util:addMoveTips({text = str})
            else
                if rewardCount and rewardCount == 0 then
                    game_util:addMoveTips({text = tostring(itemName) .. "Dùng thành công!"});
                end
            end
        end

        local function callBackFunc()
            self:refreshUi(true)
        end
        
        local is_use = config_date:getNodeWithKey("is_use"):toInt();
        --可选兑换
        if is_use == 15 then
            cclog("???")
            game_scene:addPop("game_item_info_pop_ext",{item_id = item_id, callBackFunc = callBackFunc})
        else
            if item_id == 9101148 then
                game_util:addMoveTips({text = "Vui lòng sử dụng vật phẩm này trong Đất không người."})
                return
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("item_use"), http_request_method.GET, {item_id = item_id,num = 1},"item_use")
        end
    end
    local itemsCount = #showDataTable
    local totalItem = math.max(itemsCount%8 == 0 and itemsCount or math.floor(itemsCount/8+1)*8,8)
    local params = {};
    params.viewSize = viewSize;
    params.row = 2;--行
    params.column = 4; --列
    params.totalItem = totalItem;
    params.showPageIndex = self.m_curPage;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            -- cclog("new index ================================" .. index);
            cell = CCTableViewCell:new()
            cell:autorelease()
            -- local ccbNode = game_util:createItemsItem();
            local ccbNode = luaCCBNode:create();
            ccbNode:registerFunctionWithFuncName("onCellBtnClick",onCellBtnClick);
            ccbNode:openCCBFile("ccb/ui_items_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_spr_bg_up = ccbNode:spriteForName("m_spr_bg_up");
            if index < itemsCount then
                ccbNode:nodeForName("m_info_node"):setVisible(true);
                m_spr_bg_up:setVisible(false);
                local itemData = showDataTable[index+1];
                -- local item_id,count = game_data:getItemIdAndCountAt(index+1);
                if itemData then
                    local iCountText = ccbNode:labelBMFontForName("m_count");
                    local iNameText = ccbNode:labelTTFForName("m_name");
                    local m_imgNode = tolua.cast(ccbNode:objectForName("m_imgNode"),"CCNode");
                    local m_story_label = tolua.cast(ccbNode:objectForName("m_story_label"),"CCLabelTTF");
                    local m_user_btn = tolua.cast(ccbNode:objectForName("m_user_btn"),"CCControlButton")
                    local items = tolua.cast(ccbNode:objectForName("item_sprite"),"CCSprite");

                    m_user_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-10);
                    m_user_btn:setTag(index + 101)

                    local item_id = itemData.key
                    local config_date = getConfig(game_config_field.item):getNodeWithKey(tostring(item_id));
                    local itemName = config_date:getNodeWithKey("name"):toStr();
                    local itemStory = config_date:getNodeWithKey("story"):toStr();
                    local is_use = config_date:getNodeWithKey("is_use"):toInt();
                    local use_num = config_date:getNodeWithKey("use_num"):toInt();

                    game_util:setCCControlButtonTitle(m_user_btn,"Dùng")
                    if(is_use==0)then
                        m_user_btn:setVisible(false)
                        items:setVisible(true)
                    else
                        m_user_btn:setVisible(true)
                        items:setVisible(false)
                        if is_use == 15 then
                            game_util:setCCControlButtonTitle(m_user_btn,"Dùng×" .. use_num)
                        end
                    end
                    local itemCfg = itemData.itemCfg;
                    iCountText:setString(tostring("x" .. itemData.count));
                    -- iNameText:setString(itemCfg:getNodeWithKey("name"):toStr());
                    local itemName = itemCfg:getNodeWithKey("name"):toStr()
                    iNameText:setString(itemName);
                    -- iNameText:setString(itemName .. "(" .. itemData.count ..")");

                    m_imgNode:removeAllChildrenWithCleanup(true);
                    local tempIcon = game_util:createItemIconByCfg(itemCfg)
                    if tempIcon then
                        m_imgNode:addChild(tempIcon)
                    end
                    m_story_label:setString(itemCfg:getNodeWithKey("story"):toStr());
                    local m_new_icon = ccbNode:spriteForName("m_new_icon")
                    if game_data:isNewItemFlagById(itemData.key) then
                        m_new_icon:setVisible(true);
                    else
                        m_new_icon:setVisible(false);
                    end
                end
            else
                ccbNode:nodeForName("m_info_node"):setVisible(false);
                m_spr_bg_up:setVisible(true);
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  item = " .. tolua.type(item));
        if index >= itemsCount then return end;
        if eventType == "ended" and item then
            local itemData = showDataTable[index+1];
            local item_id,count = itemData.key,itemData.count

            local itemsCfg = getConfig(game_config_field.item)
            local config_date = itemsCfg:getNodeWithKey(tostring(item_id));
            local is_use = config_date:getNodeWithKey("is_use"):toInt();
            if self.m_itemOnClick then
                self.m_itemOnClick(item_id);
            else
                local function callBackFunc()
                    self:refreshUi();
                end
                if is_use == 15 then
                    game_scene:addPop("game_item_info_pop", {itemId = item_id, openType = 101, callBackFunc = callBackFunc, enterType = "storeHouse_save"})
                else
                    game_scene:addPop("game_item_info_pop", {itemId = item_id, flag = "show", callBackFunc = callBackFunc, enterType = "storeHouse_save"})
                end
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curPage = curPage;
    end
    return TableViewHelper:createGallery2(params);
end

return items_scene;
  �4  