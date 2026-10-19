---  积分排行榜
local game_dispatch_main = {
    m_tGameData = nil,
    m_node_reward1 = nil,
    m_node_reward2 = nil,
    m_lab_combat1 = nil,
    m_lab_combat2 = nil,
    m_lab_num = nil,
    m_lab_rate = nil,
    m_lab_chanliang = nil,
    m_label_winRate = nil,
    m_label_des = nil,
    m_sp_bossRight = nil,
    m_node_tab  = nil,
    m_node_tableView = nil,
    dispatch_item_cfg = nil,
    dispatch_card_cfg = nil,
    m_select_index = nil,
    text_scroll = nil,
    content_node = nil,
    m_nandu_tab = nil,
    m_btn_autoAtk = nil, --结束战斗
    node_timeDown = nil,
};
--[[--
    销毁ui
]]
function game_dispatch_main.destroy(self)
    cclog("-----------------game_dispatch_maindestroy-----------------");
    self.m_tGameData = nil;
    self.m_node_reward1 = nil;
    self.m_node_reward2 = nil;
    self.m_lab_combat1 = nil;
    self.m_lab_combat2 = nil;
    self.m_lab_num = nil;
    self.m_lab_rate = nil;
    self.m_lab_chanliang = nil;
    self.m_label_winRate = nil;
    self.m_label_des = nil;
    self.m_sp_bossRight = nil;
    self.m_node_tab  = nil;
    self.m_node_tableView = nil;
    self.dispatch_item_cfg = nil;
    self.dispatch_card_cfg = nil;
    self.m_select_index = nil;
    self.text_scroll = nil;
    self.content_node = nil;
    self.m_nandu_tab = nil;
    self.m_btn_autoAtk = nil; --结束战斗
    self.node_timeDown = nil;

end
--[[--
    返回
]]
function game_dispatch_main.back(self,backType)
    game_data:setDispatchTab(self.m_tGameData.all_align)
    game_scene:enterGameUi("game_main_scene")
    -- local function responseMethod(tag,gameData)
    --     game_scene:enterGameUi("game_gacha_scene",{gameData = gameData});
    --     self:destroy();
    -- end
    -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("gacha_get_all_gacha"), http_request_method.GET, nil,"gacha_get_all_gacha")
end
--[[--
    读取ccbi创建ui
]]
function game_dispatch_main.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then
            self:back()
        elseif btnTag == 2 then --选择难度
            local alreadyNum = game_util:getTableLen(self.m_tGameData.dispatch_data) 
            if alreadyNum == 4 and not(self.m_tGameData.dispatch_data[tostring(self.m_select_index)]) then
                game_util:addMoveTips({text = "Tối đa được cài 4 trận hình"})
                return
            end
            if self:isFighting() then
                game_util:addMoveTips({text = "Đang đánh không thể chọn độ khó"})
                return
            end
            local function btnCallFunc( degree )
                self.m_nandu_tab[tostring(self.m_select_index)] = degree
                self:updateDegree(self.m_nandu_tab)
                self:refreshLabel()
            end 
            local curData = self.dispatch_item_cfg[tostring(self.m_select_index)]
            game_scene:addPop("game_dispatch_select_pop",{bossData = curData,btnCallFunc = btnCallFunc})
        elseif btnTag == 3 then --结束战斗
            local function responseMethod( tag,gameData )
                if gameData ~= nil and tolua.type(gameData) == "util_json" then
                    game_util:addMoveTips({text = "Kết thúc"})
                    self.m_tGameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
                    self:refreshUi()
                    self:refreshLabel()
                end
            end 
            local params = {}
            params.boss_id = self.m_select_index
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("offline_dispatch_cancel_fight"), http_request_method.GET, params,"offline_dispatch_cancel_fight")
        elseif btnTag == 4 then --开始战斗
            local function responseMethod( tag,gameData )
                if gameData ~= nil and tolua.type(gameData) == "util_json" then
                    game_util:addMoveTips({text = "Đã cử"})
                    self.m_tGameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
                    self:refreshUi()
                    self:refreshLabel()
                end
            end 
            local params = {}
            params.boss_id = self.m_select_index
            params.degree = self.m_nandu_tab[tostring(self.m_select_index)]
            if params.degree then
              local dispatch_data = self:getDispatchCard()
                if  dispatch_data[tostring(params.boss_id)] == nil then 
                     game_util:addMoveTips({text = "Chưa cử thẻ bài"})
                    return
                
             end
            else
                game_util:addMoveTips({text = "Hãy chọn độ khó"})
                return
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("offline_dispatch_fight"), http_request_method.GET, params,"offline_dispatch_fight")
        elseif btnTag == 5 then -- 仓库
            game_scene:addPop("game_dispatch_depot_pop",{gameData = self.m_tGameData})
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_dispatch_main.ccbi");
    self.text_scroll = ccbNode:scrollViewForName("m_scroll_view_Secret");
    self.m_node_reward1 = ccbNode:nodeForName("m_node_reward1");
    self.m_node_reward2 = ccbNode:nodeForName("m_node_reward2");
    self.m_lab_combat1 = ccbNode:labelTTFForName("m_lab_combat1")
    self.m_lab_combat2 = ccbNode:labelTTFForName("m_lab_combat2")
    self.m_lab_num = ccbNode:labelTTFForName("m_lab_num")
    self.m_lab_rate = ccbNode:labelTTFForName("m_lab_rate")
    self.m_lab_chanliang = ccbNode:labelTTFForName("m_lab_chanliang")
    self.m_label_winRate = ccbNode:labelTTFForName("m_label_winRate")
    self.m_sp_bossRight = ccbNode:spriteForName("m_sp_bossRight");
    self.content_node = ccbNode:nodeForName("content_node")
    self.m_label_des = ccbNode:labelTTFForName("m_label_des")
    local m_btn_cangku = ccbNode:controlButtonForName("m_btn_cangku")
    self.m_btn_autoAtk = ccbNode:controlButtonForName("m_btn_autoAtk")
    local m_node_anim = ccbNode:nodeForName("m_node_anim")
    self.node_timeDown = ccbNode:nodeForName("node_timeDown")

    local m_bg_sprite = ccbNode:spriteForName("m_bg_sprite")
    m_bg_sprite:setScale(resolution_config:getScale())
    
    m_btn_cangku:setOpacity(0)
    self.m_node_tab  = {}
    local m_node_icon = nil
    for i=1,6 do
        m_node_icon = ccbNode:nodeForName("m_node_icon" .. i)
        self.m_node_tab[i] = {m_node_icon = m_node_icon}
    end
    self.m_node_tableView = ccbNode:nodeForName("m_node_tableView");
    local dispatch_data = self:getDispatchCard()
    self:createHeroIcon(dispatch_data[tostring(self.m_select_index)])
    self:refreshLabel()
    self:refreshReward()
    local function onAnimSectionEnd( animNode, theId,theLabelName )
         animNode:playSection(theLabelName);
    end
    local anim = game_util:createBlenderAnim("yingxiongrenwu",1,true);
    anim:playSection("impact");
    anim:registerScriptTapHandler(onAnimSectionEnd)
    m_node_anim:addChild(anim)
    return ccbNode;
end
function game_dispatch_main.createTimeDown( self,parentNode,time_count_down,shwoType )
    local function timeEndFunc()
        local function responseMethod(tag,gameData)
            game_util:addMoveTips({text = "Kết thúc"})
            self.m_tGameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
            self:refreshUi()
            self:refreshLabel()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("offline_dispatch_index"), http_request_method.GET, nil,"offline_dispatch_index")
    end
    local function responseMethod(tag,gameData)
        self.m_tGameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
    end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("offline_dispatch_index"), http_request_method.GET, nil,"offline_dispatch_index")
    time_count_down = 1
    parentNode:removeAllChildrenWithCleanup(true)

    if self.m_tGameData.dispatch_data and next(self.m_tGameData.dispatch_data) and self.m_tGameData.dispatch_data[tostring(self.m_select_index)] and self.m_tGameData.dispatch_data[tostring(self.m_select_index)].status then
        time_count_down = self.m_tGameData.dispatch_data[tostring(self.m_select_index)].remain_time
        self.m_label_des:setString("CD kết thúc:")
        parentNode:setVisible(true)
    else
        self.m_label_des:setString("Chưa đánh Boss hiện tại")
        parentNode:setVisible(false)
        return
    end
    local shwoType = 3
    local countdownLabel = game_util:createCountdownLabel(time_count_down,timeEndFunc,8, shwoType);
    countdownLabel:setColor(ccc3(74, 249, 69))
    countdownLabel:setAnchorPoint(ccp(0.5,0.5))
    local tempcontent = parentNode:getContentSize()
    countdownLabel:setPosition(ccp(tempcontent.width*0.5,tempcontent.height*0.6))
    parentNode:addChild(countdownLabel,10,10) 
    -- body
end
function game_dispatch_main.createButton( self,i,parentNode)
    local function onBtnCilck( event,target )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        local alreadyNum = game_util:getTableLen(self.m_tGameData.dispatch_data) 
        if alreadyNum == 4 and not(self.m_tGameData.dispatch_data[tostring(self.m_select_index)]) then
            game_util:addMoveTips({text = "Tối đa được cài 4 trận hình"})
            return
        end
        if self:isFighting() then
            game_util:addMoveTips({text = "Đang đánh không thể cài trận hình"})
            return
        end
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();

        local btnCallFunc = function( target,event )
    
        end
        local itemOnClick = function (typeName,id,gameData)
            if typeName == "unload" then
            elseif typeName == "exchanged" then
                self:createHeroIcon(id)
                self.m_tGameData = gameData
                self:refreshLabel()
            end
        end
        local dispatch_data = self:getDispatchCard()
        game_scene:addPop("game_hero_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,openType = 9,bossId = self.m_select_index,dispatch_data = dispatch_data})
    end
    local button = game_util:createCCControlButton("public_skill.png","",onBtnCilck)
    -- button:setAnchorPoint(0.5)
    button:setScale(0.75)
    button:setZoomOnTouchDown(false)
    button:setTouchPriority(GLOBAL_TOUCH_PRIORITY)
    -- button:setPosition(ccp(20,17；));
    button:setOpacity(225)
    button:setTag(66)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/super_evolution_res.plist")
    local addImg =  CCSprite:createWithSpriteFrameName("cjh_jia.png")
    addImg:setScale(2)
    addImg:runAction(game_util:createRepeatForeverFade())
    -- addImg:setAnchorPoint(ccp(0.5,0.5))
    addImg:setPosition(ccp(27.5,27.5))
    button:addChild(addImg,11);
    parentNode:addChild(button,11);
end
--[[
    如果位置上有卡 就会创建这个按钮，去移除卡牌
]]
function game_dispatch_main.createButton2( self,i,parentNode)
    local dispatch_data = self:getDispatchCard()

    local function onBtnCilck( event,target )
        local dispatch_data = self:getDispatchCard()
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        -- cclog2(btnTag,"btnCallFunc ====")
        local alreadyNum = game_util:getTableLen(self.m_tGameData.dispatch_data) 
        if alreadyNum == 4 and not(self.m_tGameData.dispatch_data[tostring(self.m_select_index)]) then
            game_util:addMoveTips({text = "Tối đa được cài 4 trận hình"})
            return
        end
        if self:isFighting() then
            game_util:addMoveTips({text = "Đang đánh không thể cài trận hình"})
            return
        end
        local curCardIdTab = dispatch_data[tostring(self.m_select_index)]
        table.remove(curCardIdTab,btnTag-300)
        local function responseMethod(tag,gameData)
            if gameData ~= nil and tolua.type(gameData) == "util_json" then
                local tGameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
                self.m_tGameData = tGameData
                local dispatch_data = self:getDispatchCard()
                self:createHeroIcon(dispatch_data[tostring(self.m_select_index)])
                self:refreshLabel()
            end
        end
        local params = {}
        local str = ""
        params.boss_id = self.m_select_index
        if curCardIdTab and next(curCardIdTab) then
            for k,v in pairs(curCardIdTab) do
                str = str .. v .. (k == game_util:getTableLen(curCardIdTab) and "" or "_")
            end
            params.align = str
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("offline_dispatch_set_alignment"), http_request_method.GET, params,"offline_dispatch_set_alignment")
    end
    local button = game_util:createCCControlButton("dispatch_reduce.png","",onBtnCilck)
    -- button:setAnchorPoint(0.5)
    local btnSize = button:getContentSize()
    button:setScale(0.75)
    button:setZoomOnTouchDown(false)
    button:setTouchPriority(GLOBAL_TOUCH_PRIORITY-1)
    -- button:setPosition(ccp(20,17));
    button:setOpacity(255)
    button:setTag(i+300)
    parentNode:addChild(button,333);
end
function game_dispatch_main.createLogs( self )
    self.text_scroll:getContainer():removeAllChildrenWithCleanup(true);
    local viewSize = self.content_node:getContentSize()
    local contentText = ""
    local openMsg1 = self.m_tGameData.fight_log
    local fight_times = self.dispatch_item_cfg[tostring(self.m_select_index)].fight_times
    local openMsg = ""
    local openMsg_tab = {}
    local length = #openMsg1
    for k,v in pairs(openMsg1) do
        openMsg = openMsg .. v .. "\n"
    end
    contentText = openMsg

    local tempLabel = game_util:createRichLabelTTF({text = contentText,dimensions = CCSizeMake(169,0),textAlignment = kCCTextAlignmentLeft, verticalTextAlignment = kCCVerticalTextAlignmentCenter,fontSize = 9})
    local tempSize = tempLabel:getContentSize()
    self.text_scroll:setContentSize(CCSizeMake(170,tempSize.height))
    self.text_scroll:setContentOffset(ccp(0, viewSize.height - tempSize.height), false)
    self.text_scroll:setDirection(kCCScrollViewDirectionVertical)
    self.text_scroll:addChild(tempLabel)
end
--[[
    判断当前boss 是否在战斗中

]]
function game_dispatch_main.isFighting( self )
    local isFighting = false
    if self.m_tGameData.dispatch_data and next(self.m_tGameData.dispatch_data) then
        if self.m_tGameData.dispatch_data[tostring(self.m_select_index)] and self.m_tGameData.dispatch_data[tostring(self.m_select_index)].status then
            isFighting = true
        else
            isFighting = false
        end
    end
    return isFighting
end
--[[
    计算胜率
]]
function game_dispatch_main.getWinRate( self )
    local myCombat = 0
    if self.m_tGameData.dispatch_data and next(self.m_tGameData.dispatch_data) and self.m_tGameData.dispatch_data[tostring(self.m_select_index)] then
        myCombat = self.m_tGameData.dispatch_data[tostring(self.m_select_index)].combat
    end

    local degree = self.m_nandu_tab[tostring(self.m_select_index)] or 1
    local boss_combat = self.dispatch_card_cfg[tostring(degree)].boss_combat or 0
    local boss_combatAdd = self.dispatch_item_cfg[tostring(self.m_select_index)].combat_add
    boss_combat = boss_combat*(1+boss_combatAdd*0.01)

    local range = (myCombat - boss_combat) / boss_combat * 100
    local winRate = 0
    local combat_rate = self.dispatch_card_cfg[tostring(degree)].combat_rate
    for i=1,game_util:getTableLen(combat_rate) do
        if tonumber(range) > tonumber(combat_rate[i][1]) and i == game_util:getTableLen(combat_rate) then
            winRate = tonumber(combat_rate[i][2])
        elseif tonumber(range) > tonumber(combat_rate[i][1]) then
        else
            winRate = tonumber(combat_rate[i][2])
            break   
        end
    end
    return winRate
end
--[[
    刷新label
]]
function game_dispatch_main.refreshLabel( self )

    local fight_times = self.dispatch_item_cfg[tostring(self.m_select_index)].fight_times
    local des = "CD kết thúc:"
    self.m_label_des:setString(des)

    local store_current,store_max = 0,0
    store_max = self.m_tGameData.store_max
    if self.m_tGameData.store and next(self.m_tGameData.store) then
        for k,v in pairs(self.m_tGameData.store) do
            store_current = store_current + v[3]
        end
    end
    self.m_lab_num:setString(store_current .. "/" .. store_max)

    local myCombat = "0"
    if self.m_tGameData.dispatch_data and next(self.m_tGameData.dispatch_data) and self.m_tGameData.dispatch_data[tostring(self.m_select_index)] then
        myCombat = self.m_tGameData.dispatch_data[tostring(self.m_select_index)].combat
    end
    self.m_lab_combat1:setString(myCombat)

    local degree = self.m_nandu_tab[tostring(self.m_select_index)] or 1
    if degree == 0 then
        degree = 1
    end
    local rate = self.dispatch_card_cfg[tostring(degree)].drop_rate  --这个要取难度
    self.m_lab_rate:setString(tostring(rate) .. "%")

    local boss_combat = self.dispatch_card_cfg[tostring(degree)].boss_combat or 0
    local boss_combatAdd = self.dispatch_item_cfg[tostring(self.m_select_index)].combat_add
    boss_combat = boss_combat*(1+boss_combatAdd*0.01)
    self.m_lab_combat2:setString(boss_combat)

    local winRate = self:getWinRate() 
    self.m_label_winRate:setString("% win:" .. winRate .. "%")

    local fight_times = self.dispatch_item_cfg[tostring(self.m_select_index)].fight_times
    local rewardAdd = self.dispatch_card_cfg[tostring(degree)].reward
    local chanliang = ""
    chanliang = math.floor(24*60/fight_times * (rate* 0.01) * rewardAdd * (winRate * 0.01)) 
    self.m_lab_chanliang:setString(tostring(chanliang))

    local isFighting = self:isFighting()
    if isFighting then
        self.m_btn_autoAtk:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dispatch_endFight.png"),CCControlStateNormal);
        self.m_btn_autoAtk:setTag(3)
    else
        self.m_btn_autoAtk:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dispatch_start.png"),CCControlStateNormal);
        self.m_btn_autoAtk:setTag(4)
    end


    self:createTimeDown(self.node_timeDown)
end
function game_dispatch_main.createHeroIcon( self,heroIdTab)
    for i=1,6 do
        self.m_node_tab[i].m_node_icon:removeChildByTag(111,true)
        self.m_node_tab[i].m_node_icon:removeChildByTag(300+i,true)
        if heroIdTab and heroIdTab[i] then
            local itemData,itemConfig = game_data:getCardDataById(heroIdTab[i])
            if itemData then
                local heroIcon = game_util:createCardIconByCid(itemData.c_id)
                if heroIcon then
                    heroIcon:setScale(0.75)
                    self.m_node_tab[i].m_node_icon:addChild(heroIcon,111,111)
                    self:createButton2(i,self.m_node_tab[i].m_node_icon)
                end
            end
        end
    end
end
--[[
]]
function game_dispatch_main.createTableView(self,viewSize, data)
    local imgSelectTab = {}
    local function onCellBtnClick( target,event )
        local tagNode = tolua.cast(target,"CCNode");
        local btnTag = tagNode:getTag();        
    end
    local length = game_util:getTableLen(self.dispatch_item_cfg)
    local params = {};
    params.viewSize = viewSize;
    params.row = 4;
    params.column = 1; --列
    params.totalItem = length;
    params.direction = kCCScrollViewDirectionVertical;--纵向

    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local ccbNode = luaCCBNode:create();
            ccbNode:registerFunctionWithFuncName("onCellBtnClick",onCellBtnClick);
            -- ccbNode:openCCBFile("ccb/ui_arena_rank_item.ccbi");
            -- ccbNode:ignoreAnchorPointForPosition(false);
            ccbNode:setAnchorPoint(ccp(0.5,0.5))
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            ccbNode:removeAllChildrenWithCleanup(true)
            imgSelectTab[ccbNode] = nil
            local curData = self.dispatch_item_cfg[tostring(index+1)]
            local imgName = curData.img .. ".png"
            local bossImg = CCSprite:create("ccbResources/card_banner/" .. imgName)
            -- local bossImg = CCSprite:createWithSpriteFrameName(imgName .. ".png")
            ccbNode:addChild(bossImg,10,100)
            local imgSelect = CCSprite:createWithSpriteFrameName("dispatch_lightKuang.png")
            if self.m_select_index == index + 1 then
                imgSelect:setVisible(true)
            else
                imgSelect:setVisible(false)
            end
            local statusStr = "Chưa cử"
            if self.m_tGameData.dispatch_data and next(self.m_tGameData.dispatch_data) then
                if self.m_tGameData.dispatch_data[tostring(index+1)] and self.m_tGameData.dispatch_data[tostring(index+1)].status then
                    statusStr = "Đang đánh"
                else
                    statusStr = "Chưa cử"
                end
            end
            local labelStatus = CCLabelTTF:create(statusStr,TYPE_FACE_TABLE.Arial_BoldMT,12);
            labelStatus:setPosition(ccp(35,-20))
            ccbNode:addChild(imgSelect,10,101)
            ccbNode:addChild(labelStatus,10)
            imgSelectTab[ccbNode] = imgSelect
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            local ccbNode = tolua.cast(item:getChildByTag(10),"luaCCBNode")
            local imgSelect = ccbNode:getChildByTag(101)
            for k,v in pairs(imgSelectTab) do
                if k ~= ccbNode then
                    v:setVisible(false)
                end
            end
            imgSelect:setVisible(true)
            self.m_select_index = index + 1
            self:refreshRighBossImg()
            local dispatch_data = self:getDispatchCard()
            self:createHeroIcon(dispatch_data[tostring(self.m_select_index)])
            self:refreshLabel()
            self:refreshReward()
        end
    end
    return TableViewHelper:create(params);
end
--[[
    获取当前派遣出去的卡，按bossId存储
]]
function game_dispatch_main.getDispatchCard( self )
    local dispatch_data =  {}
    if self.m_tGameData.dispatch_data and next(self.m_tGameData.dispatch_data) then
        for k,v in pairs(self.m_tGameData.dispatch_data) do
            dispatch_data[tostring(k)] = v.alignment
        end
    end
    return dispatch_data
    -- body
end
--[[
    刷新右侧boss的图片
]]
function game_dispatch_main.refreshRighBossImg( self )
    self.m_sp_bossRight:removeAllChildrenWithCleanup(true)
    local curData = self.dispatch_item_cfg[tostring(self.m_select_index)]
    local imgName = curData.img .. ".png"
    local bossImg = CCSprite:create("ccbResources/card_banner/" .. imgName)
    self.m_sp_bossRight:addChild(bossImg)
    -- self.m_sp_bossRight:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(imgName .. ".png"))
end
--[[
    刷新右侧奖励掉落的内容
]]
function game_dispatch_main.refreshReward( self )
    self.m_node_reward1:removeAllChildrenWithCleanup(true)
    local reward  = self.dispatch_item_cfg[tostring(self.m_select_index)].evo_stone
    local icon,name,count = game_util:getRewardByItemTable(reward[1])
    if icon then
        icon:setScale(0.75)
        self.m_node_reward1:addChild(icon)
        local conutlab = "x" .. count
        local labelNum = CCLabelTTF:create(conutlab,TYPE_FACE_TABLE.Arial_BoldMT,10);
        labelNum:setPosition(ccp(20,-15))
        self.m_node_reward1:addChild(labelNum)
    end
    local function onBtnCilck(event,target )
        game_util:lookItemDetal(reward[1]) -- body
    end 
    local button = game_util:createCCControlButton("public_skill.png","",onBtnCilck)
    button:setScale(0.75)
    button:setZoomOnTouchDown(false)
    button:setTouchPriority(GLOBAL_TOUCH_PRIORITY)
    -- button:setPosition(ccp(20,17));
    button:setOpacity(0)
    button:setTag(666)
    self.m_node_reward1:addChild(button,11);
    -- body
end
--[[
    设置或更新boss难度数据
]]
function game_dispatch_main.updateDegree( self,degreeTab )
    if degreeTab then
        self.m_nandu_tab = degreeTab
    elseif self.m_tGameData.dispatch_data and next(self.m_tGameData.dispatch_data) then
        for k,v in pairs(self.m_tGameData.dispatch_data) do
            self.m_nandu_tab[tostring(k)] = v.degree or 1
        end
    end
   -- cclog2(self.m_nandu_tab,"self.m_nandu_tab  ")
end
--[[
    刷新
]]
function game_dispatch_main.refreshUi(self)
    for i=1,6 do
        self:createButton(i,self.m_node_tab[i].m_node_icon)
    end
    self.m_node_tableView:removeAllChildrenWithCleanup(true)
    self.m_node_tableView:addChild(self:createTableView(self.m_node_tableView:getContentSize()))
    self:createLogs()
    self:updateDegree()

end

--[[--
    初始化
]]
function game_dispatch_main.init(self,t_params)
    t_params = t_params or {};
        if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
            self.m_tGameData = json.decode(t_params.gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
        end
    self.dispatch_item_cfg = json.decode(getConfig(game_config_field.dispatch_item):getFormatBuffer()) or {}
    self.dispatch_card_cfg = json.decode(getConfig(game_config_field.dispatch_card):getFormatBuffer()) or {}
    self.m_select_index = 1
    self.m_nandu_tab = {}
    self:updateDegree()

end

--[[--
    创建ui入口并初始化数据
]]
function game_dispatch_main.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    self:refreshRighBossImg()
    return scene;
end

return game_dispatch_main;  
i