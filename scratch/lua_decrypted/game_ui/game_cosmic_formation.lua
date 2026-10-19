---  虫洞 编队
local cosmicMgr = require("game_ui.cosmicMgr")

local game_cosmic_formation = {
    m_tGameData = nil,
    m_ccbNode = nil,
    m_ccbNode2 = nil,
    m_scroll_right = nil,
    m_btn_yijian = nil,
    m_shuxing_btn = nil,
    m_medal_btn = nil,
    m_soul_btn = nil,
    m_btn_saint_stone = nil,
    m_replace_btn = nil,
    m_node_right = nil,
    m_sel_bg = nil,
    m_pos_sp = {},
    m_team_hero = {},
    m_pos = {},
    m_sel_pos = nil,
    m_formation_layer = nil,
    m_formation_layer2 = nil,
    m_data_cards = nil,
    m_team_count = nil,
    maptype = nil,
    m_lb_equip_tb = {},
    m_lb_gem_tb = {},
    m_lb_magic_tb = {},
    m_btn_equip_tb = {},
    m_btn_gem_tb = {},
    m_btn_magic_tb = {},
    m_sp_equip = {},
    m_sp_gem = {},
    m_sp_magic = {},
    m_sp_ming = {},
    -- m_equip_field = nil,
    -- m_gem_field = nil,
    -- m_talisman_field = nil,
    -- m_wormholes_formation = nil,

    m_equip_data = {}, -- hash
    m_gem_data = {}, -- hash
    m_talisman_data = {}, -- hash
    m_sp_skill = nil,
    skill_detail_cfg = nil,
    skillnode = nil,
    m_move_icon = nil,
    m_moveflag = nil,
    m_tTalismanWorm_add = {},
    m_tTalismanWorm_remove = {},
    m_tEquipWorm_add = {},
    m_tEquipWorm_remove = {}
}
--[[--
    销毁
]]
function game_cosmic_formation.destroy(self)
    -- body
    cclog("-----------------game_cosmic_formation destroy-----------------")

    self.m_tGameData = nil
    self.m_ccbNode = nil
    self.m_ccbNode2 = nil
    self.m_scroll_right = nil
    self.m_pos_sp = nil
    self.m_team_hero = nil
    self.m_pos = nil
    self.m_btn_yijian = nil
    self.m_shuxing_btn = nil
    self.m_medal_btn = nil
    self.m_soul_btn = nil
    self.m_btn_saint_stone = nil
    self.m_node_right = nil

    self.m_sel_bg = nil
    self.m_replace_btn = nil

    self.m_formation_layer = nil
    self.m_formation_layer2 = nil
    self.m_sel_pos = nil

    self.m_data_cards = nil
    self.m_team_count = nil

    self.m_lb_equip_tb = nil
    self.m_lb_gem_tb = nil
    self.m_lb_magic_tb = nil

    self.m_btn_equip_tb = nil
    self.m_btn_gem_tb = nil
    self.m_btn_magic_tb = nil

    self.m_sp_equip = nil
    self.m_sp_gem = nil
    self.m_sp_magic = nil

    self.m_sp_ming = nil
    -- self.m_equip_field = nil
    -- self.m_gem_field = nil
    -- self.m_talisman_field = nil
    -- self.m_wormholes_formation = nil
    self.m_equip_data = nil
    self.m_gem_data = nil
    self.m_talisman_data = nil
    self.m_sp_skill = nil
    self.skill_detail_cfg = nil
    self.skillnode = nil
    self.m_move_icon = nil
    self.m_moveflag = nil
    self.m_tTalismanWorm_add = nil
    self.m_tTalismanWorm_remove = nil
    self.m_tEquipWorm_add = nil
    self.m_tEquipWorm_remove = nil
end
--[[--
    返回
]]
function game_cosmic_formation.back(self, backType)
    local function responseMethod(tag, gameData)
        self:destroy()
        game_scene:enterGameUi("game_cosmic_preview", {gameData = gameData})
    end
    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_index"), http_request_method.GET, {}, "game_cosmic_formation_cosmic_war_index")
end
--[[--
    读取ccbi创建ui
]]
function game_cosmic_formation.createUi(self)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_card_quality_bg_res.plist")
    local ccbNode = luaCCBNode:create()
    local ccbNode2 = luaCCBNode:create()
    self.m_pos_sp = {}
    self.m_pos = {}
    self.m_team_hero = self.m_team_hero or {}
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if btnTag == 99999 then
            self:back("back")
        elseif btnTag == 1 then -- 进入地图
            local function responseMethod(tag, gameData)
                local data = gameData:getNodeWithKey("data")
                local _gameData = json.decode(data:getFormatBuffer()) or {}
                -- local step = _gameData.step
                -- if step == 1 then
                game_util:addMoveTips({text = cosmicMgr.tx[10]})
                -- else
                --     return
                -- end

                self:init({gameData = gameData})
                self:refreshUi(0)
            end
            network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_update_team"), http_request_method.GET, {}, "god_arena")
        elseif btnTag == 2 then -- 上阵
        elseif btnTag == 3 then -- 一键换装
        elseif btnTag == 104 or btnTag == 102 or btnTag == 103 then --
            game_util:addMoveTips({text = "功能未开启 敬请期待! "})
        elseif btnTag == 101 then --属性
            if self.m_sel_pos == nil or self.m_team_hero[self.m_sel_pos] == nil then
                game_util:addMoveTips({text = "请选择英雄! "})
            end
        elseif btnTag == 1101 or btnTag == 1102 or btnTag == 1103 or btnTag == 1104 then
            -- local btnCallFunc = function(target, event)
            -- end
            -- local itemOnClick = function(typeName, eid)
            --     local oldeid = self.m_team_hero[self.m_sel_pos].equip[btnTag % 1100]
            --     if typeName == "exchanged" then
            --         if oldeid .. "" ~= "0" then
            --             self.m_equip_data[oldeid .. ""] = 1
            --             if self.m_tEquipWorm_add[oldeid] then
            --                 self.m_tEquipWorm_add[oldeid] = nil
            --             else
            --                 self.m_tEquipWorm_remove[oldeid] = 1
            --             end
            --         end
            --         self.m_team_hero[self.m_sel_pos].equip[btnTag % 1100] = eid .. ""
            --         self.m_equip_data[eid .. ""] = nil
            --         if self.m_tEquipWorm_remove[eid] then
            --             self.m_tEquipWorm_remove[eid] = nil
            --         else
            --             self.m_tEquipWorm_add[eid] = 1
            --         end
            --     elseif typeName == "unload" then
            --         if oldeid .. "" ~= "0" then
            --             self.m_equip_data[oldeid .. ""] = 1
            --             if self.m_tEquipWorm_add[oldeid] then
            --                 self.m_tEquipWorm_add[oldeid] = nil
            --             else
            --                 self.m_tEquipWorm_remove[oldeid] = 1
            --             end
            --         end
            --         self.m_team_hero[self.m_sel_pos].equip[btnTag % 1100] = "0"
            --     end
            --     game_scene:removePopByName("game_equip_select_pop")
            --     self:refreshUi(self.m_curTab)
            -- end
            -- local cardData, heroCfg = game_data:getCardDataById(self.m_team_hero[self.m_sel_pos].id)
            -- local bind_equip = cardData.bind_equip or {}
            -- if not bind_equip[btnTag] or bind_equip[btnTag] == 0 then
            --     local alldata = self:revTable(self.m_equip_data)
            --     game_scene:addPop(
            --         "game_equip_select_pop",
            --         {btnCallFunc = btnCallFunc, itemOnClick = itemOnClick, sortBtnShow = false, selSort = btnTag % 1100, openType = 12, selHerocId = cardData.c_id, allData = alldata}
            --     )
            -- end
        elseif btnTag == 1201 or btnTag == 1202 or btnTag == 1203 or btnTag == 1204 then
            -- local btnCallFunc = function(target, event)
            -- end
            -- local itemOnClick = function(typeName, gid)
            --     local oldgid = self.m_team_hero[self.m_sel_pos].gem[btnTag % 1200]
            --     if typeName == "exchanged" then
            --         if oldgid .. "" ~= "0" then
            --             if self.m_gem_data[oldgid] then
            --                 self.m_gem_data[oldgid] = self.m_gem_data[oldgid] + 1
            --             else
            --                 self.m_gem_data[oldgid] = 1
            --             end
            --         end
            --         self.m_team_hero[self.m_sel_pos].gem[btnTag % 1200] = gid .. ""
            --         -- self.m_team_hero[self.m_sel_pos].equip[btnTag%1100] = eid..""
            --         self.m_gem_data[gid] = self.m_gem_data[gid] - 1
            --         if self.m_gem_data[gid] <= 0 then
            --             self.m_gem_data[gid] = nil
            --         end
            --     elseif typeName == "unload" then
            --         if oldgid .. "" ~= "0" then
            --             if self.m_gem_data[oldgid] then
            --                 self.m_gem_data[oldgid] = self.m_gem_data[oldgid] + 1
            --             else
            --                 self.m_gem_data[oldgid] = 1
            --             end
            --         end
            --         self.m_team_hero[self.m_sel_pos].gem[btnTag % 1200] = "0"
            --     end
            --     game_scene:removePopByName("gem_system_select_pop")
            --     self:refreshUi(self.m_curTab)
            -- end
            -- local selSort = (btnTag % 1200) < 2 and 1 or 2
            -- -- local alldata = self:revTable(self.m_gem_data)
            -- game_scene:addPop("gem_system_select_pop", {btnCallFunc = btnCallFunc, itemOnClick = itemOnClick, sortBtnShow = false, selSort = selSort, openType = 2, allData = self.m_gem_data})
        elseif btnTag == 1301 or btnTag == 1302 or btnTag == 1303 or btnTag == 1304 then
        -- local btnCallFunc = function(target, event)
        -- end
        -- local itemOnClick = function(typeName, tid)
        --     local oldtid = self.m_team_hero[self.m_sel_pos].talisman[btnTag % 1300]
        --     if typeName == "exchanged" then
        --         if oldtid .. "" ~= "0" then
        --             self.m_talisman_data[oldtid] = 1
        --             if self.m_tTalismanWorm_add[oldtid] then
        --                 self.m_tTalismanWorm_add[oldtid] = nil
        --             else
        --                 self.m_tTalismanWorm_remove[oldtid] = 1
        --             end
        --         end
        --         self.m_team_hero[self.m_sel_pos].talisman[btnTag % 1300] = tid .. ""
        --         self.m_talisman_data[tid] = nil
        --         -- self.m_tTalismanWorm_add[tid] = 1
        --         if self.m_tTalismanWorm_remove[tid] then
        --             self.m_tTalismanWorm_remove[tid] = nil
        --         else
        --             self.m_tTalismanWorm_add[tid] = 1
        --         end
        --     elseif typeName == "unload" then
        --         if oldtid .. "" ~= "0" then
        --             self.m_talisman_data[oldtid] = 1
        --             if self.m_tTalismanWorm_add[oldtid] then
        --                 self.m_tTalismanWorm_add[oldtid] = nil
        --             else
        --                 self.m_tTalismanWorm_remove[oldtid] = 1
        --             end
        --         end
        --         self.m_team_hero[self.m_sel_pos].talisman[btnTag % 1300] = "0"
        --     end
        --     game_scene:removePopByName("game_magic_select_pop")
        --     self:refreshUi(self.m_curTab)
        -- end
        -- local selSort = (btnTag % 1300) < 3 and 1 or 0
        -- local alldata = self:revTable(self.m_talisman_data)
        -- game_scene:addPop("game_magic_select_pop", {btnCallFunc = btnCallFunc, itemOnClick = itemOnClick, sortBtnShow = false, selSort = selSort, openType = 2, allData = alldata})
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode:openCCBFile("ccb/ui_game_cosmic_formation.ccbi")

    ccbNode2:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode2:openCCBFile("ccb/ui_game_cosmic_formation_right.ccbi")

    self.m_ccbNode = ccbNode
    self.m_ccbNode2 = ccbNode2

    for i = 1, 9 do
        self.m_pos_sp[i] = ccbNode:nodeForName("m_pos_" .. i)
        self.m_pos[i] = {x = self.m_pos_sp[i]:convertToWorldSpace(ccp(0, 0)).x, y = self.m_pos_sp[i]:convertToWorldSpace(ccp(0, 0)).y}
    end

    self.m_scroll_right = ccbNode:scrollViewForName("m_scroll_right")
    self.m_sel_bg = ccbNode:spriteForName("m_sel_bg")
    -- self.m_sel_bg:setVisible(false)
    self.m_replace_btn = ccbNode:controlButtonForName("m_replace_btn")
    self.m_replace_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)
    ccbNode:controlButtonForName("m_btn_go"):setOpacity(0)
    ccbNode:controlButtonForName("m_btn_go"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)
    ccbNode:controlButtonForName("m_back_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)
    self.m_formation_layer = ccbNode:layerForName("m_formation_layer")
    self.m_formation_layer2 = ccbNode:layerForName("m_formation_layer2")

    -- ccb2
    self.m_node_right = ccbNode2:nodeForName("m_node_right")
    self.m_sp_skill = ccbNode:nodeForName("m_sp_skill")
    self.m_btn_yijian = ccbNode:controlButtonForName("m_btn_yijian")
    -- self.m_sp_skill:setOpacity(0)

    -- self.skillnode = CCNode:create()
    -- self.m_sp_skill:addChild(self.skillnode)

    self.m_lb_equip_tb = {}
    self.m_lb_gem_tb = {}
    self.m_lb_magic_tb = {}

    self.m_btn_equip_tb = {}
    self.m_btn_gem_tb = {}
    self.m_btn_magic_tb = {}

    self.m_sp_equip = {}
    self.m_sp_gem = {}
    self.m_sp_magic = {}
    self.m_sp_ming = {}

    self.m_tTalismanWorm_add = self.m_tTalismanWorm_add or {}
    self.m_tTalismanWorm_remove = self.m_tTalismanWorm_remove or {}
    self.m_tEquipWorm_add = self.m_tEquipWorm_add or {}
    self.m_tEquipWorm_remove = self.m_tEquipWorm_remove or {}

    for i = 1, 4 do
        self.m_lb_equip_tb[i] = ccbNode:labelTTFForName("m_lb_equip_" .. i)
        self.m_lb_gem_tb[i] = ccbNode:labelTTFForName("m_lb_gem_" .. i)
        self.m_lb_magic_tb[i] = ccbNode:labelTTFForName("m_lb_magic_" .. i)
        self.m_btn_equip_tb[i] = ccbNode:controlButtonForName("m_btn_equip_" .. i)
        self.m_btn_gem_tb[i] = ccbNode:controlButtonForName("m_btn_gem_" .. i)
        self.m_btn_magic_tb[i] = ccbNode:controlButtonForName("m_btn_magic_" .. i)
        self.m_sp_ming[i] = ccbNode:spriteForName("m_sp_ming_" .. i)

        self.m_sp_equip[i] = ccbNode:controlButtonForName("m_equip_" .. i)
        self.m_sp_gem[i] = ccbNode:controlButtonForName("m_gem_" .. i)
        self.m_sp_magic[i] = ccbNode:controlButtonForName("m_magic_" .. i)
        self.m_btn_equip_tb[i]:setOpacity(0)
        self.m_btn_gem_tb[i]:setOpacity(0)
        self.m_btn_magic_tb[i]:setOpacity(0)
    end

    self.m_sel_bg:setPosition(self.m_pos_sp[1]:getPosition())
    self.m_sel_pos = 1

    local offsetX = nil
    local offsetY = nil
    local touchpos = {}
    local function onTouchBegan(x, y)
        offsetX = 0
        offsetY = 0
        touchpos.x = x
        touchpos.y = y
        self.m_moveflag = false
        if x > (self.m_pos[3].x + self.m_pos_sp[3]:getContentSize().width) then
            return false
        end
        for k, v in pairs(self.m_pos) do
            if x > v.x and x < v.x + 82 and y > v.y and y < v.y + 82 then
                offsetX = x - v.x
                offsetY = y - v.y
                self.m_moveflag = true
                self.m_sel_bg:setPosition(self.m_pos_sp[k]:getPosition())
                if self.m_sel_pos ~= k then
                    self.m_sel_pos = k
                    game_util:setCCControlButtonTitle(self.m_replace_btn, self.m_team_hero[self.m_sel_pos] == nil and "上阵" or "替换")
                    self:refreshUi()
                end
            end
        end
        return self.m_moveflag
    end

    local function onTouchMoved(x, y)
        -- if ccpDistance(ccp(touchpos.x, touchpos.y), ccp(x, y)) > 20 or self.m_moveflag == true then
        --     local pos = self.m_formation_layer2:convertToNodeSpace(ccp(x - offsetX, y - offsetY))
        --     if self.m_move_icon then
        --         self.m_move_icon:setPosition(pos)
        --     else
        --         if self.m_team_hero[self.m_sel_pos] then
        --             local heroData, heroCfg = game_data:getCardDataById(self.m_team_hero[self.m_sel_pos].id)
        --             self.m_move_icon = self:createCardAnimByData(heroData, heroCfg)
        --             if self.m_move_icon then
        --                 self.m_formation_layer2:addChild(self.m_move_icon)
        --                 self.m_move_icon:setPosition(pos)
        --                 self.m_move_icon:setAnchorPoint(ccp(0, 0))
        --             end
        --         end
        --     end
        -- end
    end

    local function onTouchEnded(x, y)
        self.m_moveflag = false
        -- if self.m_move_icon then
        --     self.m_move_icon:removeFromParentAndCleanup(true)
        --     self.m_move_icon = nil
        --     for k, v in pairs(self.m_pos) do
        --         if x > v.x and x < v.x + 82 and y > v.y and y < v.y + 82 then
        --             if k == self.m_sel_pos then -- 在原位置
        --             elseif self.m_team_hero[k] == nil then -- 空位置
        --                 self.m_team_hero[k] = self.m_team_hero[self.m_sel_pos]
        --                 self.m_team_hero[self.m_sel_pos] = nil
        --                 self.m_sel_bg:setPosition(self.m_pos_sp[k]:getPosition())
        --                 self.m_sel_pos = k
        --             elseif self.m_team_hero[k] ~= nil then -- 有人
        --                 local temp = self.m_team_hero[k]
        --                 self.m_team_hero[k] = self.m_team_hero[self.m_sel_pos]
        --                 self.m_team_hero[self.m_sel_pos] = temp
        --                 self.m_sel_bg:setPosition(self.m_pos_sp[k]:getPosition())
        --                 self.m_sel_pos = k
        --             end
        --         end
        --     end
        --     game_util:setCCControlButtonTitle(self.m_replace_btn, self.m_team_hero[self.m_sel_pos] == nil and "上阵" or "替换")
        --     self:refreshUi()
        -- end
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
            return onTouchMoved(x, y)
        else
            return onTouchEnded(x, y)
        end
    end
    self.m_formation_layer:registerScriptTouchHandler(onTouch, false, GLOBAL_TOUCH_PRIORITY, true)
    self.m_formation_layer:setTouchEnabled(true)
    return ccbNode
end

--[[--
    刷新ui
]]
function game_cosmic_formation.refreshUi(self)
    -- self.m_sp_skill:setOpacity(0)
    cclog("========================================  refreshUi")
    if self.m_team_hero[self.m_sel_pos] then
        game_util:setCCControlButtonTitle(self.m_replace_btn, "替换")
        if self.m_team_hero[self.m_sel_pos] and self.m_team_hero[self.m_sel_pos].bind_equip then
            self.m_btn_yijian:setVisible(num == nil)
            local num = next(self.m_team_hero[self.m_sel_pos].bind_equip)
        else
            self.m_btn_yijian:setVisible(false)
        end
    else
        game_util:setCCControlButtonTitle(self.m_replace_btn, "上阵")
        self.m_btn_yijian:setVisible(false)
    end
    self.m_btn_yijian:setVisible(false)
    self.m_replace_btn:setVisible(false)

    for k, v in pairs(self.m_pos_sp) do
        v:removeAllChildrenWithCleanup(true)
        if self.m_team_hero[k] then
            local node = CCNode:create()
            v:addChild(node)
            node:setPosition(ccp(v:getContentSize().width / 2, v:getContentSize().height / 2))
            bgSprite = CCSprite:createWithSpriteFrameName("dw_characterBg.png")
            local heroData, heroCfg = game_data:getCardDataById(self.m_team_hero[k].id)
            local icon = self:createCardAnimByData(heroData, heroCfg)
            if icon then
                node:addChild(bgSprite)
                node:addChild(icon)
                icon:setPosition(ccp(0, -33))
            end
        end
    end

    for i = 1, 4 do
        if self.m_sp_equip[i]:getChildByTag(100001) then
            self.m_sp_equip[i]:removeChildByTag(100001, true)
        end
        if self.m_sp_gem[i]:getChildByTag(100001) then
            self.m_sp_gem[i]:removeChildByTag(100001, true)
        end
        if self.m_sp_magic[i]:getChildByTag(100001) then
            self.m_sp_magic[i]:removeChildByTag(100001, true)
        end
    end
    if self.m_sp_skill then
        for i = 2000, 2020 do
            local sp = self.m_sp_skill:getChildByTag(i)
            if sp then
                sp:removeFromParentAndCleanup(true)
            end
        end
    end

    if self.m_team_hero[self.m_sel_pos] then
        local equipflag = {"0", "0", "0", "0"}
        local gemflag = {"0", "0", "0", "0"}
        local magicflag = {"0", "0", "0", "0"}

        local cardData, heroCfg = game_data:getCardDataById(self.m_team_hero[self.m_sel_pos].id)

        local skilltb = {}
        if cardData.s_1 and (cardData.s_1.avail .. "" == "2" and cardData.s_1.s .. "" ~= "0") then
            skilltb[#skilltb + 1] = {tb = cardData.s_1, id = 1}
        end
        if cardData.s_2 and (cardData.s_2.avail .. "" == "2" and cardData.s_2.s .. "" ~= "0") then
            skilltb[#skilltb + 1] = {tb = cardData.s_2, id = 2}
        end
        if cardData.s_3 and (cardData.s_3.avail .. "" == "2" and cardData.s_3.s .. "" ~= "0") then
            skilltb[#skilltb + 1] = {tb = cardData.s_3, id = 3}
        end
        if cardData.s_4 and (cardData.s_4.avail .. "" == "2" and cardData.s_4.s .. "" ~= "0") then
            skilltb[#skilltb + 1] = {tb = cardData.s_4, id = 4}
        end
        if cardData.s_5 and (cardData.s_5.avail .. "" == "2" and cardData.s_5.s .. "" ~= "0") then
            skilltb[#skilltb + 1] = {tb = cardData.s_5, id = 5}
        end

        if cardData.extra_skill and next(cardData.extra_skill) then
            if cardData.extra_skill.s_4 and (cardData.extra_skill.s_4.avail .. "" == "2" and cardData.extra_skill.s_4.s .. "" ~= "0") then
                skilltb[#skilltb + 1] = {tb = cardData.extra_skill.s_4, id = 6}
            end
            if cardData.extra_skill.s_5 and (cardData.extra_skill.s_5.avail .. "" == "2" and cardData.extra_skill.s_5.s .. "" ~= "0") then
                skilltb[#skilltb + 1] = {tb = cardData.extra_skill.s_5, id = 7}
            end
        end

        -- 装备
        -- local equipTable = game_data:getEquipIdTable()
        local equipTable = self:revTable(self.m_equip_data)
        local itemData, itemCfg = nil, nil
        for i, v in ipairs(equipTable) do
            itemData, itemCfg = game_data:getEquipDataById(tostring(v))
            if itemData then
                local equipSort = itemCfg:getNodeWithKey("sort") and itemCfg:getNodeWithKey("sort"):toInt() or 0
                local canUseFlag = true
                -- if itemData.bind_card and itemData.bind_card ~= "" then
                --     canUseFlag = false
                -- end
                if self:equipInOthers(tostring(v)) then
                    canUseFlag = false
                end
                if canUseFlag and equipflag[tonumber(equipSort)] then
                    equipflag[tonumber(equipSort)] = "1"
                end
            end
        end
        self.m_team_hero[self.m_sel_pos].bind_equip = self.m_team_hero[self.m_sel_pos].bind_equip or {}
        for i = 1, 4 do
            if self.m_team_hero[self.m_sel_pos].bind_equip[i] then
                equipflag[i] = 0
            end
        end

        -- 宝石
        -- local gemTable = game_data:getGemIdTable()
        -- local gemdata = game_data:getGemData()
        local gemdata = self.m_gem_data
        for k, v in pairs(gemdata) do
            local itemData, itemCfg = game_data:getGemDataById(k, gemdata)
            local gemSort = itemCfg:getNodeWithKey("career") and itemCfg:getNodeWithKey("career"):toInt() or 0
            local canUseFlag = true
            if self:gemInOthers(tostring(k)) then
                canUseFlag = false
            end
            if canUseFlag then
                if tonumber(gemSort) == 1 then
                    gemflag[1] = "1"
                else
                    gemflag[2] = "1"
                    gemflag[3] = "1"
                    gemflag[4] = "1"
                end
            end
        end

        -- 法宝
        -- local magicdata = game_data:getMagicData()
        local magicdata = self:revTable(self.m_talisman_data)

        for k, v in pairs(magicdata) do
            local itemdata = game_data:getMagicDataById(v)
            itemCfg = self.talismanCfg:getNodeWithKey(itemdata.c_id)
            talisman_type = itemCfg:getNodeWithKey("talisman_type") and itemCfg:getNodeWithKey("talisman_type"):toInt() or 0
            local canUseFlag = true
            if self:talismanInOthers(tostring(k)) then
                canUseFlag = false
            end
            if canUseFlag then
                if tonumber(talisman_type) == 1 then
                    magicflag[1] = "1"
                    magicflag[2] = "1"
                else
                    magicflag[3] = "1"
                    magicflag[4] = "1"
                end
            end
        end

        for i = 1, 4 do
            -- 装备
            local e_id = self.m_team_hero[self.m_sel_pos].equip[i]
            local e_id = self.m_team_hero[self.m_sel_pos].equip[i]
            if e_id .. "" == "0" then
                if equipflag[i] == "1" then
                    self.m_lb_equip_tb[i]:setVisible(true)
                    self.m_btn_equip_tb[i]:setEnabled(true)
                    self.m_sp_ming[i]:setVisible(false)
                else
                    self.m_lb_equip_tb[i]:setVisible(false)
                    self.m_btn_equip_tb[i]:setEnabled(false)
                    self.m_sp_ming[i]:setVisible(false)
                end
            else
                if self.m_team_hero[self.m_sel_pos].bind_equip[i] then
                    self.m_lb_equip_tb[i]:setVisible(false)
                    self.m_btn_equip_tb[i]:setEnabled(false)
                    self.m_sp_ming[i]:setVisible(true)
                else
                    self.m_lb_equip_tb[i]:setVisible(false)
                    self.m_btn_equip_tb[i]:setEnabled(true)
                    self.m_sp_ming[i]:setVisible(false)
                end

                local itemData_, itemCfg_ = game_data:getEquipDataById(e_id)
                if itemData_ then
                    local icon, name = game_util:createEquipIconByCid(itemData_.c_id)
                    if icon then
                        self.m_sp_equip[i]:addChild(icon)
                        icon:setAnchorPoint(ccp(0, 0))
                        icon:setTag(100001)
                    end
                end
            end

            -- 宝石
            local g_id = self.m_team_hero[self.m_sel_pos].gem[i]
            if g_id .. "" == "0" then
                if gemflag[i] == "1" then
                    self.m_lb_gem_tb[i]:setVisible(true)
                    self.m_btn_gem_tb[i]:setEnabled(true)
                else
                    self.m_lb_gem_tb[i]:setVisible(false)
                    self.m_btn_gem_tb[i]:setEnabled(false)
                end
            else
                self.m_lb_gem_tb[i]:setVisible(false)
                self.m_btn_gem_tb[i]:setEnabled(true)
                --  显示装上宝石
                local _, gemId = game_util:getRealGemLvAndCid(g_id)
                if gemId then
                    local icon, gemName = game_util:createGemIconByCid(gemId)
                    if icon then
                        self.m_sp_gem[i]:addChild(icon)
                        icon:setAnchorPoint(ccp(0.5, 0.5))
                        icon:setPosition(ccp(self.m_sp_gem[i]:getContentSize().width / 2, self.m_sp_gem[i]:getContentSize().height / 2))
                        icon:setTag(100001)
                    end
                end
            end

            -- 法宝
            local t_id = self.m_team_hero[self.m_sel_pos].talisman[i]
            if t_id .. "" == "0" then
                if gemflag[i] == "1" then
                    self.m_lb_magic_tb[i]:setVisible(true)
                    self.m_btn_magic_tb[i]:setEnabled(true)
                else
                    self.m_lb_magic_tb[i]:setVisible(false)
                    self.m_btn_magic_tb[i]:setEnabled(false)
                end
            else
                self.m_lb_magic_tb[i]:setVisible(false)
                self.m_btn_magic_tb[i]:setEnabled(true)
                --  显示装上法宝
                local magicItemData, magicItemCfg = game_data:getMagicDataById(t_id)
                if magicItemCfg then
                    local icon = game_util:createMagicIcon(magicItemCfg)
                    if icon then
                        self.m_sp_magic[i]:addChild(icon)
                        icon:setAnchorPoint(ccp(0, 0))
                        icon:setTag(100001)
                    end
                end
            end
        end
        local function onClickBtn(event, target)
            local tagNode = tolua.cast(target, "CCNode")
            local btnTag = tagNode:getTag()
            game_scene:addPop("skills_activation_pop", {skillData = skilltb[tonumber(btnTag) % 2010].tb, selHeroId = -1, posIndex = tonumber(btnTag) % 2010})
        end

        if next(skilltb) then
            for k, v in pairs(skilltb) do
                local skillJsonData = self.skill_detail_cfg:getNodeWithKey(tostring(v.tb.s))
                local skill_icon_spr = game_util:createSkillIconByCfg(skillJsonData, v.tb.avail)
                local width = skill_icon_spr:getContentSize().width / 2
                self.m_sp_skill:addChild(skill_icon_spr)
                skill_icon_spr:setAnchorPoint(ccp(0, 0))
                local skill_icon_button = game_util:createCCControlButton("public_weapon.png", "", onClickBtn)
                self.m_sp_skill:addChild(skill_icon_button)
                skill_icon_button:setTag(k)
                skill_icon_button:setOpacity(0)
                self.m_sp_skill:setScale(0.75)
                skill_icon_spr:setScale(0.8)
                -- skill_icon_button:setScale(0.8)
                skill_icon_button:setAnchorPoint(ccp(0, 0))
                local skill_label_name = game_util:createLabelTTF({text = skillJsonData:getNodeWithKey("skill_name"):toStr(), fontSize = 8})
                skill_icon_spr:addChild(skill_label_name)
                skill_label_name:setPosition(ccp(skill_icon_spr:getContentSize().width / 2, skill_icon_spr:getContentSize().height * 1.2))
                if k < 5 then
                    skill_icon_spr:setPosition(ccp((k - 1) * 55 + 5, 0))
                    skill_icon_button:setPosition(ccp((k - 1) * 55 + 5, 0))
                else
                    skill_icon_spr:setPosition(ccp((k - 5) * 55 + 5, -1 * 60))
                    skill_icon_button:setPosition(ccp((k - 5) * 55 + 5, -1 * 60))
                end
                skill_icon_spr:setTag(2000 + k)
                skill_icon_button:setTag(2010 + k)
            end
        end
    else --- 没人
        for i = 1, 4 do
            if self.m_sp_equip[i]:getChildByTag(100001) then
                self.m_sp_equip[i]:removeChildByTag(100001, true)
            end
            if self.m_sp_gem[i]:getChildByTag(100001) then
                self.m_sp_gem[i]:removeChildByTag(100001, true)
            end
            if self.m_sp_magic[i]:getChildByTag(100001) then
                self.m_sp_magic[i]:removeChildByTag(100001, true)
            end
            self.m_lb_equip_tb[i]:setVisible(false)
            self.m_btn_equip_tb[i]:setEnabled(false)
            self.m_lb_gem_tb[i]:setVisible(false)
            self.m_btn_gem_tb[i]:setEnabled(false)
            self.m_lb_magic_tb[i]:setVisible(false)
            self.m_btn_magic_tb[i]:setEnabled(false)
            self.m_sp_ming[i]:setVisible(false)
        end
    end

    local height1 = self.m_node_right:getContentSize().height
    local viewsize = self.m_scroll_right:getViewSize()
    self.m_scroll_right:setContentOffset(ccp(0, viewsize.height - height1), true)
end

--[[
    自动穿装备
]]
function game_cosmic_formation.autoMatchEquip(self)
    -- 暂时定为 让他每次点换装都不一样
    local tempequip = self.m_team_hero[self.m_sel_pos].equip
    self.m_team_hero[self.m_sel_pos].equip = {"0", "0", "0", "0"}
    local itemdata, itemCfg = nil
    local cid = {0, 0, 0, 0}
    -- cclog2(self.m_equip_data,"self.m_equip_data")
    for k, v in pairs(self.m_equip_data) do
        itemdata, itemcfg = game_data:getEquipDataById(k)
        local sort = itemcfg:getNodeWithKey("sort"):toInt()
        if cid[sort] < itemdata.c_id then
            cid[sort] = itemdata.c_id
            self.m_team_hero[self.m_sel_pos].equip[sort] = k
        end
    end
    for k, v in pairs(self.m_team_hero[self.m_sel_pos].equip) do
        if self.m_equip_data[v .. ""] then
            self.m_equip_data[v .. ""] = nil
        end
    end
    for k, v in pairs(tempequip) do
        if v ~= "0" then
            self.m_equip_data[v .. ""] = 1
        end
    end
end

function game_cosmic_formation.equipInOthers(self, item_id)
    ---todo
    return false
end

function game_cosmic_formation.gemInOthers(self, item_id)
    ---todo
    return false
end

function game_cosmic_formation.talismanInOthers(self, item_id)
    ---todo
    return false
end

function game_cosmic_formation.createCardAnimByData(self, heroData, heroCfg, animFlag)
    local animNode = nil
    local character_ID = -1
    if heroData and heroCfg then
        character_ID = heroCfg:getNodeWithKey("character_ID"):toInt()
        local ainmFile = heroCfg:getNodeWithKey("animation"):toStr()
        animFlag = animFlag == nil and true or animFlag
        if animFlag then
            animNode = game_util:createIdelAnim(ainmFile, 0, heroData, heroCfg)
        else
            animNode = game_util:createCardImgByCfg(heroCfg)
        end
        if animNode then
            local itemSize = animNode:getContentSize()
            if animFlag == false then
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_light_down.png")
                if spriteFrame then
                    local tempSprite = CCSprite:createWithSpriteFrame(spriteFrame)
                    tempSprite:setAnchorPoint(ccp(0.5, 0.1))
                    tempSprite:setPositionX(itemSize.width * 0.5)
                    animNode:addChild(tempSprite)
                end
                local spriteFrame2 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_light_up.png")
                if spriteFrame2 then
                    local tempSprite = CCSprite:createWithSpriteFrame(spriteFrame2)
                    tempSprite:setAnchorPoint(ccp(0.5, 0.1))
                    tempSprite:setPositionX(itemSize.width * 0.5)
                    animNode:addChild(tempSprite, 1000, 1000)
                end
            else
                animNode:setRhythm(1)
            end
            animNode:setAnchorPoint(ccp(0.5, 0))
            -- animNode:setScale(0.7);
            local name_after = heroData.step < 1 and "" or ("+" .. heroData.step)
            local tempLabel = CCLabelTTF:create("Lv." .. heroData.lv .. "/" .. heroData.level_max .. "\n" .. name_after, TYPE_FACE_TABLE.Arial_BoldMT, 10)
            tempLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
            tempLabel:setPosition(ccp(itemSize.width * 0.5 - 50, 97))
            tempLabel:setAnchorPoint(ccp(0, 0.5))
            animNode:addChild(tempLabel, 100, 100)
            -- local tempLabel = CCLabelTTF:create(heroCfg:getNodeWithKey("name"):toStr(),TYPE_FACE_TABLE.Arial_BoldMT,10);
            -- tempLabel:setPosition(ccp(itemSize.width*0.5 + 50,95));
            -- tempLabel:setAnchorPoint(ccp(1,0.5));
            -- animNode:addChild(tempLabel,100,100)
            -- game_util:setHeroNameColorByQuality(tempLabel,heroCfg);
            local occupation_cfg = getConfig(game_config_field.occupation)
            local occupation_item_cfg = occupation_cfg:getNodeWithKey(ainmFile)
            if occupation_item_cfg then
                local occupationType = occupation_item_cfg:toInt()
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    local occupation_icon = CCSprite:createWithSpriteFrame(spriteFrame)
                    occupation_icon:setPosition(ccp(itemSize.width * 0.5 + 57, 98))
                    occupation_icon:setAnchorPoint(ccp(1, 0.5))
                    animNode:addChild(occupation_icon)
                end
            end
            animNode:setScale(0.66)
        end
    end
    return animNode, character_ID
end

--[[--
    初始化
]]
function game_cosmic_formation.init(self, t_params)
    t_params = t_params or {}
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {}
    else
        self.m_tGameData = {}
    end

    local gameData = self.m_tGameData

    ------------------------- 转换格式
    local current = gameData.current
    local formationConfig = getConfig(game_config_field.formation);
    local itemCfg = formationConfig:getNodeWithKey(tostring(current));
    local tempTag = 1;
    local iValue = nil;
    local equip_field = {}
    local gem_field = {}
    local talisman_field = {}
    local wormholes_formation = {}

    local formationPosTab = {{key="position_a",x=0.82,y=0.83},{key="position_b",x=0.82,y=0.5},{key="position_c",x=0.82,y=0.17},{key="position_d",x=0.5,y=0.83},{key="position_e",x=0.5,y=0.5},{key="position_f",x=0.5,y=0.17}};
    if itemCfg ~= nil then
        for i=1,#formationPosTab do
            local formationPosTabItem = formationPosTab[i];
            iValue = itemCfg:getNodeWithKey(formationPosTabItem.key):toInt();
            if iValue ~= 0 and tempTag < 7 then
                equip_field[tostring(i)] = util.table_copy(gameData.equip[tostring(tempTag - 1)])
                gem_field[tostring(i)] = util.table_copy(gameData.gem[tostring(tempTag - 1)])
                talisman_field[tostring(i)] = util.table_copy(gameData.talisman[tostring(tempTag - 1)])
                tempTag = tempTag + 1;
            else
                equip_field[tostring(i)] = {"0","0","0","0"}
                gem_field[tostring(i)] = {"0","0","0","0"}
                talisman_field[tostring(i)] = {"0","0","0","0"}
            end
        end
    end
    for i=6,8 do
        equip_field[tostring(i+1)] = util.table_copy(gameData.equip[tostring(i - 1)])
        gem_field[tostring(i+1)] = util.table_copy(gameData.gem[tostring(i - 1)])
        talisman_field[tostring(i+1)] = util.table_copy(gameData.talisman[tostring(i - 1)])
    end
    -------------------------

    self.maptype = t_params.maptype

    -- local equip_field = gameData.equip or {}
    for k, v in pairs(equip_field) do
        for k1, v1 in pairs(v) do
            equip_field[k][k1] = v1 .. ""
        end
    end
    -- local gem_field = gameData.gem or {}
    -- local talisman_field = gameData.talisman or {}
    local wormholes_formation = gameData.formation or {}
    self.m_team_hero = {}
    if next(wormholes_formation) then
        for k, v in pairs(wormholes_formation) do
            if v ~= "0" and v ~= "-1" then
                local cardData, heroCfg = game_data:getCardDataById(v)
                if cardData then
                    if cardData.bind_equip == nil then
                        cardData.bind_equip = {"0", "0", "0", "0"}
                    end
                    local cid = cardData.c_id
                    local bind_equip = {"0", "0", "0", "0"}
                    for k1, v1 in pairs(bind_equip) do
                        if cardData.bind_equip[k1] then
                            bind_equip[k1] = cardData.bind_equip[k1]
                        end
                    end
                    for i = 1, 4 do
                        if bind_equip[i] then
                            if bind_equip[i] == 0 or bind_equip[i] == "0" then
                                bind_equip[i] = nil
                            else
                                equip_field[k .. ""][i] = bind_equip[i] .. ""
                            end
                        end
                    end
                    self.m_team_hero[k] = {id = v, cid = cid, equip = equip_field[k .. ""], gem = gem_field[k .. ""], talisman = talisman_field[k .. ""], bind_equip = bind_equip}
                end
            end
        end
    end

    self.charapter_cfg = getConfig(game_config_field.character_detail)
    self.equipCfg = getConfig(game_config_field.equip)
    self.gemCfg = getConfig(game_config_field.gem)
    self.talismanCfg = getConfig(game_config_field.talisman)
    self.skill_detail_cfg = getConfig(game_config_field.skill_detail)

    -- 整理数据
    self.m_equip_data = {}
    self.m_talisman_data = {}
    self.m_gem_data = {}
    -- --装备
    -- local edata = game_data:getEquipIdTable()
    -- local itemdata__, itemcfg__ = nil
    -- self.m_equip_data = {}
    -- for k, v in pairs(edata) do
        --     itemdata__, itemcfg__ = game_data:getEquipDataById(v)
        --     if itemdata__.bind_card and itemdata__.bind_card ~= "" then --去掉命运绑定装
        --     else
            --         self.m_equip_data[v .. ""] = 1
        --     end
    -- end

    -- for k, v in pairs(cannot_use_equip) do --清理掉其他战场
        --     if self.m_equip_data[v .. ""] then
            --         self.m_equip_data[v .. ""] = nil
        --     end
    -- end
    -- for k, v in pairs(self.m_team_hero) do --清理掉其他在线装备
        --     for k1, v1 in pairs(v.equip) do
            --         if v1 .. "" ~= "0" then
                --             self.m_equip_data[v1 .. ""] = nil
            --         end
        --     end
    -- end

    -- cclog2(self.m_equip_data,"self.m_equip_data2222222")
    -- --法宝
    -- local tdata = game_data:getMagicIdTable()
    -- self.m_talisman_data = {}
    -- for k, v in pairs(tdata) do
        --     self.m_talisman_data[v] = 1
    -- end
    -- for k, v in pairs(self.m_team_hero) do --清理掉其他在线装备
        --     for k1, v1 in pairs(v.talisman) do
            --         if self.m_talisman_data[v1] ~= "0" then
                --             self.m_talisman_data[v1] = nil
            --         end
    --     end
    -- end

    -- --宝石
    -- self.m_gem_data = can_use_gem
end

function game_cosmic_formation.revTable(self, tableIn)
        local tableOut = {}
    for k, v in pairs(tableIn) do
        tableOut[#tableOut + 1] = k
    end
    return tableOut
end

--[[--
    创建ui入口并初始化数据
]]
function game_cosmic_formation.create(self, t_params)
    -- body
    self:init(t_params)
    local scene = CCScene:create()
    scene:addChild(self:createUi())
    self:refreshUi()
    return scene
end

return game_cosmic_formation
 �