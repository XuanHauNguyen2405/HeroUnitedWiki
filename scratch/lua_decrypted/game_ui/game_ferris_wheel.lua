---  幸运转盘
local game_lucky_turntable = {
    m_root_layer = nil,
    m_popUi = nil,
    m_close_btn = nil,
    m_list_view_bg = nil,
    m_tGameData = nil,
    m_idTab = nil,

    rank_node = nil,
    left_time_node = nil,
    btn_gacha = nil,
    btn_gache_hh10 = nil,
    btn_gacha_10 = nil,
    m_surplus_count_label_1 = nil,
    lb_hh10 = nil,
    m_surplus_count_label_2 = nil,
    m_daily_online_lable = nil,
    m_recharge_label = nil,
    m_lottery_count_label = nil,
    btn_recharge = nil,
    btn_detail = nil,
    anim_node = nil,

    m_gachaAnimEndFlag = nil,
    m_delayTimeIndex = nil,
    m_mask_layer = nil,
    m_maxQuality = nil,
    m_maxQualityCardId = nil,
    m_refresh_count_label = nil,
    m_ccbNode = nil,
    m_startFlag = nil,
    m_luckyTurntableRewardTab = nil,
    m_rotation_spri = nil,
    m_rewardTurntableType = nil,
    m_tips_label = nil,
    m_screenShoot = nil,
    m_cost_coin_lable = nil,
    m_posIndex = nil,
    m_posIndex2 = nil,
    m_recharge_node = nil,
    m_cost_node = nil,
    m_recharge_icon = nil,
    m_refresh_node = nil,
};
--[[--
    销毁ui
]]
function game_lucky_turntable.destroy(self)
    -- body
    cclog("----------------- game_lucky_turntable destroy-----------------"); 
    self.m_root_layer = nil;
    self.m_popUi = nil;
    self.m_close_btn = nil;
    self.m_list_view_bg = nil;
    self.m_tGameData = nil;
    self.m_idTab = nil;

    self.rank_node = nil;
    self.left_time_node = nil;
    self.btn_gacha = nil;
    self.btn_gache_hh10 = nil;
    self.btn_gacha_10 = nil;
    self.m_surplus_count_label_1 = nil;
    self.lb_hh10 = nil;
    self.m_surplus_count_label_2 = nil;
    self.m_daily_online_lable = nil;
    self.m_recharge_label = nil;
    self.m_lottery_count_label = nil;
    self.btn_recharge = nil;
    self.btn_detail = nil;
    self.anim_node = nil;

    self.m_gachaAnimEndFlag = nil;
    self.m_delayTimeIndex = nil;
    self.m_mask_layer = nil;
    self.m_maxQuality = nil;
    self.m_maxQualityCardId = nil;
    self.m_refresh_count_label = nil;
    self.m_ccbNode = nil;
    self.m_startFlag = nil;
    self.m_luckyTurntableRewardTab = nil;
    self.m_rotation_spri = nil;
    self.m_rotation_spri_2 = nil;
    self.m_rewardTurntableType = nil;
    self.m_tips_label = nil;
    self.m_screenShoot = nil;
    self.m_cost_coin_lable = nil;
    self.m_posIndex = nil;
    self.m_posIndex2 = nil;
    self.m_recharge_node = nil;
    self.m_cost_node = nil;
    self.m_recharge_icon = nil;
    self.m_refresh_node = nil;
end

--[[--
    返回
]]
function game_lucky_turntable.back(self,backType)
    game_scene:enterGameUi("game_main_scene",{gameData = nil});
end
--[[--
    读取ccbi创建ui
]]
function game_lucky_turntable.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then -- 关闭
            self:back()
        elseif btnTag == 11 then--充值
            local function responseMethod(tag,gameData)
                game_scene:enterGameUi("ui_vip",{gameData = gameData});
                self:destroy();
                --game_scene:addPop("ui_vip_show_pop");
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("vip_buy_step"), http_request_method.GET, nil,"vip_buy_step")
        elseif btnTag == 12 then--查看详情
            local wheel_cfg = getConfig(game_config_field.wheel)
            local wheel_cfg_item = wheel_cfg:getNodeWithKey(tostring(self.m_tGameData.version))
            local active_msg = "Hoạt động hấp dẫn phải năng nổ tham gia nhé!"
            if wheel_cfg_item then
                active_msg = wheel_cfg_item:getNodeWithKey("notice")
                active_msg = active_msg and active_msg:toStr() or ""
            end
            game_scene:addPop("game_active_limit_detail_pop",{openMsg = active_msg})
        elseif btnTag == 101 then--豪华转轮
            function responseMethod(tag,gameData)
                self.m_gachaAnimEndFlag = false;
                local pX,pY = tagNode:getPosition();
                local tempPos = tagNode:getParent():convertToWorldSpace(ccp(pX,pY))
                self.m_animStartPos = {x = tempPos.x,y = tempPos.y}
                local rewardRandom = ((self.m_tGameData.reward_index or 0) + 1)
                local rewardTab = self.m_tGameData.reward or {}
                if rewardTab[rewardRandom] then
                    self.m_rewardTurntableType = rewardTab[rewardRandom][1];
                end
                self.m_mask_layer:setTouchEnabled(true);
                local data = gameData:getNodeWithKey("data")
                self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
                local type = self.m_tGameData.type or 1
                if type == 1 then
                    self:createRotationAnim(1,self.m_rotation_spri,self.m_posIndex,10);
                else
                    self:createRotationAnim(2,self.m_rotation_spri_2,self.m_posIndex2,6);
                end
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("diamond_wheel_open_diamond_wheel"), http_request_method.GET, {type = 1},"diamond_wheel_open_diamond_wheel")
        elseif btnTag == 102 then--至尊转轮
            function responseMethod(tag,gameData)
                self.m_gachaAnimEndFlag = false;
                local pX,pY = tagNode:getPosition();
                local tempPos = tagNode:getParent():convertToWorldSpace(ccp(pX,pY))
                self.m_animStartPos = {x = tempPos.x,y = tempPos.y}
                local rewardRandom = ((self.m_tGameData.reward_index or 0) + 1)
                local rewardTab = self.m_tGameData.reward or {}
                if rewardTab[rewardRandom] then
                    self.m_rewardTurntableType = rewardTab[rewardRandom][1];
                end
                self.m_mask_layer:setTouchEnabled(true);
                local data = gameData:getNodeWithKey("data")
                self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
                self:createRotationAnim(2,self.m_rotation_spri_2,self.m_posIndex2,6);
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("diamond_wheel_open_diamond_wheel"), http_request_method.GET, {type = 2},"diamond_wheel_open_diamond_wheel")
        elseif btnTag == 103 then--查看其他奖励

        elseif btnTag == 104 then--刷新
            function responseMethod(tag,gameData)
                local data = gameData:getNodeWithKey("data")
                self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
                self:refreshUi()
                game_util:addMoveTips({text = string_config:getTextByKey("game_lucky_turntable_003")})
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("diamond_wheel_refresh_diamond_wheel_reward"), http_request_method.GET, {},"diamond_wheel_refresh_diamond_wheel_reward")
        elseif btnTag == 105 then -- 豪华转轮 10连
            function responseMethod(tag,gameData)
                self.m_gachaAnimEndFlag = false;
                local pX,pY = tagNode:getPosition();
                local tempPos = tagNode:getParent():convertToWorldSpace(ccp(pX,pY))
                self.m_animStartPos = {x = tempPos.x,y = tempPos.y}
                local rewardRandom = ((self.m_tGameData.reward_index or 0) + 1)
                local rewardTab = self.m_tGameData.gifts or {}
                if rewardTab[rewardRandom] then
                    self.m_rewardTurntableType = rewardTab[rewardRandom][1];
                end
                self.m_mask_layer:setTouchEnabled(true);
                local data = gameData:getNodeWithKey("data")
                self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
                local type = self.m_tGameData.type or 1
                if type == 1 then
                    self:createRotationAnim(1,self.m_rotation_spri,self.m_posIndex,10);
                else
                    self:createRotationAnim(2,self.m_rotation_spri_2,self.m_posIndex2,6);
                end
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("diamond_wheel_open_diamond_wheel10"), http_request_method.GET, {type = 1},"diamond_wheel_open_diamond_wheel10")
        end
    end
    
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onBtnClick);
    ccbNode:openCCBFile("ccb/ui_ferris_wheel.ccbi");
    -- 光效 显示
    -- local falsh_blindness = ccbNode:spriteForName("falsh_blindness")
    -- falsh_blindness:runAction(game_util:createRepeatForeverFade());

    self.rank_node = ccbNode:nodeForName("rank_node");
    self.btn_gacha = ccbNode:controlButtonForName("btn_gacha");
    self.btn_gache_hh10 = ccbNode:controlButtonForName("btn_gache_hh10");
    self.btn_gacha_10 = ccbNode:controlButtonForName("btn_gacha_10");
    self.m_surplus_count_label_1 = ccbNode:labelTTFForName("m_surplus_count_label_1");--
    self.lb_hh10 = ccbNode:labelTTFForName("lb_hh10");
    self.m_surplus_count_label_2 = ccbNode:labelTTFForName("m_surplus_count_label_2");--
    self.m_daily_online_lable = ccbNode:labelTTFForName("m_daily_online_lable");--
    self.m_recharge_label = ccbNode:labelTTFForName("m_recharge_label");--当前积分排名
    self.m_lottery_count_label = ccbNode:labelTTFForName("m_lottery_count_label");--剩余钻石
    self.btn_recharge = ccbNode:controlButtonForName("btn_recharge");
    self.btn_detail = ccbNode:controlButtonForName("btn_detail");   
    self.anim_node = ccbNode:nodeForName("anim_node");
    self.left_time_node = ccbNode:nodeForName("left_time_node");
    self.m_refresh_count_label = ccbNode:labelTTFForName("m_refresh_count_label");
    self.m_tips_label = ccbNode:labelTTFForName("m_tips_label");
    self.m_cost_coin_lable = ccbNode:labelTTFForName("m_cost_coin_lable");

    self.m_recharge_node = ccbNode:nodeForName("m_recharge_node");
    self.m_refresh_node = ccbNode:nodeForName("m_refresh_node");
    self.m_cost_node = ccbNode:nodeForName("m_cost_node");
    self.m_recharge_icon = ccbNode:spriteForName("m_recharge_icon");
    self.m_mask_layer = ccbNode:layerColorForName("m_mask_layer");
    self.m_mask_layer:setOpacity(0);
    self.m_mask_layer:setVisible(true);
    self.m_anim_node = ccbNode:nodeForName("m_anim_node")
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    self.m_rotation_spri = ccbNode:spriteForName("m_rotation_spri")
    self.m_rotation_spri:setRotation(0);
    self.m_rotation_spri_2 = ccbNode:spriteForName("m_rotation_spri_2")
    self.m_rotation_spri_2:setRotation(0);
    self.m_posIndex = 1;
    self.m_posIndex2 = 1;
    -- -- 本层阻止触摸传导下一层
    -- local function onTouch(eventType, x, y)     
    --     if eventType == "began" then 
    --         return true;  
    --     end 
    -- end
    -- self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY,true);
    -- self.m_root_layer:setTouchEnabled(true);
    self:initLayerTouch(self.m_root_layer);
    -- 本层阻止触摸传导下一层
    local function onTouch2(eventType, x, y)     
        if eventType == "began" then 
            cclog("self.m_gachaAnimEndFlag === " .. tostring(self.m_gachaAnimEndFlag))
            if self.m_gachaAnimEndFlag == true then
                self.m_anim_node:removeAllChildrenWithCleanup(true);
                self.m_mask_layer:removeAllChildrenWithCleanup(true);
                self.m_mask_layer:setTouchEnabled(false);
                self.m_mask_layer:setOpacity(0);
                self:refreshUi()
            end
            return true;  
        end 
    end
    self.m_mask_layer:registerScriptTouchHandler(onTouch2,false,GLOBAL_TOUCH_PRIORITY-2,true);
    self.m_mask_layer:setTouchEnabled(false);

    self.m_close_btn = ccbNode:controlButtonForName("m_close_btn");
    self.m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.btn_gacha:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.btn_gache_hh10:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.btn_gacha_10:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);

    self.btn_recharge:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.btn_detail:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    local m_refresh_count_btn = ccbNode:controlButtonForName("m_refresh_count_btn");
    m_refresh_count_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    self.m_ccbNode = ccbNode;
    local m_root_layer = ccbNode:layerForName("m_root_layer")
    if self.m_screenShoot then
        local tempSize = m_root_layer:getContentSize();
        self.m_screenShoot:setPosition(ccp(tempSize.width*0.5, tempSize.height*0.5));
        m_root_layer:addChild(self.m_screenShoot,-1);
    end
    return ccbNode;
end

--[[
    招募后刷新
]]
function game_lucky_turntable.refreshLabel(self)
    --倒计时
    local countdownTime = self.m_tGameData.time_count_down or 0
    self.left_time_node:removeAllChildrenWithCleanup(true)
    local function timeEndFunc()
       self.left_time_node:removeAllChildrenWithCleanup(true)
       local tipsLabel = game_util:createLabelTTF({text = "Đã kết thúc",color = ccc3(0,255,0),fontSize = 10});
        tipsLabel:setAnchorPoint(ccp(0.5,0.5))
        tipsLabel:setPosition(ccp(0,0))
        self.left_time_node:addChild(tipsLabel,10,12)
    end
    if countdownTime > 0 then
        local countdownLabel = game_util:createCountdownLabel(countdownTime,timeEndFunc,8, 1);
        countdownLabel:setColor(ccc3(0,255,0))
        countdownLabel:setAnchorPoint(ccp(0.5,0.5))
        countdownLabel:setPosition(ccp(0,0))
        self.left_time_node:addChild(countdownLabel,10,10)
    else
        timeEndFunc()
    end
    self.m_daily_online_lable:setString(tostring(self.m_tGameData.daily_limit) .. "/" .. tostring(self.m_tGameData.max_daily_limit));
    local tempValue,unit = game_util:formatValueToString(self.m_tGameData.open_times or 0,true)
    self.m_lottery_count_label:setString(tostring(tempValue));
    self.m_surplus_count_label_1:setString(tostring(self.m_tGameData.normal_mod_times or 0));
    self.lb_hh10:setString(tostring(math.floor((self.m_tGameData.normal_mod_times or 0) / 10)));
    self.m_surplus_count_label_2:setString(tostring(self.m_tGameData.super_mod_times or 0))
    local refresh_times = self.m_tGameData.refresh_times or 0
    local canBuy,payValue = game_util:getCostCoinBuyTimes("28",refresh_times)
    self.m_refresh_count_label:setString(string.format("%dXu",payValue));
    local wheel_cfg = getConfig(game_config_field.wheel)
    local wheel_cfg_item = wheel_cfg:getNodeWithKey(tostring(self.m_tGameData.version))
    if wheel_cfg_item then
        self.m_tips_label:setString(wheel_cfg_item:getNodeWithKey("tips"):toStr())
    else
        self.m_tips_label:setString("")
    end
    local need_sort = self.m_tGameData.need_sort or 0
    if need_sort == 1 then--充值钻石
        self.m_recharge_node:setVisible(true)
        self.m_cost_node:setVisible(false)
        self.m_recharge_icon:setVisible(true)
        local tempValue,unit = game_util:formatValueToString(self.m_tGameData.recharge_cost or 0,true)
        self.m_recharge_label:setString(tostring(tempValue));
    elseif need_sort == 2 then--消耗钻石
        self.m_recharge_node:setVisible(false)
        self.m_cost_node:setVisible(true)
        local tempValue,unit = game_util:formatValueToString(self.m_tGameData.user_cost or 0,true)
        self.m_cost_coin_lable:setString(tostring(tempValue));
    elseif need_sort == 3 then--充值人民币
        self.m_recharge_node:setVisible(true)
        self.m_cost_node:setVisible(false)
        self.m_recharge_icon:setVisible(false)
        local tempValue,unit = game_util:formatValueToString(self.m_tGameData.price or 0,true)
        self.m_recharge_label:setString(tostring(tempValue) .. "VNĐ");
    else
        self.m_recharge_node:setVisible(false)
        self.m_cost_node:setVisible(false)
    end
    local is_refresh = self.m_tGameData.is_refresh or 0
    self.m_refresh_node:setVisible(is_refresh == 1)

    --- 根据super_item不同显示不同按钮
    local super_item = wheel_cfg_item:getNodeWithKey("super_item")
    super_item = json.decode(super_item:getFormatBuffer()) or {};
    local show = false
    for _, v in pairs(super_item) do
        if type(v) == "table" and #v >= 2 and v[1] == 6 and v[2] == 90005 then 
            show = true
        end
    end
    if show then
        game_util:setCCControlButtonBackground(self.btn_gacha_10, "zsmtl_zhizunanniu1.png")
        self.btn_gacha_10:setScaleX(1)
        self.btn_gacha_10:setPreferredSize(CCSizeMake(111 / 2, 94 / 2));
    else
        game_util:setCCControlButtonBackground(self.btn_gacha_10, "zsmtl_zhizunanniu.png")
        self.btn_gacha_10:setScaleX(1.12)
        self.btn_gacha_10:setPreferredSize(CCSizeMake(106 / 2, 80 / 2));
    end
end
--[[
    
]]
function game_lucky_turntable.createTurntableRewardItem(self,rewardTab,tempSize,radius,rewardCount)
    rewardTab = rewardTab or {}
    for index=1,math.min(rewardCount,#rewardTab) do
        local rewardItem = rewardTab[index]
        if rewardItem then
            local pX,pY = tempSize.width*0.5 + radius*math.sin(math.rad(360/rewardCount*(index-1))), tempSize.height*0.5 + radius*math.cos(math.rad(360/rewardCount*(index-1)))
            local icon,name,count = game_util:getRewardByItemTable(rewardItem,false)
            if icon then
                local tempNode = icon:getChildByTag(1)
                if tempNode then
                    tempNode:removeFromParentAndCleanup(true)
                end
                local tempNode = icon:getChildByTag(2)
                if tempNode then
                    tempNode:removeFromParentAndCleanup(true)
                end
                icon:setScale(0.65);
                -- icon:setPosition(ccp(pX,pY))
                icon:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5))
                local sequence = CCSequence:createWithTwoActions(CCDelayTime:create(0.1*index), CCMoveTo:create(0.2,ccp(pX,pY)))
                icon:runAction(sequence)
                self.anim_node:addChild(icon)
                table.insert(self.m_luckyTurntableRewardTab,{parentNode = self.anim_node,rewardNode = icon,reward = rewardItem})
                local tempIconSize = icon:getContentSize();
                if count then
                    local tempLabel = game_util:createLabelBMFont({text = "×" .. count,color = ccc3(255,255,255),fontSize = 8});
                    tempLabel:setAnchorPoint(ccp(1,0.5))
                    tempLabel:setScale(1.25)
                    tempLabel:setPosition(ccp(tempIconSize.width, 5))
                    icon:addChild(tempLabel,100)
                end
            end
        end
    end
end

--[[

]]
function game_lucky_turntable.createLuckyTurntableReward(self)
    self.anim_node:removeAllChildrenWithCleanup(true);
    self.m_luckyTurntableRewardTab = {};
    local tempSize = self.anim_node:getContentSize();
    self:createTurntableRewardItem(self.m_tGameData.out_reward,tempSize,tempSize.width*0.385,10)
    self:createTurntableRewardItem(self.m_tGameData.inner_reward,tempSize,tempSize.width*0.19,6)
end

--[[--
  
]]
function game_lucky_turntable.initLayerTouch(self,formation_layer)
    local realPos = nil;
    local touchBeginPoint = nil;
    local touchMoveFlag = false;
    local function onTouchBegan(x, y)
        touchMoveFlag = false;
        touchBeginPoint = {x = x, y = y}
        return true
    end
    
    local function onTouchMoved(x, y)
        if touchMoveFlag == false and ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 then
            touchMoveFlag = true;
        end
    end
    
    local function onTouchEnded(x, y)
        if not touchMoveFlag then
            for k,v in pairs(self.m_luckyTurntableRewardTab) do
                realPos = v.parentNode:convertToNodeSpace(ccp(x,y));
                if v.rewardNode and v.rewardNode:boundingBox():containsPoint(realPos) then
                    game_util:lookItemDetal(v.reward)
                end
            end
        end
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
    formation_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY,true)
    formation_layer:setTouchEnabled(true)
end

--[[

]]
function game_lucky_turntable.createRotationAnim(self,turntableType,m_rotation_spri,posIndex,rewardCount)
    if self.m_startFlag == true then
        return;
    end
    self.m_startFlag = true;
    local angle_value = 360/rewardCount
    local rewardRandom = ((self.m_tGameData.reward_index or 0) + 1)--math.random(1,rewardCount)
    cclog("rewardRandom = " .. rewardRandom .. " ; reward_index = " .. ((self.m_tGameData.reward_index or 0) + 1))
    local totalStep = rewardCount*5+rewardRandom;
    local stepValue = 1;
    local decelerationCount = 4;
    local rotation = m_rotation_spri:getRotation();
    local m_shared = 0;
    local dtime = 0;
    function tick( dt )        
        if posIndex > totalStep - decelerationCount and posIndex < totalStep then
            dtime = dtime + dt;
            if dtime > dt*2*(posIndex - totalStep + decelerationCount) then
                cclog("********************" .. (2*(posIndex - totalStep + decelerationCount)))
                dtime = 0;
                rotation = rotation + angle_value;
                m_rotation_spri:setRotation(rotation)
                posIndex = posIndex + 1;
            end
        elseif posIndex == totalStep then
            dtime = dtime + dt;
            if dtime > 1.0 then
                stepValue = 2;
            end
        else
            rotation = rotation + angle_value;
            m_rotation_spri:setRotation(rotation)
            posIndex = posIndex + 1;
        end
        if stepValue == 2 then
            if turntableType == 1 then
                self.m_posIndex = posIndex%rewardCount == 0 and rewardCount or posIndex%rewardCount;
            elseif turntableType == 2 then
                self.m_posIndex2 = posIndex%rewardCount == 0 and rewardCount or posIndex%rewardCount;
            end
            scheduler.unschedule(m_shared)
            self.m_startFlag = false;
            self.m_mask_layer:setOpacity(200);
            self.m_anim_node:removeAllChildrenWithCleanup(true);
            self.m_anim_node:setVisible(false);
             local function callBackFunc()
                self.m_mask_layer:setTouchEnabled(false);
                self:refreshUi()
            end
            game_util:rewardTipsByDataTable(self.m_tGameData.reward or {},callBackFunc);
            self.m_mask_layer:setOpacity(0);
        end
    end
    m_shared = scheduler.schedule(tick, 1/60, false)
end

--[[--
    中奖纪录
]]
function game_lucky_turntable.createTableView(self,viewSize)
    local showData = self.m_tGameData.logs or {}
    local showCount = #showData
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;--行
    params.column = 1; --列
    params.direction = kCCScrollViewDirectionVertical;
    params.totalItem = showCount;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-1;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
        end
        if cell then
            cell:removeAllChildrenWithCleanup(true)
            local detail_label = game_util:createRichLabelTTF({text = tostring(showData[index+1]),dimensions = dimensions,textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(255,255,255)})
            -- detail_label:setAnchorPoint(ccp(0, 0))
            detail_label:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5))
            cell:addChild(detail_label)
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  item = " .. tolua.type(item));
        end
    end
    return TableViewHelper:create(params);
end

--[[--
    刷新
]]
function game_lucky_turntable.refreshTableView(self)
    self.rank_node:removeAllChildrenWithCleanup(true);
    self.m_tableView = self:createTableView(self.rank_node:getContentSize());
    self.m_tableView:setScrollBarVisible(true);
    self.rank_node:addChild(self.m_tableView,10,10);
end

--[[--
    刷新ui
]]
function game_lucky_turntable.refreshUi(self)
    self:refreshTableView();
    self:refreshLabel();
    self:createLuckyTurntableReward();
end
--[[--
    初始化
]]
function game_lucky_turntable.init(self,t_params)
    t_params = t_params or {}
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data");
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
    else
        self.m_tGameData = {};
    end

    self.m_gachaAnimEndFlag = false;
    self.m_startFlag = false;
    self.m_luckyTurntableRewardTab = {};
    self.m_screenShoot = t_params.screenShoot;
end
--[[--
    创建ui入口并初始化数据
]]
function game_lucky_turntable.create(self,t_params)
    self:init(t_params);
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

return game_lucky_turntable;
e