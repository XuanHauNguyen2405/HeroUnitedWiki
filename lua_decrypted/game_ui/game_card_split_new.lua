---  卡牌分解
local game_card_split = {
    m_table_view = nil,--table
    m_back_btn = nil,--返回
    m_dirt_sliver_label = nil,--银尘

    m_sprite_background = nil,--显示英雄卡牌的背景

    m_for_shop_btn = nil,--兑换商店
    m_split_btn = nil,--分解
    m_auto_add_btn = nil,--自动添加

    m_select_flag = nil,
    test_count = nil,
    m_select_id_table = nil,--记录选择的

    m_text_label2 = nil,
    sliver_dir_value = nil,--超能之尘值
    sliver_dir_min = nil,
    sliver_dir_max = nil,
    gold_dir_value = nil,
    gold_dir_min = nil,
    gold_dir_max = nil,

    m_hero_id_table = nil,--存英雄Id的表
    m_btn_table = nil,--切换排序
    m_temp_table = nil,--裁剪的卡牌表

    m_real_list = nil,

    m_sprite_tag = nil,--sprite tag 的索引
    m_selHeroId = nil,

    split_flag = nil,--分解动画flag
    split_index = nil,--

    m_sprite_max = nil,  -- 资源展示个数
    m_split_num_max = nil,  -- 分解数量上限
    tableMoveOffsetY = nil;
    tableView = nil;
    m_split_node1 = nil;
    m_split_node = nil;
}
--[[--
    销毁ui
]]
function game_card_split.destroy(self)
    -- body
    cclog("-----------------game_card_split destroy-----------------");
    self.m_table_view = nil;
    self.m_back_btn = nil;
    self.m_back_btn = nil;
    self.m_dirt_sliver_label = nil;

    self.m_sprite_background = nil;

    self.m_for_shop_btn = nil;
    self.m_split_btn = nil;
    self.m_auto_add_btn = nil;

    self.m_select_flag = nil;
    test_count = nil;
    self.m_select_id_table = nil;

    self.m_text_label2 = nil;
    self.sliver_dir_value = nil;
    self.gold_dir_value = nil;

    self.m_hero_id_table = nil;
    self.m_btn_table = nil;
    self.m_temp_table = nil;

    self.m_real_list = nil;
    self.m_sprite_tag = nil;
    self.m_selHeroId = nil;

    self.sliver_dir_min = nil;
    self.sliver_dir_max = nil;
    self.gold_dir_min = nil;
    self.gold_dir_max = nil;
    self.split_flag = nil;
    self.split_index = nil;
    self.m_sprite_max = nil;
    self.m_split_num_max = nil;
    self.tableMoveOffsetY = nil;
    self.tableView = nil;
    self.m_split_node1 = nil;
    self.m_split_node = nil;
end
--[[--
    返回
]]
function game_card_split.back(self,backType)
    game_scene:enterGameUi("game_main_scene",{gameData = nil});
    self:destroy();
end
--[[--
    读取ccbi创建ui
]]
function game_card_split.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        if btnTag == 100 then--兑换商城
            local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_card_split_shop",{gameData = gameData,openType = "game_card_split"})
                self:destroy()
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_open_dirt_shop"), http_request_method.GET, nil,"cards_open_dirt_shop")
        elseif btnTag == 101 then--分解
            self.split_index = 0
            local function card_split(card_list)
                local t_params = 
                {
                    title = string_config.m_title_prompt,
                    okBtnCallBack = function(target,event)
                        if self.tableView then
                            self.tableMoveOffsetY = self.tableView:getContentOffset().y
                        end
                        game_util:closeAlertView();
                        local function responseMethod(tag,gameData)
                            local data = gameData:getNodeWithKey("data")
                            local cards_remove = data:getNodeWithKey("_client_cache_update"):getNodeWithKey("cards"):getNodeWithKey("cards"):getNodeWithKey("remove")
                            local cards_remove_count = cards_remove:getNodeCount();
                            local reward = data:getNodeWithKey("reward")
                            game_util:rewardTipsByJsonData(reward);
                            local function remove_node( node )--回调隐藏，回归原位
                                cclog("remove_node")
                                self.split_index = self.split_index + 1
                                if self.split_index > #self.m_hero_id_table then
                                    node:removeFromParentAndCleanup(true)
                                    --
                                    self.split_index = 0
                                    self.split_flag = false
                                end
                            end 
                            local function anim_call_function(sprite)
                                cclog("anim_call_function")
                                local anim_node = game_util:createSplitEffectAnim("animi_card_split1",1,false,remove_node,sprite)
                                local anima_size = sprite:getContentSize()
                                local pX,pY = sprite:getPosition();
                                anim_node:setAnchorPoint(ccp(0.5,0.5))
                                anim_node:setPosition(ccp(pX,pY));
                                self.m_sprite_background:addChild(anim_node,10)
                                game_sound:playUiSound("zhakai2")
                            end

                            self.split_flag = true
                            --特效动画 animi_hero_inherit    animi_card_split
                            for i=1,#self.m_hero_id_table do
                                cclog("i----------------"..i)
                                local hero_id = self.m_hero_id_table[i];
                                local sprite_tag = self.m_select_id_table[tostring(hero_id)];
                                local sprite = tolua.cast(self.m_sprite_background:getChildByTag(sprite_tag),"CCSprite");
                                if sprite then
                                    local function callback(sprite)
                                        cclog("callback")
                                        local anim_node = game_util:createSplitEffectAnim("animi_card_split",1,false,anim_call_function,sprite)
                                        local anima_size = sprite:getContentSize()
                                        local pX,pY = sprite:getPosition();
                                        anim_node:setAnchorPoint(ccp(0.5,0.5))
                                        anim_node:setPosition(ccp(pX,pY));
                                        local count = #self.m_hero_id_table
                                        self.m_sprite_background:addChild(anim_node,30-(count-i))
                                        --音效
                                        game_sound:playUiSound("qian1")
                                    end
                                    local animArr = CCArray:create();
                                    animArr:addObject(CCDelayTime:create(0.2 * (#self.m_hero_id_table-i)));
                                    animArr:addObject(CCCallFuncN:create(callback));
                                    local sequence = CCSequence:create(animArr);
                                    sprite:runAction(sequence); 
                                end
                            end
                            self.m_select_id_table = {}
                            -- self.gold_dir_value = {}
                            self.m_hero_id_table = {}
                            self.m_real_list = {}
                            self.card_num:setString("")
                             self.m_dirt_sliver_label:setString("0") 
                            self.m_split_node1:setVisible(true)
                            self.m_split_node:setVisible(false)
                            -- self.split_flag = false
                            --必须重新加载卡牌数据，否则会报错
                            self.m_temp_table = game_data:getCardsDataByQuality(2);
                            game_data:cardsSortByTypeNameWithTable("default",self.m_temp_table);
                            self:refreshUi();
                
                        end
                        local params = "";
                        for i=1,#self.m_hero_id_table do
                            params = params .. "card_id="..self.m_hero_id_table[i].."&";
                        end
                        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_exchange_cards"), http_request_method.GET, params,"cards_exchange_cards")
                    end,   --可缺省
                    closeCallBack = function(target,event)
                        game_util:closeAlertView();
                    end,
                    cancelBtnText = "Hủy",
                    onlyOneBtn = false,
                    okBtnText = "Xác nhận",       --可缺省
                    text = "Xác định muốn phân giải các thẻ trên?",      --可缺省
                }
                game_util:openAlertView(t_params);
            end
            if #self.m_hero_id_table > 0 then
                card_split();
            else
                game_util:addMoveTips({text = "Xin thêm đồng đội muốn phân giải"})
            end
        elseif btnTag == 102 then--自动添加
            
            if self.split_flag == true then
                game_util:addMoveTips({text = "Đang phân giải!"});
            else
                self.m_real_list = {}
                self.m_hero_id_table = {};
                self.m_sprite_background:removeAllChildrenWithCleanup(true)
                self:setAutoAddCard()
            end
        elseif btnTag == 105 then--返回
            self:back();
        elseif btnTag > 200 and btnTag < 205 then
            local index = btnTag - 200;
            for i=1,4 do
                self.m_btn_table[i]:setEnabled(true)
                self.m_btn_table[i]:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_table_select.png"),CCControlStateNormal);
            end
            self.m_btn_table[index]:setEnabled(false)
            self.m_btn_table[index]:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_table_selected.png"),CCControlStateDisabled);
            --切换table
            local typeTable = {"default","quality","lv","profession",};
            game_data:cardsSortByTypeNameWithTable(typeTable[index],self.m_temp_table);
            self:refreshUi();
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_card_split_new.ccbi");

    self.m_table_view = ccbNode:nodeForName("table_view_node");
    self.m_dirt_sliver_label = ccbNode:labelBMFontForName("dirt_sliver_label");

    self.card_num = ccbNode:labelBMFontForName("card_num")

    self.m_sprite_background = ccbNode:spriteForName("sprite_background");

    self.m_for_shop_btn = ccbNode:controlButtonForName("btn_duihuan");
    self.m_split_btn = ccbNode:controlButtonForName("btn_fenjie");
    self.m_auto_add_btn = ccbNode:controlButtonForName("btn_auto_add");

    game_util:setControlButtonTitleBMFont(self.m_for_shop_btn)
    game_util:setControlButtonTitleBMFont(self.m_split_btn)
    game_util:setControlButtonTitleBMFont(self.m_auto_add_btn)

    self.m_split_node1 = ccbNode:nodeForName("m_split_node1")
    self.m_split_node = ccbNode:nodeForName("m_split_node")
    
    self.m_back_btn = ccbNode:controlButtonForName("btn_back");
    --播放动画
    self.m_text_label2 = ccbNode:spriteForName("text_label2");
    local label_tps = ccbNode:labelTTFForName("label_tps")
    label_tps:setString("Cùng một loại thẻ tối đa phân giải 10 lá cùng lúc.")
    self.m_btn_table = {}
    for i=1,4 do
        self.m_btn_table[i] = ccbNode:controlButtonForName("table_tab_btn_"..i)
        self.m_btn_table[i]:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_table_select.png"),CCControlStateNormal);
    end
    self.m_btn_table[1]:setBackgroundSpriteFrameForState(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_table_selected.png"),CCControlStateNormal);

    -- local anmiTimeLine = "Label Timeline"
    local anmiTimeLine = "Default Timeline"
    local function animCallFunc(animName)
        ccbNode:runAnimations(anmiTimeLine)
    end
    ccbNode:registerAnimFunc(animCallFunc);
    ccbNode:runAnimations(anmiTimeLine)
    self.test_count = 0;
    --将英雄信息加入
    self.m_select_id_table = {};
    self.m_hero_id_table = {};
    self.sliver_dir_value = 0;
    self.sliver_dir_min = 0
    self.sliver_dir_max = 0
    self.gold_dir_min = 0
    self.gold_dir_max = 0
    self.gold_dir_value = 0;
    self.m_sprite_max = 10
    self.m_split_num_max = 49  -- 实际是+1的效果 30
    self.m_dirt_sliver_label:setString(tostring(self.sliver_dir_value))
    self.card_num:setString("")
    -- 选择分解种类三按钮
    return ccbNode;
end


--[[
    刷新选中英雄
]]--
function game_card_split.refresh_select_list(self)
    -- cclog("count == " .. #self.m_hero_id_table)
    -- cclog("self.m_hero_id_table == " .. json.encode(self.m_hero_id_table))
    -- cclog("self.m_select_id_table == " .. json.encode(self.m_select_id_table))
    self.m_real_list = {}
    for i=1,#self.m_hero_id_table do
        local hero_id = self.m_hero_id_table[i];
        if tostring(hero_id) ~= tostring(0) then
            table.insert(self.m_real_list,hero_id)
        end
    end
    if #self.m_real_list > self.m_sprite_max then
        return
    end
    local count = #self.m_real_list
    if count > 11 then
        count = 11
    end
    local length = 10;
    if count <= 10 then
        length = 10;
    else
        length = 100 / count;
    end
    for i=1,#self.m_real_list do
        local hero_id = self.m_real_list[i];
        local sprite_tag = self.m_select_id_table[tostring(hero_id)];
        cclog("sprite_tag == " .. sprite_tag)
        local hero_node = self.m_sprite_background:getChildByTag(sprite_tag);
        if hero_node then 
            local node_size = hero_node:getContentSize();
            hero_node:setPosition(ccp(node_size.width*0.5+10+(count-i)*length,node_size.height*0.5+8));
        end
    end
    self:setSplitShow()
end

--[[
    创建分解列表
]]--
function game_card_split.createTableView( self,viewSize )
    -- local cardsCount = game_data:getCardsCount();
    local tempIdTable = self.m_temp_table
    local cardsCount = #tempIdTable;
    local params = {};
    params.viewSize = viewSize;
    params.row = 5;
    params.column = 1; --列
    params.totalItem = cardsCount;
    params.itemActionFlag = true;
    params.direction = kCCScrollViewDirectionVertical;--纵向
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
--[[
    cell
]]--
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new();
            cell:autorelease();
            local ccbNode = game_util:createHeroListItemByCCB2();
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            local itemData,itemCfg = game_data:getCardDataById(tempIdTable[cardsCount - index]);
            if itemData and itemCfg then
                local heroId = itemData.id;
                game_util:setHeroListItemInfoByTable2(ccbNode,itemData);

                local sprite_selected = ccbNode:spriteForName("sprite_selected");
                local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
                
                local flag,k = game_util:idInTableById(tostring(itemData.id),self.m_hero_id_table);
                local godflag = game_util:godheroInTeamById(tostring(itemData.id));
                if flag and godflag ~= true then
                    sprite_selected:setVisible(true);
                    sprite_back_alpha:setVisible(true);
                else
                    sprite_selected:setVisible(false);
                    sprite_back_alpha:setVisible(false);
                end
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  item = " .. tolua.type(item) .. " ; item:getUserData() = " .. tolua.type(item:getUserData()));
        if eventType == "ended" and item then
            local ccbNode = tolua.cast(item:getChildByTag(10),"luaCCBNode");
            local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
            local sprite_selected = ccbNode:spriteForName("sprite_selected");
            -- local itemData,hero_config = game_data:getCardDataByIndex(cardsCount - index);
            local itemData,hero_config = game_data:getCardDataById(tempIdTable[cardsCount - index]);
            -- cclog2(itemData,"itemData------")
            local is_same,c_id = self:getSelectByCIdCount()
            if is_same and itemData.c_id ~= c_id then 
                game_util:addMoveTips({text = "Chỉ có thể thêm cùng một loại thẻ để phân giải!"});
                return
            end
            
            local flag,k = game_util:idInTableById(tostring(itemData.id),self.m_hero_id_table);
            local dispatchFlag,dispatchK = game_util:idInTableById(tostring(itemData.id),game_data:getDispatchTab());
            local godflag = game_util:godheroInTeamById(tostring(itemData.id));
            local isinBonus = game_util:isInFormationBonus2(itemData.id)
            if flag and k ~= nil then
                table.remove(self.m_hero_id_table,k);

                sprite_selected:setVisible(false);
                sprite_back_alpha:setVisible(false);
                for key,value in pairs(self.m_select_id_table) do
                    if tostring(key) == tostring(itemData.id) then
                        if self.m_sprite_background:getChildByTag(value) ~= nil then
                            self.m_sprite_background:removeChildByTag(value,true);
                        end
                        --删除select_table 的该项
                        -- self.m_select_id_table[key] = nil;
                    end
                end

                self:refresh_select_list();
            elseif isinBonus == "zhenfaAdd" then 
                game_util:addMoveTips({text = "Anh hùng này đang nhận thêm thuộc tính từ trận pháp, không thể phân giải."})
            elseif godflag == true then
                game_util:addMoveTips({text = "Anh hùng này đang ở đội hình Thần Vực, không thể phân giải."})
            elseif dispatchFlag then
                game_util:addMoveTips({text = "Đã cử đi!"});
            elseif self.m_famousAllData[tostring(itemData.id)] then
                game_util:addMoveTips({text = "Tướng này ở Hall of Fame, không thể phân giải"})
            else
                if self.m_hero_id_table and #self.m_hero_id_table >= 10 then 
                    game_util:addMoveTips({text = "Số lượng thẻ thêm đã đạt giới hạn, tối đa 10 lá!"});
                    return
                end
                if itemData.lv > 1 then
                    game_util:addMoveTips({text = "Chỉ có thể thêm thẻ cấp 1 để phân giải."});
                    return
                end
                if itemData.is_world and itemData.is_world == true then--转世
                    game_util:addMoveTips({text = "Thẻ chuyển sinh không thể phân giải."});
                    return
                end
                if not self:getIsExchangeCard(itemData) then 
                    game_util:addMoveTips({text = "Thẻ này không thể phân giải thành mảnh."});
                    return
                end
                if self.split_flag == true then
                    game_util:addMoveTips({text = "Đang phân giải!"});
                else
                    local is_in_team = game_data:heroInTeamById(itemData.id);
                    local is_lock = game_util:getCardUserLockFlag(itemData);
                    local is_in_train = game_util:getCardTrainingFlag(itemData);
                    local is_in_cheer = game_data:heroInAssistantById(itemData.id)
                    local can_select = is_in_team or is_lock or is_in_train or is_in_cheer;
                    
                    if can_select == true then
                        if is_in_team then
                            game_util:addMoveTips({text = "Đồng đội này đã ra trận!"});
                        elseif is_in_train then
                            game_util:addMoveTips({text = "Đồng đội này đang huấn luyện!"});
                        elseif is_lock then
                            game_util:addMoveTips({text = "Đồng đội này đaã bị khóa định!"});
                        elseif is_in_cheer then
                            game_util:addMoveTips({text = "Đồng đội này đang trợ uy!"});
                        end
                    else
                        local exchange_id = hero_config:getNodeWithKey("exchange_id"):toInt()
                        if itemData.step and itemData.step >= 1 then
                            game_util:addMoveTips({text = "Đồng minh đã tiến hóa chỉ có thể phân giải sau khi tái sinh!"});
                        elseif exchange_id > 0 then
                            if #self.m_real_list <= 10 then
                                sprite_selected:setVisible(true);
                                sprite_back_alpha:setVisible(true);
                                self:addHeroFromCellIndex(itemData)
                                -- self:refreshUi()
                            else
                                game_util:addMoveTips({text = "Số lượng phân giải đạt giới hạn!"});
                            end
                        else--exchange_id=0 的伙伴不能分解
                            game_util:addMoveTips({text = "Đồng đội này không thể phân giải!"});
                        end
                    end
                end
            end
        end
    end
    return TableViewHelper:create(params);
end
--[[
    添加英雄全身像
]]--
function game_card_split.addHeroFromCellIndex(self,itemData)
    local is_in_team = game_data:heroInTeamById(itemData.id);
    local is_lock = game_util:getCardUserLockFlag(itemData);
    local is_in_train = game_util:getCardTrainingFlag(itemData)
    local is_in_cheer = game_data:heroInAssistantById(itemData.id)
    local can_select = is_in_team or is_lock or is_in_train or is_in_cheer;
    local godflag = game_util:godheroInTeamById(tostring(itemData.id));
    if can_select == true then
    else
        table.insert(self.m_hero_id_table,itemData.id);
        local hero_node = game_util:createHeroListItemByCCB(itemData);
        hero_node:setAnchorPoint(ccp(0.5,0.5))
        local node_size = hero_node:getContentSize();
        self.m_select_id_table[tostring(itemData.id)] = self.m_sprite_tag
        
        if #self.m_hero_id_table <= self.m_sprite_max then
            self.m_sprite_background:addChild(hero_node,10,self.m_sprite_tag);
        end
        self.m_sprite_tag = self.m_sprite_tag + 1
        self:refresh_select_list();
    end
    self:setSplitShow()
end

function game_card_split:refreshOneKeyUi( ... )
    self.m_dirt_sliver_label:setString("0")
    self.card_num:setString("")
    self.m_real_list = {}
    self.m_sprite_background:removeAllChildrenWithCleanup(true)
end

--[[
    获得进阶到N的卡牌消耗的卡牌
]]
function game_card_split.getAdvancedCount(self,evo,quality,heroCfg)
    local evolutionCfg = game_data:getEvolutionCfgByHeroCfg(heroCfg);--game_util:getEvolutionCfgByQuality(quality);
    local totalExp = 0
    for i=1,evo + 1 do
        local itemCfg = evolutionCfg:getNodeWithKey(tostring(i-1))
        local evo_exp = itemCfg:getNodeWithKey("exp"):toInt()
        totalExp = totalExp + evo_exp
    end
    local costCard = math.floor(totalExp / 10)
    return costCard
end

--[[
    获得当前可选中的同卡牌数量
]]

function game_card_split.getSelectByCIdCount( self )
    if self.m_hero_id_table and self.m_hero_id_table[1] then 
        local cardid = self.m_hero_id_table[1]
        local hero_data,hero_config = game_data:getCardDataById(cardid)
        return true, hero_data.c_id
    else
        return false,nil
    end
end

--[[
    碎片展示
]]
function game_card_split:setSplitShow( ... )
    local item_cfg = getConfig(game_config_field.item);
    local exchange = getConfig(game_config_field.exchange);
    local exchange_cfg = json.decode(exchange:getFormatBuffer())
    if self.m_hero_id_table and self.m_hero_id_table[1] then 
        self.m_split_node:setVisible(true)
        self.m_split_node:removeAllChildrenWithCleanup(true)
        self.m_split_node1:setVisible(false)
        local count = #self.m_hero_id_table 
        local hero_data,hero_config = game_data:getCardDataById(self.m_hero_id_table[1]);
        local c_id = hero_data.c_id
        local tempCfg ={}
        for k,v in pairs(exchange_cfg) do
            local change_id = v.change_id
            if change_id[1][1] == 5 and change_id[1][2] == tonumber(c_id) then 
                tempCfg = v
                break
            end
        end
        local need_num = tempCfg.need_num[1] or 0
        self.m_dirt_sliver_label:setString(need_num * count) 
        local itemCfg = item_cfg:getNodeWithKey(tostring(tempCfg.need_item));
        self.m_split_node:addChild(game_util:createItemIconByCfg(itemCfg))

    else
        self.m_dirt_sliver_label:setString("0") 
        self.m_split_node1:setVisible(true)
        self.m_split_node:setVisible(false)
    end

    if #self.m_hero_id_table == 0 then
        self.card_num:setString("")
    else
        self.card_num:setString(tostring("x".. tostring(#self.m_hero_id_table)))
    end
end

function game_card_split:getIsExchangeCard( hero_data )
    local c_id = hero_data.c_id
    local exchange = getConfig(game_config_field.exchange);
    local exchange_cfg = json.decode(exchange:getFormatBuffer())
    local tempCfg ={}
    for k,v in pairs(exchange_cfg) do
        local change_id = v.change_id
        if change_id[1][1] == 5 and change_id[1][2] == tonumber(c_id) then 
            tempCfg = v
            break
        end
    end
    if tempCfg and not tempCfg.need_num then 
        return false
    else
        return true
    end
end

function game_card_split:setAutoAddCard( ... )
    local tempIdTable = self.m_temp_table
    local function get_last_hero()
        local index = 0
        local itemData = nil
        for i=#tempIdTable,1,-1 do
            --得到最后一个，去排除  quality < 2 出战和 加锁，训练的，和没有选择过的 返回符合条件的第一个
            -- local hero_data,hero_config = game_data:getCardDataByIndex(i)
            local hero_data,hero_config = game_data:getCardDataById(tempIdTable[i]);
            local quality = hero_data.quality
            local is_in_team = game_data:heroInTeamById(hero_data.id);
            local is_lock = game_util:getCardUserLockFlag(hero_data);
            local is_in_train = game_util:getCardTrainingFlag(hero_data)
            local can_select = is_in_team or is_lock or is_in_train;
            local isinBonus = game_util:isInFormationBonus2(hero_data.id) -- 阵法加成
            local is_world = false
            if hero_data.is_world and hero_data.is_world == true then--转世
                is_world = true
            end
            local is_exchange = self:getIsExchangeCard(hero_data)
            if can_select == false and quality >= 2  and is_exchange then
                --exchage_id > 0 才让添加
                if not hero_data.step or hero_data.step < 1 and hero_data.lv < 2 and not is_world and isinBonus ~= "zhenfaAdd" then  --"进阶4次的伙伴重生后才能分解！
                    local exchange_id = hero_config:getNodeWithKey("exchange_id"):toInt()
                    if exchange_id > 0 then
                        local flag,k = game_util:idInTableById(tostring(hero_data.id),self.m_hero_id_table);
                        local godflag = game_util:godheroInTeamById(tostring(hero_data.id));
                        local dispatchFlag,dispatchK = game_util:idInTableById(tostring(hero_data.id),game_data:getDispatchTab());
                        if flag and k ~= nil then
                        elseif godflag == true then
                            --限制在神域的卡牌不被自动添加分解
                        elseif dispatchFlag == true then
                        elseif self.m_famousAllData[hero_data.id] then
                        else
                            index = i;
                            itemData = hero_data;
                            break;
                        end
                    end
                end
            end
        end
        return index,itemData
    end
    local index,itemData = get_last_hero()
    local c_id = itemData.c_id
    local tempTab = {}
    for i=#tempIdTable,1,-1 do
        local hero_data,hero_config = game_data:getCardDataById(tempIdTable[i]);
        if hero_data.c_id == c_id then 
            if self:getIsAutoAddHero(tempIdTable[i]) then 
                table.insert(tempTab,hero_data)
            end
        end
    end
    local count = 0
    if #tempTab >= 10 then 
        count = 10
    else
        count = #tempTab
    end
    if count == 0 then 
        game_util:addMoveTips({text = "Đồng đội này không thể phân giải!"});
        return
    end

    for i=1,count do
        self:addHeroFromCellIndex(tempTab[i])
    end
    self:refreshUi()                         
end

function game_card_split:getIsAutoAddHero( hero_id )
    local hero_data,hero_config = game_data:getCardDataById(hero_id);
    local quality = hero_data.quality
    local is_in_team = game_data:heroInTeamById(hero_data.id);
    local is_lock = game_util:getCardUserLockFlag(hero_data);
    local is_in_train = game_util:getCardTrainingFlag(hero_data)
    local can_select = is_in_team or is_lock or is_in_train;
    local isinBonus = game_util:isInFormationBonus2(hero_data.id) -- 阵法加成
    local is_world = false
    if hero_data.is_world and hero_data.is_world == true then--转世
        is_world = true
    end
    if can_select == false and quality >= 2 then
        --exchage_id > 0 才让添加
        if not hero_data.step or hero_data.step < 1 and hero_data.lv < 2 and not is_world and isinBonus ~= "zhenfaAdd" then  --"进阶4次的伙伴重生后才能分解！
            local exchange_id = hero_config:getNodeWithKey("exchange_id"):toInt()
            if exchange_id > 0 then
                local flag,k = game_util:idInTableById(tostring(hero_data.id),self.m_hero_id_table);
                local godflag = game_util:godheroInTeamById(tostring(hero_data.id));
                local dispatchFlag,dispatchK = game_util:idInTableById(tostring(hero_data.id),game_data:getDispatchTab());
                if flag and k ~= nil then
                elseif godflag == true then
                    --限制在神域的卡牌不被自动添加分解
                elseif dispatchFlag == true then
                elseif self.m_famousAllData[hero_data.id] then
                else
                    return true
                end
            end
        end
    end
    return false
end
--[[--
    刷新ui
]]
function game_card_split.refreshUi(self)
    self.m_table_view:removeAllChildrenWithCleanup(true);
    -- self.m_temp_table = game_data:getCardsDataByQuality(2);
    -- game_data:cardsSortByTypeNameWithTable("default",self.m_temp_table);
    local tableViewTemp = self:createTableView(self.m_table_view:getContentSize());
    tableViewTemp:setScrollBarVisible(false);
    self.m_table_view:addChild(tableViewTemp);
    self.tableView = tableViewTemp

    -- 分解后自动定位
    local _tableMoveOffsetY = self.tableMoveOffsetY

    local viewSize = self.m_table_view:getContentSize();
    local itemSize = CCSizeMake(viewSize.width/1,viewSize.height/5);
    if _tableMoveOffsetY then
        local maxHeight = #self.m_temp_table * itemSize.height - self.m_table_view:getContentSize().height
        if _tableMoveOffsetY < -maxHeight then
            _tableMoveOffsetY = -maxHeight
        end
        local offset = tableViewTemp:getContentOffset()
        tableViewTemp:setContentOffset(ccp(offset.x, _tableMoveOffsetY))
    end
end
--[[--
    初始化
]]
function game_card_split.init(self,t_params)
    t_params = t_params or {};
    self.m_temp_table = game_data:getCardsDataByQualityFiltered(2);
    game_data:cardsSortByTypeNameWithTable("default",self.m_temp_table);
    self.m_sprite_tag = 101;
    self.m_selHeroId = t_params.selHeroId
    self.m_real_list = {}
    self.split_flag = false

    self.m_famousAllData = game_data:getFamousAllData()

end

--[[--
    创建ui入口并初始化数据
]]
function game_card_split.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    local id = game_guide_controller:getIdByTeam("12");
    if id == 1201 then
        game_guide_controller:gameGuide("drama","12",1201)
    end
    return scene;
end

return game_card_split;D�  