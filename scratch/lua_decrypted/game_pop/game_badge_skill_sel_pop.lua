--- 公会消息详细

local game_badge_skill_sel_pop = {
    m_node_list = nil,
    m_curPage = nil,
    content_node = nil,
    m_popUi = nil,
    m_tParams = nil,
    m_label_tps = nil,
    m_callBack = nil,
    m_root_layer = nil,
    m_selListItem = nil,
    m_badgeSkillCfg = nil,
    m_tab_skillId = nil,
    m_selectSkillIndex = nil,
};
--[[--
    销毁
]]
function game_badge_skill_sel_pop.destroy(self)
    -- body
    cclog("-----------------game_badge_skill_sel_pop destroy-----------------");
    self.m_popUi = nil;
    self.m_tParams = nil;
    self.m_curPage = nil;
    self.m_label_tps = nil;
    self.content_node = nil;
    self.m_node_list = nil;
    self.m_root_layer = nil;
    self.m_callBack = nil;
    self.m_tab_skillId = nil;
    self.m_selListItem = nil;
    self.m_badgeSkillCfg = nil;
    self.m_selectSkillIndex = nil;

end
--[[--
    返回
]]
function game_badge_skill_sel_pop.back(self,type)
    game_scene:removePopByName("game_badge_skill_sel_pop");
end
--[[--
    读取ccbi创建ui
]]
function game_badge_skill_sel_pop.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        
        if btnTag == 1 then
            self:back()
        elseif btnTag == 101 then
            local function responseMethod(tag, gameData)
                if self.m_callBack and type(self.m_callBack) == "function" then
                    self.m_callBack("refresh");
                end
                self:back()
            end
            local selskill = {}
            for k,v in pairs(self.m_tab_skillId) do
                if k then
                    table.insert(selskill,v)
                end
            end
            local params = {}
            params.badge_id = self.m_badgeId
            params.skill_ids = table.concat(selskill,"_")
            network.sendHttpRequest(responseMethod, game_url.getUrlForKey("badge_select_skill"), http_request_method.GET,params,"badge_select_skill")
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
    ccbNode:openCCBFile("ccb/ui_badge_skill_sel_pop.ccbi");
    self.m_ccbNode = ccbNode
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    self.m_node_list = ccbNode:nodeForName("node_list")
    self.m_label_tps = ccbNode:labelTTFForName("label_tps")
    self.m_label_tps:setString("Sau khi nhấn 1 kĩ năng ở bên phải, hiệu quả cường hóa sẽ được hiển thị ở khu vực này")
    local m_close_btn = ccbNode:controlButtonForName("m_close_btn")
    local m_ok_btn = ccbNode:controlButtonForName("m_ok_btn")
    m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-6)
    m_ok_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-6)
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;--intercept event
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-5,true);
    self.m_root_layer:setTouchEnabled(true);
    self.content_node = ccbNode:nodeForName("content_node")
    self.content_node:setVisible(false)
    return ccbNode;
end

--[[--
    刷新ui
]]
function game_badge_skill_sel_pop.refreshUi(self)
    self:setBadgeSkillCfg()
    self:initBadgeInfo()
    self:refreshSkillTableView()
end

function game_badge_skill_sel_pop:initBadgeInfo( ... )
    local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_badgeId)
    local m_name = self.m_ccbNode:labelTTFForName("m_name")
    local icon_node = self.m_ccbNode:nodeForName("icon_node")
    -- local item_icon = game_util:createBadgeIconByCfg(badgeCfg)
    -- icon_node:removeAllChildrenWithCleanup(true)
    local icon = badgeCfg:getNodeWithKey("image_L"):toStr();
    local tempIcon = game_util:createIconByName(icon)
    tempIcon:setScale(1.3)
    icon_node:addChild(tempIcon)

    local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
    local level = badge_cfg.badge_level
    local name = badge_cfg.badge_name
    m_name:setString(name .. "+" .. tostring(level))
end
--[[--
    刷新列表
]]
function game_badge_skill_sel_pop.refreshSkillTableView(self)
    self.m_node_list:removeAllChildrenWithCleanup(true);
    local showData = self.m_badgeSkillCfg

    local tableView = self:createSkillTableView(self.m_node_list:getContentSize(),showData);
    self.m_node_list:addChild(tableView);
end

--[[--
    创建材料列表
]]
function game_badge_skill_sel_pop.createSkillTableView(self,viewSize,tableData)
    local imgTickTab = {}
    local function onMainBtnClick(target,event)
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();

        local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_badgeId)
        local select_skills = badgeData.select_skills or {}
        local isUnlock = self:getIsSelectSkill(btnTag)
        if isUnlock then -- 解锁
            local skill_num = badgeCfg:getNodeWithKey("skill_num"):toInt();
            if self.m_tab_skillId[tostring(btnTag)] then
                self.m_tab_skillId[tostring(btnTag)] = nil
            elseif game_util:getTableLen(self.m_tab_skillId) < skill_num then
                self.m_tab_skillId[tostring(btnTag)] = btnTag
            else
                self.m_tab_skillId[tostring(btnTag)] = nil
            end
            for i=1,7 do
                imgTickTab[i]:setVisible(false)
                if self.m_tab_skillId[tostring(i)] and self.m_tab_skillId[tostring(i)] ~= 0 then
                    imgTickTab[i]:setVisible(true)
                end
            end
            cclog2(self.m_tab_skillId,"self.m_tab_skillId--111222")
        else -- 未解锁

            game_util:addMoveTips({text = string.format("Kĩ năng này chưa mở khóa, cần Tiến Giai + %d mở khóa",btnTag)})
        end
    end

    local itemsCount = #tableData;
    local talisman = getConfig(game_config_field.talisman);
    local params = {};
    params.viewSize = viewSize;
    params.row = 7;--行
    params.column = 1; --列
    params.direction = kCCScrollViewDirectionVertical;
    params.totalItem = itemsCount;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-6;
    params.showPageIndex = self.m_skill_curPage;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create()
            ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick)
            ccbNode:openCCBFile("ccb/ui_badge_skill_sel_item.ccbi")
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local sel_kuang = ccbNode:controlButtonForName("sel_kuang")
            local skill_name = ccbNode:labelTTFForName("skill_name")
            local sel_duihao = ccbNode:spriteForName("sel_duihao")
            local skill_select = ccbNode:spriteForName("skill_select")
            local unlock_node = ccbNode:spriteForName("unlock_node")

            skill_select:setVisible(false)
            sel_kuang:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 13)
            sel_kuang:setTag(index+1)
            skill_name:setString(tableData[index+1].name)
            if self.m_selectSkillIndex == index + 1 then 
                skill_select:setVisible(true)
                self.m_selListItem = cell
            end
            imgTickTab[index + 1] = sel_duihao
            if self:getIsSelectSkill(index + 1) then 
                unlock_node:setVisible(false)
            else
                unlock_node:setVisible(true)
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        if index >= itemsCount then return end;
        if eventType == "ended" and cell then
            cclog2(index,"index-----111222")
            if self.m_selectSkillIndex == 0 or self.m_selectSkillIndex ~= index + 1 then
                if self.m_selListItem then
                    local ccbNode = tolua.cast(self.m_selListItem:getChildByTag(10),"luaCCBNode");
                    local skill_select = ccbNode:spriteForName("skill_select")
                    skill_select:setVisible(false);
                end
                self.m_selListItem = cell;
                self.m_selectSkillIndex = index + 1
                self:refreshSkillDes()
                local ccbNode = tolua.cast(self.m_selListItem:getChildByTag(10),"luaCCBNode");
                local skill_select = ccbNode:spriteForName("skill_select")
                skill_select:setVisible(true);
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curPage = curPage;
        -- self.m_selListItem = nil;
    end
    return TableViewHelper:create(params);
end

function game_badge_skill_sel_pop:getIsSelectSkill( skill_id )
    local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_badgeId)
    local skills = badgeData.skills or {}
    return util.valueInTable(skill_id,skills)

end

function game_badge_skill_sel_pop:refreshSkillDes( ... )
    local cfg = self.m_badgeSkillCfg[self.m_selectSkillIndex]
    -- self.m_label_tps:setString(cfg.story)

    self.content_node:removeAllChildrenWithCleanup(true)
    local txt = cfg.story
    local labelSize = self.content_node:getContentSize()
    local node = self:createScrollLabel(CCSizeMake(labelSize.width - 4, labelSize.height - 3), {text = txt}, GLOBAL_TOUCH_PRIORITY - 6)
    if node then
        self.content_node:addChild(node)
        self.content_node:setVisible(true)
        self.m_label_tps:setVisible(false)
    end
end

function game_badge_skill_sel_pop.createScrollLabel(self, boardSize, params, touchPriority)
    params = params or {}
    if not boardSize then
        return
    end
    local scrollView = CCScrollView:create(boardSize)
    scrollView:setDirection(kCCScrollViewDirectionVertical)
    scrollView:getContainer():removeAllChildrenWithCleanup(true)
    scrollView:setTouchEnabled(true)
    if touchPriority then
        scrollView:setTouchPriority(touchPriority)
    end
    local text = params.text or ""
    local tempLabel =
        game_util:createRichLabelTTF(
        {
            text = text,
            dimensions = CCSizeMake(boardSize.width, 0),
            textAlignment = kCCTextAlignmentLeft,
            verticalTextAlignment = kCCVerticalTextAlignmentCenter,
            color = ccc3(72,216,30),
            fontSize = 8
        }
    )
    local tempSize = tempLabel:getContentSize()
    tempLabel:setAnchorPoint(ccp(0, 0.99))
    tempLabel:setPosition(ccp(0, 0))
    scrollView:setContentSize(CCSizeMake(boardSize.width + 15, tempSize.height))
    scrollView:setContentOffset(ccp(0, boardSize.height - tempSize.height), false)
    scrollView:addChild(tempLabel, 0, 998)
    return scrollView
end


function game_badge_skill_sel_pop:setBadgeSkillCfg( ... )
    local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_badgeId)
    local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
    local level = badge_cfg.badge_level
    local init_id = badgeData.c_id - level + 1
    local cfg = getConfig(game_config_field.badge);
    local tempCfg = {}
    for i=init_id,init_id + 6 do
        local _cfg = {}
        local cfg_info = cfg:getNodeWithKey(tostring(i))
        local cfg_info = json.decode(cfg_info:getFormatBuffer());
        local skill_story = cfg_info.skill_story
        local skill_story = cfg_info.skill_story
        _cfg.name = cfg_info.skill_name or ""
        _cfg.story = cfg_info.skill_story or ""
        table.insert(tempCfg,_cfg)
    end
    self.m_badgeSkillCfg = tempCfg
end

--[[--
    初始化
]]
function game_badge_skill_sel_pop.init(self,t_params)
    self.m_tParams = t_params or {};
    self.m_curPage = 1
    self.m_callBack = self.m_tParams.callBack;
    self.m_badgeId = self.m_tParams.badgeId;
    self.m_selectSkillIndex = 0
    self.m_tab_skillId = {}
end

--[[--
    创建ui入口并初始化数据
]]
function game_badge_skill_sel_pop.create(self,t_params)
    self:init(t_params);
    self.m_tParams = t_params;
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

--[[--
    回调方法
]]
function game_badge_skill_sel_pop.callBackFunc(self,typeName,t_params)
    local callBackFunc = self.m_tParams.callBackFunc;
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc(typeName,t_params);
    end
end

return game_badge_skill_sel_pop;   �2