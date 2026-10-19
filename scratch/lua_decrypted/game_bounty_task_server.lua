--- game_bounty_task_server信息

local game_bounty_task_server = {
    m_popUi = nil,
    m_root_layer = nil,
    m_ccbNode = nil,

    m_screenShoot = nil,
    btn_apply = nil,
    btn_giveup = nil,
    btn_get = nil,
    select_index = nil,
    refresh_cost_label = nil,
    light_sprite = nil,
    is_accept = nil,
    progress_node = nil,
    progress_node2 = nil,
    story_label = nil,
    num_text = nil,
    back_light2 = nil,
    btn_goto = nil,
    round_light = nil,
    btn_getreward = nil,
    openFlag = nil,
};

--[[--
    销毁
]]
function game_bounty_task_server.destroy(self)
    -- body
    cclog("-----------------game_bounty_task_server destroy-----------------");
    self.m_popUi = nil;
    self.m_root_layer = nil;
    self.m_ccbNode = nil;

    self.m_screenShoot = nil;
    self.btn_apply = nil;
    self.btn_giveup = nil;
    self.btn_get = nil;
    self.select_index = nil;
    self.refresh_cost_label = nil;
    self.light_sprite = nil;
    self.is_accept = nil;
    self.progress_node = nil;
    self.progress_node2 = nil;
    self.story_label = nil;
    self.num_text = nil;
    self.back_light2 = nil;
    self.btn_goto = nil;
    self.round_light = nil;
    self.btn_getreward = nil;
    self.openFlag = nil;
end
--[[--
    返回
]]
function game_bounty_task_server.back(self,type)
    if self.is_accept == false then
        local screenShoot = self.m_screenShoot
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_bounty_main_server",{gameData = gameData,screenShoot = screenShoot})
                screenShoot:release()
                game_util:closeAlertView();
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_bounty_order_index"), http_request_method.GET, nil,"server_bounty_order_index")
    else
        local function endCallFunc()
            self:destroy();
        end
        game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
    end
end
--[[--
    读取ccbi创建ui
]]
function game_bounty_task_server.createUi(self)
    local ccbNode = luaCCBNode:create();

    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then
            self:back();
        elseif btnTag == 11 then
            
        elseif btnTag == 12 then
            
        elseif btnTag == 101 then--get reward
            local function responseMethod(tag,gameData)
                local reward = gameData:getNodeWithKey("data"):getNodeWithKey("reward")
                game_util:rewardTipsByJsonData(reward);

                if gameData ~= nil and tolua.type(gameData) == "util_json" then
                    self.gameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
                end
                self:formatData()
                self:refreshUi()
            end
            local childType = (self.lookType - 1) * 4 + self.select_index
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_get_reward_bounty_order_child_task"), http_request_method.GET, {type = self.lookType,child_type = childType},"server_get_reward_bounty_order_child_task")
        elseif btnTag == 102 then--give up
            local function responseMethod(tag,gameData)
                local screenShoot = self.m_screenShoot
                screenShoot:retain();
                if gameData then
                    game_scene:enterGameUi("game_bounty_main_server",{gameData = gameData,screenShoot = screenShoot})
                    screenShoot:release()
                    game_util:closeAlertView();
                end
            end
            local t_params = 
            {
                title = string_config.m_title_prompt,
                okBtnCallBack = function(target,event)
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_bounty_order_is_give_up_task"), http_request_method.GET, {type = self.lookType},"server_bounty_order_is_give_up_task")
                end,   --可缺省
                okBtnText = string_config.m_btn_sure,       --可缺省
                cancelBtnText = string_config.m_btn_cancel,
                text = "Xác nhận muốn từ bỏ nhiệm vụ hiện tại?",      --可缺省
                onlyOneBtn = false,
                touchPriority = GLOBAL_TOUCH_PRIORITY-2,
            }
            game_util:openAlertView(t_params)
        elseif btnTag == 103 then--apply task
            local function responseMethod(tag,gameData)
                if gameData ~= nil and tolua.type(gameData) == "util_json" then
                    self.gameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
                end
                self:formatData()
                self:refreshUi()
                self:createBountyAnim("first")
                self.is_accept = true
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_bounty_order_is_accept_task"), http_request_method.GET, {type = self.lookType},"server_bounty_order_is_accept_task")
        elseif btnTag == 104 then--refresh task
            local function responseMethod(tag,gameData)
                if gameData ~= nil and tolua.type(gameData) == "util_json" then
                    self.gameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
                end
                self:formatData()
                self:refreshUi()
            end
            local childType = (self.lookType - 1) * 4 + self.select_index
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_refresh_bounty_order_child_task"), http_request_method.GET, {type = self.lookType,child_type = childType},"server_refresh_bounty_order_child_task")
        elseif btnTag == 105 then--领取大奖然后跳转
            local screenShoot = self.m_screenShoot
            screenShoot:retain()
            local function responseMethod(tag,gameData)
                local reward = gameData:getNodeWithKey("data"):getNodeWithKey("reward")
                game_scene:enterGameUi("game_bounty_main_server",{gameData = gameData,screenShoot = screenShoot})
                game_util:rewardTipsByJsonData(reward);
                screenShoot:release()   
                self:destroy()
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_bounty_order_get_big_reward"), http_request_method.GET, {type = self.lookType},"server_bounty_order_get_big_reward")
        elseif btnTag == 501 then--跳转
            if self.gameData.bounty_order_type.is_accept then
                local bounty_detail = getConfig(game_config_field.server_bounty_detail)
                local bountyID = self.taskData[self.select_index]["child_task_id"]
                local target_sort = bounty_detail:getNodeWithKey(tostring(bountyID)):getNodeWithKey("target_sort"):toInt()
                self:quickEnter(target_sort)
            end
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_bounty_task.ccbi");
    local m_root_layer = tolua.cast(ccbNode:objectForName("m_root_layer"),"CCLayer");

    self.count_down_node = ccbNode:nodeForName("count_down_node")
    self.scroll_node = ccbNode:scrollViewForName("scroll_node")
    self.reward_node = ccbNode:nodeForName("reward_node")
    self.task_node = ccbNode:nodeForName("task_node")
    self.title_sprite = ccbNode:spriteForName("title_sprite")
    self.icon_sprite = ccbNode:spriteForName("icon_sprite")
    self.icon_node = ccbNode:layerForName("icon_node")
    self.complete = ccbNode:spriteForName("complete")
    self.progress_node = ccbNode:nodeForName("progress_node")
    self.progress_node2 = ccbNode:nodeForName("progress_node2")
    self.refresh_cost_label = ccbNode:labelTTFForName("refresh_cost_label")
    self.light_sprite = ccbNode:spriteForName("light_sprite")
    self.story_label = ccbNode:labelTTFForName("story_label")
    self.num_text = ccbNode:labelTTFForName("num_text")
    self.back_light2 = ccbNode:spriteForName("back_light2")
    self.back_light2:runAction(game_util:createRepeatForeverFade())
    self.back_light2:setVisible(false)
    self.btn_goto = ccbNode:controlButtonForName("btn_goto")
    self.btn_goto:setOpacity(0)
    self.round_light = ccbNode:spriteForName("round_light")
    self.round_light:runAction(game_util:createRepeatForeverFade())
    self.btn_getreward = ccbNode:controlButtonForName("btn_getreward")

    self.btn_apply = ccbNode:controlButtonForName("btn_apply")
    self.btn_giveup = ccbNode:controlButtonForName("btn_giveup")
    self.btn_get = ccbNode:controlButtonForName("btn_get")
    self.anim_node = ccbNode:nodeForName("anim_node")
    local m_close_btn = ccbNode:controlButtonForName("m_close_btn")


    -- btn_get:setTouchPriority(GLOBAL_TOUCH_PRIORITY-11)
    -- btn_giveup:setTouchPriority(GLOBAL_TOUCH_PRIORITY-11)
    -- btn_apply:setTouchPriority(GLOBAL_TOUCH_PRIORITY-11)
    -- m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-11)
    self.m_ccbNode = ccbNode;

    if self.m_screenShoot then
        local tempSize = m_root_layer:getContentSize();

        self.m_screenShoot:setPosition( tempSize.width*0.5, tempSize.height*0.5 );
        m_root_layer:addChild(self.m_screenShoot,-1);
    end

    self:createBountyAnim(self.gameData.bounty_order_type.is_accept)
    return ccbNode;
end
--[[
    打击动画
]]
function game_bounty_task_server.createBountyAnim(self,animType)
    self.anim_node:removeAllChildrenWithCleanup(true)
    local pos = {ccp(34,102),ccp(33,52),ccp(85,48)}
    if animType == true then
        for i=1,3 do
            local duang = CCSprite:createWithSpriteFrameName("bounty_duang.png")
            duang:setPosition(pos[i])
            self.anim_node:addChild(duang)
        end
    elseif animType == "first" then
        local scaleTime = 0.25
        local function setOver(node)
            game_sound:playUiSound("stamp")
        end
        local function setSpiteVisible(sprite)
            sprite:setVisible(true)
        end
        local setOver = CCCallFuncN:create(setOver)
        local setSpiteVisible = CCCallFuncN:create(setSpiteVisible)
        for i=1,3 do
            local delayIndex = i * scaleTime
            local duang = CCSprite:createWithSpriteFrameName("bounty_duang.png")
            duang:setPosition(pos[i])
            duang:setScale(4)
            duang:setVisible(false)
            self.anim_node:addChild(duang)
            local arr = CCArray:create();
            arr:addObject(CCDelayTime:create(delayIndex));
            arr:addObject(setSpiteVisible)
            arr:addObject(CCScaleBy:create(scaleTime,0.25));
            arr:addObject(setOver);
            duang:runAction(CCSequence:create(arr));
        end
    end
end
--[[
    refresh table view
]]
function game_bounty_task_server.refreshTableView(self)
    local bounty_reward = getConfig(game_config_field.server_bounty_reward);
    local tempType = (self.lookType - 1) * 4 + self.select_index
    local itemCfg = bounty_reward:getNodeWithKey(tostring(tempType))
    if itemCfg then
        local reward = itemCfg:getNodeWithKey("reward")
        local rewardList = json.decode(reward:getFormatBuffer())
        self.reward_node:removeAllChildrenWithCleanup(true)
        local tableViewTemp = self:createRewardTable(self.reward_node:getContentSize(),#rewardList,rewardList);
        self.reward_node:addChild(tableViewTemp);
    end

    self.task_node:removeAllChildrenWithCleanup(true)
    local tableViewTemp = self:createSelectTable(self.task_node:getContentSize());
    tableViewTemp:setMoveFlag(false)
    self.task_node:addChild(tableViewTemp);

    local function timeOverCallFun()
        
    end
    if self.gameData.time_count_down then
        local timeLabel = game_util:createCountdownLabel(self.gameData.time_count_down,timeOverCallFun)
        timeLabel:setAnchorPoint(ccp(0.5,0.5))
        timeLabel:setPosition(ccp(0,0))
        self.count_down_node:removeAllChildrenWithCleanup(true)
        self.count_down_node:addChild(timeLabel)
    end
end
--[[--
    刷新ui
]]
function game_bounty_task_server.refreshUi(self)
    self:refreshTableView()

    self.icon_node:removeAllChildrenWithCleanup(true)
    
    local title = {"bounty_titles.png","bounty_titless.png","bounty_titlesss.png"}
    self.title_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(title[self.lookType]))
    self.light_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("bounty_light" .. self.lookType .. ".png"))

    local bounty_order = getConfig(game_config_field.server_bounty_order);
    local orderCfg = bounty_order:getNodeWithKey(tostring(self.gameData.version))
    local rewardShow = orderCfg:getNodeWithKey("reward_show_" .. self.lookType):getNodeAt(0)
    local icon,name,count = game_util:getRewardByItem(rewardShow)
    self.icon_node:removeAllChildrenWithCleanup(true)
    if icon then
        icon:setScale(0.7)
        self.icon_node:addChild(icon)
    end

    local function onBtnCilck( event,target )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        local rewardShowTable = json.decode(rewardShow:getFormatBuffer()) or {}
        game_util:lookItemDetal(rewardShowTable)
    end

    --look detail 
    local button = game_util:createCCControlButton("public_weapon.png","",onBtnCilck)
    button:setOpacity(0)
    button:setAnchorPoint(ccp(0.5,0.5))
    self.icon_node:addChild(button);

    -- local bounty_detail = getConfig(game_config_field.server_bounty_detail)
    -- local itemCfg = bounty_detail:getNodeWithKey("1")
    -- local story = itemCfg:getNodeWithKey("story"):toStr()
    local story = self.taskData[self.select_index].msg
    --srcoll view
    -- local tempLabel = game_util:createRichLabelTTF({text = story,dimensions = CCSizeMake(190,0),textAlignment = kCCTextAlignmentCenter,
    --     verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(221,221,192),fontSize = 12})
    -- local tempSize = tempLabel:getContentSize();
    -- self.scroll_node:setContentSize(CCSizeMake(190,tempSize.height))

    -- local viewSize = self.scroll_node:getContentSize()

    -- -- if tempSize.height > viewSize.height then
    --     self.scroll_node:setContentOffset(ccp(0, 65 - tempSize.height), false)
    -- -- end
    -- -- self.scroll_node:removeAllChildrenWithCleanup(true)
    -- self.scroll_node:getContainer():removeAllChildrenWithCleanup(true)
    -- self.scroll_node:addChild(tempLabel,10,10)
    self.story_label:setString(story)

    --bar
    local itemData = self.taskData[self.select_index]
    local max_times = itemData.max_times
    local times = itemData.times
    if max_times > 0 then
        self.progress_node2:removeAllChildrenWithCleanup(true)
        local bar = ExtProgressTime:createWithFrameName("bounty_detail2.png","bounty_detail.png")
        bar:setMaxValue(max_times);
        bar:setCurValue(times,false);
        bar:setAnchorPoint(ccp(0.5,0.5));
        bar:setPosition(ccp(0,-1));
        self.progress_node2:addChild(bar,-1,10);

        local barTTF = CCLabelTTF:create(times.."/"..max_times,TYPE_FACE_TABLE.Arial_BoldMT,10);
        barTTF:setAnchorPoint(ccp(0.5,0.5))
        self.progress_node2:addChild(barTTF,10)
    end

    --button status
    self.btn_apply:setVisible(not self.gameData.bounty_order_type.is_accept)
    self.btn_giveup:setVisible(self.gameData.bounty_order_type.is_accept)

    if self.openFlag == true then
        self.back_light2:setVisible(not self.gameData.bounty_order_type.is_accept)
    end

    --cost
    local canBuy,payValue = game_util:getCostCoinBuyTimes(29,self.gameData.refresh_times)
    self.refresh_cost_label:setString(payValue)

    --reward status
    local task_done = self.gameData.bounty_order_type.task_done--complete but not reveive 
    local get_task_reward = self.gameData.bounty_order_type.get_task_reward--reveive already

    --bar2
    local comTask = #task_done
    self.progress_node:removeAllChildrenWithCleanup(true)
    local bar2 = ExtProgressTime:createWithFrameName("bounty_detail2.png","bounty_detail.png")
    bar2:setMaxValue(4);
    bar2:setCurValue(comTask,false);
    bar2:setAnchorPoint(ccp(0.5,0.5));
    bar2:setPosition(ccp(0,-1));
    self.progress_node:addChild(bar2,-1,10);

    local barTTF2 = CCLabelTTF:create(comTask.."/"..4,TYPE_FACE_TABLE.Arial_BoldMT,10);
    barTTF2:setAnchorPoint(ccp(0.5,0.5))
    self.progress_node:addChild(barTTF2,10)

    local childType = (self.lookType - 1) * 4 + self.select_index
    if game_util:idInTableById(childType,get_task_reward) then--reward had geted already
        self.round_light:setVisible(false)
        self.btn_get:setEnabled(false)
        -- game_util:setCCControlButtonTitle(self.btn_get,"已领取");
        -- self.btn_get:setColor(ccc3(200,200,200))
    elseif game_util:idInTableById(childType,task_done) then--task done but not receive
        self.round_light:setVisible(true)
        self.btn_get:setEnabled(true)
        -- self.btn_get:setColor(ccc3(255,255,255))
        -- game_util:setCCControlButtonTitle(self.btn_get,"领取");
    else
        self.round_light:setVisible(false)
        self.btn_get:setEnabled(false)
        -- self.btn_get:setColor(ccc3(200,200,200))
        -- game_util:setCCControlButtonTitle(self.btn_get,"领取");
    end

    --都完成的时候显示领取
    if game_util:getTableLen(get_task_reward) == 4 then
        self.btn_giveup:setVisible(false)
        self.btn_apply:setVisible(false)
        self.btn_getreward:setVisible(true)
    else
        self.btn_getreward:setVisible(false)
    end

    self.num_text:setString(self.select_index)
end
function game_bounty_task_server.createSelectTable(self,viewSize)
    -- CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_bounty.plist");
    local params = {};
    params.viewSize = viewSize;
    params.row = 4;
    params.column = 1; --列
    params.totalItem = 4;
    params.showPoint = false
    params.itemActionFlag = false;
    params.direction = kCCScrollViewDirectionVertical;--横向
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local node = CCNode:create()
            node:setAnchorPoint(ccp(0.5,0.5))
            node:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5))
            
            local sprite = CCSprite:createWithSpriteFrameName("bounty_btn2.png")
            local numIcon = CCSprite:createWithSpriteFrameName("bounty_num" .. index+1 .. ".png")
            local completeIcon = CCSprite:createWithSpriteFrameName("bounty_icon_already.png")
            --已完成未领取加一个红点
            local bit = CCSprite:createWithSpriteFrameName("bounty_bit.png")
            bit:setPosition(ccp(12,12))
            if sprite then
                node:addChild(sprite)
            end
            if numIcon then
                node:addChild(numIcon)
            end
            cell:addChild(node)

            local itemData = self.taskData[index+1]
            local is_ok = itemData.is_ok
            local task_done = self.gameData.bounty_order_type.task_done--complete but not reveive 
            local get_task_reward = self.gameData.bounty_order_type.get_task_reward--reveive already

            
            if self.select_index == index+1 then
                sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("bounty_btn1.png"))
            else
                sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("bounty_btn2.png"))
            end

            local childType = (self.lookType - 1) * 4 + index + 1
            local lastSprite1 = node:getChildByTag(10)
            local lastSprite2 = node:getChildByTag(11)
            if lastSprite1 then
                lastSprite1:removeFromParentAndCleanup(true)
            end
            if lastSprite2 then
                lastSprite2:removeFromParentAndCleanup(true)
            end
            if game_util:idInTableById(childType,get_task_reward) then--加领取图标
                node:addChild(completeIcon,10,10)
            else
                if game_util:idInTableById(childType,task_done) then--未领取，已完成加红点
                    node:addChild(bit,11,11)
                end
            end
            -- if is_ok == false then--改为加一个图标
            --     -- sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("bounty_btn3.png"))
            -- else
            --     -- sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("bounty_btn2.png"))
            --     node:addChild(completeIcon)
            -- end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            self.select_index = index + 1
            self:refreshUi()
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
    end
    return TableViewHelper:create(params);
end
function game_bounty_task_server.createRewardTable(self,viewSize,count,rewardList)
    -- function onBtnClick( event, target )
    --     local tagNode = tolua.cast(target, "CCNode");
    --     local btnTag = tagNode:getTag();
    --     print("press button tag is ", btnTag)
        
    -- end
    local params = {};
    params.viewSize = viewSize;
    params.row = 1;
    params.column = math.min(4,#rewardList); --列
    params.totalItem = count;
    params.showPoint = false
    params.itemActionFlag = false;
    params.direction = kCCScrollViewDirectionHorizontal;--纵向
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local node = CCNode:create()
            node:setAnchorPoint(ccp(0.5,0.5))
            node:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5))
            local itemGift = rewardList[index+1]
            local icon,name,count = game_util:getRewardByItemTable(itemGift)
            node:removeAllChildrenWithCleanup(true)
            if icon then
                icon:setScale(0.7)
                icon:setAnchorPoint(ccp(0.5,0.5))
                icon:setPosition(ccp(0,2))
                node:addChild(icon,10)
                -- local button = game_util:createCCControlButton("public_weapon.png","",onBtnClick)
                -- button:setAnchorPoint(ccp(0.5,0.5))
                -- button:setPosition( node:getContentSize().width * 0.5, node:getContentSize().height * 0.5 )
                -- button:setOpacity(0)
                -- node:addChild(button)
                -- button:setTag( index )
            end
            if count then
                local label_count = game_util:createLabelTTF({text = "×" .. count,color = ccc3(255,255,255),fontSize = 12})
                label_count:setAnchorPoint(ccp(0.5,0.5))
                label_count:setPosition(ccp(0,-20))
                node:addChild(label_count,20)
            end
            cell:addChild(node)
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            local itemData = rewardList[index + 1]
            if itemData then
                game_util:lookItemDetal( itemData )
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
    end
    return TableViewHelper:createGallery2(params);
end
--[[--
    初始化
]]
function game_bounty_task_server.init(self,t_params)
    t_params = t_params or {};
    -- self.gameData = t_params.gameData
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        self.gameData = json.decode(t_params.gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
    end
    self.m_screenShoot = t_params.screenShoot
    self.lookType = t_params.lookType
    self:formatData()
    self.select_index = 1
    self.is_accept = t_params.is_accept or false
    self.openFlag = t_params.openFlag or false
end
--[[
    格式化数据，使前端要用所有字段名称都一样
]]
function game_bounty_task_server.formatData(self)
    local bounty_order_type = self.gameData.bounty_order_type
    self.taskData = {}
    local tempData = {}
    if self.lookType == 1 then
        tempData = bounty_order_type.bos_one
    elseif self.lookType == 2 then
        tempData = bounty_order_type.bos_two
    elseif self.lookType == 3 then
        tempData = bounty_order_type.bos_three
    end
    -- for k,v in pairs(tempData) do
    --     table.insert(self.taskData,v)
    -- end
    -- self.taskData = tempData[tostring((self.lookType - 1) * 4)]
    for i=1,game_util:getTableLen(tempData) do
        table.insert( self.taskData, tempData[tostring((self.lookType - 1) * 4 + i)] )        
    end
end
--[[--
    创建ui入口并初始化数据
]]
function game_bounty_task_server.create(self,t_params)
    self:init(t_params);
    local rootScene = CCScene:create();
    rootScene:addChild(self:createUi());
    self:refreshUi();
    return rootScene;
end
--[[--
    前往
]]
function game_bounty_task_server.quickEnter(self, qetype)
    print("will quick entry qetype is ", qetype)
    if qetype == 3 then  -- 收复  -- 章节
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("map_world_scene",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_world_map"), http_request_method.GET, nil,"private_city_world_map")
    elseif qetype == 1 or qetype == 2 then  -- 招募 gacha
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_gacha_scene",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("gacha_get_all_gacha"), http_request_method.GET, nil,"gacha_get_all_gacha")
    elseif qetype == 4 then--活动
       game_scene:enterGameUi("game_main_scene",{gameData = nil, openPop = "game_activity_new_pop"},{endCallFunc = function (  )
            self:destroy();
        end});
    elseif qetype == 5 then--装备进阶
        if not game_button_open:checkButtonOpen(603) then
            return;
        end
        game_scene:enterGameUi("equip_evolution",{gameData = nil});
    elseif qetype == 6 then      -- 装备强化
        if not game_button_open:checkButtonOpen(602) then
            return
        end
        game_scene:enterGameUi("equipment_strengthen",{gameData = nil})
    elseif qetype == 7 or qetype == 9 then  -- 前往 分解卡片
        game_scene:enterGameUi("game_card_split");
    elseif qetype == 8 then  -- 卡牌进阶
        game_scene:enterGameUi("game_hero_advanced_sure",{gameData = nil});
    elseif qetype == 10 then  -- 卡牌传承
        if not game_button_open:checkButtonOpen(506) then
            return
        end
        game_scene:enterGameUi("game_hero_inherit");
    elseif qetype == 11 then--转生
        if not game_button_open:checkButtonOpen(112) then
            return
        end
        game_scene:enterGameUi("game_hero_breakthrough",{gameData = nil});   
    elseif qetype == 13 then -- 属性改造
        if not game_button_open:checkButtonOpen(509) then
            return
        end
        game_scene:enterGameUi("game_hero_culture_scene",{gameData = gameData})
    elseif qetype == 14 or qetype == 15 then  -- 训练
        if not game_button_open:checkButtonOpen(501) then
            return;
        end
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_school_new",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("school_open"), http_request_method.GET, nil,"school_open")
    elseif qetype == 16 then--热门活动
        function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_charge_active",{gameData = gameData})
            self:destroy()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_active_show"), http_request_method.GET, {},"active_active_show")
    elseif qetype == 17 then--轮盘
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_lucky_turntable",{gameData = gameData})
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("roulette_index"), http_request_method.GET, {},"roulette_index")
    elseif qetype == 18 then--神将
        function shopOpenResponseMethod(tag,gameData)
            -- game_scene:addPop("game_active_limit_pop",{gameData = gameData})
            game_scene:enterGameUi("game_active_limit",{gameData = gameData})
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("get_reward_gacha"), http_request_method.GET, {},"get_reward_gacha")
    elseif qetype == 19 then--藏宝图
        local screenShoot = self.m_screenShoot
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_seapoacher",{gameData = gameData,screenShoot = screenShoot});
        end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("one_piece_index"), http_request_method.GET, nil,"one_piece_index",true,true)
    elseif qetype == 20 then--团购
        local screenShoot = self.m_screenShoot
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("mid_autumn_scene",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_group_index"), http_request_method.GET, nil,"active_group_index",true,true)
    end
end
return game_bounty_task_server;