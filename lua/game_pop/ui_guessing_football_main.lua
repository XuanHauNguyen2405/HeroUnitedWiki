local ui_guessing_football_main = {
    m_tGameData=nil,
    m_popUi = nil,
    m_tParams = nil,
    m_root_layer = nil,
    m_close_btn = nil,
    m_btn_cheer_up = {},
    m_label_name = {},
    m_time = {},
    m_btn_select = {},
    m_btn_select_label = {},
    m_btn_select_sp ={},
    -- m_select ={},  --选中
    m_btn_xiangqing = nil,
    m_btn_chongzhi = nil,
    m_btn_used = nil,
    m_btn_exchange = nil,
    m_btn_rank = nil,
    guessing_cfg = nil,
    m_remain_time = nil,
    m_type = nil,
    m_choose  = nil,
    m_num_oil = nil,
    m_id= {},
    m_version = nil,
    m_guess_node = nil,
    m_sel = {},

    m_game_type ={},
    m_bet_list= {},
    rank_node = nil,

    m_select_sp_list ={},


    
   };
--[[--
    销毁
]]
function ui_guessing_football_main.destroy(self)
    -- body
    cclog("-----------------ui_guessing_football_main destroy-----------------");
    self.m_tGameData=nil;
    self.m_popUi = nil;
    self.m_tParams = nil;
    self.m_root_layer = nil;
    self.m_close_btn = nil;
    self.m_btn_cheer_up = {};
    self.m_label_name ={};
    self.m_time = {};
    self.m_btn_select ={};
    -- self.m_select ={};
    self.m_btn_select_label ={};
    self.m_btn_select_sp = {};
    self.m_btn_xiangqing = nil;
    self.m_btn_chongzhi = nil;
    self.m_btn_rank = nil;
    self.m_btn_used = nil;
    self.m_btn_exchange = nil;
    self.guessing_cfg = nil;
    self.m_remain_time = nil;
    self.m_type = nil;
    self.m_choose =nil;
    self.m_num_oil = nil;
    self.m_id  = {};
    self.m_version = nil;
    self.m_guess_node = nil;
    self.m_sel = {};
    self.m_game_type = {}; 
    self.m_bet_list = {};
    self.rank_node = nil;
    self.m_select_sp_list = {};
    
end
--[[--
    返回
]]
function ui_guessing_football_main.back(self,type)
    game_scene:removePopByName("ui_guessing_football_main");
    self:destroy();
end

function ui_guessing_football_main.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
            if self.m_flag ==true then 
                return 
            end
        if btnTag == 999 then
            self:back();
        elseif btnTag ==  1 or btnTag ==2  then 
            
        -- elseif btnTag == 2 then 
        --     game_scene:addPop("ui_guessing_football_cheer_up",{})
        elseif btnTag == 4 then 
            game_scene:addPop("ui_guessing_football_notice",{gameData = self.m_tGameData,m_type = self.m_bet_list[self.m_type]})   
        elseif btnTag ==5 then  --成就
            game_scene:addPop("ui_guessing_football_achievement",{gameData = self.m_tGameData})
        elseif btnTag ==6 then  --排行榜
        game_scene:addPop("ui_guessing_football_rank",{gameData = self.m_tGameData})
        elseif btnTag ==7 then  --往期加油
            game_scene:addPop("ui_guessing_football_record",{gameData = self.m_tGameData})
        elseif btnTag ==8 then  --兑换商场
            game_scene:addPop("ui_guessing_football_exchange",{gameData = self.m_tGameData})
        -- elseif btnTag == 11 or btnTag == 12 or btnTag == 13   or btnTag == 21 or btnTag == 22 or btnTag == 23 then
        --     self.m_type = math.floor(btnTag/10)
        --     self.m_choose = btnTag%10 
        --     -- cclog2(self.m_type,"self.m_type-=--------")
        --     -- cclog2(self.m_choose,"self.m_choose-=--------")
        --     for  i=1,2 do
        --         for j=1,3 do
        --             if self.m_type == i  and  self.m_choose ~= j  then
        --                 self.m_select[i][j]:setOpacity(0)
        --                 -- self.m_btn_select[i][j]:setColor(ccc3(100,100,100))
        --             end 
        --             if self.m_type == i  and  self.m_choose == j  then
        --                 -- self.m_btn_select[i][j]:setColor(ccc3(255,255,255))
        --                 self.m_select[i][j]:setOpacity(255)
        --             end
        --         end
        --     end
        -- elseif  btnTag == 21 or btnTag == 22 or btnTag == 23 then 
        --     self.m_type = btnTag/10
        --     self.m_choose = btnTag%10 
           
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_guessing_football_main.ccbi");  

    -- self.m_sel = {}
    -- for i=1,2 do
    --     self.m_sel[i]= {}
    --     for j=1,3 do
    --         self.m_sel[i][j] = ccbNode:spriteForName("m_sel_"..i..j)
    --         self.m_sel[i][j]:setOpacity(0)
    --         if j ==1 and i==1  then 
    --             self.m_sel[i][j]:setOpacity(255)
                
    --         end
    --     end
    -- end

    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;
        elseif eventType == "ended" then

        end
    end

    self.m_close_btn=ccbNode:controlButtonForName("m_close_btn")
    self.m_btn_xiangqing=ccbNode:controlButtonForName("m_btn_xiangqing")
    self.m_btn_chongzhi=ccbNode:controlButtonForName("m_btn_chongzhi")
    self.m_btn_used=ccbNode:controlButtonForName("m_btn_used")
    self.m_btn_exchange=ccbNode:controlButtonForName("m_btn_exchange")
    self.m_btn_rank =ccbNode:controlButtonForName("m_btn_rank")

    self.m_scroll_msgBoard = ccbNode:scrollViewForName("m_scroll_msgBoard")

    self.rank_node = ccbNode:nodeForName("rank_node");

    self.m_btn_rank:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.m_btn_xiangqing:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.m_btn_chongzhi:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.m_btn_used:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.m_btn_exchange:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)

    self.m_num_oil = ccbNode:labelTTFForName("m_num_oil")
    self.m_num_oil:setString(game_data:getUserStatusDataByKey("world_cup_oil"))
    -- cclog2(,"getworld_cup_oil-=--------------")

    self.m_remain_time = ccbNode:nodeForName("m_remain_time")
    self:createTimeDown(self.m_remain_time,self.m_tGameData.remain_bet)
    self.m_guess_node = ccbNode:nodeForName("m_guess_node")  --生成加油列表
    -- cclog("111111")
    self.m_guess_node:removeAllChildrenWithCleanup(true);
    local tableViewTemp = self:createTableView(self.m_guess_node:getContentSize());
    self.m_guess_node:addChild(tableViewTemp,10,10);
    
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY - 1,true);
    self.m_root_layer:setTouchEnabled(true);
    self.m_ccbNode = ccbNode;
    return ccbNode;
end
-- 
function ui_guessing_football_main.createTableView(self,viewSize,showData)
    showData = showData or {}
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target,"CCNode");
        local btnTag = tagNode:getTag();
        cclog("btnTag ========== " .. btnTag)

        if tonumber(btnTag) >1000 then 
            if self.guessing_cfg[math.floor(btnTag/1000)].result ~= 0 then 
                game_util:addMoveTips({text = "Phải, trận đấu đã kết thúc."})
                return
            end
            self.m_type = math.floor(btnTag/1000) 
            self.m_choose = btnTag%1000
            self.m_first =false
            -- local  m_panduan =self.m_type%2 
            -- if m_panduan ==0 then 
            --     m_panduan =2 
            -- end
            if self.m_game_type[self.m_type] ==1  and self.m_choose ==2 then
                game_util:addMoveTips({text = "Vòng loại không có mục này"});
                return
            end
            for i=1,3 do
                if self.m_choose == i then 
                    self.m_select_sp_list[self.m_type][i]:setOpacity(255)
                else
                    self.m_select_sp_list[self.m_type][i]:setOpacity(0)
                end
            end
            -- for i=1,2 do
            --     for j=1,3 do
            --         if i == m_panduan and j ==self.m_choose  then 
            --             self.m_sel[i][j]:setOpacity(255)
            --         else
            --             self.m_sel[i][j]:setOpacity(0)
            --         end
            --     end
            -- end
        else
            -- self.m_type = btnTag
            if self.guessing_cfg[btnTag].result ~= 0 then 
                game_util:addMoveTips({text = "Phải, trận đấu đã kết thúc."})
                return
            end
            if self.m_first   then 
                game_scene:addPop("ui_guessing_football_cheer_up",{gameData = self.m_tGameData,m_type = btnTag,m_choose = self.m_choose,maxCount = game_data:getUserStatusDataByKey("world_cup_oil")})      
            else
                if self.m_type == btnTag   then 
                    
                    game_scene:addPop("ui_guessing_football_cheer_up",{gameData = self.m_tGameData,m_type = btnTag,m_choose = self.m_choose,maxCount = game_data:getUserStatusDataByKey("world_cup_oil")})   
                else
                    if self.m_choose~=nil then 
                        self.m_choose =1 
                    end
                    game_scene:addPop("ui_guessing_football_cheer_up",{gameData = self.m_tGameData,m_type = btnTag,m_choose = self.m_choose,maxCount = game_data:getUserStatusDataByKey("world_cup_oil")})   

                --     game_util:addMoveTips({text = "请选择您想要支持的队伍！"});
                end
            end
        end
        
        
    end
    local params = {}
    params.viewSize = viewSize
    params.row = 2
    params.column = 1 -- 列
    params.direction = kCCScrollViewDirectionVertical
    params.totalItem = #self.m_bet_list

    params.touchPriority = GLOBAL_TOUCH_PRIORITY-2;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create()
            ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);  
            -- cclog("222222222")          
            ccbNode:openCCBFile("ccb/ui_guessing_football_main_item.ccbi")
            -- cclog("3333333")          

            ccbNode:setAnchorPoint(ccp(0,0))
            ccbNode:setPosition(ccp(itemSize.width*0.1-40,itemSize.height*0.1-5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_btn_cheer_up=ccbNode:controlButtonForName("m_cheer_up")
            local m_btn_select = {}
            local m_btn_select_label = {}
            local m_btn_select_sp = {}
            local m_select= {}
            local m_win ={}
            self.m_select_sp_list[self.m_bet_list[index+1]] ={}
                for j=1,3 do
                     m_btn_select[j]=ccbNode:controlButtonForName("m_btn_select"..j)
                     m_btn_select[j]:setOpacity(0)
                     m_btn_select_label[j]=ccbNode:labelTTFForName("m_btn_select_label"..j)
                     m_btn_select_sp[j] =ccbNode:spriteForName("m_btn_select_sp"..j)
                     m_select[j] =ccbNode:spriteForName("m_sel_"..j)
                     m_select[j]:setOpacity(0)        
                     m_win[j] =ccbNode:spriteForName("m_win"..j)

                     m_btn_select_label[j]:setOpacity(0)
                     m_win[j]:setOpacity(0)
                     if self.guessing_cfg[self.m_bet_list[index+1]].result == j then 
                        m_win[j]:setOpacity(255)
                     else
                        m_win[j]:setOpacity(0)
                     end
                     -- cclog2(self.m_bet_list[index+1],"self.m_bet_list[index+1]-=-------")
                    if j ~= 2  then 
                        m_btn_select_sp[j]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(self.guessing_cfg[self.m_bet_list[index+1]]["team_"..j.."_picture"]..".png"))
                        m_select[j]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("ui_cloth_choose.png"))
                    else
                        m_select[j]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("ui_sp_vs2.png"))
                    end
                    m_btn_select[j]:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)  
                    m_btn_select[j]:setTag(1000*(self.m_bet_list[index+1])+j)
                    if j ==1 then 
                        m_select[j]:setOpacity(255)
                    end
                    -- cclog2(self.m_bet_list[index+1],"self.m_bet_list[index+1]-=-------")
                    self.m_select_sp_list[self.m_bet_list[index+1]][j] = m_select[j]
                end
                m_label_name = ccbNode:labelTTFForName("m_label_name")
                m_time = ccbNode:labelTTFForName("m_time")
                m_label_name:setString("Trận"..(self.m_bet_list[index+1]).."  "..self.guessing_cfg[self.m_bet_list[index+1]]["team_1"].." vs "..self.guessing_cfg[self.m_bet_list[index+1]]["team_3"])
                m_time:setString("Thời gian thi đấu :"..self.guessing_cfg[self.m_bet_list[index+1]]["match_time"])
                m_btn_cheer_up:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)  
                m_btn_cheer_up:setTag(self.m_bet_list[index+1])

        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        if eventType == "ended" and cell then
        end
    end
    return TableViewHelper:create(params);
end
--[[--
    刷新
]]
function ui_guessing_football_main.refreshTableView(self)
    self.rank_node:removeAllChildrenWithCleanup(true);
    self.m_tableView = self:createTableView2(self.rank_node:getContentSize());
    self.m_tableView:setScrollBarVisible(true);
    self.rank_node:addChild(self.m_tableView,10,10);
end

function ui_guessing_football_main.createTableView2(self,viewSize)
    local showData = self.m_tGameData.notice or {}
    local showCount = #showData
    local params = {};
    params.viewSize = viewSize;
    params.row = 3;--行
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
            local detail_label = game_util:createRichLabelTTF({text = tostring(showData[index+1]),dimensions = CCSizeMake(135,0),textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(255,255,255)})
            detail_label:setAnchorPoint(ccp(0, 0))
            if index >= 1 then
                detail_label:setPosition(ccp(itemSize.width*0.1-14,itemSize.height*0.1- ((index+1) * 10)))
            else
                detail_label:setPosition(ccp(itemSize.width*0.1-14,itemSize.height*0.1-10))    
            end
            
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

function ui_guessing_football_main.refreshUi(self)      
    -- self:refreshBroadCastMsg()
    self:refreshTableView();

end

function ui_guessing_football_main.createTimeDown( self,parentNode,time_count_down,shwoType,isclose )
    local function timeEndFunc()
        -- self:refreshUi()
        -- self.m_flag = false
    end
    parentNode:removeAllChildrenWithCleanup(true)
    -- local shwoType = shwoType or 3
    local countdownLabel = game_util:createCountdownLabel(time_count_down,timeEndFunc,8);
    countdownLabel:setColor(ccc3(74, 249, 69))
    countdownLabel:setAnchorPoint(ccp(0.5,0.5))
    -- countdownLabel:setOpacity(0)
    local tempcontent = parentNode:getContentSize()
    countdownLabel:setPosition(ccp(tempcontent.width*0.5,tempcontent.height*0.6))
    parentNode:addChild(countdownLabel,10,10) 
end

function ui_guessing_football_main:refreshBroadCastMsg() --跑马灯
    local msgTab = {}
    local msg = {"Không có tin mới",}
    for k,v in pairs(self.m_tGameData.notice or msg) do
        table.insert(msgTab, v)
    end
    -- cclog2(msgTab,"msgTab-=--------")
    if #msgTab > 0  then
        game_util:createScrollViewTips(self.m_scroll_msgBoard, msgTab, true, 2, ccc3(200, 255,255), 10)
    end
end
--[[--
    初始化
]]
function ui_guessing_football_main.init(self,t_params)
    t_params = t_params or {}
    if t_params.gameData ~= nil then
        local data = t_params.gameData:getNodeWithKey("data");

        -- local value = data:getNodeWithKey("value")
        -- self.m_tGameData = json.decode(value:getFormatBuffer()) or {};
         self.m_tGameData = json.decode(data:getFormatBuffer())
    else
        self.m_tGameData = {};
    end
    -- cclog2(self.m_tGameData,"self.m_tGameData.bet_list-=-----=----------")
    self.m_bet_list = self.m_tGameData.bet_list
    -- cclog2(self.m_bet_list,"self.m_bet_list-=-----=----------")

    self.m_version= self.m_tGameData.version
    self.guessing_cfg = {}
    self.m_id = {}
    self.m_game_type ={}
    self.m_type = 1
    local guessing_cfg  = json.decode(getConfig(game_config_field.world_guessing):getFormatBuffer())
    -- cclog2(guessing_cfg,"guessing_cfg-=------------")
    
    for k,v in pairs(guessing_cfg) do
            table.insert(self.m_id,k)
        -- end
    end
    -- cclog2(self.m_id,"self.m_id-=-----------")


    for i=1,game_util:getTableLen(guessing_cfg) do 
        -- if self.m_version ==guessing_cfg.version then 
            self.guessing_cfg[i] = guessing_cfg[tostring(i)]
            self.m_game_type[i] = self.guessing_cfg[i].game_type
            -- cclog2(self.guessing_cfg[i],"self.guessing_cfg[i]-=--------")
        -- end
    end
    self.m_type = nil
    self.m_choose =1
    self.m_first =true
   
end
--[[--
    创建ui入口并初始化数据
]]
function ui_guessing_football_main.create(self,t_params)
    self:init(t_params);
    self.m_tParams = t_params;
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

--[[--
    回调方法
]]
function ui_guessing_football_main.callBackFunc(self)
    local callBackFunc = self.callBackFunc;
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc();
    end
end

return ui_guessing_football_main;