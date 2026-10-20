-------------------- 次元战场 主界面
local cosmicMgr = require("game_ui.cosmicMgr")

local game_cosmic_main = {
    m_tGameData = nil
}

local campColor = {
    ccc3(255, 0, 0), -- 红
    ccc3(0, 255, 0), -- 绿
    ccc3(0, 0, 255) -- 蓝
}

local grayColor = ccc3(200, 200, 200)

function game_cosmic_main.destroy(self)
    self.m_tGameData = nil
    if self.m_shared then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared)
        self.m_shared = nil
    end
    if self.m_shared2 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared2)
        self.m_shared2 = nil
    end
    if self.m_shared3 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared3)
        self.m_shared3 = nil
    end
end

function game_cosmic_main.back(self, type)
    local function responseMethod(tag, gameData)
        game_scene:enterGameUi("game_godfield_mainBig", {gameData = gameData})
        self:destroy()
    end
    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("god_field_index"), http_request_method.GET, {}, "game_cosmic_main_god_field_index")
end

function game_cosmic_main.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if btnTag == 99999 then
            self:back()
        elseif btnTag == 2 then -- 左侧plane状态控制
            local winSize = CCDirector:sharedDirector():getWinSize()

            if self.leftPlaneIsOpen == true then
                self.leftPlaneIsOpen = false
                self.nd_leftPlane:stopAllActions()
                self.nd_leftPlane:runAction(CCMoveTo:create(0.5, ccp(-61.8, winSize.height - 101.4)))

                self.btn_leftPlane:setScaleX(1)
                if self.rightPlaneIsOpen == false then
                    self.mapLayer:setMoveEnable(true)
                end
            else
                self.leftPlaneIsOpen = true
                self.nd_leftPlane:stopAllActions()
                self.nd_leftPlane:runAction(CCMoveTo:create(0.5, ccp(78.2, winSize.height - 101.4)))

                self.btn_leftPlane:setScaleX(-1)
                self.mapLayer:setMoveEnable(false)
            end
        elseif btnTag == 3 then -- 右侧plane状态控制
            local winSize = CCDirector:sharedDirector():getWinSize()

            if self.rightPlaneIsOpen == true then
                self.rightPlaneIsOpen = false
                self.nd_rightPlane:stopAllActions()
                self.nd_rightPlane:runAction(CCMoveTo:create(0.5, ccp(winSize.width + 100, 110.4)))

                self.btn_rightPlane:setScaleX(-1)

                if self.leftPlaneIsOpen == false then
                    self.mapLayer:setMoveEnable(true)
                end
            else
                self.rightPlaneIsOpen = true
                self.nd_rightPlane:stopAllActions()
                self.nd_rightPlane:runAction(CCMoveTo:create(0.5, ccp(winSize.width - 157.5, 110.4)))

                self.btn_rightPlane:setScaleX(1)
                self.mapLayer:setMoveEnable(false)
            end
        elseif btnTag == 4 then -- 我的位置
            self.mapLayer:moveToPlayerPosition()
        elseif btnTag == 5 then
            game_scene:addPop("game_cosmic_detail", {tx = cosmicMgr.cfg.cosmic_war_txt[5].txt})
        elseif btnTag == 6 then
            local nd_atkPg = ccbNode:nodeForName("nd_atkPg")
            local nd_rewardShow = ccbNode:nodeForName("nd_rewardShow")
            nd_rewardShow:setVisible(false)
            local nd_rewardShow_1 = ccbNode:nodeForName("nd_rewardShow_1")
            nd_rewardShow_1:removeAllChildrenWithCleanup(true)

            local btn_atkPgBlock = ccbNode:controlButtonForName("btn_atkPgBlock")
            local btn_atkPgBlock2 = ccbNode:controlButtonForName("btn_atkPgBlock2")
            btn_atkPgBlock2:setVisible(false)
            if nd_atkPg:isVisible() then
                nd_atkPg:setVisible(false)
                btn_atkPgBlock:setVisible(false)
            else
                nd_atkPg:setVisible(true)
                self:refreshAtkPg()
                btn_atkPgBlock:setVisible(true)
            end
        elseif btnTag == 7 then
            local nd_atkPg = ccbNode:nodeForName("nd_atkPg")
            local nd_rewardShow = ccbNode:nodeForName("nd_rewardShow")
            nd_rewardShow:setVisible(false)
            local nd_rewardShow_1 = ccbNode:nodeForName("nd_rewardShow_1")
            nd_rewardShow_1:removeAllChildrenWithCleanup(true)
            nd_atkPg:setVisible(false)

            local btn_atkPgBlock = self.m_ccbNode:controlButtonForName("btn_atkPgBlock")
            btn_atkPgBlock:setVisible(false)
        elseif btnTag == 8 then
            self.leftSelect = 1
            self:refreshScoreList()
        elseif btnTag == 9 then
            local function responseMethod(tag, gameData)
                self.leftSelect = 2
                local data = gameData:getNodeWithKey("data")
                self.atkScoreData = json.decode(data:getFormatBuffer())
                self:refreshScoreList()
            end

            local showData = cosmicMgr:getRankRewardShowData2()
            local maxNum = #showData
            network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_attack_win_rank"), http_request_method.GET, {s_num = 1, e_num = maxNum}, "game_cosmic_main_cosmic_war_attack_win_rank", false)
        elseif btnTag == 10 then
            local nd_rewardShow = ccbNode:nodeForName("nd_rewardShow")
            nd_rewardShow:setVisible(false)
            local nd_rewardShow_1 = ccbNode:nodeForName("nd_rewardShow_1")
            nd_rewardShow_1:removeAllChildrenWithCleanup(true)
            local btn_atkPgBlock2 = self.m_ccbNode:controlButtonForName("btn_atkPgBlock2")
            btn_atkPgBlock2:setVisible(false)
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode:openCCBFile("ccb/ui_cosmic_main.ccbi")

    self.m_ccbNode = ccbNode

    self.leftPlaneIsOpen = false -- 左侧plane是否打开
    self.rightPlaneIsOpen = false -- 右侧plane是否打开

    self.nd_leftPlane = ccbNode:nodeForName("nd_leftPlane")
    self.nd_rightPlane = ccbNode:nodeForName("nd_rightPlane")

    self.btn_leftPlane = ccbNode:controlButtonForName("btn_leftPlane")
    self.btn_rightPlane = ccbNode:controlButtonForName("btn_rightPlane")

    local winSize = CCDirector:sharedDirector():getWinSize()
    self.nd_leftPlane:setPosition(ccp(-61.8, winSize.height - 101.4))
    self.btn_leftPlane:setScaleX(1)
    self.nd_rightPlane:setPosition(ccp(winSize.width + 100, 110.4))
    self.btn_rightPlane:setScaleX(-1)

    self.lb_endTime = ccbNode:labelTTFForName("lb_endTime")
    self.lb_endTime:setString("")
    self.lb_moveTime = ccbNode:labelTTFForName("lb_moveTime")
    self.lb_moveTime:setString("")

    self.btn_leftPlane:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    self.btn_rightPlane:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("m_close_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_selfPos"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_mask1"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_mask2"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_xq"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_atkPg"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_atkPgBlock"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_atkPgBlock"):setVisible(false)
    ccbNode:controlButtonForName("btn_atkPgBlock2"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_atkPgBlock2"):setVisible(false)
    ccbNode:controlButtonForName("btn_left_1"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_left_2"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1)
    ccbNode:controlButtonForName("btn_mask1"):setOpacity(0)
    ccbNode:controlButtonForName("btn_mask2"):setOpacity(0)

    game_util:setCCControlButtonTitle(ccbNode:controlButtonForName("btn_left_1"), cosmicMgr.tx[23])
    game_util:setCCControlButtonTitle(ccbNode:controlButtonForName("btn_left_2"), cosmicMgr.tx[24])

    self.nd_myTeam = ccbNode:nodeForName("nd_myTeam")

    ccbNode:nodeForName("nd_atkPg"):setVisible(false)
    local nd_rewardShow = ccbNode:nodeForName("nd_rewardShow")
    nd_rewardShow:setVisible(false)

    self.leftSelect = 1

    self:createMap()

    return ccbNode
end
--

function game_cosmic_main.refreshUi(self, scrollToSelect)
    local serverTime = game_data:getVirtualServerTime() -- 当前服务器时间
    local s = CCDirector:sharedDirector():getScheduler()
    local timeScale = 1
    if s then
        timeScale = s:getTimeScale()
    end

    -- 倒计时
    if self.m_shared2 == nil then
        function tick()
            local step = cosmicMgr:getCurrentStep() -- 当前阶段
            local serverTime = game_data:getVirtualServerTime() -- 当前服务器时间
            if step == 0 then
            elseif step == 1 then -- 报名阶段
            elseif step == 2 then -- 分组阶段
            elseif step == 3 then -- 战斗准备阶段
                local time = cosmicMgr:getStepBeginTime(4)
                time = time - serverTime
                time = math.max(time, 0)
                local hours = math.floor(time / 3600)
                local minutes = math.floor((time - hours * 3600) / 60)
                local seconds = math.floor(time - hours * 3600 - minutes * 60)
                hours = hours < 10 and "0" .. hours or "" .. hours
                minutes = minutes < 10 and "0" .. minutes or "" .. minutes
                seconds = seconds < 10 and "0" .. seconds or "" .. seconds
                self.lb_endTime:setString(cosmicMgr.tx[12] .. hours .. ":" .. minutes .. ":" .. seconds)
            elseif step == 4 then -- 战斗准备阶段 战斗阶段
                local time = cosmicMgr:getStepBeginTime(5)
                time = time - serverTime
                time = math.max(time, 0)
                local hours = math.floor(time / 3600)
                local minutes = math.floor((time - hours * 3600) / 60)
                local seconds = math.floor(time - hours * 3600 - minutes * 60)
                hours = hours < 10 and "0" .. hours or "" .. hours
                minutes = minutes < 10 and "0" .. minutes or "" .. minutes
                seconds = seconds < 10 and "0" .. seconds or "" .. seconds
                self.lb_endTime:setString(cosmicMgr.tx[13] .. hours .. ":" .. minutes .. ":" .. seconds)
            elseif step == 5 then
                local time = cosmicMgr:getStepBeginTime(6)
                time = time - serverTime
                time = math.max(time, 0)
                local hours = math.floor(time / 3600)
                local minutes = math.floor((time - hours * 3600) / 60)
                local seconds = math.floor(time - hours * 3600 - minutes * 60)
                hours = hours < 10 and "0" .. hours or "" .. hours
                minutes = minutes < 10 and "0" .. minutes or "" .. minutes
                seconds = seconds < 10 and "0" .. seconds or "" .. seconds
                self.lb_endTime:setString(cosmicMgr.tx[14] .. hours .. ":" .. minutes .. ":" .. seconds)
            else
                self.lb_endTime:setString(cosmicMgr.tx[5])
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared)
                self.m_shared2 = nil
            end
        end
        self.m_shared2 = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 1 * timeScale, false)
        tick()
    end

    -- local lb_endTime2 = self.m_ccbNode:labelTTFForName("lb_endTime2")
    -- lb_endTime2:setString("")
    -- lb_endTime2:removeAllChildrenWithCleanup(true)
    -- local endTime = cosmicMgr:getStepBeginTime(5)
    -- local remainTime = endTime - serverTime
    -- local function timeEndFunc()
    --     lb_endTime2:removeAllChildrenWithCleanup(true)
    --     lb_endTime2:setString(cosmicMgr.tx[5])
    -- end
    -- local countdownLabel = game_util:createCountdownLabel(remainTime, timeEndFunc, 8)
    -- countdownLabel:setPosition(ccp(countdownLabel:getContentSize().width * 0.5, 0))
    -- lb_endTime2:addChild(countdownLabel)
    -- 移动cd倒计时
    if self.m_shared3 == nil then
        function tick()
            local time = cosmicMgr:getMoveRemainCd()
            local hours = math.floor(time / 3600)
            local minutes = math.floor((time - hours * 3600) / 60)
            local seconds = math.floor(time - hours * 3600 - minutes * 60)
            hours = hours < 10 and "0" .. hours or "" .. hours
            minutes = minutes < 10 and "0" .. minutes or "" .. minutes
            seconds = seconds < 10 and "0" .. seconds or "" .. seconds
            self.lb_moveTime:setString(cosmicMgr.tx[15] .. hours .. ":" .. minutes .. ":" .. seconds)
        end
        self.m_shared3 = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 1 * timeScale, false)
        tick()
    end

    -- local lb_moveTime2 = self.m_ccbNode:labelTTFForName("lb_moveTime2")
    -- lb_moveTime2:setString("")
    -- lb_moveTime2:removeAllChildrenWithCleanup(true)
    -- local remainCd = cosmicMgr:getMoveRemainCd()
    -- local function timeEndFunc()
    --     lb_moveTime2:removeAllChildrenWithCleanup(true)
    --     lb_moveTime2:setString("0")
    -- end
    -- local countdownLabel = game_util:createCountdownLabel(remainCd, timeEndFunc, 8)
    -- countdownLabel:setPosition(ccp(countdownLabel:getContentSize().width * 0.5, 0))
    -- lb_moveTime2:addChild(countdownLabel)
    if self.leftSelect == 1 then
        self:refreshScoreList()
    end
    self:refreshOccupyList()

    -- 刷新我的阵容
    self:refreshMyTeam()

    if self.m_shared == nil then
        local idx = 0
        function tick()
            idx = idx + 1
            if idx > 5 then
                local function responseMethod(tag, gameData)
                    self:init({gameData = gameData})
                    if self.mapLayer then
                        self.mapLayer:updateMapInfo()
                    end
                    self:refreshUi()
                end
                network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_index"), http_request_method.GET, {}, "game_cosmic_main_cosmic_war_index", false)
                idx = 0
            else
                self.mapLayer:updateMapInfo()
            end
        end
        self.m_shared = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 1 * timeScale, false)
        tick()
    end

    -- 红点
    local sp_atkPgRed = self.m_ccbNode:spriteForName("sp_atkPgRed")
    local hasRed = self:checkHasCanGetBox()
    sp_atkPgRed:setVisible(hasRed)
end

--[[
    刷新进攻进度条
]]
function game_cosmic_main:refreshAtkPg()
    local nd_atkPg_pg = self.m_ccbNode:nodeForName("nd_atkPg_pg")
    nd_atkPg_pg:removeAllChildrenWithCleanup(true)

    local bar = ExtProgressTime:createWithFrameName("ciyuan_65.png", "ciyuan_64.png")
    nd_atkPg_pg:addChild(bar)

    local attack_times = cosmicMgr:getAtkTimes() -- 进攻次数
    local maxTimes = cosmicMgr:getAtkMaxTimes() -- 最大次数
    bar:setMaxValue(maxTimes)
    bar:setCurValue(attack_times, false)

    local boxDatas = cosmicMgr:getAtkBoxDatas()
    local width = nd_atkPg_pg:getContentSize().width
    local height = nd_atkPg_pg:getContentSize().height

    for k, v in ipairs(boxDatas) do
        local num = v.num
        local reward = v.reward or {}
        local hasGet = cosmicMgr:checkHasGetAtkReardLog(v.id)
        local canGet = not hasGet and num <= attack_times

        local pos = ccp(width * (num / maxTimes), height / 2)

        local sp = CCSprite:createWithSpriteFrameName("ciyuan_062.png")
        sp:setPosition(pos)
        nd_atkPg_pg:addChild(sp)

        -- 按钮
        local btn =
            game_util:createCCControlButton(
            not hasGet and "ciyuan_056.png" or "ciyuan_055.png",
            "",
            function()
                if canGet then
                    local function responseMethod(tag, gameData)
                        local data = gameData:getNodeWithKey("data")
                        data = json.decode(data:getFormatBuffer())
                        if data.reward then
                            game_util:rewardTipsByDataTable(data.reward)
                        end
                        if data.att_reward_log then
                            cosmicMgr:update_att_reward_log(data.att_reward_log)
                        end
                        if data.attack_times then
                            cosmicMgr:update_attack_times(data.attack_times)
                        end
            
                        self:refreshAtkPg()
                        self:refreshUi()
                    end
                    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_attack_reward"), http_request_method.GET, {rid = v.id}, "game_cosmic_main_cosmic_war_attack_reward")
                else
                    local nd_rewardShow = self.m_ccbNode:nodeForName("nd_rewardShow")
                    nd_rewardShow:setVisible(true)

                    -- 将pos从nd_atkPg_pg坐标系转换到nd_rewardShow父节点坐标系
                    local worldPos = nd_atkPg_pg:convertToWorldSpace(ccp(pos.x, pos.y))
                    local nd_rewardShow_parent = nd_rewardShow:getParent()
                    local targetPos = nd_rewardShow_parent:convertToNodeSpace(worldPos)
                    nd_rewardShow:setPosition(ccp(targetPos.x, targetPos.y - 10))

                    local nd_rewardShow_1 = self.m_ccbNode:nodeForName("nd_rewardShow_1")
                    nd_rewardShow_1:removeAllChildrenWithCleanup(true)
                    local tempRewardTable = self:createRewardTabelView(nd_rewardShow_1:getContentSize(), reward)
                    nd_rewardShow_1:addChild(tempRewardTable)

                    local btn_atkPgBlock2 = self.m_ccbNode:controlButtonForName("btn_atkPgBlock2")
                    btn_atkPgBlock2:setVisible(true)
                end
            end,
            GLOBAL_TOUCH_PRIORITY - 1
        )
        btn:setPosition(pos)
        nd_atkPg_pg:addChild(btn)

        -- 文本
        local tx = CCLabelTTF:create(num, TYPE_FACE_TABLE.Arial_BoldMT, 8)
        tx:setPosition(ccp(pos.x, pos.y - 15))
        tx:setColor(ccc3(215, 215, 2151))
        nd_atkPg_pg:addChild(tx)

        -- 红点
        if canGet then
            local bit = CCSprite:createWithSpriteFrameName("bounty_bit.png")
            nd_atkPg_pg:addChild(bit)
            bit:setPosition(ccp(pos.x + 10, pos.y + 10))
        end
    end
    -- 我的进攻次数
    local lb_attPgValue = self.m_ccbNode:labelTTFForName("lb_attPgValue")
    lb_attPgValue:setString(cosmicMgr.tx[28] .. attack_times)
end

function game_cosmic_main.createRewardTabelView(self, viewSize, rewardTab)
    local params = {}
    params.viewSize = viewSize
    params.row = 1 --行
    params.column = 3 --列
    params.direction = kCCScrollViewDirectionHorizontal
    params.totalItem = #rewardTab
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 1
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

--[[--
    初始化
]]
function game_cosmic_main.init(self, t_params)
    t_params = t_params or {}
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {}
    else
        self.m_tGameData = {}
    end

    cosmicMgr:updateData(self.m_tGameData)
end

--[[--
    创建ui入口并初始化数据
]]
function game_cosmic_main.create(self, t_params)
    self:init(t_params)
    local scene = CCScene:create()
    scene:addChild(self:createUi())
    self:refreshUi()
    return scene
end

--[[
    创建地图
]]
function game_cosmic_main.createMap(self)
    local winSize = CCDirector:sharedDirector():getWinSize()
    local nd_map = self.m_ccbNode:nodeForName("nd_map")
    nd_map:removeAllChildrenWithCleanup(true)

    local game_cosmic_mapLayer = require("game_ui.game_cosmic_mapLayer")

    local mapLayer = game_cosmic_mapLayer:create()
    mapLayer:init(self)
    self.mapLayer = mapLayer
    self.mapLayer:setMoveEnable(true)
    nd_map:addChild(mapLayer:getLayer())
end

--[[--
    回调方法
]]
function game_cosmic_main.callBackFunc(self)
    local callBackFunc = self.callBackFunc
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc()
    end
end

function game_cosmic_main:refreshScoreList()
    local leftSelect = self.leftSelect

    local nd_scoreList = self.m_ccbNode:nodeForName("nd_scoreList")
    nd_scoreList:removeAllChildrenWithCleanup(true)
    local showData = {1, 2, 3}
    if leftSelect == 2 then
        local data = self.atkScoreData
        showData = {{tx1 = cosmicMgr.tx[25], tx2 = cosmicMgr.tx[26], isTitle = true}}
        local rank_info = data.rank_info
        for k, v in ipairs(rank_info) do
            showData[#showData + 1] = {tx1 = v.name, tx2 = v.times}
        end
        -- showData[#showData + 1] = {tx1 = cosmicMgr.tx[27], tx2 = "", isTitle = true}
        -- showData[#showData + 1] = {tx1 = data.self_win, tx2 = ""}
    end
    local list = self:createScoreList(nd_scoreList:getContentSize(), showData)
    nd_scoreList:addChild(list)

    -- btn_left_1
    local btn_left_1 = self.m_ccbNode:controlButtonForName("btn_left_1")
    game_util:setCCControlButtonBackground(btn_left_1, leftSelect == 1 and "ciyuan_059.png" or "ciyuan_058.png")
    local color = leftSelect == 1 and game_util.c3b_parse("#fcfcfc") or game_util.c3b_parse("#038dc6")
    btn_left_1:setTitleColorForState(color, CCControlStateNormal)
    btn_left_1:setTitleColorForState(color, CCControlStateHighlighted)

    -- btn_left_2
    local btn_left_2 = self.m_ccbNode:controlButtonForName("btn_left_2")
    game_util:setCCControlButtonBackground(btn_left_2, leftSelect == 2 and "ciyuan_059.png" or "ciyuan_058.png")
    color = leftSelect == 2 and game_util.c3b_parse("#fcfcfc") or game_util.c3b_parse("#038dc6")
    btn_left_2:setTitleColorForState(color, CCControlStateNormal)
    btn_left_2:setTitleColorForState(color, CCControlStateHighlighted)

    -- nd_myScore
    local nd_myScore = self.m_ccbNode:nodeForName("nd_myScore")
    nd_myScore:setVisible(leftSelect == 2)

    if leftSelect == 2 then   
        local lb_myScoreTx = self.m_ccbNode:labelTTFForName("lb_myScoreTx")
        lb_myScoreTx:setString(cosmicMgr.tx[27])
        local lb_myScore = self.m_ccbNode:labelTTFForName("lb_myScore")
        lb_myScore:setString(self.atkScoreData.self_win)
    end
end

function game_cosmic_main:createScoreList(viewSize, showData)
    local _pngName = {"ciyuan_030.png", "ciyuan_009.png", "ciyuan_008.png"}
    local params = {
        viewSize = viewSize,
        row = self.leftSelect == 1 and 3 or 6,
        column = 1,
        totalItem = #showData,
        touchPriority = GLOBAL_TOUCH_PRIORITY - 2,
        showPoint = false,
        itemActionFlag = false,
        direction = kCCScrollViewDirectionVertical, --纵向
        newCell = function(tableView, index)
            if self.leftSelect == 1 then
                local cell = tableView:dequeueCell()
                if cell == nil then
                    cell = CCTableViewCell:new()
                    cell:autorelease()
                end

                cell:removeAllChildrenWithCleanup(true)
                local camp = showData[index + 1]
                --
                local itemSize = CCSizeMake(130, 43)
                local node = CCNode:create()
                node:setContentSize(itemSize)
                node:setPosition(ccp(itemSize.width / 2, itemSize.height / 2))
                node:setAnchorPoint(ccp(0.5, 0.5))
                cell:addChild(node)

                -- 左侧头像
                local sp = CCSprite:createWithSpriteFrameName(_pngName[camp])
                sp:setPosition(ccp(40, itemSize.height / 2))
                sp:setScale(0.64)
                node:addChild(sp)

                local buildIcon = ""
                for k, v in pairs(cosmicMgr.cfg.cosmic_war_city) do
                    if v.sort == index + 1 then
                        buildIcon = v.icon
                    end
                end
                local sp = CCSprite:createWithSpriteFrameName(buildIcon .. ".png")
                sp:setScale(0.8)
                sp:setPosition(ccp(40, itemSize.height / 2))
                node:addChild(sp)
                -- 右侧文本
                local tx = CCLabelTTF:create(cosmicMgr:getScoreByCamp(camp), TYPE_FACE_TABLE.Arial_BoldMT, 16)
                tx:setPosition(ccp(100, itemSize.height / 2))
                tx:setColor(game_util.c3b_parse("#2aeaeb"))
                node:addChild(tx)
                return cell
            else
                local cell = tableView:dequeueCell()
                if cell == nil then
                    cell = CCTableViewCell:new()
                    cell:autorelease()
                end

                cell:removeAllChildrenWithCleanup(true)
                local data = showData[index + 1]
                local isTitle = data.isTitle
                --
                local itemSize = CCSizeMake(130, 15)
                local node = CCNode:create()
                node:setContentSize(itemSize)
                node:setPosition(ccp(itemSize.width / 2, itemSize.height / 2))
                node:setAnchorPoint(ccp(0.5, 0.5))
                cell:addChild(node)

                -- 左侧文本
                local tx = CCLabelTTF:create(data.tx1, TYPE_FACE_TABLE.Arial_BoldMT, 11)
                tx:setPosition(ccp(30, itemSize.height / 2))
                tx:setColor(game_util.c3b_parse(isTitle and "#038DC6" or "#2aeaeb"))
                node:addChild(tx)
                -- 右侧文本
                local tx = CCLabelTTF:create(data.tx2, TYPE_FACE_TABLE.Arial_BoldMT, 11)
                tx:setPosition(ccp(95, itemSize.height / 2))
                tx:setColor(game_util.c3b_parse(isTitle and "#038DC6" or "#2aeaeb"))
                node:addChild(tx)
                return cell
            end
        end,
        itemOnClick = function(eventType, index, item)
        end,
        pageChangedCallFunc = function(totalPage, curPage)
        end
    }
    local tempTable = TableViewHelper:create(params)
    tempTable:setScrollBarVisible(false)
    return tempTable
end

function game_cosmic_main:refreshOccupyList()
    local nd_occupyList = self.m_ccbNode:nodeForName("nd_occupyList")
    nd_occupyList:removeAllChildrenWithCleanup(true)
    local all_building = cosmicMgr:getAllBuilding()
    local showData = {}
    local _temp = {}
    local _temp1 = {}
    local myCamp = cosmicMgr:getCamp()
    for k, v in pairs(all_building) do
        if myCamp == v.camp then
            table.insert(_temp, v)
        end
    end
    table.sort(
        showData,
        function(a, b)
            return a.c_id < b.c_id
        end
    )
    for k, v in ipairs(_temp) do
        local c_id = v.c_id
        local cfg = cosmicMgr.cfg.cosmic_war_city[tonumber(c_id)]
        local icon = cfg.icon
        _temp1[icon] = (_temp1[icon] or 0) + 1
    end
    for k, v in pairs(_temp1) do
        table.insert(showData, {icon = k, num = v})
    end

    local list = self:createOccupyList(nd_occupyList:getContentSize(), showData)
    nd_occupyList:addChild(list)
end

function game_cosmic_main:createOccupyList(viewSize, showData)
    local params = {
        viewSize = viewSize,
        row = 4,
        column = 2,
        totalItem = #showData,
        touchPriority = GLOBAL_TOUCH_PRIORITY - 2,
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
            local itemSize = CCSizeMake(130, 40)
            local node = CCNode:create()
            node:setContentSize(itemSize)
            node:setPosition(ccp(itemSize.width / 2, itemSize.height / 2))
            node:setAnchorPoint(ccp(0.5, 0.5))
            cell:addChild(node)

            local icon = data.icon
            local num = data.num
            -- sp
            local sp = CCSprite:createWithSpriteFrameName(icon .. ".png")
            sp:setPosition(ccp(25, itemSize.height / 2))
            node:addChild(sp)
            -- 文本
            local tx = CCLabelTTF:create(cosmicMgr.tx[18] .. num, TYPE_FACE_TABLE.Arial_BoldMT, 10)
            tx:setPosition(ccp(90, itemSize.height / 2))
            tx:setColor(game_util.c3b_parse("#2aeaeb"))
            node:addChild(tx)

            -- local buildInfo = self:getBuildInfo(data.id)
            -- if buildInfo then
            --     local camp = buildInfo.camp
            --     if camp == 0 then
            --         sp:setColor(grayColor)
            --         tx:setColor(grayColor)
            --     else
            --         -- sp:setColor(campColor[tonumber(camp)])
            --         sp:setColor(ccc3(255, 255, 255))
            --         tx:setColor(game_util.c3b_parse("#2aeaeb"))
            --     end
            -- end

            return cell
        end,
        itemOnClick = function(eventType, index, item)
        end,
        pageChangedCallFunc = function(totalPage, curPage)
        end
    }
    local tempTable = TableViewHelper:create(params)
    tempTable:setScrollBarVisible(false)
    return tempTable
end

function game_cosmic_main:getBuildInfo(id)
    local all_building = cosmicMgr:getAllBuilding()
    local buildInfo = all_building[tostring(id)]
    return buildInfo
end

function game_cosmic_main:updateNetData(data)
    self:init(data)
    self:refreshUi()
end

function game_cosmic_main:refreshMyTeam()
    local nd_myTeam = self.nd_myTeam
    if not nd_myTeam then
        return
    end

    nd_myTeam:removeAllChildrenWithCleanup(true)

    -- 获取自己的阵容信息
    local team_info = self.m_tGameData.team_info
    if not team_info then
        return
    end

    local align_1 = team_info.align_1
    local align_2 = team_info.align_2
    local cards = team_info.attacker_info.cards

    local addHeros = function(align)
        local hasAdd = false
        for k, heroId in ipairs(align) do
            if heroId ~= "-1" then
                local cardData = cards[heroId]
                if cardData then
                    local character_detail_cfg = getConfig(game_config_field.character_detail)
                    local cardCfg = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id))
                    local icon = game_util:createCardIconByCfg(cardCfg, cardData)
                    icon:setScale(0.5)
                    if icon then
                        nd_myTeam:addChild(icon)
                        icon:setPositionX((k - 1) * 30 + 15)
                        hasAdd = true
                    end
                end
            end
        end
        return hasAdd
    end

    local hasAdd = addHeros(align_1)
    if not hasAdd then
        addHeros(align_2)
    end
end

function game_cosmic_main:checkHasCanGetBox()
    local attack_times = cosmicMgr:getAtkTimes() -- 进攻次数
    local boxDatas = cosmicMgr:getAtkBoxDatas()
    for k, v in ipairs(boxDatas) do
        local num = v.num
        local reward = v.reward or {}
        local hasGet = cosmicMgr:checkHasGetAtkReardLog(v.id)
        local canGet = not hasGet and num <= attack_times
        if canGet then
            return true
        end
    end
    return false
end

return game_cosmic_main
   }�  