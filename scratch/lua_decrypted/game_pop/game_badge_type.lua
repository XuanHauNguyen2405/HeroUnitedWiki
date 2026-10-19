-------------------- 血石赋能 类别

local game_badge_type = {
    badge_txet = getConfig(game_config_field.badge_txet) and json.decode(getConfig(game_config_field.badge_txet):getFormatBuffer()) or {},
}

function game_badge_type.destroy(self)
    self._leftTb = nil
end

function game_badge_type.back(self, type)
    game_scene:removePopByName("game_badge_type")
    self:destroy()
end

function game_badge_type.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if self.m_flag == true then
            return
        end
        if btnTag == 99999 then
            self:back()
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode:openCCBFile("ccb/ui_bloodStone_type.ccbi")

    self.m_root_layer = ccbNode:layerForName("m_root_layer")

    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true
        elseif eventType == "ended" then
        end
    end

    self.m_root_layer:registerScriptTouchHandler(onTouch, false, GLOBAL_TOUCH_PRIORITY - 1, true)
    self.m_root_layer:setTouchEnabled(true)
    self.m_ccbNode = ccbNode

    ccbNode:controlButtonForName("m_close_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)

    self.node_lSelect = ccbNode:nodeForName("node_lSelect")
    self.node_rLb = ccbNode:nodeForName("node_rLb")

    -- 初始化左侧数据
    local lData = {}
    local _temp = {}
    cclog2(self.badge_txet,"self.badge_txet--------")
    for k, v in pairs(self.badge_txet) do
        local _data = {}
        _data.sort = v.sort
        _data.name = v.name
        _data.txt = v.des
        table.insert(lData, _data)
    end

    table.sort(
        lData,
        function(a, b)
            return a.sort < b.sort
        end
    )
    self.lData = lData

    return ccbNode
end

function game_badge_type.refreshUi(self)
    if not self.selectSortData then
        self.selectSortData = self.lData[1]
    end
    -- 左侧滑动
    self:refreshLeft()
    -- 右侧文本
    self.node_rLb:removeAllChildrenWithCleanup(true)
    if self.selectSortData then
        local txt = self.selectSortData.txt
        local labelSize = self.node_rLb:getContentSize()
        local node = self:createScrollLabel(CCSizeMake(labelSize.width - 10, labelSize.height - 5), {text = txt}, GLOBAL_TOUCH_PRIORITY - 1)
        if node then
            self.node_rLb:addChild(node)
        end
    end
end

function game_badge_type.refreshLeft(self)
    local offset
    if self._leftTb then
        offset = self._leftTb:getContentOffset()
    end
    -- 列表
    self.node_lSelect:removeAllChildrenWithCleanup(true)
    local params = {
        viewSize = self.node_lSelect:getContentSize(),
        row = 7, -- 行
        column = 1, -- 列
        totalItem = #self.lData,
        touchPriority = GLOBAL_TOUCH_PRIORITY - 1,
        showPoint = false,
        itemActionFlag = false,
        direction = kCCScrollViewDirectionVertical, --纵向
        newCell = function(tableView, index)
            local cell = tableView:dequeueCell()
            if cell == nil then
                cell = CCTableViewCell:new()
                cell:autorelease()
            end
            local data = self.lData[index + 1]
            cell:removeAllChildrenWithCleanup(true)
            local ccbNode = luaCCBNode:create()
            ccbNode:openCCBFile("ccb/ui_bloodStone_typeItem.ccbi")
            cell:addChild(ccbNode)

            local isSelect = self.selectSortData == data

            -- sp_effectIcon
            local sp_effectIcon = ccbNode:spriteForName("sp_effectIcon")
            sp_effectIcon:setVisible(false)
            local label_name = ccbNode:labelTTFForName("label_name")
            label_name:setVisible(true)
            label_name:setString(data.name)
            if index + 1 == 1 then 
                label_name:setVisible(false)
                sp_effectIcon:setVisible(true)
                local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("huizhang_text_1.png")
                if tempSpriteFrame then
                    sp_effectIcon:setScale(1)
                    sp_effectIcon:setDisplayFrame(tempSpriteFrame)
                end
            end

            local ly_noSelect = ccbNode:layerForName("ly_noSelect")
            ly_noSelect:setVisible(not isSelect)

            cell:setScale(isSelect and 1.1 or 1)
            return cell
        end,
        itemOnClick = function(eventType, index, item)
            if eventType == "ended" and item then
                self.selectSortData = self.lData[index + 1]
                self:refreshUi()
            end
        end,
        pageChangedCallFunc = function(totalPage, curPage)
        end
    }
    local tempTable = TableViewHelper:create(params)
    tempTable:setScrollBarVisible(false)
    self.node_lSelect:addChild(tempTable)
    self._leftTb = tempTable

    if offset then
        if offset.y < self.node_lSelect:getContentSize().height - tempTable:getContentSize().height then
            offset.y = self.node_lSelect:getContentSize().height - tempTable:getContentSize().height
        end
        tempTable:setContentOffset(offset)
    end
end


function game_badge_type.createScrollLabel(self, boardSize, params, touchPriority)
    params = params or {}
    if not boardSize then
        return
    end
    local scrollView = CCScrollView:create(boardSize)
    scrollView:setDirection(kCCScrollViewDirectionVertical)
    scrollView:getContainer():removeAllChildrenWithCleanup(true)
    scrollView:setTouchEnabled(true)
    if touchPriority then
        scrollView:setTouchPriority(touchPriority)
    end
    local text = params.text or ""
    local tempLabel =
        game_util:createRichLabelTTF(
        {
            text = text,
            dimensions = CCSizeMake(boardSize.width, 0),
            textAlignment = kCCTextAlignmentLeft,
            verticalTextAlignment = kCCVerticalTextAlignmentCenter,
            color = ccc3(247,222,154),
            fontSize = 10
        }
    )
    local tempSize = tempLabel:getContentSize()
    tempLabel:setAnchorPoint(ccp(0, 0.99))
    tempLabel:setPosition(ccp(0, 0))
    scrollView:setContentSize(CCSizeMake(boardSize.width + 15, tempSize.height))
    scrollView:setContentOffset(ccp(0, boardSize.height - tempSize.height), false)
    scrollView:addChild(tempLabel, 0, 998)
    return scrollView
end

--[[--
    初始化
]]
function game_badge_type.init(self, t_params)
end

--[[--
    创建ui入口并初始化数据
]]
function game_badge_type.create(self, t_params)
    self:init(t_params)
    self.m_popUi = self:createUi()
    self:refreshUi()
    return self.m_popUi
end

--[[--
    回调方法
]]
function game_badge_type.callBackFunc(self)
    local callBackFunc = self.callBackFunc
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc()
    end
end

return game_badge_type
�