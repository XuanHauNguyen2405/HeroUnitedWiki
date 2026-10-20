local game_skills_exchange_pop = {
    m_tGameData = nil,
    m_node_tableView = nil,
    btnCallFunc = nil,
    m_node_anim = nil,
    m_heroId = nil,
    m_select_index = nil,
    m_tab_nodeSkill = nil,
    m_tab_skillId = nil,
    text_scroll = nil,
    content_node = nil,
    m_tab_skillStory = nil,
    m_index = nil,
    m_layer_bofang = nil,
    m_btn_bofang = nil,
};
--[[--
    销毁ui
]]
function game_skills_exchange_pop.destroy(self)
    cclog("-----------------game_skills_exchange_popdestroy-----------------");
    self.m_tGameData = nil;
    self.m_node_tableView = nil;
    self.btnCallFunc = nil;
    self.m_node_anim = nil;
    self.m_heroId = nil;
    self.m_select_index = nil;
    self.m_tab_skillId = nil;
    self.m_tab_nodeSkill = nil;
    self.text_scroll = nil;
    self.content_node = nil;
    self.m_tab_skillStory = nil;
    self.m_index = nil;
    self.m_layer_bofang = nil;
    self.m_btn_bofang = nil;

end
--[[--
    返回
]]
function game_skills_exchange_pop.back(self,backType)
    if backType then
        local indexAndCardIdTab = game_data:getExhcangeSkillIndexAndID()
        game_scene:enterGameUi("skills_strengthen_scene",{gameData = nil,indexAndCardIdTab = indexAndCardIdTab,fromPop = true});
    else
        game_scene:removePopByName("game_skills_exchange_pop")
    end
   
    -- game_scene:enterGameUi("game_main_scene")
    -- local function responseMethod(tag,gameData)
    --     game_scene:enterGameUi("game_gacha_scene",{gameData = gameData});
    --     self:destroy();
    -- end
    -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("gachaNew_card_index"), http_request_method.GET, nil,"gachaNew_card_index")
end
--[[--
    读取ccbi创建ui
]]
function game_skills_exchange_pop.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        cclog2(btnTag,"btnTag === ")
        if btnTag == 1 then
            self:back()
        elseif btnTag == 101 then--重置

        elseif btnTag == 102 then --确定
            if game_util:getTableLen(self.m_tab_skillId) == 3 then
                local params = {}
                local str = ""
                local num = 0
                for i=1,5 do
                    if self.m_tab_skillId[tostring(i)] then
                        str = str .. self.m_tab_skillId[tostring(i)] ..  (num == 3 and "" or "_")
                        num = num + 1
                    end
                end
                params.skill_ids = str
                params.card_id = self.m_heroId
                local function responseMethod( tag,gameData)
                    self:back(true)
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_set_battle_skill"), http_request_method.GET, params,"cards_set_battle_skill")
            else
                game_util:addMoveTips({text = "Chọn 3 skill "})
            end
        elseif btnTag > 104 then
            local function responseMethod( tag,gameData )
                if gameData ~= nil and tolua.type(gameData) == "util_json" then
                    game_data:setBattleType("lookNewCardSkill");
                    game_scene:enterGameUi("game_battle_scene",{gameData = gameData});
                    -- self.m_tGameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
                    -- self:refreshUi()
                end
            end 
            local params = {}
            params.card_id = self.m_heroId
            params.skill_id = 20250
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_get_skill_animation"), http_request_method.GET, params,"cards_get_skill_animation")
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_exchangeSkill.ccbi");
    self.m_node_tableView = ccbNode:nodeForName("m_node_tableView")
    self.m_node_anim = ccbNode:nodeForName("m_node_anim")
    local m_btn_close = ccbNode:controlButtonForName("m_btn_close")
    m_btn_close:setTouchPriority(GLOBAL_TOUCH_PRIORITY-1)
    local m_btn_sure = ccbNode:controlButtonForName("m_btn_sure")
    m_btn_sure:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.text_scroll = ccbNode:scrollViewForName("m_scroll_view_Secret");
    self.content_node = ccbNode:nodeForName("content_node")
    self.m_layer_bofang = ccbNode:layerForName("m_layer_bonfang")
    self.m_btn_bofang = ccbNode:controlButtonForName("m_btn_bofang")
    self.m_btn_bofang:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.m_layer_bofang:setVisible(false)
    self.m_btn_bofang:setVisible(false)
    self.m_tab_nodeSkill = {}
    local m_node_skill = nil
    for i=1,5 do
        m_node_skill = ccbNode:nodeForName("m_node_skill" .. i)
        self.m_tab_nodeSkill[i] = m_node_skill
    end

    local m_root_layer = ccbNode:layerForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;--intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-1,true);
    m_root_layer:setTouchEnabled(true);
    return ccbNode;
end
function game_skills_exchange_pop.createLogs( self,skillId )
    if skillId >3 then
        -- skillId = skillId +2
    end
    self.text_scroll:getContainer():removeAllChildrenWithCleanup(true);
    local viewSize = self.content_node:getContentSize()
    local skill_story = self.m_tab_skillStory[skillId]
    local skill_detail_cfg = getConfig(game_config_field.skill_detail);
    local skillItem = self.m_tGameData.skill[skillId]

    local skillCfg = skill_detail_cfg:getNodeWithKey(tostring(skillItem.s));
    local  skillLevel = skillItem.lv
    if skillCfg then
        local effect = skillCfg:getNodeWithKey("effect")
        if effect then
            local attr_effect = skillCfg:getNodeWithKey("attr_effect")
            attr_effect = attr_effect ~= nil and attr_effect:toFloat() or 0
            attr_effect = string.format("%.1f",attr_effect)
            skill_story = string.gsub(skill_story,"attr",tostring(attr_effect*100));
            effect = effect:toFloat();
            local effect_lvchange = skillCfg:getNodeWithKey("effect_lvchange"):toFloat();
            effect_lvchange = string.format("%.1f",effect_lvchange)
            local tempEffect = string.format("%.1f",effect + effect_lvchange*skillLevel)
            skill_story = string.gsub(skill_story,"effect",tostring(tempEffect));
        else
        end
    end
    local contentText = skill_story
    local tempLabel = game_util:createRichLabelTTF({text = contentText,dimensions = CCSizeMake(144,0),textAlignment = kCCTextAlignmentLeft, verticalTextAlignment = kCCVerticalTextAlignmentCenter,fontSize = 9})
    local tempSize = tempLabel:getContentSize()
    self.text_scroll:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.text_scroll:setContentSize(CCSizeMake(144,tempSize.height))
    self.text_scroll:setContentOffset(ccp(0, viewSize.height - tempSize.height), false)
    self.text_scroll:setDirection(kCCScrollViewDirectionVertical)
    self.text_scroll:addChild(tempLabel)
end
function game_skills_exchange_pop.createSkillTab( self )
    local imgSelectTab,imgTickTab = {},{}
    local function onBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag < 300 then --选择三个技能
            if self.m_tab_skillId[tostring(btnTag)] then
                self.m_tab_skillId[tostring(btnTag)] = nil
            elseif game_util:getTableLen(self.m_tab_skillId) < 3 then
                self.m_tab_skillId[tostring(btnTag)] = btnTag
            else
                self.m_tab_skillId[tostring(btnTag)] = nil
            end
            for i=1,5 do
                imgTickTab[i]:setVisible(false)
                if self.m_tab_skillId[tostring(i)] and self.m_tab_skillId[tostring(i)] ~= 0 then
                    imgTickTab[i]:setVisible(true)
                end
            end
        elseif btnTag > 400 then  --没解锁 提示解锁
            local canBuy,pay = game_util:getCostCoinBuyTimes(btnTag-362)
            local t_params = 
                {
                    title = string_config.m_title_prompt,
                    okBtnCallBack = function(target,event)
                        local function responseMethod( tag,gameData )
                            if gameData ~= nil and tolua.type(gameData) == "util_json" then
                                game_util:addMoveTips({text = "Đã mở "})
                                self.m_tGameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
                                self:refreshUi()
                            end
                        end 
                        local params = {}
                        params.card_id = self.m_heroId
                        params.skill_id = btnTag - 400
                        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_unlock_skill"), http_request_method.GET, params,"cards_unlock_skill")
                        game_util:closeAlertView();
                    end,   --可缺省
                    cancelBtnCallBack = function(target,event)
                        game_util:closeAlertView();
                    end,
                    okBtnText = "YES",       --可缺省
                    cancelBtnText = "NO",
                    onlyOneBtn = false,
                    text = "Tốn" .. pay .. "mở skill nà",      --可缺省
                    touchPriority = GLOBAL_TOUCH_PRIORITY-2,
                }
                game_util:openAlertView(t_params);
        else --查看技能详情
            for i=1,5 do
                imgSelectTab[i]:setVisible(false)
                imgSelectTab[btnTag-300]:setVisible(true)
            end
            self:createHeroAnim(btnTag-300)
            self:createLogs(btnTag-300)
        end
    end
    for i=1,5 do
        self.m_tab_nodeSkill[i]:removeAllChildrenWithCleanup(true)
        local ccbNode = luaCCBNode:create();
        ccbNode:registerFunctionWithFuncName("onBtnClick",onBtnClick);
        ccbNode:openCCBFile("ccb/ui_exchangeSkill_item.ccbi");
        ccbNode:setPosition(ccp(-37,0))
        self.m_tab_nodeSkill[i]:addChild(ccbNode)   

        local cardData,heroCfg = game_data:getCardDataById(tostring(self.m_heroId));
        local skill_detail_cfg = getConfig(game_config_field.skill_detail);
        local skill_levelup_cfg = getConfig(game_config_field.skill_levelup);
        local skillJsonData = nil;
        local skillItem = nil;
        local skill_icon_spr_bg = ccbNode:spriteForName("m_skill_sprite")
        local select_sprite = ccbNode:spriteForName("select_sprite")
        local lvLabel = ccbNode:labelTTFForName("m_lab_lv")

        local m_btn_select = ccbNode:controlButtonForName("m_btn_select")
        m_btn_select:setTag(i)
        m_btn_select:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)

        local m_btn_cur = ccbNode:controlButtonForName("m_btn_cur")
        m_btn_cur:setTag(i+300)
        m_btn_cur:setOpacity(0)
        m_btn_cur:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)


        local m_sp_tick = ccbNode:spriteForName("m_sp_tick")
        imgTickTab[i] = m_sp_tick
        if self.m_tab_skillId[tostring(i)] and self.m_tab_skillId[tostring(i)] ~=0 then
            m_sp_tick:setVisible(true)
        else
            m_sp_tick:setVisible(false)
        end
        imgSelectTab[i] = select_sprite
        if self.m_select_index == i then
            select_sprite:setVisible(true)
        else
            select_sprite:setVisible(false)
        end

        local expBg = ccbNode:spriteForName("m_sp_expBg")
        local m_node_icon = ccbNode:spriteForName("m_node_icon")
        skillItem = self.m_tGameData.skill[(i)]
        local skill_break = cardData.skill_break or {}

        if skillItem and skillItem.s ~= 0 then

            expBg:setVisible(true)
            skill_icon_spr_bg:setVisible(false)
            skillJsonData = skill_detail_cfg:getNodeWithKey(tostring(skillItem.s));
            
            if skillJsonData then

                local lvStr = ""
                local skill_break_id = skillJsonData:getNodeWithKey("skill_break_id") and skillJsonData:getNodeWithKey("skill_break_id"):toInt()
                if skill_break_id and skill_break[tostring(skill_break_id)] then
                    local lv = skill_break[tostring(skill_break_id)].lv
                    lvStr = "(+" .. lv .. ")"
                end

                local skill_story = skillJsonData:getNodeWithKey("skill_story"):toStr()
                -- CCLuaLog(skill_story)
                self.m_tab_skillStory[i] = skill_story
                local icon_size = skill_icon_spr_bg:getContentSize();
                local skill_icon_spr = game_util:createSkillIconByCfg(skillJsonData,skillItem.avail)
                if skill_icon_spr then
                    skill_icon_spr:setScale(0.75)
                    m_node_icon:addChild(skill_icon_spr);
                end
                -- 'avail': 1   # 0表示未解锁，1表示解锁未激活，2表示激活
                if skillItem.avail == 2 then
                    local maxExp = 100;
                    local skill_levelup_item_cfg = skill_levelup_cfg:getNodeWithKey(tostring(skillItem.lv))
                    local skill_quality = skillJsonData:getNodeWithKey("skill_quality"):toInt();
                    if skill_levelup_item_cfg then
                        local tempCount = skill_levelup_item_cfg:getNodeCount();
                        if skill_quality < tempCount then
                            maxExp = skill_levelup_item_cfg:getNodeAt(skill_quality):toInt();
                        end
                    end

                    maxExp = (maxExp == 0 and 100 or maxExp)
                    
                    local expBgSize = expBg:getContentSize();
                    local percentage = math.min(100,100*skillItem.exp/maxExp);
                    local expBarAdd = game_util:createProgressTimer({fileName = "jnsj_jingyantiao_1.png",percentage = percentage})
                    expBarAdd:setPosition(ccp(expBgSize.width*0.5,expBgSize.height*0.5));
                    expBg:addChild(expBarAdd,1,1);


                    local bar = game_util:createProgressTimer({fileName = "jnsj_jingyantiao.png",percentage = percentage})
                    bar:setPosition(ccp(expBgSize.width*0.5,expBgSize.height*0.5));
                    expBg:addChild(bar,2,2);
                    lvLabel:setString("Lv." .. skillItem.lv .. lvStr)

                    lvLabel:setVisible(true)
                   
                else -- 没解锁
                    -- m_node_icon:removeAllChildrenWithCleanup(true)
                    skill_icon_spr_bg:setVisible(false)
                    lvLabel:setString("Lv." .. 1)
                    local lock_icon_spr = CCSprite:createWithSpriteFrameName("public_lock_icon.png");
                    lock_icon_spr:setPosition(icon_size.width*0.5,icon_size.height*0.5);
                    skill_icon_spr:addChild(lock_icon_spr,5,5);
                    if i > 3 then
                        m_btn_cur:setTag(400 + i)
                    end
                end
            else

                lvLabel:setVisible(false)
                expBg:setVisible(false)
                skill_icon_spr_bg:setVisible(true)
                local lock_icon_spr = CCSprite:createWithSpriteFrameName("public_lock_icon.png");
                -- lock_icon_spr:setPosition(icon_size.width*0.5,icon_size.height*0.5);
                skill_icon_spr_bg:addChild(lock_icon_spr,5,5);
            end
        else  --没这个技能

            skill_icon_spr_bg:setVisible(true)
            local lock_icon_spr = CCSprite:createWithSpriteFrameName("public_lock_icon.png");
            local icon_size = skill_icon_spr_bg:getContentSize()
            lock_icon_spr:setPosition(icon_size.width*0.5,icon_size.height*0.5);
            skill_icon_spr_bg:addChild(lock_icon_spr,5,5);
            if i > 3 then
                m_btn_cur:setTag(400 + i)
            end

        end
    end
    -- body
end

function game_skills_exchange_pop.createHeroAnim( self,skillID )
    self.m_node_anim:removeAllChildrenWithCleanup(true)
    local cardData,heroCfg = game_data:getCardDataById(tostring(self.m_heroId));
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local itemCfg = character_detail_cfg:getNodeWithKey(tostring(cardData.c_id));
    local skinId = 0
    if  itemCfg:getNodeWithKey("is_skin")   then 
        if itemCfg:getNodeWithKey("is_skin"):toInt() ~= 0 then 
            skinId = itemCfg:getNodeWithKey("is_skin"):toInt()
            -- self.m_btn_skin:setVisible(true)
        end
    end
    local flag = game_util:isWearSkin(skinId)
    if flag then
        itemCfg = character_detail_cfg:getNodeWithKey(tostring(skinId));
    end
    local animFile = itemCfg:getNodeWithKey("animation"):toStr();
    local anim = nil
    -- if skillID == 5 then
    --     self.m_layer_bofang:setVisible(true)
    --     self.m_btn_bofang:setVisible(true)
    --     anim  = game_util:createAnimSequence2(animFile,0,nil,itemCfg,1)
    -- else
        -- self.m_layer_bofang:setVisible(false)
        -- self.m_btn_bofang:setVisible(false)
        anim  = game_util:createAnimSequence2(animFile,0,nil,itemCfg,skillID+1)
    -- end
    self.m_node_anim:addChild(anim)
    -- body
end
--[[
    刷新
]]
function game_skills_exchange_pop.refreshUi(self)
    local index = 1
    if self.m_index then
        index = self.m_index
    end
    self:createHeroAnim(index)
    self:createSkillTab()
    self:createLogs(index)

end

--[[--
    初始化
]]
function game_skills_exchange_pop.init(self,t_params)
    t_params = t_params or {};
    if t_params.gameData ~= nil then
        self.m_tGameData =  json.decode(t_params.gameData:getNodeWithKey("data"):getFormatBuffer()) or {};

    end
    if t_params.btnCallFunc then
        self.btnCallFunc = t_params.btnCallFunc
    end
    self.m_heroId = t_params.heroId
    self.m_select_index = 1
    self.m_index = nil
    if t_params.index then
        self.m_index = t_params.index
        self.m_select_index = t_params.index
    end
    self.m_tab_skillId  = {}
    self.m_tab_skillStory = {}
end

--[[--
    创建ui入口并初始化数据
]]
function game_skills_exchange_pop.create(self,t_params)
    self:init(t_params);
    local m_popUi = self:createUi();
    self:refreshUi();
    return m_popUi;
end

return game_skills_exchange_pop;  BI  