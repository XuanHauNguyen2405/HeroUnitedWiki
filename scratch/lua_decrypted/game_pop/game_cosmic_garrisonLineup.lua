-------------------- 次元战场 驻守界面

local game_cosmic_garrisonLineup = {
    m_tGameData = nil
}

local cosmicMgr = require("game_ui.cosmicMgr")

function game_cosmic_garrisonLineup.destroy(self)
    self.m_tGameData = nil
    self._list = nil
end

function game_cosmic_garrisonLineup.back(self, type)
    game_scene:removePopByName("game_cosmic_garrisonLineup")
    self:destroy()
end

function game_cosmic_garrisonLineup.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if btnTag == 99999 then
            self:back()
        elseif btnTag == 2 then -- 移动到该城池
            -- 检查移动cd
            local moveRemainCd = cosmicMgr:getMoveRemainCd()
            if moveRemainCd > 0 then
                game_util:addMoveTips({text = cosmicMgr.tx[6]})
                return
            end

            local buildId = self.building_info.id

            local function responseMethod(tag, gameData)
                local data = gameData:getNodeWithKey("data")
                gameData = json.decode(data:getFormatBuffer()) or {}
                self.moveCb(gameData)
                self:back()
                -- game_scene:addPop("game_cosmic_garrisonLineup", {gameData = gameData})
            end
            network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_station"), http_request_method.GET, {build_id = buildId}, "cosmic_war_station")
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode:openCCBFile("ccb/ui_cosmic_garrisonLineup.ccbi")

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
    ccbNode:controlButtonForName("btn_move"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 11)

    self.nd_list = ccbNode:nodeForName("nd_list")

    return ccbNode
end
--

function game_cosmic_garrisonLineup.refreshUi(self, scrollToSelect)
    self:refreshList()

    local buildCamp = self.building_info.camp
    local buildId = tonumber(self.building_info.id)
    local myCamp = cosmicMgr:getCamp()
    local myPos = cosmicMgr:getPos()

    -- 刷新移动按钮
    local btn_move = self.m_ccbNode:controlButtonForName("btn_move")
    btn_move:setVisible((buildCamp == 0 or buildCamp == myCamp or #self.members == 0) and tostring(myPos) ~= tostring(buildId))
end

--[[--
    初始化
]]
function game_cosmic_garrisonLineup.init(self, t_params)
    t_params = t_params or {}
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {}
    else
        self.m_tGameData = {}
    end

    self.building_info = self.m_tGameData.building_info -- 城信息
    self.members = self.m_tGameData.members or {} -- 驻扎成员信息
    self.moveCb = t_params.moveCb
end

--[[--
    创建ui入口并初始化数据
]]
function game_cosmic_garrisonLineup.create(self, t_params)
    self:init(t_params)
    local scene = CCScene:create()
    scene:addChild(self:createUi())
    self:refreshUi()
    return scene
end

--[[--
    回调方法
]]
function game_cosmic_garrisonLineup.callBackFunc(self)
    local callBackFunc = self.callBackFunc
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc()
    end
end

function game_cosmic_garrisonLineup.refreshList(self)
    local nd_list = self.m_ccbNode:nodeForName("nd_list")
    nd_list:removeAllChildrenWithCleanup(true)
    local showData = self.members
    self._list = self:createList(nd_list:getContentSize(), showData)
    nd_list:addChild(self._list)
end

function game_cosmic_garrisonLineup.createList(self, viewSize, showData)
    local character_detail_cfg = getConfig(game_config_field.character_detail)
    local params = {
        viewSize = viewSize,
        row = 3,
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
            local function onMainBtnClick(target, event)
                local tagNode = tolua.cast(target, "CCNode")
                local btnTag = tagNode:getTag()
                if btnTag == 2 then -- 挑战
                -- local function responseMethod(tag,gameData)
                --     game_data:setBattleType("cosmic_fight");
                --     game_scene:enterGameUi("game_battle_scene",{gameData = gameData});
                --     self:destroy();
                -- end
                -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cosmic_war_battle"), http_request_method.GET, {},"cosmic_war_battle");
                end
            end
            ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
            ccbNode:openCCBFile("ccb/ui_cosmic_garrisonLineupItem.ccbi")
            cell:addChild(ccbNode)

            -- lb_name
            local lb_name = ccbNode:labelTTFForName("lb_name")
            lb_name:setString(data.name)
            -- btn_attack
            local btn_attack = ccbNode:controlButtonForName("btn_attack")

            local buildCamp = self.building_info.camp
            local myCamp = cosmicMgr:getCamp()
            btn_attack:setVisible(buildCamp ~= myCamp)
            btn_attack:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 12)
            btn_attack:addHandleOfControlEvent(
                function()
                    local function responseMethod(tag, gameData)
                        game_data:setBattleType("cosmic_fight")
                        game_scene:enterGameUi("game_battle_scene", {gameData = gameData})
                        self:destroy()
                    end
                    network.sendHttpRequest(
                        responseMethod,
                        game_url.getUrlForKey("cosmic_war_battle"),
                        http_request_method.GET,
                        {
                            t_uid = data.uid,
                            build_id = self.building_info.id
                        },
                        "cosmic_war_battle"
                    )
                end,
                CCControlEventTouchUpInside
            )

            -- 刷新英雄icon
            local nd_heros = ccbNode:nodeForName("nd_heros")
            nd_heros:removeAllChildrenWithCleanup(true)
            local align_1 = data.team_info.align_1
            local align_2 = data.team_info.align_2
            local cards = data.team_info.attacker_info.cards

            local addHeros = function(align)
                local hasAdd = false
                for k, heroId in ipairs(align) do
                    if heroId ~= "-1" then
                        local cardData = cards[heroId]
                        if cardData then
                            local cardCfg = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id))
                            local icon = game_util:createCardIconByCfg(cardCfg, cardData)
                            icon:setScale(0.5)
                            if icon then
                                nd_heros:addChild(icon)
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

            return cell
        end,
        itemOnClick = function(eventType, index, item)
            if eventType == "ended" and item then
                self.leftSelect = index
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

function game_cosmic_garrisonLineup.createRewardTabelView(self, viewSize, rewardTab)
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

return game_cosmic_garrisonLineup
   �)