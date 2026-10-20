local ui_guessing_football_exchange = {
    m_tGameData=nil,
    m_popUi = nil,
    m_tParams = nil,
    m_root_layer = nil,
    m_close_btn = nil,
    m_list_node = nil,
    m_btn_refresh = nil,
    m_refrsh_label = nil,
    m_refrsh_label1 = nil,
    lb_exchangeTimes = nil,

    shopCfg ={},
    m_id = {},
   };
--[[--
    销毁
]]
function ui_guessing_football_exchange.destroy(self)
    -- body
    cclog("-----------------ui_guessing_football_exchange destroy-----------------");
    self.m_tGameData=nil;
    self.m_popUi = nil;
    self.m_tParams = nil;
    self.m_root_layer = nil;
    self.m_close_btn = nil;
    self.m_list_node = nil;
    self.m_refrsh_label = nil;
    self.m_refrsh_label1 = nil;
    self.lb_exchangeTimes = nil;
    self.shopCfg ={};
    self.m_id = {};
    self.m_btn_refresh = nil;

    
end
--[[--
    返回
]]
function ui_guessing_football_exchange.back(self,type)
    
    function shopOpenResponseMethod(tag,gameData)
        game_scene:removePopByName("ui_guessing_football_exchange");
        self:destroy();
        game_scene:addPop("ui_guessing_football_main",{gameData = gameData})
    end
     network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("world_cup_guess_index"), http_request_method.GET, {},"world_cup_guess_index")
end

function ui_guessing_football_exchange.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
            if self.m_flag ==true then 
                return 
            end
        if btnTag == 999 then
            self:back();
        elseif btnTag == 888 then 
           local function responseMethod(tag,gameData) 
               if gameData then
                    local data = gameData:getNodeWithKey("data")
                    self.m_tGameData = json.decode(data:getFormatBuffer())
                        game_util:addMoveTips({text = "Tạo mới thành công!"});  
                    -- cclog2(self.m_tGameData,"self.m_tGameData ==-=----------")
                    self:refreshUi()
                end
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_cup_guess_exchange_refresh"), http_request_method.GET, {},"world_cup_guess_exchange_refresh")
        
       
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_guessing_football_exchange.ccbi");  

    

    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;
        elseif eventType == "ended" then

        end
    end

    self.m_close_btn=ccbNode:controlButtonForName("m_close_btn")
    self.m_btn_refresh = ccbNode:controlButtonForName("m_btn_refresh")
    self.m_btn_refresh :setTouchPriority(GLOBAL_TOUCH_PRIORITY-12)
    self.m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-12)
    self.m_list_node = ccbNode:nodeForName("m_list_node")
    self.m_refrsh_label = ccbNode:labelTTFForName("m_refrsh_label")
    self.m_refrsh_label1 = ccbNode:labelTTFForName("m_refrsh_label1")
    self.m_refrsh_label:setString(self.world_cup_exchange["1"].fresh[1][3])
    self.m_refrsh_label1:setString(self.world_cup_exchange["1"].fresh[1][3])

    self.lb_exchangeTimes = ccbNode:labelTTFForName("lb_exchangeTimes")


-- cclog2(self.world_cup_exchange["1"].fresh[1][3],"self.world_cup_exchange[1].fresh-=-------")
    self.m_list_node:removeAllChildrenWithCleanup(true);
    local tableViewTemp = self:createTableView(self.m_list_node:getContentSize());
    self.m_list_node:addChild(tableViewTemp);

    
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-10 ,true);
    self.m_root_layer:setTouchEnabled(true);
    self.m_ccbNode = ccbNode;
    return ccbNode;
end
-- 

function ui_guessing_football_exchange.createTableView(self,viewSize)    
   local shopCfg = getConfig(game_config_field.world_cup_exchange);
    -- local itemsCount = #self.m_shopItemIdTab;
    local itemsCount = #self.m_tGameData.exchange_list
    local totalItem = math.max(itemsCount%8 == 0 and itemsCount or math.floor(itemsCount/8+1)*8,8)
    local totalPage = math.ceil(totalItem / 8)
    if self.page_index == "last" then--跳到最后一页
        self.m_curPage = totalPage
    end
    local function onMainBtnClick(target,event)
        -- if self.m_moveFlag == false and event == 32 then
            local tagNode = tolua.cast(target, "CCNode");
            local btnTag = tagNode:getTag();
            if btnTag <= 100 then 
                local function responseMethod(tag,gameData) 
                    local data = gameData:getNodeWithKey("data")
                    self.m_tGameData = json.decode(data:getFormatBuffer())
                    self.m_exchange =self.m_tGameData.exchange_log
                    game_util:rewardTipsByJsonData(data:getNodeWithKey("reward"))

                    -- cclog2(self.m_tGameData,"self.m_tGameData123-==-=-=-=-")
                    -- game_util:addMoveTips({text = "兑换成功!"});  
                    self:refreshUi()
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_cup_guess_exchange_item"), http_request_method.GET, {exchange_id = self.m_tGameData.exchange_list[btnTag]},"world_cup_guess_exchange_item")
            else
                local tempId = tostring(self.m_tGameData.exchange_list[btnTag-100]);
                local itemCfg = shopCfg:getNodeWithKey(tempId)
                if itemCfg  then
                    local shop_reward = json.decode(itemCfg:getNodeWithKey("reward"):getFormatBuffer())or {}
                    game_util:lookItemDetal(shop_reward[1])   
                end
            end
        -- end
    end

    local params = {};
    params.viewSize = viewSize;
    params.row = 2;--行
    params.column = 4; --列
    params.direction = kCCScrollViewDirectionHorizontal;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY;
    -- params.totalItem = totalItem;
    params.totalItem = 8;
    params.showPageIndex = self.m_curPage;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            -- local spriteLand = CCLayerColor:create(ccc4(0, 0, 125, 125), 60, 30)
            local ccbNode = luaCCBNode:create();
            ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
            ccbNode:openCCBFile("ccb/ui_football_buy_item_list_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setScale(0.8);
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
            ccbNode:controlButtonForName("m_buy_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY-10);
            ccbNode:controlButtonForName("m_look"):setTouchPriority(GLOBAL_TOUCH_PRIORITY-10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_root_node=ccbNode:nodeForName("m_root_node")
            local m_buy_btn = ccbNode:controlButtonForName("m_buy_btn")
            local m_look = ccbNode:controlButtonForName("m_look")
            m_buy_btn:setTag(index+1);
            m_look:setTag(index+101);
            m_look:setOpacity(0)
            if index < itemsCount then
                m_root_node:setVisible(true);
                local tempId = tostring(self.m_tGameData.exchange_list[index+1]);

                -- -- cclog("tempId == " .. tempId)
                local itemCfg = shopCfg:getNodeWithKey(tempId)
                if itemCfg then 
                    local m_node = ccbNode:nodeForName("m_node");
                    m_node:removeAllChildrenWithCleanup(true);
                    local m_spr_bg = ccbNode:spriteForName("m_spr_bg")
                    m_spr_bg:setOpacity(0)
                    local m_cost_label = ccbNode:labelBMFontForName("m_cost_label")
                    local m_name_label = ccbNode:labelTTFForName("m_name_label")
                    local m_limit_label = ccbNode:labelBMFontForName("m_limit_label")
                    local reward = itemCfg:getNodeWithKey("reward")
                    -- if rewardCount > 0 then
                        local icon,name,count = game_util:getRewardByItem(reward:getNodeAt(0));
                        if icon then
                            icon:setScale(0.9)
                            m_node:addChild(icon);
                        end
                        -- if self.m_exchange[tostring(self.m_tGameData.exchange_list[index+1])]then 
                        --     cclog2(self.m_exchange[tostring(self.m_tGameData.exchange_list[index+1])],"121212")
                        -- end
                        local number = 0
                        if self.m_exchange[tostring(self.m_tGameData.exchange_list[index+1])] ~=nil then 
                             number = tonumber(self.m_exchange[tostring(self.m_tGameData.exchange_list[index+1])])                 
                             -- cclog2(number,"1231434123")
                        end
                        number = tonumber(itemCfg:getNodeWithKey("limit_num"):toStr())-number
                             -- cclog2(self.m_exchange[tostring(self.m_tGameData.exchange_list[index+1])],"number-123=456----------")
                             -- cclog2(itemCfg:getNodeWithKey("limit_num"):toStr(),"itemCfg:getNodeWithKe23=456----------")

                        if name then
                            m_name_label:setString(name.."("..number..")");
                        end
                        -- cclog2(itemCfg,"itemCfg-=----------")
                        if count >= 1 then
                            m_limit_label:setString("×" .. count)
                        else
                            m_limit_label:setString("")
                        end
                    -- end
                        local need_value = itemCfg:getNodeWithKey("cost_coin");
                        m_cost_label:setString(need_value:toStr())
                        -- m_limit_label:setString("x" .. itemCfg:getNodeWithKey("limit_num"):toStr())--限制次数
                        -- m_limit_label:setOpacity(0)
                        if number ==0 then  --不能购买。置灰
                            -- m_node:setColor(ccc3(100,100,100))
                            m_spr_bg:setColor(ccc3(100,100,100))
                            m_spr_bg:setOpacity(128)

                        end
                end
            else
                m_root_node:setVisible(false);
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if index >= itemsCount then return end;
        if eventType == "ended" and item then
            -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  item = " .. tolua.type(item));
            local tempId = tostring(self.m_tGameData.exchange_list[index+1]);
            local itemCfg = shopCfg:getNodeWithKey(tempId)
            if itemCfg  then
                local shop_reward = json.decode(itemCfg:getNodeWithKey("reward"):getFormatBuffer())or {}
                game_util:lookItemDetal(shop_reward[1])   
            end
            -- self:addBuyPop(tempId);
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curPage = curPage;
    end
    return TableViewHelper:create(params);
end

function ui_guessing_football_exchange.refreshUi(self)      
    self.m_list_node:removeAllChildrenWithCleanup(true);
    local tableViewTemp = self:createTableView(self.m_list_node:getContentSize());
    self.m_list_node:addChild(tableViewTemp);

    local maxFreshTimes = self.world_cup_exchange["1"]. fresh_num
    local refreshTimes = self.m_tGameData.fresh_num
    self.lb_exchangeTimes:setString(refreshTimes.. "/" .. maxFreshTimes)
end



--[[--
    初始化
]]
function ui_guessing_football_exchange.init(self,t_params)
    t_params = t_params or {}
    if t_params.gameData ~= nil then
         self.m_tGameData = t_params.gameData
    else
        self.m_tGameData = {};
    end
    -- cclog2( self.m_tGameData," self.m_tGameData-456=----------")
   -- local shopCfg = getConfig(game_config_field.world_cup_exchange);
   self.shopCfg ={}
   self.m_id = {}
   self.m_exchange ={}
   self.world_cup_exchange = {}
   local shopCfg = json.decode(getConfig(game_config_field.world_cup_exchange):getFormatBuffer());
   self.world_cup_exchange = shopCfg
    -- cclog2(self.world_cup_exchange,"self.world_cup_exchange-=------------")
    for k,v in pairs(shopCfg) do
        table.insert(self.m_id,k)
    end
    -- cclog2(self.m_id,"self.m_id-=-----------")
    self.m_exchange =self.m_tGameData.exchange_log

    for i=1,#self.m_id do
        self.shopCfg[i] = shopCfg[tostring(i)]
    end
    -- cclog2(shopCfg,"shopCfg-=------------")
end
--[[--
    创建ui入口并初始化数据
]]
function ui_guessing_football_exchange.create(self,t_params)
    self:init(t_params);
    self.m_tParams = t_params;
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

--[[--
    回调方法
]]
function ui_guessing_football_exchange.callBackFunc(self)
    local callBackFunc = self.callBackFunc;
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc();
    end
end

return ui_guessing_football_exchange;�5  