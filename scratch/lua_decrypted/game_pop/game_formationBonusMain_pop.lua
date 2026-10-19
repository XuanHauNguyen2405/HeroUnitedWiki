--阵法
local game_formationBonusMain_pop = {


    m_tempFriendData = nil,
    m_posIndex = nil,
    m_tempSelIndex = nil,
    m_tempFriendData = nil,
    m_tempEquipPosData = nil,
    m_tGameData = nil,
    m_replace_btn = nil,
    m_sel_bg = nil,
    m_node_infodetailBoar = nil,

    m_life_label = nil,
    m_physical_atk_label = nil,
    m_magic_atk_label = nil,
    m_def_label = nil,
    m_speed_label = nil,
    m_life_label2 = nil,
    m_physical_atk_label2 = nil,
    m_magic_atk_label2 = nil,
    m_def_label2 = nil,
    m_speed_label2 = nil,
    m_anim_node = nil,
    m_fate_detail_node = nil,
    m_fate_node = nil,
    m_equip_layer = nil,
    m_formation_layer = nil,
    m_replace_equip_btn = nil,
    m_oneFateScrollView = nil,
    m_ccbNode = nil,
    m_fate_list_view_bg =  nil,
    m_adjust1 = nil,
    m_adjust2 = nil,
    m_scrollView = nil,
    m_fate_label = nil,
    m_tempAssEquipPosData = nil,
    m_combatNumberChangeNode = nil,
    m_combat_label = nil,
    m_fateDataTab = nil,
    m_addTable = nil,
    m_lab_Addlife = nil,
    m_lab_AddAtk = nil,
    m_lab_AddMag = nil,
    m_lab_AddDef = nil,
    m_lab_AddSpeed = nil,
    m_bonusAddTab = nil,
    m_tempCombatValue = nil,
    m_activation_node = nil,
};
--[[--
    销毁ui
]]
function game_formationBonusMain_pop.destroy(self)
    -- body
    cclog("-----------------game_formationBonusMain_pop destroy-----------------");
    self.m_tGameData = nil;
    self.m_replace_btn = nil;
    self.m_sel_bg = nil;
    self.m_node_infodetailBoar = nil;
    self.m_life_label = nil;
    self.m_physical_atk_label = nil;
    self.m_magic_atk_label = nil;
    self.m_def_label = nil;
    self.m_speed_label = nil;
    self.m_life_label2 = nil;
    self.m_physical_atk_label2 = nil;
    self.m_magic_atk_label2 = nil;
    self.m_def_label2 = nil;
    self.m_speed_label2 = nil;
    self.m_anim_node = nil;
    self.m_fate_detail_node = nil;
    self.m_fate_node = nil;
    self.m_equip_layer = nil;
    self.m_formation_layer = nil;
    self.m_replace_equip_btn = nil;
    self.m_tempSelIndex = nil;
    self.m_oneFateScrollView = nil;
    self.m_tempFriendData = nil;
    self.m_posIndex = nil;
    self.m_tempEquipPosData = nil;
    self.m_ccbNode = nil;
    self.m_fate_list_view_bg = nil;
    self.m_adjust1 = nil;
    self.m_adjust2 = nil;
    self.m_scrollView = nil;
    self.m_tempAssEquipPosData = nil;
    self.m_fate_label = nil;
    self.m_combatNumberChangeNode = nil;
    self.m_combat_label = nil;
    self.m_fateDataTab = nil;
    self.m_addTable = nil;
    self.m_lab_Addlife = nil;
    self.m_lab_AddAtk = nil;
    self.m_lab_AddMag = nil;
    self.m_lab_AddDef = nil;
    self.m_lab_AddSpeed = nil;
    self.m_bonusAddTab = nil;
    self.m_tempCombatValue = nil;
    self.m_activation_node = nil;
end
--[[--
    返回
]]
function game_formationBonusMain_pop.back(self,type)

    if self.m_openType == "equip_strengthen" then
        -- cclog("self.select_temp_id = " .. self.select_temp_id)
        game_scene:enterGameUi("equipment_strengthen",{selEquipId = self.select_temp_id});
        self:destroy();
    elseif self.m_openType == "equip_evolution" then
        game_scene:enterGameUi("equip_evolution",{selEquipId = self.select_temp_id});
        self:destroy();
    else
        local params  = self:getParams()
        function responseMethod(tag,gameData)
            game_scene:removePopByName("game_formationBonusMain_pop")
            if self.callBackFunc then
               self.callBackFunc()
            end 
            self:destroy()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_set_bonus_formation"), http_request_method.GET, params,"cards_set_bonus_formation")
    end
end
--[[--
    读取ccbi创建ui
]]
function game_formationBonusMain_pop.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        cclog2(btnTag,"btnTag ==== ")
        if btnTag == 1 then--返回
            self:back();
        elseif btnTag == 11 then
            if self.m_teamIndex == 1 then
                if self.m_posIndex == -1 or self.m_tempTeamData[self.m_posIndex] == "-1" then return end
                self:addSelHeroUi(self.m_posIndex);
            else
                if self.m_posIndex == -1 or self.m_tempFriendData[self.m_posIndex] == "-1" then return end
                self:addFriendSelHeroUi(self.m_posIndex);                
            end
        elseif btnTag == 31 then
            self:autoMatchEquip(self.m_posIndex)
            self:refreshHeroInfo(self.m_posIndex);
        elseif btnTag == 101 then
            local tempid = self.m_tempFriendData[self.m_posIndex]
            if tempid and tempid ~= "0" and tempid ~= "-1" then
                local function popBackFunC()
                    self:refreshUi()
                end
                local params  = self:getParams()
                function responseMethod(tag,gameData)
                    game_scene:addPop("game_formationBonus_zhenfa_pop",{pos = self.m_posIndex,popBackFunC = popBackFunC})
                end
                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_set_bonus_formation"), http_request_method.GET, params,"cards_set_bonus_formation")
            else
                game_util:addMoveTips({text = "Ô không có thẻ ra trận"})
            end
        elseif btnTag == 504 then
                self.m_magic_layer:setVisible(game_data:isViewShowByID(201))
                self.m_magic_layer:setTouchEnabled(game_data:isViewShowByID(201))
                self.m_eq_layer:setVisible(true)
                self.m_eq_layer:setTouchEnabled(true)
                self.m_activation_node:setVisible(true)
                self.node_bloodDetal:setVisible(false)

                self.m_fate_detail_node:setVisible(false)
        elseif btnTag == 505 then -- 法宝
            self.m_magic_layer:setVisible(false)
            self.m_magic_layer:setTouchEnabled(false)
            self.m_eq_layer:setVisible(false)
            self.m_eq_layer:setTouchEnabled(false)
            self.m_activation_node:setVisible(false)
            self.node_bloodDetal:setVisible(false)

            self.m_fate_detail_node:setVisible(true)
            -- end
        elseif btnTag == 506 then -- 血石
            self.m_fate_detail_node:setVisible(false);
            self.m_magic_layer:setVisible(false)
            self.m_magic_layer:setTouchEnabled(false)
            self.m_eq_layer:setVisible(false)
            self.m_eq_layer:setTouchEnabled(false)
            self.m_activation_node:setVisible(false);

            self.node_bloodDetal:setVisible(true)
        elseif btnTag == 5061 then -- 打开赋能界面
            game_scene:enterGameUi("game_bloodStone_index",{})
            self:destroy();

        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_formation_bonus_main_pop.ccbi");

    self.m_replace_btn = ccbNode:controlButtonForName("m_replace_btn")
    self.m_sel_bg = ccbNode:spriteForName("m_sel_bg")
    self.m_node_infodetailBoar = ccbNode:nodeForName("m_node_infodetailBoar")
    self.m_life_label = ccbNode:labelBMFontForName("m_life_label")
    self.m_physical_atk_label = ccbNode:labelBMFontForName("m_physical_atk_label")
    self.m_magic_atk_label = ccbNode:labelBMFontForName("m_magic_atk_label")
    self.m_def_label = ccbNode:labelBMFontForName("m_def_label")
    self.m_speed_label = ccbNode:labelBMFontForName("m_speed_label")
    self.m_life_label2 = ccbNode:labelBMFontForName("m_life_label2")
    self.m_physical_atk_label2 = ccbNode:labelBMFontForName("m_physical_atk_label2")
    self.m_magic_atk_label2 = ccbNode:labelBMFontForName("m_magic_atk_label2")
    self.m_def_label2 = ccbNode:labelBMFontForName("m_def_label2")
    self.m_speed_label2 = ccbNode:labelBMFontForName("m_speed_label2")
    self.m_anim_node = ccbNode:nodeForName("m_anim_node")
    self.m_fate_detail_node = ccbNode:nodeForName("m_fate_detail_node")
    self.m_fate_node = ccbNode:nodeForName("m_fate_node")
    self.m_equip_layer = ccbNode:layerForName("m_equip_layer")
    self.m_formation_layer = ccbNode:layerForName("m_formation_layer")
    self.m_replace_equip_btn = ccbNode:controlButtonForName("m_replace_equip_btn")
    self.m_fate_list_view_bg = ccbNode:nodeForName("m_fate_list_view_bg")
    self.m_adjust1 = ccbNode:nodeForName("m_adjust1");
    self.m_adjust2 = ccbNode:nodeForName("m_adjust2");
    self.m_scrollView = ccbNode:scrollViewForName("m_scrollView");
    self.m_combat_label = ccbNode:labelBMFontForName("m_combat_label")
    self.m_lab_Addlife = ccbNode:labelBMFontForName("m_lab_Addlife")
    self.m_lab_AddAtk = ccbNode:labelBMFontForName("m_lab_AddAtk")
    self.m_lab_AddMag = ccbNode:labelBMFontForName("m_lab_AddMag")
    self.m_lab_AddDef = ccbNode:labelBMFontForName("m_lab_AddDef")
    self.m_lab_AddSpeed = ccbNode:labelBMFontForName("m_lab_AddSpeed")
    self.m_activation_node = ccbNode:nodeForName("m_activation_node")
    local m_replace_equip_btn = ccbNode:controlButtonForName("m_replace_equip_btn")
    m_replace_equip_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    self.m_combat_label:setVisible(false);
    local m_root_layer = ccbNode:layerForName("m_root_layer")
    local m_close_btn  = ccbNode:controlButtonForName("m_close_btn")
    m_close_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    self.m_replace_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2)
    -- local labelsize = self.m_fate_node:getContentSize();
    -- self.m_fate_label = game_util:createRichLabelTTF({text = "",dimensions = labelsize,textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = nil,color = ccc3(221,221,192)})
    -- self.m_fate_label:setAnchorPoint(ccp(0, 0.25));
    -- self.m_fate_node:addChild(self.m_fate_label)
    local pX,pY = self.m_combat_label:getPosition();
    self.m_combatNumberChangeNode = game_util:createExtNumberChangeNode({labelType = 2});
    self.m_combatNumberChangeNode:setPosition(ccp(pX, pY));
    self.m_combatNumberChangeNode:setAnchorPoint(ccp(0, 0.5));
    self.m_combat_label:getParent():addChild(self.m_combatNumberChangeNode);
    self.m_combatNumberChangeNode:setCurValue(0,false);
    local m_btn_zhenfa = ccbNode:controlButtonForName("m_btn_zhenfa")
    m_btn_zhenfa:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    local m_weam_btn = ccbNode:controlButtonForName("m_weam_btn")
    self.m_magic_node = ccbNode:nodeForName("m_magic_btnnode")
    self:createAnim()
    local m_magic_btn = ccbNode:controlButtonForName("m_magic_btn")
    m_weam_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    m_magic_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)

    local btn_bloodStone = ccbNode:controlButtonForName("btn_bloodStone")
    btn_bloodStone:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    local btn_openBloodStone = ccbNode:controlButtonForName("btn_openBloodStone")
    btn_openBloodStone:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    local sc_blood = ccbNode:scrollViewForName("sc_blood")
    sc_blood:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)

    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;--intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-1,true);
    m_root_layer:setTouchEnabled(true);
    self.m_ccbNode = ccbNode
    self.m_magic_layer = ccbNode:layerForName("m_magic_layer")
    self.m_eq_layer = ccbNode:layerForName("m_eq_layer")
    self.m_magic_layer:setVisible(game_data:isViewShowByID(201))
    self.m_eq_layer:setVisible(true)
    self.m_fate_node1 = ccbNode:nodeForName("fate_node1")
    self.m_fate_node2 = ccbNode:nodeForName("fate_node2")
    self.m_spr_mingyunnode = ccbNode:spriteForName("m_spr_mingyunnode")
    
    self.node_bloodDetal = ccbNode:nodeForName("node_bloodDetal")
    self.node_bloodDetal:setVisible(false)

    return ccbNode;
end



function game_formationBonusMain_pop:createAnim()
    self.m_magic_node:removeAllChildrenWithCleanup(true)
    local onAnimSectionEnd = function(animNode, theId,theLabelName)
        animNode:playSection(theLabelName)
    end
    local anim = game_anim:create("effect_anniu.swf.sam",0,"effect_anniu-hd.plist");
    if anim then
        anim:registerScriptTapHandler(onAnimSectionEnd)
        game_anim:playSection(anim,"effect")
        self.m_magic_node:addChild(anim,1,3)
    end
end


function game_formationBonusMain_pop.getParams( self )
    local params  = {}
    local function getEquipParams()
        local equipStr = ""
        for pos=1,9 do
            local paramsId = ""
            for sort=1,4 do
                paramsId = paramsId .. self.m_tempAssEquipPosData[tostring(pos+199)][sort] .. (sort == 4 and "" or "_") 
            end
            if self.m_tempFriendData[pos] == "0" or self.m_tempFriendData[pos] == "-1" then
                paramsId = "0_0_0_0"
            end
            local str = "bonus_equip_" .. pos
            params["bonus_equip_" .. pos] = paramsId
        end
    end
    getEquipParams()
    local function getMagicParams()
        local equipStr = ""
        for pos=1,9 do
            local paramsId = ""
            for sort=1,4 do
                local str = ""
                if self.m_tempAssMagicPosData[tostring(pos+199)] and self.m_tempAssMagicPosData[tostring(pos+199)][sort] then
                    str = self.m_tempAssMagicPosData[tostring(pos+199)][sort] 
                else
                    str = "0" 
                end
                paramsId = paramsId .. str .. (sort == 4 and "" or "_") 
            end
            if self.m_tempFriendData[pos] == "0" or self.m_tempFriendData[pos] == "-1" then
                paramsId = "0_0_0_0"
            end
            local str = "bonus_talisman_" .. pos
            params["bonus_talisman_" .. pos] = paramsId
        end
    end
    getMagicParams()
    local  str = ""
    for i=1,9 do
        str = str .. self.m_tempFriendData[i] .. (i == #self.m_tempFriendData and "" or "_") 
    end
    params.formation = str
    return params
end
function game_formationBonusMain_pop.isEquipCanUse( self, posIndex, equipId, equipSortIndex )
    local tempEquipTable = nil
    local formationEquipData = game_data:getEquipPosData()
    local formationEquipData2 = game_data:getAssEquipPosData()
    for k,v in pairs(formationEquipData) do
        v = v or {}
        if v[equipSortIndex] == equipId then
            return false
        end
    end

    if self.m_teamIndex == 2 then posIndex = tostring(posIndex + 199) end
    for k,v in pairs(formationEquipData2) do
        v = v or {}
        if v[equipSortIndex] == equipId then
            return false
        end
    end
    return true
end

--[[
    自动穿装备
]]
function game_formationBonusMain_pop.autoMatchEquip( self, cardIndex )
    if self.m_teamIndex == 1 then
        
    elseif self.m_teamIndex == 2 then
        local cardData,cardCfg = self:getFriendCardDataByPos( cardIndex  );
        if not cardCfg then return end
        local curPosEquip = self.m_tempAssEquipPosData[tostring(cardIndex + 199)]
        -- cclog2(curPosEquip, "curPosEquip " .. cardIndex .."   ====    ")
        local recommendEquip = {"0","0","0","0"}
        local recommendEquipData = {}

        local chainEquipDataTab = game_util:cardEquipChainByCfg(cardCfg, cardData.id)
        -- cclog2(chainEquipDataTab, "chainEquipDataTab  =====   ")
        local equipTable = game_data:getEquipIdTable()
        -- cclog2(equipTable, "auto equip all equipTable  =====   ")
        local equipCfg = getConfig(game_config_field.equip);
        local existFlag,cardName, pos = true, nil, nil
        local itemData, itemCfg = nil, nil
        local noExchangeTab = {1,1,1,1}
        for i,v in ipairs(equipTable) do
            itemData, itemCfg = game_data:getEquipDataById(tostring(v));
            -- cclog2(itemData, tostring(i) .. "auto equip  itemData  =====   ")
            -- cclog2(itemCfg, tostring(i) .. "auto equip  itemCfg  =====   ")
            local equipSort = itemCfg:getNodeWithKey("sort") and itemCfg:getNodeWithKey("sort"):toInt() or 0
            local canUseFlag = true
            if equipSort and not self:isEquipCanUse(cardIndex, v, equipSort) then
                -- cclog2(" 这个装备属于 别人装备的")
                canUseFlag = false
            end
            if itemData.bind_card and itemData.bind_card ~= "" then
                canUseFlag = false
            end
            local existFlag2,pos = game_data:equipInBonus(equipSort,tostring(v))
            if existFlag2 then
                canUseFlag = false
            end
            if canUseFlag then -- 可以装备
                if recommendEquip[equipSort] == "0" then  -- 这个位置没有装备任何东西呢
                    recommendEquip[equipSort] = v  
                    recommendEquipData[equipSort] = {itemData = itemData, itemCfg = itemCfg }
                else -- 已经有装备
                    local isThisChainFlag = game_util:isCardChainEquip(itemCfg, chainEquipDataTab ) or false
                    local autoFlag = true
                    if autoFlag and isThisChainFlag == false then
                        local isCurChainFlag = game_util:isCardChainEquip(recommendEquipData[equipSort].itemCfg, chainEquipDataTab ) or false
                        if isCurChainFlag == true then
                            autoFlag = false
                        end
                    elseif autoFlag and isThisChainFlag == true then
                        local isCurChainFlag = game_util:isCardChainEquip(recommendEquipData[equipSort].itemCfg, chainEquipDataTab ) or false
                        if isCurChainFlag == false then
                            autoFlag = false
                            recommendEquip[equipSort] = v  
                            recommendEquipData[equipSort].itemData = itemData
                            recommendEquipData[equipSort].itemCfg = itemCfg
                        end
                    end

                    if autoFlag then 
                        local curEquiplevel = recommendEquipData[equipSort].itemData.lv or 0
                        local curAddHP = game_util:getEquipHPAttributeValue(recommendEquipData[equipSort].itemCfg,curEquiplevel);
                        local thisEquiplevel = itemData.lv or 0
                        local thisAddHP = game_util:getEquipHPAttributeValue(itemCfg,thisEquiplevel);
                        if curAddHP < thisAddHP then
                            recommendEquip[equipSort] = v  
                            recommendEquipData[equipSort].itemData = itemData
                            recommendEquipData[equipSort].itemCfg = itemCfg
                        end
                    end
                end
            end
        end
        if cardData.bind_equip and next(cardData.bind_equip) then
            for k,v in pairs(cardData.bind_equip) do
                for i=1,4 do
                    if tonumber(curPosEquip[i]) == v and v~=0 then
                        noExchangeTab[i] = 0
                    end
                end
            end
        end

        for i=1,4 do

            if recommendEquip[i] ~= "0" and recommendEquip[i] ~= curPosEquip[i] and noExchangeTab[i] ~= 0 then
                
                self.m_selEquipId = curPosEquip[i];
                self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                self:updateAssEquipPosData(cardIndex,i,recommendEquip[i]);
                self.m_changeFlag = true;
                self:refreshHeroInfo(self.m_posIndex)
                self:newChainOpenAnim("equip");
            end
        end

        -- self:autoMatchFateEquip(cardData.id,cardIndex)
    end
end

--[[--
    初始化助威
]]
function game_formationBonusMain_pop:initFriend(  )
    -- self.m_fate_label:setVisible(true);
    self.m_fate_detail_node:setVisible(false);
    local tempSize = self.m_fate_detail_node:getContentSize();
    tempSize = CCSizeMake(tempSize.width,150);
    self.m_fate_detail_node:setContentSize(tempSize);
    self.m_fate_detail_node:removeAllChildrenWithCleanup(true);
    local scrollView = CCScrollView:create(tempSize);
    scrollView:setDirection(kCCScrollViewDirectionVertical);
    self.m_fate_detail_node:addChild(scrollView,2,2);
    self.m_oneFateScrollView = scrollView;
    self.m_oneFateScrollView:setTouchPriority(GLOBAL_TOUCH_PRIORITY-3)
    self.m_oneFateScrollView:setTouchEnabled(true)
    self:clearFateTabView();
    self.m_teamIndex = 2;
    self:initFriendFormation(self.m_formation_layer); 

    if self.isVisible ~= nil then
    m_magic_btn:setVisible()
        if game_data:isViewOpenByID(201) then
            self.m_magic_layer:setTouchEnabled(self.isVisible)
        else
            self.m_magic_layer:setTouchEnabled(false)
        end
        self.m_eq_layer:setTouchEnabled(self.isVisible)
    else
        if game_data:isViewOpenByID(201) then
            self.m_magic_layer:setTouchEnabled(self.m_magic_layer:isVisible())
        else
            self.m_magic_layer:setTouchEnabled(false)
        end
        self.m_eq_layer:setTouchEnabled(self.m_eq_layer:isVisible())
    end
    -- self.m_sel_bg:setVisible(true);
    self.m_posIndex = self.m_tempSelIndex;
    self:getAddRate()
    self:refreshHeroInfo(self.m_posIndex);
 
    if self.m_posIndex == -1 then
        self:refreshFriendScroll();
        self:refreshFateSummaryTableView();
        -- self.m_adjust1:setVisible(false);
    else
        -- self.m_adjust1:setVisible(true);
    end
end
--命运栏
function game_formationBonusMain_pop.createFateSummaryTableView(self, viewSize)
    local shwoData = self.m_fateDataTab or {}
    local showCount = #shwoData
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;
    params.column = 2; --列
    params.totalItem = showCount;
    params.touchPriority = GLOBAL_TOUCH_PRIORITY-1;
    params.showPoint = false
    params.itemActionFlag = false;
    params.direction = kCCScrollViewDirectionVertical;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local ccbNode = luaCCBNode:create()            
            ccbNode:openCCBFile("ccb/ui_adjustment_fate_item.ccbi")
            ccbNode:setAnchorPoint(ccp(0.5,0.5))
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_node = ccbNode:nodeForName("m_node")
            local m_fate_label = ccbNode:labelTTFForName("m_fate_label")
            m_node:removeAllChildrenWithCleanup(true)
            local itemData = shwoData[showCount - index]
            local cardData,cardCfg = game_data:getCardDataById(itemData.cardId)
            local tempIcon = game_util:createCardIconByCfg(cardCfg,cardData);
            if tempIcon then
                tempIcon:setScale(0.75);
                m_node:addChild(tempIcon);
            end
            m_fate_label:setString(tostring(itemData.openChainCount) .. "/" .. tostring(itemData.chainCount))
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            self:refreshFateTabBtn(2)
            local tempHeight = 0;
            for i=1,math.min(showCount - index,showCount) do
                tempHeight = tempHeight + shwoData[i].itemHeight;
            end
            local contentSize = self.m_scrollView:getContentSize();
            local viewSize = self.m_scrollView:getViewSize();
            if tempHeight < viewSize.height then
                self.m_scrollView:setContentOffset(ccp(0,0),false)
            else
                self.m_scrollView:setContentOffset(ccp(0,math.max(-tempHeight+viewSize.height,-contentSize.height+viewSize.height)),false)
            end
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
    end
    return TableViewHelper:create(params);
end
function game_formationBonusMain_pop.refreshFateSummaryTableView(self)
    self.m_fate_list_view_bg:removeAllChildrenWithCleanup(true)
    local tempTableView = self:createFateSummaryTableView(self.m_fate_list_view_bg:getContentSize())
    self.m_fate_list_view_bg:addChild(tempTableView)
end
function game_formationBonusMain_pop.clearFateTabView(self)
    self.m_fate_list_view_bg:removeAllChildrenWithCleanup(true)
    self.m_scrollView:getContainer():removeAllChildrenWithCleanup(true)
end
--[[--
    初始化小伙伴页面
]]
function game_formationBonusMain_pop:initFriendFormation( formation_layer )
    cclog(" -----initFriendFormation---------")
    self.m_tempSelIndex = -1
    local level = game_data:getUserStatusDataByKey("level");
    local itemIcon = nil;
    local headIconSpr = nil;
    local tempLock = nil;
    local character_detail_cfg = getConfig("character_detail");
    local tempLockIndex,selLevel = -1,100;
    local smallTag1 = 1;
    local smallTag2 = 7;
    local tempTxt = nil;
    -- cclog2(self.m_tempFriendData,"m_tempFriendData === ")

    local assistant_cfg = getConfig(game_config_field.formation_bonus);
    -- cclog2(assistant_cfg,"assistant_cfg === ")
    local sort = 0;
    for i=1,9 do
        local assistant_cfg_item = assistant_cfg:getNodeWithKey(tostring(i))
        sort = assistant_cfg_item:getNodeWithKey('sort'):toInt();
        -- cclog2(sort,"sort " .. i .. "============   ") 
        itemIcon = self.m_ccbNode:spriteForName("m_pos_" .. i)
        formation_layer:reorderChild(itemIcon,-1000)
        local headIconBgSize = itemIcon:getContentSize();
        local pX,pY = headIconBgSize.width/2,headIconBgSize.height/2
        itemIcon:removeAllChildrenWithCleanup(true);
        if self.m_tempFriendData[i] ~= "-1" then
            if(sort == 1)then
                smallTag1 = i+1;   
            else
                smallTag2 = i+1;
            end
        else
            tempLock = CCSprite:createWithSpriteFrameName("dw_suo.png");
            tempLock:setPosition(ccp(pX,pY));
            itemIcon:addChild(tempLock);
            local limit_lv = assistant_cfg_item:getNodeWithKey("limit_lv"):toInt();
            if level < limit_lv then
               local tempLabel = game_util:createLabelBMFont({text = "Giới hạn:" .. limit_lv .. "LV",color = ccc3(0, 255, 0)});    
               tempLabel:setPosition(ccp(headIconBgSize.width/2,10));
               itemIcon:addChild(tempLabel);
            else            
               if(smallTag1 == i and i < 7)then
                   local spriteTxt = CCSprite:createWithSpriteFrameName("dw_dianjiwenzi.png");
                   spriteTxt:setPosition(ccp(headIconBgSize.width/2,headIconBgSize.height/2));
                   itemIcon:addChild(spriteTxt,3,3);
               end
               if(smallTag2 == i and i > 6)then
                   local spriteTxt = CCSprite:createWithSpriteFrameName("dw_dianjiwenzi.png");
                   spriteTxt:setPosition(ccp(headIconBgSize.width/2,headIconBgSize.height/2));
                   itemIcon:addChild(spriteTxt,3,3);
               end
            end
        end
        --全命运开启效果
        --createCardAnimByFriendPos 是助阵的
        -- local backAnimNode = self:createCardAnimByFriendPos(i)--全命运后面的动画
        local animNode = self:createCardAnimByFriendPos(i,false)
        if animNode then
            -- backAnimNode:setScale(2)
            -- backAnimNode:setPosition(ccp(pX,headIconBgSize.height*0.1));
            -- backAnimNode:setColor(ccc3(255,255,0))
            -- itemIcon:addChild(backAnimNode,1,2)
            animNode:setPosition(ccp(pX,headIconBgSize.height*0.1));
            itemIcon:addChild(animNode,1,1);
            if self.m_tempSelIndex == -1 then
                self.m_tempSelIndex = i;
            end
        end
        self:setPositionBg2(i);
    end
    self:initFriendFormationTouch(self.m_formation_layer);
    self:initFriendEquipLayerTouch(self.m_eq_layer);
    self:initFriendMagicLayerTouch(self.m_magic_layer)
    self.m_magic_layer:setTouchEnabled(self.m_magic_layer:isVisible())
    self.m_eq_layer:setTouchEnabled(self.m_eq_layer:isVisible())

end
function game_formationBonusMain_pop:refreshFriendScroll(  )
    self.m_scrollView:getContainer():removeAllChildrenWithCleanup(true)
    local layer = self:initFriendScroll();
    self.m_scrollView:addChild(layer,1024,1024);
end

--[[
    
]]
function game_formationBonusMain_pop.addChainItemView(self, layer, cardData, cardCfg, offsetY)
    if cardData and cardCfg then
        local chainTab,chainCount,openChainCount = game_util:cardChainByCfg(cardCfg,cardData.id)
        local fate_detail = game_util:createRichLabelTTF({text = "",dimensions = CCSizeMake(170,0),textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = nil,color = ccc3(221,221,192)});
        if #chainTab > 0 then
            local showStr = ""
            local nameStr = "";
            for i=1,#chainTab do
                showStr = showStr .. chainTab[i].detail .. "\n"
                nameStr = nameStr .. "    " .. chainTab[i].name .. (i == 3 and "\n" or "")
            end
            fate_detail:setString(showStr)
        else
            fate_detail:setString("Không có");
        end
        local fateSz = fate_detail:getContentSize();
        local tempHeight = math.max(fateSz.height,50)
        fate_detail:setPosition(ccp(90,offsetY+tempHeight/2));
        layer:addChild(fate_detail);
        local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_zidi.png")
        if tempSpriteFrame then
            local tempSpri = CCScale9Sprite:createWithSpriteFrame(tempSpriteFrame)
            tempSpri:setPreferredSize(CCSizeMake(100, 18));
            tempSpri:setAnchorPoint(ccp(0.5,0))
            tempSpri:setPosition(ccp(55,offsetY + tempHeight+5));
            layer:addChild(tempSpri);
        end
        local name = cardCfg:getNodeWithKey("name"):toStr();
        local tempLabel = game_util:createLabelTTF({text = name,color = ccc3(250,180,0),fontSize = 12});
        tempLabel:setAnchorPoint(ccp(0.5,0))
        tempLabel:setPosition(ccp(55,offsetY + tempHeight+7));
        layer:addChild(tempLabel);
        offsetY = offsetY+tempHeight+30;
        -- local tempIcon = game_util:createCardIconByCfg(cardCfg);
        -- local iconSz = tempIcon:getContentSize();
        -- tempIcon:setPosition(ccp(30,offsetY-iconSz.height/2 - 10));
        -- layer:addChild(tempIcon);
        table.insert(self.m_fateDataTab,{chainCount = chainCount,openChainCount = openChainCount,cardId = cardData.id, itemHeight = tempHeight+30})
    end
    return offsetY;
end
function game_formationBonusMain_pop:initFriendScroll(  )
    -- body
    self.m_fateDataTab = {};
    local layer = CCLayer:create();
    local scrollContent = self.m_scrollView:getContentSize();
    local offsetY = 0;
    for k,v in pairs(self.m_tempFriendData) do
        local cardData,cardCfg = self:getFriendCardDataByPos(k);
        offsetY = self:addChainItemView(layer, cardData, cardCfg, offsetY);
    end
    -- for k,v in pairs(self.m_tempTeamData) do
    --     local cardData,cardCfg = self:getTeamCardDataByPos(k);
    --     offsetY = self:addChainItemView(layer, cardData, cardCfg, offsetY);
    -- end
    scrollContent.height = offsetY;
    self.m_scrollView:setContentSize(scrollContent);
    self.m_scrollView:setContentOffset(ccp(0,269-offsetY));
    return layer;
end
--[[
    
]]
function game_formationBonusMain_pop.refreshFriendPositionAttr( self, posIndex, assistant_cfg_item)

end

--[[
    助威阵型触摸
]]
function game_formationBonusMain_pop.initFriendFormationTouch( self,formation_layer )
    cclog(" -----initFriendFormationTouch---------")
    local level = game_data:getUserStatusDataByKey("level"); 
    local beganItem,selItem = nil,nil
    local touchBeginPoint = nil
    local touchMoveFlag = false;
    local function onTouchBegan( x,y )
        if selItem then
            selItem:removeFromParentAndCleanup(true);
            selItem = nil;
        end
        touchMoveFlag = false
        touchBeginPoint = {x = x, y = y}
        local realPos = formation_layer:convertToNodeSpace(ccp(x,y));
        -- CCTOUCHBEGAN event must return true
        for tag = 1,9 do
            beganItem = self.m_ccbNode:spriteForName("m_pos_" .. tag)
            if beganItem and beganItem:boundingBox():containsPoint(realPos) then
                selItem = self:createCardAnimByFriendPos(tag,false)
                if selItem == nil then break end
                local pX,pY = beganItem:getPosition();
                selItem:setPosition(ccp(pX,pY));
                -- selItem:setColor(ccc3(128,128,128));
                formation_layer:addChild(selItem,11,11);
                selItem:setVisible(false);
                break;
            end
        end
        return true
    end
    local function onTouchMoved( x,y )
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            if selItem then
                local realPos = formation_layer:convertToNodeSpace(ccp(x,y));
                selItem:setPosition(realPos);
                selItem:setVisible(true);
            end
            touchMoveFlag = true;
        end
    end
    local function onTouchEnded( x,y )
        local realPos = formation_layer:convertToNodeSpace(ccp(x,y));
        local smallTag1 = 9;
        local smallTag2 = 9;
        local assistant_cfg = getConfig(game_config_field.formation_bonus);
        local sort = 0

        for endTag = 1,9 do
            local assistant_cfg_item = assistant_cfg:getNodeWithKey(tostring(endTag))
            sort = assistant_cfg_item:getNodeWithKey('sort'):toInt();
            local tempid = self.m_tempFriendData[endTag]
            if tempid == "-1" then
                if(sort == 1)then
                  smallTag1 = math.min(smallTag1,endTag);
                else
                  smallTag2 = math.min(smallTag2,endTag);
                end
            end
            endItem = self.m_ccbNode:spriteForName("m_pos_" .. endTag)
            if endItem and endItem:boundingBox():containsPoint(realPos) then
                local beganTag = beganItem:getTag();
                if(endTag == beganTag)then
                    cclog2(tempid,"tempId =")
                    if tempid == "-1" then
                        if(smallTag1 == endTag or smallTag2 == endTag)then
                            local limit_lv = assistant_cfg_item:getNodeWithKey("limit_lv"):toInt();
                            if level < limit_lv then
                                -- game_util:addMoveTips({text = "等级不够！"})
                                break;
                            end
                            local t_params = {}
                            t_params.okBtnCallBack = function()
                                local function responseMethod(tag,gameData)
                                    game_util:addMoveTips({text = "Đã mở!"});
                                    local my = gameData:getNodeWithKey("data"):getNodeWithKey("formation_bonus")
                                    game_data:setFormationBonusByJsonData(my);
                                    local assistantData = game_data:getFormationBonusByJsonData();
                                    local tempData = util.table_copy(self.m_tempFriendData)
                                    self.m_tempFriendData = assistantData
                                    for k,v in pairs(tempData) do
                                        if v ~= "-1" then
                                            self.m_tempFriendData[k] = v;
                                        end
                                    end
                                    self:initFriendFormation(self.m_formation_layer);
                                    game_scene:removePopByName("game_assistant_pop");
                                end
                                network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_activate_bonus_formation"), http_request_method.GET, {pos = endTag-1},"cards_activate_bonus_formation")
                            end
                            t_params.index = endTag
                            t_params.openType = 3
                            game_scene:addPop("game_assistant_pop",t_params)
                        end
                    -- elseif tempid == "0" then
                    --     self:addFriendSelHeroUi(endTag);
                    else
                        self.m_posIndex = endTag;
                        self:setPositionBg2(endTag,true);
                        self:refreshHeroInfo(endTag);
                    end
                else
                    if selItem then
                        if tempid == "-1" then--未开启
                            game_util:addMoveTips({text = "Chưa mở ô trợ uy!"})
                        else
                            self:exchangeFriendDataByTwoPos(beganTag,endTag)
                            self.m_changeFlag = true;
                            local bgSize = endItem:getContentSize();
                            beganItem:removeAllChildrenWithCleanup(true)
                            local animNode = self:createCardAnimByFriendPos(beganTag,false)
                            if animNode then
                                animNode:setPosition(ccp(bgSize.width*0.5,bgSize.height*0.1));
                                beganItem:addChild(animNode,1,1)
                            end
                            self:setPositionBg2(beganTag)
                            endItem:removeAllChildrenWithCleanup(true)
                            local animNode = self:createCardAnimByFriendPos(endTag,false)
                            if animNode then
                                animNode:setPosition(ccp(bgSize.width*0.5,bgSize.height*0.1));
                                endItem:addChild(animNode,1,1)
                            end
                            self:setPositionBg2(endTag)
                            self.m_posIndex = endTag;
                            self:refreshHeroInfo(endTag);
                            self:refreshCombatLabel()
                        end
                    end
                end
                break;
            end
        end
        if selItem then
            selItem:removeFromParentAndCleanup(true);
            selItem = nil;
        end
        touchBeginPoint = nil;
        beganItem = nil;
        endItem = nil;
        tempPosIndex = nil;
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
    formation_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-2)
    formation_layer:setTouchEnabled(true)
end
--[[--
    
]]
function game_formationBonusMain_pop.setPositionBg2(self,posIndex)
    if posIndex == -1 then return end
    local bgSprite = tolua.cast(self.m_formation_layer:getChildByTag(posIndex),"CCSprite");
    if bgSprite == nil then return end;
    local bgName = "";
    local tempId = self.m_teamIndex == 2 and self.m_tempFriendData[posIndex] 
    -- cclog("tempId ======= " .. tempId .. " ; posIndex ======= " .. posIndex)
    if tempId == "-1" then--未开启
        if posIndex < 7 then
            bgName = "dw_qiang_diban_1.png";
        else
            bgName = "dw_chao_diban_2.png";
        end
    elseif tempId == "0" then--
        bgName = "dw_characterAdd.png";
    else
        bgName = "dw_characterBg.png";
    end
    local tempDisplayFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(bgName);
    if tempDisplayFrame then
        bgSprite:setDisplayFrame(tempDisplayFrame);
    end
end
function game_formationBonusMain_pop.refreshCombatLabel(self,source)
    -- cclog2(source,"source ===========")
    -- cclog2(self.m_tempCombatValue,"self.m_tempCombatValue==== ")
    if self.m_tempCombatValue == nil then
        -- cclog("-------1------")
        self.m_tempCombatValue = game_util:getCombatValue()
        self.m_combatNumberChangeNode:setCurValue(self.m_tempCombatValue,false);
    else
        -- cclog("-------2------")

        local tempCombatValue = game_util:getCombatValue();
        local changeValue = tempCombatValue - self.m_tempCombatValue
        -- cclog2(changeValue,"--------changeValue--------")
        self.m_tempCombatValue = tempCombatValue;
        game_util:combatChangedValueAnim({combatNode = self.m_combatNumberChangeNode,currentValue = tempCombatValue,changeValue = changeValue});
    end
end
--[[--
    
]]
function game_formationBonusMain_pop.newChainOpenAnim(self,typeName)
    local animFlag = false;
    local chainTabBackUp = self.m_chainTabBackUp
    local chainNameTab = {};
    if typeName == "card" then
        if chainTabBackUp and #chainTabBackUp > 0 then
            for i=1,#chainTabBackUp do
                if chainTabBackUp[i].openFlag == true then
                    animFlag = true
                    table.insert(chainNameTab,tostring(chainTabBackUp[i].nameExt))
                end
            end
        end
    else
        local chainTab = self.m_chainTab;
        if chainTab and #chainTab and #chainTabBackUp > 0 and #chainTabBackUp > 0 then
            for i=1,#chainTabBackUp do
                if chainTab[i] and chainTab[i].openFlag == true and chainTabBackUp[i] and chainTabBackUp[i].openFlag == false then
                    animFlag = true
                    table.insert(chainNameTab,tostring(chainTabBackUp[i].nameExt))
                end
            end
        end
    end
    if animFlag == true then
        -- 粒子效果
        local function particleMoveEndCallFunc()
            -- self:refreshCombatLabel("newChainOpenAnim true");
        end
        local tempParticle = game_util:createParticleSystemQuad({fileName = "particle_fly_up"});
        if tempParticle then
            -- if self.m_fate_detail_node:isVisible() == false then
                game_util:addMoveAndRemoveAction({node = tempParticle,startNode = self.m_magic_node,endNode = self.m_combat_label,endCallFunc = particleMoveEndCallFunc,moveTime = 0.5,delayTime = 0.5})
            -- else
            --     game_util:addMoveAndRemoveAction({node = tempParticle,startNode = self.m_fate_detail_node,endNode = self.m_combat_label,endCallFunc = particleMoveEndCallFunc,moveTime = 0.5,delayTime = 0.5})
            -- end
            game_scene:getPopContainer():addChild(tempParticle)
        else
            particleMoveEndCallFunc();
        end
        --改成动画效果
        -- local anim_zhandouli = game_util:createEffectAnim("anim_xinlianxie",2.0,false)
        -- if self.m_fate_label:isVisible() == true then
        --     local viewSize = self.m_fate_node:getContentSize()
        --     anim_zhandouli:setAnchorPoint(ccp(0.5,0.5))
        --     anim_zhandouli:setPosition(ccp(viewSize.width*0.5,viewSize.height*0.5))
        --     self.m_fate_node:addChild(anim_zhandouli)
        -- else
        --     local viewSize = self.m_fate_detail_node:getContentSize()
        --     anim_zhandouli:setAnchorPoint(ccp(0.5,0.5))
        --     anim_zhandouli:setPosition(ccp(viewSize.width*0.5,viewSize.height*0.5))
        --     self.m_fate_detail_node:addChild(anim_zhandouli)
        -- end
        --提示有新的命运开启 chainNameTab 新命运 名称列表
        for i =1,#chainNameTab do  
            local delayTime = (i - 1) * 1.7
            game_util:addQueneOpenTips({text = "Vận mệnh <" .. chainNameTab[i] .. "> " .. "mở"},delayTime)
        end
        
    else
        self:refreshCombatLabel("newChainOpenAnim false");
    end
end

--[[--
    
]]
function game_formationBonusMain_pop.addFriendSelHeroUi(self,posIndex)
    cclog("------addFriendSelHeroUi----")

    game_scene:removeGuidePop();
    cclog("addSelHeroUi posIndex ==" .. tostring(posIndex))
    local btnCallFunc = function( target,event )
        
    end
    local itemOnClick = function (typeName,id)
        if typeName == "exchanged" then
            if (not game_util:heroInTeamById(id,game_data:getTeamData())) and (not game_data:heroInAssistantById(id)) and (not game_util:heroInTeamById(id,game_data:getDestiny())) and (not game_util:isInFormationBonus(id)) then
                cclog("itemOnClick id ==================== " .. id);  
                self:updateFriendData(posIndex,id);
                self.m_changeFlag = true;
                self:initFriendFormation(self.m_formation_layer);
                self.m_posIndex = posIndex;
                self:refreshHeroInfo(posIndex,true);
                self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                self:newChainOpenAnim("card");
            else
                -- game_util:addMoveTips({text = "该卡牌无法进入阵法"})
                cclog("this card already on main formation or other position --------")
            end
        elseif typeName == "unload" then
            self.m_magic_node:setVisible(false)
            local tempId = self.m_tempFriendData[posIndex]
            -- if self:getUnloadPosFlag(posIndex) == 0 then
            if tempId ~= "-1" and tempId ~= "0" then
                self:updateFriendData(posIndex,"0");
                self.m_changeFlag = true;
                self:initFriendFormation(self.m_formation_layer);
                -- self.m_posIndex = -1;
                self:refreshHeroInfo(posIndex,true);
                self:refreshCombatLabel("addFriendSelHeroUi");
            end
        end

    end
    game_scene:addPop("game_hero_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,openType = 2})
end

function game_formationBonusMain_pop:updateFriendData( posIndex,cardId )
    -- body
    self.m_tempFriendData[posIndex] = cardId;
    if cardId == "-1" or cardId == "0" then
        self.m_tempAssMagicPosData[tostring(posIndex+199)] = {"0","0","0","0"}
    end
    self:setFriendFormationData();
end

function game_formationBonusMain_pop:exchangeFriendDataByTwoPos( posIndex1,posIndex2 )
    -- body
    self.m_tempFriendData[posIndex1],self.m_tempFriendData[posIndex2] = self.m_tempFriendData[posIndex2],self.m_tempFriendData[posIndex1];
    posIndex1 = tostring(posIndex1+199)
    posIndex2 = tostring(posIndex2+199)
    self.m_tempAssEquipPosData[posIndex1],self.m_tempAssEquipPosData[posIndex2] = self.m_tempAssEquipPosData[posIndex2],self.m_tempAssEquipPosData[posIndex1]
    self.m_tempAssMagicPosData[posIndex1],self.m_tempAssMagicPosData[posIndex2] = self.m_tempAssMagicPosData[posIndex2],self.m_tempAssMagicPosData[posIndex1]
    self:setFriendFormationData();
end

function game_formationBonusMain_pop:setFriendFormationData( )
    game_data:setFormationBonusByJsonData(self.m_tempFriendData)
    game_data:setFormationBonusEquipDataByJsonData(self.m_tempAssEquipPosData)
    game_data:setFormationBonusMagicDataByJsonData(self.m_tempAssMagicPosData)
    -- game_util:getFormationBonusAllData()
    -- body
    -- cclog("self.m_tempFriendData = " .. json.encode(self.m_tempFriendData))
end

--[[--
    获得卡牌配置以及数据
]]
function game_formationBonusMain_pop:getFriendCardDataByPos( posIndex )
    -- body
    return game_data:getCardDataById(self.m_tempFriendData[posIndex])
end
--[[
    获取小伙伴位置上的动画
]]
function game_formationBonusMain_pop:createCardAnimByFriendPos( posIndex , animFlag)
    -- body
    local heroData,heroCfg = self:getFriendCardDataByPos(posIndex);
    return self:createCardAnimByData(heroData,heroCfg,animFlag)
end
--[[
    获取小伙伴位置上的动画
]]
function game_formationBonusMain_pop.createCardAnimByData( self, heroData,heroCfg,animFlag)
    local animNode = nil;
    local character_ID = -1;
    if heroData and heroCfg then
        character_ID = heroCfg:getNodeWithKey("character_ID"):toInt();
        local ainmFile = heroCfg:getNodeWithKey("animation"):toStr();
        animFlag = animFlag == nil and true or animFlag
        if animFlag then
            animNode = game_util:createIdelAnim(ainmFile,0,heroData,heroCfg);
        else
            animNode = game_util:createCardImgByCfg(heroCfg);
        end
        if animNode then
            local itemSize = animNode:getContentSize();
            if animFlag == false then
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_light_down.png")
                if spriteFrame then
                    local tempSprite = CCSprite:createWithSpriteFrame(spriteFrame)
                    tempSprite:setAnchorPoint(ccp(0.5,0.1))
                    tempSprite:setPositionX(itemSize.width*0.5)
                    animNode:addChild(tempSprite)
                end
                local spriteFrame2 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_light_up.png")
                if spriteFrame2 then
                    local tempSprite = CCSprite:createWithSpriteFrame(spriteFrame2)
                    tempSprite:setAnchorPoint(ccp(0.5,0.1))
                    tempSprite:setPositionX(itemSize.width*0.5)
                    animNode:addChild(tempSprite,1000,1000)
                end
            else
                animNode:setRhythm(1);
            end
            animNode:setAnchorPoint(ccp(0.5,0));
            -- animNode:setScale(0.7);
            local name_after = heroData.step < 1 and "" or ("+" .. heroData.step);
            local tempLabel = CCLabelTTF:create("Lv." .. heroData.lv .. "/" .. heroData.level_max .. "\n" .. name_after,TYPE_FACE_TABLE.Arial_BoldMT,10);
            tempLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
            tempLabel:setPosition(ccp(itemSize.width*0.5 - 50,97));
            tempLabel:setAnchorPoint(ccp(0,0.5));
            animNode:addChild(tempLabel,100,100)
            -- local tempLabel = CCLabelTTF:create(heroCfg:getNodeWithKey("name"):toStr(),TYPE_FACE_TABLE.Arial_BoldMT,10);
            -- tempLabel:setPosition(ccp(itemSize.width*0.5 + 50,95));
            -- tempLabel:setAnchorPoint(ccp(1,0.5));
            -- animNode:addChild(tempLabel,100,100)
            -- game_util:setHeroNameColorByQuality(tempLabel,heroCfg);
            local occupation_cfg = getConfig(game_config_field.occupation);
            local occupation_item_cfg = occupation_cfg:getNodeWithKey(ainmFile)
            if occupation_item_cfg then
                local occupationType = occupation_item_cfg:toInt();
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    local occupation_icon = CCSprite:createWithSpriteFrame(spriteFrame)
                    occupation_icon:setPosition(ccp(itemSize.width*0.5 + 57,98));
                    occupation_icon:setAnchorPoint(ccp(1,0.5));
                    animNode:addChild(occupation_icon);
                end
            end
            animNode:setScale(0.66);
        end
    end
    return animNode,character_ID
end

--[[--
    助威装备层
]]
function game_formationBonusMain_pop.initFriendEquipLayerTouch(self,formation_layer)
    local touchBeginPoint = nil;
    local touchMoveFlag = false;
    local tempItem = nil;
    local realPos = nil;
    local tag = nil;
    local function onTouchBegan(x, y)
        touchMoveFlag = false;
        -- cclog("onTouchBegan: %0.2f, %0.2f", x, y)
        touchBeginPoint = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    local function onTouchMoved(x, y)
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            touchMoveFlag = true;
        end
    end
    
    local function onTouchEnded(x, y)
        if formation_layer:isVisible() == true then
            realPos = formation_layer:convertToNodeSpace(ccp(x,y));
            for i = 1,4 do
                tempItem = self.m_ccbNode:spriteForName("m_equip_" .. i)  
                if tempItem:boundingBox():containsPoint(realPos) then
                    tag = tempItem:getTag();
                    if self.m_posIndex == -1 or self.m_tempAssEquipPosData[tostring(self.m_posIndex+199)] == "-1" then
                        game_util:addMoveTips({text = string_config:getTextByKey("m_onclick_team_pos")});
                        return;
                    end
                    if tag < 20 then
                        local openFlag = true;--game_button_open:getOpenFlagByBtnId("705" .. self.m_posIndex .. (tag-10));
                        if openFlag then
                            local tempData = self.m_tempAssEquipPosData[tostring(self.m_posIndex+199)] or {}
                            local tempEquipId = tempData[tag - 10] or 0--self:getPosEquipId(self.m_posIndex,tag - 10);
                            if tempEquipId == nil or tostring(tempEquipId) == "0" then
                                self:addSelAssEquipUi(self.m_posIndex,tag - 10);
                            else
                                tempEquipId = tostring(tempEquipId);
                                local itemData = game_data:getEquipDataById(tempEquipId)
                                local function callBack(typeName,t_param)
                                    if typeName == "unload" then
                                        self:addSelAssEquipUi(self.m_posIndex,tag - 10);
                                    elseif typeName == "strengthen" then
                                        self.m_openType = "equip_strengthen"
                                        self:back()
                                    elseif typeName == "evolution" then
                                        self.m_openType = "equip_evolution"
                                        self:back()
                                        
                                    end
                                end
                                self.select_temp_id = tempEquipId
                                local fateEquipLock  = self:fateEquipLock(itemData,tempEquipId)
                                game_scene:addPop("game_equip_info_pop",{tGameData = itemData,posEquipData = self.m_tempAssEquipPosData[tostring(self.m_posIndex+199)],fateEquipLock = fateEquipLock,callBack = callBack,openType=2,selHeroId = self.m_selHeroId});
                            end
                        else
                            game_util:addMoveTips({text = string_config:getTextByKey("m_equip_pos_no_open")});
                        end
                    elseif tag >= 20 then
                    end
                    break;
                end
            end
        end
        if touchMoveFlag == false then
            -- self:fateTouchShow(x,y)
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
    formation_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-2)
    formation_layer:setTouchEnabled(true)
end

--[[--
    助威装备层
]]
function game_formationBonusMain_pop.initFriendMagicLayerTouch(self,formation_layer)
    local touchBeginPoint = nil;
    local touchMoveFlag = false;
    local tempItem = nil;
    local realPos = nil;
    local tag = nil;
    local function onTouchBegan(x, y)
        touchMoveFlag = false;
        -- cclog("onTouchBegan: %0.2f, %0.2f", x, y)
        touchBeginPoint = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    local function onTouchMoved(x, y)
        if ccpDistance(ccp(touchBeginPoint.x,touchBeginPoint.y),ccp(x,y)) > 20 or touchMoveFlag == true then
            touchMoveFlag = true;
        end
    end
    
    local function onTouchEnded(x, y)
        if formation_layer:isVisible() == true then
            realPos = formation_layer:convertToNodeSpace(ccp(x,y));
            for i = 1,4 do
                tempItem = self.m_ccbNode:spriteForName("m_magic_" .. i)  
                if tempItem:boundingBox():containsPoint(realPos) then
                    tag = tempItem:getTag();
                    if self.m_posIndex == -1 or self.m_tempAssMagicPosData[tostring(self.m_posIndex+199)] == "-1" then
                        game_util:addMoveTips({text = string_config:getTextByKey("m_onclick_team_pos")});
                        return;
                    end
                    if tag < 20 then
                        local openFlag = true;--game_button_open:getOpenFlagByBtnId("705" .. self.m_posIndex .. (tag-10));
                        if openFlag then
                            local tempData = self.m_tempAssMagicPosData[tostring(self.m_posIndex+199)] or {}
                            local tempEquipId = tempData[tag - 10] or 0--self:getPosEquipId(self.m_posIndex,tag - 10);
                            if tempEquipId == nil or tostring(tempEquipId) == "0" then
                                self:addSelAssMagicUi(self.m_posIndex,tag - 10);
                            else
                                tempEquipId = tostring(tempEquipId);
                                local itemData = game_data:getMagicDataById(tempEquipId)
                                local function callBack(typeName,t_param)
                                    if typeName == "unload" then
                                        self:addSelAssMagicUi(self.m_posIndex,tag - 10);
                                    elseif typeName == "strengthen" then
                                        self.m_openType = "magic_strengthen"
                                        self:back()
                                    elseif typeName == "evolution" then
                                        self.m_openType = "magic_evolution"
                                        game_scene:enterGameUi("game_magic_evolution",{gameData = nil,openType = self.m_openType});
                                        self:back()
                                        
                                    end
                                end
                                local Type
                                if tag - 10 < 3 then
                                    Type = 1 
                                else
                                    Type = 0
                                end
                                self.select_temp_id = tempEquipId
                                game_scene:addPop("game_magic_info_pop",{tGameData = itemData,posEquipData = self.m_tempAssMagicPosData[tostring(self.m_posIndex+199)],callBack = callBack,magicType=Type,openType=2,selHeroId = self.m_selHeroId});
                            end
                        else
                            game_util:addMoveTips({text = string_config:getTextByKey("m_equip_pos_no_open")});
                        end
                    elseif tag >= 20 then
                    end
                    break;
                end
            end
        end
        if touchMoveFlag == false then
            -- self:fateTouchShow(x,y)
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
    formation_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-2)
    formation_layer:setTouchEnabled(true)
end



function game_formationBonusMain_pop.autoMatchFateEquip( self,heroId,posIndex,isFriendEquip )
    cclog("autoMatchFateEquip -----")
    local cardData,cardCfg = game_data:getCardDataById( heroId );
    if not cardCfg then return end
    local curPosEquip = self.m_tempAssEquipPosData[tostring(posIndex+199)]
    if curPosEquip and next(curPosEquip) then
    else
        curPosEquip = self.m_tempAssEquipPosData[tonumber(posIndex+199)]
    end
    local recommendEquip = {"0","0","0","0"}
    local recommendEquipData = {}
    local equipTable = game_data:getEquipIdTable()
    local equipCfg = getConfig(game_config_field.equip);
    local existFlag,cardName, pos = true, nil, nil
    local itemData, itemCfg = nil, nil
    local toNilFlag = false
    local tempTab = {1,1,1,1}
    local tempEquipPosData = {}
    tempEquipPosData = self.m_tempAssEquipPosData
    posIndex = tostring(posIndex + 199)
    cclog2(posIndex,"posIndex ====")
    cclog2(curPosEquip,"curPosEquip ====")
    if cardData.bind_equip and next(cardData.bind_equip) then
        cclog2(cardData.bind_equip,"cardData.bind_equip[i]==== ")
        for i=1,4 do
            if cardData.bind_equip[i] ~= 0 then
                tempEquipPosData[posIndex][i] = cardData.bind_equip[i]
            else
                local equipData = game_data:getEquipDataById(curPosEquip[i])
                if equipData and equipData.bind_card and equipData.bind_card ~= ""  then
                    if equipData.bind_card ~= cardData.id then
                        tempEquipPosData[posIndex][i] = "0"
                    end
                else
                end
            end
        end
        -- cclog2(tempEquipPosData,"-------1-=------")
    else
        for sort,Id in pairs(curPosEquip) do
            local equipData = game_data:getEquipDataById(Id)
            if equipData and equipData.bind_card and equipData.bind_card ~= ""  then
                if equipData.bind_card ~= cardData.id then
                    tempEquipPosData[posIndex][sort] = "0"
                end
            else
            end
        end
        -- cclog2(tempEquipPosData,"-------2-=------")

    end
    self.m_tempAssEquipPosData = tempEquipPosData
    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
    -- self:newChainOpenAnim("equip");
end
function game_formationBonusMain_pop.setSelPositionBg(self,posIndex)
    if self.m_teamIndex == 1 then
        if posIndex == -1 or self.m_tempTeamData[posIndex] == "-1" then return end
    else
        if posIndex == -1 or self.m_tempFriendData[posIndex] == "-1" then return end
    end    
    local bgSprite = tolua.cast(self.m_formation_layer:getChildByTag(posIndex),"CCSprite");
    if bgSprite == nil then return end
    -- local tempDisplayFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dw_characterBgSel.png");
    -- if tempDisplayFrame then
    --     bgSprite:setDisplayFrame(tempDisplayFrame);
        local pX,pY = bgSprite:getPosition();

        local tempPos = bgSprite:getParent():convertToWorldSpace(ccp(pX,pY));
        local tempPos2 = self.m_sel_bg:getParent():convertToNodeSpace(ccp(tempPos.x,tempPos.y))
        -- cclog2(tempPos2,"tempPos ==== ")
        self.m_sel_bg:setAnchorPoint(ccp(0.5, 0.5))
        self.m_sel_bg:setPosition(tempPos2);
        self.m_sel_bg:setVisible(true);
    -- end
end
--判断该装备是否可以命运装备绑定
function game_formationBonusMain_pop.fateEquipLock(self,itemData,tempEquipId)
    local fateEquipId = string.sub(itemData.c_id,1,3)
    if tonumber(itemData.c_id) > 100100 then
        fateEquipId = string.sub(itemData.c_id,1,4)
    end
    local fateEquipLock = false
    if self.m_selHeroId then
        local heroData,heroCfg = game_data:getCardDataById(self.m_selHeroId)
        local chain_cfg = getConfig(game_config_field.chain);
        local chain = heroCfg:getNodeWithKey("chain")
        local chainCount = chain:getNodeCount();
        for i=1,chainCount do
            local chainId = chain:getNodeAt(i-1):toStr();
            local chainItemCfg = chain_cfg:getNodeWithKey(chainId);
            local equip_cfg = getConfig(game_config_field.equip);
            if chainItemCfg then
                local data = chainItemCfg:getNodeWithKey("data")
                local dataCount = data:getNodeCount();
                local condition_sort = chainItemCfg:getNodeWithKey("condition_sort"):toInt();
                if dataCount > 0 then
                    if condition_sort == 1 then
                        for i=1,dataCount do
                            local itemCfg = equip_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                itemCfg = json.decode(itemCfg:getFormatBuffer())
                                local chain_id = itemCfg.chain_id
                                if chain_id == tonumber(fateEquipId) then
                                    return  true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local heroData,heroCfg = game_data:getCardDataById(self.m_selHeroId)
    local chainEquipDataTab = game_util:cardEquipChainByCfg(heroCfg, heroData.id)
    local equipCfg = getConfig(game_config_field.equip);
    local itemData2, itemCfg2 = game_data:getEquipDataById(tostring(tempEquipId));
    local isThisChainFlag = game_util:isCardChainEquip(itemCfg2, chainEquipDataTab ) or false
    return isThisChainFlag
end
--[[
    刷新装备
]]
function game_formationBonusMain_pop.refreshEquipPos(self,posIndex)
    if posIndex and posIndex > 0 and posIndex < 10 then
        local tempNode = nil;
        local equipPosData = nil
        equipPosData = self.m_tempAssEquipPosData[tostring(posIndex+199)]
        for k,v in pairs(equipPosData) do
            if v ~= 0 and v ~= "0" then
                local equipItemData =  game_data:getEquipDataById(v);
                if equipItemData.bind_card and equipItemData.bind_card ~= "" then
                    if equipItemData.bind_card ~= self.m_selHeroId then
                        equipPosData[k] = 0
                    end
                end
            end

        end

        if equipPosData then
            -- cclog("posIndex == " .. posIndex .. " ; equipPosData ======= " .. json.encode(equipPosData))
            local noUseEquipCountTab = game_data:getNoUseEquipCountTab();
            local is_bright = false
            for i=1,4 do
                tempNode = self.m_ccbNode:spriteForName("m_equip_" .. i)  
                if tempNode then
                    local tempNodeSize = tempNode:getContentSize();
                    local id = equipPosData[i];
                    if id and tostring(id) ~= "0" then
                        local equipItemData,equipItemCfg = game_data:getEquipDataById(tostring(id));
                        local equipIcon = game_util:createEquipIcon(equipItemCfg);
                        if equipIcon then
                            equipIcon:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(equipIcon,10,10)
                            if self.m_selEquipId == id then
                                equipIcon:setScale(2.0);
                                local animArr = CCArray:create();
                                animArr:addObject(CCSpawn:createWithTwoActions(CCEaseIn:create(CCScaleTo:create(0.5,1.0),5),CCFadeIn:create(0.5)));
                                animArr:addObject(CCScaleTo:create(0.1,1.2));
                                animArr:addObject(CCScaleTo:create(0.1,1.0));
                                equipIcon:runAction(CCSequence:create(animArr));
                                self.m_selEquipId = nil;
                            end
                            if equipItemData.bind_card and equipItemData.bind_card ~= "" then
                                local temp = CCSprite:createWithSpriteFrameName("public_icon_ming.png")
                                local tempSize = equipIcon:getContentSize()
                                temp:setPosition(ccp(tempSize.width-5,tempSize.height-5))
                                equipIcon:addChild(temp,10,10)
                            else
                                is_bright = true
                            end
                        end
                        if equipItemData then
                            local tempLabel = game_util:createLabelTTF({text = "Lv." .. equipItemData.lv,color = ccc3(250,255,0),fontSize = 14});
                            tempLabel:setPosition(ccp(tempNodeSize.width*0.5,-tempNodeSize.height*0.1))
                            tempNode:addChild(tempLabel,11,11)
                        else
                            -- cclog("equipIndex == " .. i .. " ; equipId == " .. tostring(id));
                        end
                    else
                        is_bright = true
                        if noUseEquipCountTab[i] > 0 then
                            local tempSpri = CCSprite:createWithSpriteFrameName("public_kezhuangbei.png")
                            tempSpri:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(tempSpri,10,10)
                        end
                        if i == 1 then
                            local id = game_guide_controller:getCurrentId();
                            if id == 31 then
                                self.m_guide_step = 31
                                game_guide_controller:gameGuide("show","2",32,{tempNode = tempNode})
                            end
                        end
                    end
                end
            end
            self.m_replace_equip_btn:setVisible(is_bright)
        end
    end 
end
--[[
    刷新装备
]]
function game_formationBonusMain_pop.refreshMagicPos(self,posIndex)
    if posIndex and posIndex > 0 and posIndex < 10 then
        local tempNode = nil;
        local equipPosData = nil
        equipPosData = self.m_tempAssMagicPosData[tostring(posIndex+199)]
        -- for k,v in pairs(equipPosData) do
        --     if v ~= 0 and v ~= "0" then
        --         local equipItemData =  game_data:getMagicDataById(v);
        --         if equipItemData.bind_card and equipItemData.bind_card ~= "" then
        --             if equipItemData.bind_card ~= self.m_selHeroId then
        --                 equipPosData[k] = 0
        --             end
        --         end
        --     end

        -- end

        if equipPosData then
            -- cclog("posIndex == " .. posIndex .. " ; equipPosData ======= " .. json.encode(equipPosData))
            local noUseMagicCountTab = game_data:getNoUseMagicCountTab();
            for i=1,4 do
                tempNode = self.m_ccbNode:spriteForName("m_magic_" .. i)  
                if tempNode then
                    local tempNodeSize = tempNode:getContentSize();
                    local id = equipPosData[i];
                    if id and tostring(id) ~= "0" then
                        local equipItemData,equipItemCfg = game_data:getMagicDataById(tostring(id));
                        local equipIcon = game_util:createMagicIcon(equipItemCfg);
                        if equipIcon then
                            equipIcon:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(equipIcon,10,10)
                            if self.m_selMagicId == id then
                                equipIcon:setScale(2.0);
                                local animArr = CCArray:create();
                                animArr:addObject(CCSpawn:createWithTwoActions(CCEaseIn:create(CCScaleTo:create(0.5,1.0),5),CCFadeIn:create(0.5)));
                                animArr:addObject(CCScaleTo:create(0.1,1.2));
                                animArr:addObject(CCScaleTo:create(0.1,1.0));
                                equipIcon:runAction(CCSequence:create(animArr));
                                self.m_selMagicId = nil;
                            end
                        end
                        if equipItemData then
                            local tempLabel = game_util:createLabelTTF({text = "Lv." .. equipItemData.lv,color = ccc3(250,255,0),fontSize = 14});
                            tempLabel:setPosition(ccp(tempNodeSize.width*0.5,-tempNodeSize.height*0.1))
                            tempNode:addChild(tempLabel,11,11)
                        else
                            -- cclog("equipIndex == " .. i .. " ; equipId == " .. tostring(id));
                        end
                    else
                        local temp_type
                        if i < 3 then
                            temp_type = 2
                        else
                            temp_type = 1   
                        end
                        if noUseMagicCountTab[temp_type] > 0 then
                            local tempSpri = CCSprite:createWithSpriteFrameName("public_kezhuangbei.png")
                            tempSpri:setPosition(ccp(tempNodeSize.width*0.5,tempNodeSize.height*0.5))
                            tempNode:addChild(tempSpri,10,10)
                        end
                        if i == 1 then
                            local id = game_guide_controller:getCurrentId();
                            if id == 31 then
                                self.m_guide_step = 31
                                game_guide_controller:gameGuide("show","2",32,{tempNode = tempNode})
                            end
                        end
                    end
                end
            end
        end
    end 
end

--[[--
    刷新卡牌信息
]]
function game_formationBonusMain_pop.getPosEquipAttrValue(self,posIndex)
    -- 1物攻 2魔攻 3防御 4速度 5生命
    local equip_set_random = getConfig(game_config_field.equip_set_random)
    local attrValueTab = {0,0,0,0,0};
    local posEquips = nil
    posEquips = self.m_tempAssEquipPosData[tostring(posIndex+199)]
    -- cclog("posIndex ==== " .. posIndex .. " ;type(posEquips) == " .. type(posEquips))
    local level,value1,value2;
    local suitTab = {};
    if posEquips and type(posEquips) == "table" then
        for k,v in pairs(posEquips) do
            local equipItemData,itemCfg = game_data:getEquipDataById(v);
            if equipItemData and itemCfg then
                level = equipItemData.lv;
                value1 = itemCfg:getNodeWithKey("value1"):toInt();
                value2 = itemCfg:getNodeWithKey("value2"):toInt();
                local level_add1,level_add2 = itemCfg:getNodeWithKey("level_add1"):toInt(),itemCfg:getNodeWithKey("level_add2"):toInt()
                value1 = value1 + level_add1*(level - 1);
                value2 = value2 + level_add2*(level - 1);
                -- cclog("value1 == " .. value1 .. " ; value2 == " .. value2)
                local ability1 = itemCfg:getNodeWithKey("ability1"):toInt();
                local ability2 = itemCfg:getNodeWithKey("ability2"):toInt();
                local attrName1 = PUBLIC_ABILITY_TABLE["ability_" .. ability1].attrName
                local attrName2 = PUBLIC_ABILITY_TABLE["ability_" .. ability2].attrName
                if equipItemData.equip_refine then
                    if equipItemData.equip_refine[attrName1] then
                        local temp1 = equipItemData.equip_refine[attrName1]
                        value1 = value1 + temp1
                    end
                    if equipItemData.equip_refine[attrName2] then
                        local temp2 = equipItemData.equip_refine[attrName2]
                        value2 = value2 + temp2
                    end
                end
                if attrValueTab[ability1] then
                    attrValueTab[ability1] = attrValueTab[ability1] + value1;
                end
                if attrValueTab[ability2] then
                    attrValueTab[ability2] = attrValueTab[ability2] + value2;
                end
                local suit = itemCfg:getNodeWithKey("suit"):toInt();
                if suitTab[suit] == nil then
                    suitTab[suit] = 0;
                    local suitCount,_,tempAttrValueTab = game_util:getEquipSuit(itemCfg:getNodeWithKey("suit"):toStr(),posEquips);
                    if suitCount > 0 then
                        for i=1,5 do
                            attrValueTab[i] = attrValueTab[i] + tempAttrValueTab[i]
                        end
                    end
                end
                --增加锻造属性值
                if equipItemData.is_equip_forge == true then
                    -- local attrname = 
                    -- local tempValue = {0,0,0,0,0}
                    for key_type,valueTable in pairs(equipItemData.equip_forge) do
                        local itemEquipForgeCfg = json.decode(equip_set_random:getNodeWithKey(tostring(key_type)):getFormatBuffer())
                        local sort = itemEquipForgeCfg.sort
                        local enemy = itemEquipForgeCfg.enemy[1]
                        local value = 0
                        for k,v in pairs(valueTable) do
                            value = v
                        end
                        -- cclog2(value,"equp forge value")
                        if sort > 0 and sort <= 5 then
                            -- tempValue[sort] = value

                            -- attrValueTab[sort] = attrValueTab[sort] * (1 + value)
                            --改成加数不用百分比
                            if enemy ~= -1 then--减敌人的不加
                                attrValueTab[sort] = attrValueTab[sort] + value
                            end
                        end
                    end
                                
                end


             end
        end
    end
    return attrValueTab
end



function game_formationBonusMain_pop.getPosMagicAttrValue(self,posIndex)
    -- 1物攻 2魔攻 3防御 4速度 5生命
    local TempTable = {
        {
            {base = "patk",},
            {base =  "matk",},
            {base = nil,},
            {base = nil,},
            {base = nil,},
        },
        {
            {base = nil,},
            {base = nil,},
            {base = "def",},
            {base = "speed",},
            {base = "hp",},
        },

    }
    local talisman = getConfig(game_config_field.talisman)
    local attrValueTab = {0,0,0,0,0};
    local posMagic = nil
    posMagic = self.m_tempAssMagicPosData[tostring(posIndex+199)]
    -- cclog("posIndex ==== " .. posIndex .. " ;type(posMagic) == " .. type(posMagic))
    local level,value1,value2;
    local suitTab = {};
    if posMagic and type(posMagic) == "table" then
        for k,v in pairs(posMagic) do
            local ItemData,itemCfg = game_data:getMagicDataById(v);
            if ItemData and itemCfg then
                level = ItemData.lv;
                if itemCfg.talisman_type == 1 or itemCfg.talisman_type == "1" then
                    local table = TempTable[1]
                    for k,v in pairs(table) do
                        if v.base ~= nil then
                            attrValueTab[k] = attrValueTab[k] + itemCfg["base_" .. v.base] + itemCfg["growth_" .. v.base] * level
                        end
                    end
                elseif itemCfg.talisman_type == 0 or itemCfg.talisman_type == "0" then
                    local table = TempTable[2]
                    for k,v in pairs(table) do
                        if v.base ~= nil then
                            attrValueTab[k] = attrValueTab[k] + itemCfg["base_" .. v.base] + itemCfg["growth_" .. v.base] * level
                        end
                    end
                end
            end
        end
    end
    return attrValueTab
end

--[[--
    刷新卡牌信息
]]
function game_formationBonusMain_pop.refreshHeroInfo(self,posIndex,isFriendEquip)
    local replaceStr = "Đổi"
    self.m_magic_node:setVisible(false)
    self.m_sel_bg:setVisible(false);
    self.m_selHeroId = nil;
    self.m_anim_node:removeAllChildrenWithCleanup(true);
    local tempNode = nil;
    for i=1,8 do
        tempNode = self.m_ccbNode:spriteForName("m_equip_" .. i)
        if tempNode then
            tempNode:removeAllChildrenWithCleanup(true);
        end
    end
    for i=1,4 do
        tempNode = self.m_ccbNode:spriteForName("m_magic_" .. i)
        if tempNode then
            tempNode:removeAllChildrenWithCleanup(true);
        end
    end
    local cardData,cardCfg = nil,nil;
    cardData,cardCfg = self:getFriendCardDataByPos(posIndex);
    -- cclog("cardData ========" .. tostring(cardData) .. " ; cardCfg ========" .. tostring(cardCfg))
    local fate_detail_label_str = "Không có";
    local attrValueTab = {0,0,0,0,0};
    if cardData and cardCfg then
        self:setSelPositionBg(posIndex);
        self.m_selHeroId = cardData.id
        self.m_life_label:setString(cardData.hp);
        self.m_physical_atk_label:setString(cardData.patk);
        self.m_magic_atk_label:setString(cardData.matk);
        self.m_def_label:setString(cardData.def);
        self.m_speed_label:setString(cardData.speed);
        local ainmFile = cardCfg:getNodeWithKey("animation"):toStr();
        local animNode = game_util:createHeroListItemByCCB(cardData);
        self.m_anim_node:addChild(animNode);
        -- 1物攻 2魔攻 3防御 4速度 5生命
        local equipAttrValueTab = self:getPosEquipAttrValue(posIndex);--装备属性
        local magicAttrValueTab = self:getPosMagicAttrValue(posIndex);--装备属性
        local petAttrValueTab = game_util:getPetCombatValue(posIndex)
        local petFollowValueTab = game_util:getPetFollowCombatValue(posIndex)
        local gemAttrValueTab = {0,0,0,0,0};
        local medalAttrValueTab = {0,0,0,0,0}
        local attrValueTab2 = {0,0,0,0,0};
        local attrValueTab3 = {0,0,0,0,0};
        local universeCombatValue = 0
        local universeAttrValueTab = {0,0,0,0,0}
        local soulAttrValueTab = {0,0,0,0,0};
        local soulAttrValueTab2 = {0,0,0,0,0};
        local soulPercentValueTab = {0,0,0,0,0};
        local rolePropertryValueTab = {0,0,0,0,0}
        if self.m_teamIndex == 1 then
            gemAttrValueTab = self:getGemBaseAttrValue(posIndex);--宝石的基本属性
            attrValueTab2 = game_util:getCommanderCombatValue();--统帅能力
            attrValueTab3 = game_util:getAssistantCombatValue();--助威加的属性
            medalAttrValueTab = self:getMedalBaseAttrValue(posIndex);--勋章的基本属性
            -- soulAttrValueTab,soulPercentValueTab,soulAttrValueTab2 = self:getSoulBaseAttrValue(posIndex,cardData); --英魂基本属性
            -- cclog2(soulAttrValueTab,"soulAttrValueTab")
            universeCombatValue,universeAttrValueTab = game_util:getUniverseCombatValue(cardData.id,self.allUniverseEffect)--宇宙属性加成
            rolePropertryValueTab = game_util:getRolePropertryValue()
           
        end
        local cbmTab = game_util:getCombatBonusMultiplierByCfg(cardCfg,cardData.id);--连协属性
        local soulPercentCombatTab = {0,0,0,0,0};
        local famousAdd = {}
        local key = {"patk_v","matk_v","def_v","speed_v","hp_v"}
        if cardData.famous then
            famousAdd = cardData.famous
        end
        for i=1,5 do
            local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. i] or {}
            local attrValue = cardData[abilityItem.attrName or ""] or 0
            soulPercentCombatTab[i] = attrValue * soulPercentValueTab[i] * 0.01
            attrValueTab[i] = math.floor(equipAttrValueTab[i]+magicAttrValueTab[i]  + (famousAdd[key[i]] or 0) + attrValueTab2[i] + attrValue*cbmTab[i] + gemAttrValueTab[i] + attrValueTab3[i] + petAttrValueTab[i] + medalAttrValueTab[i] + soulAttrValueTab[i] + soulAttrValueTab2[i] + universeAttrValueTab[i] + petFollowValueTab[i] + soulPercentCombatTab[i] + rolePropertryValueTab[i])
        end

        self.m_life_label2:setString("+" .. attrValueTab[5])
        self.m_physical_atk_label2:setString("+" .. attrValueTab[1])
        self.m_magic_atk_label2:setString("+" .. attrValueTab[2])
        self.m_def_label2:setString("+" .. attrValueTab[3])
        self.m_speed_label2:setString("+" .. attrValueTab[4])


        self.m_selHeroId = cardData.id
        self.m_life_label:setString(cardData.hp);
        self.m_physical_atk_label:setString(cardData.patk);
        self.m_magic_atk_label:setString(cardData.matk);
        self.m_def_label:setString(cardData.def);
        self.m_speed_label:setString(cardData.speed);

        local addLife = math.floor((attrValueTab[5] + cardData.hp)* self.m_addTable[posIndex] * 0.01)
        local addAtk = math.floor((attrValueTab[1] + cardData.patk + (famousAdd[key[1]] or 0)) * self.m_addTable[posIndex] * 0.01)
        local addMag = math.floor((attrValueTab[2] + cardData.matk + (famousAdd[key[2]] or 0))* self.m_addTable[posIndex] * 0.01)
        local addDef = math.floor((attrValueTab[3] + cardData.def + (famousAdd[key[3]] or 0)) * self.m_addTable[posIndex] * 0.01)
        local addSpeed = math.floor((attrValueTab[4] + cardData.speed + (famousAdd[key[4]] or 0)) * self.m_addTable[posIndex] * 0.01)
        self.m_lab_Addlife:setString("+" .. addLife)
        self.m_lab_AddAtk:setString("+" .. addAtk)
        self.m_lab_AddMag:setString("+" .. addMag)
        self.m_lab_AddDef:setString("+" .. addDef)
        self.m_lab_AddSpeed:setString("+" .. addSpeed)

        local chainTab = game_util:cardChainByCfg(cardCfg,cardData.id)
        self.m_chainTab = chainTab;
        local is_bright = true
        if #chainTab > 0 then
            local showStr = ""
            local nameStr = "";
            for i=1,#chainTab do
                showStr = showStr .. chainTab[i].detail .. "\n"
                nameStr = nameStr .. "    " .. chainTab[i].name .. (i == 3 and "\n" or "")
                if chainTab[i].openFlag == false then
                    is_bright = false
                end
            end
            fate_detail_label_str = showStr;
        else
        end
        self.m_magic_node:setVisible(is_bright)
        if game_data:isViewShowByID(182) == true then
            cclog("----is true ===---- ")
            self:autoMatchFateEquip(self.m_selHeroId,posIndex)
        end
        self:refreshEquipPos(posIndex)
        self:refreshMagicPos(posIndex)
        -- self:refreshMedalPos(posIndex)--勋章不显示，所以不用加
    else
        self.m_life_label:setString("---");
        self.m_physical_atk_label:setString("---");
        self.m_magic_atk_label:setString("---");
        self.m_def_label:setString("---");
        self.m_speed_label:setString("---");
        self.m_life_label2:setString("---");
        self.m_physical_atk_label2:setString("---");
        self.m_magic_atk_label2:setString("---");
        self.m_def_label2:setString("---");
        self.m_speed_label2:setString("---");

        self.m_lab_Addlife:setString("---")
        self.m_lab_AddAtk:setString("---")
        self.m_lab_AddMag:setString("---")
        self.m_lab_AddDef:setString("---")
        self.m_lab_AddSpeed:setString("---")

        -- self.m_fate_label:setString("Không có")

        -- self.m_fate_detail_label:setString("无")
        if self.m_teamIndex == 2 then
            self:setSelPositionBg(posIndex);
        end
        replaceStr = "Ra trận"
    end
    
    game_util:setCCControlButtonTitle(self.m_replace_btn,replaceStr)
    local labelsize = self.m_fate_detail_node:getContentSize();
    self.m_oneFateScrollView:getContainer():removeAllChildrenWithCleanup(true);
    self.m_fate_detail_label = game_util:createRichLabelTTF({text = fate_detail_label_str,dimensions = CCSizeMake(labelsize.width, 0),textAlignment = kCCTextAlignmentLeft,verticalTextAlignment = nil,color = ccc3(221,221,192)})
    self.m_fate_detail_label:setAnchorPoint(ccp(0, 0));
    self.m_oneFateScrollView:addChild(self.m_fate_detail_label)
    local contentSize = self.m_fate_detail_label:getContentSize();
    self.m_oneFateScrollView:setContentSize(CCSizeMake(contentSize.width, math.max(contentSize.height,labelsize.height)));
    if contentSize.height < labelsize.height then
        self.m_fate_detail_label:setPosition(ccp(0, labelsize.height - contentSize.height));
        self.m_oneFateScrollView:setContentOffset(ccp(0, 0),false)
    else
        self.m_oneFateScrollView:setContentOffset(ccp(0, labelsize.height - contentSize.height),false)
    end

    -- btn_bloodStone
    local btn_bloodStone = self.m_ccbNode:controlButtonForName("btn_bloodStone")
    if not game_data:isViewOpenByID(226) then
        btn_bloodStone:setVisible(false)
    else
        btn_bloodStone:setVisible(true)
        self:refreshBloodStone()
    end
    

end
--[[--
    
]]
function game_formationBonusMain_pop.addFriendTeamHeroPop(self,posIndex)
    game_scene:removeGuidePop();
    if self.m_tempFriendData[posIndex] == "-1" then

    else
        self.m_posIndex = posIndex;
        self:refreshHeroInfo(posIndex);
    end
end

function game_formationBonusMain_pop.exchangeAssEquipPosAlert(self,posIndex,currPos,sort,id,posType)
    cclog(posType .. "posType---" .. currPos .. "currPos === " )
    if posType == 2 and posIndex == currPos then 
        game_util:addMoveTips({text = "Trang bị đang ở ô này!"});
        return 
    end
    local tempText = nil;
    local heroData,heroCfg = nil,nil
    if posType == 1 then
        heroData,heroCfg = self:getTeamCardDataByPos(currPos)
    elseif posType == 2 then
        heroData,heroCfg = self:getFriendCardDataByPos(currPos)
    end
    if heroData and heroCfg then
        tempText = "Trang bị đang được" .. heroCfg:getNodeWithKey("name"):toStr() .. "dùng, đổi chứ?"
    else
        tempText = "Trang bị đang được dùng ở ô khác, đổi chứ?"
    end
    local t_params = 
    {
        title = string_config.m_title_prompt,
        okBtnCallBack = function(target,event)
            self.m_selEquipId = id;
            self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
            game_scene:removePopByName("game_equip_select_pop");
            game_util:closeAlertView();
            if posType == 1 then
                self:exchangeAssAndTeamEquipPosDataByTwoPos(posIndex,currPos,sort);
            elseif posType == 2 then
                self:exchangeAssEquipPosDataByTwoPos(posIndex,currPos,sort);
            end
            self.m_changeFlag = true;
            self:addFriendTeamHeroPop(posIndex);
            self:newChainOpenAnim("equip");
        end,   --可缺省
        okBtnText = "Đổi trang bị",       --可缺省
        text = tempText,      --可缺省
    }
    game_util:openAlertView(t_params);
end
function game_formationBonusMain_pop.exchangeAssMagicPosAlert(self,posIndex,currPos,sort,id,posType,magicPos)
    cclog(posType .. "posType---" .. currPos .. "currPos === " )
    if posType == 2 and posIndex == currPos then 
        game_util:addMoveTips({text = "Trang bị đang ở ô này!"});
        return 
    end
    local tempText = nil;
    local heroData,heroCfg = nil,nil
    if posType == 1 then
        heroData,heroCfg = self:getTeamCardDataByPos(currPos)
    elseif posType == 2 then
        heroData,heroCfg = self:getFriendCardDataByPos(currPos)
    end
    if heroData and heroCfg then
        tempText = "Pháp bảo đang được" .. heroCfg:getNodeWithKey("name"):toStr() .. "dùng, đổi chứ?"
    else
        tempText = "Pháp bảo đang được dùng ở ô khác, đổi chứ?"
    end
    local t_params = 
    {
        title = string_config.m_title_prompt,
        okBtnCallBack = function(target,event)
            self.m_selMagicId = id;
            self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
            game_scene:removePopByName("game_magic_select_pop");
            game_util:closeAlertView();
            if posType == 1 then
                self:exchangeAssAndTeamMagicPosDataByTwoPos(posIndex,currPos,sort,magicPos);
            elseif posType == 2 then
                self:exchangeAssMagicPosDataByTwoPos(posIndex,currPos,sort,magicPos);
            end
            self.m_changeFlag = true;
            self:addFriendTeamHeroPop(posIndex);
            self:newChainOpenAnim("equip");
        end,   --可缺省
        okBtnText = "Đổi trang bị",       --可缺省
        text = tempText,      --可缺省
    }
    game_util:openAlertView(t_params);
end
--[[
法宝
]]
function game_formationBonusMain_pop.exchangeAssMagicPosDataByTwoPos(self,posIndex1,posIndex2,Type1,Type2)
    if posIndex1 == posIndex2 then return end
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or Type1 > 4 or Type1 < 1 or Type2 > 4 or Type2 < 1 then return end
    posIndex1 = tostring(posIndex1+199)
    posIndex2 = tostring(posIndex2+199)
    self.m_tempAssMagicPosData[posIndex1][Type1],self.m_tempAssMagicPosData[posIndex2][Type2] = self.m_tempAssMagicPosData[posIndex2][Type2],self.m_tempAssMagicPosData[posIndex1][Type1]
    -- cclog("updateAssEquipPosData = " .. json.encode(self.m_tempAssEquipPosData))
end
--[[
法宝
]]
function game_formationBonusMain_pop.exchangeAssAndTeamMagicPosDataByTwoPos(self,posIndex1,posIndex2,equipType)
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    posIndex1 = tostring(posIndex1+199)
    self.m_tempAssMagicPosData[posIndex1][equipType],self.m_tempMagicPosData[posIndex2][equipType] = self.m_tempMagicPosData[posIndex2][equipType],self.m_tempAssMagicPosData[posIndex1][equipType]
    -- cclog("exchangeAssAndTeamEquipPosDataByTwoPos = " .. json.encode(self.m_tempAssEquipPosData))
end
--[[
装备
]]
function game_formationBonusMain_pop.exchangeAssEquipPosDataByTwoPos(self,posIndex1,posIndex2,equipType)
    if posIndex1 == posIndex2 then return end
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    posIndex1 = tostring(posIndex1+199)
    posIndex2 = tostring(posIndex2+199)
    self.m_tempAssEquipPosData[posIndex1][equipType],self.m_tempAssEquipPosData[posIndex2][equipType] = self.m_tempAssEquipPosData[posIndex2][equipType],self.m_tempAssEquipPosData[posIndex1][equipType]
    -- cclog("updateAssEquipPosData = " .. json.encode(self.m_tempAssEquipPosData))
end

--[[
装备
]]
function game_formationBonusMain_pop.exchangeAssAndTeamEquipPosDataByTwoPos(self,posIndex1,posIndex2,equipType)
    if posIndex1 > 9 or posIndex1 < 0 or posIndex2 > 9 or posIndex2 < 0 or equipType > 4 or equipType < 1 then return end
    posIndex1 = tostring(posIndex1+199)
    self.m_tempAssEquipPosData[posIndex1][equipType],self.m_tempEquipPosData[posIndex2][equipType] = self.m_tempEquipPosData[posIndex2][equipType],self.m_tempAssEquipPosData[posIndex1][equipType]
    -- cclog("exchangeAssAndTeamEquipPosDataByTwoPos = " .. json.encode(self.m_tempAssEquipPosData))
end

--[[--
    设置阵型相应位置装备数据
]]
function game_formationBonusMain_pop.updateAssEquipPosData(self,equipPos,equipType,equipId)
    if equipPos > 9 or equipPos < 0 or equipType > 4 or equipType < 1 then return end
    equipPos = tostring(equipPos+199)
    self.m_tempAssEquipPosData[equipPos][equipType] = tonumber(equipId);
    -- cclog("updateAssEquipPosData = " .. json.encode(self.m_tempAssEquipPosData))
end
--[[--
    设置阵型相应位置装备数据
]]
function game_formationBonusMain_pop.updateAssMagicPosData(self,equipPos,equipType,equipId)
    if equipPos > 9 or equipPos < 0 or equipType > 4 or equipType < 1 then return end
    equipPos = tostring(equipPos+199)
    self.m_tempAssMagicPosData[equipPos][equipType] = equipId;
    -- cclog("updateAssMagicPosData = " .. json.encode(self.m_tempAssMagicPosData))
end
--[[--
    判断是否装备上
]]
function game_formationBonusMain_pop.equipInEquipPos(self,equipType,equipId)
    local existFlag = false;
    local posIndex = -1;
    local posType = 1
    if equipType then
        for i=1,9 do
            if self.m_tempAssEquipPosData[tostring(i+199)][equipType] == tonumber(equipId) then
                cclog("realy?")
                posIndex = i;
                existFlag = true
                posType = 2
                break;
            end
        end
    end
    return existFlag,posIndex,posType
end


--[[--
    判断是否装备上
]]
function game_formationBonusMain_pop.magicInMagicPos(self,Type,Id)
    local existFlag = false;
    local posIndex = -1;
    local posType = 1
    local change_pos = 1
    local magicPosData = game_data:getMagicPosData()
    local existFlag1 = game_data:magicInMagicPos(Type,Id)
    if existFlag1 then return existFlag1,nil,nil end
    cclog("game_formationBonusMain_pop      i d    = " .. Id)
    cclog2(self.m_tempAssMagicPosData)
    if Type then
        for i=1,10 do
            if Type == 1 then
                if self.m_tempAssMagicPosData[tostring(i+199)][1] == Id then
                    posIndex = i;
                    existFlag = true
                    posType = 2
                    change_pos = 1
                    break;
                elseif self.m_tempAssMagicPosData[tostring(i+199)][2] == Id then
                    posIndex = i;
                    existFlag = true
                    posType = 2
                    change_pos = 2
                    break;
                end
            elseif  Type == 0 then
                if self.m_tempAssMagicPosData[tostring(i+199)][3] == Id then
                    posIndex = i;
                    existFlag = true
                    posType = 2
                    change_pos = 3
                    break;
                elseif self.m_tempAssMagicPosData[tostring(i+199)][4] == Id then
                    posIndex = i;
                    existFlag = true
                    posType = 2
                    change_pos = 4
                    break;
                end
            end
        end
    end
    return existFlag,posIndex,posType,change_pos
end
--[[--
    
]]
function game_formationBonusMain_pop.addSelAssEquipUi(self,posIndex,sort)
    game_scene:removeGuidePop();
    cclog("addSelEquipUi posIndex ==" .. tostring(posIndex))
    local btnCallFunc = function( target,event )
    end
    local itemOnClick = function (typeName,id)

        if typeName == "exchanged" then
            if id then
                local existFlag,currPos,posType = self:equipInEquipPos(sort,id)
                cclog2(existFlag,"existFlag === ")
                if existFlag then
                    self:exchangeAssEquipPosAlert(posIndex,currPos,sort,id,posType);
                else
                    self.m_selEquipId = id;
                    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                    game_scene:removePopByName("game_equip_select_pop");
                    cclog("itemOnClick changed id ==================== " .. id);
                    self:updateAssEquipPosData(posIndex,sort,id);
                    self.m_changeFlag = true;
                    self:addFriendTeamHeroPop(posIndex);
                    self:newChainOpenAnim("equip");
                    local id = game_guide_controller:getCurrentId();
                    if id == 33 and self.m_back_btn then
                        game_guide_controller:gameGuide("show","2",34,{tempNode = self.m_back_btn})
                    end
                end
            end
        elseif typeName == "unload" then
            self:updateAssEquipPosData(posIndex,sort,"0");
            cclog("itemOnClick remove id ==================== ");
            self.m_changeFlag = true;
            self:addFriendTeamHeroPop(posIndex);
            self:refreshCombatLabel("addSelAssEquipUi");
        end

        game_data:setFormationBonusEquipDataByJsonData(self.m_tempAssEquipPosData)
        game_data:setFormationBonusMagicDataByJsonData(self.m_tempAssMagicPosData)
    end
    game_scene:addPop("game_equip_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = sort,openType = 3})
end


--[[--
    
]]
function game_formationBonusMain_pop.addSelAssMagicUi(self,posIndex,sort)
    game_scene:removeGuidePop();
    cclog("addSelEquipUi posIndex ==" .. tostring(posIndex))
    local selSort
    if sort < 3 then
        selSort = 1
    else
        selSort = 0
    end
    local btnCallFunc = function( target,event )
    end
    local itemOnClick = function (typeName,id)

        if typeName == "exchanged" then
            if id then
                local existFlag,currPos,posType,magicPos = self:magicInMagicPos(selSort,id)
                cclog2(existFlag,"magicInMagicPos   existFlag === ")
                if existFlag then
                    if currPos == nil then
                        game_util:addMoveTips({text = "Pháp bảo đã "}) 
                        return
                    else
                        self:exchangeAssMagicPosAlert(posIndex,currPos,sort,id,posType,magicPos);
                    end
                else
                    self.m_selmagicId = id;
                    self.m_chainTabBackUp = self.m_chainTab == nil and nil or util.table_copy(self.m_chainTab)
                    game_scene:removePopByName("game_magic_select_pop");
                    cclog("itemOnClick changed id ==================== " .. id);
                    self:updateAssMagicPosData(posIndex,sort,id);
                    self.m_changeFlag = true;
                    self:addFriendTeamHeroPop(posIndex);
                    self:newChainOpenAnim("magic");
                    local id = game_guide_controller:getCurrentId();
                    if id == 33 and self.m_back_btn then
                        game_guide_controller:gameGuide("show","2",34,{tempNode = self.m_back_btn})
                    end
                end
            end
        elseif typeName == "unload" then
            self:updateAssMagicPosData(posIndex,sort,"0");
            cclog("itemOnClick remove id ==================== ");
            self.m_changeFlag = true;
            self:addFriendTeamHeroPop(posIndex);
            self:refreshCombatLabel("addSelAssMagicUi");
        end

        game_data:setFormationBonusMagicDataByJsonData(self.m_tempAssMagicPosData)
    end
    -- game_scene:addPop("game_magic_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = selSort,openType = 2})
    game_scene:addPop("game_magic_select_pop",{btnCallFunc = btnCallFunc,itemOnClick = itemOnClick,sortBtnShow = false,selSort = selSort,openType = 3})
end


function game_formationBonusMain_pop:fateTouchShow( x,y )
    if self.m_fate_label:isVisible() == true then
        realPos = self.m_fate_node:getParent():convertToNodeSpace(ccp(x,y));
        if self.m_fate_node:boundingBox():containsPoint(realPos) then
            local wx,wy = self.m_fate_node2:getPosition()
            self.m_spr_mingyunnode:setPositionY(wy)
            self.m_fate_label:setVisible(false);
            self.m_equip_layer:setVisible(false);
            self.isVisible = self.m_eq_layer:isVisible()
            self.m_eq_layer:setVisible(false)
            self.m_magic_layer:setVisible(false)
            self.m_activation_node:setVisible(false)
            if self.m_teamIndex == 1 then
                self.m_gem_layer:setVisible(false)
            else
            end
            self.m_fate_detail_node:setVisible(true);
        end
    elseif self.m_fate_detail_node:isVisible() == true then
        realPos = self.m_fate_detail_node:getParent():convertToNodeSpace(ccp(x,y));
        if self.m_fate_detail_node:boundingBox():containsPoint(realPos) then
            local wx,wy = self.m_fate_node1:getPosition()
            self.m_spr_mingyunnode:setPositionY(wy)
            self.m_fate_label:setVisible(true);
            self.m_eq_layer:setVisible(self.isVisible)
            self.m_magic_layer:setVisible(not self.isVisible)
            if self.m_teamIndex == 1 then
                if self.m_teamGemOpenFlag then self.m_gem_layer:setVisible(true) end
                self.m_equip_layer:setVisible(true)
            else
                self.m_equip_layer:setVisible(true)
                if self.m_ability2OpenFlag then self.m_equip_layer:setVisible(true) end
            end
            self.m_activation_node:setVisible(true)
            self.m_fate_detail_node:setVisible(false);
        end
    end
end

------------------------------------- 助威 end -------------------------------------------

function game_formationBonusMain_pop.getAddRate( self )
    local tempTab  = game_data:getFormationBonusAdditionByJsonData()
    local m_formation_bonus = getConfig(game_config_field.formation_bonus);
    local addTable = {}
    m_formation_bonus = json.decode(m_formation_bonus:getFormatBuffer()) or {}
    for i=1,9 do
        local length = game_util:getTableLen(tempTab[tostring(i-1)])
        local addRate = 0 
        for j=1,length do
            addRate = addRate + m_formation_bonus[tostring(j)].add_ability
        end
        addTable[i] = addRate
    end
    self.m_addTable = addTable
end
--[[--
    刷新ui
]]
function game_formationBonusMain_pop.refreshUi(self)
    self:initFriend()
    self:refreshCombatLabel()
end


-- 刷新血石
function game_formationBonusMain_pop:refreshBloodStone()
    local equipPosData = nil
    if self.m_teamIndex == 1 then
        equipPosData = self.m_tempEquipPosData[self.m_posIndex]
    elseif self.m_teamIndex == 2 then
        equipPosData = self.m_tempAssEquipPosData[tostring(self.m_posIndex+199)]
    end
    if not equipPosData then
        equipPosData = {}
    end
    for k,v in pairs(equipPosData) do
        if v ~= "0" then
            local equipItemData =  game_data:getEquipDataById(v);
            if equipItemData ~= nil and  equipItemData.bind_card and equipItemData.bind_card ~= "" then
                if equipItemData.bind_card ~= self.m_selHeroId then
                    equipPosData[k] = "0"
                end
            end
        end
    end
    -- cclog2(self.m_tempEquipPosData, "[血石] self.m_tempEquipPosData -> ")
    -- cclog2(self.m_tempAssEquipPosData, "[血石] self.m_tempAssEquipPosData -> ")

    local sc_blood = self.m_ccbNode:scrollViewForName("sc_blood")
    -- sc_blood:getContainer():removeAllChildrenWithCleanup(true);

    local ccbNode = self.m_ccbNode

    -- local ccbNode = luaCCBNode:create()            
    -- ccbNode:openCCBFile("ccb/ui_equipBloodSc.ccbi")
    -- ccbNode:setAnchorPoint(ccp(0.5,0.5))
    -- sc_blood:addChild(ccbNode)

    sc_blood:setContentOffset(ccp(0, -ccbNode:getContentSize().height + 130))
    for i=1, 4 do
        -- 获取装备数据
        local _euqipData = equipPosData[i]
        cclog2(_euqipData, "[血石] _euqipData -> ")
        local equipData
        local gem_fateData
        if _euqipData ~= "0" then
            equipData = game_data:getEquipDataById(tostring(_euqipData))
            cclog2(equipData, "[血石] equipData -> ")
            if equipData and equipData.gem_fate then
                gem_fateData = equipData.gem_fate
                cclog2(gem_fateData, "[血石] gem_fateData -> ")
            end
        end
        -- node_item
        local node_item = ccbNode:nodeForName("node_item" .. i)
        -- node_item:setVisible(_euqipData ~= "0")
        -- node_equipIcon
        local node_equipIcon = ccbNode:nodeForName("node_equipIcon" .. i)
        node_equipIcon:removeAllChildrenWithCleanup(true);
        if _euqipData ~= "0" then
            local equipItemData,equipItemCfg = game_data:getEquipDataById(tostring(_euqipData));
            cclog2(equipItemCfg, "[血石] equipItemCfg -> ")
            local equipIcon = game_util:createEquipIcon(equipItemCfg);
            if equipIcon then
                equipIcon:setScale(0.9)
                equipIcon:setPosition(ccp(0, 0))
                node_equipIcon:addChild(equipIcon,10,10)
            end
        end
        -- 赋能
        for j = 1, 4 do
            -- stone icon
            local node_stone = ccbNode:nodeForName("node_" .. i .. "_stone" .. j)
            node_stone:removeAllChildrenWithCleanup(true);
            if gem_fateData and gem_fateData[j] and gem_fateData[j] ~= 0 then
                local icon = game_util:createFateGemIconByCid(gem_fateData[j])
                icon:setScale(0.7)
                node_stone:addChild(icon)
            end
            -- 
        end
        -- effect
        local effects = game_util.bloodStone.getEquipStoneEffect(nil, _euqipData)
        local effect = effects[1]
        -- sp_no
        local sp_no = ccbNode:spriteForName("sp_no" .. i)
        sp_no:setVisible(effect == nil)
        -- sp_effect1
        local sp_effect1 = ccbNode:spriteForName("sp_effect1_" .. i)
        sp_effect1:setVisible(effect ~= nil)
        if effect then
            local sid = effect.effectSid
            local icon1, icon2 = game_util.bloodStone.getSkillEffectIconName(sid)
            sp_effect1:setTexture(CCTextureCache:sharedTextureCache():addImage("icon/" .. icon1))
        end
        -- sp_effect2
        local sp_effect2 = ccbNode:spriteForName("sp_effect2_" .. i)
        sp_effect2:setVisible(effect ~= nil)
        if effect then
            local sid = effect.effectSid
            local icon1, icon2 = game_util.bloodStone.getSkillEffectIconName(sid)
            sp_effect2:setTexture(CCTextureCache:sharedTextureCache():addImage("icon/" .. icon2))
        end
        -- lb_effect
        local lb_effect = ccbNode:labelTTFForName("lb_effect" .. i)
        lb_effect:setVisible(effect ~= nil)
        if lb_effect:isVisible() then
            lb_effect:setString(effect.des)
        end
    end
end


--[[--
    初始化
]]
function game_formationBonusMain_pop.init(self,t_params)
    t_params = t_params or {};
    if t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        self.m_tGameData = json.decode(t_params.gameData:getNodeWithKey("data"):getFormatBuffer()) or {};
    end
    self.m_posIndex = -1;
    self.m_tempSelIndex = -1;
    self.m_tempFriendData = {};
    self.m_tempEquipPosData = {};
    self.m_fateDataTab = {}
    self.m_tempSelIndex = -1;
    local friendData = game_data:getFormationBonusByJsonData();
    self.m_tempFriendData = friendData
    self.m_tempAssEquipPosData = game_data:getFormationBonusEquipData() or {}
    self.m_tempAssMagicPosData = game_data:getFormationBonusMagicData() or {}
    self.m_bonusAddTab = game_data:getBonusAddTab()
    game_data:equipInBonus()

end
--[[--
    创建ui入口并初始化数据
]]
function game_formationBonusMain_pop.create(self,t_params)
    self:init(t_params);
    local m_popUi = self:createUi();
    self:refreshUi();

    return  m_popUi;
end
return game_formationBonusMain_pop; ˳