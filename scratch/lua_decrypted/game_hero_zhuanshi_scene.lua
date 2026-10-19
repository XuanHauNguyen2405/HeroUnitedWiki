--转世
local game_hero_zhuanshi_scene = {
	m_ccbNode = nil,
	m_tGameData = nil,
	m_back_btn = nil,
	m_sel_card = nil,
	m_animTable = {},
	m_selectd_sp = nil,
    m_gachaAnimTab = nil,
    m_animNode = nil,
    m_anim_node = nil,
    m_skill_node = nil,
    m_super_skill_node = nil,
    m_zhuanshi_btn = nil,
    m_mask_layer = nil,
    m_skill_detail = nil,
    m_character_detail = nil,
    m_cardId = nil,
    m_c_id = nil,
    m_cardCfg = nil,
}

function game_hero_zhuanshi_scene:destroy()
    cclog("---------- game_hero_zhuanshi_scene destroy ----------------------")
	self.m_ccbNode = nil;
	self.m_tGameData = nil;
	self.m_back_btn = nil;
	self.m_sel_card = nil;
	self.m_selectd_sp = nil;
	self.m_animTable = {};
    self.m_gachaAnimTab = nil;


    self.m_animNode = nil;
    self.m_anim_node = nil;
    self.m_skill_node = nil;
    self.m_super_skill_node = nil;
    self.m_zhuanshi_btn = nil;
    self.m_mask_layer = nil;
    self.m_skill_detail = nil;
    self.m_character_detail = nil;
    self.m_cardId = nil;
    self.m_c_id = nil;
    self.m_cardCfg = nil;
end

local position_XY = {
    positionX_1 = {0.5},
    positionX_2 = {0.3 ,0.7},
    positionX_3 = {0.25 ,0.5 ,0.75},
    positionX_4 = {0.2 ,0.4 ,0.6 ,0.8},
    positionX_5 = {0.1 ,0.3 ,0.5 ,0.7 ,0.9 },
}


function game_hero_zhuanshi_scene:back()
    game_scene:addPop("ui_zhuanshi_select_pop",{id = self.m_cardId})
end


function game_hero_zhuanshi_scene:createUi()
	local ccbNode = luaCCBNode:create()
	self.m_ccbNode = ccbNode
	local function onMainBtnClick(target,event)
		local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then
        	self:back()
        elseif btnTag == 2 then
            local function responseMethod( tag,gameData )
                game_util:addMoveTips({text = "Đã chuyển sinh"});
               local data = gameData:getNodeWithKey("data")
               local _client_cache_update = data:getNodeWithKey("_client_cache_update") 
               local cards = _client_cache_update:getNodeWithKey("cards")
               local cards1 = cards:getNodeWithKey("cards")
               local update = cards1:getNodeWithKey("update")
               update = json.decode(update:getFormatBuffer())
               local id  = nil;
               local heroData = {}
               for k,v in pairs(update) do
                   id = k
                   heroData = v
               end
               self:createFirstHeroAnim(id);
               self.m_anim_node:setVisible(false);
               self:addGachaAnim();
               game_data:setTeamByJsonData(data:getNodeWithKey("alignment"));
            end
            local params = {}
            params.major = self.m_cardId
            params.afterlife_id = self.m_c_id
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_card_world"), http_request_method.GET, params,"cards_card_world")
        end
	end
	ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick)
	ccbNode:openCCBFile("ccb/ui_hero_zhuanshi_show_pop.ccbi")
    self.m_animNode = ccbNode:nodeForName("animNode")
    self.m_anim_node = ccbNode:nodeForName("m_anim_node")
    self.m_skill_node = ccbNode:nodeForName("m_skill_node")
    self.m_super_skill_node = ccbNode:nodeForName("m_super_skill_node")
    self.m_zhuanshi_btn = ccbNode:controlButtonForName("m_zhuanshi_btn")

    local function onTouch2(eventType, x, y)
        if eventType == "began" then
            self:removeGachaAnim()
            --self.m_anim_node:removeAllChildrenWithCleanup(true)
            local function responseMethod(tag,gameData)
                game_scene:enterGameUi("game_hero_zhuanshi",{gameData = nil,dispatch_data = gameData});
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("offline_dispatch_index"), http_request_method.GET, nil,"offline_dispatch_index")
        end
    end
    self.m_mask_layer = ccbNode:layerColorForName("m_mask_layer")
    self.m_mask_layer:setVisible(false);
    self.m_mask_layer:registerScriptTouchHandler(onTouch2,false,GLOBAL_TOUCH_PRIORITY-20,true);
    self.m_mask_layer:setTouchEnabled(false)


	return ccbNode
end


function game_hero_zhuanshi_scene:getCardIdByfamousId(famousId)
	local Tempfamous = self.famous:getNodeWithKey(tostring(famousId))
	local tempTab = json.decode(Tempfamous:getNodeWithKey("card_id"):getFormatBuffer())
	local tempTab1 = {}
	for k,v in pairs(tempTab) do
		tempTab1[tostring(v)] = 1
	end
	return tempTab[1],tempTab,tempTab1
end


function game_hero_zhuanshi_scene.createBreakTable(self, viewSize, maxBreak,currentBreak)
    maxBreak = maxBreak or 5;
    currentBreak = currentBreak or 0;
    local params = {};
    params.viewSize = viewSize;
    params.row = 1;
    params.column = 5; --列
    params.totalItem = maxBreak;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-12;
    params.showPoint = false
    params.itemActionFlag = false;
    params.direction = kCCScrollViewDirectionHorizontal;--纵向
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local ccbNode = luaCCBNode:create()            
            ccbNode:openCCBFile("ccb/ui_hero_breakthrough_item.ccbi")
            ccbNode:setAnchorPoint(ccp(0.5,0.5))
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            ccbNode:setScale(0.8)
            local m_break_icon = ccbNode:spriteForName("m_break_icon")
            local m_break_label = ccbNode:labelTTFForName("m_break_label")
            local m_break_sel_spr = ccbNode:spriteForName("m_break_sel_spr")
            -- m_break_sel_spr:setVisible(currentBreak == index)
            local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kpxq_break_" .. (index+1) .. ".png")
            if tempSpriteFrame then
                m_break_icon:setDisplayFrame(tempSpriteFrame);
            end
            local tempStr = game_util:convertNum2Chinese(index+1)
            m_break_label:setString(tostring(tempStr) .. "Chuyển")
            if index < currentBreak then
                m_break_icon:setColor(ccc3(255, 255, 255));
                m_break_label:setColor(ccc3(255, 255, 255));
            else
                m_break_icon:setColor(ccc3(81, 81, 81));
                m_break_label:setColor(ccc3(81, 81, 81));
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            if self.m_c_id then
                game_scene:addPop("hero_breakthrough_detail_pop",{cardCfgId = self.m_c_id,breValue = 0,selBreValue = index+1})
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
    end
    return TableViewHelper:create(params);
end

function game_hero_zhuanshi_scene.refreshBreakTable(self)
    -- if not game_data:isViewOpenByID( 44 ) then--转生开关
    --     return
    -- end
    local character_break_cfg = getConfig(game_config_field.character_break_new)
    local character_break_item = character_break_cfg:getNodeWithKey(self.m_c_id)
    local high_break = character_break_item:getNodeWithKey("high_break")
    high_break = high_break and high_break:toInt() or 5


    local m_bre_list_view_bg = self.m_ccbNode:nodeForName("m_bre_list_view_bg")
    m_bre_list_view_bg:removeAllChildrenWithCleanup(true)
    local tempTableView = self:createBreakTable(m_bre_list_view_bg:getContentSize(), high_break,0)
    m_bre_list_view_bg:addChild(tempTableView)
end
function game_hero_zhuanshi_scene.removeGachaAnim(self)
    self.m_mask_layer:removeAllChildrenWithCleanup(true);
    self.m_gachaAnimTab = {};
end

--[[--
    创建
]]
function game_hero_zhuanshi_scene.addGachaAnim(self)
    self:removeGachaAnim();
    self.m_mask_layer:setVisible(true);
    local animFile = "gacha_anim_3";
    local m_iAnim = zcAnimNode:create(animFile .. ".swf.sam",0,animFile .. ".plist");
    local function animEnd(animNode,theId,lableName)
        if lableName == "daiji" then

        elseif lableName == "xunhuan" then
            animNode:playSection("xunhuan");
        elseif lableName == "fanpai" then
            game_sound:playUiSound("gacha")
            self.m_anim_node:setVisible(true);
            self.m_mask_layer:setTouchEnabled(true)
            animNode:playSection("xunhuan");
        end
    end
    m_iAnim:registerScriptTapHandler(animEnd);
    m_iAnim:playSection("daiji");
    m_iAnim:setScale(1);
    local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    m_iAnim:setPosition(ccp(visibleSize.width*0.9, visibleSize.height*0.1))
    local function animEndCallFunc()
        m_iAnim:playSection("fanpai");
    end
    local animArr = CCArray:create();
    animArr:addObject(CCMoveTo:create(0.1,ccp(visibleSize.width*0.5, visibleSize.height*0.5)));
    animArr:addObject(CCCallFunc:create(animEndCallFunc));
    m_iAnim:runAction(CCSequence:create(animArr));
    self.m_mask_layer:addChild(m_iAnim,10,10);
    self.m_gachaAnimTab[#self.m_gachaAnimTab+1] = m_iAnim
end



function game_hero_zhuanshi_scene.createFirstHeroAnim(self,cardId)
    self.m_anim_node:removeAllChildrenWithCleanup(true);
        local cardData,heroCfg = game_data:getCardDataById(tostring(cardId));
        if heroCfg == nil then return end

        local animNode = game_util:createHeroListItemByCCB(cardData);
        if animNode then
            self.m_anim_node:addChild(animNode);
        end
end


function game_hero_zhuanshi_scene:refreshSkill()
    local skill = {}
    for i=1,7 do
        if i ~= 4 and i ~= 5 then
            local tempS = self.m_cardCfg:getNodeWithKey("skill_" .. i .. "_source")
            tempS = tempS and json.decode(tempS:getFormatBuffer())
            if tempS[1] then
                skill[#skill+1] = tempS
            end
        end
    end
    local positionX = position_XY["positionX_" .. #skill]
    self.m_skill_node:removeAllChildrenWithCleanup(true)
    local viewSize = self.m_skill_node:getContentSize()
    for i=1,#skill do
        local tempSkill = skill[i][1]
        --createSkillIconByCfg
        local tempCCB = luaCCBNode:create()
        local function onMainBtnClick(target,event)
            local tagNode = tolua.cast(target, "CCNode");
            local btnTag = tagNode:getTag();
            local skill_id = btnTag - 1000
            local tempTab = {avail=0,lv = 1, s = skill_id,exp = 0 }
            game_scene:addPop("skills_activation_pop",{skillData = tempTab}) 
        end
        tempCCB:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick)
        tempCCB:openCCBFile("ccb/ui_new_hero_skill_icon.ccbi")
        tempCCB:setPosition(ccp(viewSize.width*positionX[i],viewSize.height*0.5))
        tempCCB:setAnchorPoint(ccp(0.5,0.5))
        self.m_skill_node:addChild(tempCCB)
        local skill_node = tempCCB:nodeForName("m_skill_node")
        local m_skill_name = tempCCB:labelTTFForName("m_skill_name")
        local m_skill_btn = tempCCB:controlButtonForName("m_skill_btn")
        m_skill_btn:setTag(tonumber(tempSkill[1])+1000)
        m_skill_btn:setOpacity(0)
        local skillCfg = self.m_skill_detail:getNodeWithKey(tostring(tempSkill[1]))
        if skillCfg then
            m_skill_name:setString(skillCfg:getNodeWithKey("skill_name"):toStr())
            local icon = game_util:createSkillIconByCfg(skillCfg)
            if icon then
                icon:setScale(0.7)
                skill_node:addChild(icon)
            end
        end
    end
end
function game_hero_zhuanshi_scene:refreshSuperSkill()
    local skill = {}
    for i=4,5 do
        local tempS = self.m_cardCfg:getNodeWithKey("skill_" .. i .. "_source")
        tempS = tempS and json.decode(tempS:getFormatBuffer())
        if tempS[1] then
            skill[#skill+1] = tempS
        end
    end
    local positionX = position_XY["positionX_" .. #skill]
    self.m_super_skill_node:removeAllChildrenWithCleanup(true)
    local viewSize = self.m_super_skill_node:getContentSize()
    for i=1,#skill do
        local tempSkill = skill[i][1]
        --createSkillIconByCfg
        local tempCCB = luaCCBNode:create()
        local function onMainBtnClick(target,event)
            local tagNode = tolua.cast(target, "CCNode");
            local btnTag = tagNode:getTag();
            local skill_id = btnTag - 1000
            local tempTab = {avail=0,lv = 1, s = skill_id,exp = 0 }
            game_scene:addPop("skills_activation_pop",{skillData = tempTab}) 
        end
        tempCCB:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick)
        tempCCB:openCCBFile("ccb/ui_new_hero_skill_icon.ccbi")
        tempCCB:setPosition(ccp(viewSize.width*positionX[i],viewSize.height*0.5))
        tempCCB:setAnchorPoint(ccp(0.5,0.5))
        self.m_super_skill_node:addChild(tempCCB)
        local skill_node = tempCCB:nodeForName("m_skill_node")
        local m_skill_name = tempCCB:labelTTFForName("m_skill_name")
        local m_skill_btn = tempCCB:controlButtonForName("m_skill_btn")
        m_skill_btn:setTag(tonumber(tempSkill[1])+1000)
        m_skill_btn:setOpacity(0)
        local skillCfg = self.m_skill_detail:getNodeWithKey(tostring(tempSkill[1]))
        if skillCfg then
            m_skill_name:setString(skillCfg:getNodeWithKey("skill_name"):toStr())
            local icon = game_util:createSkillIconByCfg(skillCfg)
            if icon then
                icon:setScale(0.7)
                skill_node:addChild(icon)
            end
        end
    end
end

function game_hero_zhuanshi_scene:refreshUi()
    self:refreshBreakTable()
	self:refreshSkill()
    self:refreshSuperSkill()
    local anim = game_util:createIdelAnim(self.m_cardCfg:getNodeWithKey("animation"):toStr())
    if anim then
        anim:setScale(1)
        -- local function onAnimSectionEnd( animNode, theId,theLabelName )
        --      animNode:playSection(theLabelName);
        -- end
        -- local anim_eff = game_util:createEffectAnim("zhujue_daiji",1,true);
        -- anim_eff:setAnchorPoint(ccp(0.5,0))
        -- anim_eff:setPositionY(-70)
        -- anim_eff:setScale(1.2)
        -- anim_eff:registerScriptTapHandler(onAnimSectionEnd)
        -- anim_eff:playSection("impact");
        -- self.m_animNode:addChild(anim_eff,1,1)
        self.m_animNode:addChild(anim,2,2)
        anim:setAnchorPoint(ccp(0.5,0))
    end
end

function game_hero_zhuanshi_scene:init(t_params)
    self.m_gachaAnimTab = {}
    self.m_skill_detail = getConfig(game_config_field.skill_detail)
    self.m_character_detail = getConfig(game_config_field.character_detail)

	local t_params = t_params or {}
	self.m_cardId = t_params.selId
	self.m_c_id = t_params.c_id
	self.m_cardCfg = t_params.cardCfg
	if not self.m_cardCfg then
		self.m_cardCfg = self.m_character_detail:getNodeWithKey(tostring(self.m_c_id))
	end
end

function game_hero_zhuanshi_scene:create(t_params)
	self:init(t_params)
	local scene = CCScene:create()
	scene:addChild(self:createUi())
	self:refreshUi()
	return scene
end
return game_hero_zhuanshi_scene