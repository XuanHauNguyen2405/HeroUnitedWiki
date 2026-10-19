-- 新转盘 -- 秘境探宝
local ui_new_roulette = {
    m_root_layer = nil,
    m_btn_back = nil,

    m_icon_sp = {},
    m_icon_kuang = {},
    m_last_kuang = nil,
    m_btn_1= nil,   --普通
    m_btn_2= nil,   --钻石
    m_btn_refresh= nil,
    m_btn_purchase= nil,
    m_btn_rule= nil,
    m_label_lasttime= nil,
    m_label_refreshcost= nil,
    m_label_purcost2= nil,
    m_sp_light1 = nil,
    m_node_refreshcost= nil,
    m_node_purcost= nil,

    m_layer_rule = nil,
    m_scroll_rule = nil,

    m_tGameData = nil,
    callback = nil,
    curpage = nil,
    curtable = nil,
    curgetnum = nil,
    getrewardnum = nil,
    m_TempNode1 =nil,
    m_btn_back2 = nil,
    _sch = 0 ,
    m_node_middle = nil,
    m_flag=nil,
} 

function ui_new_roulette:destroy( )
    cclog("   -------  ui_new_roulette   ----------     destroy  -------")
    self.m_root_layer = nil;
    self.m_btn_back = nil;

    self.m_icon_sp = {};
    self.m_icon_kuang = {};
    self.m_last_kuang = nil;
    self.m_btn_1= nil;
    self.m_btn_2= nil;
    self.m_btn_refresh= nil;
    self.m_btn_purchase= nil;
    self.m_btn_rule= nil;
    self.m_label_lasttime= nil;
    self.m_label_refreshcost= nil;
    self.m_label_purcost2= nil;
    self.m_sp_light1= nil;
    self.m_node_refreshcost= nil;
    self.m_node_purcost= nil;

    self.m_layer_rule = nil;
    self.m_scroll_rule = nil;

    self.m_tGameData = nil;
    self.callback = nil;

    self.curpage = nil;
    self.curtable = nil;
    self.curgetnum = nil;

    self.getrewardnum = nil;
    self.m_TempNode1 = nil;
    self.m_btn_back2 =nil;
    self._sch = 0;
    self.m_node_middle = nil;
    self.m_flag=nil;
end

function ui_new_roulette:back()
    if self.callback then
        self.callback()
    end
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self._sch);
	game_scene:removePopByName("ui_new_roulette")
end

function ui_new_roulette:createUi()
	local function onMainBtnClick( target,event )
		local tagNode = tolua.cast(target,"CCNode")
		local btnTag = tagNode:getTag()
		if btnTag == 101 then
			self:back()
        elseif btnTag == 102  then    -- 规则           
            self.m_layer_rule:setVisible(true)
            self.m_layer_rule:setTouchEnabled(true)

            if not self.m_TempNode1 then
                self.m_TempNode1 = CCNode:create()
                self.m_scroll_rule:addChild(self.m_TempNode1,1001)
            else
                self.m_TempNode1:removeAllChildrenWithCleanup(true)
            end
            local detailCfg = nil
            if self.curpage == 1 then
                detailCfg = getConfig(game_config_field.new_roulette_diamond):getNodeWithKey(tostring(self.m_tGameData.version))
            else 
                detailCfg = getConfig(game_config_field.new_roulette_item):getNodeWithKey(tostring(self.m_tGameData.version))
            end
            local detailCfg = json.decode(detailCfg:getFormatBuffer())
            local contentText = detailCfg.notice or ""
            local tempLabel = game_util:createRichLabelTTF({text = contentText,dimensions = CCSizeMake(220,0),textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(221,221,192),fontSize = 12})
            local viewSize1 = self.m_scroll_rule:getViewSize()

            self.m_TempNode1:addChild(tempLabel)
                tempLabel:setAnchorPoint(ccp(0,0))
            tempLabel:setPosition(ccp(0,0))
            local height1 = tempLabel:getContentSize().height

            self.m_TempNode1:setContentSize(CCSizeMake(viewSize1.width,height1))
            self.m_TempNode1:setAnchorPoint(ccp(0,0))
            self.m_TempNode1:setPosition(ccp(0,0))

            self.m_scroll_rule:setContentSize(CCSizeMake(self.m_scroll_rule:getContentSize().width,height1))
            self.m_scroll_rule:setContentOffset(ccp(0,viewSize1.height-height1),true)

        elseif btnTag == 201 and self.m_flag then    -- 钻石宝藏
            local function ResponseMethod(tag,gameData)
                self.curpage = 1
                self.m_tGameData = {}
                if gameData ~= nil and tolua.type(gameData) == "util_json" then
                    local data = gameData:getNodeWithKey("data");
                    self.m_tGameData = json.decode(data:getFormatBuffer()) or {};    
                end
                self.curtable={}
                self.getrewardnum = 0
                for k,v in pairs(self.m_tGameData.diamond_pool) do
                    self.curtable[k]= v
                    self.curtable[k][5]= self.m_tGameData.diamond_log[(tonumber(k)-1)..""]
                    self.getrewardnum = self.getrewardnum + tonumber(self.m_tGameData.diamond_log[(tonumber(k)-1)..""])
                end
                for i=1,14 do
                    self.m_icon_sp[i]:removeAllChildrenWithCleanup(true)
                end
                self:refreshUi()
            end
            local params = {};
            params.type = 1;
            network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("new_roulette_index"), http_request_method.GET, params,"new_roulette_index")
        elseif btnTag == 202 and self.m_flag then    -- 龙珠宝藏
            local function ResponseMethod(tag,gameData)
                self.curpage = 2
                self.m_tGameData = {}
                if gameData ~= nil and tolua.type(gameData) == "util_json" then
                    local data = gameData:getNodeWithKey("data");
                    self.m_tGameData = json.decode(data:getFormatBuffer()) or {};    
                end

                self.curtable = {}
                self.getrewardnum = 0
                for k,v in pairs(self.m_tGameData.item_pool) do
                    self.curtable[k]= v
                    self.curtable[k][5]= self.m_tGameData.item_log[(tonumber(k)-1)..""]
                    self.getrewardnum = self.getrewardnum + tonumber(self.m_tGameData.item_log[(tonumber(k)-1)..""])
                end
                for i=1,14 do
                    self.m_icon_sp[i]:removeAllChildrenWithCleanup(true)
                end
                self:refreshUi()
            end
            local params = {};
            params.type = 2;
            network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("new_roulette_index"), http_request_method.GET, params,"new_roulette_index")

        elseif btnTag == 301 and self.m_flag then    -- 刷新
            self:refreshchest()
        elseif btnTag == 302 and self.m_flag then    -- 购买弹窗
            local _icon,_name,_count = game_util:getRewardByItemTable(self.m_tGameData.need_cost[1],false)
            local t__params = 
            {
                title = "Gợi ý",
                okBtnCallBack = function(target,event)
                    local function ResponseMethod(tag,gameData)
                        self.m_flag = false
                        self.m_btn_refresh:setEnabled(false)
                        self.m_btn_purchase:setEnabled(false)
                        self.m_btn_refresh:setColor(ccc3(155,155,155))
                        self.m_btn_purchase:setColor(ccc3(155,155,155))
                        self:purchase(gameData)
                    end
                    local params = {};
                    params.type = tonumber(self.curpage)
                    network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("new_roulette_open_new_roulette"), http_request_method.GET, params,"new_roulette_open_new_roulette")
                    require("game_ui.game_pop_up_box").close(); 
                end,   --可缺省
                cancelBtnCallBack = function(target,event)

                    cclog("rightBtnCallBack");
                    require("game_ui.game_pop_up_box").close(); 
                 end,   --可缺省
                okBtnText = "OK",       --可缺省
                cancelBtnText = "Hủy",
                text = "Mua cần tiêu hao ".._count .." ".. _name,      --可缺省
                onlyOneBtn = false,          --可缺省
            }
            require("game_ui.game_pop_up_box").show(t__params);
        elseif btnTag == 601 and self.m_flag then    -- 规则提示
            self.m_layer_rule:setTouchEnabled(false);
            self.m_layer_rule:setVisible(false);
		end
	end
	local ccbNode =  luaCCBNode:create();
	ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick)
	ccbNode:openCCBFile("ccb/ui_new_roulette.ccbi")
    self.ccbNode = ccbNode
	self.m_root_layer = ccbNode:layerForName("m_root_layer")

	self.m_btn_back = ccbNode:controlButtonForName("m_btn_back")
    self.m_btn_back:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)
    
    self.m_sp_light1 = ccbNode:spriteForName("m_sp_light1")
    self.m_sp_light1:runAction(CCRepeatForever:create(CCRotateBy:create(3,360)))

    local function onTouchdes(eventType, x, y)
        if eventType == "began" then
            return true;
        elseif eventType == "ended" then
        end
    end

    for i=1,14 do
        self.m_icon_sp[i] = ccbNode:spriteForName("m_icon_sp"..i)
    end
    self.m_btn_1 = ccbNode:controlButtonForName("m_btn_1")
    self.m_btn_1:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)
    self.m_btn_2 = ccbNode:controlButtonForName("m_btn_2")
    self.m_btn_2:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)
    self.m_btn_refresh = ccbNode:controlButtonForName("m_btn_refresh")
    self.m_btn_refresh:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)
    self.m_btn_purchase = ccbNode:controlButtonForName("m_btn_purchase")
    self.m_btn_purchase:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)
    self.m_btn_rule = ccbNode:controlButtonForName("m_btn_rule")
    self.m_btn_rule:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 6)

    self.m_label_lasttime = ccbNode:labelTTFForName("m_label_lasttime")
    self.m_label_refreshcost = ccbNode:labelTTFForName("m_label_refreshcost")
    self.m_label_purcost2= ccbNode:labelTTFForName("m_label_purcost2")

    self.m_node_refreshcost= ccbNode:nodeForName("m_node_refreshcost")
    self.m_node_purcost= ccbNode:nodeForName("m_node_purcost")

    self.m_btn_back2  = ccbNode:controlButtonForName("m_btn_back2")
    self.m_btn_back2:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 8)
    self.m_node_middle = ccbNode:nodeForName("m_node_middle")
	local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;
        elseif eventType == "ended" then
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-5,true);
    self.m_root_layer:setTouchEnabled(true);

    self.m_layer_rule = ccbNode:layerForName("m_layer_rule")
    self.m_layer_rule:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-7,true);
    self.m_layer_rule:setTouchEnabled(false);
    self.m_layer_rule:setVisible(false);
    self.m_scroll_rule = ccbNode:scrollViewForName("m_scroll_rule")
    self.m_scroll_rule:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 8)
    return ccbNode
end

function ui_new_roulette:refreshchest()
    local function ResponseMethod(tag,gameData)
        self.m_tGameData = {}
        if gameData ~= nil and tolua.type(gameData) == "util_json" then
            local data = gameData:getNodeWithKey("data");
            self.m_tGameData = json.decode(data:getFormatBuffer()) or {};    
        end
        self.curtable={}
        self.getrewardnum = 0
        if self.curpage == 1 then
            for k,v in pairs(self.m_tGameData.diamond_pool) do
                self.curtable[k]= v
                self.curtable[k][5]= self.m_tGameData.diamond_log[(tonumber(k)-1)..""]
                self.getrewardnum = self.getrewardnum + tonumber(self.m_tGameData.diamond_log[(tonumber(k)-1)..""])
            end
        else
            for k,v in pairs(self.m_tGameData.item_pool) do
                self.curtable[k]= v
                self.curtable[k][5]= self.m_tGameData.item_log[(tonumber(k)-1)..""]
                self.getrewardnum = self.getrewardnum + tonumber(self.m_tGameData.item_log[(tonumber(k)-1)..""])
            end
        end
        for i=1,14 do
            self.m_icon_sp[i]:removeAllChildrenWithCleanup(true)
        end
        self:refreshUi()
    end
    local params = {};
    params.type = tonumber(self.curpage)
    network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("new_roulette_refresh_new_roulette"), http_request_method.GET, params,"new_roulette_refresh_new_roulette") 
end


function ui_new_roulette:purchase(gameData)
    self.m_tGameData = {}
    if gameData ~= nil and tolua.type(gameData) == "util_json" then
        local data = gameData:getNodeWithKey("data");
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {};    
    end
    local temptb = self.curtable
    self.curtable={}
    self.curgetnum  = nil
    self.getrewardnum = 0
    if self.curpage == 1 then
        for k,v in pairs(self.m_tGameData.diamond_pool) do
            self.curtable[k]= v
            self.curtable[k][5]= self.m_tGameData.diamond_log[(tonumber(k)-1)..""]
            self.getrewardnum = self.getrewardnum + tonumber(self.m_tGameData.diamond_log[(tonumber(k)-1)..""])
            if temptb and temptb[k][5] ~= self.curtable[k][5] then
                self.curgetnum = k
            end
        end
    else
        for k,v in pairs(self.m_tGameData.item_pool) do
            self.curtable[k]= v
            self.curtable[k][5]= self.m_tGameData.item_log[(tonumber(k)-1)..""]
            self.getrewardnum = self.getrewardnum + tonumber(self.m_tGameData.item_log[(tonumber(k)-1)..""])
            if temptb and temptb[k][5] ~= self.curtable[k][5] then
                self.curgetnum = k
            end
        end
    end

    self:doAnim()
end

function ui_new_roulette:doAnim()
    local curpos = 1
    local curpos2 = 1

    local delay = 0.001
    local defaultTimes = 2*14 +tonumber(self.curgetnum)
    local time1 = 1*14
    local time2 = 1*14 + (defaultTimes - 2*14)/2
    self._sch = 0 
    self.m_last_kuang = nil
    local function tick()
        if time1 == curpos2 then
            delay = delay + 0.1
        elseif time2 < curpos2 then
            delay = delay + 0.1
            if curpos2 == defaultTimes then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self._sch);
                local function lastfun()
                    self:refreshUi()
                    game_util:rewardTipsByDataTable(self.m_tGameData.reward)
                    if self.getrewardnum == 14 then
                        self:refreshchest()
                    end

                    self.m_btn_refresh:setEnabled(true)
                    self.m_btn_purchase:setEnabled(true)
                    self.m_btn_refresh:setColor(ccc3(255,255,255))
                    self.m_btn_purchase:setColor(ccc3(255,255,255))
                    self.m_flag = true
                    self.m_last_kuang:setVisible(false)
                end
                local animArr = CCArray:create();
                animArr:addObject(CCBlink:create(2,4));
                animArr:addObject(CCCallFuncN:create(lastfun))
                self.m_icon_kuang[curpos]:runAction(CCSequence:create(animArr))
            end
        end
        if self.m_last_kuang and type(self.m_last_kuang)=="userdata" then
            self.m_last_kuang:setVisible(false)
        end

        self.m_icon_kuang[curpos]:setVisible(true)
        self.m_last_kuang = self.m_icon_kuang[curpos]

        curpos = (curpos + 1)%14
        curpos2 = curpos2 +1
        if curpos == 0 then curpos =14 end

        self.m_last_kuang:runAction(CCDelayTime:create(delay))
    end

    self._sch  = scheduler.schedule(tick, 1/75, false)
end



function ui_new_roulette:refreshUi()
    self.m_btn_1:setEnabled(self.curpage == 2) 
    self.m_btn_2:setEnabled(self.curpage == 1) 
        
    local timeLabel,timeStr = game_util:createStaticCountDownLabel(self.m_tGameData.remain_time)
    self.m_label_lasttime:setString(timeStr)

    local refreshcost = nil
    if self.curpage == 1 then
        refreshcost =json.decode(getConfig(game_config_field.new_roulette_diamond):getNodeWithKey(tostring(self.m_tGameData.version)):getNodeWithKey("refresh_price"):getFormatBuffer())[1]
    else
        refreshcost =json.decode(getConfig(game_config_field.new_roulette_item):getNodeWithKey(tostring(self.m_tGameData.version)):getNodeWithKey("refresh_price"):getFormatBuffer())[1]
    end
    local _icon,_name,_count = game_util:getRewardByItemTable(refreshcost,false)
    local _icon2,_name2,_count2 = game_util:getRewardByItemTable(self.m_tGameData.need_cost[1],false)

    if self.m_node_refreshcost:getChildren() then
        self.m_node_refreshcost:removeAllChildrenWithCleanup(true)
    end

    if self.m_node_purcost:getChildren() then
        self.m_node_purcost:removeAllChildrenWithCleanup(true)
    end
    if self.getrewardnum == 14 then
        self.m_label_refreshcost:setVisible(true)
        self.m_label_refreshcost:setString("Lần này miễn phí")
        self.m_label_purcost2:setVisible(false)
    else
        self.m_label_purcost2:setVisible(true)
        self.m_node_refreshcost:addChild(_icon)
        _icon:setScale(0.3)
        self.m_label_refreshcost:setString(_count)

        self.m_node_purcost:addChild(_icon2)
        _icon2:setScale(0.3)
        self.m_label_purcost2:setString(_count2)
    end

    self.m_icon_kuang = {}

    function onBtnCilck( event, target )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        local index = btnTag%100
        game_util:lookItemDetal( self.curtable[index] )
    end

    local h_rewardChance_tb = {}
    if self.curpage == 1 then
        h_rewardChance_tb =json.decode(getConfig(game_config_field.new_roulette_diamond):getNodeWithKey(tostring(self.m_tGameData.version)):getNodeWithKey("reward_chance"):getFormatBuffer())
    else
        h_rewardChance_tb =json.decode(getConfig(game_config_field.new_roulette_item):getNodeWithKey(tostring(self.m_tGameData.version)):getNodeWithKey("reward_chance"):getFormatBuffer())
    end

    local curWeight = nil
    for k,v in pairs(h_rewardChance_tb) do
        if v[1].."" == "1" then
            curWeight = v[2]
        end
    end

    for i=1,14 do
        if self.curtable[i][4].."" == curWeight.."" and self.curtable[i][5].."" == "0" then 
            local sphlight2 = CCSprite:createWithSpriteFrameName("ui_mysteryplace_light2.png")
            self.m_icon_sp[i]:addChild(sphlight2)
            sphlight2:setPosition(ccp(self.m_icon_sp[i]:getContentSize().width/2,self.m_icon_sp[i]:getContentSize().height/2))
            sphlight2:runAction(CCRepeatForever:create(CCRotateBy:create(1,-360)))
            -- local anim1 = game_util:createEffectAnim("teshujiangli",1,true)
            -- self.m_icon_sp[i]:addChild(anim1,10,10)
            -- anim1:setPosition(ccp(self.m_icon_sp[i]:getContentSize().width/2,self.m_icon_sp[i]:getContentSize().height/2-2))
        else
            if self.m_icon_sp[i]:getChildren() then
                self.m_icon_sp[i]:removeAllChildrenWithCleanup(true)
            end
        end

        local button = game_util:createCCControlButton("ui_mysteryplace_kuang.png","",onBtnCilck)
        self.m_icon_sp[i]:addChild(button)
        button:setTouchPriority(GLOBAL_TOUCH_PRIORITY-5)
        button:setTag(100 + i)
        button:setOpacity(0)
        button:setAnchorPoint(ccp(0.5,0.5))
        button:setPosition(ccp(self.m_icon_sp[i]:getContentSize().width/2,self.m_icon_sp[i]:getContentSize().height/2))
        local icon,name,count = game_util:getRewardByItemTable(self.curtable[i],true)
        local itemname =  CCLabelTTF:create(tostring(name),TYPE_FACE_TABLE.Arial_BoldMT,10);
        self.m_icon_sp[i]:addChild(icon)
        self.m_icon_sp[i]:addChild(itemname)
        icon:setScale(0.7)
        itemname:setScale(0.7)
        icon:setPosition(ccp(self.m_icon_sp[i]:getContentSize().width/2,self.m_icon_sp[i]:getContentSize().height*5/9))
        itemname:setPosition(ccp(self.m_icon_sp[i]:getContentSize().width/2,self.m_icon_sp[i]:getContentSize().height/8))

        if self.curtable[i][5].."" == "1"  then
            local temp_shade_icon = CCSprite:createWithSpriteFrameName("ui_mysteryplace_bg2.png")
            self.m_icon_sp[i]:addChild(temp_shade_icon)
            temp_shade_icon:setPosition(ccp(self.m_icon_sp[i]:getContentSize().width/2,self.m_icon_sp[i]:getContentSize().height/2))
        end        
        local kuang = CCSprite:createWithSpriteFrameName("ui_mysteryplace_kuang.png")
        self.m_icon_sp[i]:addChild(kuang)
        kuang:setPosition(ccp(self.m_icon_sp[i]:getContentSize().width/2,self.m_icon_sp[i]:getContentSize().height/2))
        kuang:setVisible(false)
        table.insert(self.m_icon_kuang,kuang)

        if self.curtable[i][4].."" == curWeight..""  then
            local button = game_util:createCCControlButton("ui_mysteryplace_light1.png","",onBtnCilck)
            self.m_node_middle:addChild(button)
            button:setTouchPriority(GLOBAL_TOUCH_PRIORITY-5)
            button:setTag(100 + i)
            button:setOpacity(0)
            button:setAnchorPoint(ccp(0.5,0.5))
            button:setPosition(ccp(0,0))

            local icon,name,count = game_util:getRewardByItemTable(self.curtable[i],true)
            self.m_node_middle:addChild(icon)
            icon:setPosition(ccp(0,0))
        end  
    end

    local _icon2,_name2,_count2 = game_util:getRewardByItemTable({6, 511317, 1},false)
    local count = game_data:getItemCountByCid(511317) or 0
    local nd_lzIcon = self.ccbNode:nodeForName("nd_lzIcon")
    nd_lzIcon:removeAllChildrenWithCleanup(true)
    nd_lzIcon:addChild(_icon2)
    _icon2:setScale(0.3)
    local lb_lzHas = self.ccbNode:labelTTFForName("lb_lzHas")
    lb_lzHas:setString(count)
end


function ui_new_roulette:init(t_params)
    cclog( "                ui_new_roulette ============================                      ")

	self.m_tGameData = {}
	if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data");
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {};    
    end
    if t_params.callback then
        self.callback = t_params.callback
    end
    self.curpage = 1 --钻石
    
    self.curtable={}
    self.getrewardnum = 0
    for k,v in pairs(self.m_tGameData.diamond_pool) do
        self.curtable[k]= v
        self.curtable[k][5]= self.m_tGameData.diamond_log[(tonumber(k)-1)..""]
        self.getrewardnum = self.getrewardnum + tonumber(self.m_tGameData.diamond_log[(tonumber(k)-1)..""])
    end
    self.m_flag = true
    cclog2(self.m_tGameData,"self.m_tGameData-=--------------")
end

function ui_new_roulette:create(t_params)
	self:init(t_params)
	local scene = CCScene:create()
	scene:addChild(self:createUi())
	self:refreshUi()
	return scene
end


return ui_new_roulette   �Y