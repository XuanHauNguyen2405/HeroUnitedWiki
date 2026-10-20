--- 装备列表 

local game_badge_equip_pop = {
    m_list_view_bg = nil,
    m_tableView = nil,
    m_posIndex = nil,
    m_selSort = nil,
    m_back_btn = nil,
    m_sort_btn = nil,
    m_btnCallFunc = nil,
    m_itemOnClick = nil,
    m_openType = nil,
    m_title_label = nil,
    m_curPage = nil,
    m_ok_btn = nil,
    m_tab_btn_1 = nil,
    m_tab_btn_2 = nil,
    m_showIndex = nil,
    m_material_id_table = nil,
    m_sell_node = nil,
    m_gain_value_label = nil,
    m_is_notice = nil,
    m_popUi = nil,
    m_gain_icon = nil,
    m_num_label = nil,
    m_sell_btn = nil,
    m_ccbNode = nil,
    m_func_btn = nil,
    m_zhuanshiData = nil,
    m_root_layer = nil,
    m_itemOnClick = nil,
    m_equipIdTable = nil,
    m_onlyId = nil,
    m_selectEquipId = nil,
};
--[[--
    销毁ui
]]
function game_badge_equip_pop.destroy(self)
    -- body
    cclog("-----------------game_badge_equip_pop destroy-----------------");
    self.m_list_view_bg = nil;
    self.m_tableView = nil;
    self.m_posIndex = nil;
    self.m_selSort = nil;
    self.m_back_btn = nil;
    self.m_sort_btn = nil;
    self.m_btnCallFunc = nil;
    self.m_itemOnClick = nil;
    self.m_openType = nil;
    self.m_title_label = nil;
    self.m_curPage = nil;
    self.m_ok_btn = nil;
    self.m_tab_btn_1 = nil;
    self.m_tab_btn_2 = nil;
    self.m_showIndex = nil;
    self.m_material_id_table = nil;
    self.m_sell_node = nil;
    self.m_gain_value_label = nil;
    self.m_is_notice = nil;
    self.m_popUi = nil;
    self.m_gain_icon = nil;
    self.m_num_label = nil;
    self.m_sell_btn = nil;
    self.m_ccbNode = nil;
    self.m_func_btn = nil;
    self.m_zhuanshiData = nil;
    self.m_root_layer = nil;
    self.m_itemOnClick = nil;
    self.m_equipIdTable = nil;
    self.m_onlyId = nil;
    self.m_selectEquipId = nil;
end

--[[--
    返回
]]
function game_badge_equip_pop.back(self,type)
    game_data:resetNewEquipIdTab();
    game_scene:removePopByName("game_badge_equip_pop")
    self:destroy()

end
--[[--
    读取ccbi创建ui
]]
function game_badge_equip_pop.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then--返回
            if self.m_btnCallFunc then
                self.m_btnCallFunc(target,event)
            else
                self:back();
            end
        -- elseif btnTag == 2 then
        --     local function btnCallBack(btnTag)
        --         -- cclog("btnCallBack ===========btnTag===" .. btnTag)
        --         local selSort = tostring(EQUIP_SORT_TAB[btnTag].sortType);
        --         self:refreshEquipTableView(selSort);
        --     end
        --     game_scene:addPop("game_sort_pop",{btnTitleTab = EQUIP_SORT_TAB,btnCallFunc = btnCallBack,currentSortType = self.m_selSort})
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_godtemple_hero_list_new.ccbi");
    self.m_list_view_bg = tolua.cast(ccbNode:objectForName("m_list_view_bg"), "CCNode");
    self.m_back_btn = ccbNode:controlButtonForName("m_back_btn")
    self.m_sort_btn = ccbNode:controlButtonForName("m_sort_btn")
    self.m_title_label = ccbNode:labelTTFForName("m_title_label")
    self.m_sell_node = ccbNode:nodeForName("m_sell_node")
    self.m_gain_value_label = ccbNode:labelBMFontForName("m_gain_value_label")
    -- self.m_num_label = ccbNode:labelTTFForName("m_num_label")
    self.m_title_label:setString("")
    -- self.m_ok_btn = ccbNode:controlButtonForName("m_ok_btn")
    self.m_tab_btn_1 = ccbNode:controlButtonForName("m_tab_btn_1")
    self.m_tab_btn_2 = ccbNode:controlButtonForName("m_tab_btn_2")
    self.m_sell_btn = ccbNode:controlButtonForName("m_sell_btn")
    self.m_func_btn = ccbNode:controlButtonForName("m_func_btn")
    -- game_util:setControlButtonTitleBMFont(self.m_sell_btn)
    game_util:setControlButtonTitleBMFont(self.m_sort_btn)
    -- game_util:setControlButtonTitleBMFont(self.m_ok_btn)
    self.m_gain_icon = ccbNode:spriteForName("m_gain_icon")
    self.m_back_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-9)
    self.m_sort_btn:setVisible(false)
    self.m_tab_btn_1:setVisible(false)
    self.m_tab_btn_2:setVisible(false)
    self.m_func_btn:setVisible(false);
    self.m_sell_btn:setVisible(false);
    self.m_gain_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_icon_metal.png"));
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;--intercept event
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-8,true);
    self.m_root_layer:setTouchEnabled(true);
    -- ccbNode:registerAnimFunc(animEndFunc)
    self.m_ccbNode = ccbNode;
    return ccbNode;
end

--[[--

]]
function game_badge_equip_pop.removePop(self)
    if self.m_popUi then
        self.m_popUi:removeFromParentAndCleanup(true);
        self.m_popUi = nil;
    end
end

--[[--
    创建装备列表
]]
function game_badge_equip_pop.createEquipTableView(self,viewSize,tableData)
   
end

-- --[[--
--     刷新列表
-- ]]
-- function game_badge_equip_pop.refreshEquipTableView(self,sort)
--     self.m_list_view_bg:removeAllChildrenWithCleanup(true)
--     self.m_selSort = sort;
--     game_data:equipSortByTypeName(self.m_selSort)
--     local equipData = game_data:getEquipIdTable();
--    -- self.m_sort_btn:setVisible(true);
--    self.m_list_view_bg:removeAllChildrenWithCleanup(true);
--    self.m_tableView = self:createFilterTableView(self.m_list_view_bg:getContentSize());
--    self.m_list_view_bg:addChild(self.m_tableView);
-- end

function game_badge_equip_pop.getCurrentEquipTab(self,showDataTable)
    local tempTab = {}
    local needTab = {}
    local temponlyTab = {}
    local i = 1
    for k,v in pairs(self.m_equipIdTable) do
        tempTab[v] = 1
    end

    -- for k,v in pairs(self.m_onlyId) do
    --     temponlyTab[v] = 1
    -- end

    for k,v in pairs(showDataTable) do
        if tempTab[v.itemData.c_id] and temponlyTab[tostring(v.itemData.id)] then
        else
            needTab[i] = v
            i = i+1
        end
    end
    return needTab 
end

function game_badge_equip_pop:getShowData( ... )
    local equipCfg = getConfig(game_config_field.equip);
    local equipsDataTable = game_data:getEquipData();
    local showDataTable = {};
    cclog2(self.m_selectEquipId,"self.m_selectEquipId----")
    for key,itemData in pairs(equipsDataTable) do
        if not util.valueInTable(key,self.m_selectEquipId) then 
            local equip_cfg = equipCfg:getNodeWithKey(itemData.c_id);
            -- local equip_cfg_new = json.decode(equip_cfg:getFormatBuffer())
            local pos = itemData.pos  -- 是否装备
            local level = itemData.lv  -- 等级
            local gem_fate = itemData.gem_fate  -- 宝石
            local gem_fate = itemData.gem_fate  -- 宝石
            local is_gem = false -- 是否装备宝石
            local st_lv = itemData.st_lv -- 精炼
            local atts = itemData.atts -- 附魔
            local is_atts = game_util:getTableLen(atts) -- 是否附魔
            local is_equip_refine = itemData.is_equip_refine -- 洗练
            local equip_forge_level = itemData.equip_forge_level or {} -- 锻造
            local is_equip_forge_level = game_util:getTableLen(equip_forge_level) -- 是否锻造
            for i,v in ipairs(gem_fate) do
                if v ~= 0 then 
                    is_gem = true
                    break
                end
            end
            if self:getIsEquipId(itemData) and pos == -1 and level == 1 and not is_gem and st_lv == 0 and not is_equip_refine and is_atts == 0 and is_equip_forge_level == 0 then 
                showDataTable[#showDataTable+1] = {itemData = itemData,itemCfg = equip_cfg,equip_id = key}
            end
        end
    end
    return showDataTable
end

function game_badge_equip_pop:getIsEquipId( itemData )
    -- local equip_cfg = json.decode(equipCfg:getFormatBuffer())
    local badge_equip = getConfig(game_config_field.badge_equip);
    local badge_equip_cfg = json.decode(badge_equip:getFormatBuffer())
    for k,v in pairs(badge_equip_cfg) do
        if tonumber(k) == itemData.c_id then 
            return true
        end
    end
    return false

end
--[[--
    创建筛选的列表
]]
function game_badge_equip_pop.createFilterTableView(self,viewSize)
    local showDataTable = self:getShowData()
    -- showDataTable = self:getCurrentEquipTab(showDataTable)
    local function sortFunc(dataOne,dataTwo)
        return dataOne.itemCfg:getNodeWithKey("quality"):toInt() > dataTwo.itemCfg:getNodeWithKey("quality"):toInt();
    end
    table.sort(showDataTable,sortFunc)
    cclog2(showDataTable,"showDataTable------")
    local itemsCount = #showDataTable;
    local totalItem = math.max(itemsCount%8 == 0 and itemsCount or math.floor(itemsCount/8+1)*8,8)
    local params = {};
    params.viewSize = viewSize;
    params.row = 2;--行
    params.column = 4; --列
    params.totalItem = totalItem;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY -9 ;
    params.showPageIndex = self.m_curPage;
    params.itemActionFlag = true;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            -- cclog("new index ================================" .. index);
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = game_util:createEquipItemByCCB();
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_spr_bg_up = ccbNode:spriteForName("m_spr_bg_up");
            if index < itemsCount then
                m_spr_bg_up:setVisible(false);
                local itemData = showDataTable[index+1].itemData;
                local itemCfg = showDataTable[index+1].itemCfg;
                local dataId = itemData.id;
                if ccbNode and itemData then
                    game_util:setEquipItemInfoByTable(ccbNode,itemData);
                    local flag,k = game_util:idInTableById(tostring(dataId),self.m_material_id_table)
                    if flag then
                        local m_sel_img = ccbNode:spriteForName("m_sel_img")
                        m_sel_img:setVisible(true);
                    end
                end
            else
                m_spr_bg_up:setVisible(true);
                ccbNode:nodeForName("m_info_node"):setVisible(false);
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  item = " .. tolua.type(item) .. " ; item:getUserData() = " .. tolua.type(item:getUserData()));
        if index >= itemsCount then return end;
        if eventType == "ended" and item then
            local ccbNode = tolua.cast(item:getChildByTag(10),"luaCCBNode");
            local itemData = showDataTable[index+1].itemData;
            local equip_id = showDataTable[index+1].equip_id;
            local dataId = tostring(itemData.id);
            local lv = itemData.lv
            local m_tEquipPosData1 = game_data:getGodEquipPosData1();
            local m_tEquipPosData2 = game_data:getGodEquipPosData2();
            local m_tEquipPosData3 = game_data:getGodEquipPosData3();
            local godflag1 = game_util:godEquipeidInTableById(dataId,m_tEquipPosData1)
            local godflag2 = game_util:godEquipeidInTableById(dataId,m_tEquipPosData2)
            local godflag3 = game_util:godEquipeidInTableById(dataId,m_tEquipPosData3)
            if godflag1 == true or godflag2 == true or godflag3 == true then
                -- cclog("add select material hero id ==========" .. dataId);
                local t_params = 
                {
                    title = string_config.m_title_prompt,
                    okBtnCallBack = function(target,event)
                        if self.m_itemOnClick then
                            self.m_itemOnClick(itemData.c_id,equip_id);
                            game_util:closeAlertView();
                            self:back();
                        end
                    end,   --可缺省
                    cancelBtnCallBack = function(target,event)
                        game_util:closeAlertView();
                    end,
                    okBtnText = "Xác nhận",       --可缺省
                    cancelBtnText = "Hủy",
                    onlyOneBtn = false,
                    text = "Xác nhận xóa trang bại này ở Thần Vực?",      --可缺省
                    touchPriority = GLOBAL_TOUCH_PRIORITY-9,
                }
                game_util:openAlertView(t_params);
            else
                if self.m_itemOnClick then
                    self.m_itemOnClick(itemData.c_id,dataId);
                    self:back();
                end
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curPage = curPage;
    end
    return TableViewHelper:createGallery2(params);
end


function game_badge_equip_pop.refreshTab2(self)
    -- self.m_sort_btn:setVisible(true);
    self.m_list_view_bg:removeAllChildrenWithCleanup(true);
    self.m_tableView = self:createFilterTableView(self.m_list_view_bg:getContentSize());
    self.m_list_view_bg:addChild(self.m_tableView);
end


--[[--
    刷新ui
]]
function game_badge_equip_pop.refreshUi(self)
    self:refreshTab2();
end
--[[--
    初始化
]]
function game_badge_equip_pop.init(self,t_params)
    t_params = t_params or {};
    -- body
    self.m_zhuanshiData = t_params.zhuanshiData or {}
    self.m_posIndex = t_params.posIndex;
    self.m_selSort = game_data:getEquipSortType();
    self.m_openType = t_params.openType or "";
    self.m_showIndex = t_params.showIndex or 1;
    self.m_itemOnClick = t_params.itemOnClick;
    self.m_material_id_table = {};
    self.m_equipIdTable = t_params.m_equipIdTable or {}
    self.m_selectEquipId = t_params.m_selectEquipId or {}
    self.m_onlyId = t_params.m_onlyId or {}
    self.m_is_notice = 0;
end

--[[--
    创建ui入口并初始化数据
]]
function game_badge_equip_pop.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    return scene;
end

return game_badge_equip_pop;  :  