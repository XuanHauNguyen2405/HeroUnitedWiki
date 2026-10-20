--- 扭蛋机 Gashapon
local game_gashapon = {
    m_root_layer = nil,
    m_tParams = nil,
    selectPage = 1,
    isAniming = false
}

local tx = {
    gashapon_1 = "",
    gashapon_2 = "Gashapon",
    gashapon_3 = "Đã kết thúc",
    gashapon_4 = "Đếm ngược:",
    gashapon_5 = "Cấp",
    gashapon_6 = "Đã đạt giới hạn quay thưởng kim cương hôm nay",
    gashapon_7 = "Đã đạt giới hạn quay thưởng vật phẩm hôm nay",
    gashapon_8 = "kim cương",
    gashapon_9 = "vật phẩm",
    gashapon_10 = "Không đủ Kim Cương",
    gashapon_11 = "Không đủ Vật Phẩm" 
}

function game_gashapon.destroy(self)
    self.m_root_layer = nil
    self.m_tParams = nil
    self.selectPage = 1
    self.isAniming = false
end

function game_gashapon.back(self, type)
    game_scene:removePopByName("game_gashapon")
end

function game_gashapon.init(self, t_params)
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {}

        self.item_times = self.m_tGameData.item_times or 0 -- 道具抽取次数
        self.expLv = self.m_tGameData.lv or 1 -- 等级
        self.version = self.m_tGameData.version or 100 -- 版本号
        self.endTime = self.m_tGameData.end_time
        self.exp = self.m_tGameData.exp or 0
        self.diamond_times = self.m_tGameData.diamond_times -- 钻石抽取次数
        self.today_diamond_times = self.m_tGameData.today_diamond_times -- 今日钻石抽次数
        self.today_item_times = self.m_tGameData.today_item_times -- 今日道具抽次数
        self.log = self.m_tGameData.log or {}
    else
        self.m_tGameData = {}
    end
end

function game_gashapon.create(self, t_params)
    self:init(t_params)
    self.m_tParams = t_params
    local m_popUi = self:createUi()
    self:refreshUi()
    return m_popUi
end

function game_gashapon.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if btnTag == 1 then
            self:back()
        elseif btnTag == 2 then -- 钻石抽奖
            if self.isAniming then
                return
            end

            ---- 判断每日上限
            local limit_diamondtime, _ = self:getTodayMaxGacha()
            if self.today_diamond_times >= limit_diamondtime then
                return game_util:addMoveTips({text = tx.gashapon_6})
            end

            ---- 判断钻石上限
            local gashaponPriceCfg = self:getGashaponPriceConfigByVersion(self.version)
            local getDiamondCost = function(times)
                local price_diamond = gashaponPriceCfg.price_diamond
                local cost = price_diamond[times + 1]
                if not cost then
                    cost = price_diamond[#price_diamond]
                end
                return cost
            end
            local diamondCost = {9, 0, getDiamondCost(self.diamond_times)}
            local ownCoin = game_data:getUserStatusDataByKey("coin") or 0
            if ownCoin < diamondCost[3] then
                return game_util:addMoveTips({text = tx.gashapon_10})
            end

            self.r_type = 0
            self.gashaponAnim:playSection("impact2")
            self.isAniming = true
        elseif btnTag == 3 then -- 道具抽奖
            if self.isAniming then
                return
            end

            ---- 判断每日上限
            local _, limit_itemtime = self:getTodayMaxGacha()
            if self.today_item_times >= limit_itemtime then
                return game_util:addMoveTips({text = tx.gashapon_7})
            end

            ---- 判断道具数量
            local gashaponPriceCfg = self:getGashaponPriceConfigByVersion(self.version)
            local getItemCost = function(times)
                local price_item = gashaponPriceCfg.price_item
                local limit_item = gashaponPriceCfg.limit_item
                if times < limit_item then
                    return price_item[1]
                else
                    return price_item[2]
                end
            end
            local itemCost = getItemCost(self.item_times)
            local count = game_data:getItemCountByCid(itemCost[2])
            if count < itemCost[3] then
                return game_util:addMoveTips({text = tx.gashapon_11})
            end

            self.r_type = 1
            self.gashaponAnim:playSection("impact2")
            self.isAniming = true
        elseif btnTag == 4 then -- 页面1 奖励预览
            self.selectPage = 1
            self:refreshUi()
        elseif btnTag == 5 then -- 页面2 中奖记录
            self.selectPage = 2
            self:refreshUi()
        elseif btnTag == 12 then --详情
            local cfg = self:getGashaponConfigByVersion(self.version)
            local des = cfg.des
            game_scene:addPop("game_active_limit_detail_pop", {openMsg = des})
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick) --bind button on click event
    ccbNode:openCCBFile("ccb/ui_gashapon.ccbi")
    self.ccbNode = ccbNode

    self.m_root_layer = ccbNode:layerForName("m_root_layer")

    -- 注册根图层触摸事件处理器并启用触摸功能
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true
        elseif eventType == "ended" then
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch, false, GLOBAL_TOUCH_PRIORITY - 2, true)
    self.m_root_layer:setTouchEnabled(true)

    self.cfg = {
        gashapon = json.decode(getConfig("gashapon"):getFormatBuffer() or "") or {},
        gashapon_price = json.decode(getConfig("gashapon_price"):getFormatBuffer() or "") or {},
        gashapon_exp = json.decode(getConfig("gashapon_exp"):getFormatBuffer() or "") or {}
    }

    self.lb_endTime = ccbNode:labelTTFForName("lb_endTime")
    ccbNode:labelTTFForName("lb_desc2"):setString(tx.gashapon_2)
    ccbNode:labelTTFForName("lb_endTime1"):setString(tx.gashapon_4)
    ccbNode:controlButtonForName("btn_gacha1"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
    ccbNode:controlButtonForName("btn_gacha2"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
    ccbNode:controlButtonForName("btn_page1"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
    ccbNode:controlButtonForName("btn_page2"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
    ccbNode:controlButtonForName("m_close_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
    ccbNode:controlButtonForName("btn_detail"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)

    self.nd_reward = ccbNode:nodeForName("nd_reward")
    self.lb_expLv = ccbNode:labelTTFForName("lb_expLv")
    self.lb_expValue = ccbNode:labelTTFForName("lb_expValue")

    ------ 更新进度条
    self.nd_expProgress = ccbNode:nodeForName("nd_expProgress")
    self.nd_expProgress:removeAllChildrenWithCleanup(true)
    self.m_progress_bar = ExtProgressBar:createWithFrameName("niudankuanghuan_005.png", "niudankuanghuan_006.png", self.nd_expProgress:getContentSize())
    self.m_progress_bar:setCurValue(0, false)
    self.nd_expProgress:addChild(self.m_progress_bar)

    self.selectPage = 1

    ------ 动画
    local nd_gashaponAnim = ccbNode:nodeForName("nd_gashaponAnim")
    nd_gashaponAnim:removeAllChildrenWithCleanup(true)
    local gashaponAnim = zcAnimNode:create("niudanji.swf.sam", 0, "niudanji.plist")
    local function animEnd(animNode, theId, lableName)
        if lableName == "impact1" then
            gashaponAnim:playSection("impact1")
        elseif lableName == "impact2" then
            self.isAniming = false
            gashaponAnim:playSection("impact1")
            self:getReward()
        end
    end
    gashaponAnim:registerScriptTapHandler(animEnd)
    gashaponAnim:playSection("impact1")
    self.gashaponAnim = gashaponAnim
    nd_gashaponAnim:addChild(gashaponAnim)

    return ccbNode
end

function game_gashapon.refreshUi(self)
    self:refreshCountdown()
    self:refreshPageBtn()
    self:refreshRewardPreview()
    self:refreshExpProgress()
    self:refreshCost()
end

function game_gashapon.refreshCost(self)
    local nd_cost1 = self.ccbNode:nodeForName("nd_cost1")
    local nd_cost2 = self.ccbNode:nodeForName("nd_cost2")
    nd_cost1:removeAllChildrenWithCleanup(true)
    nd_cost2:removeAllChildrenWithCleanup(true)
    local lb_cost1 = self.ccbNode:labelTTFForName("lb_cost1")
    local lb_cost2 = self.ccbNode:labelTTFForName("lb_cost2")
    local gashaponPriceCfg = self:getGashaponPriceConfigByVersion(self.version)

    ---- 根据次数获取钻石消耗
    local getDiamondCost = function(times)
        local price_diamond = gashaponPriceCfg.price_diamond
        local cost = price_diamond[times + 1]
        if not cost then
            cost = price_diamond[#price_diamond]
        end
        return cost
    end
    ---- 根据次数获取道具消耗
    local getItemCost = function(times)
        local price_item = gashaponPriceCfg.price_item
        local limit_item = gashaponPriceCfg.limit_item
        if times < limit_item then
            return price_item[1]
        else
            return price_item[2]
        end
    end

    local diamondCost = {9, 0, getDiamondCost(self.diamond_times)}
    local itemCost = getItemCost(self.item_times)

    local icon, name, count = game_util:getRewardByItemTable(diamondCost, false, true)
    icon:setScale(12 / icon:getContentSize().width)
    icon:setPosition(ccp(6, 6))
    nd_cost1:addChild(icon)

    local icon, name, count = game_util:getRewardByItemTable(itemCost, false, true)
    icon:setScale(12 / icon:getContentSize().width)
    icon:setPosition(ccp(6, 6))
    nd_cost2:addChild(icon)

    lb_cost1:setString(diamondCost[3])
    lb_cost2:setString(itemCost[3])

    game_util:centerTwoNode(nd_cost1, lb_cost1, 0, 3)
    game_util:centerTwoNode(nd_cost2, lb_cost2, 0, 3)

    local btn_gacha1 = self.ccbNode:controlButtonForName("btn_gacha1")
    local btn_gacha2 = self.ccbNode:controlButtonForName("btn_gacha2")
    game_util:setCCControlButtonTitle(btn_gacha1, tx.gashapon_8)
    game_util:setCCControlButtonTitle(btn_gacha2, tx.gashapon_9)

    ------ 刷新限制次数
    local lb_times1 = self.ccbNode:labelTTFForName("lb_times1")
    local lb_times2 = self.ccbNode:labelTTFForName("lb_times2")
    local limit_diamondtime, limit_itemtime = self:getTodayMaxGacha()
    lb_times1:setString((limit_diamondtime - self.today_diamond_times) .. "/" .. limit_diamondtime)
    lb_times2:setString((limit_itemtime - self.today_item_times) .. "/" .. limit_itemtime)
end

function game_gashapon.refreshPageBtn(self)
    local btn_page1 = self.ccbNode:controlButtonForName("btn_page1")
    local btn_page2 = self.ccbNode:controlButtonForName("btn_page2")
    if self.selectPage == 1 then
        game_util:setCCControlButtonBackground(btn_page1, "niudankuanghuan_018.png")
        game_util:setCCControlButtonBackground(btn_page2, "niudankuanghuan_017.png")
    elseif self.selectPage == 2 then
        game_util:setCCControlButtonBackground(btn_page1, "niudankuanghuan_017.png")
        game_util:setCCControlButtonBackground(btn_page2, "niudankuanghuan_018.png")
    end
end

function game_gashapon.refreshRewardPreview(self)
    local rewardTab
    if self.selectPage == 1 then
        local gashaponCfg = self:getGashaponConfigByVersion(self.version)
        rewardTab = gashaponCfg["reward_" .. self.expLv]
    elseif self.selectPage == 2 then
        local log = self.log
        local _reward = {}
        for k, v in ipairs(log) do
            for k1, v1 in ipairs(v) do
                table.insert(_reward, v1)
            end
        end
        rewardTab = _reward
    end

    self.nd_reward:removeAllChildrenWithCleanup(true)
    local parent = self.nd_reward
    local viewSize = parent:getContentSize()

    local params = {}
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 3
    params.viewSize = viewSize
    params.totalItem = #rewardTab
    params.row = 3
    params.column = 4
    params.direction = kCCScrollViewDirectionVertical
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height / params.row)
    params.newCell = function(tableView, index)
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
        end
        if cell then
            cell:removeAllChildrenWithCleanup(true)
            local icon, name, count = game_util:getRewardByItemTable(rewardTab[index + 1], true)
            if icon then
                icon:setPosition(ccp(itemSize.width * 0.5, itemSize.height * 0.5))
                icon:setScale(0.65)
                cell:addChild(icon)
            end
            if name then
                local tempLabel = game_util:createLabelTTF({text = "x" .. count, color = ccc3(250, 180, 0), fontSize = 8})
                tempLabel:setPosition(ccp(itemSize.width * 0.5, itemSize.height * 0.2))
                cell:addChild(tempLabel)
            end
        end
        return cell
    end
    params.itemOnClick = function(eventType, index, item)
        if eventType == "ended" and item then
            game_util:lookItemDetal(rewardTab[index + 1])
        end
    end

    local tbv = TableViewHelper:create(params)
    parent:addChild(tbv)
end

function game_gashapon.refreshCountdown(self)
    local lb_endTime1 = self.ccbNode:labelTTFForName("lb_endTime1")
    local lb_endTime = self.lb_endTime
    local node_conutdownTime = self.ccbNode:nodeForName("node_conutdownTime")
    node_conutdownTime:removeAllChildrenWithCleanup(true)
    local endTime = self.endTime
    local server_time = game_data:getUserStatusDataByKey("server_time")
    local remainTime = endTime - server_time

    if remainTime > 0 then
        lb_endTime:setString("")
        local function timeOverCallFun()
            lb_endTime:setString(tx.gashapon_3)
            node_conutdownTime:removeAllChildrenWithCleanup(true)
        end

        local pX, pY = lb_endTime:getPosition()
        local timeLabel = game_util:createCountdownLabel(remainTime, timeOverCallFun, 8, 1)
        timeLabel:setColor(ccc3(105, 238, 67))
        timeLabel:setPosition(ccp(node_conutdownTime:getContentSize().width / 2, node_conutdownTime:getContentSize().height / 2))
        node_conutdownTime:addChild(timeLabel, 10, 10)
    else
        lb_endTime:setString(tx.gashapon_3)
    end
end

--- 刷新经验进度条
-- @function refreshExpProgress
-- @param self game_gashapon 模块实例
-- @desc 根据当前等级和经验值更新进度条显示，包括等级标签、经验值标签和进度条视觉
-- @usage self:refreshExpProgress()
function game_gashapon.refreshExpProgress(self)
    -- 获取当前等级
    local currentLevel = self.expLv or 0
    -- 获取当前经验值（假设从服务器数据中获取）
    local currentExp = self.exp or 0
    local totalExpForNextLevel = self:getFullExpForLevel(currentLevel)

    -- 计算进度百分比
    local percentage = currentExp * 100 / totalExpForNextLevel
    if totalExpForNextLevel > 100 then
        totalExpForNextLevel = 100
    end

    -- 更新等级标签
    if self.lb_expLv then
        self.lb_expLv:setString(string.format("%d" .. tx.gashapon_5, currentLevel))
    end

    -- 更新经验值标签（格式：当前经验/下一级所需总经验）
    if self.lb_expValue then
        if totalExpForNextLevel > 0 then
            self.lb_expValue:setString(string.format("%d/%d", currentExp, totalExpForNextLevel))
        else
            -- 如果是最高等级
            self.lb_expValue:setString(string.format("%d/MAX", currentExp))
        end
    end

    -- 更新进度条显示
    self.m_progress_bar:setMaxValue(totalExpForNextLevel)
    self.m_progress_bar:setCurValue(currentExp, false)
end

---------------------------------------  tools  ------------------------------
--- 获取指定等级到下一等级所需配置经验值
function game_gashapon.getFullExpForLevel(self, level)
    local cfgExp = self.cfg.gashapon_exp
    if cfgExp[tostring(level + 1)] then
        return cfgExp[tostring(level + 1)].need_exp
    else
        return 0
    end
end

--- 根据版本获取gashapon配置
function game_gashapon.getGashaponConfigByVersion(self, version)
    return self.cfg.gashapon[tostring(version)]
end

--- 根据版本获取gashapon_price配置
function game_gashapon.getGashaponPriceConfigByVersion(self, version)
    return self.cfg.gashapon_price[tostring(version)]
end

--- 获取今日抽奖上限
function game_gashapon.getTodayMaxGacha(self)
    local cfg = self:getGashaponConfigByVersion(self.version)
    local limit_diamondtime = cfg.limit_diamondtime
    local limit_itemtime = cfg.limit_itemtime
    return limit_diamondtime, limit_itemtime
end

function game_gashapon:getReward()
    local r_type = self.r_type
    -- gashapon_get_reward
    local function responseMethod(tag, gameData)
        if gameData then
            self:init({gameData = gameData})
            self:refreshUi()
            gameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer())
            local reward = gameData.reward or {} -- 任务奖励
            game_util:rewardTipsByDataTable(reward)
        end
    end
    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("gashapon_get_reward"), http_request_method.GET, {r_type = r_type}, "gashapon_get_reward", true, true)
end

return game_gashapon
   -E  