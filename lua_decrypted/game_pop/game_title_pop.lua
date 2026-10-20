--- 称号
local game_title_pop = {
    m_selectType = 1,
    _titleList = nil
}


function game_title_pop.destroy(self)
    cclog("[称号] destroy")
    self.m_rootNode = nil
    self.m_tParams = nil
    self.m_selectType = 1
    self.cfg = nil
    self._titleList = nil
end

function game_title_pop.back(self, type)
    cclog("[称号] back")
    game_scene:removePopByName("game_title_pop")
    self:destroy()
end

function game_title_pop.createUi(self)
    local ccbNode = luaCCBNode:create()
    local function onMainBtnClick(target, event)
        local tagNode = tolua.cast(target, "CCNode")
        local btnTag = tagNode:getTag()
        if self.m_flag == true then
            return
        end

        if btnTag == 999 then
            self:back()
        elseif btnTag == 1 then -- 佩戴
            local all_titile = game_data:getAllTitle()
            if self.m_selTitleData then
                local titleVld = all_titile[tostring(self.m_selTitleData.id)]
                if titleVld then
                    local userStatusData = game_data:getUserStatusData();
                    if tostring(userStatusData.cur_title) == tostring(self.m_selTitleData.id) then
                        return game_util:addMoveTips({text = "Đã Đeo"});
                    end

                    local server_time = math.floor(game_data:getUserStatusDataByKey("server_time") or 0)
                    if titleVld == - 1 then
                        self:useTitle()
                    else
                        local cur_time = titleVld - server_time
                        if cur_time > 0 then
                            self:useTitle()
                        else
                            game_util:addMoveTips({text = "Đã Hết Hạn"});
                        end
                    end
                else
                    game_util:addMoveTips({text = "Chưa Nhận"});
                end
            end

        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick", onMainBtnClick)
    ccbNode:openCCBFile("ccb/ui_title_pop.ccbi")
    self.ccbNode = ccbNode
    self.m_root_layer = ccbNode:layerForName("m_root_layer")

    self.m_ccbNode = ccbNode

    self.m_titles_node = ccbNode:nodeForName("m_titles_node") -- 称号列表
    self.m_des_label = ccbNode:labelTTFForName("m_des_label") -- 称号描述
    self.m_attr_labels = {}
    for i=1,3 do
        self.m_attr_labels[i] = ccbNode:labelTTFForName("m_attr_label"..i) -- 称号属性
        self.m_attr_labels[i]:setVisible(false)
    end

    self.m_target_label = ccbNode:labelTTFForName("m_target_label") -- 称号佩戴条件
    self.m_time_tips_label = ccbNode:labelTTFForName("m_time_tips_label") -- 称号有效期
    self.m_time_tips_label:setString("Thời gian hết hạn:")
    self.countdown_label = ccbNode:labelTTFForName("countdown_label") -- 称号倒计时
    self.m_drees_btn = ccbNode:controlButtonForName("m_drees_btn") -- 佩戴按钮
    self.m_close_btn = ccbNode:controlButtonForName("m_close_btn") 

    self.m_drees_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 12)
    self.m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 12)
    local m_root_layer = ccbNode:layerForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY - 11,true);
    m_root_layer:setTouchEnabled(true);


    local title_list_cfg = getConfig(game_config_field.title_list)
    local _title_list_cfg = json.decode(title_list_cfg:getFormatBuffer()) or {}
    local tempCount = title_list_cfg:getNodeCount();

    self.m_selTitleId = 1
    self.m_selectType = 1
    self.title_group = json.decode(getConfig("title_group"):getFormatBuffer() or "") or {}

    return ccbNode
end
--

function game_title_pop.useTitle(self)
    local function responseMethod(tag,gameData)
        if gameData then
            self:refreshUi()
            if self.m_useCallBack and type(self.m_useCallBack) == "function" then
                self.m_useCallBack();
            end
        end
    end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("user_use_title"), http_request_method.GET, {title_id = self.m_selTitleData.id},"user_use_title")
end

function game_title_pop.refreshUi(self)
    cclog("[称号] refreshUi")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_title.plist");
    
    ------ 刷新title type 列表
    self:refreshTitleTypeList()
    ------ 刷新称号列表 
    self:refreshTitleList()

    if self.m_selTitleData then
        self.m_des_label:setString(self.m_selTitleData.des1)
        self.m_target_label:setString(self.m_selTitleData.des2)

        for i=1,3 do
            if self.m_selTitleData.buff1[i] then
                self.m_attr_labels[i]:setVisible(true)
                local icon,name,count = game_util:getRewardByItemTable(self.m_selTitleData.buff1[i])
                self.m_attr_labels[i]:setString(name.."x"..count)

            else
                self.m_attr_labels[i]:setVisible(false)
            end
        end
        
        local userStatusData = game_data:getUserStatusData();
        if tostring(userStatusData.cur_title) == tostring(self.m_selTitleData.id) then
            game_util:setCCControlButtonTitle(self.m_drees_btn,"Đã Đeo")
        else
            game_util:setCCControlButtonTitle(self.m_drees_btn,"Đeo")
        end

        local all_titile = game_data:getAllTitle()
        if all_titile[tostring(self.m_selTitleData.id)] then
            local server_time = math.floor(game_data:getUserStatusDataByKey("server_time") or 0)
            if all_titile[tostring(self.m_selTitleData.id)] > 0 and all_titile[tostring(self.m_selTitleData.id)] - server_time > 0 then
                self.m_time_tips_label:setVisible(true)
                self.countdown_label:removeAllChildrenWithCleanup(true)
                local time_left = all_titile[tostring(self.m_selTitleData.id)] - server_time
                local function timeOverCallFun(label,type)
                    -- label:removeFromParentAndCleanup(true);
                    game_util:setCCControlButtonTitle(self.m_drees_btn,"Chưa Nhận")

                end
                local timeLabel = game_util:createCountdownLabel(time_left,timeOverCallFun,8,1)
                timeLabel:setAnchorPoint(ccp(0,0.5))
                timeLabel:setPositionX(-10)
                self.countdown_label:addChild(timeLabel,10,10)
            else
                self.countdown_label:removeAllChildrenWithCleanup(true)
                self.m_time_tips_label:setVisible(false)
            end
        else
            self.countdown_label:removeAllChildrenWithCleanup(true)
            self.m_time_tips_label:setVisible(false)
            game_util:setCCControlButtonTitle(self.m_drees_btn,"Chưa Nhận")
        end
    end
end

function game_title_pop.refreshTitleList(self)
    local offset
    if self._titleList then
        offset = self._titleList:getContentOffset()
    end
    local parent = self.m_titles_node

    parent:removeAllChildrenWithCleanup(true)
    local viewSize = parent:getContentSize()

    local showData = {}
    local titleGroupCfg = self.title_group[tostring(self.m_selectType)]
    local id = titleGroupCfg.id
    local title_list_cfg = getConfig(game_config_field.title_list)
    local _title_list_cfg = json.decode(title_list_cfg:getFormatBuffer()) or {}
    for k, v in ipairs(id) do
        local itemCfg = _title_list_cfg[tostring(v)]
        table.insert(showData,itemCfg)
        showData[#showData].id = v
    end

    local params = {};
    params.viewSize = viewSize;
    params.row = 5;--行
    params.column = 1; --列
    params.totalItem = #showData --totalItem;
    params.direction = kCCScrollViewDirectionVertical;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-15;
    -- params.itemActionFlag = true
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local ccbNode = luaCCBNode:create();
            ccbNode:openCCBFile("ccb/ui_title_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5))
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            cell:setTag(index)
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local titleData = showData[index+1];
            if titleData then
                local m_select_sprite = ccbNode:spriteForName("m_select_sprite")
                m_select_sprite:setVisible(self.m_selTitleId == index + 1);
                if self.m_selTitleId == index + 1 then
                    self.m_selListItem = cell;
                    self.m_selTitleData = titleData
                end
             
                ---- 创建图标
                local m_title_node = ccbNode:nodeForName("m_title_node")
                m_title_node:removeAllChildrenWithCleanup(true)
                local icon 
                local animation = titleData.animation
                if animation and animation ~= "" then
                    local function onAnimSectionEnd(animNode, theId,theLabelName)
                        if theLabelName == "impact" then
                            animNode:playSection(theLabelName)
                        end
                    end

                    local effectFileFullPath = CCFileUtils:sharedFileUtils():fullPathForFilename("iphonehd/anim/" .. animation .. ".swf.sam");
                    local existFlag = util.fileIsExist(effectFileFullPath)
                    if existFlag then
                        icon = zcAnimNode:create(animation .. ".swf.sam",0,animation .. ".plist");
                        icon:registerScriptTapHandler(onAnimSectionEnd)
                        icon:playSection("impact");
                    else
                        cclog("\27[31m 动态称号资源不存在 animation = " .. animation)
                    end
                else
                     icon = CCSprite:create("icon/"..titleData.icon..".png")
                end
                if icon then
                    m_title_node:addChild(icon)

                    local all_titile = game_data:getAllTitle()
                    if all_titile[tostring(titleData.id)] then
                        if all_titile[tostring(titleData.id)] == -1 then
                            icon:setColor(ccc3(255,255,255))
                        else
                            local server_time = math.floor(game_data:getUserStatusDataByKey("server_time") or 0)
                            if all_titile[tostring(titleData.id)] - server_time > 0 then
                                icon:setColor(ccc3(255,255,255))
                            else
                                icon:setColor(ccc3(100,100,100))
                            end
                        end
                    else
                        icon:setColor(ccc3(100,100,100))
                    end
                end
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  cell = " .. tolua.type(cell));
        if index >= #showData then return end;
        if eventType == "ended" and cell then
            self.m_selListItem = cell
            self.m_selTitleId = index + 1
            local titleData = showData[index+1]
            self.m_selTitleData = titleData
            self:refreshUi()
        end
    end
    local tbv = TableViewHelper:create(params)
    tbv:setScrollBarVisible(false)
    if offset then
        if offset.y < parent:getContentSize().height - tbv:getContentSize().height then
            offset.y = parent:getContentSize().height - tbv:getContentSize().height
        end
        tbv:setContentOffset(offset)
    end
    self._titleList = tbv
    parent:addChild(tbv)


end

function game_title_pop.refreshTitleTypeList(self)
    local nd_titleType = self.ccbNode:nodeForName("nd_titleType")
    local parent = nd_titleType
    
    parent:removeAllChildrenWithCleanup(true)
    local viewSize = parent:getContentSize()

    local title_group = self.title_group
    local showData = {}
    for k, v in pairs(title_group) do
        v.title_group = tonumber(k)
        table.insert(showData, v)
    end
    table.sort(showData, function (a, b)
        return a.title_group < b.title_group
    end)

    local params = {}
    params.viewSize = viewSize
    params.totalItem = #showData
    params.row = 6
    params.column = 1
    params.direction = kCCScrollViewDirectionVertical
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-15;
    local itemSize = CCSizeMake(viewSize.width / params.column, viewSize.height / params.row)
    params.newCell = function(tableView, index)
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
        end
        if cell then
            cell:removeAllChildrenWithCleanup(true)

            local idx = index + 1 -- 下标1开始
            local cfg = showData[idx]
            -- 创建背景底板
            local bgSpName = idx == self.m_selectType and "TitleTag2.png" or "TitleTag.png"
            local bg = CCSprite:createWithSpriteFrameName(bgSpName)
            bg:setPosition(ccp(itemSize.width * 0.5, itemSize.height * 0.5))
            cell:addChild(bg)

            -- 创建文本 group_name
            local name = game_util:createLabelTTF({text = cfg.group_name, color = ccc3(255, 255, 106), fontSize = 12})
            name:setPosition(ccp(itemSize.width * 0.5, itemSize.height * 0.5))
            cell:addChild(name)
        end
        return cell
    end
    params.itemOnClick = function(eventType, index, item)
        if eventType == "ended" and item then
            if self.m_selectType == index + 1 then
                return
            end
            self.m_selTitleId = 1
            self.m_selectType = index + 1
            self._titleList = nil
            self:refreshUi()
        end
    end

    local tbv = TableViewHelper:create(params)
    tbv:setScrollBarVisible(false)
    parent:addChild(tbv)
end

--[[--
    初始化
]]
function game_title_pop.init(self, t_params)
    cclog("[称号] init")
    self.m_useCallBack = t_params.useCallBack
end
--[[--
    创建ui入口并初始化数据
]]
function game_title_pop.create(self, t_params)
    cclog("[称号] create")

    self:init(t_params)
    self.m_tParams = t_params
    self.m_popUi = self:createUi()
    self:refreshUi()
    return self.m_popUi
end

--[[--
    回调方法
]]
function game_title_pop.callBackFunc(self)
    cclog("[称号] callBackFunc")

    local callBackFunc = self.callBackFunc
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc()
    end
end

return game_title_pop
  �;  