---  突破信息

local hero_breakthrough_detail_pop = {
    m_popUi = nil,
    m_story_label_1 = nil,
    m_story_label_2 = nil,
    m_break_icon = nil,
    m_tips_label = nil,
    m_cardCfgId = nil,
    m_breValue = nil,
    m_selBreValue = nil,
    m_ccbNode = nil,
    m_title_label = nil,
    m_title_label_1 = nil,
    m_title_label_2 = nil,
    mystroy = nil,
};
--[[--
    銷毀
]]
function hero_breakthrough_detail_pop.destroy(self)
    -- body
    cclog("-----------------hero_breakthrough_detail_pop destroy-----------------");
    self.m_popUi = nil;
    self.m_story_label_1 = nil;
    self.m_story_label_2 = nil;
    self.m_break_icon = nil;
    self.m_tips_label = nil;
    self.m_cardCfgId = nil;
    self.m_breValue = nil;
    self.m_selBreValue = nil;
    self.m_ccbNode = nil;
    self.m_title_label = nil;
    self.m_title_label_1 = nil;
    self.m_title_label_2 = nil;
    self.mystroy = nil;

end

local breNameTab = {"Chuyển sinh lần 1", "Chuyển sinh lần 2", "Chuyển sinh lần 3", "Chuyển sinh lần 4", "Chuyển sinh lần 5","Chuyển sinh lần 6","Chuyển sinh lần 7"}

--[[--
    返回
]]
function hero_breakthrough_detail_pop.back(self,type)
    game_scene:removePopByName("hero_breakthrough_detail_pop");
end
--[[--
    讀取ccbi創建ui
]]
function hero_breakthrough_detail_pop.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then--關閉
            self:back();
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
    ccbNode:openCCBFile("ccb/ui_hero_breakthrough_detail_pop.ccbi");

    local m_close_btn = ccbNode:controlButtonForName("m_close_btn")
    m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 16);
    
    local m_root_layer = ccbNode:layerForName("m_root_layer")
    

    local m_stroy_label_1 = ccbNode:nodeForName("m_stroy_label_1")
    local m_stroy_label_2 = ccbNode:nodeForName("m_stroy_label_2")
    self.m_title_label = ccbNode:labelTTFForName("m_title_label")
    self.m_title_label_1 = ccbNode:labelTTFForName("m_title_label_1")
    self.m_title_label_2 = ccbNode:labelTTFForName("m_title_label_2")
    self.m_break_icon = ccbNode:spriteForName("m_break_icon")
    self.m_tips_label = ccbNode:labelTTFForName("m_tips_label")
    self.m_ccbNode = ccbNode;

    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local itemCfg = character_detail_cfg:getNodeWithKey(tostring(self.m_cardCfgId));
    if itemCfg then
        local character_break_cfg = getConfig(game_config_field.character_break_new)
        local character_ID = itemCfg:getKey()--itemCfg:getNodeWithKey("character_ID"):toStr();
        local character_break_item = character_break_cfg:getNodeWithKey(character_ID)
        
        local break_story = character_break_item:getNodeWithKey("break_story" .. self.m_selBreValue)
        if break_story then
            break_story = break_story:toStr();
        else
            break_story = "Không"
        end
        local story_detail = character_break_item:getNodeWithKey("story_detail" .. self.m_selBreValue)
        if story_detail then
            story_detail = story_detail:toStr();
        else
            story_detail = "Không";
        end
        if story_detail ~= "Không" and story_detail ~= "" then
            self.mystroy = story_detail
        else
            self.mystroy = break_story
        end
        
    end

    local tempNode = m_stroy_label_2
    local sc,label = game_util:createMulitLabel(tempNode, {text = self.mystroy ,fontSize = 10,textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(221,221,192)}, true, GLOBAL_TOUCH_PRIORITY  - 100)
    self.stroy_label = label
    local function onTouch( eventType,x,y )
        -- body
        if(eventType == "began")then
            if sc then
                local realPos = tempNode:getParent():convertToNodeSpace(ccp(x,y));
                if tempNode:boundingBox():containsPoint(realPos) then
                    return false
                end
            end
            -- cclog2("  0000000000000000000  ")
            self:back();
            return true;
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-15,true);
    m_root_layer:setTouchEnabled(true);
    local touchLayer = CCLayer:create()
    m_root_layer:addChild(touchLayer)
    local function onTouch( eventType,x,y )
        if(eventType == "began")then
            return true;
        end
    end
    touchLayer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-9,true);
    touchLayer:setTouchEnabled(true);

    self.m_story_label_1 = game_util:createRichLabelTTF({text = "ddd",dimensions = m_stroy_label_1:getContentSize(),textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(221,221,192),fontSize = 10})
    self.m_story_label_1:setAnchorPoint(ccp(0, 0))
    m_stroy_label_1:addChild(self.m_story_label_1)
    -- self.m_story_label_2 = game_util:createRichLabelTTF({text = "ddd",dimensions = m_stroy_label_2:getContentSize(),textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = kCCVerticalTextAlignmentCenter,color = ccc3(221,221,192),fontSize = 12})     
    -- self.m_story_label_2:setAnchorPoint(ccp(0, 0))
    -- m_stroy_label_2:addChild(self.m_story_label_2)
    
    
    return ccbNode;
end
--[[--
    刷新ui
]]
function hero_breakthrough_detail_pop.refreshUi(self)
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local itemCfg = character_detail_cfg:getNodeWithKey(tostring(self.m_cardCfgId));
    if itemCfg then
        local character_break_cfg = getConfig(game_config_field.character_break_new)
        local character_ID = itemCfg:getKey()--itemCfg:getNodeWithKey("character_ID"):toStr();
        local character_break_item = character_break_cfg:getNodeWithKey(character_ID)
        local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kpxq_break_" .. self.m_selBreValue .. ".png")
        if tempSpriteFrame then
            self.m_break_icon:setDisplayFrame(tempSpriteFrame);
        end
        local break_story = character_break_item:getNodeWithKey("break_story" .. self.m_selBreValue)
        if break_story then
            break_story = break_story:toStr();
        else
            break_story = "Không"
        end
        local story_detail = character_break_item:getNodeWithKey("story_detail" .. self.m_selBreValue)
        if story_detail then
            story_detail = story_detail:toStr();
        else
            story_detail = "Không";
        end
        if story_detail ~= "Không" and story_detail ~= "" then
            self.m_ccbNode:runAnimations("anim_1")
            self.m_story_label_1:setString(break_story);
            -- self.stroy_label:setString(story_detail);
        else
            self.m_ccbNode:runAnimations("anim_2")
            self.m_title_label_2:setString("Tăng thuộc tính")
            -- self.stroy_label:setString(break_story);
        end
        self.m_title_label:setString(tostring(breNameTab[self.m_selBreValue]))
        if self.m_selBreValue > self.m_breValue then--未開啟
            local break_control_cfg = getConfig(game_config_field.break_control)
            local break_control_item = break_control_cfg:getNodeWithKey(tostring(self.m_selBreValue))
            if break_control_item then
                local need_level = break_control_item:getNodeWithKey("need_level"):toInt();
                self.m_tips_label:setString(string.format("Điều kiện chuyển sinh: cấp độ đồng đội đạt %d có thể chuyển sinh",need_level))
            end
            self.m_break_icon:setColor(ccc3(81, 81, 81))
        end
    end
end

--[[--
    初始化
]]
function hero_breakthrough_detail_pop.init(self,t_params)
    t_params = t_params or {};
    -- body
    self.m_cardCfgId = t_params.cardCfgId
    self.m_breValue = t_params.breValue or 0;
    if self.m_breValue < 0 then
        self.m_breValue = 0;
    elseif self.m_breValue > 5 then
        -- self.m_breValue = 5;
    end
    self.m_selBreValue = t_params.selBreValue or 0;
    if self.m_selBreValue < 0 then
        self.m_selBreValue = 0;
    elseif self.m_selBreValue > 5 then
        -- self.m_selBreValue = 5;
    end
    self.mystroy = "";
end

--[[--
    创建ui入口并初始化数据
]]
function hero_breakthrough_detail_pop.create(self,t_params)
    -- if self.m_popUi then return end
    self:init(t_params);
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

return hero_breakthrough_detail_pop;