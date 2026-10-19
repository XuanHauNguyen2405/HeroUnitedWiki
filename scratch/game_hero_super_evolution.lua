
---  超进化 

local game_hero_super_evolution = {
    m_anim_node = nil,--动画节点
    m_selHeroId = nil,--选中的heroid
    m_ok_btn = nil,
    m_tips_spr_1 = nil,
    m_tips_spr_2 = nil,
    m_list_view_bg = nil,
    m_sel_btn = nil,
    m_showType = nil,
    m_selListItem = nil,
    m_attr_node = nil,
    m_maxCrystalLv = nil,
    m_selHeroDataBackup = nil,
    m_material_id_table = nil,
    m_material_node_tab = nil,
    m_material_node = nil,
    m_evo_food = nil,
    m_status = nil,
    m_curPage = nil,
    m_cost_food_label = nil,
    m_food_total_label = nil,
    m_ccbNode = nil,
    m_anim_node_parent = nil,
    m_root_layer = nil,
    m_auto_add_btn = nil,
    m_selFilterCardSortIndex = nil,
    m_selHeroTab = nil,
    m_selHeroData = nil,
    m_popUi = nil,
    m_mate_tips = nil,
    m_attrValueTab = nil,
    m_scroll_view_tips = nil,
    m_selSortIndex = nil,
    m_showHeroTable = nil,
    m_light_bg_1 = nil,
    m_no_material_tips = nil,
    m_needMaterialCount = nil,
    m_guildNode = nil,
    m_combatNumberChangeNode = nil,
    m_tempCombatValue = nil,
    m_addAttrTab = nil,
    m_attr_list_view_bg = nil,
    m_attr_list_view_bg_2 = nil,
    m_needMaterialTab = nil,
    m_super_evo_tips_label = nil,
    m_super_evo_node_1 = nil,
    m_super_evo_node_2 = nil,
    m_quality_label_1 = nil,
    m_quality_label_2 = nil,
    m_condition_label = nil,
    m_evoType = nil,
    m_tips_label_1 = nil,
    m_tips_label_2 = nil,
    m_material_select_index = nil,
};
--[[--
    销毁ui
]]
function game_hero_super_evolution.destroy(self)
    -- body
    cclog("-----------------game_hero_super_evolution destroy-----------------");
    self.m_anim_node = nil;
    self.m_selHeroId = nil;
    self.m_ok_btn = nil;
    self.m_tips_spr_1 = nil;
    self.m_tips_spr_2 = nil;
    self.m_list_view_bg = nil;
    self.m_sel_btn = nil;
    self.m_showType = nil;
    self.m_selListItem = nil;
    self.m_attr_node = nil;
    self.m_maxCrystalLv = nil;
    self.m_selHeroDataBackup = nil;
    self.m_material_id_table = nil;
    self.m_material_node_tab = nil;
    self.m_material_node = nil;
    self.m_evo_food = nil;
    self.m_status = nil;
    self.m_curPage = nil;
    self.m_cost_food_label = nil;
    self.m_food_total_label = nil;
    self.m_ccbNode = nil;
    self.m_anim_node_parent = nil;
    self.m_root_layer = nil;
    self.m_auto_add_btn = nil;
    self.m_selFilterCardSortIndex = nil;
    self.m_selHeroTab = nil;
    self.m_selHeroData = nil;
    self.m_popUi = nil;
    self.m_attrValueTab = nil;
    self.m_scroll_view_tips = nil;
    self.m_selSortIndex = nil;
    self.m_showHeroTable = nil;
    self.m_light_bg_1 = nil;
    self.m_no_material_tips = nil;
    self.m_needMaterialCount = nil;
    self.m_guildNode = nil;
    self.m_combatNumberChangeNode = nil;
    self.m_tempCombatValue = nil;
    self.m_addAttrTab = nil;
    self.m_attr_list_view_bg = nil;
    self.m_attr_list_view_bg_2 = nil;
    self.m_needMaterialTab = nil;
    self.m_super_evo_tips_label = nil;
    self.m_super_evo_node_1 = nil;
    self.m_super_evo_node_2 = nil;
    self.m_quality_label_1 = nil;
    self.m_quality_label_2 = nil;
    self.m_condition_label = nil;
    self.m_evoType = nil;
    self.m_tips_label_1 = nil;
    self.m_tips_label_2 = nil;
    self.m_material_select_index = nil;
end

--[[--
    返回
]]
function game_hero_super_evolution.back(self,backType)
    if backType == "back" then
        game_scene:enterGameUi("game_main_scene");
    end
end
--[[--
    读取ccbi创建ui
]]
function game_hero_super_evolution.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 1 then--返回
            self:back("back");
        elseif btnTag == 2 then--材料
            if self.m_selHeroId then
                self:refreshByType(2);
            end
        elseif btnTag == 3 then--重新选择
            if self.m_showType ~= 1 then
                self:refreshByType(1);
            end
        elseif btnTag == 101 then--开始铸魂
            self.m_evoType = 1
            self:onSureFunc(1);
        elseif btnTag == 102 then--自动选择
            self:autoSelectMaterial();
        elseif btnTag == 103 then--查看进化
            if self.m_selHeroId == nil then
                game_util:addMoveTips({text = "Xin chọn đồng đội muốn tiến hóa!"});
                return;
            end
            game_scene:addPop("game_hero_evo_look_pop",{selHeroId = self.m_selHeroId,evoType = 1})
        elseif btnTag == 104 then--开始进化
            self.m_evoType = 2
            self:onSureFunc(2);
        elseif btnTag >= 201 and btnTag <= 204 then--排序
            self:refreshSortTabBtn(btnTag - 200);
            if self.m_showType == 1 then
                local selSort = tostring(CARD_SORT_TAB[btnTag - 200].sortType);
                game_data:cardsSortByTypeName(selSort);
                self:refreshCardTableView();
            elseif self.m_showType == 2 then
                self:refreshFilterCardTableView();
            end
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_hero_super_evolution.ccbi");

    --英雄相关
    self.m_anim_node = ccbNode:nodeForName("m_anim_node")
    self.m_tips_spr_1 = ccbNode:spriteForName("m_tips_spr_1")
    self.m_tips_spr_2 = ccbNode:spriteForName("m_tips_spr_2")
    self.m_ok_btn = ccbNode:controlButtonForName("m_ok_btn")
    self.m_sel_btn = ccbNode:controlButtonForName("m_sel_btn")
    self.m_list_view_bg = ccbNode:layerForName("m_list_view_bg")
    self.m_attr_list_view_bg = ccbNode:layerForName("m_attr_list_view_bg")
    self.m_attr_list_view_bg_2 = ccbNode:layerForName("m_attr_list_view_bg_2")
    self.m_material_node = ccbNode:layerForName("m_material_node")
    self.m_attr_node = ccbNode:nodeForName("m_attr_node")
    self.m_cost_food_label = ccbNode:labelBMFontForName("m_cost_food_label")
    self.m_food_total_label = ccbNode:labelBMFontForName("m_food_total_label")
    self.m_anim_node_parent = ccbNode:nodeForName("m_anim_node_parent")
    self.m_auto_add_btn = ccbNode:controlButtonForName("m_auto_add_btn")
    self.m_scroll_view_tips = ccbNode:scrollViewForName("m_scroll_view_tips")
    self.m_light_bg_1 = ccbNode:scale9SpriteForName("m_light_bg_1");
    self.m_no_material_tips = ccbNode:spriteForName("m_no_material_tips")
    self.m_super_evo_tips_label = ccbNode:labelTTFForName("m_super_evo_tips_label")
    self.m_super_evo_node_1 = ccbNode:nodeForName("m_super_evo_node_1")
    self.m_super_evo_node_2 = ccbNode:nodeForName("m_super_evo_node_2")
    self.m_quality_label_1 = ccbNode:labelTTFForName("m_quality_label_1")
    self.m_quality_label_2 = ccbNode:labelTTFForName("m_quality_label_2")
    self.m_condition_label = ccbNode:labelTTFForName("m_condition_label")
    self.m_tips_label_1 = ccbNode:labelTTFForName("m_tips_label_1")
    self.m_tips_label_2 = ccbNode:labelTTFForName("m_tips_label_2")

    local m_bg_sprite = ccbNode:spriteForName("m_bg_sprite")
    m_bg_sprite:setScale(resolution_config:getScale())
    
    -- game_util:setControlButtonTitleBMFont(self.m_ok_btn)
    -- game_util:setControlButtonTitleBMFont(self.m_auto_add_btn)
    local m_material_node,m_mate_tips = nil,nil;
    for i=1,6 do
        m_material_node = ccbNode:nodeForName("m_material_node_" .. i);
        m_mate_tips = ccbNode:spriteForName("m_mate_tips_" .. i);
        self.m_material_node_tab[i] = {m_material_node = m_material_node,m_mate_tips = m_mate_tips}
    end
    self:initMaterialLayerTouch(self.m_material_node);
    self.m_ccbNode = ccbNode
    -- game_util:createScrollViewTips2(self.m_scroll_view_tips,{"hbjj_miaoshu.png","hbjj_miaoshu_1.png","hbjj_miaoshu_2.png","hbjj_miaoshu_3.png"});
    local m_combat_node = ccbNode:nodeForName("m_combat_node");
    self.m_combatNumberChangeNode = game_util:createExtNumberChangeNode({labelType = 2});
    self.m_combatNumberChangeNode:setAnchorPoint(ccp(0, 0.5));
    -- self.m_combatNumberChangeNode:setScale(0.75);
    m_combat_node:addChild(self.m_combatNumberChangeNode);
    self.m_combatNumberChangeNode:setCurValue(0,false);

    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;--intercept event
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,-999,true);
    self.m_root_layer:setTouchEnabled(false);
    return ccbNode;
end

--[[--
    自动选择材料
]]
function game_hero_super_evolution.autoSelectMaterial(self)
    if self.m_selHeroId == nil then
        game_util:addMoveTips({text = "Xin chọn đồng đội muốn tiến hóa"});
        return;
    end
    if self.m_showType ~= 2 or self.m_material_select_index ~= nil then
        self.m_material_select_index = nil;
        self.m_showType = 2;
        self:refreshSortTabBtn(self.m_selFilterCardSortIndex);
        self:filterMaterialData();
    end
    local itemData,itemConfig = game_data:getCardDataById(tostring(self.m_selHeroId));
    local super_soul = itemData.super_soul or {}
    local needStep = 0;
    local selQuality = 0;
    local c_id = "0";
    local character_ID,super_evo = nil,(itemData.super_step or 0);
    if itemConfig then
        selQuality = itemConfig:getNodeWithKey("quality"):toInt();
        needStep = itemData.step
        c_id = itemConfig:getKey()
        character_ID = itemData.c_id--itemConfig:getNodeWithKey("character_ID"):toInt();
    end
    self.m_material_id_table = {};
    local material_id_tab = {material_1 = {},material_2 = {}}
    local tempIndexTab = {index1 = 1,index2 = 1}
    for i=#self.m_showHeroTable,1,-1 do
        local heroId = self.m_showHeroTable[i];
        local itemData,itemCfg = game_data:getCardDataById(tostring(heroId));
        if itemData and itemCfg then
            local character_ID2 = itemData.c_id--itemCfg:getNodeWithKey("character_ID"):toInt();
            local lockFlag = game_util:getCardUserLockFlag(itemData);
            local godflag = game_util:godheroInTeamById(tostring(heroId));
            if lockFlag == false and godflag == false then
                local super_evo2 = itemData.super_step or 0
                if character_ID == character_ID2  then
                    if super_evo > 0 and super_evo == super_evo2 then-- －2
                        table.insert(material_id_tab["material_2"],heroId)
                    else-- －1
                        table.insert(material_id_tab["material_1"],heroId)
                    end
                else -- 其他伙伴
                    if material_id_tab[character_ID2] == nil then
                        material_id_tab[character_ID2] = {}
                        tempIndexTab[character_ID2] = 1
                    end
                    table.insert(material_id_tab[character_ID2],heroId)
                end
            end
        end
    end
    local tempCount = #self.m_needMaterialTab
    for i=1,tempCount do
        local tempId = self.m_needMaterialTab[i]
        if super_soul[i] == nil or super_soul[i] == 0 then
            if tempId == -2 then--表示相同的character_id和超进阶等级
                local tempMaterialTab = material_id_tab["material_2"] or {}
                local tempIndex = tempIndexTab["index2"] or 1
                if tempIndex <= #tempMaterialTab then
                    self.m_material_id_table[i] = tempMaterialTab[tempIndex]
                    tempIndexTab["index2"] = tempIndex + 1
                end
            elseif tempId == -1 then--表示相同的character_id
                local tempMaterialTab = material_id_tab["material_1"] or {}
                local tempIndex = tempIndexTab["index1"] or 1
                if tempIndex <= #tempMaterialTab then
                    self.m_material_id_table[i] = tempMaterialTab[tempIndex]
                    tempIndexTab["index1"] = tempIndex + 1
                end
            else--一般需求填写character_id
                local tempMaterialTab = material_id_tab[tempId] or {}
                local tempIndex = tempIndexTab[tempId] or 1
                if tempIndex <= #tempMaterialTab then
                    self.m_material_id_table[i] = tempMaterialTab[tempIndex]
                    tempIndexTab[tempId] = tempIndex + 1
                end
            end
        end
    end    
    self:refreshMaterial();
    self.m_list_view_bg:removeAllChildrenWithCleanup(true);
    self.m_tableView = self:createFilterTableView(self.m_list_view_bg:getContentSize());
    self.m_list_view_bg:addChild(self.m_tableView);
    local _,containerPosY = self.m_tableView:getContainer():getPosition()
    cclog("containerPosY === " .. containerPosY)
    if containerPosY < 0 then
        self.m_tableView:setContentOffset(ccp(0,0))
    end
    self:refreshTips();
    -- if self.m_needMaterialCount > 0 then
    --     local id = game_guide_controller:getIdByTeam("5");
    --     if id == 508 then
    --         game_guide_controller:gameGuide("show","5",509,{tempNode = self.m_ok_btn})
    --     end
    -- end
end

--[[--

]]
function game_hero_super_evolution.onSureFunc(self,evoType)
    if self.m_selHeroId == nil then
        game_util:addMoveTips({text = "Xin chọn đồng đội muốn tiến hóa"});--请选择需要进化的伙伴！
        return;
    end
    local tempCount = game_util:getTableLen(self.m_material_id_table)
    local selItemData,selItemCfg = game_data:getCardDataById(tostring(self.m_selHeroId));
    local super_soul = selItemData.super_soul or {}
    local havaCount = 0
    for k,v in pairs(super_soul) do
        if v == 1 then
            havaCount = havaCount + 1
        end
    end
    if havaCount ~= self.m_needMaterialCount and (tempCount + havaCount) <= havaCount then
        game_util:addMoveTips({text = "Xin chọn đồng đội nguyên liệu!"}); --请选择材料伙伴！
        return;
    end
    if self.m_status == 1 then
        game_util:addMoveTips({text = "Thẻ chính không thể tiến hóa tiếp, xin chọn lại!"}); --主卡不能再超进化,请重新选择
        return;
    end
    local function sendRequest()
        local function responseMethod(tag,gameData)
            if gameData == nil then
                self.m_root_layer:setTouchEnabled(false);
                return;
            end
            local reward = gameData:getNodeWithKey("data"):getNodeWithKey("reward")
            if reward then
                game_util:rewardTipsByJsonData(reward);
            end
            self:responseSuccess();
        end
        -- major=主卡id&metal=材料卡id
        local params = "major=" .. self.m_selHeroId
        local metal = ""
        for i=1,self.m_needMaterialCount do
            local tempId = self.m_material_id_table[i]
            if tempId then
                metal = metal .. (i == 1 and tempId or ("_" ..  tempId))
            else
                metal = metal .. (i == 1 and "-3" or "_-3") 
            end
        end
        params = params .. "&metal=" .. metal
        if evoType == 1 then
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_make_soul"), http_request_method.GET, params,"cards_make_soul",true,true)            
        elseif evoType == 2 then
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_super_evolution"), http_request_method.GET, params,"cards_super_evolution",true,true)
        end
    end
    local tipsFlag = false
    for i=1,self.m_needMaterialCount do
        local heroId = self.m_material_id_table[i]
        if heroId then
            local cardData,heroCfg = game_data:getCardDataById(heroId);
            local advance_step = cardData.step -- 进阶层数
            local lv = cardData.lv  --等级
            local bre = cardData.bre or 0
            local quality = cardData.quality
            if advance_step > 0 or lv > 1 or bre > 0 then
                tipsFlag = true
                break
            end
        end
    end
    if tipsFlag == true then
        local t_params = 
        {
            title = string_config:getTextByKey("m_title_prompt"),
            okBtnCallBack = function(target,event)
                self.m_root_layer:setTouchEnabled(true);
                sendRequest();
                game_util:closeAlertView();
            end,   --可缺省
            closeCallBack = function(target,event)
                game_util:closeAlertView();
            end,
            okBtnText = string_config:getTextByKey("m_btn_sure"),       --可缺省
            text = "Trong số nguyên liệu của bạn có đồng đội cấp lớn hơn 1 (cấp tiến hóa lớn hơn 1, đã chuyển sinh), xác nhận tiếp tục siêu tiến hóa chứ?",      --您的材料中部分伙伴等级大于1（进阶等级大于1，已经转生），是否继续进行超进化？
            closeFlag = true,
            onlyOneBtn = false,
        }
        game_util:openAlertView(t_params);
    else
        self.m_root_layer:setTouchEnabled(true);
        sendRequest();
    end
end

--[[--
    
]]
function game_hero_super_evolution.responseSuccess(self)
    game_scene:removeGuidePop();
    local endFlag = false;
    local function responseEndFunc()
        if endFlag == true then return end
        self.m_root_layer:setTouchEnabled(false);
        endFlag = true;
        game_sound:playUiSound("evo_success")
        self.m_material_id_table = {};
        self.m_material_select_index = nil;
        self.m_evo_food = 0;
        self:refreshByType(1);
        -- self.m_ccbNode:addChild(game_util:animSuccessCCBAnim(nil,"evolution_success"));
        local pX,pY = self.m_sel_btn:getPosition();
        local tempPos = self.m_sel_btn:getParent():convertToWorldSpace(ccp(pX,pY));
        local tempAnim = game_util:createUniversalAnim({animFile = "anim_shenkajinjie",rhythm = 1.0,loopFlag = false,endCallFunc = function() self:addAdvancedAnim(); end});
        if tempAnim then
            tempAnim:setPosition(tempPos)
            game_scene:getPopContainer():addChild(tempAnim,100)
        end
        -- local id = game_guide_controller:getIdByTeam("5");
        -- if id == 509 then
        --     game_guide_controller:gameGuide("send","5",509);
        -- end
        self:refreshCombatLabel();
    end
    local removeIndex = game_util:getTableLen(self.m_material_id_table)
    if self.m_evoType == 2 then
        removeIndex = self.m_needMaterialCount
    end
    local animFile = "anim_icon_disappear"
    local function particleMoveEndCallFunc()
        cclog("tempParticle particleMoveEndCallFunc --------------------------")
    end
    for i=1,self.m_needMaterialCount do
        if (self.m_evoType == 1 and self.m_material_id_table[i]) or self.m_evoType == 2 then
            local m_material_node = self.m_material_node_tab[i].m_material_node;
            local mAnimNode = game_util:createSortNode(animFile .. ".swf.sam", 0, animFile.. ".plist");
            if mAnimNode then
                local function onAnimSectionEnd(animNode, theId,theLabelName)
                    if theLabelName == "impact1" then
                        animNode:playSection("impact2");
                        local tempNode = m_material_node:getChildByTag(10)
                        if tempNode then
                            tempNode:setVisible(false);
                        end
                    else
                        mAnimNode:removeFromParentAndCleanup(true);
                        removeIndex = removeIndex - 1;
                        if removeIndex == 0 then
                            responseEndFunc();
                            -- self.m_ccbNode:runAnimations("success_anim")
                        end
                    end
                end
                mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
                mAnimNode:playSection("impact1");
                local tempSize = m_material_node:getContentSize();
                mAnimNode:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5));
                m_material_node:addChild(mAnimNode,100,100);
                local tempParticle = game_util:createParticleSystemQuad({fileName = "particle_fly_up"});
                if tempParticle then
                    game_util:addMoveAndRemoveAction({node = tempParticle,startNode = m_material_node,endNode = self.m_sel_btn,endCallFunc = particleMoveEndCallFunc,moveTime = 0.5,delayTime = 0.5})
                    game_scene:getPopContainer():addChild(tempParticle)
                end
            else
                removeIndex = removeIndex - 1;
                if removeIndex == 0 then
                    responseEndFunc();
                end
            end
        end
    end
end

--[[--
    材料层
]]
function game_hero_super_evolution.initMaterialLayerTouch(self,formation_layer)
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
        realPos = self.m_material_node:convertToNodeSpace(ccp(x,y));
        for k,v in pairs(self.m_material_node_tab) do
            if v.m_material_node:isVisible() and v.m_material_node:boundingBox():containsPoint(realPos) then
                if self.m_selHeroId then
                    if self.m_showType == 1 then
                        self.m_material_select_index = k;
                        self:refreshByType(2);
                    else
                        if self.m_material_select_index == k and self.m_material_id_table[k] ~= nil then
                            -- table.remove(self.m_material_id_table,k);
                            self.m_material_id_table[k] = nil;
                            self:refreshMaterial();
                        end
                        self.m_material_select_index = k;
                        self:refreshFilterCardTableView();
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
    formation_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY)
    formation_layer:setTouchEnabled(true)
end


--[[--
    刷新材料列表
]]
function game_hero_super_evolution.refreshMaterial(self)
    local haveMaterialFlag = false
    local selItemData,selItemCfg = game_data:getCardDataById(tostring(self.m_selHeroId));
    selItemData = selItemData or {}
    local super_soul = selItemData.super_soul or {}
    local character_detail = getConfig(game_config_field.character_detail);
    local material_node_size = self.m_material_node:getContentSize();
    local itemWidth = material_node_size.width/5
    local startX = material_node_size.width*0.5 - itemWidth*0.5*(self.m_needMaterialCount - 1)
    local m_material_node,m_mate_tips = nil,nil;
    local tempSize = nil;
    for index=1,#self.m_material_node_tab do
        m_material_node = self.m_material_node_tab[index].m_material_node;
        m_mate_tips = self.m_material_node_tab[index].m_mate_tips;
        m_material_node:removeAllChildrenWithCleanup(true);
        if self.m_selHeroId then
            if index <= self.m_needMaterialCount then
                m_material_node:setPositionX(startX + itemWidth*(index - 1))
                m_mate_tips:setPositionX(10 + startX + itemWidth*(index - 1))
                m_material_node:setVisible(true);
                if self.m_material_id_table[index] ~= nil  then
                    local card_id = tostring(self.m_material_id_table[index])
                    local cardData,cardCfg = game_data:getCardDataById(card_id)
                    local tempHeadIcon = game_util:createCardIconByCfg(cardCfg,cardData)
                    if tempHeadIcon then
                        tempSize = m_material_node:getContentSize();
                        tempHeadIcon:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5));
                        m_material_node:addChild(tempHeadIcon,10,10);
                    end
                    m_mate_tips:setVisible(false);
                    haveMaterialFlag = true
                else
                    local tempHeadIcon = nil
                    local heroData,heroCfg = game_data:getCardDataById(tostring(self.m_selHeroId));
                    local tempId = self.m_needMaterialTab[index]
                    if tempId == -1 then---1表示相同的character_id
                        tempHeadIcon = game_util:createCardIconByCfg(heroCfg)--game_util:createIconByName(heroCfg:getNodeWithKey("img"):toStr())
                    elseif tempId == -2 then---2表示相同的character_id和超进阶等级
                        tempHeadIcon = game_util:createCardIconByCfg(heroCfg,heroData)--game_util:createIconByName(heroCfg:getNodeWithKey("img"):toStr())
                    else--一般需求填写character_id
                        local character_detail_item = character_detail:getNodeWithKey(tostring(tempId))
                        if character_detail_item then
                            tempHeadIcon = game_util:createCardIconByCfg(character_detail_item)--game_util:createIconByName(character_detail_item:getNodeWithKey("img"):toStr())
                        end
                    end
                    if tempHeadIcon then
                        if super_soul[index] == nil or super_soul[index] == 0 then
                            tempHeadIcon:setColor(ccc3(81,81,81));
                            m_mate_tips:setVisible(true);
                        else
                            m_mate_tips:setVisible(false);
                        end
                        tempSize = m_material_node:getContentSize();
                        tempHeadIcon:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5));
                        m_material_node:addChild(tempHeadIcon,10,10);
                    end
                end
            else
                m_material_node:setVisible(false);
                m_mate_tips:setVisible(false);
            end
        else
            m_material_node:removeAllChildrenWithCleanup(true);
            m_material_node:setVisible(true);
            m_mate_tips:setVisible(true);
        end
    end
    self:refreshAttrTableView2()
    self.m_tips_label_2:setVisible(self.m_selHeroId == nil or haveMaterialFlag == false)
end

--[[--

]]
function game_hero_super_evolution.addAdvancedAnim(self)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/anim_word.ccbi");
    local m_root_layer = tolua.cast(ccbNode:objectForName("m_root_layer"), "CCLayer");
    local m_spr = tolua.cast(ccbNode:objectForName("m_spr"), "CCSprite");
    local tempSpriteFrame = nil
    if self.m_evoType == 1 then
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("cjh_zhouhunchengg.png")
    elseif self.m_evoType == 2 then
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("cjh_jinhuachenggong.png")
    end
    if tempSpriteFrame then
        m_spr:setDisplayFrame(tempSpriteFrame);
    end
    local function playAnimEnd(animName)
        ccbNode:removeFromParentAndCleanup(true);
    end
    ccbNode:registerAnimFunc(playAnimEnd);
    ccbNode:runAnimations("play_anim");
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            ccbNode:removeFromParentAndCleanup(true);
            return true;--intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-10,true);
    m_root_layer:setTouchEnabled(true);
    game_scene:getPopContainer():addChild(ccbNode,1000,1000)
end

--[[--
    属性英雄信息
]]
function game_hero_super_evolution.refreshHeroInfo(self,heroId)
    self.m_quality_label_1:setString("---")
    self.m_quality_label_2:setString("---")
    self.m_super_evo_node_1:setVisible(true)
    self.m_super_evo_node_2:setVisible(false)
    self.m_super_evo_tips_label:setVisible(false)
    self.m_needMaterialCount = 1;
    self.m_status = 0;
    self.m_selHeroId = heroId;
    self.m_anim_node:removeAllChildrenWithCleanup(true);
    self.m_evo_food = 0;
    self.m_selHeroData = nil;
	if heroId ~= nil and heroId ~= "-1" then
        self.m_tips_spr_1:setVisible(false);
        self.m_tips_spr_2:setVisible(false);
        local cardData,heroCfg = game_data:getCardDataById(tostring(heroId));
        self.m_selHeroData = cardData;
        local card_lv = cardData.lv
        local ccbNode = game_util:createHeroListItemByCCB(cardData);
        self.m_anim_node:addChild(ccbNode,10,10);
        self.m_addAttrTab = {};
        self:refreshAttrTableView();
    else
        self.m_tips_spr_1:setVisible(true);
        self.m_tips_spr_2:setVisible(false);
	end
    self:refreshMaterial();
end

--[[--
    过虑材料数据材料
进阶材料  
+0-+4  uid一样  万能橙卡
+5-+7  uid一样  万能红卡
+8+14  uid一样  万能红卡  uid不一样，cid一样  材料卡品质 >= 本卡
+15-+23  uid一样  万能红卡
+24以上  uid一样  万能金卡
]]
function game_hero_super_evolution.filterMaterialData(self)
    local character_ID,character_ID2,c_ID,c_ID2 = -1;
    local heroData = nil;
    local itemConfig = nil;
    local needStep = 0;
    local selQuality = 0;
    local sel_super_step = 0
    if self.m_selHeroId ~= nil then
        heroData,itemConfig = game_data:getCardDataById(tostring(self.m_selHeroId));
        needStep = heroData.step
        character_ID = heroData.c_id--itemConfig:getNodeWithKey("character_ID"):toInt();
        selQuality = itemConfig:getNodeWithKey("quality"):toInt();
        c_ID = itemConfig:getKey()
        sel_super_step = heroData.super_step or 0
    end
    local character_detail = getConfig(game_config_field.character_detail);
    local cardsDataTable = game_data:getTableCardsData();
    local showHeroTable = {};
    local level_max,quality = nil;
    local tempMaterialTab = {}
    for k,v in pairs(self.m_needMaterialTab) do
        tempMaterialTab[v] = k
    end
    local selMaterialId = nil
    if self.m_material_select_index ~= nil then
        selMaterialId = self.m_needMaterialTab[self.m_material_select_index]
    end
    for key,heroData in pairs(cardsDataTable) do
        if heroData.step < 1 then -- 判断英雄是否进阶过,进阶过不能做为材料
            if not self.m_famousAllData[key] or self.m_famousAllData[key] == 0 then 
                if key ~= tostring(self.m_selHeroId) and not game_data:heroInTeamById(key) and not game_data:heroInAssistantById(key) then
                    itemConfig = character_detail:getNodeWithKey(heroData.c_id);
                    character_ID2 = heroData.c_id--itemConfig:getNodeWithKey("character_ID"):toInt();
                    c_ID2 = itemConfig:getKey();
                    local metal_super_step = heroData.super_step or 0
                    local cardQuality = itemConfig:getNodeWithKey("quality")
                    cardQuality = cardQuality and cardQuality:toInt() or 8
                    if tempMaterialTab[character_ID2] then
                        if selMaterialId == nil or selMaterialId == character_ID2 then
                            table.insert(showHeroTable, heroData.id)
                        end
                    elseif (tempMaterialTab[-1] and character_ID == character_ID2 and metal_super_step == 0) then
                        if selMaterialId == nil or selMaterialId == -1 then
                            table.insert(showHeroTable, heroData.id)
                        end
                    elseif (tempMaterialTab[-2] and character_ID == character_ID2 and sel_super_step == metal_super_step) then
                        if selMaterialId == nil or selMaterialId == -2 then
                            table.insert(showHeroTable, heroData.id)
                        end
                    end
                end
            end
        end
    end
    if self.m_selFilterCardSortIndex == 1 then
        game_data:cardsSuperEvoSortByTypeNameWithTable(CARD_SORT_TAB[self.m_selFilterCardSortIndex].sortType,showHeroTable);
    else
        game_data:cardsSortByTypeNameWithTable(CARD_SORT_TAB[self.m_selFilterCardSortIndex].sortType,showHeroTable);
    end
    self.m_showHeroTable = showHeroTable;
end

--[[--
    创建筛选的列表
]]
function game_hero_super_evolution.createFilterTableView(self,viewSize)
    self.m_selListItem = nil;
    self.m_guildNode = nil;
    -- local showHeroTable = self.m_showHeroTable or {};
    local showHeroTable = {};
    for key,id in pairs(self.m_showHeroTable) do
        if not self.m_famousAllData[id] or self.m_famousAllData[id] == 0 then 
            showHeroTable[#showHeroTable+1] = id
        end
    end

    local cardsCount = #showHeroTable;
    self.m_no_material_tips:setVisible(cardsCount == 0);
    local totalItem = math.max(cardsCount%4 == 0 and cardsCount or math.floor(cardsCount/4+1)*4,4)
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;--行
    params.column = 1; --列
    params.totalItem = cardsCount--totalItem;
    params.direction = kCCScrollViewDirectionVertical;
    params.itemActionFlag = true;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            -- cclog("new index ================================" .. index);
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = game_util:createHeroListItemByCCB2();
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
                local itemData,itemCfg = game_data:getCardDataById(showHeroTable[index+1]);
                if itemData and itemCfg then
                    local heroId = itemData.id;
                    game_util:setHeroListItemInfoByTable2(ccbNode,itemData);
                    local flag,k = game_util:idInTableById(tostring(itemData.id),self.m_material_id_table)
                    if flag then
                        local m_sel_img = ccbNode:spriteForName("sprite_selected")
                        m_sel_img:setVisible(true);
                        local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
                        sprite_back_alpha:setVisible(true);
                        self.m_selListItem = cell;
                    end
                end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  cell = " .. tolua.type(cell) .. " ; cell:getUserData() = " .. tolua.type(cell:getUserData()));
        if index >= cardsCount then return end;
        if eventType == "ended" and cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_sel_img = ccbNode:spriteForName("sprite_selected")
            local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
            local itemData,itemCfg = game_data:getCardDataById(showHeroTable[index+1]);
            local heroId = tostring(itemData.id);
            local flag,k = game_util:idInTableById(heroId,self.m_material_id_table)
            local godflag = game_util:godheroInTeamById(heroId)
            if flag and k ~= nil then
                -- cclog("remove select material hero id ==========" .. heroId);
                -- table.remove(self.m_material_id_table,k);
                self.m_material_id_table[k] = nil
                m_sel_img:setVisible(false);
                sprite_back_alpha:setVisible(false);
                self:refreshMaterial();
            elseif godflag == true then --添加神域提示
                local t_params = 
                    {
                        title = string_config.m_title_prompt,
                        okBtnCallBack = function(target,event)
                            local selMaterialCount = game_util:getTableLen(self.m_material_id_table)
                            if selMaterialCount < 6 and selMaterialCount < self.m_needMaterialCount then
                                -- cclog("add select material hero id ==========" .. heroId);
                                -- table.insert(self.m_material_id_table,heroId);
                                local material_super_evolution_value = itemData.super_step or 0
                                local selItemData,selItemCfg = game_data:getCardDataById(tostring(self.m_selHeroId));
                                local super_evolution_value = selItemData.super_step or 0
                                local character_ID = selItemData.c_id--selItemCfg:getNodeWithKey("character_ID"):toInt();
                                local character_ID2 = itemData.c_id--itemCfg:getNodeWithKey("character_ID"):toInt();
                                local tempCount = #self.m_needMaterialTab
                                local selFlag = false
                                local super_soul = selItemData.super_soul or {}
                                if character_ID == character_ID2 then
                                    if super_evolution_value > 0 and material_super_evolution_value == super_evolution_value then-- -2
                                        for i=1,tempCount do
                                            local tempId = super_soul[i] or 0
                                            if self.m_needMaterialTab[i] == -2 and self.m_material_id_table[i] == nil and tempId == 0 then
                                                self.m_material_id_table[i] = heroId
                                                selFlag = true
                                                break
                                            end
                                        end
                                    else -- -1
                                        for i=1,tempCount do
                                            local tempId = super_soul[i] or 0
                                            if self.m_needMaterialTab[i] == -1 and self.m_material_id_table[i] == nil and tempId == 0 then
                                                self.m_material_id_table[i] = heroId
                                                selFlag = true
                                                break
                                            end
                                        end
                                    end
                                else--其他卡牌
                                    for i=1,tempCount do
                                        local tempId = super_soul[i] or 0
                                        if self.m_needMaterialTab[i] == character_ID2 and self.m_material_id_table[i] == nil and tempId == 0 then
                                            self.m_material_id_table[i] = heroId
                                            selFlag = true
                                            break
                                        end
                                    end
                                end
                                if selFlag == true then
                                    m_sel_img:setVisible(true);
                                    sprite_back_alpha:setVisible(true);
                                    self:refreshMaterial();
                                end
                            end
                            game_util:closeAlertView();
                        end,   --可缺省
                        cancelBtnCallBack = function(target,event)
                            game_util:closeAlertView();
                        end,
                        okBtnText = "Xác nhận",       --可缺省
                        cancelBtnText = "Hủy",
                        onlyOneBtn = false,
                        text = "Hero đang ở Thần Vực, tiêu hao chứ？",      --可缺省
                        touchPriority = GLOBAL_TOUCH_PRIORITY-2,
                    }
                    game_util:openAlertView(t_params);
            
            else
                local selMaterialCount = game_util:getTableLen(self.m_material_id_table)
                if selMaterialCount < 6 and selMaterialCount < self.m_needMaterialCount then
                    -- cclog("add select material hero id ==========" .. heroId);
                    -- table.insert(self.m_material_id_table,heroId);
                    local material_super_evolution_value = itemData.super_step or 0
                    local selItemData,selItemCfg = game_data:getCardDataById(tostring(self.m_selHeroId));
                    local super_evolution_value = selItemData.super_step or 0
                    local character_ID = selItemData.c_id--selItemCfg:getNodeWithKey("character_ID"):toInt();
                    local character_ID2 = itemData.c_id--itemCfg:getNodeWithKey("character_ID"):toInt();
                    local tempCount = #self.m_needMaterialTab
                    local selFlag = false
                    local super_soul = selItemData.super_soul or {}
                    if character_ID == character_ID2 then
                        if super_evolution_value > 0 and material_super_evolution_value == super_evolution_value then-- -2
                            for i=1,tempCount do
                                local tempId = super_soul[i] or 0
                                if self.m_needMaterialTab[i] == -2 and self.m_material_id_table[i] == nil and tempId == 0 then
                                    self.m_material_id_table[i] = heroId
                                    selFlag = true
                                    break
                                end
                            end
                        else -- -1
                            for i=1,tempCount do
                                local tempId = super_soul[i] or 0
                                if self.m_needMaterialTab[i] == -1 and self.m_material_id_table[i] == nil and tempId == 0 then
                                    self.m_material_id_table[i] = heroId
                                    selFlag = true
                                    break
                                end
                            end
                        end
                    else--其他卡牌
                        for i=1,tempCount do
                            local tempId = super_soul[i] or 0
                            if self.m_needMaterialTab[i] == character_ID2 and self.m_material_id_table[i] == nil and tempId == 0 then
                                self.m_material_id_table[i] = heroId
                                selFlag = true
                                break
                            end
                        end
                    end
                    if selFlag == true then
                        m_sel_img:setVisible(true);
                        sprite_back_alpha:setVisible(true);
                        self:refreshMaterial();
                    end
                end
            end
        elseif eventType == "longClick" and cell then
            local itemData = showHeroTable[index+1].heroData;
            local function callBack(typeName)
                typeName = typeName or "";
                if typeName == "refresh" then
                    self:refreshFilterCardTableView();
                end
            end
            game_scene:addPop("game_hero_info_pop",{tGameData = itemData,openType = 1,callBack = callBack})
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        -- self.m_selListItem = nil;
    end
    return TableViewHelper:create(params);
end

--[[--
    创建英雄列表
]]
function game_hero_super_evolution.createTableView(self,viewSize)
    self.m_selListItem = nil;
    self.m_guildNode = nil;
    local character_detail = getConfig(game_config_field.character_detail);
    local showData = {}
    local cardsData = game_data:getTableCardsData()
    local cardsIdTable = game_data:getDataByKey("m_tCardsIdTable") or {}
    local tempCount = #cardsIdTable
    for i=1,tempCount do
        local itemData = cardsData[cardsIdTable[i]]
        if itemData then
            local step = itemData.step or 0
            local itemConfig = character_detail:getNodeWithKey(itemData.c_id);
            if step > 19 and itemConfig then
                local quality = itemConfig:getNodeWithKey("quality")
                quality = quality and quality:toInt() or 8
                local super_evo = itemConfig:getNodeWithKey("super_evo")
                super_evo = super_evo and super_evo:toInt() or 0
                if quality > 3 and super_evo ~= 0 then
                    table.insert(showData,cardsIdTable[i])
                end
            end
        end
    end
    local cardsCount = #showData
    self.m_tips_label_1:setVisible(cardsCount == 0)
    local totalItem = math.max(cardsCount%4 == 0 and cardsCount or math.floor(cardsCount/4+1)*4,4)
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;--行
    params.column = 1; --列
    params.totalItem = cardsCount --totalItem;
    params.showPageIndex = self.m_curPage;
    params.direction = kCCScrollViewDirectionVertical;
    -- local id = game_guide_controller:getIdByTeam("5");
    -- if id == 505 then
    --     params.itemActionFlag = false;
    -- else
        params.itemActionFlag = true;
    -- end

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
            cell:setTag(index);
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local itemData,itemCfg = game_data:getCardDataById(showData[index+1]);
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
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  cell = " .. tolua.type(cell));
        if index >= cardsCount then return end;
        if eventType == "ended" and cell then
            local itemData,itemCfg = game_data:getCardDataById(showData[index+1]);
            local super_evo = itemCfg:getNodeWithKey("super_evo")
            super_evo = super_evo and super_evo:toInt() or 0
            if super_evo == 0 then
                game_util:addMoveTips({text = "Đồng đội này không thể siêu tiến hóa!"}); --此伙伴不能超进化
                return;
            end
            local card_id = itemData.id;
            if self.m_selHeroId == nil or self.m_selHeroId ~= card_id then
                if self.m_selListItem then
                    local ccbNode = tolua.cast(self.m_selListItem:getChildByTag(10),"luaCCBNode");
                    local m_sel_img = ccbNode:spriteForName("sprite_selected")
                    m_sel_img:setVisible(false);
                    local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
                    sprite_back_alpha:setVisible(false);
                end
                self.m_material_select_index = nil
                self.m_selListItem = cell;
                self.m_selHeroId = card_id;
                self:refreshHeroInfo(self.m_selHeroId);
                self:refreshTips();
                local ccbNode = tolua.cast(self.m_selListItem:getChildByTag(10),"luaCCBNode");
                local m_sel_img = ccbNode:spriteForName("sprite_selected")
                m_sel_img:setVisible(true);
                local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
                sprite_back_alpha:setVisible(true);

                -- local id = game_guide_controller:getIdByTeam("5");
                -- if id == 507 then
                --     game_guide_controller:gameGuide("show","5",508,{tempNode = self.m_auto_add_btn})
                -- end
            end
        elseif eventType == "longClick" and cell then
            local itemData,_ = game_data:getCardDataByIndex(index+1);--self.m_selHeroTab[index+1].heroData
            local function callBack(typeName)
                typeName = typeName or ""
                if typeName == "refresh" then
                    self:refreshCardTableView();
                end
            end
            game_scene:addPop("game_hero_info_pop",{tGameData = itemData,openType = 1,callBack = callBack})
        end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        -- self.m_selListItem = nil;
        self.m_curPage = curPage;
    end
    return TableViewHelper:create(params);
end

--[[--

]]
function game_hero_super_evolution.refreshSortTabBtn(self,sortIndex)
    local tempBtn = nil;
    if self.m_showType == 1 then
        self.m_selSortIndex = sortIndex
        for i=1,4 do
            tempBtn = self.m_ccbNode:controlButtonForName("m_table_tab_btn_" .. i)
            tempBtn:setHighlighted(self.m_selSortIndex == i);
            tempBtn:setEnabled(self.m_selSortIndex ~= i);
        end
    elseif self.m_showType == 2 then
        self.m_selFilterCardSortIndex = sortIndex
        for i=1,4 do
            tempBtn = self.m_ccbNode:controlButtonForName("m_table_tab_btn_" .. i)
            tempBtn:setHighlighted(self.m_selFilterCardSortIndex == i);
            tempBtn:setEnabled(self.m_selFilterCardSortIndex ~= i);
        end
    end
end

--[[--
    刷新
]]
function game_hero_super_evolution.refreshByType(self,showType)
    self.m_no_material_tips:setVisible(false);
    self.m_showType = showType;
    if showType == 1 then
        self.m_material_id_table = {};
        self:refreshHeroInfo(self.m_selHeroId);
        -- self.m_cost_food_label:setString("0");
        self:refreshSortTabBtn(self.m_selSortIndex);
        self:refreshCardTableView();
    elseif showType == 2 then
        self.m_tips_label_1:setVisible(false)
        self:refreshSortTabBtn(self.m_selFilterCardSortIndex);
        self:refreshFilterCardTableView();
    end
    self:refreshTips();
end

--[[--
    刷新状态
]]
function game_hero_super_evolution.refreshTips(self)
    game_util:setCCControlButtonEnabled(self.m_auto_add_btn,true);
    if self.m_showType == 1 then
        if self.m_selHeroId == nil then
            self.m_tips_spr_1:setVisible(true);
            self.m_tips_spr_2:setVisible(false);
            for i=1,math.min(self.m_needMaterialCount,6) do
                self.m_material_node_tab[i].m_mate_tips:stopAllActions();
                self.m_material_node_tab[i].m_mate_tips:setOpacity(255);
            end
            game_util:setCCControlButtonEnabled(self.m_auto_add_btn,false);
            self.m_tips_spr_1:runAction(game_util:createRepeatForeverFade())
            self.m_light_bg_1:runAction(game_util:createRepeatForeverFade())
        else
            self.m_tips_spr_1:setVisible(false);
            self.m_tips_spr_2:setVisible(false);
            for i=1,math.min(self.m_needMaterialCount,6) do
                self.m_material_node_tab[i].m_mate_tips:runAction(game_util:createRepeatForeverFade())
            end
        end
    elseif self.m_showType == 2 then
        self.m_tips_spr_1:setVisible(false);
        self.m_tips_spr_2:setVisible(false);
    end
    local totalFood = game_data:getUserStatusDataByKey("food") or 0
    local value,unit = game_util:formatValueToString(totalFood);
    self.m_food_total_label:setString(value .. unit);
    -- game_util:setCostLable(self.m_cost_food_label,self.m_evo_food,totalFood);
end

--[[--
    刷新
]]
function game_hero_super_evolution.refreshCardTableView(self)
    self.m_list_view_bg:removeAllChildrenWithCleanup(true);
    self.m_tableView = self:createTableView(self.m_list_view_bg:getContentSize());
    self.m_list_view_bg:addChild(self.m_tableView);
    -- local id = game_guide_controller:getIdByTeam("5");
    -- if id == 505 then
    --     self.m_tableView:setMoveFlag(false)
    --     if self.m_guildNode then
    --         local index = self.m_guildNode:getTag();
    --         cclog("index ===== " .. index)
    --         local contentSize = self.m_tableView:getContentSize()
    --         local viewSize = self.m_tableView:getViewSize()
    --         local cellHeight = viewSize.height  / 5;--一个cell的高度
    --         if viewSize.height <= contentSize.height then--如果contentSize 大于 viewSize 则不需要设置偏移
    --             self.m_tableView:setContentOffset(ccp(0,viewSize.height - contentSize.height + index * cellHeight))
    --         end
    --     end
    -- end

    -- 自适应滑动到选定位置
    local character_detail = getConfig(game_config_field.character_detail);
    local showData = {}
    local selSort = tostring(CARD_SORT_TAB[self.m_selSortIndex].sortType);
    game_data:cardsSortByTypeName3(selSort)
    local cardsData = game_data:getTableCardsData()
    local cardsIdTable = game_data:getDataByKey("m_tCardsIdTable") or {}
    local tempCount = #cardsIdTable
    for i=1,tempCount do
        local itemData = cardsData[cardsIdTable[i]]
        if itemData then
            local step = itemData.step or 0
            local itemConfig = character_detail:getNodeWithKey(itemData.c_id);
            if step > 19 and itemConfig then
                local quality = itemConfig:getNodeWithKey("quality")
                quality = quality and quality:toInt() or 8
                local super_evo = itemConfig:getNodeWithKey("super_evo")
                super_evo = super_evo and super_evo:toInt() or 0
                if quality > 3 and super_evo ~= 0 then
                    table.insert(showData,cardsIdTable[i])
                end
            end
        end
    end


    local _datas = showData
    local _parent = self.m_list_view_bg
    local m_tableView = self.m_tableView
    local index = 1
    for i=1,#_datas do
        if _datas[i] == tostring(self.m_selHeroId) then
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
    m_tableView:setContentOffset(ccp(offset.x, newOffsetY))
end

--[[--
    刷新
]]
function game_hero_super_evolution.refreshFilterCardTableView(self)
    self.m_list_view_bg:removeAllChildrenWithCleanup(true);
    self:filterMaterialData();
    self.m_tableView = self:createFilterTableView(self.m_list_view_bg:getContentSize());
    self.m_list_view_bg:addChild(self.m_tableView);
end

--[[--
    创建属性的列表
]]
function game_hero_super_evolution.createAttrTableView(self,viewSize)
    local cardData,skinHeroCfg,heroCfg = game_data:getCardDataById(tostring(self.m_selHeroId));
    local super_evo = heroCfg:getNodeWithKey("super_evo")
    super_evo = super_evo and super_evo:toInt() or 0
    local super_evolution_cfg = getConfig(game_config_field.super_evolution);
    local super_evolution_cfg_item = super_evolution_cfg:getNodeWithKey(tostring(super_evo))
    if super_evolution_cfg_item == nil then
        game_util:addMoveTips({text = "Siêu tiến hóa thiếu cấu hình" .. tostring(super_evo)}); --超进阶少配置
        return
    end
    local super_evolution_value = (cardData.super_step or 0) + 1
    local super_soul = cardData.super_soul or {}
    local level_need = super_evolution_cfg_item:getNodeWithKey("level_" .. super_evolution_value .. "_need")
    local super_evo_node_1_flag = false
    if level_need then
        self.m_needMaterialTab = json.decode(level_need:getFormatBuffer())
        self.m_needMaterialCount = #self.m_needMaterialTab
        if self.m_needMaterialCount == 0 then
            self.m_status = 1;--不能再超进化
            self.m_super_evo_tips_label:setVisible(true)
        else
            local quality = heroCfg:getNodeWithKey("quality"):toInt();
            local super_quality_1 = cardData.super_quality_1 or 0
            local hero_quality_item = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
            if hero_quality_item then
                self.m_quality_label_1:setString(tostring(hero_quality_item.name))
                self.m_quality_label_1:setColor(hero_quality_item.color)
            end
            super_quality_1 = super_quality_1 + 1
            local hero_quality_item = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
            if hero_quality_item then
                self.m_quality_label_2:setString(tostring(hero_quality_item.name))
                self.m_quality_label_2:setColor(hero_quality_item.color)
            end
        end
        local super_evo_team = getConfig(game_config_field.super_evo_team);
        for k,v in pairs(self.m_needMaterialTab) do
            if v ~= -1 and v ~= -2 then
                local super_evo_team_item = super_evo_team:getNodeWithKey(tostring(v))
                local card_need = super_evo_team_item:getNodeWithKey("card_need"):toInt()
                self.m_needMaterialTab[k] = card_need
            end
            local tempId = super_soul[k]
            if (tempId == nil or tempId == 0) then
                super_evo_node_1_flag = true
            end
        end
    else
        game_util:addMoveTips({text = "Không thể siêu tiến hóa tiếp"}); --不能再超进化
        return
    end
    self.m_super_evo_node_1:setVisible(super_evo_node_1_flag)
    self.m_super_evo_node_2:setVisible(not super_evo_node_1_flag)
    local level_add = super_evolution_cfg_item:getNodeWithKey("level_" .. super_evolution_value .. "_add")
    local tempShowData = json.decode(level_add:getFormatBuffer()) --{{1,101},{2,102},{3,103},{4,104},{5,105},{201,106},{202,107}}
    local tempCount = #tempShowData
    local showData = {}
    for i=1,tempCount do
        if tempShowData[i][1] < 501 then
            table.insert(showData,tempShowData[i])
        end
    end
    local totalItem = #showData
    local params = {};
    params.viewSize = viewSize;
    params.row = 4;--行
    params.column = 1; --列
    params.totalItem = totalItem;
    params.direction = kCCScrollViewDirectionVertical;
    params.itemActionFlag = false;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create();
            ccbNode:openCCBFile("ccb/ui_hero_super_evolution_attr_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_attr_icon = ccbNode:spriteForName("m_attr_icon");
            local m_attr_label = ccbNode:labelTTFForName("m_attr_label");
            local m_add_attr_label = ccbNode:labelTTFForName("m_add_attr_label");
            local itemData = showData[index+1] or {}
            local attrValue = itemData[1] or 0
            local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. tostring(attrValue)]
            if attrTab then
                local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(attrTab.icon)
                if tempSpriteFrame then
                    m_attr_icon:setDisplayFrame(tempSpriteFrame)
                end
                m_attr_label:setString(tostring(cardData[attrTab.attrName] or ""))
            end
            if attrValue > 100 and attrValue < 200 then
                m_add_attr_label:setString("+" .. tostring(itemData[2]) .. "%")
            else
                m_add_attr_label:setString("+" .. tostring(itemData[2]))
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  cell = " .. tolua.type(cell) .. " ; cell:getUserData() = " .. tolua.type(cell:getUserData()));
        if eventType == "ended" and cell then
        end
    end
    return TableViewHelper:create(params);
end

--[[--
    刷新
]]
function game_hero_super_evolution.refreshAttrTableView(self)
    self.m_attr_list_view_bg:removeAllChildrenWithCleanup(true);
    local temptableView = self:createAttrTableView(self.m_attr_list_view_bg:getContentSize());
    if temptableView then
        self.m_attr_list_view_bg:addChild(temptableView);
    end
end

--[[--
    创建属性的列表
]]
function game_hero_super_evolution.createAttrTableView2(self,viewSize)
    local cardData,heroCfg = game_data:getCardDataById(tostring(self.m_selHeroId));
    if cardData == nil then return end
    local super_evo = heroCfg:getNodeWithKey("super_evo")
    super_evo = super_evo and super_evo:toInt() or 0
    local super_evolution_cfg = getConfig(game_config_field.super_evolution);
    local super_evolution_cfg_item = super_evolution_cfg:getNodeWithKey(tostring(super_evo))
    if super_evolution_cfg_item == nil then
        game_util:addMoveTips({text = "Siêu tiến hóa thiếu cấu hình" .. tostring(super_evo)});
        return
    end
    local super_evolution_value = (cardData.super_step or 0) + 1
    local super_soul = cardData.super_soul or {}
    local level_need = super_evolution_cfg_item:getNodeWithKey("level_" .. super_evolution_value .. "_need")
    local tempShowData = {}
    local tempAttrTypeTab = {}
    if level_need then
        local levelNeedTab = json.decode(level_need:getFormatBuffer())
        local super_evo_team = getConfig(game_config_field.super_evo_team);
        for k,v in pairs(levelNeedTab) do
            local super_evo_team_item = super_evo_team:getNodeWithKey(tostring(v))
            if super_evo_team_item then
                local ability_add = super_evo_team_item:getNodeWithKey("ability_add")--{{1,101},{2,102},{3,103},{4,104},{5,105},{201,106},{202,107}}
                local tempId = super_soul[k]
                local material_id = self.m_material_id_table[k]
                if (tempId == nil or tempId == 0) and material_id ~= nil then
                    local ability_add_tab = json.decode(ability_add:getFormatBuffer())
                    for k,v in pairs(ability_add_tab) do
                        local attrType = v[1]
                        local tempIndex = tempAttrTypeTab[attrType]
                        if tempIndex == nil then
                            table.insert(tempShowData,v)
                            tempAttrTypeTab[attrType] = #tempShowData
                        else
                            tempShowData[tempIndex][2] = tempShowData[tempIndex][2] + v[2]
                        end
                    end
                end
            end
        end
    end
    local tempCount = #tempShowData
    local showData = {}
    for i=1,tempCount do
        if tempShowData[i][1] < 501 then
            table.insert(showData,tempShowData[i])
        end
    end
    local totalItem = #showData
    local params = {};
    params.viewSize = viewSize;
    params.row = 6;--行
    params.column = 1; --列
    params.totalItem = totalItem;
    params.direction = kCCScrollViewDirectionVertical;
    params.itemActionFlag = false;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create();
            ccbNode:openCCBFile("ccb/ui_hero_super_evolution_attr_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local m_attr_icon = ccbNode:spriteForName("m_attr_icon");
            local m_attr_label = ccbNode:labelTTFForName("m_attr_label");
            local m_add_attr_label = ccbNode:labelTTFForName("m_add_attr_label");
            local itemData = showData[index+1] or {}
            local attrValue = itemData[1] or 0
            local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. tostring(attrValue)]
            if attrTab then
                local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(attrTab.icon)
                if tempSpriteFrame then
                    m_attr_icon:setDisplayFrame(tempSpriteFrame)
                end
                m_attr_label:setString(tostring(cardData[attrTab.attrName] or ""))
            end
            if attrValue > 100 and attrValue < 200 then
                m_add_attr_label:setString("+" .. tostring(itemData[2]) .. "%")
            else
                m_add_attr_label:setString("+" .. tostring(itemData[2]))
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,cell)
        -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  cell = " .. tolua.type(cell) .. " ; cell:getUserData() = " .. tolua.type(cell:getUserData()));
        if eventType == "ended" and cell then
        end
    end
    return TableViewHelper:create(params);
end

--[[--
    刷新
]]
function game_hero_super_evolution.refreshAttrTableView2(self)
    self.m_attr_list_view_bg_2:removeAllChildrenWithCleanup(true);
    local temptableView = self:createAttrTableView2(self.m_attr_list_view_bg_2:getContentSize());
    if temptableView then
        self.m_attr_list_view_bg_2:addChild(temptableView);
    end
end

--[[--
    刷新
]]
function game_hero_super_evolution.refreshCombatLabel(self)
    if self.m_tempCombatValue == nil then
        self.m_tempCombatValue = game_util:getCombatValue()
        self.m_combatNumberChangeNode:setCurValue(self.m_tempCombatValue,false);
    else
        local tempCombatValue = game_util:getCombatValue();
        local changeValue = tempCombatValue - self.m_tempCombatValue
        self.m_tempCombatValue = tempCombatValue;
        game_util:combatChangedValueAnim({combatNode = self.m_combatNumberChangeNode,currentValue = tempCombatValue,changeValue = changeValue});
    end
end

--[[--
    刷新ui
]]
function game_hero_super_evolution.refreshUi(self)
    self:refreshHeroInfo(self.m_selHeroId);
    self:refreshByType(self.m_showType);
    self:refreshCombatLabel();
end
--[[--
    初始化
]]
function game_hero_super_evolution.init(self,t_params)
    t_params = t_params or {};
    -- body
    self.m_selHeroId = t_params.selHeroId;
    self.m_showType = 1;
    self.m_maxCrystalLv = 1;
    self.m_material_id_table = {};
    self.m_material_node_tab = {};
    self.m_evo_food = 0;
    self.m_status = 0;
    self.m_selFilterCardSortIndex = 1;
    self.m_selHeroTab = {};
    local selSort = game_data:getCardSortType();
    for k,v in pairs(CARD_SORT_TAB) do
        if v.sortType == selSort then
            self.m_selSortIndex = k;
            break;
        end
    end
    self.m_selSortIndex = self.m_selSortIndex or 1;
    self.m_showHeroTable = {};
    self.m_needMaterialCount = 1;
    self.m_needMaterialTab = {};
    self.m_material_select_index = nil;
    self.m_famousAllData = game_data:getFamousAllData()

end

--[[--
    创建ui入口并初始化数据
]]
function game_hero_super_evolution.create(self,t_params)
    -- body
    self:init(t_params);
    local uiNode = self:createUi();
    self:refreshUi();
    -- local id = game_guide_controller:getIdByTeam("5");
    -- if id == 505 then
    --     self:gameGuide("drama","5",506)
    -- end
    return uiNode;
end


--[[
    新手引导
]]
function game_hero_super_evolution.gameGuide(self,guideType,guide_team,guide_id,t_params)
    if not game_guide_controller:getGuideCompareFlag(guide_team,guide_id) then return end
    local id = game_guide_controller:getId(guide_team,guide_id);
    t_params = t_params or {};
    if guideType == "drama" then
        if guide_team == "5" and id == 506 then
            local function endCallFunc()
                if self.m_guildNode then
                    game_guide_controller:gameGuide("show","5",507,{tempNode = self.m_guildNode})
                end
            end
            t_params.guideType = "drama";
            t_params.endCallFunc = endCallFunc;
            game_guide_controller:showGuide(guide_team,guide_id,t_params)
        -- elseif guide_team == "5" and id == 511 then
        --     local function endCallFunc()
        --         game_guide_controller:gameGuide("send","5",511);
        --     end
        --     t_params.guideType = "drama";
        --     t_params.endCallFunc = endCallFunc;
        --     game_guide_controller:showGuide(guide_team,guide_id,t_params)
        end
    end
end


return game_hero_super_evolution;
 g