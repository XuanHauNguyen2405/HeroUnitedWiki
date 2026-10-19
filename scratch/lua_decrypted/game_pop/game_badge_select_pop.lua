--- 弹框选择

local game_badge_select_pop = {
    m_list_view_bg = nil,
    m_tableView = nil,
    m_posIndex = nil,
    m_selSort = nil,
    m_back_btn = nil,
    m_sort_btn = nil,
    m_btnCallFunc = nil,
    m_itemOnClick = nil,
    m_openType = nil,
    m_title_label = nil,
    m_popUi = nil,
    m_sortBtnShow = nil,
    m_guildNode = nil,
    m_alldata = nil
}
--[[--
    销毁ui
]]
function game_badge_select_pop.destroy(self)
    -- body
    cclog("-----------------game_badge_select_pop destroy-----------------")
    self.m_list_view_bg = nil
    self.m_tableView = nil
    self.m_posIndex = nil
    self.m_selSort = nil
    self.m_back_btn = nil
    self.m_sort_btn = nil
    self.m_btnCallFunc = nil
    self.m_itemOnClick = nil
    self.m_openType = nil
    self.m_title_label = nil
    self.m_popUi = nil
    self.m_sortBtnShow = nil
    self.m_guildNode = nil
    self.m_alldata = nil
end

--[[--
    返回
]]
function game_badge_select_pop.back(self, type)
    -- if self.m_popUi then
    --     self.m_popUi:removeFromParentAndCleanup(true);
    --     self.m_popUi = nil;
    -- end
    -- self:destroy();
    game_data:resetNewEquipIdTab()
    game_scene:removePopByName("game_badge_select_pop")
end
--[[--
    读取ccbi创建ui
]]
function game_badge_select_pop.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if btnTag == 1 then --返回
            if self.m_btnCallFunc then
                self.m_btnCallFunc(target, event)
            end
            self:back()
        elseif btnTag == 2 then
            local function btnCallBack(btnTag)
                cclog("btnCallBack ===========btnTag===" .. btnTag)
                local selSort = tonumber(EQUIP_SORT_TAB[btnTag].sortType)
                self:refreshBadgeTableView(selSort)
            end
            game_scene:addPop("game_sort_pop", {btnTitleTab = EQUIP_SORT_TAB, btnCallFunc = btnCallBack, currentSortType = self.m_selSort})
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode:openCCBFile("ccb/ui_hero_list.ccbi")
    self.m_list_view_bg = tolua.cast(ccbNode:objectForName("m_list_view_bg"), "CCNode")
    self.m_back_btn = ccbNode:controlButtonForName("m_back_btn")
    self.m_sort_btn = ccbNode:controlButtonForName("m_sort_btn")
    self.m_title_label = ccbNode:labelBMFontForName("m_title_label")
    self.m_title_label:setString("")
    self.m_back_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 12)
    self.m_sort_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 12)
    game_util:setControlButtonTitleBMFont(self.m_sort_btn)
    -- game_util:setCCControlButtonBackground(self.m_back_btn,"public_backNormal2.png","public_backDown2.png","public_backDown2.png");
    local m_root_layer = ccbNode:layerColorForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true --intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch, false, GLOBAL_TOUCH_PRIORITY - 11, true)
    m_root_layer:setTouchEnabled(true)
    return ccbNode
end

function game_badge_select_pop.createEquipTableView2(self, viewSize, tableData)
    cclog("game_badge_select_pop json.encode(tableData) == " .. json.encode(tableData))
    local itemsCount = #tableData + 1
    local totalItem = math.max(itemsCount % 8 == 0 and itemsCount or math.floor(itemsCount / 8 + 1) * 8, 8)
    local params = {}
    params.viewSize = viewSize
    params.row = 2 --行
    params.column = 4 --列
    params.direction = kCCScrollViewDirectionVertical
    params.totalItem = totalItem
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 12
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height / params.row)
    params.newCell = function(tableView, index)
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()

            local ccbNode = luaCCBNode:create()
            ccbNode:openCCBFile("ccb/ui_badge_equip_list_item.ccbi")
            ccbNode:setAnchorPoint(ccp(0.5, 0.5))
            ccbNode:setPosition(ccp(itemSize.width * 0.5, itemSize.height * 0.5))
            cell:addChild(ccbNode, 10, 10)
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10), "luaCCBNode")
            local m_spr_bg_up = ccbNode:spriteForName("m_spr_bg_up")
            if index < itemsCount then
                if index == 0 then
                    m_spr_bg_up:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_q_bg2.png"))
                    m_spr_bg_up:setVisible(true)
                    ccbNode:nodeForName("m_info_node"):setVisible(false)
                else
                    m_spr_bg_up:setVisible(false)
                    ccbNode:nodeForName("m_info_node"):setVisible(true)

                    local badgeData, badgeCfg = game_data:getBadgeDataById(tableData[index])
                    badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}

                    -- m_spr_bg
                    local m_spr_bg = ccbNode:spriteForName("m_spr_bg")
                    local sf = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(badgeCfg.image_bg .. ".png")
                    if sf then
                        m_spr_bg:setDisplayFrame(sf)
                    end
                    -- 头像
                    local m_anim_node = ccbNode:nodeForName("m_anim_node")
                    m_anim_node:removeAllChildrenWithCleanup(true)
                    local image_L = badgeCfg.image_L
                    local icon = CCSprite:create("icon/" .. image_L .. ".png")
                    if icon then
                        m_anim_node:addChild(icon)
                    end
                    -- 穿戴着名称
                    local lb_equipHeroName = ccbNode:labelTTFForName("lb_equipHeroName")
                    local owner = badgeData.owner
                    if owner and owner ~= "" then
                        local cardData, cardCfg = game_data:getCardDataById(owner)
                        lb_equipHeroName:setString(cardCfg:getNodeWithKey("name"):toStr())
                    else
                        lb_equipHeroName:setString("")
                    end
                    -- 徽章名称
                    local lb_name = ccbNode:labelTTFForName("lb_name")
                    lb_name:setString(badgeCfg.badge_name .. "+" .. badgeCfg.badge_level)
                end
            else
                m_spr_bg_up:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_q_bg.png"))
                m_spr_bg_up:setVisible(true)
                ccbNode:nodeForName("m_info_node"):setVisible(false)
            end
        end
        return cell
    end
    params.itemOnClick = function(eventType, index, item)
        if index >= itemsCount then
            return
        end
        if eventType == "ended" and item then
            if index == 0 then
                self.m_itemOnClick("unload", nil)
                self:back()
            else
                local badgeData, badgeCfg = game_data:getBadgeDataById(tableData[index])
                badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}

                if badgeData.id == self.curBadgeId then
                    game_util:addMoveTips({text = "Huy hiệu này đã được Anh Hùng này đeo"})
                    return
                end

                local badge_type_id = badgeCfg.badge_type_id
                local c_id = self.cardCid
                if badge_type_id ~= c_id then
                    game_util:addMoveTips({text = "Huy hiệu này không thể trang bị cho nhân vật này"})
                    return
                end

                self.m_itemOnClick("exchanged", tableData[index])
                self:back()
            end
        end
    end
    return TableViewHelper:createGallery2(params)
end

--[[--
    刷新列表
]]
function game_badge_select_pop.refreshBadgeTableView(self)
    if self.m_tableView ~= nil then
        self.m_tableView:removeFromParentAndCleanup(true)
    end

    local AllBadge = game_data:getAllBadgeIdData()
    local c_id = self.cardCid
    local showData = {}
    local firstArr = {}
    local secondArr = {}
    for k, v in pairs(AllBadge) do
        local badgeData, badgeCfg = game_data:getBadgeDataById(v)
        badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}
        local badge_type_id = badgeCfg.badge_type_id
        if badge_type_id == c_id then
            table.insert(firstArr, v)
        else
            table.insert(secondArr, v)
        end
    end
    local sortFunc = function(a, b)
        local _, a = game_data:getBadgeDataById(a)
        a = json.decode(a:getFormatBuffer() or "") or {}
        local _, b = game_data:getBadgeDataById(b)
        b = json.decode(b:getFormatBuffer() or "") or {}

        if a.badge_type_id == b.badge_type_id then
            return a.badge_level > b.badge_level
        else
            return a.badge_type_id < b.badge_type_id
        end
    end
    table.sort(firstArr, sortFunc)
    table.sort(secondArr, sortFunc)
    -- 整合
    for i, v in ipairs(firstArr) do
        table.insert(showData, v)
    end
    for i, v in ipairs(secondArr) do
        table.insert(showData, v)
    end

    


    -- local c_id = self.cardCid
    -- local curBadgeId = self.curBadgeId
    -- local showData = {}
    -- for k, badgeId in pairs(AllBadge) do
    --     local badgeData, badgeCfg = game_data:getBadgeDataById(badgeId)
    --     badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}
    --     local badge_type_id = badgeCfg.badge_type_id
    --     if badge_type_id == c_id and curBadgeId ~= badgeId then
    --         table.insert(showData, badgeId)
    --     end
    -- end

    self.m_tableView = self:createEquipTableView2(self.m_list_view_bg:getContentSize(), showData)
    self.m_list_view_bg:addChild(self.m_tableView)
end

function game_badge_select_pop.refreshUi(self)
    self:refreshBadgeTableView()
    self.m_sort_btn:setVisible(self.m_sortBtnShow)
end

function game_badge_select_pop.init(self, t_params)
    t_params = t_params or {}
    self.m_posIndex = t_params.posIndex
    self.m_selSort = 0
    self.m_openType = 2
    self.m_itemOnClick = t_params.itemOnClick
    self.m_sortBtnShow = false
    if t_params.allData ~= nil then
        self.m_alldata = t_params.allData
    end
    self.curBadgeId = t_params.curBadgeId or ""
    self.cardCid = t_params.cardCid
end

function game_badge_select_pop.create(self, t_params)
    self:init(t_params)
    self.m_popUi = self:createUi()
    self:refreshUi()
    return self.m_popUi
end

function game_badge_select_pop:getShowData()
end

return game_badge_select_pop
 �*