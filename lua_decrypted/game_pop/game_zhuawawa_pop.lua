---  游戏设置

local game_zhuawawa_pop = {
    m_popUi = nil,
    m_root_layer = nil,
    m_root_layer2 = nil,
    m_root_layer3 = nil,

    m_sp_left = nil,
    m_sp_righ = nil,
    m_btn_go = nil,
    m_btn_rank = nil,
    m_btn_rule = nil,

    m_lb_times = nil,
    m_node_zhuazi = nil,
    m_node_balls = nil,
    m_node_balls2 = nil,
    m_sp_zhuazi_left = nil,
    m_sp_zhuazi_right = nil,
    m_sp_gan = nil,

    m_lb_mine_name = nil,
    m_lb_mine_rank = nil,
    m_node_mine_icon = nil,
    m_lb_top_rank = nil,
    m_lb_mine_use = nil,

    m_lb_rules = nil,
    m_lb_act_lasts = nil,
    m_lb_free = nil,

    m_node_rank = nil,
    m_node_list = nil,
    m_sp_relreward = nil,
    m_node_rule = nil,

    -----------------------------
    m_cfg_toy = nil,
    m_cfg_toy_reward = nil,

    m_balls = nil,

    m_lrbtn_posY = nil,
    m_shared = nil,
    m_shared_touch = nil,
    m_shared_gan = nil,
    m_balls_pos_tb = nil,
    m_catch_flag = nil,
    m_cur_usetimes = nil,
    m_version = nil,
    
    m_hard_lv = nil,
    m_all_rank = nil,
    m_cfg_rank_reward = nil,
    m_sc_rules = nil,
    m_data_cost = nil,
    rank_rew_tb = nil,
};
--[[--
    销毁
]]
function game_zhuawawa_pop.destroy(self)
    -- body
    cclog("-----------------game_zhuawawa_pop destroy-----------------");
    self.m_popUi = nil;
    self.m_root_layer = nil;
    self.m_root_layer2 = nil;
    self.m_root_layer3 = nil;

    self.m_sp_left = nil;
    self.m_sp_righ = nil;
    self.m_btn_go = nil;
    self.m_btn_rank = nil;
    self.m_btn_rule = nil;

    self.m_lb_times = nil;
    self.m_node_zhuazi = nil;
    self.m_node_balls = nil;
    self.m_node_balls2 = nil;
    self.m_sp_zhuazi_left = nil;
    self.m_sp_zhuazi_right = nil;
    self.m_sp_gan = nil;

    self.m_lb_mine_name = nil;
    self.m_lb_mine_rank = nil;
    self.m_node_mine_icon = nil;
    self.m_lb_top_rank = nil;
    self.m_lb_mine_use = nil;

    self.m_lb_rules = nil;
    self.m_lb_act_lasts = nil
    self.m_lb_free = nil
    self.m_balls = nil
    self.m_node_rank = nil
    self.m_node_list = nil
    self.m_sp_relreward = nil
    self.m_node_rule = nil

    self.m_lrbtn_posY = nil

    self.m_shared = nil
    self.m_shared_touch = nil
    self.m_shared_gan = nil
    self.m_balls_pos_tb = nil
    self.m_catch_flag = nil
    self.m_cur_usetimes = nil
    self.m_version = nil
    self.m_cfg_toy = nil
    self.m_cfg_toy_reward = nil
    self.m_hard_lv = nil
    self.m_all_rank = nil
    self.m_cfg_rank_reward = nil
    self.m_sc_rules = nil
    self.m_data_cost = nil
    self.rank_rew_tb = nil
end

--[[--
    返回
]]
function game_zhuawawa_pop.back(self)
    game_scene:enterGameUi("game_main_scene")
    if self.m_shared then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared)
        self.m_shared = nil
    end
    if self.m_shared_touch then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared_touch)
        self.m_shared_touch = nil
    end
    if self.m_shared_gan then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared_gan)
        self.m_shared_gan = nil
    end
end
--[[--
    读取ccbi创建ui
]]
function game_zhuawawa_pop.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 999 then--关闭
            self:back();
        -- elseif btnTag == 1 then --left
        -- elseif btnTag == 2 then --right
        elseif btnTag == 3 then --go
            if self.m_catch_flag == 1 then return end
            if self.m_cur_usetimes < self.m_data_cost  and self.m_tGameData.free > 0 then
                game_util:addMoveTips({text = "Không đủ đạo cụ, hãy chờ kết thúc CD miễn phí hoặc vào shop mua!"})
                return
            end
            if self.m_tGameData.remain_time <= 0 then
                game_util:addMoveTips({text = "Event đã kết thúc"})
                return
            end
            -- 第一层 80   第二层 105
            self.m_catch_flag = 1
            local target_k = nil
            local cur_x = self.m_sp_gan:getPositionX()
            for k,v in pairs(self.m_balls_pos_tb) do
                local offset = math.abs(v.x - cur_x)
                if offset <= self.m_hard_lv then
                    target_k = k
                end
            end
            local gan_size_w = self.m_sp_gan:getContentSize().width
            local gan_size_h = self.m_sp_gan:getContentSize().height
            local direction = 1 -- 1下  2上
            local ballfall_flag = 0
            local max_height = (target_k and target_k%2 == 1 ) and 80 or 105
            if target_k then
                local function ResponseMethod(tag,gameData)
                    if self.m_tGameData.free > 0 then
                        self.m_cur_usetimes = self.m_cur_usetimes - self.m_data_cost 
                        self.m_lb_times:setString(self.m_cur_usetimes)
                    end
                    local data = gameData:getNodeWithKey("data")
                    self.m_tGameData = json.decode(data:getFormatBuffer())
                    local cur_reward = self.m_tGameData.cur_reward
                    self.m_balls = self.m_balls or {}
                    if self.m_tGameData.rewards then
                        for k,v in pairs(self.m_tGameData.rewards) do
                            self.m_balls[tonumber(k)].id =tonumber(k)
                            self.m_balls[tonumber(k)].reward = v
                        end
                    end
                    local function ballfall()
                        ballfall_flag = 1
                        local function fallcallback1(node)
                            self.m_balls[target_k].ball_bg:setVisible(true)
                            game_util:addMoveTips({text = "Gắp thất bại!"})
                        end
                        local function fallcallback(node)
                            ballfall_flag = 0
                            self.m_catch_flag = 2
                            game_util:rewardTipsByDataTable(self.m_tGameData.reward)
                            self.m_node_balls2:removeChildByTag(1,true)
                            self.m_node_balls:removeAllChildrenWithCleanup(true)
                            self:setBalls()
                        end
                        local arr = CCArray:create();
                        arr:addObject(CCMoveTo:create(0.4,ccp(self.m_balls_pos_tb[target_k].x,self.m_balls_pos_tb[target_k].y)))
                        arr:addObject(CCCallFuncN:create(fallcallback1));
                        arr:addObject(CCDelayTime:create(1));
                        arr:addObject(CCCallFuncN:create(fallcallback));
                        self.m_balls[target_k].node_ball:runAction(CCSequence:create(arr));
                    end
                    local function finalcal()
                        self.m_catch_flag = 2
                        self.m_node_balls2:removeChildByTag(1,true)
                        self.m_node_balls:removeAllChildrenWithCleanup(true)
                        self:setBalls()
                    end
                    if self.m_shared_gan == nil then
                        local cur_h = gan_size_h
                        function tick()
                            -- cclog("==============$$$$$$$$   tick m_shared_gan  33333 ====== cur_h",cur_h)
                            cur_h = (direction == 1) and (cur_h + 4) or (cur_h - 2)
                            if cur_h<=max_height and cur_h > 26 then
                                self.m_sp_gan:setContentSize(CCSizeMake(gan_size_w, cur_h))
                                self.m_node_zhuazi:setPositionY(self.m_sp_gan:getPositionY()-cur_h)
                                if direction == 2 and cur_h >= 60 then
                                    self.m_balls[target_k].node_ball:setPosition(ccp(self.m_node_zhuazi:getPositionX(),self.m_node_zhuazi:getPositionY()-50))
                                elseif direction == 2 and cur_h < 60 and cur_h >= 40 then
                                    local kd = (cur_h/2)%2 == 1 and 1 or -1
                                    self.m_balls[target_k].node_ball:setPosition(ccp(self.m_node_zhuazi:getPositionX()+4*kd,self.m_node_zhuazi:getPositionY()-50))
                                    self.m_node_zhuazi:setRotation(-3*kd)
                                elseif direction == 2 and cur_h < 40 then
                                    if self.m_tGameData.get_type == 1 then
                                        self.m_balls[target_k].node_ball:setPosition(ccp(self.m_node_zhuazi:getPositionX(),self.m_node_zhuazi:getPositionY()-50))
                                        self.m_node_zhuazi:setRotation(0)
                                    else
                                        if ballfall_flag == 0 then
                                            ballfall(target_k)
                                        end
                                    end
                                end
                            elseif cur_h <= 26 then
                                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared_gan)
                                self.m_shared_gan = nil
                                if self.m_tGameData.get_type == 1 then
                                    self.m_balls[target_k].node_ball:setVisible(false)
                                    game_sound:playUiSound("gacha")
                                    --[[
                                        紫色 -- impact1:34  -- impact1@1:34  -- impact2:19  -- impact2@1:19
                                        黄色 -- impact3:34  -- impact3@1:34  -- impact4:19  -- impact4@1:19
                                    ]]
                                    local animFile = "niudan"
                                    local tempNode = CCNode:create()
                                    self.m_node_balls2:addChild(tempNode)
                                    tempNode:setTag(1)
                                    tempNode:setPosition(ccp(self.m_node_balls2:getContentSize().width/2,self.m_node_balls2:getContentSize().height/2))
                                    local m_iAnim1 = zcAnimNode:create(animFile .. ".swf.sam",0,animFile .. ".plist")
                                    local m_iAnim2= zcAnimNode:create(animFile .. ".swf.sam",0,animFile .. ".plist")
                                    
                                    tempNode:addChild(m_iAnim1)
                                    tempNode:addChild(m_iAnim2)
                                    m_iAnim1:setAnchorPoint(ccp(0.5,0.5))
                                    m_iAnim2:setAnchorPoint(ccp(0.5,0.5))
                                    local impact11 = target_k%2 == 1 and "impact3" or "impact1"
                                    local impact12 = target_k%2 == 1 and "impact4" or "impact2"
                                    local impact21 = target_k%2 == 1 and "impact3@1" or "impact1@1"
                                    local impact22 = target_k%2 == 1 and "impact4@1" or "impact2@1"
                                    m_iAnim1:playSection(impact11)
                                    m_iAnim2:playSection(impact21)
                                    local  over1 = 0
                                    local  over2 = 0
                                    local function animEnd(animNode,theId,lableName)
                                        if lableName == impact11 then
                                            m_iAnim1:playSection(impact21)
                                            m_iAnim2:playSection(impact22)
                                            local _icon,_name,_count = game_util:getRewardByItemTable(cur_reward,false)
                                            local namelb = game_util:createLabelTTF({text = _name.." X".._count,color = ccc3(255,255,255),fontSize = 12})
                                            _icon:addChild(namelb)
                                            namelb:setAnchorPoint(ccp(0.5,0.5))
                                            namelb:setScale(0.8)
                                            namelb:setPosition(ccp(_icon:getContentSize().width/2,_icon:getContentSize().height*-0.3))
                                            tempNode:addChild(_icon)
                                            _icon:setScale(1.3)
                                            local function fallcallback2(node)
                                                over1 = 1
                                                if over1 == 1 and over2 ==1 then
                                                    finalcal()
                                                end
                                            end
                                            local arr = CCArray:create();
                                            arr:addObject(CCScaleTo:create(0.5,1.5))
                                            arr:addObject(CCDelayTime:create(1))
                                            arr:addObject(CCScaleTo:create(0.5,1))
                                            arr:addObject(CCCallFuncN:create(fallcallback2))
                                            _icon:runAction(CCSequence:create(arr))

                                        elseif lableName == impact21 then
                                            over2 = 1
                                            if over1 == 1 and over2 ==1 then
                                                finalcal()
                                            end
                                        end
                                    end
                                    m_iAnim1:registerScriptTapHandler(animEnd)
                                else
                                    self.m_sp_zhuazi_left:setRotation(50)
                                    self.m_sp_zhuazi_right:setRotation(-50)
                                end
                            else
                                self.m_sp_zhuazi_left:setRotation(40)
                                self.m_sp_zhuazi_right:setRotation(-40)
                                self.m_balls[target_k].node_ball:setPosition(ccp(self.m_node_zhuazi:getPositionX(),self.m_node_zhuazi:getPositionY()-50))
                                self.m_balls[target_k].ball_bg:setVisible(false)
                                direction = 2
                                cur_h = cur_h - 4
                                self.m_sp_gan:setContentSize(CCSizeMake(gan_size_w, cur_h))
                                self.m_node_zhuazi:setPositionY(self.m_sp_gan:getPositionY()-cur_h)
                            end
                        end
                        self.m_shared_gan = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 0.1 , false)
                    end
                end
                local params = {};
                params.reward_id = target_k
                params.catch = 1
                network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("toy_get_toy"), http_request_method.GET, params,"toy_get_toy")
            else
                local function ResponseMethod(tag,gameData)
                    if self.m_tGameData.free > 0 then
                        self.m_cur_usetimes = self.m_cur_usetimes - self.m_data_cost 
                        self.m_lb_times:setString(self.m_cur_usetimes)
                    end
                    local data = gameData:getNodeWithKey("data")
                    self.m_tGameData = json.decode(data:getFormatBuffer())

                    if self.m_shared_gan == nil then
                        local cur_h = gan_size_h
                        function tick()
                            cur_h = (direction == 1) and (cur_h + 4) or (cur_h - 2)
                            if cur_h <= max_height and cur_h > 26 then
                                self.m_sp_gan:setContentSize(CCSizeMake(gan_size_w, cur_h))
                                self.m_node_zhuazi:setPositionY(self.m_sp_gan:getPositionY()-cur_h)
                            elseif cur_h <= 26 then
                                self.m_sp_zhuazi_left:setRotation(50)
                                self.m_sp_zhuazi_right:setRotation(-50)
                                self.m_catch_flag = 2
                                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared_gan)
                                self.m_shared_gan = nil 
                                if direction == 2 then

                                    local function failcallback1(node)
                                        game_util:addMoveTips({text = "Gắp thất bại!"})
                                    end
                                    local function failcallback2(node)
                                        game_util:rewardTipsByDataTable(self.m_tGameData.reward)
                                    end
                                    local arr = CCArray:create();
                                    arr:addObject(CCCallFuncN:create(failcallback1))
                                    arr:addObject(CCDelayTime:create(1))
                                    arr:addObject(CCCallFuncN:create(failcallback2))
                                    self.m_sp_gan:runAction(CCSequence:create(arr))
                                end
                            else
                                self.m_sp_zhuazi_left:setRotation(40)
                                self.m_sp_zhuazi_right:setRotation(-40)
                                direction = 2
                                cur_h = cur_h - 4
                                self.m_sp_gan:setContentSize(CCSizeMake(gan_size_w, cur_h))
                                self.m_node_zhuazi:setPositionY(self.m_sp_gan:getPositionY()-cur_h)
                            end
                        end
                        self.m_shared_gan = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 0.1 , false)
                    end
                end
                local params = {};
                params.reward_id = 1
                params.catch = 0
                network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("toy_get_toy"), http_request_method.GET, params,"toy_get_toy")
            end
        elseif btnTag == 4 then --rule
            if self.m_catch_flag == 1 then return end
            self.m_node_rule:setVisible(true)
            self.m_root_layer3:setTouchEnabled(true);
        elseif btnTag == 5 then --rank
            if self.m_catch_flag == 1 then return end

            local function ResponseMethod(tag,gameData)
                local data = gameData:getNodeWithKey("data")
                data = json.decode(data:getFormatBuffer())
                self:setRank(data)
            end
            local params = {};
            network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("toy_get_rank"), http_request_method.GET, params,"toy_get_rank")
        elseif btnTag == 20 then --关闭排行榜
            self.m_node_rank:setVisible(false)
            self.m_root_layer2:setTouchEnabled(false);
        elseif btnTag == 30 then --关闭说明
            self.m_node_rule:setVisible(false)
            self.m_root_layer3:setTouchEnabled(false);
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
    ccbNode:openCCBFile("ccb/game_activity_zhuawawa.ccbi");
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    self.m_root_layer2 = ccbNode:layerForName("m_root_layer2")
    self.m_root_layer3 = ccbNode:layerForName("m_root_layer3")

    self.m_lb_times = ccbNode:labelTTFForName("m_lb_times")
    self.m_node_zhuazi = ccbNode:nodeForName("m_node_zhuazi")
    self.m_node_balls = ccbNode:nodeForName("m_node_balls")
    self.m_node_balls2 = ccbNode:nodeForName("m_node_balls2")
    self.m_sp_zhuazi_left = ccbNode:spriteForName("m_sp_zhuazi_left")
    self.m_sp_zhuazi_right = ccbNode:spriteForName("m_sp_zhuazi_right")
    self.m_sp_gan = ccbNode:scale9SpriteForName("m_sp_gan")

    self.m_lb_mine_name = ccbNode:labelTTFForName("m_lb_mine_name")
    self.m_lb_mine_rank = ccbNode:labelTTFForName("m_lb_mine_rank")
    self.m_node_mine_icon = ccbNode:nodeForName("m_node_mine_icon")
    self.m_lb_top_rank = ccbNode:labelTTFForName("m_lb_top_rank")
    self.m_lb_mine_use = ccbNode:labelTTFForName("m_lb_mine_use")

    self.m_lb_rules = ccbNode:labelTTFForName("m_lb_rules")
    self.m_lb_act_lasts =  ccbNode:labelTTFForName("m_lb_act_lasts")
    self.m_lb_free =  ccbNode:labelTTFForName("m_lb_free")

    self.m_sp_left = ccbNode:spriteForName("m_sp_left")
    self.m_sp_right = ccbNode:spriteForName("m_sp_right")
    self.m_btn_go = ccbNode:controlButtonForName("m_btn_go")
    self.m_btn_rank = ccbNode:controlButtonForName("m_btn_rank")
    self.m_btn_rule = ccbNode:controlButtonForName("m_btn_rule")

    self.m_node_rank = ccbNode:nodeForName("m_node_rank")
    self.m_node_list = ccbNode:nodeForName("m_node_list")
    self.m_sp_relreward = ccbNode:spriteForName("m_sp_relreward")
    self.m_node_rule = ccbNode:nodeForName("m_node_rule")
    self.m_node_rank:setVisible(false)
    self.m_node_rule:setVisible(false)
    self.m_sc_rules = ccbNode:scrollViewForName("m_sc_rules")

    self.m_btn_go:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.m_btn_rank:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.m_btn_rule:setTouchPriority(GLOBAL_TOUCH_PRIORITY-5)
    ccbNode:controlButtonForName("m_close_btn"):setTouchPriority(GLOBAL_TOUCH_PRIORITY-1)
    ccbNode:controlButtonForName("m_close_btn2"):setTouchPriority(GLOBAL_TOUCH_PRIORITY-4)
    ccbNode:controlButtonForName("m_close_btn3"):setTouchPriority(GLOBAL_TOUCH_PRIORITY-7)
    self.m_sc_rules:setTouchPriority(GLOBAL_TOUCH_PRIORITY-7)
    -- self.m_lb_rules:setTouchPriority(GLOBAL_TOUCH_PRIORITY-13)

    local x_leftbtn = self.m_sp_left:getPositionX()
    local y_leftbtn = self.m_sp_left:getPositionY()
    local x_rightbtn = self.m_sp_right:getPositionX()
    local y_rightbtn = self.m_sp_right:getPositionY()
    local posleft = self.m_sp_left:getParent():convertToWorldSpace(ccp(x_leftbtn,y_leftbtn));
    local posright = self.m_sp_right:getParent():convertToWorldSpace(ccp(x_rightbtn,y_rightbtn));
    posleft = self.m_root_layer:convertToNodeSpace(ccp(posleft.x,posleft.y));
    posright = self.m_root_layer:convertToNodeSpace(ccp(posright.x,posright.y));
    -- local leftBtnpos = self.m_sp_left:getPo
    local move_dir = 0 --  1-left   2-right
    local start_time = 0
    local cur_time = 0
    local moved_flag = 0
    local end_flag = 0
    local con_length = self.m_node_balls:getContentSize().width
    -- cclog(" ========================     con_length  ",con_length)
    local function onTouch(eventType, x, y)
        local pos = self.m_root_layer:convertToNodeSpace(ccp(x,y));
        if eventType == "began" then
            if self.m_catch_flag == 1 then
                return true
            end
            end_flag = 0
            start_time = os.time()
            if (pos.x > posleft.x and pos.x < posleft.x+44 and pos.y > posleft.y and pos.y < posleft.y + 20 ) or (pos.x > posright.x and pos.x < posright.x+44 and pos.y > posright.y and pos.y < posright.y + 20) then
                -- 判断左右
                if pos.x > posleft.x and pos.x < posleft.x+44 and pos.y > posleft.y and pos.y < posleft.y + 20 then
                    self.m_sp_left:setPositionY(y_leftbtn-2)
                    move_dir = -37
                else
                    self.m_sp_right:setPositionY(y_rightbtn-2)
                    move_dir = 37
                end
                --进行tick 判断
                if self.m_shared_touch == nil then
                    function tick()
                        cur_time = os.time() - start_time
                        -- cclog("==============$$$$$$$$   tick m_shared_touch ====left  cur_time",cur_time)
                        if end_flag == 1 then  -- 如果发现松手则停止
                            self.m_sp_left:setPositionY(y_leftbtn)
                            self.m_sp_right:setPositionY(y_rightbtn)
                            -- start_time = 0
                            if self.m_shared_touch then
                                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared_touch)
                                self.m_shared_touch = nil
                            end

                            if cur_time <= 1 then
                                local gan_posx = self.m_sp_gan:getPositionX()
                                gan_posx = gan_posx + move_dir
                                if gan_posx <= 0 then
                                    gan_posx =  gan_posx - move_dir
                                elseif gan_posx >= con_length then
                                    gan_posx =  gan_posx - move_dir
                                end

                                self.m_sp_gan:setPositionX(gan_posx)
                                self.m_node_zhuazi:setPositionX(self.m_sp_gan:getPositionX())
                            end
                        end
                        if cur_time > 1 then
                            local gan_posx = self.m_sp_gan:getPositionX()
                            gan_posx = gan_posx + move_dir/8
                            if gan_posx <= 0 then
                                gan_posx =  gan_posx - move_dir/8
                            elseif gan_posx >= con_length then
                                gan_posx =  gan_posx - move_dir/8
                            end

                            self.m_sp_gan:setPositionX(gan_posx)
                            self.m_node_zhuazi:setPositionX(self.m_sp_gan:getPositionX())
                        end
                    end
                    self.m_shared_touch = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 0.1 , false)
                end
            end
            return true
        elseif eventType == "ended" then
            end_flag = 1
            -- cclog("===================================    touch ended   ")
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY,true);
    self.m_root_layer:setTouchEnabled(true);

    local function onTouch2(eventType, x, y)
        local pos = self.m_root_layer:convertToNodeSpace(ccp(x,y));
        if eventType == "began" then
            return true
        end
    end
    self.m_root_layer2:registerScriptTouchHandler(onTouch2,false,GLOBAL_TOUCH_PRIORITY - 3,true);
    self.m_root_layer2:setTouchEnabled(false);

    local function onTouch3(eventType, x, y)
        local pos = self.m_root_layer:convertToNodeSpace(ccp(x,y));
        if eventType == "began" then
            return true
        end
    end
    self.m_root_layer3:registerScriptTouchHandler(onTouch2,false,GLOBAL_TOUCH_PRIORITY - 6,true);
    self.m_root_layer3:setTouchEnabled(false);
    return ccbNode;
end


function game_zhuawawa_pop.setRank(self,data)
    cclog("====================    setRank   ")
    self.m_node_rank:setVisible(true)
    self.m_root_layer2:setTouchEnabled(true);
    self.m_node_list:removeAllChildrenWithCleanup(true)
    self.m_all_rank = {}
    local luckitem = data.lucky or {}
    -- local ranks = data.rank

    self.m_cfg_rank_reward = {}
    local cfg_rew = {}
    for k,v in pairs(self.m_cfg_toy_reward) do
        if self.m_version == v.version then
            cfg_rew[tonumber(k)] = v
        end
    end
    for k,v in pairs(cfg_rew) do
        self.m_cfg_rank_reward[#self.m_cfg_rank_reward+1]={num = v.rank[2],reward = v.reward_12}
    end

    table.sort(self.m_cfg_rank_reward, function (a,b)
        return a.num < b.num
    end)

    local rewards = {}
    local rewards_flag = 0
    for k,v in ipairs(data.rank) do
        rewards_flag = 0
        if k <= 3 then
            for kk,vv in ipairs(self.m_cfg_rank_reward) do
                if k <= vv.num and rewards_flag == 0 then
                    rewards = vv.reward
                    rewards_flag = 1
                end
            end
            self.m_all_rank[#self.m_all_rank + 1] = {name = v[1],role = v[2],cost = v[3],islucky = 0,id = tonumber(k),rewards = rewards}
        end
    end
    if next(luckitem) then
        self.m_all_rank[#self.m_all_rank + 1] = {name = luckitem[1],role = luckitem[2],cost = luckitem[3],islucky = 1,id = 0,rewards = {}}
    end

    for k,v in ipairs(data.rank) do
        rewards_flag = 0
        if k > 3 then
            for kk,vv in ipairs(self.m_cfg_rank_reward) do
                if k <= vv.num and rewards_flag == 0 then
                    rewards = vv.reward
                    rewards_flag = 1
                end
            end
            self.m_all_rank[#self.m_all_rank + 1] = {name = v[1],role = v[2],cost = v[3],islucky = 0,id = tonumber(k),rewards = rewards}
        end
    end
    
    local cfg_rew_des = self:getToyRewardCfg()
    self.m_lb_top_rank:setString(cfg_rew_des.des)

    local tableView = self:createTableView(self.m_node_list:getContentSize(),self.m_all_rank)
    if tableView then
        self.m_node_list:addChild(tableView)
    end

    self.m_lb_mine_name:setString(data.own_info[1])
    if data.own_rank == 0 then
        self.m_lb_mine_rank:setString("Chưa lọt BXH")
    else
        self.m_lb_mine_rank:setString("Hạng "..data.own_rank)
    end
    self.m_lb_mine_use:setString(data.own_info[3])

    local tempIcon = game_util:createPlayerIconByRoleId(data.own_info[2])
    self.m_node_mine_icon:addChild(tempIcon)
    tempIcon:setScale(0.3)
end

function game_zhuawawa_pop:getToyRewardCfg(  )
    local cfg = {}
    for k,v in pairs(self.m_cfg_toy_reward) do
        if v.version == self.m_version then
            cfg = v
            break
        end
    end
    return cfg
    
end
--[[--
    刷新ui
]]
function game_zhuawawa_pop.refreshUi(self)
    -- self.m_node_balls:removeAllChildrenWithCleanup(true)
    self:setBalls()
    self.m_lb_times:setString(self.m_cur_usetimes)
    local hours,minutes,seconds = nil

    if self.m_tGameData.remain_time > 0 then
        hours = math.floor(self.m_tGameData.remain_time / 3600)
        minutes = math.floor((self.m_tGameData.remain_time - hours * 3600)/ 60)
        seconds = math.floor(self.m_tGameData.remain_time - 3600 * hours - 60 * minutes)
        hours = hours<10 and "0"..hours or ""..hours
        minutes = minutes<10 and "0"..minutes or ""..minutes
        seconds = seconds<10 and "0"..seconds or ""..seconds
        self.m_lb_act_lasts:setString("CD event: "..hours..":"..minutes..":"..seconds)
    else
        self.m_lb_act_lasts:setString("CD event: Event đã kết thúc")
    end
   
    if self.m_tGameData.free > 0 then
        hours = math.floor(self.m_tGameData.free / 3600)
        minutes = math.floor((self.m_tGameData.free - hours * 3600)/ 60)
        seconds = math.floor(self.m_tGameData.free - 3600 * hours - 60 * minutes)
        hours = hours<10 and "0"..hours or ""..hours
        minutes = minutes<10 and "0"..minutes or ""..minutes
        seconds = seconds<10 and "0"..seconds or ""..seconds
        self.m_lb_free:setString("CD miễn phí: "..hours..":"..minutes..":"..seconds)
    else
        if self.m_tGameData.remain_time <= 0 then
            self.m_lb_free:setString("")
        else
            self.m_lb_free:setString("Miễn phí lần này")
        end
    end

    if self.m_shared == nil then
        function tick()
            if self.m_tGameData.remain_time > 0 then
                hours = math.floor(self.m_tGameData.remain_time / 3600)
                minutes = math.floor((self.m_tGameData.remain_time - hours * 3600)/ 60)
                seconds = math.floor(self.m_tGameData.remain_time - 3600 * hours - 60 * minutes)
                hours = hours<10 and "0"..hours or ""..hours
                minutes = minutes<10 and "0"..minutes or ""..minutes
                seconds = seconds<10 and "0"..seconds or ""..seconds
                self.m_lb_act_lasts:setString("CD event: "..hours..":"..minutes..":"..seconds)
                self.m_tGameData.remain_time = self.m_tGameData.remain_time - 1
            else
                -- self:back()
                self.m_lb_act_lasts:setString("CD event: Event đã kết thúc")
                self.m_lb_free:setString("")
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_shared)
                self.m_shared = nil
            end
            if self.m_tGameData.free > 0 then
                hours = math.floor(self.m_tGameData.free / 3600)
                minutes = math.floor((self.m_tGameData.free - hours * 3600)/ 60)
                seconds = math.floor(self.m_tGameData.free - 3600 * hours - 60 * minutes)
                hours = hours<10 and "0"..hours or ""..hours
                minutes = minutes<10 and "0"..minutes or ""..minutes
                seconds = seconds<10 and "0"..seconds or ""..seconds
                self.m_lb_free:setString("CD miễn phí: "..hours..":"..minutes..":"..seconds)
                self.m_tGameData.free = self.m_tGameData.free - 1
            else
                self.m_lb_free:setString("Miễn phí lần này")
            end
        end
        self.m_shared = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 1 , false)
    end
    local frameName = self.m_cfg_toy.picture or "ui_wawa_icon_relreward_1"
    self.m_sp_relreward:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName..".png"))

    local tempLabel = game_util:createRichLabelTTF({text = self.m_cfg_toy.notice,dimensions = CCSizeMake(250,0),textAlignment = kCCTextAlignmentLeft,
        verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(255,255,255),fontSize = 10})
    local tempSize = tempLabel:getContentSize();
    local viewSize = self.m_lb_rules:getContentSize();
    self.m_sc_rules:setContentSize(CCSizeMake(250,tempSize.height))
    self.m_sc_rules:setContentOffset(ccp(0, viewSize.height - tempSize.height), false)
    self.m_sc_rules:addChild(tempLabel)
end

--[[]]
function game_zhuawawa_pop.createTableView(self,viewSize,tableData)
    -- self.m_node_mycard:removeAllChildrenWithCleanup(true)
    -- self.m_node_othercard:removeAllChildrenWithCleanup(true)
    self.rank_rew_tb = {}
    tableData = tableData or {}
    local params = {};
    params.viewSize = viewSize;
    params.row = 4;--行
    params.column = 1; --列
    params.direction = kCCScrollViewDirectionVertical;
    params.totalItem = #tableData ;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-4;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create();
            ccbNode:openCCBFile("ccb/game_activity_zhuawawa_item.ccbi");
            ccbNode:ignoreAnchorPointForPosition(false);
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode")
            local m_node_icon = ccbNode:nodeForName("m_node_icon")
            local m_sp_rank_id = ccbNode:spriteForName("m_sp_rank_id")
            local m_lb_rank_id = ccbNode:labelTTFForName("m_lb_rank_id")
            local m_lb_name = ccbNode:labelTTFForName("m_lb_name")
            local m_lb_cost = ccbNode:labelTTFForName("m_lb_cost")
            local m_node_reward = ccbNode:nodeForName("m_node_reward")
            local m_sp_xingyun = ccbNode:spriteForName("m_sp_xingyun")

            if index+1 == 1 then
                m_sp_rank_id:setVisible(true)
                m_lb_rank_id:setVisible(false)
                local framename = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("ui_wawa_icon_rank1.png")
                m_sp_rank_id:setDisplayFrame(framename)
            elseif index+1 == 2 then
                m_sp_rank_id:setVisible(true)
                m_lb_rank_id:setVisible(false)
                m_sp_rank_id:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("ui_wawa_icon_rank2.png"))
            elseif index+1 == 3 then
                m_sp_rank_id:setVisible(true)
                m_lb_rank_id:setVisible(false)
                m_sp_rank_id:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("ui_wawa_icon_rank3.png"))
            else
                if tableData[4].islucky == 1 then
                    if index+1 == 4 then
                        m_sp_rank_id:setVisible(true)
                        m_lb_rank_id:setVisible(false)
                        m_sp_rank_id:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("ui_wawa_icon_rank4.png"))
                    else
                        m_sp_rank_id:setVisible(false)
                        m_lb_rank_id:setVisible(true)
                        m_lb_rank_id:setString(index)
                        m_lb_rank_id:setColor(ccc3(255,211,155))
                    end
                else
                    m_sp_rank_id:setVisible(false)
                    m_lb_rank_id:setVisible(true)
                    m_lb_rank_id:setString((index+1).."")
                    m_lb_rank_id:setColor(ccc3(255,211,155))
                end
            end
            m_node_icon:removeAllChildrenWithCleanup(true)
            local tempIcon = game_util:createPlayerIconByRoleId(tableData[index+1].role)
            m_node_icon:addChild(tempIcon)
            tempIcon:setScale(0.3)

            m_lb_name:setString(tableData[index+1].name)
            m_lb_cost:setString(tableData[index+1].cost)
            if tableData[index+1].islucky == 1 then
                m_node_reward:setVisible(false)
                m_sp_xingyun:setVisible(true)
            else
                m_node_reward:setVisible(true)
                m_sp_xingyun:setVisible(false)

                local function onClick( event, target  )
                    local tagNode = tolua.cast(target, "CCNode");
                    local btnTag = tagNode:getTag()
                    game_util:lookItemDetal(tableData[index+1].rewards[btnTag])
                end

                local  scrollView = m_node_reward:getChildByTag(111)
                local c_size = m_node_reward:getContentSize()
                if scrollView == nil then
                else
                    m_node_reward:removeAllChildrenWithCleanup(true)
                end
                scrollView = CCScrollView:create(c_size)
                scrollView:setDirection(kCCScrollViewDirectionHorizontal)
                scrollView:setTouchEnabled(true)
                scrollView:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 5)
                m_node_reward:addChild(scrollView)
                scrollView:setTag(111)

                local curwidth = 0
                local width = 0
                for i=1,#tableData[index+1].rewards do
                    local icon,name,count = game_util:getRewardByItemTable(tableData[index+1].rewards[i])
                    if icon then
                        scrollView:getContainer():addChild(icon)
                        icon:setAnchorPoint(ccp(0.5,0.5))
                        icon:setScale(0.3)
                        icon:setPosition(ccp((i-1)*icon:getContentSize().width*0.4 + icon:getContentSize().width*0.2,c_size.height*0.6))
                        if count then
                            local numLab = CCLabelTTF:create("x" .. count,TYPE_FACE_TABLE.Arial_BoldMT,14)
                            icon:addChild(numLab,10,10)
                            numLab:setPosition(ccp(25,-7))
                            numLab:setScale(1.5)
                        end
                        curwidth = icon:getContentSize().width+(i-1)*icon:getContentSize().width*0.9
                    end
                    local button = game_util:createCCControlButton("public_weapon.png","",onClick)
                    button:setTag(i)
                    button:setOpacity(0)
                    scrollView:getContainer():addChild(button)
                    button:setScale(0.3)
                    button:setTouchPriority(GLOBAL_TOUCH_PRIORITY-5)
                    button:setPosition(ccp((i-1)*icon:getContentSize().width*0.4 + icon:getContentSize().width*0.2,c_size.height*0.6))
                    width = width + icon:getContentSize().width*0.9 + 3
                end
                scrollView:setContentSize(CCSizeMake(width, c_size.height))
                scrollView:setContentOffset(ccp(0, 0), false)
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
        end
    end
    return TableViewHelper:create(params);
end
--]]

function game_zhuawawa_pop.setBalls(self)
    local function onClick( event, target  )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag()
        game_util:lookItemDetal(self.m_balls[btnTag].reward)
    end

    -- local ball = nil
    local _icon,_name,_count,_ballbg =  nil
    self.m_node_balls:removeAllChildrenWithCleanup(true)
    for k,v in pairs(self.m_balls) do        
        if k%2 == 1 then 
            local node_ball = CCNode:create()
            self.m_node_balls:addChild(node_ball)
            self.m_balls[k].node_ball = node_ball
            node_ball:setPosition(ccp(20+56*math.floor(k/2),40))

            _ballbg = CCSprite:createWithSpriteFrameName("ui_wawa_bg_ball.png")
            node_ball:addChild(_ballbg)
            _ballbg:setScale(1.2)
            _ballbg:setPositionY(-15)
            self.m_balls[k].ball_bg = _ballbg
            _icon,_name,_count = game_util:getRewardByItemTable(v.reward,false)
            local button = game_util:createCCControlButton("public_weapon.png","",onClick)
            button:setTag(tonumber(k))
            button:setOpacity(0)
            node_ball:addChild(button)
            button:setScale(0.6)
            button:setTouchPriority(GLOBAL_TOUCH_PRIORITY-1)
            node_ball:addChild(_icon)
            _icon:setScale(0.5)
            local ball = CCSprite:createWithSpriteFrameName("ui_wawa_icon_bao1.png")
            if ball then
                node_ball:addChild(ball)
                ball:setScale(0.6)
            end
            if self.m_balls_pos_tb[k] == nil then
                self.m_balls_pos_tb[k] = {x = 20+56*math.floor(k/2),y = 40}
            end
        end
    end

    for k,v in pairs(self.m_balls) do
        if k%2 ~= 1 then        
            local node_ball = CCNode:create()
            self.m_node_balls:addChild(node_ball)
            self.m_balls[k].node_ball = node_ball
            node_ball:setPosition(ccp(24+56*math.floor(k/2)-32,15))
            
            _ballbg = CCSprite:createWithSpriteFrameName("ui_wawa_bg_ball.png")
            node_ball:addChild(_ballbg)
            _ballbg:setScale(1.2)
            _ballbg:setPositionY(-15)
            self.m_balls[k].ball_bg = _ballbg
            _icon = CCSprite:createWithSpriteFrameName("ui_wawa_icon_wenhao.png")
            node_ball:addChild(_icon)
            _icon:setScale(0.5)
            local ball = CCSprite:createWithSpriteFrameName("ui_wawa_icon_bao2.png")
            if ball then
                node_ball:addChild(ball)
                ball:setScale(0.6)
            end
            if self.m_balls_pos_tb[k] == nil then
                self.m_balls_pos_tb[k] = {x = 24+56*math.floor(k/2)-32,y = 15}
            end
        end
    end
end

--[[--
    初始化
]]
function game_zhuawawa_pop.init(self,t_params)
    self.m_balls_pos_tb = {}
    t_params = t_params or {};
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data")
        data = json.decode(data:getFormatBuffer())
        self.m_tGameData = data
    elseif t_params.gameData and tolua.type(t_params.gameData) == "table" then
        self.m_tGameData = t_params.gameData
    end
    -- cclog2(self.m_tGameData,"self.m_tGameData")
    self.m_balls = {}
    if self.m_tGameData.rewards then
        for k,v in pairs(self.m_tGameData.rewards) do
            self.m_balls[tonumber(k)] = {id =tonumber(k) , reward = v}
        end
    end
    self.m_cur_usetimes = self.m_tGameData.item_num
    self.m_version = self.m_tGameData.version
    -- cclog2(self.m_balls,"self.m_balls   1111111")

    self.m_cfg_toy = getConfig(game_config_field.toy) and json.decode(getConfig(game_config_field.toy):getFormatBuffer()) or {}
    self.m_cfg_toy = self.m_cfg_toy[self.m_version..""]
    -- cclog2(self.m_cfg_toy,"self.m_cfg_toy")
    self.m_cfg_toy_reward = getConfig(game_config_field.toy_reward) and json.decode(getConfig(game_config_field.toy_reward):getFormatBuffer()) or {}
    self.m_hard_lv = tonumber(self.m_cfg_toy.difficulty) or 5
    self.m_data_cost = self.m_cfg_toy.coin[1][3]
end

--[[--
    创建ui入口并初始化数据
]]
function game_zhuawawa_pop.create(self,t_params)
    -- if self.m_popUi then return end
    self:init(t_params);
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

return game_zhuawawa_pop;   %�  