--- 新人邀请活动
local game_new_player_invite = {
    m_root_layer = nil,
    m_tParams = nil,
    m_btnsData = {},
    leftSelectId = 1,
    inviteEditTx = ""
}

local tx = {
    daily_sign_1 = "Ngày %s",
    invite_tx_1 = "Mỗi tài khoản chỉ được điền một lần, hãy kiểm tra kỹ trước khi xác nhận.",
    invite_tx_2 = "Nhập UID người chơi cũ.",
    invite_tx_3 = "Phần thưởng",
    invite_tx_4 = "Đã nhận",
    invite_tx_5 = "Có thể nhận",
    invite_tx_6 = "Chưa hoàn thành",
    invite_tx_7 = "Số người đạt mục tiêu hiện tại: %s",
    invite_tx_8 = "Gửi"
}

local function safeDecode(field)
    local config = getConfig(field)
    if config and config.getFormatBuffer then
        local tb = json.decode(config:getFormatBuffer() or "") or {}
        local newTb = {}
        for k, v in pairs(tb) do
            v.id = tonumber(k)
            table.insert(newTb, v)
        end
        table.sort(
            newTb,
            function(a, b)
                return a.id < b.id
            end
        )
        return newTb
    end
    return {}
end

function game_new_player_invite.destroy(self)
    self.m_root_layer = nil
    self.m_tParams = nil
    self.m_btnsData = {}
    self.leftSelectId = 1
    self.inviteEditTx = ""
end

function game_new_player_invite.back(self, type)
    game_scene:removePopByName("game_new_player_invite")
end

function game_new_player_invite.init(self, t_params)
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {}
        self.is_new = self.m_tGameData.is_new
        self.invite_done = self.m_tGameData.invite_done or {}
        self.version = self.m_tGameData.version
        self.days = self.m_tGameData.days or 0
        self.sign_gift_done = self.m_tGameData.sign_gift_done or {}
        self.tasks_data = self.m_tGameData.tasks_data or {}
        self.tasks_done = self.m_tGameData.tasks_done or {}
        self.cost = self.m_tGameData.cost or 0
        self.charge_done = self.m_tGameData.charge_done or {}

        self.invite_uids = self.m_tGameData.invite_uids or {}
        self.caller = self.m_tGameData.caller or ""
        self.acc_caller = self.m_tGameData.acc_caller or ""
        self.charge = self.m_tGameData.charge or 0
    else
        self.m_tGameData = {}
    end
end

function game_new_player_invite.create(self, t_params)
    self:init(t_params)
    self.m_tParams = t_params
    local m_popUi = self:createUi()
    self:updateLeftBtnData()
    self:refreshUi()
    return m_popUi
end

function game_new_player_invite.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if btnTag == 1 then
            self:back()
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick) --bind button on click event
    ccbNode:openCCBFile("ccb/ui_g_n_p_invite_pop.ccbi")
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

    ccbNode:controlButtonForName("close_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)

    self.cfg = {
        newstar_seven = safeDecode(game_config_field.newstar_seven),
        newstar_mission = safeDecode(game_config_field.newstar_mission),
        newstar_reward = safeDecode(game_config_field.newstar_reward),
        newstar_invitation = safeDecode(game_config_field.newstar_invitation),
        newstar_veteran = safeDecode(game_config_field.newstar_veteran)
    }

    return ccbNode
end

function game_new_player_invite.refreshUi(self)
    self:refreshLeftList()
    self:refreshContent()
end

--[[
    更新左侧按钮数据
]]
function game_new_player_invite.updateLeftBtnData(self)
    local btnsData = {}

    if self.is_new then
        btnsData[#btnsData + 1] = {id = 1, mark = "Điểm danh mỗi ngày", ccb = "ccb/ui_g_n_p_invite_content_1.ccbi", updateFunc = "refreshDailySign"}
        btnsData[#btnsData + 1] = {id = 2, mark = "Nhiệm vụ tân thủ", ccb = "ccb/ui_g_n_p_invite_content_2.ccbi", updateFunc = "refreshNewPlayerTask"}
        btnsData[#btnsData + 1] = {id = 3, mark = "Quà siêu giá", ccb = "ccb/ui_g_n_p_invite_content_3.ccbi", updateFunc = "refreshExtraReward"}
        btnsData[#btnsData + 1] = {id = 4, mark = "Phần thưởng mời bạn", ccb = "ccb/ui_g_n_p_invite_content_4.ccbi", updateFunc = "refreshInviteReward"} -- 添加邀请奖励按钮配置
    else
        btnsData[#btnsData + 1] = {id = 5, mark = "Mốc cấp độ", ccb = "ccb/ui_g_n_p_invite_content_5.ccbi", updateFunc = "refreshMilestone", type = 1}
        btnsData[#btnsData + 1] = {id = 6, mark = "Mốc lực chiến", ccb = "ccb/ui_g_n_p_invite_content_5.ccbi", updateFunc = "refreshMilestone", type = 2}
        btnsData[#btnsData + 1] = {id = 7, mark = "Mốc VIP", ccb = "ccb/ui_g_n_p_invite_content_5.ccbi", updateFunc = "refreshMilestone", type = 3}
    end

    self.leftSelectId = btnsData[1].id

    self.m_btnsData = btnsData
end

--[[
    刷新左侧列表
]]
function game_new_player_invite.refreshLeftList(self)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/player_comeback.plist")

    local nd_leftList = self.ccbNode:nodeForName("nd_leftList")
    nd_leftList:removeAllChildrenWithCleanup(true)

    local parent = nd_leftList
    local viewSize = parent:getContentSize()

    local params = {}
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 3
    params.viewSize = viewSize
    params.totalItem = #self.m_btnsData
    params.row = 6
    params.column = 1
    params.direction = kCCScrollViewDirectionVertical
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height / params.row)
    params.newCell = function(tableView, index)
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local node = CCNode:create()
            node:setContentSize(itemSize)
            node:setAnchorPoint(ccp(0.5, 0.5))
            node:setPosition(ccp(itemSize.width / 2, itemSize.height / 2))
            cell:addChild(node, 0, 10)
        end

        if cell then
            local node = cell:getChildByTag(10)
            node:removeAllChildrenWithCleanup(true)

            local data = self.m_btnsData[index + 1]
            local id = data.id
            local name = data.mark

            -- 按钮图片
            local png = id == self.leftSelectId and "a1.png" or "a3.png"
            local sp = CCSprite:createWithSpriteFrameName(png)
            sp:setPosition(itemSize.width / 2, itemSize.height / 2)
            node:addChild(sp)
            -- 按钮文本
            local lb = CCLabelTTF:create(name, TYPE_FACE_TABLE.Arial_BoldMT, 7)
            lb:setPosition(itemSize.width / 2, itemSize.height / 2)
            node:addChild(lb)
        end
        return cell
    end
    params.itemOnClick = function(eventType, index, item)
        if eventType == "ended" and item then
            local data = self.m_btnsData[index + 1]
            self.leftSelectId = data.id
            self:refreshUi()
        end
    end

    local tbv = TableViewHelper:create(params)
    parent:addChild(tbv)
end

--[[
    根据selectId获取btnsData
]]
function game_new_player_invite.getBtnsDataById(self, selectId)
    for _, btnData in ipairs(self.m_btnsData) do
        if btnData.id == selectId then
            return btnData
        end
    end
    return nil
end

--[[
    刷新内容区域
]]
function game_new_player_invite.refreshContent(self)
    local nd_content = self.ccbNode:nodeForName("nd_content")
    nd_content:removeAllChildrenWithCleanup(true)

    local btnData = self:getBtnsDataById(self.leftSelectId)
    if not btnData then
        return
    end

    local ccbNode
    if btnData.ccb then
        ccbNode = luaCCBNode:create()
        ccbNode:openCCBFile(btnData.ccb)
        ccbNode:setAnchorPoint(ccp(0.5, 0.5))
        -- ccbNode:setPosition(ccp(nd_content:getContentSize().width / 2, nd_content:getContentSize().height / 2))
        nd_content:addChild(ccbNode)
    end

    if ccbNode and self[btnData.updateFunc] then
        self[btnData.updateFunc](self, ccbNode, btnData)
    end
end

--[[
    刷新每日签到状态
]]
function game_new_player_invite.refreshDailySign(self, ccbNode, btnData)
    local newstar_seven = self.cfg.newstar_seven
    local nd_list = ccbNode:nodeForName("nd_list")
    nd_list:removeAllChildrenWithCleanup(true)

    --------- 获取展示数据
    local showData = {}
    for k, v in pairs(newstar_seven) do
        if v.version == self.version then
            local _data = {}
            _data.cfg = v
            local day_id = v.day_id
            local hasGet = game_util:idInTableById(day_id, self.sign_gift_done)
            _data.hasGet = hasGet
            local canGet = day_id <= self.days and not hasGet
            _data.canGet = canGet
            table.insert(showData, _data)
        end
    end
    table.sort(
        showData,
        function(a, b)
            local statusA = a.canGet and 3 or (a.hasGet and 1 or 2)
            local statusB = b.canGet and 3 or (b.hasGet and 1 or 2)

            if statusA == statusB then
                return a.cfg.day_id < b.cfg.day_id
            else
                return statusA > statusB
            end
        end
    )

    local parent = nd_list
    local viewSize = parent:getContentSize()

    local params = {}
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 3
    params.viewSize = viewSize
    params.totalItem = #showData
    params.row = 3
    params.column = 1
    params.direction = kCCScrollViewDirectionVertical
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height / params.row)
    params.newCell = function(tableView, index)
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()

            local ccbNode = luaCCBNode:create()
            local function onMainBtnClick(target, event)
                local tagNode = tolua.cast(target, "CCNode")
                local btnTag = tagNode:getTag()
                if btnTag == 1 then
                    self:back()
                end
            end
            ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick) --bind button on click event
            ccbNode:openCCBFile("ccb/ui_g_n_p_invite_content_1_item.ccbi")
            cell:addChild(ccbNode, 0, 10)
        end

        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10), "luaCCBNode")

            local data = showData[index + 1]
            local day_id = data.cfg.day_id
            local hasGet = data.hasGet
            local canGet = data.canGet

            local reward = data.cfg.reward
            ----- 第几天
            local lb_signDay = ccbNode:labelTTFForName("lb_signDay")
            lb_signDay:setString(string.format(tx["daily_sign_1"], day_id))
            game_util.adaptNodeScaleX(lb_signDay, 140)
            ----- 奖励展示
            local nd_reward = ccbNode:nodeForName("nd_reward")
            nd_reward:removeAllChildrenWithCleanup(true)
            local tempRewardTable = self:createRewardTabelView(nd_reward:getContentSize(), reward)
            nd_reward:addChild(tempRewardTable)
            ----- 领奖按钮
            local btn_get = ccbNode:controlButtonForName("btn_get")
            btn_get:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
            btn_get:removeHandleOfControlEvent(CCControlEventTouchUpInside)
            btn_get:addHandleOfControlEvent(
                function()
                    if not canGet then
                        return
                    end
                    cclog("领取每日签到奖励 day_id: " .. data.cfg.day_id)
                    local function responseMethod(tag, gameData)
                        local data = gameData:getNodeWithKey("data")
                        local tData = json.decode(data:getFormatBuffer())
                        game_util:rewardTipsByDataTable(tData.reward)

                        self:init({gameData = gameData})
                        self:refreshUi()
                    end
                    local params = {}
                    params.days = day_id
                    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("newstar_get_login_reward"), http_request_method.GET, params, "newstar_get_login_reward_game_new_player_invite")
                end,
                CCControlEventTouchUpInside
            )
            if hasGet then -- 已领取
                -- btn_get:setColor(ccc3(81, 81, 81))
                btn_get:setTouchEnabled(false)
                local title = CCString:create(tx["invite_tx_4"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(81, 81, 81))
                btn_get:setTitleColorForState(ccc3(81, 81, 81), CCControlStateNormal)
            elseif canGet then -- 可领取
                -- btn_get:setColor(ccc3(255, 255, 255))
                btn_get:setTouchEnabled(true)
                local title = CCString:create(tx["invite_tx_5"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(255, 255, 255))
                btn_get:setTitleColorForState(ccc3(255, 255, 255), CCControlStateNormal)
            else -- 未完成
                btn_get:setTouchEnabled(false)
                local title = CCString:create(tx["invite_tx_6"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(160, 160, 160))
                btn_get:setTitleColorForState(ccc3(160, 160, 160), CCControlStateNormal)
            end
            game_util:setCCControlButtonSize(btn_get, 7)
        end
        return cell
    end
    params.itemOnClick = function(eventType, index, item)
        if eventType == "ended" and item then
            local data = self.m_btnsData[index + 1]
            self.leftSelectId = data.cfg.id
            self:refreshUi()
        end
    end

    local tbv = TableViewHelper:create(params)
    parent:addChild(tbv)
end

--[[
    刷新新人任务状态
]]
function game_new_player_invite.refreshNewPlayerTask(self, ccbNode, btnData)
    local newstar_mission = self.cfg.newstar_mission
    local nd_list = ccbNode:nodeForName("nd_list")
    nd_list:removeAllChildrenWithCleanup(true)

    local tasks_data = self.tasks_data
    local result = tasks_data.result

    --------- 获取展示数据
    local showData = {}
    for k, v in pairs(newstar_mission) do
        if v.version == self.version then
            local _data = {}
            _data.id = tonumber(k)
            _data.cfg = v
            _data.hasGet = game_util:idInTableById(_data.id, self.tasks_done)
            _data.value = result[tostring(_data.id)][1]
            _data.target = result[tostring(_data.id)][2]
            _data.canGet = _data.value >= _data.target and not _data.hasGet
            table.insert(showData, _data)
        end
    end
    table.sort(
        showData,
        function(a, b)
            local statusA = a.canGet and 3 or (a.hasGet and 1 or 2)
            local statusB = b.canGet and 3 or (b.hasGet and 1 or 2)

            if statusA == statusB then
                return a.id < b.id
            else
                return statusA > statusB
            end
        end
    )

    local parent = nd_list
    local viewSize = parent:getContentSize()

    local params = {}
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 3
    params.viewSize = viewSize
    params.totalItem = #showData
    params.row = 3
    params.column = 1
    params.direction = kCCScrollViewDirectionVertical
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height / params.row)
    params.newCell = function(tableView, index)
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()

            local ccbNode = luaCCBNode:create()
            local function onMainBtnClick(target, event)
                local tagNode = tolua.cast(target, "CCNode")
                local btnTag = tagNode:getTag()
                if btnTag == 1 then
                    self:back()
                end
            end
            ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick) --bind button on click event
            ccbNode:openCCBFile("ccb/ui_g_n_p_invite_content_2_item.ccbi")
            cell:addChild(ccbNode, 0, 10)
        end

        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10), "luaCCBNode")

            local data = showData[index + 1]
            local id = data.id
            local value = data.value
            local target = data.target
            local canGet = data.canGet
            local hasGet = data.hasGet
            local cfg = data.cfg
            local des = cfg.des
            local reward = cfg.reward

            ----- 任务
            local lb_taskName = ccbNode:labelTTFForName("lb_taskName")
            lb_taskName:setString(string.format("%s(%s/%s)", des, value, target))
            game_util.adaptNodeScaleX(lb_taskName, 140)
            ----- 奖励展示
            local nd_reward = ccbNode:nodeForName("nd_reward")
            nd_reward:removeAllChildrenWithCleanup(true)
            local tempRewardTable = self:createRewardTabelView(nd_reward:getContentSize(), reward)
            nd_reward:addChild(tempRewardTable)
            ----- 领奖按钮
            local btn_get = ccbNode:controlButtonForName("btn_get")
            btn_get:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
            btn_get:removeHandleOfControlEvent(CCControlEventTouchUpInside)
            btn_get:addHandleOfControlEvent(
                function()
                    if not canGet then
                        return
                    end
                    cclog("领取新人任务奖励 id: " .. data.id)
                    local function responseMethod(tag, gameData)
                        local data = gameData:getNodeWithKey("data")
                        local tData = json.decode(data:getFormatBuffer())
                        game_util:rewardTipsByDataTable(tData.reward)

                        self:init({gameData = gameData})
                        self:refreshUi()
                    end
                    local params = {}
                    params.task_id = id
                    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("newstar_get_task_reward"), http_request_method.GET, params, "newstar_get_task_reward_game_new_player_invite")
                end,
                CCControlEventTouchUpInside
            )
            if hasGet then -- 已领取
                -- btn_get:setColor(ccc3(81, 81, 81))
                btn_get:setTouchEnabled(false)
                local title = CCString:create(tx["invite_tx_4"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(81, 81, 81))
                btn_get:setTitleColorForState(ccc3(81, 81, 81), CCControlStateNormal)
            elseif canGet then -- 可领取
                -- btn_get:setColor(ccc3(255, 255, 255))
                btn_get:setTouchEnabled(true)
                local title = CCString:create(tx["invite_tx_5"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(255, 255, 255))
                btn_get:setTitleColorForState(ccc3(255, 255, 255), CCControlStateNormal)
            else -- 未完成
                btn_get:setTouchEnabled(false)
                local title = CCString:create(tx["invite_tx_6"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(160, 160, 160))
                btn_get:setTitleColorForState(ccc3(160, 160, 160), CCControlStateNormal)
            end
            game_util:setCCControlButtonSize(btn_get, 7)
        end
        return cell
    end
    params.itemOnClick = function(eventType, index, item)
        if eventType == "ended" and item then
        end
    end

    local tbv = TableViewHelper:create(params)
    parent:addChild(tbv)
end

--[[
    刷新超值奖励状态
    功能说明：
    1. 从配置表获取超值奖励数据
    2. 根据当前版本筛选有效数据
    3. 创建滚动列表展示奖励内容
    4. 每个条目包含奖励标题、条件说明和奖励内容展示
]]
function game_new_player_invite.refreshExtraReward(self, ccbNode, btnData)
    local newstar_reward = self.cfg.newstar_reward
    local nd_list = ccbNode:nodeForName("nd_list")
    nd_list:removeAllChildrenWithCleanup(true)

    local charge_done = self.charge_done
    local charge = self.charge
    local cost = self.cost

    --------- 获取展示数据
    local showData = {}
    for k, v in pairs(newstar_reward) do
        if v.version == self.version and v.type == 1 then
            local _data = {}
            local id = tonumber(k)
            _data.id = id
            _data.cfg = v
            local hasGet = game_util:idInTableById(id, charge_done)
            _data.hasGet = hasGet
            local canGet = charge >= v.num and not hasGet
            _data.canGet = canGet
            table.insert(showData, _data)
        end
        if v.version == self.version and v.type == 3 then
            local _data = {}
            local id = tonumber(k)
            _data.id = id
            _data.cfg = v
            local hasGet = game_util:idInTableById(id, charge_done)
            _data.hasGet = hasGet
            local canGet = cost >= v.num and not hasGet
            _data.canGet = canGet
            table.insert(showData, _data)
        end
    end

    table.sort(
        showData,
        function(a, b)
            local statusA = a.canGet and 3 or (a.hasGet and 1 or 2)
            local statusB = b.canGet and 3 or (b.hasGet and 1 or 2)

            if statusA == statusB then
                return a.id < b.id
            else
                return statusA > statusB
            end
        end
    )

    local parent = nd_list
    local viewSize = parent:getContentSize()

    local params = {}
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 3
    params.viewSize = viewSize
    params.totalItem = #showData
    params.row = 3
    params.column = 1
    params.direction = kCCScrollViewDirectionVertical
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height / params.row)
    params.newCell = function(tableView, index)
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()

            local ccbNode = luaCCBNode:create()
            ccbNode:openCCBFile("ccb/ui_g_n_p_invite_content_3_item.ccbi")
            cell:addChild(ccbNode, 0, 10)
        end

        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10), "luaCCBNode")

            local data = showData[index + 1]
            local cfg = data.cfg
            local des = cfg.des
            local reward = cfg.reward
            local hasGet = data.hasGet
            local canGet = data.canGet
            local id = data.id

            ----- 标题展示
            local lb_des = ccbNode:labelTTFForName("lb_des")
            lb_des:setString(des)
            game_util.adaptNodeScaleX(lb_des, 140)
            ----- 奖励展示
            local nd_reward = ccbNode:nodeForName("nd_reward")
            nd_reward:removeAllChildrenWithCleanup(true)
            local tempRewardTable = self:createRewardTabelView(nd_reward:getContentSize(), reward)
            nd_reward:addChild(tempRewardTable)
            ----- 领奖按钮
            local btn_get = ccbNode:controlButtonForName("btn_get")
            btn_get:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
            btn_get:removeHandleOfControlEvent(CCControlEventTouchUpInside)
            btn_get:addHandleOfControlEvent(
                function()
                    if not canGet then
                        return
                    end
                    -- 领奖逻辑待实现
                    cclog("领取超值奖励 id: " .. id)
                    local function responseMethod(tag, gameData)
                        local data = gameData:getNodeWithKey("data")
                        local tData = json.decode(data:getFormatBuffer())
                        game_util:rewardTipsByDataTable(tData.reward)

                        self:init({gameData = gameData})
                        self:refreshUi()
                    end
                    local params = {}
                    params.gift_id = id
                    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("newstar_get_coin_reward"), http_request_method.GET, params, "newstar_get_coin_reward_game_new_player_invite")
                end,
                CCControlEventTouchUpInside
            )
            if hasGet then -- 已领取
                -- btn_get:setColor(ccc3(81, 81, 81))
                btn_get:setTouchEnabled(false)
                local title = CCString:create(tx["invite_tx_4"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(81, 81, 81))
                btn_get:setTitleColorForState(ccc3(81, 81, 81), CCControlStateNormal)
            elseif canGet then -- 可领取
                -- btn_get:setColor(ccc3(255, 255, 255))
                btn_get:setTouchEnabled(true)
                local title = CCString:create(tx["invite_tx_5"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(255, 255, 255))
                btn_get:setTitleColorForState(ccc3(255, 255, 255), CCControlStateNormal)
            else -- 未完成
                btn_get:setTouchEnabled(false)
                local title = CCString:create(tx["invite_tx_6"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(160, 160, 160))
                btn_get:setTitleColorForState(ccc3(160, 160, 160), CCControlStateNormal)
            end
            game_util:setCCControlButtonSize(btn_get, 7)
        end
        return cell
    end
    params.itemOnClick = function(eventType, index, item)
        if eventType == "ended" and item then
        -- 可添加点击条目详情逻辑
        end
    end

    local tbv = TableViewHelper:create(params)
    parent:addChild(tbv)
end

--[[
    刷新邀请奖励状态
    功能说明：
    1. 从配置表获取邀请奖励数据
    2. 根据当前版本筛选有效数据
    3. 创建滚动列表展示邀请进度和奖励内容
    4. 每个条目包含任务描述、当前进度和奖励展示
]]
function game_new_player_invite.refreshInviteReward(self, ccbNode, btnData)
    local newstar_invitation = self.cfg.newstar_invitation
    local cfg = nil
    for k, v in pairs(newstar_invitation) do
        if v.id == self.version then -- v.id 实际是对应的配置version字段
            cfg = v
            break
        end
    end
    if not cfg then
        return
    end

    local reward = cfg.reward
    local acc_caller = self.acc_caller or ""
    local hasGet = acc_caller ~= ""

    -- 描述文本
    ccbNode:labelTTFForName("lb_des1"):setString(cfg.des or tx["invite_tx_1"])
    ccbNode:labelTTFForName("lb_des2"):setString(tx["invite_tx_2"])
    ccbNode:labelTTFForName("lb_des3"):setString(tx["invite_tx_3"])

    -- uid输入框
    local nd_editBox = ccbNode:nodeForName("nd_editBox")
    nd_editBox:removeAllChildrenWithCleanup(true)
    local function editBoxTextEventHandle(strEventName, pSender)
        local edit = tolua.cast(pSender, "CCEditBox")
        local strFmt
        if strEventName == "changed" then
            self.inviteEditTx = edit:getText()
        end
    end
    local editBox = game_util:createEditBox({bgFileName = nil, scriptEditBoxHandler = editBoxTextEventHandle, size = nd_editBox:getContentSize(), placeHolder = "", maxLength = 20})
    editBox:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
    editBox:setText(acc_caller)
    editBox:setEnabled(acc_caller == "")
    nd_editBox:addChild(editBox)
    ----- 奖励展示
    local nd_reward = ccbNode:nodeForName("nd_reward")
    nd_reward:removeAllChildrenWithCleanup(true)
    local tempRewardTable = self:createRewardTabelView(nd_reward:getContentSize(), reward)
    nd_reward:addChild(tempRewardTable)
    ----- 确认按钮
    local btn_get = ccbNode:controlButtonForName("btn_get")
    btn_get:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
    btn_get:addHandleOfControlEvent(
        function()
            if hasGet then
                return
            end
            if self.inviteEditTx == "" then
                return
            end
            -- 确认逻辑待实现
            cclog("确认邀请 id: " .. self.inviteEditTx)
            local function responseMethod(tag, gameData)
                local data = gameData:getNodeWithKey("data")
                local tData = json.decode(data:getFormatBuffer())
                game_util:rewardTipsByDataTable(tData.reward)

                self:init({gameData = gameData})
                self:refreshUi()
            end
            local params = {}
            params.t_uid = self.inviteEditTx
            network.sendHttpRequest(responseMethod, game_url.getUrlForKey("newstar_add_caller"), http_request_method.GET, params, "newstar_add_caller_game_new_player_invite")
        end,
        CCControlEventTouchUpInside
    )
    btn_get:setTouchEnabled(not hasGet)
    btn_get:setTitleForState(CCString:create(not hasGet and tx["invite_tx_8"] or tx["invite_tx_4"]), CCControlStateNormal)
    btn_get:setColor(not hasGet and ccc3(255, 255, 255) or ccc3(81, 81, 81))
    btn_get:setTitleColorForState(not hasGet and ccc3(255, 255, 255) or ccc3(81, 81, 81), CCControlStateNormal)
end

function game_new_player_invite.createRewardTabelView(self, viewSize, rewardTab)
    local params = {}
    params.viewSize = viewSize
    params.row = 1 --行
    params.column = 4 --列
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
                tempLabel:setPosition(ccp(itemSize.width * 0.5, itemSize.height * 0.2))
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

-- 刷新里程碑状态
function game_new_player_invite.refreshMilestone(self, ccbNode, btnData)
    local type = btnData.type
    local inviteNum = self:getInviteNumByType(type)
    ----- 完成目标人数
    local lb_targetNum = ccbNode:labelTTFForName("lb_targetNum")
    lb_targetNum:setString(string.format(tx["invite_tx_7"], inviteNum))

    local newstar_veteran = self.cfg.newstar_veteran
    local invite_done = self.invite_done
    local nd_list = ccbNode:nodeForName("nd_list")
    nd_list:removeAllChildrenWithCleanup(true)

    ---- 构建展示数据
    local showData = {}
    for k, v in pairs(newstar_veteran) do
        if v.version == self.version and type == v.type then
            local _data = {}
            local id = tonumber(k)
            _data.id = id
            _data.cfg = v
            local hasGet = game_util:idInTableById(v.id, invite_done)
            _data.hasGet = hasGet
            local canGet = inviteNum >= v.num and not hasGet
            _data.canGet = canGet

            table.insert(showData, _data)
        end
    end
    table.sort(
        showData,
        function(a, b)
            local statusA = a.canGet and 3 or (a.hasGet and 1 or 2)
            local statusB = b.canGet and 3 or (b.hasGet and 1 or 2)

            if statusA == statusB then
                return a.cfg.num < b.cfg.num
            else
                return statusA > statusB
            end
        end
    )
    if #showData == 0 then
        return
    end
    ---- 构建展示列表显示
    local parent = nd_list
    local viewSize = parent:getContentSize()

    local params = {}
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 3
    params.viewSize = viewSize
    params.totalItem = #showData
    params.row = 3
    params.column = 1
    params.direction = kCCScrollViewDirectionVertical
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height / params.row)
    params.newCell = function(tableView, index)
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()

            local ccbNode = luaCCBNode:create()
            -- local function onMainBtnClick(target, event)
            --     local tagNode = tolua.cast(target, "CCNode")
            --     local btnTag = tagNode:getTag()
            --     if btnTag == 1 then
            --         self:back()
            --     end
            -- end
            -- ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick) --bind button on click event
            ccbNode:openCCBFile("ccb/ui_g_n_p_invite_content_5_item.ccbi")
            ccbNode:setAnchorPoint(ccp(0.5, 0.5))
            ccbNode:setPosition(ccp(itemSize.width * 0.5, itemSize.height * 0.5))
            cell:addChild(ccbNode, 0, 10)
        end

        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10), "luaCCBNode")

            local data = showData[index + 1]
            local cfg = data.cfg
            local des = cfg.des
            local reward = cfg.reward
            local id = data.id
            local num = cfg.num
            local type = cfg.type

            local hasGet = game_util:idInTableById(id, invite_done)
            local canGet = inviteNum >= num and not hasGet

            -- des
            local lb_leftTopTx = ccbNode:labelTTFForName("lb_leftTopTx")
            lb_leftTopTx:setString(des)
            game_util.adaptNodeScaleX(lb_leftTopTx, 140)

            ----- 奖励展示
            local nd_reward = ccbNode:nodeForName("nd_reward")
            nd_reward:removeAllChildrenWithCleanup(true)
            local tempRewardTable = self:createRewardTabelView(nd_reward:getContentSize(), reward)
            nd_reward:addChild(tempRewardTable)

            ----- 领奖按钮
            local btn_get = ccbNode:controlButtonForName("btn_get")
            btn_get:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 3)
            btn_get:removeHandleOfControlEvent(CCControlEventTouchUpInside)
            btn_get:addHandleOfControlEvent(
                function()
                    if not canGet then
                        return
                    end
                    cclog("领取等级里程碑奖励: " .. cfg.id)
                    local function responseMethod(tag, gameData)
                        local data = gameData:getNodeWithKey("data")
                        local tData = json.decode(data:getFormatBuffer())
                        game_util:rewardTipsByDataTable(tData.reward)

                        self:init({gameData = gameData})
                        self:refreshUi()
                    end
                    local params = {}
                    params.gift_id = id
                    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("newstar_get_invite_reward"), http_request_method.GET, params, "newstar_get_invite_reward_game_new_player_invite")
                end,
                CCControlEventTouchUpInside
            )

            if hasGet then -- 已领取
                btn_get:setTouchEnabled(false)
                local title = CCString:create(tx["invite_tx_4"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(81, 81, 81))
                btn_get:setTitleColorForState(ccc3(81, 81, 81), CCControlStateNormal)
            elseif canGet then -- 可领取
                btn_get:setTouchEnabled(true)
                local title = CCString:create(tx["invite_tx_5"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(255, 255, 255))
                btn_get:setTitleColorForState(ccc3(255, 255, 255), CCControlStateNormal)
            else -- 未完成
                btn_get:setTouchEnabled(false)
                local title = CCString:create(tx["invite_tx_6"])
                btn_get:setTitleForState(title, CCControlStateNormal)
                btn_get:setColor(ccc3(160, 160, 160))
                btn_get:setTitleColorForState(ccc3(160, 160, 160), CCControlStateNormal)
            end
            game_util:setCCControlButtonSize(btn_get, 7)
        end
        return cell
    end
    params.itemOnClick = function(eventType, index, item)
        if eventType == "ended" and item then
        end
    end

    local tbv = TableViewHelper:create(params)
    parent:addChild(tbv)
end

-- 获取单个type的邀请人数
function game_new_player_invite.getInviteNumByType(self, type)
    local newstar_veteran = self.cfg.newstar_veteran
    local invite_uids = self.invite_uids or {}
    local num = 0
    local task = nil
    for k, v in pairs(newstar_veteran) do
        if v.version == self.version and type == v.type then
            task = v.task
            break
        end
    end
    for uid, v in pairs(invite_uids) do
        local value = v[tostring(type)]
        if value and value >= task then
            num = num + 1
        end
    end
    return num
end

-- 获取邀请人数
function game_new_player_invite.getInviteUidNum(self, ccbNode)
    local invite_uids = self.invite_uids or {}
    local num = 0
    for k, v in pairs(invite_uids) do
        num = num + 1
    end
    return num
end

return game_new_player_invite
   ��  