--- 主場景

local game_main_scene = {
    m_ccbNode = nil,
    m_subordinateMenuPop = nil,
    m_resourcesAnimTable = nil,
    m_bottom_btn_node = nil,
    m_right_btn_node = nil,
    m_top_btn_node = nil,
    m_top_btn_node2 = nil,
    m_top_btn_node3 = nil,
    m_top_btn_node4 = nil,
    m_btnShowFlag = nil,
    m_gainResTime = nil,
    m_top_btn_node3 = nil,
    m_btn_shensuo = nil,

    m_formation_btn = nil,
    m_shop_btn = nil,
    m_partner_btn = nil,
    m_chat_btn = nil,
    m_backpack_btn = nil,
    m_more_btn = nil,
    m_reward_btn = nil,
    m_activity_btn = nil,
    m_kfhd_activity_btn = nil;  -- 开服活动
    m_do_something_btn = nil, -- 消息提示按钮
    m_conbtn_levelgift = nil,  -- 等级礼包按钮
    m_ranking_btn = nil,
    m_battle_btn = nil,
    m_announcement_btn = nil,
    m_conbtn_challenge = nil,
    m_team_layer = nil,
    m_teamNodeTab = nil,
    m_combat_label = nil,
    m_gift_btn = nil,--领奖按钮
    m_firstFlag = nil,
    m_chat_node = nil,
    m_battle_btn_bg = nil,
    m_tipsAnimTab = nil,
    m_social_btn = nil,
    m_get_flag = nil,
    m_pp_btn = nil,
    m_pp_btn2 = nil,
    m_task_btn = nil,
    m_guild_btn = nil,
    m_leader_skill_btn = nil,
    m_gacha_btn = nil,
    m_pay_btn = nil,
    m_conbtn_vipshow_btn = nil,
    m_daily_task_btn = nil,
    m_award_btn = nil,
    m_conbtn_limit_score_btn = nil,
    m_limit_btn = nil,
    m_conbtn_secreary = nil,
    m_tshowDoSthParams = {},  --消息提醒参数
    m_lucky_turntable_btn = nil,
    m_dragon_ball_btn = nil,
    m_hot_active_btn = nil,
    m_king_btn = nil,
    m_rank_btn = nil,

    m_show_chatNode = nil,
    m_show_chatMsg = nil,
    m_fristOpenPop = nil,
    m_sky_star_btn = nil,
    m_conbtn_fuli = nil,
    m_gvg_btn = nil,
    m_kaifu_chongzhi_btn = nil,
    m_btn_firecup = nil,
    m_new_gift = nil,
    m_red_envelope_btn = nil,
    m_SysRed_node = nil,
    m_label_sysTime = nil,
     m_btn_superDay = nil,
    m_node_theme = nil,

    m_month_fund_btn = nil,
    m_free_dinner_btn = nil,
    m_snow_node = nil,
    is_double = nil,
    m_activeBtn_count = nil,
    m_rocket_layer = nil,

    m_worm_btn = nil,
};
--[[--
    銷毀
]]
function game_main_scene.destroy(self)
    cclog("-----------------game_main_scene destroy-----------------");
    self.m_ccbNode = nil;
    self.m_subordinateMenuPop = nil;
    self.m_resourcesAnimTable = nil;
    self.m_bottom_btn_node = nil;
    self.m_right_btn_node = nil;
    self.m_top_btn_node = nil;
    self.m_top_btn_node2 = nil;
    self.m_top_btn_node3 = nil;
    self.m_top_btn_node4 = nil;
    -- self.m_btnShowFlag = nil;
    self.m_top_btn_node3 = nil;
    self.m_btn_shensuo = nil;

    self.m_formation_btn = nil;
    self.m_shop_btn = nil;
    self.m_partner_btn = nil;
    self.m_chat_btn = nil;
    self.m_backpack_btn = nil;
    self.m_more_btn = nil;
    self.m_reward_btn = nil;
    self.m_activity_btn = nil;
    self.m_kfhd_activity_btn = nil;
    self.m_do_something_btn = nil;
    self.m_ranking_btn = nil;
    self.m_battle_btn = nil;
    self.m_announcement_btn = nil;
    self.m_team_layer = nil;
    self.m_teamNodeTab = nil;
    self.m_combat_label = nil;
    self.m_gift_btn = nil;
    self.m_firstFlag = nil;
    self.m_chat_node = nil;
    self.m_battle_btn_bg = nil;
    self.m_tipsAnimTab = nil;
    self.m_social_btn = nil;
    self.m_get_flag = nil;
    self.m_pp_btn = nil;
    self.m_pp_btn2 = nil;
    self.m_task_btn = nil;
    self.m_guild_btn = nil;
    self.m_leader_skill_btn = nil;
    self.m_gacha_btn = nil;
    self.m_pay_btn = nil;
    self.m_conbtn_vipshow_btn = nil;
    self.m_daily_task_btn = nil;
    self.m_award_btn = nil;
    self.m_tshowDoSthParams = nil;
    self.m_conbtn_levelgift = nil;
    self.m_conbtn_limit_score_btn = nil;
    self.m_limit_btn = nil;
    self.m_conbtn_secreary = nil;
    self.m_conbtn_challenge =nil;
    self.m_lucky_turntable_btn = nil;
    self.m_dragon_ball_btn = nil;
    self.m_hot_active_btn = nil;
    self.m_king_btn = nil;
    self.m_rank_btn = nil;

    self.m_show_chatNode = nil;
    self.m_show_chatMsg = nil;
    self.m_fristOpenPop = nil;
    self.m_sky_star_btn = nil;
    self.m_conbtn_fuli = nil;
    self.m_gvg_btn = nil;
    self.m_kaifu_chongzhi_btn = nil;
    self.m_btn_firecup = nil;
    self.m_new_gift = nil;

    self.m_red_envelope_btn = nil;
    self.m_SysRed_node = nil;
    self.m_label_sysTime = nil;
    self.m_btn_superDay = nil;
    self.m_node_theme = nil;

    self.m_month_fund_btn=nil;

    self.m_free_dinner_btn = nil;
    self.m_snow_node = nil;
    self.is_double = nil;
    self.m_activeBtn_count = nil;
    self.m_rocket_layer = nil;
    self.m_worm_btn = nil;
end
--[[--
    返回
]]
function game_main_scene.back(self,type)

    self:destroy();
end
--[[--
    讀取cbbi 創建ui
]]
function game_main_scene.createUi(self)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/new_main_add_res.plist")
    local today = os.date("*t")
    cclog("today == " .. json.encode(today))
    local winSize = CCDirector:sharedDirector():getWinSize();
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event)
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        self:mainBtnOnClick(btnTag, tagNode);
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
    ccbNode:openCCBFile("ccb/ui_game_main.ccbi");

    self.m_ccbNode = ccbNode;
    self.m_node_theme = ccbNode:nodeForName("m_node_theme")
    if self.m_node_theme then
        self.m_node_theme:removeAllChildrenWithCleanup(true)
    end

    local m_bg_sprite = ccbNode:spriteForName("m_bg_sprite")
    m_bg_sprite:setScale(resolution_config:getScale()+0.1)

    local exchangeThemeId = CCUserDefault:sharedUserDefault():getIntegerForKey("exchangeThemeId") or 0
    if exchangeThemeId and exchangeThemeId ~= 0 and game_data:isViewOpenByID(199) then
        local cfg_background_charge = getConfig(game_config_field.background_charge)
        if cfg_background_charge:getNodeWithKey(tostring(exchangeThemeId)) then
            local currentThemeData = cfg_background_charge:getNodeWithKey(tostring(exchangeThemeId))
            local newBgName = currentThemeData:getNodeWithKey("background"):toStr()
            local newBg = CCSprite:create("ccbResources/" .. newBgName)
            if newBg then
                local tempSize = m_bg_sprite:getContentSize();
                newBg:setPosition(ccp(tempSize.width * 0.5,tempSize.height * 0.5))
                m_bg_sprite:addChild(newBg,110,110)
                local animName = currentThemeData:getNodeWithKey("background_animation"):toStr()
                if animName and animName ~= "" then
                    local is_snow = nil
                    if animName == "xuetexiao" then
                        is_snow = "snow"
                    else
                        is_snow = nil
                    end
                    local anim = game_util:createEffectAnim(animName,1,true,"snow")
                    anim:setPosition(ccp(tempSize.width * 0.5,tempSize.height * 0.5))
                    if self.m_node_theme then
                        self.m_node_theme:addChild(anim,10,10)
                    end
                end
            end
        end
    end

    self.m_left_btn_node = ccbNode:controlButtonForName("m_left_btn_node") 
    self.m_bottom_btn_node = ccbNode:nodeForName("m_bottom_btn_node")
    self.m_right_btn_node = ccbNode:nodeForName("m_right_btn_node")
    self.m_top_btn_node = ccbNode:nodeForName("m_top_btn_node")
    self.m_top_btn_node2 = ccbNode:nodeForName("m_top_btn_node2")
    self.m_top_btn_node3 = ccbNode:nodeForName("m_top_btn_node3")

    self.m_top_btn_node4 = CCNode:create()
    self.m_top_btn_node4:setAnchorPoint(self.m_top_btn_node3:getAnchorPoint())
    self.m_top_btn_node4:setPosition(ccp(self.m_top_btn_node3:getPositionX(), self.m_top_btn_node3:getPositionY()))
    self.m_top_btn_node4:setContentSize(CCSizeMake(self.m_top_btn_node3:getContentSize().width, self.m_top_btn_node3:getContentSize().height))
    self.m_top_btn_node3:getParent():addChild(self.m_top_btn_node4)
    
    self.m_chat_node = ccbNode:nodeForName("m_chat_node")
    self.m_formation_btn = ccbNode:controlButtonForName("m_formation_btn")
    self.m_shop_btn = ccbNode:controlButtonForName("m_shop_btn")
    self.m_partner_btn = ccbNode:controlButtonForName("m_partner_btn")
    self.m_chat_btn = ccbNode:controlButtonForName("m_chat_btn")
    self.m_backpack_btn = ccbNode:controlButtonForName("m_backpack_btn")
    self.m_btn_shensuo = ccbNode:controlButtonForName("m_btn_shensuo")
    self.m_btn_shensuo:setVisible(false)
    -- self.m_more_btn = ccbNode:controlButtonForName("m_more_btn")
    -- self.m_reward_btn = ccbNode:controlButtonForName("m_reward_btn")
    -- self.m_conbtn_challenge = ccbNode:controlButtonForName("m_conbtn_challenge")
    self.m_activity_btn = ccbNode:controlButtonForName("m_activity_btn")
    self.m_do_something_btn = ccbNode:controlButtonForName("m_conbtn_dosth")  -- 消息提示按钮
    self.m_conbtn_levelgift = ccbNode:controlButtonForName("m_conbtn_levelgift")  -- 消息提示按钮
    self.m_ranking_btn = ccbNode:controlButtonForName("m_ranking_btn")

    self.m_battle_btn = ccbNode:controlButtonForName("m_battle_btn")
    if self.m_battle_btn then
        self.m_battle_btn:setPreferredSize(CCSizeMake(58, 34))
    end
    self.m_combat_label = ccbNode:labelBMFontForName("m_combat_label")
    self.m_combat_label:setVisible(false);
    local pX,pY = self.m_combat_label:getPosition();
    -- self.m_combatNumberChangeNode = game_util:createExtNumberChangeNode({labelType = 2});
    self.m_combatNumberChangeNode = CCLabelBMFont:create("","yellow_image_text.fnt")
    -- self.m_combatNumberChangeNode = CCLabelTTF:create("0","yellow_image_text.fnt",16)
    self.m_combatNumberChangeNode:setPosition(ccp(pX, pY));
    self.m_combatNumberChangeNode:setAnchorPoint(ccp(0, 0.5));
    self.m_combat_label:getParent():addChild(self.m_combatNumberChangeNode);
    -- self.m_combatNumberChangeNode:setCurValue(0,false);

    local function onBtnClick( event, target  )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        self:mainBtnOnClick(btnTag, tagNode);
    end 


    local button = game_util:createCCControlButton("mbutton_7_1.png","",onBtnClick)
    button:setTouchPriority(GLOBAL_TOUCH_PRIORITY + 130)
    button:setAnchorPoint(ccp(0.5,0.5))
    button:setPosition(ccp(426, 27))
    self.m_bottom_btn_node:addChild(button)
    button:setTag(17)


     self.m_btn_superDay = ccbNode:controlButtonForName("m_btn_superDay")
    self.m_btn_superDay:setVisible(game_data:isViewShowByID(188))
    -- self.m_gift_btn = ccbNode:controlButtonForName("m_gift_btn")
    -- self.m_announcement_btn = ccbNode:controlButtonForName("m_announcement_btn")
    -- self.m_award_btn = ccbNode:controlButtonForName("m_award_btn")
    self.m_social_btn = ccbNode:controlButtonForName("m_social_btn")
    self.m_pp_btn = ccbNode:controlButtonForName("m_pp_btn")
    self.m_pp_btn2 = ccbNode:controlButtonForName("m_pp_btn2")
    self.m_task_btn = ccbNode:controlButtonForName("m_task_btn")
    self.m_guild_btn = ccbNode:controlButtonForName("m_guild_btn")
    self.m_leader_skill_btn = ccbNode:controlButtonForName("m_leader_skill_btn")
    self.m_gacha_btn = ccbNode:controlButtonForName("m_gacha_btn")
    -- self.m_pay_btn = ccbNode:controlButtonForName("m_pay_btn")
    -- self.m_conbtn_secreary = ccbNode:controlButtonForName("m_conbtn_secreary")
    self.m_rank_btn = ccbNode:controlButtonForName("m_rank_btn")--新排行榜
    self.m_conbtn_fuli = ccbNode:controlButtonForName("m_conbtn_fuli")
    self.m_conbtn_teamRaid = ccbNode:controlButtonForName("m_conbtn_teamRaid")
    self.m_snow_node =ccbNode:nodeForName("m_snow_node")
    local snow_btn = ccbNode:controlButtonForName("snow_btn")
    
    self.m_red_envelope_btn = ccbNode:controlButtonForName("m_red_envelope_btn")
    self.m_red_envelope_btn:setVisible(false)

    self.m_new_gift = ccbNode:controlButtonForName("m_new_gift_btn")
    self.m_new_gift:setVisible(false)

    self.m_SysRed_node=ccbNode:nodeForName("m_SysRed_node")

    if getPlatForm() == "pp" then
        self.m_pp_btn:setVisible(true);
    elseif getPlatForm() == "itools" then
        -- game_util:setCCControlButtonBackground(self.m_pp_btn,"main_itools_icon.png")
        self.m_pp_btn:setVisible(false);
    elseif  getPlatForm() == "platformCommon" then
        self.m_pp_btn:setVisible(false);
        local function needShowSDKBtnResult(table)
            -- body
            if table["needShow"] then
                self.m_pp_btn:setVisible(true);
                if table["icon"] ~= nil then
                    game_util:setCCControlButtonBackground(self.m_pp_btn, table["icon"])
                end
            end
            if table["needShow"] then
                            --监听用户中心的注销事件
            end
        end
        require("shared.native_helper").needShowSDKBtn(needShowSDKBtnResult)
        
        local function logoutResult(table)
            local m_shared = 0;
            function tick( dt )
              CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_shared);
              if game_data_statistics then
                    game_data_statistics:logoutGame()
                end
                game_scene:setVisibleBroadcastNode(false);
                game:resourcesDownload();
            end
            m_shared = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 0 , false)
        end
        require("shared.native_helper").listenBroadCast("userlogOut", logoutResult)
    else
        self.m_pp_btn:setVisible(false);
    end

    if getPlatForm() == "pp" then
        self.m_pp_btn2:setVisible(true);
    else
        self.m_pp_btn2:setVisible(false);
    end

    self.m_battle_btn_bg = ccbNode:spriteForName("m_battle_btn_bg")
    local animArr = CCArray:create();
    -- animArr:addObject(CCRotateBy:create(3,-360));
    animArr:addObject(CCScaleTo:create(1,0.9));
    animArr:addObject(CCScaleTo:create(1,1.0));
    self.m_battle_btn_bg:runAction(CCRepeatForever:create(CCSequence:create(animArr)))
    -- cclog("self.m_battle_btn_bg ==== " .. tostring(self.m_battle_btn_bg))
    -- local m_snatch_btn_bg = ccbNode:spriteForName("m_snatch_btn_bg")
    -- local animArr = CCArray:create();
    -- -- animArr:addObject(CCRotateBy:create(3,-360));
    -- animArr:addObject(CCScaleTo:create(1,0.9));
    -- animArr:addObject(CCScaleTo:create(1,1.0));
    -- m_snatch_btn_bg:runAction(CCRepeatForever:create(CCSequence:create(animArr)))

    -- self:setBottomBtnSort();
    -- self:setRightBtnSort();
    self.m_team_layer = ccbNode:layerForName("m_team_layer")
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    self.m_rocket_layer = ccbNode:layerForName("m_rocket_layer")
    self:initLayerTouch(self.m_team_layer);
    local tempSpri = nil;
    for i=1,5 do
        tempSpri = ccbNode:spriteForName("m_team_bg_" .. i)
        self.m_teamNodeTab[i] = tempSpri;
    end
    game_button_open:setButtonShow(self.m_ranking_btn,200,1);

    local function timeOverCallFun(label,type)
        label:setTime(180)
        local function responseMethod(tag,response)

        end
        network.sendHttpRequestNoLoading(responseMethod,game_url.getUrlForKey("user_main_page"), http_request_method.GET, nil,"user_main_page")
    end
    local timeLabel = game_util:createCountdownLabel(180,timeOverCallFun,8,1)
    timeLabel:setVisible(false);
    ccbNode:addChild(timeLabel,10,10)

    if self.m_snow_node then    ----    雪人活动node
        if game_data:isActiveOpenByID(533) then
            self.m_snow_node:setVisible(true)
            snow_btn:setVisible(true)
            snow_btn:setOpacity(0)
            snow_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY+110);
        else
            self.m_snow_node:setVisible(false)
            snow_btn:setVisible(false)
        end
    end
    -- game_data:startChat()

    -- -- 初始化聊天框
    -- local chatNode = CCNode:create()
    -- chatNode:setContentSize(CCSizeMake(125, 30))
    -- local size = chatNode:getContentSize()
    -- local chatBg = CCScale9Sprite:create("ccbResources/public_lll_black.png");
    -- chatBg:setPreferredSize(size);
    -- chatBg:setPosition(size.width * 0.4, size .height * 0.5)
    -- chatNode:addChild(chatBg)
    -- self.m_chat_node:addChild(chatNode)
    -- self.m_show_chatNode = chatNode
    -- self.m_show_chatNode:setPositionX(size.width * 0.1)
    -- self.m_show_chatNode:setVisible(false)
    -- local chatMsgLabel = game_util:createRichLabelTTF({text = showMsg or "",dimensions = CCSizeMake(size.width - 5,0),
    --     textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = nil,color = ccc3(221,221,192),fontSize = 9})
    -- chatMsgLabel:setAnchorPoint(ccp(0, 1));
    -- chatMsgLabel:setPositionY(size.height - 2)
    -- chatMsgLabel:setPositionX( 2 )
    -- self.m_show_chatNode:addChild(chatMsgLabel, 1)
    -- self.m_show_chatMsg = chatMsgLabel

    -- local function onChatBtnClick(event, target) 
    --     game_scene:addPop("ui_chat_pop");
    --     self.m_show_chatNode:setVisible(false)
    --     self.m_chat_btn:removeChildByTag(888, true)
    -- end

    -- local button = game_util:createCCControlButton("public_9_32X32.png","",onChatBtnClick)
    -- button:setPreferredSize(size)
    -- button:setAnchorPoint(ccp(0.5,0.5))
    -- button:setPositionY(size.height * 0.5)
    -- button:setPositionX(size.width * 0.5)
    -- self.m_show_chatNode:addChild(button)
    -- button:setOpacity(0)
    -- button:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);

    -- local reciveData = function ( chatData, state )
    --     self:reciveChatData( chatData , state)
    -- end
    -- local m_chatObserver = game_data:getChatObserver()            
    -- m_chatObserver:registerOneLinster( reciveData, "game_main_scene" )

    -- local friendChatCount, chatData = m_chatObserver:getFriendChatMessage()
    -- if friendChatCount > 0 then
    --     self.m_show_chatNode:setVisible(true)
    --     self.m_show_chatMsg:setString(chatData and chatData.content or "")
    -- end

    -- self.m_show_chatNode:setVisible(false)
    local wormopen = game_data:getUserStatusDataByKey("wormholes_version") or 0
    if game_data:isViewShowByID( 216 ) == true  and wormopen ~= 0 then -- active_inview 216      m_cloneLane_btn
        self:openWormActivity();
    elseif game_data:isViewShowByID( 171 ) == true then -- active_inview 519      m_cloneLane_btn
        self:openDoorActivity();
        cclog2("1231231231")
    else
        self:openOutDoorActivity();
         cclog2("1231231231aaaa")
    end

    self.m_top_btn_node3:setVisible(false)
    self.m_top_btn_node4:setVisible(false)

    return ccbNode;
end

function game_main_scene.openWormActivity(self)
    --状态  0. 未开放, 1.未开启, 2.准备状态, 3. 可以进入状态, 4. 已进入状态
    local open_door = game_data:getAlertsDataByKey("open_door") or 0
    if open_door > 0 then
        local function onBtnCilck( event,target )
            local tagNode = tolua.cast(target, "CCNode");
            local btnTag = tagNode:getTag();
            if open_door < 3 and btnTag == 104 then
                local function responseMethod(tag,gameData)
                    game_scene:addPop("open_door_activity",{gameData = gameData});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("open_door_index"), http_request_method.GET, nil,"open_door_index")
            elseif open_door == 3 and btnTag == 104 then
                local function responseMethod(tag,gameData)
                    game_data:setBattleType("open_door_first_battle");
                    game_scene:enterGameUi("game_battle_scene",{gameData = gameData});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("open_door_battle"), http_request_method.GET, {},"open_door_battle")
            elseif btnTag == 105 then
                local function responseMethod( tag,gameData )
                    local data = gameData:getNodeWithKey("data");
                    data = json.decode(data:getFormatBuffer()) or {};
                    game_data:setGuildHighWarVersion(data.guild_high_war_version)
                    local is_formation = false
                    is_formation = data.is_formation
                    if is_formation == true then 
                        if game_data:isViewShowByID (174) == true then
                            game_scene:enterGameUi("game_godfield_mainBig",{gameData = gameData});
                        else
                            game_scene:enterGameUi("game_godfield_main",{gameData = gameData})
                        end
                    else
                        local function responseMethod(tag,gameData)
                            if gameData then
                                local first_time = true
                                game_scene:enterGameUi("game_god_adjustment",{gameData = gameData,openType="game_godfield_mainBig",first_time = first_time});
                            end
                        end
                        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_upload_god_formation"), http_request_method.GET, nil,"god_field_upload_god_formation",true,true)
                    end
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_index"), http_request_method.GET, {},"god_field_index")
            elseif btnTag == 106 then   --   虫洞
                local function responseMethod( tag,gameData )
                    local data = gameData:getNodeWithKey("data");
                    data = json.decode(data:getFormatBuffer()) or {}
                    game_scene:enterGameUi("game_wormhole_main",{gameData = data});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("wormholes_index"), http_request_method.GET, {},"wormholes_index")
            else
                game_scene:enterGameUi("open_door_main_scene")
            end
        end
        local m_bg_sprite = self.m_rocket_layer
        local rocket_image = CCSprite:create("ccbResources/rocket_image.png")
        -- rocket_image:setAnchorPoint(ccp(0.5,1))
        local exchangeThemeId = CCUserDefault:sharedUserDefault():getIntegerForKey("exchangeThemeId") or 0
        if exchangeThemeId and exchangeThemeId ~=0  and game_data:isViewOpenByID(199) then
            local cfg_background_charge = getConfig(game_config_field.background_charge)
            if cfg_background_charge:getNodeWithKey(tostring(exchangeThemeId)) then
                ---切换主题暂时没有
                local currentThemeData = cfg_background_charge:getNodeWithKey(tostring(exchangeThemeId))
                local rocket_image_name = currentThemeData:getNodeWithKey("background_tree"):toStr()
                local outdoor_image = CCSprite:create("ccbResources/outdoor_wenzi2.png")
                local godfield_image = CCSprite:create("ccbResources/godfield_wenzi2.png")
                local wormhole_image = CCSprite:create("ccbResources/wormhole_wenzi2.png")
                if rocket_image_name and rocket_image_name ~= "" then
                    rocket_image = CCSprite:create("ccbResources/" .. rocket_image_name)
                end

                local outDoorBtnSpriteName,godfieldBtnSpriteName,wormholeBtnSpriteName = "", "" , ""

                local btnNameTab = currentThemeData:getNodeWithKey("background_button")
                local btnName1,btnName2,btnName3 = btnNameTab:getNodeAt(0):toStr(),btnNameTab:getNodeAt(1):toStr(),btnNameTab:getNodeAt(2):toStr()

                if btnName1 and btnName1 ~= "" then
                    outDoorBtnSpriteName = btnName1
                    local tempSprite = CCSprite:create("ccbResources/" .. outDoorBtnSpriteName)
                    if tempSprite then
                        outdoor_image = CCSprite:create("ccbResources/" .. outDoorBtnSpriteName)
                    end
                end
                if btnName2 and btnName2 ~= "" then
                    godfieldBtnSpriteName = btnName2
                    local tempSprite = CCSprite:create("ccbResources/" .. godfieldBtnSpriteName)
                    if tempSprite then
                        godfield_image = CCSprite:create("ccbResources/" .. godfieldBtnSpriteName)
                    end
                end
                if btnName3 and btnName3 ~= "" then
                    wormholeBtnSpriteName = btnName3
                    local tempSprite = CCSprite:create("ccbResources/" .. wormholeBtnSpriteName)
                    if tempSprite then
                        wormhole_image = CCSprite:create("ccbResources/" .. wormholeBtnSpriteName)
                    end
                end

                local tempSize = m_bg_sprite:getContentSize();
                rocket_image:setPosition(ccp(tempSize.width*0.51,tempSize.height*0.69))
                m_bg_sprite:addChild(rocket_image,111,111)
                if rocket_image_name and rocket_image_name == "bg_btnAirship11.png" then  
                    rocket_image:setVisible(false)
                elseif rocket_image_name and rocket_image_name == "bg_btnAirship21.png" then  
                    rocket_image:setVisible(false)
                end

                local btnImg = outdoor_image:displayFrame();
                local btnImg1 = godfield_image:displayFrame();
                local btnImg2 = wormhole_image:displayFrame();

                local btn = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg));
                btn:setPreferredSize(btnImg:getRect().size);
                btn:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn:setPosition(ccp(tempSize.width*0.45,tempSize.height*0.9));
                btn:setTag(104);
                btn:setTouchPriority(2);
                btn:setScale(0.8)

                local btn1 = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg1));
                btn1:setPreferredSize(btnImg1:getRect().size);
                btn1:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn1:setPosition(ccp(tempSize.width*0.51,tempSize.height*0.9));
                btn1:setTouchPriority(2);
                btn1:setTag(105);
                btn1:setScale(0.8)

                self.m_worm_btn = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg2));
                self.m_worm_btn:setPreferredSize(btnImg2:getRect().size);
                self.m_worm_btn:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                self.m_worm_btn:setPosition(ccp(tempSize.width*0.57,tempSize.height*0.9));
                self.m_worm_btn:setTag(106);
                self.m_worm_btn:setTouchPriority(2);
                self.m_worm_btn:setScale(0.8)

                -- 全都一致吧
                if rocket_image_name == "bg_winterTree.png" then
                    btn:setPosition(ccp(tempSize.width*0.45,tempSize.height*0.9));
                    btn1:setPosition(ccp(tempSize.width*0.51,tempSize.height*0.9));
                    self.m_worm_btn:setPosition(ccp(tempSize.width*0.57,tempSize.height*0.9));
                elseif rocket_image_name == "bg_btnAirship21.png" or  rocket_image_name == "bg_btnAirship11.png"  then 
                    btn:setPosition(ccp(tempSize.width*0.45,tempSize.height*0.9));
                    btn1:setPosition(ccp(tempSize.width*0.51,tempSize.height*0.903));
                    self.m_worm_btn:setPosition(ccp(tempSize.width*0.57,tempSize.height*0.9));
                end
                m_bg_sprite:addChild(btn,222)
                m_bg_sprite:addChild(btn1,222)
                m_bg_sprite:addChild(self.m_worm_btn,222)
            end
        else
            if rocket_image and m_bg_sprite then
                local outdoor_image = CCSprite:create("ccbResources/outdoor_wenzi2.png")
                local godfield_image = CCSprite:create("ccbResources/godfield_wenzi2.png")
                local wormhole_image = CCSprite:create("ccbResources/wormhole_wenzi2.png")
                local tempSize_rocket = rocket_image:getContentSize();
                local tempSize = m_bg_sprite:getContentSize();

                rocket_image:addChild(godfield_image);
                rocket_image:addChild(outdoor_image);
                rocket_image:addChild(wormhole_image);

                local btnImg = outdoor_image:displayFrame();
                local btnImg1 = godfield_image:displayFrame();
                local btnImg2 = wormhole_image:displayFrame();

                rocket_image:setPosition(ccp(tempSize.width*0.51,tempSize.height*0.69))
                outdoor_image:setPosition(ccp(tempSize.width*0.45,tempSize.height*0.81))
                godfield_image:setPosition(ccp(tempSize.width*0.51,tempSize.height*0.81))
                wormhole_image:setPosition(ccp(tempSize.width*0.57,tempSize.height*0.81))

                local btn = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg));
                btn:setPreferredSize(btnImg:getRect().size);
                btn:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn:setPosition(ccp(tempSize.width*0.45,tempSize.height*0.9));
                btn:setTag(104);
                btn:setTouchPriority(2);
                btn:setScale(0.8)

                local btn1 = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg1));
                btn1:setPreferredSize(btnImg1:getRect().size);
                btn1:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn1:setPosition(ccp(tempSize.width*0.51,tempSize.height*0.9));
                btn1:setTouchPriority(2);
                btn1:setTag(105);
                btn1:setScale(0.8)

                self.m_worm_btn = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg2));
                self.m_worm_btn:setPreferredSize(btnImg2:getRect().size);
                self.m_worm_btn:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                self.m_worm_btn:setPosition(ccp(tempSize.width*0.57,tempSize.height*0.9));
                self.m_worm_btn:setTouchPriority(2);
                self.m_worm_btn:setTag(106);
                self.m_worm_btn:setScale(0.8)
                m_bg_sprite:addChild(rocket_image)
                m_bg_sprite:addChild(btn)
                m_bg_sprite:addChild(btn1)
                m_bg_sprite:addChild(self.m_worm_btn)
            end
        end
    end
end


function game_main_scene.openOutDoorActivity(self)
    --状态  0. 未开放, 1.未开启, 2.准备状态, 3. 可以进入状态, 4. 已进入状态
    local open_door = game_data:getAlertsDataByKey("open_door") or 0
    if open_door > 0 then
        local function onBtnCilck( event,target )
            -- local tagNode = tolua.cast(target, "CCNode");
            -- local btnTag = tagNode:getTag();
            if open_door < 3 then
                local function responseMethod(tag,gameData)
                    game_scene:addPop("open_door_activity",{gameData = gameData});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("open_door_index"), http_request_method.GET, nil,"open_door_index")
            elseif open_door == 3 then
                local function responseMethod(tag,gameData)
                    game_data:setBattleType("open_door_first_battle");
                    game_scene:enterGameUi("game_battle_scene",{gameData = gameData});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("open_door_battle"), http_request_method.GET, {},"open_door_battle")
            else
                game_scene:enterGameUi("open_door_main_scene")
            end
        end

        local exchangeThemeId = CCUserDefault:sharedUserDefault():getIntegerForKey("exchangeThemeId") or 0
        if exchangeThemeId and exchangeThemeId ~=0 and game_data:isViewOpenByID(199) then
            local cfg_background_charge = getConfig(game_config_field.background_charge)
            if cfg_background_charge:getNodeWithKey(tostring(exchangeThemeId)) then
                local currentThemeData = cfg_background_charge:getNodeWithKey(tostring(exchangeThemeId))
                local rocket_image_name = currentThemeData:getNodeWithKey("background_tree"):toStr()
                local rocket_image = CCSprite:create("ccbResources/old_rocket_image.png")
                if rocket_image_name and rocket_image_name ~= "" then
                    rocket_image = CCSprite:create("ccbResources/" .. rocket_image_name)
                end
                local m_bg_sprite = self.m_ccbNode:spriteForName("m_bg_sprite")
                local parentNode = m_bg_sprite:getChildByTag(110)
                if rocket_image and m_bg_sprite then
                    local tempSize = parentNode:getContentSize();
                    local btnImg = rocket_image:displayFrame();
                    local btn = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg));
                    btn:setPreferredSize(btnImg:getRect().size);
                    btn:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                    btn:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.65));
                    if rocket_image_name == "bg_christmasTree.png" then
                        btn:setPosition(ccp(tempSize.width*0.52,tempSize.height*0.64));
                    end
                    btn:setTouchPriority(2);
                    parentNode:addChild(btn)

                    local sprite_wenzi = CCSprite:create("ccbResources/outdoor_wenzi.png")
                    if sprite_wenzi and rocket_image_name ~= "old_rocket_image.png" and rocket_image_name ~= "" then
                        btn:addChild(sprite_wenzi)
                        local tempsize = btn:getContentSize()
                            sprite_wenzi:setPosition(tempsize.width*0.475,tempsize.height*0.75)
                        if rocket_image_name == "bg_christmasTree.png" then
                            sprite_wenzi:setPosition(tempsize.width*0.50,tempsize.height*0.75)
                        end
                    end
                end
            end
        else
            local m_bg_sprite = self.m_ccbNode:spriteForName("m_bg_sprite")
            local rocket_image = CCSprite:create("ccbResources/old_rocket_image.png")

            if rocket_image and m_bg_sprite then
                local tempSize = m_bg_sprite:getContentSize();
                local btnImg = rocket_image:displayFrame();
                local btn = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg));
                btn:setPreferredSize(btnImg:getRect().size);
                btn:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.65));
                btn:setTouchPriority(2);
                m_bg_sprite:addChild(btn)
            end
        end
        
    end
end
function game_main_scene.openDoorActivity(self)
    --状态  0. 未开放, 1.未开启, 2.准备状态, 3. 可以进入状态, 4. 已进入状态
    local open_door = game_data:getAlertsDataByKey("open_door") or 0
    if open_door > 0 then
        local function onBtnCilck( event,target )
            local tagNode = tolua.cast(target, "CCNode");
            local btnTag = tagNode:getTag();
            if open_door < 3 and btnTag == 104 then
                local function responseMethod(tag,gameData)
                    game_scene:addPop("open_door_activity",{gameData = gameData});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("open_door_index"), http_request_method.GET, nil,"open_door_index")
            elseif open_door == 3 and btnTag == 104 then
                local function responseMethod(tag,gameData)
                    game_data:setBattleType("open_door_first_battle");
                    game_scene:enterGameUi("game_battle_scene",{gameData = gameData});
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("open_door_battle"), http_request_method.GET, {},"open_door_battle")
            elseif btnTag == 105 then
                local function responseMethod( tag,gameData )
                    local data = gameData:getNodeWithKey("data");
                    data = json.decode(data:getFormatBuffer()) or {};
                    game_data:setGuildHighWarVersion(data.guild_high_war_version)

                    local is_formation = false
                    is_formation = data.is_formation
                    if is_formation == true then 
                        if game_data:isViewShowByID (174) == true then
                            game_scene:enterGameUi("game_godfield_mainBig");
                        else
                            game_scene:enterGameUi("game_godfield_main",{gameData = gameData})
                        end
                    else
                        local function responseMethod(tag,gameData)
                            if gameData then
                                local first_time = true
                                game_scene:enterGameUi("game_god_adjustment",{gameData = gameData,openType="game_godfield_mainBig",first_time = first_time});
                            end
                        end
                        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_upload_god_formation"), http_request_method.GET, nil,"god_field_upload_god_formation",true,true)
                    end
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_index"), http_request_method.GET, {},"god_field_index")
            else
                game_scene:enterGameUi("open_door_main_scene")
            end
        end
        local m_bg_sprite = self.m_ccbNode:spriteForName("m_bg_sprite")
        local rocket_image = CCSprite:create("ccbResources/rocket_image.png")
        rocket_image:setAnchorPoint(ccp(0.5,1))
        local tempSize = CCDirector:sharedDirector():getWinSize();

        local exchangeThemeId = CCUserDefault:sharedUserDefault():getIntegerForKey("exchangeThemeId") or 0
        if exchangeThemeId and exchangeThemeId ~=0  and game_data:isViewOpenByID(199) then
            local cfg_background_charge = getConfig(game_config_field.background_charge)
            if cfg_background_charge:getNodeWithKey(tostring(exchangeThemeId)) then
                local currentThemeData = cfg_background_charge:getNodeWithKey(tostring(exchangeThemeId))
                local rocket_image_name = currentThemeData:getNodeWithKey("background_tree"):toStr()
                local outdoor_image = CCSprite:create("ccbResources/outdoor_wenzi2.png")
                local godfield_image = CCSprite:create("ccbResources/godfield_wenzi2.png")
                if rocket_image_name and rocket_image_name ~= "" then
                    rocket_image = CCSprite:create("ccbResources/" .. rocket_image_name)
                end
                local outDoorBtnSpriteName,godfieldBtnSpriteName = "", ""

                local btnNameTab = currentThemeData:getNodeWithKey("background_button")
                local btnName1,btnName2 = btnNameTab:getNodeAt(0):toStr(),btnNameTab:getNodeAt(1):toStr()

                if btnName1 and btnName1 ~= "" then
                    outDoorBtnSpriteName = btnName1
                    local tempSprite = CCSprite:create("ccbResources/" .. outDoorBtnSpriteName)
                    if tempSprite then
                        outdoor_image = CCSprite:create("ccbResources/" .. outDoorBtnSpriteName)
                    end
                end
                if btnName2 and btnName2 ~= "" then
                    godfieldBtnSpriteName = btnName2
                    local tempSprite = CCSprite:create("ccbResources/" .. godfieldBtnSpriteName)
                    if tempSprite then
                        godfield_image = CCSprite:create("ccbResources/" .. godfieldBtnSpriteName)
                    end
                end

                if exchangeThemeId <= 3 then 
                    rocket_image:setPosition(ccp(tempSize.width*0.51,tempSize.height*0.65))
                    self.m_rocket_layer:addChild(rocket_image)
                end

                -- local outdoor_image = CCSprite:create("ccbResources/outdoor_christmas_wenzi2.png")
                -- local godfield_image = CCSprite:create("ccbResources/godfield_christmas_wenzi2.png")

                local btnImg1 = godfield_image:displayFrame();
                local btnImg = outdoor_image:displayFrame();
                outdoor_image:setPosition(ccp(tempSize.width*0.45,tempSize.height*0.81))
                godfield_image:setPosition(ccp(tempSize.width*0.55,tempSize.height*0.81))
                local btn = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg));
                btn:setPreferredSize(btnImg:getRect().size);
                btn:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn:setPosition(ccp(tempSize.width*0.46,tempSize.height*0.9));
                btn:setTag(104);
                btn:setTouchPriority(2);

                local btn1 = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg1));
                btn1:setPreferredSize(btnImg1:getRect().size);
                btn1:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn1:setPosition(ccp(tempSize.width*0.56,tempSize.height*0.9));
                if rocket_image_name == "bg_winterTree.png" then
                    btn1:setPosition(ccp(tempSize.width*0.55,tempSize.height*0.9));
                end
                btn1:setTouchPriority(2);
                btn1:setTag(105);
                self.m_root_layer:addChild(btn,222)
                self.m_root_layer:addChild(btn1,222)
            end

        else
            if rocket_image and m_bg_sprite then

                local outdoor_image = CCSprite:create("ccbResources/outdoor_wenzi2.png")
                local godfield_image = CCSprite:create("ccbResources/godfield_wenzi2.png")
                local tempSize_rocket = rocket_image:getContentSize();
                --local tempSize = m_bg_sprite:getContentSize();

                rocket_image:addChild(godfield_image);
                rocket_image:addChild(outdoor_image);

                local btnImg1 = godfield_image:displayFrame();
                local btnImg = outdoor_image:displayFrame();

                rocket_image:setPosition(ccp(tempSize.width*0.51,tempSize.height*0.9))
                outdoor_image:setPosition(ccp(tempSize.width*0.45,tempSize.height*0.81))
                godfield_image:setPosition(ccp(tempSize.width*0.55,tempSize.height*0.81))

                local btn = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg));
                btn:setPreferredSize(btnImg:getRect().size);
                btn:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn:setPosition(ccp(tempSize.width*0.46,tempSize.height*0.9));
                btn:setTag(104);
                btn:setTouchPriority(2);

                local btn1 = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg1));
                btn1:setPreferredSize(btnImg1:getRect().size);
                btn1:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn1:setPosition(ccp(tempSize.width*0.56,tempSize.height*0.9));
                btn1:setTouchPriority(2);
                btn1:setTag(105);
                self.m_rocket_layer:addChild(rocket_image)
                self.m_root_layer:addChild(btn)
                self.m_root_layer:addChild(btn1)
            end
        end
    end
end

function game_main_scene.reciveChatData( self, chatData, state )
    if chatData then
        if state ~= "ui_chat_pop" and chatData.kqgFlag == "friend" then
            self:chatTips()
            -- self.m_show_chatNode:setVisible(true)
            -- local msg = chatData.content or ""
            -- local showName = chatData.user or ""
            -- showName = "[color=ffffdc00]" .. showName .. "[/color]"
            -- self.m_show_chatMsg:setString("" .. showName .. ": " .. msg )
        end
    end
end


--[[--
    创建一个button
]]
function game_main_scene.createAMainButton( self, posx, onBtnCilck, spriteName, tag)
    local winSize = CCDirector:sharedDirector():getWinSize();
    local _rankPos = self.m_rank_btn:getPositionX()      -- 按钮x坐标
    button = game_util:createCCControlButton(spriteName,"",onBtnCilck)
    button:setTouchPriority(GLOBAL_TOUCH_PRIORITY+130);
    button:setTag(tag)
    if posx <(winSize.width*0.3) then
        if posx < _rankPos - self.m_activeBtn_count * 2 * 40 then
            self.m_btn_shensuo:setVisible(true)
            posx = posx + self.m_activeBtn_count * 2 * 40
            self.m_top_btn_node4:addChild(button)
        else
            self.m_btn_shensuo:setVisible(true)
            posx = posx + self.m_activeBtn_count * 40
            self.m_top_btn_node3:addChild(button)
        end
    else
        self.m_activeBtn_count = self.m_activeBtn_count or 0
        self.m_activeBtn_count = self.m_activeBtn_count + 1
        self.m_top_btn_node2:addChild(button)

    end

    button:setPosition(ccp(posx,22))

    return button
end

--[[
    主按钮点击
]]
function game_main_scene.mainBtnOnClick( self, btnTag, tagNode )
    if btnTag == 1 then --去战斗
        if type(game_data.getGuideProcess) == "function" and game_data:getGuideProcess() == "third_enter_main_scene" then
            if type(game_util.statisticsSendUserStep) == "function" then game_util:statisticsSendUserStep(39)  --[[第一次点击战斗 步骤39]] end
        end
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("map_world_scene",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_world_map"), http_request_method.GET, nil,"private_city_world_map")
    elseif btnTag == 2 then--聊天
    --game_scene:addPop("ui_chat_new_pop");
        local function loginChat(data)
            if data["result"] then
                game_scene:addPop("ui_chat_new_pop");
            else
                game_util:addMoveTips({text = "Đăng nhập trò chuyện không thành công, vui lòng thử lại"});
            end
        end

        local function isLoginCall(data)
            if data["result"] then
                game_scene:addPop("ui_chat_new_pop");
            else
                local function responseMethod(tag,gameData)
                    local data = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer())
                    local accid = data["accid"]["accid"]
                    local token = data["accid"]["token"]
                    local roomid = data["chatroom"]["roomid"]
                    local uid = data["accid"]["uid"]

                    --local data = gameData:getNodeWithKey("data")
                    --local accid = data:getNodeWithKey("accid"):toStr()
                    local params = {
                        accid=accid,
                        token=token,
                        roomid=roomid,
                        uid=uid
                    }
                    cclog2(params,"userinfo")
                    require("shared.native_helper").loginChat(params,loginChat)
                    
                    local function newrefresh()
                        require("game_ui.game_loading").show();
                    end
                    performWithDelay(self.m_top_btn_node,newrefresh,0.1)
                end
                --require("shared.native_helper").loginChat({},loginChat)
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("yunxin_chat_info"), http_request_method.GET, nil,"yunxin_chat_info")
            end
        end
        require("shared.native_helper").isLoginChat({},isLoginCall)
        
        -- -- game_scene:enterGameUi("game_first_opening",{});
        -- -- game_util:addMoveTips({text = "暂未开放！"});
        -- -- self.m_show_chatNode:setVisible(false)
        self.m_chat_btn:removeChildByTag(888, true)
    elseif btnTag == 3 then--公告
        game_scene:addPop("annoucement_pop");
        -- game_scene:addPop("game_announcement_pop",{typeName = "announcement"});
    elseif btnTag == 4 then--抢夺
        game_scene:addPop("game_function_pop",{typeName = "snatch",posNode = tagNode})
    elseif btnTag == 11 then--阵型
        if type(game_data.getGuideProcess) == "function" and game_data:getGuideProcess() == "second_enter_main_scene" then
            if type(game_util.statisticsSendUserStep) == "function" then game_util:statisticsSendUserStep(35)  --[[第一次点击阵型 步骤35]] end
        elseif type(game_data.getGuideProcess) == "function" and game_data:getGuideProcess() == "guide_second" then
            if type(game_util.statisticsSendUserStep) == "function" then game_util:statisticsSendUserStep(47)   --[[完成剧情30步 -- 步骤47]] end
        end
        -- CCNative:openURL("http://baidu.com");
        -- CCNative:createAlert("tt","ttt","sure");
        -- CCNative:addAlertButton("dd");
        -- CCNative:showAlertLua(function(tParams) cclog("============================" .. tParams.buttonIndex .. " ; tParams.action = " .. tParams.action) end);
        game_scene:enterGameUi("game_adjustment_formation",{gameData = nil,openType="game_main_scene"});
        self:destroy();
    elseif btnTag == 12 then--伙伴
        game_scene:addPop("game_function_pop",{typeName = "partner",posNode = tagNode})
    elseif btnTag == 13 then--装备z
        if type(game_data.getGuideProcess) == "function" and game_data:getGuideProcess() == "guide_second_start_2_35" then
            if type(game_util.statisticsSendUserStep) == "function" then game_util:statisticsSendUserStep(52)   --[[新手引导35步 -- 步骤52]] end
        end
        game_scene:addPop("game_function_pop",{typeName = "backpack",posNode = tagNode})
    elseif btnTag == 14 then--社交
        game_scene:addPop("game_function_pop",{typeName = "social",posNode = tagNode})
    elseif btnTag == 15 then--商店
        game_scene:addPop("game_function_pop",{typeName = "shop",posNode = tagNode})
    elseif btnTag == 16 then--功能
        game_scene:addPop("game_function_pop",{typeName = "func",posNode = tagNode})
    elseif btnTag == 17 then--加速器
        game_scene:addPop("game_function_pop",{typeName = "accelerate",posNode = tagNode})
    elseif btnTag == 21 then--gacha
        if type(game_data.getGuideProcess) == "function" and game_data:getGuideProcess() == "first_enter_main_scene" then
            if type(game_util.statisticsSendUserStep) == "function" then game_util:statisticsSendUserStep(30)  --[[第一次点击伙伴招募 步骤30]] end
        end
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_gacha_scene",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("gacha_get_all_gacha"), http_request_method.GET, nil,"gacha_get_all_gacha")
    elseif btnTag == 22 then--英雄技能
        game_scene:addPop("game_function_pop",{typeName = "heroInfo",posNode = tagNode})
    elseif btnTag == 23 then--道具
        game_scene:enterGameUi("items_scene",{gameData = nil});
    elseif btnTag == 31 then--竞技场
        if not game_button_open:checkButtonOpen(200) then
            return;
        end
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_arena",{pk_flag = "pk",gameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer())});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("arena_index"), http_request_method.GET, {},"arena_index");
    elseif btnTag == 32 then--活动
        --先联网再进入
        local function responseMethod(tag,gameData)
             --game_scene:enterGameUi("game_activity",{gameData = gameData})
            game_scene:addPop("game_activity_new_pop",{gameData = gameData})
            -- self:destroy()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_index"), http_request_method.GET, nil,"active_index")
    elseif btnTag == 5043 then
        local function responseMethod( tag, gameData )
            if gameData then
                game_scene:enterGameUi("game_teamRaid_main",{gameData = gameData,enterFlag = 1})
            end
        end
        local params = {}
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("team_raid_index"), http_request_method.GET, nil,"team_raid_index")
    elseif btnTag == 1033 then--消息提醒
        if self.m_tshowDoSthParams and self.m_tshowDoSthParams.showType then
        else
            self:refreshDoSomethingBtn()
            return 
        end
        if self.m_tshowDoSthParams.showType == "gongneng" then
            game_data:addOneNewButtonByBtnID(self.m_tshowDoSthParams.data)
        elseif self.m_tshowDoSthParams.showType == "shencundakaoyan" then
            self:showLiveActiveTips("shencundakaoyan", game_data.m_talreadyTips[self.m_tshowDoSthParams.showType].data)
        elseif game_data.m_talreadyTips[self.m_tshowDoSthParams.showType] then
                game_data.m_talreadyTips[self.m_tshowDoSthParams.showType].isShow = true
        end
       if self.m_tshowDoSthParams.showType == "gongneng" and (self.m_tshowDoSthParams.data == 108 or self.m_tshowDoSthParams.data == 109 )then

            local chapterID_index = {}
            local function responseMethod(tag,gameData)
                local data = gameData:getNodeWithKey("data")
                -- cclog("activity data=="..data:getFormatBuffer())
                local others = data:getNodeWithKey("index");--有的即开启
                others_index = json.decode(others:getFormatBuffer())
                for i=1,others:getNodeCount() do
                    local indexItem = others:getNodeAt(i-1)
                    local index_key = indexItem:getKey()
                    table.insert(chapterID_index,tonumber(index_key))
                end
                game_scene:addPop("game_do_something_pop", {gameData = self.m_tshowDoSthParams, activityData = chapterID_index})
                self:refreshDoSomethingBtn();
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_index"), http_request_method.GET, nil,"active_index")
        else
            game_scene:addPop("game_do_something_pop", {gameData = self.m_tshowDoSthParams})
            self:refreshDoSomethingBtn();
        end
    elseif btnTag == 1034 then  -- 等级礼包
        local popRemoveFun = function ()
            -- print("  self:refreshUi()  ")
           self:refreshUi()
        end
       game_scene:addPop("game_limitgift_pop", {gameData = game_data:getAlertsDataByKey("level_gift"), popRemFun = popRemoveFun});
    elseif btnTag == 1035 then --左侧红包
        local function responseMethod(tag,gameData)
           cclog2(gameData,"gameData jihuoma ")
            game_scene:addPop("game_redEnvelope_getRed_pop",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("red_bag_index"), http_request_method.GET, nil,"red_bag_index")
    elseif btnTag == 41 then --每日任务  日常领奖
        function shopOpenResponseMethod(tag,gameData)
            -- game_scene:enterGameUi("game_daily_wanted",{gameData = gameData})
            -- self:destroy();
            game_scene:addPop("game_daily_wanted",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("reward_index"), http_request_method.GET, {},"reward_index")
    elseif btnTag == 1036 then -- 新包礼物
        -- local function responseMethod(tag,gameData)
            -- local is_new_version = game_data:getUserStatusDataByKey()
            local is_new_version = game_data:getIsNewVersion()
            -- cclog2(is_new_version , "is_new_version = = = ")
            
            game_scene:addPop("game_newpackage_getgift_pop",{is_new_version = is_new_version});
        --     self:destroy();
        -- end
        -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("red_bag_index"), http_request_method.GET, nil,"red_bag_index")
     elseif btnTag == 1037 then -- 超值签到
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_superDaily_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("pay_sign_index"), http_request_method.GET, nil,"pay_sign_index")
    elseif btnTag == 35 then --任务
        if game_data:getAlertsDataByKey("diary") and game_data:getAlertsDataByKey("diary") > 0 then
            function responseMethod(tag,gameData)
                game_scene:addPop("game_daily_task_pop",{gameData = gameData})
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("reward_diary_index"), http_request_method.GET, {},"reward_diary_index")
        elseif game_data:getAlertsDataByKey("reward") == true then
            function shopOpenResponseMethod(tag,gameData)
                -- game_scene:enterGameUi("game_daily_wanted",{gameData = gameData})
                -- self:destroy();
                game_scene:addPop("game_daily_wanted",{gameData = gameData})
            end
            network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("reward_index"), http_request_method.GET, {},"reward_index")
        else
            function responseMethod(tag,gameData)
                game_scene:addPop("game_daily_task_pop",{gameData = gameData})
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("reward_diary_index"), http_request_method.GET, {},"reward_diary_index")
        end
    elseif btnTag == 8082 then--新排行榜
        function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_new_rank",{gameData = gameData})
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("rank_combat"), http_request_method.GET, {},"rank_combat",true,true)
    elseif btnTag == 10061 then--小秘书
    elseif btnTag == 10067 then -- 福利
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_fuli_activity_scene",{awardData = gameData, screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("reward_once_index"), http_request_method.GET, nil,"reward_once_index",true,true)
    elseif btnTag == 100 then--pp
        if getPlatForm() == "pp" then
            PP_CLASS:sharedInstance():showCenter();
        elseif getPlatForm() == "itools" then
            PLATFORM_ITOOLS.enterPlatform()
        elseif getPlatForm() == "platformCommon" then
            local function showResult(table)
                -- body
                if table["needShow"] then
                    require("shared.native_helper").enterUserCenter()
                end
            end
            require("shared.native_helper").needShowSDKBtn(showResult)
        end
    elseif btnTag == 101 then--pp论坛独有后加专享唯一跳转按钮
        local updataUrl = "http://bbs.996.com/forum-cjyx-1.html" 
        util_system:openUrlOutside(updataUrl);
    elseif btnTag == 980510 then
        -- cclog("1234342131312431313431243")
            function responseMethod(tag,gameData)
                if gameData then
                    game_scene:addPop("ui_Chrismas_main",{gameData = gameData})
                end
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("snow_index"), http_request_method.GET, {},"snow_index")
    elseif btnTag == 8084 then -- 
        self.m_btn_shensuo:setTag(8085)
        self.m_top_btn_node3:setVisible(true)
        self.m_top_btn_node2:setVisible(false)
        self.m_top_btn_node4:setVisible(false)

    elseif btnTag == 8085 then
        local count = self.m_top_btn_node4:getChildrenCount()
        if count > 0 then
            self.m_btn_shensuo:setTag(8086)
            self.m_top_btn_node3:setVisible(false)
            self.m_top_btn_node4:setVisible(true)
            self.m_top_btn_node2:setVisible(false)
        else
            self.m_btn_shensuo:setTag(8084)
            self.m_top_btn_node3:setVisible(false)
            self.m_top_btn_node4:setVisible(false)
            self.m_top_btn_node2:setVisible(true)
        end
    elseif btnTag == 8086 then
        self.m_btn_shensuo:setTag(8084)
        self.m_top_btn_node4:setVisible(false)
        self.m_top_btn_node3:setVisible(false)
        self.m_top_btn_node2:setVisible(true)
    elseif btnTag == 222 then
        local updataUrl = "https://discord.gg/wabQhDQEfM" 
        util_system:openUrlOutside(updataUrl);
    end
end


--[[
    活动按钮点击
]]
function game_main_scene.activeBtnOnClick( self, btnTag )
    local active_inreview = getConfig(game_config_field.active_inreview)
    local current_vip = game_data:getUserStatusDataByKey("vip")
    if btnTag == 10063 then
        -- 挑战
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_challange_pop",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("battle_challenge_info"), http_request_method.GET, {},"battle_challenge_info")
   elseif btnTag == 10064 then     
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_lucky_turntable",{gameData = gameData})
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("roulette_index"), http_request_method.GET, {},"roulette_index")
    elseif btnTag == 10065 then  -- 龙珠
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("dragon_ball_scene",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("super_active_index"), http_request_method.GET, nil,"super_active_index",true,true)
    elseif btnTag == 8080 then  -- 热门活动
        function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_charge_active",{gameData = gameData})
            self:destroy()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_active_show"), http_request_method.GET, {},"active_active_show")
    elseif btnTag == 950504 then  -- 火焰棋盘
        function responseMethod(tag,gameData)
            if gameData then
                game_scene:addPop("ui_fire_board_pop",{gameData = gameData})
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("fire_chess_index"), http_request_method.GET, {},"fire_chess_index")
    elseif btnTag == 198810 then  -- 超级大玩家
        function responseMethod(tag,gameData)
            if gameData then
                game_scene:addPop("ui_super_player_main",{gameData = gameData})
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("super_player_index"), http_request_method.GET, {},"super_player_index")
   
    elseif btnTag == 8081 then  -- 赛亚人归来
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_saiya_active",{gameData = gameData,screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("super_active_index"), http_request_method.GET, {},"super_active_index",true,true)
    elseif btnTag == 8083 then--公会战
        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            local sort = data:getNodeWithKey("sort"):toInt()
            if sort == 1 then--外围战布阵开启
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = 1});
            elseif sort == 2 then--外围战战争开始
                game_scene:enterGameUi("game_gvg_war_half",{gameData = gameData,sort = 2});
            elseif sort == 3 then--内城布阵开始
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = 3});
            elseif sort == 4 then--内城战开始
                game_scene:enterGameUi("game_gvg_war_half",{gameData = gameData,sort = 4});
            elseif sort == 5 then
                
            elseif sort == -1 then--公会战未开启
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = -1});
            else
                game_scene:enterGameUi("game_gvg_show",{gameData = gameData,sort = sort});
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("guild_gvg_index"), http_request_method.GET, nil,"guild_gvg_index")
    elseif btnTag == 10066 then
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_sky_star",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("bandit_index"), http_request_method.GET, nil,"bandit_index",true,true)
    elseif btnTag == 10089 then --主题英雄传
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_hero_legend",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("rocker_machine_index"), http_request_method.GET, nil,"rocker_machine_index",true,true)
    elseif btnTag == 10068 then--中秋
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("mid_autumn_scene",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_group_index"), http_request_method.GET, nil,"active_group_index",true,true)
    elseif btnTag == 10069 then--中秋
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
       local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("mid_autumn_group_buy_scene",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_group_active_index"), http_request_method.GET, nil,"active_group_active_index",true,true)
    elseif btnTag == 10070 then--福利基金
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                local data = gameData:getNodeWithKey("data")
                local mail_mark = data:getNodeWithKey("mail_mark"):toBool();
                if mail_mark == true then
                    if self.m_fund_btn then
                        self.m_fund_btn:setVisible(false);
                    end
                    game_util:addMoveTips({text = "Phần thưởng còn lại sẽ gửi qua Thư!"})
                else
                    local bought_funds = data:getNodeWithKey("bought_funds")
                    if bought_funds and bought_funds:getNodeCount() > 0 then
                        game_scene:enterGameUi("fund_activation_scene",{gameData = gameData,screenShoot = screenShoot});
                    else
                        game_scene:enterGameUi("fund_main_scene",{gameData = gameData,screenShoot = screenShoot});
                    end
                end
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("foundation_show_available_funds"), http_request_method.GET, nil,"foundation_show_available_funds",true,true)
    elseif btnTag == 10111 then--充值好礼   开服活动
        -- local screenShoot = game_util:createScreenShoot();
        -- screenShoot:retain();
        -- function responseMethod(tag,gameData)
        --     if gameData then
        --         game_scene:enterGameUi("game_open_rechrage",{gameData = gameData,screenShoot = screenShoot})
        --     end
        --     screenShoot:release();
        -- end
        -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_active_recharge_index"), http_request_method.GET, {},"server_active_recharge_index",true,true);
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_server_active_show",{gameData = gameData,screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_active_show"), http_request_method.GET, {},"server_active_show",true,true);
    
    elseif btnTag == 10112 then--限时伙伴   开服活动
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_active_limit",{gameData = gameData,open_type = 2})
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("server_limit_hero_index"), http_request_method.GET, {},"server_limit_hero_index")
    elseif btnTag == 11111 then --新服商城
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_shop_new_scene",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release()
        end
        local params = {}
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_shop_show"), http_request_method.GET, params,"server_shop_show",true,true);
    elseif btnTag == 11112 then -- 新服兑换活动
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_exchange_newServer",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("show_server_exchange_options"), http_request_method.GET, {},"show_server_exchange_options")
    elseif btnTag == 10071 then--开服转盘
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_lucky_turntable_server",{gameData = gameData})
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("server_roulette_index"), http_request_method.GET, {},"server_roulette_index")
    elseif btnTag == 10072 then--开服漫天星
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_sky_star_server",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_bandit_index"), http_request_method.GET, nil,"server_bandit_index",true,true)
    
         elseif btnTag == 10080 then--开服神龙
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("dragon_ball_scene_server",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_super_active_index"), http_request_method.GET, {all_open = 1},"server_super_active_index",true,true)
    elseif btnTag == 10081 then--开服赛亚人
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_saiya_active_server",{gameData = gameData,screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_super_active_index"), http_request_method.GET, {rich_open = 1},"server_super_active_index",true,true)


    elseif btnTag == 10082 then--开服团购   看
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("mid_autumn_scene_server",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_group_index"), http_request_method.GET, nil,"server_group_index",true,true)
    elseif btnTag == 10083 then--开服团购   买
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
       local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("mid_autumn_group_buy_scene_server",{gameData = gameData,screenShoot = screenShoot});
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_group_active_index"), http_request_method.GET, nil,"server_group_active_index",true,true)
    elseif btnTag == 10084 then--海贼王宝藏
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_seapoacher_server",{gameData = gameData,screenShoot = screenShoot});
        end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_one_piece_index"), http_request_method.GET, nil,"server_one_piece_index",true,true)
    elseif btnTag == 10085 then--开服赏金令
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            -- game_scene:addPop("game_bounty_main",{gameData = gameData})
            local bounty_order_type = gameData:getNodeWithKey("data"):getNodeWithKey("bounty_order_type")
            if bounty_order_type then--直接跳到任务
                local index = 1
                if bounty_order_type:getNodeWithKey("bos_one") then
                    index = 1
                elseif bounty_order_type:getNodeWithKey("bos_two") then
                    index = 2
                elseif bounty_order_type:getNodeWithKey("bos_three") then
                    index = 3
                end
                game_scene:enterGameUi("game_bounty_task_server",{gameData = gameData,screenShoot = screenShoot,lookType = index,is_accept = true})
                screenShoot:release()
            else
                game_scene:enterGameUi("game_bounty_main_server",{gameData = gameData,screenShoot = screenShoot})
                screenShoot:release()
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_bounty_order_index"), http_request_method.GET, nil,"server_bounty_order_index")
    elseif btnTag == 10086 then--开服火焰杯
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("ui_firecup_scene_server", { gameData = gameData, screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_magic_school_index"), http_request_method.GET, nil,"server_magic_school_index",true,true)
    elseif btnTag == 10087 then--开服钻石摩天轮
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_ferris_wheel_server", { gameData = gameData, screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_diamond_wheel_index"), http_request_method.GET, nil,"server_diamond_wheel_index",true,true)
    elseif btnTag == 10088 then--开服老玩家回归
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
            game_scene:addPop("ui_oldplayer_pop", { gameData = gameData, screenShoot = screenShoot})
            -- game_scene:addPop("ui_oldplayer_pop", { gameData = nil})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("king_recall_index"), http_request_method.GET, nil,"king_recall_index",true,true)
    elseif btnTag == 10090 then
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();

        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:addPop("game_new_player_invite", { gameData = gameData, screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("newstar_index"), http_request_method.GET, nil,"newstar_index_game_main_scene",true,true)
    elseif btnTag == 10565 then -- 扭蛋机
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();

        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:addPop("game_gashapon", { gameData = gameData, screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("gashapon_index"), http_request_method.GET, nil,"gashapon_index",true,true)
    elseif btnTag == 10073 then--开服基金        
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                local data = gameData:getNodeWithKey("data")
                local mail_mark = data:getNodeWithKey("mail_mark"):toBool();
                if mail_mark == true then
                    if self.m_server_fund_btn then
                        self.m_server_fund_btn:setVisible(false);
                    end
                    game_util:addMoveTips({text = "Phần thưởng còn lại sẽ gửi qua Thư！"})
                else
                    local bought_funds = data:getNodeWithKey("bought_funds")
                    if bought_funds and bought_funds:getNodeCount() > 0 then
                        game_scene:enterGameUi("fund_activation_server_scene",{gameData = gameData,screenShoot = screenShoot});
                    else
                        game_scene:enterGameUi("fund_main_server_scene",{gameData = gameData,screenShoot = screenShoot});
                    end
                end
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_foundation_show_available_funds"), http_request_method.GET, nil,"server_foundation_show_available_funds",true,true)
    elseif btnTag == 10074 then--寻宝
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_seapoacher",{gameData = gameData,screenShoot = screenShoot});
        end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("one_piece_index"), http_request_method.GET, nil,"one_piece_index",true,true)
    elseif btnTag == 10075 then
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("ui_firecup_scene", { gameData = gameData, screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("magic_school_index"), http_request_method.GET, nil,"magic_school_index",true,true)
    
    elseif btnTag == 10076 then--钻石摩天轮
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_ferris_wheel", { gameData = gameData, screenShoot = screenShoot})
            end
            screenShoot:release();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("diamond_wheel_index"), http_request_method.GET, nil,"diamond_wheel_index",true,true)
    elseif btnTag == 12007 then--开服众神殿
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_cloneLane_server_main",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_clone_lane_index"), http_request_method.GET, nil,"server_clone_lane_index")
    elseif btnTag == 11008 then--红包
        local function responseMethod(tag,gameData)
            cclog2(gameData,"gamedata is game_redEnvelope_pop =====")
            game_scene:addPop("game_redEnvelope_pop",{gameData = gameData});

            -- self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("red_bag_index"), http_request_method.GET, nil,"red_bag_index")

   elseif btnTag == 11000 then--赏金令
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            -- game_scene:addPop("game_bounty_main",{gameData = gameData})
            local bounty_order_type = gameData:getNodeWithKey("data"):getNodeWithKey("bounty_order_type")
            if bounty_order_type then--直接跳到任务
                local index = 1
                if bounty_order_type:getNodeWithKey("bos_one") then
                    index = 1
                elseif bounty_order_type:getNodeWithKey("bos_two") then
                    index = 2
                elseif bounty_order_type:getNodeWithKey("bos_three") then
                    index = 3
                end
                game_scene:enterGameUi("game_bounty_task",{gameData = gameData,screenShoot = screenShoot,lookType = index,is_accept = true})
                screenShoot:release()
            else
                game_scene:enterGameUi("game_bounty_main",{gameData = gameData,screenShoot = screenShoot})
                screenShoot:release()
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("bounty_order_index"), http_request_method.GET, nil,"bounty_order_index")
     elseif btnTag == 11001 then--跨服擂台赛
        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            local stage = data:getNodeWithKey("stage")
            if stage then
                stage = stage:toInt()
            end
            if stage == 2 then 
                game_util:addMoveTips({text = "Đang tự động chia nhóm, vui lòng đợi!"}) --正在自动分组，请稍后！
            elseif stage == 4 then
                game_util:addMoveTips({text = "Đang kết toán, vui lòng đợi!"}) --正在结算，请稍后！
            else
                game_scene:enterGameUi("game_league_signup",{gameData = gameData})
                self:destroy()
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_one_index"), http_request_method.GET, nil,"world_one_index")
    elseif btnTag == 500 then-- 消费计划
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_payplan_pop",{ gameData = gameData, turnUICallFun = function (  )
            self:destroy();
        end})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("vip_guide_isbuy"), http_request_method.GET, {},"vip_guide_isbuy")
    elseif btnTag == 6666 then -- 超级返利
        local function responseMethod(tag,gameData)
                game_scene:addPop("game_bigholiday_pop",{ gameData = gameData, turnUICallFun = function (  )
                self:destroy();
            end})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("bigholiday_index"), http_request_method.GET, {},"bigholiday_index")
    elseif btnTag == 501 then
        game_scene:addPop("game_vipguide_pop",{})
    elseif btnTag == 60 then--限时神将
        function shopOpenResponseMethod(tag,gameData)
            -- game_scene:addPop("game_active_limit_pop",{gameData = gameData})
            game_scene:enterGameUi("game_active_limit",{gameData = gameData})
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("get_reward_gacha"), http_request_method.GET, {},"get_reward_gacha")
    elseif btnTag == 61 then--限时积分
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_active_limitscore",{gameData = gameData})
            -- game_scene:addPop("game_active_limitscore_pop",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("integration_index"), http_request_method.GET, {},"integration_index")
    elseif btnTag == 62 then --霸王餐
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_new_free_dinner",{gameData = gameData})
            -- game_scene:addPop("game_active_limitscore_pop",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("free_dinner"), http_request_method.GET, {price = 200},"free_dinner")
    elseif btnTag == 63 then -- 开服霸王餐
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_new_free_dinner_server",{gameData = gameData})
            -- game_scene:addPop("game_active_limitscore_pop",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("server_free_dinner"), http_request_method.GET, {price = 200},"server_free_dinner")

    elseif btnTag == 64 then --砸金蛋
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_golden_eggs",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("egg_index"), http_request_method.GET, {},"egg_index")

    elseif btnTag == 1032 then--开服活动
        function responseMethod(tag,gameData)
            game_scene:addPop("game_opening_pop",{gameData = gameData, callFun =  function()
                    game_scene:enterGameUi("game_main_scene",{gameData = nil});
                end})
            self:destroy()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_kfhd_index"), http_request_method.GET, {},"active_kfhd_index")
    elseif btnTag == 11002 then--红包
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_redpacket_pop",{gameData = gameData})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("redpacket_index"), http_request_method.GET, nil,"redpacket_index")
    elseif btnTag == 11003 then--跨服摩天轮
        function shopOpenResponseMethod(tag,gameData)
            local VIP_limit,needVip 
            if active_inreview:getNodeWithKey("517"):getNodeWithKey("VIP_limit") then
                needVip = active_inreview:getNodeWithKey("517"):getNodeWithKey("VIP_limit"):toInt() or 1
                if current_vip < needVip then
                    VIP_limit = "true"
                else
                    VIP_limit = "close"
                end
            end
            game_scene:enterGameUi("game_server_lucky_truntable",{gameData = gameData,VIP_limit = VIP_limit,needVip = needVip})
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("large_roulette_index"), http_request_method.GET, {},"large_roulette_index")
    elseif btnTag == 11005 then--群雄争霸
        local function responseMethod(tag,gameData)
            local VIP_limit,needVip 
            if active_inreview:getNodeWithKey("516"):getNodeWithKey("VIP_limit") then
                needVip = active_inreview:getNodeWithKey("516"):getNodeWithKey("VIP_limit"):toInt() or 1
                if current_vip < needVip then
                    VIP_limit = "true"
                else
                    VIP_limit = "close"
                end
            end
            game_scene:enterGameUi("game_lsxx_rank",{gameData = gameData,VIP_limit = VIP_limit,needVip = needVip});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("large_super_rich_index"), http_request_method.GET, nil,"large_super_rich_index")
    elseif btnTag == 11004 then--乱世枭雄
        local function responseMethod(tag,gameData)
            local VIP_limit,needVip 
            if active_inreview:getNodeWithKey("515"):getNodeWithKey("VIP_limit") then
                needVip = active_inreview:getNodeWithKey("515"):getNodeWithKey("VIP_limit"):toInt() or 1
                if current_vip < needVip then
                    VIP_limit = "true"
                else
                    VIP_limit = "close"
                end
            end
            game_scene:enterGameUi("game_lsxx",{gameData = gameData,VIP_limit = VIP_limit,needVip = needVip});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("large_super_all_index"), http_request_method.GET, nil,"large_super_all_index")
    elseif btnTag == 11009 then--古灵阁
        local screenShoot = game_util:createScreenShoot();
        screenShoot:retain();
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_gringotts_scene",{gameData = gameData,screenShoot = screenShoot});
            screenShoot:release()
            -- self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("gringotts_index"), http_request_method.GET, nil,"gringotts_index")
    elseif btnTag == 11007 then--克隆诡巷
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_cloneLane_main",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("clone_lane_index"), http_request_method.GET, nil,"clone_lane_index")

    elseif btnTag == 11010 then -- 大富翁
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_monopoly_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("super_tycoon_active_index"), http_request_method.GET, nil,"super_tycoon_active_index")
    elseif btnTag == 12010 then -- 开服大富翁
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_monopoly_server_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_super_tycoon_active_index"), http_request_method.GET, nil,"server_super_tycoon_active_index")
    elseif btnTag == 11011 then -- 世界树
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_worldTree_new_mian",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("world_tree_new_index"), http_request_method.GET, nil,"world_tree_new_index")
   
    elseif btnTag == 11013 then -- 卡牌集换
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_cardCollection_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("card_collection_index"), http_request_method.GET, nil,"card_collection_index")
    elseif btnTag == 12013 then -- 卡牌集换
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_cardCollection_server_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_card_collection_index"), http_request_method.GET, nil,"server_card_collection_index")
    elseif btnTag == 11012 then -- 夺宝奇兵
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_indiana_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("raiders_index"), http_request_method.GET, nil,"raiders_index")    
--month_fund
     elseif btnTag ==11016 then --月初基金 
        local function responseMethod(tag,gameData)
        if gameData then
                local data = gameData:getNodeWithKey("data")
                local mail_mark = data:getNodeWithKey("mail_mark"):toBool();
                if mail_mark == true then
                    game_util:addMoveTips({text = "剩余奖励已通过邮件发送，请查收！"})
                else
                    game_scene:addPop("game_month_fund_pop",{gameData=gameData}); 
                end
            end
           
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("month_foundation_index"), http_request_method.GET, nil,"month_foundation_index")
    elseif btnTag == 11017 then --新大富翁
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_newRichMan_main",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("monopoly_index"), http_request_method.GET, nil,"monopoly_index")
    elseif btnTag == 11018 then --聚宝盆
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_cornucopia_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("bowl_index"), http_request_method.GET, nil,"bowl_index")
    elseif btnTag == 11019 then -- 羊驼快跑
        local function responseMethod( tag,gameData )
            game_scene:enterGameUi("ui_yato_running_main_new",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("yato_running_index"),http_request_method.GET,nil,"yato_running_index")

    elseif btnTag == 955401 then
        game_scene:addPop("game_survey_pop")
    elseif btnTag == 12011 then --新转盘 秘境探宝
        local function ResponseMethod(tag,gameData)
            -- game_scene:addPop("ui_new_roulette",{gameData = json.decode(gameData:getFormatBuffer()).data})
            game_scene:addPop("ui_new_roulette",{gameData = gameData})
        end
        local params = {};
        params.type = 1;
        network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("new_roulette_index"), http_request_method.GET, params,"new_roulette_index")
    elseif btnTag == 12012 then --培养赛
        local function ResponseMethod(tag,gameData)
            -- game_scene:addPop("ui_new_roulette",{gameData = json.decode(gameData:getFormatBuffer()).data})
            game_scene:addPop("game_trainning",{gameData = gameData})
            -- game_scene:addPop("game_trainning")
        end
        network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("trainning_index"), http_request_method.GET, nil,"trainning_index")
    elseif btnTag == 955402 then -- 幸运彩票
                local function ResponseMethod(tag,gameData)
            -- game_scene:addPop("ui_new_roulette",{gameData = json.decode(gameData:getFormatBuffer()).data})
            game_scene:addPop("game_lottery_main",{gameData = gameData})
            -- game_scene:addPop("game_trainning")
        end
        network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("lottery_index"), http_request_method.GET, nil,"lottery_index")
    elseif btnTag == 502 then
         local function responseMethod(tag,gameData)
                local data = gameData:getNodeWithKey("data");
                game_scene:enterGameUi("ui_vip",{gameData = gameData});
                --game_scene:addPop("ui_vip_show_pop")

            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("vip_buy_step"), http_request_method.GET, nil,"vip_buy_step")
    elseif btnTag == 767 then
        local function responseMethod( tag,gameData )
            local data = gameData:getNodeWithKey("data")
            game_scene:addPop("game_leichong_active",{gameData = gameData});
            -- self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("recharge_index"), http_request_method.GET, nil,"recharge_index")
    elseif btnTag == 12015 then --抓娃娃
        local function ResponseMethod( tag,gameData )
            game_scene:addPop("game_zhuawawa_pop",{gameData = gameData})
        end
        local params = {}
        network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("toy_toy_index"),http_request_method.GET,params,"toy_toy_index")
    elseif btnTag == 12016 then --玲珑宝塔
        local function ResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_pagoda_scene",{gameData = gameData})
        end
        local params = {};
        network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("pagoda_pagoda_index"), http_request_method.GET, params,"pagoda_pagoda_index")
    elseif btnTag == 12017 then   --收集国旗
        local function ResponseMethod(tag,gameData)
            game_scene:addPop("game_world_cup_flag",{gameData = gameData})
        end
        local params = {};
        network.sendHttpRequest(ResponseMethod,game_url.getUrlForKey("world_cup_flag_index"), http_request_method.GET, params,"world_cup_flag_index")
    
    elseif btnTag == 13000 then --足球竞猜
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("ui_guessing_football_main",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("world_cup_guess_index"), http_request_method.GET, {},"world_cup_guess_index")
    elseif btnTag == 13001 then --偶像英雄祭
        function shopOpenResponseMethod(tag,gameData)
        --     game_scene:addPop("ui_guessing_football_main",{gameData = gameData})
            game_scene:enterGameUi("ui_call_for_idle_main",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("idol_festival_index"), http_request_method.GET, {},"idol_festival_index")   
    elseif btnTag == 13003 then --宇宙神射
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_shooting",{gameData = gameData}) 
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("god_shot_index"), http_request_method.GET, {},"god_shot_index")

    elseif btnTag == 13006 then --拼图大作战
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_spell_image_pop",{gameData = gameData}) 
           
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("jigsaw_jigsaw_index"), http_request_method.GET, {},"jigsaw_jigsaw_index")
    
    elseif btnTag == 13005 then --狂欢圣典
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_carnival_pop",{gameData = gameData}) 
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("celebration_show"), http_request_method.GET, {},"celebration_show")
    elseif btnTag == 13007 then --我是大富翁
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_super_luck",{gameData = gameData}) 
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("super_luck_index"), http_request_method.GET, {},"super_luck_index")
    elseif btnTag == 13010 then --限时出征
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_limit_time_war_pop",{gameData = gameData}) 
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("limit_time_war_index"), http_request_method.GET, {},"limit_time_war_index")
    elseif btnTag == 562 then -- 邀请码
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_invitation_pop",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("invite_code_index"), http_request_method.GET, {},"invite_code_index")
    elseif btnTag == 13011 then -- 赋能大赛
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_empowerContest_index",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("funeng_task_index"), http_request_method.GET, {},"funeng_task_index")
    elseif btnTag == 13012 then -- 新服红包 
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_server_redpacket_pop",{gameData = gameData})
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("redpacket_server_index"), http_request_method.GET, nil,"redpacket_index")
    elseif btnTag == 563 then -- 一元夺宝
        local function responseMethod(tag,gameData)
            game_scene:addPop("game_oneYuanRaffle",{gameData = gameData})
        end
        local params = {}
        params['start'] = 1
        params['end'] = params["start"] + 19
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("crowdfunding_index"), http_request_method.GET, params, "crowdfunding_index")
    end
        
   

end

--[[--
    功能按鈕
]]
function game_main_scene.setBottomBtnSort(self)
    -- local items = self.m_bottom_btn_node:getChildren();
    -- local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    -- if items then
    --     local itemCount = items:count();
    --     local btn = nil;
    --     local posIndex = 0;
    --     for i = 1,itemCount do
    --         btn = tolua.cast(items:objectAtIndex(i - 1),"CCControlButton");
    --         if btn:isVisible() then
    --             local btnSize = btn:getContentSize();
    --             btn:setPositionX(visibleSize.width - btnSize.width*(1.7 + 1.15*posIndex));
    --             posIndex = posIndex + 1;
    --         end
    --     end
    -- end
end

--[[--
    功能按鈕
]]
function game_main_scene.setRightBtnSort(self)
    -- local items = self.m_right_btn_node:getChildren();
    -- local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    -- if items then
    --     local itemCount = items:count();
    --     local btn = nil;
    --     local posIndex = 0;
    --     for i = 1,itemCount do
    --         btn = tolua.cast(items:objectAtIndex(i - 1),"CCControlButton");
    --         if btn:isVisible() then
    --             local btnSize = btn:getContentSize();
    --             btn:setPositionY(btnSize.height*(1.5 + 1.1*posIndex));
    --             posIndex = posIndex + 1;
    --         end
    --     end
    -- end
end
--[[--
    通過陣型下標創建卡牌動畫
]]
function game_main_scene.createCardAnimByPosIndex(self,posIndex)
    local animNode = nil;

    local heroData,heroCfg = game_data:getTeamCardDataByPos(posIndex)
    if heroData and heroCfg then
        local ainmFile = heroCfg:getNodeWithKey("animation"):toStr();
        animNode = game_util:createIdelAnim(ainmFile,0,heroData,heroCfg);
        if animNode then
            animNode:setRhythm(1);
            local itemSize = animNode:getContentSize();
            animNode:setAnchorPoint(ccp(0.5,0));
            local headBg = CCSprite:createWithSpriteFrameName("public_hengtiao.png");
            headBg:setOpacity(155);
            headBg:setPosition(ccp(itemSize.width*0.5,itemSize.height + 15));
            animNode:addChild(headBg)
            --改 ---------- 2 --------------- 直接不顯示等級上限
            -- local tempLabel = CCLabelTTF:create("Lv." .. heroData.lv .. "/" .. heroData.level_max,TYPE_FACE_TABLE.Arial_BoldMT,10);
            --最大等級修改為用戶等級
            local userMaxLevel = game_data:getUserStatusDataByKey("level")
            --幾張不能進階的卡最大等級是1
            local is_evo = heroCfg:getNodeWithKey("is_evo")
            local maxLevel = userMaxLevel
            if is_evo and is_evo:toInt() == 0 then
                maxLevel = 1
            end
            -- local tempLabel = CCLabelTTF:create("Lv." .. heroData.lv .. "/" .. maxLevel,TYPE_FACE_TABLE.Arial_BoldMT,10);
            local tempLabel = CCLabelTTF:create("Lv." .. heroData.lv,TYPE_FACE_TABLE.Arial_BoldMT,10);
            -- tempLabel:setPosition(ccp(itemSize.width*0.5 - 40,itemSize.height + 15));
            --改为居中
            tempLabel:setPosition(ccp(itemSize.width*0.5,itemSize.height + 15));
            tempLabel:setAnchorPoint(ccp(0.5,0.5));
            animNode:addChild(tempLabel,100,100)
            -- local tempLabel = CCLabelTTF:create(heroCfg:getNodeWithKey("name"):toStr(),TYPE_FACE_TABLE.Arial_BoldMT,10);
            -- tempLabel:setPosition(ccp(itemSize.width*0.5 + 50,95));
            -- tempLabel:setAnchorPoint(ccp(1,0.5));
            -- animNode:addChild(tempLabel,100,100)
            -- game_util:setHeroNameColorByQuality(tempLabel,heroCfg);
            local occupation_cfg = getConfig(game_config_field.occupation);
            local occupation_item_cfg = occupation_cfg:getNodeWithKey(ainmFile)
            if occupation_item_cfg then
                local occupationType = occupation_item_cfg:toInt();
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    local occupation_icon = CCSprite:createWithSpriteFrame(spriteFrame)
                    occupation_icon:setPosition(ccp(itemSize.width*0.5 + 40,itemSize.height + 15));
                    occupation_icon:setAnchorPoint(ccp(1,0.5));
                    animNode:addChild(occupation_icon);
                end
            end
        end
    end
    return animNode;
end

--[[--
    觸摸
]]
function game_main_scene.initLayerTouch(self,touch_layer)
    local tempItem,selItem,realPos
    local function onTouchBegan(x, y)
        -- CCTOUCHBEGAN event must return true
        selItem = nil;
        realPos = self.m_team_layer:convertToNodeSpace(ccp(x,y));
        for k,v in pairs(self.m_teamNodeTab) do
            tempItem = v
            if tempItem:boundingBox():containsPoint(realPos) then
                selItem = tempItem;
                break;
            end
        end
        return true
    end
    local function onTouchMoved(x, y)
    end
    local function onTouchEnded(x, y)
        realPos = self.m_team_layer:convertToNodeSpace(ccp(x,y));
        if selItem and selItem:boundingBox():containsPoint(realPos) then
            -- cclog("on click -----------------------------" .. selItem:getTag())
            local heroData,heroCfg = game_data:getTeamCardDataByPos(selItem:getTag())
            if heroData and heroCfg then
                local function callBack(typeName)
                    typeName = typeName or ""
                    if typeName == "refresh" then
                        self:refreshTeamLayer();
                    end
                end
                game_scene:addPop("game_hero_info_pop",{tGameData = heroData,openType = 1,callBack = callBack})
            end
        end
        tempItem = nil;
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
    touch_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY+140,false)
    touch_layer:setTouchEnabled(true)
end
--[[--
    
]]
function game_main_scene.refreshBtnStatus(self)
    for k,v in pairs(self.m_tipsAnimTab) do
        v:removeFromParentAndCleanup(true);
    end
    self.m_tipsAnimTab = {};

    -- 其他按钮
    self:setButtonState(self.m_gacha_btn, 12)  -- 伙伴招募
    -- self:setButtonState(self.m_guild_btn, 13)  -- 背包
    self:setButtonState(self.m_chat_btn, 14)  -- 聊天
    self:refreshTopButton();
    self:refreshActiveButton();

    if game_data:getAlertsDataByKey("gacha") then
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_shop_btn,9);
    end

    if game_data:getNewCardFlag() then
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_partner_btn,10);
    else
        -- 训练完成， 英雄碎片兑换 -- 红点不再显示
        -- if game_data:getAlertsDataByKey("train_finish") or game_data:getAlertsDataByKey("exchange") == true then
        --     self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_partner_btn,9);
        -- end
    end
    if game_data:getOpenFormationAlertFlag() then
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_formation_btn,9);
    end
    
    -- 世界boss 提醒活动按钮
    if game_data:getAlertsDataByKey("boss") then--活动
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_activity_btn,7);
    end
    local level = game_data:getUserStatusDataByKey("level") or 0
    -- 生存物资 提醒福利按钮
    if game_data:getAlertsDataByKey("active") == 1 and game_data:isViewOpenByID( 49 ) then--活动
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_conbtn_fuli, 18);
    else
        -- 月卡 提醒福利按钮
        if game_data:getAlertsDataByKey("month") and game_data:isViewOpenByID( 126 ) then--活动
            self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_conbtn_fuli, 18);
        else
            if level >= 3 then
                -- 签到奖励提示
                if game_data:getAlertsDataByKey("daily") == true and game_data:isViewOpenByID(9) then
                    self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_conbtn_fuli, 18);
                end
                if game_data:getAlertsDataByKey("once") == true and game_data:isViewOpenByID( 8 ) then--领奖   或在线领奖
                    self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_conbtn_fuli,18 );
                end
            end
        end
    end

    -- 装备兑换按钮红点不再显示 --
    if game_data:getNewEquipFlag() or game_data:getNewItemFlag() or game_data:getAlertsDataByKey("equip_exchange") == true then
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_backpack_btn,10);
    end

    if game_data:getAlertsDataByKey("notify") then
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_social_btn,9);
    end
    if game_data:getAlertsDataByKey("guild_gvg") then
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_gvg_btn,7);
    end
    -- -- 精力 30   -- 统帅
    -- if game_button_open:getOpenFlagByBtnId(606) then
    --     local cmdr_energy = game_data:getUserStatusDataByKey("cmdr_energy") or 0
    --     if cmdr_energy >= 30 and game_data:updateShowTips("cmdr_energy" )  then  -- 精力已满
    --         self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_leader_skill_btn,9);
    --     elseif cmdr_energy < 30 then
    --         game_data:updateShowTips("cmdr_energy", "reset_show")
    --     end
    -- end

    -- 金币300 gacha
    local ogold = game_data:getUserStatusDataByKey("silver") or 0  -- 金币数量
    if game_data:isViewOpenByID(12) then
        if ogold >= 300 and game_data:updateShowTips("gold_enough" )  then  -- 可以金币招募了
            self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_gacha_btn,9);
            cclog2(ogold, "ogold   ====    ")
        elseif ogold < 300 then
            game_data:updateShowTips("gold_enough", "reset_show")
        end
    end


    -- 星灵 1000  -- 英雄技能
    if game_button_open:getOpenFlagByBtnId(605) then
        local totalStar = game_data:getUserStatusDataByKey("star") or 0
        if totalStar >= 1000  and game_data:updateShowTips("totalStar") then  -- 星灵 1000
            self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_leader_skill_btn,9);
        elseif totalStar < 1000  then
            game_data:updateShowTips("totalStar", "reset_show")
        end
    end

    -- mark do  -- 目前使用的是 活动的动画 应该是 开服活动
    -- 开服活动按钮动画尝试
    if game_data:getAlertsDataByKey("opening") and game_data:getAlertsDataByKey("opening") ~= "" then    --活动
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_kfhd_activity_btn, 7);
    end

    -- 每天第一次登陆 悬赏任务闪烁
    local tflag = false
    local sedata = game_data:getUserStatusDataByKey("server_time")
    local formatDate = os.date("*t", sedata)
    local time = os.date("%Y%m%d", sedata)
    local localSaveData = game_data:updateLocalData( "m_task_btn_date" )
    local itime = tonumber(time)
    local ilocaltime = tonumber(localSaveData) or 0
    if itime > ilocaltime then
        -- print("  -------------   time", itime)
        game_data:updateLocalData( "m_task_btn_date", tostring(itime + 1), true)
        tflag = true
    elseif itime == ilocaltime and formatDate.hour >= 16 then
        game_data:updateLocalData( "m_task_btn_date", tostring(itime + 1), true)
        tflag = true
    end

    if level >= 3 then
        -- reward 日常任务（悬赏）奖励
        -- diary  日常任务
        -- daily  签到
        if game_data:getAlertsDataByKey("reward") == true or ( game_data:getAlertsDataByKey("diary") and game_data:getAlertsDataByKey("diary") > 0)  or tflag then-- 任务
            self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_task_btn,12);
        elseif game_data:getAlertsDataByKey("reward") == nil and game_data:getAlertsDataByKey("diary") == nil then--
            self.m_task_btn:setVisible(false)
        end
    else
        self.m_task_btn:setVisible(false)
    end
    if not game_data:isViewOpenByID(4) then  -- 日常任务按钮隐藏
        self.m_task_btn:setVisible(false)
    end
    
    --热门活动
    if game_data:getAlertsDataByKey("active_show") == true then
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_hot_active_btn,16);
    end
end

local top_btn_name_tab = {{name="m_rank_btn",inReviewId=52},{name="m_ranking_btn",inReviewId=7},{name = "m_conbtn_teamRaid",inReviewId=219},{name="m_activity_btn",inReviewId=6},{name="m_conbtn_fuli",inReviewId=3}}

function game_main_scene.refreshTopButton( self )
    local posx = self.m_rank_btn:getPositionX()   -- 按钮x坐标
    for i=1,#top_btn_name_tab do
        local itemData = top_btn_name_tab[i]
        local tempBtn = self[itemData.name]
        if tempBtn then
            if game_data:isViewOpenByID(itemData.inReviewId) then
                tempBtn:setPositionX(posx)
                tempBtn:setVisible(true)
                posx = posx - 40
            else
                tempBtn:setVisible(false)
            end
        end
    end
end

local active_btn_name_tab = {
    "m_pay_btn",
    "m_conbtn_vipshow_btn",
    "m_kfhd_activity_btn",
    "m_limit_btn",
    "m_conbtn_limit_score_btn",
    "m_lucky_turntable_btn",
    "m_dragon_ball_btn",
    "m_king_btn",
    "m_hot_active_btn",
    "m_sky_star_btn",
    "m_gvg_btn",
    "m_mid_autumn_btn",
    "m_mid_autumn_buy_btn",
    "m_fund_btn",
    "m_xunbao_btn",
    "m_btn_firecup",
    "m_ferris_sheel_btn",
    "m_kaifu_chongzhi_btn",
    "m_kaifu_limit_hero_btn",
    "m_kaifu_newshop_btn",
    "m_kaifu_newExchange_btn",
    "m_server_lucky_turntable_btn",
    "m_server_sky_star_btn",
    "m_server_fund_btn",
    "m_server_dragon_ball_btn",
    "m_server_king_btn",
    "m_server_mid_autumn_btn",
    "m_server_mid_autumn_buy_btn",
    "m_server_xunbao_btn",
    "m_server_btn_bounty",
    "m_lsxx_btn",
    "m_monopoly_btn",
    "m_redEnvelope_btn",
    "m_superDaily_btn",
    "m_fire_board_btn",
    "m_yato_btn",
    "m_free_dinner_btn",
    "m_lottery_btn",
    "m_server_monopoly_btn",
    "empowerContest",
    "m_bigholiday_btn",
    "m_oneYuanRaffle_btn"
}

--[[
    --活动
]]
function game_main_scene.refreshActiveButton( self )
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_bloodstone_res.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_card_quality_bg_res.plist")
    for k,v in pairs(active_btn_name_tab) do
        self[v] = nil;
    end
    local function onBtnCilck( event,target )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        self:activeBtnOnClick(btnTag);
    end
    self.m_top_btn_node2:removeAllChildrenWithCleanup(true);
    self.m_top_btn_node3:removeAllChildrenWithCleanup(true);
    self.m_top_btn_node4:removeAllChildrenWithCleanup(true);
    local posx = self.m_rank_btn:getPositionX()      -- 按钮x坐标
    posx = posx - 10
    local shopInfo = game_data:getShopData()
    local level = game_data:getUserStatusDataByKey("level") or 0
    local vipLevel = game_data:getUserStatusDataByKey("vip") or 0
    -- cclog2(game_data:getAlertsDataByKey("opening"), "opening ==== ")

    if game_data:isViewOpenByID(1) and (vipLevel < 1  or game_data:getAlertsDataByKey("opening") == 1) then
        self.m_conbtn_vipshow_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_chongzhihaoli.png", 501)
        posx = posx - 40
    else
        if game_data:isViewOpenByID(2) and shopInfo.guide_display then
            self.m_pay_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_xiaofeijihua.png", 500)
            posx = posx - 40
        end
    end

    local server_time = game_data:getUserStatusDataByKey("server_time")
    local sedata,_ = game_data:getServer()
    local open_time = -1;
    if sedata.open_time then
        open_time = sedata.open_time
    end

    local endFlag = false
    if open_time ~= -1 then
        local serDate = os.date("%Y%m%d", server_time) or 1
        local dayNum = game_data:getOpeningDayNum() or 14
        -- local curDay = "" .. serDate.year .. serDate.month .. serDate.day
        local endDate = os.date("%Y%m%d", sedata.open_time +  dayNum * 24 * 3600) or 0
        -- local endDay = "" .. endDate.year .. endDate.month .. endDate.day
        local nCurDay = tonumber(serDate)
        local nEndDay = tonumber(endDate)
        -- print(" opeing date : endDay == ", nEndDay, " curDay == ", nCurDay)
        if nCurDay>nEndDay then
            endFlag = true
        end
    end
    if game_data:isViewOpenByID(10) and level >= 3 and (open_time == -1 or not endFlag) then    -- 开服
        self.m_kfhd_activity_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_kaifuhuodong.png", 1032)
        posx = posx - 40
    end


    -- if game_data:isViewOpenByID(110) then  -- 限时神将活动
    --     self.m_limit_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_xianshi.png", 60)
    --     posx = posx - 40
    -- end

      if game_data:isViewOpenByID(112) or game_data:isViewOpenByID(113) then  -- 限时积分活动
        self.m_conbtn_limit_score_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_limitscore.png", 61)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(501) then  --热门活动   inview 117  新 active_inview  501
        self.m_hot_active_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_remen.png", 8080)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(532) then  --火焰棋盘   inview 117  新 active_inview  532
        self.m_fire_board_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_fire_board.png", 950504)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(534) then  -- 超级大玩家   inview 534  新 active_inview  534
        self.m_super_player_btn = self:createAMainButton(posx,onBtnCilck, "mbutton_super_player.png",198810)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(502) then  -- 限时神将活动   inview 110 新 active_inview 502
        self.m_limit_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_xianshi.png", 60)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(503) then  -- 转盘活动  inview 114 新 active_inview 503
        self.m_lucky_turntable_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_lunpan.png", 10064)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(504) then  -- 神龙活动  inview 115 新 active_inview 503
        self.m_dragon_ball_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_shenlong.png", 10065)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(505) then  --赛亚人归来  inview 116  新 active_inview  505  
        self.m_king_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_king.png", 8081)
        posx = posx - 40
    end
  
    if game_data:isActiveOpenByID(506) then  -- 满天星活动 inview 124  新 active_inview 506
        self.m_sky_star_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_maintianxing.png", 10066 )
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(520) then  -- 主题英雄传活动 inview 124  新 active_inview 506
        self.m_hero_legend_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_hero_legend.png", 10089 )
        posx = posx - 40
    end
    
    if game_data:isActiveOpenByID(507) then  -- 中秋活动   inview 125  新 active_inview  507
        self.m_mid_autumn_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_zhongqiu.png", 10068)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(507) then  -- 中秋团购活动   inview 125  新 active_inview  507
        self.m_mid_autumn_buy_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_zhongqiutuangou.png", 10069)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(508) or game_data:getDataByKey("foundation_status") == true then  -- 福利基金  inview 127  新 active_inview  508 
        self.m_fund_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_jijin.png", 10070)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(509) then  -- 寻宝活动   inview 125  新 active_inview  509
        self.m_xunbao_btn = self:createAMainButton( posx, onBtnCilck, "m_button_xunbao.png", 10074)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 510 ) then -- 火焰杯  inview 141  新 active_inview 510
        self.m_btn_firecup = self:createAMainButton( posx, onBtnCilck, "m_button_c_firecup.png", 10075)
        posx = posx - 40
    end
    -- if game_data:isViewOpenByID(114) then  -- 转盘活动
    --     self.m_lucky_turntable_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_lunpan.png", 10064)
    --     posx = posx - 40
    -- end
    


    -- if game_data:isViewOpenByID(115) then  -- 神龙活动
    --     self.m_dragon_ball_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_shenlong.png", 10065)
    --     posx = posx - 40
    -- end
    

    --热门活动
    -- if game_data:isViewOpenByID(117) then
    --     self.m_hot_active_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_remen.png", 8080)
    --     posx = posx - 40
    -- end
    

    --赛亚人归来
    -- if game_data:isViewOpenByID(116) then
    --     self.m_king_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_king.png", 8081)
    --     posx = posx - 40
    -- end
    


    -- if game_data:isViewOpenByID(124) then  -- 满天星活动
    --     self.m_sky_star_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_maintianxing.png", 10066 )
    --     posx = posx - 40
    -- end
    
    if level >= 10 and game_data:isViewOpenByID(123) then--公会战
        self.m_gvg_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_zhengba.png", 8083)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(535) then  --新大富翁   
        self.m_fire_board_btn = self:createAMainButton( posx, onBtnCilck, "m_button_newRichMan.png", 11017)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(536) then  --聚宝盆
        self.m_fire_board_btn = self:createAMainButton( posx, onBtnCilck, "m_button_cornucopia.png", 11018)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(538) then   --羊驼快跑  
        self.m_yato_btn = self:createAMainButton(posx,onBtnCilck,"mbutton_m_xunlu.png",11019)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(537) then  -- 霸王餐
        self.m_free_dinner_btn = self:createAMainButton( posx, onBtnCilck, "ui_free_dinner_main_icon.png", 62)
        posx = posx - 40 --霸王餐 
    end 
    if game_data:isViewOpenByID(919) then  -- 开服霸王餐
        self.m_free_dinner_btn = self:createAMainButton( posx, onBtnCilck, "ui_free_dinner_main_icon.png", 63)
        posx = posx - 40 --霸王餐 
    end 
    if game_data:isActiveOpenByID(541) then  -- 砸金蛋
        self.m_conbtn_limit_score_btn = self:createAMainButton( posx, onBtnCilck, "m_button_zadan.png", 64)
        posx = posx - 40 --砸金蛋 
    end 
    -- if game_data:isViewOpenByID(125) then  -- 中秋活动
    --     self.m_mid_autumn_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_zhongqiu.png", 10068)
    --     posx = posx - 40
    -- end

    -- if game_data:isViewOpenByID(125) then  -- 中秋团购活动
    --     self.m_mid_autumn_buy_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_zhongqiutuangou.png", 10069)
    --     posx = posx - 40
    -- end
    

    -- if game_data:isViewOpenByID(127) or game_data:getDataByKey("foundation_status") == true then  -- 福利基金
    --     self.m_fund_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_jijin.png", 10070)
    --     posx = posx - 40
    -- end

    -- if game_data:isViewOpenByID(132) then  -- 寻宝活动
    --     self.m_xunbao_btn = self:createAMainButton( posx, onBtnCilck, "m_button_xunbao.png", 10074)
    --     posx = posx - 40
    -- end
    


    if game_data:isActiveOpenByID( 511 ) then -- 钻石摩天轮  新 active_inview 511
        self.m_ferris_sheel_btn = self:createAMainButton( posx, onBtnCilck, "m_button_motianlun.png", 10076)
        posx = posx - 40
    end

    if game_data:isViewOpenByID( 915 ) then -- active_inview 915     大富翁
        self.m_server_monopoly_btn = self:createAMainButton( posx, onBtnCilck, "m_button_richman.png", 12010)
        posx = posx - 40
    end


    if game_data:isActiveOpenByID( 524 ) then -- active_inview 524     m_cloneLane_btn
        self.m_gringotts_btn = self:createAMainButton( posx, onBtnCilck, "m_button_gringotts.png", 11009)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 526 ) then -- active_inview 526     大富翁
        self.m_monopoly_btn = self:createAMainButton( posx, onBtnCilck, "m_button_richman.png", 11010)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 527 ) then -- active_inview 527     世界之树
        self.m_monopoly_btn = self:createAMainButton( posx, onBtnCilck, "m_button_worldTree.png", 11011)
        posx = posx - 40
    end
    
    if game_data:isActiveOpenByID( 512 ) then -- 赏金令  active_inview 512
        self.m_btn_bounty = self:createAMainButton( posx, onBtnCilck, "mbutton_m_bounty.png", 11000)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 529 ) then -- active_inview 529     卡牌集换
        self.m_cardCollection_btn = self:createAMainButton( posx, onBtnCilck, "m_button_cardCollection.png", 11013)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID( 528 ) then -- active_inview 528     夺宝奇兵  

        self.m_indiana_btn = self:createAMainButton( posx, onBtnCilck, "m_button_indiana.png", 11012)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 531 ) or game_data:getDataByKey("month_foundation_status") == true then --     月初基金
        self.m_month_fund_btn = self:createAMainButton( posx, onBtnCilck, "m_button_month_found.png", 11016)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(548) then  -- 足球竞猜
        self.m_conbtn_limit_score_btn = self:createAMainButton( posx, onBtnCilck, "m_button_cheer_up.png", 13000)
        posx = posx - 40 --足球竞猜
    end 

    if game_data:isActiveOpenByID(550) then  -- 偶像英雄祭
        self.m_conbtn_limit_score_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_ouxiang.png", 13001)
        posx = posx - 40 
    end 

    if game_data:isActiveOpenByID(552) then  --宇宙神射
        self:createAMainButton( posx, onBtnCilck, "m_button_archery.png", 13003)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(555) then  --狂欢盛典
        self:createAMainButton( posx, onBtnCilck, "mbutton_carnival.png", 13005)
        posx = posx - 40
    end
    
    if game_data:isActiveOpenByID(556) then  --拼图大作战
        self:createAMainButton( posx, onBtnCilck, "mbutton_pingtu.png", 13006)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(557) then  --我是大富翁
        self:createAMainButton( posx, onBtnCilck, "mbutton_super_luck.png", 13007)  --
        posx = posx - 40
    end

    --开服活动 
    if game_data:isViewOpenByID(901) then  -- 开服 充值活动
        self.m_kaifu_chongzhi_btn = self:createAMainButton( posx, onBtnCilck, "m_button_c_chongzhihaoli.png", 10111)
        posx = posx - 40
    end
    
    if game_data:isViewOpenByID(904) then -- 开服 限时伙伴
        self.m_kaifu_limit_hero_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_xianshi.png", 10112)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(902) then  -- 开服 新服商城
        self.m_kaifu_newshop_btn = self:createAMainButton( posx, onBtnCilck, "m_button_c_newShop.png", 11111)
        posx = posx - 40
    end
    if game_data:isViewOpenByID(903) then  -- 开服 新服兑换
        self.m_kaifu_newExchange_btn = self:createAMainButton( posx, onBtnCilck, "m_button_c_newExchange.png", 11112)
        posx = posx - 40
    end
    if game_data:isViewOpenByID(906) then  -- 开服转盘活动
        self.m_server_lucky_turntable_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_lunpan.png", 10071)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(905) then  -- 满天星活动
        self.m_server_sky_star_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_maintianxing.png", 10072)
        posx = posx - 40
    end
    if game_data:isViewOpenByID(907) or game_data:getDataByKey("server_foundation_status") == true then  -- 开服福利基金
        self.m_server_fund_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_jijin.png", 10073)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(909) then  -- 开服神龙活动  
        self.m_server_dragon_ball_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_shenlong.png", 10080)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(910) then  --开服赛亚人归来  
        self.m_server_king_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_king.png", 10081)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(908) then  -- 开服中秋活动   
        self.m_server_mid_autumn_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_zhongqiu.png", 10082)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(908) then  -- 开服中秋团购活动   
        self.m_server_mid_autumn_buy_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_zhongqiutuangou.png", 10083)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(912) then  -- 开服海贼王
        self.m_server_xunbao_btn = self:createAMainButton( posx, onBtnCilck, "m_button_xunbao.png", 10084)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(911) then  -- 开服悬赏令
        self.m_server_btn_bounty = self:createAMainButton( posx, onBtnCilck, "mbutton_m_bounty.png", 10085)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID( 513 ) then -- 跨服擂台  active_inview 513
        self.m_btn_league = self:createAMainButton( posx, onBtnCilck, "mbutton_m_league.png", 11001)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 514 ) then -- 超级红包  active_inview 514
        self.m_btn_redpaper = self:createAMainButton( posx, onBtnCilck, "mbutton_m_redpaper.png", 11002)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(914) then  -- 开服火焰杯
        self.m_server_btn_firecup = self:createAMainButton( posx, onBtnCilck, "m_button_c_firecup.png", 10086)
        posx = posx - 40
    end

    if game_data:isViewOpenByID( 916 ) then -- active_inview 916     开服卡牌集换
        self.m_server_cardCollection_btn = self:createAMainButton( posx, onBtnCilck, "m_button_cardCollection.png", 12013)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 516 ) then -- active_inview 516      m_button_m_lsxx
        self.m_calsh_btn = self:createAMainButton( posx, onBtnCilck, "m_button_m_lsxx.png", 11005)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 517 ) then -- 跨服轮盘 active_inview 517
        self.m_inter_route = self:createAMainButton( posx, onBtnCilck, "m_button_m_server_turn.png", 11003)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 515 ) then -- 乱世枭雄和群雄争霸 active_inview 515   m_button_m_clash
        self.m_lsxx_btn = self:createAMainButton( posx, onBtnCilck, "m_button_m_clash.png", 11004)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 521 ) then -- active_inview 519      m_cloneLane_btn
        self.m_cloneLane_btn = self:createAMainButton( posx, onBtnCilck, "m_button_cloneLane.png", 11007)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 525 ) then --新包活动
        local get_has_version_reward = game_data:getAlertsDataByKey("has_version_reward") 
        -- cclog2(get_has_version_reward,"get_has_version_reward === ")
        if get_has_version_reward == false then 
            self.m_new_gift:setVisible(false);
        else
            self.m_new_gift:setVisible(true)
        end
    end

    local newstar = game_data:getAlertsDataByKey("newstar")
    if newstar and newstar == 1 then
        self.m_ChaoXinXing_btn = self:createAMainButton( posx, onBtnCilck, "m_button_CaoXinXing.png", 10090)
        posx = posx - 40
    end
    
    if game_data:isActiveOpenByID(565) then  -- 扭蛋机
        self.m_gashapon_btn = self:createAMainButton( posx, onBtnCilck, "m_button_gashapon.png", 10565)
        posx = posx - 40
    end
   
    if game_data:isViewOpenByID( 917 ) then -- active_inview 519      m_cloneLane_btn  开服众神殿
        self.m_server_cloneLane_btn = self:createAMainButton( posx, onBtnCilck, "m_button_cloneLane.png", 12007)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(913) then  -- 开服摩天轮
        self.m_server_ferris_sheel_btn = self:createAMainButton( posx, onBtnCilck, "m_button_motianlun.png", 10087)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(522) or game_data:getAlertsDataByKey("recall_alert") == true then  -- 开服老玩家回归
        self.m_server_btn_oldplayer = self:createAMainButton( posx, onBtnCilck, "m_button_oldplayer.png", 10088)
        posx = posx - 40
    end

    local big_holiday = game_data:getAlertsDataByKey("big_holiday")
    if big_holiday and big_holiday == 1 then  --超级返利
        self.m_bigholiday_btn = self:createAMainButton( posx, onBtnCilck, "czfl_icon.png", 6666)
        local big_holiday_red_dot = game_data:getAlertsDataByKey("big_holiday_red_dot")
        local tips_reward = CCSprite:createWithSpriteFrameName("public_new2.png");
        if tips_reward then
            local tempSize = self.m_bigholiday_btn:getContentSize();
            tips_reward:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5))
            self.m_bigholiday_btn:addChild(tips_reward,1000,1000);
        end
        tips_reward:setVisible(big_holiday_red_dot)
        posx = posx - 40
    end

    -- if game_data:isActiveOpenByID(562) then  --邀请码
    --     self:createAMainButton( posx, onBtnCilck, "mbutton_m_yqoqingma.png", 562)
    --     posx = posx - 40
    -- end

    local _btn = game_util:createCCControlButton("mbutton_m_yqoqingma.png","",onBtnCilck)
    _btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY+130);
    self.m_left_btn_node:addChild(_btn)
    _btn:setTag(562)
    _btn:setPosition(68, 75)
    if game_data:isActiveOpenByID(539) then   --问卷调查  
        self.m_survey_btn = self:createAMainButton(posx,onBtnCilck,"m_button_survey.png",955401)
        posx = posx - 40
    end
    
    if game_data:isActiveOpenByID(540) then  -- 秘境探宝 新转盘
        self.m_mysteryplace_btn = self:createAMainButton( posx, onBtnCilck, "m_button_mijingtanbao.png", 12011)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(542) then  -- 培养赛
        self.m_trainning_btn = self:createAMainButton( posx, onBtnCilck, "m_button_longhubang.png", 12012)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(543) then
        self.m_lottery_btn = self:createAMainButton(posx,onBtnCilck,"m_button_lottery.png",955402)
        posx = posx - 40
    end
    
    if game_data:isActiveOpenByID(601) then
        self.m_lottery_btn = self:createAMainButton(posx,onBtnCilck,"m_button_leichong.png",767)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID(563) then -- 一元夺宝
        self.m_oneYuanRaffle_btn = self:createAMainButton(posx,onBtnCilck,"m_button_oneYuanRaffle.png",563)
        posx = posx - 40
    end

    if game_data:isActiveOpenByID( 523 ) then -- active_inview 519      红包齐分享
        self.m_redEnvelope_btn = self:createAMainButton( posx, onBtnCilck, "m_button_redEnvelope.png", 11008)--红包活动按钮
        posx = posx - 40
        local red_bag_status = game_data:getAlertsDataByKey("red_bag_status") or false   --设置左侧抢红包按钮
        if red_bag_status == true then
            self.m_red_envelope_btn:setVisible(true)
            self.m_red_envelope_btn:setScale(0.8)
            local m_bg_sprite = self.m_ccbNode:spriteForName("m_bg_sprite")
            local tempSize = m_bg_sprite:getContentSize();
            local animArr = CCArray:create();
            local moveTo1 = CCMoveTo:create(0.3,ccp(tempSize.width*0.04,tempSize.height*0.52))
            local moveTo2 = CCMoveTo:create(0.3,ccp(tempSize.width*0.035,tempSize.height*0.52))
            animArr:addObject(moveTo1)
            animArr:addObject(moveTo2)
            self.m_red_envelope_btn:runAction(CCRepeatForever:create(CCSequence:create(animArr)));
            local anim = game_util:createEffectAnim("anim_ui_hongbao",1,true)
            anim:setAnchorPoint(ccp(0,0));
            self.m_red_envelope_btn:addChild(anim,-1,-1)
        else
            self.m_red_envelope_btn:setVisible(true)
            self.m_red_envelope_btn:setScale(0.8)
        end
        local sys_red_bag_status = game_data:getAlertsDataByKey("sys_red_bag_status") or nil   --设置系统红包按钮

        if sys_red_bag_status[1] ~= nil  then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/red_envelope.plist")
            local m_bg_sprite = self.m_ccbNode:spriteForName("m_bg_sprite")
            local spriteFrame =CCSprite:createWithSpriteFrameName("redEnvelope_mainDi.png")
            local btnImg = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("red_envelope_Qiang.png")
            if spriteFrame and m_bg_sprite then
                local function onBtnCilck( target,event )
                    local function responseMethod( tag,gameData )
                            local data = gameData:getNodeWithKey("data")
                            data = json.decode(data:getFormatBuffer())
                            local is_successful = false
                            if data.err_code == 1 then
                                game_scene:addPop("game_redEnvelope_alreadyGet_pop",{gameData = gameData,is_successful = false,openType = true})

                            else

                                game_scene:addPop("game_redEnvelope_alreadyGet_pop",{gameData = gameData,is_successful = true,openType = true})
                            end
                    end
                    local params = {}
                    params.key = sys_red_bag_status[1]
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("red_bag_open_red_bag"), http_request_method.GET, params,"red_bag_open_red_bag")
                end
                local tempSize =self.m_SysRed_node:getContentSize();
                local btn = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg));
                btn:setPreferredSize(btnImg:getRect().size);
                btn:addHandleOfControlEvent(onBtnCilck,CCControlEventTouchUpInside);
                btn:setPosition(ccp(tempSize.width*0.7,tempSize.height*0.6));
                spriteFrame:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.6));
                btn:setTouchPriority(2);

                --屏幕红包框体后的按钮事件，将框体创建为按钮 ,start
                local function onBtnCilck2( target,event )
                         local function responseMethod( tag,gameData )
                            local data = gameData:getNodeWithKey("data")
                            data = json.decode(data:getFormatBuffer())
                            local is_successful = false
                            if data.err_code == 1 then
                                
                                game_scene:addPop("game_redEnvelope_alreadyGet_pop",{gameData = gameData,is_successful = false,openType = true})

                            else

                                game_scene:addPop("game_redEnvelope_alreadyGet_pop",{gameData = gameData,is_successful = true,openType = true})
                            end
                    end
                    local params = {}
                    params.key = sys_red_bag_status[1]
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("red_bag_open_red_bag"), http_request_method.GET, params,"red_bag_open_red_bag")
                end
                local btnImg2 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("redEnvelope_mainDi.png")
                local btn2 = CCControlButton:create(CCLabelTTF:create("",TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg2));
                btn2:setPreferredSize(btnImg2:getRect().size);
                btn2:addHandleOfControlEvent(onBtnCilck2,CCControlEventTouchUpInside);
                btn2:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.6));

                btn2:setTouchPriority(2);

                --屏幕红包框体后的按钮事件，将框体创建为按钮 over

                local red_bag_version = game_data:getAlertsDataByKey("red_bag_version") or nil 
                local m_config = getConfig(game_config_field.system_red_bag)
                m_config = json.decode(m_config:getFormatBuffer())
                m_config = m_config[tostring(red_bag_version)]
                if m_config.des4 then 
                    local des4 = m_config.des4
                    local lab = CCLabelTTF:create(des4,TYPE_FACE_TABLE.Arial_BoldMT,12);
                    local tempsize = btn2:getContentSize()
                    lab:setPosition(ccp(tempsize.width*0.5,tempsize.height*0.5))
                    btn2:addChild(lab)
                end


               
                self.m_SysRed_node:addChild(btn2)
                self.m_SysRed_node:addChild(btn)
                
            end
        else

        end
    end
    if game_data:isViewOpenByID(144) then
        if   game_data:getIsdoubleValue()  then 
            self.m_conbtn_vipshow_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_shuangbei.png", 502)
            posx = posx - 40
            -- cclog("123123123123")
            -- cclog2(game_data:getIsdoubleValue(),"game_data:getIsdoubleValue-=---------")
        end
    else
        -- cclog("123456789/45454645646465464646466431436")
    --     self.m_conbtn_vipshow_btn:setVisible(false)
    end
    
    if game_data:isActiveOpenByID(545) then  -- 抓娃娃
        self.m_toys_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_zhuawawa.png", 12015)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(546) then  -- 玲珑宝塔
        self.m_toys_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_pagoda.png", 12016)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(547) then  -- 世界杯收集国旗
        self.m_toys_btn = self:createAMainButton( posx, onBtnCilck, "mbutton_m_huanqingshijiebei.png", 12017)
        posx = posx - 40
    end
    if game_data:isActiveOpenByID(561) then  --限时远征
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/new_main_add_res.plist")
        self:createAMainButton( posx, onBtnCilck, "mbutton_limit_war.png", 13010)
        posx = posx - 40
    end


    -- 赋能大赛
    if game_data:isActiveOpenByID(562) then
        self.empowerContest = self:createAMainButton( posx, onBtnCilck, "fnds_ui_20.png", 13011)
        local funeng_red_dot = game_data:getAlertsDataByKey("funeng_red_dot") or {}
        local canShow = false
        local tips_reward = CCSprite:createWithSpriteFrameName("public_new2.png");
        if tips_reward then
            local tempSize = self.empowerContest:getContentSize();
            tips_reward:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5))
            self.empowerContest:addChild(tips_reward,1000,1000);
        end
        for k, v in pairs(funeng_red_dot) do
            if v == true then
                canShow = true
                break
            end
        end
        tips_reward:setVisible(canShow)
        posx = posx - 40
    end

    if game_data:isViewOpenByID(921) then  --新服红包
        self.m_btn_redpaper = self:createAMainButton( posx, onBtnCilck, "mbutton_m_redpaper.png", 13012)
        posx = posx - 40
    end

end

function game_main_scene.setButtonState( self, button, buttonID )
    if not button then return end
    if game_data:isViewOpenByID(buttonID) then    
        -- button:setVisible(true)
    else
        button:setVisible(false)
    end
end


function game_main_scene.showAnnouncement(self)
    if self.m_firstFlag == true then--第一次進入
        local id2 = game_guide_controller:getIdByTeam("1");
        if id2 > 1 then
            local popEndCallFunc = function( )
                if not self:guideHelper() then
                    local wormfirst = game_data:getUserStatusDataByKey("wormholes_first")
                    local wormopen = game_data:getUserStatusDataByKey("wormholes_version") or 0
                    if wormfirst and game_data:isViewShowByID( 216 ) == true  and wormopen ~= 0 then
                        self:gameGuide("show","100", 10001,{tempNode = self.m_worm_btn})
                    end
                    self:refreshDoSomethingBtn();           -- 刷新消息提示按钮的状态
                end
            end
            -- game_scene:addPop("game_announcement_pop",{typeName = "announcement"});
            if (game_data:isViewOpenByID(11) ) then
                game_scene:addPop("annoucement_pop", {endCallFunc = popEndCallFunc});
            end

        end
    else 
        local id2 = game_guide_controller:getIdByTeam("1");

        if self.m_fristOpenPop == "game_monopoly_pop" then
            local function responseMethod(tag,gameData)
                game_scene:addPop("game_monopoly_pop",{gameData = gameData});
                self.m_fristOpenPop = nil
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("super_tycoon_active_index"), http_request_method.GET, nil,"super_tycoon_active_index")
        elseif self.m_fristOpenPop == "game_monopoly_server_pop" then
            local function responseMethod(tag,gameData)
                game_scene:addPop("game_monopoly_server_pop",{gameData = gameData});
                self.m_fristOpenPop = nil
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("server_super_tycoon_active_index"), http_request_method.GET, nil,"server_super_tycoon_active_index")
        elseif self.m_fristOpenPop == "game_month_fund_pop" then
            local function responseMethod(tag,gameData)
                if gameData then
                    self.m_fristOpenPop = nil
                    local data = gameData:getNodeWithKey("data")
                    local mail_mark = data:getNodeWithKey("mail_mark"):toBool();
                    if mail_mark == true then
                        game_util:addMoveTips({text = "剩余奖励已通过邮件发送，请查收！"})
                    else
                        game_scene:addPop("game_month_fund_pop",{gameData=gameData}); 
                    end
                end
               
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("month_foundation_index"), http_request_method.GET, nil,"month_foundation_index")
        elseif id2 > 1 then
            if self.m_fristOpenPop == "game_activity_new_pop" then
                --先联网再进入
                local function responseMethod(tag,gameData)
                    -- game_scene:enterGameUi("game_activity",{gameData = gameData})
                    game_scene:addPop("game_activity_new_pop",{gameData = gameData})
                    self.m_fristOpenPop = nil
                    -- self:destroy()
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_index"), http_request_method.GET, nil,"active_index")
            else
                if not self:guideHelper() then
                    local wormfirst = game_data:getUserStatusDataByKey("wormholes_first")
                    local wormopen = game_data:getUserStatusDataByKey("wormholes_version") or 0
                    if wormfirst and game_data:isViewShowByID( 216 ) == true  and wormopen ~= 0 then
                        self:gameGuide("show","100", 10001,{tempNode = self.m_worm_btn})
                    end
                    self:refreshDoSomethingBtn();           -- 刷新消息提示按钮的状态
                end
            end
        end
        
    end
end

--[[--
    刷新
]]
function game_main_scene.refreshTeamLayer(self)
    local tempNode;
    for i=1,5 do
        local animNode = self:createCardAnimByPosIndex(i);
        tempNode = self.m_teamNodeTab[i]
        if animNode and tempNode then
            tempNode:removeAllChildrenWithCleanup(true);
            local tempSize = self.m_teamNodeTab[i]:getContentSize();
            animNode:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.13));
            tempNode:addChild(animNode,1,1);
        end
    end
end

--[[--
    刷新ui
]]
function game_main_scene.refreshUi(self)
    local get_has_version_reward = game_data:getAlertsDataByKey("has_version_reward") 
    -- cclog2(get_has_version_reward,"get_has_version_reward === ")
    if get_has_version_reward == false then 
        self.m_new_gift:setVisible(false);
    end
    self:refreshBtnStatus();
    self:refreshDoSomethingBtn();           -- 刷新消息提示按鈕的狀態
    self:refreshLevelGiftBtn();
    local user_status = game_data:getUserStatusData();
    local action_point_rate = user_status.action_point_rate;
    local action_point_update_left = user_status.action_point_update_left;
    self:refreshTeamLayer();
    local combatValue = game_util:getCombatValue()
    -- self.m_combat_label:setString(tostring(combatValue));
    local tempCombatValue = game_data:getTempCombatValue();
    local combatValue,tempCombatValue = game_data:getChangedCombat()
    if combatValue ~= 0 or tempCombatValue == 0 then
        self.m_combatNumberChangeNode:setString(combatValue)
        -- self.m_combatNumberChangeNode:setCurValue(combatValue,false);
    else
        self.m_combatNumberChangeNode:setString(tempCombatValue)
        -- self.m_combatNumberChangeNode:setCurValue(tempCombatValue,false);
    end
    if tempCombatValue ~= 0 and combatValue ~= tempCombatValue and self.m_firstFlag == false then
        -- self.m_combat_label:setVisible(false);
        -- local function callBackFunc()
        --     self.m_combat_label:setVisible(true);
        -- end
        -- local anim_zhandouli = game_util:createEffectAnimCallBack("anim_zhandouli",1.0,false,callBackFunc);
        -- local pX,pY = self.m_combat_label:getPosition();
        -- anim_zhandouli:setPosition(ccp(pX + self.m_combat_label:getContentSize().width*0.5,pY))
        -- self.m_combat_label:getParent():addChild(anim_zhandouli);
        local changeValue = combatValue - tempCombatValue
        game_util:combatChangedValueAnim({combatNode = self.m_combatNumberChangeNode:getParent(),currentValue = combatValue,changeValue = changeValue});
    end
    game_data:setTempCombatValue(combatValue);
end

--[[--
    初始化
]]
function game_main_scene.init(self,t_params)
    -- print_lua_table(t_params, 5)
    if luaCCBNode.addPublicResource then
        luaCCBNode:addPublicResource("ccbResources/public_res_add.plist");
    end
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/other_public_res.plist");
    t_params = t_params or {};
    -- game_sound:playMusic("background_home",true);
    self.m_resourcesAnimTable = {};
    self.m_btnShowFlag = self.m_btnShowFlag or true;
    self.m_teamNodeTab = {};
    self.m_firstFlag = t_params.firstFlag ~= nil and  t_params.firstFlag or false;
    self.m_tipsAnimTab = {};
    if self.m_firstFlag == true then
        public_config.action_rythm = 0.5
    end
    self.m_fristOpenPop = t_params.openPop
    self.is_double =t_params.is_double
    -- cclog2(self.is_double,"self.is_double-=-------")
end


--[[--
    外部調用的創建ui方法
]]
function game_main_scene.create(self,t_params)
    -- body
    self:init(t_params);
    local scene = CCScene:create();
    local tempNode = self:createUi()
    if display.ipx_fit then
        local layer = CCLayerColor:create(ccc4(0,0,0,0))
        layer:setContentSize(display.size_design)
        layer:ignoreAnchorPointForPosition(false)
        local winSize = CCDirector:sharedDirector():getWinSize()
        layer:setPosition(ccp(winSize.width*0.5,winSize.height*0.5))
        layer:addChild(tempNode)
        scene:addChild(layer);
    else
        scene:addChild(tempNode);
    end
    self:refreshUi();
    local id = game_guide_controller:getCurrentId();
    cclog("id ====================================" .. id)
    if id == 12 then
        self:gameGuide("drama","1",13);
    elseif id == 15 or id == 16 or id == 17 then
        self:gameGuide("drama","1",18);
    elseif id == 22 then
        self:gameGuide("drama","1",23);
    elseif id == 29 then--第二大步開始
        if game_data:getEquipGuideFlag() then
            self:gameGuide("drama","2",29);
        else
            self:gameGuide("drama","2",35);
        end
    elseif id == 33 or id == 34 then
        self:gameGuide("drama","2",35);
    -- elseif id == 50 then
    --     self:gameGuide("drama","3",51);
    elseif id == 39 then
        -- self:gameGuide("show","2",39,{tempNode = self.m_battle_btn})
        game_guide_controller:gameGuide("send","2",39);
    else
        local id = game_guide_controller:getIdByTeam("3");
        if id == 302 then -- 技能升級
            self:gameGuide("show","3",302,{tempNode = self.m_partner_btn})
        else
            local id2 = game_guide_controller:getIdByTeam("5");
            if id2 == 502 then -- 碎片兌換
                self:gameGuide("show","5",502,{tempNode = self.m_partner_btn})
            elseif id2 == 505 then -- 夥伴進階
                if game_data:getMaxLvCardFlag() == true then
                    game_guide_controller:gameGuide("send","5",505);
                    self:gameGuide("show","5",505,{tempNode = self.m_partner_btn})
                else
                    self:gameGuide("send","5",511);
                    self:showAnnouncement();
                end
            else
                local id = game_guide_controller:getIdByTeam("65");     -- 助威
                -- id = 6501
                if id == 6501 then
                    self:gameGuide("show","65", 6501,{tempNode = self.m_formation_btn})  
                else
                    local id = game_guide_controller:getIdByTeam("7");     -- 融合
                    -- id = 6501
                    -- if not adfadfas then
                    --     id = 700
                    -- else
                    --     id =
                    -- end
                    print("game_guide_controller:getIdByTeam(7)", id)
                    if (id ==701 or id ==705 ) and not game_data:isViewOpenByID(133) then
                        -- cclog2(id, "id == is not open ==========")
                        game_guide_controller:sendGuideData("7", 711)
                    elseif id == 701 then
                        -- adfadfas = true
                        self:gameGuide("drama","7", 701)  
                    elseif id == 705 then
                        self:gameGuide("drama","7", 705)  
                    else
                        self:showAnnouncement();  
                    end
                end
            end
        end
    end
    -- game_scene:addPop("game_error_pop",{errorStatus = "error_9"});
    self:chatTips()
    game_data:setMapType()   -- 重置地圖類型
    -- if device.platform == "ios" and (getPlatForm() == "appstore" or getPlatForm() == "cmgeapp") and game_data:isViewOpenByID( 42 ) then
    cclog("getPlatFormExt() ==== "  .. getPlatFormExt())
    if device.platform == "ios" and (getPlatFormExt() == "platform_haiwai") and game_data:isViewOpenByID( 42 ) then   
        local luaoc = require("luaoc")
        luaoc.callStaticMethod("AppController", "addADDiAD", {})
    end
    if device.platform == "ios" and (getPlatFormExt() == "PLATFORM_yuenan") and game_data:isViewOpenByID( 42 ) then   
        local luaoc = require("luaoc")
        luaoc.callStaticMethod("AppController", "addADDiAD", {})
    end
    return scene;
end

--[[--
    引導方法
]]
function game_main_scene.chatTips(self)
    -- 為聊天添加一個紅點
    function addPointForChatBtn()
        if self.m_chat_btn:getChildByTag(888) == nil then
            local ani = game_util:addTipsAnimByType(self.m_chat_btn,9);
            ani:setTag(888)
        end
    end
    local delay = CCDelayTime:create(300)
    local callfunc = CCCallFunc:create(addPointForChatBtn)
    local sequence = CCSequence:createWithTwoActions(delay, callfunc)
    local action = CCRepeatForever:create(sequence)
    self.m_chat_btn:runAction(action)
end

function game_main_scene.forceGuideFun( self, forceInfo )
    if not forceInfo then return end
    local t_params = {}
    local finishOneStep = nil
    cclog2(forceInfo, "forceInfo === forceInfo")
    if forceInfo.game_main_scene.step then
        for i=1, forceInfo.game_main_scene.step do
            local thisStep = forceInfo.game_main_scene["step" .. tostring(i)] or {}
            if thisStep.state == false then
                t_params.tempNode = self[ thisStep.btn ]
                finishOneStep = function ( step )
                    thisStep.state = true
                    cclog2(forceInfo, "forceInfo === finishOneStep")
                end
                break
            end
        end
    else
        t_params.tempNode = self[ forceInfo.game_main_scene[1] ]
    end
    if not t_params.tempNode then return end
    t_params.clickCallFunc = function (  )
        -- cclog2("click")
        if type(finishOneStep) == "function" then finishOneStep() end
        game_scene:removeGuidePop()
    end
    t_params.skipFunc = function (  )
        if type(forceInfo.guideEndfun) == "function" then
            forceInfo.guideEndfun( forceInfo.guide_team )
        end
        -- game_data:setForceGuideInfo( nil )
    end
    game_scene:addGuidePop( t_params )
    game_data:setForceGuideInfo( forceInfo )

end

--[[
    檢查時候需要新手引導
]]
function game_main_scene.guideHelper( self )
    local force_guide = game_data:getForceGuideInfo()
    if type(force_guide) == "table" and force_guide.game_main_scene then
        self:forceGuideFun( force_guide )
        return true
    else
        local  guidfun = function (  forceInfo )
            self:forceGuideFun( forceInfo )
        end
        return game_guide_controller:guideHelper( guidfun , "game_main_scene")
    end
    return false
end

--[[--
    引導方法
]]
function game_main_scene.gameGuide(self,guideType,guide_team,guide_id,t_params)
    if not game_guide_controller:getGuideCompareFlag(guide_team,guide_id) then return end
    local id = game_guide_controller:getId(guide_team,guide_id);
    t_params = t_params or {};
    if guideType == "show" then
        game_guide_controller:showGuide(guide_team,guide_id,t_params);
    elseif guideType == "send" then
        game_guide_controller:sendGuideData(guide_team,guide_id)
    elseif guideType == "drama" then
        if guide_team == "1" and id == 13 then
            local function endCallFunc()
                self:gameGuide("send","1",13);
                self.m_bottom_btn_node:setPositionY(0);
                self.m_gacha_btn:setVisible(true);
                self:setBottomBtnSort();
                self:gameGuide("show","1",14,{tempNode = self.m_gacha_btn})
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        elseif guide_team == "1" and id == 18 then
            local function endCallFunc()
                self:gameGuide("send","1",18);
                self.m_bottom_btn_node:setPositionY(0);
                self.m_formation_btn:setVisible(true);
                self:setBottomBtnSort();
                self:gameGuide("show","1",19,{tempNode = self.m_formation_btn})
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        elseif guide_team == "1" and id == 23 then
            local function endCallFunc()
                self:gameGuide("send","1",23);
                self:gameGuide("show","1",24,{tempNode = self.m_battle_btn})
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        elseif guide_team == "2" and id == 28 or id == 29 then
            local function endCallFunc()
                -- self:gameGuide("send","2",29);
                self.m_bottom_btn_node:setPositionY(0);
                self.m_formation_btn:setVisible(true);
                self:setBottomBtnSort();
                self:gameGuide("show","2",30,{tempNode = self.m_formation_btn})
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        elseif guide_team == "2" and id == 35 then
            local function endCallFunc()
                self:gameGuide("send","2",35);
                self:gameGuide("show","2",36,{tempNode = self.m_backpack_btn})
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        elseif guide_team == "3" and id == 51 then
            local function endCallFunc()
                self:gameGuide("send","3",51);
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        elseif guide_team == "7" and id == 701 then
            local function endCallFunc()
                -- assert(false)
                self:gameGuide("show","7",702,{tempNode = self.m_conbtn_fuli})
                game_guide_controller:setGuideData("7",703);
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        elseif guide_team == "7" and id == 705 then
            local function endCallFunc()
                self:gameGuide("show", "7",705,{tempNode = self.m_shop_btn});
                game_guide_controller:setGuideData("7",706);
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        end
    end
end

--[[--
    消息提示
]]
function game_main_scene.refreshDoSomethingBtn(self)
    self.m_tshowDoSthParams = nil
    self.m_tshowDoSthParams = {}
    -- print("---------- all alert data is -----------")
    -- print_lua_table(game_data:getAllAlertsData())
    -- print("new guanqia ---- :", game_data:getNewOpenCityId())


    local level = game_data:getUserStatusDataByKey("level")

    local total_silver = game_data:getUserStatusDataByKey("silver") or 0;

    local server_time = game_data:getUserStatusDataByKey("server_time")
    local curdate = os.date("*t", server_time)
    local hour = curdate.hour
    function isZhenXing(  )
        local flag, data = game_data:getOpenFormationAlertFlag() 
        return self:isAlreadyShowDataTips("zhenxing", data) 
    end
    if self:getIsNewOpenButton() and self:isAlreadyShowDataTips("gongneng", self:getIsNewOpenButton()) then            --  新功能解鎖   
        self.m_tshowDoSthParams.showType = "gongneng"
        self.m_tshowDoSthParams.data = self:getIsNewOpenButton()
        game_data.m_talreadyTips["gongneng"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    elseif game_data:isViewOpenByID(12) and total_silver >= 300 and self:isAlreadyShowDataTips("gold_gacha", total_silver) then  -- 金幣招募
        self.m_tshowDoSthParams.showType = "gold_gacha"
        self.m_tshowDoSthParams.data = total_silver
        game_data.m_talreadyTips["gold_gacha"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    -- elseif game_data:getNewOpenCityId() and self:isAlreadyShowDataTips("guanqia", game_data:getNewOpenCityId()) then    ---   新關卡解鎖   
        -- self.m_tshowDoSthParams.showType = "guanqia"
        -- self.m_tshowDoSthParams.data = game_data:getNewOpenCityId()
     --    game_data.m_talreadyTips["guanqia"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    elseif game_data:getOpenFormationAlertFlag() and isZhenXing() then    -- 新陣型解鎖    
        self.m_tshowDoSthParams.showType = "zhenxing"
        _, self.m_tshowDoSthParams.data = game_data:getOpenFormationAlertFlag()
        game_data.m_talreadyTips["zhenxing"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    elseif game_data:getAlertsDataByKey("exchange_card") ~= "" and self:isAlreadyShowDataTips("exchange_card", game_data:getAlertsDataByKey("exchange_card")) and game_data.m_texchangedCardEquip[tostring(game_data:getAlertsDataByKey("exchange_card"))] == nil then    -- 夥伴兌換   
        self.m_tshowDoSthParams.showType = "exchange_card"
        self.m_tshowDoSthParams.data = game_data:getAlertsDataByKey("exchange_card")
        game_data.m_talreadyTips["exchange_card"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    elseif game_data:getAlertsDataByKey("exchange_equip") ~= "" and self:isAlreadyShowDataTips("exchange_equip", game_data:getAlertsDataByKey("exchange_equip")) and game_data.m_texchangedCardEquip[tostring(game_data:getAlertsDataByKey("exchange_equip"))] == nil then    -- 裝備兌換   
        self.m_tshowDoSthParams.showType = "exchange_equip"
        self.m_tshowDoSthParams.data = game_data:getAlertsDataByKey("exchange_equip")
        game_data.m_talreadyTips["exchange_equip"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    elseif game_data:getAlertsDataByKey("") then      --  懸賞任務完成   
        self.m_tshowDoSthParams.showType = "task"
        self.m_tshowDoSthParams.data = game_data:getAlertsDataByKey("")
        game_data.m_talreadyTips["task"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    elseif game_data:getAlertsDataByKey("train") ~= "" and self:isAlreadyShowDataTips("trainfinish", game_data:getAlertsDataByKey("train"))  and game_data.m_ttrainfinishCard[tostring(game_data:getAlertsDataByKey("train"))] == nil then    ---   夥伴訓練完成   
        self.m_tshowDoSthParams.showType = "trainfinish"
        self.m_tshowDoSthParams.data = game_data:getAlertsDataByKey("train")
        game_data.m_talreadyTips["trainfinish"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    elseif game_data:getAlertsDataByKey("rank_down") > 0 and self:isAlreadyShowDataTips("jjc_down", game_data:getAlertsDataByKey("rank_down")) then    ---   競技場排名下降   
        self.m_tshowDoSthParams.showType = "jjc_down"
        self.m_tshowDoSthParams.data = game_data:getAlertsDataByKey("rank_down")
        game_data.m_talreadyTips["jjc_down"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    elseif level >= 20 and (((hour > 9 and hour < 21) and not self:isShowLiveActiveTips("shencundakaoyan", 9)) or  (hour >= 21 and not self:isShowLiveActiveTips("shencundakaoyan", 21))) then
        self.m_tshowDoSthParams.showType = "shencundakaoyan"
        if hour > 9 and hour < 21 then
            self.m_tshowDoSthParams.data = 9
        elseif hour >= 21 then
            self.m_tshowDoSthParams.data = 21
        end
        game_data.m_talreadyTips["shencundakaoyan"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    elseif game_data:isViewOpenByID(105) and level >= 8 and  self:isVipGiftUseful() and self:isAlreadyShowDataTips("vip_gift", self:isVipGiftUseful()) then    ---   有vip禮包可以購買   
        self.m_tshowDoSthParams.showType = "vip_gift"
        self.m_tshowDoSthParams.data = self:isVipGiftUseful()
        game_data.m_talreadyTips["vip_gift"] = {isShow = false, data = self.m_tshowDoSthParams.data}
    end

    self.m_tshowDoSthParams.callFun = function (  )
        self:destroy();
    end

    self.m_do_something_btn:setPosition(-100, 125)  -- 將按鈕移出屏幕
    self.m_do_something_btn:setVisible(false);   -- 提示按鈕的隱藏
    if self.m_tshowDoSthParams.showType then
        self.m_do_something_btn:stopAllActions()
        self.m_do_something_btn:setVisible(true);   -- 提示按钮的显示
        self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_do_something_btn, 14);
        self.m_do_something_btn:setPositionX(-20)
        local moveBy = CCMoveBy:create(0.5, ccp(40, 0))
        self.m_do_something_btn:runAction(CCEaseBackIn:create(moveBy))
    else
        self.m_tshowDoSthParams = nil
    end
end

function game_main_scene.isShowLiveActiveTips(self, key, data )
    -- do
    --     return false
    -- end
    if not key then assert(0) end
    local server_time = game_data:getUserStatusDataByKey("server_time")
    local curdate = os.date("*t", server_time)
    local hour = curdate.hour

    local savedata = game_data:updateLocalData(key)
    -- print("shencundakaoyan  -- save data is ", savedata, tostring(savedata))
    if not savedata then return false end
    local save = json.decode(savedata)
    if not save then return false end
    if save.date ~= tostring( "" .. curdate.year .. curdate.month .. curdate.day  ) then return end
    for i,v in ipairs(save.data) do
        if v == data then 
            return true
        end
    end
    return true
end

function game_main_scene.showLiveActiveTips(self, key, data )
    if not key then assert(0) end
    local server_time = game_data:getUserStatusDataByKey("server_time")
    local curdate = os.date("*t", server_time)
    local hour = curdate.hour
    local save = nil
    local savedata = game_data:updateLocalData(key)
    if not savedata then save = {} end
    if savedata then 
        save = json.decode(savedata) or {}
    end
    local today = "" .. curdate.year .. curdate.month .. curdate.day
    if save.date ~= today then save = {date = today, data = {}} end
    save.data[#save.data + 1] = today 
    print("shencundakaoyan  -- will save data is ", save, tostring(save), json.encode(save))
    game_data:updateLocalData(key, json.encode(save), true)
end




function game_main_scene.isAlreadyShowDataTips( key, oneDay, value)
    
    local server_time = game_data:getUserStatusDataByKey("server_time")
    local curdate = os.date("*t", server_time)
    local hour = curdate.hour
end

function game_main_scene.refreshLevelGiftBtn(self)
    -- do 
    --     return 
    -- end
    self.m_conbtn_levelgift:setPosition(-100, self.m_do_something_btn:getPositionY() + 50)  -- 將按鈕移出屏幕
    self.m_conbtn_levelgift:setVisible(false);   -- 提示按鈕的隱藏

    if game_data:getAlertsDataByKey("level_gift") == nil or game_data:getAlertsDataByKey("level_gift") == false then        -- 條件達到 自動跳出限時購買選項
        return;
    end
    self.m_conbtn_levelgift:setVisible(true);   -- 提示按鈕的顯示
    self.m_tipsAnimTab[#self.m_tipsAnimTab+1] = game_util:addTipsAnimByType(self.m_conbtn_levelgift, 15);
    self.m_conbtn_levelgift:setPositionX(-20)
    local moveBy = CCMoveBy:create(0.5, ccp(40, 0))
    self.m_conbtn_levelgift:runAction(CCEaseBackIn:create(moveBy))

    local params = game_data:getAlertsDataByKey("level_gift")
    local time = nil
    if params and type(params) == "table" then 
        local minLevel = 9999
        for i,v in pairs(params) do
            if minLevel > tonumber(i) then
                minLevel = tonumber(i)
            end
        end
        time = params[tostring(minLevel)] or 1
    end
      -- 倒計時
    local function timeOverCallFun(label,type)
        local moveBy = CCMoveBy:create(0.5, ccp(-40, 0))
        self.m_conbtn_levelgift:runAction(CCEaseBackIn:create(moveBy))
        self.m_conbtn_levelgift:setVisible(false)
    end
    local offset = {{-0.5,0.5},{-0.5,-0.5},{0.5,-0.5},{0.5,0.5},{0,0},};
    local color = {ccc3(0,255,0),ccc3(0,0,0),ccc3(0,0,0),ccc3(0,0,0),ccc3(0,255,0),}
    local timeLabel = game_util:createCountdownLabel(tonumber(time) ,timeOverCallFun,8, 2)
    -- timeLabel:setFontSize(12.00)
    local size = self.m_conbtn_levelgift:getContentSize()
    timeLabel:setAnchorPoint(ccp( 0.5, 0.5 ))
    timeLabel:setPosition(size.width * 0.5, size.height * 0.5)
    self.m_conbtn_levelgift:addChild(timeLabel, 10000)
    timeLabel:setScale(14/12.0)
    timeLabel:setColor(ccc3(255, 255, 0))
end

function game_main_scene.isAlreadyShowDataTips(self, tipName, data )
    if game_data.m_talreadyTips[tipName] and game_data.m_talreadyTips[tipName].isShow == true then
        -- print("train data is --- ",game_data.m_talreadyTips[tipName].data, data)
        return game_data.m_talreadyTips[tipName].data ~= data
    end
    return true
end

function game_main_scene.isVipGiftUseful(self)
    local shopData = game_data:getShopData()
    local bought = shopData["vip_bought"]
    local vipLevel = game_data:getUserStatusDataByKey("vip") or 0
    for i=1,vipLevel + 1 do
        if bought[tostring(i)] ~= 1 then
            return true
        end
    end
    return false
end

function game_main_scene.getIsNewOpenButton(self)
    -- do
    --     return 108
    -- end
     -- 檢查現在開啟的功能 現在開啟功能列表
    local curOpen = game_button_open:getOpenButtonIdList()
    local perOpen = game_data:getOpenButtonList()
    -- print("  per open is")
    -- print_lua_table(perOpen, 5)
    for i,v in pairs(curOpen) do
        -- print("open button is ",i, perOpen[i] ," == ", v)
        if v == true and perOpen[i] ~= true then
            -- print("-----------------------  find new gongneng ----------------------  gongneng id is ", i)
            return i
        end  
    end
    return nil
end
-- --[[--
--     创建一个button
-- ]]
-- function game_main_scene.createAMainButton( self, brotherNode, onBtnCilck, spriteName, tag )
--     local button = game_util:createCCControlButton(spriteName,"",onBtnCilck)
--     button:setAnchorPoint(ccp(0.5,0.5))
--     button:setPositionY(brotherNode:getPositionY())
--     brotherNode:getParent():addChild(button)
--     button:setTag(tag)
--     button:setVisible(false)
--     button:setTouchPriority(GLOBAL_TOUCH_PRIORITY);
--     return button
-- end

return game_main_scene;
   m� 