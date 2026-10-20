local ui_fire_board_pop = {
    reward_open = nil,
    m_root_layer = nil,
    m_btn_back = nil,
    m_fire_node = nil,
    m_bigfire_node = nil,
    m_xiaohuo_node = nil,
    m_biankuang_node = nil,
    m_rewards_node = nil,
    m_progress_node = nil,
    m_my_remain_times = nil,
    m_my_ach = nil,
    m_all_ach = nil,
    m_rich_lb1 = nil,
    m_rich_lb2 = nil,
    active_time = nil,
    m_time_node = nil,
    m_card_node = nil,
    m_btn_node = nil,
    m_buy_layer = nil,
    m_buy_btn1 = nil,
    m_buy_btn2 = nil,
    m_count_1 = nil,
    m_count_2 = nil,
    m_count_3 = nil,
    m_count_4 = nil,
    m_first_fire = nil,
    list = nil,
    m_open_count = nil,
    m_open_list = nil,
    bar = nil,
    m_iAnim_biankuanghuoyan = nil,
    m_iAnim_dahuo = nil,
    isfire = nil,
    m_fire = nil,
    m_tGameData = nil,
    m_shop_reward = nil,
    m_open_list = nil,
    m_fire = nil,
    isChange = nil,
    m_all_buy_count = nil,
    m_version = nil,
    m_free_fresh_times = nil,
}
function ui_fire_board_pop:destroy()
    cclog("-------------- ui_fire_board_pop  destroy --------------")
    shop_reward_open = nil;
    self.m_root_layer = nil;
    self.m_btn_back = nil;
    self.m_fire_node = nil;
    self.m_bigfire_node = nil;
    self.m_xiaohuo_node = nil;
    self.m_biankuang_node = nil;
    self.m_rewards_node = nil;
    self.m_progress_node = nil;
    self.m_my_remain_times = nil;
    self.m_my_ach = nil;
    self.m_all_ach = nil;
    self.m_rich_lb1 = nil;
    self.m_rich_lb2 = nil; 
    self.active_time = nil;
    self.m_time_node = nil;
    self.m_card_node = nil;
    self.m_btn_node = nil;
    self.m_buy_layer = nil;
    self.m_buy_btn1 = nil;
    self.m_buy_btn2 = nil;
    self.m_count_1 = nil;
    self.m_count_2 = nil;
    self.m_count_3 = nil;
    self.m_count_4 = nil;
    self.m_first_fire = nil;
    self.list = nil;
    self.m_open_count = nil;
    self.m_open_list = nil;
    self.bar = nil;
    self.m_iAnim_biankuanghuoyan = nil;
    self.m_iAnim_dahuo = nil;
    self.isfire = nil;
    self.m_fire = nil;
    self.m_tGameData = nil;
    self.m_shop_reward = nil;
    self.m_open_list = nil;
    self.m_fire = nil;
    self.isChange = nil;
    self.m_all_buy_count = nil;
    self.m_version = nil;
    self.m_free_fresh_times = nil;
end

function ui_fire_board_pop:back()
	game_scene:removePopByName("ui_fire_board_pop")
    local function endCallFunc()
		self:destroy();
	end
	game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
end


function ui_fire_board_pop:createUi()
	local function onMainBtnClick( target,event )
		local tagNode = tolua.cast(target,"CCNode")
		local btnTag = tagNode:getTag()
		if btnTag == 1 then
			self:back()
        elseif btnTag == 101 then
            local function responseMethod( tag,gameData )
                game_scene:addPop("ui_fire_board_rank_pop",{gameData = gameData,version = self.m_version})
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("fire_chess_rank_achievement"), http_request_method.GET, nil,"fire_chess_rank_achievement")
        elseif btnTag == 102 then
            local function responseMethod( tag,gameData )
                if gameData and tolua.type(gameData) == "util_json" then
                    local data = gameData:getNodeWithKey("data")
                    self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
                    self.m_cost = self.m_tGameData.cost
                    self.isfire = self.m_tGameData.isfire
                    self:createFire()
                    local shop_reward_open = self.m_tGameData.shop_reward_open
                    self.m_shop_reward = self.m_tGameData.shop_reward
                    self.m_open_list = {}
                    for k,v in pairs(shop_reward_open) do
                        self.m_open_list[v] = v
                    end
                    self.m_rewards_node:removeAllChildrenWithCleanup(true)
                    self:createTableView1(self.m_rewards_node:getContentSize())
                    self:refreshData(gameData)
                    -- self:refreshProgressTime(self.m_tGameData.all_buy_times)
                end
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("fire_chess_shuffle_shop"), http_request_method.GET, nil,"fire_chess_shuffle_shop")
        elseif btnTag == 103 then
            local text,is_free
            if self.m_open_count == 60 or self.m_free_fresh_times > 0 then
                text = "             Miễn phí  "
                if self.m_open_count == 60 then
                    is_free = 1
                else
                    is_free = 0
                end
            elseif self.m_open_count < 60 then
                text = "         Tốn 20 Xu tạo mới"
                    is_free = 0
            end
            local t_params = {
                title = string_config.m_title_prompt,
                okBtnCallBack = function(target,event)
                    game_util:closeAlertView();
                    if self.m_open_count == 60 or self.m_free_fresh_times > 0  then
                        if self.m_open_count < 60  then
                            self.m_free_fresh_times = self.m_free_fresh_times - 1
                        end
                        self:refreshRewardList(is_free)
                    elseif self.m_open_count < 60 then
                        self:refreshRewardList(is_free)
                    end
                    self.m_open_count = 0
                end,   --可缺省
                cancelBtnCallBack = function(target,event)
                    game_util:closeAlertView();
                    self:refreshBtn(false)
                end,
                okBtnText = "OK",       --可缺省
                cancelBtnText = "Hủy",
                onlyOneBtn = false,
                text =text,      --可缺省
                touchPriority = GLOBAL_TOUCH_PRIORITY-7,
            }
            game_util:openAlertView(t_params);

        elseif btnTag == 104 then
            self:refreshBtn(true)
        elseif btnTag == 201 then
            local t_params = {
                title = string_config.m_title_prompt,
                okBtnCallBack = function(target,event)
                    game_util:closeAlertView();
                    local function responseMethod( tag,gameData )
                        if gameData and tolua.type(gameData) == "util_json" then
                            local data = gameData:getNodeWithKey("data")
                            self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
                        end

                        self:refreshData(gameData)

                        self.m_cost = self.m_tGameData.cost
                        self.isfire = self.m_tGameData.isfire
                        self:createFire()
                        local shop_reward_open = self.m_tGameData.shop_reward_open
                        self.m_open_list = {}
                        for k,v in pairs(shop_reward_open) do
                            self.m_open_list[v] = v
                        end
                        self.m_rewards_node:removeAllChildrenWithCleanup(true)
                        self:createTableView1(self.m_rewards_node:getContentSize())
                        game_util:addMoveTips({text="Đã mua ！"})
                        self:refreshBtn(false)
                        -- self:refreshProgressTime(self.m_tGameData.all_buy_times)
                    end
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("fire_chess_all_choice_reward"), http_request_method.GET, {tp = 1},"fire_chess_all_choice_reward")
                end,   --可缺省
                cancelBtnCallBack = function(target,event)
                    game_util:closeAlertView();
                    self:refreshBtn(false)
                end,
                okBtnText = "OK",       --可缺省
                cancelBtnText = "Hủy",
                onlyOneBtn = false,
                text ="    Xác nhận mua 10 lần ?   ",      --可缺省
                touchPriority = GLOBAL_TOUCH_PRIORITY-7,
            }
            game_util:openAlertView(t_params);
        elseif btnTag == 202 then
            local t_params = {
                title = string_config.m_title_prompt,
                okBtnCallBack = function(target,event)
                    game_util:closeAlertView();
                    local function responseMethod( tag,gameData )
                        if gameData and tolua.type(gameData) == "util_json" then
                            local data = gameData:getNodeWithKey("data")
                            self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
                        end

                        self:refreshData(gameData)

                        self.isfire = self.m_tGameData.isfire
                        self.m_cost = self.m_tGameData.cost
                        local shop_reward_open = self.m_tGameData.shop_reward_open
                        -- self.m_shop_reward = self.m_tGameData.shop_reward
                        self.m_open_list = {}
                        for k,v in pairs(shop_reward_open) do
                            self.m_open_list[v] = v
                        end
                        self.m_rewards_node:removeAllChildrenWithCleanup(true)
                        self:createTableView1(self.m_rewards_node:getContentSize())
                        game_util:addMoveTips({text="Đã mua ！"})
                        self:refreshBtn(false)
                        -- self:refreshProgressTime(self.m_tGameData.all_buy_times)
                    end
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("fire_chess_all_choice_reward"), http_request_method.GET, {tp = 2},"fire_chess_all_choice_reward")
                end,   --可缺省
                cancelBtnCallBack = function(target,event)
                    game_util:closeAlertView();
                    self:refreshBtn(false)
                end,
                okBtnText = "OK",       --可缺省
                cancelBtnText = "Hủy",
                onlyOneBtn = false,
                text ="    Xác nhận Take-away ?   ",      --可缺省
                touchPriority = GLOBAL_TOUCH_PRIORITY-7,
            }
            game_util:openAlertView(t_params);
		end
	end
	local ccbNode =  luaCCBNode:create();
	ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick)
	ccbNode:openCCBFile("ccb/ui_fire_board_pop.ccbi")
	self.m_root_layer = ccbNode:layerForName("m_root_layer");
	self.m_btn_back = ccbNode:controlButtonForName("btn_back")
	self.m_fire_node = ccbNode:nodeForName("m_fire_node")
    self.m_bigfire_node = ccbNode:nodeForName("m_bigfire_node")
	self.m_xiaohuo_node = ccbNode:nodeForName("m_xiaohuo_node")
	self.m_biankuang_node = ccbNode:nodeForName("m_biankuang_node")
	self.m_rewards_node = ccbNode:nodeForName("m_rewards_node")
    self.m_progress_node = ccbNode:nodeForName("m_progress_node")
    self.m_my_ach = ccbNode:labelTTFForName("my_ach")
    self.m_my_remain_times =ccbNode:labelTTFForName("my_last_bigaward")
    self.m_all_ach = ccbNode:labelTTFForName("all_ach")
    self.m_rich_lb1 = ccbNode:labelTTFForName("m_rich_lb1")
    self.m_rich_lb2 = ccbNode:labelTTFForName("m_rich_lb2")
    self.active_time = ccbNode:labelTTFForName("active_time")
    self.m_time_node = ccbNode:nodeForName("m_time_node")
    self.active_time:setVisible(true)
	self.m_card_node = ccbNode:nodeForName("m_card_node")
    self.m_btn_node = ccbNode:nodeForName("m_btn_node")
    self.m_buy_layer = ccbNode:layerForName("m_buy_layer")
    self.m_buy_btn1 = ccbNode:controlButtonForName("m_buy_btn1")
    self.m_buy_btn2 = ccbNode:controlButtonForName("m_buy_btn2")
	local m_btn1 = ccbNode:controlButtonForName("m_btn1")
	local m_btn2 = ccbNode:controlButtonForName("m_btn2")
	local m_btn3 = ccbNode:controlButtonForName("m_btn3")
	local m_btn4 = ccbNode:controlButtonForName("m_btn4")
    self.m_count_1 = ccbNode:labelTTFForName("count_1")
    self.m_count_2 = ccbNode:labelTTFForName("count_2")
    self.m_count_3 = ccbNode:labelTTFForName("count_3")
    self.m_count_4 = ccbNode:labelTTFForName("count_4")
    self.m_discount_node1 = ccbNode:nodeForName("discount_node1")
    self.m_discount_node2 = ccbNode:nodeForName("discount_node2")
    self.m_discount_node3 = ccbNode:nodeForName("discount_node3")
    self.m_discount_node4 = ccbNode:nodeForName("discount_node4")
	self.m_btn_back:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 2)
	m_btn1:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 2)
	m_btn2:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 2)
	m_btn3:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 2)
	m_btn4:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 2)
    self.m_buy_btn1:setTouchPriority(GLOBAL_TOUCH_PRIORITY -6)
    self.m_buy_btn2:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)
	local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;
        elseif eventType == "ended" then
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-1,true);
    self.m_root_layer:setTouchEnabled(true);
    local function onTouch2(eventType, x, y)
        if eventType == "began" then
            return true;
        elseif eventType == "ended" then
            self:refreshBtn(false)
        end
    end
    self.m_buy_layer:registerScriptTouchHandler(onTouch2,false,GLOBAL_TOUCH_PRIORITY-5,true);
    self.m_buy_layer:setTouchEnabled(false);
	return ccbNode
end



--[[刷新按钮]]
function ui_fire_board_pop:refreshBtn( flag )
    self.m_btn_node:setVisible(flag)
    self.m_buy_layer:setTouchEnabled(flag);
    self.m_buy_btn1:setVisible(flag)
    self.m_buy_btn2:setVisible(flag)
    self.m_rich_lb1:setString(10*self.m_cost .. "Xu")
    self.m_rich_lb2:setString((60 - self.m_open_count)*self.m_cost .. "Xu")
end



--[[设置]]
function ui_fire_board_pop:setCoinRich()
    local fire_shopcfg = getConfig(game_config_field.fire_shop)
    local fire_shopconfig = json.decode(fire_shopcfg:getFormatBuffer()) 
    local viewSize = self.m_progress_node:getContentSize()
    local ccpX1,ccpX2,ccpX3,ccpX4
    for i=1,game_util:getTableLen(fire_shopconfig) do
        local v = fire_shopconfig[tostring(i)]
        if v.selloff == 90 and v.type == 1 then
            self.m_count_1:setString(v.num)
            ccpX1 = v.num
        elseif v.selloff == 80 and v.type == 1 then
            self.m_count_2:setString(v.num)
            ccpX2 = v.num
        elseif v.selloff == 70 and v.type == 1 then
            self.m_count_3:setString(v.num)
            ccpX3 = v.num
        elseif v.selloff == 60 and v.type == 1 then
            self.m_count_4:setString(v.num)
            ccpX4 = v.num
        elseif v.selloff == 100 and v.type == -1 then
            self.m_first_fire = v.num
            self.m_discount_node1:setPositionX(viewSize.width*(ccpX1/self.m_first_fire))
            self.m_discount_node2:setPositionX(viewSize.width*(ccpX2/self.m_first_fire))
            self.m_discount_node3:setPositionX(viewSize.width*(ccpX3/self.m_first_fire))
            self.m_discount_node4:setPositionX(viewSize.width*(ccpX4/self.m_first_fire))
            return
        end
    end

end


--[[获取item]]
function ui_fire_board_pop:getRewardById(id)
    local item = self.m_shop_reward[id]
    if item then
        local icon,name,count = game_util:getRewardByItemTable(item)
        if icon then
            return icon,name,count
        else
            return nil,nil,nil
        end
    end
end


--[[刷新按钮刷新列表]]
function ui_fire_board_pop:refreshRewardList(free)
    local function responseMethod( tag,gameData )
        if gameData and tolua.type(gameData) == "util_json" then
            local data = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {}
            self.list = data.shop_reward
            -- self.m_free_fresh_times = data.free_fresh_times
            self.m_rewards_node:removeAllChildrenWithCleanup(true)
            self:createTableView(self.m_rewards_node:getContentSize())
        end
    end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("fire_chess_refresh_shop"), http_request_method.GET, {isfree = free},"fire_chess_refresh_shop")
end


--[[创建列表]]
function ui_fire_board_pop:createTableView(viewSize)
    if not self.list then return end 
    local function onCellBtnClick( target,event )      
    end
    local itemSize = CCSizeMake(viewSize.width/10,viewSize.height/6);
    local index = 0
    for i=1,6 do
    	for j=1,10 do
    		index = index + 1
    		local ccbNode = luaCCBNode:create();
            ccbNode:registerFunctionWithFuncName("onCellBtnClick",onCellBtnClick);
            ccbNode:setAnchorPoint(ccp(0.5,0.5))
            ccbNode:setPosition(ccp(itemSize.width*(j - 0.5),itemSize.height*(6 - i + 0.5)));
            self.m_rewards_node:addChild(ccbNode,10,10);
            local item = self.list[index]
            if item then
                local icon,name,count = game_util:getRewardByItemTable(item)
                if icon then
                    icon:setScale(0.52)
                    ccbNode:addChild(icon)
                    local item_lab = game_util:createLabelTTF({text = "×" .. count , color = ccc3(255,255,255),fontSize = 12})
                    if item_lab then
                        icon:addChild(item_lab,10)
                        item_lab:setAnchorPoint(ccp(1,0.5))
                        item_lab:setPosition(ccp(40,7))
                    end
                end
            end
    	end
    end
end



--[[创建列表]]
function ui_fire_board_pop:createTableView1(viewSize)
    local SelectTab = {}
    local function onCellBtnClick( target,event )
    end
    self.m_open_count = 0
    local itemSize = CCSizeMake(viewSize.width/10,viewSize.height/6);
    local index = 0
    for i=1,6 do
        for j=1,10 do
            index = index + 1
            local ccbNode = luaCCBNode:create();
            ccbNode:registerFunctionWithFuncName("onCellBtnClick",onCellBtnClick);
            ccbNode:setAnchorPoint(ccp(0.5,0.5))
            ccbNode:setPosition(ccp(itemSize.width*(j - 0.5),itemSize.height*(6 - i + 0.5)));
            self.m_rewards_node:addChild(ccbNode,10,10);
            SelectTab[index] = ccbNode
            local isOpen = self.m_open_list[index]
            if self.m_open_list[index] then
                local item = self.m_shop_reward[index]
                local icon,name,count = game_util:getRewardByItemTable(item)
                if icon then
                    self.m_open_count = self.m_open_count + 1
                    icon:setScale(0.52)
                    ccbNode:addChild(icon)
                    local item_lab = game_util:createLabelTTF({text = "×" .. count , color = ccc3(255,255,255),fontSize = 12})
                    if item_lab then
                        icon:addChild(item_lab,10)
                        item_lab:setAnchorPoint(ccp(1,0.5))
                        item_lab:setPosition(ccp(40,7))
                    end
                end
            else
                local bossImg
                if i%2 == 0 then
                    if j%2 ~= 0 then
                        bossImg = CCSprite:createWithSpriteFrameName("ui_fired_grid1.png")
                    else
                        bossImg = CCSprite:createWithSpriteFrameName("ui_fired_grid2.png")
                    end
                else
                    if j%2 ~= 0 then
                        bossImg = CCSprite:createWithSpriteFrameName("ui_fired_grid2.png")
                    else
                        bossImg = CCSprite:createWithSpriteFrameName("ui_fired_grid1.png")
                    end
                end
                local function onBtnClick( event, target  )
                    local tagNode = tolua.cast(target, "CCNode");
                    local btnTag = tagNode:getTag();
                    local parent_node = SelectTab[btnTag]
                    local function responseMethod( tag,gameData )
                        if gameData and tolua.type(gameData) == "util_json" then
                            self:refreshData(gameData)

                            local icon,name,count = self:getRewardById(btnTag)
                            if icon and parent_node then
                                self.m_open_count = self.m_open_count + 1
                                icon:setScale(0.52)
                                parent_node:removeAllChildrenWithCleanup(true)
                                parent_node:addChild(icon,10)
                                local item_lab = game_util:createLabelTTF({text = "×" .. count , color = ccc3(255,255,255),fontSize = 12})
                                if item_lab then
                                    icon:addChild(item_lab,10)
                                    item_lab:setAnchorPoint(ccp(1,0.5))
                                    item_lab:setPosition(ccp(40,7))
                                end
                            end
                        end
                    end
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("fire_chess_choice_reward"), http_request_method.GET, {choice_num = btnTag},"fire_chess_choice_reward")
                end 
                local button = game_util:createCCControlButton("ui_fired_grid1.png","",onBtnClick)
                button:setTag(index)
                button:setOpacity(0)
                button:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 4)
                bossImg:setScale(1)
                ccbNode:addChild(button)
                ccbNode:addChild(bossImg,10)
            end
        end
    end
end


--[[创建进度条和卡牌特效]]

function ui_fire_board_pop:createBroadCastMsg()
    local m_iAnim_xiaohuo = game_util:createBlenderAnim("xiaohuo",1,true);
    local function onAnimSectionEnd3(animNode, theId,theLabelName)
        animNode:playSection(theLabelName)
    end
    m_iAnim_xiaohuo:registerScriptTapHandler(onAnimSectionEnd3)
    m_iAnim_xiaohuo:setPosition(ccp(0,5))
    self.m_xiaohuo_node:addChild(m_iAnim_xiaohuo)
    game_anim:playSection(m_iAnim_xiaohuo , "impact");

    local ccbNode = game_util:createHeroListItemByCCB();
    if ccbNode then
   		self.m_card_node:addChild(ccbNode)
        local m_totalnum_lab1 = ccbNode:labelTTFForName("m_totalnum_lab1")
        local m_totalnum_lab2 = ccbNode:labelTTFForName("m_totalnum_lab2")
        local m_spr_bg_up = ccbNode:spriteForName("m_spr_bg_up");
        self:setGodHeroListItemInfoByTable(ccbNode);
   	end

    self.bar = ExtProgressTime:createWithFrameName("ui_fired_progress2.png","ui_fired_progress1.png");
    self.bar:setScaleX(1);
    if self.m_tGameData.all_count > self.m_first_fire then
        self.isChange = false
        self.bar:setMaxValue(self.m_first_fire)
        self.bar:setCurValue(self.m_first_fire,false); 
    else
        self.isChange = true
        self.bar:setMaxValue(self.m_tGameData.all_count)
        self.bar:setCurValue(self.m_tGameData.all_buy_times,false);
    end
    self.bar:setAnchorPoint(ccp(0.5,0.5))
    self.bar:setPosition(ccp(125,10))
    self.m_progress_node:addChild(self.bar,10)

end


--[[刷新进度条]]
function ui_fire_board_pop:refreshProgressTime(times)
    if self.isChange then
        if times > self.m_first_fire then
            self.bar:setCurValue(self.m_first_fire)
        else
            self.bar:setCurValue(times,false);
        end
    end
end

--[[创建卡牌]]
function ui_fire_board_pop:setGodHeroListItemInfoByTable(ccbNode)
    local itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(tostring(self.m_tGameData.daily_limite_reward_show[1][2]));
    if itemConfig then
        ccbNode:nodeForName("m_info_node"):setVisible(true);
    else
        ccbNode:nodeForName("m_info_node"):setVisible(false);
        return
    end
    tolua.cast(ccbNode:objectForName("m_level_label"),"CCLabelBMFont"):setVisible(false)
    local m_name_label = ccbNode:labelTTFForName("m_name_label");
    m_name_label:setString(itemConfig:getNodeWithKey("name"):toStr());
    local quality = itemConfig:getNodeWithKey("quality"):toInt();
    local super_quality_1 = quality or 0
    local hero_quality_item = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
    if hero_quality_item then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(hero_quality_item.card_img));
    end
    local animation = itemConfig:getNodeWithKey("animation"):toStr();
    local rgb = itemConfig:getNodeWithKey("rgb_sort"):toInt();

    local m_anim_node = tolua.cast(ccbNode:objectForName("m_anim_node"),"CCNode");
    m_anim_node:removeAllChildrenWithCleanup(true);
    local animNode = game_util:createImgByName("image_" .. animation,rgb,nil,nil,0,itemConfig)
    if animNode then
        local animNodeSize = animNode:getContentSize();
        animNode:setAnchorPoint(ccp(0.5,0));
        m_anim_node:addChild(animNode);
    end
    ccbNode:spriteForName("m_sel_img"):setVisible(false)
    ccbNode:spriteForName("m_team_img"):setVisible(false);
    --ccbNode:spriteForName("m_godTemple_img"):setVisible(false)
    ccbNode:spriteForName("m_lock_img"):setVisible(false);
    ccbNode:spriteForName("m_perfect_img"):setVisible(false);
    local bre = math.min(0,10)
    local tempSpriteFrame = nil;
    if bre > 5 then
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_moon_icon.png")
        bre = bre - 5
    else
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_equip_star.png")
    end
    for i=1,5 do
        local m_star_icon = ccbNode:spriteForName("m_star_icon_" .. i)
        m_star_icon:setVisible(false);
    end

    local m_occupation_icon = ccbNode:spriteForName("m_occupation_icon")
    local occupation_cfg = getConfig(game_config_field.occupation);
    local occupation_item_cfg = occupation_cfg:getNodeWithKey(animation)
    if occupation_item_cfg then
        local occupationType = occupation_item_cfg:toInt();
        local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
        if spriteFrame then
            m_occupation_icon:setDisplayFrame(spriteFrame);
        else
            m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
        end
    else
        m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    end
    local m_occupation_icon_bg = ccbNode:spriteForName("m_occupation_icon_bg")
    local spriteFrame = super_quality_1 > 0 and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg_2.png") or CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg.png")
    if m_occupation_icon_bg and spriteFrame then
        m_occupation_icon_bg:setDisplayFrame(spriteFrame);
    end
end

--[[刷新Ui]]
function ui_fire_board_pop:refreshUi()
    self:setCoinRich()
    if self.m_tGameData.is_shuffle == 0 then
        -- self:refreshRewardList(1)
        self.list = self.m_tGameData.shop_reward
        self.m_rewards_node:removeAllChildrenWithCleanup(true)
        self:createTableView(self.m_rewards_node:getContentSize())
    elseif self.m_tGameData.is_shuffle == 1 then
        self.m_rewards_node:removeAllChildrenWithCleanup(true)
        self:createTableView1(self.m_rewards_node:getContentSize())
    end
    self.m_my_ach:setString(self.m_tGameData.buy_times)
    self.m_my_remain_times:setString(self.m_tGameData.remain_times.."/"..json.decode(getConfig(game_config_field.fire_reward):getNodeWithKey(tostring(self.m_tGameData.version)):getNodeWithKey("limite_reward_num"):getFormatBuffer())[1][4])
    self.m_all_buy_count = self.m_tGameData.all_buy_times or 0
    self.m_all_ach:setString(self.m_tGameData.all_buy_times .. "/" .. self.m_tGameData.all_count)
 	self.active_time:setString("Mua 1 lần tốn " .. self.m_cost .. "Xu")
    self:createBroadCastMsg()
    self:createFire()
end

--[[创建火焰特效]]
function ui_fire_board_pop:createFire()
    if self.isfire == 0 then
        self.m_fire_node:removeAllChildrenWithCleanup(true)
        self.m_fire = false
        return
    end
    if self.m_fire then return end

    self.m_iAnim_biankuanghuoyan = game_util:createBlenderAnim("biankuanghuoyan",1,true);
    self.m_iAnim_dahuo = game_util:createBlenderAnim("dahuo",1,true);

    local function onAnimSectionEnd1(animNode, theId,theLabelName)
        animNode:playSection(theLabelName)
    end

    local function onAnimSectionEnd2(animNode, theId,theLabelName)
        self.m_bigfire_node:removeAllChildrenWithCleanup(true)
    end

    self.m_iAnim_biankuanghuoyan:registerScriptTapHandler(onAnimSectionEnd1)
    self.m_iAnim_biankuanghuoyan:setPosition(ccp(0,0))
    self.m_fire_node:addChild(self.m_iAnim_biankuanghuoyan)
    self.m_iAnim_dahuo:registerScriptTapHandler(onAnimSectionEnd2)
    self.m_iAnim_dahuo:setPosition(ccp(0,0))
    self.m_bigfire_node:addChild(self.m_iAnim_dahuo)

    if self.isfire ~= 0 and not self.m_fire then
        self.m_fire = true
        game_anim:playSection(self.m_iAnim_biankuanghuoyan , "impact");
        game_anim:playSection(self.m_iAnim_dahuo , "impact"); 
    end
end

--[[刷新data信息]]
function ui_fire_board_pop:refreshData(gameData)
    if gameData and tolua.type(gameData) == "util_json" then
        local data = gameData:getNodeWithKey("data")
        self.m_data = json.decode(data:getFormatBuffer()) or {};
    end
    -- self.m_free_fresh_times = self.m_data.free_fresh_times
    self.isfire = self.m_data.isfire
    self.m_cost = self.m_data.cost
    self:createFire()
    local shop_reward_open = self.m_data.shop_reward_open
    self.m_my_ach:setString(self.m_data.buy_times)
    self.m_all_buy_count = self.m_data.all_buy_times or 0
    self.m_all_ach:setString(self.m_data.all_buy_times .. "/" .. self.m_data.all_count)
    self:refreshProgressTime(self.m_data.all_buy_times)
    self.m_my_remain_times:setString(self.m_tGameData.remain_times.."/"..json.decode(getConfig(game_config_field.fire_reward):getNodeWithKey(tostring(self.m_tGameData.version)):getNodeWithKey("limite_reward_num"):getFormatBuffer())[1][4])
    self.active_time:setString("Mua 1 lần tốn " .. self.m_cost .. "Xu")
    self.m_shop_reward = self.m_data.shop_reward
end


function ui_fire_board_pop:init(t_params)
    if t_params.gameData and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
    end
    local shop_reward_open = self.m_tGameData.shop_reward_open
    self.m_shop_reward = self.m_tGameData.shop_reward
    self.m_open_list = {}
    self.m_version = self.m_tGameData.version
    for k,v in pairs(shop_reward_open) do
        self.m_open_list[v] = v
    end
    self.m_free_fresh_times = self.m_tGameData.free_fresh_times or 0
    self.m_open_count = 0
    self.isfire = self.m_tGameData.isfire
    self.m_cost = self.m_tGameData.cost
    self.m_fire = false
    self.isChange = true
    self.m_all_buy_count = self.m_tGameData.all_buy_times or 0
end


function ui_fire_board_pop:create(t_params)
	self:init(t_params)
	local scene = CCScene:create()
	scene:addChild(self:createUi())
	self:refreshUi()
	return scene
end

return ui_fire_board_pop   �{  