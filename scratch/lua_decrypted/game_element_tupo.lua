--- 法宝进化
local game_element_tupo = {
    m_anim_node = nil,--动画节点
    m_selMagicId = nil,--选中的heroid
    m_ok_btn = nil,
    m_tips_spr_1 = nil,
    m_list_view_bg = nil,
    m_sel_btn = nil,
    m_showType = nil,
    m_selListItem = nil,
    m_back_btn = nil,
    m_ability2_name_label_2 = nil,
    m_material_layer = nil,
    m_material_node_tab = nil,
    m_materialDataTable = nil,
    m_curPage = nil,
    m_ccbNode = nil,
    m_anim_node_parent = nil,
    m_root_layer = nil,
    m_metal_total_label = nil,
    m_status = nil,
    m_selSortIndex = nil,
    m_shop_btn = nil,
    m_openType = nil,
    myformation = nil,
    m_tableView = nil,
    m_newCardsTab = nil,
    m_materialTab = nil,
    m_material_node_1 = nil,
    m_butes_node = nil,
    m_food_txt = nil,
    m_element_level = nil,
    m_element_huot = nil,
    m_selHeroId = nil,
};
--[[--
    销毁ui
]]
function game_element_tupo.destroy(self)
    -- body
    cclog("-----------------game_element_tupo destroy-----------------");
    self.m_food_txt = nil;
    self.m_anim_node = nil;
    self.m_selMagicId = nil;
    self.m_ok_btn = nil;
    self.m_tips_spr_1 = nil;
    self.m_list_view_bg = nil;
    self.m_sel_btn = nil;
    self.m_showType = nil;
    self.m_selListItem = nil;
    self.m_back_btn = nil;
    self.m_material_layer = nil;
    self.m_material_node_tab = nil;
    self.m_materialDataTable = nil;
    self.m_curPage = nil;
    self.m_ccbNode = nil;
    self.m_anim_node_parent = nil;
    self.m_root_layer = nil;
    self.m_metal_total_label = nil;
    self.m_status = nil;
    self.m_selSortIndex = nil;
    self.m_shop_btn = nil;
    self.m_openType = nil;
    self.myformation = nil;
    self.m_tableView = nil;
    self.m_newCardsTab = nil;
    self.m_materialTab = nil;
    self.m_butes_node = nil;
    self.m_element_level = nil;
    self.m_element_huot = nil;
    self.m_selHeroId = nil;
end
--[[--
    返回
]]
function game_element_tupo.back(self,backType)
    if backType == "back" then
        local function endCallFunc()
            self:destroy();
        end
        game_scene:enterGameUi("game_main_scene",{gameData = nil},{endCallFunc = endCallFunc});
    end
end
--[[--
    读取ccbi创建ui    equipSortByTypeName
]]
function game_element_tupo.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then--返回
            self:back("back");
        elseif btnTag == 3 then--突破查询

            if self.m_selHeroId == nil then
                game_util:addMoveTips({text = "Chọn đồng đội cần đột phá!"}); --请选择需要突破的伙伴
                return;
            end
            local function responseMethod(tag,gameData)
                local data = gameData:getNodeWithKey("data"):getFormatBuffer()
                game_scene:addPop("game_element_pop",json.decode(data))  
            end
            local params = {}
            params.card_id = self.m_selHeroId 
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("element_query"), http_request_method.GET, params,"element_query")
        elseif btnTag == 101 then -- 突破
            if self.m_selHeroId == nil then
                game_util:addMoveTips({text = "Chọn đồng đội cần đột phá!"});
                return;
            end
            local function responseMethod(tag,gameData)
                local data = gameData:getNodeWithKey("data"):getFormatBuffer()
                self:refreshUi()
                self:refreshHeroInfo(self.m_selHeroId)
            end

            local selItemData,selItemCfg = game_data:getCardDataById(tostring(self.m_selHeroId));

            local element_lv = 0
            if selItemData.element_break then
                element_lv = selItemData.element_break
            end
            local params = {}
            params.card_id = self.m_selHeroId 
            params.element_lv = element_lv
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("element_break"), http_request_method.GET, params,"element_break")
		elseif btnTag >= 201 and btnTag <= 204 then--排序
            self:refreshSortTabBtn(btnTag - 200);
            local selSort = tostring(CARD_SORT_TAB[btnTag - 200].sortType);
            game_data:cardsSortByTypeNameWithTable(selSort,self.m_newCardsTab)
            self:refreshCardTableView(true);
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_element_tupo.ccbi");
    --英雄相关
    self.m_anim_node = ccbNode:nodeForName("m_anim_node")
    self.m_tips_spr_1 = ccbNode:spriteForName("m_tips_spr_1")
    self.m_ok_btn = ccbNode:controlButtonForName("m_ok_btn")
    self.m_shop_btn = ccbNode:controlButtonForName("m_shop_btn")
    self.m_sel_btn = ccbNode:controlButtonForName("m_sel_btn")
    self.m_list_view_bg = ccbNode:layerForName("m_list_view_bg")
    self.m_back_btn = ccbNode:controlButtonForName("m_back_btn")
    self.m_butes_node = ccbNode:nodeForName("m_butes_node")

    self.m_scroll_node = ccbNode:nodeForName("m_scroll_node")
    self.m_scroll = ccbNode:scrollViewForName("m_scroll")
    self.m_detail_lb = ccbNode:labelTTFForName("detail_lb")
    self.m_food_txt = ccbNode:labelTTFForName("m_food_txt")
    self.m_food_txt:setString("0")
    self.m_element_level = ccbNode:labelTTFForName("m_element_level")
    self.m_element_huot = ccbNode:labelTTFForName("m_element_huot")
    self.m_metal_total_label = ccbNode:labelBMFontForName("m_metal_total_label")

    local m_bg_sprite = ccbNode:spriteForName("m_bg_sprite")
    m_bg_sprite:setScale(resolution_config:getScale())

    self.m_anim_node_parent = ccbNode:nodeForName("m_anim_node_parent")
    game_util:setControlButtonTitleBMFont(self.m_sel_btn)
    game_util:setControlButtonTitleBMFont(self.m_ok_btn)
    game_util:setControlButtonTitleBMFont(self.m_shop_btn)
    self.m_ccbNode = ccbNode

    local m_material_node,m_mate_tips,m_mate_txt = nil;
    for i=1,3 do
        m_material_node = ccbNode:spriteForName("m_material_node_" .. i);
        m_mate_tips = ccbNode:spriteForName("m_mate_tips_" .. i);
        m_mate_txt = ccbNode:labelTTFForName("m_mate_txt_" .. i);
        self.m_material_node_tab[i] = {m_material_node = m_material_node,m_mate_tips = m_mate_tips,m_mate_txt = m_mate_txt}
    end

    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    self.m_material_Layer = ccbNode:layerForName("m_material_Layer")

    self:initMaterialLayerTouch()

    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;--intercept event
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,-999,true);
    self.m_root_layer:setTouchEnabled(false);

    self:refreshCardTableView()
    return ccbNode;
end

function game_element_tupo.initMaterialLayerTouch(self)
    local tempItem = nil;
    local realPos = nil;
    local tag = nil;
    local function onTouchBegan(x, y)
        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    local function onTouchMoved(x, y)
    end
    
    local function onTouchEnded(x, y)
        realPos = self.m_material_Layer:convertToNodeSpace(ccp(x,y))
        for k,v in pairs(self.m_material_node_tab) do
            local px,py = v.m_material_node:getPosition()
            if v.m_material_node:boundingBox():containsPoint(realPos) then
                cclog("m_material_node click ==== " .. k)
                local tempData = self.m_materialDataTable[k];
                if self.m_selHeroId and tempData then
                    if tempData.materialType == 6 then
                        game_scene:addPop("game_item_info_pop",{itemId = tempData.materialId,openType = 3})
                    elseif tempData.materialType == 5 then
                        game_scene:addPop("game_hero_info_pop",{cId = tostring(tempData.materialId),openType = 4})
                    end
                end
                break;
            end
        end
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
    self.m_material_Layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY)
    self.m_material_Layer:setTouchEnabled(true)
end

function game_element_tupo.refreshSortTabBtn(self,sortIndex)
    local tempBtn = nil;
    self.m_selSortIndex = sortIndex
    for i=1,4 do
        tempBtn = self.m_ccbNode:controlButtonForName("m_table_tab_btn_" .. i)
        tempBtn:setHighlighted(self.m_selSortIndex == i);
        tempBtn:setEnabled(self.m_selSortIndex ~= i);
    end
   
end


--[[--
    刷新
]]
function game_element_tupo.refreshCardTableView(self)
    self.m_list_view_bg:removeAllChildrenWithCleanup(true);
    self.m_tableView = nil
    self.m_tableView = self:createTableView(self.m_list_view_bg:getContentSize());
    self.m_list_view_bg:addChild(self.m_tableView);
end

--[[--
    创建装备列表
]]
function game_element_tupo.createTableView(self,viewSize)
    self.m_selListItem = nil;
    local showData = {}
    local tempCount = #self.m_newCardsTab
    local character_detail = getConfig(game_config_field.character_detail);
    local cardsData = game_data:getTableCardsData()
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/public_res.plist");
    for i=1,tempCount do
        local itemData = cardsData[self.m_newCardsTab[i]]
        if itemData then
            local itemConfig = character_detail:getNodeWithKey(itemData.c_id);
            local breakthrough = itemConfig:getNodeWithKey("breakthrough_ids");
            local breakthrough_tab = json.decode(breakthrough:getFormatBuffer()) or {}
            if next(breakthrough_tab) then
                table.insert(showData,self.m_newCardsTab[i]) 
            end
        end
    end


    local cardsCount = #showData
    local totalItem = math.max(cardsCount%4 == 0 and cardsCount or math.floor(cardsCount/4+1)*4,4)
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;--行
    params.column = 1; --列
    params.totalItem = cardsCount -- totalItem;
    params.showPageIndex = self.m_curPage;
    params.direction = kCCScrollViewDirectionVertical;
    
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = game_util:createHeroListItemByCCB2();
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            if index < cardsCount then
                local itemData,itemConfig =  game_data:getCardDataById(showData[index+1])
                if itemData then
                    local card_id = itemData.id;
                    game_util:setHeroListItemInfoByTable2(ccbNode,itemData);
                    if self.m_selHeroId and self.m_selHeroId == card_id then
                        local m_sel_img = ccbNode:spriteForName("sprite_selected")
                        m_sel_img:setVisible(true);
                        local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
                        sprite_back_alpha:setVisible(true);
                        self.m_selListItem = cell;
                    end
                end
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        if index >= cardsCount then return end;
        if eventType == "ended" and cell then
            local itemData,itemConfig = game_data:getCardDataById(showData[index+1])
            cclog2(itemData,"itemData")
            local card_id = itemData.id;
            if self.m_selHeroId == nil or self.m_selHeroId ~= card_id then
                if self.m_selListItem then
                    local ccbNode = tolua.cast(self.m_selListItem:getChildByTag(10),"luaCCBNode");
                    local m_sel_img = ccbNode:spriteForName("sprite_selected")
                    m_sel_img:setVisible(false);
                    local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
                    sprite_back_alpha:setVisible(false);
                end
                self.m_up_skill_index = 1;
                self.m_selListItem = cell;
                self.m_selHeroId = card_id;
                self:refreshHeroInfo(self.m_selHeroId);
                self:refreshUi()
                local ccbNode = tolua.cast(self.m_selListItem:getChildByTag(10),"luaCCBNode");
                local m_sel_img = ccbNode:spriteForName("sprite_selected")
                m_sel_img:setVisible(true);
                local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
                sprite_back_alpha:setVisible(true);
                
            end
        elseif eventType == "longClick" and cell then
    
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curPage = curPage;
    end
    local tableView = TableViewHelper:create(params);

    return tableView
end

--[[--
    属性英雄信息
]]
function game_element_tupo.refreshHeroInfo(self,heroId)
    self.m_selHeroId = heroId;
    self.m_anim_node:removeAllChildrenWithCleanup(true);
   
    if heroId ~= nil and heroId ~= "-1" then
        self.m_tips_spr_1:setVisible(false);
        local cardData,heroCfg = game_data:getCardDataById(tostring(heroId));
        self.m_selHeroData = cardData;
        local card_lv = cardData.lv
        local ccbNode = game_util:createHeroListItemByCCB(cardData);
        self.m_anim_node:addChild(ccbNode,10,10);
    else
        self.m_tips_spr_1:setVisible(true);
    end
    self:refreshMaterial();
end

--[[--
    刷新材料列表
]]
function game_element_tupo.refreshMaterial(self)
    local selItemData,selItemCfg = game_data:getCardDataById(tostring(self.m_selHeroId));
    local level = selItemData.element_break or 0
    if level >= 20 then
        return
    end
    local material = {}
    for k,v in pairs(self.m_materialTab) do
        local num = tonumber(string.sub(k,5,6))
        if num==level+1 and  (selItemData.c_id==v.character_id) then
            cclog(num .. " abcd ".. level)
            material = v
        end
    end

    local catds = game_data:getTableCardsData()

    local materialType ,materialId = nil, nil
    for i=1,3 do
        materialType = material.need_material[i][1]
        materialId = material.need_material[i][2]
        costCount = material.need_material[i][3]
        local icon = nil;
        if materialType == 6 then
            count = game_data:getItemCountByCid(materialId);
            icon = game_util:createItemIconByCid(materialId);
        elseif materialType == 5 then
            count = game_data:getCardCountByCid(materialId,self.m_selHeroId);
            icon = game_util:createCardIconByCid(materialId);
        end
        if costCount > count then
           -- self.m_status = 3;
            self.m_material_node_tab[i]["m_mate_txt"]:setColor(ccc3(255, 0, 0))
        else
            self.m_material_node_tab[i]["m_mate_txt"]:setColor(ccc3(255, 255, 255));
        end
        local str = costCount.." / "..count
        self.m_material_node_tab[i]["m_mate_txt"]:setString(str);
        self.m_materialDataTable[i] = {count = count,materialId = materialId,materialType = materialType};
        if icon then  
            icon:setPosition(ccp(27,27));
            self.m_material_node_tab[i]["m_material_node"]:addChild(icon)
            self.m_material_node_tab[i]["m_mate_tips"]:setVisible(false)
            if costCount > count then
                icon:setColor(ccc3(151,151,151));                        
            end
        end
    end
    local value,unit = game_util:formatValueToString(material.need_money);
    self.m_food_txt:setString(value .. unit);

    self:refreshAttributes(material)
    
end

--[[--
    刷新属性列表
]]
function game_element_tupo.refreshAttributes(self,material)
    local selItemData,selItemCfg = game_data:getCardDataById(tostring(self.m_selHeroId));
    local butes = material.abilitys
    local viewSize = self.m_butes_node:getContentSize()

    local params = {};
    params.viewSize = viewSize;
    params.row = 6;--行
    params.column = 1; --列
    params.totalItem = #butes -- totalItem;
    params.direction = kCCScrollViewDirectionVertical;
    params.showPageIndex = self.m_curPage;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create();
            ccbNode:openCCBFile("ccb/ui_element_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_prop_node = ccbNode:spriteForName("m_prop_node")
            local m_card_numbel = ccbNode:labelTTFForName("m_card_numbel")
            local m_eleme_numble = ccbNode:labelTTFForName("m_eleme_numble")
            m_eleme_numble:setString("+"..butes[index+1][2])

            local attrName = self.m_effect_dictTab[butes[index+1][1]]
            cclog(attrName,"attrName")
            m_card_numbel:setString(selItemData[attrName])

            local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. (butes[index+1][1] or 0)]
            local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tostring(abilityItem.icon))
            if tempSpriteFrame then
                m_prop_node:setDisplayFrame(tempSpriteFrame)
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        
    end
    local tableView = TableViewHelper:create(params);
    self.m_butes_node:addChild(tableView)
end

--[[--
    刷新ui
]]
function game_element_tupo.refreshUi(self)
    local totalFood = game_data:getUserStatusDataByKey("food") or 0
    local value,unit = game_util:formatValueToString(totalFood);
    self.m_metal_total_label:setString(value .. unit);

    if not self.m_selHeroId then
        return
    end
    local selItemData,selItemCfg = game_data:getCardDataById(tostring(self.m_selHeroId));

    if selItemData.element_break then
        self.m_element_level:setString("Cấp đột phá:"..selItemData.element_break)  --突破等级
        if selItemData.element_break >= 20 then
            self.m_material_Layer:setVisible(false)
            self.m_element_huot:setVisible(true)
        else
            self.m_material_Layer:setVisible(true)
            self.m_element_huot:setVisible(false)
        end  
    else
        self.m_element_level:setString("Cấp đột phá：0")
        self.m_material_Layer:setVisible(true)
        self.m_element_huot:setVisible(false)
    end
    
end
--[[--
    初始化
]]
function game_element_tupo.init(self,t_params)
    t_params = t_params or {};
    self.m_material_node_tab = {}
    self.m_materialDataTable = {}
    
    local selSort = game_data:getCardSortType();
    for k,v in pairs(CARD_SORT_TAB) do
        if v.sortType == selSort then
            self.m_selSortIndex = k;
            break;
        end
    end
    self.m_materialTab = {}
    self.m_effect_dictTab = {}
    self.m_selSortIndex = self.m_selSortIndex or 1;
    self.m_newCardsTab,_,_,_,_,_,_ = game_data:getCardsDataSimple()
    local material =  getConfig(game_config_field.breakthrough)
    self.m_materialTab = json.decode(material:getFormatBuffer())

    --cclog2(material_tab,"material_tab")
    -- for k,v in pairs(material_tab) do
    --     cclog(type(k))
    --     cclog(string.sub(k,5,6))
    --     -- self.m_materialTab[v.character_id] = {}  
    --     -- self.m_materialTab[v.character_id] = v
    -- end 

    for k,v in pairs(CHAIN_EFFECT_NUM_NAME_DICT) do
        self.m_effect_dictTab[v.typeValue] = {}  
        self.m_effect_dictTab[v.typeValue] = v.attrName
    end
    game_data:cardsSortByTypeNameWithTable("default",self.m_newCardsTab)
end

--[[--
    创建ui入口并初始化数据
]]
function game_element_tupo.create(self,t_params)
    -- body
    self:init(t_params);
    local uiNode = self:createUi();
    self:refreshUi();
    self:refreshSortTabBtn(1)
    return uiNode;
end

return game_element_tupo;
