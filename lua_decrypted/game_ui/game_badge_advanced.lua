---  商店

local game_badge_advanced = {
    m_curPage = nil,
    m_ccbNode = nil,

    m_showType = nil,
    m_skill_node = nil,
    m_showData = nil,
    m_detail_lb = nil,
    m_root_layer = nil,
    text_scroll = nil,
    content_node = nil,
    m_selectBadge = nil,
    m_selListItem = nil,
    m_selSkillListItem = nil,
    m_selSortIndex = nil,
    m_list_view_bg = nil,
    m_skill_curPage = nil,
    m_skill_tableView = nil,
    m_selectBadgeSkill = nil,
};

--[[--
    销毁ui
]]
function game_badge_advanced.destroy(self)
    -- body
    self.m_ccbNode = nil;
    self.m_curPage = nil;
    self.m_showData = nil;
    self.m_showType = nil;
    self.m_detail_lb = nil;
    self.m_skill_node = nil;
    self.m_root_layer = nil;
    self.text_scroll = nil;
    self.content_node = nil;
    self.m_selectBadge = nil;
    self.m_selListItem = nil;
    self.m_selSkillListItem = nil;
    self.m_selSortIndex = nil;
    self.m_list_view_bg = nil;
    self.m_skill_curPage = nil;
    self.m_skill_tableView = nil;
    self.m_selectBadgeSkill = nil;
end
--[[--
    返回
]]
function game_badge_advanced.back(self,backType)
    if backType == "back" then
        local function endCallFunc()
            self:destroy();
        end
        game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
    end
end
--[[--
    读取ccbi创建ui
]]
function game_badge_advanced.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then--返回
            self:back("back");
        elseif btnTag == 66 then
            game_scene:addPop("game_badge_type")
        elseif btnTag == 67 then
            if self.m_selectBadge == "" then 
                game_util:addMoveTips({text = string_config:getTextByKey("badge_tx_2")});
                return
            end
            game_scene:addPop("game_badgeFate", {badgeId = self.m_selectBadge})
        elseif btnTag == 101 then
            if self.m_selectBadge == "" then 
                game_util:addMoveTips({text = "Hãy thực hiện thao tác khác sau khi chọn Huy Hiệu"})
                return
            end
            local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_selectBadge)
            local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
            if badge_cfg.badge_level == 7 then 
                game_util:addMoveTips({text = "Huy Hiệu hiện tại đã tiến giai đến cấp cao nhất!"})
                return
            end
            local exp = badgeData.exp
            local nextCfg = game_util:getBadgeByIdCfg(badge_cfg.badge_break)
            local next_cfg = json.decode(nextCfg:getFormatBuffer())
            local need_exp = next_cfg.need_exp or 0


            local function callBack(typeName)
                typeName = typeName or ""
                if typeName == "refresh" then
                    cclog("返回刷新 ---------")
                    local selSort = tostring(BADGE_SORT_TAB[self.m_selSortIndex].sortType);
                    self.m_showData = game_util:getSortBadgeByTtypeName(selSort)
                    self:refreshEquipTableView()
                    self:refreshBadgeInfo(self.m_selectBadge)
                    self:checkIsAdvancedOpenPop()
                end
            end
            local params = {}
            params.badgeId = self.m_selectBadge
            params.callBack = callBack
            if exp >= need_exp then  -- 进阶
                self:checkIsAdvancedOpenPop()
            else -- 增加经验
                game_scene:addPop("game_badge_adv_pop",params);
            end
        elseif btnTag == 102 then
            if self.m_selectBadge == "" then 
                game_util:addMoveTips({text = "Hãy thực hiện thao tác khác sau khi chọn Huy Hiệu"})
                return
            end
            local function callBack(typeName)
                typeName = typeName or ""
                if typeName == "refresh" then
                    cclog("返回刷新 ---------")
                    local selSort = tostring(BADGE_SORT_TAB[self.m_selSortIndex].sortType);
                    self.m_showData = game_util:getSortBadgeByTtypeName(selSort)
                    self:refreshEquipTableView()
                    self:refreshBadgeInfo(self.m_selectBadge)
                end
            end
            local params = {}
            params.badgeId = self.m_selectBadge
            params.callBack = callBack
            game_scene:addPop("game_badge_skill_sel_pop",params)
        elseif btnTag >= 201 and btnTag <= 203 then--排序
            -- cclog("btnCallBack ===========btnTag===" .. btnTag)
            local selSort = tostring(BADGE_SORT_TAB[btnTag-200].sortType);
            self.m_showData = game_util:getSortBadgeByTtypeName(selSort)
            self:refreshSortTabBtn(btnTag-200);
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_badge_advanced.ccbi");
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    self.m_list_view_bg = ccbNode:layerForName("m_list_view_bg")
    self.m_skill_node = ccbNode:nodeForName("skill_node")
    self.m_detail_lb = ccbNode:labelTTFForName("detail_lb")
    self.m_detail_lb:setString("")
    local m_btn1 = ccbNode:controlButtonForName("m_btn1")
    local m_btn2 = ccbNode:controlButtonForName("m_btn2")
    local m_btn3 = ccbNode:controlButtonForName("m_btn3")
    local m_btn4 = ccbNode:controlButtonForName("m_btn4")
    local m_btn5 = ccbNode:controlButtonForName("m_btn5")
    local des_text = ccbNode:labelTTFForName("des_text")
    m_btn1:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    m_btn2:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    m_btn3:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    m_btn4:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    m_btn5:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.content_node = ccbNode:nodeForName("content_node")
    self.text_scroll = ccbNode:scrollViewForName("m_scroll_view_Secret");
    des_text:setString("Thuyết minh quy tắc")
    self.m_ccbNode = ccbNode
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;--intercept event
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-1,true);
    self.m_root_layer:setTouchEnabled(true);

    return ccbNode;
end

--[[--
    刷新ui
]]
function game_badge_advanced.refreshUi(self)
    self.m_showData = game_util:getSortBadgeByTtypeName()
    self:refreshByType(self.m_showType);
    self:refreshBadgeInfo(self.m_selectBadge)
end

function game_badge_advanced:checkIsAdvancedOpenPop( ... )
    local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_selectBadge)
    local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
    if badge_cfg.badge_level == 7 then 
        return
    end
    local exp = badgeData.exp
    local nextCfg = game_util:getBadgeByIdCfg(badge_cfg.badge_break)
    local next_cfg = json.decode(nextCfg:getFormatBuffer())
    local need_exp = next_cfg.need_exp or 0
    if exp >= need_exp then 
        local function callBack(typeName)
            typeName = typeName or ""
            if typeName == "refresh" then
                local selSort = tostring(BADGE_SORT_TAB[self.m_selSortIndex].sortType);
                self.m_showData = game_util:getSortBadgeByTtypeName(selSort)
                self:refreshEquipTableView()
                self:refreshBadgeInfo(self.m_selectBadge)
            end
        end
        local params = {}
        params.badgeId = self.m_selectBadge
        params.callBack = callBack
        game_scene:addPop("game_badge_adv_up_pop",params);
    end
end

function game_badge_advanced.refreshSortTabBtn(self,sortIndex)
    self.m_selSortIndex = sortIndex;
    local tempBtn = nil;
    for i=1,3 do
        tempBtn = self.m_ccbNode:controlButtonForName("m_table_tab_btn_" .. i)
        tempBtn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
        tempBtn:setHighlighted(self.m_selSortIndex == i);
        tempBtn:setEnabled(self.m_selSortIndex ~= i);
    end
    -- self.m_curPage = 1;
    -- self.m_skill_curPage = 1;
    self:refreshEquipTableView()
    
end


function game_badge_advanced:refreshUi1( )
    self:refreshEquipTableView()
end
--[[--
    刷新
]]
function game_badge_advanced.refreshByType(self,showType)
    -- cclog("refreshByType ==============" .. showType);
    self.m_showType = showType;
    if showType == 1 then
        self:refreshSortTabBtn(self.m_selSortIndex);
    end
end

function game_badge_advanced.createBadgeItemCCb(self)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_badge_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    return ccbNode
end

--[[--
    创建徽章列表
]]
function game_badge_advanced.createMagicTableView(self,viewSize,tableData)
    cclog2(self.m_curPage,"self.m_curPage-------22")
    self.m_selListItem = nil;
    local itemsCount = #tableData;
    local totalItem = math.max(itemsCount%4 == 0 and itemsCount or math.floor(itemsCount/4+1)*4,4)
    local talisman = getConfig(game_config_field.talisman);
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;--行
    params.column = 1; --列
    params.direction = kCCScrollViewDirectionVertical;
    params.totalItem = itemsCount--totalItem;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-2;
    params.showPageIndex = self.m_curPage;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = self:createBadgeItemCCb();
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local spr_1 = ccbNode:spriteForName("m_sel_img")
            local spr_2 = ccbNode:spriteForName("spr_2")
            local spr_3 = ccbNode:spriteForName("spr_3")
            local icon_node = ccbNode:nodeForName("icon_node")
            local m_name_label = ccbNode:labelTTFForName("m_name_label")
            local m_max_evo_img = ccbNode:spriteForName("m_max_evo_img")
            spr_1:setVisible(false)
            spr_2:setVisible(false)
            spr_3:setVisible(false)
            m_max_evo_img:setVisible(false)
            local badgeId = tableData[index + 1]
            local badgeData,badgeCfg = game_data:getBadgeDataById(badgeId)
            local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
            local level = badge_cfg.badge_level
            local name = badge_cfg.badge_name
            m_name_label:setString(name .."+" .. tostring(level))
            if level == 7 then 
                m_max_evo_img:setVisible(true)
            end

            local item_icon = game_util:createBadgeIconByCfg(badgeCfg)
            icon_node:removeAllChildrenWithCleanup(true)
            item_icon:setScale(0.8)
            icon_node:addChild(item_icon)
            --是否选中
            if self.m_selectBadge == badgeId then 
                spr_1:setVisible(true)
                self.m_selListItem = cell
            end
            -- 是否装备判断
            if badgeData.owner == "" then 
                spr_2:setVisible(false)
            else
                spr_2:setVisible(true)
                -- 神域判断
                local god_flag = game_data:godheroInTeamById(badgeData.owner)
                if god_flag then 
                    spr_3:setVisible(true)
                else
                    spr_3:setVisible(false)
                end
            end

            local m_node_old = ccbNode:nodeForName("m_node_old")
            local base_up = badge_cfg.base_up
            local attr_info1 = base_up[1]
            local attr_info2 = base_up[2]
            local attr_info3 = base_up[3]
            local value1 = attr_info1[2]
            local value2 = attr_info2[2]
            local value3 = attr_info3[2]
            local value1,unit1 = game_util:formatValueToString2(value1)
            local value2,unit2 = game_util:formatValueToString2(value2)
            local value3,unit3 = game_util:formatValueToString2(value3)
            local icon1 = PUBLIC_ABILITY_TABLE["ability_" .. attr_info1[1]].icon
            local icon2 = PUBLIC_ABILITY_TABLE["ability_" .. attr_info2[1]].icon
            local icon3 = PUBLIC_ABILITY_TABLE["ability_" .. attr_info3[1]].icon
            
            ccbNode:labelBMFontForName("m_label_ability_1"):setString(value1..unit1);
            ccbNode:labelBMFontForName("m_label_ability_2"):setString(value2..unit2);
            ccbNode:spriteForName("m_icon_ability_1"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1));
            ccbNode:spriteForName("m_icon_ability_2"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon2));
            
            m_node_old:stopAllActions();
            local function newFunc(node)
                ccbNode:spriteForName("m_icon_ability_1"):setVisible(true)
                ccbNode:spriteForName("m_label_ability_1"):setVisible(true)
                ccbNode:spriteForName("m_icon_ability_2"):setVisible(true)
                ccbNode:spriteForName("m_label_ability_2"):setVisible(true)
                ccbNode:labelBMFontForName("m_label_ability_1"):setString(value1..unit1);
                ccbNode:labelBMFontForName("m_label_ability_2"):setString(value2..unit2);
                ccbNode:spriteForName("m_icon_ability_1"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1));
                ccbNode:spriteForName("m_icon_ability_2"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon2));
            end
            local function oldFunc(node)
                ccbNode:spriteForName("m_icon_ability_2"):setVisible(false)
                ccbNode:spriteForName("m_label_ability_2"):setVisible(false)
                ccbNode:labelBMFontForName("m_label_ability_1"):setString(value3..unit3);
                ccbNode:spriteForName("m_icon_ability_1"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon3));
            end
            local animArr = CCArray:create();
            animArr:addObject(CCFadeIn:create(1));
            animArr:addObject(CCDelayTime:create(1));
            animArr:addObject(CCFadeOut:create(1));
            animArr:addObject(CCCallFuncN:create(oldFunc));
            animArr:addObject(CCFadeIn:create(1));
            animArr:addObject(CCDelayTime:create(1));
            animArr:addObject(CCFadeOut:create(1));
            animArr:addObject(CCCallFuncN:create(newFunc));
            m_node_old:runAction(CCRepeatForever:create(CCSequence:create(animArr)));
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        if index >= itemsCount then return end;
        if eventType == "ended" and cell then
            local tempId = tableData[index+1]
            if self.m_selectBadge == nil or self.m_selectBadge ~= tempId then
                if self.m_selListItem then
                    local ccbNode = tolua.cast(self.m_selListItem:getChildByTag(10),"luaCCBNode");
                    local m_sel_img = ccbNode:spriteForName("m_sel_img")
                    m_sel_img:setVisible(false);
                end
                self.m_selListItem = cell;
                self.m_selectBadge = tableData[index + 1]
                self.m_selectBadgeSkill = 0
                self:refreshBadgeInfo(self.m_selectBadge)
                local ccbNode = tolua.cast(self.m_selListItem:getChildByTag(10),"luaCCBNode");
                local m_sel_img = ccbNode:spriteForName("m_sel_img")
                m_sel_img:setVisible(true);
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curPage = curPage;
        -- self.m_selListItem = nil;
    end
    return TableViewHelper:create(params);
end

--[[
    设置选中徽章info
]]
function game_badge_advanced.refreshBadgeInfo(self, badgeId )
    local name_node = self.m_ccbNode:nodeForName('name_node')
    local m_tips_spr_1 = self.m_ccbNode:spriteForName("m_tips_spr_1")
    local icon_node = self.m_ccbNode:nodeForName("icon_node")
    
    if badgeId  == "" then 
        name_node:setVisible(false)
        m_tips_spr_1:setVisible(true)
        for i=1,3 do
            local attr = self.m_ccbNode:labelTTFForName("attr_" .. tostring(i))
            attr:setString("--")
        end
        return
    end

    name_node:setVisible(true)
    m_tips_spr_1:setVisible(false)
    local badgeData,badgeCfg = game_data:getBadgeDataById(badgeId)
    cclog2(badgeData,"badgeData-------")
    local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
    local m_name = self.m_ccbNode:labelTTFForName("m_name")
    local level = badge_cfg.badge_level
    local name = badge_cfg.badge_name
    m_name:setString(name .. "+" .. tostring(level))

    local icon = badgeCfg:getNodeWithKey("image_L"):toStr();
    local tempIcon = game_util:createIconByName(icon)
    icon_node:removeAllChildrenWithCleanup(true)
    tempIcon:setScale(1.3)
    icon_node:addChild(tempIcon)

    local attr_1 = self.m_ccbNode:labelTTFForName("attr_1")
    local attr_2 = self.m_ccbNode:labelTTFForName("attr_2")
    local attr_3 = self.m_ccbNode:labelTTFForName("attr_3")
    local skill_spr_1 = self.m_ccbNode:spriteForName('skill_spr_1')
    local skill_spr_2 = self.m_ccbNode:spriteForName('skill_spr_2')
    local skill_spr_3 = self.m_ccbNode:spriteForName('skill_spr_3')

    local base_up = badge_cfg.base_up
    for i=1,#base_up do
        local attr_info = base_up[i]
        local attr = self.m_ccbNode:labelTTFForName("attr_" .. tostring(i))
        local skill_spr = self.m_ccbNode:spriteForName('skill_spr_' .. tostring(i))
        attr:setString(attr_info[2])
        local icon = PUBLIC_ABILITY_TABLE["ability_" .. attr_info[1]].icon
        local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon)
        if tempSpriteFrame then
            skill_spr:setDisplayFrame(tempSpriteFrame)
        end
    end

    self:refreshSkillTableView()
end


--[[--
    刷新徽章列表
]]
function game_badge_advanced.refreshEquipTableView(self)
    self.m_list_view_bg:removeAllChildrenWithCleanup(true);
    self.m_tableView = self:createMagicTableView(self.m_list_view_bg:getContentSize(),self.m_showData);
    self.m_list_view_bg:addChild(self.m_tableView);

     -- 自适应滑动到选定位置
    local _datas = self.m_showData
    local _parent = self.m_list_view_bg
    local m_tableView = self.m_tableView
    local index = 1
    for i=1,#_datas do
        if _datas[i] == tostring(self.m_selectBadge) then
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
    if #self.m_showData >= 5 then 
        m_tableView:setContentOffset(ccp(offset.x, newOffsetY))    
    end
end

--[[--
    刷新列表
]]
local tempTable = {"huizhang_jinjie1.png","huizhang_jinjie2.png",
                    "huizhang_jinjie3.png","huizhang_jinjie4.png",
                    "huizhang_jinjie5.png","huizhang_jinjie6.png",
                    "huizhang_jinjie7.png"}
function game_badge_advanced.refreshSkillTableView(self)
    self.m_skill_node:removeAllChildrenWithCleanup(true);
    
    local showData = {}
    local selectTab = {}
    local not_selectTab = {}
    local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_selectBadge)
    for i,v in ipairs(tempTable) do
        if util.valueInTable(i,badgeData.select_skills) then 
            table.insert(selectTab,i)
        else
            table.insert(not_selectTab,i)
        end
    end
    for i=1,#selectTab do
        table.insert(showData,selectTab[i])
    end
    for i=1,#not_selectTab do
        table.insert(showData,not_selectTab[i])
    end
    self.m_skill_tableView = self:createSkillTableView(self.m_skill_node:getContentSize(),showData);
    self.m_skill_node:addChild(self.m_skill_tableView);


      -- 自适应滑动到选定位置
    local _datas = showData
    local _parent = self.m_skill_node
    local m_tableView = self.m_skill_tableView
    local index = 1
    if self.m_selectBadgeSkill == 0 then 
        return
    end
    for i=1,#_datas do
        if i == self.m_selectBadgeSkill then
            index = i
            break
        end
    end
    local offset = m_tableView:getContentOffset()
    local viewSize = _parent:getContentSize()
    local totalItem = #_datas
    local column = 5
    local row = 1
    local itemSize = CCSizeMake(viewSize.width / column, viewSize.height / row)
    -- 计算新的偏移量
    local newOffsetX = 0 + viewSize.width - (totalItem - index + 1) * itemSize.width
    -- 边界判断
    local minOffsetX = -((totalItem - row) * itemSize.width)  -- 最小偏移量（列表滚动到底部）
    local maxOffsetX = 0  -- 最大偏移量（列表滚动到顶部）
    -- 确保 newOffsetY 在有效范围内
    if newOffsetX < minOffsetX then
        newOffsetX = minOffsetX
    elseif newOffsetX > maxOffsetX then
        newOffsetX = maxOffsetX
    end
    -- 设置新的偏移量
    if self.m_selectBadgeSkill > 5 then 
        m_tableView:setContentOffset(ccp(-100, offset.y))
    else
        m_tableView:setContentOffset(ccp(0, offset.y))
    end
    
end

function game_badge_advanced.createBadgeSkillItemCCb(self)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_badge_skill_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    return ccbNode
end

--[[--
    创建技能列表
]]
function game_badge_advanced.createSkillTableView(self,viewSize,tableData)
    self.m_selSkillListItem = nil
    local itemsCount = #tableData;
    local talisman = getConfig(game_config_field.talisman);
    local params = {};
    params.viewSize = viewSize;
    params.row = 1;--行
    params.column = 5; --列
    params.direction = kCCScrollViewDirectionHorizontal;
    params.totalItem = itemsCount;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-2;
    params.showPageIndex = self.m_skill_curPage;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = self:createBadgeSkillItemCCb();
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local skill_icon = ccbNode:spriteForName("skill_icon")
            local spr_sel = ccbNode:spriteForName("spr_sel")
            local label_text = ccbNode:spriteForName("label_text")
            -- label_text:setColor(ccc3(100,100,100))
            local m_sel_img = ccbNode:spriteForName("m_sel_img")
            spr_sel:setVisible(false)
            m_sel_img:setVisible(false)
            skill_icon:setColor(ccc3(100,100,100))
            local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_selectBadge)
            local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
            local m_name = self.m_ccbNode:labelTTFForName("m_name")
            local level = badge_cfg.badge_level
            if level >= tableData[index + 1] then 
                label_text:setVisible(false)
            else
                label_text:setVisible(true)
            end
            local icon = tempTable[tableData[index + 1]]
            local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tostring(icon))
            if tempSpriteFrame then
                skill_icon:setDisplayFrame(tempSpriteFrame)
            end

            if self.m_selectBadgeSkill and self.m_selectBadgeSkill == tableData[index + 1] then 
                m_sel_img:setVisible(true)
                self.m_selSkillListItem = cell
            end

            if util.valueInTable(tableData[index + 1],badgeData.select_skills) then 
                spr_sel:setVisible(true)
                skill_icon:setColor(ccc3(255,255,255))
            else
                spr_sel:setVisible(false)
            end

        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        if index >= itemsCount then return end;
        if eventType == "ended" and cell then
            if self.m_selectBadgeSkill == nil or self.m_selectBadgeSkill ~= tableData[index + 1] then
                if self.m_selSkillListItem then
                    local ccbNode = tolua.cast(self.m_selSkillListItem:getChildByTag(10),"luaCCBNode");
                    local m_sel_img = ccbNode:spriteForName("m_sel_img")
                    m_sel_img:setVisible(false);
                end
                self.m_selSkillListItem = cell;
                self.m_selectBadgeSkill = tableData[index + 1]
                self:refreshSkillDes()
                local ccbNode = tolua.cast(self.m_selSkillListItem:getChildByTag(10),"luaCCBNode");
                local m_sel_img = ccbNode:spriteForName("m_sel_img")
                m_sel_img:setVisible(true);
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_skill_curPage = curPage;
        -- self.m_selListItem = nil;
    end
    return TableViewHelper:create(params);
end

function game_badge_advanced:refreshSkillDes( )
    local index = self.m_selectBadgeSkill
    local tempCfg = {}
    local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_selectBadge)
    local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
    local level = badge_cfg.badge_level
    local init_id = badgeData.c_id - level + 1
    local cfg = getConfig(game_config_field.badge);

    for i=init_id,init_id + 6 do
        local cfg_info = cfg:getNodeWithKey(tostring(i))
        local cfg_info = json.decode(cfg_info:getFormatBuffer());
        local skill_story = cfg_info.skill_story
        table.insert(tempCfg,skill_story)
    end

    self.content_node:removeAllChildrenWithCleanup(true)
    local txt = tempCfg[index]
    local labelSize = self.content_node:getContentSize()
    local node = self:createScrollLabel(CCSizeMake(labelSize.width - 10, labelSize.height - 5), {text = txt}, GLOBAL_TOUCH_PRIORITY - 2)
    if node then
        self.content_node:addChild(node)
    end
end

function game_badge_advanced.createScrollLabel(self, boardSize, params, touchPriority)
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
            color = ccc3(247,222,154),
            fontSize = 10
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



--[[--
    初始化
]]
function game_badge_advanced.init(self,t_params)
    t_params = t_params or {};
    self.m_showType = 1;
    self.m_curPage = 1;
    self.m_skill_curPage = 1;
    self.m_selSortIndex = 1;
    self.m_selectBadge = ""
    self.m_selectBadgeSkill = 0
    -- body
end

--[[--
    创建ui入口并初始化数据
]]
function game_badge_advanced.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    return scene;
end

return game_badge_advanced;8s  