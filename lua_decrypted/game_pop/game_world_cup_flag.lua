local game_world_cup_flag = {
	time_node = nil,
	m_close_btn = nil,
	m_btn_rule = nil,
	m_btn_reward = nil,
	m_btn_yulan = nil,
	m_root_layer = nil,
	m_ccbNode = nil,
	m_list_view_bg = nil,
	m_tableView = nil,
	m_btn_left = nil,
	m_btn_right = nil,
    m_version = nil,
    m_showFlags = nil,
    m_flag_spriteChip = nil,
    m_select_index = nil,
    m_flag_light = nil,
    m_select_item = nil, 
    m_curPage = nil,
    m_select_index = nil,
    m_cellSize = nil,
    m_cellCount = nil,
    m_tGameData = nil,
    m_progress_node = nil,
    bar = nil,
}

function game_world_cup_flag:destroy(  )
	cclog("-----------------game_world_cup_flag destroy-----------------");
	self.time_node = nil;
	self.m_close_btn = nil;
	self.m_btn_rule = nil;
	self.m_btn_reward = nil;
	self.m_btn_yulan = nil;
	self.m_root_layer = nil;
	self.m_ccbNode = nil;
	self.m_list_view_bg = nil;
	self.m_tableView = nil;
	self.m_btn_left = nil;
	self.m_btn_right = nil;
    self.m_version = nil;
    self.m_showFlags = nil;
    self.m_flag_spriteChip = nil;
    self.m_select_index = nil;
    self.m_flag_light = nil;
    self.m_select_item = nil; 
    self.m_curPage = nil;
    self.m_select_index = nil;
    self.m_cellSize = nil;
    self.m_cellCount = nil;
    self.m_tGameData = nil;
    self.m_progress_node = nil;
    self.bar = nil;
end


function game_world_cup_flag:back(  )
	-- body
    game_scene:removePopByName("game_world_cup_flag");
end



function game_world_cup_flag:createUi(  )
	local ccbNode = luaCCBNode:create()
	local function onBtnClick( target,event )
		local tagNode = tolua.cast(target,"CCNode")
		local btnTag = tagNode:getTag()
        if btnTag == 1 then
        	self:back()
        elseif btnTag == 2 then
            game_scene:addPop("game_worldcup_flag_rule_pop",{version = self.m_version})
        elseif btnTag == 3 then
            if self.m_tGameData.can_get_big_reward then
            	local function responseMethod( tag,gameData )
                    local data = gameData:getNodeWithKey("data")
                    local reward = data:getNodeWithKey("reward")
                    game_util:rewardTipsByJsonData(reward);
            		self.m_tGameData = json.decode(data:getFormatBuffer()) or {}
			        self:refreshUi(true)
            	end
            	network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_cup_flag_get_big_reward"),http_request_method.GET,nil,"world_cup_flag_get_big_reward")
            else
            	local reward = self.m_showFlags[2].reward_big
    		    if reward then
				    game_util:lookItemDetal(reward[1])
    		    else
    			    game_util:addMoveTips({text = "Tải cấu hình thất bại!"})
    		    end
    		end
        elseif btnTag == 4 then
            game_scene:addPop("game_world_flags_collect",{version = self.m_version})
        elseif btnTag == 6 then -- 右边按钮
            local size = self.m_tableView:getChildByTag(10):getViewSize()
            local curOffset = self.m_tableView:getChildByTag(10):getContentOffset()
            local width = self.m_cellCount * self.m_cellSize.width
            if curOffset.x > -1 * (width - size.width) then
                self.m_tableView:getChildByTag(10):setContentOffset(ccp(  math.max(curOffset.x - self.m_cellSize.width * 5, -1 * (width - size.width))  , 0), true);
                self.m_curPage = self.m_curPage + 1
                self:refreshUi(true)
            end
        elseif btnTag == 5 then -- 左边按钮
            local size = self.m_tableView:getChildByTag(10):getViewSize()
            local curOffset = self.m_tableView:getChildByTag(10):getContentOffset()
            local width = self.m_cellCount * self.m_cellSize.width
            if curOffset.x < 0 then
                self.m_tableView:getChildByTag(10):setContentOffset(ccp(  math.min(curOffset.x + self.m_cellSize.width * 5, 0), 0), true);
                self.m_curPage = self.m_curPage - 1
                self:refreshUi(true)
            end
        end
	end
	ccbNode:registerFunctionWithFuncName("onMainBtnClick",onBtnClick)
	ccbNode:openCCBFile("ccb/ui_collet_flags.ccbi")
	self.time_node = ccbNode:nodeForName("time_node")
	self.m_close_btn = ccbNode:controlButtonForName("m_close_btn")
	self.m_btn_rule = ccbNode:controlButtonForName("m_btn_rule")
	self.m_btn_reward = ccbNode:controlButtonForName("m_btn_reward")
	self.m_btn_yulan = ccbNode:controlButtonForName("m_btn_yulan")
	self.m_btn_left = ccbNode:controlButtonForName("m_btn_left")
	self.m_btn_right = ccbNode:controlButtonForName("m_btn_right")
    self.m_progress_node = ccbNode:controlButtonForName("m_progress_node")
	self.m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
	self.m_btn_rule:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
	self.m_btn_reward:setTouchPriority(GLOBAL_TOUCH_PRIORITY-5)
	self.m_btn_yulan:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
	self.m_btn_left:setTouchPriority(GLOBAL_TOUCH_PRIORITY-6)
	self.m_btn_right:setTouchPriority(GLOBAL_TOUCH_PRIORITY-6)
	self.m_list_view_bg = ccbNode:nodeForName("m_list_view_bg");
	self.m_root_layer = ccbNode:layerForName("m_root_layer")
	local function onTouch( eventType,x,y )
		if eventType == "began" then
            return true;
        end
	end
	self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY - 1,true)
	self.m_root_layer:setTouchEnabled(true)
	self.m_ccbNode = ccbNode
	return ccbNode
end

function game_world_cup_flag:refreshLabel()
    local function timeEndFunc()
        
    end
    self.time_node:removeAllChildrenWithCleanup(true)
    local showActive = self.m_tGameData.remain_all
    local countdownLabel = game_util:createCountdownLabel(showActive,timeEndFunc,8,1);
    countdownLabel:setAnchorPoint(ccp(0,0.5))
    countdownLabel:setPosition(ccp(15,0))
    countdownLabel:setColor(ccc3(0,250,0))
    self.time_node:addChild(countdownLabel,10,10)
end

function game_world_cup_flag:refreshProgress(  )
    local maxValue = #self.m_showFlags
    local viewSize = self.m_progress_node:getContentSize()
    local percentage = 0/maxValue * 100 
    local barChangeRate = ccp(0,1)
    if not self.bar then
        -- self.bar = game_util:createProgressTimer({fileName = "ui_ouguan2.png",percentage = percentage,barChangeRate = barChangeRate})
        self.bar = game_util:createProgressTimer({fileName = "ui_dalishenbei2.png",percentage = percentage,barChangeRate = barChangeRate})
    end
    self.bar:setAnchorPoint(ccp(0.5,0.5))
    self.bar:setPosition(ccp(viewSize.width*0.5,90))
    -- self.bar:setCurValue(maxValue*0.5,true);

    self.m_progress_node:addChild(self.bar,10)
end

function game_world_cup_flag:createTableView( viewSize )
    self.m_flag_spriteChip = {} 
    local function onCellBtnClick( target,event )
        local tagNode = tolua.cast(target,"CCNode");
        local btnTag = tagNode:getTag();
        if btnTag > 1000 then
        	index = btnTag -1000
        	local ccbNode = self.m_flag_spriteChip[index]
        	local heart_num = 0
            local itemDta = self.m_showFlags[index]
            for k,v in pairs(self.m_tGameData.heart) do
            	if v[1] == itemDta.key then
            		heart_num = v[2]
            	end
            end
            local heart_nums = itemDta.score
            if heart_num < heart_nums then
            	local params = {}
	        	params.flag_id = itemDta.key
            	local function responseMethod( tag,gameData )
            		self.m_tGameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {}
			        self:refreshUi(true)
            	end
            	network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_cup_flag_choose_heart"),http_request_method.GET,params,"world_cup_flag_choose_heart")
            else
            	local params = {}
            	params.flag_id = itemDta.key
            	local function responseMethod( tag,gameData )
                    local data = gameData:getNodeWithKey("data")
                    local reward = data:getNodeWithKey("reward")
                    game_util:rewardTipsByJsonData(reward);
            		self.m_tGameData = json.decode(data:getFormatBuffer()) or {}
			        self:refreshUi(true)
            	end
            	network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_cup_flag_get_reward"),http_request_method.GET,params,"world_cup_flag_get_reward")
            end
        elseif btnTag > 100 then
        	index = btnTag - 100
        	local ccbNode = self.m_flag_spriteChip[index - 1]
            local itemDta = self.m_showFlags[index]
	        if self.m_select_index then
	        	local isIn ,k = game_util:idInTableById2(itemDta.key,self.m_flag_light)
	            if isIn then
	        		game_util:addMoveTips({text = "Đã thắp sáng quốc kỳ này！"})
	        	else                
	        		local params = {}
	        		params.flag_id = itemDta.key      			
			        local function responseMethod( tag,gameData )
			        	self.m_tGameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {}
                        local m_sprite_title = ccbNode:spriteForName("m_sprite_title") 
                        m_sprite_title:setColor(ccc3(255,255,255))
			        	self:refreshUi(true)	 
			        end
			        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_cup_flag_use_flag"),http_request_method.GET,params,"world_cup_flag_use_flag")
			    end
			else
			end
		else
            local _,flag_num = game_data:getMetalByTable(self.m_showFlags[btnTag].flag_id[1],0,0)
            if flag_num > 0 then
			    game_scene:enterGameUi("game_friend_scene",{flag_id = self.m_showFlags[btnTag].key});
            else
                game_util:addMoveTips({text = "Không có quốc kỳ này！"})
            end
		end    
    end
    self.m_select_index = 0
    self.m_select_item = nil
    local showData = self.m_showFlags
    local itemsCount = #showData
    local totalItem = math.max(itemsCount%5 == 0 and itemsCount or math.floor(itemsCount/5+1)*5,5)
    local params = {};
    params.viewSize = viewSize;
    params.row = 1;--行
    params.column = 5; --列
    params.totalItem = itemsCount;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY - 3;
    params.showPageIndex = self.m_curPage;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    self.m_cellSize = itemSize
    self.m_cellCount = itemsCount
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create();
            ccbNode:registerFunctionWithFuncName("onCellBtnClick",onCellBtnClick);
            ccbNode:openCCBFile("ccb/ui_collect_flags_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.6));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
        	local itemDta = showData[index + 1]
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_sprite_title = ccbNode:spriteForName("m_sprite_title")
            local m_flag_name = ccbNode:labelTTFForName("m_flag_name")
            local m_flag_num = ccbNode:labelTTFForName("m_flag_num")
            local m_flag_num1 = ccbNode:labelTTFForName("m_flag_num1")
            local _,flag_num = game_data:getMetalByTable(showData[index + 1].flag_id[1],0,0)
            local flag_names = itemDta.name
            m_flag_num:setString(flag_num .. "/1")
            m_flag_num1:setString(flag_num .. "/1")
            m_flag_name:setString(flag_names)
            local m_heart_num = ccbNode:labelTTFForName("m_heart_num")
            local m_heart_nums = ccbNode:labelTTFForName("m_heart_nums")
            local m_sprite_flagzhong = ccbNode:spriteForName("m_sprite_flagzhong")
            local heart_num = 0
            for k,v in pairs(self.m_tGameData.heart) do
            	if v[1] == itemDta.key then
            		heart_num = v[2]
            	end
            end
            local heart_nums = showData[index + 1].score
            m_heart_num:setString(heart_num.."/"..heart_nums)
            -- m_heart_nums:setString(heart_nums)
            self.m_flag_spriteChip[index] = ccbNode
            local btn_use = ccbNode:controlButtonForName("m_btn_use")
            local btn_send = ccbNode:controlButtonForName("m_btn_send")
            local btn_heart = ccbNode:controlButtonForName("m_btn_heart")
            btn_use:setTouchPriority(GLOBAL_TOUCH_PRIORITY-4)
            btn_send:setTouchPriority(GLOBAL_TOUCH_PRIORITY-4)
            btn_heart:setTouchPriority(GLOBAL_TOUCH_PRIORITY-4)
            btn_send:setTag(index+1)
            btn_use:setTag(index+101)
            btn_heart:setTag(index+1001)
            if self.m_select_index == index + 1 then
            	self.m_select_item = cell
            	btn_send:setVisible(true)
            	btn_use:setVisible(true)
                m_sprite_flagzhong:setVisible(true)
            else
            	btn_send:setVisible(false)
            	btn_use:setVisible(false)
                m_sprite_flagzhong:setVisible(false)
            end
            local isIn ,k = game_util:idInTableById2(itemDta.key,self.m_flag_light)
            if not isIn  then
            	m_sprite_title:setColor(ccc3(100,100,100))	
            else
            	m_sprite_title:setColor(ccc3(255,255,255))            		
            end

            local titleSpriteName = showData[index + 1].img_big or ""
            local frame = game_util:createIconByName(titleSpriteName)
            if m_sprite_title and frame then
                m_sprite_title:setDisplayFrame(frame:displayFrame())
            end

        end

        return cell;
    end

    params.itemOnClick = function(eventType,index,item)
        if index >= itemsCount then return end;
        if eventType == "ended" and item then
            local tempId = index + 1
            if self.m_select_index == 0 or self.m_select_index ~= tempId then
            	if self.m_select_item then
                    local ccbNode = tolua.cast(self.m_select_item:getChildByTag(10),"luaCCBNode");
                    local btn_use = ccbNode:controlButtonForName("m_btn_use")
                    local btn_send = ccbNode:controlButtonForName("m_btn_send")
                    local m_sprite_flagzhong = ccbNode:spriteForName("m_sprite_flagzhong")
                    btn_use:setVisible(false)
                    btn_send:setVisible(false)
                    m_sprite_flagzhong:setVisible(false)
                end
                self.m_select_item = item
                self.m_select_index = tempId
                local ccbNode = tolua.cast(self.m_select_item:getChildByTag(10),"luaCCBNode");
                local btn_use = ccbNode:controlButtonForName("m_btn_use")
                local btn_send = ccbNode:controlButtonForName("m_btn_send")
                local m_sprite_flagzhong = ccbNode:spriteForName("m_sprite_flagzhong")
                btn_use:setVisible(true)
                btn_send:setVisible(true)
                m_sprite_flagzhong:setVisible(true)
            elseif self.m_select_index == tempId then
                local ccbNode = tolua.cast(self.m_select_item:getChildByTag(10),"luaCCBNode");
                local btn_use = ccbNode:controlButtonForName("m_btn_use")
                local btn_send = ccbNode:controlButtonForName("m_btn_send")
                local m_sprite_flagzhong = ccbNode:spriteForName("m_sprite_flagzhong")
                btn_use:setVisible(false)
                btn_send:setVisible(false)
                m_sprite_flagzhong:setVisible(false)
                self.m_select_item = nil
                self.m_select_index = 0
            end 
            
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curPage = curPage;
    end
    return TableViewHelper:createGallery2(params);
    
    
end

function game_world_cup_flag:refreshLightFlags(  )
    -- for i=1,#self.m_showFlags do

        local ccbNode = self.m_flag_spriteChip[self.m_select_index - 1]
        local m_sprite_title = ccbNode:spriteForName("m_sprite_title")
        local m_heart_num = ccbNode:labelTTFForName("m_heart_num")
        local m_heart_nums = ccbNode:labelTTFForName("m_heart_nums")
        local isIn ,k = game_util:idInTableById2(i,self.m_flag_light)
        if not isIn  then
           m_sprite_title:setColor(ccc3(100,100,100))  
        else
            m_sprite_title:setColor(ccc3(255,255,255))                  
        end
        local heart_num = 0
            local itemDta = self.m_showFlags[i]
            for k,v in pairs(self.m_tGameData.heart) do
                if v[1] == itemDta.key then
                    heart_num = v[2]
                end
            end
            local heart_nums = itemDta.score
            m_heart_nums:setString(heart_nums)
    

	

end

function game_world_cup_flag:refreshUi( flag )
    self.m_flag_light = {}
    self.m_flag_light = self.m_tGameData.flag
	local world_cup_flag = getConfig(game_config_field.world_cup_flag)
	local world_cup_flagCfg = json.decode(world_cup_flag:getNodeWithKey(self.m_version):getFormatBuffer())
	self:refreshLabel()
	self.m_list_view_bg:removeAllChildrenWithCleanup(true);
    self.m_tableView = self:createTableView(self.m_list_view_bg:getContentSize());
    self.m_list_view_bg:addChild(self.m_tableView);
    -- self:refreshLightFlags()
    if not flag then
        self:refreshProgress()
    end
    local flag_number = 0
    flag_number = game_util:getTableLen(self.m_flag_light)
    local percentage = flag_number/#self.m_showFlags *100
    self.bar:setPercentage(percentage)
end

function game_world_cup_flag:init( t_params )
	t_params = t_params or {}
	if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
		local data = t_params.gameData:getNodeWithKey("data")
		self.m_tGameData = json.decode(data:getFormatBuffer()) or {}
	else
		self.m_tGameData = {}
	end
    self.m_flag_light = {}
    self.m_flag_light = self.m_tGameData.flag
	self.m_version = self.m_tGameData.version
	local world_cup_flag = getConfig(game_config_field.world_cup_flag)
	self.m_showFlags = {}
	local world_cup_flagCfg = json.decode(world_cup_flag:getFormatBuffer())
	for k,v in pairs(world_cup_flagCfg) do
		local itemItemCfg = v
		itemItemCfg.key = k
		if itemItemCfg.version == self.m_version then
			table.insert(self.m_showFlags,itemItemCfg)
		end
	end
    local sortFun = function ( data1,data2 )
     return tonumber(data1.key) < tonumber(data2.key)
    end
    table.sort(self.m_showFlags,sortFun)

end

function game_world_cup_flag:create( t_params )
	self:init(t_params)
	local pop = self:createUi()
	self:refreshUi()
	return pop
end


return game_world_cup_flag �I  