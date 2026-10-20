--- 游戏公共方法集合
local tostring,os,type,pairs,math,tonumber = tostring,os,type,pairs,math,tonumber
local M = {};
require "shared.extern"

--[[--
    创建待机动画
]]
function M.createBattleIdelAnim(self,animFile,animId,cardData,cardCfg,equipData,animNode)
    return self:createIdelAnim(animFile,animId,cardData,cardCfg,equipData,animNode)
end

--[[--
    播放动作
]]
function M.playSection(self,animNode,name,state)

    local curSectionName = animNode:getCurSectionName();
    -- if(M:isPlayTheAction(name,anim_label_name_cfg.siwang))then
    --     cclog("----------game_util:playSection->siwang " .. curSectionName);
    -- else
    --     cclog("----------game_util:playSection->" .. name);
    -- end
    if(M:isPlayTheAction(curSectionName,anim_label_name_cfg.siwang))then
        if (string.find(name,"gongji")==nil and string.find(name,"mofa")==nil) and string.find(name,"bianshen")==nil then
            return;
        end
    end

    if state then  --changedByZJR  卡牌多段变身
        if state == 0 then
            name = name
        else 
            if string.find(name,"_") then
            else
                name = name.."_" .. state + 1
            end
        end
    else

    end

    --animNode:playSection(name)
    game_anim:playSection(animNode , name);
end

--[[--
    判断当前动作是否是哪个动作
]]
function M.isPlayTheAction(self,curLable,isLable)
    if(curLable == isLable) then
        return true
    elseif(curLable == (isLable.."_2")) then
        return true
    else
        return false
    end
end

--[[--
    创建待机动画
        animFile(string):动画名，无后缀名
        animId(int):动画id
        cardData(table):单张卡牌数据 
        cardCfg(json):单张卡牌的详情配置
        equipData(table):卡牌位置上的装备  可为nil
]]
function M.createIdelAnim(self,animFile,animId,cardData,cardCfg,equipData,animNode,zhuanshiTag)
    if cardData and equipData == nil then
        equipData = game_data:getEquipDataByCardId(cardData.id);
    end

    animId = animId or 0;
    local m_iAnim = animNode;
    -- cclog("M.createIdelAnim() animFile =====" .. animFile .. " ; animId ==" .. animId)
    if(m_iAnim == nil) then
       -- cclog("m_iAnim == nil")
       m_iAnim = game_util:createSortNode(animFile .. ".swf.sam",animId,animFile .. ".plist");
    end
    if m_iAnim == nil then 
        m_iAnim = game_util:createUnknowIdelAnim(animFile,animId);
        animFile = "unknow";
    end
    if cardCfg then
        local rgb = 0;
        if tolua.type(cardCfg) == "util_json" then
            rgb = cardCfg:getNodeWithKey("rgb_sort")
            if rgb then
                rgb = rgb:toInt();
            else
                rgb = 0;
            end
        else
            rgb = cardCfg.rgb_sort or 0;
        end
        if rgb == 1 then
            m_iAnim:setColor(ccc3(47,255,118));
        elseif rgb == 2 then
            m_iAnim:setColor(ccc3(67,117,253));
        elseif rgb == 3 then
            m_iAnim:setColor(ccc3(171,65,255));
        end
    end
    m_iAnim:setScale(public_config.anim_scale)
    local function animEnd(animNode,theId,labelName)
        animNode:playSection(anim_label_name_cfg.daiji);
    end
    local function qualityEnd(animNode,theId,labelName)
        animNode:playSection(labelName);
    end
    local function equipEnd( animNode,theId,labelName )
        -- body
        animNode:playSection(labelName);
    end
    local function crystalEnd( animNode,theId,labelName )
        -- body
        animNode:playSection(labelName);
    end
    local function stepEnd( animNode,theId,labelName )
        -- body
        animNode:playSection(labelName);
    end
    m_iAnim:registerScriptTapHandler(animEnd);
    local function componentFunc( node,theId,flag,x,y )
        -- cclog("theId = " .. tostring(theId) .. " ; flag = " .. tostring(flag) .. " ; x = " .. tostring(x) .. " ; y = " .. tostring(y));
        local parentNode = node:getParent();
        local sz = node:getContentSize();
         if animFile ~= "chongwu17" and animFile ~= "bingzhang" then
            local effect = parentNode:getChildByTag(1);     -- 粒子
            if(effect ~= nil) then
                effect:setPosition(ccp(x,y));
            end
        end
        -- local effect = parentNode:getChildByTag(1);     -- 粒子
        -- if(effect ~= nil) then
        --     effect:setPosition(ccp(x,y));
        -- end
        local quality = parentNode:getChildByTag(2);    -- 背后火焰
        if(quality ~= nil)then
            quality:setPosition(ccp(x,y));
        end
        local equip = parentNode:getChildByTag(3);
        if(equip~=nil)then
            equip:setPosition(ccp(x,y+sz.height/2));
        end
        local crystal = parentNode:getChildByTag(4);
        if(crystal~=nil)then
            crystal:setPosition(ccp(x,y));
        end
        local stepAnim = parentNode:getChildByTag(5);
        if(stepAnim~=nil)then
            stepAnim:setPosition(ccp(x,y));
        end
    end

    m_iAnim:registerComponent(componentFunc);
    m_iAnim:setComponentId(animFile .. ".swf1.png");    -- 绑定影子
    --m_iAnim:playSection(anim_label_name_cfg.daiji);
    game_anim:playSection(m_iAnim,anim_label_name_cfg.daiji);
    --m_iAnim:setScale(1);

    if(cardData==nil)then
        return m_iAnim;
    end

    -- 添加特效

    local sz = m_iAnim:getContentSize();

    -- 添加进阶特效
    local stepAnim = nil;
    cardData.step = cardData.step or 0
    if(cardData.step>=20)then
        stepAnim = zcAnimNode:create("color_circle3.swf.sam",1,"color_circle3.plist");
        stepAnim:setColor(ccc3(248,0,0));
    elseif(cardData.step>=15)then
        stepAnim = zcAnimNode:create("color_circle3.swf.sam",1,"color_circle3.plist");
        stepAnim:setColor(ccc3(239,137,0));
    elseif(cardData.step>=10)then
        stepAnim = zcAnimNode:create("color_circle3.swf.sam",1,"color_circle3.plist");
        stepAnim:setColor(ccc3(233,104,213));
    end

    cclog("--------- step " .. tostring(cardData.step));
    if cardData.is_world and cardData.is_world == true then--转世
        --加入其它特效
        local incarnationAnim = zcAnimNode:create("anim_zhuanshi.swf.sam",1,"anim_zhuanshi.plist");
        incarnationAnim:registerScriptTapHandler(stepEnd);
        incarnationAnim:playSection("impact")
        incarnationAnim:setPosition(ccp(sz.width/2,0));
        m_iAnim:addChild(incarnationAnim,-2,100001);
    else
        if(stepAnim)then
            stepAnim:setPosition(ccp(sz.width/2,0));
            stepAnim:registerScriptTapHandler(stepEnd);
            stepAnim:playSection("impact");
            m_iAnim:addChild(stepAnim,-1,5);
        end
    end
    
    -- 添加品阶
    -- local cardQuality = cardCfg:getNodeWithKey("quality"):toInt()
    -- if(cardQuality >= 3)then
    --     local iEffect = luaCCBNode:create();
    --     iEffect:openCCBFile("ccb/effect_fire.ccbi");
    --     iEffect:setPosition(ccp(sz.width/2,0));
    --     m_iAnim:addChild(iEffect,-2,1);

    --     local iQuality = zcAnimNode:create("color_fire" .. tostring(cardQuality) .. ".swf.sam",1,"color_fire" .. tostring(cardQuality) .. ".plist");
    --     iQuality:setPosition(ccp(sz.width/2,0));
    --     iQuality:playSection("impact");
    --     iQuality:registerScriptTapHandler(qualityEnd);
    --     m_iAnim:addChild(iQuality,-1,2);
    -- end
    -- 添加套装特效
    -- if(equipData~=nil)then
    --     local equipQuality = 0;
    --     local equip_config = getConfig(game_config_field.equip);
    --     local equipCount = 0;
    --     for k,v in pairs(equipData) do
    --         if(v==0)then
    --             break;
    --         end
    --         if(k==1)then
    --             equipQuality = equip_config:getNodeWithKey(tostring(v['c_id'])):getNodeWithKey("quality"):toInt();
    --         else
    --             if(equipQuality~=equip_config:getNodeWithKey(tostring(v['c_id'])):getNodeWithKey("quality"):toInt())then
    --                 break;
    --             end
    --         end
    --         equipCount=equipCount+1;
    --     end
    --     if(equipCount>=4)then
    --         local iEquip = zcAnimNode:create("color_light" .. tostring(equipQuality) .. ".swf.sam",1,"color_light" .. tostring(equipQuality) .. ".plist");
    --         if iEquip then
    --             iEquip:setPosition(ccp(sz.width/2,sz.height/2));
    --             iEquip:playSection("impact");
    --             iEquip:registerScriptTapHandler(equipEnd);
    --             m_iAnim:addChild(iEquip,1,3);
    --         end
    --     end
    -- end
    -- 添加能晶特效
    -- local cardCrystal={0,0,0,0,0};
    -- if(cardData["patk_crystal"]~=nil)then
    --     cardCrystal[1]=cardData["patk_crystal"];
    -- end
    -- if(cardData["matk_crystal"]~=nil)then
    --     cardCrystal[2]=cardData["matk_crystal"];
    -- end
    -- if(cardData["def_crystal"]~=nil)then
    --     cardCrystal[3]=cardData["def_crystal"];
    -- end
    -- if(cardData["speed_crystal"]~=nil)then
    --     cardCrystal[4]=cardData["speed_crystal"];
    -- end
    -- if(cardData["hp_crystal"]~=nil)then
    --     cardCrystal[5]=cardData["hp_crystal"];
    -- end
    -- local CrystalFlag = cardCrystal[1];
    -- for k,v in pairs(cardCrystal) do
    --     if(v<CrystalFlag)then
    --         CrystalFlag=v;
    --     end
    -- end
    -- CrystalFlag = math.floor(CrystalFlag/4);
    -- if(CrystalFlag>=0)then
    --     local iCrystal = zcAnimNode:create("color_circle3.swf.sam",1,"color_circle3.plist");
    --     iCrystal:setPosition(ccp(sz.width/2,0));
    --     iCrystal:playSection("impact");
    --     iCrystal:registerScriptTapHandler(crystalEnd);
    --     m_iAnim:addChild(iCrystal,-3,4);
    -- end
    return m_iAnim;
end
--[[--
    创建暂停的卡牌动画
]]
function M.createPauseAnim(self,animFile,animId,cardData,cardCfg,zhuanshiTag)
    if zhuanshiTag == true then
        local m_iAnim = self:createIdelAnim(animFile,animId,cardData,cardCfg,_,_,zhuanshiTag);
        if m_iAnim == nil then return nil end
        m_iAnim:pause();
        return m_iAnim;
    else
        local m_iAnim = self:createIdelAnim(animFile,animId,cardData,cardCfg);
        if m_iAnim == nil then return nil end
        m_iAnim:pause();
        return m_iAnim;
    end
end
--[[--
    创建卡牌动画序列
]]
function M.createAnimSequence(self,animFile,animId,cardData,cardCfg)
    local m_iAnim = self:createIdelAnim(animFile,animId,cardData,cardCfg);
    local function animEnd(animNode,theId,lableName)
        if lableName == anim_label_name_cfg.daiji then
            --animNode:playSection(anim_label_name_cfg.gongji1);
            game_anim:playSection(m_iAnim,anim_label_name_cfg.gongji1);
        elseif lableName == anim_label_name_cfg.gongji1 then
            --animNode:playSection(anim_label_name_cfg.gongji2);
            game_anim:playSection(m_iAnim,anim_label_name_cfg.gongji2);
        elseif lableName == anim_label_name_cfg.gongji2 then
            --animNode:playSection(anim_label_name_cfg.daiji);
            game_anim:playSection(m_iAnim,anim_label_name_cfg.daiji);
        end
    end
    if m_iAnim then
        m_iAnim:registerScriptTapHandler(animEnd);
        --m_iAnim:playSection(anim_label_name_cfg.daiji);
        game_anim:playSection(m_iAnim,anim_label_name_cfg.daiji);
        m_iAnim:setScale(1);
    end
    return m_iAnim;
end


function M.setHeroListItemInfoByTableOnlyNeedId(self,cardId)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_hero_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    local cardId = cardId
    cclog("cardId ===" .. tostring(cardId))
    local itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(tostring(cardId));
    cclog2(itemConfig,"name_after itemConfig")  --todo
    if itemConfig then
        ccbNode:nodeForName("m_info_node"):setVisible(true);
    else
        ccbNode:nodeForName("m_info_node"):setVisible(false);
        return
    end
    local m_anim_node = tolua.cast(ccbNode:objectForName("m_anim_node"),"CCNode");
    m_anim_node:removeAllChildrenWithCleanup(true);
    local m_name_label = ccbNode:labelTTFForName("m_name_label2"); --todo
    if not m_name_label then
        m_name_label = ccbNode:labelTTFForName("m_name_label");
    end
    local quality = itemConfig:getNodeWithKey("quality"):toInt();
    local super_quality_1 =  0
    local hero_quality_item = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
    if hero_quality_item then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(hero_quality_item.card_img));
    end
    local name_after = itemConfig:getNodeWithKey("name"):toStr()
    cclog2(name_after,"name_after") --todo
    if m_name_label then
        m_name_label:setString(name_after);
        m_name_label:setVisible(true); --todo
    end
    cclog2(m_name_label,"m_name_label")
    -- local name_after = self:getCardName(heroDataTable,itemConfig)
    -- m_name_label:setString(name_after);
    local animation = itemConfig:getNodeWithKey("animation"):toStr();
    local rgb = itemConfig:getNodeWithKey("rgb_sort"):toInt();
    local animNode = self:createImgByName("image_" .. animation,rgb,nil,nil,wake_lv,itemConfig)
    if animNode then
        local animNodeSize = animNode:getContentSize();
        animNode:setAnchorPoint(ccp(0.5,0));
        m_anim_node:addChild(animNode);
    end
    local m_occupation_icon = ccbNode:spriteForName("m_occupation_icon")
    local occupation_cfg = getConfig(game_config_field.occupation);
    local occupation_item_cfg = occupation_cfg:getNodeWithKey(animation)
    if occupation_item_cfg then
        local occupationType = occupation_item_cfg:toInt();
        local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
        if spriteFrame then
            m_occupation_icon:setDisplayFrame(spriteFrame);
        else
            m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
        end
    else
        m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    end
    local m_occupation_icon_bg = ccbNode:spriteForName("m_occupation_icon_bg")
    local spriteFrame = super_quality_1 > 0 and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg_2.png") or CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg.png")
    if m_occupation_icon_bg and spriteFrame then
        m_occupation_icon_bg:setDisplayFrame(spriteFrame);
    end
    for i=1,5 do
        local m_star_icon = ccbNode:spriteForName("m_star_icon_" .. i)
        if tempSpriteFrame then
            m_star_icon:setDisplayFrame(tempSpriteFrame)
        end
        m_star_icon:setVisible(false);
    end
    return ccbNode
end
--[[--
    创建未知卡牌动画
]]
function M.createUnknowIdelAnim(self,animFile,nanimId)
    animFile = "unknow";
    local animId = nanimId;
    if(animId == nil)then
        animId = 0;
    end
    local m_iAnim = game_util:createSortNode(animFile .. ".swf.sam",animId,animFile .. ".plist");
    local function animEnd(animNode,theId,lableName)
        animNode:playSection(lableName);
    end
    m_iAnim:registerScriptTapHandler(animEnd);
    m_iAnim:playSection("impact");
    m_iAnim:setScale(1);
    return m_iAnim;
end

function M.createAnimSequence3(self,animFile,animId,cardData,cardCfg)
    local m_iAnim = self:createIdelAnim(animFile,animId,cardData,cardCfg);
    local function animEnd(animNode,theId,lableName)
        if lableName == anim_label_name_cfg.daiji then
            animNode:playSection(anim_label_name_cfg.daiji);
        end
    end
    if m_iAnim then
        m_iAnim:registerScriptTapHandler(animEnd);
        -- m_iAnim:playSection(anim_label_name_cfg.daiji);
        game_anim:playSection(m_iAnim,anim_label_name_cfg.daiji);
        m_iAnim:setScale(1);
    end
    return m_iAnim;
end

--[[--
    判断id是否在table中
]]
function M.idInTableById(self,id,idTable)
    idTable = idTable or {};
    for k,v in pairs(idTable) do
        if v ~= 0 and tostring(v) == tostring(id) then
            return true,k;
        end
    end
    return false,nil;
end
--[[--
    判断卡牌id是否在table中
]]
function M.heroInTeamById(self,heroId,teamIdTable)
    teamIdTable = teamIdTable or {}
    for k,v in pairs(teamIdTable) do
        if v ~= "-1" and tostring(v) == tostring(heroId) then
            return true;
        end
    end
    return false;
end
--[[--
    判断只是否在table中
]]
function M.valueInTeam(self,value,tableValue)
    tableValue = tableValue or {};
    for k,v in pairs(tableValue) do
        if tostring(v) == tostring(value) then
            return true;
        end
    end
    return false;
end
--[[--
    从table中移除指定的值
]]
function M.removeValueInTeam(self,value,tableValue)
    tableValue = tableValue or {};
    local kTemp = nil;
    for k,v in pairs(tableValue) do
        if tostring(v) == tostring(value) then
            kTemp = k;
            break;
        end
    end
    table.remove(tableValue,kTemp);
end
--[[--
    创建提示文字
]]
function M.createTips(self,msg)
    local bgW,bgH = 120,80;
    local bgLayer = CCLayerColor:create(ccc4(155,155,155,255),bgW,bgH);
    local msgLabel = CCLabelTTF:create(msg,TYPE_FACE_TABLE.Arial_BoldMT,10,CCSizeMake(bgW,bgH),kCCTextAlignmentLeft);
    msgLabel:setPosition(bgW*0.5,bgH*0.5);
    bgLayer:addChild(msgLabel);
    return bgLayer;
end

--[[--
    创建特定的卡牌动画序列
]]
function M.createAnimSequence2(self,animFile,animId,cardData,cardCfg,skillId)
    local m_iAnim = self:createIdelAnim(animFile,animId,cardData,cardCfg);
    local function animEnd(animNode,theId,lableName)
        -- if lableName == anim_label_name_cfg.daiji then
        --     -- animNode:playSection(anim_label_name_cfg.gongji1);
        --     game_anim:playSection(m_iAnim,anim_label_name_cfg.gongji1);
        -- elseif lableName == anim_label_name_cfg.gongji1 then
        --     -- animNode:playSection(anim_label_name_cfg.gongji2);
        --     game_anim:playSection(m_iAnim,anim_label_name_cfg.gongji2);
        -- elseif lableName == anim_label_name_cfg.gongji2 then
        --     -- animNode:playSection(anim_label_name_cfg.daiji);
        --     game_anim:playSection(m_iAnim,anim_label_name_cfg.daiji);
        -- end
        game_anim:playSection(m_iAnim,lableName);
    end
    if m_iAnim then
        m_iAnim:registerScriptTapHandler(animEnd);
        -- m_iAnim:playSection(anim_label_name_cfg.daiji);
        local skillName = "gongji" .. skillId
        if skillId == 1 then
            -- skillName = "daiji"
        end
        game_anim:playSection(m_iAnim,anim_label_name_cfg[tostring(skillName)]);
        m_iAnim:setScale(1);
    end
    return m_iAnim;
end
--[[--
    创建移动的提示文字
]]
function M.addMoveTips(self,t_params)
    t_params = t_params or {};
    t_params.text = t_params.text or ""
    -- t_params.color = t_params.new_color or ccc3(250,180,0)
    local colorType = t_params.colorType or "";
    if colorType == "" then
        t_params.color = ccc3(250,180,0)
    elseif colorType == "red" then
        t_params.color = ccc3(250,0,0)
    end
    if t_params.new_color then
        t_params.color = t_params.new_color
    end
    local winSize = CCDirector:sharedDirector():getWinSize();
    local tempBg = CCScale9Sprite:createWithSpriteFrameName("public_selectBg.png");
    tempBg:setPreferredSize(CCSizeMake(winSize.width*0.5, winSize.height*0.1));
    tempBg:setPosition(ccp(winSize.width*0.5, winSize.height*0.5))
    local msgLabel = CCLabelTTF:create(t_params.text,TYPE_FACE_TABLE.Arial_BoldMT,16);
    msgLabel:setColor(t_params.color)
    msgLabel:setPosition(winSize.width*0.25,winSize.height*0.05);
    tempBg:addChild(msgLabel);
    local function remove_node( node )
        -- body
        node:removeFromParentAndCleanup(true);
    end
    local remove = CCCallFuncN:create(remove_node);
    local arr = CCArray:create();
    arr:addObject(CCEaseIn:create(CCMoveTo:create(1,ccp(winSize.width*0.5,winSize.height*0.7)),5));
    arr:addObject(CCDelayTime:create(1));
    arr:addObject(remove);
    tempBg:runAction(CCSequence:create(arr));
    game_scene:getPopContainer():addChild(tempBg,100000);
end
--[[
    一连串的文字提示
]]
function M.addQueneMoveTips(self,t_params,delayTime)
    delayTime = delayTime or 0
    t_params = t_params or {};
    local winSize = CCDirector:sharedDirector():getWinSize();
    t_params.text = t_params.text or ""
    local colorType = t_params.colorType or "";
    if colorType == "" then
        t_params.color = ccc3(250,230,0)
    elseif colorType == "red" then
        t_params.color = ccc3(250,0,0)
    end
    local tempBg = CCScale9Sprite:createWithSpriteFrameName("public_numBg.png");
    local function createTips()
        tempBg:setPreferredSize(CCSizeMake(winSize.width*0.5, winSize.height*0.1));
        tempBg:setPosition(ccp(winSize.width*0.5, winSize.height*0.5))
        local msgLabel = CCLabelTTF:create(t_params.text,TYPE_FACE_TABLE.Arial_BoldMT,16);
        msgLabel:setColor(t_params.color)
        msgLabel:setPosition(winSize.width*0.25,winSize.height*0.05);
        tempBg:addChild(msgLabel);
    end
    local function remove_node( node )
        node:removeFromParentAndCleanup(true);
    end
    local remove = CCCallFuncN:create(remove_node);
    local arr = CCArray:create();
    arr:addObject(CCDelayTime:create(delayTime));
    arr:addObject(CCCallFuncN:create(createTips));
    arr:addObject(CCEaseIn:create(CCMoveTo:create(1,ccp(winSize.width*0.5,winSize.height*0.7)),5));
    arr:addObject(CCDelayTime:create(1));
    arr:addObject(remove);
    tempBg:runAction(CCSequence:create(arr));
    game_scene:getPopContainer():addChild(tempBg,100000);
end
--[[
    提示新命运开启
]]
function M.addQueneOpenTips(self,t_params,delayTime)
    delayTime = delayTime or 0
    t_params = t_params or {};
    local winSize = CCDirector:sharedDirector():getWinSize();
    t_params.text = t_params.text or ""
    local colorType = t_params.colorType or "";
    t_params.color = ccc3(247,202,35)
    local tempBg = CCScale9Sprite:createWithSpriteFrameName("public_selectBg.png");
    local function createTips()
        tempBg:setPreferredSize(CCSizeMake(winSize.width*0.5, winSize.height*0.1));
        tempBg:setPosition(ccp(winSize.width*0.5, winSize.height*0.5))
        local msgLabel = CCLabelTTF:create(t_params.text,TYPE_FACE_TABLE.Arial_BoldMT,16);
        msgLabel:setColor(t_params.color)
        msgLabel:setPosition(winSize.width*0.25,winSize.height*0.05);
        tempBg:addChild(msgLabel);
    end
    tempBg:setScaleY(0)
    local function remove_node( node )
        node:removeFromParentAndCleanup(true);
    end
    local remove = CCCallFuncN:create(remove_node);
    local arr = CCArray:create();
    arr:addObject(CCDelayTime:create(delayTime));
    arr:addObject(CCCallFuncN:create(createTips));
    -- arr:addObject(CCEaseIn:create(CCMoveTo:create(1,ccp(winSize.width*0.5,winSize.height*0.7)),5));
    arr:addObject(CCScaleTo:create(0.3,1,1.2));
    arr:addObject(CCScaleTo:create(0.1,1,1));
    arr:addObject(CCDelayTime:create(1));
    arr:addObject(CCScaleTo:create(0.3,1,0));
    arr:addObject(remove);
    tempBg:runAction(CCSequence:create(arr));
    game_scene:getPopContainer():addChild(tempBg,100000);
end
--[[--
    创建native可移动的文字
]]
function M.addMoveTipsForNative(self,params)
    local function callback()
        game_util:addMoveTips(params)
    end
    performWithDelay(CCDirector:sharedDirector():getRunningScene(),callback,0)
end
--[[--
    创建移动的提示
]]
function M.addMoveTipsByNode(self,node,delayTime,callBackFunc)
    if node == nil then return end
    delayTime = delayTime or 0;
    local winSize = CCDirector:sharedDirector():getWinSize();
    node:ignoreAnchorPointForPosition(false);
    node:setAnchorPoint(ccp(0.5,0.5));
    node:setPosition(winSize.width*0.5,winSize.height*0.5);
    local function remove_node( node )
        -- body
        node:removeFromParentAndCleanup(true);
        if callBackFunc then
            callBackFunc();
        end
    end
    node:setVisible(false);
    local arr = CCArray:create();
    arr:addObject(CCDelayTime:create(delayTime));
    arr:addObject(CCShow:create());
    arr:addObject(CCEaseIn:create(CCMoveTo:create(1,ccp(winSize.width*0.5,winSize.height*0.7)),5));
    -- arr:addObject(CCDelayTime:create(1.0));
    arr:addObject(CCScaleTo:create(1.0,0));
    arr:addObject(CCCallFuncN:create(remove_node));
    node:runAction(CCSequence:create(arr));
    game_scene:getPopContainer():addChild(node,delayTime + 100000);
end
--[[--
    添加提示动画
]]
function M.addTipsAnimByType(self,parentNode,typeValue)
    if parentNode == nil then return end
    local rhythm = rhythm or 1.0;
    local loopFlag = true;
    local animFile = "tips_reward";
    if typeValue == 2 then
        animFile = "tips_reward2";
    elseif typeValue == 3 then
        animFile = "tips_reward3";
    elseif typeValue == 4 then
        animFile = "tips_reward4";
        loopFlag = false;
    elseif typeValue == 5 then
        animFile = "anim_ui_dingshilingjiang";
    elseif typeValue == 6 then
        animFile = "anim_ui_gonggao";
    elseif typeValue == 7 then
        animFile = "anim_ui_huodong";
    elseif typeValue == 8 then
        animFile = "anim_ui_qiandao";
    elseif typeValue == 17 then
        animFile = "anim_ui_tongyong";
    -- elseif typeValue == 10 then
    --     animFile = "anim_ui_new";
    elseif typeValue == 9 or typeValue == 10 then
        local tips_reward = CCSprite:createWithSpriteFrameName("public_new2.png");
        if tips_reward then
            local tempSize = parentNode:getContentSize();
            tips_reward:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5))
            parentNode:addChild(tips_reward,1000,1000);
        end
        return tips_reward;
    elseif typeValue == 11 then
        animFile = "anim_ui_xuanshang";
    elseif typeValue == 12 then
        animFile = "anim_ui_renwu";
    elseif typeValue == 13 then
        animFile = "anim_ui_baoxianglingjiang";
    elseif typeValue == 103 then
       animFile = "tips_reward2";
    elseif typeValue == 14 then
        animFile = "anim_ui_gantanhao"
    elseif typeValue == 15 then
        animFile = "anim_ui_libaotixing"
    elseif typeValue == 16 then--热门活动
        animFile = "anim_ui_remenhuodong"
    elseif typeValue == 18 then
        animFile = "anim_ui_fuli"
    end

    local tips_reward = game_util:createTipsAnim(animFile,rhythm,loopFlag);

    if typeValue == 103 then 
        tips_reward:setScale(0.8)
    end
    
    if tips_reward then
        local tempSize = parentNode:getContentSize();
        tips_reward:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5))
        parentNode:addChild(tips_reward,1000,1000);
    end
    return tips_reward;
end
--[[--
    创建提示动画
]]
function M.createTipsAnim(self,animFile,rhythm,loopFlag)
    if loopFlag == nil then loopFlag = false end
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        if loopFlag then
            animNode:playSection(theLabelName)
        else
            animNode:getParent():removeFromParentAndCleanup(true);
        end
    end
    local mAnimNode = game_util:createSortNode(animFile .. ".swf.sam", 0, animFile.. ".plist");
    if mAnimNode then
        mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
        mAnimNode:playSection("impact");
        mAnimNode:setRhythm(rhythm);
    end
    return mAnimNode;
end

--[[--
    创建通用动画
    game_util:createUniversalAnim({animFile = "",rhythm = 1.0,loopFlag = true,animCallFunc = nil});
]]
function M.createUniversalAnim(self,params)
    params = params or {};
    local animFile = params.animFile or ""
    local rhythm = params.rhythm or 1.0
    local actionName = params.actionName or "impact";
    local loopFlag = params.loopFlag == nil and false or params.loopFlag;
    local onAnimSectionEnd = params.animCallFunc;
    if onAnimSectionEnd == nil then
        onAnimSectionEnd = function(animNode, theId,theLabelName)
            if loopFlag then
                animNode:playSection(theLabelName)
            else
                animNode:getParent():removeFromParentAndCleanup(true);
            end
        end
    end
    local mAnimNode = SortNode:create(animFile .. ".swf.sam", 0, animFile.. ".plist");
    if mAnimNode then
        mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
        mAnimNode:playSection(actionName);
        mAnimNode:setRhythm(rhythm);
    end
    return mAnimNode;
end
--[[--
    创建特效--公会站  延时
]]
function M.createEffectAnimGvg(self,animFile,rhythm,loopFlag,delayTime)
    delayTime = delayTime or 0
    if loopFlag == nil then loopFlag = false end
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        if loopFlag then
            animNode:playSection(theLabelName)
        else
            animNode:getParent():removeFromParentAndCleanup(true);
        end
    end
    local mAnimNode = game_util:createSortNode(animFile .. ".swf.sam", 0, animFile.. ".plist");
    if(mAnimNode == nil) then
        cclog("lack of "..animFile)
        mAnimNode = game_util:createSortNode("shouji_2.swf.sam",0,"shouji_2.plist");
    end
    mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
    if delayTime > 0 then
        local function delyFunc()
            mAnimNode:playSection("impact");
        end
        local animArr = CCArray:create()
        animArr:addObject(CCDelayTime:create(delayTime));
        animArr:addObject(CCCallFunc:create(delyFunc));
        mAnimNode:runAction(CCSequence:create(animArr));
    else
        mAnimNode:playSection("impact");
    end
    mAnimNode:setRhythm(rhythm);
    return mAnimNode;
end

--[[
    创建UI通用动画特效
    swfname         : 动画文件
    plistname       : 资源plist文件
    actionCallback  : anim动作回调
    anchorCallback  : 锚点回调
]]
function M.createAnimEffect(self, swfname, plistname, secEndCallback, anchorCallback,flag)
    -- body
    --cclog2(flag,"flag")
    if swfname == nil or plistname == nil then return nil end
    --动作回调
    local function __animSectionEnd( animNode, theId, theLabelName )
        -- body
        if flag then
            cclog2(secEndCallback,"secEndCallback")
        end
        if secEndCallback then
            secEndCallback(animNode, theId, theLabelName)
        end
    end
    -- 锚点回调
    local function __anchorLabel( node , theId , anchorMsg )
        -- body
        local anchor = json.decode(anchorMsg);
        if(anchor and anchor.type == "wav")then
            local effectFileFullPath = CCFileUtils:sharedFileUtils():fullPathForFilename("sound/attack_effect/" .. tostring(anchor.res)..".mp3");
            local existFlag = util.fileIsExist(effectFileFullPath)
            if existFlag == true then
                game_sound:playAttackSound(effectFileFullPath,false);
            end
        else
            if anchorCallback then
                anchorCallback(node , theId, anchor)
            end
        end
    end
    --cclog2( "createAnimEffect   _anim:create" )
        -- local aniNode = zcAnimNode:create(swfname .. ".swf.sam", 0, plistname .. ".plist")
    local aniNode 
    if flag then
        aniNode =  game_anim:create(swfname .. ".swf.sam", 0, plistname .. ".plist", true) 
    else
        aniNode = game_anim:create(swfname .. ".swf.sam", 0, plistname .. ".plist")
    end
    -- cclog2( anino )
    
    if aniNode then
        aniNode:registerScriptTapHandler(__animSectionEnd);
        aniNode:registerScriptAnchor(__anchorLabel)
    else
        cclog(" <<ERROR>> ----- anim effect failed ---- ")
    end
    return aniNode
end

--[[--
    创建特效
]]
function M.createEffectAnim(self,animFile,rhythm,loopFlag,gem)
    if loopFlag == nil then loopFlag = false end
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        if loopFlag then
            animNode:playSection(theLabelName)
        else
            animNode:getParent():removeFromParentAndCleanup(true);
        end
    end
    local mAnimNode = game_util:createSortNode(animFile .. ".swf.sam", 0, animFile.. ".plist");
    if(mAnimNode == nil) then
        cclog("lack of "..animFile)
        mAnimNode = game_util:createSortNode("shouji_2.swf.sam",0,"shouji_2.plist");
    end
    mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
   --mAnimNode:playSection("impact");
    -- game_anim:playSection(mAnimNode , "impact");
    if gem == "gem" then
        game_anim:playSection(mAnimNode , "taozhuangjihuo");
    elseif gem == "snow" then --新加切换主题背景，播放的动画特殊的锚记------zjr
        game_anim:playSection(mAnimNode , "xuetexiao_1");

    else
        game_anim:playSection(mAnimNode , "impact");
    end

    mAnimNode:setRhythm(rhythm);
    -- mAnimNode:setScale(0.5);
    return mAnimNode;
end

--[[--
    创建特效
]]
function M.createEffectAnimCallBack(self,animFile,rhythm,loopFlag,callBackFunc)
    if loopFlag == nil then loopFlag = false end
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        if loopFlag then
            animNode:playSection(theLabelName)
        else
            animNode:getParent():removeFromParentAndCleanup(true);
        end
        if callBackFunc then
            callBackFunc();
        end
    end
    local mAnimNode = game_util:createSortNode(animFile .. ".swf.sam", 0, animFile.. ".plist");
    if mAnimNode then
        mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
        mAnimNode:playSection("impact");
        mAnimNode:setRhythm(rhythm);
    else
        if callBackFunc then
            callBackFunc();
        end
    end
    return mAnimNode;
end

--[[--
    创建分解特效
]]
function M.createSplitEffectAnim(self,animFile,rhythm,loopFlag,callFunc,node)
    if loopFlag == nil then loopFlag = false end
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        if loopFlag then
            animNode:playSection(theLabelName)
        else
            if node ~= nil then
                node:setVisible(false)
                callFunc(node);
            else
                callFunc();
            end
            animNode:getParent():removeFromParentAndCleanup(true);
        end
    end
    local mAnimNode = game_util:createSortNode(animFile .. ".swf.sam", 0, animFile.. ".plist");
    if(mAnimNode == nil) then
        cclog("lack of "..animFile)
        mAnimNode = game_util:createSortNode("shouji_2.swf.sam",0,"shouji_2.plist");
    end
    mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
    mAnimNode:playSection("impact");
    mAnimNode:setRhythm(rhythm);
    return mAnimNode;
end
--[[--
    创建特效并添加到节点上
]]
function M.createEffectAnimAddToParent(self,parentNode,animFile,rhythm)
    local mAnimNode = self:createEffectAnim(animFile,rhythm)
    if(mAnimNode == nil) then
        cclog("createEffectAnimAddToParent->"..animFile)
        mAnimNode = self:createEffectAnim("shouji_2",rhythm)
    end
    local size = parentNode:getContentSize();
    mAnimNode:setPosition(ccp(size.width*0.5,size.height*0.5));
    parentNode:addChild(mAnimNode,1000,1000);
end
--[[--
    创建资源特效
]]
function M.createResourcesEffectAnim(self,animFile,rhythm,onAnimEnd)
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        if theLabelName == "daiji" then
            animNode:playSection(theLabelName);
        else
            animNode:getParent():removeFromParentAndCleanup(true);
            if onAnimEnd ~= nil then
                onAnimEnd(animFile);
            end
        end
    end
    local mAnimNode = game_util:createSortNode(animFile .. ".swf.sam", 0, animFile.. ".plist");
    mAnimNode:setAnchorPoint(ccp(0.5,0.5));
    mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
    mAnimNode:playSection("daiji");
    mAnimNode:setRhythm(rhythm);
    -- mAnimNode:setScale(0.5);
    return mAnimNode
end
--[[--
    创建建筑上移动的人物动画
]]
function M.createBuildingPersonAnim(self,animFile,rhythm)
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        animNode:playSection(theLabelName);
    end
    local mAnimNode = zcAnimNode:create(animFile .. ".swf.sam", 0, animFile.. ".plist");
    mAnimNode:setAnchorPoint(ccp(0.5,0.5));
    mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
    -- mAnimNode:playSection("daiji");
    mAnimNode:playSection("xiazuo");
    mAnimNode:setRhythm(rhythm);
    -- mAnimNode:setScale(0.5);
    return mAnimNode
end
--[[--
    创建玩家角色的动画
]]
function M.createPlayerMapAnim(self,animFile,rhythm)
    return self:createPlayerRoleAnim(animFile,rhythm);
end


--[[--
    xiazuo xiayou shangzuo shangyou xiazuoD xiayouD shangzuoD shangyouD
    建筑上动画的移动
]]
function M.createBuildingPersonAnimMove(self,mAnimNode,pos,callBackFunc)
    if mAnimNode == nil then 
        if callBackFunc and type(callBackFunc) == "function" then
            callBackFunc();
        end
        return;
    end
    mAnimNode:stopAllActions();
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        animNode:playSection(theLabelName);
    end
    mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
    local pX,pY = mAnimNode:getPosition();
    local offsetX,offsetY = pos.x - pX,pos.y - pY;
    if offsetX > 0 then
        if offsetY > 0 then--右上
            mAnimNode:playSection("shangyou");
        elseif offsetY < 0 then--右下
            mAnimNode:playSection("xiayou");
        else
            mAnimNode:playSection("xiayouD");
        end
    else
        if offsetY > 0 then--左上
            mAnimNode:playSection("shangzuo");
        elseif offsetY < 0 then--左下
            mAnimNode:playSection("xiazuo");
        else
            mAnimNode:playSection("xiazuo");
        end
    end
    local function animEndCallFunc()
        local curSectionName = mAnimNode:getCurSectionName()
        if curSectionName == "shangyou" then
             mAnimNode:playSection("shangyouD");
        elseif curSectionName == "xiayou" then
             mAnimNode:playSection("xiayouD");
        elseif curSectionName == "shangzuo" then
             mAnimNode:playSection("shangzuoD");
        elseif curSectionName == "xiazuo" then
             mAnimNode:playSection("xiazuoD");
        end

        if callBackFunc and type(callBackFunc) == "function" then
            callBackFunc();
        end
    end
    local pix = math.sqrt(math.pow(pos.x - pX, 2) + math.pow(pos.y - pY, 2));
    local moveTime = pix / 200;
    local animArr = CCArray:create();
    animArr:addObject(CCMoveTo:create(moveTime,pos));
    animArr:addObject(CCCallFunc:create(animEndCallFunc));
    mAnimNode:runAction(CCSequence:create(animArr));
end
--[[--
    xiazuo xiayou shangzuo shangyou xiazuoD xiayouD shangzuoD shangyouD
    建筑上动画的移动   有名字的
]]
function M.createBuildingPersonWithNameAnimMove(self,mAnimNode,callBackFunc,nameLabel,posList)
    if mAnimNode == nil then 
        if callBackFunc and type(callBackFunc) == "function" then
            callBackFunc();
        end
        return;
    end
    mAnimNode:stopAllActions();
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        animNode:playSection(theLabelName);
    end
    mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
    
    local function animEndCallFunc()
        local curSectionName = mAnimNode:getCurSectionName()
        if curSectionName == "shangyou" then
             mAnimNode:playSection("shangyouD");
        elseif curSectionName == "xiayou" then
             mAnimNode:playSection("xiayouD");
        elseif curSectionName == "shangzuo" then
             mAnimNode:playSection("shangzuoD");
        elseif curSectionName == "xiazuo" then
             mAnimNode:playSection("xiazuoD");
        end
        if callBackFunc and type(callBackFunc) == "function" then
            callBackFunc();
        end
    end
    
    local animArr = CCArray:create();
    local moveLabelArr = CCArray:create();
    for i=1,#posList do
        local pos = posList[i];
        local pX,pY = 0,0;
        if i == 1 then
            pX,pY = mAnimNode:getPosition();
        else
            pX,pY = posList[i-1].x,posList[i-1].y;
        end
        local offsetX,offsetY = pos.x - pX,pos.y - pY;
        if offsetX > 0 then
            if offsetY > 0 then--右上
                mAnimNode:playSection("shangyou");
            elseif offsetY < 0 then--右下
                mAnimNode:playSection("xiayou");
            else
                mAnimNode:playSection("xiayouD");
            end
        else
            if offsetY > 0 then--左上
                mAnimNode:playSection("shangzuo");
            elseif offsetY < 0 then--左下
                mAnimNode:playSection("xiazuo");
            else
                mAnimNode:playSection("xiazuo");
            end
        end
        local pix = math.sqrt(math.pow(pos.x - pX, 2) + math.pow(pos.y - pY, 2));
        local moveTime = pix / 200;
        animArr:addObject(CCMoveTo:create(moveTime,pos));
        moveLabelArr:addObject(CCMoveTo:create(moveTime,ccp(pos.x,pos.y+60)))
    end
    animArr:addObject(CCCallFunc:create(animEndCallFunc));
    mAnimNode:runAction(CCSequence:create(animArr));
    nameLabel:runAction(CCSequence:create(moveLabelArr));
end
--[[--
    创建buff效果动画
]]
function M.createBuffAnim(self,parentNode,animFile,rhythm)
    local mAnimNode = self:createImpactAnim(animFile,rhythm)
    local size = parentNode:getContentSize();
    mAnimNode:setPosition(ccp(size.width,size.height));
    parentNode:addChild(mAnimNode,1000,1000);
    return mAnimNode;
end
--[[--
    创建特效动画
]]
function M.createImpactAnim(self,animFile,rhythm)
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        animNode:playSection(theLabelName);
    end
    local mAnimNode = game_util:createSortNode(animFile .. ".swf.sam", 0, animFile.. ".plist");
    if(mAnimNode == nil) then
        cclog("lack of "..animFile)
        mAnimNode = game_util:createSortNode("shouji_2.swf.sam",0,"shouji_2.plist");
    end
    if mAnimNode then
        mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
        mAnimNode:playSection("impact");
        mAnimNode:setRhythm(rhythm);
        -- mAnimNode:setScale(0.5);
    end
    return mAnimNode;
end
--[[--
    格式化数字
]]
function M.formatValueToString(self,value,combFlag)
    combFlag = combFlag == nil and true or combFlag;
    local tempValue = "0";
    local unit = "";
    if type(value) == "string" then
        value = tonumber(value);
    end
    if value == nil or type(value) ~= "number" then
        return tempValue,unit;
    end
    if value > 0 and value < 10000 then
        tempValue = tostring(value)
    elseif value >= 10000 and value < 100000000 then
        if value < 10000000 then
            tempValue,unit = string.format("%.1f",value * 0.0001),"Vạn"
        else
            tempValue,unit = string.format("%.0f",value * 0.0001),"Vạn"
        end
    elseif value >= 100000000 then
        tempValue,unit = string.format("%.2f",value * 0.00000001),"Trăm triệu"
    end
    if combFlag then
        tempValue = tempValue .. unit
        unit = "";
    end
    return tempValue,unit;
end

--[[--
    设置玩家单个属性
]]
function M.setPlayerProperty(self,m_label,m_value)
    if m_label ~= nil and m_value ~= nil then
        local value,unit = self:formatValueToString(m_value);
        if m_value >= 10000 then
            m_label:setString(value .. unit);
        else
            m_label:setString(value);
        end
    end
end

--[[--
    设置玩家属性栏信息
]]
function M.setPlayerPropertyByCCBAndTableData(self,ccbNode,user_status)
    if ccbNode == nil or user_status == nil or user_status.uid == nil then
        return;
    end
    local m_lightning_label = ccbNode:labelBMFontForName("m_lightning_label")
    if m_lightning_label ~= nil then
        m_lightning_label:setString(user_status.action_point .. "/" .. user_status.action_point_max);
    end
    local m_gem_label = ccbNode:labelBMFontForName("m_gem_label")
    local m_money_label = ccbNode:labelBMFontForName("m_money_label")
    -- local m_material_label = ccbNode:labelBMFontForName("m_material_label")
    -- local m_energy_label = ccbNode:labelBMFontForName("m_energy_label")
    self:setPlayerProperty(m_gem_label,user_status.coin);
    self:setPlayerProperty(m_money_label,user_status.food);
    -- self:setPlayerProperty(m_material_label,user_status.metal);
    -- self:setPlayerProperty(m_energy_label,user_status.energy);
    local m_head_icon_node = tolua.cast(ccbNode:objectForName("m_head_icon_node"), "CCNode");
    local sb_list = {}
    
    local m_player_name = tolua.cast(ccbNode:objectForName("m_player_name"), "CCLabelTTF");
    local m_exp_bar_bg = tolua.cast(ccbNode:objectForName("m_exp_bar_bg"), "CCSprite");
    local m_exp_label = ccbNode:labelBMFontForName("m_exp_label")


    local m_vip_node = ccbNode:nodeForName("m_vip_node")
    if game_data:isViewOpenByID(101) then
        if user_status.vip > 0 then
            m_vip_node:setVisible(true)
            local m_vip_label = ccbNode:labelTTFForName("m_vip_label")
            m_vip_label:setString("VIP" .. tostring(user_status.vip))
        else
            m_vip_node:setVisible(false)
        end
    else
        m_vip_node:setVisible(false)
    end

    if m_head_icon_node and m_head_icon_node:getChildrenCount() == 0 then
        m_head_icon_node:removeAllChildrenWithCleanup(true);
        local role_detail_cfg = getConfig(game_config_field.role_detail);
        if user_status.role and role_detail_cfg then
            local itemCfg = role_detail_cfg:getNodeWithKey(tostring(user_status.role));
            local tempSpr = game_util:createPlayerIconByCfg(itemCfg)--game_util:createIconByName(itemCfg:getNodeWithKey("icon"):toStr());
            if tempSpr then
                tempSpr:setScale(0.75);
                tempSpr:setPosition(ccp(31, 29));
                m_head_icon_node:addChild(tempSpr);
            end
        end
    end
    if m_player_name then
        m_player_name:setString(tostring(user_status.show_name))
        for i=1,4 do
            sb_list[i] = tolua.cast(ccbNode:objectForName("m_player_name_" .. i), "CCLabelTTF");
            sb_list[i]:setString(tostring(user_status.show_name))
        end
    end
    if m_exp_bar_bg ~= nil then
        local exp_max = user_status.exp_max;
        local exp = user_status.exp;
        m_exp_label:setString(exp .. "/" .. exp_max);
        local bar = m_exp_bar_bg:getChildByTag(10)
        if bar then
            bar = tolua.cast(bar,"CCProgressTimer");
        else
            local bar_bg_size = m_exp_bar_bg:getContentSize();
            bar = game_util:createProgressTimer({fileName = "public_jingyan.png",percentage = 0})
            bar:setPosition(ccp(bar_bg_size.width*0.5,bar_bg_size.height*0.5));
            m_exp_bar_bg:addChild(bar,10,10);
        end
        if exp_max ~= 0 then
            bar:setPercentage(100*exp/exp_max);
        end
        -- bar:setPercentage(100);
    end
    local m_lightning_bar_bg = tolua.cast(ccbNode:objectForName("m_lightning_bar_bg"), "CCSprite");
    if m_lightning_bar_bg then
        local bar = m_lightning_bar_bg:getChildByTag(10)
        if bar then
            bar = tolua.cast(bar,"CCProgressTimer");
        else
            local bar_bg_size = m_lightning_bar_bg:getContentSize();
            bar = game_util:createProgressTimer({fileName = "public_tili.png",percentage = 0})
            bar:setPosition(ccp(bar_bg_size.width*0.5,bar_bg_size.height*0.5));
            m_lightning_bar_bg:addChild(bar,10,10);
        end
        if user_status.action_point_max ~= 0 then
            bar:setPercentage(100*user_status.action_point/user_status.action_point_max);
        end
        -- bar:setPercentage(100);
    end
    local m_lv_label = tolua.cast(ccbNode:objectForName("m_lv_label"), "CCLabelTTF");
    if m_lv_label ~= nil then
        m_lv_label:setString(tostring(user_status.level));
    end
    local count_down_label = ccbNode:nodeForName("count_down_label")
    local timeOverLabel = count_down_label:getChildByTag(10)
    if user_status.action_point < user_status.action_point_max then
        local function timeOverFunc(label,type)
            user_status = game_data:getUserStatusData();
            if user_status.action_point == nil then return end
            -- cclog("userStatusData = " .. json.encode(user_status or {}))
            user_status.action_point = user_status.action_point + 1;
            -- cclog("user_status.action_point============ " .. user_status.action_point)
            m_lightning_label:setString((user_status.action_point) .. "/" .. user_status.action_point_max)
            local bar = m_lightning_bar_bg:getChildByTag(10)
            if bar then
                bar = tolua.cast(bar,"CCProgressTimer");
                if user_status.action_point_max ~= 0 then
                    bar:setPercentage(100*user_status.action_point/user_status.action_point_max);
                end
            end
            if user_status.action_point < user_status.action_point_max then
                label:setTime(user_status.action_point_rate);
            else
                label:setTime(0);
            end
        end
        if timeOverLabel then
            timeOverLabel = tolua.cast(timeOverLabel,"ExtCountdownLabel");
            timeOverLabel:setTime(user_status.action_point_update_left)
        else
            timeOverLabel = self:createCountdownLabel(user_status.action_point_update_left,timeOverFunc,8,2)
            timeOverLabel:setAnchorPoint(ccp(0.5,0.5))
            count_down_label:addChild(timeOverLabel,10,10)
        end
    else
        count_down_label:removeAllChildrenWithCleanup(true)
    end
end


--[[--
    设置玩家属性栏信息
]]
function M.setPlayerPropertyByCCBAndTableData2(self,ccbNode,user_status)

    print(" ------ setPlayerPropertyByCCBAndTableData2 ---- ")

    user_status = user_status or game_data:getUserStatusData();
    if ccbNode == nil or user_status == nil or user_status.uid == nil then
        return;
    end
    local m_lightning_label = ccbNode:labelBMFontForName("m_lightning_label")
    if m_lightning_label ~= nil then
        m_lightning_label:setString(user_status.action_point .. "/" .. user_status.action_point_max);
    end
    local m_exp_bar_bg = tolua.cast(ccbNode:objectForName("m_exp_bar_bg"), "CCSprite");
    local m_exp_label = ccbNode:labelBMFontForName("m_exp_label")
    if m_exp_bar_bg ~= nil then
        local exp_max = user_status.exp_max;
        local exp = user_status.exp;
        m_exp_label:setString(exp .. "/" .. exp_max);
        local bar = m_exp_bar_bg:getChildByTag(10)
        if bar then
            bar = tolua.cast(bar,"CCProgressTimer");
        else
            local bar_bg_size = m_exp_bar_bg:getContentSize();
            bar = game_util:createProgressTimer({fileName = "public_jingyan.png",percentage = 0})
            bar:setPosition(ccp(bar_bg_size.width*0.5,bar_bg_size.height*0.5));
            m_exp_bar_bg:addChild(bar,10,10);
        end
        if exp_max ~= 0 then
            bar:setPercentage(100*exp/exp_max);
        end
        -- bar:setPercentage(100);
    end
    local m_lightning_bar_bg = tolua.cast(ccbNode:objectForName("m_lightning_bar_bg"), "CCSprite");
    if m_lightning_bar_bg then
        local bar = m_lightning_bar_bg:getChildByTag(10)
        if bar then
            bar = tolua.cast(bar,"CCProgressTimer");
        else
            local bar_bg_size = m_lightning_bar_bg:getContentSize();
            bar = game_util:createProgressTimer({fileName = "public_tili.png",percentage = 0})
            bar:setPosition(ccp(bar_bg_size.width*0.5,bar_bg_size.height*0.5));
            m_lightning_bar_bg:addChild(bar,10,10);
        end
        if user_status.action_point_max ~= 0 then
            bar:setPercentage(100*user_status.action_point/user_status.action_point_max);
        end
        -- bar:setPercentage(100);
    end
end

--[[--寵物]]
function M.createPetListItemByCCB(self,heroData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_hero_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and heroData ~= nil then
        self:setPetListItemInfoByTable(ccbNode,heroData);
    end
    return ccbNode
end

function M.setPetListItemInfoByTable(self,ccbNode,petDataTable)
    local cardId = petDataTable.c_id;
    -- cclog("cardId ===" .. tostring(cardId))
    local itemConfig = getConfig(game_config_field.pet_detail):getNodeWithKey(cardId);
    if itemConfig then
        ccbNode:nodeForName("m_info_node"):setVisible(true);
    else
        ccbNode:nodeForName("m_info_node"):setVisible(false);
        return
    end
    -- local wake_lv = petDataTable.bre
    tolua.cast(ccbNode:objectForName("m_level_label"),"CCLabelBMFont"):setString("Lv." .. petDataTable.lv .. "/" .. petDataTable.level_max);
    local m_anim_node = tolua.cast(ccbNode:objectForName("m_anim_node"),"CCNode");
    m_anim_node:removeAllChildrenWithCleanup(true);
    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    -- local m_name_label = ccbNode:labelTTFForName("m_name_label");
    -- self:setHeroNameColorByQuality(m_name_label,itemConfig);
    local quality = itemConfig:getNodeWithKey("quality"):toInt();
    local hero_quality_item = HERO_QUALITY_COLOR_TABLE[quality+1]
    if hero_quality_item then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(hero_quality_item.card_img));
    end
    local name_after = itemConfig:getNodeWithKey("name"):toStr()
    m_name_label:setString(name_after);
    cclog("name_after ====" .. name_after)
    local animation = itemConfig:getNodeWithKey("animation"):toStr();
    local rgb = itemConfig:getNodeWithKey("rgb_sort"):toInt();

    local animNode = self:createImgByName("image_" .. animation,rgb,nil,nil,0,itemConfig)
    if animNode then
        local animNodeSize = animNode:getContentSize();
        animNode:setAnchorPoint(ccp(0.5,0));
        m_anim_node:addChild(animNode);
    end
    local m_sel_img = ccbNode:spriteForName("m_sel_img")
    m_sel_img:setVisible(false)
    local m_team_img = ccbNode:spriteForName("m_team_img")
    if game_data:petInTeamById(petDataTable.id) then
        m_team_img:setVisible(true);
        m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_played.png"));
    else
        -- if game_data:heroInAssistantById(petDataTable.id) then
        --     m_team_img:setVisible(true);
        --     m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_zhuzhanzhong.png"));
        -- else
        --     m_team_img:setVisible(false);
        -- end
        m_team_img:setVisible(false);
    end
    -- local lockFlag = game_util:getCardUserLockFlag(petDataTable);
    ccbNode:spriteForName("m_lock_img"):setVisible(false);
    local m_perfect_img = ccbNode:spriteForName("m_perfect_img")
    m_perfect_img:setVisible(false);
    -- local tempSpriteFrame = nil;
    --這裡是星星
    local star = petDataTable.star
    for i=1,5 do
        local m_star_icon = ccbNode:spriteForName("m_star_icon_" .. i)
        if tempSpriteFrame then
            m_star_icon:setDisplayFrame(tempSpriteFrame)
        end
        if i <= star then
            m_star_icon:setVisible(true);
        else
            m_star_icon:setVisible(false);
        end
    end
end

function M.setPetListItemInfoByTable2(self,ccbNode,petDataTable)
    local cardId = petDataTable.c_id;
    -- cclog("cardId ===" .. tostring(cardId))
    local m_level_label = ccbNode:labelBMFontForName("m_level_label");
    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    -- local m_name_label = ccbNode:labelTTFForName("m_name_label");
    local sprite_chuzhan = ccbNode:spriteForName("sprite_chuzhan");
    local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
    local sprite_selected = ccbNode:spriteForName("sprite_selected");
    local sprite_perfect = ccbNode:spriteForName("sprite_perfect");
    local sprite_lock = ccbNode:spriteForName("sprite_lock");
    
    sprite_back_alpha:setVisible(false);
    sprite_selected:setVisible(false);

    local itemConfig = getConfig(game_config_field.pet_detail):getNodeWithKey(cardId);
    m_level_label:setString(petDataTable.lv .. "/" .. petDataTable.level_max);
    local head_node = ccbNode:nodeForName("head_node");
    head_node:removeAllChildrenWithCleanup(true);
    local tempIcon = game_util:createCardIconByCfg(itemConfig,petDataTable)
    if tempIcon then
        tempIcon:setScale(0.75);
        head_node:addChild(tempIcon)
    end
    --加跟随
    local pet_follow_pos = game_data:getPetFollowPos()
    local isFollow,k = game_util:idInTableById(petDataTable.id,pet_follow_pos)
    if isFollow then
        local followSprite = CCSprite:createWithSpriteFrameName("ui_pet_follow.png")
        followSprite:setPosition(ccp(110,7))
        head_node:addChild(followSprite)
    end
    local name_after = itemConfig:getNodeWithKey("name"):toStr()
    m_name_label:setString(name_after);
    --是否在陣型中
    if game_data:petInTeamById(petDataTable.id) then
        sprite_chuzhan:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_chuzhan.png"));
        sprite_chuzhan:setVisible(true);
    else
        sprite_chuzhan:setVisible(false);
    end
    sprite_lock:setVisible(false);
    sprite_perfect:setVisible(false);
end

--寵物
function M.getPetRewardId(self,tempId,count)
    local icon,name,quality = nil,nil,0;
    local pet_detail_cfg = getConfig(game_config_field.pet_detail);
    local itemCfg = pet_detail_cfg:getNodeWithKey(tostring(tempId));
    if itemCfg then
        -- cclog("getCardRewardId tempId ============== " .. tostring(tempId) .. " ; count ===========" .. tostring(count));
        name = itemCfg:getNodeWithKey("name"):toStr()-- .. (count ~= nil and "×" .. count or "");
        icon = self:createCardIconByCfg(itemCfg);
        quality = itemCfg:getNodeWithKey("quality"):toInt();
    end
    return icon,name,count,quality;
end

--[[--
    格式化技能描述
]]
function M.formatSkillStory(self,skillCfgItem,skillLevel)
    if skillCfgItem == nil then return "Không có" end
    local story = skillCfgItem:getNodeWithKey("story"):toStr();
    print("story ==============================" .. story);
    local base_effect1 = skillCfgItem:getNodeWithKey("base_effect1"):toInt();
    local base_effect2 = skillCfgItem:getNodeWithKey("base_effect2"):toInt();
    local add_effect1 = skillCfgItem:getNodeWithKey("add_effect1"):toInt();
    local add_effect2 = skillCfgItem:getNodeWithKey("add_effect2"):toInt();
    if skillLevel == nil or type(skillLevel) ~= "number" then
        skillLevel = 1;
    end
    local replace1 = ""
    local replace2 = ""
    local value1 = 0;
    local value2 = 0;
    if base_effect1 >= 10000 then--不加％
        value1 = base_effect1 - 10000 + add_effect1*skillLevel;
        replace1 = tostring(value1);
    else
        value1 = base_effect1 + add_effect1*skillLevel;
        if value1 > 0 then
            replace1 = tostring(value1) .. "%";
        end
    end
    if base_effect2 >= 10000 then--不加％
        value2 = base_effect2 - 10000 + add_effect2*skillLevel
        replace2 = tostring(value2);
    else
        value2 = base_effect2 + add_effect2*skillLevel;
        if value2 > 0 then
            replace2 = tostring(value2) .. "%";
        end
    end
    return string.format(story,replace1,replace2);
end
--[[--
    创建英雄技能解锁
]]
function M.heroSkillUnlockCCB(self,skillId)
    if skillId == nil then return nil end
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/anim_hero_skill_unlock.ccbi");
    return ccbNode;
end
--[[--
    玩家升级动画
]]
function M.playerLevelUpCCBAnim(self,backCallFunc)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/anim_player_level_up.ccbi");
    local m_root_layer = tolua.cast(ccbNode:objectForName("m_root_layer"), "CCLayer");

    local function playAnimEnd(animName)
        ccbNode:removeFromParentAndCleanup(true);
        if backCallFunc ~= nil then backCallFunc(); end
    end
    ccbNode:registerAnimFunc(playAnimEnd);
    ccbNode:runAnimations("player_level_up");
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            ccbNode:removeFromParentAndCleanup(true);
            if backCallFunc ~= nil then backCallFunc(); end
            return true;--intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-10,true);
    m_root_layer:setTouchEnabled(true);
    return ccbNode;
end

--[[--
    通用的成功动画
]]
function M.animSuccessCCBAnim(self,backCallFunc,typeName)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_feedback_text_res.plist");
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/anim_word.ccbi");
    local m_root_layer = tolua.cast(ccbNode:objectForName("m_root_layer"), "CCLayer");
    local m_spr = tolua.cast(ccbNode:objectForName("m_spr"), "CCSprite");

    if typeName == "strengthen_success" then
        m_spr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fkxg_qianghuachenggong.png"));
    elseif typeName == "evolution_success" then
        m_spr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fkxg_jinhua.png"));
    elseif typeName == "synthesis_success" then
        m_spr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fkxg_hechengchenggong.png"));
    elseif typeName == "equip_production" then
        m_spr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fkxg_newEffect.png"));
    elseif typeName == "lv_up" then
        m_spr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fkxg_shengjichenggong.png"));
    end

    local function playAnimEnd(animName)
        ccbNode:removeFromParentAndCleanup(true);
        if backCallFunc ~= nil then backCallFunc(); end
    end
    ccbNode:registerAnimFunc(playAnimEnd);
    ccbNode:runAnimations("play_anim");
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            ccbNode:removeFromParentAndCleanup(true);
            if backCallFunc ~= nil then backCallFunc(); end
            return true;--intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-10,true);
    m_root_layer:setTouchEnabled(true);
    return ccbNode;
end
--[[--

]]
function M.setHeroBgByQuality(self,heroBg,quality)
    -- if heroBg == nil then return end;
    -- if quality < 1 or quality > 7 then
    --     quality = 1;
    -- end
    -- local typeName = tolua.type(heroBg);
    -- if typeName == "CCSprite" then
    --     heroBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(HERO_QUALITY_BG_IMG[quality]));
    -- elseif typeName == "CCControlButton" then
    --     heroBg:setBackgroundSpriteForState(CCScale9Sprite:createWithSpriteFrameName(HERO_QUALITY_BG_IMG[quality]),CCControlStateNormal);
    --     heroBg:setBackgroundSpriteForState(CCScale9Sprite:createWithSpriteFrameName(HERO_QUALITY_BG_IMG[quality]),CCControlStateHighlighted);
    -- end
end
--[[--
    设置英雄的颜色
]]
function M.setHeroNameColorByQuality(self,label,heroCfg)
    if label == nil then return end
    local quality = 1;
    if heroCfg then
        quality = heroCfg:getNodeWithKey("quality"):toInt()+1
    end
    self:setLabelColorByQuality(label,quality)
end

function M.setLabelColorByQuality(self,label,quality)
    -- if label == nil then return end
    -- if quality < 1 or quality > 7 then
    --     quality = 1;
    -- end
    -- label:setColor(HERO_QUALITY_COLOR_TABLE[quality].color);
end

function M.createHeroListItemByCCB(self,heroData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_hero_list_item.ccbi");
    ccbNode:nodeForName("nd_storeHouseAdd"):setVisible(false)
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and heroData ~= nil then
        self:setHeroListItemInfoByTable(ccbNode,heroData);
    end
    return ccbNode
end

function M.createHeroListItemByCCB3(self,heroData)
    local ccbNode = luaCCBNode:create();
    -- ccbNode:registerFunctionWithFuncName("onMainBtnClick",callFunc);
    ccbNode:openCCBFile("ccb/ui_hero_list_item2.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and heroData ~= nil then
        self:setHeroListItemInfoByTable3(ccbNode,heroData);
    end
    return ccbNode
end

function M.setHeroListItemInfoByTable3(self,ccbNode,heroDataTable)
    local cardId = heroDataTable.c_id;
    -- cclog("cardId ===" .. tostring(cardId))
    local itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(cardId);
    if itemConfig then
        ccbNode:nodeForName("m_info_node"):setVisible(true);
    else
        ccbNode:nodeForName("m_info_node"):setVisible(false);
        return
    end
    if itemConfig:getNodeWithKey("is_skin") then
        if itemConfig:getNodeWithKey("is_skin"):toInt() ~= 0 then
            local skinID = itemConfig:getNodeWithKey("is_skin"):toInt()
            local flag = game_util:isWearSkin(skinID)
            if flag then
                local character_detail_cfg = getConfig(game_config_field.character_detail);
                itemConfig = character_detail_cfg:getNodeWithKey(tostring(skinID));
            end
        end
    end
    local wake_lv = heroDataTable.bre
    -- tolua.cast(ccbNode:objectForName("m_level_label"),"CCLabelBMFont"):setString("Lv." .. heroDataTable.lv .. "/" .. heroDataTable.level_max);
    tolua.cast(ccbNode:objectForName("m_level_label"),"CCLabelBMFont"):setVisible(false)
    local m_anim_node = tolua.cast(ccbNode:objectForName("m_anim_node"),"CCNode");
    m_anim_node:removeAllChildrenWithCleanup(true);
    -- local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local m_name_label = ccbNode:labelTTFForName("m_name_label");
    -- self:setHeroNameColorByQuality(m_name_label,itemConfig);
    local quality = itemConfig:getNodeWithKey("quality"):toInt();
    local super_quality_1 = heroDataTable.super_quality_1 or 0
    local hero_quality_item = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
    if hero_quality_item then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(hero_quality_item.card_img));
    end
    local name_after = self:getCardName(heroDataTable,itemConfig)
    m_name_label:setString(name_after);
    local animation = itemConfig:getNodeWithKey("animation"):toStr();
    local rgb = itemConfig:getNodeWithKey("rgb_sort"):toInt();

    local animNode = self:createImgByName("image_" .. animation,rgb,nil,nil,wake_lv,itemConfig)
    -- local animNode = game_util:createPauseAnim(animation,0,heroDataTable,itemConfig);
    -- cclog("setHeroListItemInfoByTable animNode == " .. tostring(animNode))
    -- if animNode then
    --     local animNodeSize = animNode:getContentSize();
    --     -- local ccbNodeSize = ccbNode:getContentSize();
    --     -- local scale = math.min(1,animNodeSize.height~=0 and 70/animNodeSize.height or 1);
    --     -- animNode:setScale(scale);
    --     animNode:setAnchorPoint(ccp(0.5,0));
    --     m_anim_node:addChild(animNode);
    --     -- m_anim_node:getParent():reorderChild(m_anim_node,-1);
    -- end
     if animNode then
        local animNodeSize = animNode:getContentSize();
        -- local ccbNodeSize = ccbNode:getContentSize();
        -- local scale = math.min(1,animNodeSize.height~=0 and 70/animNodeSize.height or 1);
        -- animNode:setScale(scale);
        animNode:setAnchorPoint(ccp(0.5,0));
        m_anim_node:addChild(animNode);

        -- m_anim_node:getParent():reorderChild(m_anim_node,-1);
        local m_occupation_icon = ccbNode:spriteForName("m_occupation_icon")
        local m_occupation_icon2 = ccbNode:spriteForName("m_occupation_icon2")
        m_occupation_icon2:setVisible(true)
        local occupation_cfg = getConfig(game_config_field.occupation);

        local occupation_item_cfg = occupation_cfg:getNodeWithKey(animation)
        -- local occcc = occupation_cfg:getNodeWithKey(animation) and occupation_cfg:getNodeWithKey(animation):toStr()
        -- local occcc2 = occupation_cfg:getNodeWithKey(animation) and occupation_cfg:getNodeWithKey(animation):toInt() or nil
        -- cclog2(cardId,"cardId-=---------")

        local occupation_item_cfg2 = itemConfig:getNodeWithKey("occupation_shade"):toInt() 
        -- cclog2(itemConfig,"itemConfig-=-------")
        -- cclog2(occupation_item_cfg2,"occupation_item_cfg2-=123-------")
        -- if cardId == 38200 then
        --     cclog2(occcc)
        --     cclog2(occcc2,"    ----- - - - -- ")
        --     -- cclog("      238194719463279649265   ")
        --     occupation_item_cfg = occupation_cfg:getNodeWithKey("gelimuqiao")

        -- end
        -- if cardId == 38200 then
        --     -- cclog2(occupation_cfg,"     ------------ -   - -- - -  -    zyz  ")
        --     -- cclog2(animation .. "animation-=--------")
        --     -- cclog2(itemConfig,"itemConfig-=--------")
            
        --     -- cclog2(occupation_item_cfg,"occupation_item_cfg-=---------")
        --     local occccccc = json.decode(occupation_item_cfg:getFormatBuffer())
        --     -- cclog2(occccccc,"occupation_item_cfg-=---------")

        --     if not occccccc then
        --         cclog2(heroDataTable.id,"    ----------  11111112222     ")
        --     end
        -- end
        if occupation_item_cfg then
            local occupationType = occupation_item_cfg:toInt();

            if occupationType >=0 and occupationType <4 then 
                -- if cardId == 38200 then 
                --     cclog()
                -- cclog2(heroDataTable.id,"    ----------  11111112222     ")

                -- end
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    m_occupation_icon:setDisplayFrame(spriteFrame);
                else
                    m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
                end
                m_occupation_icon2:setVisible(false)
            else
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    m_occupation_icon:setDisplayFrame(spriteFrame);
                else
                    m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
                end
                -- local occupationType2 = occupation_item_cfg2:toInt();
                

                local spriteFrame2 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupation_item_cfg2 .. ".png")
                if spriteFrame2 then
                    if m_occupation_icon2  then
                        if cardId == 38200 then 
                            -- cclog2(occupation_item_cfg2,"occupation_item_cfg2-=-456-------")
                        -- cclog2(occupationType2,"occupationType2-=--------")
                        end
                        m_occupation_icon2:setDisplayFrame(spriteFrame2);
                    end
                else
                    m_occupation_icon2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
                end
                if occupation_item_cfg2 == -1 then 
                    m_occupation_icon2:setVisible(false)
                end
            end
        else
            m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
        end
        local m_occupation_icon_bg = ccbNode:spriteForName("m_occupation_icon_bg")
        local spriteFrame = super_quality_1 > 0 and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg_2.png") or CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg.png")
        if m_occupation_icon_bg and spriteFrame then
            m_occupation_icon_bg:setDisplayFrame(spriteFrame);
        end
    end
    local m_famous_icon = ccbNode:spriteForName("m_famous_icon")
    local flag = game_data:isInFamousById(heroDataTable.id)
    if m_famous_icon then
        m_famous_icon:setVisible(flag)
    end
    local m_bonusAdd_img = ccbNode:spriteForName("m_bonusAdd_img")
    local m_bonus_img = ccbNode:spriteForName("m_bonus_img")
    local isinBonus = game_util:isInFormationBonus2(heroDataTable.id)
    if isinBonus == "zhenfa" then
        m_bonus_img:setVisible(true)
        m_bonusAdd_img:setVisible(false)
    elseif isinBonus == "zhenfaAdd" then
        m_bonus_img:setVisible(false)
        m_bonusAdd_img:setVisible(true)
    else
        m_bonus_img:setVisible(false)
        m_bonusAdd_img:setVisible(false)
    end
    local m_sel_img = ccbNode:spriteForName("m_sel_img")
    m_sel_img:setVisible(false)
    local m_team_img = ccbNode:spriteForName("m_team_img")
    if game_data:heroInTeamById(heroDataTable.id) then
        m_team_img:setVisible(true);
        m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_played.png"));
    else
        if game_data:heroInAssistantById(heroDataTable.id) then
            m_team_img:setVisible(true);
            m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_zhuzhanzhong.png"));
        else
            m_team_img:setVisible(false);
        end
    end
    -- local m_god_img = ccbNode:spriteForName("m_god_img")
    -- if game_data:godheroInTeamById(heroDataTable.id) and heroDataTable.id ~= "0" then
    --     m_god_img:setVisible(true);
    -- else
    --     -- m_god_img:setVisible(true);
    --     m_god_img:setVisible(false);
    -- end
    local lockFlag = game_util:getCardUserLockFlag(heroDataTable);
    ccbNode:spriteForName("m_lock_img"):setVisible(lockFlag);
    local m_perfect_img = ccbNode:spriteForName("m_perfect_img")
    m_perfect_img:setVisible(false);
    local bre = math.min(heroDataTable.bre or 0,10)
    local tempSpriteFrame = nil;
    if bre > 5 then
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_moon_icon.png")
        bre = bre - 5
    else
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_equip_star.png")
    end
    for i=1,5 do
        local m_star_icon = ccbNode:spriteForName("m_star_icon_" .. i)
        if tempSpriteFrame then
            m_star_icon:setDisplayFrame(tempSpriteFrame)
        end
        if i <= bre then
            m_star_icon:setVisible(true);
        else
            m_star_icon:setVisible(false);
        end
    end

    -- local m_occupation_icon = ccbNode:spriteForName("m_occupation_icon")
    -- local m_occupation_icon2 = ccbNode:spriteForName("m_occupation_icon2")
    -- local occupation_cfg = getConfig(game_config_field.occupation);
    -- local occupation_item_cfg = occupation_cfg:getNodeWithKey(animation)
    -- local occupation_item_cfg2 = itemConfig:getNodeWithKey("occupation_shade")
    -- if occupation_item_cfg then
    --     local occupationType = occupation_item_cfg:toInt();
    --     if occupationType >=0 and occupationType <4 then 
    --         local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
    --         if spriteFrame then
    --             m_occupation_icon:setDisplayFrame(spriteFrame);
    --         else
    --             m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    --         end
    --         m_occupation_icon2:setVisible(false)
    --     else
    --         local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
    --         if spriteFrame then
    --             m_occupation_icon:setDisplayFrame(spriteFrame);
    --         else
    --             m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    --         end
    --         local occupationType2 = occupation_item_cfg2:toInt();
    --         local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType2 .. ".png")
    --         if spriteFrame then
    --             m_occupation_icon2:setDisplayFrame(spriteFrame);
    --         else
    --             m_occupation_icon2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    --         end
    --         if occupationType2 == -1 then 
    --             m_occupation_icon2:setVisible(false)
    --         end
    --     end
    -- else
    --     m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    -- end
    -- local m_occupation_icon_bg = ccbNode:spriteForName("m_occupation_icon_bg")
    -- local spriteFrame = super_quality_1 > 0 and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg_2.png") or CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg.png")
    -- if m_occupation_icon_bg and spriteFrame then
    --     m_occupation_icon_bg:setDisplayFrame(spriteFrame);
    -- end
end

function M.setHeroListItemInfoByTable3(self,ccbNode,heroDataTable)
    local cardId = heroDataTable.c_id;
    -- cclog("cardId ===" .. tostring(cardId))
    local itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(cardId);
    if itemConfig then
        ccbNode:nodeForName("m_info_node"):setVisible(true);
    else
        ccbNode:nodeForName("m_info_node"):setVisible(false);
        return
    end
    if itemConfig:getNodeWithKey("is_skin") then
        if itemConfig:getNodeWithKey("is_skin"):toInt() ~= 0 then
            local skinID = itemConfig:getNodeWithKey("is_skin"):toInt()
            local flag = game_util:isWearSkin(skinID)
            if flag then
                local character_detail_cfg = getConfig(game_config_field.character_detail);
                itemConfig = character_detail_cfg:getNodeWithKey(tostring(skinID));
            end
        end
    end
    local wake_lv = heroDataTable.bre
    -- tolua.cast(ccbNode:objectForName("m_level_label"),"CCLabelBMFont"):setString("Lv." .. heroDataTable.lv .. "/" .. heroDataTable.level_max);
    tolua.cast(ccbNode:objectForName("m_level_label"),"CCLabelBMFont"):setVisible(false)
    local m_anim_node = tolua.cast(ccbNode:objectForName("m_anim_node"),"CCNode");
    m_anim_node:removeAllChildrenWithCleanup(true);
    -- local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local m_name_label = ccbNode:labelTTFForName("m_name_label");
    -- self:setHeroNameColorByQuality(m_name_label,itemConfig);
    local quality = itemConfig:getNodeWithKey("quality"):toInt();
    local super_quality_1 = heroDataTable.super_quality_1 or 0
    local hero_quality_item = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
    if hero_quality_item then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(hero_quality_item.card_img));
    end
    local name_after = self:getCardName(heroDataTable,itemConfig)
    m_name_label:setString(name_after);
    local animation = itemConfig:getNodeWithKey("animation"):toStr();
    local rgb = itemConfig:getNodeWithKey("rgb_sort"):toInt();

    local animNode = self:createImgByName("image_" .. animation,rgb,nil,nil,wake_lv,itemConfig)
    -- local animNode = game_util:createPauseAnim(animation,0,heroDataTable,itemConfig);
    -- cclog("setHeroListItemInfoByTable animNode == " .. tostring(animNode))
    -- if animNode then
    --     local animNodeSize = animNode:getContentSize();
    --     -- local ccbNodeSize = ccbNode:getContentSize();
    --     -- local scale = math.min(1,animNodeSize.height~=0 and 70/animNodeSize.height or 1);
    --     -- animNode:setScale(scale);
    --     animNode:setAnchorPoint(ccp(0.5,0));
    --     m_anim_node:addChild(animNode);
    --     -- m_anim_node:getParent():reorderChild(m_anim_node,-1);
    -- end
     if animNode then
        local animNodeSize = animNode:getContentSize();
        -- local ccbNodeSize = ccbNode:getContentSize();
        -- local scale = math.min(1,animNodeSize.height~=0 and 70/animNodeSize.height or 1);
        -- animNode:setScale(scale);
        animNode:setAnchorPoint(ccp(0.5,0));
        m_anim_node:addChild(animNode);

        -- m_anim_node:getParent():reorderChild(m_anim_node,-1);
        local m_occupation_icon = ccbNode:spriteForName("m_occupation_icon")
        local m_occupation_icon2 = ccbNode:spriteForName("m_occupation_icon2")
        m_occupation_icon2:setVisible(true)
        local occupation_cfg = getConfig(game_config_field.occupation);

        local occupation_item_cfg = occupation_cfg:getNodeWithKey(animation)
        -- local occcc = occupation_cfg:getNodeWithKey(animation) and occupation_cfg:getNodeWithKey(animation):toStr()
        -- local occcc2 = occupation_cfg:getNodeWithKey(animation) and occupation_cfg:getNodeWithKey(animation):toInt() or nil
        -- cclog2(cardId,"cardId-=---------")

        local occupation_item_cfg2 = itemConfig:getNodeWithKey("occupation_shade"):toInt() 
        -- cclog2(itemConfig,"itemConfig-=-------")
        -- cclog2(occupation_item_cfg2,"occupation_item_cfg2-=123-------")
        -- if cardId == 38200 then
        --     cclog2(occcc)
        --     cclog2(occcc2,"    ----- - - - -- ")
        --     -- cclog("      238194719463279649265   ")
        --     occupation_item_cfg = occupation_cfg:getNodeWithKey("gelimuqiao")

        -- end
        -- if cardId == 38200 then
        --     -- cclog2(occupation_cfg,"     ------------ -   - -- - -  -    zyz  ")
        --     -- cclog2(animation .. "animation-=--------")
        --     -- cclog2(itemConfig,"itemConfig-=--------")
            
        --     -- cclog2(occupation_item_cfg,"occupation_item_cfg-=---------")
        --     local occccccc = json.decode(occupation_item_cfg:getFormatBuffer())
        --     -- cclog2(occccccc,"occupation_item_cfg-=---------")

        --     if not occccccc then
        --         cclog2(heroDataTable.id,"    ----------  11111112222     ")
        --     end
        -- end
        if occupation_item_cfg then
            local occupationType = occupation_item_cfg:toInt();

            if occupationType >=0 and occupationType <4 then 
                -- if cardId == 38200 then 
                --     cclog()
                -- cclog2(heroDataTable.id,"    ----------  11111112222     ")

                -- end
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    m_occupation_icon:setDisplayFrame(spriteFrame);
                else
                    m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
                end
                m_occupation_icon2:setVisible(false)
            else
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    m_occupation_icon:setDisplayFrame(spriteFrame);
                else
                    m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
                end
                -- local occupationType2 = occupation_item_cfg2:toInt();
                

                local spriteFrame2 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupation_item_cfg2 .. ".png")
                if spriteFrame2 then
                    if m_occupation_icon2  then
                        if cardId == 38200 then 
                            -- cclog2(occupation_item_cfg2,"occupation_item_cfg2-=-456-------")
                        -- cclog2(occupationType2,"occupationType2-=--------")
                        end
                        m_occupation_icon2:setDisplayFrame(spriteFrame2);
                    end
                else
                    m_occupation_icon2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
                end
                if occupation_item_cfg2 == -1 then 
                    m_occupation_icon2:setVisible(false)
                end
            end
        else
            m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
        end
        local m_occupation_icon_bg = ccbNode:spriteForName("m_occupation_icon_bg")
        local spriteFrame = super_quality_1 > 0 and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg_2.png") or CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg.png")
        if m_occupation_icon_bg and spriteFrame then
            m_occupation_icon_bg:setDisplayFrame(spriteFrame);
        end
    end
    local m_famous_icon = ccbNode:spriteForName("m_famous_icon")
    local flag = game_data:isInFamousById(heroDataTable.id)
    if m_famous_icon then
        m_famous_icon:setVisible(flag)
    end
    local m_bonusAdd_img = ccbNode:spriteForName("m_bonusAdd_img")
    local m_bonus_img = ccbNode:spriteForName("m_bonus_img")
    local isinBonus = game_util:isInFormationBonus2(heroDataTable.id)
    if isinBonus == "zhenfa" then
        m_bonus_img:setVisible(true)
        m_bonusAdd_img:setVisible(false)
    elseif isinBonus == "zhenfaAdd" then
        m_bonus_img:setVisible(false)
        m_bonusAdd_img:setVisible(true)
    else
        m_bonus_img:setVisible(false)
        m_bonusAdd_img:setVisible(false)
    end
    local m_sel_img = ccbNode:spriteForName("m_sel_img")
    m_sel_img:setVisible(false)
    local m_team_img = ccbNode:spriteForName("m_team_img")
    if game_data:heroInTeamById(heroDataTable.id) then
        m_team_img:setVisible(true);
        m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_played.png"));
    elseif game_data:heroInAssistantById(heroDataTable.id) then
        m_team_img:setVisible(true);
        m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_zhuzhanzhong.png"));
    else
        m_team_img:setVisible(false);
    end
    local m_god_img = ccbNode:spriteForName("m_god_img")
    -- if game_data:godheroInTeamById(heroDataTable.id) and heroDataTable.id ~= "0" then
    --     m_god_img:setVisible(true);
    -- else
    --     -- m_god_img:setVisible(true);
    --     m_god_img:setVisible(false);
    -- end
    local lockFlag = game_util:getCardUserLockFlag(heroDataTable);
    ccbNode:spriteForName("m_lock_img"):setVisible(lockFlag);
    local m_perfect_img = ccbNode:spriteForName("m_perfect_img")
    m_perfect_img:setVisible(false);
    local bre = math.min(heroDataTable.bre or 0,10)
    local tempSpriteFrame = nil;
    if bre > 5 then
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_moon_icon.png")
        bre = bre - 5
    else
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_equip_star.png")
    end
    for i=1,5 do
        local m_star_icon = ccbNode:spriteForName("m_star_icon_" .. i)
        if tempSpriteFrame then
            m_star_icon:setDisplayFrame(tempSpriteFrame)
        end
        if i <= bre then
            m_star_icon:setVisible(true);
        else
            m_star_icon:setVisible(false);
        end
    end

    -- local m_occupation_icon = ccbNode:spriteForName("m_occupation_icon")
    -- local m_occupation_icon2 = ccbNode:spriteForName("m_occupation_icon2")
    -- local occupation_cfg = getConfig(game_config_field.occupation);
    -- local occupation_item_cfg = occupation_cfg:getNodeWithKey(animation)
    -- local occupation_item_cfg2 = itemConfig:getNodeWithKey("occupation_shade")
    -- if occupation_item_cfg then
    --     local occupationType = occupation_item_cfg:toInt();
    --     if occupationType >=0 and occupationType <4 then 
    --         local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
    --         if spriteFrame then
    --             m_occupation_icon:setDisplayFrame(spriteFrame);
    --         else
    --             m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    --         end
    --         m_occupation_icon2:setVisible(false)
    --     else
    --         local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
    --         if spriteFrame then
    --             m_occupation_icon:setDisplayFrame(spriteFrame);
    --         else
    --             m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    --         end
    --         local occupationType2 = occupation_item_cfg2:toInt();
    --         local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType2 .. ".png")
    --         if spriteFrame then
    --             m_occupation_icon2:setDisplayFrame(spriteFrame);
    --         else
    --             m_occupation_icon2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    --         end
    --         if occupationType2 == -1 then 
    --             m_occupation_icon2:setVisible(false)
    --         end
    --     end
    -- else
    --     m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    -- end
    -- local m_occupation_icon_bg = ccbNode:spriteForName("m_occupation_icon_bg")
    -- local spriteFrame = super_quality_1 > 0 and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg_2.png") or CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg.png")
    -- if m_occupation_icon_bg and spriteFrame then
    --     m_occupation_icon_bg:setDisplayFrame(spriteFrame);
    -- end
end

function M.setHeroListItemInfoByTable(self,ccbNode,heroDataTable)
    local cardId = heroDataTable.c_id;
    -- cclog("cardId ===" .. tostring(cardId))
    local itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(cardId);
    if itemConfig then
        ccbNode:nodeForName("m_info_node"):setVisible(true);
    else
        ccbNode:nodeForName("m_info_node"):setVisible(false);
        return
    end
    if itemConfig:getNodeWithKey("is_skin") then
        if itemConfig:getNodeWithKey("is_skin"):toInt() ~= 0 then
            local skinID = itemConfig:getNodeWithKey("is_skin"):toInt()
            local flag = game_util:isWearSkin(skinID)
            if flag then
                local character_detail_cfg = getConfig(game_config_field.character_detail);
                itemConfig = character_detail_cfg:getNodeWithKey(tostring(skinID));
            end
        end
    end
    local wake_lv = heroDataTable.bre
    tolua.cast(ccbNode:objectForName("m_level_label"),"CCLabelBMFont"):setString("Lv." .. heroDataTable.lv .. "/" .. heroDataTable.level_max);
    local m_anim_node = tolua.cast(ccbNode:objectForName("m_anim_node"),"CCNode");
    m_anim_node:removeAllChildrenWithCleanup(true);
    -- local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    -- self:setHeroNameColorByQuality(m_name_label,itemConfig);
    local quality = itemConfig:getNodeWithKey("quality"):toInt();
    local super_quality_1 = heroDataTable.super_quality_1 or 0
    local hero_quality_item = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
    if hero_quality_item then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(hero_quality_item.card_img));
    end
    local name_after = self:getCardName(heroDataTable,itemConfig)
    m_name_label:setString(name_after);
    local animation = itemConfig:getNodeWithKey("animation"):toStr();
    local rgb = itemConfig:getNodeWithKey("rgb_sort"):toInt();

    local animNode = self:createImgByName("image_" .. animation,rgb,nil,nil,wake_lv,itemConfig)
    -- local animNode = game_util:createPauseAnim(animation,0,heroDataTable,itemConfig);
    -- cclog("setHeroListItemInfoByTable animNode == " .. tostring(animNode))
    if animNode then
        local animNodeSize = animNode:getContentSize();
        -- local ccbNodeSize = ccbNode:getContentSize();
        -- local scale = math.min(1,animNodeSize.height~=0 and 70/animNodeSize.height or 1);
        -- animNode:setScale(scale);
        animNode:setAnchorPoint(ccp(0.5,0));
        m_anim_node:addChild(animNode);
        -- m_anim_node:getParent():reorderChild(m_anim_node,-1);

        local m_occupation_icon = ccbNode:spriteForName("m_occupation_icon")
        local m_occupation_icon2 = ccbNode:spriteForName("m_occupation_icon2")
        m_occupation_icon2:setVisible(true)
        local occupation_cfg = getConfig(game_config_field.occupation);

        local occupation_item_cfg = occupation_cfg:getNodeWithKey(animation)
        local occupation_item_cfg2 = itemConfig:getNodeWithKey("occupation_shade"):toInt() 

        if occupation_item_cfg then
            local occupationType = occupation_item_cfg:toInt();

            if occupationType >=0 and occupationType <4 then 
                -- if cardId == 38200 then 
                --     cclog()
                -- cclog2(heroDataTable.id,"    ----------  11111112222     ")

                -- end
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    m_occupation_icon:setDisplayFrame(spriteFrame);
                else
                    m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
                end
                m_occupation_icon2:setVisible(false)
            else
                local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
                if spriteFrame then
                    m_occupation_icon:setDisplayFrame(spriteFrame);
                else
                    m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
                end
                -- local occupationType2 = occupation_item_cfg2:toInt();

                local spriteFrame2 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupation_item_cfg2 .. ".png")
                if spriteFrame2 then
                    if m_occupation_icon2  then
                        if cardId == 38200 then 
                        end
                        m_occupation_icon2:setDisplayFrame(spriteFrame2);
                    end
                else
                    m_occupation_icon2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
                end
                if occupation_item_cfg2 == -1 then 
                    m_occupation_icon2:setVisible(false)
                end
            end
        else
            m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
        end
        local m_occupation_icon_bg = ccbNode:spriteForName("m_occupation_icon_bg")
        local spriteFrame = super_quality_1 > 0 and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg_2.png") or CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg.png")
        if m_occupation_icon_bg and spriteFrame then
            m_occupation_icon_bg:setDisplayFrame(spriteFrame);
        end
    end
    local m_famous_icon = ccbNode:spriteForName("m_famous_icon")
    local flag = game_data:isInFamousById(heroDataTable.id)
    if m_famous_icon then
        m_famous_icon:setVisible(flag)
    end

    local m_bonusAdd_img = ccbNode:spriteForName("m_bonusAdd_img")
    local m_bonus_img = ccbNode:spriteForName("m_bonus_img")
    local isinBonus = game_util:isInFormationBonus2(heroDataTable.id)
    if isinBonus == "zhenfa" then
        m_bonus_img:setVisible(true)
        m_bonusAdd_img:setVisible(false)
    elseif isinBonus == "zhenfaAdd" then
        m_bonus_img:setVisible(false)
        m_bonusAdd_img:setVisible(true)
    else
        m_bonus_img:setVisible(false)
        m_bonusAdd_img:setVisible(false)
    end


    local m_sel_img = ccbNode:spriteForName("m_sel_img")
    m_sel_img:setVisible(false)
    local m_team_img = ccbNode:spriteForName("m_team_img")
    if game_data:heroInTeamById(heroDataTable.id) then
        m_team_img:setVisible(true);
        m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_played.png"));
    else
        if game_data:heroInAssistantById(heroDataTable.id) then
            m_team_img:setVisible(true);
            m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_zhuzhanzhong.png"));
        else
            m_team_img:setVisible(false);
        end
    end
    local m_god_img = ccbNode:spriteForName("m_god_img")
    if game_data:godheroInTeamById(heroDataTable.id) and heroDataTable.id ~= "0" then
        m_god_img:setVisible(true);
    else
        m_god_img:setVisible(false);
    end
    local lockFlag = game_util:getCardUserLockFlag(heroDataTable);
    ccbNode:spriteForName("m_lock_img"):setVisible(lockFlag);
    local m_perfect_img = ccbNode:spriteForName("m_perfect_img")
    m_perfect_img:setVisible(false);
    local bre = math.min(heroDataTable.bre or 0,10)
    local tempSpriteFrame = nil;
    if bre > 5 then
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_moon_icon.png")
        bre = bre - 5
    else
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_equip_star.png")
    end
    for i=1,5 do
        local m_star_icon = ccbNode:spriteForName("m_star_icon_" .. i)
        if tempSpriteFrame then
            m_star_icon:setDisplayFrame(tempSpriteFrame)
        end
        if i <= bre then
            m_star_icon:setVisible(true);
        else
            m_star_icon:setVisible(false);
        end
    end

    -- local m_occupation_icon = ccbNode:spriteForName("m_occupation_icon")
    -- local occupation_cfg = getConfig(game_config_field.occupation);
    -- local occupation_item_cfg = occupation_cfg:getNodeWithKey(animation)
    -- if occupation_item_cfg then
    --     local occupationType = occupation_item_cfg:toInt();
    --     local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
    --     if spriteFrame then
    --         m_occupation_icon:setDisplayFrame(spriteFrame);
    --     else
    --         m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    --     end
    -- else
    --     m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    -- end
    -- local m_occupation_icon_bg = ccbNode:spriteForName("m_occupation_icon_bg")
    -- local spriteFrame = super_quality_1 > 0 and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg_2.png") or CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg.png")
    -- if m_occupation_icon_bg and spriteFrame then
    --     m_occupation_icon_bg:setDisplayFrame(spriteFrame);
    -- end
end

function M.createHeroListItemByCCB2(self,heroData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_card_split_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and heroData ~= nil then
        self:setHeroListItemInfoByTable2(ccbNode,heroData);
    end
    return ccbNode
end

function M.setHeroListItemInfoByTable2(self,ccbNode,heroDataTable)
    local cardId = heroDataTable.c_id;
    -- cclog("cardId ===" .. tostring(cardId))
    local m_level_label = ccbNode:labelBMFontForName("m_level_label");
    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    -- local m_name_label = ccbNode:labelTTFForName("m_name_label");
    local sprite_chuzhan = ccbNode:spriteForName("sprite_chuzhan");
    local sprite_back_alpha = ccbNode:spriteForName("sprite_back_alpha");
    local sprite_selected = ccbNode:spriteForName("sprite_selected");
    local sprite_perfect = ccbNode:spriteForName("sprite_perfect");
    local sprite_lock = ccbNode:spriteForName("sprite_lock");
    
    sprite_back_alpha:setVisible(false);
    sprite_selected:setVisible(false);

    local itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(cardId);
    --幾張不能進階的卡最大等級是1
    if itemConfig:getNodeWithKey("is_skin") then
        if itemConfig:getNodeWithKey("is_skin"):toInt() ~= 0 then
            local skinID = itemConfig:getNodeWithKey("is_skin"):toInt()
            local flag = game_util:isWearSkin(skinID)
            if flag then
                local character_detail_cfg = getConfig(game_config_field.character_detail);
                itemConfig = character_detail_cfg:getNodeWithKey(tostring(skinID));
            end
        end
    end
    local is_evo = itemConfig:getNodeWithKey("is_evo")
    --最大等級取用戶等級
    local userMaxLevel = game_data:getUserStatusDataByKey("level")
    local maxLevel = userMaxLevel
    if is_evo and is_evo:toInt() == 0 then
        maxLevel = 1
    end
    -- m_level_label:setString(heroDataTable.lv .. "/" .. heroDataTable.level_max);
    -- m_level_label:setString(heroDataTable.lv .. "/" .. maxLevel);
    m_level_label:setString(heroDataTable.lv);
    local head_node = ccbNode:nodeForName("head_node");
    head_node:removeAllChildrenWithCleanup(true);
    local tempIcon = game_util:createCardIconByCfg(itemConfig,heroDataTable)
    if tempIcon then
        tempIcon:setScale(0.75);
        head_node:addChild(tempIcon)
    end
    --判断是否在神域，加神域标志
    local m_god_img = ccbNode:spriteForName("m_god_img2")
    if game_data:godheroInTeamById(heroDataTable.id) then
        m_god_img:setVisible(true);
        m_god_img:setScale(0.9);
    else
        m_god_img:setVisible(false);
    end
    local name_after = self:getCardName(heroDataTable,itemConfig)
    m_name_label:setString(name_after);
    --是否在阵型中
    if game_data:heroInTeamById(heroDataTable.id) then
        sprite_chuzhan:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_chuzhan.png"));
        sprite_chuzhan:setVisible(true);
    else
        if game_data:heroInAssistantById(heroDataTable.id) then--在助阵中
            sprite_chuzhan:setVisible(true);
            sprite_chuzhan:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_zhuzhanzhong.png"));
        else
            --是否在训练中
            local is_in_train = game_util:getCardTrainingFlag(heroDataTable)
            if is_in_train == true then
                sprite_chuzhan:setVisible(true)
                sprite_chuzhan:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_xunlian.png"));
            else
                sprite_chuzhan:setVisible(false);
            end
        end
    end
    --是否枷锁
    local lockFlag = game_util:getCardUserLockFlag(heroDataTable);
    sprite_lock:setVisible(lockFlag);
    sprite_perfect:setVisible(false);
    --判断是否完美
    -- local evolution_flag = heroDataTable.evolution_flag or 0
    -- local is_evolution = heroDataTable.is_evolution or 0;
    -- local quality = itemConfig:getNodeWithKey("quality"):toInt();
    -- if is_evolution == 1 and quality >= 3 and evolution_flag > 0 then--完美
    --     sprite_perfect:setVisible(true);
    -- end
end


--[[--
    获得卡牌的是否完美
]]
function M.getCardPerfectValue(self,heroDataTable)
    local perfectValue = 0;
    if heroDataTable == nil then return perfectValue end
    local cardId = heroDataTable.c_id;
    local itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(cardId);
    local quality = itemConfig:getNodeWithKey("quality"):toInt();
    local evolution_flag = heroDataTable.evolution_flag or 0
    local is_evolution = heroDataTable.is_evolution or 0;
    if is_evolution == 1 and quality >= 3 then
        perfectValue = evolution_flag;
    end
    return perfectValue;
end

--[[--
    
]]
function M.createListCardIconByData(self,heroDataTable)
    local cid = heroDataTable.c_id;
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroCfg = character_detail_cfg:getNodeWithKey(tostring(cid));
    local tempIcon = self:createCardIconByCfg(heroCfg,heroDataTable)
    if tempIcon then
        local m_team_img = CCSprite:createWithSpriteFrameName("public_chuzhan.png")
        m_team_img:setAnchorPoint(ccp(0.5, 0));
        m_team_img:setPositionX(tempIcon:getContentSize().width*0.5);
        tempIcon:addChild(m_team_img);
        local evolution_flag = heroDataTable.evolution_flag or 0
        local is_evolution = heroDataTable.is_evolution or 0;
        local quality = heroCfg:getNodeWithKey("quality"):toInt();
        if is_evolution == 1 and quality >= 3 and evolution_flag > 0 then
            local public_perfect = CCSprite:createWithSpriteFrameName("public_perfect.png")
            public_perfect:setAnchorPoint(ccp(1, 0));
            public_perfect:setPositionX(tempIcon:getContentSize().height);
            tempIcon:addChild(public_perfect);
        end
    end
    return tempIcon;
end

function M.createEquipItemByCCB(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_equip_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setEquipItemInfoByTable(ccbNode,itemData);
    end
    return ccbNode
end

function M.setEquipItemInfoByTable(self,ccbNode,itemData)
    if ccbNode == nil or itemData == nil then return end
    ccbNode:nodeForName("m_info_node"):setVisible(true);
    local equipCfg = getConfig(game_config_field.equip);
    local itemCfg = equipCfg:getNodeWithKey(itemData.c_id);
    local level = itemData.lv;
    local attrName1,value1,attrName2,value2,icon1,icon2 = self:getEquipAttributeValue(itemCfg,level,itemData);

    local m_ability1_label = ccbNode:labelBMFontForName("m_ability1_label")
    local recast_icon = ccbNode:spriteForName("recast_icon")
    if  itemData.is_equip_recast then
        recast_icon:setVisible(true)
    else
        recast_icon:setVisible(false)
    end

    local parentNode = m_ability1_label:getParent()
    local value1,unit1 = self:formatValueToString2(value1)
    local value2,unit2 = self:formatValueToString2(value2)
    ccbNode:labelBMFontForName("m_ability1_label"):setString(value1..unit1);
    ccbNode:labelBMFontForName("m_ability2_label"):setString(value2..unit2);

    ccbNode:spriteForName("m_ability1_icon"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1));
    ccbNode:spriteForName("m_ability2_icon"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon2));
    local sort = itemCfg:getNodeWithKey("sort"):toInt();
    -- ccbNode:labelBMFontForName("m_type_label"):setString(tostring(EQUIP_TYPE_NAME_TABLE["type_" ..tostring(sort)]));
    ccbNode:spriteForName("m_type_icon"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(PUBLIC_ABILITY_TABLE["ability_" .. sort].icon))
    local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
    if quality > 0 and quality < 10 then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(HERO_QUALITY_COLOR_TABLE[quality].card_img));
        --装备品质框
        local disPla = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(EQUIP_QUALITY_COLOR_TABLE[quality].img2)
        local m_kuang = ccbNode:spriteForName("m_kuang")
        if disPla and m_kuang then
            m_kuang:setDisplayFrame(disPla);
        end
    end
    -- local equip_strongthen = getConfig(game_config_field.equip_strongthen);
    -- local userLevel = game_data:getUserStatusDataByKey("level") or 1;
    -- ccbNode:labelTTFForName("m_level_label"):setString("Lv." .. level .. "/" .. math.min(equip_strongthen:getNodeCount(),userLevel));
    --装备名称加等级
    -- local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    -- local m_name_label = ccbNode:labelTTFForName("m_name_label");
    -- m_name_label:setString(itemCfg:getNodeWithKey("name"):toStr() .. "+" .. level);
    local m_name_label = ccbNode:labelTTFForName("m_name_label");
    local m_lv = ccbNode:labelTTFForName("m_lv");
    m_name_label:setString(itemCfg:getNodeWithKey("name"):toStr());
    m_lv:setString("Lv." .. level);
    -- game_util:setEquipNameColorByQuality(m_name_label,itemCfg);

    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    -- local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    local m_team_name = ccbNode:labelTTFForName("m_team_name")
    --所属英雄
    local existFlag,cardName = game_data:equipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),itemData.id)
    local isHeroEquipFlag = false
    isHeroEquipFlag = game_data:isEquipInHeroEquipTab(itemData.id)
    if existFlag and isHeroEquipFlag then
        m_team_img:setVisible(true);
        if isHeroEquipFlag then
            m_team_name:setString("已装备");
        else
            m_team_name:setString(cardName);
        end
    else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    end
    local m_god_img = ccbNode:spriteForName("m_god_img")
    local godexistFlag =  game_data:godequipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),itemData.id,ccbNode) --设置神域标志
    if godexistFlag  then
        m_god_img:setVisible(true);
        m_god_img:setColor(ccc3(255,255,255));
    else
        m_god_img:setVisible(true);
        m_god_img:setColor(ccc3(50,50,50));
        -- m_god_img:setVisible(false);
    end

    local m_bonus_img = ccbNode:spriteForName("m_bonus_img")
    local existFlag2,pos = game_data:equipInBonus(itemCfg:getNodeWithKey("sort"):toInt(),itemData.id)
    if existFlag2 then 
        m_bonus_img:setVisible(true)
    else
        m_bonus_img:setVisible(false)
    end
    
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createIconByName(itemCfg:getNodeWithKey("image"):toStr()) --self:createEquipIcon(itemCfg)
    icon:setScale(0.8)
    if icon then
        m_anim_node:addChild(icon)
    end
    --英雄星级
    local refining_node = ccbNode:nodeForName("refining_node")
    local refining_sp = ccbNode:spriteForName("refining_sp")
    local refining_level = ccbNode:labelBMFontForName("refining_level")
    local st_lv = itemData.st_lv
    -- if st_lv > 0 then
    --     refining_node:setVisible(true)
    --     refining_level:setString(tostring(st_lv))
    -- else
    --     refining_node:setVisible(false)
    -- end
    if st_lv > 0 then
        refining_node:setVisible(true)
        refining_sp:setColor(ccc3(255,255,255))
        refining_level:setString(tostring(st_lv))
    else
        -- refining_node:setVisible(false)
        refining_level:setString("")
        refining_sp:setColor(ccc3(50,50,50))
        refining_node:setVisible(true)
    end

    --装备锻造等级
    local forge_node = ccbNode:nodeForName("forge_node")
    local forge_sp = ccbNode:spriteForName("forge_sp")
    local forge_level = ccbNode:labelBMFontForName("forge_level")
    -- if st_lv > 0 then 
    --     forge_node:setPosition(ccp(55,116))
    -- else
    --     forge_node:setPosition(ccp(18,116))
    -- end

    -- if itemData.equip_forge_level then
    --     local forge_lv = itemData.equip_forge_level.lv
    --     if forge_lv > 0 then
    --         forge_node:setVisible(true)
    --         forge_level:setString(tostring(forge_lv))

    --     else
    --         forge_node:setVisible(false)
    --     end
    -- else
    --     forge_node:setVisible(false)
    -- end
    if itemData.equip_forge_level then
        local forge_lv = itemData.equip_forge_level.lv
        if forge_lv > 0 then
            forge_node:setVisible(true)
            forge_level:setString(tostring(forge_lv))
            forge_sp:setColor(ccc3(255,255,255))
        else
            forge_sp:setColor(ccc3(50,50,50))
            -- forge_node:setVisible(false)
            forge_node:setVisible(true)
            forge_level:setString("")
        end
    else
        -- forge_node:setVisible(false)
        forge_node:setVisible(true)
        forge_level:setString("")
        forge_sp:setColor(ccc3(50,50,50))

    end
     --m命运装备绑定
    -- local m_sprite_ming = ccbNode:spriteForName("m_sprite_ming")
    -- if itemData.bind_card and itemData.bind_card ~= "" then
    --     m_sprite_ming:setVisible(true)
    --     m_team_img:setVisible(true);
    --     local cardData,cardCfg = game_data:getCardDataById(itemData.bind_card)
    --     local name = cardCfg:getNodeWithKey("name"):toStr()
    --     m_team_name:setString(name);

    -- else
    --     m_sprite_ming:setVisible(false)

    -- end
    local m_sprite_ming = ccbNode:spriteForName("m_sprite_ming")
    if itemData.bind_card and itemData.bind_card ~= "" then
        m_sprite_ming:setVisible(true)
        m_sprite_ming:setColor(ccc3(255,255,255))
        m_team_img:setVisible(true);
        local cardData,cardCfg = game_data:getCardDataById(itemData.bind_card)
        local name = cardCfg:getNodeWithKey("name"):toStr()
        m_team_name:setString(name);

    else
        m_sprite_ming:setVisible(true)
        m_sprite_ming:setColor(ccc3(50,50,50))

        -- m_sprite_ming:setVisible(false)

    end

    local m_eq_building_node = ccbNode:nodeForName("m_eq_building_node")
    m_eq_building_node:setVisible(false)
    if itemData.is_building and m_eq_building_node then
        local m_building_ab_sp = ccbNode:spriteForName("m_building_ab_sp")
        local m_building_ab_lb = ccbNode:labelBMFontForName("m_building_ab_lb")
        local build_type = itemData.build_type
        if build_type and PUBLIC_ABILITY_NAME_TABLE[build_type] then
            m_eq_building_node:setVisible(true)
            local ablityTab = PUBLIC_ABILITY_NAME_TABLE[build_type]
            local build_value = itemData.build_atts[build_type]
            local value1,unit1 = self:formatValueToString2(build_value)
            m_building_ab_lb:setString(value1 .. unit1)
            local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(ablityTab.icon)
            if tempSpriteFrame then
                m_building_ab_sp:setDisplayFrame(tempSpriteFrame);
            end
        end
    end

    -- 英雄附魔信息
    ccbNode:spriteForName("m_icon_ability_1"):setVisible(false)
    ccbNode:spriteForName("m_icon_ability_2"):setVisible(false)
    ccbNode:labelBMFontForName("m_label_ability_1"):setVisible(false)
    ccbNode:labelBMFontForName("m_label_ability_2"):setVisible(false)
    local atts = itemData.atts
    local is_enchant = itemData.is_enchant
    if is_enchant then -- 已附魔
        ccbNode:spriteForName("m_ability2_icon"):getParent():setPosition(ccp(45,30))
        local tempSpr ={}
        -- local spriteTable = {self.m_property_sprite_add_1,self.m_property_sprite_add_2}
        local i = 0 -- 计数 表示sprite的编号 1 2 
        for k,v in pairs(atts) do
            tempSpr = PUBLIC_ABILITY_NAME_TABLE[k] or {}
            -- cclog2(tempSpr,"tempSpr")
            i = i + 1
            local m_icon_ability = ccbNode:spriteForName("m_icon_ability_"..i)
            local m_label_ability = ccbNode:labelBMFontForName("m_label_ability_"..i)
            local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tostring(tempSpr.icon))
            
            -- cclog2(tempSpriteFrame,"tempSpriteFrame")
            if tempSpriteFrame then
                m_icon_ability:setDisplayFrame(tempSpriteFrame)
                m_icon_ability:setVisible(true)
                local value,unit = self:formatValueToString2(v)
                m_label_ability:setString(value..unit)
                m_label_ability:setVisible(true)
            else

                m_icon_ability:setVisible(false)
                m_label_ability:setVisible(false)
            end
        end
    else
        -- 未附魔

        ccbNode:spriteForName("m_ability2_icon"):getParent():setPosition(ccp(45,23))
        ccbNode:spriteForName("m_icon_ability_1"):setVisible(false)
        ccbNode:spriteForName("m_icon_ability_2"):setVisible(false)
        ccbNode:labelBMFontForName("m_label_ability_1"):setVisible(false)
        ccbNode:labelBMFontForName("m_label_ability_2"):setVisible(false)
    end
    local anim_node =  ccbNode:nodeForName("anim_node")
    if anim_node:getChildren() then
        anim_node:removeAllChildrenWithCleanup(true)
    end
    if itemData.is_equip_recast and itemData.heroid then
        local equip_chain_table = getConfig(game_config_field.chain_equip) and json.decode(getConfig(game_config_field.chain_equip):getFormatBuffer()) or {}
        for i,v in ipairs(equip_chain_table[itemData.recast_bind..""].card_id) do
            if v..""  ==  itemData.heroid.."" then 
                local anim1 = game_util:createEffectAnim("jinkuang",1,true)
                anim_node:addChild(anim1,10,1)
                anim1:setScaleX(1.2)
                anim1:setPositionX(10)
                break
            end
        end
    end
end

function M.createEquipItemByCCB2(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_equip_list_item2.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setEquipItemInfoByTable2(ccbNode,itemData);
    end
    return ccbNode
end

function M.setEquipItemInfoByTable2(self,ccbNode,itemData)
    local equipCfg = getConfig(game_config_field.equip);
    local itemCfg = equipCfg:getNodeWithKey(tostring(itemData.c_id));
    if itemCfg == nil then return end
    local level = itemData.lv;
    local attrName1,value1,attrName2,value2,icon1,icon2 = self:getEquipAttributeValue(itemCfg,level,itemData);
    -- ccbNode:labelTTFForName("m_ability1_name_label"):setString(attrName1);
    -- ccbNode:labelTTFForName("m_ability2_name_label"):setString(attrName2);
    ccbNode:spriteForName("m_icon_ability_2"):setVisible(true)
    ccbNode:spriteForName("m_label_ability_2"):setVisible(true)
    local value1,unit1 = self:formatValueToString2(value1)
    local value2,unit2 = self:formatValueToString2(value2)
    ccbNode:labelBMFontForName("m_label_ability_2"):setString(value1..unit1);
    ccbNode:labelBMFontForName("m_label_ability_1"):setString(value2..unit2);
    ccbNode:spriteForName("m_icon_ability_2"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1));
    ccbNode:spriteForName("m_icon_ability_1"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon2));
    -- local equip_strongthen = getConfig(game_config_field.equip_strongthen);
    -- local userLevel = game_data:getUserStatusDataByKey("level") or 1;
    -- ccbNode:labelTTFForName("m_level_label"):setString(level .. "/" .. math.min(equip_strongthen:getNodeCount(),userLevel));
    -- local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local m_name_label = ccbNode:labelTTFForName("m_name_label");
    m_name_label:setString(itemCfg:getNodeWithKey("name"):toStr() .. "+" .. level);
    
    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    -- local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    local m_team_name = ccbNode:labelTTFForName("m_team_name")
    local existFlag,cardName = game_data:equipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),itemData.id)
    if existFlag then
        m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_yizhuangbei.png"));
        m_team_img:setVisible(true);
        -- m_team_name:setString(cardName);
        m_team_name:setString("");
    else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    end
    local m_god_img = ccbNode:spriteForName("m_god_img2")
    local godexistFlag =  game_data:godequipInEquipPos(itemCfg:getNodeWithKey("sort"):toInt(),itemData.id,ccbNode) --设置神域标志
    if godexistFlag then
        m_god_img:setVisible(true);
    else
        m_god_img:setVisible(false);
    end
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createEquipIcon(itemCfg)
    if icon then
        icon:setScale(0.75);
        m_anim_node:addChild(icon)
    end

    local refining_node = ccbNode:nodeForName("refining_node")
    local refining_level = ccbNode:labelBMFontForName("refining_level")
    local st_lv = itemData.st_lv
    if st_lv > 0 then
        refining_node:setVisible(true)
        refining_level:setString(tostring(st_lv))
    else
        refining_node:setVisible(false)
    end
    local m_max_evo_img = ccbNode:spriteForName("m_max_evo_img")
    local evolution = itemCfg:getNodeWithKey("evolution"):toInt();
    if evolution == 0 then
        m_max_evo_img:setVisible(true);
    else
        m_max_evo_img:setVisible(false);
    end

    local m_node_old = ccbNode:nodeForName("m_node_old")
    -- 英雄附魔信息
    local atts = itemData.atts
    local is_enchant = itemData.is_enchant
    if is_enchant then -- 已附魔
        m_node_old:stopAllActions();
        local function newFunc(node)

            ccbNode:spriteForName("m_icon_ability_1"):setVisible(true)
            ccbNode:spriteForName("m_label_ability_1"):setVisible(true)
            ccbNode:spriteForName("m_icon_ability_2"):setVisible(true)
            ccbNode:spriteForName("m_label_ability_2"):setVisible(true)
            ccbNode:labelBMFontForName("m_label_ability_2"):setString(value1..unit1);
            ccbNode:labelBMFontForName("m_label_ability_1"):setString(value2..unit2);
            ccbNode:spriteForName("m_icon_ability_2"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1));
            ccbNode:spriteForName("m_icon_ability_1"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon2));
        end
        local function oldFunc(node)
            ccbNode:spriteForName("m_icon_ability_1"):setVisible(false)
            ccbNode:spriteForName("m_label_ability_1"):setVisible(false)
            ccbNode:spriteForName("m_icon_ability_2"):setVisible(false)
            ccbNode:spriteForName("m_label_ability_2"):setVisible(false)
            -- ccbNode:spriteForName("m_label_ability_2"):removeAllChildrenWithCleanup(true)
            local tempSpr ={}
            -- local spriteTable = {self.m_property_sprite_add_1,self.m_property_sprite_add_2}
            local i = 0 -- 计数 表示sprite的编号 1 2 
            for k,v in pairs(atts) do
                tempSpr = PUBLIC_ABILITY_NAME_TABLE[k] or {}
                i = i + 1
                local m_icon_ability = ccbNode:spriteForName("m_icon_ability_"..i)
                local m_label_ability = ccbNode:labelBMFontForName("m_label_ability_"..i)
                local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tostring(tempSpr.icon))
                if tempSpriteFrame then
                    m_icon_ability:setDisplayFrame(tempSpriteFrame)
                    m_icon_ability:setVisible(true)
                    local value,unit = self:formatValueToString2(v)
                    m_label_ability:setString(value..unit)
                    m_label_ability:setVisible(true)
                else
                    m_icon_ability:setVisible(false)
                    m_label_ability:setVisible(false)
                end
            end
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
    else
        m_node_old:stopAllActions();
        ccbNode:spriteForName("m_icon_ability_1"):setOpacity(255)
        ccbNode:spriteForName("m_label_ability_1"):setOpacity(255)
        ccbNode:spriteForName("m_icon_ability_2"):setOpacity(255)
        ccbNode:spriteForName("m_label_ability_2"):setOpacity(255)
        ccbNode:spriteForName("m_icon_ability_2"):setVisible(true)
        ccbNode:spriteForName("m_label_ability_2"):setVisible(true)
    end


end

--[[--
    格式化数字
]]
function M.formatValueToString2(self,value,combFlag)
    combFlag = combFlag == nil and true or combFlag;
    local tempValue = "0";
    local unit = "";
    if type(value) == "string" then
        value = tonumber(value);
    end
    if value == nil or type(value) ~= "number" then
        return tempValue,unit;
    end
    if value > 0 and value < 1000 then
        tempValue = tostring(value)
    elseif value >= 1000 and value < 100000000 then
        if value < 10000000 then
            tempValue,unit = string.format("%.1f",value * 0.001),"k"
        else
            tempValue,unit = string.format("%.0f",value * 0.0001),"万"
        end
    elseif value >= 100000000 then
        tempValue,unit = string.format("%.2f",value * 0.00000001),"亿"
    end
    if combFlag then
        tempValue = tempValue .. unit
        unit = "";
    end
    return tempValue,unit;
end
function M.setEquipNameColorByQuality(self,label,equipCfg)
    local quality = 1;
    if equipCfg then
        quality = equipCfg:getNodeWithKey("quality"):toInt()+1
    end
    self:setLabelColorByQuality(label,quality)
end

function M.createCCControlButton(self,btnImgName,text,callFunc)
    local btnImg = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(btnImgName);
    local btn = CCControlButton:create(CCLabelTTF:create(text,TYPE_FACE_TABLE.Arial_BoldMT,16),CCScale9Sprite:createWithSpriteFrame(btnImg));
    btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY-2);
    btn:setPreferredSize(btnImg:getRect().size);
    btn:addHandleOfControlEvent(callFunc,CCControlEventTouchUpInside);
    return btn;
end

--字体大小可调
function M.createCCControlButton2(self,btnImgName,text,callFunc,touchPriority,size)
    local btnImg = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(btnImgName);
    local btn = CCControlButton:create(CCLabelTTF:create(text,TYPE_FACE_TABLE.Arial_BoldMT,size),CCScale9Sprite:createWithSpriteFrame(btnImg));
    touchPriority = touchPriority or GLOBAL_TOUCH_PRIORITY-2
    btn:setTouchPriority(touchPriority);
    btn:setPreferredSize(btnImg:getRect().size);
    btn:addHandleOfControlEvent(callFunc,CCControlEventTouchUpInside);
    return btn;
end
function M.createCCControlButtonByTable(self,params)
    local btn = CCControlButton:create(params.text,TYPE_FACE_TABLE.Arial_BoldMT,12);
    local btnImg = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(params.btnImgName);
    btn:setBackgroundSpriteForState(CCScale9Sprite:createWithSpriteFrame(btnImg),CCControlStateNormal);
    btn:setTitleColorForState(ccc3(255,255,255),CCControlStateNormal)
    if params.btnImgNameSel ~= nil and params.btnImgNameSel ~= "" then
        local btnImgSel = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(params.btnImgNameSel);
        btn:setBackgroundSpriteForState(CCScale9Sprite:createWithSpriteFrame(btnImgSel),CCControlStateHighlighted);
        btn:setTitleColorForState(ccc3(255,255,255),CCControlStateHighlighted)
        btn:setZoomOnTouchDown(false);
    end
    if params.btnImgNameDis ~= nil and params.btnImgNameDis ~= "" then
        local btnImgDis = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(params.btnImgNameDis);
        btn:setBackgroundSpriteForState(CCScale9Sprite:createWithSpriteFrame(btnImgDis),CCControlStateDisabled);
        btn:setTitleColorForState(ccc3(255,255,255),CCControlStateDisabled)
        btn:setZoomOnTouchDown(false);
    end
    
    if params.touchPriority == nil then params.touchPriority = GLOBAL_TOUCH_PRIORITY-2 end
    btn:setTouchPriority(params.touchPriority);
    btn:setPreferredSize(btnImg:getRect().size);
    btn:addHandleOfControlEvent(params.callFunc,CCControlEventTouchUpInside);
    -- self:setControlButtonTitleBMFont(btn);
    return btn;
end
--[[
    設置按鈕的可點擊狀態
]]
function M.setCCControlButtonEnabled(self,btn,enabled)
    if btn == nil then return end
    if enabled == true then
        btn:setColor(ccc3(255, 255, 255));
        btn:setEnabled(true);
    else
        btn:setColor(ccc3(155, 155, 155));
        btn:setEnabled(false);
    end
end

function M.createSkillNameTips(self,parentNode,skillId,callback,mtype)
    -- cclog("createSkillNameTips ===================================skillId==" .. tostring(skillId));
    local skill_detail_cfg = getConfig("skill_detail");
    local skill_name = "Tấn công";
    local quality = 0;
    if(skillId) then
       local skill_detail_cfg_item = skill_detail_cfg:getNodeWithKey(tostring(skillId));
       if skill_detail_cfg_item then
          skill_name = skill_detail_cfg_item:getNodeWithKey("skill_name"):toStr();
          quality = skill_detail_cfg_item:getNodeWithKey("skill_quality"):toInt();
       end
    else
       if(mtype == 0) then
          skill_name = "Vật công"
       else
          skill_name = "Ma công"
       end
    end
    -- local bgW,bgH = 80,40;
    -- local bgNode = CCLayerColor:create(ccc4(155,155,155,255),bgW,bgH);
    local bgNode = CCSprite:createWithSpriteFrameName("zd_skill.png")
    local bgNodeSize = bgNode:getContentSize();
    local msgLabel = CCLabelTTF:create(skill_name,TYPE_FACE_TABLE.Arial_BoldMT,12);
    msgLabel:setPosition(bgNodeSize.width * 0.5,bgNodeSize.height * 0.5);
    bgNode:addChild(msgLabel);
    game_util:setLabelColorByQuality(msgLabel,quality)
    local parentNodeSize = parentNode:getContentSize();
    bgNode:setPosition(ccp(parentNodeSize.width * 0.5,parentNodeSize.height * 1.2));
    bgNode:setScale(1.5)
    parentNode:addChild(bgNode);
    local function show_end( node )
        -- body
        local remove_node = function()
           node:removeFromParentAndCleanup(true);
        end
        local arr = CCArray:create();
        arr:addObject(CCMoveBy:create(0.2,ccp(0,100)));
        arr:addObject(CCCallFuncN:create(remove_node));
        bgNode:runAction(CCSequence:create(arr));
        bgNode:runAction(CCFadeOut:create(0.2));
        callback();
    end
    local arr = CCArray:create();
    arr:addObject(CCDelayTime:create(0.3));
    arr:addObject(CCCallFuncN:create(show_end));
    bgNode:runAction(CCSequence:create(arr));
end
--[[
    创建静态倒计时
    依次显示剩余**天，剩余**小时，剩余**分，小于一分钟
]]
function M.createStaticCountDownLabel(self,needTime)
    local days = math.floor(needTime / 86400)
    local hours = math.floor((needTime - 86400 * days) / 3600)
    local minutes = math.floor((needTime - 86400 * days - 3600 * hours) / 60)
    local timeStr = ""
    if days > 0 then
        timeStr = string_helper.game_util.surplus .. days .. string_helper.game_util.days
    elseif hours > 0 then
        timeStr = string_helper.game_util.surplus .. hours .. string_helper.game_util.hours
    elseif minutes > 0 then
        timeStr = string_helper.game_util.surplus .. minutes .. string_helper.game_util.minutes
    else
        timeStr = string_helper.game_util.less_one_minutes
    end
    return self:createLabelTTF({text = timeStr,fontSize = 10}),timeStr
end
--[[
    创建倒计时label 
    #params 倒计时时间，回调，字体（未实现），是否需要显示小时（1是显示）
]]
function M.createCountdownLabel(self,needTime,timeLabelEndFunc,fontSize,shwoType,stroke)
    fontSize = fontSize or 10;
    shwoType = shwoType or 1;
    local countdownLabel = ExtCountdownLabel:create(needTime,1.0,shwoType);
    countdownLabel:ignoreAnchorPointForPosition(false);
    countdownLabel:setAnchorPoint(ccp(0.5,0.5));
    countdownLabel:registerScriptTapHandler(timeLabelEndFunc);
    return countdownLabel;
end

function M.getCurrentTime(self)
    return os.time();
end

function M.getTableLen(self,tableData)
    local tempLen = 0;
    if type(tableData) == "table" then
        table.foreach(tableData,function() tempLen = tempLen+1; end);
    end
    return tempLen;
end

function M.createEditBox(self,t_params)
    -- lua sample 输入框
    local function editBoxTextEventHandle(strEventName,pSender)
        local edit = tolua.cast(pSender,"CCEditBox")
        local strFmt
        if strEventName == "began" then
            -- strFmt = string.format("editBox %p DidBegin !", edit)
            -- print(strFmt)
        elseif strEventName == "ended" then
            -- strFmt = string.format("editBox %p DidEnd !", edit)
            -- print(strFmt)
        elseif strEventName == "return" then
            -- strFmt = string.format("editBox %p was returned !",edit)
            -- print(strFmt)
        elseif strEventName == "changed" then
            -- strFmt = string.format("editBox %p TextChanged, text: %s ", edit, edit:getText())
            -- print(strFmt)
            self.m_palyer_name = edit:getText();
        end
    end
    if t_params.bgFileName == nil then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/public_res.plist");
        t_params.bgFileName = "public_talkBar.png";
    end
    if t_params.fontSize == nil then
        t_params.fontSize = 25;
    end
    if t_params.fontColor == nil then
        t_params.fontColor = ccc3(0,0,0);
    end
    if t_params.placeHolder == nil then
        t_params.placeHolder = "Nhập tên"
    end
    if t_params.placeholderFontColor == nil then
        t_params.placeholderFontColor = ccc3(188,188,188)
    end
    if t_params.maxLength == nil then
        t_params.maxLength = 12;
    end
    if t_params.returnType == nil then
        t_params.returnType = kKeyboardReturnTypeDone;
    end
    if t_params.inputMode == nil then
        t_params.inputMode = kEditBoxInputModeSingleLine;
    end
    if t_params.scriptEditBoxHandler == nil then
        t_params.scriptEditBoxHandler = editBoxTextEventHandle;
    end

    local input_bg = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(t_params.bgFileName);
    local editBoxSize = input_bg:getRect().size;
    if t_params.size then
        editBoxSize = t_params.size
    end
    local editBoxTemp = CCEditBox:create(editBoxSize, CCScale9Sprite:createWithSpriteFrame(input_bg));
    editBoxTemp:setPreferredSize(editBoxSize);
    editBoxTemp:setPosition(ccp(editBoxSize.width*0.5, editBoxSize.height*0.5))
    editBoxTemp:setFontSize(t_params.fontSize)
    editBoxTemp:setFontColor(t_params.fontColor)
    editBoxTemp:setPlaceHolder(t_params.placeHolder)
    editBoxTemp:setPlaceholderFontColor(t_params.placeholderFontColor)
    editBoxTemp:setMaxLength(t_params.maxLength)
    editBoxTemp:setReturnType(t_params.returnType)
    editBoxTemp:setInputMode(t_params.inputMode);
    --Handler
    editBoxTemp:registerScriptEditBoxHandler(t_params.scriptEditBoxHandler)
    if t_params.text ~= nil then
        editBoxTemp:setText(t_params.text);
    end
    return editBoxTemp;
end
--[[--
    
]]
function M.spriteOnClickAnim(self,params)
    local listener = params.listener
    local tempSpr = params.tempSpr

    params.listener = function(tag)
        if params.prepare then
            params.prepare()
        end

        local function zoom1(offset, time, onComplete)
            local x, y = tempSpr:getPosition()
            local size = tempSpr:getContentSize()

            local scaleX = tempSpr:getScaleX() * (size.width + offset) / size.width
            local scaleY = tempSpr:getScaleY() * (size.height - offset) / size.height
            transition.moveTo(tempSpr, {x = x  , y = y - offset, time = time})
            transition.scaleTo(tempSpr, {
                scaleX     = scaleX,
                scaleY     = scaleY,
                scale      = 0.9,
                time       = time,
                onComplete = onComplete,
            })
        end

        local function zoom2(offset, time, onComplete)
            local x, y = tempSpr:getPosition()
            local size = tempSpr:getContentSize()

            transition.moveTo(tempSpr, {x = x , y = y + offset, time = time / 2})
            transition.scaleTo(tempSpr, {
                scaleX     = 1.0,
                scaleY     = 1.0,
                time       = time,
                onComplete = onComplete,
            })
        end
        zoom1(10, 0.08, function()
            zoom2(10, 0.09, function()
                zoom1(5, 0.10, function()
                    zoom2(5, 0.11, function()
                        listener(tag)
                    end)
                end)
            end)
        end)
    end
    params.listener(params.tag);
end

function M.setAttributeLable(self,oldLable,arrowLabel,newLabel,oldValue,newValue)
    if oldLable and arrowLabel and newLabel then
        oldLable:setString(oldValue);
        newLabel:setString(newValue);
        if oldValue == newValue then
            arrowLabel:setRotation(0);
            arrowLabel:setColor(ccc3(222,152,40));
            newLabel:setColor(ccc3(222,152,40));
        elseif oldValue > newValue then
            arrowLabel:setRotation(45);
            arrowLabel:setColor(ccc3(16,255,0));
            newLabel:setColor(ccc3(16,255,0));
        else
            arrowLabel:setRotation(-45);
            arrowLabel:setColor(ccc3(16,255,0));
            newLabel:setColor(ccc3(16,255,0));
        end
    end
end

function M.resetAttributeLable(self,oldLable,arrowLabel,newLabel)
    if oldLable and arrowLabel and newLabel then
        oldLable:setString("---");
        newLabel:setString("---");
        arrowLabel:setRotation(0);
        arrowLabel:setColor(ccc3(222,152,40));
        newLabel:setColor(ccc3(222,152,40));
    end
end

function M.setAttributeLable2(self,lable,oldValue,newValue,str)
    if lable then
        if oldValue == newValue or newValue == 0 then
            lable:setColor(ccc3(255,255,255));
            if str then
                lable:setString(str .. newValue);
            else
                lable:setString(newValue);
            end
        elseif oldValue > newValue then
            lable:setColor(ccc3(255,0,0));
            if str then
                lable:setString(str .. newValue);
            else
                lable:setString("-" .. newValue);
            end
        else
            lable:setColor(ccc3(0,255,0));
            if str then
                lable:setString(str .. newValue);
            else
                lable:setString("+" .. newValue);
            end
        end
    end
end

function M.resetAttributeLable2(self,lable)
    if lable then
        lable:stopAllActions();
        lable:setString("---");
        lable:setColor(ccc3(255,255,255));
        lable:setOpacity(255);
    end
end

function M.setCostLable(self,lable,costValue,currentValue)
    costValue = tonumber(costValue)
    currentValue = tonumber(currentValue);
    lable:setString(tostring(costValue))
    if costValue == 0 then
        lable:setColor(ccc3(0,255,0))
    elseif costValue > currentValue then
        lable:setColor(ccc3(255,0,0))
    else
        lable:setColor(ccc3(0,255,0))
    end
end

function M.createItemsItem( self,itemData )
    -- body
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_items_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if(ccbNode~=nil and itemData~=itemData)then
    end
    return ccbNode;
end


function M.formatTime(self,timeValue)
    return string.format("%02d:%02d:%02d", math.floor(timeValue/3600), math.floor((timeValue%3600)/60), math.floor(timeValue%60))
end

function M.formatTime2(self,timeValue)
    local timeValue = timeValue or 0
    if timeValue <= 60 then
        timeValue = string.format("%02d", timeValue)
    elseif timeValue > 60 and timeValue <= 3600 then
        timeValue = string.format("%02d:%02d", math.floor(timeValue/60), math.floor(timeValue%60))
    else
        timeValue = string.format("%02d:%02d:%02d", math.floor(timeValue/3600), math.floor((timeValue%3600)/60), math.floor(timeValue%60))
    end
    return timeValue;
end

function M.setCCControlButtonTitle(self,btn,title)
    if btn == nil then return end
    local title = CCString:create(tostring(title));
    btn:setTitleForState(title,CCControlStateNormal);
    btn:setTitleForState(title,CCControlStateHighlighted);
    btn:setTitleForState(title,CCControlStateDisabled);
end

--[[
    设置按钮字体大小
]]
function M.setCCControlButtonSize(self,btn,size)
    if btn == nil then return end
    btn:setTitleTTFSizeForState(size,CCControlStateNormal);
    btn:setTitleTTFSizeForState(size,CCControlStateHighlighted);
    btn:setTitleTTFSizeForState(size,CCControlStateDisabled);
end

function M.setControlButtonTitleBMFont(self,btn)
    if btn == nil then return end
    btn:setTitleBMFontForState("btn_text_character.fnt",CCControlStateNormal)
    btn:setTitleBMFontForState("btn_text_character.fnt",CCControlStateHighlighted)
    btn:setTitleBMFontForState("btn_text_character.fnt",CCControlStateDisabled)
end

function M.setCCControlButtonBackground(self,btn,normalImgName,highlightedImgName,disabledImgName)
    if btn == nil or normalImgName == nil then return end
    local tempFrame = CCScale9Sprite:createWithSpriteFrameName(normalImgName)
    if tempFrame then btn:setBackgroundSpriteForState( tempFrame ,CCControlStateNormal); end
    highlightedImgName = highlightedImgName or normalImgName
    local tempFrame = CCScale9Sprite:createWithSpriteFrameName(highlightedImgName)
    if tempFrame then  btn:setBackgroundSpriteForState(CCScale9Sprite:createWithSpriteFrameName(highlightedImgName),CCControlStateHighlighted); end
    disabledImgName = disabledImgName or normalImgName
    local tempFrame = CCScale9Sprite:createWithSpriteFrameName(disabledImgName)
    if tempFrame then  btn:setBackgroundSpriteForState(CCScale9Sprite:createWithSpriteFrameName(disabledImgName),CCControlStateDisabled); end
end
--[[
    通过cid创建卡牌头像  小头像
]]
function M.createCardIconByCid(self,cid,itemData)
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroCfg = character_detail_cfg:getNodeWithKey(tostring(cid));
    if heroCfg == nil then return nil,nil end
    return self:createCardIconByCfg(heroCfg,itemData),heroCfg:getNodeWithKey("name"):toStr();
end

function M.createCardIconByCfg(self,itemCfg,itemData)--小头像
    if itemCfg == nil then
        return nil;
    end
    local rgb = itemCfg:getNodeWithKey("rgb_sort");
    if rgb then
        rgb = rgb:toInt();
    else
        rgb = 0;
    end
    local fileName = itemCfg:getNodeWithKey("img"):toStr();
    local quality = itemCfg:getNodeWithKey("quality"):toInt();
    itemData = itemData or {}
    local super_quality_1 = itemData.super_quality_1 or 0
    local tempIcon = self:createIconByName(fileName)
    if tempIcon then
        -- cclog("quality ==" .. quality)
        if rgb == 1 then
            tempIcon:setColor(ccc3(47,255,118));
        elseif rgb == 2 then
            tempIcon:setColor(ccc3(67,117,253));
        elseif rgb == 3 then
            tempIcon:setColor(ccc3(171,65,255));
        end
        local qualityTab = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
        if qualityTab then
            local tempIconSize = tempIcon:getContentSize();
            local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
            img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img1,-1,-1)
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,1)
        end
    end
    return tempIcon;
end
--[[
    通过CID创建装备图标
]]
function M.createEquipIconByCid(self,cid)
    local equipCfg = getConfig(game_config_field.equip);
    local itemCfg = equipCfg:getNodeWithKey(tostring(cid));
    if itemCfg == nil then return nil,nil end
    return self:createEquipIcon(itemCfg),itemCfg:getNodeWithKey("name"):toStr();
end
--[[
    通过Cfg创建装备图标
]]
function M.createEquipIcon(self,itemCfg)
    local tempIcon = nil;
    if itemCfg then
        local image = itemCfg:getNodeWithKey("image"):toStr();
        tempIcon = self:createIconByName(image)
        if tempIcon == nil then
            cclog(image .. " image is not found");
        end
    else
        cclog("equip config is not found");
    end
    if tempIcon then
        local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
        -- cclog("quality ==" .. quality)
        local qualityTab = HERO_QUALITY_COLOR_TABLE[quality];
        if qualityTab then
            local tempIconSize = tempIcon:getContentSize();
            local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
            img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img1,-1,1)
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,2)
        end
    end
    return tempIcon;
end

-- function M.getEquipAttributeValue(self,itemCfg,level,itemData)
--     local attrName1,value1,attrName2,value2,icon1,icon2 = "Không có","Không có","Không có","Không có","public_icon_phsc.png","public_icon_hp.png";
--     if itemCfg:getNodeWithKey("sort"):toInt() ~= 0 then
--         value1 = itemCfg:getNodeWithKey("value1"):toInt();
--         value2 = itemCfg:getNodeWithKey("value2"):toInt();
--         value1 = value1 + itemCfg:getNodeWithKey("level_add1"):toInt() * math.max(0,level-1)
--         value2 = value2 + itemCfg:getNodeWithKey("level_add2"):toInt() * math.max(0,level-1)
--         local ability1 = itemCfg:getNodeWithKey("ability1"):toInt();
--         -- cclog("ability1 ====================" .. ability1)
--         local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability1]
--         attrName1 = attrTab.name;
--         icon1 = attrTab.icon;
--         local ability2 = itemCfg:getNodeWithKey("ability2"):toInt();
--         -- cclog("ability2 ====================" .. ability2)
--         local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability2]
--         attrName2 = attrTab.name;
--         icon2 = attrTab.icon;
--     end
--     return attrName1,value1,attrName2,value2,icon1,icon2;
-- end

function M.getEquipAttributeValue(self,itemCfg,level,itemData)
     local equip_set_random = getConfig(game_config_field.equip_set_random)
    itemData = itemData or nil
    local attrName1,value1,attrName2,value2,icon1,icon2,aName,bName = "Không có","Không có","Không có","Không có","public_icon_phsc.png","public_icon_hp.png","","";
    if itemCfg:getNodeWithKey("sort"):toInt() ~= 0 then
        value1 = itemCfg:getNodeWithKey("value1"):toInt();
        value2 = itemCfg:getNodeWithKey("value2"):toInt();
        value1 = value1 + itemCfg:getNodeWithKey("level_add1"):toInt() * math.max(0,level-1)
        value2 = value2 + itemCfg:getNodeWithKey("level_add2"):toInt() * math.max(0,level-1)
        local ability1 = itemCfg:getNodeWithKey("ability1"):toInt();
        aName = PUBLIC_ABILITY_TABLE["ability_" .. ability1].attrName
        -- cclog("ability1 ====================" .. ability1)
        local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability1]
        attrName1 = attrTab.name;
        icon1 = attrTab.icon;
        local ability2 = itemCfg:getNodeWithKey("ability2"):toInt();
        bName = PUBLIC_ABILITY_TABLE["ability_" .. ability2].attrName
        -- cclog("ability2 ====================" .. ability2)
        local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability2]
        attrName2 = attrTab.name;
        icon2 = attrTab.icon;
    end
    if itemData ~= nil and itemData.equip_refine ~= nil then
        cclog("9++++++++++")
        value2 = value2 + itemData.equip_refine.hp
        local temp2 = 0
        -- if itemData.equip_refine.patk ~= 0 then temp2 = itemData.equip_refine.patk
        -- elseif itemData.equip_refine.matk ~= 0 then temp2 = itemData.equip_refine.matk
        -- elseif itemData.equip_refine.def ~= 0 then temp2 = itemData.equip_refine.def
        -- elseif itemData.equip_refine.speed ~= 0 then temp2 = itemData.equip_refine.speed
        -- end
        local ability1 = itemCfg:getNodeWithKey("ability1"):toInt();
        local attrName = PUBLIC_ABILITY_TABLE["ability_" .. ability1].attrName
        aName = attrName
        if itemData.equip_refine[attrName] then
            temp2 = itemData.equip_refine[attrName]
        end
        value1 = value1 + temp2
    end
    if itemData ~= nil and itemData.is_equip_forge == true then
        -- local attrname = 
        -- local tempValue = {0,0,0,0,0}
        for key_type,valueTable in pairs(itemData.equip_forge) do
            local itemEquipForgeCfg = json.decode(equip_set_random:getNodeWithKey(tostring(key_type)):getFormatBuffer())
            local sort = itemEquipForgeCfg.sort
            local enemy = itemEquipForgeCfg.enemy[1]
            local value = 0
            for k,v in pairs(valueTable) do
                value = v
            end
            if sort > 0 and sort <= 5 then
                -- tempValue[sort] = value
                if sort == 5 then
                    -- value2 = math.floor(value2 * (1 + value ))
                    --不用百分比
                    if enemy ~= -1 then
                        value2 = math.floor(value2 + value )
                    end
                else
                    local attrName = PUBLIC_ABILITY_TABLE["ability_" .. sort].attrName 
                    aName = attrName
                    -- value1 = math.floor(value1 * (1 + value) )
                    --不用百分比
                    if enemy ~= -1 then
                        value1 = math.floor(value1 + value) 
                    end
                end
            end
        end
    end

    --装备


    return attrName1,value1,attrName2,value2,icon1,icon2,aName,bName;
end

--[[
    获取装备增加的血量
]]
function M.getEquipHPAttributeValue(self,itemCfg,level)
    local hp = 0
    if itemCfg:getNodeWithKey("sort"):toInt() ~= 0 then
        for i=1,2 do
            local ability = itemCfg:getNodeWithKey("ability" .. i)
            ability = ability and ability:toInt() or 1
            local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability] or {}
            if attrTab.typeValue == 5 then  -- hp
                local value = itemCfg:getNodeWithKey("value" .. i) 
                value = value and value:toInt() or 0
                local addVal = itemCfg:getNodeWithKey("level_add" .. i)
                addVal = addVal and addVal:toInt() or 0
                hp = value + addVal * math.max(0,level-1)
            end
        end
    end
    return hp
end

function M.createRepeatForeverFade(self,outValue,inValue)
    outValue = outValue or 1
    inValue = inValue or 1
    local animArr = CCArray:create();
    animArr:addObject(CCFadeTo:create(outValue,100));
    animArr:addObject(CCFadeTo:create(inValue,255));
    return CCRepeatForever:create(CCSequence:create(animArr));
end

function M.createRepeatForeverMove(self,startPos,endPos)
    startPos = startPos or ccp(0,0);
    endPos = endPos or ccp(0,0);
    local animArr = CCArray:create();
    animArr:addObject(CCMoveTo:create(0.5,startPos));
    animArr:addObject(CCMoveTo:create(0.5,endPos));
    return CCRepeatForever:create(CCSequence:create(animArr));
end

function M.createRepeatForeverMoveWithTime(self,startPos,endPos,startTime,endTime)
    startPos = startPos or ccp(0,0);
    endPos = endPos or ccp(0,0);
    local animArr = CCArray:create();
    animArr:addObject(CCMoveTo:create(startTime,startPos));
    animArr:addObject(CCMoveTo:create(endTime,endPos));
    return CCRepeatForever:create(CCSequence:create(animArr));
end
--[[
    创建文字变化
]]
function M.labelChangedRepeatForeverFade(self,label,valueOld,valueNew,outValue,inValue)
    if label == nil then return end
    label:stopAllActions();
    label:setString(tostring(valueOld));
    label:setColor(ccc3(255,255,255))
    if valueOld == valueNew then
        label:setOpacity(255);
        return 
    end
    outValue = outValue or 1
    inValue = inValue or 1
    local function newFunc(node)
        label:setString(tostring(valueNew))
        label:setColor(ccc3(0,255,0))
    end
    local function oldFunc(node)
        label:setString(tostring(valueOld))
        label:setColor(ccc3(255,255,255))
    end
    local animArr = CCArray:create();
    animArr:addObject(CCFadeIn:create(inValue));
    animArr:addObject(CCFadeOut:create(outValue));
    animArr:addObject(CCCallFuncN:create(oldFunc));
    animArr:addObject(CCFadeIn:create(inValue));
    animArr:addObject(CCFadeOut:create(outValue));
    animArr:addObject(CCCallFuncN:create(newFunc));
    label:runAction(CCRepeatForever:create(CCSequence:create(animArr)));
end

--[[--
    滚动提示
]]
function M.createScrollViewTips(self,scroll_view_tips,tipsStrTab,loopFlag,openType, fontColor, fontSize)
    openType = openType or 1;
    fontSize = fontSize or 10
    if scroll_view_tips == nil or scroll_view_tips:getParent() == nil then
        return;
    end
    tipsStrTab = tipsStrTab or {};
    if #tipsStrTab == 0 then
        scroll_view_tips:getParent():setVisible(false);
        return;
    else
        scroll_view_tips:getParent():setVisible(true);
    end
    loopFlag = loopFlag == nil and true or loopFlag
    scroll_view_tips:getContainer():removeAllChildrenWithCleanup(true);
    local showIndex = 1;
    local scroll_view_size = scroll_view_tips:getViewSize();
    local containerNode = CCNode:create();
    scroll_view_tips:addChild(containerNode)
    scroll_view_tips:setTouchEnabled(false);
    local function getMsg(showIndex)
        local msg = "";
        if type(tipsStrTab[showIndex]) == "string" then
            msg = tipsStrTab[showIndex];
        elseif type(tipsStrTab[showIndex]) == "table" then
            msg = tipsStrTab[showIndex].msg or "";
        end
        return msg;
    end
    local function getMsg(showIndex)
        local msg = "";
        if type(tipsStrTab[showIndex]) == "string" then
            msg = tipsStrTab[showIndex]
        elseif type(tipsStrTab[showIndex]) == "table" then
            msg = tipsStrTab[showIndex].msg or "";
        end
        return msg;
    end
    local tempTipsLabel
    if openType == 3 then
        tempTipsLabel = game_util:createRichLabelTTF({text = getMsg(showIndex),dimensions = CCSizeMake(221,0),textAlignment = kCCTextAlignmentLeft, verticalTextAlignment = kCCVerticalTextAlignmentCenter,fontSize = fontSize})
        tempTipsLabel:setPosition(ccp(scroll_view_size.width*0.5,-scroll_view_size.height))
    else
        tempTipsLabel = CCLabelTTF:create(getMsg(showIndex),TYPE_FACE_TABLE.Arial_BoldMT, fontSize)
        if tempTipsLabel and fontColor then
            tempTipsLabel:setColor(fontColor)
        end
        tempTipsLabel:setPosition(ccp(scroll_view_size.width*0.5,-scroll_view_size.height))
    end
    containerNode:addChild(tempTipsLabel)
    local function backCallFunc( node )
        showIndex = showIndex + 1
        scroll_view_tips:getParent():setVisible(true);
        if showIndex > #tipsStrTab then
            if loopFlag == true then
                showIndex = 1;
            else
                tempTipsLabel:removeFromParentAndCleanup(true);
                scroll_view_tips:getParent():setVisible(false);
            end
        end
        tempTipsLabel:setString(getMsg(showIndex))
        tempTipsLabel:setPosition(ccp(scroll_view_size.width*0.5,-scroll_view_size.height))
    end
    local function visibleCallFunc( node )
        scroll_view_tips:getParent():setVisible(false);
    end
    local animArr = CCArray:create();
    animArr:addObject(CCEaseIn:create(CCMoveTo:create(0.5,ccp(scroll_view_size.width*0.5,scroll_view_size.height*0.5)),5));
    -- animArr:addObject(CCFadeOut:create(0.5));
    -- animArr:addObject(CCFadeIn:create(0.5));
    animArr:addObject(CCDelayTime:create(5));
    animArr:addObject(CCEaseIn:create(CCMoveTo:create(0.5,ccp(scroll_view_size.width*0.5,scroll_view_size.height*2)),5));
    if openType == 2 then
        animArr:addObject(CCCallFuncN:create(visibleCallFunc));
        animArr:addObject(CCDelayTime:create(5));
    end
    animArr:addObject(CCCallFuncN:create(backCallFunc));
    tempTipsLabel:runAction(CCRepeatForever:create(CCSequence:create(animArr)))
end
-- --[[--
--     滚动提示
-- ]]
-- function M.createScrollViewTips(self,scroll_view_tips,tipsStrTab,loopFlag,openType, fontColor, fontSize)
--     openType = openType or 1;
--     fontSize = fontSize or 10
--     if scroll_view_tips == nil or scroll_view_tips:getParent() == nil then
--         return;
--     end
--     tipsStrTab = tipsStrTab or {};
--     if #tipsStrTab == 0 then
--         scroll_view_tips:getParent():setVisible(false);
--         return;
--     else
--         scroll_view_tips:getParent():setVisible(true);
--     end
--     loopFlag = loopFlag == nil and true or loopFlag
--     scroll_view_tips:getContainer():removeAllChildrenWithCleanup(true);
--     local showIndex = 1;
--     local scroll_view_size = scroll_view_tips:getViewSize();
--     local containerNode = CCNode:create();
--     scroll_view_tips:addChild(containerNode)
--     scroll_view_tips:setTouchEnabled(false);
--     local function getMsg(showIndex)
--         local msg = "";
--         if type(tipsStrTab[showIndex]) == "string" then
--             msg = tipsStrTab[showIndex];
--         elseif type(tipsStrTab[showIndex]) == "table" then
--             msg = tipsStrTab[showIndex].msg or "";
--         end
--         return msg;
--     end
--     -- local tempTipsLabel = CCLabelTTF:create(getMsg(showIndex),TYPE_FACE_TABLE.Arial_BoldMT,fontSize)
--     -- if tempTipsLabel and fontColor then
--     --     tempTipsLabel:setColor(fontColor)
--     -- end
--     -- tempTipsLabel:setPosition(ccp(scroll_view_size.width*0.5,-scroll_view_size.height))
--      if openType == 3 then
--         tempTipsLabel = game_util:createRichLabelTTF({text = getMsg(showIndex),dimensions = CCSizeMake(221,0),textAlignment = kCCTextAlignmentLeft, verticalTextAlignment = kCCVerticalTextAlignmentCenter,fontSize = fontSize})
--         tempTipsLabel:setPosition(ccp(scroll_view_size.width*0.5,-scroll_view_size.height))
--     else
--         tempTipsLabel = CCLabelTTF:create(getMsg(showIndex),TYPE_FACE_TABLE.Arial_BoldMT, fontSize)
--         if tempTipsLabel and fontColor then
--             tempTipsLabel:setColor(fontColor)
--         end
--         tempTipsLabel:setPosition(ccp(scroll_view_size.width*0.5,-scroll_view_size.height))
--     end
--     containerNode:addChild(tempTipsLabel)
--     local function backCallFunc( node )
--         showIndex = showIndex + 1
--         scroll_view_tips:getParent():setVisible(true);
--         if showIndex > #tipsStrTab then
--             if loopFlag == true then
--                 showIndex = 1;
--             else
--                 tempTipsLabel:removeFromParentAndCleanup(true);
--                 scroll_view_tips:getParent():setVisible(false);
--             end
--         end
--         tempTipsLabel:setString(getMsg(showIndex))
--         tempTipsLabel:setPosition(ccp(scroll_view_size.width*0.5,-scroll_view_size.height))
--     end
--     local function visibleCallFunc( node )
--         scroll_view_tips:getParent():setVisible(false);
--     end
--     local animArr = CCArray:create();
--     animArr:addObject(CCEaseIn:create(CCMoveTo:create(0.5,ccp(scroll_view_size.width*0.5,scroll_view_size.height*0.5)),5));
--     -- animArr:addObject(CCFadeOut:create(0.5));
--     -- animArr:addObject(CCFadeIn:create(0.5));
--     animArr:addObject(CCDelayTime:create(5));
--     animArr:addObject(CCEaseIn:create(CCMoveTo:create(0.5,ccp(scroll_view_size.width*0.5,scroll_view_size.height*2)),5));
--     if openType == 2 then
--         animArr:addObject(CCCallFuncN:create(visibleCallFunc));
--         animArr:addObject(CCDelayTime:create(5));
--     end
--     animArr:addObject(CCCallFuncN:create(backCallFunc));
--     tempTipsLabel:runAction(CCRepeatForever:create(CCSequence:create(animArr)))
-- end

--[[--
    滚动提示
]]
function M.createScrollViewTips2(self,scroll_view_tips,nameTab)
    if nameTab == nil or #nameTab == 0 then return end
    scroll_view_tips:getContainer():removeAllChildrenWithCleanup(true);
    local showIndex = 1;
    local scroll_view_size = scroll_view_tips:getViewSize();
    local containerNode = CCNode:create();
    scroll_view_tips:addChild(containerNode)
    scroll_view_tips:setTouchEnabled(false);
    local function getSpriteFrameByIndex(showIndex)
        local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tostring(nameTab[showIndex]));
        return tempSpriteFrame;
    end
    local function showTips()
        local tempDisplayFrame = getSpriteFrameByIndex(showIndex);
        if tempDisplayFrame == nil then return end
        local tempSprite = CCSprite:createWithSpriteFrame(tempDisplayFrame);
        if tempSprite == nil then return end
        tempSprite:setPosition(ccp(scroll_view_size.width*0.5,-scroll_view_size.height))
        containerNode:addChild(tempSprite)

        local function backCallFunc( node )
            showIndex = showIndex + 1
            if showIndex > #nameTab then
                showIndex = 1;
            end
            local tempDisplayFrame = getSpriteFrameByIndex(showIndex);
            if tempDisplayFrame == nil then return end
            tempSprite:setDisplayFrame(tempDisplayFrame)
            tempSprite:setPosition(ccp(scroll_view_size.width*0.5,-scroll_view_size.height))
        end
        local animArr = CCArray:create();
        animArr:addObject(CCEaseIn:create(CCMoveTo:create(0.5,ccp(scroll_view_size.width*0.5,scroll_view_size.height*0.5)),5));
        -- animArr:addObject(CCFadeOut:create(0.5));
        -- animArr:addObject(CCFadeIn:create(0.5));
        animArr:addObject(CCDelayTime:create(5));
        animArr:addObject(CCEaseIn:create(CCMoveTo:create(0.5,ccp(scroll_view_size.width*0.5,scroll_view_size.height*2)),5));
        animArr:addObject(CCCallFuncN:create(backCallFunc));
        tempSprite:runAction(CCRepeatForever:create(CCSequence:create(animArr)))
    end
    showTips();
end
--[[
    推送
]]
function M.registerScriptApplication(self)
    local function addApplicationCallFunc(typeName)
        cclog("---------------------addApplicationCallFunc---------------------typeName= " .. tostring(typeName))
        if typeName == "didFinishLaunching" then
            if game_data_statistics then
                game_data_statistics:enterGame()
            end
            util_system:removeAllNotification();
        elseif typeName == "didEnterBackground" then
            local actionPointTime = game_data:getActionPointTime();
            if actionPointTime > 0 then
                util_system:addNotification(1,string_config.action_point_push_text,actionPointTime,false)
            end
            local server_time = math.floor(game_data:getUserStatusDataByKey("server_time") or 0)
            -- cclog("server_time == " .. server_time)
            --每天推送13：00   和   20：00两次   进击的巨人
            local today = os.date("*t")
            local oneHour = os.time({day=today.day, month=today.month,year=today.year, hour=13, minute=0, second=0})
            -- cclog("secondOfToday == " .. oneHour)
            local sub = oneHour - 300 - server_time
            if sub > 0 then
                util_system:addNotification(2,string_config.world_boss_push_text,sub,false)
            end
            local eightHour = os.time({day=today.day, month=today.month,year=today.year, hour=20, minute=0, second=0})
            -- cclog("eightHour == " .. eightHour)
            local sub2 = eightHour - 300 - server_time
            if sub2 > 0 then
                util_system:addNotification(2,string_config.world_boss_push_text,sub2,false)
            end
            game_data:didEnterBackground();
            if game_data_statistics then
                game_data_statistics:quitGame()
            end

            --推送生存大考验
            local nineHour = os.time({day=today.day, month=today.month,year=today.year, hour=9, minute=0, second=0})
            local live_sub = nineHour - server_time
            if live_sub > 0 then
                util_system:addNotification(3,string_config.active_live,live_sub,false)
            end
            local twenty_one = os.time({day=today.day, month=today.month,year=today.year, hour=21, minute=0, second=0})
            local live_sub2 = twenty_one - server_time
            if live_sub2 then
                util_system:addNotification(3,string_config.active_live,live_sub2,false)
            end

            --只顯示一次的推送   --->第二天推送
            local uid = game_data:getUserStatusDataByKey("uid")
            if uid then
                local rewardSign = CCUserDefault:sharedUserDefault():getStringForKey(uid .. "rewardSign");
                -- cclog(uid .. "rewardSign = " .. tostring(rewardSign))
                if rewardSign == "first" then--為空說明第一天，推送，否則不推送
                    -- cclog("tuisong~~~~~~~~~~~~~~~~~")
                    CCUserDefault:sharedUserDefault():setStringForKey(uid .. "rewardSign","already");
                    CCUserDefault:sharedUserDefault():flush();
                    util_system:addNotification(4,"Ngày mai điểm danh có thể nhận Thẻ Cam siêu cấp Songoku",1,false)
                end
            end
        elseif typeName == "willEnterForeground" then
            if game_data_statistics then
                game_data_statistics:enterGame()
            end
            if device.platform == "ios" then
                util_system:removeAllNotification();
            elseif device.platform == "android" then
                for i=1,4 do
                    util_system:removeNotificationById(i);
                end
            end
            game_data:willEnterForeground();
            game_scene:fillPropertyBarData();
        end
    end
    util_system:registerScriptApplicationHandler(addApplicationCallFunc);
end

function M.createBattleHeroLevelUpByCCB(self,backCallFunc,cardId,lv)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_battle_hero_levelup.ccbi");
    local m_root_layer = ccbNode:layerForName("m_root_layer")
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    local m_name_label = ccbNode:labelTTFForName("m_name_label")
    local m_level_label = ccbNode:labelTTFForName("m_level_label")
    local m_life_label = ccbNode:labelTTFForName("m_life_label")
    local m_physical_atk_label = ccbNode:labelTTFForName("m_physical_atk_label")
    local m_magic_atk_label = ccbNode:labelTTFForName("m_magic_atk_label")
    local m_def_label = ccbNode:labelTTFForName("m_def_label")
    local m_speed_label = ccbNode:labelTTFForName("m_speed_label")

    local cardData,heroCfg = game_data:getCardDataById(tostring(cardId));
    if cardData and heroCfg then
        m_level_label:setString(cardData.lv .. "/" .. cardData.level_max);
        m_name_label:setString(heroCfg:getNodeWithKey("name"):toStr());
        game_util:setHeroNameColorByQuality(m_name_label,heroCfg);
        m_life_label:setString(cardData.hp);
        m_physical_atk_label:setString(cardData.patk);
        m_magic_atk_label:setString(cardData.matk);
        m_def_label:setString(cardData.def);
        m_speed_label:setString(cardData.speed);
        local ainmFile = heroCfg:getNodeWithKey("animation"):toStr();
        local animNode = game_util:createIdelAnim(ainmFile,0,cardData,heroCfg);
        animNode:setAnchorPoint(ccp(0.5,0));
        m_anim_node:addChild(animNode);
    end
    -- local animNode = game_util:createIdelAnim("ailisi",0,nil,nil);
    -- animNode:setAnchorPoint(ccp(0.5,0));
    -- m_anim_node:addChild(animNode);
    local function animEnd(animName)
        ccbNode:removeFromParentAndCleanup(true);
        if backCallFunc ~= nil then backCallFunc(); end
    end
    ccbNode:registerAnimFunc(animEnd);
    ccbNode:runAnimations("level_up_anim");
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            ccbNode:removeFromParentAndCleanup(true);
            if backCallFunc ~= nil then backCallFunc(); end
            return true;--intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY-10,true);
    m_root_layer:setTouchEnabled(true);
    return ccbNode;
end

function M.getBuildingRewardId(self,tempId,count)
    count = count or 1;
    local icon,name = nil,nil;
    local building_mine = getConfig(game_config_field.building_mine);
    local reward_building_cfg = building_mine:getNodeWithKey(tostring(tempId))
    if reward_building_cfg then
        iconName = reward_building_cfg:getNodeWithKey("icon"):toStr();
        iconName = self:getResName(iconName);
        icon = CCSprite:createWithSpriteFrameName(iconName .. ".png")
        name = reward_building_cfg:getNodeWithKey("building_name"):toStr()-- .. "×" .. count;
    end
    return icon,name,count;
end

function M.getCardRewardId(self,tempId,count)
    local icon,name,quality = nil,nil,0;
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local itemCfg = character_detail_cfg:getNodeWithKey(tostring(tempId));
    if itemCfg then
        -- cclog("getCardRewardId tempId ============== " .. tostring(tempId) .. " ; count ===========" .. tostring(count));
        name = itemCfg:getNodeWithKey("name"):toStr()-- .. (count ~= nil and "×" .. count or "");
        icon = self:createCardIconByCfg(itemCfg);
        quality = itemCfg:getNodeWithKey("quality"):toInt();
    end
    return icon,name,count,quality;
end

function M.getItemRewardId(self,tempId,count)
    -- cclog(tostring(tempId) .. " ; count ===========" .. tostring(count))
    local icon,name,quality = nil,nil,0;
    local item = getConfig(game_config_field.item);
    local itemCfg = item:getNodeWithKey(tostring(tempId));
    if itemCfg then
        -- cclog("getItemRewardId tempId ============== " .. tostring(tempId) .. " ; count ===========" .. tostring(count));
        name = itemCfg:getNodeWithKey("name"):toStr()-- .. (count ~= nil and "×" .. count or "");
        icon = self:createItemIconByCfg(itemCfg);
        quality = itemCfg:getNodeWithKey("quality"):toInt();
    else
        cclog("item cfg not found == " .. tostring(tempId))
    end
    return icon,name,count,quality;
end

function M.getEquipRewardId(self,tempId,count)
    local icon,name,quality = nil,nil,0;
    local equipCfg = getConfig(game_config_field.equip);
    local itemCfg = equipCfg:getNodeWithKey(tostring(tempId));
    if itemCfg then
        -- cclog("getEquipRewardId tempId ============== " .. tostring(tempId) .. " ; count ===========" .. tostring(count));
        name = itemCfg:getNodeWithKey("name"):toStr()-- .. (count ~= nil and "×" .. count or "");
        icon = self:createEquipIcon(itemCfg);
        quality = itemCfg:getNodeWithKey("quality"):toInt();
    end
    return icon,name,count,quality;
end
--[[--
    通用奖励
]]
function M.getRewardByItem(self,itemJsonData,flag)
    if itemJsonData == nil then return nil,nil,nil end
    return self:getRewardByItemTable(json.decode(itemJsonData:getFormatBuffer()),flag);
end

--[[--
    通用奖励
]]
function M.getRewardByItemTable(self,dataTable,flag,qualityFlag, ext)
    if flag == nil then
        flag = false;
    end
    ext = ext or {}
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/public_res_add.plist");
    local icon,name,count,rewardType,quality = nil,nil,0,0,0
    if dataTable and #dataTable > 2 then
        rewardType = dataTable[1]
        local tempId = dataTable[2];
        local tempCount = dataTable[3];
        if rewardType == 1 then--食品，佔位，參數數量；[1,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_food2.png"),"Thức ăn",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 2 then--金屬，佔位，參數數量；[2,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_metal2.png"),"Sắt",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 3 then--能源，佔位，能源數量；[3,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_energy2.png"),"Năng nguyên",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 4 then--能晶，佔位，能晶數量；[4,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_crystal2.png"),"Năng tinh",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 5 then--卡牌，卡牌ID,數量；[5,4,1]
            icon,name,count = self:getCardRewardId(tempId,tempCount);
        elseif rewardType == 6 then--道具，ID,數量；[6,4,1]
            icon,name,count = self:getItemRewardId(tempId,tempCount);
        elseif rewardType == 7 then--裝備,ID，數量；[7,4,1]
            icon,name,count = self:getEquipRewardId(tempId,tempCount);
        elseif rewardType == 8 then--玩家經驗，佔位，數值;[8,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_add_exp.png"),"EXP",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 9 then--鑽石,佔位，數量;[9,0,1]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_gold2.png"),"Xu",tempCount
            if qualityFlag then
            else
                self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 10 then--強能之塵,佔位，數量;[10,0,1]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_chen_2.png"),"Bụi cường năng",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 11 then--超能之塵,佔位，數量;[11,0,1]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_chen_1.png"),"Bụi siêu năng",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 12 then--陣石,佔位，數量;[12,0,1]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_gold2.png"),"Đá trận",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 13 then--行動力,佔位，數量;[13,0,1]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_action_point2.png"),"Huân chương",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 14 then--星靈,佔位，數量;[14,0,1]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_xingxing2.png"),"Hồn sao",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 15 then--金幣,佔位，數量;[15,0,1]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_silver2.png"),"Vàng",tempCount
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 16 then--精煉石
            icon,name,count = CCSprite:createWithSpriteFrameName("public_xilian2.png"),"Đá tinh luyện",tempCount 
            self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 17 then--神恩
            icon,name,count = CCSprite:createWithSpriteFrameName("public_shenen_d2.png"),"Thần Ân",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 18 then--高级神恩
            icon,name,count = CCSprite:createWithSpriteFrameName("public_shenen_g2.png"),"Thần Ân cao cấp",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 19 then--宝石
            icon,name,count,quality = self:getGemRewardId(tempId,tempCount);
        elseif rewardType == 20 then--高级能晶
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_gaojinengjing2.png"),"Năng Tinh cao cấp",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 21 then--魔光碎片
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_piece2.png"),"Mảnh Ma Quang",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 22 then -- 种子
            icon,name,count = self:getSeedItemRewardId(tempId,tempCount);
        elseif rewardType == 23 then--洗练石
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_succinct2.png"),"Đá Tẩy Luyện",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 24 then--寵物能晶   --like diamond
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_crystle2.png"),"Năng Tinh thú nuôi",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 25 then--寵物   card
            icon,name,count,quality = self:getPetRewardId(tempId,tempCount);
        elseif rewardType == 26 then--寵物經驗球     膠囊    --like diamond
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_capsule2.png"),"Bao Con Nhộng",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 27 then--寵物技能石     --like diamond
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_pet_stone2.png"),"Đá kỹ năng thú nuôi",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 29 then--勋章材料;[29,id,count]
            icon,name = self:createMaterialIconById(tempId)
            count = tempCount
        elseif rewardType == 30 then--勋章;[30,id,count]
            icon,name = self:createMedalIconById(tempId)
            count = tempCount
        elseif rewardType == 36 then--英魂[36,id,count]
            icon,name = self:createSoulIconById(tempId)
            count = tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 33 then--初级锻造石[33,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("equip_forge_Stone1.png"),"Đá Rèn Thô",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 34 then--中级锻造石[34,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("equip_forge_Stone2.png"),"Đá Rèn Trung",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 40 then--超级能晶[40,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_redcrystal.png"),"Năng Tinh siêu cấp",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 35 then--高级锻造石[35,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("equip_forge_Stone3.png"),"Đá Rèn cao cấp",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 41 then--低级命运石[41,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_destinyStone1.png"),"Đá vận mệnh Thô",tempCount   --todo
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 42 then--高级命运石[42,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_destinyStone2.png"),"Đá vận mệnh Trung",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 43 then--超级命运石[43,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_destinyStone3.png"),"Đá vận mệnh cấp",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 44 then--星辰铁[44,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_star_iron.png"),"星辰铁",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 45 then--高级星灵[45,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_xingxing4.png"),"高级星灵",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 47 then--粉钻[46,0,100]
            icon,name,count = CCSprite:createWithSpriteFrameName("fenzuan.png"),"Đá Fancy",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
                --ZWJ<<<<圣石奖励
        elseif rewardType == 46 then--圣石
            icon,name,count,quality = self:getSaintStoneRewardId(tempId,tempCount);


        elseif rewardType == 49 then--法宝  zyz
            icon,name,count,quality = self:createMagicIconByTable(dataTable)
        elseif rewardType == 50 then--命运宝石[46,0,100]
            icon,name,count,quality = self:getFateGemRewardId(tempId,tempCount);
        
        elseif rewardType == 51 then--低级经验丹   [51,0,100]              
            icon,name,count = CCSprite:createWithSpriteFrameName("icon_master_level1.png"),"低级经验丹",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 52 then--中级经验丹 [52,0,100]    
            icon,name,count = CCSprite:createWithSpriteFrameName("icon_master_level2.png"),"中级经验丹",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 53 then--高级经验丹 [53,0,100]           
            icon,name,count = CCSprite:createWithSpriteFrameName("icon_master_level3.png"),"高级经验丹",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 54 then--主角强化石 [54,0,100]           
            icon,name,count = CCSprite:createWithSpriteFrameName("icon_master_strengh.png"),"主角强化石",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end

        elseif rewardType == 59  then --加油罐
            icon,name,count = CCSprite:createWithSpriteFrameName("ui_icon_jiayouguan.png"),"Bình Xăng",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 60 then -- 宇宙币
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_ybi.png"),"Xu vũ trụ",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 511907 then --筛子
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_shaizi.png"),"小骰子",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 511906 then --运气硬币
            icon,name,count = CCSprite:createWithSpriteFrameName("public_icon_duihuan.png"),"运气硬币",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        
        elseif rewardType == 100 then--功勋,占位,数量；[100,0,1]
            icon,name,count = CCSprite:createWithSpriteFrameName("public_medal2.png"),"Huân chương",tempCount
            quality = self:setQualityIcon(icon,rewardType,tempCount)
        elseif rewardType == 117 then--新增卡牌發送方式  增加等級   [117, 4000, 2, 9]   兩張 9 級綠箭俠的獎勵
            icon,name,count = self:getCardRewardId(tempId,tempCount);
        elseif rewardType == 108 then --拓印石
            local equip_gem_fate_stone = getConfig(game_config_field.equip_gem_fate_stone) and json.decode(getConfig(game_config_field.equip_gem_fate_stone):getFormatBuffer()) or {}
            local cfg = equip_gem_fate_stone[tostring(tempId)]
            local iconName = cfg.icon
            icon,name,count = CCSprite:create("icon/"..iconName..".png"),cfg.name_stone,tempCount
            if qualityFlag then
            else
                quality = cfg.level
                self:addIconQualityBgByQuality(icon, quality)
            end
        elseif rewardType == 109 then--点化石
            local _icon = game_util.bloodStonePrint.createIcon(tempId)
            local _name = ""
            if ext.useFullName then
                _name = self.bloodStonePrint.getPrintName(tempId)
            else
                _name = self.bloodStonePrint.getPrintNameLetter(tempId)
            end
            icon,name,count = _icon, _name,tempCount
            if qualityFlag then
            else
                local equip_gem_fate_word = getConfig(game_config_field.equip_gem_fate_word) and json.decode(getConfig(game_config_field.equip_gem_fate_word):getFormatBuffer()) or {}
                local cfg = equip_gem_fate_word[tostring(tempId)]
                quality = cfg.level
                self:addIconQualityBgByQuality(icon, quality)
            end
        elseif rewardType == 106 then--代金券
            icon,name,count = CCSprite:create("icon/public_ticket.png"),"Phiếu giảm giá",tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 111 then -- 神域竞速能量
            icon, name, count = CCSprite:create("icon/th_nl.png"), require("lua/game_pop/game_god_escort_helper").txt.god_escort_txt_26, tempCount
            if qualityFlag then
            else
                quality = self:setQualityIcon(icon,rewardType,tempCount)
            end
        elseif rewardType == 112 then--徽章  zyz
            icon,name,count,quality = self:createBadgeIconByTable(dataTable)
        end 
    end
    if flag == true then
        name = tostring(name) .. (count ~= nil and "×" .. count or "");
    end
    return icon,name,count,rewardType,quality
end

--[[
    获取种子奖励
]]
function M.getSeedItemRewardId( self,tempId,count )
    local seed_cfg = getConfig(game_config_field.seed)
    local itemCfg = seed_cfg:getNodeWithKey(tempId)
    local name = itemCfg:getNodeWithKey("name"):toStr()-- .. (count ~= nil and "×" .. count or "");
    local icon = self:createItemIconByCfg(itemCfg);
    local quality = itemCfg:getNodeWithKey("quality"):toInt();
    return icon, name, count, quality 

end

--[[
    根据rewardType得到颜色
]]
function M.setQualityIcon(self,tempIcon,rewardType,rewardCount)
    -- resoucequality
    if tempIcon then
        local quality = 0;
        rewardType = rewardType or 0;
        rewardCount = rewardCount or 0;
        local resoucequality_cfg = getConfig(game_config_field.resoucequality)
        if resoucequality_cfg then
            local itemCfg = resoucequality_cfg:getNodeWithKey(rewardType)
            if itemCfg then
                for i=0,6 do
                    local tempItemCfg = itemCfg:getNodeWithKey("quailty" .. i)
                    if tempItemCfg and tempItemCfg:getNodeCount() > 1 then
                        if rewardCount >= tempItemCfg:getNodeAt(0):toInt() and rewardCount <= tempItemCfg:getNodeAt(1):toInt() then
                            quality = i;
                            break;
                        end
                    end
                end
            end
        end
        local qualityTab = HERO_QUALITY_COLOR_TABLE[quality+1];
        if tempIcon and qualityTab then
            local tempIconSize = tempIcon:getContentSize();
            local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
            img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img1,-1,-1)
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,1)
        end
        return quality
    end
    return 0;
end

--[[
    查看通用奖励方法  [5,6,7]
]]
function M.lookItemDetal(self,tempTable,goShop,ext)
    local itemDataType = tempTable[1]
    local itemId = tempTable[2]
    local itemCount = tempTable[3]
    if itemDataType == 6 then--道具
        if itemId >= 1000 and itemId < 2000 then--卡牌碎片
            local itemCfg = getConfig(game_config_field.item)
            local exchageCfg = getConfig(game_config_field.exchange)
            local heroId = itemId
            local sortId = itemCfg:getNodeWithKey(heroId):getNodeWithKey("sort"):toStr()
            local changeId = exchageCfg:getNodeWithKey(sortId):getNodeWithKey("change_id"):getNodeAt(0):getNodeAt(1):toStr()
            game_scene:addPop("game_hero_info_pop",{cId = tostring(changeId),openType = 4})
        elseif itemId >= 2000 and itemId < 3000 then--装备碎片
            local itemCfg = getConfig(game_config_field.item)
            local exchageCfg = getConfig(game_config_field.exchange)
            local equipId = itemId
            local sortId = itemCfg:getNodeWithKey(equipId):getNodeWithKey("sort"):toStr()
            local changeId = exchageCfg:getNodeWithKey(sortId):getNodeWithKey("change_id"):getNodeAt(0):getNodeAt(1):toStr()
            local equipData = {lv = 1,c_id = changeId,id = -1,pos = -1}
            game_scene:addPop("game_equip_info_pop",{tGameData = equipData});
        else--道具
            game_scene:addPop("game_item_info_pop",{itemId = itemId,openType = 2,goShop = goShop})
        end
    elseif itemDataType == 7 then--装备
        local equipData = {lv = 1,c_id = itemId,id = -1,pos = -1}
        game_scene:addPop("game_equip_info_pop",{tGameData = equipData});
    elseif itemDataType == 5 then--卡牌
        game_scene:addPop("game_hero_info_pop",{cId = tostring(itemId),openType = 4})
    elseif itemDataType == 19 then--宝石
        game_scene:addPop("gem_system_info_pop",{tGameData = {count = itemCount,c_id = itemId},callBack = nil, openType=1});
    else--查看食物等等
        game_scene:addPop("game_food_info_pop",{itemData = tempTable})
    end
end
--[[--
    通用奖励
]]
function M.rewardTipsByJsonData(self,jsonData,callBackFunc)
    if jsonData == nil then return end
    return self:rewardTipsByDataTable(json.decode(jsonData:getFormatBuffer()),callBackFunc);
end

--[[--
    通用奖励
]]
function M.rewardTipsByDataTable(self,dataTable,callBackFunc,endPos)
    if dataTable == nil then return end
    -- cclog("rewardTipsByDataTable ---------------" .. json.encode(dataTable))
    local count = nil
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/public_res.plist");    
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/public_res_add.plist");    
    local rewardCount = 0;
    local function removeCallFunc()
        rewardCount = rewardCount - 1;
        if rewardCount <= 0 then
            if callBackFunc then
                callBackFunc();
            end
        end
    end
    local function createRewardItem(icon,name)
        local bgSpr = CCSprite:createWithSpriteFrameName("public_reward_item_bg.png")
        local bgSprSize = bgSpr:getContentSize();
        if icon then
            icon:setPosition(ccp(bgSprSize.width*0.4,bgSprSize.height*0.5));
            icon:setScale(0.75);
            bgSpr:addChild(icon);
        end
        local tempLabel
        if name then
            tempLabel = self:createLabelTTF({text = name,color = ccc3(250,180,0),fontSize = 16});
            tempLabel:setPosition(ccp(bgSprSize.width*0.6,bgSprSize.height*0.5));
            bgSpr:addChild(tempLabel);
        end
        if icon and tempLabel then -- 让两个居中
            self:centerTwoNode(icon, tempLabel, bgSprSize.width * 0.5, 5)
        end
        rewardCount = rewardCount + 1;
        self:addMoveTipsByNode(bgSpr,0.5*(rewardCount-1),removeCallFunc);
    end
    local icon,name;
    local super_crystal = dataTable.super_crystal or 0
    if super_crystal ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_redcrystal.png"),"Năng Tinh siêu cấp x" .. super_crystal;
        createRewardItem(icon,name);
    end
    local super_tycoon_medal = dataTable.super_tycoon_medal or 0

    --todo
    if super_tycoon_medal ~= 0 then
        local m_richman_plot = json.decode(getConfig(game_config_field.richman_plot):getFormatBuffer()) 
        icon,name = CCSprite:createWithSpriteFrameName("pubilc_icon_monopoly_medal.png"),"HC×" .. super_tycoon_medal;
        if m_richman_plot["1"].medal_img  then
            icon,name=CCSprite:create("icon/"..m_richman_plot["1"].medal_img..".png"),"HC×" .. super_tycoon_medal;
        end
        createRewardItem(icon,name);
    end

    local food = dataTable.food or 0;
    if food ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_food2.png"),"Thức ăn x" .. food;
        createRewardItem(icon,name);
    end
    local metal = dataTable.metal or 0
    if metal ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_metal2.png"),"Sắt x" .. metal;
        createRewardItem(icon,name);
    end
    local energy = dataTable.energy or 0
    if energy ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_energy2.png"),"Năng Nguyên x" .. energy;
        createRewardItem(icon,name);
    end
    local crystal = dataTable.crystal or 0
    if crystal ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_crystal2.png"),"Năng Tinh x" .. crystal;
        createRewardItem(icon,name);
    end
    local adv_crystal = dataTable.adv_crystal or 0
    if adv_crystal ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_gaojinengjing2.png"),"Năng Tinh cao cấp×" .. adv_crystal;
        createRewardItem(icon,name);
    end
    local coin = dataTable.coin or 0;
    if coin ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_gold2.png"),"Xu x" .. coin;
        createRewardItem(icon,name);
    end
    local dirt_silver = dataTable.dirt_silver or 0;
    if dirt_silver ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_chen_2.png"),"Bụi Cường Năng x" .. dirt_silver;
        createRewardItem(icon,name);
    end
    local dirt_gold = dataTable.dirt_gold or 0;
    if dirt_gold ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_chen_1.png"),"Bụi Siêu Năng x" .. dirt_gold;
        createRewardItem(icon,name);
    end
    local action_point = dataTable.action_point or 0;
    if action_point ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_action_point2.png"),"Thể Lực x" .. action_point;
        createRewardItem(icon,name);
    end
    local arena_point = dataTable.arena_point or 0;
    if arena_point ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_medal2.png"),"Huân Chương x" .. arena_point;
        createRewardItem(icon,name);
    end
    local star = dataTable.star or 0;
    if star ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_xingxing2.png"),"Hồn Sao x" .. star;
        createRewardItem(icon,name);
    end
    local silver = dataTable.silver or 0;
    if silver ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_silver2.png"),"Vàng x" .. silver;
        createRewardItem(icon,name);
    end
    --寵物
    local pet_crystal = dataTable.pet_crystal or 0;
    if pet_crystal ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_crystle2.png"),"Năng Tinh thú nuôi" .. pet_crystal;
        createRewardItem(icon,name);
    end
    local pet_exp_ball = dataTable.pet_exp_ball or 0;
    if pet_exp_ball ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_capsule2.png"),"Bao Con Nhộng" .. pet_exp_ball;
        createRewardItem(icon,name);
    end
    local pet_skill_stone = dataTable.pet_skill_stone or 0;
    if pet_skill_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_pet_stone2.png"),"Đá kỹ năng thú nuôi" .. pet_skill_stone;
        createRewardItem(icon,name);
    end
    local equip_smelting = dataTable.equip_smelting or 0;
    if equip_smelting ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_ronglian_2.png"),"熔炼石×" .. equip_smelting;
        createRewardItem(icon,name);
    end
    local   world_cup_oil = dataTable.world_cup_oil or 0
    if world_cup_oil ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("ui_icon_jiayouguan.png"),"Bình Xăng x" .. world_cup_oil;
        createRewardItem(icon,name);
    end
    local ticket = dataTable.ticket or 0
    if  ticket ~= 0 then
        icon,name = CCSprite:create("icon/public_ticket.png"),"Phiếu giảm giá" .. ticket;
        createRewardItem(icon,name);
    end

    -- 血石-点化石
    local fateWords = {}
    local fate_word = dataTable.fate_word or {}
    for i, v in pairs(fate_word) do
        fateWords[v] = (fateWords[v] or 0) + 1
    end
    for k, v in pairs(fateWords) do
        local _icon = game_util.bloodStonePrint.createIcon(k)
        local _name = game_util.bloodStonePrint.getPrintName(k)
        icon,name = _icon,_name .. v;
        createRewardItem(icon, name);
    end
    -- 血石-拓印石
    local fateStones = {}
    local fate_stone = dataTable.fate_stone or {}
    for i, v in pairs(fate_stone) do
        fateStones[v] = (fateStones[v] or 0) + 1
    end
    for k, v in pairs(fateStones) do
        local _icon = game_util.bloodStoneReborn.createIcon(k)
        local _name = game_util.bloodStoneReborn.getRebornName(k)
        icon,name = _icon,_name .. v;
        createRewardItem(icon, name);
    end
    local fenzuan = dataTable.fenzuan or 0;
    if fenzuan ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("fenzuan.png"),"Đá Fancy x" .. fenzuan;
        createRewardItem(icon,name);
    end

    local highway_power = dataTable.highway_power or 0
    if pet_exp_ball ~= 0 then
        icon, name = CCSprite:create("icon/th_nl.png"), require("lua/game_pop/game_god_escort_helper").txt.god_escort_txt_26
        createRewardItem(icon,name);
    end
    
    --cards
    local cards = dataTable.cards or {};
    local tempId,tempQuality = "-1",-1;
    for k,cardId in pairs(cards) do
        local cardData,heroCfg = game_data:getCardDataById(tostring(cardId));
        if heroCfg then
            name = heroCfg:getNodeWithKey("name"):toStr() .. (count ~= nil and "×" .. count or "×1")
            icon = self:createCardIconByCfg(heroCfg,cardData);
            createRewardItem(icon,name);
            local quality = heroCfg:getNodeWithKey("quality"):toInt();
            if quality > tempQuality then
                tempQuality = quality
                tempId = tostring(cardId);
            end
        end 
    end
    local animFlag = self:addRewardCardAnim(tempId);
    --pet
    local pets = dataTable.pets or {};
    tempId,tempQuality = "-1",-1;
    for k,petId in pairs(pets) do
        local petData,petCfg = game_data:getPetDataById(tostring(petId));
        if petCfg then
            name = petCfg:getNodeWithKey("name"):toStr() .. (count ~= nil and "×" .. count or "×1")
            icon = self:createCardIconByCfg(petCfg,petData);
            createRewardItem(icon,name);
            local quality = petCfg:getNodeWithKey("quality"):toInt();
            if quality > tempQuality then
                tempQuality = quality
                tempId = tostring(cardId);
            end
        end 
    end
    if animFlag == false and tempId ~= "-1" then
        self:addRewardPetAnim(tempId);
    end
    --equip
    local equip = dataTable.equip or {};
    tempId,tempQuality = "-1",-1;
    for k,equipId in pairs(equip) do
        local itemData,itemCfg = game_data:getEquipDataById(tostring(equipId));
        if itemCfg then
            name = itemCfg:getNodeWithKey("name"):toStr() .. (count ~= nil and "×" .. count or "×1")
            icon = self:createEquipIcon(itemCfg);
            createRewardItem(icon,name);
            local quality = itemCfg:getNodeWithKey("quality"):toInt();
            if quality > tempQuality then
                tempQuality = quality
                tempId = tostring(equipId);
            end
        end
    end
    if animFlag == false and tempId ~= "-1" then
        self:addRewardEquipAnim(tempId);
    end
    local item = dataTable.item or {};
    local tempIdTab = {};
    for k,itemCid in pairs(item) do
        if tempIdTab[itemCid] == nil then
            tempIdTab[itemCid] = 1;
        else
            tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        icon,name,count = self:getItemRewardId(itemCid,count);
        createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    end
    local metalcore = dataTable.metalcore or 0
    if metalcore ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_xilian2.png"),"Đá Tinh Luyện x" .. metalcore;
        createRewardItem(icon,name);
    end
    local small_forge_stone = dataTable.small_forge_stone or 0;
    if small_forge_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("equip_forge_Stone1.png"),"Đá Rèn Thô×" .. small_forge_stone;
        createRewardItem(icon,name);
    end
    local middle_forge_stone = dataTable.middle_forge_stone or 0;
    if middle_forge_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("equip_forge_Stone2.png"),"Đá Rèn Trung×" .. middle_forge_stone;
        createRewardItem(icon,name);
    end
    local high_forge_stone = dataTable.high_forge_stone or 0;
    if high_forge_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("equip_forge_Stone3.png"),"Đá Rèn cao cấp×" .. high_forge_stone;
        createRewardItem(icon,name);
    end
    local grace = dataTable.grace or 0;
    if grace ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_shenen_d2.png"),"Thần Ân×" .. grace;
        createRewardItem(icon,name);
    end
    local grace_high = dataTable.grace_high or 0;
    if grace_high ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_shenen_g2.png"),"Thần Ân cao cấp×" .. grace_high;
        createRewardItem(icon,name);
    end
    local enchant = dataTable.enchant or 0;
    if enchant ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_piece2.png"),"Mảnh Ma Quang×" .. enchant;
        createRewardItem(icon,name)
    end
    local refine_stone = dataTable.refine_stone or 0;
    if refine_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_succinct2.png"),"Đá Tẩy Luyện×" .. refine_stone;
        createRewardItem(icon,name);
    end
    local wood = dataTable.wood or 0
    if wood ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_wood2.png"),"Gỗ×" .. wood;
        createRewardItem(icon,name);
    end
    local soul_stone = dataTable.soul_stone or 0
    if soul_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("pubilc_icon_soul_stone2.png"),"Linh Thạch×" .. soul_stone;
        createRewardItem(icon,name);
    end
    local min_fate_stone = dataTable.min_fate_stone or 0
    if min_fate_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_destinyStone1.png"),"Đá vận mệnh Thô×" .. min_fate_stone;
        createRewardItem(icon,name);
    end
    local mid_fate_stone = dataTable.mid_fate_stone or 0
    if mid_fate_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_destinyStone2.png"),"Đá vận mệnh Trung×" .. mid_fate_stone;
        createRewardItem(icon,name);
    end
    local max_fate_stone = dataTable.max_fate_stone or 0
    if max_fate_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_destinyStone3.png"),"Đá vận mệnh siêu cấp×" .. max_fate_stone;
        createRewardItem(icon,name);
    end
    local star_iron = dataTable.star_iron or 0
    if star_iron ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_star_iron.png"),"星辰铁x" .. star_iron;
        createRewardItem(icon,name);
    end
    local senior_star = dataTable.senior_star or 0
    if senior_star ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_xingxing4.png"),"高级星灵x" .. senior_star;
        createRewardItem(icon,name);
    end
    local lushi = dataTable.lushi or 0
    if lushi ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("public_magic_jinghua.png"),"TH-Pháp Bảo×" .. lushi
        createRewardItem(icon,name)
    end

    --主角系统相关道具
    local small_exp  = dataTable.small_exp or 0 --低级经验丹，
    if small_exp ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("icon_master_level1.png"),"低级经验丹×" .. small_exp
        createRewardItem(icon,name)
    end
    local middle_exp = dataTable.middle_exp or 0 --中级经验丹
    if middle_exp ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("icon_master_level2.png"),"中级经验丹×" .. middle_exp
        createRewardItem(icon,name)
    end
    local high_exp = dataTable.high_exp or 0 --高级经验丹
    if high_exp ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("icon_master_level3.png"),"高级经验丹" .. high_exp
        createRewardItem(icon,name)
    end
    local fortified_stone = dataTable.fortified_stone or 0 --主角强化石
    if fortified_stone ~= 0 then
        icon,name = CCSprite:createWithSpriteFrameName("icon_master_strengh.png"),"主角强化石" .. fortified_stone
        createRewardItem(icon,name)
    end

    local universe_coin = dataTable.universe_coin or 0 --宇宙币
    if universe_coin ~= 0 then 
        icon,name = CCSprite:createWithSpriteFrameName("public_icon_ybi.png"),"Xu vũ trụ x" .. universe_coin
        createRewardItem(icon,name)
    end

    local gem = dataTable.gem or {}
    local tempIdTab = {};
    for k,itemCid in pairs(gem) do
        if tempIdTab[itemCid] == nil then
            tempIdTab[itemCid] = 1;
        else
            tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        icon,name,count = self:getGemRewardId(itemCid,count);
        createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    end



    --圣石
    local saintStone = dataTable.god_stone or {}
    local tempIdTab = {};
    for k,itemCid in pairs(saintStone) do
        if tempIdTab[itemCid] == nil then
            tempIdTab[itemCid] = 1;
        else
            tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        icon,name,count = self:getSaintStoneRewardId(itemCid,count);
        createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    end

    --命运宝石
    local gem_fate = dataTable.gem_fate or {}
    local tempIdTab = {};
    for k,itemCid in pairs(gem_fate) do
        if tempIdTab[itemCid] == nil then
            tempIdTab[itemCid] = 1;
        else
            tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        icon,name,count = self:getFateGemRewardId(itemCid,count);
        createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    end

    --勋章
    local medal = dataTable.medal or {}
    local tempIdTab = {};
    for k,itemCid in pairs(medal) do
        if tempIdTab[itemCid] == nil then
            tempIdTab[itemCid] = 1;
        else
            tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        icon,name = self:createMedalIconById(itemCid)
        count = count
        createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    end
    --勋章材料
    local material = dataTable.material or {}
    local tempIdTab = {};
    for k,itemCid in pairs(material) do
        if tempIdTab[itemCid] == nil then
            tempIdTab[itemCid] = 1;
        else
            tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        icon,name = self:createMaterialIconById(itemCid)
        count = count
        createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    end

    -- 法宝
    local talisman = dataTable.talisman
    local tempIdTab = {}
    if talisman then
        for k,itemCid in pairs(talisman) do
            if tempIdTab[itemCid] == nil then
                tempIdTab[itemCid] = 1;
            else
                tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
            end
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        icon,name = self:createTalismanIconById(itemCid)
        count = count
        createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    end

    -- 徽章
    local badges = dataTable.badges
    local tempIdTab = {}
    if badges then
        for k,itemCid in pairs(badges) do
            if tempIdTab[itemCid] == nil then
                tempIdTab[itemCid] = 1;
            else
                tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
            end
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        icon,name = self:createBadgeIconById(itemCid)
        count = count
        createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    end
    
    -- 种子
    local seed = dataTable.seed
    local tempIdTab = {}
    if seed then
        for k,itemCid in pairs(seed) do
            if tempIdTab[itemCid] == nil then
                tempIdTab[itemCid] = 1;
            else
                tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
            end
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        icon,name = self:getSeedItemRewardId(itemCid)
        count = count
        createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    end
    
    --英魂
    -- local soul = dataTable.soul or {}
    -- local tempIdTab = {};
    -- for k,itemCid in pairs(soul) do
    --     if tempIdTab[itemCid] == nil then
    --         tempIdTab[itemCid] = 1;
    --     else
    --         tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
    --     end
    -- end
    -- for itemCid,count in pairs(tempIdTab) do
    --     local itemData,itemCfg = game_data:getSoulDataById(tostring(itemCid));
    --     icon,name = self:createSoulIcon(itemCfg)
    --     count = count
    --     createRewardItem(icon,name .. (count ~= nil and "×" .. count or "×1"))
    -- end
    if rewardCount == 0 then
        if callBackFunc then
            callBackFunc();
        end
    end


    return rewardCount;
end

function M.createPetSkillIconByCid(self,cid,avail)
    local skill_detail_cfg = getConfig(game_config_field.pet_skill_detail);
    local itemCfg = skill_detail_cfg:getNodeWithKey(tostring(cid));
    if itemCfg == nil then 
        return nil,nil 
    end
    return self:createSkillIconByCfg(itemCfg,avail),itemCfg:getNodeWithKey("skill_name"):toStr();
end

--[[
    主角属性升级加成
]]
function M.getRolePropertryValue( self )
    local rolePropertryValueTab = {0,0,0,0,0}
    local userStatusData = game_data:getUserStatusData();
    local role_attri_level = 0
    if  userStatusData.role_attri_level then
        role_attri_level = userStatusData.role_attri_level    else
    end
    local role_attri_add_cfg = getConfig(game_config_field.role_attri_add)
    if role_attri_add_cfg then
        role_attri_add_cfg = json.decode(role_attri_add_cfg:getFormatBuffer()) or {}
        if role_attri_add_cfg[tostring(role_attri_level)] then
            local valueTab = role_attri_add_cfg[tostring(role_attri_level)].skill_add
            for k,v in pairs(valueTab) do
                rolePropertryValueTab[v[1]] = v[2]
            end
        end
    end
    return rolePropertryValueTab
    -- body
end
--[[
    寵物屬性加成
]]
function M.getPetCombatValue(self,posIndex)
    -- cclog2(posIndex,"posIndex")
    local petAttrValueTab = {0,0,0,0,0}
    local petData,petCfg = game_data:getPetTeamCardDataByPos(1)--只取第一個的
    -- cclog2(game_data:getPetTeamData())
    if petData and petCfg then
        -- cclog2(petData,"petData")
        -- local attrValueTab = {petData.patk_crystal,petData.matk_crystal,petData.def_crystal,petData.speed_crystal,petData.hp_crystal}
        -- local attrCfg = {"add_patk","add_matk","add_def","add_speed","add_hp"}

        -- for i=1,5 do
        --     local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. i] or {}
        --     local attrValue = petData[abilityItem.attrName or ""] or 0
        --     --屬性改造等級轉成值
        --     if attrValueTab[i] > 0 then--改造屬性大於1
        --         local pet_strengthen = getConfig(game_config_field.pet_strengthen)
        --         local itemStreng = pet_strengthen:getNodeWithKey(tostring(attrValueTab[i]))
        --         attrValueTab[i] = itemStreng:getNodeWithKey(attrCfg[i]):toInt()
        --     end
        -- end
        petAttrValueTab[1] = petAttrValueTab[1] + petData.patk-- + attrValueTab[1]
        petAttrValueTab[2] = petAttrValueTab[2] + petData.matk-- + attrValueTab[2]
        petAttrValueTab[3] = petAttrValueTab[3] + petData.def-- + attrValueTab[3]
        petAttrValueTab[4] = petAttrValueTab[4] + petData.speed-- + attrValueTab[4]
        petAttrValueTab[5] = petAttrValueTab[5] + petData.hp-- + attrValueTab[5]
    end
    return petAttrValueTab
end
--[[
    添加技能
]]
function M.setSkillInfo(self,skillItemData,skillItemCfg,iconNode,namePosType)
    if skillItemData and skillItemCfg and iconNode then
        -- 'avail': 1   # 0表示未解锁，1表示解锁未激活，2表示激活
        local avail = skillItemData.avail;
        local icon_size = iconNode:getContentSize();
        local skill_icon_spr = game_util:createSkillIconByCfg(skillItemCfg,avail);
        if skill_icon_spr then
            skill_icon_spr:setPosition(ccp(icon_size.width*0.5,icon_size.height*0.5));
            iconNode:addChild(skill_icon_spr);
        end
        local lvLabel = nil;
        local tempLabel = nil;
        if avail ~= 2 then
            local lock_icon_spr = CCSprite:createWithSpriteFrameName("public_lock_icon.png");
            -- lock_icon_spr:setOpacity(150);
            lock_icon_spr:setPosition(icon_size.width*0.5,icon_size.height*0.5);
            iconNode:addChild(lock_icon_spr,5,5);
            -- skill_icon_spr:setColor(ccc3(155,155,155));
            -- local lockLabel = CCLabelTTF:create("未解锁",TYPE_FACE_TABLE.Arial_BoldMT,8);
            -- lockLabel:setColor(ccc3(155,155,155));
            -- lockLabel:setPosition(ccp(icon_size.width*0.5,icon_size.height*0.5));
            -- bottomNode:addChild(lockLabel);
        -- elseif avail == 1 then
        --     skill_icon_spr:setColor(ccc3(155,155,155));
        --     tempLabel:setString("未激活")`
        else
        end
        lvLabel = self:createLabel({text = "Lv." .. skillItemData.lv,color = ccc3(255, 255, 0)})
        lvLabel:setPosition(ccp(icon_size.width*0.5,icon_size.height*0.15));
        iconNode:addChild(lvLabel,10,10);
        -- tempLabel = self:createLabel({text = skillItemCfg:getNodeWithKey("skill_name"):toStr()})
        tempLabel = self:createLabelTTF({text = skillItemCfg:getNodeWithKey("skill_name"):toStr()})
        if namePosType == nil or namePosType == 1 then
            tempLabel:setPosition(ccp(icon_size.width*0.5,-icon_size.height*0.1));
        else
            tempLabel:setPosition(ccp(icon_size.width*0.5,icon_size.height*1.1));
        end
        iconNode:addChild(tempLabel,10,11);
        return skill_icon_spr,lvLabel,tempLabel
    end
end
--[[--
    写错误信息
]]
function M.writeErrorMessage(self,msg)
    local writablePath = CCFileUtils:sharedFileUtils():getWritablePath();
    local fullpath = writablePath .. "errorMsg.temp";
    util.writeFile(fullpath,"\ntime=" .. os.date() .. " : " .. msg,"a");
end

--[[--
    写战斗数据
]]
function M.writeBattleData(self,msg)
    -- local writablePath = CCFileUtils:sharedFileUtils():getWritablePath();
    -- util.writeFile(writablePath .. "battleData" .. os.date() ..".temp",msg);
end

function M.createItemIconByCid(self,cid,showImg1)
    local config_date = getConfig(game_config_field.item);
    local itemCfg = config_date:getNodeWithKey(tostring(cid));
    if itemCfg == nil then return nil,nil end
    return self:createItemIconByCfg(itemCfg,showImg1),itemCfg:getNodeWithKey("name"):toStr();
end

--创建物品图标
function M.createItemIconByCfg(self,itemCfg,showImg1)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_public_iconcer.plist")
    local tempIcon = nil;
    if itemCfg then
        showImg1 = showImg1 == nil and true or showImg1;
        tempIcon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr());
        local shade = itemCfg:getNodeWithKey("shade"):toStr();
        local quality = itemCfg:getNodeWithKey("quality"):toInt();
        local qualityTab = HERO_QUALITY_COLOR_TABLE[quality+1];
        if tempIcon and qualityTab then
            local tempIconSize = tempIcon:getContentSize();
            if showImg1 == true then
                local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
                img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
                tempIcon:addChild(img1,-1,-1)
            end
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,1)
        end
        if tempIcon and shade ~= "" then
            shade = game_util:getResName(shade);
            local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tostring(shade) .. ".png");
            if tempSpriteFrame then
                local shadeSpr = CCSprite:createWithSpriteFrame(tempSpriteFrame);
                local tempSize = tempIcon:getContentSize();
                shadeSpr:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5));
                tempIcon:addChild(shadeSpr,10);
            end
        end
    end
    return tempIcon;
end

function M.createLeaderSkillIconByCid(self,cid,treeId,openFlag)
    local leader_skill_cfg = getConfig(game_config_field.leader_skill)
    local itemCfg = leader_skill_cfg:getNodeWithKey(tostring(cid));
    return self:createLeaderSkillIconByCfg(itemCfg,treeId,openFlag);
end

function M.createLeaderSkillIconByCfg(self,itemCfg,treeId,openFlag)
    local tempIcon = nil;
    if treeId == nil then
        local skillIdTreeTab = game_data:getSkillIdTreeTab() or {};
        treeId = skillIdTreeTab[tostring(cid)] or 1;
    end
    if openFlag == nil then
        openFlag = false;
    end
    local is_positive = 0;
    if itemCfg then
        tempIcon = game_util:createIconByName(itemCfg:getNodeWithKey("icon"):toStr());
        if tempIcon then
            local tempSize = tempIcon:getContentSize();
            local treeBg = game_util:createIconByName(LEADER_SKILL_TREE_TABLE[tonumber(treeId)].iconBg);
            if treeBg then
                treeBg:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5));
                tempIcon:addChild(treeBg,-1,-1);
            end
            is_positive = itemCfg:getNodeWithKey("is_positive"):toInt()--0被动技能  1主动技能 
            local skillIconUp = nil;
            if not openFlag then--未开启
                tempIcon:setColor(ccc3(54,54,54));
                if is_positive == 1 then
                    skillIconUp = CCSprite:createWithSpriteFrameName("public_skillActionDark.png")
                else
                    skillIconUp = CCSprite:createWithSpriteFrameName("public_skillNormalDark.png")
                end
            else--开启
                if is_positive == 1 then
                    skillIconUp = CCSprite:createWithSpriteFrameName("public_skillAction.png")
                else
                    skillIconUp = CCSprite:createWithSpriteFrameName("public_skillNormal.png")
                end
            end
            if skillIconUp then
                skillIconUp:setPosition(ccp(tempSize.width*0.5,tempSize.height*0.5));
                tempIcon:addChild(skillIconUp,1,1);
            end
        end
    end
    return tempIcon,is_positive;
end

function M.createIconByName(self,iconName,quality)
    iconName = self:getResName(iconName);
    local tempIcon = CCSprite:create("icon/" .. iconName .. ".png");
    if tempIcon == nil then
        tempIcon = CCSprite:create("icon/" .. iconName .. ".jpg");
    end

    if tempIcon == nil then
        tempIcon = CCSprite:create("icon/icon_bg_zuzhou.png");
    end
    cclog("jinlaile  me  ? ")
    cclog2(quality,"quality-=--------")
    cclog2(tempIcon,"tempIcon-=--------")

    if quality and tempIcon then

        local qualityTab = HERO_QUALITY_COLOR_TABLE[quality]

        cclog2(qualityTab,"qualityTab-=------------")
        cclog2(quality,"quality-=------------")
        if qualityTab then
            local tempIconSize = tempIcon:getContentSize();
            local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
            img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img1,-1,1)
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,2)
        end
    end
    return tempIcon;
end

function M.addIconQualityBgByQuality(self,tempIcon,quality)
    quality = quality or 1;
    local qualityTab = HERO_QUALITY_COLOR_TABLE[quality];
    if tempIcon and qualityTab then
        local tempIconSize = tempIcon:getContentSize();
        local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
        img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
        tempIcon:addChild(img1,-1,1)
        local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
        img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
        tempIcon:addChild(img2,1,2)
    end
end

function M.getResName(self,iconName)
    iconName = tostring(iconName);
    local firstValue,_ = string.find(iconName,".png");
    if firstValue then
        iconName = string.sub(iconName,0,firstValue-1);
    end
    local firstValue,_ = string.find(iconName,".jpg");
    if firstValue then
        iconName = string.sub(iconName,0,firstValue-1);
    end
    return iconName;
end

function M.createSkillIconByCid(self,cid,avail)
    local skill_detail_cfg = getConfig(game_config_field.skill_detail);
    local itemCfg = skill_detail_cfg:getNodeWithKey(tostring(cid));
    if itemCfg == nil then 
        return nil,nil 
    end
    return self:createSkillIconByCfg(itemCfg,avail),itemCfg:getNodeWithKey("skill_name"):toStr();
end

function M.createSkillIconByCfg(self,itemCfg,avail)
    avail = avail or 2;
    local tempIcon = nil;
    if itemCfg then
        local skill_icon = itemCfg:getNodeWithKey("skill_icon"):toStr();
        -- cclog(skill_icon)
        tempIcon = self:createIconByName(skill_icon);
    end
    if tempIcon then
        local skill_quality = itemCfg:getNodeWithKey("skill_quality"):toInt()+1;
        cclog("skill_quality ==================" .. skill_quality)
        local qualityTab = HERO_QUALITY_COLOR_TABLE[skill_quality];
        if qualityTab then
            local tempIconSize = tempIcon:getContentSize();
            local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
            img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img1,-1,1)
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,2)
            if avail ~= 2 then
                img1:setColor(ccc3(151, 151, 151))
                img2:setColor(ccc3(151, 151, 151))
                tempIcon:setColor(ccc3(151, 151, 151))
            end
        end
    end
    return tempIcon;
end


function M.openAlertView(self,t_params)
    require("game_ui.game_pop_up_box").show(t_params);
end

function M.closeAlertView(self)
    require("game_ui.game_pop_up_box").close(); 
end

function M.setLabelTTFStroke(self,label,tintColor,strokeColor,strokeSize)
    if label == nil then return end
    tintColor = tintColor or ccc3(255, 255, 255);
    strokeColor = strokeColor or ccc3(0, 0, 0);
    strokeSize = strokeSize or 0.5;
    setLabelTTFStroke(label,tintColor,strokeColor,strokeSize);
end

function M.createProgressTimer(self,t_params)
    t_params = t_params or {};
    t_params.fileName = t_params.fileName or "o_public_skillExpAdd.png";
    t_params.percentage = t_params.percentage or 0;
    t_params.midpoint = t_params.midpoint or ccp(0,0);
    t_params.barChangeRate = t_params.barChangeRate or ccp(1, 0);
    t_params.type = t_params.type or kCCProgressTimerTypeBar;
    local tempSprite = CCSprite:createWithSpriteFrameName(t_params.fileName)
    local bar = nil;
    if tempSprite then
        bar = CCProgressTimer:create(tempSprite);
        bar:setMidpoint(t_params.midpoint);
        bar:setBarChangeRate(t_params.barChangeRate);
        bar:setType(t_params.type);
        bar:setPercentage(t_params.percentage);
    end
    return bar;
end

function M.createLabel(self,t_params)
    t_params = t_params or {};
    if t_params.lableType == nil or t_params.lableType == "bmfont" then
        return self:createLabelBMFont(t_params);
    else
        return self:createLabelTTF(t_params);
    end
end

function M.createLabelBMFont(self,t_params)
    t_params = t_params or {};
    t_params.fnt = t_params.fnt or "chinese_character.fnt";
    t_params.text = t_params.text or "";
    t_params.color = t_params.color or ccc3(255,255,255)
    t_params.scale = t_params.scale or 1
    local tempLabel = CCLabelBMFont:create(t_params.text,t_params.fnt);
    tempLabel:setColor(t_params.color);
    tempLabel:setScale(t_params.scale);
    return tempLabel;
end

function M.createLabelTTF(self,t_params)
    t_params = t_params or {};
    t_params.text = t_params.text or "";
    t_params.color = t_params.color or ccc3(255,255,255)
    t_params.scale = t_params.scale or 1;
    t_params.fontSize = t_params.fontSize or 10;
    local tempLabel = CCLabelTTF:create(t_params.text,TYPE_FACE_TABLE.Arial_BoldMT,t_params.fontSize);
    tempLabel:setColor(t_params.color);
    tempLabel:setScale(t_params.scale);
    return tempLabel;
end


function M.createRichLabelTTF(self,params)
    params = params or {};
    params.text = params.text or "";
    params.fontSize = params.fontSize or 10;
    params.fontName = params.fontName or "Arial-BoldMT";
    params.color = params.color or ccc3(255,255,255)
    local richLabelTTF = nil;
    if params.textAlignment and params.verticalTextAlignment and params.dimensions then
        richLabelTTF = CCRichLabelTTF:create(params.text,params.fontName,params.fontSize,params.dimensions,params.textAlignment,params.verticalTextAlignment);
    elseif params.textAlignment and params.verticalTextAlignment == nil and params.dimensions then
        richLabelTTF = CCRichLabelTTF:create(params.text,params.fontName,params.fontSize,params.dimensions,params.textAlignment);
    else
        richLabelTTF = CCRichLabelTTF:create(params.text,params.fontName,params.fontSize);
    end
    richLabelTTF:setColor(params.color);
    return richLabelTTF;
end

function M.setNpcImg(self,npcSpr,flipX)
    if npcSpr == nil then return end
    flipX = flipX == nil and false or true;
    local bigImg = self:createOwnBigImg();
    if bigImg then
        npcSpr:setDisplayFrame(bigImg:displayFrame());
        npcSpr:setFlipX(flipX)
        npcSpr:setScale(0.75);
    end
end

function M.createPlayerRoleAnim(self,animFile,rhythm)
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        animNode:playSection(theLabelName);
    end
    local mAnimNode = zcAnimNode:create(animFile .. ".swf.sam", 0, animFile.. ".plist");
    if mAnimNode == nil then
        animFile = "role_soldier";
        mAnimNode = zcAnimNode:create(animFile .. ".swf.sam", 0, animFile.. ".plist");
    end
    if mAnimNode then
        mAnimNode:setAnchorPoint(ccp(0.5,0.5));
        mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
        mAnimNode:playSection("xiazuoD");
        mAnimNode:setRhythm(rhythm);
        -- mAnimNode:setScale(0.5);
    end
    return mAnimNode
end

function M.createOwnRoleAnim(self)
    local tempAnim = nil;
    local animName = nil;
    local roleId = game_data:getUserStatusDataByKey("role")
    local role_detail_cfg = getConfig(game_config_field.role_detail);
    -- cclog("roleId ========================" .. tostring(roleId));
    local itemCfg = role_detail_cfg:getNodeWithKey(tostring(roleId))
    if itemCfg then
        animName = itemCfg:getNodeWithKey("animation"):toStr();
    else
        animName = "role_soldier";
    end
    return self:createPlayerRoleAnim(animName,1);
end

function M.createOwnBigImg(self)
    local roleId = game_data:getUserStatusDataByKey("role")
    local role_detail_cfg = getConfig(game_config_field.role_detail);
    -- cclog("roleId ========================" .. tostring(roleId));
    local itemCfg = role_detail_cfg:getNodeWithKey(tostring(roleId))
    return self:createPlayerBigImgByCfg(itemCfg);
end

function M.createOwnBigImgHalf(self)
    local roleId = game_data:getUserStatusDataByKey("role")
    local role_detail_cfg = getConfig(game_config_field.role_detail);
    -- cclog("roleId ========================" .. tostring(roleId));
    local itemCfg = role_detail_cfg:getNodeWithKey(tostring(roleId))
    return self:createPlayerBigImgByCfg(itemCfg,"_half");
end

function M.createRoleBigImgHalf( self, roleId )
    local role_detail_cfg = getConfig(game_config_field.role_detail);
    -- cclog("roleId ========================" .. tostring(roleId));
    local itemCfg = role_detail_cfg:getNodeWithKey(tostring(roleId))
    return self:createPlayerBigImgByCfg(itemCfg,"_half");
end


function M.createPlayerBigImgByRoleId(self,roleId,extStr)
    local role_detail_cfg = getConfig(game_config_field.role_detail);
    -- cclog("roleId ========================" .. tostring(roleId));
    local itemCfg = role_detail_cfg:getNodeWithKey(tostring(roleId))
    return self:createPlayerBigImgByCfg(itemCfg,extStr);
end

function M.createPlayerBigImgByCfg(self,itemCfg,extStr)
    local temp_big_img = nil;
    if itemCfg then
        extStr = extStr or "";
        local img = itemCfg:getNodeWithKey("img"):toStr();
        img = self:getResName(img);
        cclog("img ========================" .. img);
        temp_big_img = CCSprite:create("humen/" .. img .. extStr .. ".png");
    end
    return temp_big_img;
end

function M.createPlayerBattleImgRoleId(self,roleId)
    local role_detail_cfg = getConfig(game_config_field.role_detail);
    cclog("roleId ========================" .. roleId);
    local itemCfg = role_detail_cfg:getNodeWithKey(tostring(roleId))
    return self:createPlayerBattleImgByCfg(itemCfg);
end

function M.createPlayerBattleImgByCfg(self,itemCfg)
    local temp_img = nil;
    if itemCfg then
        local battle_icon = itemCfg:getNodeWithKey("battle_icon"):toStr()
        battle_icon = self:getResName(battle_icon);
        temp_img = CCSprite:create("humen/" .. battle_icon .. ".png");
    end
    return temp_img;
end

function M.createPlayerIconByRoleId(self,roleId)
    local role_detail_cfg = getConfig(game_config_field.role_detail);
    -- cclog("roleId ========================" .. roleId);
    local itemCfg = role_detail_cfg:getNodeWithKey(tostring(roleId))
    return self:createPlayerIconByCfg(itemCfg);
end

function M.createPlayerIconByCfg(self,itemCfg)
    local temp_icon = nil;
    if itemCfg then
        local icon = self:getResName(itemCfg:getNodeWithKey("icon"):toStr());
        temp_icon = CCSprite:create("humen/" .. icon .. "_b.png")
    end
    return temp_icon;
end

--[[--
    通过卡牌配置创建卡牌全身像
]]
function M.createCardImgByCfg(self,itemConfig)
    if itemConfig == nil then return nil end
    local animation = itemConfig:getNodeWithKey("animation"):toStr();
    local rgb = itemConfig:getNodeWithKey("rgb_sort"):toInt();
    return self:createImgByName("image_" .. animation,rgb,nil,nil,1,itemConfig)
end
--[[--
    通过通过名字创建卡牌全身像
]]
function M.createImgByName(self,fileName,rgb_sort,anim_flag,bFlipX,wake_lv,heroCfg)
    wake_lv = wake_lv or 0
    heroCfg = heroCfg or nil
    rgb_sort = rgb_sort or 0;
    fileName = self:getResName(fileName);
    local tempImg = CCSprite:create("img/" .. fileName .. ".png");
    if tempImg then
        if bFlipX ~= nil then
            tempImg:setFlipX(bFlipX);
        end
        if rgb_sort == 1 then
            tempImg:setColor(ccc3(47,255,118));
        elseif rgb_sort == 2 then
            tempImg:setColor(ccc3(67,117,253));
        elseif rgb_sort == 3 then
            tempImg:setColor(ccc3(171,65,255));
        end

        local effectFileName = string.sub(fileName,7)
        -- cclog("effectFileName ========= " .. effectFileName)
        local tempSize = tempImg:getContentSize();
        anim_flag = anim_flag == nil and true or anim_flag;
        -- cclog("fileName == " .. fileName)
        -- cclog("anim_flag = " .. tostring(anim_flag))

        if anim_flag == true then
            -- local effectNode = self:createUniversalAnim({animFile = effectFileName .. "_action1",loopFlag = true});
            -- if effectNode then
            --     effectNode:setRhythm(1);
            --     effectNode:setPosition(ccp(tempSize.width*0.5, 20))
            --     if bFlipX ~= nil then
            --         effectNode:setFlipX(bFlipX);
            --     end
            --     tempImg:addChild(effectNode,1)
            -- end
            -- local effectNode = self:createUniversalAnim({animFile = effectFileName .. "_action2",loopFlag = true});
            -- if effectNode then
            --     effectNode:setRhythm(1);
            --     effectNode:setPosition(ccp(tempSize.width*0.5, 20))
            --     if bFlipX ~= nil then
            --         effectNode:setFlipX(bFlipX);
            --     end
            --     tempImg:addChild(effectNode,-1)
            -- end

            --总共有7层
            local wake_table = {"wake1","wake2","wake3","wake4","wake5","wake6","wake6","wake6","wake6","wake6","wake6"}
            local layer_table = {4,3,2,1,-1,-2,-3,-4,-5}--层级关系表
            if heroCfg and wake_table[wake_lv+1] then
                local itemWakeCfg = heroCfg:getNodeWithKey(wake_table[wake_lv+1])
                if itemWakeCfg then
                    local effectImg = itemWakeCfg:getNodeAt(0)
                    if effectImg then
                        for i=1,effectImg:getNodeCount() do
                            local fileName = effectImg:getNodeAt(i-1):toStr()
                            local splitTab = util.stringSplit(fileName,"_");
                            local lastStr = splitTab[#splitTab]
                            local layer = layer_table[tonumber(lastStr)]
                            local effectNode = self:createUniversalAnim({animFile = fileName,loopFlag = true});
                            if effectNode then
                                effectNode:setRhythm(1);
                                effectNode:setPosition(ccp(tempSize.width*0.5, 20))
                                if bFlipX ~= nil then
                                    effectNode:setFlipX(bFlipX);
                                end
                                tempImg:addChild(effectNode,layer)
                            end
                        end
                    end
                end
            end
        end
    end
    return tempImg;
end

function M.getCardUserLockFlag(self,itemData)
    local lockFlag = false;
    if itemData and itemData.remove_avail then
        for k,v in pairs(itemData.remove_avail) do
            if tostring(v) == "user" then
                lockFlag = true;
                break;
            end
        end
    end
    return lockFlag;
end

-- 出征卡
function M.getCarddispatchFlag(self,itemData)
    local lockFlag = false;
    if itemData and itemData.remove_avail then
        for k,v in pairs(itemData.remove_avail) do
            if tostring(v) == "dispatch" then
                lockFlag = true;
                break;
            end
        end
    end
    return lockFlag;
end
--[[
    判断是否在训练中
]]
function M.getCardTrainingFlag(self,itemData)
    local trainingFlag = false;
    if itemData and itemData.remove_avail then
        for k,v in pairs(itemData.remove_avail) do
            if tostring(v) == "train" then
                trainingFlag = true;
                break;
            end
        end
    end
    return trainingFlag;
end

function M.getCardLockFlag(self,itemData)
    local lockFlag = false;
    if itemData and itemData.remove_avail and #itemData.remove_avail > 0 then
        lockFlag = true;
    end
    return lockFlag;
end
--[[
    通过id获取自己伙伴的扩展属性
]]
function M.getOwnCardAttrValueByCardId(self,cardId)
    local heroData,_ = game_data:getCardDataById(cardId)
    local commanderData = game_data:getCommanderAttrsData();
    local posIndex = game_data:getHeroInTeamIndexById(cardId);
    local posGemData,posEquipData,posSoulData,saintStoneData = {},{},{},{}
    local medalPosData = game_data:getMedalPos() or {}
    local soulPosData = game_data:getSoulPos()
    local saintStonelPosData=game_data:getSaintStonePosData() or {};
    if posIndex > 0 then
        local equipPosData = game_data:getEquipPosData() or {};
        local gemPosData = game_data:getGemPosData() or {};
        posGemData = gemPosData[tostring(posIndex-1)] or {}
        posEquipData = equipPosData[tostring(posIndex-1)] or {}
        --还有勋章属性伤害
        posMedalData = medalPosData[tostring(posIndex-1)] or {}
        --加英魂属性伤害
        posSoulData = soulPosData[tostring(posIndex-1)] or {}

        saintStoneData=saintStonelPosData[tostring(posIndex-1)] or {}

    end
    return self:getCardAttrValueByData(heroData,posEquipData,posGemData,commanderData,nil,posMedalData,posSoulData,saintStoneData) or {}
    -- return self:getCardAttrValueByData(heroData,posEquipData,posGemData,commanderData) or {}
end

--[[
    
]]
function M.getOtherCardAttrValueByCardId(self, posIndex, heroData,  playerData)

    local commanderData = nil

    local posGemData,posEquipData = {},{};
    if posIndex > 0 then
        local equipPosData = playerData:getEquipPosData() or {};
        local gemPosData = playerData:getGemPosData() or {};
        posGemData = gemPosData[tostring(posIndex-1)] or {}
        posEquipData = equipPosData[tostring(posIndex-1)] or {}

        local medalPosData = playerData:getMedalPosData() or {};
        local posMedalData =  medalPosData[tostring(posIndex-1)] or {}
    end
    local equipData = playerData:getEquipData()
    return self:getCardAttrValueByData(heroData,posEquipData,posGemData,commanderData, equipData,posMedalData) or {}
end

--[[
    获取卡牌的扩展属性
]]
function M.getCardAttrValueByData(self,cardData,posEquipData,posGemData,commanderData,equipDataAll,posMedalData,posSoulData,saintStoneData)
    local attrValueTab = {fire = 0,water = 0,wind = 0,earth = 0,fire_dfs = 0,water_dfs = 0,wind_dfs = 0,earth_dfs = 0}
    --装备扩展属性
    local attrValueTabExt = {};
    local equipCfg = getConfig(game_config_field.equip);
    local equipPosItemData = posEquipData or {}
    local suitTab = {};
    for k,v in pairs(equipPosItemData) do
        v = tostring(v)
        if v ~= "0" then
            equipData,equipCfg = game_data:getEquipDataById(v);
            if equipData and equipCfg then
                local suit = equipCfg:getNodeWithKey("suit"):toInt();
                if suitTab[suit] == nil then
                    suitTab[suit] = 0;
                    local _,_,_,tempAttrValueTabExt = self:getEquipSuit(suit,equipPosItemData,equipDataAll);
                    attrValueTabExt = tempAttrValueTabExt or {};
                end
                if equipData.is_enchant == true then--装备的八种新属性
                    local atts = equipData.atts or {}
                    for k,v in pairs(atts) do
                        if attrValueTab[k] then
                            attrValueTab[k] = attrValueTab[k] + v;
                        end
                    end
                end
            end
        end
    end
    --宝石扩展属性
    local gemCfg = getConfig(game_config_field.gem);
    local gemPosItemData = posGemData or {}
    for k,v in pairs(gemPosItemData) do
        local gemLv,gemId = self:getRealGemLvAndCid(tostring(v)) --changedBy ZJR
        local itemCfg = gemCfg:getNodeWithKey(tostring(gemId))
        if itemCfg then
            local ability = itemCfg:getNodeWithKey("ability"):toInt();
            local value = itemCfg:getNodeWithKey("value"):toInt();
            local curValue1,curValue2 = game_util:getGemAttrByLv(gemLv, itemCfg:getNodeWithKey("ability"):toInt())
            local tempItemData = PUBLIC_ABILITY_TABLE["ability_" .. ability];
            if ability > 6 and tempItemData then
                attrValueTab[tempItemData.attrName] = attrValueTab[tempItemData.attrName] + value + curValue1
            end
            local ability2 = itemCfg:getNodeWithKey("ability2")
            if ability2 then
                ability2 = ability2:toInt();
                local value2 = itemCfg:getNodeWithKey("value2"):toInt();
                local tempItemData = PUBLIC_ABILITY_TABLE["ability_" .. ability2];
                if ability2 > 6 and tempItemData then
                    attrValueTab[tempItemData.attrName] = attrValueTab[tempItemData.attrName] + value2 + curValue2
                end
            end
        end
    end
    --统帅能力扩展属性
    local commander_attrs = commanderData or {}
    local commander_type_cfg = getConfig(game_config_field.commander_type);
    for k,v in pairs(COMBAT_ABILITY_TABLE.commander_attr_ext) do
        local commander_attrs_item = commander_attrs[k]
        if commander_attrs_item then
            local tempItemCfg = commander_type_cfg:getNodeWithKey(tostring(commander_attrs_item.lv))
            local tempValue = tempItemCfg:getNodeWithKey("add_" .. v)
            if tempValue then
                attrValueTab[v] = attrValueTab[v] + tempValue:toInt();
            end
        end
    end
    --卡牌扩展属性
    cardData = cardData or {}
    for k,v in pairs(attrValueTab) do
        if attrValueTabExt[k] then
            attrValueTab[k] = attrValueTab[k] + attrValueTabExt[k];
        end
        if cardData[k] then
            attrValueTab[k] = attrValueTab[k] + cardData[k];
        end
    end
    --勋章扩展属性
    posMedalData = posMedalData or {}
    -- cclog2(posMedalData,"posMedalData")
    local medalCfg = getConfig(game_config_field.medal)
    for k,v in pairs(posMedalData) do
        if v ~= "0" then
            local itemCfg = medalCfg:getNodeWithKey(tostring(v))
            local effect = itemCfg:getNodeWithKey("effect")
            for i=1,effect:getNodeCount() do
                local itemEffect = effect:getNodeAt(i-1)
                local ability = itemEffect:getNodeAt(0):toInt()
                local value = itemEffect:getNodeAt(1):toInt()
                if ability > 6 then--只取大于6的扩展属性
                    local tempItemData = PUBLIC_ABILITY_TABLE["ability_" .. ability];
                    attrValueTab[tempItemData.attrName] = attrValueTab[tempItemData.attrName] + value
                end
            end
        end
    end
    --英魂扩展属性
    posSoulData = posSoulData or {}
    local soulCfg = getConfig(game_config_field.soul_detail)
    local allSoulData = game_data:getSoulData()
    for k,v in pairs(posSoulData) do
        if v ~= "0" and v ~= "-1" then
            local itemSoulData = allSoulData[v]
            local s_id = itemSoulData.s_id
            local itemCfg = soulCfg:getNodeWithKey(tostring(s_id));
            if itemCfg then
                local value = itemCfg:getNodeWithKey("value"):toInt()
                local ability = itemCfg:getNodeWithKey("ability"):toInt()
                if ability > 200 then--只取大于200的属性伤害
                    local tempItemData = PUBLIC_ABILITY_TABLE["ability_" .. ability];
                    attrValueTab[tempItemData.attrName] = attrValueTab[tempItemData.attrName] + value
                end
            end
        end
    end

    --圣石属性
    local gemCfg = getConfig(game_config_field.god_stone);
    local gemPosItemData = saintStoneData or {}
    for k,v in pairs(gemPosItemData) do
        local itemCfg = gemCfg:getNodeWithKey(tostring(v))
        if itemCfg then
            local ability = itemCfg:getNodeWithKey("ability"):toInt();
            local value = itemCfg:getNodeWithKey("value"):toInt();
            local tempItemData = PUBLIC_ABILITY_TABLE["ability_" .. ability];
            if ability > 6 and ability <=600   and tempItemData then
                attrValueTab[tempItemData.attrName] =math.floor(attrValueTab[tempItemData.attrName]*(1+value/100))
            end
            local ability2 = itemCfg:getNodeWithKey("ability2")
            if ability2 then
                ability2 = ability2:toInt();
                local value2 = itemCfg:getNodeWithKey("value2"):toInt();
                local tempItemData = PUBLIC_ABILITY_TABLE["ability_" .. ability2];
                if ability2 > 6 and tempItemData then
                    attrValueTab[tempItemData.attrName] = math.floor(attrValueTab[tempItemData.attrName]*(1+value2/100))
                end
            end
        end
    end


    return attrValueTab
end


--[[
    统帅能力属性加成
]]
function M.getCommanderCombatValue(self)
    local attrValueTab = {0,0,0,0,0}
    local attrValueTab = {0,0,0,0,0,0,0,0,0}
    local attrValueTab2={0,0,0,0,0,0,0,0}
    local commander_type_cfg = getConfig(game_config_field.commander_type);
    local commander_attrs = game_data:getCommanderAttrsData();
    -- cclog2(commander_attrs,"commander_attrs is")
    for k,v in pairs(COMMANDER_ABILITY_TABLE) do
        local commander_attrs_item = commander_attrs[v.attrName]
        if commander_attrs_item then
            local tempItemCfg = commander_type_cfg:getNodeWithKey(tostring(commander_attrs_item.lv))
            if tempItemCfg and attrValueTab[v.typeValue] then
                local tempValue = tempItemCfg:getNodeWithKey("add_" .. v.attrName)
                if tempValue then
                    attrValueTab[v.typeValue] = attrValueTab[v.typeValue] + tempValue:toInt();
                else
                    cclog("v.attrName not found cfg ===== " .. tostring(v.attrName))
                end
            end
             --todo 圣石
            local tempValue = tempItemCfg:getNodeWithKey("add_" .. v.attrName)
            local table={"fireatt","wateratt","windatt","earthatt","firedfs","waterdfs","winddfs","earthdfs"}
            if tempValue then
                for i=1,8 do 
                    if table[i]==v.attrName then
                        attrValueTab2[i]=tempValue:toInt()
                    end
                end
            end
        end

    end
    -- cclog2(attrValueTab2,"attrValueTab2 isasd")
    -- cclog("getCommanderCombatValue json.encode(attrValueTab) ======== " .. json.encode(attrValueTab))
    return attrValueTab,attrValueTab2
end
--[[
    宝石能力属性加成
]]
function M.getGemCombatValue(self, posIndex , GodGemData)
    local attrValueTab = {0,0,0,0,0}
    local attrValueTab2 = {0,0,0,0,0,0,0,0}
    local combatValue = 0;
    local gemCfg = getConfig(game_config_field.gem);
    local gemPosData = game_data:getGemPosData() or {};
    local gemPosItemData = gemPosData[tostring(posIndex-1)] or {}

    if GodGemData ~= nil then
          gemPosData = GodGemData or {};
          gemPosItemData = gemPosData[tostring(posIndex-1)] or {}
    end
    -- cclog2(GodGemData,"GodGemData is")
    -- cclog2(gemPosItemData,"gemPosItemData isasa")
    for k,v in pairs(gemPosItemData) do
        local gemLv,gemId = game_util:getRealGemLvAndCid(tostring(v))-----changedByzjr
        local itemCfg = gemCfg:getNodeWithKey(tostring(gemId))
        if itemCfg then
            local ability = itemCfg:getNodeWithKey("ability"):toInt();
            local value = itemCfg:getNodeWithKey("value"):toInt();
            local curValue1,curValue2 = game_util:getGemAttrByLv(gemLv, itemCfg:getNodeWithKey("ability"):toInt())
            if ability > 0 and ability < 6 then
                attrValueTab[ability] = attrValueTab[ability] + value + curValue1
            else
                combatValue = combatValue + value + curValue1;
            end

 
            --todo
            if ability>200 and ability<400 then
                local team=itemCfg:getNodeWithKey("team"):toInt()
                attrValueTab2[team]=value
            end



            local ability2 = itemCfg:getNodeWithKey("ability2")
            if ability2 then
                ability2 = ability2:toInt();
                local value2 = itemCfg:getNodeWithKey("value2"):toInt();
                if ability2 > 0 and ability2 < 6 then
                    attrValueTab[ability2] = attrValueTab[ability2] + value2 + curValue2
                else
                    combatValue = combatValue + value2;
                end
            end
        end
    end
    local commander_attrs = game_data:getCommanderAttrsData();
    local commander_type_cfg = getConfig(game_config_field.commander_type);
    for k,v in pairs(COMBAT_ABILITY_TABLE.gem) do
        local commander_attrs_item = commander_attrs[v]
        if commander_attrs_item then
            local tempItemCfg = commander_type_cfg:getNodeWithKey(tostring(commander_attrs_item.lv))
            local tempValue = tempItemCfg:getNodeWithKey("add_" .. v)
            if tempValue then
                combatValue = combatValue + tempValue:toInt();
            end
        end
    end
    return combatValue,attrValueTab,attrValueTab2;
end
--[[
    助威单个卡牌的属性加成
]]
function M.getAssistantCardAttrValue(self, heroData, heroCfg, att_type, cardlimit)
    local temp_value = 0
    att_type = att_type or 0
    cardlimit = cardlimit or 0
    -- cclog2(cardlimit,"cardlimit")
    local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. att_type]
    if heroData and heroCfg and abilityItem then
        local break_control_cfg = getConfig(game_config_field.break_control)
        local character_strengthen = getConfig(game_config_field.character_strengthen)
        local cbmTab = self:getCombatBonusMultiplierByCfg(heroCfg,heroData.id)
        local attrName = tostring(abilityItem.attrName)
        local evo = heroData.evo or 0--进阶
        temp_value = heroData[attrName] or 0
        if att_type < 6 and evo > cardlimit then--需要重新计算
            local attr_base_value = heroCfg:getNodeWithKey("base_" .. attrName):toInt()
            local attr_growth_value = heroCfg:getNodeWithKey("growth_" .. attrName):toInt() 
            local race = heroCfg:getNodeWithKey("race"):toInt()
            local evolutionCfg = game_data:getEvolutionCfgByHeroCfg(heroCfg)
            local tempItemCfg1 = evolutionCfg:getNodeWithKey(tostring(cardlimit))
            local evo_attr_value = 0
            local all_value = 0
            if tempItemCfg1 then
                all_value = tempItemCfg1:getNodeWithKey("all"):toFloat()
                local attrType1 = tempItemCfg1:getNodeWithKey("type" .. race)
                evo_attr_value = attrType1:getNodeAt(att_type-1):toInt()
            end
            local hp_add = 0
            if att_type == 5 then
                local bre = heroData.bre or 0--转生  只和基本血量有关  hp_add
                local break_control_cfg_item = break_control_cfg:getNodeWithKey(tostring(bre))
                if break_control_cfg_item then
                    hp_add = break_control_cfg_item:getNodeWithKey("hp_add"):toFloat()
                end
            end
            --加超进化的东西
            local super_evo_value = 0
            local super_evolution_cfg = getConfig(game_config_field.super_evolution)
            local super_evo = heroCfg:getNodeWithKey("super_evo")
            super_evo = super_evo and super_evo:toInt() or 0
            local super_evolution_cfg_item = super_evolution_cfg:getNodeWithKey(tostring(super_evo))
            if super_evolution_cfg_item then
                local super_step = heroData.super_step or 0
                for j=1,super_step do
                    local level_add = super_evolution_cfg_item:getNodeWithKey("level_" .. j .. "_add")
                    for i=1,level_add:getNodeCount() do
                        local effectItem = level_add:getNodeAt(i-1)
                        local effectType = effectItem:getNodeAt(0):toInt()
                        if effectType == att_type then
                            super_evo_value = super_evo_value + effectItem:getNodeAt(1):toFloat()
                        end
                    end
                end
                --加铸魂的东西
                local super_soul = heroData.super_soul or {}
                for k=1,(super_step+1) do
                    local next_super_evo = super_evolution_cfg_item:getNodeWithKey("level_" .. k .. "_need")
                    if next_super_evo then
                        local super_evo_team = getConfig(game_config_field.super_evo_team)
                        --之前铸魂的东西
                        if k <= super_step then
                            for i=1,4 do
                                local super_team_id = next_super_evo:getNodeAt(i-1):toInt()
                                local item_evo_team = super_evo_team:getNodeWithKey(tostring(super_team_id))
                                local ability_add = item_evo_team:getNodeWithKey("ability_add")
                                for j=1,ability_add:getNodeCount() do
                                    local item_ability = ability_add:getNodeAt(j-1)
                                    local soul_type = item_ability:getNodeAt(0):toInt()
                                    if soul_type == att_type then
                                        super_evo_value = super_evo_value + item_ability:getNodeAt(1):toFloat()
                                    end
                                end
                            end
                        else
                            for i=1,#super_soul do
                                local item_soul = super_soul[i]
                                if item_soul == 1 then
                                    local super_team_id = next_super_evo:getNodeAt(i-1):toInt()
                                    local item_evo_team = super_evo_team:getNodeWithKey(tostring(super_team_id))
                                    local ability_add = item_evo_team:getNodeWithKey("ability_add")
                                    for j=1,ability_add:getNodeCount() do
                                        local item_ability = ability_add:getNodeAt(j-1)
                                        local soul_type = item_ability:getNodeAt(0):toInt()
                                        if soul_type == att_type then
                                            super_evo_value = super_evo_value + item_ability:getNodeAt(1):toFloat()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- cclog2(super_evo_value,"super_evo_value")
            -- cclog2(hp_add,"hp_add")
            -- cclog2(all_value,"all_value")
            -- cclog2(attr_base_value,"attr_base_value")
            -- cclog2(evo_attr_value,"evo_attr_value")
            attr_base_value = (attr_base_value + evo_attr_value + super_evo_value)*(1+all_value+hp_add)
            -- attr_base_value = (attr_base_value + evo_attr_value)*(1+all_value)*(1+hp_add)
            -- attr_growth_value = attr_growth_value*(1+all_value)*(1+hp_add)
            local crystal_value = 0;
            local item_cfg = character_strengthen:getNodeWithKey(tostring(heroData[attrName .. "_crystal"] or 0));
            if item_cfg then
                crystal_value = item_cfg:getNodeWithKey("add_" .. attrName)
                crystal_value = crystal_value and crystal_value:toInt() or 0
            end
            -- cclog2(attr_base_value,"attr_base_value")
            -- cclog2(crystal_value,"crystal_value")
            -- cclog2(attr_growth_value,"attr_growth_value")
            attr_growth_value = attr_growth_value*(1+all_value+hp_add)
            temp_value = (attr_base_value + attr_growth_value*((heroData.lv or 1) - 1)) + crystal_value
        end
        temp_value = temp_value*(1+cbmTab[att_type])
    end
    return temp_value
end
--[[
    助威属性加成
]]
--[[
    助威属性加成
]]
--[[
    助威属性加成
]]
function M.getAssistantCombatValue(self)
    cclog("-------getAssistantCombatValue---------")

    local attrValueTab = {0,0,0,0,0}
    local att_key = {"patk_v","matk_v","def_v","speed_v","hp_v",}
    local friendData = game_data:getAssistant()
    -- cclog2(friendData,"getAssistant  ======== ")
    local assistantEffect = game_data:getAssistantEffect()
    -- cclog2(assistantEffect,"getAssistantEffect  ======== ")
    local equipPosData = game_data:getAssEquipPosData()
    local magicPosData = game_data:getAssMagicPosData()
    local equip_set_random = getConfig(game_config_field.equip_set_random)
    local assistant_cfg = getConfig(game_config_field.assistant)
    for k,v in pairs(friendData) do
        local assistantEffectItem = assistantEffect[k] or {}
        local active_status = assistantEffectItem.active_status or "-1" -- "-1"未激活 "0" 激活
        local assistant_cfg_item = assistant_cfg:getNodeWithKey(tostring(k))
        if active_status ~= "-1" and assistant_cfg_item then
            local att_type = assistant_cfg_item:getNodeWithKey("att_type")
            att_type = att_type and att_type:toInt() or 0--加成的属性
            local cardlimit = assistant_cfg_item:getNodeWithKey("cardlimit")--进阶的限制
            cardlimit = cardlimit and cardlimit:toInt() or 0
            if attrValueTab[att_type] then
                -- local att_value = assistant_cfg_item:getNodeWithKey("att_value")
                -- att_value = att_value and att_value:toInt() or 0
                local heroData,heroCfg = game_data:getCardDataById(tostring(v))--heroData 属性值包括进阶 转生 属性改造
                if heroData then
                    local equipAttrValueTab = {0,0,0,0,0}
                    --计算助威装备属性值
                    local suitTab = {}
                    local equipPosItemData = equipPosData[tostring(k+99)] or {}
                    for k,v in pairs(equipPosItemData) do
                        v = tostring(v)
                        if v ~= "0" then
                            local equipData,equipCfg = game_data:getEquipDataById(v);
                            if equipData and equipCfg then
                                local value1 = equipCfg:getNodeWithKey("value1"):toInt();
                                local value2 = equipCfg:getNodeWithKey("value2"):toInt();
                                local lv = math.max(0,equipData.lv-1)
                                value1 = value1 + equipCfg:getNodeWithKey("level_add1"):toInt()*lv
                                value2 = value2 + equipCfg:getNodeWithKey("level_add2"):toInt()*lv
                                local ability1,ability2 = equipCfg:getNodeWithKey("ability1"):toInt(),equipCfg:getNodeWithKey("ability2"):toInt();
                                local equip_refine = equipData.equip_refine or {}
                                if equipAttrValueTab[ability1] then
                                    equipAttrValueTab[ability1] = equipAttrValueTab[ability1] + value1
                                    local attItem = PUBLIC_ABILITY_TABLE["ability_" .. ability1]
                                    if attItem then
                                        equipAttrValueTab[ability1] = equipAttrValueTab[ability1] + (equip_refine[attItem.attrName] or 0)
                                    end
                                end
                                if equipAttrValueTab[ability2] then
                                    equipAttrValueTab[ability2] = equipAttrValueTab[ability2] + value2;
                                    local attItem = PUBLIC_ABILITY_TABLE["ability_" .. ability2]
                                    if attItem then
                                        equipAttrValueTab[ability2] = equipAttrValueTab[ability2] + (equip_refine[attItem.attrName] or 0)
                                    end
                                end
                                local suit = equipCfg:getNodeWithKey("suit"):toInt();
                                if suitTab[suit] == nil then
                                    suitTab[suit] = 0;
                                    local suitCount,_,tempAttrValueTab = self:getEquipSuit(suit,equipPosItemData);
                                    if suitCount > 0 then
                                        for i=1,5 do
                                            equipAttrValueTab[i] = equipAttrValueTab[i] + tempAttrValueTab[i]
                                        end
                                    end
                                end
                                --加装备锻造的属性
                                -- cclog2(equipData.is_equip_forge,"equipData.is_equip_forge")
                                if equipData.is_equip_forge == true then
                                    -- local attrname = 
                                    -- local tempValue = {0,0,0,0,0}
                                    for key_type,valueTable in pairs(equipData.equip_forge) do
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
                                            --改成加数
                                            if enemy ~= -1 then--减敌人的不加
                                                equipAttrValueTab[sort] = equipAttrValueTab[sort] + value
                                            end
                                        end
                                    end
                                    
                                end

                            end
                        end
                    end
                    local magicPosItemData = magicPosData[tostring(k+99)] or {}
                    local attrMagicValueTab = {0,0,0,0,0};
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
                    for k,v in pairs(magicPosItemData) do
                        if v ~= "0" and v ~= "-1" then
                            local itemData,itemCfg = game_data:getMagicDataById(v)
                            if itemData and itemCfg then
                                local level = itemData.lv or 1;  
                                if itemCfg.talisman_type == 1 or itemCfg.talisman_type == "1" then
                                    local table = TempTable[1]
                                    for k,v in pairs(table) do
                                        if v.base ~= nil then
                                            attrMagicValueTab[k] = attrMagicValueTab[k] + itemCfg["base_" .. v.base] + itemCfg["growth_" .. v.base] * level
                                        end
                                    end
                                elseif itemCfg.talisman_type == 0 or itemCfg.talisman_type == "0" then
                                    local table = TempTable[2]
                                    for k,v in pairs(table) do
                                        if v.base ~= nil then
                                            attrMagicValueTab[k] = attrMagicValueTab[k] + itemCfg["base_" .. v.base] + itemCfg["growth_" .. v.base] * level
                                        end
                                    end
                                end 
                            end
                        end
                    end




                    --计算伙伴本身属性
                    local tempAssistantCardAttrValueTab = {}
                    local assAttrValueTab,_,_ = self:getAssistantAttrTab(k, assistantEffectItem, assistant_cfg_item, false)

                    --名人堂加成    zyz
                    local tempFamousAdd = {}
                    if heroData.famous then
                        tempFamousAdd = heroData.famous
                    -- --     hp = hp + (tempTab.hp and tempTab.hp or 0) * combat_base_cfg:getNodeWithKey("hp"):toFloat();
                    -- --     patk = patk + (tempTab.patk and tempTab.patk or 0) * combat_base_cfg:getNodeWithKey("patk"):toFloat();
                    -- --     matk = matk + (tempTab.matk and tempTab.matk or 0) * combat_base_cfg:getNodeWithKey("matk"):toFloat();
                    -- --     def = def + (tempTab.def and tempTab.def or 0) * combat_base_cfg:getNodeWithKey("def"):toFloat();
                    -- --     speed = speed + (tempTab.speed and tempTab.speed or 0) * combat_base_cfg:getNodeWithKey("speed"):toFloat();
                    end
                    for i=1,#assAttrValueTab do
                        local attrValueItem = assAttrValueTab[i]
                        local temp_att_type = attrValueItem.att_type or 0
                        local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. temp_att_type]
                        local active = attrValueItem.active or 1--没值为激活
                        if abilityItem and attrValueItem.open > 0 and active > 0 then
                            local temp_value,temp_att_value = tempAssistantCardAttrValueTab[att_type],attrValueItem.att_value or 0
                            if temp_value == nil then
                                temp_value = self:getAssistantCardAttrValue(heroData, heroCfg, att_type, cardlimit)
                                if heroData.bind_equip and next(heroData.bind_equip) then
                                    local fateEquipData = {0,0,0,0,0}
                                    fateEquipData = self:getFateEquipValue(heroData.bind_equip)
                                    temp_value = math.floor(temp_value * (1 + fateEquipData[att_type]/100))
                                end
                                tempAssistantCardAttrValueTab[att_type] = temp_value
                            end

                            attrValueTab[att_type] = attrValueTab[att_type] + (temp_value+equipAttrValueTab[att_type]+attrMagicValueTab[att_type] +(tempFamousAdd[att_key[att_type]] or 0))*temp_att_value*0.01
                            
                            -- --计算装备绑定加的百分比
                            -- if heroData.bind_equip and next(heroData.bind_equip) then
                            --     local fateEquipData = {0,0,0,0,0}
                            --     fateEquipData = self:getFateEquipValue(heroData.bind_equip)
                            --     attrValueTab[att_type] = math.floor(attrValueTab[att_type] * (1 + fateEquipData[att_type]/100))
                            -- end
                        
                        end
                    end
                end
            end
        end
    end
    return attrValueTab
end
--[[--
    计算命运装备绑定的
]]
function M.getFateEquipValue(self,equipIdTab)
    -- local fateEquipData = {0,0,0,0,0}
    -- for  a,id in pairs(equipIdTab) do
    --     if id ~= 0 then
    --         local equipData = game_data:getEquipDataById(tostring(id))
    --         if equipData and equipData.bind_data and next(equipData.bind_data) then
    --             for k,v in pairs(equipData.bind_data) do
    --                fateEquipData[tonumber(k)] = v + fateEquipData[tonumber(k)]
    --             end
    --         end
    --     end
    -- end
    -- return fateEquipData
    local equip_gem_fate_skill = getConfig(game_config_field.equip_gem_fate_skill) and json.decode(getConfig(game_config_field.equip_gem_fate_skill):getFormatBuffer()) or {}

    local fateEquipData = {0,0,0,0,0}
    for  a,id in pairs(equipIdTab) do
        if id ~= 0 then
            local equipData = game_data:getEquipDataById(tostring(id))
            if equipData and equipData.bind_data and next(equipData.bind_data) then
                for k,v in pairs(equipData.bind_data) do
                   fateEquipData[tonumber(k)] = v + fateEquipData[tonumber(k)]
                end
                for i=1,4 do --changedByZJR 绑定的装备上如果有命运宝石 添加数值
                    local equip_fateGem = equipData.gem_fate
                    if equip_fateGem then
                        local fateGemCid = equip_fateGem[i]
                        local team,value = self:getFateGemData(fateGemCid)
                        if team ~= 0 then
                            -- 血石加成判断
                            local effects = game_util.bloodStone.getEquipStoneEffect2(equip_fateGem)
                            local effect = effects[1]
                            local bloodAddValue = 0
                            if effect then
                                local effectSid = effect.effectSid
                                bloodAddValue = equip_gem_fate_skill[tostring(effectSid)].effect[1][2]
                            end
                            fateEquipData[tonumber(team)] = fateEquipData[tonumber(team)] + (value + value * bloodAddValue / 100)
                        end
                    end

                end

            end
        end
    end
    return fateEquipData
end
--[[
    命运宝石 通过配置获取宝石的类型和数值
]]
function M.getFateGemData( self,cId )
    local team,value = 0,0 --value1装备的特殊属性，value2血量
    local gem_fate_cfg = getConfig(game_config_field.equip_gem_fate)
    if cId and cId ~= 0 then
        cId = game_util.bloodStone.gem.getCId(cId)
        local itemCfgData = gem_fate_cfg:getNodeWithKey(tostring(cId))
        team = itemCfgData:getNodeWithKey("team"):toInt()
        value = itemCfgData:getNodeWithKey("value"):toInt()
        value = value --changedbyZJR
    end
    return team,value
end
--[[--
计算总战斗力
]]
function M.getCombatValue(self)
    local combat_base_cfg = getConfig(game_config_field.combat_base)
    local combat_skill_cfg = getConfig(game_config_field.combat_skill)
    local skill_detail_cfg = getConfig(game_config_field.skill_detail);
    local equip_set_random = getConfig(game_config_field.equip_set_random)
    
    local combat = 0;
    local teamTable = game_data:getTeamData() or {};
    local cardData,heroCfg;
    local hp,patk,matk,def,speed;
    local attrValueTab = {0,0,0,0,0}
    local skill_detail_cfg_item,combat_skill_cfg_item;
    local skillItem,skill_quality,total_factor;

    local attrValueTab2,attrValueTab2ForGodStone = self:getCommanderCombatValue();
    local attrValueTab3 = self:getAssistantCombatValue();
    local equipPosData = game_data:getEquipPosData() or {};
    local equipPosItemData;
    local equipData,equipCfg;
    local value1,value2;
    local ability1,ability2;
    local rightTeamData = game_data:getRightTeamData()
    local bonusCombat
    if tempbonusCombat then
        bonusCombat = tempbonusCombat
    else
        bonusCombat = self:getAllBonusCombat()
    end
    local magicPosData = game_data:getMagicPosData() or {};
    local magicPosItemData;

    local total_factor_table = {}
    for k,v in pairs(teamTable) do
        cardData,heroCfg = game_data:getCardDataById(tostring(v));
        if cardData and heroCfg then
            total_factor = 1;
            for i=1,5 do
                skillItem = cardData["s_" .. i]
                if skillItem and skillItem.s ~= 0 and skillItem.avail == 2 then
                    skill_detail_cfg_item = skill_detail_cfg:getNodeWithKey(tostring(skillItem.s));
                    if skill_detail_cfg_item and skillItem.lv > 0 then
                        combat_skill_cfg_item = combat_skill_cfg:getNodeWithKey(tostring(skillItem.lv))
                        skill_quality = skill_detail_cfg_item:getNodeWithKey("skill_quality"):toInt();
                        if combat_skill_cfg_item and skill_quality > -1 and skill_quality <= 7 then
                            total_factor = total_factor + combat_skill_cfg_item:getNodeWithKey(tostring(skill_quality)):toFloat();
                            total_factor_table[v] = total_factor
                        end
                    end
                end
            end
            -- hp,patk,matk,def,speed = cardData.hp,cardData.patk,cardData.matk,cardData.def,cardData.speed
            local cbmTab = self:getCombatBonusMultiplierByCfg(heroCfg,v);
            --todo 命运刷新
            if cardData.fate_change and next(cardData.fate_change) then
                cbmTab=self:getCombatBonusMultiplierByCfg2(heroCfg,v) 
            end

            attrValueTab = {cardData.patk*(1 + cbmTab[1]),cardData.matk*(1 + cbmTab[2]),cardData.def*(1 + cbmTab[3]),cardData.speed*(1 + cbmTab[4]),cardData.hp*(1 + cbmTab[5])};-- 1物攻 2魔攻 3防御 4速度 5生命
            value1,value2 = 0,0;
            ability1,ability2 = 0,0;
            local gemCombatValue,gemAttrValueTab ,gemCombatValue2= self:getGemCombatValue(k);--宝石的八种新属性和基本属性
            local suitTab = {};
            equipPosItemData = equipPosData[tostring(k-1)]
            if equipPosItemData then
                for k,v in pairs(equipPosItemData) do
                    v = tostring(v)
                    if v ~= "0" then
                        equipData,equipCfg = game_data:getEquipDataById(v);
                        if equipData and equipCfg then
                            value1 = equipCfg:getNodeWithKey("value1"):toInt();
                            value2 = equipCfg:getNodeWithKey("value2"):toInt();
                            local lv = math.max(0,equipData.lv-1)
                            value1 = value1 + equipCfg:getNodeWithKey("level_add1"):toInt()*lv
                            value2 = value2 + equipCfg:getNodeWithKey("level_add2"):toInt()*lv
                            ability1,ability2 = equipCfg:getNodeWithKey("ability1"):toInt(),equipCfg:getNodeWithKey("ability2"):toInt();
                            local equip_refine = equipData.equip_refine or {}
                            -- cclog("total_factor =====================" .. total_factor .. " ; ability1 = " .. ability1 .. " ; value1 = " .. value1 .. " ; ability2 = " .. ability2 .. " ;value2 = " .. value2)
                            if attrValueTab[ability1] then
                                attrValueTab[ability1] = attrValueTab[ability1] + value1
                                local attItem = PUBLIC_ABILITY_TABLE["ability_" .. ability1]
                                if attItem then
                                    attrValueTab[ability1] = attrValueTab[ability1] + (equip_refine[attItem.attrName] or 0)
                                end
                            end
                            if attrValueTab[ability2] then
                                attrValueTab[ability2] = attrValueTab[ability2] + value2;
                                local attItem = PUBLIC_ABILITY_TABLE["ability_" .. ability2]
                                if attItem then
                                    attrValueTab[ability2] = attrValueTab[ability2] + (equip_refine[attItem.attrName] or 0)
                                end
                            end
                            local suit = equipCfg:getNodeWithKey("suit"):toInt();
                            if suitTab[suit] == nil then
                                suitTab[suit] = 0;
                                local suitCount,_,tempAttrValueTab = self:getEquipSuit(suit,equipPosItemData);
                                if suitCount > 0 then
                                    for i=1,5 do
                                        attrValueTab[i] = attrValueTab[i] + tempAttrValueTab[i]
                                    end
                                end
                                gemCombatValue = gemCombatValue + tempAttrValueTab[6]--套装的八种新属性
                            end
                            if equipData.is_enchant == true then--装备的八种新属性
                                local atts = equipData.atts or {}
                                for k,v in pairs(atts) do
                                    gemCombatValue = gemCombatValue + v;
                                end
                            end
                            --加装备锻造的属性
                            -- cclog2(equipData.is_equip_forge,"equipData.is_equip_forge")
                            if equipData.is_equip_forge == true then
                                -- local attrname = 
                                -- local tempValue = {0,0,0,0,0}
                                for key_type,valueTable in pairs(equipData.equip_forge) do
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
                                        --改成加数
                                        if enemy ~= -1 then--减敌人的不加
                                            attrValueTab[sort] = attrValueTab[sort] + value
                                        end
                                    end
                                end
                                
                            end
                        end
                    end
                end
            end
            magicPosItemData = magicPosData[tostring(k-1)]--法宝
            local attMagicValueTab = {0,0,0,0,0}
            if magicPosItemData then
                attMagicValueTab = self:getMagicAttrValueByTable(magicPosItemData)
            end
            --加主角属性升级的属性
            local rolePropertryValueTab = self:getRolePropertryValue()
            --加寵物屬性
            local petAttrValueTab = self:getPetCombatValue(k)
            --加宠物跟随的属性
            local petFollowValueTab = nil;
            petFollowValueTab = self:getPetFollowCombatValue(k)

            --加勋章的属性，勋章的基本属性和属性攻击分开计算
            local medalCombatValue,medalAttrValueTab,medalAttrValueTab2 = self:getMedalCombatValue(k);
            gemCombatValue = gemCombatValue + medalCombatValue--把勋章的属性伤害加上
            --加英魂的属性，英魂的基本属性和属性攻击分开计算
            local soulCombatValue,soulAttrValueTab,soulPercentValueTab,soulAttrValueTab2 = self:getSoulCombatValue(k);
            gemCombatValue = gemCombatValue + soulCombatValue--把英魂的属性伤害加上

            --计算英魂所加的百分比数值  cardData.hp,cardData.patk,cardData.matk,cardData.def,cardData.speed
            local soulPercentCombat = {0,0,0,0,0}
            soulPercentCombat[1] = cardData.patk  * soulPercentValueTab[1] * 0.01
            soulPercentCombat[2] = cardData.matk  * soulPercentValueTab[2] * 0.01
            soulPercentCombat[3] = cardData.def   * soulPercentValueTab[3] * 0.01
            soulPercentCombat[4] = cardData.speed * soulPercentValueTab[4] * 0.01
            soulPercentCombat[5] = cardData.hp    * soulPercentValueTab[5] * 0.01
            

            --圣石百分比
            local saintStonePercentValueTab = self:getSaintStoneCombatValue(k);
            local saintStonePercentCombat = {0,0,0,0,0,0,0,0}
            for i=1,8 do 
                saintStonePercentCombat[i] = (gemCombatValue2[i]+medalAttrValueTab2[i]+attrValueTab2ForGodStone[i]) * saintStonePercentValueTab[i] * 0.01
            end
            for i=1,8 do 
                gemCombatValue=gemCombatValue+saintStonePercentCombat[i]
            end


            hp = (attrValueTab[5] + rolePropertryValueTab[5]+ attrValueTab2[5] + attrValueTab3[5] + gemAttrValueTab[5] + petAttrValueTab[5] + medalAttrValueTab[5]  + petFollowValueTab[5] + soulAttrValueTab[5] + soulAttrValueTab2[5] + soulPercentCombat[5]) * combat_base_cfg:getNodeWithKey("hp"):toFloat();
            patk = (attrValueTab[1] + rolePropertryValueTab[1]+ attrValueTab2[1] + attrValueTab3[1] + gemAttrValueTab[1] + petAttrValueTab[1] + medalAttrValueTab[1]  + petFollowValueTab[1]+ soulAttrValueTab[1] + soulAttrValueTab2[1] + soulPercentCombat[1]) * combat_base_cfg:getNodeWithKey("patk"):toFloat();
            matk = (attrValueTab[2] + rolePropertryValueTab[2]+  attrValueTab2[2] + attrValueTab3[2] + gemAttrValueTab[2] + petAttrValueTab[2] + medalAttrValueTab[2] + petFollowValueTab[2]+ soulAttrValueTab[2] + soulAttrValueTab2[2] + soulPercentCombat[2]) * combat_base_cfg:getNodeWithKey("matk"):toFloat();
            def = (attrValueTab[3] + rolePropertryValueTab[3]+  attrValueTab2[3] + attrValueTab3[3] + gemAttrValueTab[3] + petAttrValueTab[3] + medalAttrValueTab[3]  + petFollowValueTab[3]+ soulAttrValueTab[3] + soulAttrValueTab2[3] + soulPercentCombat[3]) * combat_base_cfg:getNodeWithKey("def"):toFloat();
            speed = (attrValueTab[4] +  rolePropertryValueTab[4]+ attrValueTab2[4] + attrValueTab3[4] + gemAttrValueTab[4] + petAttrValueTab[4] + medalAttrValueTab[4]  + petFollowValueTab[4]+ soulAttrValueTab[4] + soulAttrValueTab2[4] + soulPercentCombat[4]) * combat_base_cfg:getNodeWithKey("speed"):toFloat();
            
            if cardData.bind_equip and next(cardData.bind_equip) then
                local fateEquipData = {0,0,0,0,0}
                fateEquipData = self:getFateEquipValue(cardData.bind_equip)
                -- cclog2(fateEquipData,"fateEquipData-=---------")
                hp = math.floor(hp * (1 + fateEquipData[5] * 0.01))
                matk = math.floor(matk * (1 + fateEquipData[2] * 0.01))
                def = math.floor(def * (1 + fateEquipData[3] * 0.01))
                speed = math.floor(speed * (1 + fateEquipData[4] * 0.01))
                patk = math.floor(patk * (1 + fateEquipData[1] * 0.01))
            end
            if attMagicValueTab then
                local att5 = (attMagicValueTab[5]) * combat_base_cfg:getNodeWithKey("hp"):toFloat()
                local att1 = (attMagicValueTab[1]) * combat_base_cfg:getNodeWithKey("patk"):toFloat()
                local att2 = (attMagicValueTab[2]) * combat_base_cfg:getNodeWithKey("matk"):toFloat()
                local att3 = (attMagicValueTab[3]) * combat_base_cfg:getNodeWithKey("def"):toFloat()
                local att4 = (attMagicValueTab[4]) * combat_base_cfg:getNodeWithKey("speed"):toFloat()
                -- cclog("   hp   " .. att5 .. "   patk   " .. att1 .. "   matk   " .. att2 .. "    def   " .. att3 .. "  speed   " .. att4 .. "   all   " .. att5+att1+att2+att3+att4 )
            --]]
                hp = hp + (attMagicValueTab[5]) * combat_base_cfg:getNodeWithKey("hp"):toFloat();
                patk = patk +(attMagicValueTab[1]) * combat_base_cfg:getNodeWithKey("patk"):toFloat();
                matk = matk + (attMagicValueTab[2]) * combat_base_cfg:getNodeWithKey("matk"):toFloat();
                def = def + (attMagicValueTab[3]) * combat_base_cfg:getNodeWithKey("def"):toFloat();
                speed = speed + (attMagicValueTab[4]) * combat_base_cfg:getNodeWithKey("speed"):toFloat();
            end
            local data = game_data:getFamousAttrs() or {}
            local tempTab = cardData.famous or {}
            hp = hp + ((tempTab.hp_v and tempTab.hp_v or 0)+(data.hp or 0)) * combat_base_cfg:getNodeWithKey("hp"):toFloat();
            patk = patk + ((tempTab.patk_v and tempTab.patk_v or 0)+(data.patk or 0)) * combat_base_cfg:getNodeWithKey("patk"):toFloat();
            matk = matk + ((tempTab.matk_v and tempTab.matk_v or 0)+(data.matk or 0)) * combat_base_cfg:getNodeWithKey("matk"):toFloat();
            def = def + ((tempTab.def_v and tempTab.def_v or 0)+(data.def or 0)) * combat_base_cfg:getNodeWithKey("def"):toFloat();
            speed = speed + ((tempTab.speed_v and tempTab.speed_v or 0)+(data.speed or 0)) * combat_base_cfg:getNodeWithKey("speed"):toFloat();
            -- end

            --计算皮肤加的战斗力
            local skinCombat = self:getSkinCombat(cardData.c_id)
            if skinCombat then
                hp = hp +  skinCombat[5] 
                matk = matk +  skinCombat[2] 
                def = def +  skinCombat[3] 
                speed = speed +  skinCombat[4] 
                patk = patk +  skinCombat[1] 
            end

            hp = math.floor(hp)
            patk = math.floor(patk)
            matk = math.floor(matk)
            def = math.floor(def)
            speed = math.floor(speed)
            combat = combat + (hp + patk + matk + def + speed)*total_factor + gemCombatValue;
            for k,v in pairs(COMBAT_ABILITY_TABLE.card) do--卡牌的八种新属性
                combat = combat + (cardData[v] or 0)
            end
        end
    end
    if rightTeamData then
        local bonusCombat = self:getbonusCombat(total_factor_table,rightTeamData)
        combat = combat + bonusCombat
    else
        local bonusData = 0
        for i=1,5 do
            bonusData =  bonusData + bonusCombat[i]
        end
        combat = combat + (bonusData * (total_factor or 0)) -- 战斗力    zyz 
    end

    cclog("combat =====================" .. combat)
    return math.floor(combat);
end

--[[--
计算总战斗力
]]
function M.getGodCombatValue(self,teamData,equipallData,GodGemData,soulData,medalData,stoneData,magicData)
    local combat_base_cfg = getConfig(game_config_field.combat_base)
    local combat_skill_cfg = getConfig(game_config_field.combat_skill)
    local skill_detail_cfg = getConfig(game_config_field.skill_detail);
    local equip_set_random = getConfig(game_config_field.equip_set_random)
    local combat = 0;
    
    local teamTable = teamData or {};
    local cardData,heroCfg;
    local hp,patk,matk,def,speed;
    local attrValueTab = {0,0,0,0,0}
    local skill_detail_cfg_item,combat_skill_cfg_item;
    local skillItem,skill_quality,total_factor;

    local attrValueTab2,attrValueTab2ForGodStone = self:getCommanderCombatValue();
    -- cclog2(attrValueTab2,"attrValueTab2")
    local attrValueTab3 = self:getAssistantCombatValue();
    -- cclog2(attrValueTab3,"attrValueTab3")
    local equipPosData = equipallData or {};
    local equipPosItemData;
    local equipData,equipCfg;
    local value1,value2;
    local ability1,ability2;

    local magic_combat = 0
    if magicData then
       magic_combat = self:getMagicCombatByTable(magicData)
    end
    for k,v in pairs(teamTable) do
        cardData,heroCfg = game_data:getCardDataById(tostring(v));
        if cardData and heroCfg then 
            total_factor = 1;
            for i=1,5 do
                skillItem = cardData["s_" .. i]
                if skillItem and skillItem.s ~= 0 and skillItem.avail == 2 then
                    skill_detail_cfg_item = skill_detail_cfg:getNodeWithKey(tostring(skillItem.s));
                    if skill_detail_cfg_item and skillItem.lv > 0 then
                        combat_skill_cfg_item = combat_skill_cfg:getNodeWithKey(tostring(skillItem.lv))
                        skill_quality = skill_detail_cfg_item:getNodeWithKey("skill_quality"):toInt();
                        if combat_skill_cfg_item and skill_quality > -1 and skill_quality <= 7 then
                            total_factor = total_factor + combat_skill_cfg_item:getNodeWithKey(tostring(skill_quality)):toFloat();
                        end
                    end
                end
            end
            -- hp,patk,matk,def,speed = cardData.hp,cardData.patk,cardData.matk,cardData.def,cardData.speed
            local cbmTab = self:getCombatBonusMultiplierByCfg(heroCfg,v);
                         --todo 命运刷新
            if cardData.fate_change and next(cardData.fate_change) then
                cbmTab=self:getCombatBonusMultiplierByCfg2(heroCfg,v,teamData,equipallData) 
            end

            attrValueTab = {cardData.patk*(1 + cbmTab[1]),cardData.matk*(1 + cbmTab[2]),cardData.def*(1 + cbmTab[3]),cardData.speed*(1 + cbmTab[4]),cardData.hp*(1 + cbmTab[5])};-- 1物攻 2魔攻 3防御 4速度 5生命
            -- cclog2(attrValueTab,"cards")
            value1,value2 = 0,0;
            ability1,ability2 = 0,0;
            -- local gemCombatValue,gemAttrValueTab = self:getGemCombatValue(k,GodGemData) or nil,nil;--宝石的八种新属性和基本属性
            -- local gemCombatValue,gemAttrValueTab = nil , nil;
            -- local CombatValue = 0;
            local gemCombatValue,gemAttrValueTab,gemCombatValue2 = self:getGemCombatValue(k,GodGemData);--宝石的八种新属性和基本属性
            local suitTab = {};
            equipPosItemData = equipPosData[tostring(k-1)]
            cclog2(k-1,"k-1===================")
            -- cclog2(equipPosItemData,"equipPosItemData==2===3=3=4=")
            if equipPosItemData then
                for k,v in pairs(equipPosItemData) do
                    v = tostring(v)
                    if v ~= "0" then
                        equipData,equipCfg = game_data:getEquipDataById(v);
                        if equipData and equipCfg then
                            value1 = equipCfg:getNodeWithKey("value1"):toInt();
                            value2 = equipCfg:getNodeWithKey("value2"):toInt();
                            local lv = math.max(0,equipData.lv-1)
                            value1 = value1 + equipCfg:getNodeWithKey("level_add1"):toInt()*lv
                            value2 = value2 + equipCfg:getNodeWithKey("level_add2"):toInt()*lv
                            ability1,ability2 = equipCfg:getNodeWithKey("ability1"):toInt(),equipCfg:getNodeWithKey("ability2"):toInt();
                            local equip_refine = equipData.equip_refine or {}
                            -- cclog("total_factor =====================" .. total_factor .. " ; ability1 = " .. ability1 .. " ; value1 = " .. value1 .. " ; ability2 = " .. ability2 .. " ;value2 = " .. value2)
                            if attrValueTab[ability1] then
                                attrValueTab[ability1] = attrValueTab[ability1] + value1
                                local attItem = PUBLIC_ABILITY_TABLE["ability_" .. ability1]
                                if attItem then
                                    attrValueTab[ability1] = attrValueTab[ability1] + (equip_refine[attItem.attrName] or 0)
                                end
                            end
                            if attrValueTab[ability2] then
                                attrValueTab[ability2] = attrValueTab[ability2] + value2;
                                local attItem = PUBLIC_ABILITY_TABLE["ability_" .. ability2]
                                if attItem then
                                    attrValueTab[ability2] = attrValueTab[ability2] + (equip_refine[attItem.attrName] or 0)
                                end
                            end
                            local suit = equipCfg:getNodeWithKey("suit"):toInt();
                            if suitTab[suit] == nil then
                                suitTab[suit] = 0;
                                local suitCount,_,tempAttrValueTab = self:getEquipSuit(suit,equipPosItemData);
                                if suitCount > 0 then
                                    for i=1,5 do
                                        attrValueTab[i] = attrValueTab[i] + tempAttrValueTab[i]
                                    end
                                end
                                -- CombatValue = CombatValue + tempAttrValueTab[6]--套装的八种新属性
                                gemCombatValue = gemCombatValue + tempAttrValueTab[6]--套装的八种新属性
                            end
                            if equipData.is_enchant == true then--装备的八种新属性
                                local atts = equipData.atts or {}
                                for k,v in pairs(atts) do
                                    -- CombatValue = CombatValue + v;
                                     gemCombatValue = gemCombatValue + v;
                                end
                            end
                            --加装备锻造的属性
                            -- cclog2(equipData.is_equip_forge,"equipData.is_equip_forge")
                            -- if equipData.is_equip_forge == true then
                            --     -- local attrname = 
                            --     -- local tempValue = {0,0,0,0,0}
                            --     for key_type,valueTable in pairs(equipData.equip_forge) do
                            --         local itemEquipForgeCfg = json.decode(equip_set_random:getNodeWithKey(tostring(key_type)):getFormatBuffer())
                            --         local sort = itemEquipForgeCfg.sort
                            --         local enemy = itemEquipForgeCfg.enemy[1]
                            --         local value = 0
                            --         for k,v in pairs(valueTable) do
                            --             value = v
                            --         end
                            --         -- cclog2(value,"equp forge value")
                            --         if sort > 0 and sort <= 5 then
                            --             -- tempValue[sort] = value

                            --             -- attrValueTab[sort] = attrValueTab[sort] * (1 + value)
                            --             --改成加数
                            --             if enemy ~= -1 then--减敌人的不加
                            --                 attrValueTab[sort] = attrValueTab[sort] + value
                            --             end
                            --         end
                            --     end
                                
                            -- end
                        end
                    end
                end
            end
            
              --加勋章的属性，勋章的基本属性和属性攻击分开计算
            local medalCombatValue,medalAttrValueTab,medalAttrValueTab2 = self:getMedalCombatValue(k,medalData);
            gemCombatValue = gemCombatValue + medalCombatValue--把勋章的属性伤害加上
            --加英魂的属性，英魂的基本属性和属性攻击分开计算
            local soulCombatValue,soulAttrValueTab,soulPercentValueTab,soulAttrValueTab2 = self:getSoulCombatValue(k,soulData);
            gemCombatValue = gemCombatValue + soulCombatValue--把英魂的属性伤害加上
            --计算英魂所加的百分比数值  cardData.hp,cardData.patk,cardData.matk,cardData.def,cardData.speed
            local soulPercentCombat = {0,0,0,0,0}
            soulPercentCombat[1] = cardData.patk  * soulPercentValueTab[1] * 0.01
            soulPercentCombat[2] = cardData.matk  * soulPercentValueTab[2] * 0.01
            soulPercentCombat[3] = cardData.def   * soulPercentValueTab[3] * 0.01
            soulPercentCombat[4] = cardData.speed * soulPercentValueTab[4] * 0.01
            soulPercentCombat[5] = cardData.hp    * soulPercentValueTab[5] * 0.01
            -- hp = (attrValueTab[5] + attrValueTab2[5]) * combat_base_cfg:getNodeWithKey("hp"):toFloat();
            -- patk = (attrValueTab[1] + attrValueTab2[1] ) * combat_base_cfg:getNodeWithKey("patk"):toFloat();
            -- matk = (attrValueTab[2] + attrValueTab2[2]) * combat_base_cfg:getNodeWithKey("matk"):toFloat();
            -- def = (attrValueTab[3] + attrValueTab2[3] ) * combat_base_cfg:getNodeWithKey("def"):toFloat();
            -- speed = (attrValueTab[4] + attrValueTab2[4]) * combat_base_cfg:getNodeWithKey("speed"):toFloat();
            hp = (attrValueTab[5] + attrValueTab2[5] + gemAttrValueTab[5] + medalAttrValueTab[5] + soulAttrValueTab[5] + soulAttrValueTab2[5] + soulPercentCombat[5]) * combat_base_cfg:getNodeWithKey("hp"):toFloat();
            patk = (attrValueTab[1] + attrValueTab2[1] + gemAttrValueTab[1] + medalAttrValueTab[1] + soulAttrValueTab[1] + soulAttrValueTab2[1] + soulPercentCombat[1]) * combat_base_cfg:getNodeWithKey("patk"):toFloat();
            matk = (attrValueTab[2] + attrValueTab2[2] + gemAttrValueTab[2] + medalAttrValueTab[2] + soulAttrValueTab[2] + soulAttrValueTab2[2] + soulPercentCombat[2]) * combat_base_cfg:getNodeWithKey("matk"):toFloat();
            def = (attrValueTab[3] + attrValueTab2[3] + gemAttrValueTab[3] + medalAttrValueTab[3] + soulAttrValueTab[3] + soulAttrValueTab2[3] + soulPercentCombat[3]) * combat_base_cfg:getNodeWithKey("def"):toFloat();
            speed = (attrValueTab[4] + attrValueTab2[4] + gemAttrValueTab[4] + medalAttrValueTab[4] + soulAttrValueTab[4] + soulAttrValueTab2[4] + soulPercentCombat[4]) * combat_base_cfg:getNodeWithKey("speed"):toFloat();
            -- combat = combat + (hp + patk + matk + def + speed)*total_factor + CombatValue ;
            -- combat = combat + (hp + patk + matk + def + speed)*total_factor + gemCombatValue ;

                        --神域圣石
             --圣石百分比
              --圣石
            
            local saintStonePercentValueTab = self:getSaintStoneCombatValue(k,stoneData);

            local saintStonePercentCombat = {0,0,0,0,0,0,0,0}
            for i=1,8 do 
                saintStonePercentCombat[i] = (gemCombatValue2[i]+medalAttrValueTab2[i]+attrValueTab2ForGodStone[i]) * saintStonePercentValueTab[i] * 0.01
            end
             for i=1,8 do 
                gemCombatValue=gemCombatValue+saintStonePercentCombat[i]
                -- cclog2(saintStonePercentCombat[i],"saintStonePercentCombat ")
            end


            if cardData.bind_equip and next(cardData.bind_equip) then
                local fateEquipData = {0,0,0,0,0}
                fateEquipData = self:getFateEquipValue(cardData.bind_equip)
                hp = math.floor(hp * (1 + fateEquipData[5] * 0.01))
                matk = math.floor(matk * (1 + fateEquipData[2] * 0.01))
                def = math.floor(def * (1 + fateEquipData[3] * 0.01))
                speed = math.floor(speed * (1 + fateEquipData[4] * 0.01))
                patk = math.floor(patk * (1 + fateEquipData[1] * 0.01))
            end

            local magic_com = 0
            if magicData then
                local magicPosItemData = magicData[tostring(k-1)]
                if magicPosItemData then
                    local attMagic = self:getMagicAttrValueByTable(magicPosItemData)
                    magic_com = magic_com + attMagic[1]*combat_base_cfg:getNodeWithKey("patk"):toFloat()
                    magic_com = magic_com + attMagic[2]*combat_base_cfg:getNodeWithKey("matk"):toFloat()
                    magic_com = magic_com + attMagic[3]*combat_base_cfg:getNodeWithKey("def"):toFloat()
                    magic_com = magic_com + attMagic[4]*combat_base_cfg:getNodeWithKey("speed"):toFloat()
                    magic_com = magic_com + attMagic[5]*combat_base_cfg:getNodeWithKey("hp"):toFloat()
                end
            end

            local data = game_data:getFamousAttrs() or {}
            local tempTab = cardData.famous or {}
            hp = hp + ((tempTab.hp and tempTab.hp_v or 0)+(data.hp or 0)) * combat_base_cfg:getNodeWithKey("hp"):toFloat();
            patk = patk + ((tempTab.patk and tempTab.patk_v or 0)+(data.patk or 0)) * combat_base_cfg:getNodeWithKey("patk"):toFloat();
            matk = matk + ((tempTab.matk and tempTab.matk_v or 0)+(data.matk or 0)) * combat_base_cfg:getNodeWithKey("matk"):toFloat();
            def = def + ((tempTab.def and tempTab.def_v or 0)+(data.def or 0)) * combat_base_cfg:getNodeWithKey("def"):toFloat();
            speed = speed + ((tempTab.speed and tempTab.speed_v or 0)+(data.speed or 0)) * combat_base_cfg:getNodeWithKey("speed"):toFloat();
            -- end
            --todo
           -- combat = combat + (hp + patk + matk + def + speed)*total_factor + gemCombatValue;
           -- combat = combat + (hp + patk + matk + def + speed)*total_factor+CombatValue;
             combat = combat + (hp + patk + matk + def + speed+ magic_com)*total_factor + gemCombatValue;
            for k,v in pairs(COMBAT_ABILITY_TABLE.card) do--卡牌的八种新属性
                combat = combat + (cardData[v] or 0)
            end
        end
    end

    -- cclog("combat =====================" .. combat)
    return math.floor(combat);
end

function M.setCailiaoNum( self,m_num_lab1,m_num_lab2,card_id,purpleNum,orangeNum,redNum,goldNum,yuanNum,shenNum)
    -- local _,orangeNum,redNum,goldNum,yuanNum,shenNum = game_data:getCardsDataSimple()
    if string.sub(card_id,1,3) == "50-" then
        m_num_lab1:setVisible(true)
        m_num_lab1:setString(tostring("x" .. purpleNum))
        m_num_lab2:setVisible(true)
        m_num_lab2:setString(tostring("x" .. purpleNum))
    elseif string.sub(card_id,1,3) == "51-" then
        m_num_lab1:setVisible(true)
        m_num_lab1:setString(tostring("x" .. orangeNum))
        m_num_lab2:setVisible(true)
        m_num_lab2:setString(tostring("x" .. orangeNum))
    elseif string.sub(card_id,1,3) == "52-" then
        m_num_lab1:setVisible(true)
        m_num_lab1:setString(tostring("x" .. redNum))
        m_num_lab2:setVisible(true)
        m_num_lab2:setString(tostring("x" .. redNum))
    elseif string.sub(card_id,1,3) == "53-" then
         m_num_lab1:setVisible(true)
        m_num_lab1:setString(tostring("x" .. goldNum))
        m_num_lab2:setVisible(true)
        m_num_lab2:setString(tostring("x" .. goldNum))
    elseif string.sub(card_id,1,3) == "54-" then
        m_num_lab1:setVisible(true)
        m_num_lab1:setString(tostring("x" .. yuanNum))
        m_num_lab2:setVisible(true)
        m_num_lab2:setString(tostring("x" .. yuanNum))
    elseif string.sub(card_id,1,3) == "55-" then
        m_num_lab1:setVisible(true)
        m_num_lab1:setString(tostring("x" .. shenNum))
        m_num_lab2:setVisible(true)
        m_num_lab2:setString(tostring("x" .. shenNum))
    else
        m_num_lab1:setVisible(false)
        m_num_lab2:setVisible(false)
    end 
end

--[[
    宠物跟随属性加成
]]
function M.getPetFollowCombatValue(self,posIndex)
    local value = 0
    
    local petFollowAttrValueTab = {0,0,0,0,0}
    local pet_follow_pos = game_data:getPetFollowPos()

    local pet_follow = getConfig(game_config_field.pet_follow)
    local pet_refresh = getConfig(game_config_field.pet_refresh)
    local pet_tab = json.decode(pet_refresh:getFormatBuffer()) or {};
    local add_value = pet_tab["1"].value_add;
    local min_addValue = add_value[1][1]/100
    for i=1,#pet_follow_pos do
        if pet_follow_pos[i] and pet_follow_pos[i] ~= "-1" and pet_follow_pos[i] ~= "0" then
            local petId = pet_follow_pos[i]
            local petData,petCfg = game_data:getPetDataById(petId)--只取第一个的
            
            if petData.refresh_num then
                value = petData.refresh_num + 0.1
                --cclog2(value,"value=3=3==44==5=66=")
            else
                value = 0.1;
            end    
            petFollowAttrValueTab[1] = petFollowAttrValueTab[1] + petData.patk * (value) ;-- + attrValueTab[1]
            petFollowAttrValueTab[2] = petFollowAttrValueTab[2] + petData.matk * (value) ;-- + attrValueTab[2]
            petFollowAttrValueTab[3] = petFollowAttrValueTab[3] + petData.def * (value) ;-- + attrValueTab[3]
            petFollowAttrValueTab[4] = petFollowAttrValueTab[4] + petData.speed * (value) ;-- + attrValueTab[4]
            petFollowAttrValueTab[5] = petFollowAttrValueTab[5] + petData.hp * (value) ;-- + attrValueTab[5]
            
        end
    end
    return petFollowAttrValueTab
end

--[[
    獎勵寵物動畫
]]
function M.addRewardPetAnim(self,tempId)
    local petData,petCfg = game_data:getPetDataById(tostring(tempId));
    local currentUiName = game_scene:getCurrentUiName();
    local game_active_limit_pop = game_scene:getPopByName("game_active_limit_pop")
    if petData == nil or petCfg == nil or currentUiName == "game_gacha_scene" or game_active_limit_pop ~= nil then return false end
    local quality = petCfg:getNodeWithKey("quality"):toInt();
    local animFile = "gacha_anim_1";
    if quality == 3 then
        animFile = "gacha_anim_2";
    elseif quality > 3 then
        animFile = "gacha_anim_3";
    else
        return false;
    end
    local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    local m_root_layer = CCLayerColor:create(ccc4(0, 0, 0, 100), visibleSize.width, visibleSize.height)
    local m_iAnim = zcAnimNode:create(animFile .. ".swf.sam",0,animFile .. ".plist");
    local function animEnd(animNode,theId,lableName)
        if lableName == "daiji" then
        elseif lableName == "xunhuan" then
            animNode:playSection("xunhuan");
        elseif lableName == "fanpai" then
            game_sound:playUiSound("gacha")
            animNode:playSection("xunhuan");
            local animNode = game_util:createPetListItemByCCB(petData);
            if animNode then
                animNode:setPosition(ccp(visibleSize.width*0.5, visibleSize.height*0.5))
                m_root_layer:addChild(animNode,20,20)
            end
        end
    end
    m_iAnim:registerScriptTapHandler(animEnd);
    m_iAnim:playSection("daiji");
    m_iAnim:setScale(1);
    m_iAnim:setPosition(ccp(visibleSize.width*0.5, visibleSize.width*0.5))
    local function animEndCallFunc()
        m_iAnim:playSection("fanpai");
    end
    cclog("addGachaAnim ======================== " .. animFile);
    local animArr = CCArray:create();
    animArr:addObject(CCMoveTo:create(0.1,ccp(visibleSize.width*0.5, visibleSize.height*0.5)));
    animArr:addObject(CCCallFunc:create(animEndCallFunc));
    m_iAnim:runAction(CCSequence:create(animArr));
    -- m_iAnim:setPosition(ccp(visibleSize.width*0.5, visibleSize.height*0.5))
    -- game_scene:getPopContainer():addChild(m_iAnim,10,10);
    m_root_layer:addChild(m_iAnim,10,10);
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            m_root_layer:removeFromParentAndCleanup(true);
            return true;--intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY - 100,true);
    m_root_layer:setTouchEnabled(true);
    game_scene:getPopContainer():addChild(m_root_layer,1000,1000);
    return true;
end

function M.createSortNode(self,swfname,id,plistname)
    local node = SortNode:create(swfname,id,plistname)
    if(node == nil) then
        -- game_util:addMoveTips({text = "缺少动画"..swfname})
    else
        node:setRhythm(public_config.action_rythm);
    end
    return node
end

--[[--
    通用奖励显示
]]
function M.rewardTipsByDataTableShow(self,dataTable,callBackFunc)
    if dataTable == nil then return end
    -- cclog("rewardTipsByDataTable ---------------" .. json.encode(dataTable))
    local tableShow = {}    
    local rewardCount = 0;

    local icon,name;
    local food = dataTable.food or 0;
    if food ~= 0 then
        table.insert( tableShow,{1,0,food} )
    end
    local metal = dataTable.metal or 0
    if metal ~= 0 then
        table.insert( tableShow,{2,0,metal} )
    end
    local energy = dataTable.energy or 0
    if energy ~= 0 then
        table.insert( tableShow,{3,0,energy} )
    end
    local crystal = dataTable.crystal or 0
    if crystal ~= 0 then
        table.insert( tableShow,{4,0,crystal} )
    end
    local adv_crystal = dataTable.adv_crystal or 0
    if adv_crystal ~= 0 then
        table.insert( tableShow,{20,0,adv_crystal} )
    end
    local coin = dataTable.coin or 0;
    if coin ~= 0 then
        table.insert( tableShow,{9,0,coin} )
    end
    local dirt_silver = dataTable.dirt_silver or 0;
    if dirt_silver ~= 0 then
        table.insert( tableShow,{10,0,dirt_silver} )
    end
    local dirt_gold = dataTable.dirt_gold or 0;
    if dirt_gold ~= 0 then
        table.insert( tableShow,{11,0,dirt_gold} )
    end
    local action_point = dataTable.action_point or 0;
    if action_point ~= 0 then
        table.insert( tableShow,{8,0,action_point} )
    end
    local arena_point = dataTable.arena_point or 0;
    if arena_point ~= 0 then
        table.insert( tableShow,{100,0,arena_point} )
    end
    local star = dataTable.star or 0;
    if star ~= 0 then
        table.insert( tableShow,{14,0,star} )
    end
    local silver = dataTable.silver or 0;
    if silver ~= 0 then
        table.insert( tableShow,{15,0,silver} )
    end
    --
    local pet_crystal = dataTable.pet_crystal or 0;
    if pet_crystal ~= 0 then
        table.insert( tableShow,{24,0,pet_crystal} )
    end
    local pet_exp_ball = dataTable.pet_exp_ball or 0;
    if pet_exp_ball ~= 0 then
        table.insert( tableShow,{26,0,pet_exp_ball} )
    end
    local pet_skill_stone = dataTable.pet_skill_stone or 0;
    if pet_skill_stone ~= 0 then
        table.insert( tableShow,{27,0,pet_skill_stone} )
    end
    --cards
    local cards = dataTable.cards or {};
    local tempId,tempQuality = "-1",-1;
    for k,cardId in pairs(cards) do
        local cardData,heroCfg = game_data:getCardDataById(tostring(cardId));
        if heroCfg then
            table.insert( tableShow,{5,cardId,1} )
        end 
    end
    local animFlag = self:addRewardCardAnim(tempId);
    --pet
    local pets = dataTable.pets or {};
    tempId,tempQuality = "-1",-1;
    for k,petId in pairs(pets) do
        local petData,petCfg = game_data:getPetDataById(tostring(petId));
        if petCfg then
            table.insert( tableShow,{25,petId,1} )
        end 
    end
    --equip
    local equip = dataTable.equip or {};
    tempId,tempQuality = "-1",-1;
    for k,equipId in pairs(equip) do
        local itemData,itemCfg = game_data:getEquipDataById(tostring(equipId));
        if itemCfg then
            table.insert( tableShow,{7,equipId,1} )
        end
    end
    local item = dataTable.item or {};
    local tempIdTab = {};
    for k,itemCid in pairs(item) do
        if tempIdTab[itemCid] == nil then
            tempIdTab[itemCid] = 1;
        else
            tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        table.insert( tableShow,{6,itemCid,count} )
    end
    local metalcore = dataTable.metalcore or 0
    if metalcore ~= 0 then
        table.insert( tableShow,{16,0,metalcore} )
    end
    local grace = dataTable.grace or 0;
    if grace ~= 0 then
        table.insert( tableShow,{17,0,grace} )
    end
    local grace_high = dataTable.grace_high or 0;
    if grace_high ~= 0 then
        table.insert( tableShow,{18,0,grace_high} )
    end
    local enchant = dataTable.enchant or 0;
    if enchant ~= 0 then
        table.insert( tableShow,{21,0,enchant} )
    end
    local refine_stone = dataTable.refine_stone or 0;
    if refine_stone ~= 0 then
        table.insert( tableShow,{23,0,refine_stone} )
    end
    local gem = dataTable.gem or {}
    local tempIdTab = {};
    for k,itemCid in pairs(gem) do
        if tempIdTab[itemCid] == nil then
            tempIdTab[itemCid] = 1;
        else
            tempIdTab[itemCid] = tempIdTab[itemCid] + 1;
        end
    end
    for itemCid,count in pairs(tempIdTab) do
        table.insert( tableShow,{19,itemCid,count} )
    end
    return tableShow;
end

function M.testShowSortInfo(self,tempid,tempdid,spc,str)
    --[[--cclog("info->"..str)
    cclog("tempid->"..tempid)
    cclog("--tempdid--")
    if type(tempdid) == "number" then
        cclog(tempdid)
    elseif type(tempdid) == "table" then
        for i = 1,#tempdid do
            cclog("number->"..tempdid[i])
        end
    end
    if(spc ~= nil) then
        cclog("spc->"..spc)
    else
        cclog("spcnil")
    end
    cclog("-----------")]]--
end
--[[
    改变sprite的纹理
]]
function M.changeSpriteTexture(self,sprite,textureName,mode)
    if sprite == nil then return end
    mode = mode or 1;
    if mode == 1 then
        local tempFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(textureName)
        if tempFrame then
            sprite:setDisplayFrame(tempFrame);
        end
    else
        local tempSprite = CCSprite:create(textureName);
        sprite:setDisplayFrame(tempSprite:displayFrame());
    end
end

--[[--
    获取装备套装
]]
function M.getEquipSuit(self,suitValue,posEquipData, equipData)
    -- cclog2(suitValue,"suitValue")
    -- cclog2(posEquipData,"posEquipData")
    -- cclog2(equipData,"equipData")
    local suitCount = 0;
    local tempEquipData = {};
    local attrValueTab = {0,0,0,0,0,0};
    local attrValueTabExt = {fire = 0,water = 0,wind = 0,earth = 0,fire_dfs = 0,water_dfs = 0,wind_dfs = 0,earth_dfs = 0}
    posEquipData = posEquipData or {"0","0","0","0"};
    local equipCfg = getConfig(game_config_field.equip);
    local suitCfg = getConfig(game_config_field.suit);
    local suitItemCfg = suitCfg:getNodeWithKey(tostring(suitValue));
    if suitItemCfg then
        local part = suitItemCfg:getNodeWithKey("part")
        local partCount = part:getNodeCount();
        if partCount == 4 then
            for i=1,4 do
                local tempEquipCfg = equipCfg:getNodeWithKey(tostring(part:getNodeAt(i-1):toStr()))
                tempEquipData[i] = {itemCfg = tempEquipCfg,itemData = nil}
                if tempEquipCfg then
                    local tempEquipId = tempEquipCfg:getNodeWithKey("equip_id"):toInt();
                    local tempSort = tempEquipCfg:getNodeWithKey("sort"):toInt();
                    local tempId = tostring(posEquipData[tempSort])
                    if tempId and tempId ~= "0" then
                        local equipItemData,equipItemCfg = nil, nil
                        if not equipData then
                            equipItemData,equipItemCfg = game_data:getEquipDataById(tempId);
                        else
                            equipItemData,equipItemCfg = game_data:getEquipDataByIdFromPool(tempId, equipData);
                        end
                        if equipItemCfg and equipItemCfg:getNodeWithKey("equip_id"):toInt() == tempEquipId then
                            suitCount = suitCount + 1;
                            tempEquipData[i] = {itemData = equipItemData,itemCfg = equipItemCfg}
                        end
                    end
                end
            end
        end
        local effectItem = nil;
        for i=2,4 do
            effectItem = suitItemCfg:getNodeWithKey("effect_" .. i)
            local tempCount = effectItem:getNodeCount();
            local len = (i == 4 and 4 or 2);
            for j=1,tempCount do
                if j <= tempCount then
                    local tempItem = effectItem:getNodeAt(j-1);
                    local attType = tempItem:getNodeAt(0):toInt();
                    local attValue = tempItem:getNodeAt(1):toInt();
                    -- cclog("attType ========== " .. attType .. " ; attValue =========== " .. attValue)
                    if i <= suitCount then
                        if attType > 5 then
                            attrValueTab[6] = attrValueTab[6] + attValue;
                            local tempItemData = PUBLIC_ABILITY_TABLE["ability_" .. attType];
                            if tempItemData then
                                attrValueTabExt[tempItemData.attrName] = attrValueTabExt[tempItemData.attrName] + attValue
                            end
                        else
                            attrValueTab[attType] = attrValueTab[attType] + attValue;
                        end
                    end
                end
            end
        end
    end
    -- cclog("suitCount ================== " .. suitCount)
    -- table.foreach(attrValueTab,print)
    -- cclog("getEquipSuit json.encode(attrValueTab) ======== " .. json.encode(attrValueTab))
    return suitCount,tempEquipData,attrValueTab,attrValueTabExt;
end

--[[--
    联协
]]
function M.getCardAndEquipChainTab(self,cardId,teamData,equipData)
    local card_data,_ = game_data:getCardDataById(cardId)
    local teamTable = game_data:getTeamData() or {};
    if teamData ~= nil then
        local teamTable = teamData or {};
    end
    local teamCharacterIdTab = {};
    local posIndex = -1;
    local chainTeamType = 1;
    for k,v in pairs(teamTable) do
        local _,heroCfg = game_data:getCardDataById(tostring(v));
        if heroCfg then
            teamCharacterIdTab[heroCfg:getNodeWithKey("character_ID"):toInt()] = k;
        end
        if v == cardId then
            posIndex = k;
        end
    end
    local friendData = game_data:getAssistant() or {};
    for k,v in pairs(friendData) do
        local _,heroCfg = game_data:getCardDataById(tostring(v));
        if heroCfg then
            teamCharacterIdTab[heroCfg:getNodeWithKey("character_ID"):toInt()] = k;
        end
        if v == cardId then
            posIndex = k;
            chainTeamType = 2;
        end
    end
    local destinyData = game_data:getDestiny() or {};--命运小伙伴
    for k,v in pairs(destinyData) do
        local _,heroCfg = game_data:getCardDataById(tostring(v));
        if heroCfg then
            teamCharacterIdTab[heroCfg:getNodeWithKey("character_ID"):toInt()] = k;
        end

    end
    local fromationBonusData = game_data:getFormationBonusByJsonData() or {} -- 新阵法
    for k,v in pairs(fromationBonusData) do
        local _,heroCfg = game_data:getCardDataById(tostring(v));
        if heroCfg then
            teamCharacterIdTab[heroCfg:getNodeWithKey("character_ID"):toInt()] = k;
        end
        if v == cardId then
            posIndex = k;
            chainTeamType = 3;
        end
    end
    if posIndex == -1 then
        teamCharacterIdTab = {};
    end
    local teamEquipIdTab = {};
    if chainTeamType == 1 then
        local equipPosData = game_data:getEquipPosData() or {};
        if equipData ~= nil then
            local equipPosData = equipData or {};
        end
        local tempPosEquip = equipPosData[tostring(posIndex-1)] or {};
        if card_data and card_data.bind_equip then
            for k,v in pairs(card_data.bind_equip) do
                if v ~= 0 then
                    tempPosEquip[k] = tostring(v)
                end
            end
        end
        for k,v in pairs(tempPosEquip) do
            local equipData,equipCfg = game_data:getEquipDataById(v);
            if equipCfg and (equipData.bind_card == "" or  equipData.bind_card == cardId) then
                local chain_id = equipCfg:getNodeWithKey("chain_id")
                chain_id = chain_id and chain_id:toInt() or equipCfg:getNodeWithKey("equip_id"):toInt()
                teamEquipIdTab[chain_id] = k;
            end
        end
    elseif chainTeamType == 3 then
        local equipPosData = game_data:getFormationBonusEquipData()
        local tempPosEquip = equipPosData[tostring(posIndex+199)] or {};
        if card_data.bind_equip then
            for k,v in pairs(card_data.bind_equip) do
                if v ~= 0 then
                    tempPosEquip[k] = tostring(v)
                end
            end
        end
        for k,v in pairs(tempPosEquip) do
            local equipData,equipCfg = game_data:getEquipDataById(v);
            if equipCfg and (equipData.bind_card == "" or  equipData.bind_card == cardId) then
                local chain_id = equipCfg:getNodeWithKey("chain_id")
                chain_id = chain_id and chain_id:toInt() or equipCfg:getNodeWithKey("equip_id"):toInt()
                teamEquipIdTab[chain_id] = k;
            end
        end 
    else
        local equipPosData = game_data:getAssEquipPosData()
        local tempPosEquip = equipPosData[tostring(posIndex+99)] or {};
        if card_data.bind_equip then
            for k,v in pairs(card_data.bind_equip) do
                if v ~= 0 then
                    tempPosEquip[k] = tostring(v)
                end
            end
        end
        for k,v in pairs(tempPosEquip) do
            local equipData,equipCfg = game_data:getEquipDataById(v);
            if equipCfg and (equipData.bind_card == "" or  equipData.bind_card == cardId) then
                local chain_id = equipCfg:getNodeWithKey("chain_id")
                chain_id = chain_id and chain_id:toInt() or equipCfg:getNodeWithKey("equip_id"):toInt()
                teamEquipIdTab[chain_id] = k;
            end
        end  
    end
    -- if card_data.bind_data then
    --     for k,v in pairs(card_data.bind_data) do
    --         print(k,v)
    --         if v~= 0 then
    --             teamEquipIdTab[k] = v
    --         end
    --     end
    -- end
    return teamCharacterIdTab,teamEquipIdTab;
end

--[[--
    联协
]]
function M.getPlayerCardAndEquipChainTab(self,cardId, playerData ,teamData,equipData)
    local teamTable = playerData:getTeamData() or {};
    local equipPosData = playerData:getEquipPosData() or {};
    if teamData ~= nil or equipData ~= nil then
        local teamTable = teamData or {};
        local equipPosData = equipData or {};
    end
    local teamCharacterIdTab = {};
    local posIndex = -1;
    for k,v in pairs(teamTable) do
        local _,heroCfg = playerData:getCardDataById(tostring(v));
        if heroCfg then
            teamCharacterIdTab[heroCfg:getNodeWithKey("character_ID"):toInt()] = k;
        end
        if v == cardId then
            posIndex = k;
        end
    end
    local friendData = playerData:getAssistant() or {};
    for k,v in pairs(friendData) do
        if v ~= "-1" and v ~= "0" then
            local _,heroCfg = playerData:getCardDataById(tostring(v));
            if heroCfg then
                teamCharacterIdTab[heroCfg:getNodeWithKey("character_ID"):toInt()] = k;
            end
        end
    end
    if posIndex == -1 then
        teamCharacterIdTab = {};
    end
    local teamEquipIdTab = {};
    local tempPosEquip = equipPosData[tostring(posIndex-1)] or {};
    for k,v in pairs(tempPosEquip) do
        local _,equipCfg = playerData:getEquipDataById(v);
        if equipCfg then
            local chain_id = equipCfg:getNodeWithKey("chain_id")
            chain_id = chain_id and chain_id:toInt() or equipCfg:getNodeWithKey("equip_id"):toInt()
            teamEquipIdTab[chain_id] = k;
        end
    end
    return teamCharacterIdTab,teamEquipIdTab;
end

--[[--
    联协
]]
function M.cardChainByCfg(self,heroCfg,cardId, playerData,teamData,equipData)
    local chainTab, openChainCount = {},0;
    if heroCfg == nil then return chainTab end
    local chain = heroCfg:getNodeWithKey("chain")
    local chainCount = chain:getNodeCount();
    -- cclog("chainCount ======================= " .. chainCount)
    local teamCharacterIdTab, teamEquipIdTab = nil, nil
    if chainCount > 0 then
        if playerData then
            teamCharacterIdTab, teamEquipIdTab = self:getPlayerCardAndEquipChainTab(cardId, playerData,teamData,equipData);
        else
            if teamData ~= nil or equipData ~= nil then
                teamCharacterIdTab, teamEquipIdTab = self:getCardAndEquipChainTab1(cardId,teamData,equipData);
            else
                teamCharacterIdTab, teamEquipIdTab = self:getCardAndEquipChainTab(cardId,teamData,equipData);
            end
            
        end

        local character_detail_cfg = getConfig(game_config_field.character_detail);
        local chain_cfg = getConfig(game_config_field.chain);
        local equip_cfg = getConfig(game_config_field.equip);
        for i=1,chainCount do
            local chainId = chain:getNodeAt(i-1):toStr();
            local chainItemCfg = chain_cfg:getNodeWithKey(chainId);
            if chainItemCfg then
                local name = chainItemCfg:getNodeWithKey("name"):toStr();
                local des = chainItemCfg:getNodeWithKey("des"):toStr();
                local effect = chainItemCfg:getNodeWithKey("effect")
                local data = chainItemCfg:getNodeWithKey("data")
                local dataCount = data:getNodeCount();
                local condition_sort = chainItemCfg:getNodeWithKey("condition_sort"):toInt();
                if dataCount > 0 then
                    local tempCount = 0;
                    if condition_sort == 0 then--卡牌联协
                        for i=1,dataCount do
                            local itemCfg = character_detail_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                if teamCharacterIdTab[itemCfg:getNodeWithKey("character_ID"):toInt()] then
                                    des = string.gsub(des,"card" .. i,"[color=ffffdc00]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                    tempCount = tempCount + 1;
                                else
                                    des = string.gsub(des,"card" .. i,"[color=ff8A8A8A]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                end
                            end
                        end
                        if tempCount >= dataCount then--联协开启
                            openChainCount = openChainCount + 1;
                            chainTab[#chainTab + 1] = {name = "[color=ffffdc00]" .. name .. "[/color]",detail = "[color=ffffdc00]" .. name .. "[/color] : " .. des,openFlag = true,count = dataCount ,t = "c" , chain = chainId , nameExt = name}
                        else
                            chainTab[#chainTab + 1] = {name = "[color=ff8A8A8A]" .. name .. "[/color]",detail = "[color=ff8A8A8A]" .. name .. "[/color] : " .. des,openFlag = false,count = tempCount ,t = "c" , chain = chainId , nameExt = name}
                        end
                    elseif condition_sort == 1 then--装备联协
                        for i=1,dataCount do
                            local itemCfg = equip_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                -- cclog("itemCfg:getNodeWithKey(\"equip_id\"):toInt() == " .. itemCfg:getNodeWithKey("equip_id"):toInt())
                                local sort = itemCfg:getNodeWithKey("sort"):toInt();
                                local chain_id = itemCfg:getNodeWithKey("chain_id")
                                chain_id = chain_id and chain_id:toInt() or itemCfg:getNodeWithKey("equip_id"):toInt()
                                if teamEquipIdTab[chain_id] or teamEquipIdTab[sort] then
                                    des = string.gsub(des,"equip" .. i,"[color=ffC636F8]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                    tempCount = tempCount + 1;
                                else
                                    des = string.gsub(des,"equip" .. i,"[color=ff8A8A8A]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                end
                            end
                        end
                        if tempCount >= dataCount then--联协开启
                            openChainCount = openChainCount + 1;
                            chainTab[#chainTab + 1] = {name = "[color=ffC636F8]" .. name .. "[/color]",detail = "[color=ffC636F8]" .. name .. "[/color] : " .. des,openFlag = true, count = dataCount , t = "e" , chain = chainId , nameExt = name}
                        else
                            chainTab[#chainTab + 1] = {name = "[color=ff8A8A8A]" .. name .. "[/color]",detail = "[color=ff8A8A8A]" .. name .. "[/color] : " .. des,openFlag = false, count = tempCount , t = "e" , chain = chainId , nameExt = name}
                        end
                    end
                else
                    chainTab[#chainTab + 1] = {name = name,detail = name .. " : "}
                end
            end
        end
    end
    return chainTab,chainCount,openChainCount
end

--[[--
    获取装备联协
]]
function M.cardEquipChainByCfg(self,heroCfg,cardId, playerData)
    local chainTab = {};
    if heroCfg == nil then return chainTab end
    local chain = heroCfg:getNodeWithKey("chain")
    local chainCount = chain:getNodeCount();
    -- cclog("chainCount ======================= " .. chainCount)
    local chainEquipDataTab = {}
    local equip_cfg = getConfig(game_config_field.equip);
    if chainCount > 0 then
        -- local character_detail_cfg = getConfig(game_config_field.character_detail);
        local chain_cfg = getConfig(game_config_field.chain);
        for i=1,chainCount do
        local chainId = chain:getNodeAt(i-1):toStr();
        local chainItemCfg = chain_cfg:getNodeWithKey(chainId);
        if chainItemCfg then
            local condition_sort = chainItemCfg:getNodeWithKey("condition_sort"):toInt();
            local data = chainItemCfg:getNodeWithKey("data")
            local dataCount = data:getNodeCount();
                if condition_sort == 1 then--装备联协
                    for i=1,dataCount do
                        local itemCfg = equip_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                        -- cclog2(itemCfg , "equip chain  itemCfg =======  ")
                        if itemCfg then
                            chainEquipDataTab[#chainEquipDataTab+1] = json.decode(itemCfg:getFormatBuffer())
                        end
                    end
                end
            end
        end
    end
    --加万能缘装备
    for i=1,equip_cfg:getNodeCount() do
        local itemCfg = equip_cfg:getNodeAt(i-1)
        local chain_id = itemCfg:getNodeWithKey("chain_id"):toInt()
        if chain_id == 1 or chain_id == 2 or chain_id == 3 or chain_id == 4 then
            chainEquipDataTab[#chainEquipDataTab+1] = json.decode(itemCfg:getFormatBuffer())
        end
    end

    return chainEquipDataTab
end

--[[
    -- 检查此装备是否是这张卡牌的连协
    -- equipCfg 装备信息cfg
    -- chainEquipTab 连协装备表
]]
function M.isCardChainEquip( self, equipCfg, chainEquipTab )
    if not equipCfg or not chainEquipTab then return false end  -- 传的数据不对
    for i,v in ipairs(chainEquipTab) do
        if v.equip_id == (equipCfg:getNodeWithKey("equip_id") and equipCfg:getNodeWithKey("equip_id"):toInt() or -1) then
            return true
        end
    end
    return false
end

--[[--
    敌方联协
]]
function M.dfdCardChainByCfg(self,heroCfg,cardId,dfdAll,dfdFriend )
    local chainTab = {};
    if heroCfg == nil then return chainTab end
    local chain = heroCfg:getNodeWithKey("chain")
    local chainCount = chain:getNodeCount();
    cclog("chainCount ======================= " .. chainCount)
    if chainCount > 0 then
        -- cclog(json.encode(dfdAll));
        local teamTable = dfdAll or {};
        local equipPosData = {};
        local teamCharacterIdTab = {};
        local posIndex = 1;
        local character_detail_cfg = getConfig(game_config_field.character_detail);

        for k,v in pairs(teamTable) do
            cclog("  ----------- card_id : " .. tostring(v.card_id));
            local heroCfg = character_detail_cfg:getNodeWithKey(tostring(v.card_id));

            -- local _,heroCfg = game_data:getCardDataById(tostring(cId));
            if heroCfg then
                teamCharacterIdTab[heroCfg:getNodeWithKey("character_ID"):toInt()] = k;
            else
                cclog("----------- v.card_id " .. tostring(v.card_id));
            end
            if v.card_id == cardId then
                posIndex = k;
            end
        end


        local friendData = dfdFriend or {};
        for k,v in pairs(friendData) do
            if v ~= "-1" and v ~= "0" then
                local valueTab = util.stringSplit(tostring(v),"-");
                local heroCfg = character_detail_cfg:getNodeWithKey(tostring(valueTab[1]));
                if heroCfg then
                    teamCharacterIdTab[heroCfg:getNodeWithKey("character_ID"):toInt()] = k;
                end
            end
        end

        if posIndex == -1 then
            teamCharacterIdTab = {};
        end
        local teamEquipIdTab = {};
        local tempPosEquip = equipPosData[tostring(posIndex-1)] or {};
        for k,v in pairs(tempPosEquip) do
            local _,equipCfg = game_data:getEquipDataById(v);
            if equipCfg then
                teamEquipIdTab[equipCfg:getNodeWithKey("equip_id"):toInt()] = k;
            end
        end

        local character_detail_cfg = getConfig(game_config_field.character_detail);
        local chain_cfg = getConfig(game_config_field.chain);
        local equip_cfg = getConfig(game_config_field.equip);
        for i=1,chainCount do
            local chainId = chain:getNodeAt(i-1):toStr();
            local chainItemCfg = chain_cfg:getNodeWithKey(chainId);
            if chainItemCfg then
                local name = chainItemCfg:getNodeWithKey("name"):toStr();
                local des = chainItemCfg:getNodeWithKey("des"):toStr();
                local effect = chainItemCfg:getNodeWithKey("effect")
                local data = chainItemCfg:getNodeWithKey("data")
                local dataCount = data:getNodeCount();
                local condition_sort = chainItemCfg:getNodeWithKey("condition_sort"):toInt();
                if dataCount > 0 then
                    local tempCount = 0;
                    if condition_sort == 0 then--卡牌联协
                        for i=1,dataCount do
                            local itemCfg = character_detail_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                if teamCharacterIdTab[itemCfg:getNodeWithKey("character_ID"):toInt()] then
                                    des = string.gsub(des,"card" .. i,"[color=ffffdc00]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                    tempCount = tempCount + 1;
                                else
                                    des = string.gsub(des,"card" .. i,"[color=ff8A8A8A]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                end
                            end
                        end
                        if tempCount >= dataCount then--联协开启
                            chainTab[#chainTab + 1] = {name = "[color=ffffdc00]" .. name .. "[/color]",detail = "[color=ffffdc00]" .. name .. "[/color] : " .. des,openFlag = true,count = dataCount ,t = "c" , chain = chainId , nameExt = name}
                        else
                            cclog("-------------- tempCount : " .. tostring(tempCount) .. "  dataCount : " .. tostring(dataCount) .. " name:" .. name);
                            chainTab[#chainTab + 1] = {name = "[color=ff8A8A8A]" .. name .. "[/color]",detail = "[color=ff8A8A8A]" .. name .. "[/color] : " .. des,openFlag = false,count = tempCount ,t = "c" , chain = chainId , nameExt = name}
                        end
                    elseif condition_sort == 1 then--装备联协
                        for i=1,dataCount do
                            local itemCfg = equip_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                -- cclog("itemCfg:getNodeWithKey(\"equip_id\"):toInt() == " .. itemCfg:getNodeWithKey("equip_id"):toInt())
                                local sort = itemCfg:getNodeWithKey("sort"):toInt();
                                local chain_id = itemCfg:getNodeWithKey("chain_id")
                                chain_id = chain_id and chain_id:toInt() or itemCfg:getNodeWithKey("equip_id"):toInt()
                                if teamEquipIdTab[chain_id] or teamEquipIdTab[sort] then
                                    des = string.gsub(des,"equip" .. i,"[color=ffC636F8]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                    tempCount = tempCount + 1;
                                else
                                    des = string.gsub(des,"equip" .. i,"[color=ff8A8A8A]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                end
                            end
                        end
                        if tempCount >= dataCount then--联协开启
                            chainTab[#chainTab + 1] = {name = "[color=ffC636F8]" .. name .. "[/color]",detail = "[color=ffC636F8]" .. name .. "[/color] : " .. des,openFlag = true, count = dataCount , t = "e" , chain = chainId , nameExt = name}
                        else
                            chainTab[#chainTab + 1] = {name = "[color=ff8A8A8A]" .. name .. "[/color]",detail = "[color=ff8A8A8A]" .. name .. "[/color] : " .. des,openFlag = false, count = tempCount , t = "e" , chain = chainId , nameExt = name}
                        end
                    end
                else
                    chainTab[#chainTab + 1] = {name = name,detail = name .. " : "}
                end
            end
        end
    end
    return chainTab
end

--[[--
    联协属性加成
]]
function M.getChainCombat(self)

end


--[[--
    联协属性加成倍数
]]
function M.getCombatBonusMultiplierByCfg(self,heroCfg,cardId,teamData,equipData)
    local attrValueTab = {0,0,0,0,0};
    if heroCfg == nil then return attrValueTab end
    local chain = heroCfg:getNodeWithKey("chain")
    local chainCount = chain:getNodeCount();
    -- cclog("chainCount ======================= " .. chainCount)
    if chainCount > 0 then
        local teamCharacterIdTab, teamEquipIdTab = {},{}
        if teamData ~= nil or equipData ~= nil then
            teamCharacterIdTab, teamEquipIdTab = self:getCardAndEquipChainTab1(cardId,teamData,equipData);
            -- cclog2(teamEquipIdTab, "teamEquipIdTab========")
            
        else
            teamCharacterIdTab, teamEquipIdTab = self:getCardAndEquipChainTab(cardId,teamData,equipData);
        end

        local character_detail_cfg = getConfig(game_config_field.character_detail);
        local chain_cfg = getConfig(game_config_field.chain);
        local equip_cfg = getConfig(game_config_field.equip);
        for i=1,chainCount do
            local chainItemCfg = chain_cfg:getNodeWithKey(chain:getNodeAt(i-1):toStr());
            if chainItemCfg then
                local name = chainItemCfg:getNodeWithKey("name"):toStr();
                local data = chainItemCfg:getNodeWithKey("data")
                local dataCount = data:getNodeCount();
                local condition_sort = chainItemCfg:getNodeWithKey("condition_sort"):toInt();
                if dataCount > 0 then
                    local tempCount = 0;
                    if condition_sort == 0 then--卡牌联协
                        for i=1,dataCount do
                            local itemCfg = character_detail_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                if teamCharacterIdTab[itemCfg:getNodeWithKey("character_ID"):toInt()] then
                                    tempCount = tempCount + 1;
                                end
                            end
                        end
                    elseif condition_sort == 1 then--装备联协
                        for i=1,dataCount do
                            local itemCfg = equip_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                local sort = itemCfg:getNodeWithKey("sort"):toInt();
                                local chain_id = itemCfg:getNodeWithKey("chain_id")
                                chain_id = chain_id and chain_id:toInt() or itemCfg:getNodeWithKey("equip_id"):toInt()
                                if teamEquipIdTab[chain_id] or teamEquipIdTab[sort] then
                                    tempCount = tempCount + 1;
                                end
                            end
                        end
                    end
                    if tempCount >= dataCount then--激活
                        local effectTab = json.decode(chainItemCfg:getNodeWithKey("effect"):getFormatBuffer()) or {}
                        for k,v in pairs(effectTab) do
                            if #v == 2 then
                                attrValueTab[v[1] + 1] = attrValueTab[v[1] + 1]  + v[2]*0.001;
                            end
                        end
                    end
                end
            end
        end
    end
    -- cclog("getCombatBonusMultiplierByCfg json.encode(attrValueTab) ======== " .. json.encode(attrValueTab))
    return attrValueTab
end

--[[--
    联协
]]
function M.getCardAndEquipChainTab1(self,cardId,teamData,equipData)
   
    local teamTable = teamData or {};
    local teamCharacterIdTab = {};
    
    local posIndex = -1;
    local chainTeamType = 1;
    for k,v in pairs(teamTable) do
        local _,heroCfg = game_data:getCardDataById(tostring(v));
        if heroCfg then

            teamCharacterIdTab[heroCfg:getNodeWithKey("character_ID"):toInt()] = k;
        end
        if v == cardId then
            posIndex = k;
        end
    end
    if posIndex == -1 then
        teamCharacterIdTab = {};
    end
    local teamEquipIdTab = {};
        local equipPosData = equipData or {};
        local tempPosEquip = equipPosData[posIndex] or {};
        for k,v in pairs(tempPosEquip) do
            local _,equipCfg = game_data:getEquipDataById(v);
            if equipCfg then
                local chain_id = equipCfg:getNodeWithKey("chain_id")
                chain_id = chain_id and chain_id:toInt() or equipCfg:getNodeWithKey("equip_id"):toInt()
                teamEquipIdTab[chain_id] = k;
            end
        end
    return teamCharacterIdTab,teamEquipIdTab;
end

--[[
    设置table view 的 index
    index 索引 table view 父节点 tag , 一页显示几个cell
]]
function M.setTableViewIndex(self,index,tableNode,tag,cellCount)
    if type(index) ~= "number" or type(cellCount) ~= "number" then return end
    if index < cellCount - 1 then
        return
    end
    local tempTable = tolua.cast(tableNode:getChildByTag(tag),"TableView")
    local contentSize = tempTable:getContentSize()
    local viewSize = tempTable:getViewSize()
    local size = tableNode:getContentSize()
    -- cclog("contentSize = " .. contentSize.height .. "size = " .. size.height)
    local cellHeight = size.height  / cellCount;--一个cell的高度


    if viewSize.height <= contentSize.height then--如果contentSize 大于 viewSize 则不需要设置偏移
        tempTable:setContentOffset(ccp(0, math.min(viewSize.height - contentSize.height + index * cellHeight, 0)))
    end
end

function M.removeFile(self,fileName)
    os.remove(fileName);
end

--[[
    脉冲动画
]]
function M.createPulseAnmi(self,frameName,parentNode)
    local scale_time = 0.4
    local wait_time = 0.7
    local action_sprite = CCSprite:createWithSpriteFrameName(frameName)
    local action_sprite_2 = CCSprite:createWithSpriteFrameName(frameName)

    local actionArr = CCArray:create()
    local actionArr2 = CCArray:create()

    local function newFunc(node)    
        action_sprite:setScale(1)
        action_sprite:setOpacity(255)
    end
    local function newFunc2(node)    
        action_sprite_2:setScale(1)
        action_sprite_2:setOpacity(255)
    end
    actionArr:addObject(CCDelayTime:create(scale_time))
    actionArr:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(scale_time/2),CCScaleBy:create(scale_time/2,1.5)))
    actionArr:addObject(CCCallFuncN:create(newFunc))
    actionArr:addObject(CCDelayTime:create(wait_time))

    -- actionArr:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(scale_time),CCScaleBy:create(scale_time,0.5)))
    local timeInterval = 0.15
    actionArr2:addObject(CCDelayTime:create(scale_time+timeInterval))
    actionArr2:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(scale_time/2),CCScaleBy:create(scale_time/2,1.5)))
    actionArr2:addObject(CCCallFuncN:create(newFunc2))
    actionArr2:addObject(CCDelayTime:create(wait_time-timeInterval))

    local animArr = CCArray:create();
    animArr:addObject(CCScaleBy:create(scale_time,1.2));
    animArr:addObject(CCScaleBy:create(scale_time/2,1/1.2))
    animArr:addObject(CCDelayTime:create(wait_time))

    action_sprite:setAnchorPoint(ccp(0.5,0.5))
    action_sprite:setPosition(ccp(action_sprite:getContentSize().width*0.5,action_sprite:getContentSize().height*0.5))
    parentNode:addChild(action_sprite,-1,10)

    action_sprite_2:setAnchorPoint(ccp(0.5,0.5))
    action_sprite_2:setPosition(ccp(action_sprite:getContentSize().width*0.5,action_sprite:getContentSize().height*0.5))
    parentNode:addChild(action_sprite_2,-2,11)

    parentNode:runAction(CCRepeatForever:create(CCSequence:create(animArr)));
    action_sprite:runAction(CCRepeatForever:create(CCSequence:create(actionArr)))
    action_sprite_2:runAction(CCRepeatForever:create(CCSequence:create(actionArr2)))
end


--[[
    脉冲动画
]]
function M.createPulseAnmi2(self,frameName,parentNode)
    local scale_time = 0.4
    local wait_time = 0.7
    local action_sprite = CCSprite:createWithSpriteFrameName(frameName)
    local action_sprite_2 = CCSprite:createWithSpriteFrameName(frameName)

    local actionArr = CCArray:create()
    local actionArr2 = CCArray:create()

    local function newFunc(node)    
        action_sprite:setScale(1)
        action_sprite:setOpacity(255)
    end
    local function newFunc2(node)    
        action_sprite_2:setScale(1)
        action_sprite_2:setOpacity(255)
    end
    actionArr:addObject(CCDelayTime:create(scale_time))
    actionArr:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(scale_time/2),CCScaleBy:create(scale_time/2,1.2)))
    actionArr:addObject(CCCallFuncN:create(newFunc))
    actionArr:addObject(CCDelayTime:create(wait_time))

    -- actionArr:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(scale_time),CCScaleBy:create(scale_time,0.5)))
    local timeInterval = 0.15
    actionArr2:addObject(CCDelayTime:create(scale_time+timeInterval))
    actionArr2:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(scale_time/2),CCScaleBy:create(scale_time/2,1.2)))
    actionArr2:addObject(CCCallFuncN:create(newFunc2))
    actionArr2:addObject(CCDelayTime:create(wait_time-timeInterval))

    local animArr = CCArray:create();
    animArr:addObject(CCScaleBy:create(scale_time,1.1));
    animArr:addObject(CCScaleBy:create(scale_time/2,1/1.1))
    animArr:addObject(CCDelayTime:create(wait_time))

    -- action_sprite:setAnchorPoint(ccp(0.5,0.5))
    -- action_sprite:setPosition(ccp(action_sprite:getContentSize().width*0.5,action_sprite:getContentSize().height*0.5))
    -- parentNode:addChild(action_sprite,-1,10)

    -- action_sprite_2:setAnchorPoint(ccp(0.5,0.5))
    -- action_sprite_2:setPosition(ccp(action_sprite:getContentSize().width*0.5,action_sprite:getContentSize().height*0.5))
    -- parentNode:addChild(action_sprite_2,-2,11)

    parentNode:runAction(CCRepeatForever:create(CCSequence:create(animArr)));
    action_sprite:runAction(CCRepeatForever:create(CCSequence:create(actionArr)))
    action_sprite_2:runAction(CCRepeatForever:create(CCSequence:create(actionArr2)))
end

--[[--

]]
function M.getEvolutionCfgByQuality(self,quality)
    return game_data:getEvolutionCfgByQuality(quality);
end

--[[--

]]
function M.getEnemyCfgByStageIdAndEnemyId(self,stageId,enemyId)
    local enemy_detail_cfg,enemyCfg = nil,nil;
    -- stageId = stageId or game_data:getSelCityId();
    -- enemy_detail_cfg = getConfig("enemy_soldier_" .. stageId);
    -- if enemy_detail_cfg then
    --     enemyCfg = enemy_detail_cfg:getNodeWithKey(tostring(enemyId))
    -- end
    -- if enemyCfg == nil then
    --     local enemy_detail_cfg = getConfig(game_config_field.enemy_detail);
    --     enemyCfg = enemy_detail_cfg:getNodeWithKey(tostring(enemyId))
    -- end
    return enemyCfg;
end
--[[
    创建粒子
    game_util:createParticleSystemQuad({fileName = "particle_fly_up"})
]]
function M.createParticleSystemQuad(self,params)
    local fileName = params.fileName or "particle_fly_up"
    local tempParticle = CCParticleSystemQuad:create(fileName .. ".plist")
    if tempParticle then
        if params.pos then
            tempParticle:setPosition(params.pos);
        end
        tempParticle:setAutoRemoveOnFinish(false);
    end
    return tempParticle
end

--[[
    game_util:addMoveAndRemoveAction({node = node,startPos = ccp(),endPos = ccp(),endCallFunc = nil,moveTime = 1.0})
]]
function M.addMoveAndRemoveAction(self,params)
    local node = params.node
    local startPos = params.startPos or ccp(0, 0)
    local endPos = params.endPos or ccp(0, 0)
    local endCallFunc = params.endCallFunc;
    local moveTime = params.moveTime or 1
    local delayTime = params.delayTime or 0
    local startNode = params.startNode
    if startNode then
        local pX,pY = startNode:getPosition();
        startPos = startNode:getParent():convertToWorldSpace(ccp(pX,pY));
    end
    local endNode = params.endNode
    if endNode then
        local pX,pY = endNode:getPosition();
        endPos = endNode:getParent():convertToWorldSpace(ccp(pX,pY));
    end
    local function callback(tempNode)
        local tag = tempNode:getTag();
        tempNode:removeFromParentAndCleanup(true);
        if endCallFunc then
            endCallFunc(tag);
        end
    end
    local animArr = CCArray:create();
    if delayTime > 0 then
        animArr:addObject(CCDelayTime:create(delayTime));
    end
    animArr:addObject(CCMoveTo:create(moveTime,endPos));
    animArr:addObject(CCCallFuncN:create(callback));
    local sequence = CCSequence:create(animArr)
    node:setPosition(startPos)
    node:runAction(sequence);
end
--[[
    获得卡牌分解的尘数量
]]
function M.getDirValueById(self,cardId)
    local sliver_value = 0;
    local itemData,hero_config = game_data:getCardDataById(cardId)

    local exchange_id = hero_config:getNodeWithKey("exchange_id"):toInt()
    local character_exchange_cfg = getConfig(game_config_field.character_exchange)
    local data_config = character_exchange_cfg:getNodeWithKey(tostring(exchange_id))
    local dirt_gold = data_config:getNodeWithKey("dirt_gold")
    local dirt_silver = data_config:getNodeWithKey("dirt_silver")
    local dirt_silver0 = dirt_silver:getNodeAt(0);
    local evo = (itemData.evo + 1);
    sliver_value = dirt_silver0:getNodeAt(0):toInt()*evo;

    local sliver_max = dirt_silver0:getNodeAt(1):toInt()*evo
    local gold_min = 1*evo
    local gold_max = 1*evo
    for i=1,dirt_gold:getNodeCount() do
        local gold_1 = dirt_gold:getNodeAt(i-1):getNodeAt(0):toInt()
        local gold_2 = dirt_gold:getNodeAt(i-1):getNodeAt(1):toInt()

        if gold_1 < gold_min then
            gold_min = gold_1*evo
        end
        if gold_2 > gold_max then
            gold_max = gold_2*evo
        end
    end
    return sliver_value,gold_min,sliver_max,gold_max;
end

--[[
    
]]
function M.setSelectServerGameUrl(self)
    local server = game_data:getServer();

    --master_url路径
    local len = string.len(server.master_url);
    local endStr = string.sub(server.master_url,len,len);
    if endStr == "/" then
        master_url = string.sub(server.master_url,0,len-1);
    else
        master_url = server.master_url;
    end
    cclog("endStr===============" .. endStr .. " ; master_url = " .. master_url)


    --lua_resource文件的下载路径
    len = string.len(server.lua_url);
    endStr = string.sub(server.lua_url,len,len);
    if endStr == "/" then
        lua_url = string.sub(server.lua_url,0,len-1);
    else
        lua_url = server.lua_url;
    end
    cclog("endStr===============" .. endStr .. " ; lua_url = " .. lua_url)

    --lua_resource文件的版本路径
    len = string.len(server.lua_ver_url);
    endStr = string.sub(server.lua_ver_url,len,len);
    if endStr == "/" then
        lua_ver_url = string.sub(server.lua_ver_url,0,len-1);
    else
        lua_ver_url = server.lua_ver_url;
    end
    cclog("endStr===============" .. endStr .. " ; lua_ver_url = " .. lua_ver_url)


    -- api 服务路径
    len = string.len(server.domain);
    endStr = string.sub(server.domain,len,len);
    if endStr == "/" then
        service_url = string.sub(server.domain,0,len-1);
    else
        service_url = server.domain;
    end
    cclog("endStr===============" .. endStr .. " ; service_url = " .. service_url)


    -- 大逃杀 服务路径
    len = string.len(server.dataosha_url);
    endStr = string.sub(server.dataosha_url,len,len);
    if endStr == "/" then
        dataosha_url = string.sub(server.dataosha_url,0,len-1);
    else
        dataosha_url = server.dataosha_url;
    end
    cclog("endStr===============" .. endStr .. " ; dataosha_url = " .. dataosha_url)

    -- 聊天 服务路ip
    len = string.len(server.chat_ip);
    endStr = string.sub(server.chat_ip,len,len);
    if endStr == "/" then
        chat_ip = string.sub(server.chat_ip,0,len-1);
    else
        chat_ip = server.chat_ip;
    end
    cclog("endStr===============" .. endStr .. " ; chat_ip = " .. chat_ip)
    -- 聊天 服务路 port
    chat_port = tonumber(server.chat_port);
    cclog("endStr===============" .. endStr .. " ; chat_port = " .. chat_port)
end

--[[
    
]]
function M.createExtNumberChangeNode(self,t_params)
    t_params = t_params or {};
    local numberChangeNode
    t_params.labelType = t_params.labelType or 1;
    t_params.value = t_params.value or 0;
    if t_params.labelType == 1 then
        t_params.fontSize = t_params.fontSize or 12
        numberChangeNode = ExtNumberChangeNode:createTTF(t_params.value,TYPE_FACE_TABLE.Arial_BoldMT,t_params.fontSize);
    else
        t_params.fnt = t_params.fnt or "yellow_image_text.fnt"
        numberChangeNode = ExtNumberChangeNode:createBMFont(t_params.value,t_params.fnt)
    end
    if t_params.callBackFunc then
        numberChangeNode:registerScriptHandler(t_params.callBackFunc)
    end
    return numberChangeNode;
end

--[[
    
]]
function M.combatChangedValue(self,t_params)
    local combatNode = t_params.combatNode;
    local value = t_params.value or 0
    if combatNode == nil or value == 0 then
        return;
    end
    local tempLabel = nil;
    if value > 0 then
        tempLabel = self:createLabelBMFont({text = "+" .. value,fnt = "yellow_image_text.fnt",color = ccc3(0, 255, 0)});    
    else
        tempLabel = self:createLabelBMFont({text = value,fnt = "yellow_image_text.fnt",color = ccc3(255, 0, 0)});
    end
    local function remove_node( node )
        node:removeFromParentAndCleanup(true);
    end
    local arr = CCArray:create();
    arr:addObject(CCMoveTo:create(0.2,ccp(0, 15)));
    arr:addObject(CCDelayTime:create(1));
    arr:addObject(CCCallFuncN:create(remove_node));
    tempLabel:runAction(CCSequence:create(arr));
    if t_params.anchorPoint then
        tempLabel:setAnchorPoint(t_params.anchorPoint);
    end
    combatNode:addChild(tempLabel)
end

function M.getPayInfoUrl(self)
    
    local function responseMethod(tag,gameData)

    end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("pay_respon_url"), http_request_method.GET, nil,"pay_respon_url")

end

local MAP_TITLE_DETAIL_CFG_TAB = {game_config_field.map_title_detail,game_config_field.map_title_detail_hell,game_config_field.map_title_detail_purgatory}
--[[--
    通过buildingId获得建筑的配置
]]
function M.getBuildingCfgByBuildingId(self,buildingId)
    local buildingCfgData = nil
    for k,v in pairs(MAP_TITLE_DETAIL_CFG_TAB) do
        local mapConfig = getConfig(v)
        if mapConfig then
            buildingCfgData = mapConfig:getNodeWithKey(tostring(buildingId))
            if buildingCfgData then
                break
            end
        end
    end
    return buildingCfgData;
end


--[[
    
]]
function M.combatChangedValueAnim(self,t_params)
    local combatNode = t_params.combatNode;
    if combatNode == nil then return end;
    local currentValue = t_params.currentValue or self:getCombatValue()
    local changeValue = t_params.changeValue or 0;
    -- combatNode:registerScriptHandler(function()
        self:combatChangedValue({combatNode = combatNode,value = changeValue,anchorPoint = ccp(0, 0.5)});
    -- end)
    -- if changeValue > 0 then
    --     combatNode:setCurValue(currentValue-100,false);
    --     combatNode:setCurValue(currentValue,true,200);
    -- elseif changeValue < 0 then
    --     combatNode:setCurValue(currentValue+100,false);
    --     combatNode:setCurValue(currentValue,true,200);
    -- end
    -- local tempChangeValue = math.abs(changeValue)
    -- if tempChangeValue < 1000 then
    --     combatNode:setCurValue(currentValue,true,200);
    -- elseif tempChangeValue < 10000 then
    --     combatNode:setCurValue(currentValue,true,1000);
    -- else
    --     combatNode:setCurValue(currentValue,true,5000);
    -- end
end

--[[
    奖励卡牌动画
]]
function M.addRewardCardAnim(self,tempId)
    local cardData,heroCfg = game_data:getCardDataById(tostring(tempId));
    local currentUiName = game_scene:getCurrentUiName();
    local game_active_limit_pop = game_scene:getPopByName("game_active_limit_pop")
    if cardData == nil or heroCfg == nil or currentUiName == "game_gacha_scene" or game_active_limit_pop ~= nil then return false end
    local quality = heroCfg:getNodeWithKey("quality"):toInt();
    local animFile = "gacha_anim_1";
    if quality == 3 then
        animFile = "gacha_anim_2";
    elseif quality > 3 then
        animFile = "gacha_anim_3";
    else
        return false;
    end
    local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    local m_root_layer = CCLayerColor:create(ccc4(0, 0, 0, 100), visibleSize.width, visibleSize.height)
    local m_iAnim = zcAnimNode:create(animFile .. ".swf.sam",0,animFile .. ".plist");
    local function animEnd(animNode,theId,lableName)
        if lableName == "daiji" then
        elseif lableName == "xunhuan" then
            animNode:playSection("xunhuan");
        elseif lableName == "fanpai" then
            game_sound:playUiSound("gacha")
            animNode:playSection("xunhuan");
            local animNode = game_util:createHeroListItemByCCB(cardData);
            if animNode then
                animNode:setPosition(ccp(visibleSize.width*0.5, visibleSize.height*0.5))
                m_root_layer:addChild(animNode,20,20)
            end
        end
    end
    m_iAnim:registerScriptTapHandler(animEnd);
    m_iAnim:playSection("daiji");
    m_iAnim:setScale(1);
    m_iAnim:setPosition(ccp(visibleSize.width*0.5, visibleSize.width*0.5))
    local function animEndCallFunc()
        m_iAnim:playSection("fanpai");
    end
    cclog("addGachaAnim ======================== " .. animFile);
    local animArr = CCArray:create();
    animArr:addObject(CCMoveTo:create(0.1,ccp(visibleSize.width*0.5, visibleSize.height*0.5)));
    animArr:addObject(CCCallFunc:create(animEndCallFunc));
    m_iAnim:runAction(CCSequence:create(animArr));
    -- m_iAnim:setPosition(ccp(visibleSize.width*0.5, visibleSize.height*0.5))
    -- game_scene:getPopContainer():addChild(m_iAnim,10,10);
    m_root_layer:addChild(m_iAnim,10,10);
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            m_root_layer:removeFromParentAndCleanup(true);
            return true;--intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY - 100,true);
    m_root_layer:setTouchEnabled(true);
    game_scene:getPopContainer():addChild(m_root_layer,1000,1000);
    return true;
end

--[[
    奖励装备动画  品质大于等于3
]]
function M.addRewardEquipAnim(self,tempId)
    local itemData,itemCfg = game_data:getEquipDataById(tostring(tempId));
    if itemData == nil or itemCfg == nil then return end
    local quality = itemCfg:getNodeWithKey("quality"):toInt();
    local animFile = "gacha_anim_1";
    if quality == 2 then
    elseif quality == 3 then
        animFile = "gacha_anim_2";
    elseif quality > 3 then
        animFile = "gacha_anim_3";
    else
        return;
    end
    local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    local m_root_layer = CCLayerColor:create(ccc4(0, 0, 0, 100), visibleSize.width, visibleSize.height)
    local m_iAnim = zcAnimNode:create(animFile .. ".swf.sam",0,animFile .. ".plist");
    local function animEnd(animNode,theId,lableName)
        if lableName == "daiji" then
        elseif lableName == "xunhuan" then
            animNode:playSection("xunhuan");
        elseif lableName == "fanpai" then
            game_sound:playUiSound("gacha")
            animNode:playSection("xunhuan");
            local animNode = game_util:createEquipItemByCCB(itemData);
            if animNode then
                animNode:setPosition(ccp(visibleSize.width*0.5, visibleSize.height*0.5))
                m_root_layer:addChild(animNode,20,20)
            end
        end
    end
    m_iAnim:registerScriptTapHandler(animEnd);
    m_iAnim:playSection("daiji");
    m_iAnim:setScale(1);
    m_iAnim:setPosition(ccp(visibleSize.width*0.5, visibleSize.width*0.5))
    local function animEndCallFunc()
        m_iAnim:playSection("fanpai");
    end
    cclog("addAnim ======================== " .. animFile);
    local animArr = CCArray:create();
    animArr:addObject(CCMoveTo:create(0.1,ccp(visibleSize.width*0.5, visibleSize.height*0.5)));
    animArr:addObject(CCCallFunc:create(animEndCallFunc));
    m_iAnim:runAction(CCSequence:create(animArr));
    -- m_iAnim:setPosition(ccp(visibleSize.width*0.5, visibleSize.height*0.5))
    -- game_scene:getPopContainer():addChild(m_iAnim,10,10);
    m_root_layer:addChild(m_iAnim,10,10);
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            m_root_layer:removeFromParentAndCleanup(true);
            return true;--intercept event
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY - 100,true);
    m_root_layer:setTouchEnabled(true);
    game_scene:getPopContainer():addChild(m_root_layer,1000,1000);
end


function M.isEqual(self, valueLeft, ...)
    local args = {...}
    for k,v in pairs(args) do
        if valueLeft == v then
            return true
        end
    end
    return false
end

function M.setWordAchieve(self,achieve_btn ,expBar ,world_level ,world_score)
    cclog("world_level ======== " .. tostring(world_level) .. " ; world_score === " .. tostring(world_score))
    world_level = world_level or 1;
    world_score = world_score or 0;
    local integration_world_cfg = getConfig(game_config_field.integration_world)
    local item_cfg = integration_world_cfg:getNodeWithKey(tostring(world_level));
    if item_cfg then
        local maxScore = item_cfg:getNodeWithKey("top"):toInt();
        maxScore = maxScore == 0 and 100 or maxScore;
        expBar:setMaxValue(maxScore);
        expBar:setCurValue(world_score,false);
        local bgSprSize = expBar:getContentSize();
        local tempLabel = self:createLabelTTF({text = string.format("%0.0f",math.floor(100*math.min(maxScore,world_score)/maxScore)) .. "%",color = ccc3(255,255,255),fontSize = 16});
        tempLabel:setPosition(ccp(bgSprSize.width*0.5,bgSprSize.height*0.5));
        expBar:addChild(tempLabel);
    end
end
--[[
    获得卡牌的名称
]]
function M.getCardName(self,itemData,itemCfg)
    if itemData == nil or itemCfg == nil then return "" end
    local bk_value = itemData.bre or 0;
    local character_break_cfg = getConfig(game_config_field.character_break_new)
    local character_ID = itemCfg:getKey()--itemCfg:getNodeWithKey("character_ID"):toStr();
    local character_break_item = character_break_cfg:getNodeWithKey(character_ID)
    local name_after = itemData.step < 1 and "" or ("+" .. itemData.step);
    if character_break_item then
        local name_str = character_break_item:getNodeWithKey("name" .. bk_value)
        if name_str then
            name_after = name_str:toStr() .. name_after
        else
            name_after = itemCfg:getNodeWithKey("name"):toStr() .. name_after
        end
    else
        name_after = itemCfg:getNodeWithKey("name"):toStr() .. name_after
    end
    return name_after;
end

function M.invitePlayerJoinGuild( self, uid, responseMethod )
    local params = {};
    params.target_id = uid
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("guild_invite"), http_request_method.GET, params,"guild_invite")
end

function M.invitePlayerBeFriend( self, uid, responseMethod )
    local params = {};
    params.target_id = uid
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("friend_apply_friend"), http_request_method.GET, params,"friend_apply_friend")
end

function M.createMask( self, width, height, point)
    print(width, height, "createMask ============= ")
    local m_layer = CCLayerColor:create(ccc4(0, 0, 0, 255), width, height);
    local ccb = ccBlendFunc:new_local()
    ccb.src = GL_ZERO;
    ccb.dst = GL_ONE_MINUS_SRC_ALPHA;

    m_layer:setBlendFunc(ccb);
    m_layer:setPosition(point);
    local s = CCDirector:sharedDirector():getWinSize();
    
    local rt = CCRenderTexture:create(s.width, s.height);
    local ccb1 = ccBlendFunc:new_local()
    ccb1.src = GL_SRC_ALPHA;
    ccb1.dst = GL_ONE_MINUS_SRC_ALPHA;
    rt:getSprite():setBlendFunc(ccb1);
    rt:clear(0.0, 0.0, 0.0, 0.8);
    -- rt->clear(0.0f, 0.0f, 0.0f, 0.0f);
    
    rt:setPosition(s.width/2,s.height/2);
    
    rt:begin();
    m_layer:visit();
    rt:endToLua();
    return rt
end

--[[
    创建截屏
]]
function M.createScreenShoot(self)
    local pCurScene = CCDirector:sharedDirector():getRunningScene();
    local screenShoot = nil;
    if pCurScene then
        local tempSize = CCDirector:sharedDirector():getWinSize();  
        screenShoot = CCRenderTexture:create(tempSize.width,tempSize.height, kCCTexture2DPixelFormat_RGB565);
        screenShoot:begin();  
        pCurScene:visit();  
        screenShoot:endToLua();
    end
    return screenShoot;
end

--[[
    创建
    game_util:createCustomLabel({text = "",title = "",labelWidth = size})
]]
function M.createCustomLabel(self,params)
    params = params or {};
    local text = params.text
    if text == nil or text == "" then
        text = "Không có"
    end
    local title = params.title or "Không có"
    local nineBg = params.nineBg or "public_mianshukuang.png"
    local bianqianBg = params.bianqianBg or "public_bianqian.png"
    local labelWidth = params.labelWidth or 100
    local msgLabel = self:createRichLabelTTF({text = text,dimensions = CCSizeMake(labelWidth - 10, 0),textAlignment = kCCTextAlignmentLeft,verticalTextAlignment,color = ccc3(221,221,192)})
    local tempSize = msgLabel:getContentSize()
    local realSize = CCSizeMake(tempSize.width, tempSize.height+30)
    local tempBg = CCScale9Sprite:createWithSpriteFrameName(nineBg);
    tempBg:setPreferredSize(CCSizeMake(labelWidth, tempSize.height + 10))
    tempBg:setPosition(ccp(tempSize.width*0.5, tempSize.height*0.5 + 5))
    msgLabel:setPosition(ccp(tempSize.width*0.5, tempSize.height*0.5 + 5))
    local tempNode = CCNode:create();
    tempNode:setContentSize(realSize)
    tempNode:addChild(tempBg);
    tempNode:addChild(msgLabel);
    local bianqian = CCSprite:createWithSpriteFrameName(bianqianBg)
    local titleLabel = self:createLabelTTF({text = title,color = ccc3(246,221,154),fontSize = 10});
    local bianqianSize = bianqian:getContentSize();
    bianqian:setPosition(ccp(bianqianSize.width*0.5 -5,realSize.height - bianqianSize.height*0.5 -5));
    titleLabel:setPosition(ccp(bianqianSize.width*0.5 -5,realSize.height-bianqianSize.height*0.5 - 5));
    tempNode:addChild(bianqian)
    tempNode:addChild(titleLabel)
    tempNode:setAnchorPoint(ccp(0.5, 0.5))
    tempNode:ignoreAnchorPointForPosition(false);
    return tempNode;
end


--[[--
    Gallery Page
]]
function M.createGalleryPage(self,params)
    if params == nil or type(params) ~= "table" then
        params = {};
    end
    local m_nTotalPage = 1;
    local m_nCurPage = 1;
    if params.totalItem ~= nil then
        m_nTotalPage = tonumber(params.totalItem);
    end
    if params.showPageIndex and m_nTotalPage > 0 then
        m_nCurPage = math.min(params.showPageIndex,m_nTotalPage)
    end
    local galleryLayer = CCLayer:create();
    local pageIndexNode = CCNode:create();
    local tableViewSize = params.viewSize;
    galleryLayer:setContentSize(tableViewSize)
    pageIndexNode:setPosition(ccp(tableViewSize.width*0.5,-visibleSize.height*0.025));
    galleryLayer:addChild(pageIndexNode,20,20);

    local pageLable = CCLabelTTF:create("0/0",TYPE_FACE_TABLE.Arial_BoldMT,10);
    pageLable:setVisible(false);
    pageLable:setAnchorPoint(ccp(1,0));
    pageLable:setPositionX(tableViewSize.width);
    galleryLayer:addChild(pageLable,100,100);
    if m_nTotalPage == 0 then
        pageLable:setVisible(false);
    end
    local leftArrow = CCSprite:createWithSpriteFrameName("o_public_leftArrow.png")
    leftArrow:setScale(0.25)
    leftArrow:setPosition(ccp(-10,tableViewSize.height*0.5));
    galleryLayer:addChild(leftArrow)
    local rightArrow = CCSprite:createWithSpriteFrameName("o_public_leftArrow.png")
    rightArrow:setFlipX(true)
    rightArrow:setScale(0.25)
    rightArrow:setPosition(ccp(tableViewSize.width + 10,tableViewSize.height*0.5));
    galleryLayer:addChild(rightArrow)
    if params.showPoint ~= nil and params.showPoint == false then
        pageIndexNode:setVisible(false);
        leftArrow:setVisible(false);
        rightArrow:setVisible(false);
        pageLable:setVisible(false);
    end
    local posX,posY;
    local direction = 0;
    local function refreshTableView()
        if params.pageChangedCallFunc and m_nTotalPage ~= 0 then
            params.pageChangedCallFunc(m_nTotalPage,m_nCurPage,galleryLayer)
        end
        pageLable:setString(m_nCurPage .. "/" .. m_nTotalPage);
        if m_nTotalPage > 1 then
            if m_nCurPage == 1 then
                leftArrow:setOpacity(0);
                rightArrow:setOpacity(255);
            elseif m_nCurPage == m_nTotalPage then
                leftArrow:setOpacity(255);
                rightArrow:setOpacity(0);
            else
                leftArrow:setOpacity(255);
                rightArrow:setOpacity(255);
            end
        else
            leftArrow:setOpacity(0);
            rightArrow:setOpacity(0);
        end
    end
    refreshTableView();

    local function adjustScrollView(offset)
        -- cclog("adjustScrollView offset =====================" .. tostring(offset));
        local refreshPageIndexFlag = true;
        if offset < -200 then
            m_nCurPage = m_nCurPage + 1;
            direction = 1;
        elseif offset > 200 then
            m_nCurPage = m_nCurPage - 1;
            direction = -1;
        else
            refreshPageIndexFlag = false;
        end
        if m_nCurPage < 1 then
            m_nCurPage = 1;
            refreshPageIndexFlag = false;
        elseif m_nCurPage > m_nTotalPage then
            m_nCurPage = m_nTotalPage;
            refreshPageIndexFlag = false;
        end
        if refreshPageIndexFlag and m_nTotalPage > 1 then
            refreshTableView();
        end
    end
    -- handing touch events
    local touchBeginPoint = nil
    local touchPoint = nil
    local beganTime = nil
    local moveFlag = nil
    local function onTouchBegan(x, y)
        -- cclog("onTouchBegan: %0.2f, %0.2f", x, y)
        touchBeginPoint = {x = x, y = y}
        touchPoint = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        beganTime = os.time();
        moveFlag = false;
        longClick = false;
        if not galleryLayer:boundingBox():containsPoint(galleryLayer:getParent():convertToNodeSpace(ccp(x,y))) then
            return false;
        end
        return true
    end

    local function onTouchMoved(x, y)
        -- cclog("onTouchMoved: %0.2f, %0.2f", x, y)
        if touchPoint then
            local cx, cy = 0,0;
            local offsetX = cx + x - touchPoint.x;
            if offsetX < 100 and offsetX > -100 then
                touchPoint = {x = x, y = y}
            end
        end
        if moveFlag == false then
        end
        moveFlag = true;
    end

    local function onTouchEnded(x, y)
        -- cclog("onTouchEnded: %0.2f, %0.2f", x, y)
        local distance = x - touchBeginPoint.x;
        if distance > 1 or distance < -1 then
            adjustScrollView(distance/math.max(0.1,(os.time() - beganTime)));
        end
        touchBeginPoint = nil
        touchPoint = nil
        beganTime = nil
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
    
    galleryLayer:registerScriptTouchHandler(onTouch,false,params.touchPriority and params.touchPriority-1 or -128,false)
    galleryLayer:setTouchEnabled(true)
    return galleryLayer;
end
--[[
    各种抽卡
]]
function M.setGachaSelect( self,viewSize,in_index )
    local spriteFrameTable = {"equip_title_hero.png","equip_title_equip.png","equip_title_shop.png","equip_title_limit.png"}
    local params = {};
    params.viewSize = viewSize;
    params.row = 4;--行
    params.column = 1; --列
    -- params.direction = kCCScrollViewDirectionHorizontal;
    params.totalItem = 4;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
        if cell == nil then
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create();
            ccbNode:openCCBFile("ccb/ui_4in1_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode");
            if ccbNode then
                local back_sprite = ccbNode:spriteForName("back_sprite");
                local light_add = ccbNode:scale9SpriteForName("light_add")

                back_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(spriteFrameTable[index+1]));
                if (index + 1) == in_index then
                    light_add:setVisible(true)
                else
                    light_add:setVisible(false)
                end
            end
        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        if eventType == "ended" and item then
            if (index + 1) ~= in_index then--跳转界面
                if index == 0 then--伙伴gacha
                    local function responseMethod(tag,gameData)
                        game_scene:enterGameUi("game_gacha_scene",{gameData = gameData});
                    end
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("gacha_get_all_gacha"), http_request_method.GET, nil,"gacha_get_all_gacha")
                elseif index == 1 then--装备gacha
                    -- self:addMoveTips({text = "暂未开放！"})
                    local function responseMethod(tag,gameData)
                        game_scene:enterGameUi("game_gacha_equip",{gameData = gameData});
                    end
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("equip_gacha_get_all_gacha"), http_request_method.GET, nil,"equip_gacha_get_all_gacha")
                elseif index == 2 then--钻石商城
                    function shopOpenResponseMethod(tag,gameData)
                        game_scene:enterGameUi("game_buy_item_scene",{gameData = gameData});
                    end
                    network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("shop_open"), http_request_method.GET, {},"shop_open")
                elseif index == 3 then--限购商城
                    local function responseMethod(tag,gameData)
                        game_scene:enterGameUi("game_limit_shop",{gameData = gameData});
                     end
                    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("shop_outlets_open"), http_request_method.GET, {},"shop_outlets_open");
                end
            end
        end
    end
    return TableViewHelper:create(params);
end
--
function M.createGachaSelect( self,index )
    
end

--[[
    统计：发送用户步数
]]
function M.statisticsSendUserStep( self, newstep )

    -- cclog2(newstep," user step statisticsSendUserStep  =====  ")
    local url = ""

    local device_mark = CCUserDefault:sharedUserDefault():getStringForKey("device_mark");
    if device_mark == nil or device_mark == "" then
        device_mark   = tostring(util_system:macAddres()); -- mac 地址
    end

    local platform_channel = ""
    if util_system.getPlatformChannel then
        platform_channel = tostring(util_system:getPlatformChannel()); -- 平台渠道号
    end
    local user_name = CCUserDefault:sharedUserDefault():getStringForKey("username")
    if user_name == "" then user_name = "nil" end
    url = "http://cjyx-login-sg.pocketgamesol.com/pub_abroad_vn/follow_stat/?login_result=" .. tostring(newstep) .. "&user_name=".. tostring(user_name) .. "&"

    url = url .. "&user_token=" .. tostring(user_token) .. "&mk=" .. tostring(mark_user_login_mk);
    -- url = url .. "&user_token=" .. "g651119638" .. "&backdoor=12581"
    url = url .. "&version=" .. CLIENT_VERSION;
    url = url .. "&pt=" .. device_platform .. "&device_mark=" .. tostring(device_mark) .. "&platform_channel=" .. tostring(platform_channel) 
    if util_system.getTotalMemory then
        url = url .. "&device_mem=" .. tostring(util_system:getTotalMemory())
    end
    newstep = tonumber(newstep)
    if newstep < 7 then
        network.sendHttpRequestNoLoading(nil,url, http_request_method.GET, {step = newstep},"statistics_add_step")
        return
    elseif newstep == 7 then
        network.sendHttpRequestNoLoading(nil,url, http_request_method.GET, {step = newstep},"statistics_add_step")
        url = game_url.getUrlForKey("statistics_add_step")
    else
        url = game_url.getUrlForKey("statistics_add_step")
    end
    -- self.m_netWork.sendHttpRequest( function() end , game_url.getUrlForKey("statistics_add_step") , http_request_method.GET , params_ , "statistics_add_step" ,false );
    network.sendHttpRequestNoLoading(nil,url, http_request_method.GET, {step = newstep},"statistics_add_step")
end

--[[--
    新加宝石的三个特效
]]
function M.createNewGemAnim( self,parentNode,quality,isKuang,tempIconSize,position )
    local animName = {"anim_gem_effect3","anim_gem_effect1","anim_gem_effect4","anim_gem_effect4","anim_gem_effect4","anim_gem_effect4"}
    tempName = animName[quality-10]
    local function onAnimSectionEnd( animNode, theId,theLabelName )
         animNode:playSection(theLabelName);
    end
    local anim = game_util:createBlenderAnim(tempName,1,true);
    anim:registerScriptTapHandler(onAnimSectionEnd)
    if tempIconSize then
        anim:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
    elseif position then
        anim:setPosition(position);
    end
    anim:playSection("impact");
    anim:setScale(0.9)
    parentNode:addChild(anim,10,10)
    if isKuang == "kuang" then
        local anim2 = game_util:createEffectAnim("taozhuangjihuo",1,true,"gem")
        if tempIconSize then
            anim2:setPosition(ccp(tempIconSize.width*0.5+3,tempIconSize.height*0.5));
        end
        parentNode:addChild(anim2,11,11)
    end
    -- body
end

--[[
    通过CID创建命运宝石图标   changedByZJR
]]
function M.createFateGemIconByCid(self,cid,ext)
    ext = ext or {}
    local equip_gem_fate = getConfig(game_config_field.equip_gem_fate);
    local readCid = game_util.bloodStone.gem.getCId(cid)
    local itemCfg = equip_gem_fate:getNodeWithKey(tostring(readCid));
    if itemCfg == nil then return nil,nil end
    if game_util.bloodStone.gem.checkIdHasEmpower(cid) then
        local gemQuality = itemCfg:getNodeWithKey("quality"):toInt()
        local skillId = ext.skillId or game_data.m_formationBloodStoneData.gem_special[cid].skill.sid
        return game_util.bloodStone.createIcon(gemQuality, skillId, ext) ,itemCfg:getNodeWithKey("last_name"):toStr()
    end
    return self:createGemIconByCfg(itemCfg, ext),itemCfg:getNodeWithKey("last_name"):toStr()
end

--[[
    通过CID创建宝石图标
]]
function M.createGemIconByCid(self,cid)
    local gemCfg = getConfig(game_config_field.gem);
    local lv,gemid = self:getRealGemLvAndCid(cid)-----changedByzjr
    local itemCfg = gemCfg:getNodeWithKey(tostring(gemid));
    if itemCfg == nil then return nil,nil end
    return self:createGemIconByCfg(itemCfg),itemCfg:getNodeWithKey("last_name"):toStr()
end
--[[
    通过CID创建圣石图标
]]
function M.createSaintStoneIconByCid(self,cid)
    local gemCfg = getConfig(game_config_field.god_stone);
    local itemCfg = gemCfg:getNodeWithKey(tostring(cid));
    if itemCfg == nil then return nil,nil end
    return self:createGemIconByCfg(itemCfg),itemCfg:getNodeWithKey("last_name"):toStr()
end

--[[
    通过CID创建圣石图标
]]
function M.createSaintStoneIconByCid2(self,cid)
    local tempIcon = nil;
    local gemCfg = getConfig(game_config_field.god_stone);
    local itemCfg = gemCfg:getNodeWithKey(tostring(cid));
    if itemCfg == nil then return nil,nil end
    local icon = itemCfg:getNodeWithKey("icon"):toStr();
    return   self:createIconByName(icon)
end
--[[
    通过Cfg创建宝石图标
]]
function M.createGemIconByCfg(self,itemCfg, ext)
    ext = ext or {}
    local tempIcon = nil;
    if itemCfg then
        local icon = itemCfg:getNodeWithKey("icon"):toStr();
        tempIcon = self:createIconByName(icon)
        if tempIcon == nil then
            cclog(icon .. " image is not found");
        end
    else
        cclog("gem config is not found");
    end
    if tempIcon then
        -- local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
        local quality = itemCfg:getNodeWithKey("quality1") and itemCfg:getNodeWithKey("quality1"):toInt()+1 or itemCfg:getNodeWithKey("quality"):toInt()+1;
        
        -- cclog("quality ==" .. quality)
        local qualityTab = HERO_QUALITY_COLOR_TABLE[quality];
        if qualityTab then
            local tempIconSize = tempIcon:getContentSize();
            local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
            img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img1,-1,1)
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,2)
        end
        local tempIconSize = tempIcon:getContentSize();
        if quality > 10 and quality < 14 then
            self:createNewGemAnim(tempIcon,quality,"kuang",tempIconSize )
        end

        if ext.showNum then
            local countLabel = game_util:createLabelBMFont({text = "×" .. ext.showNum});
            countLabel:setAnchorPoint(ccp(1,0.5));
            countLabel:setPosition(ccp(tempIcon:getContentSize().width, 3))
            tempIcon:addChild(countLabel,10)
        end
    end
    return tempIcon;
end

--[[
    
]]
function M.getGemAttributeValue(self,itemCfg,level)
    local attrName1,value1,icon1 = "Không có","Không có","";
    local attrName2,value2,icon2 = "Không có",0,"";
    value1 = tonumber(itemCfg:getNodeWithKey("value"):toStr())
    local ability = itemCfg:getNodeWithKey("ability"):toInt();
    -- cclog("ability ====================" .. ability)
    local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability]
    if attrTab then
        attrName1 = attrTab.name;
        icon1 = attrTab.icon;
    end
    value2 = itemCfg:getNodeWithKey("value2");
    if value2 then
        value2 = value2:toInt();
        local ability2 = itemCfg:getNodeWithKey("ability2"):toInt();
        local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability2]
        if attrTab then
            attrName2 = attrTab.name;
            icon2 = attrTab.icon;
        end
    else
        value2 = 0
    end
    return attrName1,value1,icon1,attrName2,value2,icon2;
end
--圣石
function M.getSaintStoneAttributeValue(self,itemCfg,level)
    local attrName1,value1,icon1 = "Không có","Không có","";
    local attrName2,value2,icon2 = "Không có",0,"";
    value1 = itemCfg:getNodeWithKey("value"):toInt();
    local ability = itemCfg:getNodeWithKey("ability"):toInt();
    -- cclog("ability ====================" .. ability)
    local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability]
    if attrTab then
        attrName1 = attrTab.name;
        icon1 = attrTab.icon;
    end
    value2 = itemCfg:getNodeWithKey("value2");
    if value2 then
        value2 = value2:toInt();
        local ability2 = itemCfg:getNodeWithKey("ability2"):toInt();
        local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability2]
        if attrTab then
            attrName2 = attrTab.name;
            icon2 = attrTab.icon;
        end
    else
        value2 = 0
    end
    return attrName1,value1,icon1,attrName2,value2,icon2;
end
--[[

]]
function M.createGemItemByCCB(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_gem_system_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setGemItemInfoByTable(ccbNode,itemData);
    end
    -- 先隐藏lb_name, lb_name只有在chinese_character.fnt没有文字的时候使用
    ccbNode:labelTTFForName("lb_name"):setVisible(false)
    return ccbNode
end

function M.createGemItemByCCB7(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_gem_system_list_item3.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    return ccbNode
end

function M.createSaintStoneItemByCCB(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_saint_stone_system_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setGemItemInfoByTable(ccbNode,itemData);
    end
    return ccbNode
end
function M.createFateGemItemByCCB(self,itemData)
    local ccbNode = luaCCBNode:create();

    ccbNode:openCCBFile("ccb/ui_gem_system_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setFateGemItemInfoByTable(ccbNode,itemData);
    end
    -- 先隐藏lb_name, lb_name只有在chinese_character.fnt没有文字的时候使用
    ccbNode:labelTTFForName("lb_name"):setVisible(false)
    return ccbNode
end

function M.setGemItemInfoByTable(self,ccbNode,itemData)
    if ccbNode == nil or itemData == nil then return end
    ccbNode:nodeForName("m_info_node"):setVisible(true);
    local gemCfg = getConfig(game_config_field.gem);
    local gemId = ""-----changedByzjr
    _,gemId = self:getRealGemLvAndCid(itemData.c_id)
    -- cclog2(itemData.c_id,"setGemItemInfoByTable cid  ===")
    local itemCfg = gemCfg:getNodeWithKey(gemId);
    local curValue1,curValue2 = self:getGemAttrByLv(itemData.curGemLv, itemCfg:getNodeWithKey("ability"):toInt() )
    local attrName1,value1,icon1,attrName2,value2,icon2 = self:getGemAttributeValue(itemCfg);
    ccbNode:labelBMFontForName("m_ability1_name_label"):setString(attrName1);
    ccbNode:labelBMFontForName("m_ability1_label"):setString("+" .. value1 + curValue1);

    -- 布局修改
    local m_ability1_name_label = ccbNode:labelBMFontForName("m_ability1_name_label")
    local m_ability1_label = ccbNode:labelBMFontForName("m_ability1_label")
    -- if m_ability1_name_label:getPositionX() + m_ability1_name_label:getContentSize().width + 1 > m_ability1_label:getPositionX() then
    --     m_ability1_label:setPositionX(m_ability1_name_label:getPositionX() + m_ability1_name_label:getContentSize().width + 1)
    -- end
    -- 自适应
    local nd_attr1 = ccbNode:nodeForName("nd_attr1")
    self.adaptNodeChildrensScaleX(nd_attr1, 74, 1)

    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1)
    if tempSpriteFrame then
        ccbNode:spriteForName("m_ability1_icon"):setDisplayFrame(tempSpriteFrame);
    end
    local career = itemCfg:getNodeWithKey("career"):toInt();
    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(PUBLIC_ABILITY_TABLE["ability_" .. career].icon)
    if tempSpriteFrame then
        ccbNode:spriteForName("m_type_icon"):setDisplayFrame(tempSpriteFrame)
    end
    local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
    if quality > 0 and quality < 17 then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(HERO_QUALITY_COLOR_TABLE[quality].card_img));
    end

    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local last_name = itemCfg:getNodeWithKey("last_name"):toStr()
    local first_name = itemCfg:getNodeWithKey("first_name"):toStr()
    m_name_label:setString(last_name .. first_name .. " x" .. tostring(itemData.count));

    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    --防御新增
    local m_ability2_label = ccbNode:labelBMFontForName("m_ability2_label")
    local fangyu_node = ccbNode:nodeForName("fangyu_node")



    
    if value2 > 0 then
        fangyu_node:setVisible(true)
        m_ability2_label:setString("+" .. tostring(value2) + curValue2)-----changedByzjr
    else
        fangyu_node:setVisible(false)
    end
    -- local existFlag,cardName = game_data:gemInGemPos(career,itemData.c_id)
    -- if existFlag then
    --     m_team_img:setVisible(true);
    --     m_team_name:setString(cardName);
    -- else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    -- end
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr()) --self:createGemIconByCfg(itemCfg)
    if icon then
        m_anim_node:addChild(icon)
    end
    local function onAnimSectionEnd( animNode, theId,theLabelName )
        animNode:playSection(theLabelName);
    end
    if quality > 10 and quality < 17 then
        self:createNewGemAnim(m_anim_node,quality,nil,nil )
    end
    local advanced_node = ccbNode:nodeForName("advanced_node")-----changedByzjr
    if itemData.curGemLv and itemData.curGemLv > 0 then
        advanced_node:setVisible(true)
        local advanced_level = ccbNode:labelBMFontForName("advanced_level")
        advanced_level:setString(tostring(itemData.curGemLv))
    else
        advanced_node:setVisible(false)
    end
end
--圣石
function M.setSaintStoneItemInfoByTable(self,ccbNode,itemData)
    if ccbNode == nil or itemData == nil then return end
    ccbNode:nodeForName("m_info_node"):setVisible(true);
    local gemCfg = getConfig(game_config_field.god_stone);
    local itemCfg = gemCfg:getNodeWithKey(itemData.c_id);
    local attrName1,value1,icon1,attrName2,value2,icon2 = self:getSaintStoneAttributeValue(itemCfg);
    ccbNode:labelTTFForName("m_ability1_name_label"):setString(attrName1)
    --ccbNode:labelBMFontForName("m_ability1_name_label"):setString(attrName1);
    --CCLuaLog("name====="..attrName1)
    ccbNode:labelTTFForName("m_ability1_label"):setString("+" .. value1.."%")
    ---ccbNode:labelBMFontForName("m_ability1_label"):setString("+" .. value1.."%");

    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1)
    if tempSpriteFrame then
        ccbNode:spriteForName("m_ability1_icon"):setDisplayFrame(tempSpriteFrame);
    end
    local career = itemCfg:getNodeWithKey("career"):toInt();
    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(PUBLIC_ABILITY_TABLE["ability_" .. career].icon)
    if tempSpriteFrame then
        ccbNode:spriteForName("m_type_icon"):setDisplayFrame(tempSpriteFrame)
    end
    local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
    if quality > 0 and quality < 15 then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(HERO_QUALITY_COLOR_TABLE[quality].card_img));
    end

    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local last_name = itemCfg:getNodeWithKey("last_name"):toStr()
    local first_name = itemCfg:getNodeWithKey("first_name"):toStr()
    m_name_label:setString(last_name .. first_name .. " x" .. tostring(itemData.count));

    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    --防御新增
    local m_ability2_label = ccbNode:labelBMFontForName("m_ability2_label")
    local fangyu_node = ccbNode:nodeForName("fangyu_node")
    if value2 > 0 then
        fangyu_node:setVisible(true)
        m_ability2_label:setString("+" .. tostring(value2))
    else
        fangyu_node:setVisible(false)
    end
    -- local existFlag,cardName = game_data:gemInGemPos(career,itemData.c_id)
    -- if existFlag then
    --     m_team_img:setVisible(true);
    --     m_team_name:setString(cardName);
    -- else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    -- end
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr()) --self:createGemIconByCfg(itemCfg)
    if icon then
        m_anim_node:addChild(icon)
    end
    local function onAnimSectionEnd( animNode, theId,theLabelName )
        animNode:playSection(theLabelName);
    end
    if quality > 10 and quality < 14 then
        self:createNewGemAnim(m_anim_node,quality,nil,nil )
    end
end
--命运宝石
function M.setFateGemItemInfoByTable(self,ccbNode,itemData)
    if ccbNode == nil or itemData == nil then return end
    ccbNode:nodeForName("m_info_node"):setVisible(true);
    local gemCfg = getConfig(game_config_field.equip_gem_fate);
    local itemCfg = gemCfg:getNodeWithKey(itemData.c_id);
    local attrName1,value1,icon1,attrName2,value2,icon2 = self:getGemAttributeValue(itemCfg);
    ccbNode:labelBMFontForName("m_ability1_name_label"):setString(attrName1);
    ccbNode:labelBMFontForName("m_ability1_label"):setString("+" .. value1 .. "%");
    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1)
    if tempSpriteFrame then
        ccbNode:spriteForName("m_ability1_icon"):setDisplayFrame(tempSpriteFrame);
    end
    local career = itemCfg:getNodeWithKey("career"):toInt();
    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(PUBLIC_ABILITY_TABLE["ability_" .. career].icon)
    if tempSpriteFrame then
        ccbNode:spriteForName("m_type_icon"):setDisplayFrame(tempSpriteFrame)
    end
    local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
    if quality > 0 and quality < 15 then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(HERO_QUALITY_COLOR_TABLE[quality].card_img));
    end

    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local last_name = itemCfg:getNodeWithKey("last_name"):toStr()
    local first_name = itemCfg:getNodeWithKey("first_name"):toStr()
    local stone_name = itemCfg:getNodeWithKey("stone_name"):toStr()
    if itemData.usePublicLb then
        m_name_label:setVisible(false)
        m_name_label = ccbNode:labelTTFForName("lb_name")
        m_name_label:setVisible(true)
    end
    if game_util.bloodStone.gem.checkIdHasEmpower(itemData.id) and itemData.skillCfg then
        m_name_label:setString(last_name .. string.gsub(itemData.skillCfg.name, "·", "") .. stone_name)
    else
        m_name_label:setString(last_name .. first_name .. " x" .. tostring(itemData.count));
    end

    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    --防御新增
    local m_ability2_label = ccbNode:labelBMFontForName("m_ability2_label")
    local fangyu_node = ccbNode:nodeForName("fangyu_node")
    if value2 > 0 then
        fangyu_node:setVisible(true)
        m_ability2_label:setString("+" .. tostring(value2) .. "%")
    else
        fangyu_node:setVisible(false)
    end
    -- local existFlag,cardName = game_data:gemInGemPos(career,itemData.c_id)
    -- if existFlag then
    --     m_team_img:setVisible(true);
    --     m_team_name:setString(cardName);
    -- else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    -- end
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon 
    if itemData.id and itemData.id ~= itemData.c_id then
        local gemQuality = itemCfg:getNodeWithKey("quality"):toInt()
        local sid = game_data.m_formationBloodStoneData.gem_special[itemData.id].skill.sid
        icon = game_util.bloodStone.createIcon(gemQuality, sid, {hideFrame= true})
    else
        icon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr()) --self:createGemIconByCfg(itemCfg)
    end
    if icon then
        m_anim_node:addChild(icon)
    end
    local function onAnimSectionEnd( animNode, theId,theLabelName )
        animNode:playSection(theLabelName);
    end
    if quality > 10 and quality < 14 then
        self:createNewGemAnim(m_anim_node,quality,nil,nil )
    end
end






function M.createGemItemByCCB2(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_gem_system_list_item2.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setGemItemInfoByTable2(ccbNode,itemData);
    end
    return ccbNode
end

function M.setGemItemInfoByTable2(self,ccbNode,itemData)
    local gemCfg = getConfig(game_config_field.gem);
    local curGemLv,gemId = 0,0-----changedByzjr
    if itemData.c_id then
         curGemLv,gemId = self:getRealGemLvAndCid(itemData.c_id)
    end
    local itemCfg = gemCfg:getNodeWithKey(tostring(gemId));
    if itemCfg == nil then return end
    local level = itemData.lv;
    local attrName1,value1,icon1 = self:getGemAttributeValue(itemCfg,level);
    ccbNode:labelBMFontForName("m_ability1_label"):setString("+" .. value1);
    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1)
    if tempSpriteFrame then
        ccbNode:spriteForName("m_ability1_icon"):setDisplayFrame(tempSpriteFrame);
    end
    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local last_name = itemCfg:getNodeWithKey("last_name"):toStr()
    local first_name = itemCfg:getNodeWithKey("first_name"):toStr()
    m_name_label:setString(last_name .. first_name .. " x" .. tostring(itemData.count));
    ccbNode:labelBMFontForName("m_ability1_name_label"):setString("");
    
    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    local existFlag,cardName = game_data:gemInGemPos(itemCfg:getNodeWithKey("career"):toInt(),itemData.c_id)
    -- if existFlag then
    --     m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_yizhuangbei.png"));
    --     m_team_img:setVisible(true);
    --     -- m_team_name:setString(cardName);
    --     m_team_name:setString("");
    -- else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    -- end
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createGemIconByCfg(itemCfg)
    if icon then
        icon:setScale(0.75);
        m_anim_node:addChild(icon)
    end
    local m_max_evo_img = ccbNode:spriteForName("m_max_evo_img")
end

function M.getGemRewardId(self,tempId,count)
    -- cclog(tostring(tempId) .. " ; count ===========" .. tostring(count))
    local icon,name,quality = nil,"",0;
    local gemCfg = getConfig(game_config_field.gem);
    local lv,gemId = self:getRealGemLvAndCid(tempId)-----changedByzjr
    local itemCfg = gemCfg:getNodeWithKey(tostring(gemId));
    if itemCfg then
        local last_name = itemCfg:getNodeWithKey("last_name"):toStr()
        local first_name = itemCfg:getNodeWithKey("first_name"):toStr()
        local str = "" -----changedByzjr
        if tonumber(lv) > 0 then
            lv = self:convertNum2Chinese(tonumber(lv))
            str = " Giai đoạn " .. lv
        end
        name = str .. last_name .. first_name
        icon = self:createGemIconByCfg(itemCfg);
        quality = itemCfg:getNodeWithKey("quality"):toInt();    else
        cclog("gemCfg cfg not found == " .. tostring(tempId))
    end
    return icon,name,count,quality;
end
function M.getSaintStoneRewardId(self,tempId,count)
    -- cclog(tostring(tempId) .. " ; count ===========" .. tostring(count))
    local icon,name,quality = nil,"",0;
    local gemCfg = getConfig(game_config_field.god_stone);
    local itemCfg = gemCfg:getNodeWithKey(tostring(tempId));
    if itemCfg then
        local last_name = itemCfg:getNodeWithKey("last_name"):toStr()
        local first_name = itemCfg:getNodeWithKey("first_name"):toStr()
        name = last_name .. first_name
        icon = self:createGemIconByCfg(itemCfg);
        quality = itemCfg:getNodeWithKey("quality"):toInt();
    else
        cclog("gemCfg cfg not found == " .. tostring(tempId))
    end
    return icon,name,count,quality;
end
--[[
    解析时间  dd hh-mm
    结束时时间戳
]]
function M.parseDDHHMMTime1( self, timeStr )
    local prTime = util.string_cut(timeStr, " ")
    local addDay = tonumber(prTime[1]) or 0
    local serTime = game_data:getServerOpenTime() or 0
    local endTime = serTime + (addDay - 1) * 86400   -- 结束时间 = 服务器时间 + （开服天数 - 1）秒数
    local endTimeTable = os.date("*t",endTime)
    local hourMinStr = prTime[2]
    local hourMinStrTable = util.string_cut(hourMinStr, ":")
    local hour = tonumber(hourMinStrTable[1]) or 0   
    local min = tonumber(hourMinStrTable[2]) or 0 
    local sec = tonumber(hourMinStrTable[3]) or 0
    endTimeTable.hour = hour                            -- 替换成配置时间 时
    endTimeTable.min = min                              -- 替换成配置时间 分
    endTimeTable.sec = 0
    local endtime = os.time(endTimeTable)
    return endtime
end

--[[
    根据服务器时间判断是否在开服规定的时间内
    openServerDay  开服活动第几天内
    isRightDay     是否是精确的时间
]]
function M.isInServertimeInServerday( self, openServerDay, isRightDay )
    local serTime = tonumber(game_data:getUserStatusDataByKey("server_time")) or 0
    local serOpen = game_data:getServerOpenTime()
    local serOpenTime = tonumber(serOpen) or 0

    local rightDayTime = serOpenTime + (openServerDay) * 86400
    local rightDayTable = os.date("*t", rightDayTime)
    rightDayTable.hour = 0
    rightDayTable.min = 0
    rightDayTable.sec = 0
    -- local tab = {year=2005, month=11, day=6, hour=22,min=18,sec=30,isdst=false}
    local rightTime = os.time(rightDayTable)
    local flag = false
    if serTime > 0 and serTime < rightTime then 
        flag = true
    end
    -- cclog2(openServerDay, "openServerDay  ===  ")
    -- cclog2(flag, "flag  ===  ")
    return flag
end

--[[
    购买某个支付项
]]
function M.buySthByChargeIndex( self, index, callback )
    local pay_client = require("shared.pay")
    if pay_client then
        pay_client:rechargeByIndex( index, callback )
    end
    return pay_client
end


--[[--
    查看用户
]]
function M.lookPlayerInfo(self,uid, isFriend, enterType)
    local function responseMethod(tag,gameData)
        game_scene:addPop("game_player_info_pop",{gameData = gameData, isFriend = isFriend, enterType = enterType})
    end
    local params = {};
    params.uid = uid;
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("user_info"), http_request_method.GET, params,"user_info")
end

--[[
    获取花费的钻石数
]]
function M.getCostCoinBuyTimes(self,key,buyTimes)
    key = tostring(key)
    buyTimes = buyTimes or 0;
    local canBuy = false;
    local payValue = 0
    local vipLevel = game_data:getVipLevel()
    local vipCfg = getConfig(game_config_field.vip)
    local vipItemCfg = vipCfg:getNodeWithKey(tostring(vipLevel))
    if vipItemCfg then
        local PayCfg = getConfig(game_config_field.pay)
        local itemCfg = PayCfg:getNodeWithKey(key)
        if itemCfg then
            local coin = itemCfg:getNodeWithKey("coin")
            local tempCount = coin:getNodeCount()
            if buyTimes >= tempCount then
                payValue = coin:getNodeAt(tempCount-1):toInt()
            else
                payValue = coin:getNodeAt(buyTimes):toInt()
            end
            local buyLimit = vipItemCfg:getNodeWithKey("buy_point"):toInt()-- 只作买体力的限制，其他不作限制
            if key == "2" and buyTimes < buyLimit then
                canBuy = true;
            end
        else
            self:addMoveTips({text = "pay配置找不到" .. key})
        end
    else
        self:addMoveTips({text = "vip配置找不到" .. vipLevel})
    end
    return canBuy,payValue;
end

--创建物品图标
function M.createMazeItemIconByCfg(self,itemCfg)
    local tempIcon = nil;
    if itemCfg then
        tempIcon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr());
        local quality = itemCfg:getNodeWithKey("quality"):toInt();
        local qualityTab = HERO_QUALITY_COLOR_TABLE[quality+1];
        if tempIcon and qualityTab then
            local tempIconSize = tempIcon:getContentSize();
            local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
            img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img1,-1,1)
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,2)
        end
    end
    return tempIcon;
end
--[[
    回廊获得奖励
]]
function M.createMazeRewardTips(self,stageId,shopIndex)
    local maze_item_cfg = getConfig(game_config_field.maze_item)
    local maze_buff_cfg = getConfig(game_config_field.maze_buff)
    local maze_stage_cfg = getConfig(game_config_field.maze_stage)
    local maze_stage_cfg_item = maze_stage_cfg:getNodeWithKey(tostring(stageId));
    if maze_stage_cfg_item then
        local rewardCount = 0;
        local function createRewardItem(icon,name)
            local bgSpr = CCSprite:createWithSpriteFrameName("public_reward_item_bg.png")
            local bgSprSize = bgSpr:getContentSize();
            if icon then
                icon:setPosition(ccp(bgSprSize.width*0.4,bgSprSize.height*0.5));
                icon:setScale(0.75);
                bgSpr:addChild(icon);
            end
            if name then
                local tempLabel = self:createLabelTTF({text = name,color = ccc3(250,180,0),fontSize = 16});
                tempLabel:setPosition(ccp(bgSprSize.width*0.5,bgSprSize.height*0.5));
                bgSpr:addChild(tempLabel);
            end
            rewardCount = rewardCount + 1;
            self:addMoveTipsByNode(bgSpr,0.5*(rewardCount-1),removeCallFunc);
        end

        local buff = maze_stage_cfg_item:getNodeWithKey("buff")
        local buffCount = buff:getNodeCount();
        if buffCount > 0 then
            for i=1,buffCount do
                local buffId = buff:getNodeAt(i - 1):toStr()
                local maze_buff_cfg_item = maze_buff_cfg:getNodeWithKey(buffId)
                if maze_buff_cfg_item then
                    createRewardItem(nil,"Nhận buff:" .. maze_buff_cfg_item:getNodeWithKey("name"):toStr())
                end
            end
        end
        local item = maze_stage_cfg_item:getNodeWithKey("item")
        local itemCount = item:getNodeCount();
        if itemCount > 0 then
            for i=1,itemCount do
                local buffId = item:getNodeAt(i - 1):toStr()
                local maze_item_cfg_item = maze_item_cfg:getNodeWithKey(buffId)
                if maze_item_cfg_item then
                    createRewardItem(nil,"Nhận đạo cụ:" .. maze_item_cfg_item:getNodeWithKey("name"):toStr())
                end
            end
        end
        local shop = maze_stage_cfg_item:getNodeWithKey("shop")
        local shopCount = shop:getNodeCount();
        local startIndex,endIndex = 1,shopCount;
        if shopIndex then
            startIndex = math.max(1,math.min(shopIndex+1,shopCount));
            endIndex = startIndex;
        end
        for i=startIndex,endIndex do
            local itemCfg = shop:getNodeAt(i-1)
            local value1 = itemCfg:getNodeAt(0):toInt();
            local value2 = itemCfg:getNodeAt(1):toInt();
            if value1 == 1 then--buff
                local maze_buff_cfg_item = maze_buff_cfg:getNodeWithKey(tostring(value2))
                if maze_buff_cfg_item then
                    createRewardItem(nil,"Nhận buff:" .. maze_buff_cfg_item:getNodeWithKey("name"):toStr())
                end
            elseif value1 == 2 then--道具
                local maze_item_cfg_item = maze_item_cfg:getNodeWithKey(tostring(value2))
                if maze_item_cfg_item then
                    createRewardItem(nil,"Nhận đạo cụ:" .. maze_item_cfg_item:getNodeWithKey("name"):toStr())
                end
            elseif value1 == 3 then
                createRewardItem(nil,string_helper.game_util.HP .. value2 .. "%")
            elseif value1 == 4 then
                createRewardItem(nil,string_helper.game_util.HP .. value2)
            end
        end
    end
end

--[[
    更改精灵显示
]]
function M.setSpriteDisplayBySpriteFrameName( self, spr, sprFrameName )
    if not spr or not sprFrameName then return end
    local tempFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(sprFrameName)
    if tempFrame then
        spr:setDisplayFrame(tempFrame)
    end
end


--[[
    数字转换成中文数字
]]
function M.convertNum2Chinese( self, num )
    if num == 0 then return "0" end     -- 直接返回
    local chineseCodes = {string_helper.number.one, string_helper.number.two, string_helper.number.three, string_helper.number.four, string_helper.number.five, string_helper.number.six, string_helper.number.seven, string_helper.number.eight, string_helper.number.nine, string_helper.number.ten}
    local chineseUnit = {"",  string_helper.number.ten, string_helper.number.bai, string_helper.number.qian, string_helper.number.wan, string_helper.number.shiwan, string_helper.number.baiwan, string_helper.number.qianwan, string_helper.number.yi, string_helper.number.shiyi, string_helper.number.baiyi, string_helper.number.qianyi, string_helper.number.wanyi}
    local strnum = tostring(num)
    local conv = function( pos, cur )
        if cur == "0" then return "0" end
        return chineseCodes[tonumber(cur)] .. chineseUnit[tonumber(pos)]
    end
    local fore_word  = ""
    local perstrnum = strnum
    for i=1, string.len(strnum) do
         local cur = string.sub(perstrnum, -1, -1)
         perstrnum = string.sub(perstrnum, 1, -2)
         if cur then
            local oneWord = conv(i , cur )
            if oneWord ~= "0" or fore_word ~= "" then  -- 最后一位不会为零
                fore_word = oneWord .. fore_word 
            end
         end
    end
    srtt = string.gsub(fore_word, "0", "0")  -- 两个零 替换成一个零
    if num > 9 and num < 20 then
        srtt = string.gsub(fore_word, "1", "", 1)  -- 一十二 替换成 十二，只替换掉第一个一
    end
    return srtt
end
--[[
    设置上下移动动作
]]
function M.setNodeUpAndDownMoveAction( self, tempSprite)
    if tempSprite then
        local pX,pY = tempSprite:getPosition();
        local animArr = CCArray:create();
        animArr:addObject(CCMoveTo:create(1,ccp(pX,pY+1)));
        animArr:addObject(CCMoveTo:create(1,ccp(pX,pY-1)));
        tempSprite:runAction(CCRepeatForever:create(CCSequence:create(animArr)));
    end
end

function M.getGuildCombatValue(self)
    local combat_base_cfg = getConfig(game_config_field.combat_base)
    local combat_skill_cfg = getConfig(game_config_field.combat_skill)
    local skill_detail_cfg = getConfig(game_config_field.skill_detail);
    local equip_set_random = getConfig(game_config_field.equip_set_random)

    local combat = 0;
    local teamTable = game_util:getGuildCurFormationId() or {};
    local cardData,heroCfg;
    local hp,patk,matk,def,speed;
    local attrValueTab = {0,0,0,0,0}
    local skill_detail_cfg_item,combat_skill_cfg_item;
    local skillItem,skill_quality,total_factor;

    local attrValueTab2,attrValueTab2ForGodStone = self:getCommanderCombatValue();
    -- cclog2(attrValueTab2,"attrValueTab2")
    -- local attrValueTab3 = self:getAssistantCombatValue();
    -- cclog2(attrValueTab3,"attrValueTab3")
    local equipPosData = game_data:getEquipPosData() or {};
    local equipPosItemData;
    local equipData,equipCfg;
    local value1,value2;
    local ability1,ability2;
    local allUniverseEffect = self:getAllUniverseEffect()
    -- cclog2(allUniverseEffect,"allUniverseEffect")
    for k,v in pairs(teamTable) do
        cardData,heroCfg = game_data:getCardDataById(tostring(v));
        -- cclog2(cardData,"cardData ==== ")
        if cardData and heroCfg then 
            total_factor = 1;
            for i=1,5 do
                skillItem = cardData["s_" .. i]
                if skillItem and skillItem.s ~= 0 and skillItem.avail == 2 then
                    skill_detail_cfg_item = skill_detail_cfg:getNodeWithKey(tostring(skillItem.s));
                    if skill_detail_cfg_item and skillItem.lv > 0 then
                        combat_skill_cfg_item = combat_skill_cfg:getNodeWithKey(tostring(skillItem.lv))
                        skill_quality = skill_detail_cfg_item:getNodeWithKey("skill_quality"):toInt();
                        if combat_skill_cfg_item and skill_quality > -1 and skill_quality <= 7 then
                            total_factor = total_factor + combat_skill_cfg_item:getNodeWithKey(tostring(skill_quality)):toFloat();
                        end
                    end
                end
            end
            local cbmTab = self:getCombatBonusMultiplierByCfg(heroCfg,v);
            attrValueTab = {cardData.patk*(1 + cbmTab[1]),cardData.matk*(1 + cbmTab[2]),cardData.def*(1 + cbmTab[3]),cardData.speed*(1 + cbmTab[4]),cardData.hp*(1 + cbmTab[5])};-- 1物攻 2魔攻 3防御 4速度 5生命
            value1,value2 = 0,0;
            ability1,ability2 = 0,0;
    
            local suitTab = {};
            equipPosItemData = equipPosData[tostring(k-1)]
            if equipPosItemData then
                for k,v in pairs(equipPosItemData) do
                    v = tostring(v)
                    if v ~= "0" then
                        equipData,equipCfg = game_data:getEquipDataById(v);
                        if equipData and equipCfg then
                            value1 = equipCfg:getNodeWithKey("value1"):toInt();
                            value2 = equipCfg:getNodeWithKey("value2"):toInt();
                            local lv = math.max(0,equipData.lv-1)
                            value1 = value1 + equipCfg:getNodeWithKey("level_add1"):toInt()*lv
                            value2 = value2 + equipCfg:getNodeWithKey("level_add2"):toInt()*lv
                            ability1,ability2 = equipCfg:getNodeWithKey("ability1"):toInt(),equipCfg:getNodeWithKey("ability2"):toInt();
                            local equip_refine = equipData.equip_refine or {}
                            if attrValueTab[ability1] then
                                attrValueTab[ability1] = attrValueTab[ability1] + value1
                                local attItem = PUBLIC_ABILITY_TABLE["ability_" .. ability1]
                                if attItem then
                                    attrValueTab[ability1] = attrValueTab[ability1] + (equip_refine[attItem.attrName] or 0)
                                end

                            end
                            if attrValueTab[ability2] then
                                attrValueTab[ability2] = attrValueTab[ability2] + value2;
                                local attItem = PUBLIC_ABILITY_TABLE["ability_" .. ability2]
                                if attItem then
                                    attrValueTab[ability2] = attrValueTab[ability2] + (equip_refine[attItem.attrName] or 0)
                                end
                                -- cclog2(attrValueTab[ability2],"attrValueTab[ability1] -----------2222")

                            end
                            local suit = equipCfg:getNodeWithKey("suit"):toInt();
                            if suitTab[suit] == nil then
                                suitTab[suit] = 0;
                                local suitCount,_,tempAttrValueTab = self:getEquipSuit(suit,equipPosItemData);
                                if suitCount > 0 then
                                    for i=1,5 do
                                        attrValueTab[i] = attrValueTab[i] + tempAttrValueTab[i]
                                    end
                                -- cclog2(attrValueTab[1],"attrValueTab[ability1] -----------3333")

                                end
                            end
                            if equipData.is_enchant == true then--装备的八种新属性
                                local atts = equipData.atts or {}
                                for k,v in pairs(atts) do
                                end
                            end
                            --加装备锻造的属性
                            -- cclog2(equipData.is_equip_forge,"equipData.is_equip_forge")
                            if equipData.is_equip_forge == true then
                                -- local attrname = 
                                -- local tempValue = {0,0,0,0,0}
                                for key_type,valueTable in pairs(equipData.equip_forge) do
                                    local itemEquipForgeCfg = json.decode(equip_set_random:getNodeWithKey(tostring(key_type)):getFormatBuffer())
                                    local sort = itemEquipForgeCfg.sort
                                    local enemy = itemEquipForgeCfg.enemy[1]
                                    local value = 0
                                    for k,v in pairs(valueTable) do
                                        value = v
                                    end
                                    -- cclog2(value,"equp forge value")
                                    if sort > 0 and sort <= 5 then
                                        --改成加数
                                        if enemy ~= -1 then--减敌人的不加
                                            attrValueTab[sort] = attrValueTab[sort] + value
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            --加主角属性升级的属性
            local rolePropertryValueTab = self:getRolePropertryValue()
            --加宠物属性
            local petAttrValueTab = self:getPetCombatValue(k)
            -- cclog2(petAttrValueTab,"petAttrValueTab")
            --加宠物跟随的属性
            local petFollowValueTab = nil;
            petFollowValueTab = self:getPetFollowCombatValue(k)
            
            

            --加战争科技的属性，基本属性和属性攻击也是分开来计算
            --local universeCombatValue,universeAttrValueTab = self:getUniverseCombatValue(v,allUniverseEffect)
            local universeCombatValue,universeAttrValueTab={0,0,0,0,0},{0,0,0,0,0}
 

            -- cclog2((attrValueTab[5] + rolePropertryValueTab[5]+ attrValueTab2[5] + attrValueTab3[5] + gemAttrValueTab[5] + petAttrValueTab[5] + medalAttrValueTab[5] + universeAttrValueTab[5] + petFollowValueTab[5] + soulAttrValueTab[5] + soulPercentCombat[5]),"before =====")

            hp = (attrValueTab[5] + rolePropertryValueTab[5]+ attrValueTab2[5]   + petAttrValueTab[5] +  universeAttrValueTab[5] + petFollowValueTab[5] ) * combat_base_cfg:getNodeWithKey("hp"):toFloat();
            patk = (attrValueTab[1] + rolePropertryValueTab[1]+ attrValueTab2[1]   + petAttrValueTab[1] +  universeAttrValueTab[1] + petFollowValueTab[1] )* combat_base_cfg:getNodeWithKey("patk"):toFloat();
            matk = (attrValueTab[2] + rolePropertryValueTab[2]+  attrValueTab2[2]   + petAttrValueTab[2] +  universeAttrValueTab[2] + petFollowValueTab[2]) * combat_base_cfg:getNodeWithKey("matk"):toFloat();
            def = (attrValueTab[3] + rolePropertryValueTab[3]+  attrValueTab2[3]   + petAttrValueTab[3] +  universeAttrValueTab[3] + petFollowValueTab[3] )* combat_base_cfg:getNodeWithKey("def"):toFloat();
            speed = (attrValueTab[4] +  rolePropertryValueTab[4]+ attrValueTab2[4]   + petAttrValueTab[4] +  universeAttrValueTab[4] + petFollowValueTab[4] )* combat_base_cfg:getNodeWithKey("speed"):toFloat();
            -- cclog2(attrValueTab,"----attrValueTab2222----")
            
            --计算装备绑定加的百分比
            if cardData.bind_equip and next(cardData.bind_equip) then
                local fateEquipData = {0,0,0,0,0}
                fateEquipData = self:getFateEquipValue(cardData.bind_equip)
                hp = math.floor(hp * (1 + fateEquipData[5] * 0.01))
                matk = math.floor(matk * (1 + fateEquipData[2] * 0.01))
                def = math.floor(def * (1 + fateEquipData[3] * 0.01))
                speed = math.floor(speed * (1 + fateEquipData[4] * 0.01))
                patk = math.floor(patk * (1 + fateEquipData[1] * 0.01))
            end

            hp = math.floor(hp)
            patk = math.floor(patk)
            matk = math.floor(matk)
            def = math.floor(def)
            speed = math.floor(speed)
            combat = combat + (hp + patk + matk + def + speed)*total_factor ;
            for k,v in pairs(COMBAT_ABILITY_TABLE.card) do--卡牌的八种新属性
                combat = combat + (cardData[v] or 0)
            end

        end
    end
    local em = game_data:getGuildSelTeamData();
    for k,v in pairs(em) do
        if v.uid and v.combat then

            combat = combat +v.combat 
        end
    end
    cclog("combat =====================" .. combat)
    return math.floor(combat);
end
function M.getAllUniverseEffect(self)
    local super_commander_detail = getConfig(game_config_field.super_commander_detail)
    local hero_race = getConfig(game_config_field.hero_race)
    local super_commander_value = game_data:getCommanderAvailableSkill()
    local universeEffectTable = {}
    for k,v in pairs(super_commander_value) do
        if v > 0 then
            local itemCfg = super_commander_detail:getNodeWithKey(k)
            if itemCfg then
                for level=1,v do
                    local effect = itemCfg:getNodeWithKey("effect_" .. level)
                    local race = itemCfg:getNodeWithKey("race"):toInt()
                    if effect then
                        for i=1,effect:getNodeCount() do
                            local itemEffect = effect:getNodeAt(i-1)
                            local effect_type = itemEffect:getNodeAt(0):toInt()
                            local effect_value = itemEffect:getNodeAt(1):toInt()
                            if universeEffectTable[tostring(race)] == nil then
                                universeEffectTable[tostring(race)] = {}
                            end
                            if universeEffectTable[tostring(race)][tostring(effect_type)] == nil then
                                universeEffectTable[tostring(race)][tostring(effect_type)] = 0
                            end
                            universeEffectTable[tostring(race)][tostring(effect_type)] = universeEffectTable[tostring(race)][tostring(effect_type)] + effect_value
                        end
                    end
                end
            end
        end
    end
    return universeEffectTable
end
--[[
    战争科技能力加成   按 race 分
]]
function M.getUniverseCombatValue(self,cardId,allUniverseEffect)
    local attrValueTab = {0,0,0,0,0}
    local combatValue = 0;
    local hero_race = getConfig(game_config_field.hero_race)

    cardData,heroCfg = game_data:getCardDataById(tostring(cardId));
    local c_id = cardData.c_id
    local raceCfg = hero_race:getNodeWithKey(tostring(c_id))
    if raceCfg then--有则加
        local cardRace = raceCfg:getNodeWithKey("race"):toInt()
        local universeEffect = allUniverseEffect[tostring(cardRace)]
        if universeEffect then
            for k,v in pairs(universeEffect) do
                if tonumber(k) < 200 then
                    attrValueTab[tonumber(k)] = attrValueTab[tonumber(k)] + v
                else
                    combatValue = combatValue + v
                end
            end
        end
    end
    -- cclog2(combatValue,"combatValue")
    -- cclog2(attrValueTab,"attrValueTab")
    return combatValue,attrValueTab
end

function M.getGuildCurFormationId( self )
    local zjrTab = game_data:getGuildFormationData()
    -- cclog2(zjrTab,"zjrTab ==== ")
    local testTab,testTab2 = {},{}
    for k,v in pairs(zjrTab) do
        table.insert(testTab,v)
    end
    table.sort( testTab )
    for i=1,#testTab do
        for k,v in pairs(zjrTab) do
            if testTab[i] == v then
                table.insert(testTab2,k)
            end
        end
    end
    return testTab2
    -- body
end

--[[
    助威属性加成属性计算
]]
function M.getAssistantAttrTab( self, posIndex, assistantEffectItem, assistant_cfg_item, newAttrFlag)
    local attrValueTab,newAttrValueTab = {},{}
    local refreshFlag = false
    local assistant_cfg = getConfig(game_config_field.assistant)
    assistant_cfg_item = assistant_cfg_item or assistant_cfg:getNodeWithKey(tostring(posIndex))
    if assistant_cfg_item then
        local assistant_random_cfg = getConfig(game_config_field.assistant_random)
        assistantEffectItem = assistantEffectItem or {}
        local active_status = assistantEffectItem.active_status or "-1"--是否激活助威属性
        local ass_random_id = assistantEffectItem.ass_random_id or 0 --第一属性刷新后的值，刷新之前取att_value
        local limit_character_id = assistantEffectItem.limit_character_id or 0 --缘助威刷新后的值
        local two_switch = assistantEffectItem.two_switch or 0 --第二属性是否开启 0为未开启
        local two_value = assistantEffectItem.two_value or 0 --第二属性刷新后的值

        local max_ability1 = assistant_cfg_item:getNodeWithKey("max_ability1")--第一属性最大值
        max_ability1 = max_ability1 and max_ability1:toInt() or 0
        local max_ability2 = assistant_cfg_item:getNodeWithKey("max_ability2")--第二属性最大值
        max_ability2 = max_ability2 and max_ability2:toInt() or 0
        local att_type = assistant_cfg_item:getNodeWithKey("att_type")--第一属性
        att_type = att_type and att_type:toInt() or 0
        local att_value,quality = 0,0
        if ass_random_id == 0 then
            att_value = assistant_cfg_item:getNodeWithKey("att_value")--第一属性加成值
            att_value = att_value and att_value:toInt() or 0
        else
            local assistant_random_cfg_item = assistant_random_cfg:getNodeWithKey(tostring(ass_random_id))
            if assistant_random_cfg_item then
                att_value = assistant_random_cfg_item:getNodeWithKey("ability")
                att_value = att_value and att_value:toFloat() or 0
                att_value = tonumber(string.format("%.2f",att_value))
                quality = assistant_random_cfg_item:getNodeWithKey("quality")
                quality = quality and quality:toInt() or 0
            end
        end
        table.insert(attrValueTab,{att_type = att_type,att_value = att_value,open = 1,quality = quality,att_name = "ability1",max_value = max_ability1})
        local card_ability = assistant_cfg_item:getNodeWithKey("card_ability")--阵缘属性
        card_ability = card_ability and card_ability:toInt() or 0
        local card_value = assistant_cfg_item:getNodeWithKey("card_value")--阵缘属性加成值
        card_value = card_value and card_value:toInt() or 0
        local assistant_random_cfg_item = assistant_random_cfg:getNodeWithKey(tostring(limit_character_id))
        local _,itemCfg = game_data:getAssTeamCardDataByPos(posIndex)
        local character_detail_cfg = getConfig(game_config_field.character_detail)
        local character_id,quality = 0,0
        local character_name,active = "无配置",0
        if assistant_random_cfg_item then
            character_id = assistant_random_cfg_item:getNodeWithKey("ability")
            character_id = character_id and character_id:toInt() or 0
            quality = assistant_random_cfg_item:getNodeWithKey("quality")
            quality = quality and quality:toInt() or 0
            local heroCfg = character_detail_cfg:getNodeWithKey(tostring(character_id))
            if heroCfg then
                character_name = heroCfg:getNodeWithKey("name"):toStr()
                if itemCfg then
                    local character_ID1 = itemCfg:getNodeWithKey("character_ID"):toInt()
                    local character_ID2 = heroCfg:getNodeWithKey("character_ID"):toInt()
                    if character_ID1 == character_ID2 then
                        active = 1
                    end 
                end
            end
        end
        table.insert(attrValueTab,{att_type = card_ability,att_value = card_value,open = limit_character_id,quality = quality,att_name = "card",character_id = character_id,character_name = character_name,active = active,max_value = 0})
        local att_type2 = assistant_cfg_item:getNodeWithKey("att_type2")--第二属性
        att_type2 = att_type2 and att_type2:toInt() or 0
        local assistant_random_cfg_item = assistant_random_cfg:getNodeWithKey(tostring(two_value))
        local ability,quality = 0,0
        if assistant_random_cfg_item then
            ability = assistant_random_cfg_item:getNodeWithKey("ability")
            ability = ability and ability:toFloat() or 0
            ability = tonumber(string.format("%.2f",ability))
            quality = assistant_random_cfg_item:getNodeWithKey("quality")
            quality = quality and quality:toInt() or 0
        end
        table.insert(attrValueTab,{att_type = att_type2,att_value = ability,open = two_switch,quality = quality,att_name = "ability2",max_value = max_ability2})

        newAttrFlag = newAttrFlag == nil and false or newAttrFlag--是否计算刷新的属性值
        if newAttrFlag then
            local refresh = assistantEffectItem.refresh or {}--刷新的临时属性值
            local ability1 = refresh.ability1 or 0
            local card = refresh.card or 0
            local ability2 = refresh.ability2 or 0
            if (ability1 + card + ability2) > 0 then
                refreshFlag = true
            end
            local att_value,quality = 0,0
            local assistant_random_cfg_item = assistant_random_cfg:getNodeWithKey(tostring(ability1))
            if assistant_random_cfg_item then
                att_value = assistant_random_cfg_item:getNodeWithKey("ability")
                att_value = att_value and att_value:toFloat() or 0
                att_value = tonumber(string.format("%.2f",att_value))
                quality = assistant_random_cfg_item:getNodeWithKey("quality")
                quality = quality and quality:toInt() or 0
            end
            table.insert(newAttrValueTab,{att_type = att_type,att_value = att_value,open = 1,quality = quality,att_name = "ability1",max_value = max_ability1})

            local assistant_random_cfg_item = assistant_random_cfg:getNodeWithKey(tostring(card))
            local character_id,quality = 0,0
            local character_name,active = "无配置",0
            if assistant_random_cfg_item then
                character_id = assistant_random_cfg_item:getNodeWithKey("ability")
                character_id = character_id and character_id:toInt() or 0
                quality = assistant_random_cfg_item:getNodeWithKey("quality")
                quality = quality and quality:toInt() or 0
                local heroCfg = character_detail_cfg:getNodeWithKey(tostring(character_id))
                if heroCfg then
                    character_name = heroCfg:getNodeWithKey("name"):toStr()
                    if itemCfg then
                        local character_ID1 = itemCfg:getNodeWithKey("character_ID"):toInt()
                        local character_ID2 = heroCfg:getNodeWithKey("character_ID"):toInt()
                        if character_ID1 == character_ID2 then
                            active = 1
                        end 
                    end
                end
            end
            table.insert(newAttrValueTab,{att_type = card_ability,att_value = card_value,open = limit_character_id,quality = quality,att_name = "card",character_id = character_id,character_name = character_name,active = active,max_value = 0})
            local assistant_random_cfg_item = assistant_random_cfg:getNodeWithKey(tostring(ability2))
            local ability,quality = 0,0
            if assistant_random_cfg_item then
                ability = assistant_random_cfg_item:getNodeWithKey("ability")
                ability = ability and ability:toFloat() or 0
                ability = tonumber(string.format("%.2f",ability))
                quality = assistant_random_cfg_item:getNodeWithKey("quality")
                quality = quality and quality:toInt() or 0
            end
            table.insert(newAttrValueTab,{att_type = att_type2,att_value = ability,open = two_switch,quality = 0,att_name = "ability2",max_value = max_ability2})
        end
    end
    return attrValueTab,newAttrValueTab,refreshFlag
end
function M.createMulitLabel( self, boardNode, params, labelType, touchPriority  )
    if not boardNode then
        cclog2(" will add a scroll label ,but parent Node is nil")
        return
    end
    touchPriority = touchPriority or -128
    local boardSize = boardNode:getContentSize()
    cclog2(boardSize.width, "boardSize.width  ======     ")
    cclog2(boardSize.height, "boardSize.width  ======     ")
    params = params or {}
    if not boardSize then return end
    local text = params.text or ""
    local fontSize = params.fontSize or 12
    local verticalTextAlignment = params.verticalTextAlignment or kCCVerticalTextAlignmentTop
    local textAlignment = params.textAlignment or kCCTextAlignmentCenter
    local color = params.color or ccc3(221,221,192)
    local tempLabel = nil
    if labelType == "labelBMFont" then
        tempLabel = game_util:createRichLabelTTF({text = text,dimensions = CCSizeMake(boardSize.width  ,0),textAlignment = textAlignment,
            verticalTextAlignment = verticalTextAlignment,color = color,fontSize = fontSize})
    else 
        tempLabel = game_util:createLabelTTF({text = text, textAlignment = textAlignment,
            verticalTextAlignment = verticalTextAlignment,color = color,fontSize = fontSize})
        tempLabel:setDimensions(CCSizeMake(boardSize.width, 0))
    end
    if not tempLabel then return end
    local tempSize = tempLabel:getContentSize();
    if tempSize.height < boardSize.height then
        cclog2(" not scroll text ")
        tempLabel:setAnchorPoint(ccp(0.5,0.5))
        tempLabel:setPosition(ccp(boardSize.width * 0.5, boardSize.height * 0.5 ))
        boardNode:addChild(tempLabel)
        return nil, tempLabel
    end
    cclog2(" is scroll text ")
    local scrollView = CCScrollView:create(boardSize)
    scrollView:setDirection(kCCScrollViewDirectionVertical)
    scrollView:getContainer():removeAllChildrenWithCleanup(true)
    tempLabel:setAnchorPoint(ccp(0,0.99))
    tempLabel:setPosition(ccp(0, 0))
    scrollView:setContentSize(CCSizeMake(boardSize.width + 15, tempSize.height))
    scrollView:setContentOffset(ccp(0, boardSize.height - tempSize.height), false)
    scrollView:addChild(tempLabel, 0, 998)
    boardNode:addChild(scrollView)
    scrollView:setTouchEnabled(false)




    local leftArrow = CCSprite:createWithSpriteFrameName("o_public_leftArrow.png")
    leftArrow:setScale(0.2)
    local signSize = leftArrow:getContentSize()
    leftArrow:setRotation(270)
    leftArrow:setAnchorPoint(ccp(1,0))
    leftArrow:setPosition(boardSize.width - 5, signSize.height * 0.2);
    boardNode:addChild(leftArrow)

    -- self.setNodeUpAndDownMoveAction(leftArrow)

    local animArr = CCArray:create();
    animArr:addObject(CCMoveBy:create( 1, ccp(0, 3)));
    animArr:addObject(CCMoveBy:create( 1, ccp(0, -3)));
    leftArrow:runAction(CCRepeatForever:create(CCSequence:create(animArr)));


    local touchLayer = CCLayer:create()
    boardNode:addChild(touchLayer)
    local touchBeginPoint = nil
    local touchPoint = nil
    local beginTime = nil
    local lastTime = nil
    local maxY = boardSize.height * 0.33
    local minY = boardSize.height - tempSize.height
    local mminY = minY * 1.33
    local function resetScrollViewOffset( offx, offy, draging, withAnimate )
        withAnimate = withAnimate or false
        local cx, cy = scrollView:getContainer():getPosition();
        local offsetY = math.min(cy + offy, maxY )
        offsetY = math.max(offsetY, mminY )
        if not draging then
            withAnimate = true
            if offsetY >= 0 then
                offsetY = 0
                leftArrow:setVisible(false)
            elseif offsetY <= minY then
                offsetY = minY
                leftArrow:setVisible(true)
            else
                leftArrow:setVisible(true)
            end
        end
        -- local offsetY = math.min(cy + offy, boardSize.height * 0.33 )
        scrollView:setContentOffset(ccp(cx, offsetY ), withAnimate)
    end


    local function onTouchBegan(x, y)
        local realPos = boardNode:getParent():convertToNodeSpace(ccp(x,y));
        if not boardNode:boundingBox():containsPoint(realPos) then  -- 
            return false
        end
        -- cclog("onTouchBegan: %0.2f, %0.2f", x, y)
        touchBeginPoint = {x = x, y = y}
        touchPoint = {x = x, y = y}
        lastTime = os.time()
        return true
    end

    local function onTouchMoved(x, y)
        -- cclog("onTouchMoved: %0.2f, %0.2f", x, y)
        if touchBeginPoint then
            -- cclog("offsetX ==========================" .. offsetX)
            -- tableView:getContainer():setPositionX(offsetX);
            resetScrollViewOffset(0, y - touchPoint.y, true, false)
            touchPoint = {x = x, y = y}
            lastTime = os.time()
        end
    end

    local function onTouchEnded(x, y)
        -- cclog("onTouchEnded: %0.2f, %0.2f", x, y)
        -- galleryLayer:stopAllActions();
        -- local distance = x - touchBeginPoint.x;
        -- if distance > 1 or distance < -1 then
        --     adjustScrollView(distance/math.max(0.1,(os.time() - beganTime)));
        -- end

        local dt = os.time() - lastTime
        local dy = touchPoint.y - y
        cclog2(dy, "move end and dy ====  ")
        -- if dy < 0.1 then return end
        local s = dy / dt * 2
        resetScrollViewOffset(0, 0, false, true)
        touchBeginPoint = nil
        touchPoint = nil
        beganTime = nil
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

    local function refreshScrollView( dis_move )



    end

    
    touchLayer:registerScriptTouchHandler(onTouch,false, touchPriority-1 or -128,false)
    touchLayer:setTouchEnabled(true)
    return scrollView, tempLabel
end

--[[
    分段均匀的进度条值转换
    通项公式：
    第i段的数值转换，其中x是真实值，finalValue为转换过后的值
    finalValue = (i-1)/n * X[n] + 1/n * X[n]/(X[i] - X[i-1]) * (x - X[i-1])
    n表示总共有n段，X[i]表示第i段的值，默认 X[0] = 0    
]]
function M.getSectionBarValue(self,value,valueTable)
    --传进来的value，分段数据表，要转换第index段的值,index都不用传
    local finalValue = 0
    local count = #valueTable
    local tempTable = util.table_copy(valueTable)
    tempTable[0] = 0
    local index = 1
    for i=1,#valueTable do
        if value > tempTable[i -1] and value <= tempTable[i] then
            index = i
            break;
        end
    end
    finalValue = (index - 1) / count * tempTable[count] + 1 / count * tempTable[count] / (tempTable[index] - tempTable[index - 1]) * (value - tempTable[index - 1])
    finalValue = math.max(0,finalValue)--不小于0
    finalValue = math.min(finalValue,valueTable[#valueTable])--不超过最大值
    return finalValue,index
end

--[[
    判断配置里面的版本号是否和 指定的版本号一致
    itemCfg  配置
    version  指定的版本号
    versionKey  配置里面的版本号字段名称
]]
function M.compareItemCfgVersion( self, itemCfg, version, versionKey )
    if not version then return false end
    if not itemCfg then return false end
    versionKey = versionKey and tostring( versionKey ) or "version"
    if itemCfg:getNodeWithKey( versionKey ) and itemCfg:getNodeWithKey( versionKey ):toStr() == tostring(version) then
        return true
    end
    return false
end

--[[ ------------------------------ 英魂相关 start ------------------------------ ]]

--[[
    英魂
]]
function M.createSoulItemByCCB(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_soul_system_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        -- cclog2(itemData,"itemData=====")
        self:setSoulItemInfoByTable(ccbNode,itemData);
    end
    return ccbNode
end

function M.setSoulItemInfoByTable(self,ccbNode,itemData)
    if ccbNode == nil or itemData == nil then return end
    ccbNode:nodeForName("m_info_node"):setVisible(true);
    local soulCfg = getConfig(game_config_field.soul_detail);
    -- cclog2(itemData,"itemData========")
    local itemData_data = itemData.count
    local itemCfg = soulCfg:getNodeWithKey(itemData_data.s_id);
    local name = itemCfg:getNodeWithKey("name"):toStr()
    local ability = itemCfg:getNodeWithKey("des"):toStr()
    local ability2 = itemCfg:getNodeWithKey("des2"):toStr()
    local abilityType = itemCfg:getNodeWithKey("ability"):toInt()
    local ability_value = itemCfg:getNodeWithKey("value"):toInt()
    local level_add = itemCfg:getNodeWithKey("level_add"):toStr()
    
    local level = itemData_data.lv --当前英魂等级
    -- cclog2(itemData,"itemData=====")
   
        local abilityType2 = itemCfg:getNodeWithKey("ability2"):toInt()
        local ability_value2 = itemCfg:getNodeWithKey("value2"):toInt()
        local level_add2 = itemCfg:getNodeWithKey("level_add2"):toStr()

    local level_max = itemCfg:getNodeWithKey("max_level"):toInt() -- 最大等级 
    local m_level_label = ccbNode:labelTTFForName("m_level_label") 
    if m_level_label and level and level_max then
        -- if level==level_max then
        --     m_level_label:setString("lv.max")
        -- elseif level<level_max then
            m_level_label:setString("lv." .. level .. "/" .. level_max)
        -- end
    end
    local m_ability_name_label = ccbNode:labelTTFForName("m_ability_name_label") --能力名字
    if m_ability_name_label and ability then
        m_ability_name_label:setString(ability)
    end
    local m_ability_name_label2 = ccbNode:labelTTFForName("m_ability_name_label2") --能力名字
    if m_ability_name_label2 and ability2 and tonumber(ability2)~=0 then
        m_ability_name_label2:setString(ability2)
    else
        m_ability_name_label2:setString("")
    end
    local m_ability_label = ccbNode:labelTTFForName("m_ability_label") --能力效果
    if abilityType < 6 or abilityType >= 200 then
        m_ability_label:setString("+" .. ability_value+level*level_add)
    elseif abilityType >= 6 and abilityType < 200 then
        m_ability_label:setString("+" .. ability_value+level*level_add .. "%")
    end
    local m_ability_label2 = ccbNode:labelTTFForName("m_ability_label2") --能力效果
    if abilityType2 and tonumber(abilityType2) ~= 0 then
        if abilityType2 < 6 or abilityType2 >= 200 then
            m_ability_label2:setString("+" .. ability_value2+level*level_add2)
        elseif abilityType2 >= 6 and abilityType2 < 200 then
            m_ability_label2:setString("+" .. ability_value2+level*level_add2 .. "%")
        end
        
    else
        m_ability_label2:setString("")
    end
    local quality = itemCfg:getNodeWithKey("quality"):toInt();
    if quality > 0 and quality <= 6 then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(HERO_QUALITY_COLOR_TABLE[quality].card_img));
    end
    local m_name_label = ccbNode:labelTTFForName("m_name_label");  
    m_name_label:setString(name);

    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    
    m_team_name:setString("");
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr()) --self:createGemIconByCfg(itemCfg)
    if icon then
        icon:setScale(1.2)
        m_anim_node:addChild(icon)
    end
end
function M.setSoulItemInfoByTable2(self,ccbNode,itemData)
    local soulCfg = getConfig(game_config_field.soul_detail);
    local itemCfg = soulCfg:getNodeWithKey(tostring(itemData.s_id));
    if itemCfg == nil then return end

    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    local m_name_label = ccbNode:labelBMFontForName("m_name_label")
    local m_count_label = ccbNode:labelBMFontForName("m_count_label")
    local m_sel_img = ccbNode:spriteForName("m_sel_img")

    m_anim_node:removeAllChildrenWithCleanup(true)
    -- local icon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr())
    local icon = self:createSoulIcon(itemCfg)
    if icon then
        icon:setScale(0.8)
        m_anim_node:addChild(icon)
    end
    local name = itemCfg:getNodeWithKey("name"):toStr()
    m_name_label:setString(name)
    if itemData.count then
        m_count_label:setString("")
    end
end
--[[
    创建英魂icon
]]
function M.createSoulIcon(self,itemCfg)
    local quality = itemCfg:getNodeWithKey("quality"):toInt()
    local name = itemCfg:getNodeWithKey("name"):toStr()
    local tempIcon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr())
    local qualityTab = HERO_QUALITY_COLOR_TABLE[quality+1]
    if qualityTab then
        local tempIconSize = tempIcon:getContentSize();
        local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
        img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
        tempIcon:addChild(img1,-1,-1)
        local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
        img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
        tempIcon:addChild(img2,1,1)
    end
    return tempIcon,name
end

function M.createSoulAnimeByData( self,data )
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/ui_soul_all.plist");
    if data == nil then return end
    local name = data.icon   
    local sp 
    if name then
        sp = CCSprite:createWithSpriteFrameName(name .. ".png")
    end
    local quality = data.quality
    local file = "st_"..quality
    local size = sp:getContentSize();
    local mAnimNode = game_util:createBlenderAnim(file,1,true)
    if mAnimNode then
        local function onAnimSectionEnd(animNode, theId,theLabelName)
            animNode:playSection(theLabelName);
        end
        mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
        mAnimNode:setPosition(ccp(size.width*0.5,size.height*0.5))
        mAnimNode:playSection("impact@1")
        sp:addChild(mAnimNode)
    end
    return sp 
end

function M.createBlenderAnim(self,animFile,id,isblender)
    local ani = zcAnimNode:create(animFile .. ".swf.sam",id, animFile .. ".plist");
    if isblender == true then
        local blendFunc = ani:getBlendFunc()
        blendFunc.src = GL_SRC_ALPHA
        blendFunc.dst = GL_ONE
        ani:setBlendFunc(blendFunc)
    end
    return ani;
end


function M:createBlenderAnim2( animFile,id,isblender )
    -- body
    local anim = zcAnimNode:create(animFile .. ".swf.sam",id, animFile .. ".plist");
    if(isblender)then
        local blendFunc = anim:getBlendFunc();
        blendFunc.src = GL_ONE_MINUS_SRC_COLOR;
        blendFunc.dst = GL_ONE;
        anim:setBlendFunc(blendFunc);
    end
    return anim;
end
--[[
    通过英魂id创建英魂图标
]]
function M.createSoulIconById(self,id)
    local soulCfg = getConfig(game_config_field.soul_detail);
    local itemCfg = soulCfg:getNodeWithKey(tostring(id))
    return self:createSoulIcon(itemCfg)
end

--[[
    英魂属性加成
]]
function M.getSoulCombatValue(self,posIndex,soulData)
    local attrValueTab = {0,0,0,0,0}
    local attrValueTab2 = {0,0,0,0,0}
    local combatValue = 0;
    local attrPercentValueTab = {0,0,0,0,0}
    local soulCfg = getConfig(game_config_field.soul_detail);
    local soulPosData = game_data:getSoulPos() or {};
    if soulData then
        soulPosData = soulData
    end
    local soulPosItemData = soulPosData[tostring(posIndex-1)] or {}
    local souldata = game_data:getSoulData();
    for k,v in pairs(soulPosItemData) do
        -- cclog2(soulPosItemData,"soulPosItemData====")
        if v ~= "0"  then
            local souldata2 = souldata[v]
            local s_id = souldata2.s_id
            local lv = souldata2.lv
            local itemCfg = soulCfg:getNodeWithKey(tostring(s_id));
            -- cclog2(itemCfg,"itemCfg=====")
            if itemCfg then
                local value = itemCfg:getNodeWithKey("value"):toInt()
                local ability = itemCfg:getNodeWithKey("ability"):toInt()
                local level_add = itemCfg:getNodeWithKey("level_add"):toFloat()
                if itemCfg:getNodeWithKey("value2") and itemCfg:getNodeWithKey("value2"):toInt()~=0 then
                    local value2 = itemCfg:getNodeWithKey("value2"):toInt()
                    local ability2 = itemCfg:getNodeWithKey("ability2"):toInt()
                    local level_add2 = itemCfg:getNodeWithKey("level_add2"):toFloat()
                    if ability2 > 0 and ability2 < 6 then
                        attrValueTab2[ability2] = attrValueTab2[ability2] + math.floor(value2 + level_add2 * lv)
                    end
                end
                if ability > 0 and ability < 6 then
                    attrValueTab[ability] = attrValueTab[ability] + math.floor(value + level_add * lv)
                elseif ability > 200 then
                    combatValue = combatValue + value
                elseif ability > 100 and ability < 106 then--加百分比的
                    local percent = value + level_add * lv
                    attrPercentValueTab[ability - 100] = attrPercentValueTab[ability - 100] + percent
                end
            end
        end
    end
    -- cclog2(combatValue,"combatValue")
    -- cclog2(attrValueTab,"attrValueTab")
    return combatValue,attrValueTab,attrPercentValueTab,attrValueTab2;
end
--[[ ------------------------------ 英魂相关 end ------------------------------ ]]
--[[ ------------------------------ 勋章相关 start ------------------------------ ]]
--[[
    通用勋章1
]]
function M.createMedalItemByCCB(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_medal_system_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setMedalItemInfoByTable(ccbNode,itemData);
    end
    return ccbNode
end

function M.setMedalItemInfoByTable(self,ccbNode,itemData)
    if ccbNode == nil or itemData == nil then return end
    ccbNode:nodeForName("m_info_node"):setVisible(true);
    local medalCfg = getConfig(game_config_field.medal);
    local itemCfg = medalCfg:getNodeWithKey(itemData.c_id);

    local name = itemCfg:getNodeWithKey("name"):toStr()
    local des = itemCfg:getNodeWithKey("des"):toStr()

    local effect = itemCfg:getNodeWithKey("effect")
    for i=1,effect:getNodeCount() do
        local itemEffect = effect:getNodeAt(i-1)
        local ability = itemEffect:getNodeAt(0):toInt()
        local ability_value = itemEffect:getNodeAt(1):toInt()

        local attrTab = PUBLIC_ABILITY_TABLE["ability_" .. ability]
        local iconStr = attrTab.icon
        local iconName = attrTab.name

        local ability_icon = ccbNode:spriteForName("m_ability" .. i .. "_icon")
        local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(iconStr)
        if tempSpriteFrame and ability_icon then
            ability_icon:setDisplayFrame(tempSpriteFrame)
        end
        local m_ability_name_label = ccbNode:labelBMFontForName("m_ability".. i .. "_name_label")
        if m_ability_name_label and iconName then
            m_ability_name_label:setString(iconName)
        end
        local m_ability_label = ccbNode:labelBMFontForName("m_ability" .. i .. "_label")
        if m_ability_label and ability_value then
            m_ability_label:setString("+" .. ability_value)
        end
    end
    -- local career = itemCfg:getNodeWithKey("career"):toInt();
    -- local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(PUBLIC_ABILITY_TABLE["ability_" .. career].icon)
    -- if tempSpriteFrame then
    --     ccbNode:spriteForName("m_type_icon"):setDisplayFrame(tempSpriteFrame)
    -- end
    local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
    if quality > 0 and quality < 12 then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(HERO_QUALITY_COLOR_TABLE[quality].card_img));
    end
    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    
    m_name_label:setString(name .. " x" .. tostring(itemData.count));

    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    
    m_team_name:setString("");
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr()) --self:createGemIconByCfg(itemCfg)
    if icon then
        m_anim_node:addChild(icon)
    end
    
end
--[[
    通用勋章2
]]
function M.createMedalItemByCCB2(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_medal_system_list_item2.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setMedalItemInfoByTable2(ccbNode,itemData);
    end
    return ccbNode
end

function M.setMedalItemInfoByTable2(self,ccbNode,itemData)
    local medalCfg = getConfig(game_config_field.medal);
    local itemCfg = medalCfg:getNodeWithKey(tostring(itemData.c_id));
    if itemCfg == nil then return end

    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    local m_name_label = ccbNode:labelBMFontForName("m_name_label")
    local m_count_label = ccbNode:labelBMFontForName("m_count_label")
    local m_sel_img = ccbNode:spriteForName("m_sel_img")

    m_anim_node:removeAllChildrenWithCleanup(true)
    -- local icon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr())
    local icon = self:createMedalIcon(itemCfg)
    if icon then
        icon:setScale(0.8)
        m_anim_node:addChild(icon)
    end
    local name = itemCfg:getNodeWithKey("name"):toStr()
    m_name_label:setString(name)
    if itemData.count then
        m_count_label:setString("x" .. itemData.count)
    end
end

--[[
    勋章材料
]]
function M.createMedalItemByCCB3(self,itemData)
    cclog2(itemData,"ss")
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_medal_system_list_item3.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setMedalItemInfoByTable3(ccbNode,itemData);
    end
    return ccbNode
end

function M.setMedalItemInfoByTable3(self,ccbNode,itemData)
    if ccbNode == nil or itemData == nil then return end
    local m_spr_bg_up = ccbNode:spriteForName("m_spr_bg_up");
    m_spr_bg_up:setVisible(false);
    local material_key = itemData.key
    cclog2(material_key,"material_key")
    local materialCfg = getConfig(game_config_field.material)
    local itemCfg = materialCfg:getNodeWithKey(material_key)

    local m_have_label = ccbNode:labelTTFForName("m_have_label")
    local m_node = ccbNode:nodeForName("m_node")
    local m_price_label = ccbNode:labelBMFontForName("m_price_label")
    local m_buy_btn = ccbNode:controlButtonForName("m_buy_btn")
    local label_node = ccbNode:nodeForName("label_node")
    local price_node = ccbNode:nodeForName("price_node")
    --为练卡准备的
    local material_node = ccbNode:nodeForName("material_node")
    local alpha_layer = ccbNode:layerColorForName("alpha_layer")
    local light_sprite = ccbNode:spriteForName("light_sprite")
    local material_sprite = ccbNode:spriteForName("material_sprite")

    m_buy_btn:setVisible(false)
    label_node:setVisible(false)
    price_node:setVisible(true)
    m_node:removeAllChildrenWithCleanup(true);
    local icon = game_util:createIconByName(itemCfg:getNodeWithKey("icon"):toStr()) 
    if icon then
        icon:setScale(1.2)
        m_node:addChild(icon)
    end

    m_have_label:setString(itemCfg:getNodeWithKey("name"):toStr())
    m_price_label:setString(itemCfg:getNodeWithKey("price"):toStr())

end
--[[
    通用勋章材料2
]]
function M.createMedalItemByCCB4(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_medal_system_list_item4.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setMedalItemInfoByTable2(ccbNode,itemData);
    end
    return ccbNode
end

function M.setMedalItemInfoByTable4(self,ccbNode,itemData)
    local materialCfg = getConfig(game_config_field.material);
    local itemCfg = materialCfg:getNodeWithKey(tostring(itemData.c_id));
    if itemCfg == nil then return end

    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    local m_name_label = ccbNode:labelBMFontForName("m_name_label")
    local m_cost_label = ccbNode:labelBMFontForName("m_cost_label")

    local name = itemCfg:getNodeWithKey("name"):toStr()
    local price = itemCfg:getNodeWithKey("price"):toStr()

    m_name_label:setString("Nguyên liệu:" .. name)
    m_cost_label:setString("Giá trị:" .. price)

    if itemData.count then
        m_name_label:setString("Nguyên liệu:" .. name .. "x" .. itemData.count)
    end

    m_anim_node:removeAllChildrenWithCleanup(true)
    -- local icon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr())
    local icon = self:createMedalIcon(itemCfg)
    if icon then
        icon:setScale(0.8)
        m_anim_node:addChild(icon)
    end
end

--[[
    勋章属性加成
]]
function M.getMedalCombatValue(self,posIndex,medalData)
    local attrValueTab = {0,0,0,0,0}
    local combatValue = 0;
    local attrValueTab2={0,0,0,0,0,0,0,0}
    local medalCfg = getConfig(game_config_field.medal);
    local medalPosData = game_data:getMedalPos() or {};
    if medalData then
        medalPosData = medalData;
    end
    local medalPosItemData = medalPosData[tostring(posIndex-1)] or {}
    for k,v in pairs(medalPosItemData) do
        local itemCfg = medalCfg:getNodeWithKey(tostring(v))
        if itemCfg then
            local effect = itemCfg:getNodeWithKey("effect")
            for i=1,3 do
                local itemEffect = effect:getNodeAt(i-1)
                local ability = itemEffect:getNodeAt(0):toInt()
                local value = itemEffect:getNodeAt(1):toInt()
                if ability > 0 and ability < 6 then
                    attrValueTab[ability] = attrValueTab[ability] + value
                
                else
                    combatValue = combatValue + value
                end
                --todo 圣石
                if ability>200 and ability<400 then
                    local team=itemEffect:getNodeAt(1):toInt()
                    attrValueTab2[ability-300+4]=value
                end
            end
        end
    end

    return combatValue,attrValueTab,attrValueTab2;

end
--[[
    通过勋章id创建勋章图标
]]
function M.createMedalIconById(self,id)
    local medalCfg = getConfig(game_config_field.medal);
    local itemCfg = medalCfg:getNodeWithKey(tostring(id))
    return self:createMedalIcon(itemCfg)
end
--[[
    通过勋章材料id创建材料
]]
function M.createMaterialIconById(self,id)
    local medalCfg = getConfig(game_config_field.material);
    local itemCfg = medalCfg:getNodeWithKey(tostring(id))
    return self:createMedalIcon(itemCfg)
end
--[[
    创建勋章icon
]]
function M.createMedalIcon(self,itemCfg)
    local quality = itemCfg:getNodeWithKey("quality"):toInt()
    local name = itemCfg:getNodeWithKey("name"):toStr()
    local tempIcon = self:createIconByName(itemCfg:getNodeWithKey("icon"):toStr())
    local qualityTab = HERO_QUALITY_COLOR_TABLE[quality+1]
    if qualityTab then
        local tempIconSize = tempIcon:getContentSize();
        local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
        img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
        tempIcon:addChild(img1,-1,-1)
        local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
        img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
        tempIcon:addChild(img2,1,1)
    end
    return tempIcon,name
end
--[[
    创建勋章材料icon
]]
function M.createMaterialIcon(self,itemCfg)
    
end
--[[ ------------------------------ 勋章相关 end ------------------------------ ]]

--[[------------------------------------神域相关 start------------------------------------------- ]]
--[[--
    判断id是否在table中
]]
function M.godEquipeidInTableById(self,id,idTable)
    idTable = idTable or {};
    for i=1,10 do
        for k,v in pairs(idTable[tostring(i-1)]) do
            if v ~= 0 and tostring(v) == tostring(id) then
                return true;
            end
        end
    end
    return false;
end

function M.idInTableById2(self,id,idTable)
    idTable = idTable or {};
    for k,v in pairs(idTable) do
        if v ~= 0 and tostring(k) == tostring(id) then
            return true,k;
        end
    end
    return false,nil;
end

--[[--
    判断英雄是否在神域编队中
]]
function M.godheroInTeamById(self,heroId)
    local GodTeamData = game_data:getGodCardsPosData();
    for i=1,3 do
        for k,v in pairs(GodTeamData[tostring(i)]) do
            -- cclog2(self.m_tGodTeamData[i],"self.m_tGodTeamData[i]====22=333=")
            if v ~= "-1" and tostring(v) == tostring(heroId) then
                -- cclog2(i,"i======")
                return true , i;
            end
        end
    end
    
    return false;
end
--[[------------------------------------神域相关 end------------------------------------------- ]]
--[[------------------------------------召唤兽 start------------------------------------------- ]]
--[[
    通过cid创建没有品质的卡牌头像  小头像
]]
function M.createCombinerCardIconByCid(self,cid,itemData)
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroCfg = character_detail_cfg:getNodeWithKey(tostring(cid));
    if heroCfg == nil then return nil,nil end
    return self:createCombinerCardIconByCfg(heroCfg,itemData),heroCfg:getNodeWithKey("name"):toStr();
end

function M.createCombinerCardIconByCfg(self,itemCfg,itemData)--小头像
    if itemCfg == nil then
        return nil;
    end
    local rgb = itemCfg:getNodeWithKey("rgb_sort");
    if rgb then
        rgb = rgb:toInt();
    else
        rgb = 0;
    end
    local fileName = itemCfg:getNodeWithKey("img"):toStr();
    local quality = itemCfg:getNodeWithKey("quality"):toInt();
    itemData = itemData or {}
    local super_quality_1 = itemData.super_quality_1 or 0
    local tempIcon = self:createIconByName(fileName)
    if tempIcon then
        -- cclog("quality ==" .. quality)
        if rgb == 1 then
            tempIcon:setColor(ccc3(47,255,118));
        elseif rgb == 2 then
            tempIcon:setColor(ccc3(67,117,253));
        elseif rgb == 3 then
            tempIcon:setColor(ccc3(171,65,255));
        end
        
    end
    return tempIcon;
end


--[[------------------------------------召唤兽 end------------------------------------------- ]]
--公会雇佣筛选
function M.setGuildHeroListItemInfoByTable(self,ccbNode,heroDataTable)
    local cardId = heroDataTable.c_id;
    -- cclog("cardId ===" .. tostring(cardId))
    local itemConfig = getConfig(game_config_field.character_detail):getNodeWithKey(cardId);
    -- if itemConfig then
    --     ccbNode:nodeForName("m_info_node"):setVisible(true);
    -- else
    --     ccbNode:nodeForName("m_info_node"):setVisible(false);
    --     return
    -- end
    if itemConfig then
        if itemConfig:getNodeWithKey("is_skin") then
            if itemConfig:getNodeWithKey("is_skin"):toInt() ~= 0 then
                local skinID = itemConfig:getNodeWithKey("is_skin"):toInt()
                local flag = game_util:isWearSkin(skinID)
                if flag then
                    local character_detail_cfg = getConfig(game_config_field.character_detail);
                    itemConfig = character_detail_cfg:getNodeWithKey(tostring(skinID));
                end
            end
        end
        ccbNode:nodeForName("m_info_node"):setVisible(true);
    else
        ccbNode:nodeForName("m_info_node"):setVisible(false);
        return
    end
    local wake_lv = heroDataTable.bre
    tolua.cast(ccbNode:objectForName("m_level_label"),"CCLabelBMFont"):setString("Lv." .. heroDataTable.lv .. "/" .. heroDataTable.level_max);
    local m_anim_node = tolua.cast(ccbNode:objectForName("m_anim_node"),"CCNode");
    m_anim_node:removeAllChildrenWithCleanup(true);
    -- local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    -- self:setHeroNameColorByQuality(m_name_label,itemConfig);
    local quality = itemConfig:getNodeWithKey("quality"):toInt();
    local super_quality_1 = heroDataTable.super_quality_1 or 0
    local hero_quality_item = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
    if hero_quality_item then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(hero_quality_item.card_img));
    end
    local name_after = self:getCardName(heroDataTable,itemConfig)
    m_name_label:setString(name_after);
    local animation = itemConfig:getNodeWithKey("animation"):toStr();
    local rgb = itemConfig:getNodeWithKey("rgb_sort"):toInt();

    local animNode = self:createImgByName("image_" .. animation,rgb,nil,nil,wake_lv,itemConfig)
    -- local animNode = game_util:createPauseAnim(animation,0,heroDataTable,itemConfig);
    -- cclog("setHeroListItemInfoByTable animNode == " .. tostring(animNode))
    if animNode then
        local animNodeSize = animNode:getContentSize();
        -- local ccbNodeSize = ccbNode:getContentSize();
        -- local scale = math.min(1,animNodeSize.height~=0 and 70/animNodeSize.height or 1);
        -- animNode:setScale(scale);
        animNode:setAnchorPoint(ccp(0.5,0));
        m_anim_node:addChild(animNode);
        -- m_anim_node:getParent():reorderChild(m_anim_node,-1);
    end
    local m_sel_img = ccbNode:spriteForName("m_sel_img")
    m_sel_img:setVisible(false)
    local m_team_img = ccbNode:spriteForName("m_team_img")
    if game_data:heroInGuildTeamById(heroDataTable.id) then
        m_team_img:setVisible(true);
        m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_played.png"));
    else
        m_team_img:setVisible(false);
    end
    
    local m_guild_img = ccbNode:spriteForName("m_guild_img")
    m_guild_img:setVisible(false);
    -- if game_data:heroInGuildTeamById2(heroDataTable.id) then
    --     m_guild_img:setVisible(true);
    --     m_guild_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_yipaiqian.png"));
    -- else
    --     m_guild_img:setVisible(false);
    -- end

    local m_team_img_text=ccbNode:labelTTFForName("m_team_img_text")
     if game_data:heroInGuildTeamById2(heroDataTable.id) then
        m_team_img_text:setVisible(true);
        m_team_img_text:setString("Đã cử")
    else
        m_team_img_text:setVisible(false);
    end
    
    
    local lockFlag = game_util:getCardUserLockFlag(heroDataTable);
    ccbNode:spriteForName("m_lock_img"):setVisible(lockFlag);
    local m_perfect_img = ccbNode:spriteForName("m_perfect_img")
    m_perfect_img:setVisible(false);
    local bre = math.min(heroDataTable.bre or 0,10)
    local tempSpriteFrame = nil;
    if bre > 5 then
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_moon_icon.png")
        bre = bre - 5
    else
        tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_equip_star.png")
    end
    for i=1,5 do
        local m_star_icon = ccbNode:spriteForName("m_star_icon_" .. i)
        if tempSpriteFrame then
            m_star_icon:setDisplayFrame(tempSpriteFrame)
        end
        if i <= bre then
            m_star_icon:setVisible(true);
        else
            m_star_icon:setVisible(false);
        end
    end

    local m_occupation_icon = ccbNode:spriteForName("m_occupation_icon")
    local occupation_cfg = getConfig(game_config_field.occupation);
    local occupation_item_cfg = occupation_cfg:getNodeWithKey(animation)
    if occupation_item_cfg then
        local occupationType = occupation_item_cfg:toInt();
        local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation" .. occupationType .. ".png")
        if spriteFrame then
            m_occupation_icon:setDisplayFrame(spriteFrame);
        else
            m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
        end
    else
        m_occupation_icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_ocupation5.png"));
    end
    local m_occupation_icon_bg = ccbNode:spriteForName("m_occupation_icon_bg")
    local spriteFrame = super_quality_1 > 0 and CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg_2.png") or CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("card_race_bg.png")
    if m_occupation_icon_bg and spriteFrame then
        m_occupation_icon_bg:setDisplayFrame(spriteFrame);
    end
end

function M.isInFormationBonus( self,cardId ) --判断是否在新助威的阵法里面
    local m_formationBounsData,m_formationBounsAdditionData = {},{}
    m_formationBounsData = game_data:getFormationBonusByJsonData()
    m_formationBounsAdditionData = game_data:getFormationBonusAdditionByJsonData()
    for k,v in pairs(m_formationBounsData) do
        if tostring(v) == tostring(cardId) then
            return true
        end
    end
    for index,table in pairs(m_formationBounsAdditionData) do
        if table and next(table) then
            for i,id in pairs(table) do
                if tostring(id) == tostring(cardId) then
                    return true
                end
            end
        end
    end
    return false
end
function M.isInFormationBonus2( self,cardId ) --判断是否在新助威的阵法里面
    local sha = ""
    local m_formationBounsData,m_formationBounsAdditionData = {},{}
    m_formationBounsData = game_data:getFormationBonusByJsonData()
    m_formationBounsAdditionData = game_data:getFormationBonusAdditionByJsonData()
    for k,v in pairs(m_formationBounsData) do
        if tostring(v) == tostring(cardId) then
            sha = "zhenfa"
            return sha
        end
    end
    for index,table in pairs(m_formationBounsAdditionData) do
        if table and next(table) then
            for i,id in pairs(table) do
                if tostring(id) == tostring(cardId) then
                    sha = "zhenfaAdd"
                    return sha
                end
            end
        end
    end
    return false
end

--[[
    计算总的新助威加成
]]
function M.getAllBonusCombat2( self,curFormation )
    -- cclog2(curFormation,"curFormation ==== ")
    local dataTab  = {0,0,0,0,0}
    local posIndexTab = {}
    if curFormation then
        posIndexTab = self:getFormationPos(curFormation)
    else
        posIndexTab = self:getFormationPos()
    end
    for i=1,9 do
        local curData = self:getFormationBonusAllData(i)
        if posIndexTab[tostring(i)] then
            -- cclog2(curData,"curData ==============   ")
            for j=1,5 do
                dataTab[j] = dataTab[j] + curData[j]
            end
        end
    end
    return dataTab
    -- body
end

--[[
    获取阵型pos
]]
function M.getFormationPos( self,curFormation )
    local posTab,posIndexTab = {},{}
    -- cclog2(curFormation,"curFormation ==== ")
    if curFormation then
        cclog("im waiting for you baby come on ---------")
        for k,v in pairs(curFormation) do
            if v ~= "0" and v~= "-1" then
                cclog2(k,"k ----- ")
                posIndexTab[tostring(k)] = k
            end
        end
    else
        cclog("why go here? ---------")
        local formationPosTab = {{key="position_a",x=0.82,y=0.83},{key="position_b",x=0.82,y=0.5},{key="position_c",x=0.82,y=0.17},{key="position_d",x=0.5,y=0.83},{key="position_e",x=0.5,y=0.5},{key="position_f",x=0.5,y=0.17}};
        local teamData = game_data:getTeamData()
        local formationData = game_data:getFormationData() or {};
        local ownFormation = formationData.own or {}
        local ownFormationCount = #ownFormation
        local m_currentFormationId = formationData.current
        local m_selFormationId = m_currentFormationId;

        local formationConfig = getConfig(game_config_field.formation);
        local itemCfg = formationConfig:getNodeWithKey(tostring(m_selFormationId));
        local tempTag = 1;
        local iValue = nil;
        if itemCfg ~= nil then
            for i=1,#formationPosTab do
                local formationPosTabItem = formationPosTab[i];
                -- cclog(itemCfg:getFormatBuffer())
                -- cclog("formationPosTabItem.key =========" .. formationPosTabItem.key .. " ; itemCfg = " .. tostring(itemCfg))
                iValue = itemCfg:getNodeWithKey(formationPosTabItem.key):toInt();
                if iValue ~= 0 and tempTag < 7 then
                    posTab[i] = teamData[tempTag]
                    tempTag = tempTag + 1;
                else
                    posTab[i] = "-1";
                end
            end
        end
        for i=6,8 do
            posTab[i+1] = teamData[i];
        end
        for k,v in pairs(posTab) do
            if v ~= "0" and v~= "-1" then
                posIndexTab[tostring(k)] = k
            end
        end
    end
    return posIndexTab
end



function M.getCombatBonusMultiplierByCfg2(self,heroCfg,cardId,teamData,equipData)
    local cardData=game_data:getCardDataById(cardId)--32500
    if cardData == nil then -- 兼容取自己数据为空 取公会数据
        cardData = game_data:getGuildCardDataById(cardId)
    end
    local fate_change_cfg=getConfig(game_config_field.fate_change)
    local attrValueTab = {0,0,0,0,0};
    if heroCfg == nil then return attrValueTab end
    local chain = heroCfg:getNodeWithKey("chain")
    local chainCount = chain:getNodeCount();
    -- cclog("chainCount ======================= " .. chainCount)
    if chainCount > 0 then
        local teamCharacterIdTab, teamEquipIdTab = {},{}
        if teamData ~= nil or equipData ~= nil then
            cclog("11111111111111111111")
            teamCharacterIdTab, teamEquipIdTab = self:getCardAndEquipChainTab1(cardId,teamData,equipData);
            -- cclog2(teamEquipIdTab, "teamEquipIdTab========")
            
        else
            cclog("22222222222")

            teamCharacterIdTab, teamEquipIdTab = self:getCardAndEquipChainTab(cardId,teamData,equipData);
        end

        local character_detail_cfg = getConfig(game_config_field.character_detail);
        local chain_cfg = getConfig(game_config_field.chain);
        local equip_cfg = getConfig(game_config_field.equip);
        for i=1,chainCount do
            local chainId=chain:getNodeAt(i-1):toStr()
            local chainItemCfg = chain_cfg:getNodeWithKey(chain:getNodeAt(i-1):toStr());
            if chainItemCfg then
                local name = chainItemCfg:getNodeWithKey("name"):toStr();
                local data = chainItemCfg:getNodeWithKey("data")
                local dataCount = data:getNodeCount();
                local condition_sort = chainItemCfg:getNodeWithKey("condition_sort"):toInt();
                local dataTab=json.decode(data:getFormatBuffer())
                if dataCount > 0 then
                    --todo
                        -- local afterLifeId=nil;
                        -- local afterLifeCfg=getConfig(game_config_field.afterlife)
                        -- local afterlifeTab=json.decode(afterLifeCfg:getFormatBuffer())
                        -- for k,v in pairs(afterlifeTab) do
                        --     cclog2(v["afterlife_id"],"afterlife_id")
                        --     cclog2(cardData.id,"card.id")
                        --     if tostring(v["afterlife_id"]) ==tostring(cardData.id) then
                        --         cclog2("12123123")
                        --         dataTab[1]=v["afterlife_id"]
                        --     end
                        -- end
                   
                    local tempCount = 0;
                    if condition_sort == 0 then--卡牌联协
                        for i=1,dataCount do
                             --todo
                            if cardData.fate_change and next(cardData.fate_change) then
                                    if data:getNodeAt(i-1):toStr() == tostring(cardData.fate_change["c_id1"] ) and tostring(chainId)==tostring(cardData.fate_change["chain_id"]) then
                                        dataTab[i]=cardData.fate_change["c_id2"]; --直接修改相应table
                                    end
                            end
                        
                        --todo end
                            local itemCfg = character_detail_cfg:getNodeWithKey(tostring(dataTab[i]))
                            if itemCfg then
                                if teamCharacterIdTab[itemCfg:getNodeWithKey("character_ID"):toInt()] then
                                    tempCount = tempCount + 1;
                                end
                            end
                        end
                    elseif condition_sort == 1 then--装备联协
                        for i=1,dataCount do
                            local itemCfg = equip_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                local sort = itemCfg:getNodeWithKey("sort"):toInt();
                                local chain_id = itemCfg:getNodeWithKey("chain_id")
                                chain_id = chain_id and chain_id:toInt() or itemCfg:getNodeWithKey("equip_id"):toInt()
                                if teamEquipIdTab[chain_id] or teamEquipIdTab[sort] then
                                    tempCount = tempCount + 1;
                                end
                            end
                        end
                    end
                    if tempCount >= dataCount then--激活
                        local effectTab={};
                        if chain:getNodeAt(i-1):toStr()== tostring(cardData.fate_change["chain_id"]) then
                            effectTab=cardData.fate_change["effect"]
                        else
                            effectTab = json.decode(chainItemCfg:getNodeWithKey("effect"):getFormatBuffer()) or {}
                        end
                       
                        for k,v in pairs(effectTab) do
                            if #v == 2 then
                                attrValueTab[v[1] + 1] = attrValueTab[v[1] + 1]  + v[2]*0.001;
                            end
                        end
                    end
                end
             end
        end
    end
    return attrValueTab
end



--[[
    新助威加成计算  新
]]
function M.getAllBonusCombat( self,curFormation )
    -- cclog2(curFormation,"curFormation ==== ")
    local dataTab  = {0,0,0,0,0,0,0,0,0}
    local posIndexTab = {}
    if curFormation then
        posIndexTab = self:getFormationPos(curFormation)
    else
        posIndexTab = self:getFormationPos()
    end
    for i=1,9 do
        local curData = self:getFormationBonusAllData(i)
        if posIndexTab[tostring(i)] then
            local data
            for j=1,5 do
                dataTab[i] = dataTab[i] + curData[j]
            end
        end
    end
    return dataTab
    -- body
end
--[[
    单个新助威和阵法加成
]]
function M.getFormationBonusAllData( self,index )
    local friendData = game_data:getFormationBonusByJsonData() or {}
    local zhenfaFriend = game_data:getFormationBonusAdditionByJsonData() or {}
    local friendEquipData = game_data:getFormationBonusEquipData() or {}
    local friendMagicData = game_data:getFormationBonusMagicData() or {}
    local temptab = {}

    --[[--
        刷新卡牌信息
    ]]
    local function getPosEquipAttrValue(posIndex)
        -- 1物攻 2魔攻 3防御 4速度 5生命
        local equip_set_random = getConfig(game_config_field.equip_set_random)
        local attrValueTab = {0,0,0,0,0};
        local posEquips = nil
        posEquips = friendEquipData[tostring(posIndex+199)]
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
    ----[[
    local function getPosMagicAttrValue(posIndex)
        -- 1物攻 2魔攻 3防御 4速度 5生命
        local combat_base_cfg = getConfig(game_config_field.combat_base)
        local attrValueTab = {0,0,0,0,0};
        local posMagics = nil
        posMagics = friendMagicData[tostring(posIndex+199)]
        local level,value1,value2;
        if posMagics and type(posMagics) == "table" then
            local Temp_att = self:getMagicAttrValueByTable(posMagics)
            if Temp_att then
                Temp_att[1] = Temp_att[1] * combat_base_cfg:getNodeWithKey("patk"):toFloat()
                Temp_att[2] = Temp_att[2] * combat_base_cfg:getNodeWithKey("matk"):toFloat()
                Temp_att[3] = Temp_att[3] * combat_base_cfg:getNodeWithKey("def"):toFloat()
                Temp_att[4] = Temp_att[4] * combat_base_cfg:getNodeWithKey("speed"):toFloat()
                Temp_att[5] = Temp_att[5] * combat_base_cfg:getNodeWithKey("hp"):toFloat()
                attrValueTab = Temp_att
                    
            end
        end
        return attrValueTab
    end

    local m_formation_bonus = getConfig(game_config_field.formation_bonus);
    if m_formation_bonus then
        m_formation_bonus = json.decode(m_formation_bonus:getFormatBuffer()) or {}
    end
    local function getAddRate( index,m_tab_curId)
        local length = game_util:getTableLen(m_tab_curId)
        local addRate = 0 
        for i=1,length do
            if m_tab_curId[i] and m_tab_curId[i] ~= 0 then
                if m_formation_bonus and next(m_formation_bonus) then
                    addRate = addRate + m_formation_bonus[tostring(i)].add_ability
                end
            end
        end
        local tempTab = {}
        tempTab[index] = addRate
        game_data:setFormationBounsData_AddTable(addRate,index)
        return addRate
    end
    local function getPriority( posIndex,m_addTable )
        local cardData,cardCfg = nil,nil;
        cardData,cardCfg = game_data:getCardDataById(friendData[posIndex])
        local attrValueTab = {0,0,0,0,0};
        local aa =  {0,0,0,0,0};
        if cardData and cardCfg then
            -- 1物攻 2魔攻 3防御 4速度 5生命
            local equipAttrValueTab = getPosEquipAttrValue(posIndex);--装备属性
            local magicAttrValueTab = getPosMagicAttrValue(posIndex);
            local petAttrValueTab = game_util:getPetCombatValue(posIndex)
            local petFollowValueTab = game_util:getPetFollowCombatValue(posIndex)
            local universeCombatValue = 0
            local universeAttrValueTab = {0,0,0,0,0}
            local soulAttrValueTab = {0,0,0,0,0};
            local soulAttrValueTab2 = {0,0,0,0,0};
            local soulPercentValueTab = {0,0,0,0,0};
            local rolePropertryValueTab = {0,0,0,0,0}
            local cbmTab = game_util:getCombatBonusMultiplierByCfg(cardCfg,cardData.id);--连协属性
            local soulPercentCombatTab = {0,0,0,0,0};
            for i=1,5 do
                local abilityItem = PUBLIC_ABILITY_TABLE["ability_" .. i] or {}
                local attrValue = cardData[abilityItem.attrName or ""] or 0
                soulPercentCombatTab[i] = attrValue * soulPercentValueTab[i] * 0.01
                attrValueTab[i] = math.floor(equipAttrValueTab[i]  + magicAttrValueTab[i] + attrValue*cbmTab[i] + petAttrValueTab[i] + petFollowValueTab[i] + rolePropertryValueTab[i])
            end
            local addLife = math.floor((attrValueTab[5] + cardData.hp)* m_addTable * 0.01)
            local addAtk = math.floor((attrValueTab[1] + cardData.patk) * m_addTable * 0.01)
            local addMag = math.floor((attrValueTab[2] + cardData.matk)* m_addTable * 0.01)
            local addDef = math.floor((attrValueTab[3] + cardData.def) * m_addTable * 0.01)
            local addSpeed = math.floor((attrValueTab[4] + cardData.speed) * m_addTable * 0.01)
            aa[1] = addAtk
            aa[2] = addMag
            aa[3] = addDef
            aa[4] = addSpeed
            aa[5] = addLife
            -- game_data:setBonusAddTab(aa,posIndex)
        else
            aa[1] = 0
            aa[2] = 0
            aa[3] = 0
            aa[4] = 0
            aa[5] = 0
            -- game_data:setBonusAddTab(aa,posIndex)
        end
        temptab = aa
        -- table.insert(temptab,aa)
    end
    local m_tab_curId = zhenfaFriend[tostring(index-1)] or {}
    local m_addTable =  getAddRate(index,m_tab_curId)
    getPriority(index,m_addTable)
    game_data:setBonusAddTab(temptab)
    return temptab
end

function M.getFateGemRewardId(self,tempId,count)
    -- cclog(tostring(tempId) .. " ; count ===========" .. tostring(count))
    local icon,name,quality = nil,"",0;
    local gemCfg = getConfig(game_config_field.equip_gem_fate);
    local itemCfg = gemCfg:getNodeWithKey(tostring(tempId));
    if itemCfg then
        local last_name = itemCfg:getNodeWithKey("last_name"):toStr()
        local first_name = itemCfg:getNodeWithKey("first_name"):toStr()
        name = last_name .. first_name
        icon = self:createGemIconByCfg(itemCfg);
        quality = itemCfg:getNodeWithKey("quality"):toInt();
    else
        cclog("gemCfg cfg not found == " .. tostring(tempId))
    end
    return icon,name,count,quality;
end


--[[--
    联协刷新用
   
]]
function M.cardChainByCfg2(self,heroCfg,cardId, playerData,teamData,equipData)
    local chainTab, openChainCount = {},0;
    if heroCfg == nil then return chainTab end
    local chain = heroCfg:getNodeWithKey("chain")
    local chainCount = chain:getNodeCount();
    -- cclog("chainCount ======================= " .. chainCount)
    local teamCharacterIdTab, teamEquipIdTab = nil, nil
    if chainCount > 0 then
        if playerData then
            teamCharacterIdTab, teamEquipIdTab = self:getPlayerCardAndEquipChainTab(cardId, playerData,teamData,equipData);
        else
            if teamData ~= nil or equipData ~= nil then
                teamCharacterIdTab, teamEquipIdTab = self:getCardAndEquipChainTab1(cardId,teamData,equipData);
            else
                teamCharacterIdTab, teamEquipIdTab = self:getCardAndEquipChainTab(cardId,teamData,equipData);
            end
        end
        local character_detail_cfg = getConfig(game_config_field.character_detail);
        local chain_cfg = getConfig(game_config_field.chain);
        local equip_cfg = getConfig(game_config_field.equip);
        for i=1,chainCount do
            local chainId = chain:getNodeAt(i-1):toStr();
            local chainItemCfg = chain_cfg:getNodeWithKey(chainId);
            if chainItemCfg then
                local name = chainItemCfg:getNodeWithKey("name"):toStr();
                local des = chainItemCfg:getNodeWithKey("des"):toStr();
                local effect = chainItemCfg:getNodeWithKey("effect")
                local effectTab=json.decode(effect:getFormatBuffer())
                local data = chainItemCfg:getNodeWithKey("data")
                local dataTab=json.decode(data:getFormatBuffer())
                local dataCount = data:getNodeCount();
                local condition_sort = chainItemCfg:getNodeWithKey("condition_sort"):toInt();
                local newDes="(Đã chuyển đổi)Với"
                if dataCount > 0 then
                    local tempCount = 0;
                    if condition_sort == 0 then--卡牌联协

                        --todo bengin
                        --des重写
                            local cardData=game_data:getCardDataById(cardId)
                            if cardData == nil then -- 兼容取自己数据为空 取公会数据
                                cardData = game_data:getGuildCardDataById(cardId)
                            end
                            local fate_change_cfg=getConfig(game_config_field.fate_change)
                            if cardData.fate_change and next(cardData.fate_change) then
                                for k=2,dataCount do
                                    --if data:getNodeAt(i-1):toStr() == tostring(cardData.fate_change["c_id1"] ) and tostring(chainId)==tostring(cardData.fate_change["chain_id"]) then
                                     if tostring(chainId)==tostring(cardData.fate_change["chain_id"]) then
                                        newDes=newDes.." ".."card"..k.." ";
                                        des=newDes.."Trong khi đó";
                                        local changedEffect=nil;
                                         local change_id=cardData.fate_change["change_id"]
                                         changedEffect=cardData.fate_change["effect"]
                                        
                                   --des描述
                                        local typeName = {"Vật công+","Ma Công+","Phòng ngự+","Tốc độ+","HP+"}
                                        for j=1,#changedEffect do
                                           des=des..typeName[changedEffect[j][1]+1]..tostring(changedEffect[j][2]/10).."%".." "
                                          
                                        end
                                    end
                                end
                            end


                        for i=1,dataCount do
                            if cardData.fate_change and next(cardData.fate_change) then
                                -- cclog2(cardData.fate_change,"fate_change==")
                                if data:getNodeAt(i-1):toStr() == tostring(cardData.fate_change["c_id1"] ) and tostring(chainId)==tostring(cardData.fate_change["chain_id"]) then

                                    dataTab[i]=cardData.fate_change["c_id2"]; --直接修改相应table
                                end
                            end
                            --todo end
                            local itemCfg = character_detail_cfg:getNodeWithKey(tostring(dataTab[i]))
                            if itemCfg then
                                if teamCharacterIdTab[itemCfg:getNodeWithKey("character_ID"):toInt()] then
                                    des = string.gsub(des,"card" .. i,"[color=ffffdc00]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                    tempCount = tempCount + 1;
                                else
                                    des = string.gsub(des,"card" .. i,"[color=ff8A8A8A]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                end
                            end
                        end
                        if tempCount >= dataCount then--联协开启
                            openChainCount = openChainCount + 1;
                            chainTab[#chainTab + 1] = {name = "[color=ffffdc00]" .. name .. "[/color]",detail = "[color=ffffdc00]" .. name .. "[/color] : " .. des,openFlag = true,count = dataCount ,t = "c" , chain = chainId , nameExt = name}
                        else
                            chainTab[#chainTab + 1] = {name = "[color=ff8A8A8A]" .. name .. "[/color]",detail = "[color=ff8A8A8A]" .. name .. "[/color] : " .. des,openFlag = false,count = tempCount ,t = "c" , chain = chainId , nameExt = name}
                        end
                    elseif condition_sort == 1 then--装备联协
                        for i=1,dataCount do
                            local itemCfg = equip_cfg:getNodeWithKey(data:getNodeAt(i-1):toStr())
                            if itemCfg then
                                -- cclog("itemCfg:getNodeWithKey(\"equip_id\"):toInt() == " .. itemCfg:getNodeWithKey("equip_id"):toInt())
                                local sort = itemCfg:getNodeWithKey("sort"):toInt();
                                local chain_id = itemCfg:getNodeWithKey("chain_id")
                                chain_id = chain_id and chain_id:toInt() or itemCfg:getNodeWithKey("equip_id"):toInt()
                                if teamEquipIdTab[chain_id] or teamEquipIdTab[sort] then
                                    des = string.gsub(des,"equip" .. i,"[color=ffC636F8]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                    tempCount = tempCount + 1;
                                else
                                    des = string.gsub(des,"equip" .. i,"[color=ff8A8A8A]" .. itemCfg:getNodeWithKey("name"):toStr() .. "[/color]");
                                end
                            end
                        end
                        if tempCount >= dataCount then--联协开启
                            openChainCount = openChainCount + 1;
                            chainTab[#chainTab + 1] = {name = "[color=ffC636F8]" .. name .. "[/color]",detail = "[color=ffC636F8]" .. name .. "[/color] : " .. des,openFlag = true, count = dataCount , t = "e" , chain = chainId , nameExt = name}
                        else
                            chainTab[#chainTab + 1] = {name = "[color=ff8A8A8A]" .. name .. "[/color]",detail = "[color=ff8A8A8A]" .. name .. "[/color] : " .. des,openFlag = false, count = tempCount , t = "e" , chain = chainId , nameExt = name}
                        end
                    end
                else
                    chainTab[#chainTab + 1] = {name = name,detail = name .. " : "}
                end
            end
        end
    end
    return chainTab,chainCount,openChainCount
end

function M.isInFormationBonusAdd( self,cardId ) --判断是否在新助威的阵法加成add里面
    local sha = ""
    local m_formationBounsAdditionData = {},{}
    m_formationBounsAdditionData = game_data:getFormationBonusAdditionByJsonData()
    for index,table in pairs(m_formationBounsAdditionData) do
        if table and next(table) then
            for i,id in pairs(table) do
                if tostring(id) == tostring(cardId) then
                    sha = "zhenfaAdd"
                    return sha
                end
            end
        end
    end
    return false
end



--[[
    ------------------------------------法宝ccb start   zyz -------------------------------------------  
]]


function M.createMagicItemByCCB(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_magic_list_item.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setMagicItemInfoByTable(ccbNode,itemData);
    end
    return ccbNode
end


function M.setMagicItemInfoByTable(self,ccbNode,itemData)
    if ccbNode == nil or itemData == nil then return end
    ccbNode:nodeForName("m_info_node"):setVisible(true);
    local magicCfg = getConfig(game_config_field.talisman);
    local itemCfg = magicCfg:getNodeWithKey(itemData.c_id);
    local level = itemData.lv;
    local attTable = self:getMagicAbilityValue(itemCfg,level,itemData);
    for k,v in pairs(attTable) do
        ccbNode:spriteForName(v.sp):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(v.icon));
        ccbNode:labelBMFontForName(v.lb):setString(v.value)
    end
    local talisman_type = itemCfg:getNodeWithKey("talisman_type"):toInt();
    ccbNode:spriteForName("m_type_icon"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(PUBLIC_MAGIC_ABILITY_TABLE["ability_" .. talisman_type].icon))
    local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
    if quality > 0 and quality < 10 then
        ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(HERO_QUALITY_COLOR_TABLE[quality].card_img));
    end
    local m_name_label = ccbNode:labelTTFForName("m_name_label");
    m_name_label:setString(itemCfg:getNodeWithKey("talisman_name"):toStr() .. "+" .. level);

    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    local m_team_name = ccbNode:labelTTFForName("m_team_name")
    --所属英雄
    local existFlag,cardName = game_data:magicInMagicPos(itemCfg:getNodeWithKey("talisman_type"):toInt(),itemData.id)
    if existFlag then
        m_team_img:setVisible(true);
        m_team_name:setString(cardName);
        m_team_name:setVisible(true)
    else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    end
    local m_god_img = ccbNode:spriteForName("m_god_img")
    local godexistFlag =  game_data:godmagicInMagicPos(itemCfg:getNodeWithKey("talisman_type"):toInt(),itemData.id,ccbNode) --设置神域标志
    if godexistFlag then
        m_god_img:setVisible(true);
    else
        m_god_img:setVisible(false);
    end
    local m_bonus_img = ccbNode:spriteForName("m_bonus_img")
    local existFlag2,pos = game_data:magicInBonus2(itemCfg:getNodeWithKey("talisman_type"):toInt(),itemData.id)
    if existFlag2 then 
        m_bonus_img:setVisible(true)
    else
        m_bonus_img:setVisible(false)
    end
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createIconByName(itemCfg:getNodeWithKey("image"):toStr()) --self:createEquipIcon(itemCfg)
    if icon then
        m_anim_node:addChild(icon)
    end
    --英雄星级
    local refining_node = ccbNode:nodeForName("refining_node")
    local refining_level = ccbNode:labelBMFontForName("refining_level")
    local string = itemCfg:getNodeWithKey("star"):toStr()
    -- cclog2(string,"string  -------- ")
    if string ~= "0" then
        refining_level:setString(string)
        refining_node:setVisible(true)
    else
        refining_node:setVisible(false)
    end
    --装备锻造等级
    ccbNode:nodeForName("forge_node"):setPosition(ccp(18,116))

    --m命运装备绑定
    ccbNode:spriteForName("m_sprite_ming"):setVisible(false)

end


function M.createMagicItemByCCB2(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_equip_list_item2.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setMagicItemInfoByTable2(ccbNode,itemData);
    end
    return ccbNode
end

function M.setMagicItemInfoByTable2(self,ccbNode,itemData)
    local magicCfg = getConfig(game_config_field.talisman);
    local itemCfg = magicCfg:getNodeWithKey(tostring(itemData.c_id));
    if itemCfg == nil then return end
    local level = itemData.lv;
    local attTable = self:getMagicAbilityValue2(itemCfg,level,itemData);
    -- cclog2(attTable,"  attTable   -----  >>>>> ")
    for k,v in pairs(attTable) do
        ccbNode:spriteForName(v.sp):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(v.icon));
        ccbNode:labelBMFontForName(v.lb):setString(v.value)
    end -- formatValueToString2

    local m_name_label = ccbNode:labelTTFForName("m_name_label");
    m_name_label:setString(itemCfg:getNodeWithKey("talisman_name"):toStr() .. "+" .. level);
    
    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    -- local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    local m_team_name = ccbNode:labelTTFForName("m_team_name")
    local existFlag,cardName = game_data:magicInMagicPos(itemCfg:getNodeWithKey("talisman_type"):toInt(),itemData.id)
    if existFlag then
        m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_yizhuangbei.png"));
        m_team_img:setVisible(true);
        m_team_name:setString("");
    else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    end
    local m_god_img = ccbNode:spriteForName("m_god_img2")
    local godexistFlag =  game_data:godmagicInMagicPos(itemCfg:getNodeWithKey("talisman_type"):toInt(),itemData.id,ccbNode) --设置神域标志
    if godexistFlag then
        m_god_img:setVisible(true);
    else
        m_god_img:setVisible(false);
    end

    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createMagicIcon(itemCfg,"false")
    if icon then
        icon:setScale(0.8);
        m_anim_node:addChild(icon)
    end

    local refining_node = ccbNode:nodeForName("refining_node")
    local refining_level = ccbNode:labelBMFontForName("refining_level")
    local string = itemCfg:getNodeWithKey("star"):toStr()
    if string and string ~= "0" then
        refining_level:setString(string)
        refining_node:setVisible(true)
    else
        refining_node:setVisible(false)
    end


    local m_max_evo_img = ccbNode:spriteForName("m_max_evo_img")
    local evolution = itemCfg:getNodeWithKey("talisman_break"):toInt();
    if evolution == 0 then
        m_max_evo_img:setVisible(true);
    else
        m_max_evo_img:setVisible(false);
    end

    local m_node_old = ccbNode:nodeForName("m_node_old")
    -- 英雄附魔信息
    local atts = itemData.atts
    local is_enchant = itemData.is_enchant
    if is_enchant then -- 已附魔
        m_node_old:stopAllActions();
        local function newFunc(node)

            ccbNode:spriteForName("m_icon_ability_1"):setVisible(true)
            ccbNode:spriteForName("m_label_ability_1"):setVisible(true)
            ccbNode:spriteForName("m_icon_ability_2"):setVisible(true)
            ccbNode:spriteForName("m_label_ability_2"):setVisible(true)
            ccbNode:labelBMFontForName("m_label_ability_2"):setString(value1..unit1);
            ccbNode:labelBMFontForName("m_label_ability_1"):setString(value2..unit2);
            ccbNode:spriteForName("m_icon_ability_2"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1));
            ccbNode:spriteForName("m_icon_ability_1"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon2));
        end
        local function oldFunc(node)
            ccbNode:spriteForName("m_icon_ability_1"):setVisible(false)
            ccbNode:spriteForName("m_label_ability_1"):setVisible(false)
            ccbNode:spriteForName("m_icon_ability_2"):setVisible(false)
            ccbNode:spriteForName("m_label_ability_2"):setVisible(false)
            -- ccbNode:spriteForName("m_label_ability_2"):removeAllChildrenWithCleanup(true)
            local tempSpr ={}
            -- local spriteTable = {self.m_property_sprite_add_1,self.m_property_sprite_add_2}
            local i = 0 -- 计数 表示sprite的编号 1 2 
            for k,v in pairs(atts) do
                tempSpr = PUBLIC_ABILITY_NAME_TABLE[k] or {}
                i = i + 1
                local m_icon_ability = ccbNode:spriteForName("m_icon_ability_"..i)
                local m_label_ability = ccbNode:labelBMFontForName("m_label_ability_"..i)
                local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tostring(tempSpr.icon))
                if tempSpriteFrame then
                    m_icon_ability:setDisplayFrame(tempSpriteFrame)
                    m_icon_ability:setVisible(true)
                    local value,unit = self:formatValueToString2(v)
                    m_label_ability:setString(value..unit)
                    m_label_ability:setVisible(true)
                else
                    m_icon_ability:setVisible(false)
                    m_label_ability:setVisible(false)
                end
            end
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
    else
        m_node_old:stopAllActions();
        ccbNode:spriteForName("m_icon_ability_1"):setOpacity(255)
        ccbNode:spriteForName("m_label_ability_1"):setOpacity(255)
        ccbNode:spriteForName("m_icon_ability_2"):setOpacity(255)
        ccbNode:spriteForName("m_label_ability_2"):setOpacity(255)
        ccbNode:spriteForName("m_icon_ability_2"):setVisible(true)
        ccbNode:spriteForName("m_label_ability_2"):setVisible(true)
    end


end

function M.createMagicIcon(self,itemCfg,flag)
    local flag = flag or "true"
    local tempIcon = nil;
    if itemCfg then
        local image
        if tolua.type(itemCfg) == "util_json" then
            image = itemCfg:getNodeWithKey("image"):toStr();
        else
            image = itemCfg.image
        end
        tempIcon = self:createIconByName(image)
        if tempIcon == nil then
            cclog(image .. " image is not found");
        end
    else
        cclog("magic config is not found");
    end
    if tempIcon then
        local tempIconSize = tempIcon:getContentSize();
        local quality
        if tolua.type(itemCfg) == "util_json" then
            quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
        else
            quality = tonumber(itemCfg.quality) + 1
        end
        -- cclog("quality ==" .. quality)
        local qualityTab = HERO_QUALITY_COLOR_TABLE[quality];
        if qualityTab then
            local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
            img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img1,-1,1)
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,2)
        end
        if flag == "true" then
            local frame = nil
            if tolua.type(itemCfg) == "util_json" then
                frame = itemCfg:getNodeWithKey("frame"):toStr()
            else
                frame = itemCfg.frame
            end
        
            if frame and frame ~= "" then
                local onAnimSectionEnd = function(animNode, theId,theLabelName)
                    animNode:playSection(theLabelName)
                end

                local anim = game_anim:create(frame .. ".swf.sam",0,frame .. "-hd.plist");
                if anim then
                    anim:setScale(1.25)
                    anim:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
                    tempIcon:addChild(anim,1,3)
                    anim:registerScriptTapHandler(onAnimSectionEnd)
                    game_anim:playSection(anim,"effect")
                end
            end
        end
    end
    return tempIcon;
end

function M:getMagicAbilityValue(itemCfg,level,itemData)
    if tolua.type(itemCfg) == "util_json" then
        itemCfg = json.decode(itemCfg:getFormatBuffer())
    end
    local tempTable = {
    type_0 = {
        {icon = "public_icon_hp.png",att = "hp",value = 0,sp = "m_ability2_icon",lb = "m_ability2_label",},
        {icon = "public_icon_dfs.png",att = "def",value = 0,sp = "m_ability1_icon",lb = "m_ability1_label",},
        {icon = "public_icon_speed.png",att = "speed",value = 0,sp = "m_icon_ability_1",lb = "m_label_ability_1",},
        {icon = "public_magic_dodge.png",att = "dr",value = 0,sp = "m_icon_ability_2",lb = "m_label_ability_2",},
    },
    type_1 = {
        {icon = "public_icon_phsc.png",att = "patk",value = 0,sp = "m_ability2_icon",lb = "m_ability2_label",},
        {icon = "public_icon_mgc.png",att = "matk",value = 0,sp = "m_ability1_icon",lb = "m_ability1_label",},
        {icon = "public_magic_crit.png",att = "crit",value = 0,sp = "m_icon_ability_1",lb = "m_label_ability_1",},
        {icon = "public_magic_hit.png",att = "hr",value = 0,sp = "m_icon_ability_2",lb = "m_label_ability_2",},
    },
}
    local table = tempTable["type_" .. itemCfg.talisman_type]
    for k,v in pairs(table) do
        v.value = v.value + itemCfg["base_" .. v.att] + itemCfg["growth_" .. v.att] * level
        if v.att == "dr" or v.att == "crit" or v.att == "hr" then
            v.value = tostring(v.value) .. "%"
        else
            v.value = tostring(v.value)
            if string.len(v.value) > 3 then
                v.value = math.floor(tonumber(v.value)/1000) .. "k"
            end
        end
    end
    return table
end

function M:getMagicAbilityValue2(itemCfg,level,itemData)
    if tolua.type(itemCfg) == "util_json" then
        itemCfg = json.decode(itemCfg:getFormatBuffer())
    end
    local tempTable = {
    type_0 = {
        {icon = "public_icon_hp.png",att = "hp",value = 0,sp = "m_icon_ability_1",lb = "m_label_ability_1",},
        {icon = "public_icon_dfs.png",att = "def",value = 0,sp = "m_icon_ability_2",lb = "m_label_ability_2",},
    },
    type_1 = {
        {icon = "public_icon_phsc.png",att = "patk",value = 0,sp = "m_icon_ability_1",lb = "m_label_ability_1",},
        {icon = "public_icon_mgc.png",att = "matk",value = 0,sp = "m_icon_ability_2",lb = "m_label_ability_2",},
    },
}
    local table = tempTable["type_" .. itemCfg.talisman_type]
    for k,v in pairs(table) do
        v.value = v.value + itemCfg["base_" .. v.att] + itemCfg["growth_" .. v.att] * level
        if v.att == "dr" or v.att == "crit" or v.att == "hr" then
            v.value = tostring(v.value) .. "%"
        else
            v.value = tostring(v.value)
            if string.len(v.value) > 3 then
                v.value = math.floor(tonumber(v.value)/1000) .. "k"
            end
        end
    end
    return table
end

function M:createMagicIconByTable(table)
    local id = table[2]
    local count = table[3]
    local talisman = getConfig(game_config_field.talisman)
    local tempData = talisman:getNodeWithKey(id)
    local image = tempData:getNodeWithKey("image"):toStr()
    local quality = tempData:getNodeWithKey("quality"):toInt()
    local name = tempData:getNodeWithKey("talisman_name"):toStr()
    local icon = self:createMagicIcon(tempData)
    return icon,name,count,quality
end


function M:getMagicCombatByTable(tableData)
    local combat = 0
    if tableData then
        for k,v in pairs(tableData) do
            local att = self:getMagicAttrValueByTable(v)
            for m,n in pairs(att) do
                combat = combat + n
            end
        end
    end
    cclog("getMagicCombatByTable     ========== " .. combat)
    return combat
end


function M:getMagicAttrValueByTable(tableData)
    -- 1物攻 2魔攻 3防御 4速度 5生命
    local attrValueTab = {0,0,0,0,0};
    local TempTable = {
       tab_1 = {
            {base = "patk",},
            {base =  "matk",},
            {base = nil,},
            {base = nil,},
            {base = nil,},
        },
        tab_0 = {
            {base = nil,},
            {base = nil,},
            {base = "def",},
            {base = "speed",},
            {base = "hp",},
        },
    }
    for k,v in pairs(tableData) do
        if v ~= "0" and v ~= 0 then
            local itemData,itemCfg = game_data:getMagicDataById(v)
            if itemData and itemCfg then
                local level = itemData.lv;
                local table = TempTable["tab_" .. itemCfg.talisman_type]
                for k,v in pairs(table) do
                    if v.base ~= nil then
                        attrValueTab[k] = attrValueTab[k] + itemCfg["base_" .. v.base] + itemCfg["growth_" .. v.base] * level
                    end  
                end
            end 
        end
    end
    return attrValueTab
end

--[[
    通过勋章id创建勋章图标
]]
function M.createTalismanIconById(self,id)--createMagicIconByTable
    local itemData,itemCfg = game_data:getMagicDataById(id)
    return self:createMagicIcon(itemCfg),itemCfg.talisman_name
end


--[[------------------------------------法宝ccb end-------------------------------------------  ]]

--[[
    宝石进阶 通过id来判定宝石的cid和进阶级别 -----changedByzjr
]]
function M.getRealGemLvAndCid( self, gemId )
    local lv = 0
    if string.find(tostring(gemId),"-") then --进阶过的宝石id有 "-"
        local result = util.stringSplit(gemId,"-")
        return result[1], result[2]
    else
        return tonumber(lv),tostring(gemId)
    end
end
--[[
    获取进阶过后的宝石数量-----changedByzjr
]]
function M.getAllGemConunt( self, gemId )
    local tempData = game_data:getGemData() or {};
    local count = 0
    for k,v in pairs(tempData) do
        if string.find(k,"-") then
            local result = util.stringSplit(k,"-")
            if tostring(gemId) == tostring(result[2]) then
                count = count + v
            end
        end
    end
    return count
end

--[[
    通过宝石进阶数获取增加的属性值-----changedByzjr
]]
function M.getGemAttrByLv( self, lv, ability )
    local gem_evo_cfg = getConfig(game_config_field.gem_evolution)
    lv = lv or 0
    if lv == 0 then
        return 0,0
    end
    local itemCfg = gem_evo_cfg:getNodeWithKey(tostring(lv))
    local abilityTab = itemCfg:getNodeWithKey("ability")
    abilityTab = json.decode(abilityTab:getFormatBuffer())
    -- cclog2(ability,"ability ==== ")
    local curValue1,curValue2 = 0,0
    for k,v in pairs(abilityTab) do
        if tonumber(v[1]) == tonumber(ability) then
            curValue1 = v[2]
            if v[3] then
                curValue2 = v[3]
            end
        end
    end
    return curValue1,curValue2

end

--[[
    创建cocos2dx 自带的粒子特效
]]

function M.createCocosParticleSystemQuad(self,params)
    local tempParticle = CCParticleExplosion:create()
    if params.name then
        if params.name == "boom" then
            tempParticle = CCParticleExplosion:create()
        elseif params.name == "fire" then
            tempParticle = CCParticleFire:create()
        elseif params.name == "fireworks" then
            tempParticle = CCParticleFireworks:create()
        elseif params.name == "flowers" then
            tempParticle = CCParticleFlower:create()
        elseif params.name == "galaxy" then
            tempParticle = CCParticleGalaxy:create()
        elseif params.name == "sun" then
            tempParticle = CCParticleSun:create()
        elseif params.name == "sprial" then
            tempParticle = CCParticleSpiral:create()
        elseif params.name == "snow" then
            tempParticle = CCParticleSnow:create()
        elseif params.name == "smoke" then
            tempParticle = CCParticleSmoke:create()
        elseif params.name == "rain" then
            tempParticle = CCParticleRain:create()
        elseif params.name == "meteor" then
            tempParticle = CCParticleMeteor:create()
        end
    end
    if tempParticle then
        if params.pos then
            tempParticle:setPosition(params.pos);
        end
        tempParticle:setAutoRemoveOnFinish(false);
    end
    return tempParticle
end


--[[
    计算穿戴皮肤获得的战斗力
]]
function M.getSkinCombat( self, c_id )
    local usedSkin = game_data:getCurCardSkinData()
    local skin = game_data:getCardSkinData()
    local skinCombatTab = {0,0,0,0,0}
    local skinID = 0
    local character_detail_cfg = getConfig(game_config_field.character_detail);
    local heroCfg = character_detail_cfg:getNodeWithKey(tostring(c_id));
    if heroCfg:getNodeWithKey("is_skin") then
        if heroCfg:getNodeWithKey("is_skin"):toInt() ~= 0 then
            skinID = heroCfg:getNodeWithKey("is_skin"):toInt()
        end
    end

    for k,v in pairs(usedSkin) do
        if tonumber(skinID) == tonumber(v) then
            local attrType = skin[tostring(v)][1]
            local attrValue = skin[tostring(v)][2]
            if not(skinCombatTab[attrType]) then
                skinCombatTab[attrType] = 0
            end 
            skinCombatTab[attrType] = skinCombatTab[attrType] + attrValue
        end
    end
    return skinCombatTab
end

--[[
    获取阵法加成战斗力
]]
function M:getbonusCombat(total_factor_tab,rightTeamData)   --
    local combat = 0
    local temp_TeamData = game_data:getRightTeamData()
    local bonusCombat = self:getAllBonusCombat(temp_TeamData)
    for k,v in pairs(temp_TeamData) do
        if bonusCombat[k] and total_factor_tab[v] then
            combat = combat + bonusCombat[k] * total_factor_tab[v]
        end
    end
    return combat
end



--[[
    圣石能力属性加成
]]
function M.getSaintStoneCombatValue(self, posIndex , GodGemData)
    local attrPercentValueTab = {0,0,0,0,0,0,0,0}
    local cfg = getConfig(game_config_field.god_stone);
    local posData = game_data:getSaintStonePosData() or {};

    local posItemData = posData[tostring(posIndex-1)] or {}
    local sainStonedata = game_data:getSaintStoneData();

    if GodGemData ~= nil then
          posData = GodGemData or {};
          posItemData = posData[tostring(posIndex-1)] or {}
    end
    for k,v in pairs(posItemData) do
        if tostring(v)~=tostring(0) then

            local itemData=cfg:getNodeWithKey(tostring(v))
            local ability=itemData:getNodeWithKey("ability"):toInt()
            local value=itemData:getNodeWithKey("value"):toInt()
            local team=itemData:getNodeWithKey("team"):toInt()
            if team~=9 and team ~=10 then
                attrPercentValueTab[team]=value
            end

        end

    end

    -- cclog2(attrPercentValueTab,"attrPercentValueTab")
    return attrPercentValueTab
  
end


--[[ 
    进阶过的宝石-----changedByzjr
]]
function M.setGemItemInfoByTable3(self,ccbNode,itemData)
    local gemCfg = getConfig(game_config_field.gem);
    local itemCfg = gemCfg:getNodeWithKey(tostring(itemData.c_id));
    if itemCfg == nil then return end
    local level = itemData.lv;
    local attrName1,value1,icon1 = self:getGemAttributeValue(itemCfg,level);
    local curValue1,curValue2 = 0,0
    if itemData.curGemLv and itemData.curGemLv > 0 then
         curValue1,curValue2 = game_util:getGemAttrByLv(itemData.curGemLv, itemCfg:getNodeWithKey("ability"):toInt())
    end
    ccbNode:labelBMFontForName("m_ability1_label"):setString("+" .. value1 + curValue1);
    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1)
    if tempSpriteFrame then
        ccbNode:spriteForName("m_ability1_icon"):setDisplayFrame(tempSpriteFrame);
    end
    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local x,y = m_name_label:getPosition()
    m_name_label:setPosition(ccp(84,y))
    local last_name = itemCfg:getNodeWithKey("last_name"):toStr()
    local first_name = itemCfg:getNodeWithKey("first_name"):toStr()
    m_name_label:setString(last_name .. first_name);
    ccbNode:labelBMFontForName("m_ability1_name_label"):setString("");
    
    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    local existFlag,cardName = game_data:gemInGemPos(itemCfg:getNodeWithKey("career"):toInt(),itemData.c_id)
    -- if existFlag then
    --     m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_yizhuangbei.png"));
    --     m_team_img:setVisible(true);
    --     -- m_team_name:setString(cardName);
    --     m_team_name:setString("");
    -- else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    -- end
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createGemIconByCfg(itemCfg)
    if icon then
        icon:setScale(0.75);
        m_anim_node:addChild(icon)
    end
    local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
    if quality > 10 and quality < 14 then
        self:createNewGemAnim(m_anim_node,quality,nil,nil )
    end
    local m_max_evo_img = ccbNode:spriteForName("m_max_evo_img")
    local advanced_node = ccbNode:nodeForName("advanced_node")

    if itemData.curGemLv and itemData.curGemLv > 0 then
        advanced_node:setVisible(true)
        local advanced_level = ccbNode:labelBMFontForName("advanced_level")
        advanced_level:setString(tostring(itemData.curGemLv))
    else
        advanced_node:setVisible(false)
    end
    local m_max_evo_img = ccbNode:spriteForName("m_max_evo_img")
    local evo_max = itemCfg:getNodeWithKey("evo_max"):toInt()
    if itemData.curGemLv and itemData.curGemLv  < evo_max then
        m_max_evo_img:setVisible(false)
    else
        m_max_evo_img:setVisible(true)
    end

end
function M:utfstrlen(str)
    local byteSize = 0
    for i = 1 , #str do
        local byteCount = 0
        local curByte = string.byte(str, i)
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<=239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        byteSize = byteSize + byteCount
    end
    return byteSize
end


--截取中英文混合字符串
--参数
--  string str  原始字符串
--  number start 起始位置，注意中文长度为1
--  number len  截取长度
--返回值
--  string 截取后的字符串
--备注
--  1)中文UTF8默认占3个字节，可能对于一些占2个或4个字节的中文处理有问题
--  2)回车\n等特殊控制字符也算一个长度
function M:subUTF8String(str, len)
    local byteSize = 0
    for i = 1 , len do
        local byteCount = 0
        local curByte = string.byte(str, i)
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<=239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        byteSize = byteSize + byteCount
    end
    return string.sub(str,1,byteSize)..'...'
end

--判断玩家身上穿戴的皮肤
function M:isWearSkin( cardSkinId)
    local curSkinData = game_data:getCurCardSkinData()
    -- cclog2(curSkinData,"curSkinData -----")
    -- cclog2(cardSkinId,"cardSkinId -----")
    for k,v in pairs(curSkinData) do
        if tostring(cardSkinId) == tostring(v) then
            return true
        end
    end
    return false
end

function M:isWearSkin2( cardSkinId, cardSkinData)
    local curSkinData = cardSkinData
    -- cclog2(curSkinData,"curSkinData -----")
    -- cclog2(cardSkinId,"cardSkinId -----")
    for k,v in pairs(curSkinData) do
        if tostring(cardSkinId) == tostring(v) then
            return true
        end
    end
    return false
end

function M.getCardUserLockFlag(self,itemData)
    local lockFlag = false;
    if itemData and itemData.remove_avail then
        for k,v in pairs(itemData.remove_avail) do
            if tostring(v) == "user" then
                lockFlag = true;
                break;
            end
        end
    end
    return lockFlag;
end



function M.createGemItemByCCB2(self,itemData)
    local ccbNode = luaCCBNode:create();
    ccbNode:openCCBFile("ccb/ui_gem_system_list_item2.ccbi");
    ccbNode:setAnchorPoint(ccp(0.5,0.5));
    if ccbNode ~= nil and itemData ~= nil then
        self:setGemItemInfoByTable2(ccbNode,itemData);
    end
    return ccbNode
end

function M.setGemItemInfoByTable2(self,ccbNode,itemData)
    local gemCfg = getConfig(game_config_field.gem);
    local curGemLv,gemId = 0,0-----changedByzjr
    if itemData.c_id then
         curGemLv,gemId = self:getRealGemLvAndCid(itemData.c_id)
    end
    local itemCfg = gemCfg:getNodeWithKey(tostring(gemId));
    if itemCfg == nil then return end
    local level = itemData.lv;
    local attrName1,value1,icon1 = self:getGemAttributeValue(itemCfg,level);
    local curValue1,curValue2 = self:getGemAttrByLv(curGemLv, itemCfg:getNodeWithKey("ability"):toInt() )
    ccbNode:labelBMFontForName("m_ability1_label"):setString("+" .. value1);
    local tempSpriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon1)
    if tempSpriteFrame then
        ccbNode:spriteForName("m_ability1_icon"):setDisplayFrame(tempSpriteFrame);
    end
    local m_name_label = ccbNode:labelBMFontForName("m_name_label");
    local last_name = itemCfg:getNodeWithKey("last_name"):toStr()
    local first_name = itemCfg:getNodeWithKey("first_name"):toStr()
    m_name_label:setString(last_name .. first_name .. " x" .. tostring(itemData.count));
    ccbNode:labelBMFontForName("m_ability1_name_label"):setString(attrName1);

    -- 布局修改
    local m_ability1_name_label = ccbNode:labelBMFontForName("m_ability1_name_label")
    local m_ability1_label = ccbNode:labelBMFontForName("m_ability1_label")
    -- if m_ability1_name_label:getPositionX() + m_ability1_name_label:getContentSize().width + 1 > m_ability1_label:getPositionX() then
    --     m_ability1_label:setPositionX(m_ability1_name_label:getPositionX() + m_ability1_name_label:getContentSize().width + 1)
    -- end
    -- 自适应
    local nd_attr1 = ccbNode:nodeForName("nd_attr1")
    self.adaptNodeChildrensScaleX(nd_attr1, 96, 1)
    
    ccbNode:spriteForName("m_sel_img"):setVisible(false);
    local m_team_img = ccbNode:spriteForName("m_team_img")
    local m_team_name = ccbNode:labelBMFontForName("m_team_name")
    local existFlag,cardName = game_data:gemInGemPos(itemCfg:getNodeWithKey("career"):toInt(),gemId)
    -- if existFlag then
    --     m_team_img:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("public_yizhuangbei.png"));
    --     m_team_img:setVisible(true);
    --     -- m_team_name:setString(cardName);
    --     m_team_name:setString("");
    -- else
        m_team_img:setVisible(false);
        m_team_name:setString("");
    -- end
    local m_anim_node = ccbNode:nodeForName("m_anim_node")
    m_anim_node:removeAllChildrenWithCleanup(true);
    local icon = self:createGemIconByCfg(itemCfg)
    if icon then
        icon:setScale(0.75);
        m_anim_node:addChild(icon)
    end
    local quality = itemCfg:getNodeWithKey("quality"):toInt()+1;
    if quality > 10 and quality < 14 then
        self:createNewGemAnim(m_anim_node,quality,nil,nil )
    end
    local advanced_node = ccbNode:nodeForName("advanced_node")
    if tonumber(curGemLv) > 0 then
       advanced_node:setVisible(true)
       local advanced_level = ccbNode:labelBMFontForName("advanced_level")
       advanced_level:setString(tostring(curGemLv))
    else
       advanced_node:setVisible(false)
    end
    local m_max_evo_img = ccbNode:spriteForName("m_max_evo_img")
end
--[[
    命运宝石 通过配置获取宝石的类型和数值
]]
function M.getFateGemData( self,cId )
    local team,value = 0,0 --value1装备的特殊属性，value2血量
    local gem_fate_cfg = getConfig(game_config_field.equip_gem_fate)
    if cId and cId ~= 0 then
        cId = game_util.bloodStone.gem.getCId(cId)
        local itemCfgData = gem_fate_cfg:getNodeWithKey(tostring(cId))
        team = itemCfgData:getNodeWithKey("team"):toInt()
        value = tonumber(itemCfgData:getNodeWithKey("value"):toStr())
        value = value --changedbyZJR
    -- cclog2(itemCfgData,"itemCfgData-=-=----------")

    end
    -- cclog2(cId,"cId-=-=----------")
    -- cclog2(value,"value-=-=----------")
    return team,value
end
function M.createPlayerRoleAnimNew(self,animFile,rhythm)
    local function onAnimSectionEnd(animNode, theId,theLabelName)
        animNode:playSection(theLabelName);
    end
    local mAnimNode = zcAnimNode:create(animFile .. "_1.swf.sam", 0, animFile.. "_1.plist");
    if mAnimNode == nil then
        animFile = "role_soldier";
        mAnimNode = zcAnimNode:create(animFile .. "_1.swf.sam", 0, animFile.. "_1.plist");
    end
    if mAnimNode then
        mAnimNode:setAnchorPoint(ccp(0.5,0.5));
        mAnimNode:registerScriptTapHandler(onAnimSectionEnd)
        mAnimNode:playSection("daiji");
        mAnimNode:setRhythm(rhythm);
        -- mAnimNode:setScale(0.5);
    end
    return mAnimNode
end
function M:createPlayerRoleGardenIconByRoleId(roleId)
    -- body
    local role_detail_cfg = getConfig(game_config_field.role_detail);
    -- cclog("roleId ========================" .. roleId);
    local itemCfg = role_detail_cfg:getNodeWithKey(tostring(roleId))
    local icon_name = itemCfg:getNodeWithKey("icon"):toStr()
    local icon = CCSprite:create("humen/" .. icon_name .. "_b_r.png")
    return icon
end

-- 创建称号资源
function M:createTitleRes(id)
    if not id or id == 0 then
        return
    end

    local title_list_cfg = getConfig(game_config_field.title_list)
    title_list_cfg = json.decode(title_list_cfg:getFormatBuffer()) or {}
    local _titleCfg = title_list_cfg[tostring(id)]
    local animation = _titleCfg.animation
    local icon
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
        icon = CCSprite:create("icon/".. _titleCfg.icon ..".png")
    end 

    return icon
end

-------- 血石赋能
M.bloodStone = {
    gem = {
        -- 根据id获取对应命运宝石
        checkIdHasEmpower = function(id)
            return string.find(tostring(id), "-")
        end,
        getCId = function(cid)
            cid = tostring(cid)
            local idx = game_util.bloodStone.gem.checkIdHasEmpower(cid)
            if idx then
                return string.sub(cid, 1, idx - 1)
            else
                return cid
            end
        end,
        getCfg = function(cId)
            cId = game_util.bloodStone.gem.getCId(cId)
            local equip_gem_fate = getConfig(game_config_field.equip_gem_fate) and json.decode(getConfig(game_config_field.equip_gem_fate):getFormatBuffer()) or {}
            return equip_gem_fate[cId]
        end,
    },
    --[[
        创建血石icon
        hideFrame 隐藏图标底框

    ]]
    createIcon = function(quality, skill_id, ext)
        ext = ext or {}
        local equip_gem_fate_skill = getConfig(game_config_field.equip_gem_fate_skill) and json.decode(getConfig(game_config_field.equip_gem_fate_skill):getFormatBuffer()) or {}
        local _power_icon = equip_gem_fate_skill[tostring(skill_id)].power_icon
        local power_icon = {}
        string.gsub(_power_icon, "[^,]+", function(w) table.insert(power_icon, w) end)
        local _id = #power_icon - (6 - quality)
        if _id < 1 then
            _id = 1
        end
        local iconName = power_icon[_id]
        local icon = CCSprite:create("icon/"..iconName..".png")
        if icon and not ext.hideFrame then
            local quality = quality + 1;
            local qualityTab = HERO_QUALITY_COLOR_TABLE[quality];
            if qualityTab then
                local tempIconSize = icon:getContentSize();
                local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
                img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
                icon:addChild(img1,-1,1)
                local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
                img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
                icon:addChild(img2,1,2)
            end
            local tempIconSize = icon:getContentSize();
            if quality > 10 and quality < 14 then
                self:createNewGemAnim(icon,quality,"kuang",tempIconSize )
            end
        end
        return icon
    end,
    getStoneData = function(id)
        local gem_special = game_data.m_formationBloodStoneData.gem_special
        return gem_special[id]
    end,
    -- 获取达到的套装效果
    getEquipStoneEffect = function(equipData, equipId, stoneDatas)
        if not equipData then
            equipData = game_data:getEquipDataById(tostring(equipId))
        end
        local gem_fateData
        if equipData and equipData.gem_fate then
            gem_fateData = equipData.gem_fate
        end
        return game_util.bloodStone.getEquipStoneEffect2(gem_fateData, stoneDatas)
    end,
    getEquipStoneEffect2 = function(gem_fateData, stoneDatas)
        stoneDatas = stoneDatas or {}
        -- 先取出所有结果
        local equip_gem_fate_skill = getConfig(game_config_field.equip_gem_fate_skill) and json.decode(getConfig(game_config_field.equip_gem_fate_skill):getFormatBuffer()) or {}
        local tempEffects = {}
        for i = 1, 4 do
            if gem_fateData and game_util.bloodStone.gem.checkIdHasEmpower(gem_fateData[i]) then
                local cfg = game_util.bloodStone.gem.getCfg(gem_fateData[i])
                local quality = cfg.quality
                local stoneData = stoneDatas[tostring(gem_fateData[i])] or game_util.bloodStone.getStoneData(gem_fateData[i])
                if stoneData then
                    local skillId = stoneData.skill.sid
                    local skillCfg = equip_gem_fate_skill[tostring(skillId)]
                    local skill_sort = skillCfg.skill_sort
                    if not tempEffects[skill_sort] then
                        tempEffects[skill_sort] = {
                            num = 0,
                            use_num = skillCfg.use_num,
                            sids = {},
                        }
                    end
                    tempEffects[skill_sort].num = tempEffects[skill_sort].num + 1
                    table.insert(tempEffects[skill_sort].sids, skillId)
                end
            end
        end
        -- 取出达到的结果
        local activeEffects = {}
        for k, v in pairs(tempEffects) do
            if v.num >= v.use_num then
                -- table.insert(activeEffects ,v)
                table.sort(v.sids, function(a, b)
                    return a < b
                end)
                local x = v.num - v.use_num
                if x > 0 then
                    for i = 1, x do
                        table.remove(v.sids, 1)
                    end
                end
                v.effectSid = v.sids[1]
                local effectSidCfg = equip_gem_fate_skill[tostring(v.sids[1])]
                v.name = effectSidCfg.name
                local _formatString = ""
                local effect = effectSidCfg.effect
                local effectValue = {}
                if type(effectSidCfg.effect) == "number" then
                    effect = {effectSidCfg.effect}
                end
                for i = 1, #effect do
                    table.insert( effectValue, effect[i][2] )
                end
                v.des = string.format(effectSidCfg.des, unpack(effectValue))
                table.insert(activeEffects, v)
            end
        end
        return activeEffects
    end,
    getSkillEffectIconName = function(sid)
        local equip_gem_fate_skill = getConfig(game_config_field.equip_gem_fate_skill) and json.decode(getConfig(game_config_field.equip_gem_fate_skill):getFormatBuffer()) or {}
        local skillCfg = equip_gem_fate_skill[tostring(sid)]
        local icon1 = "qitiao_meishuzi_" .. skillCfg.skill_quality .. ".png"
        local icon2 = "qitiao_meishuzi_" .. skillCfg.skill_sort .. "_" .. skillCfg.skill_quality .. ".png"
        return icon1, icon2
    end,
    getEffectValueData = function(equipPosData) 
        local equip_gem_fate_skill = getConfig(game_config_field.equip_gem_fate_skill) and json.decode(getConfig(game_config_field.equip_gem_fate_skill):getFormatBuffer()) or {}
        local fateEquipData = {0,0,0,0,0}
        for i = 1, 4 do
            local _euqipData = equipPosData[i]
            local effects = game_util.bloodStone.getEquipStoneEffect(nil, _euqipData)
            local effect = effects[1]
            if effect then
                local sid = effect.effectSid
                local skillCfg = equip_gem_fate_skill[tostring(sid)]
                cclog("1")
            end
        end
    end
}
-------- 血石赋能 点化
M.bloodStonePrint = {
    -- 创建点化石icon
    createIcon = function(id)
        local equip_gem_fate_word = getConfig(game_config_field.equip_gem_fate_word) and json.decode(getConfig(game_config_field.equip_gem_fate_word):getFormatBuffer()) or {}
        local cfg = equip_gem_fate_word[tostring(id)]
        local iconName = cfg.icon
        local icon = CCSprite:create("icon/"..iconName..".png")
        return icon
    end,
    getPrintName = function(id)
        local equip_gem_fate_word = getConfig(game_config_field.equip_gem_fate_word) and json.decode(getConfig(game_config_field.equip_gem_fate_word):getFormatBuffer()) or {}
        local cfg = equip_gem_fate_word[tostring(id)]
        return cfg.des
    end,
    getPrintNameLetter = function(id)
        local _name = game_util.bloodStonePrint.getPrintName(id)
        local _results = {}
        string.gsub(_name, "[^-]+", function(w) table.insert(_results, w) end)
        local _result = _results[2]
        _result = string.gsub(_result, "点化石", "")
        return _result
    end,
    -- 获取所有的点化石列表
    getNormalPrintStoneList = function()
        local fate_word = game_data.m_formationBloodStoneData.fate_word
        cclog2(fate_word, "fate_word")
        local _data = {}
        for k, v in pairs(fate_word) do
            table.insert(_data, {id= k, num= v})
        end
        return _data
    end
}
M.bloodStoneReborn = {
    createIcon = function(id)
        local equip_gem_fate_stone = getConfig(game_config_field.equip_gem_fate_stone) and json.decode(getConfig(game_config_field.equip_gem_fate_stone):getFormatBuffer()) or {}
        local cfg = equip_gem_fate_stone[tostring(id)]
        local iconName = cfg.icon
        local icon = CCSprite:create("icon/"..iconName..".png")
        return icon
    end,
    getRebornName = function(id)
        local equip_gem_fate_stone = getConfig(game_config_field.equip_gem_fate_stone) and json.decode(getConfig(game_config_field.equip_gem_fate_stone):getFormatBuffer()) or {}
        local cfg = equip_gem_fate_stone[tostring(id)]
        return cfg.name_stone
    end
}

function M.adaptNodeScaleX(node, maxWidth)
    if not node then return node end
    if not maxWidth then return node end

    local width = node:getContentSize().width
    local scale = 1
    if width > maxWidth then
        scale = maxWidth / width
    end
    node:setScale(scale)
end

function M.adaptNodeChildrensScaleX(node, maxWidth, interval, startPosX, archorPointX)
    archorPointX = archorPointX or 0 -- 暂不继续实现,保留备用
    startPosX = startPosX or 0 -- 起始位置
    interval = interval or 0 -- 间隔
    if not node then return node end
    if not maxWidth then return node end

    node:setAnchorPoint(ccp(0, 0.5))
    local childrens = node:getChildren()
    local len = childrens:count()
    local lastX = 0

    for i = 1, len do
        local v = tolua.cast(childrens:objectAtIndex(i - 1),"CCNode");
        local width = v:getContentSize().width
        v:setAnchorPoint(ccp(0.5, 0.5))
        if width > 0 then
            v:setPositionX(lastX + width / 2)
            if i ~= len then
                lastX = lastX + width + interval
            else
                lastX = lastX + width
            end
        end
    end

    local scale = 1
    if lastX > maxWidth then
        scale = maxWidth / lastX
    end
    node:setScale(scale)
    return node
end

function M:centerTwoNode(nd1, nd2, centorPosX, interval)
    centorPosX = centorPosX or 0
    interval = interval or 0
    local width1 = nd1:getContentSize().width * nd1:getScale()
    local width2 = nd2:getContentSize().width * nd2:getScale()
    local allWidth = width1 + width2
    local startPos = centorPosX - allWidth / 2
    nd1:setAnchorPoint(ccp(0.5, 0.5))
    nd2:setAnchorPoint(ccp(0.5, 0.5))
    nd1:setPositionX(startPos + width1 / 2)
    nd2:setPositionX(startPos + width1 + interval + width2 / 2)
end

function M:centerTwoLabel(label1, label2, centorPosX, interval)
    centorPosX = centorPosX or 0
    interval = interval or 0
    local width1 = label1:getContentSize().width * label1:getScale()
    local width2 = label2:getContentSize().width * label2:getScale()
    local allWidth = width1 + width2
    local startPos = centorPosX - allWidth / 2

    label1:setAnchorPoint(ccp(0.5, 0.5))
    label2:setAnchorPoint(ccp(0.5, 0.5))

    label1:setPositionX(startPos + width1 / 2)
    label2:setPositionX(startPos + width1 + interval + width2 / 2)
end
    
-- 判断两个节点是否相交的通用函数，考虑锚点
function M:isIntersecting(node1, node2)
    -- 获取 node1 和 node2 的父节点
    local parent1 = node1:getParent()
    local parent2 = node2:getParent()

    -- 获取节点的内容大小和锚点
    local size1 = node1:getContentSize()
    local anchor1 = node1:getAnchorPoint()
    local size2 = node2:getContentSize()
    local anchor2 = node2:getAnchorPoint()

    -- 计算节点的世界坐标原点（左下角）
    local worldPos1 = parent1:convertToWorldSpace(ccp(
        node1:getPositionX() - size1.width * anchor1.x,
        node1:getPositionY() - size1.height * anchor1.y
    ))

    local worldPos2 = parent2:convertToWorldSpace(ccp(
        node2:getPositionX() - size2.width * anchor2.x,
        node2:getPositionY() - size2.height * anchor2.y
    ))

    -- 创建世界坐标系中的包围盒
    local boundingBox1 = CCRectMake(worldPos1.x, worldPos1.y, size1.width, size1.height)
    local boundingBox2 = CCRectMake(worldPos2.x, worldPos2.y, size2.width, size2.height)

    -- 判断两个包围盒是否相交
    return boundingBox1:intersectsRect(boundingBox2)
end

function M.c3b_parse(s)
    local r, g, b = 0, 0, 0
    if #s == 4 then
        r, g, b = tonumber(string.rep(string.sub(s, 2, 2), 2), 16), tonumber(string.rep(string.sub(s, 3, 3), 2), 16), tonumber(string.rep(string.sub(s, 4, 4), 2), 16)
    elseif #s == 7 then
        r, g, b = tonumber(string.sub(s, 2, 3), 16), tonumber(string.sub(s, 4, 5), 16), tonumber(string.sub(s, 6, 7), 16)
    end
    return ccc3(r, g, b)
end

function M.c4b_parse(s)
    local r, g, b = 0, 0, 0
    if #s == 4 then
        r, g, b = tonumber(string.rep(string.sub(s, 2, 2), 2), 16), tonumber(string.rep(string.sub(s, 3, 3), 2), 16), tonumber(string.rep(string.sub(s, 4, 4), 2), 16)
    elseif #s == 7 then
        r, g, b = tonumber(string.sub(s, 2, 3), 16), tonumber(string.sub(s, 4, 5), 16), tonumber(string.sub(s, 6, 7), 16)
    end
    return ccc4(r, g, b, 255)
end

-- type1 根据指定时区将时间戳转换为 YYYY-MM-DD 格式
function M.timestampToDate(timestamp, type)
    type = type or 1
    local timezone = game_data.timezone or 8
    if type == 1 then
        return os.date("!%Y-%m-%d", timestamp + timezone * 3600)
    end
end

--[[
    获取徽章道具信息
]]
function M:createBadgeIconByTable(table)
    local id = table[2]
    local count = table[3]
    local badge = getConfig(game_config_field.badge)
    local tempData = badge:getNodeWithKey(id)
    -- local image = tempData:getNodeWithKey("image"):toStr()
    local quality = 4
    local name = tempData:getNodeWithKey("badge_name"):toStr()
    local icon = self:createBadgeIconByCfg(tempData)
    return icon,name,count,quality
end

--[[
    通过Cfg创建徽章图标
]]
function M.createBadgeIconByCfg(self,itemCfg)
    ext = ext or {}
    local tempIcon = nil;
    if itemCfg then
        local icon = itemCfg:getNodeWithKey("image_S"):toStr();
        tempIcon = self:createIconByName(icon)
        if tempIcon == nil then
            cclog(icon .. " image is not found");
        end
    else
        cclog("gem config is not found");
    end
    if tempIcon then
        local quality = 7
        local qualityTab = HERO_QUALITY_COLOR_TABLE[quality];
        if qualityTab then
            local tempIconSize = tempIcon:getContentSize();
            local img1 = CCSprite:createWithSpriteFrameName(qualityTab.img1)
            img1:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img1,-1,1)
            local img2 = CCSprite:createWithSpriteFrameName(qualityTab.img2)
            img2:setPosition(ccp(tempIconSize.width*0.5,tempIconSize.height*0.5));
            tempIcon:addChild(img2,1,2)
        end
    end
    return tempIcon;
end

function M.getBadgeByIdCfg( self,id )
    local badge = getConfig(game_config_field.badge)
    local tempCfg = badge:getNodeWithKey(tostring(id))
    return tempCfg
end

--[[
    通过勋章id创建勋章图标
]]
function M.createBadgeIconById(self,id)
    local itemData, itemCfg = game_data:getBadgeDataById(id)
    local name = itemCfg:getNodeWithKey("badge_name"):toStr();
    return self:createBadgeIconByCfg(itemCfg),name
end


--[[
    勋章排序
]]
function M.getSortBadgeByTtypeName(self,typeName)
    local m_badgeIdTable = game_data:getAllBadgeIdData()
    local typeName = typeName or "default"
    local badgeTemp = util.table_copy(m_badgeIdTable)
    if typeName == "default" then 
        local function sortFunc(data1,data2)
            local badgeData1,badgeCfg1 = game_data:getBadgeDataById(data1)
            local badgeData2,badgeCfg2 = game_data:getBadgeDataById(data2)
            badgeCfg1 = json.decode(badgeCfg1:getFormatBuffer())
            badgeCfg2 = json.decode(badgeCfg2:getFormatBuffer())
            local owner1 = 0
            local owner2 = 0
            local badge_level1 = badgeCfg1.badge_level  
            local badge_level2 = badgeCfg2.badge_level
            local badge_sort1 = badgeCfg1.badge_sort[1]
            local badge_sort2 = badgeCfg2.badge_sort[1]
            if badgeData1.owner ~= "" then 
                owner1 = 1
            end
            if badgeData2.owner ~= "" then 
                owner2 = 1
            end
            if owner1 == owner2 then
                if badge_level1 == badge_level2 then
                    return badge_sort1 > badge_sort2
                else
                    return badge_level1 > badge_level2
                end
            else
                return owner1 > owner2
            end
        end
        table.sort(badgeTemp,sortFunc)
    elseif typeName == "level" then 
        local function sortFunc(data1,data2)
            local badgeData1,badgeCfg1 = game_data:getBadgeDataById(data1)
            local badgeData2,badgeCfg2 = game_data:getBadgeDataById(data2)
            badgeCfg1 = json.decode(badgeCfg1:getFormatBuffer())
            badgeCfg2 = json.decode(badgeCfg2:getFormatBuffer())
            local badge_level1 = badgeCfg1.badge_level  
            local badge_level2 = badgeCfg2.badge_level
            local badge_sort1 = badgeCfg1.badge_sort[1]
            local badge_sort2 = badgeCfg2.badge_sort[1]
    
            if badge_level1 == badge_level2 then
                return badge_sort1 > badge_sort2
            else
                return badge_level1 > badge_level2
            end
        end
        table.sort(badgeTemp,sortFunc)
    elseif typeName == "sort" then 
        local function sortFunc(data1,data2)
            local badgeData1,badgeCfg1 = game_data:getBadgeDataById(data1)
            local badgeData2,badgeCfg2 = game_data:getBadgeDataById(data2)
            badgeCfg1 = json.decode(badgeCfg1:getFormatBuffer())
            badgeCfg2 = json.decode(badgeCfg2:getFormatBuffer())
            local badge_level1 = badgeCfg1.badge_level  
            local badge_level2 = badgeCfg2.badge_level
            local badge_sort1 = badgeCfg1.badge_sort[1]  
            local badge_sort2 = badgeCfg2.badge_sort[1]
            
            if badge_sort1 == badge_sort2 then 
                return badge_level1 > badge_level2
            else
                return badge_sort1 > badge_sort2
            end
            if badge_level1 == badge_level2 then
                return
            else
                
            end
        end
        table.sort(badgeTemp,sortFunc)
    end
    return badgeTemp

end

return M;
       � 