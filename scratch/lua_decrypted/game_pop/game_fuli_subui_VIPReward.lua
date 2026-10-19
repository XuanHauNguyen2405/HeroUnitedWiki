---  
local game_fuli_subui_VIPReward = {
	m_reward_node = nil,
	m_vip_node = nil, 
	m_reward_sp1 = nil,
	m_reward_sp2 = nil,
	m_conbtn_right = nil,
	m_conbtn_left = nil,
	m_getReward_btn = nil,
	m_select_index = nil,
	m_cur_selectcell = nil,
	m_tGameData = nil,
	m_vip_level = nil,
	m_vip_reward = nil,
	m_everyDayCount_lab1 = nil,
	m_everyDayCount_lab2 = nil,
	sign_record = nil,
	m_first_index = nil,
	is_every_day = nil,
	m_redPoint_tab = nil,
	m_temp_index = nil,
	m_cellSize = nil,
	m_tableview = nil,
	m_params = nil,
}

--[[--
    销毁ui
]]
function game_fuli_subui_VIPReward.destroy(self)
	self.m_reward_node = nil;
	self.m_vip_node = nil;
	self.m_reward_sp1 = nil;
	self.m_reward_sp2 = nil;
	self.m_conbtn_right = nil;
	self.m_conbtn_left = nil;
	self.m_getReward_btn = nil;
	self.m_select_index = nil;
	self.m_cur_selectcell = nil;
	self.m_tGameData = nil;
	self.m_vip_level = nil;
	self.m_vip_reward = nil;
	self.m_everyDayCount_lab1 = nil;
	self.m_everyDayCount_lab2 = nil;
	self.sign_record = nil;
	self.m_first_index = nil;
	self.is_every_day = nil;
	self.m_redPoint_tab = nil;
	self.m_temp_index = nil;
	self.m_cellSize = nil;
	self.m_tableview = nil;
	self.m_params = nil;
    -- body
    cclog("----------------- game_fuli_subui_peak_arena destroy-----------------"); 
end
--[[--
    返回
]]
function game_fuli_subui_VIPReward.back(self,backType)
    self:destroy();
end
--[[--
    读取ccbi创建ui
]]
function game_fuli_subui_VIPReward.createUi(self)
	local ccbNode = luaCCBNode:create();
	local function onMainBtnClick( target,event )
		local tagNode = tolua.cast(target, "CCNode");
		local btnTag = tagNode:getTag();
		if btnTag == 103 then
			local function responseMethod( tag,gameData )
				local data = gameData:getNodeWithKey("data")
				local reward = data:getNodeWithKey("reward")
				-- local every_day = data:getNodeWithKey("is_every_day")
				data = json.decode(data:getFormatBuffer())
				self.m_tGameData = data
				self.is_every_day = data.is_every_day
				self:refreshUi()
				if self.is_every_day == false then
					game_util:setCCControlButtonBackground(self.m_getReward_btn,"VipReward_alredy.png")
				end
				-- self.sign_record = data:getNodeWithKey("sign_record")
				-- self.sign_record = json.decode(self.sign_record:getFormatBuffer())
				game_util:rewardTipsByJsonData(reward);
				-- body
			end
			network.sendHttpRequest(responseMethod,game_url.getUrlForKey("vip_reward_every_day"), http_request_method.GET, nil,"vip_reward_every_day")
		elseif btnTag == 102 then -- 右边按钮
		    local size = self.m_tableview:getViewSize()
		    local curOffset = self.m_tableview:getContentOffset()
		    local width = 7 * self.m_cellSize.width 
		    if curOffset.x > -1 * (width - size.width) then
		        self.m_tableview:setContentOffset(ccp(  math.max(curOffset.x - self.m_cellSize.width, -1 * (width - size.width))  , 0), true);
		    end
		elseif btnTag == 101 then -- 左边按钮
		    local size = self.m_tableview:getViewSize()
		    local curOffset = self.m_tableview:getContentOffset()
		    local width = 7 * self.m_cellSize.width
		    if curOffset.x < 0 then
		        self.m_tableview:setContentOffset(ccp(  math.min(curOffset.x + self.m_cellSize.width, 0), 0), true);
		    end
		end
	end
	ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
	ccbNode:openCCBFile("ccb/ui_fuli_content_VipReward.ccbi");
	self.m_reward_node = ccbNode:nodeForName("m_reward_node");
	self.m_vip_node = ccbNode:nodeForName("m_vip_node");
	self.m_reward_sp1 = ccbNode:nodeForName("m_reward_sp1");
	self.m_reward_sp2 = ccbNode:nodeForName("m_reward_sp2");
	self.m_conbtn_right = ccbNode:controlButtonForName("m_conbtn_right")
	self.m_conbtn_left = ccbNode:controlButtonForName("m_conbtn_left")
	self.m_getReward_btn = ccbNode:controlButtonForName("m_getReward_btn")
	self.m_everyDayCount_lab1 = ccbNode:labelTTFForName("m_everyDayCount_lab1");
	self.m_everyDayCount_lab2 = ccbNode:labelTTFForName("m_everyDayCount_lab2");
	-- self.m_getReward_btn:setVisible(false)
	self.m_conbtn_right:setTouchPriority(GLOBAL_TOUCH_PRIORITY-6)
	self.m_conbtn_left:setTouchPriority(GLOBAL_TOUCH_PRIORITY-6)
	self.m_getReward_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-6)


	return ccbNode;
end
--[[--
	创建左侧vip等级按钮
]]
function game_fuli_subui_VIPReward.createLeftBtn( self,viewSize,m_vip_level )
	-- setTableViewIndex
	local totalItem = 16
	local params = {};
	local viewSize = viewSize
	params.viewSize = viewSize;
	params.row = 7;--行
	params.column = 1; --列
	params.totalItem = totalItem;
	params.touchPriority = GLOBAL_TOUCH_PRIORITY-5;
	params.direction = kCCScrollViewDirectionVertical
	local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
	params.newCell = function(tableView,index) 
	    local cell = tableView:dequeueCell()
	    if cell == nil then
	        cell = CCTableViewCell:new()
	        cell:autorelease()
	        local ccbNode = luaCCBNode:create();
	        ccbNode:openCCBFile("ccb/ui_fuli_content_VipReward_vipItem.ccbi")       
	        ccbNode:setPosition(ccp(itemSize.width*0,itemSize.height*0));
	        cell:addChild(ccbNode,10,10);
	    end
	    if cell then
	    	local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
	    	local m_vip_sp = ccbNode:spriteForName("m_vip_sp")
	    	local m_vip_sp1 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("VipReward_VIP" .. index+1 .. ".png")
	    	local m_hongdian_sp = ccbNode:spriteForName("m_hongdian_sp")
	    	m_hongdian_sp:setVisible(false)
	    	if index + 1 == self.m_vip_level and self.is_every_day == true then
	    		-- cclog("1111")
	    		m_hongdian_sp:setVisible(true)
	    	elseif self.m_tGameData.sign_record[tostring(index+1)] and self.m_tGameData.sign_record[tostring(index+1)].flag == true then
	    		-- cclog("2222")
	    		m_hongdian_sp:setVisible(true)
	    	else
	    		m_hongdian_sp:setVisible(false)
	    	end

	    	--cclog2(m_hongdian_sp:isVisible(),"hogndian---" .. index + 1)
	  		m_vip_sp:setDisplayFrame(m_vip_sp1)
	  		local m_select_sp = ccbNode:spriteForName("m_select_sp")
	    	if self.m_select_index == index then
	    		m_select_sp:setVisible(true)
	    		self.m_cur_selectcell = cell
	    		if index + 1 == self.m_vip_level then
		    		self.m_getReward_btn:setVisible(true)--设置每日奖励的a

		    		if self.is_every_day == false  then
		    			game_util:setCCControlButtonBackground(self.m_getReward_btn,"VipReward_alredy.png")
		    			if self.m_tGameData.sign_record[tostring(index+1)] and self.m_tGameData.sign_record[tostring(index+1)].flag == false then
		    				m_hongdian_sp:setVisible(false)
		    			else
		    				m_hongdian_sp:setVisible(true)
		    			end
		    		else
		    			m_hongdian_sp:setVisible(true)
		    		end
		    	end
		    	if self.m_params.vip == 0 then
		    		m_hongdian_sp:setVisible(false)
		    	end
	    	else
	    		m_select_sp:setVisible(false)
	    	end
	    	self.m_redPoint_tab[index+1] = m_hongdian_sp

	    end
	    return cell;
	end
	params.itemOnClick = function(eventType,index,item)
	    if index >= totalItem then return end;
	    if eventType == "ended" and item then
	    	if self.m_cur_selectcell then
	    		-- cclog("-----1------")
	    		local ccbNode = tolua.cast(self.m_cur_selectcell:getChildByTag(10),"luaCCBNode") 
	    		local m_select_sp = ccbNode:spriteForName("m_select_sp")
	    		m_select_sp:setVisible(false)
	    	end
	    	self.m_first_index = nil
	    	self.m_select_index = index
	    	local ccbNode = tolua.cast(item:getChildByTag(10),"luaCCBNode")  
	    	local m_select_sp = ccbNode:spriteForName("m_select_sp")
	    	self.m_cur_selectcell = item
	    	m_select_sp:setVisible(true)
	    	self:selectVIPBtn(item,index)
	    	self:refreshUi2()
	    end
	end
	return TableViewHelper:create(params);
	-- body
end
--[[--
	设置vip按钮选择状态
]]
function game_fuli_subui_VIPReward.selectVIPBtn( self,cell,index)
	-- --if index == self.m_select_index then return end
	-- cclog2(self.m_vip_level,"m_vip_level === ")
	-- cclog2(index+1,"index + 1====")
	if index +1 == self.m_vip_level then
		self.m_getReward_btn:setVisible(true)--设置每日奖励的a
		if self.is_every_day == false then
			game_util:setCCControlButtonBackground(self.m_getReward_btn,"VipReward_alredy.png")
		end
	else
		self.m_getReward_btn:setVisible(false)
	end
end
--[[--
	创建中间奖励
]]
function game_fuli_subui_VIPReward.createMidReward( self,viewSize )
	cclog("--------------createMidReward------------")
	local function onMainBtnClick( target,event )
		local tagNode = tolua.cast(target, "CCNode");
		local btnTag = tagNode:getTag();
		if btnTag == -101 then
			 game_util:addMoveTips({text = "Hiện chưa thể nhận"});
		elseif btnTag == -102 then
			game_util:addMoveTips({text = "Bạn đã nhận quà này rồi"})
		else
			self:getVipLevelReward(btnTag)
		end
	end
	self.m_reward_node:removeAllChildrenWithCleanup(true);
	local totalItem = 7
	local params = {};
	local viewSize = viewSize
	params.viewSize = viewSize;
	params.row = 1;--行
	params.column = 4; --列
	params.totalItem = totalItem;
	params.touchPriority = GLOBAL_TOUCH_PRIORITY-5;
	params.direction = kCCScrollViewDirectionHorizontal
	local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
	self.m_cellSize = itemSize
	params.newCell = function(tableView,index) 
	    local cell = tableView:dequeueCell()
	    if cell == nil then
	        cell = CCTableViewCell:new()
	        cell:autorelease()
	        local ccbNode = luaCCBNode:create();
	        ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
	        ccbNode:openCCBFile("ccb/ui_fuli_content_VipReward_rewardItem.ccbi")
	        ccbNode:setPosition(ccp(itemSize.width*0.2,itemSize.height*0.3));
	        cell:addChild(ccbNode,10,10);
	    end
	    if cell then
    	  	local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
    	  	local m_dayily_sp = ccbNode:spriteForName("m_dayily_sp")
    	  	local m_dayily_sp1 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("VipReward_day" .. index+1 .. ".png")
    		m_dayily_sp:setDisplayFrame(m_dayily_sp1)
    		local m_conbtn_getres = ccbNode:controlButtonForName("m_conbtn_getres")
    		m_conbtn_getres:setTag(index+1)
    		m_conbtn_getres:setTouchPriority(GLOBAL_TOUCH_PRIORITY-100)
    		local sign_dayNum = nil
    		local sign_dayFlag = nil
			if self.sign_record[tostring(self.m_select_index+1)] then
				sign_dayNum = self.sign_record[tostring(self.m_select_index+1)].day
				sign_dayFlag = self.sign_record[tostring(self.m_select_index+1)].flag
				if sign_dayFlag == true then  --今天可以领取
					if  index < sign_dayNum  then
						m_conbtn_getres:setTitleForState(CCString:create("Đã nhận"),1)
						m_conbtn_getres:setColor(ccc3(150,150,150))
						m_conbtn_getres:setTag(-102)
					elseif index == sign_dayNum  then
						m_conbtn_getres:setTitleForState(CCString:create("Nhận"),1)
						m_conbtn_getres:setColor(ccc3(255,255,255))
					else
						-- cclog("-----1------")
						m_conbtn_getres:setTitleForState(CCString:create("Nhận"),1)
						m_conbtn_getres:setColor(ccc3(150,150,150))
						m_conbtn_getres:setTag(-101)
					end
				else-- 今天已经领过了
					if index <= sign_dayNum -1 then
						m_conbtn_getres:setTitleForState(CCString:create("Đã nhận"),1)
						m_conbtn_getres:setColor(ccc3(150,150,150))
						m_conbtn_getres:setTag(-102)
					else
						-- cclog("-----2------")
						m_conbtn_getres:setTitleForState(CCString:create("Nhận"),1)
						m_conbtn_getres:setColor(ccc3(150,150,150))
						m_conbtn_getres:setTag(-101)
					end
				
				end
			else
				-- cclog("-----3------")
				m_conbtn_getres:setTitleForState(CCString:create("Nhận"),1)
				m_conbtn_getres:setColor(ccc3(150,150,150))
				m_conbtn_getres:setTag(-101)
			end
    		local m_reward_sp = ccbNode:nodeForName("m_reward_sp")
    		local m_count_label = ccbNode:labelTTFForName("m_count_label")
    		local reward = {}
    		if next(self.m_vip_reward) then
    			reward = self.m_vip_reward["day" .. index+1]
    			local icon,name,count = game_util:getRewardByItemTable(reward[1])
    			if icon then
    				icon:setScale(0.8)
    				m_reward_sp:addChild(icon)
    				m_reward_sp:setVisible(true)
    				m_count_label:setString(name .. "x" .. count)
    			end
    		end
	    end
	    return cell;
	end
	params.itemOnClick = function(eventType,index,item)
	    if index >= totalItem then return end;
	    if eventType == "ended" and item then
	    	local reward = {}
	    	reward = self.m_vip_reward["day" .. index+1]
	    	local info = reward[1]
	    	local tempType = info[1]
	    	if tempType == 6 then--道具
	    	    local itemId = info[2]
	    	    game_scene:addPop("game_item_info_pop",{itemId = itemId,openType = 2})
	    	elseif tempType == 7 then--装备
	    	    local equipId = info[2]
	    	    local equipData = {lv = 1,c_id = equipId,id = -1,pos = -1}
	    	    game_scene:addPop("game_equip_info_pop",{tGameData = equipData});
	    	elseif tempType == 5 then--卡牌
	    	    local cId = info[2]
	    	    game_scene:addPop("game_hero_info_pop",{cId = tostring(cId),openType = 4})
	    	else                   -- 食品
	    	    game_scene:addPop("game_food_info_pop",{itemData = info})
	    	 end
	    end
	end
	return TableViewHelper:create(params);
	-- body
end

--[[--
	创建每日福利的奖励
]]
function game_fuli_subui_VIPReward.createEveryDayReward( self )
	self.m_reward_sp1:removeAllChildrenWithCleanup(true)
	self.m_reward_sp2:removeAllChildrenWithCleanup(true)
	self.m_everyDayCount_lab1:setString("")
	self.m_everyDayCount_lab2:setString("") 
	local reward1 = {}
	local reward2 = {}
	if next(self.m_vip_reward) then
		reward1 = self.m_vip_reward["everyday"][1]
		reward2 = self.m_vip_reward["everyday"][2]
		-- cclog2(reward1,"reward1 === ")
		local icon1,name,count1 = game_util:getRewardByItemTable(reward1)
		local icon2,name,count2 = game_util:getRewardByItemTable(reward2)
		if icon1 and icon2 then
			icon1:setScale(0.7)
			icon2:setScale(0.7)
			self.m_reward_sp1:addChild(icon1)
			self.m_reward_sp2:addChild(icon2)
			self.m_everyDayCount_lab1:setString(count1)
			self.m_everyDayCount_lab2:setString(count2) 
			local info1 = reward1
			local info2 = reward2
			local function onBtnClick( event, target  )
			    local tagNode = tolua.cast(target, "CCNode");
			    local btnTag = tagNode:getTag();
			    print("press button tag is ", btnTag)
			    if btnTag == 1 then
			    	local tempType = info1[1]
			    	if tempType == 6 then--道具
			    	    local itemId = info1[2]
			    	    game_scene:addPop("game_item_info_pop",{itemId = itemId,openType = 2})
			    	elseif tempType == 7 then--装备
			    	    local equipId = info1[2]
			    	    local equipData = {lv = 1,c_id = equipId,id = -1,pos = -1}
			    	    game_scene:addPop("game_equip_info_pop",{tGameData = equipData});
			    	elseif tempType == 5 then--卡牌
			    	    local cId = info1[2]
			    	    game_scene:addPop("game_hero_info_pop",{cId = tostring(cId),openType = 4})
			    	else                   -- 食品
			    	    game_scene:addPop("game_food_info_pop",{itemData = info1})
			    	 end
			    elseif btnTag == 2 then
			    	local tempType = info2[1]
			    	if tempType == 6 then--道具
			    	    local itemId = info2[2]
			    	    game_scene:addPop("game_item_info_pop",{itemId = itemId,openType = 2})
			    	elseif tempType == 7 then--装备
			    	    local equipId = info2[2]
			    	    local equipData = {lv = 1,c_id = equipId,id = -1,pos = -1}
			    	    game_scene:addPop("game_equip_info_pop",{tGameData = equipData});
			    	elseif tempType == 5 then--卡牌
			    	    local cId = info2[2]
			    	    game_scene:addPop("game_hero_info_pop",{cId = tostring(cId),openType = 4})
			    	else                   -- 食品
			    	    game_scene:addPop("game_food_info_pop",{itemData = info2})
			    	 end
			    end

			end 
			local button = game_util:createCCControlButton("public_weapon.png","",onBtnClick)
			button:setAnchorPoint(ccp(0.5,0.5))
			button:setPosition( icon1:getContentSize().width * 0.5, icon1:getContentSize().height * 0.5 )
			button:setOpacity(0)
			button:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 21)
			icon1:addChild(button)
			button:setTag( 1 )
			local button2 = game_util:createCCControlButton("public_weapon.png","",onBtnClick)
			button2:setAnchorPoint(ccp(0.5,0.5))
			button2:setPosition( icon2:getContentSize().width * 0.5, icon1:getContentSize().height * 0.5 )
			button2:setOpacity(0)
			button2:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 21)
			icon2:addChild(button2)
			button2:setTag( 2 )

		end
	end
	-- body
end
--[[--
	领取vip等级奖励
]]
function game_fuli_subui_VIPReward.getVipLevelReward( self,btnTag )
	if self.m_select_index then
		local function responseMethod(tag,gameData)
			if gameData then
				 local data = gameData:getNodeWithKey("data")
				 local reward = data:getNodeWithKey("reward")
				 self.sign_record = data:getNodeWithKey("sign_record")
				 self.sign_record = json.decode(self.sign_record:getFormatBuffer())
				 data = json.decode(data:getFormatBuffer())
				 self.m_tGameData = data
				 game_util:rewardTipsByJsonData(reward);
				 self:refreshUi()
			end
		end
		local params = {}
		if self.m_vip_level ==self.m_select_index then 
			params = nil
		else
			params.vip = self.m_select_index + 1
		end
		network.sendHttpRequest(responseMethod,game_url.getUrlForKey("vip_reward_vip_sign"), http_request_method.GET, params,"vip_reward_vip_sign")
	end
	-- body
end
--[[--
	获取vip奖励数据
]]
function game_fuli_subui_VIPReward.getVipRewardConfig( self,index )
	local new_vip_reward = getConfig(game_config_field.new_vip_reward)
	new_vip_reward = json.decode(new_vip_reward:getFormatBuffer())
	local vip_reward = new_vip_reward[tostring(index)]
	self.m_vip_reward = vip_reward
end
--[[--
    刷新ui
]]
function game_fuli_subui_VIPReward.refreshUi(self)
	self.m_vip_node:removeAllChildrenWithCleanup(true)
	if m_temp_index ~= nil then 
		self.m_vip_node:addChild(self:createLeftBtn(self.m_vip_node:getContentSize(),m_temp_index),10,10)
	else
		self.m_vip_node:addChild(self:createLeftBtn(self.m_vip_node:getContentSize(),self.m_vip_level),10,10)
	end
	-- cclog2(self.m_vip_level,"refreshUi ---self.m_vip_level")
	-- game_util:setTableViewIndex(self.m_vip_level-1,self.m_vip_node,10,7)
	if self.m_first_index ~= nil then
		game_util:setTableViewIndex(self.m_first_index,self.m_vip_node,10,7)
	else	
		game_util:setTableViewIndex(self.m_select_index,self.m_vip_node,10,7)
	end
	if self.m_vip_level -1 < 6 then
	    self.m_temp_index = 0
	end
	if self.m_vip_level -1 > 6 then
	    self.m_temp_index = 8
	end
	self.m_reward_node:addChild(self:createMidReward(self.m_reward_node:getContentSize()))
	self:createEveryDayReward()
	-- self:setRedPoint()
   	self:refreshUi2()
end
function game_fuli_subui_VIPReward.refreshUi2(self)
	self:getVipRewardConfig(self.m_select_index+1)
	self.m_reward_node:removeAllChildrenWithCleanup(true)
	self.m_tableview =self:createMidReward(self.m_reward_node:getContentSize())
	self.m_reward_node:addChild(self.m_tableview)
	self:createEveryDayReward()
end

--[[--
    初始化
]]
function game_fuli_subui_VIPReward.init(self,t_params)
    t_params = t_params or {};
    self.m_vip_reward = {}
    self.m_redPoint_tab = {}
    -- self.m_parentCloseBtn = t_params.parentCloseBtn
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local temp1 = json.decode(t_params.gameData:getNodeWithKey("data"):getFormatBuffer())
        local temp2 = json.decode(t_params.gameData:getNodeWithKey("user_status"):getFormatBuffer())
        self.m_tGameData = temp1
        self.m_params = temp2
        self.m_vip_level = temp2.vip 
        if self.m_vip_level == 0 then
        	self.m_vip_level = 1
        end
        self.sign_record = temp1.sign_record or {}
        self.is_every_day =temp1.is_every_day 
    end
	self:getVipRewardConfig(self.m_vip_level)
	self.m_select_index =  self.m_vip_level - 1
	self.m_first_index = self.m_vip_level - 1

end
--[[--
    创建ui入口并初始化数据
]]
function game_fuli_subui_VIPReward.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    return scene;
end

return game_fuli_subui_VIPReward �O