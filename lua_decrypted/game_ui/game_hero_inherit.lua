---  夥伴傳承
local game_hero_inherit = {
    m_add_now_label = nil,
    m_add_next_label = nil,
    m_added_now_label = nil,
    m_added_next_label = nil,

    m_table_view_node = nil,--table view

    m_btn_add = nil,
    m_btn_added = nil,
    m_btn_trans= nil,

    m_card_add_node = nil,
    m_carded_add_node_2 = nil,

    m_select_id_table = nil,--記錄選擇的

    m_can_select = nil,--是否能夠選擇
    m_alpha_layer = nil,--是否能選擇的蒙版
    m_select_index = nil,--是選擇的添加還是被添加的
    m_have_selected = nil,--是否有英雄被選擇
    m_add_hero_id = nil,
    m_added_hero_id = nil,

    m_add_lv_sprite = nil,
    m_added_lv_sprite = nil,
    m_btn_table = nil,--切換排序

    light_add = nil,
    light_added = nil,

    m_selHeroDataBackup = nil,
    back_add_id = nil,
    back_added_id = nil,

    m_aniName = nil, -- 動畫 vip文字 動畫名字
    ball_node = nil,
    m_chest_anim = nil,
    m_combat_label = nil,
    anim_section = nil,
    ball_flag = nil,
    ball_exp = nil,
    m_newCardsTab = nil,
};
--[[--
    銷毀ui
]]
function game_hero_inherit.destroy(self)
    -- body
    cclog("-----------------game_hero_inherit destroy-----------------");
    self.m_added_now_label = nil;
    self.m_add_now_label = nil;
    self.m_added_next_label = nil;
    self.m_add_next_label = nil;
    self.m_table_view_node = nil;
    self.m_btn_trans = nil;
    self.m_btn_added = nil;
    self.m_btn_add = nil;
    self.m_card_add_node = nil;
    self.m_carded_add_node_2 = nil;
    self.m_select_id_table = nil;
    self.m_can_select = nil;
    self.m_alpha_layer = nil;
    self.m_select_index = nil;
    self.m_have_selected = nil;
    self.m_add_hero_id = nil;
    self.m_added_hero_id = nil;
    self.m_add_lv_sprite = nil;
    self.m_added_lv_sprite = nil;
    self.m_btn_table = nil;
    self.light_add = nil;
    self.light_added = nil;
    self.m_selHeroDataBackup = nil;

    self.back_add_id = nil;
    self.back_added_id = nil;
    self.ball_node = nil;
    self.m_chest_anim = nil;
    self.m_combat_label = nil;
    self.anim_section = nil;
    self.ball_flag = nil;
    self.ball_exp = nil;
    self.m_newCardsTab = nil;
end
--[[--
    返回
]]
function game_hero_inherit.back(self,backType)
    game_scene:enterGameUi("game_main_scene",{gameData = nil});
    self:destroy();
end
--[[--
    讀取ccbi創建ui
]]
function game_hero_inherit.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 101 then--傳承
            local function trans_exp(hero_id1,hero_id2)--將1的經驗傳給2
                local function responseMethod(tag,gameData)
                    local data = gameData:getNodeWithKey("data")
                    -- cclog("data == " .. data:getFormatBuffer())
                    local cards = data:getNodeWithKey("cards")
                    local reward = data:getNodeWithKey("reward")
                    game_util:rewardTipsByJsonData(reward);
                    local testBallExp = game_data:getUserStatusDataByKey("exp_ball") or 0
                    if testBallExp > self.ball_exp then
                        self.anim_section = "daiji3"
                        self.m_chest_anim:playSection(self.anim_section)
                    end
                    self.ball_exp = game_data:getUserStatusDataByKey("exp_ball") or 0

                    -- cclog("cards == "..cards:getFormatBuffer())
                    local function anim_call_function()
                        local masterData,master_cfg = game_data:getCardDataById(tostring(self.m_add_hero_id))
                        local studentData,stu_cfg = game_data:getCardDataById(tostring(self.m_added_hero_id))
                        local master_hero_node = game_util:createHeroListItemByCCB(masterData);
                        local student_hero_node = game_util:createHeroListItemByCCB(studentData);
                        if self.m_card_add_node ~= nil then
                            self.m_card_add_node:removeAllChildrenWithCleanup(true);
                        end
                        if self.m_carded_add_node_2 ~= nil then
                            self.m_carded_add_node_2:removeAllChildrenWithCleanup(true);
                        end
                        master_hero_node:setAnchorPoint(ccp(0.5,0.5))
                        student_hero_node:setAnchorPoint(ccp(0.5,0.5))
                        local node_size = master_hero_node:getContentSize();
                        self.m_card_add_node:addChild(master_hero_node)
                        self.m_carded_add_node_2:addChild(student_hero_node)
                        master_hero_node:setPosition(ccp(node_size.width*0.5,node_size.height*0.5));
                        student_hero_node:setPosition(ccp(node_size.width*0.5,node_size.height*0.5));

                        local student_lv = studentData.lv
                        local master_lv = masterData.lv
                        self.m_add_now_label:setString(tostring(master_lv));
                        self.m_added_now_label:setString(tostring(student_lv));
                        self.m_add_next_label:setString(tostring(master_lv));
                        self.m_added_next_label:setString(tostring(student_lv));

                        game_scene:addPop("game_hero_info_pop",{tGameData = game_data:getCardDataById(tostring(self.m_added_hero_id)),heroDataBackup = self.m_selHeroDataBackup,openType=2})

                        --刪除兩個傳承人物
                        self.m_add_hero_id = nil;
                        self.m_card_add_node:removeAllChildrenWithCleanup(true);
                        -- 被传承卡如果等级未满,则不删除
                        if studentData.lv >= studentData.level_max then
                            self.m_added_hero_id = nil;
                            self.m_carded_add_node_2:removeAllChildrenWithCleanup(true);
                            self.m_select_index = 1
                            self.m_alpha_layer:setVisible(false)
                            self.light_add:setVisible(true)
                        else
                            self.m_select_index = 0
                            self.m_alpha_layer:setVisible(true)
                        end
                        self.light_added:setVisible(false)
                        self.ball_flag = 0
                        self:set_level_label()
                        self:refreshUi()
                    end
                    --特效動畫 animi_hero_inherit    animi_card_split
                    local anim_node = game_util:createSplitEffectAnim("animi_hero_inherit",1,false,anim_call_function,nil)
                    local anima_size = self.m_card_add_node:getContentSize()
                    anim_node:setAnchorPoint(ccp(0.5,0.5))
                    anim_node:setPosition(ccp(anima_size.width*0.5,anima_size.height*0.5));
                    game_sound:playUiSound("chuancheng")
                    local pX,pY = self.m_card_add_node:getPosition();
                    anim_node:setPosition(ccp(pX,pY));
                    self.m_card_add_node:getParent():addChild(anim_node,10)
                    -- self:refreshUi()
                end
                local params = {};
                params.master = self.m_add_hero_id
                params.student = self.m_added_hero_id
                params.use_exp_ball = self.ball_flag
                self.m_selHeroDataBackup = util.table_new(game_data:getCardDataById(tostring(self.m_added_hero_id)));

                self.back_add_id = self.m_add_hero_id
                self.back_added_id = self.m_added_hero_id

                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_inherit"), http_request_method.GET, params,"cards_inherit")
            end

            if self.m_add_hero_id ~= nil and self.m_added_hero_id ~= nil then--選擇了傳承卡和被傳承卡
                if self.back_add_id == self.m_add_hero_id and self.back_added_id == self.m_added_hero_id then
                    game_util:addMoveTips({text = "Đồng đội này cạn kiệt nội lực, đổi đồng đội đi~~"});
                else
                    --先判斷有沒有道具  ID 24 有就直接傳，沒有提示使用鑽石
                    local count = game_data:getItemCountByCid(tostring(24))
                    if count > 0 then
                        trans_exp(self.m_add_hero_id,self.m_added_hero_id)
                    else
                        local canBuy,pay = game_util:getCostCoinBuyTimes(15)
                        local t_params = 
                        {
                            title = string_config.m_title_prompt,
                            okBtnCallBack = function(target,event)
                                game_util:closeAlertView();
                                trans_exp(self.m_add_hero_id,self.m_added_hero_id)
                            end,   --可缺省
                            okBtnText = string_config.m_btn_sure,       --可缺省
                            cancelBtnText = string_config.m_btn_cancel,
                            text = "Kế thừa cần tiêu hao" .. pay .. "Xu，tiếp tục chứ？",      --可缺省 传承需要消耗   钻石 是否继续
                            onlyOneBtn = false,
                            touchPriority = GLOBAL_TOUCH_PRIORITY-20,
                        }
                        game_util:openAlertView(t_params)
                    end
                end
            else
                -------------
                if self.ball_flag == 1 and self.m_added_hero_id ~= nil then--使用經驗球
                    local function trans_anim2()--將經驗球的經驗傳給2
                        local function responseMethod(tag,gameData)
                            local data = gameData:getNodeWithKey("data")
                            local cards = data:getNodeWithKey("cards")
                            local reward = data:getNodeWithKey("reward")
                            game_util:rewardTipsByJsonData(reward);
                            self.ball_exp = game_data:getUserStatusDataByKey("exp_ball") or 0
                            local function anim_call_function()
                                local studentData,stu_cfg = game_data:getCardDataById(tostring(self.m_added_hero_id))
                                local student_hero_node = game_util:createHeroListItemByCCB(studentData);
                                if self.m_carded_add_node_2 ~= nil then
                                    self.m_carded_add_node_2:removeAllChildrenWithCleanup(true);
                                end
                                local node_size = student_hero_node:getContentSize();
                                student_hero_node:setAnchorPoint(ccp(0.5,0.5))
                                self.m_carded_add_node_2:addChild(student_hero_node)
                                student_hero_node:setPosition(ccp(node_size.width*0.5,node_size.height*0.5));

                                local student_lv = studentData.lv
                                -- self.m_added_now_label:setString(tostring(student_lv));
                                -- self.m_added_next_label:setString(tostring(student_lv));

                                game_scene:addPop("game_hero_info_pop",{tGameData = game_data:getCardDataById(tostring(self.m_added_hero_id)),heroDataBackup = self.m_selHeroDataBackup,openType=2})

                                --刪除兩個傳承人物
                                self.m_add_hero_id = nil;
                                self.m_added_hero_id = nil;
                                self.m_card_add_node:removeAllChildrenWithCleanup(true);
                                self.m_carded_add_node_2:removeAllChildrenWithCleanup(true);

                                self.m_select_index = 1
                                self.light_added:setVisible(false)
                                self.light_add:setVisible(true)
                                self.m_alpha_layer:setVisible(false)
                                self.ball_flag = 0
                                self:set_level_label()
                                self:refreshUi()
                            end
                            --特效動畫 animi_hero_inherit    animi_card_split
                            local anim_node = game_util:createSplitEffectAnim("animi_ball_inherit",1,false,anim_call_function,nil)
                            local anima_size = self.ball_node:getContentSize()
                            anim_node:setAnchorPoint(ccp(0.5,0.5))
                            anim_node:setPosition(ccp(anima_size.width*0.5,anima_size.height*0.5));
                            game_sound:playUiSound("chuancheng")
                            local pX,pY = self.ball_node:getPosition();
                            anim_node:setPosition(ccp(pX,pY));
                            self.ball_node:getParent():addChild(anim_node,10)
                        end
                        local params = {};
                        params.master = self.m_add_hero_id
                        params.student = self.m_added_hero_id
                        params.use_exp_ball = self.ball_flag
                        self.m_selHeroDataBackup = util.table_new(game_data:getCardDataById(tostring(self.m_added_hero_id)));

                        self.back_add_id = self.m_add_hero_id
                        self.back_added_id = self.m_added_hero_id
                        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_inherit"), http_request_method.GET, params,"cards_inherit")
                    end
                    local canBuy,pay = game_util:getCostCoinBuyTimes(15)
                    local t_params = 
                    {
                        title = string_config.m_title_prompt,
                        okBtnCallBack = function(target,event)
                            game_util:closeAlertView();
                            -- trans_exp(self.m_add_hero_id,self.m_added_hero_id)
                            trans_anim2()
                        end,   --可缺省
                        okBtnText = string_config.m_btn_sure,       --可缺省
                        cancelBtnText = string_config.m_btn_cancel,
                        text = "Kế thừa cần tiêu hao" .. pay .. "Xu, tiếp tục chứ?",      --可缺省
                        onlyOneBtn = false,
                        touchPriority = GLOBAL_TOUCH_PRIORITY-20,
                    }
                    game_util:openAlertView(t_params)
                elseif self.ball_flag == 1 and self.m_added_hero_id == nil then
                    game_util:addMoveTips({text = "Hãy chọn thẻ được kế thừa ~~"});
                else
                    game_util:addMoveTips({text = "Hãy chọn thẻ kế thừa và thẻ được kế thừa ~~"});
                end
            end
        elseif btnTag == 102 then--添加傳承卡
            local function add_card()
            self.light_added:setVisible(false)
            self.light_add:setVisible(true)
            -- if self.m_select_index == 2 then--被占用，不能用
            --     self.m_select_index = 1;
                        --     self.m_alpha_layer:setVisible(false);
            --     self.m_added_hero_id = nil;
            --     if self.m_carded_add_node_2 ~= nil then
            --         self.m_carded_add_node_2:removeAllChildrenWithCleanup(true);
                        --     end
-- else--可点，清空
            --     self.m_select_index = 1;          
--     self.m_alpha_layer:setVisible(false);
            --     self.m_add_hero_id = nil;
                --     if self.m_card_add_node ~= nil then
                --         self.m_card_add_node:removeAllChildrenWithCleanup(true);
                --     end
                -- end
                self.m_alpha_layer:setVisible(false);
                -- if self.m_select_index == 2 then

                -- else
                    self.m_add_hero_id = nil;
                    if self.m_card_add_node ~= nil then
                        self.m_card_add_node:removeAllChildrenWithCleanup(true);
                    end
                -- end
                self.m_select_index = 1;          

                -- local ex_exp = game_data:getCardDataById(self.m_add_hero_id).pre_exp      
            self:set_level_label()
            self:refreshUi(true)
            end
            add_card()
        elseif btnTag == 103 then--添加被傳承卡 
            local function added_card()
            self.light_added:setVisible(true)
            self.light_add:setVisible(false)
            -- if self.m_select_index == 1 then
            --     self.m_select_index = 2;
                        --     self.m_alpha_layer:setVisible(false);
            --     self.m_add_hero_id = nil;
            --     if self.m_card_add_node ~= nil then
            --         self.m_card_add_node:removeAllChildrenWithCleanup(true);
                        --     end
-- else
            --     self.m_select_index = 2;
--     self.m_alpha_layer:setVisible(false);
            --     self.m_added_hero_id = nil;
                --     if self.m_carded_add_node_2 ~= nil then
                --         self.m_carded_add_node_2:removeAllChildrenWithCleanup(true);
                --     end
                -- end
                self.m_alpha_layer:setVisible(false);
                -- if self.m_select_index == 1 then

                -- else
                    self.m_added_hero_id = nil;
                    if self.m_carded_add_node_2 ~= nil then
                        self.m_carded_add_node_2:removeAllChildrenWithCleanup(true);
                    end
                -- end
                self.m_select_index = 2;

                -- local ex_exp = game_data:getCardDataById(self.m_add_hero_id).pre_exp
            self:set_level_label()
            self:refreshUi(true)
            end
            added_card()
        elseif btnTag == 105 then--返回
            self:back();
        elseif btnTag > 200 and btnTag < 205 then
            local index = btnTag - 200;
            for i=1,4 do
                self.m_btn_table[i]:setEnabled(true)
                self.m_btn_table[i]:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_table_select.png"),CCControlStateNormal);
            end
            self.m_btn_table[index]:setEnabled(false)
            self.m_btn_table[index]:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_table_selected.png"),CCControlStateDisabled);
            --切換table
            local typeTable = {"default","quality","lv","profession",};
            local selSort = typeTable[index]
            game_data:cardsSortByTypeNameWithTable(selSort,self.m_newCardsTab)
            self:refreshUi(true);
        elseif btnTag == 500 then--經驗球
            if self.m_added_hero_id ~= nil then--不為空才可選
                self.ball_flag = 1
                self.anim_section = "daiji1"
                self.m_chest_anim:playSection(self.anim_section)
                self:set_level_label()
            else
                game_util:addMoveTips({text = "Xin chọn thẻ được kế thừa xong rồi dùng quả cầu EXP!"})
            end
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_chuancheng.ccbi");

    self.m_table_view = ccbNode:nodeForName("table_view_node");
    self.m_card_add_node = ccbNode:nodeForName("card_add_node")
    self.m_carded_add_node_2 = ccbNode:nodeForName("card_added_node")
    self.m_btn_add = ccbNode:controlButtonForName("btn_add_hero")
    self.m_btn_added = ccbNode:controlButtonForName("btn_added_hero")
    self.m_btn_trans = ccbNode:controlButtonForName("btn_trans")
    self.m_alpha_layer = ccbNode:layerColorForName("alpha_layer");

    game_util:setControlButtonTitleBMFont(self.m_btn_trans)

    self.m_add_now_label = ccbNode:labelTTFForName("add_now_label")
    self.m_add_next_label = ccbNode:labelTTFForName("add_next_label")
    self.m_added_now_label = ccbNode:labelTTFForName("added_now_label")
    self.m_added_next_label = ccbNode:labelTTFForName("added_next_label")
    self.m_add_lv_sprite = ccbNode:spriteForName("add_lv_sprite")
    self.m_added_lv_sprite = ccbNode:spriteForName("added_lv_sprite")

    self.light_add = ccbNode:scale9SpriteForName("light_add")
    self.light_added = ccbNode:scale9SpriteForName("light_added")
    self.ball_node = ccbNode:nodeForName("ball_node")
    self.m_combat_label = ccbNode:labelBMFontForName("m_combat_label")
    self.btn_ball = ccbNode:controlButtonForName("btn_ball")
    self.btn_ball:setOpacity(0)

    local m_bg_sprite = ccbNode:spriteForName("m_bg_sprite")
    m_bg_sprite:setScale(resolution_config:getScale())

    self.m_btn_table = {}
    for i=1,4 do
        self.m_btn_table[i] = ccbNode:controlButtonForName("table_tab_btn_"..i)
        self.m_btn_table[i]:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_table_select.png"),CCControlStateNormal);
    end
    self.m_btn_table[1]:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_table_selected.png"),CCControlStateNormal);

    self.m_add_lv_sprite:setVisible(false)
    self.m_added_lv_sprite:setVisible(false)


    local aniName = "Default Timeline"

     -- 是否隱藏 vip
    if game_data:isViewOpenByID(103) then
        aniName = "Label Timeline"
    elseif text_label2_vip then
        aniName = "Default Timeline"
    end

    local function animCallFunc(animName)
        ccbNode:runAnimations(aniName)
    end
    ccbNode:registerAnimFunc(animCallFunc);
    ccbNode:runAnimations(aniName)

    self.m_can_select = false;
    self.m_select_index = 1;
    self.light_added:setVisible(false)
    self.m_alpha_layer:setVisible(false);

    self.m_have_selected = 0;
    self.m_select_id_table = {};

    local iconSprite = game_util:createIconByName("icon_gongzhengshu")
    iconSprite:setScale(0.7)
    iconSprite:setAnchorPoint(ccp(0.5,0.5))

    local icon_gongzheng = ccbNode:nodeForName("icon_gongzheng")
    icon_gongzheng:removeAllChildrenWithCleanup(true)
    if iconSprite then
        icon_gongzheng:addChild(iconSprite,10,10)
    end

    local function animCallFunc2(animNode, theId,theLabelName)
        animNode:playSection(self.anim_section)
    end
    self.m_chest_anim = game_util:createUniversalAnim({animFile = "anim_jingyancao",rhythm = 1.0,loopFlag = true,animCallFunc = animCallFunc2,actionName = self.anim_section});
    local tempSize = ccbNode:getContentSize();
    -- self.m_chest_anim:setPosition(ccp(tempSize.width*0.5, tempSize.height*0.5))
    self.ball_node:addChild(self.m_chest_anim,100,100)
    return ccbNode;
end
--[[
    創建英雄列表
]]--
function game_hero_inherit.createTableView( self,viewSize )
    local cardsCount = game_data:getCardsCount();
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;
    params.column = 1; --列
    params.totalItem = #self.m_newCardsTab
    params.itemActionFlag = true;
    params.direction = kCCScrollViewDirectionVertical;--縱向
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
--[[
    cell
]]--
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local ccbNode = game_util:createHeroListItemByCCB2();
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local itemData,itemCfg = game_data:getCardDataById(self.m_newCardsTab[index+1])
            
            if itemData and itemCfg then
                local heroId = itemData.id;
                game_util:setHeroListItemInfoByTable2(ccbNode,itemData);

                local sprite_selected = ccbNode:spriteForName("sprite_selected");
                local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
                if self.m_add_hero_id == itemData.id or self.m_added_hero_id == itemData.id then
                    sprite_selected:setVisible(true);
                    sprite_back_alpha:setVisible(true);
                else
                    sprite_selected:setVisible(false);
                    sprite_back_alpha:setVisible(false);
                end
            end
        end
        return cell;
    end

    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            local ccbNode = tolua.cast(item:getChildByTag(10),"luaCCBNode");
            local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
            local sprite_selected = ccbNode:spriteForName("sprite_selected");
            local itemData,hero_config =  game_data:getCardDataById(self.m_newCardsTab[index+1])
            if self.m_select_index == 1 then--添加的在選英雄
                local is_in_team = game_data:heroInTeamById(itemData.id);
                local is_lock = game_util:getCardUserLockFlag(itemData);
                local is_in_train = game_util:getCardTrainingFlag(itemData)
                local lock = is_in_team or is_lock or is_in_train
                if lock == true then
                    if is_in_team then
                        game_util:addMoveTips({text = "Đồng đội này đã ra trận!"});
                    else
                        if is_in_train then
                            game_util:addMoveTips({text = "Đồng đội này đang huấn luyện!"});
                        else
                            if is_lock then
                                game_util:addMoveTips({text = "Đồng đội này đã bị khóa định!"});
                            end
                        end
                    end
                else
                    -- cclog("itemData = " .. json.encode(itemData))
                    if itemData.lv == 1 then
                        game_util:addMoveTips({text = "Tên này mới cấp 1, đổi ai khác đi~"});
                    else
                        if self.m_added_hero_id ~= itemData.id then
                            sprite_selected:setVisible(true);
                            sprite_back_alpha:setVisible(true);
                            local hero_node = game_util:createHeroListItemByCCB(itemData);
                            self.m_add_hero_id = itemData.id;
                            hero_node:setAnchorPoint(ccp(0.5,0.5))
                            local node_size = hero_node:getContentSize();
                            self.m_card_add_node:addChild(hero_node,10,100+index+1);
                            hero_node:setPosition(ccp(node_size.width*0.5,node_size.height*0.5));
                            self.m_select_index = 0;
                            self.m_alpha_layer:setVisible(true);
                            self:set_level_label()

                            self.light_add:setVisible(false)

                            --選完之後自動切換
                            -- self.m_select_index = 2
                            -- self.m_alpha_layer:setVisible(false);
                            -- if self.m_added_hero_id == nil then
                            --     self.light_added:setVisible(true)
                            --     self.light_add:setVisible(false)
                            -- else
                            --     self.light_added:setVisible(false)
                            --     self.light_add:setVisible(false)
                            -- end
                        end
                    end
                end
            elseif self.m_select_index == 2 then--被添加的在選
                --達到主卡等級滿時，提示等級已滿
                if itemData.level_max == itemData.lv then
                    game_util:addMoveTips({text = "Đồng đội này đã đạt cấp tối đa"});
                else
                    if self.m_add_hero_id ~= itemData.id then
                        sprite_selected:setVisible(true);
                        sprite_back_alpha:setVisible(true);
                        local hero_node = game_util:createHeroListItemByCCB(itemData);
                        self.m_added_hero_id = itemData.id;
                        hero_node:setAnchorPoint(ccp(0.5,0.5))
                        local node_size = hero_node:getContentSize();
                        self.m_carded_add_node_2:addChild(hero_node,10,100+index+1);
                        hero_node:setPosition(ccp(node_size.width*0.5,node_size.height*0.5));
                        self.m_select_index = 0;
                        self.m_alpha_layer:setVisible(true);

                        -- local ex_exp = game_data:getCardDataById(self.m_add_hero_id).pre_exp
                        self:set_level_label()

                        self.light_added:setVisible(false)

                        --選完之後自動切換
                        -- self.m_select_index = 1
                        -- self.m_alpha_layer:setVisible(false);
                        -- if self.m_add_hero_id == nil then
                        --     self.light_added:setVisible(false)
                        --     self.light_add:setVisible(true)
                        -- else
                        --     self.light_added:setVisible(false)
                        --     self.light_add:setVisible(false)
                        -- end
                    end
                end
            else--不可選擇

            end
        end
    end
    return TableViewHelper:create(params);
end
--[[
    設置等級變化
]]--
function game_hero_inherit.set_level_label(self,server_ex)
    local function get_hero_info(hero_id)
        local itemData,hero_config = game_data:getCardDataById(hero_id);
        return itemData;
    end
    local function get_ex_exp(level_cfg,level,now_level_exp)
        local ex_exp = 0;
        for i=1,level-1 do
            local my_level = level_cfg:getNodeWithKey((tostring(i)))
            local exp = my_level:getNodeWithKey("exp"):toInt();
            ex_exp = ex_exp + exp
        end
        ex_exp = ex_exp + now_level_exp
        ----------------------------傳經驗有比例，先寫100%--------------------------
        return ex_exp;
    end
    local function last_level(max_level,now_level,exp,level_cfg,exp_rate)
        local next_level = now_level
        local free_exp = exp
        for i=now_level,max_level - 1 do
            local my_level = level_cfg:getNodeWithKey((tostring(i)))
            local level_exp = my_level:getNodeWithKey("exp"):toInt()*exp_rate
            if free_exp - level_exp >= 0 then
                free_exp = free_exp - level_exp
                next_level = next_level + 1
            else
                break;
            end
        end
        if next_level >= max_level then
            return max_level
        else
            return next_level
        end
    end
    
    if self.m_add_hero_id ~= nil and self.m_added_hero_id ~= nil then
        local hero_info_1 = get_hero_info(self.m_add_hero_id)
        local hero_info_2 = get_hero_info(self.m_added_hero_id)
        local level_cfg = getConfig(game_config_field.character_base);--得到每級的經驗值，去相加
        local add_now_exp = hero_info_1.exp;
        -- local add_exp = get_ex_exp(level_cfg,hero_info_1.lv,add_now_exp)--傳承英雄所能傳過來全部的經驗

        -- if server_ex then
        --     add_exp = server_ex
        -- end
        local add_exp = hero_info_1.pre_exp + hero_info_1.exp
        if game_data:getVipLevel() < 1 then
            add_exp = add_exp * 0.7
        end
        if self.ball_flag == 1 then--加上經驗球的經驗
            local ballExp = game_data:getUserStatusDataByKey("exp_ball") or 0
            add_exp = ballExp + add_exp
        end
        local quality = hero_info_2.quality
        local character_base_rate = getConfig(game_config_field.character_base_rate)
        local itemCfg = character_base_rate:getNodeWithKey(tostring(quality))
        local exp_rate = itemCfg:getNodeWithKey("exp_rate"):toFloat()

        local added_now_exp = hero_info_2.exp
        local added_exp = added_now_exp + add_exp
        local level_max = hero_info_2.level_max
        local next_level = last_level(level_max,hero_info_2.lv,added_exp,level_cfg,exp_rate)

        local level_add = hero_info_1.lv;
        local level_added = hero_info_2.lv;
        self.m_add_now_label:setString(tostring(level_add));
        self.m_added_now_label:setString(tostring(level_added));
        
        self.m_add_next_label:setString("1")
        self.m_added_next_label:setString(tostring(next_level))
        -- game_util:labelChangedRepeatForeverFade(self.m_add_next_label,"1","1")
        -- game_util:labelChangedRepeatForeverFade(self.m_added_next_label,tostring(next_level),tostring(next_level))
        self.m_add_lv_sprite:setVisible(true)
        self.m_added_lv_sprite:setVisible(true)
    elseif self.m_added_hero_id ~= nil and self.ball_flag == 1 then--只有經驗球的
        local hero_info_2 = get_hero_info(self.m_added_hero_id)
        local level_cfg = getConfig(game_config_field.character_base);--得到每級的經驗值，去相加
        local ballExp = game_data:getUserStatusDataByKey("exp_ball") or 0
        local add_exp = ballExp
        if game_data:getVipLevel() < 1 then
            add_exp = add_exp * 0.7
        end
        local quality = hero_info_2.quality
        local character_base_rate = getConfig(game_config_field.character_base_rate)
        local itemCfg = character_base_rate:getNodeWithKey(tostring(quality))
        local exp_rate = itemCfg:getNodeWithKey("exp_rate"):toFloat()

        local added_now_exp = hero_info_2.exp
        local added_exp = added_now_exp + add_exp
        local level_max = hero_info_2.level_max
        local next_level = last_level(level_max,hero_info_2.lv,added_exp,level_cfg,exp_rate)

        local level_added = hero_info_2.lv;
        self.m_add_now_label:setString("");
        self.m_added_now_label:setString(tostring(level_added));
        
        self.m_added_next_label:setString(tostring(next_level));
        self.m_add_lv_sprite:setVisible(false)
        self.m_added_lv_sprite:setVisible(true)
    else
        self.m_add_now_label:setString("");
        self.m_added_now_label:setString("");
        self.m_add_next_label:setString("")
        self.m_added_next_label:setString("")
        self.m_add_lv_sprite:setVisible(false)
        self.m_added_lv_sprite:setVisible(false)
    end
end
--[[--
    刷新ui
]]
function game_hero_inherit.refreshUi(self,falg)
    if falg == true then

    else
        self.m_newCardsTab,_,_,_,_,_,_ = game_data:getCardsDataSimpleFiltered()
        game_data:cardsSortByTypeNameWithTable("default",self.m_newCardsTab)
    end
    self.m_table_view:removeAllChildrenWithCleanup(true);
    local tableViewTemp = self:createTableView(self.m_table_view:getContentSize());
    tableViewTemp:setScrollBarVisible(false);
    self.m_table_view:addChild(tableViewTemp);

    self.m_combat_label:setString(self.ball_exp)
    if self.m_select_index == 0 and self.m_added_hero_id and not falg and self.m_newCardsTab then
        -- 自适应滑动到选定位置
        local _datas = self.m_newCardsTab
        local _parent = self.m_table_view
        local m_tableView = tableViewTemp
        local index = 1
        for i=1,#_datas do
            if _datas[i] == tostring(self.m_added_hero_id) then
                index = i
                break
            end
        end
        local offset = m_tableView:getContentOffset()
        local viewSize = _parent:getContentSize()
        local totalItem = #_datas
        local column = 1
        local row = 5
        local itemSize = CCSizeMake(viewSize.width / column, viewSize.height / row)
        -- 计算新的偏移量
        local newOffsetY = 0 + viewSize.height - (totalItem - index + 1) * itemSize.height
        -- 边界判断
        local minOffsetY = -((totalItem - row) * itemSize.height)  -- 最小偏移量（列表滚动到底部）
        local maxOffsetY = 0  -- 最大偏移量（列表滚动到顶部）
        -- 确保 newOffsetY 在有效范围内
        if newOffsetY < minOffsetY then
            newOffsetY = minOffsetY
        elseif newOffsetY > maxOffsetY then
            newOffsetY = maxOffsetY
        end
        -- 设置新的偏移量
        m_tableView:setContentOffset(ccp(offset.x, newOffsetY))
    end
end
--[[--
    初始化
]]
function game_hero_inherit.init(self,t_paragame_hero_inherits)
    t_params = t_params or {};
    self.m_newCardsTab = {}
    self.anim_section = "daiji2"
    self.ball_flag = 0
    self.ball_exp = game_data:getUserStatusDataByKey("exp_ball") or 0
    cclog2(self.ball_exp,"self.ball_exp")
end

--[[--
    創建ui入口並初始化數據
]]
function game_hero_inherit.create(self,t_paragame_hero_inherits)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    local id = game_guide_controller:getIdByTeam("11");
    if id == 1101 then
        game_guide_controller:gameGuide("drama","11",1101)
    end
    return scene;
end

return game_hero_inherit;�  