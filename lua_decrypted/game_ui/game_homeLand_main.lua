---  家园

local game_homeLand_main = {
    m_tGameData = nil,
	m_layer_map = nil,
	m_scroll_rect = nil,
	m_layer_build = nil,
    m_temp_ui = nil,
    m_node_editText1 = nil,
    m_node_editText2 = nil,
    m_node_editText3 = nil,
    m_editBox1 = nil,
    m_editBox2 = nil,
    m_editBox3 = nil,
    m_node_adjust = nil,
    m_btn_move = nil,
    m_node_hero = nil,
    m_ccbNode = nil,
    m_tab_ui = nil,--存储需要和人物做碰撞检测的ui
    m_touchView = nil,
    m_homeQuality = nil,
    m_label_name = nil,
    m_node_icon = nil,
    m_node_houseUi = nil,
    m_flag_pop = nil, -- 当前是否存在pop的标识
    m_shared = nil,
    m_sprite_jindutiao = nil,
    m_ccbNode = nil,
    m_tab_nodeBall = nil,
    m_type = nil,
    m_friend_uid = nil,
    m_btn_houseDon = nil,
    m_buildTpye = nil,
    m_node_look = nil,
    m_lookId = nil,
    flag = 0,
    m_get_falg = nil,
};


--[[--
    销毁
]]
function game_homeLand_main.destroy(self)
    cclog("-----------------game_homeLand_main destroy-----------------");
    self.m_tGameData = nil;
	self.m_layer_map = nil;
	self.m_scroll_rect = nil;
	self.m_layer_build = nil;
    self.m_temp_ui = nil;
    self.m_node_editText1 = nil;
    self.m_node_editText2 = nil;
    self.m_node_editText3 = nil;
    self.m_editBox1 = nil;
    self.m_editBox2 = nil;
    self.m_editBox3 = nil;
    self.m_node_adjust = nil;
    self.m_btn_move = nil;
    self.m_node_hero = nil;
    self.m_ccbNode = nil;
    self.m_tab_ui = nil;
    self.m_touchView = nil;
    self.m_homeQuality = nil;     
    self.m_label_name = nil;
    self.m_node_icon = nil;   
    self.m_node_houseUi = nil;  
    self.m_flag_pop = nil; 
    self.m_shared = nil;
    self.m_sprite_jindutiao = nil;
    self.m_ccbNode = nil;
    self.m_tab_nodeBall = nil;
    self.m_type = nil;
    self.m_friend_uid = nil;
    self.m_btn_houseDon = nil;
    self.m_buildTpye = nil;
    self.m_node_look = nil;
    self.m_lookId = nil;
    self.flag = 0;
    self.m_get_falg = nil
end
--[[
	层级关系 zorder
	1 view
	2 草地
	3 路 
	4 各种建筑  zorder 门11，房子是9，路灯是 11
	5 各种道具
	6 人 10
	7 特效
]]
--[[--
    返回
]]
function game_homeLand_main.back(self,type)
    if self.m_shared then
        scheduler:unscheduleAll()
    end
    game_scene:enterGameUi("game_main_scene")
end
--[[--
    读取ccbi创建ui
]]
function game_homeLand_main.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        cclog2(btnTag,"btnTag =--- ")
        if self.m_flag_pop == true then
            return
            -- game_scene:removeAllPop()
        end
        if btnTag == 1 then --返回
            self:back();
        elseif btnTag == 0 then
            local function responseMethod(tag,gameData)
                game_scene:enterGameUi("game_homeLand_main",{gameData = gameData});
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_index"), http_request_method.GET, nil,"homeland_index")
        elseif btnTag == 2 then 
            local function responseMethod(tag,gameData)
                game_scene:addPop("game_homeLand_farm_pop", { gameData = gameData})
               
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_friends"), http_request_method.GET, nil,"homeland_friends")
            -- if self.m_flag_pop == true then
            --     self.m_flag_pop = false
            --     return
            -- end
            -- self.m_flag_pop = true
            -- game_scene:addPop("game_homeLand_visit_pop",{visitData = self.m_tGameData.visit_log})
        elseif btnTag == 3 then 
            local function responseMethod(tag,gameData)
                game_scene:addPop("game_homeLand_shop_pop",{gameData = gameData, types = "capot", use_adorn = self.m_tGameData.use_adorn})
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_store_index"), http_request_method.GET, nil,"homeland_store_index")
        elseif btnTag == 4 then
            local function responseMethod(tag,gameData)
                local data = gameData:getNodeWithKey("data")
                local store = json.decode(data:getNodeWithKey("store"):getFormatBuffer()) 
                game_scene:addPop("game_homeLand_shop_pop",{types = "shop", use_adorn = store})
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_store_index"), http_request_method.GET, nil,"homeland_store_index")
        elseif btnTag == 5 then
            local function responseMethod(tag,gameData)
                game_scene:addPop("game_homeLand_luckyTurn_pop", { gameData = gameData})
               
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("hoemland_roulette_index"), http_request_method.GET, nil,"hoemland_roulette_index")
        elseif btnTag == 6 then
            local function responseMethod( tag,gameData )
				game_scene:enterGameUi("game_godfield_pvp",{gameData = gameData})
			end
			network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena"), http_request_method.GET, {},"god_arena")
        elseif btnTag == 55 then
            local shopid = self.m_lookId
            local params = {}
            params.shop_id = shopid
            local function responseMethod(tag,gameData)
                -- game_util:addMoveTips({text = "恭喜您購買成功，請進入倉庫查看使用"})
                local function responseMethod(tag,gameData)
                    game_scene:enterGameUi("game_homeLand_main",{gameData = gameData,tipsText = "Đã mua vật phẩm này, hãy đến Kho sử dụng~"});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_index"), http_request_method.GET, nil,"homeland_index")
                
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_shop_buy"), http_request_method.GET, params,"homeland_shop_buy")
        elseif btnTag == 56 then
                local function responseMethod(tag,gameData)
                    game_scene:enterGameUi("game_homeLand_main",{gameData = gameData});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_index"), http_request_method.GET, nil,"homeland_index")
                  
        elseif btnTag >100 and btnTag < 107 then
            self:movePx(btnTag)
        elseif btnTag == 201 then --捐献
            local function responseMethod(tag,gameData)
                -- cclog2(gameData,"gameData  help -----=====")
               game_util:addMoveTips({text = "Giúp đỡ thành công"})
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_help"), http_request_method.GET, {friend_uid = self.m_friend_uid}, "homeland_help")
        elseif btnTag == 202 then --详情
            game_scene:addPop("game_active_limit_detail_pop",{enterType = "191"})
        elseif btnTag == 203 then -- 升级
            local function responseMethod(tag,gameData)
                local function responseMethod(tag,gameData)
                    game_scene:enterGameUi("game_homeLand_main",{gameData = gameData});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_index"), http_request_method.GET, nil,"homeland_index")
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_level_up"), http_request_method.GET, {friend_uid = self.m_friend_uid}, "homeland_level_up")
        elseif btnTag == 999 then
            
            local function responseMethod(tag,gameData)
                game_scene:addPop("game_homeLand_luckyTurn_pop", { gameData = gameData})
               
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("hoemland_roulette_index"), http_request_method.GET, nil,"hoemland_roulette_index")
            
            -- local x,y = self.m_node_adjust:getPosition()
            -- if y > 218 then
            --     y = y - 200 
            -- else
            --     y = y + 200
            -- end
            -- self.m_node_adjust:runAction(CCMoveTo:create(0.5,ccp(x,y)))
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
    ccbNode:openCCBFile("ccb/ui_homeLand_main.ccbi");
    self.m_layer_map = ccbNode:layerForName("m_layer_map")
    self.m_sprite_jindutiao = ccbNode:spriteForName("m_sprite_jindutiao")
    self.m_node_adjust = ccbNode:nodeForName("m_node_adjust")
    self.m_node_adjust:setVisible(false)
    
    --cclog2(self.conutdownTime,"self.conutdownTime")
    self.m_scroll_rect = self.m_layer_map:boundingBox()
    -- self.m_node_editText1 = ccbNode:nodeForName("m_node_editText1")
    -- self.m_node_editText2 = ccbNode:nodeForName("m_node_editText2")
    -- self.m_node_editText3 = ccbNode:nodeForName("m_node_editText3")

    -- self.m_editBox1 = game_util:createEditBox({bgFileName = nil,inputMode = kEditBoxInputModePhoneNumber,placeHolder="输入像素",fontColor = ccc3(255,255,255),scriptEditBoxHandler=editBoxTextEventHandle,size = self.m_node_editText1:getContentSize(),maxLength = 3,});
    -- self.m_editBox1:setOpacity(0)
    -- self.m_editBox1:setTouchPriority(-1);
    -- self.m_node_editText1:addChild(self.m_editBox1);

    -- self.m_editBox2 = game_util:createEditBox({bgFileName = nil,inputMode = kEditBoxInputModePhoneNumber,placeHolder="输入像素",fontColor = ccc3(255,255,255),scriptEditBoxHandler=editBoxTextEventHandle,size = self.m_node_editText2:getContentSize(),maxLength = 3,});
    -- self.m_editBox2:setOpacity(0)
    -- self.m_editBox2:setTouchPriority(-1);
    -- self.m_node_editText2:addChild(self.m_editBox2);

    -- self.m_editBox3 = game_util:createEditBox({bgFileName = nil,inputMode = kEditBoxInputModePhoneNumber,placeHolder="输入角度",fontColor = ccc3(255,255,255),scriptEditBoxHandler=editBoxTextEventHandle,size = self.m_node_editText3:getContentSize(),maxLength = 3,});
    -- self.m_editBox3:setOpacity(0)
    -- self.m_editBox3:setTouchPriority(-1);
    -- self.m_node_editText3:addChild(self.m_editBox3);
    self.m_node_look = ccbNode:nodeForName("m_node_look")
    local m_btn_turn = ccbNode:controlButtonForName("m_btn_turn")
    m_btn_turn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    local m_btn_jjc = ccbNode:controlButtonForName("m_btn_jjc")
    m_btn_jjc:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    self.m_btn_move = ccbNode:controlButtonForName("m_btn_move")
    self.m_label_name = ccbNode:labelTTFForName("m_label_name")
    self.m_label_name:setString(game_data:getUserStatusDataByKey("show_name"))
    self.m_node_icon = ccbNode:nodeForName("m_node_icon")
    local roleId =  game_data:getUserStatusDataByKey("role")
    local sprite_head = game_util:createPlayerIconByRoleId(roleId)
    sprite_head:setScale(0.5)
    sprite_head:setAnchorPoint(ccp(0.5, 0.5))
    self.m_node_icon:addChild(sprite_head)

    self.m_btn_houseDon = ccbNode:controlButtonForName("m_btn_houseDon")
    local m_btn_houseUplv = ccbNode:controlButtonForName("m_btn_houseUplv")
    local m_btn_houseDes = ccbNode:controlButtonForName("m_btn_houseDes")
    m_btn_houseDes:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    self.m_btn_houseDon:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    m_btn_houseUplv:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)

    self.m_ccbNode = ccbNode;
    self:onEnter();
    self.m_layer_build = CCLayer:create()

    self.m_node_houseUi = ccbNode:nodeForName("m_node_houseUi")
    self.m_node_houseUi:setVisible(false)
    local m_node_myBtn = ccbNode:nodeForName("m_node_myBtn")
    local m_back_btn = ccbNode:controlButtonForName("m_back_btn")
    if self.m_type and self.m_type == "friends" then
        m_node_myBtn:setVisible(false)
        m_back_btn:setTag(0)
    elseif self.m_type == "look" then
        m_node_myBtn:setVisible(false)
        m_back_btn:setVisible(false)
        self.m_node_look:setVisible(true)
    end

    -- self:createBuilding()
    return ccbNode;

end
--[[
    奖励宝箱的位置
]]
local posRewardBoxTab = {
    ccp(67,177),ccp(111,529),ccp(452,452),ccp(397,364),ccp(497,56),ccp(427,139),ccp(617,265)
}
--[[
    装饰品的位置
]]
local posAdornTab = {
    ccp(543,240), ccp(630,170), ccp(980,300), ccp(590,110), ccp(210,300), ccp(605,460)
}
--[[
    房子的位置
]]
local posHouseTab = {high = ccp(589,410),mid = ccp(649,390),low = ccp(693,400)}

--[[
    树的位置
]]
local treePosTab = {ccp(111,400), ccp(301,540), ccp(501,180), ccp(761,300)}

--[[
    路灯的位置
]]
local posTabLight = {ccp(160,80),ccp(332,282),ccp(667,377)}
--[[
    果实的位置
]]
local ballPosTab = {ccp(-50,-5),ccp(-20,55),ccp(10,10),ccp(26,80),ccp(60,-20),ccp(52,21),ccp(83,55),ccp(31,48)}
--[[
    围墙外的位置

]]
local pointTab = {
    {{0, 0}, {333, 0}, {0, 160}},  
    {{686, 0}, {848, 0}, {842, 86}},
    {{850, 438}, {850, 630}, {468, 630}},
    {{0, 534}, {195, 630}, {0, 630}}
}
function game_homeLand_main.getIntriangleByStartPoint( self, types, startPoint )
    local intriangleTab = {}
    if types == "tree" then
        intriangleTab[1] = {{startPoint.x+110,startPoint.y-8},{startPoint.x + 50, startPoint.y + 103}, {startPoint.x + 140, startPoint.y + 87}}
        intriangleTab[2] = {{startPoint.x -4, startPoint.y + 120},{startPoint.x + 204, startPoint.y + 90}, {startPoint.x + 19, startPoint.y + 162}}
        intriangleTab[3] = {{startPoint.x + 204, startPoint.y + 90},{startPoint.x +118, startPoint.y + 261}, {startPoint.x -2, startPoint.y + 189}}
    elseif types == "light" then
        intriangleTab[1] = {startPoint.x, startPoint.y}
        intriangleTab[2] = {startPoint.x + 23, startPoint.y + 50}
        intriangleTab[3] = {startPoint.x + 52, startPoint.y}
    end 

    -- cclog2(intriangleTab,"intriangleTab ----- ")
    return intriangleTab
end
--[[
    同向法判断点是否在三角形内  point 需要判断的点 node_pos_table 三角形的三个顶点
]]
function game_homeLand_main.isPointIntriangle(self, point, node_pos_table)
    -- cclog2(point,"point ----- ")
    -- cclog2(node_pos_table,"node_pos_table ----- ")

    local function evaluatePointToLine(point, node1, node2)
        local a = node2[2] - node1[2]
        local b = node1[1] - node2[1]
        local c = node2[1] * node1[2] - node1[1] * node2[2]
        return a * point[1] + b * point[2] + c
    end 
    local d1 = evaluatePointToLine(point, node_pos_table[1], node_pos_table[2])
    local d2 = evaluatePointToLine(point, node_pos_table[2], node_pos_table[3])
    local d3 = evaluatePointToLine(point, node_pos_table[3], node_pos_table[1])


    return (d1 * d2 > 0) and (d2 * d3 > 0)
end


--[[
    调整模块ui坐标
]]
-- function game_homeLand_main.movePx( self, btnTag )
--     local x,y = self.m_temp_ui:getPosition()
--     local rotation = self.m_temp_ui:getRotation()
--     local minX = tonumber(self.m_editBox1:getText()) or 1
--     local minY = tonumber(self.m_editBox2:getText()) or 1
--     local minRotation = tonumber(self.m_editBox3:getText()) or 1
--     if btnTag == 101 then 
--         x = x + minX
--     elseif btnTag == 102 then
--         x = x - minX
--     elseif btnTag == 103 then
--         y = y + minY
--     elseif btnTag == 104 then
--         y = y - minY
--     elseif btnTag == 105 then
--         self.m_temp_ui:setRotation(rotation + minRotation)
--     elseif btnTag == 106 then
--         self.m_temp_ui:setRotation(rotation - minRotation)
--     end
--     -- cclog2({x,y},"getPosition ===== ")
--     -- cclog2(rotation,"setRotation ===== ")
--     self.m_temp_ui:setPosition(ccp(x,y))
-- end
--[[
    创建随机奖励
]]
function game_homeLand_main.createRewardBox( self )

    local rewardBoxData = self.m_tGameData.reward_ids
    local posIndex = 1
    for k,v in pairs(rewardBoxData) do
        -- cclog2(rewardBoxData,"boandl ----- ")
        -- cclog2(k,"k ----- " )
        local rewarNode = luaCCBNode:create()
        rewarNode:setPosition(posRewardBoxTab[posIndex])
        posIndex = posIndex + 1
        self.m_touchView:addChild(rewarNode)

        self:createButton(k + 300 , rewarNode, _, "Nightmare_box2.png", ccp(0,0))
        -- self.m_temp_ui = adornSprite
    end
end
--[[
    创建装饰品
]]
function game_homeLand_main.createAdorn( self )
    local adornData = self.m_tGameData.use_adorn
    local posIndex = 1
    -- cclog2(adornData,"adornData -------")
    local cfg_homeland_adorn = getConfig(game_config_field.homeland_adorn)
    if self.m_lookId then
        if tonumber(self.m_lookId) == 8 then --樱花
            animFile = "changjingtexiao_1"
            local function stepEnd( animNode,theId,labelName )
                game_anim:playSection(animNode,labelName)
            end
            local animShouzhi = zcAnimNode:create("changjingtexiao.swf.sam",1,"changjingtexiao.plist");
            animShouzhi:registerScriptTapHandler(stepEnd);
            animShouzhi:playSection(animFile)
            self.m_layer_map:addChild(animShouzhi);
            local viewSize = self.m_layer_map:getContentSize()
            animShouzhi:setPosition(ccp(viewSize.width * 0.5,viewSize.height * 0.5))
            
        elseif tonumber(self.m_lookId) == 9 then --雪花
            animFile = "xuetexiao_1"
            local function stepEnd( animNode,theId,labelName )
                game_anim:playSection(animNode,labelName)
            end
            local animShouzhi = zcAnimNode:create("changjingtexiao.swf.sam",1,"changjingtexiao.plist");
            animShouzhi:registerScriptTapHandler(stepEnd);
            animShouzhi:playSection(animFile)
            self.m_layer_map:addChild(animShouzhi);
            local viewSize = self.m_layer_map:getContentSize()
            animShouzhi:setPosition(ccp(viewSize.width * 0.5,viewSize.height * 0.5))
            
        end
    end
    
    
    for types,c_id in pairs(adornData) do
        -- cclog2(types,"types -----")
        if types == "1" then --场景 
            -- cclog2(c_id,"c_id ----" .. types)
            if c_id == 7 then --沙漠
                self.m_buildTpye = 3
            elseif c_id == 6 then --雪地
                self.m_buildTpye = 2
            end
        elseif types == "3" then -- 特效 
            local animFile = ""
            -- cclog2(c_id,"c_id ---" .. types)
            if c_id == 8 then --樱花
                animFile = "changjingtexiao_1"
            elseif c_id == 9 then --雪花
                animFile = "xuetexiao_1"
            end
            if self.m_lookId then
                break
            end
            local function stepEnd( animNode,theId,labelName )
                game_anim:playSection(animNode,labelName)
            end
            local animShouzhi = zcAnimNode:create("changjingtexiao.swf.sam",1,"changjingtexiao.plist");
            animShouzhi:registerScriptTapHandler(stepEnd);
            animShouzhi:playSection(animFile)
            self.m_layer_map:addChild(animShouzhi);
            local viewSize = self.m_layer_map:getContentSize()
            animShouzhi:setPosition(ccp(viewSize.width * 0.5,viewSize.height * 0.5))
        else --装饰品
            -- if c_id > 6 then
            --     c_id = 6
            -- end
            local iconName = cfg_homeland_adorn:getNodeWithKey(tostring(c_id)):getNodeWithKey("icon"):toStr()
            local adornSprite = CCSprite:createWithSpriteFrameName(iconName .. self.m_buildTpye .. ".png")
            adornSprite:setPosition(posAdornTab[posIndex])
            posIndex = posIndex + 1
            if posIndex > 6 then
                posIndex = 1 
            end
            self.m_touchView:addChild(adornSprite)
        end
            -- self.m_temp_ui = adornSprite
        -- end
    end
end
function game_homeLand_main.createHouseUi( self,parentNode )
    local function setProgress( self, needExp )
        local expBg = self.m_sprite_jindutiao
        local expBgSize = expBg:getContentSize(); 
        local current_score = self.m_tGameData.help_exp
        
        local score_max = needExp or 1
        local percentage = current_score/score_max * 100 
        local label_exp = self.m_ccbNode:labelTTFForName("m_label_exp") 
        if self.m_tGameData.level == 3 then
            label_exp:setString("Đã đầy cấp")
        else
            label_exp:setString(current_score .. "/" .. needExp)
        end
        local params = {}
        params.percentage = percentage
        params.fileName = "ui_homeLandSys_jindutiao1.png"
        local expBarAdd = game_util:createProgressTimer(params)
        expBg:removeAllChildrenWithCleanup(true)
        expBarAdd:setPosition(ccp(expBgSize.width*0.5,expBgSize.height*0.5));
        expBg:addChild(expBarAdd,2,1);
        -- self.m_label_charge:setString("累计充值:(" .. current_score .. "/" .. score_max .. ")")
    end
    local cfg_homeland_evo = getConfig(game_config_field.homeland_evo)
    local needExp = cfg_homeland_evo:getNodeWithKey(tostring(self.m_tGameData.level)):getNodeWithKey("need_exp"):toInt()
    -- cclog2()
    local node_ui = luaCCBNode:create()
    local pX,pY = parentNode:getPosition()
    local tempPos = parentNode:getParent():convertToWorldSpace(ccp(pX,pY))
    -- self.m_node_houseUi:setAnchorPoint(ccp(-0.5,-0.5))
    self.m_node_houseUi:setPosition(ccp(tempPos.x+75,tempPos.y+70))
    self.m_node_houseUi:setVisible(true)

    if self.m_type == "friends" then
        self.m_btn_houseDon:setVisible(true)
    else
        self.m_btn_houseDon:setVisible(false)
    end
    setProgress(self, needExp)
end
function game_homeLand_main.createAnimHand( self,parentNode )

    local function stepEnd( animNode,theId,labelName )
        if labelName == "impact" then
            game_anim:playSection(animNode,"impact1")
        elseif labelName == "impact1" then
            game_anim:playSection(animNode,"impact")
        end
        -- animNode:playSection(labelName);
    end
    local animShouzhi = zcAnimNode:create("shouzhi.swf.sam",1,"shouzhi.plist");
    animShouzhi:registerScriptTapHandler(stepEnd);
    animShouzhi:playSection("impact")
    parentNode:addChild(animShouzhi);

    local function animEndCallFunc()
        local function rewardTipsCallBack(  )
            if self.m_type == "friends" then
                game_scene:enterGameUi("game_homeLand_main", {gameData = self.m_tGameData, types = "friends", friend_uid = self.m_friend_uid})
            else
                game_scene:enterGameUi("game_homeLand_main", {gameData = self.m_tGameData})
            end
        end
        animShouzhi:removeFromParentAndCleanup(true)
        animShouzhi = nil
        parentNode:setVisible(true)
        parentNode = nil
        game_util:rewardTipsByDataTable(self.m_tGameData.reward,rewardTipsCallBack)

    end
    local arrayAnim = CCArray:create()
    local tempSize = parentNode:getContentSize()
    arrayAnim:addObject(CCMoveTo:create(0.4,ccp(50 , 50)))
    arrayAnim:addObject(CCDelayTime:create(0.5))
    arrayAnim:addObject(CCMoveTo:create(0.4,ccp(15 , 25)))
    arrayAnim:addObject(CCDelayTime:create(0.5))
    arrayAnim:addObject(CCMoveTo:create(0.4,ccp(59 , 0)))
    arrayAnim:addObject(CCDelayTime:create(0.5))
    arrayAnim:addObject(CCCallFunc:create(animEndCallFunc))
    animShouzhi:runAction(CCSequence:create(arrayAnim))
    
end
function game_homeLand_main.createShuihu( self,parentNode )
     local function stepEnd( animNode,theId,labelName )
        -- cclog2(labelName,"labelName ----- ")
        if labelName == "impact" then
            game_anim:playSection(animNode,"impact1")
        elseif labelName == "impact1" then
            game_anim:playSection(animNode,"impact2")
        else
            animNode:removeFromParentAndCleanup(true)
            animNode = nil
            local function responseMethod(tag,gameData)
                game_scene:enterGameUi("game_homeLand_main",{gameData = gameData, types = "friends", friend_uid = self.m_friend_uid})
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_visit"), http_request_method.GET, {friend_uid = self.m_friend_uid},"homeland_visit")
            -- for i=1,game_util:getTableLen(self.m_tGameData.farm) do
            --     self:createTrees(view, treePosTab[i], i)
            -- end
        end
        -- animNode:playSection(labelName);
    end
    local animShouzhi = zcAnimNode:create("shuihu.swf.sam",1,"shuihu.plist");
    animShouzhi:registerScriptTapHandler(stepEnd);
    animShouzhi:playSection("impact")
    animShouzhi:setPosition(ccp(0,20));
    parentNode:addChild(animShouzhi);
end
function game_homeLand_main.createTimeDown( self,parentNode,time_count_down,shwoType,isclose )
    local function timeEndFunc()
        if isclose == "get" then
            -- parentNode:removeFromParentAndCleanup()
        elseif self.m_type == "friends" then
            local function responseMethod(tag,gameData)
                game_scene:enterGameUi("game_homeLand_main",{gameData = gameData, types = "friends", friend_uid = self.m_friend_uid})
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_visit"), http_request_method.GET, {friend_uid = self.m_friend_uid},"homeland_visit")
        else
            local function responseMethod(tag,gameData)
                game_scene:enterGameUi("game_homeLand_main",{gameData = gameData});
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_index"), http_request_method.GET, nil,"homeland_index")
      
        end
        
    end
    if parentNode:getChildByTag(101) then
        parentNode:removeChildByTag(101)
    end
    parentNode:removeAllChildrenWithCleanup(true)
    local shwoType = shwoType or 3
    local countdownLabel = game_util:createCountdownLabel(time_count_down,timeEndFunc,8, shwoType);
    countdownLabel:setColor(ccc3(255, 249, 255))
    countdownLabel:setAnchorPoint(ccp(0.5,0.5))
    local tempcontent = parentNode:getContentSize()
    countdownLabel:setPosition(ccp(tempcontent.width*0.5,tempcontent.height*0.1))
    parentNode:addChild(countdownLabel,10,101) 
    -- body
end

function game_homeLand_main.createButton( self, tag, parentNode, myccp, btnImg, pos)
    parentNode:removeAllChildrenWithCleanup(true)
    local function onBtnCilck( event,target )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if self.m_flag_pop == true then
            return
        end
        if self.m_type == "look" then
            return
        end
        if btnTag > 400 and btnTag < 405 then --偷取or摘取
            game_util:addMoveTips({text = "Bạn đang hái quả"})
            local params = {}
            params.farm_id = btnTag - 400
            local function responseMethod(tag,gameData)
                if gameData then
                    
                    local expBg = CCSprite:createWithSpriteFrameName("ui_homeLandSys_jindutiao2.png")
                    tagNode:addChild(expBg)
                    if gameData and tolua.type(gameData) == "util_json" then
                        local data = gameData:getNodeWithKey("data")
                        self.m_tGameData = json.decode(data:getFormatBuffer())
                    elseif gameData and tolua.type(gameData) == "table" then
                        self.m_tGameData = gameData
                    end
                --     if self.m_tGameData.farm[tostring(btnTag-400)].cd_expire and self.m_tGameData.farm[tostring(btnTag-400)].cd_expire > 0 then
                --         local timenode = luaCCBNode:create()
                --         tagNode:addChild(timenode)
                --         self:createTimeDown(timenode,self.m_tGameData.farm[tostring(btnTag-400)].cd_expire,3,"get")
                --     end
                --     local function setHavestProgress( self, curTime, allTime )
                --         -- cclog2(expBg,"expBg- - - -- - ")
                --         self.m_flag_pop = true
                --         local expBgSize = expBg:getContentSize(); 
                --         local current_score = curTime
                        
                --         local score_max = 50 or 1
                --         local percentage = current_score/score_max * 100 
                       
                --         local params = {}
                --         params.percentage = percentage
                --         params.fileName = "ui_homeLandSys_jindutiao1.png"
                --         local expBarAdd = game_util:createProgressTimer(params)
                --         expBg:removeAllChildrenWithCleanup(true)
                --         expBarAdd:setPosition(ccp(expBgSize.width*0.5,expBgSize.height*0.5));
                --         expBg:addChild(expBarAdd,2,1);
                --         if curTime == 50 then
                            expBg:removeFromParentAndCleanup(true)
                --             -- self.m_flag_pop = false
                            self:createBall(tagNode, "get", btnTag)
                --         end
                --     end
                --     local function havestWait( self )
                --         self.m_shared = 0;
                --         local allTime = 50
                --         local curTime = 0
                --         function tick( dt )
                --             allTime = allTime - 1
                --             curTime = curTime + 1
                --             if allTime <= 0 then
                --                 scheduler.unschedule(self.m_shared)
                --                 self.m_shared = nil
                --             end
                --             setHavestProgress(self,curTime,allTime)
                --         end
                --         self.m_shared = scheduler.schedule(tick, 1/10, false)
                --     end
                --     havestWait(self)
                -- else
                    
                end
            end
            if self.m_type == "friends" then
                local function popCallBack(result,gameData)
                    if result == "win" then
                        self.m_tGameData = gameData
                        responseMethod("pop",gameData)
                        -- params.friend_uid = self.m_friend_uid
                        -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_steal_havest"), http_request_method.GET, params,"homeland_steal_havest",true,true)
                    elseif result == "lose" then
                        local function responseMethod( tag,gameData )
                            local data = gameData:getNodeWithKey("data")
                            self.m_tGameData = json.decode(data:getFormatBuffer()) 
                        end
                        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_visit"), http_request_method.GET, {friend_uid = self.m_friend_uid},"homeland_visit")
                    else
                        local function responseMethod2( tag,gameData )
                            self.m_flag_pop = false
                            local data = gameData:getNodeWithKey("data")
                            self.m_tGameData = json.decode(data:getFormatBuffer()) 
                        end
                        network.sendHttpRequest(responseMethod2,game_url.getUrlForKey("homeland_visit"), http_request_method.GET, {friend_uid = self.m_friend_uid},"homeland_visit")
                        
                    end
                end
                local myUid = game_data:getUserStatusDataByKey("uid")
                local finger_result = self.m_tGameData.farm[tostring(btnTag - 400)].finger_result
                local steal_uids = self.m_tGameData.farm[tostring(btnTag - 400)].steal_uids
                for k,v in pairs(finger_result) do
                    if tostring(myUid) == tostring(k) then
                            game_util:addMoveTips({text = "Bạn bị chủ nhân bắt được, ko thể trộm cây này"})
                        return
                    end
                end
                for k,v in pairs(steal_uids) do
                    if tostring(myUid) == tostring(v) then
                            game_util:addMoveTips({text = "Bạn đã trộm của người này"})
                        return
                    end
                end
                game_scene:addPop("ui_homeLand_caiquan_pop",{popCallBack = popCallBack, friend_uid = self.m_friend_uid, farm_id = btnTag - 400})
            else
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_auto_havest"), http_request_method.GET, nil,"homeland_havest")
            end
        elseif btnTag > 500 and btnTag < 505 then  --浇水
            local params = {}
            params.farm_id = btnTag - 500
            params.friend_uid = self.m_friend_uid
            local function responseMethod( tag,gameData )
                local data = gameData:getNodeWithKey("data")
                self.m_tGameData = json.decode(data:getFormatBuffer())
                self.m_flag_pop = true
                -- cclog2(self.m_tGameData,"m_tGameData ---- ")
                game_util:addMoveTips({text = "Đã tăng" .. self.m_tGameData.add_exp .. "điểm EXP Farm"})
                self:createShuihu(tagNode)

            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_watering"), http_request_method.GET, params,"homeland_watering")
            
        elseif btnTag > 300 and btnTag < 400 then -- 开启宝箱或者偷取宝箱

            local params = {}
            params.reward_id = btnTag - 300
            local function responseMethod(tag,gameData)
                -- self:createBall(parentNode, "get", btnTag)
                tagNode:removeFromParentAndCleanup(true);
                game_util:rewardTipsByJsonData(gameData:getNodeWithKey("data"):getNodeWithKey("reward"))
            end
            if self.flag == 1 then --摘取动画播放
                 game_util:addMoveTips({text = "Bạn đang hái quả"})
            elseif   self.flag == 0 then 
                if self.m_type == "friends" then
                    params.friend_uid = self.m_friend_uid
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_rob_reward"), http_request_method.GET, params,"homeland_rob_reward")
                else
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_get_reward"), http_request_method.GET, params,"homeland_get_reward")
                end
            end

        elseif btnTag == 1 then
            self:createHouseUi(parentNode)
        end
    end
    local button = game_util:createCCControlButton(btnImg,"",onBtnCilck)
    if rotation then
    end
    button:setZoomOnTouchDown(true)
    button:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    button:setPosition(pos);
    button:setOpacity(255)
    button:setScale(1)
    button:setTag(tag)
    -- self.m_temp_ui = button
    local parentNodeSize = parentNode:getContentSize()
    -- button:setPreferredSize(CCSizeMake(parentNodeSize.width, parentNodeSize.height));
    parentNode:addChild(button,11);
end
--[[
    创建主角，可行走
]]
function game_homeLand_main.createHero( self, parentNode )
    self.m_node_hero = CCNode:create()
    -- self.m_node_hero:setCascadeOpacityEnabled(true)
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        game_anim:playSection(animNode,theLabelName);
    end
    -- local pX,pY = node:getPosition();
    local animId = 100
    if self.m_tGameData.fight_hero and self.m_tGameData.fight_hero ~= 0 then
        animId = self.m_tGameData.fight_hero
    end
    local animNode = zcAnimNode:create("zhujue" .. animId .. ".swf.sam", 0, "zhujue" .. animId .. ".plist");
    animNode:registerScriptTapHandler(onAnimSectionEnd)
    game_anim:playSection(animNode,"daiji1")
    animNode:setScale(1.5)
    self.m_node_hero = animNode
    if self.m_node_hero then
        if self.m_homeLand_lastPos then
            self:createPersonAnimMove(nil,self.m_homeLand_lastPos,"first")
            -- self.m_node_hero:setPosition(self.m_homeLand_lastPos)
        else
            self.m_node_hero:setPosition(ccp(158,123))
        end
        self.m_node_hero:setAnchorPoint(ccp(0.5,0));
        parentNode:addChild(self.m_node_hero,10,10)
    end

end
function game_homeLand_main.isHeroInBuilding(self, build, tag)
    local posx,posy = build:getPosition()
    local size = build:getContentSize()
    local startPoint = ccp(posx,posy)
    local cx,cy = self.m_node_hero:getPosition();
    -- cclog2(startPoint,"startPoint -=----- ")
    if tag == 302 then
        local intriangleTab = self:getIntriangleByStartPoint("tree", startPoint )
        for i=1,3 do
            posTabxx = intriangleTab[i]
            for j=1,3 do
                local startPos = ccp(posTabxx[j][1],posTabxx[j][2])
                local endPos = startPos
                -- drawLine(startPos,endPos)
            end
            if self:isPointIntriangle({cx,cy},intriangleTab[i]) then
                cclog2(self:isPointIntriangle({cx,cy},intriangleTab[i]),"zjr just gogo ----")
                return self:isPointIntriangle({cx,cy},intriangleTab[i])
            end
        end
    elseif tag == 301 then
        local intriangleTab = self:getIntriangleByStartPoint("light", startPoint )
        for i=1,3 do
            posTabxx = intriangleTab[i]
                local startPos = ccp(posTabxx[1],posTabxx[2])
                local endPos = startPos
                -- drawLine(startPos,endPos)
            if self:isPointIntriangle({cx,cy},intriangleTab) then
                -- cclog2(self:isPointIntriangle({cx,cy},intriangleTab),"zjr just gogo ----")
                return self:isPointIntriangle({cx,cy},intriangleTab)
            end
        end
    end
end
function game_homeLand_main.createPersonAnimMove(self, mAnimNode, pos, isFirst, callBackFunc)
    -- cclog2(pos,"hero pos ==== ")
    if self.m_node_hero == nil then 
        if callBackFunc and type(callBackFunc) == "function" then
            callBackFunc();
        end
        return;
    end
    for i=1,4 do
        local tempPointTab = pointTab[i]
        local moveFlag = self:isPointIntriangle({pos.x,pos.y}, tempPointTab)
        if moveFlag then 
            game_util:addMoveTips({text = "Không thể dời đến vị trí này"})
            return
        end
    end
    
    if pos.y >580 then
        -- game_util:addMoveTips({text = "无法移动到该位置"})
        -- return
    end
    local cx,cy = self.m_node_hero:getPosition();
    -- cclog2({ cx, cy },"zjr ----m_node_hero-----getPosition---------- ")
    local heroWidth,heroHeight = 47.5/2,66.5/2
    local heroRetTab = {ccp(cx + heroWidth/2,cy + heroHeight/2 ), ccp(cx, cy), ccp(cx+heroWidth, cy), ccp(cx, cy + heroHeight), ccp(cx + heroWidth, cy + heroHeight) }
    local zcAnimNode = self.m_node_hero
    self.m_node_hero:stopAllActions();
    
    local pX,pY = self.m_node_hero:getPosition();
    local offsetX,offsetY = pos.x - pX,pos.y - pY;
    if offsetX > 0 then
        if offsetY > 0 then--右上
            zcAnimNode:playSection("pao3");
        elseif offsetY < 0 then--右下
            zcAnimNode:playSection("pao2");
        else
            zcAnimNode:playSection("pao2D");
        end
    else
        if offsetY > 0 then--左上
            zcAnimNode:playSection("pao1");
        elseif offsetY < 0 then--左下
            zcAnimNode:playSection("pao4");
        else
            zcAnimNode:playSection("pao4");
        end
    end
    local tickFlag = false
    local function animEndCallFunc()
        tickFlag = true
        local curSectionName = zcAnimNode:getCurSectionName()
        if curSectionName == "pao3" then
             game_anim:playSection(self.m_node_hero,"daiji1");
        elseif curSectionName == "pao2" then
             game_anim:playSection(self.m_node_hero,"daiji1");
        elseif curSectionName == "pao1" then
             game_anim:playSection(self.m_node_hero,"daiji1");
        elseif curSectionName == "pao4" then
             game_anim:playSection(self.m_node_hero,"daiji1");
        end

        if callBackFunc and type(callBackFunc) == "function" then
            callBackFunc();
        end
        
        local alpha = -1;
        local function drawLine( startPos,endPos )
            local drawNode = ExtDrawNode:create(self.m_node_hero:getContentSize(),1);
            drawNode:drawLine(startPos,endPos, 0.5, ccc4f(0/255, 254/255, 255/255, 1));
            self.m_touchView:addChild(drawNode,999,999)
            -- body
        end
        for i=1,5 do
            local heroPos = heroRetTab[i]
            for k,v in pairs(self.m_tab_ui) do
                local tempBuilding = v
                -- tempBuilding:setOpacity(255)
                local tag = tempBuilding:getTag()
                local tempPos = tempBuilding:convertToNodeSpace(heroPos);
                local fileName = ""
                if tag == 301 then
                    fileName = "ui_homeLand_highLight.png"
                elseif tag == 302 then 
                    fileName = "ui_homeLand_tree.png"
                end
                local tempSize = tempBuilding:getContentSize();

                if tempBuilding:boundingBox():containsPoint(heroPos) then
                    if self:isHeroInBuilding(v,tag) then
                        game_anim:playSection(self.m_node_hero,"daiji2");
                        return
                    else
                    end
                end
            end
        end

    end
    local pix = math.sqrt(math.pow(pos.x - pX, 2) + math.pow(pos.y - pY, 2));
    local moveTime = pix / 90;
    local animArr = CCArray:create();
    if isFirst then
        moveTime = 0
    end
    animArr:addObject(CCMoveTo:create(moveTime,pos));
    animArr:addObject(CCCallFunc:create(animEndCallFunc));
    self.m_node_hero:runAction(CCSequence:create(animArr));
    -- self.m_shared = scheduler.schedule(tick, 1/20, false)
end
--[[
    创建路灯
]]
function game_homeLand_main.createLight(self, parentNode, pos)
    local sp_lightName = "ui_homeLand_".. self.m_homeQuality .. "Light" .. self.m_buildTpye .. ".png" 
    local sp_light = CCSprite:createWithSpriteFrameName(sp_lightName)
    parentNode:addChild(sp_light,9)
    sp_light:setPosition(pos)
    -- self.m_temp_ui = sp_light
    sp_light:setTag(301)
    table.insert(self.m_tab_ui, sp_light)

end
function game_homeLand_main.createBall( self, parentNode, types, btnTag )
    local node_ball = luaCCBNode:create()
    if types == "create" then
        local ballNum = 8 
        local selfHavestTimes = self.m_tGameData.farm[tostring(btnTag)].self_havest_times
        local othersHavestTimes = game_util:getTableLen(self.m_tGameData.farm[tostring(btnTag)].steal_uids)
        ballNum = ballNum - selfHavestTimes - othersHavestTimes
        for i=1,ballNum do
            local sp_ball = CCSprite:createWithSpriteFrameName("ui_homeLandSys_ballOrange.png")
            node_ball:addChild(sp_ball)
            sp_ball:setPosition(ballPosTab[i])
            local randomNum = math.random(1,200) * 0.001
            -- cclog2(randomNum,"aa ---- ")
            local scaleTemp = 0.55 + randomNum
            sp_ball:setScale(scaleTemp)
        end
        local tempSize = parentNode:getContentSize()
        node_ball:setPosition(ccp(tempSize.width * 0.45 , tempSize.height * 0.5))
        parentNode:addChild(node_ball)
        self.m_tab_nodeBall[btnTag] = node_ball

    elseif types == "get" then
        if self.m_tab_nodeBall[btnTag-400] then
            self.flag =1
            if type(self.m_get_falg)  == "table" and #self.m_get_falg > 0 then
                for i,v in ipairs(self.m_get_falg) do
                    self:createAnimHand(self.m_tab_nodeBall[v])
                end
            end
        end
    end
end
--[[
    创建树木
]]
function game_homeLand_main.createTrees( self, parentNode, pos, btnTag )
    local node_tree = CCNode:create()
    pos = pos or ccp(50,50)
    btnTag = btnTag
    local function btnCallBack( event, target )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if self.m_type == "friends" or self.m_type == "look" then
            return
        end

        if self.m_tGameData.farm[tostring(btnTag)] and next(self.m_tGameData.farm[tostring(btnTag)]) then
            return
        end
        if self.m_flag_pop then
            return
        end
        game_scene:addPop("game_homeLand_plant_pop",{framId = btnTag})
    end
    local sp_holeName = "ui_homeLand_hole.png"
    local btn_hole = game_util:createCCControlButton(sp_holeName,"",btnCallBack)
    btn_hole:setPosition(ccp(3,-118))
    btn_hole:setTag(btnTag)
    node_tree:setPosition(pos)
    node_tree:addChild(btn_hole)
    parentNode:addChild(node_tree)


    local width,height = btn_hole:getContentSize().width,btn_hole:getContentSize().height
    if self.m_tGameData.farm[tostring(btnTag)] and next(self.m_tGameData.farm[tostring(btnTag)]) then
        -- cclog2(self.m_tGameData.farm[tostring(btnTag)],"self.m_tGameData.farm[tostring(btnTag)] ==== ")
        local sp_tree = CCSprite:createWithSpriteFrameName("ui_homeLand_tree" .. 1 .. ".png")
        -- local sp_shadow = CCSprite:createWithSpriteFrameName("ui_homeLand_shadow" .. self.m_buildTpye .. ".png")
        sp_tree:setPosition(ccp(pos.x - 101, pos.y  -132))
        sp_tree:setTag(302)
        sp_tree:setOpacity(0)
        table.insert(self.m_tab_ui, sp_tree)
        -- parentNode:addChild(sp_shadow)
        -- sp_shadow:setScale(1)
        -- sp_shadow:setPosition(ccp(pos.x - 15, pos.y  -152))
        local function stepEnd( animNode,theId,labelName )
            game_anim:playSection(animNode,labelName)
        end
        local multiple = self.m_tGameData.farm[tostring(btnTag)].multiple or 1
        if tonumber(multiple) == 5 then --策划设定品质是1，2，3，5，动画是对应的1，2，3，4
            multiple = 4
        end
        local animShouzhi = game_util:createAnimEffect("homeland_tree_" .. multiple,"homeland_tree_" .. multiple,stepEnd);
        if animShouzhi then
            animShouzhi:setSort(false)
            -- local tempsize = self.anim_node:getContentSize()
            animShouzhi:setAnchorPoint(ccp(0.5,0.5));
            animShouzhi:setPosition(ccp(pos.x - 121, pos.y  -112))
            animShouzhi:registerScriptTapHandler(stepEnd);
            game_anim:playSection(animShouzhi,"impact")
            animShouzhi:setScale(3)
            parentNode:addChild(animShouzhi)
        end
        parentNode:addChild(sp_tree)
        
        if self.m_type == "friends" then
            for k,v in pairs(self.m_tGameData.can_watering) do
                if v and v == btnTag then
                    local btnImg = "ui_homeLandSys_btnWater.png"
                    self:createButton(  500 + btnTag, sp_tree, ccp(100,50), btnImg,  ccp(150,50))
                end
            end
        end
        if self.m_tGameData.farm[tostring(btnTag)].matured == 1 then --果实成熟 可摘取
            table.insert(self.m_get_falg,btnTag)
            local btnImg = "ui_homeLandSys_get.png"
            if self.m_type == "friends" then
                btnImg = "ui_homeLandSys_steal.png"
            end
            self:createButton(  400 + btnTag, sp_tree, ccp(100,50), btnImg,  ccp(150,50))
            self:createBall(sp_tree, "create", btnTag)
        else
            local multiple = self.m_tGameData.farm[tostring(btnTag)].multiple or 1
            self:createFruit(self.m_tGameData.farm[tostring(btnTag)].c_id, sp_tree, multiple)
        end
        if self.m_type == "look" then
            
        else
            if self.m_tGameData.farm[tostring(btnTag)].expire > 0 then
                self:createTimeDown(sp_tree,self.m_tGameData.farm[tostring(btnTag)].expire + 2)
            end
        end


    end
    -- self.m_temp_ui = sp_tree
    
end
--[[
    创建预览的果实
]]
function game_homeLand_main.createFruit( self, c_id, parentNode, multiple )
    local multiple = tonumber(multiple)
    local cfg_homeland_grow = getConfig(game_config_field.homeland_grow)
    local itemData = json.decode(cfg_homeland_grow:getNodeWithKey(tostring(c_id)):getFormatBuffer())
    local icon,name,count = game_util:getRewardByItemTable(itemData.item[1])
    count = 0
    for i=1,game_util:getTableLen(itemData.item) do
        count = count + itemData.item[i][3]
    end
    count = multiple * count
    if icon then
        local tempSize = parentNode:getContentSize()

        
        local countLabel = CCLabelTTF:create(" x " .. count,TYPE_FACE_TABLE.Arial_BoldMT,12);
        if self.m_buildTpye == 2 then
            countLabel:setColor(ccc3(25,25,25))
        elseif self.m_buildTpye == 3 then
            countLabel:setColor(ccc3(30,160,90))
        end
        parentNode:addChild(icon)
        icon:addChild(countLabel,99)
        icon:setScale(0.75)
        icon:setPosition(ccp(tempSize.width * 0.5 + 5,  - 5))
        countLabel:setPosition(ccp(icon:getContentSize().width,-5))
    end
end
--[[
    创建围栏 
    参数 父节点 创建数量 起点坐标  node_wallZorderTag nodewall 的zorder
]]
function game_homeLand_main.createWall( self, parentNode, num, startPos, node_wallZorderTag, face )
    local sp_wallNam = "ui_homeLand_".. self.m_homeQuality .. "Wall" .. self.m_buildTpye .. ".png"
    local node_wall = CCNode:create()
    local node_wallZorder = nil

    num = num or 5
    startPos = startPos or ccp(50,50)
    rotation = rotation or 0
    local offsetY,offsetX = 0,0
    if self.m_homeQuality == "high" then
        offsetX = 60
        offsetY = 33
        if self.m_buildTpye == 3 then
          sp_wallNam = "ui_homeLand_".. self.m_homeQuality .. "Wall1.png"
        end
    elseif self.m_homeQuality == "mid" then
       offsetX = 38
       offsetY = 21
        if node_wallZorderTag == 1 then
            node_wallZorder = 12
        elseif node_wallZorderTag == 2 then
            node_wallZorder = 10
        end
    elseif self.m_homeQuality == "low" then
        offsetX = 46
        offsetY = 24
        if node_wallZorderTag == 1 then
            node_wallZorder = 12
        elseif node_wallZorderTag == 2 then
            node_wallZorder = 10
        end
        -- 116   56
    end
    for i=1,num do
        local sp_wall= CCSprite:createWithSpriteFrameName(sp_wallNam)
        local width,height = sp_wall:getContentSize().width,sp_wall:getContentSize().height
        if face then
            sp_wall:setScaleX(-1)
            sp_wall:setPosition(ccp((i-1) * offsetX + 65,(i-1) * (offsetY-3) + 80))
        else
            sp_wall:setPosition(ccp((i-1) * (offsetX+5) + 65,-(i-1) *offsetY + 80))
        end
       
        if face then
            node_wall:addChild(sp_wall,num-i)
        else
            node_wall:addChild(sp_wall)
        end

    end
    node_wall:setPosition(startPos)
    if node_wallZorder then
        parentNode:addChild(node_wall,node_wallZorder)
    else
        parentNode:addChild(node_wall)
    end
    node_wall:setRotation(rotation)
    
end
--[[--
    创建高级建筑物
]]
function game_homeLand_main.createHighBuild(self, parentNode)
    for i=1,23 do
        local sp_roadName = "ui_homeLand_" .. self.m_homeQuality .. "Road" .. self.m_buildTpye .. ".png"
        local scaleX = 1
        local x,y = 0,0
        if self.m_homeQuality == "low" then
            x,y = 5,-3
        elseif self.m_homeQuality == "mid" then
        elseif self.m_homeQuality == "high" then
            sp_roadName = "ui_homeLand_" .. self.m_homeQuality .. "Road" .. self.m_buildTpye .. "1.png"
            if i == 12 then
                sp_roadName = "ui_homeLand_highRoad" .. self.m_buildTpye .. "2.png"
            elseif i == 13 then
                sp_roadName = "ui_homeLand_highRoad" .. self.m_buildTpye .. "2.png"
                scaleX = -1
                y = 10
                x = 22.5
            elseif i >13 then
                x = -63
                y = 20
            else
            end
        end
        local sp_road = CCSprite:createWithSpriteFrameName(sp_roadName)
        local width,height = sp_road:getContentSize().width,sp_road:getContentSize().height

        sp_road:setPosition(ccp((i-1) * 31 + 65 + x,(i-1) *16 + 80 + y))
        sp_road:setScaleX(scaleX)
        parentNode:addChild(sp_road)
        if i == 1 then
            -- self.m_temp_ui = sp_road
        end
        if i == 4 then
            local sp_door = CCSprite:createWithSpriteFrameName("ui_homeLand_".. self.m_homeQuality .. "Door" .. self.m_buildTpye ..".png")
           
            sp_door:setPosition(ccp(43,63))
            parentNode:addChild(sp_door,11)
        end
        if i == 23 then
            local sp_house = CCSprite:createWithSpriteFrameName("ui_homeLand_".. self.m_homeQuality .. "House" .. self.m_buildTpye ..".png")
            sp_house:setPosition(posHouseTab[self.m_homeQuality])
            sp_house:setOpacity(0)
            local btnImg = "ui_homeLand_".. self.m_homeQuality .. "House" .. self.m_buildTpye .. ".png"
            if self.m_homeQuality == "high" then
                self:createButton(1, sp_house, 1.8, btnImg, ccp(115,110))
            elseif self.m_homeQuality == "mid" then
                self:createButton(1, sp_house, 1.8, btnImg, ccp(88,95))
            elseif self.m_homeQuality == "low" then 
                self:createButton(1, sp_house, 1.8, btnImg, ccp(70,68))
            end
            parentNode:addChild(sp_house,9)
        end
    end
end
--[[
	创建背景草地
]]
function game_homeLand_main.createMeadow( self, parentNode )
	local num1 = 2
	local num2 = 4
    local spName = {"ui_homeLand_meadow.png","ui_homeLand_snow.png","ui_homeLand_shamo.png"}
	local meadowBatchNode = CCSpriteBatchNode:create("ccbResources/ui_homeLand_tree-hd.pvr.ccz");
    meadowBatchNode:setContentSize(CCSizeMake(1136 * 1.5/2, 640)) 
    for x=1,2 do
        for y=1,4 do
            local sp_meadow = CCSprite:createWithSpriteFrameName(spName[self.m_buildTpye]);
            local width,height = sp_meadow:getContentSize().width,sp_meadow:getContentSize().height
            sp_meadow:setPosition(ccp((x-1) * width,(y-1) * height+ 80) )
            sp_meadow:getTexture():setAliasTexParameters()
            -- local posX,posY = sp_meadow:getPosition()
            meadowBatchNode:addChild(sp_meadow);
             if y > 1 then
                local posX,posY = sp_meadow:getPosition()
                sp_meadow:setPosition(ccp(posX,posY - (y-1)*3))
             end
             if x > 1 then
                local posX,posY = sp_meadow:getPosition()
                sp_meadow:setPosition(ccp(posX- (x-1)*2,posY))
             end
        end
    end
    parentNode:addChild(meadowBatchNode)
    -- for x=1,2 do
	-- 	for y=1,4 do
 --            cclog2(spName[self.m_buildTpye],"x0000----------")
	-- 		local sp_meadow = CCSprite:createWithSpriteFrameName(spName[self.m_buildTpye])
	-- 		local width,height = sp_meadow:getContentSize().width,sp_meadow:getContentSize().height
	-- 		sp_meadow:setPosition(ccp((x-1) * width,(y-1) * height))
 --            sp_meadow:getTexture():setAliasTexParameters()
	-- 		parentNode:addChild(sp_meadow)
 --            
			
 --            if y > 2 then
	-- 			sp_meadow:setPosition(ccp(posX,posY- (y-1)*2))
	-- 		end
	-- 		if x > 1 then
	-- 			sp_meadow:setPosition(ccp(posX- (x-1)*2,posY))
	-- 		end
	-- 	end
	-- end
end
function game_homeLand_main:createScrollContent( parentNode )
    local container = CCLayer:create()
    local size = parentNode:getContentSize()
    local view = CCScrollView:create(size, container)
    maxOffsetX = 0
    maxOffsetY = 0
    view:setAnchorPoint(ccp(0,0))
    container:setContentSize(CCSizeMake(size.width, size.height))
    view:setContentSize(CCSizeMake(1136 * 1.5/2, 640))
    view:setContentOffset(ccp(0, 0));
    view:setTouchEnabled(false)
    view:setPosition(ccp(-1,-6))
    self:createMeadow(view)
    self:createHighBuild(view)
    self.m_touchView = view
    local numTab = {3, 1,  10, 5, 4}
    local wallPosTab = {ccp(113, -15), ccp(-50, 63),  ccp(240, 650), ccp(-100, 450), ccp(660, -75)}
    
    if self.m_homeQuality == "high" then
    elseif self.m_homeQuality == "mid" then
        numTab = {4, 2,  10, 5, 4}
        wallPosTab = {ccp(109, -9), ccp(-76, 84), ccp(390, 560), ccp(-55, 490), ccp(660, -75)}
    
    elseif self.m_homeQuality == "low" then 
        numTab = {4, 2,  10, 5, 4}
        wallPosTab = {ccp(90, -12), ccp(-83, 71),  ccp(390, 560), ccp(-55, 490), ccp(660, -75)}
    end
    for i=1,5 do --创建围墙
        local faceFlag = false
        if i > 3 then
            faceFlag = true
        end
        self:createWall(view, numTab[i], wallPosTab[i], i, faceFlag)
    end
   

    
    if self.m_homeQuality == "high" then
    else
        posTabLight[3] = ccp(687,367)
    end
    for i=1,3 do
       self:createLight(view, posTabLight[i])
    end
    self.m_get_falg = {}
    for i=1,game_util:getTableLen(self.m_tGameData.farm) do
        self:createTrees(view, treePosTab[i], i)
    end
    self:createHero(container)
    maxOffsetX = display.height_design - (size.width / size.height - 1.3) * 120
    maxOffsetY = 500
    if self.m_homeLand_offsetX and self.m_homeLand_offsetY then
        view:setContentOffset(ccp(self.m_homeLand_offsetX,self.m_homeLand_offsetY))
    end
    return view
   
end

function game_homeLand_main:onEnter(  )
    local touchMoveFlag = false
    local selectFlag = false
    local selectIndex = nil
    local scrollviewOffset = nil
    local function layerTouch(eventType, x, y)
        if self.m_flag_pop then
            return
        end
        self.m_node_houseUi:setVisible(false)
        if eventType == "began" then
            cclog("onTouchBegan: ", x, y)
            touchMoveFlag = false
            selectFlag = false

            touch_start_x = x
            touch_start_y = y
            local touched = self.m_scroll_rect:containsPoint(ccp(x, y))
            scrollviewOffset = self.m_scroll_view:getContentOffset()
            return touched
        elseif eventType == "moved" then
            -- cclog("onTouchMoved: ", x, y)
            --不让划出图片
            -- if scrollviewOffset.x + (x - touch_start_x) > -1136 and scrollviewOffset.x + (x - touch_start_x) < 0 then
            local srcollviewOffsetX = scrollviewOffset.x + (x - touch_start_x)
            local srcollviewOffsetY = scrollviewOffset.y + (y - touch_start_y)
            cclog2(srcollviewOffsetX,"-----x")
            cclog2(srcollviewOffsetY,"-----y")
            -- cclog2(srcollviewOffsetX,"srcollviewOffsetX")
            if srcollviewOffsetX > 400 then
                srcollviewOffsetX = 400
            end
            if srcollviewOffsetY > 0 then
                srcollviewOffsetY = 0
            end
            if srcollviewOffsetX < - maxOffsetX then
                srcollviewOffsetX = - maxOffsetX
            end
            if srcollviewOffsetY < - maxOffsetY then
                srcollviewOffsetY = - maxOffsetY
            end
            if ccpDistance(ccp(touch_start_x,touch_start_y),ccp(x,y)) > 20 then
                touchMoveFlag = true
            end
            self.m_homeLand_offsetX,self.m_homeLand_offsetY = srcollviewOffsetX, srcollviewOffsetY
            self.m_scroll_view:setContentOffset(ccp( srcollviewOffsetX, srcollviewOffsetY))
        elseif eventType == "ended" then
            if touchMoveFlag then
            else
                self.m_homeLand_lastPos = ccp(x - scrollviewOffset.x, y - scrollviewOffset.y)
                self:createPersonAnimMove(nil,ccp(x - scrollviewOffset.x, y - scrollviewOffset.y));
            end
        end
    end
    
    self.m_layer_map:registerScriptTouchHandler(layerTouch, false, 2, true)
    self.m_layer_map:setTouchEnabled(true)

end

--[[--
    刷新ui
]]
function game_homeLand_main.refreshUi(self)
    -- cclog2(self.m_buildTpye,"m_buildTpye -----")
    self.m_layer_map:removeAllChildrenWithCleanup(true);
    local w = self.m_layer_map:getContentSize().width
    local h = self.m_layer_map:getContentSize().height

    --cclog2(self.m_layer_map.getContentSize().height,"sheight")
    self.m_scroll_view =  self:createScrollContent(self.m_layer_map)
    self.m_layer_map:addChild(self.m_scroll_view)
    self:createAdorn()
    

    self:createRewardBox()
    if self.m_type == "friends" then
         self.m_label_name:setString(self.m_tGameData.name) 
    end
    if self.m_type == "look" then
        -- self.m_node_myBtn:setVisible(false)
    end
end


--[[--
    初始化
]]
function game_homeLand_main.init(self,t_params)
    t_params = t_params or {};
    self.m_tab_nodeBall = {}
    self.m_flag_pop = false

    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_homeLand_tree.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_homeLand.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_worldTree.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_nightmare.plist")
    self.m_tab_ui = {}
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        data = json.decode(data:getFormatBuffer())
        self.m_tGameData = data
    elseif t_params.gameData and tolua.type(t_params.gameData) == "table" then
        self.m_tGameData = t_params.gameData
    end
    if t_params.types then
        self.m_type = t_params.types
    end

    if t_params.friend_uid then
        self.m_friend_uid = t_params.friend_uid
    end
    -- self.m_tGameData.level = 3
    local adornData = self.m_tGameData.use_adorn
    self.m_buildTpye = 1
    local cfg_homeland_adorn = getConfig(game_config_field.homeland_adorn)
    -- cclog2(adornData,"adornData ---- ")
    for types,c_id in pairs(adornData) do

        if tostring(types) == "1" then --场景 
            if c_id == 7 then --沙漠
                self.m_buildTpye = 3
            elseif c_id == 6 then --雪地
                self.m_buildTpye = 2
            end
        end
    end
    if t_params.lookId then
        self.m_lookId = t_params.lookId
        cclog2(t_params.lookId,"lookId ---- ")
        if tonumber(t_params.lookId) == 7 then
            self.m_buildTpye = 3
        elseif tonumber(t_params.lookId) == 6 then
            self.m_buildTpye = 2
        end
    end
    if t_params.tipsText then
        game_util:addMoveTips({text = t_params.tipsText})
    end
    -- cclog2(self.m_tGameData,"self.m_tGameData === ")
    local qualityNameTAB = {"low", "mid", "high"}
    -- self.m_tGameData.level = 2 
    self.m_homeQuality = qualityNameTAB[self.m_tGameData.level]
    self.flag = 0

end
--[[--
    创建入口
]]
function game_homeLand_main.create(self,t_params)
    self:init(t_params);
    local rootScene = CCScene:create();
    rootScene:addChild(self:createUi());
    self:refreshUi();
    -- self:openBuildingDetailPop();
    -- self:showMainSceneTips();
    return rootScene;
end
return game_homeLand_main;   ��  