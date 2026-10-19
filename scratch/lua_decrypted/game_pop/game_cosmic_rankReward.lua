-------------------- 次元战场 排行奖励界面

local game_cosmic_rankReward = {}
local cosmicMgr = require("game_ui.cosmicMgr")

function game_cosmic_rankReward.destroy(self)
    self._leftTb = nil
    self._rightTb = nil
end

function game_cosmic_rankReward.back(self, type)
    game_scene:removePopByName("game_cosmic_rankReward")
    self:destroy()
end

function game_cosmic_rankReward.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if btnTag == 99999 then
            self:back()
        elseif btnTag == 2 then -- 奖励预览
        elseif btnTag == 3 then -- 进入战场
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode:openCCBFile("ccb/ui_cosmic_rankReward.ccbi")

    self.m_ccbNode = ccbNode

    local m_root_layer = ccbNode:layerColorForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true --intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch, false, GLOBAL_TOUCH_PRIORITY - 10, true)
    m_root_layer:setTouchEnabled(true)

    ccbNode:controlButtonForName("m_close_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 11)

    self.leftSelect = 1
    self.showData1 = cosmicMgr:getRankRewardShowData()
    self.showData2 = cosmicMgr:getRankRewardShowData2()

    return ccbNode
end
--

function game_cosmic_rankReward.refreshUi(self, scrollToSelect)
    self:refreshLeftList()
    self:refreshRightList()
end

--[[--
    初始化
]]
function game_cosmic_rankReward.init(self, t_params)
end

--[[--
    创建ui入口并初始化数据
]]
function game_cosmic_rankReward.create(self, t_params)
    self:init(t_params)
    local scene = CCScene:create()
    scene:addChild(self:createUi())
    self:refreshUi()
    return scene
end

--[[--
    回调方法
]]
function game_cosmic_rankReward.callBackFunc(self)
    local callBackFunc = self.callBackFunc
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc()
    end
end

function game_cosmic_rankReward.refreshLeftList(self)
    local offset
    if self._leftTb then
        offset = self._leftTb:getContentOffset()
    end

    local nd_left_list = self.m_ccbNode:nodeForName("nd_left_list")
    nd_left_list:removeAllChildrenWithCleanup(true)
    local showData = {{id = 1, name = cosmicMgr.tx[21]}, {id = 2, name = cosmicMgr.tx[22]}}
    self._leftTb = self:createLeftList(nd_left_list:getContentSize(), showData)
    nd_left_list:addChild(self._leftTb)

    -- if offset then
    --     if offset.y < nd_left_list:getContentSize().height - self._leftTb:getContentSize().height then
    --         offset.y = nd_left_list:getContentSize().height - self._leftTb:getContentSize().height
    --     end
    --     self._leftTb:setContentOffset(offset)
    -- end
end

function game_cosmic_rankReward.createLeftList(self, viewSize, showData)
    local params = {
        viewSize = viewSize,
        row = 4,
        column = 1,
        totalItem = #showData,
        touchPriority = GLOBAL_TOUCH_PRIORITY - 11,
        showPoint = false,
        itemActionFlag = false,
        direction = kCCScrollViewDirectionVertical, --纵向
        newCell = function(tableView, index)
            local cell = tableView:dequeueCell()
            if cell == nil then
                cell = CCTableViewCell:new()
                cell:autorelease()
            end

            cell:removeAllChildrenWithCleanup(true)
            local data = showData[index + 1]
            --
            local itemSize = CCSizeMake(75, 31)
            local node = CCNode:create()
            node:setContentSize(itemSize)
            node:setPosition(ccp(itemSize.width / 2, itemSize.height / 2))
            node:setAnchorPoint(ccp(0.5, 0.5))
            cell:addChild(node)

            local isSelect = self.leftSelect == (index + 1)

            -- 创建背景
            local bg = CCSprite:createWithSpriteFrameName(isSelect and "ciyuan_011.png" or "ciyuan_012.png")
            bg:setPosition(ccp(itemSize.width / 2, itemSize.height / 2))
            node:addChild(bg)
            -- 文本
            local tx = CCLabelTTF:create(data.name, TYPE_FACE_TABLE.Arial_BoldMT, 8)
            tx:setPosition(ccp(itemSize.width / 2, itemSize.height / 2))
            tx:setColor(game_util.c3b_parse(isSelect and "#2AEAEB" or "#498EE4"))
            node:addChild(tx)
            return cell
        end,
        itemOnClick = function(eventType, index, item)
            if eventType == "ended" and item then
                local data = showData[index + 1]
                self.leftSelect = data.id
                self:refreshUi()
            end
        end,
        pageChangedCallFunc = function(totalPage, curPage)
        end
    }
    local tempTable = TableViewHelper:create(params)
    tempTable:setScrollBarVisible(false)
    return tempTable
end

function game_cosmic_rankReward.refreshRightList(self)
    local nd_right_list = self.m_ccbNode:nodeForName("nd_right_list")
    nd_right_list:removeAllChildrenWithCleanup(true)
    local showData = self.leftSelect == 1 and  self.showData1 or  self.showData2
    self._rightTb = self:createRightList(nd_right_list:getContentSize(), showData)
    nd_right_list:addChild(self._rightTb)
end

function game_cosmic_rankReward.createRightList(self, viewSize, showData)
    local params = {
        viewSize = viewSize,
        row = 2,
        column = 1,
        totalItem = #showData,
        touchPriority = GLOBAL_TOUCH_PRIORITY - 11,
        showPoint = false,
        itemActionFlag = false,
        direction = kCCScrollViewDirectionVertical, --纵向
        newCell = function(tableView, index)
            local cell = tableView:dequeueCell()
            if cell == nil then
                cell = CCTableViewCell:new()
                cell:autorelease()
            end

            cell:removeAllChildrenWithCleanup(true)
            local data = showData[index + 1]
            --
            local ccbNode = luaCCBNode:create()
            ccbNode:openCCBFile("ccb/ui_cosmic_rankRewardItem.ccbi")
            cell:addChild(ccbNode)

            -- lb_title
            local lb_title = ccbNode:labelTTFForName("lb_title")
            lb_title:setString(string.format(cosmicMgr.tx[9], data.rank))
            -- nd_rewards
            local nd_rewards = ccbNode:nodeForName("nd_rewards")
            nd_rewards:removeAllChildrenWithCleanup(true)
            local rewardData = data.reward
            local tempRewardTable = self:createRewardTabelView(nd_rewards:getContentSize(), rewardData)
            nd_rewards:addChild(tempRewardTable)

            return cell
        end,
        itemOnClick = function(eventType, index, item)
            if eventType == "ended" and item then
                -- self.leftSelect = index
                -- self:refreshUi()
            end
        end,
        pageChangedCallFunc = function(totalPage, curPage)
        end
    }
    local tempTable = TableViewHelper:create(params)
    tempTable:setScrollBarVisible(false)
    return tempTable
end

function game_cosmic_rankReward.createRewardTabelView(self, viewSize, rewardTab)
    local params = {}
    params.viewSize = viewSize
    params.row = 1 --行
    params.column = 3 --列
    params.direction = kCCScrollViewDirectionHorizontal
    params.totalItem = #rewardTab
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 11
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height / params.row)
    params.newCell = function(tableView, index)
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
        end
        if cell then
            cell:removeAllChildrenWithCleanup(true)
            local icon, name, count = game_util:getRewardByItemTable(rewardTab[index + 1], false)
            if icon then
                icon:setScale(0.65)
                icon:setPosition(ccp(itemSize.width * 0.5, itemSize.height * 0.6))
                cell:addChild(icon)
            end
            if count then
                local tempLabel = game_util:createLabelBMFont({text = "×" .. count, color = ccc3(255, 255, 255), fontSize = 8})
                tempLabel:setPosition(ccp(itemSize.width * 0.5, itemSize.height * 0.1))
                cell:addChild(tempLabel)
            end
        end
        return cell
    end
    params.itemOnClick = function(eventType, index, item)
        if eventType == "ended" and item then
            -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  item = " .. tolua.type(item));
            game_util:lookItemDetal(rewardTab[index + 1])
        end
    end
    return TableViewHelper:create(params)
end

return game_cosmic_rankReward
   #