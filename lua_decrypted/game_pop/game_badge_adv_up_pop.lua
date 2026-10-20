--- 公会消息详细

local game_badge_adv_up_pop = {
    m_ccbNode = nil,
    m_node_list = nil,
    m_curPage = nil,
    m_popUi = nil,
    m_tParams = nil,
    m_root_layer = nil,
    m_callBack = nil,
    m_badgeId = nil,
    m_equip_tab = nil,
    m_selectEquipId = nil,
    m_equipIdTable = nil,

};
--[[--
    销毁
]]
function game_badge_adv_up_pop.destroy(self)
    -- body
    cclog("-----------------game_badge_adv_up_pop destroy-----------------");
    self.m_ccbNode = nil;
    self.m_popUi = nil;
    self.m_tParams = nil;
    self.m_curPage = nil;
    self.m_node_list = nil;
    self.m_root_layer = nil;
    self.m_callBack = nil;
    self.m_badgeId = nil;
    self.m_equip_tab = nil;
    self.m_equipIdTable = nil;
    self.m_selectEquipId = nil;
end
--[[--
    返回
]]
function game_badge_adv_up_pop.back(self,type)
    game_scene:removePopByName("game_badge_adv_up_pop");
end
--[[--
    读取ccbi创建ui
]]
function game_badge_adv_up_pop.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        
        if btnTag == 1 then
            self:back()
        elseif btnTag == 101 then

            local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_badgeId)
            local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
            local nextCfg = game_util:getBadgeByIdCfg(badge_cfg.badge_break)
            local next_cfg = json.decode(nextCfg:getFormatBuffer())
            local badge_material = next_cfg.badge_material
            local count = badge_material[1][3]
            local itemCount = game_data:getItemCountByCid(badge_material[1][2]) or 0
            if itemCount < count then 
                game_util:addMoveTips({text = "Không đủ tài liệu tiến giai, tiến giai thất bại"})
                return
            end

            local function responseMethod(tag, gameData)
                if self.m_callBack and type(self.m_callBack) == "function" then
                    self.m_callBack("refresh");
                end
                self:back()
            end
            local params = {}
            params.badge_id = self.m_badgeId
            network.sendHttpRequest(responseMethod, game_url.getUrlForKey("badge_level_up"), http_request_method.GET,params,"badge_level_up")
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
    ccbNode:openCCBFile("ccb/ui_badge_adv_up_pop.ccbi");
    self.m_ccbNode = ccbNode
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    self.m_node_list = ccbNode:nodeForName("node_list")
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
    return ccbNode;
end

--[[--
    刷新ui
]]
function game_badge_adv_up_pop.refreshUi(self)
    self:refreshBadgeInfo()
end

--[[
    设置选中徽章info
]]
function game_badge_adv_up_pop.refreshBadgeInfo(self, badgeId )
    local icon_node = self.m_ccbNode:nodeForName("icon_node")
    cclog2(self.m_badgeId,"self.m_badgeId-------")
    local badgeData,badgeCfg = game_data:getBadgeDataById(self.m_badgeId)
    local badge_cfg = json.decode(badgeCfg:getFormatBuffer())
    local m_name = self.m_ccbNode:labelTTFForName("m_name")
    local level = badge_cfg.badge_level
    local name = badge_cfg.badge_name
    m_name:setString(name .. "+" .. tostring(level))

    -- local item_icon = game_util:createBadgeIconByCfg(badgeCfg)
    -- icon_node:removeAllChildrenWithCleanup(true)
    -- item_icon:setScale(0.8)
    local icon = badgeCfg:getNodeWithKey("image_L"):toStr();
    local tempIcon = game_util:createIconByName(icon)
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
    local nextCfg = game_util:getBadgeByIdCfg(badge_cfg.badge_break)
    local next_cfg = json.decode(nextCfg:getFormatBuffer())
    local badge_material = next_cfg.badge_material
    cclog2(badge_material,"badge_material--------")
    local m_equip_node = self.m_ccbNode:spriteForName("m_equip_node")
    m_equip_node:removeAllChildrenWithCleanup(true)
    local icon,name,count = game_util:getRewardByItemTable(badge_material[1])

    local tempSize = m_equip_node:getContentSize();
    icon:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5));
    icon:setScale(0.8)
    m_equip_node:addChild(icon,10,10);

    local label_tps_1 = self.m_ccbNode:labelTTFForName("label_tps_1")
    local label_tps_2 = self.m_ccbNode:labelTTFForName("label_tps_2")

    local itemCount = game_data:getItemCountByCid(badge_material[1][2]) or 0

    label_tps_1:setString(itemCount)
    label_tps_2:setString("/" .. count ) --进阶需要
    if itemCount >= count then 
        label_tps_1:setColor(ccc3(255,255,255))
    else
        label_tps_1:setColor(ccc3(255, 0, 0))
    end


    local function onBtnCilck( event,target )
        cclog("---123123--------111")
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag()
        local tempType = badge_material[1][1];
        if tempType == 6 then--道具
            local itemId = badge_material[1][2];
            game_scene:addPop("game_item_info_pop",{itemId = itemId,openType = 2})
        end
    end
    self:createButton(m_equip_node,onBtnCilck,1,0.6,ccp(0.5,0.5),0,6)
end

--[[--
    创建按钮
]]
function game_badge_adv_up_pop.createButton( self,icon,onBtnCilck,i,scale,AnchorPoint,opacity,touchPriority )
    local button = game_util:createCCControlButton("public_skill.png","",onBtnCilck)
    button:setAnchorPoint(AnchorPoint)
    button:setZoomOnTouchDown(false)
    button:setTouchPriority(GLOBAL_TOUCH_PRIORITY-touchPriority)
    button:setPosition( icon:getContentSize().width * 0.5, icon:getContentSize().height * 0.5 )
    if opacity then 
        button:setOpacity(opacity)
    else
        button:setOpacity(0)
    end
    if scale then 
       button:setScale(tonumber(scale))
    end
    button:setTag(i)
    icon:addChild(button,10)
end

--[[--
    初始化
]]
function game_badge_adv_up_pop.init(self,t_params)
    self.m_tParams = t_params or {};
    self.m_callBack = self.m_tParams.callBack;
    self.m_badgeId = self.m_tParams.badgeId;
    self.m_curPage = 1
    self.m_equipIdTable = {}
    self.m_selectEquipId = {}
    -- cclog("self.m_tParams == " .. json.encode(self.m_tParams))
end

--[[--
    创建ui入口并初始化数据
]]
function game_badge_adv_up_pop.create(self,t_params)
    self:init(t_params);
    self.m_tParams = t_params;
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

--[[--
    回调方法
]]
function game_badge_adv_up_pop.callBackFunc(self,typeName,t_params)
    local callBackFunc = self.m_tParams.callBackFunc;
    if callBackFunc and type(callBackFunc) == "function" then
        callBackFunc(typeName,t_params);
    end
end

return game_badge_adv_up_pop;  �   