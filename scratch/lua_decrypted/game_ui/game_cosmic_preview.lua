-------------------- 次元战场 预览界面
local cosmicMgr = require("game_ui.cosmicMgr")

local game_cosmic_preview = {}

function game_cosmic_preview.destroy(self)
    if self.m_shared then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared)
        self.m_shared = nil
    end
end

function game_cosmic_preview.back(self, type)
    local function responseMethod(tag, gameData)
        game_scene:enterGameUi("game_godfield_mainBig", {gameData = gameData})
        self:destroy()
    end
    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("god_field_index"), http_request_method.GET, {}, "god_field_index")
end

function game_cosmic_preview.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if btnTag == 99999 then
            self:back()
        elseif btnTag == 2 then -- 奖励预览
            game_scene:addPop("game_cosmic_rankReward", {})
        elseif btnTag == 3 then -- 进入战场
            local step = cosmicMgr:getCurrentStep()
            local has_team = cosmicMgr:getHasTeam()
            if step == 1 and not has_team then
                game_util:addMoveTips({text = cosmicMgr.tx[17]})
                return
            end
            ---- 判断是否可以进入战场
            local serverTime = game_data:getVirtualServerTime() -- 当前服务器时间
            local readyTime = cosmicMgr:getStepBeginTime(3) -- 准备阶段开始时间
            if serverTime < readyTime then
                game_util:addMoveTips({text = cosmicMgr.tx[4]})
                return
            end

            ---- 判断玩家是否报名,未报名不可进入战场
            local camp = cosmicMgr:getCamp()
            if camp == 0 then
                game_util:addMoveTips({text = cosmicMgr.tx[1]})
                return
            end

            ---- 进入战场
            local function responseMethod(tag, gameData)
                game_scene:enterGameUi("game_cosmic_main", {gameData = gameData})
            end
            network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_index"), http_request_method.GET, {}, "game_cosmic_preview_cosmic_war_index_1")
        elseif btnTag == 4 then -- 报名
            local step = cosmicMgr:getCurrentStep() -- 当前阶段
            if step ~= 1 then
                game_util:addMoveTips({text = self.tx[11]})
                return
            end
            local isSign = cosmicMgr:isSign()
            if isSign then
                game_util:addMoveTips({text = self.tx[12]})
                return
            end
            local function responseMethod(tag, gameData)
                game_util:addMoveTips({text = self.tx[13]})
                self:init({gameData = gameData})
                self:refreshUi()
            end
            network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_sign"), http_request_method.GET, {}, "cosmic_war_sign")
        elseif btnTag == 5 then
            game_scene:addPop("game_cosmic_detail", {tx = cosmicMgr.cfg.cosmic_war_txt[4].txt})
        elseif btnTag == 501 then -- 阵型
            local function responseMethod(tag, gameData)
                game_scene:enterGameUi("game_cosmic_formation", {gameData = gameData})
            end
            network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_formation"), http_request_method.GET, {}, "cosmic_war_formation")
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode:openCCBFile("ccb/ui_cosmic_preview.ccbi")

    self.m_ccbNode = ccbNode

    self.tx = {
        [1] = "战场已经开放",
        [2] = "距离战场开放还有:",
        [3] = "测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试",
        [4] = "当前阶段无法进入战场",
        [5] = "报名阶段倒计时:",
        [6] = "分组阶段倒计时:",
        [7] = "战斗准备阶段倒计时:",
        [8] = "战斗阶段倒计时:",
        [9] = "战斗结束阶段倒计时:",
        [10] = "活动已结束:",
        [11] = "Hiện không phải giai đoạn Đăng Ký!",
        [12] = "Bạn đã Đăng ký!",
        [13] = "Đăng Ký thành công!",
        [14] = "Trạng thái Đăng Ký: Chưa đăng ký",
        [15] = "Trạng thái Đăng Ký: Đã đăng ký"
    }

    self:onCreate()
    return ccbNode
end
--

function game_cosmic_preview.refreshUi(self, scrollToSelect)
    local step = cosmicMgr:getCurrentStep() -- 当前阶段
    local is_sign = cosmicMgr:isSign() -- 是否报名
    local serverTime = game_data:getVirtualServerTime() -- 当前服务器时间
    local s = CCDirector:sharedDirector():getScheduler()
    local timeScale = 1
    if s then
        timeScale = s:getTimeScale()
    end
    -- 倒计时
    if self.m_shared == nil then
        function tick()
            local step = cosmicMgr:getCurrentStep() -- 当前阶段
            local serverTime = game_data:getVirtualServerTime() -- 当前服务器时间
            if step == 0 then
                self.lb_endTime:setString(cosmicMgr.tx[5])
            elseif step == 1 then -- 报名阶段
                local time = cosmicMgr:getStepBeginTime(2)
                time = time - serverTime
                time = math.max(time, 0)
                local hours = math.floor(time / 3600)
                local minutes = math.floor((time - hours * 3600) / 60)
                local seconds = math.floor(time - hours * 3600 - minutes * 60)
                hours = hours < 10 and "0" .. hours or "" .. hours
                minutes = minutes < 10 and "0" .. minutes or "" .. minutes
                seconds = seconds < 10 and "0" .. seconds or "" .. seconds
                self.lb_endTime:setString(cosmicMgr.tx[11] .. hours .. ":" .. minutes .. ":" .. seconds)

                if time == 0 then
                    self:updateNetData()
                end
            elseif step == 2 then -- 分组阶段
                local time = cosmicMgr:getStepBeginTime(3)
                time = time - serverTime
                time = math.max(time, 0)
                local hours = math.floor(time / 3600)
                local minutes = math.floor((time - hours * 3600) / 60)
                local seconds = math.floor(time - hours * 3600 - minutes * 60)
                hours = hours < 10 and "0" .. hours or "" .. hours
                minutes = minutes < 10 and "0" .. minutes or "" .. minutes
                seconds = seconds < 10 and "0" .. seconds or "" .. seconds
                self.lb_endTime:setString(cosmicMgr.tx[2] .. hours .. ":" .. minutes .. ":" .. seconds)
            elseif step == 3 or step == 4 then -- 战斗准备阶段 战斗阶段
                self.lb_endTime:setString(cosmicMgr.tx[3])
                if time == 0 then
                    self:updateNetData()
                end
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
                if time == 0 then
                    self:updateNetData()
                end
            else
                self.lb_endTime:setString(cosmicMgr.tx[5])
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared)
                self.m_shared = nil
            end
        end
        self.m_shared = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 1 * timeScale, false)
        tick()
    end

    -- local lb_endTime2 = self.m_ccbNode:labelTTFForName("lb_endTime2")
    -- lb_endTime2:setString("")
    -- lb_endTime2:removeAllChildrenWithCleanup(true)
    -- local fightTime = cosmicMgr:getStepBeginTime(3)
    -- local remainTime = fightTime - serverTime
    -- if remainTime > 0 then
    --     local function timeEndFunc()
    --         lb_endTime2:removeAllChildrenWithCleanup(true)
    --         self:updateNetData()
    --     end
    --     local countdownLabel = game_util:createCountdownLabel(remainTime, timeEndFunc, 8)
    --     countdownLabel:setPosition(ccp(countdownLabel:getContentSize().width * 0.5, 0))
    --     lb_endTime2:addChild(countdownLabel)
    -- end
    -- 报名按钮
    local btn_sign = self.m_ccbNode:controlButtonForName("btn_sign")
    btn_sign:setVisible(not is_sign and step == 1)
    -- btn_enter
    local btn_enter = self.m_ccbNode:controlButtonForName("btn_enter")
    btn_enter:setVisible(not btn_sign:isVisible())
    -- 报名状态文本
    local lb_signStatus = self.m_ccbNode:labelTTFForName("lb_signStatus")
    lb_signStatus:setString(is_sign and self.tx[15] or self.tx[14])
    -- 阵型按钮
    local m_btn_zhenxing = self.m_ccbNode:controlButtonForName("m_btn_zhenxing")
    m_btn_zhenxing:setVisible(step == 1) -- 报名阶段才显示
    -- 阶段计时器
    self.nd_schedule:stopAllActions()
    local next_ts = cosmicMgr:getNextTs()
    local remainTime = next_ts - serverTime
    if remainTime > 0 then
        local arr = CCArray:create()
        arr:addObject(CCDelayTime:create(remainTime + 0.5))
        arr:addObject(
            CCCallFuncN:create(
                function()
                    self:updateNetData()
                end
            )
        )
        self.nd_schedule:runAction(CCSequence:create(arr))
    end

    -- 当前主城
    local nd_campBuild = self.m_ccbNode:nodeForName("nd_campBuild")
    nd_campBuild:removeAllChildrenWithCleanup(true)
    local camp = cosmicMgr:getCamp()
    if camp ~= 0 then
        local cfg = nil
        for k, v in pairs(cosmicMgr.cfg.cosmic_war_city) do
            local sort = v.sort
            local icon = v.icon
            if sort == camp then
                local pngs = {
                    "ciyuan_030.png",
                    "ciyuan_009.png",
                    "ciyuan_008.png"
                }
                local png = pngs[camp]
                local sp = CCSprite:createWithSpriteFrameName(png)
                sp:setScale(1.8)
                nd_campBuild:addChild(sp)

                local sp = CCSprite:createWithSpriteFrameName(icon .. ".png")
                sp:setScale(1.8)
                nd_campBuild:addChild(sp)
            end
        end
    end
end

--[[--
    初始化
]]
function game_cosmic_preview.init(self, t_params)
    local m_tGameData
    t_params = t_params or {}
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        m_tGameData = json.decode(data:getFormatBuffer()) or {}
    end

    cosmicMgr:updateData(m_tGameData)
end

--[[--
    创建ui入口并初始化数据
]]
function game_cosmic_preview.create(self, t_params)
    self:init(t_params)
    local scene = CCScene:create()
    scene:addChild(self:createUi())
    self:refreshUi()
    return scene
end

--[[--
    回调方法
]]
function game_cosmic_preview.callBackFunc(self)
    local callBackFunc = self.callBackFunc
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc()
    end
end

function game_cosmic_preview:updateNetData()
    local function responseMethod(tag, gameData)
        self:init({gameData = gameData})
        self:refreshUi()
    end
    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_index"), http_request_method.GET, {}, "game_cosmic_preview_cosmic_war_index_2")
end

function game_cosmic_preview:onCreate()
    self.lb_endTime = self.m_ccbNode:labelTTFForName("lb_endTime")
    self.lb_endTime:setString("")
    self.nd_schedule = self.m_ccbNode:nodeForName("nd_schedule")

    -- 基础规则
    local text_scroll = self.m_ccbNode:scrollViewForName("text_scroll")
    local contentText = cosmicMgr.cfg.cosmic_war_txt[1].txt
    local tempLabel =
        game_util:createRichLabelTTF(
        {
            text = contentText,
            dimensions = CCSizeMake(200, 0),
            textAlignment = kCCTextAlignmentLeft,
            verticalTextAlignment = kCCVerticalTextAlignmentCenter,
            color = ccc3(36, 236, 239),
            fontSize = 12
        }
    )
    local tempSize = tempLabel:getContentSize()
    text_scroll:setContentSize(CCSizeMake(430, tempSize.height))
    text_scroll:setContentOffset(ccp(0, 146 - tempSize.height), false)
    text_scroll:addChild(tempLabel)
end

return game_cosmic_preview
  *3