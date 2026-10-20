-------------------- 潜力徽章 命运洗练
local posRes = {"mingyunxilian_010.png", "mingyunxilian_008.png", "mingyunxilian_009.png", "mingyunxilian_007.png"}

local game_badgeFate = {
    badge_refinement = getConfig(game_config_field.badge_refinement) and json.decode(getConfig(game_config_field.badge_refinement):getFormatBuffer()) or {},
    Refinement_cost = getConfig(game_config_field.Refinement_cost) and json.decode(getConfig(game_config_field.Refinement_cost):getFormatBuffer()) or {},
    m_popUi = nil,
    _listTb = false,
    lockRefineAttr = {}
}

function game_badgeFate.destroy(self)
    self.m_popUi = nil
    self._listTb = nil
    self.m_tGameData = nil
    self.badgeId = nil
    self.lockRefineAttr = {}
end

function game_badgeFate.back(self, type)
    game_scene:removePopByName("game_badgeFate")
    self:destroy()
end

function game_badgeFate.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if btnTag == 1 then
            self:back()
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode:openCCBFile("ccb/ui_badgeFate.ccbi")
    self.m_ccbNode = ccbNode

    --------- 触摸拦截
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true
        elseif eventType == "ended" then
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch, false, GLOBAL_TOUCH_PRIORITY - 5, true)
    self.m_root_layer:setTouchEnabled(true)

    -- 关闭按钮
    ccbNode:controlButtonForName("m_close_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 5)

    self.nd_list = ccbNode:nodeForName("nd_list")

    return ccbNode
end

function game_badgeFate.refreshUi(self)
    self:refreshList()
end

function game_badgeFate.refreshList(self)
    ----- 清空列表父节点
    self.nd_list:removeAllChildrenWithCleanup(true)

    local badgeData, badgeCfg = game_data:getBadgeDataById(self.badgeId)
    badgeCfg = json.decode(badgeCfg:getFormatBuffer() or "") or {}
    if not badgeData then
        return
    end

    local refine = badgeData.refine or {}
    local badge_refinement = self.badge_refinement
    local Refinement_cost = self.Refinement_cost
    local unlockNeed = Refinement_cost["1"].unlock
    local cost = Refinement_cost["1"].cost
    local cost_lock = Refinement_cost["1"].cost_lock
    -- local offset = nil
    -- ----- 获取初始偏移值
    -- if self._listTb then
    --     offset = self._listTb:getContentOffset()
    -- end
    ----- 构建列表
    local params = {
        viewSize = self.nd_list:getContentSize(),
        row = 4, -- 行
        column = 1, -- 列
        totalItem = badgeCfg.refine or 4,
        touchPriority = GLOBAL_TOUCH_PRIORITY - 5,
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

            ----- 构建节点数据
            local pos = index + 1
            local refineData = refine[tostring(pos)] -- 位置pos 洗练数据 1~4
            local r_id
            local incr_num = 0
            local cfg_badge_refinement
            local need = unlockNeed[pos]
            local isLock = refineData == nil and next(need) ~= nil
            local isRefreshLock = self.lockRefineAttr[pos] == true

            ----- 创建节点
            local ccbNode = luaCCBNode:create()
            ccbNode:openCCBFile("ccb/ui_badgeFate_item.ccbi")
            cell:addChild(ccbNode)

            if refineData then
                r_id = refineData.r_id -- 洗练配置ID
                if r_id then
                    cfg_badge_refinement = badge_refinement[tostring(r_id)] -- 洗练配置
                end
                incr_num = refineData.incr_num or 0
            end

            ---- pos图标显示
            local sp_pos = ccbNode:spriteForName("sp_pos")
            sp_pos:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(posRes[pos]))

            ---- 词条
            local nd_citiao = ccbNode:nodeForName("nd_citiao")
            nd_citiao:removeAllChildrenWithCleanup(true)
            if cfg_badge_refinement then
                local icon = cfg_badge_refinement.icon
                if icon then
                    local sp = CCSprite:create("icon/"..icon..".png")
                    nd_citiao:addChild(sp)
                end
            end
            
            ---- 词条效果
            local lb_effect = ccbNode:labelTTFForName("lb_effect")
            if cfg_badge_refinement then
                local effect = cfg_badge_refinement.effect
                local skill_sort = cfg_badge_refinement.skill_sort
                -- 提取 effect 中的第二位值
                local effectValues = {}
                for _, pair in ipairs(effect) do
                    if type(pair) == "table" and #pair >= 2 then
                        table.insert(effectValues, pair[2])
                    end
                end
                local des = cfg_badge_refinement.des
                -- 替换 des 中的 % 符号
                local str = string.gsub(des, "%%%%", "%%") -- 先处理转义的百分号
                for i, value in ipairs(effectValues) do
                    local _value = value
                    -- 根据 skill_sort 和 i 的值决定是否添加 incr_num
                    if (skill_sort == 6 and i == 2) or (skill_sort == 10 and i == 3) or (skill_sort ~= 6 and skill_sort ~= 10 and i == 1) then
                        _value = _value + incr_num
                    end
                    str = string.gsub(str, "%%s", tostring(_value), 1)
                end
                lb_effect:setString(str)
            else
                lb_effect:setString("")
            end
            ----- 锁定洗练属性
            local btn_lockRefineAttr = ccbNode:controlButtonForName("btn_lockRefineAttr")
            game_util:setCCControlButtonBackground(btn_lockRefineAttr, self.lockRefineAttr[pos] and "mingyunxilian_004.png" or "mingyunxilian_003.png")
            btn_lockRefineAttr:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 5)
            btn_lockRefineAttr:removeHandleOfControlEvent(CCControlEventTouchUpInside)
            btn_lockRefineAttr:addHandleOfControlEvent(
                function(sender, eventType)
                    self.lockRefineAttr[pos] = not self.lockRefineAttr[pos]
                    self:refreshUi()
                end,
                CCControlEventTouchUpInside
            )
            ----- 锁定
            local btn_lock = ccbNode:controlButtonForName("btn_lock")
            btn_lock:setVisible(isLock)
            btn_lock:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 5)
            btn_lock:removeHandleOfControlEvent(CCControlEventTouchUpInside)
            btn_lock:addHandleOfControlEvent(
                function()
                    if isLock then
                        local t_params = {}
                        t_params.okBtnCallBack = function()
                            self:unlockPos(pos)
                            game_scene:removePopByName("game_assistant_pop1")
                        end
                        t_params.cost1 = need[1]
                        t_params.cost2 = need[2]
                        local str = string_config:getTextByKey("badge_tx_6")
                        t_params.context = string.format(str, need[1][3], need[2][3])
                        game_scene:addPop("game_assistant_pop1", t_params)
                    end
                end,
                CCControlEventTouchUpInside
            )
            ----- 刷新按钮
            local btn_refresh = ccbNode:controlButtonForName("btn_refresh")
            btn_refresh:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 5)
            btn_refresh:removeHandleOfControlEvent(CCControlEventTouchUpInside)
            btn_refresh:addHandleOfControlEvent(
                function()
                    if not isLock then
                        if cfg_badge_refinement and cfg_badge_refinement.skill_quality == 4 then
                            local t_params = {
                                title = string_config:getTextByKey("m_title_prompt"),
                                okBtnCallBack = function(target, event)
                                    game_util:closeAlertView()

                                    self:refine(pos)
                                end, --可缺省
                                closeCallBack = function(target, event)
                                    game_util:closeAlertView()
                                end,
                                okBtnText = string_config:getTextByKey("m_btn_sure"),
                                cancelBtnText = string_config:getTextByKey("m_btn_cancel"),
                                onlyOneBtn = false,
                                text = string_config:getTextByKey("badge_tx_5")
                            }
                            game_util:openAlertView(t_params)
                        else
                            self:refine(pos)
                        end
                    end
                end,
                CCControlEventTouchUpInside
            )

            ----- 消耗节点
            -- self.lockRefineAttr[pos]
            local nd_refreshCost = ccbNode:nodeForName("nd_refreshCost")
            nd_refreshCost:setVisible(not isLock)
            if not isLock then
                local nd_cost1 = ccbNode:nodeForName("nd_cost1")
                local lb_cost1 = ccbNode:labelTTFForName("lb_cost1")
                local nd_cost2 = ccbNode:nodeForName("nd_cost2")
                local lb_cost2 = ccbNode:labelTTFForName("lb_cost2")
                nd_cost1:removeAllChildrenWithCleanup(true)
                nd_cost2:removeAllChildrenWithCleanup(true)

                if isRefreshLock then
                    local icon, name, count = game_util:getRewardByItemTable(cost_lock[1], false, true)
                    icon:setScale(12 / icon:getContentSize().width)
                    nd_cost1:addChild(icon)
                    lb_cost1:setString(count)

                    nd_cost2:setVisible(true)
                    lb_cost2:setVisible(true)

                    local icon, name, count = game_util:getRewardByItemTable(cost_lock[2], false, true)
                    icon:setScale(12 / icon:getContentSize().width)
                    nd_cost2:addChild(icon)
                    lb_cost2:setString(count)
                else
                    local icon, name, count = game_util:getRewardByItemTable(cost[1], false, true)
                    icon:setScale(12 / icon:getContentSize().width)
                    nd_cost1:addChild(icon)
                    lb_cost1:setString(count)

                    nd_cost2:setVisible(false)
                    lb_cost2:setVisible(false)
                end
            end

            return cell
        end
    }
    local tempTable = TableViewHelper:create(params)
    tempTable:setScrollBarVisible(false)
    self.nd_list:addChild(tempTable)
    self._listTb = tempTable
    -- ----- 列表偏移
    -- if offset then
    --     if offset.y < self.nd_list:getContentSize().height - tempTable:getContentSize().height then
    --         offset.y = self.nd_list:getContentSize().height - tempTable:getContentSize().height
    --     end
    --     tempTable:setContentOffset(offset)
    -- end
end

--[[--
    初始化
]]
function game_badgeFate.init(self, t_params)
    t_params = t_params or {}
    self.badgeId = t_params.badgeId
end

--[[--
    创建ui入口并初始化数据
]]
function game_badgeFate.create(self, t_params)
    self:init(t_params)
    self.m_popUi = self:createUi()
    self:refreshUi()
    return self.m_popUi
end

--[[--
    回调方法
]]
function game_badgeFate.callBackFunc(self)
    local callBackFunc = self.callBackFunc
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc()
    end
end

function game_badgeFate.unlockPos(self, pos)
    local function responseMethod(tag, gameData)
        game_util:addMoveTips({text = string_config:getTextByKey("badge_tx_3")})
        self:refreshUi()
    end
    local params = {}
    params.badge_id = self.badgeId
    params.pos = pos
    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("badge_unlock_pos"), http_request_method.GET, params, "badge_unlock_pos" .. game_data:getGlobalIdx())
end

function game_badgeFate.refine(self, pos)
    local function responseMethod(tag, gameData)
        game_util:addMoveTips({text = string_config:getTextByKey("badge_tx_4")})
        self:refreshUi()
    end
    local params = {}
    params.badge_id = self.badgeId
    params.pos = pos
    params.lock = self.lockRefineAttr[pos] and 1 or 0
    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("badge_refine"), http_request_method.GET, params, "badge_refine" .. game_data:getGlobalIdx())
end

return game_badgeFate
h4  