---  功能彈出框 

local game_function_pop = {
    m_popUi = nil,
    m_callFunc = nil,
    m_typeName = nil,
    m_posNode = nil,
    m_root_layer = nil,
    m_animEndStatus = nil,
    m_temp_spri = nil,
    m_btn_bg = nil,
    m_arrow_spri = nil,
    m_showBtnTab = nil,
};
--[[--
    銷毀
]]
function game_function_pop.destroy(self)
    -- body
    cclog("-----------------game_function_pop destroy-----------------");
    self.m_popUi = nil;
    self.m_callFunc = nil;
    self.m_typeName = nil;
    self.m_posNode = nil;
    self.m_root_layer = nil;
    self.m_animEndStatus = nil;
    self.m_temp_spri = nil;
    self.m_btn_bg = nil;
    self.m_arrow_spri = nil;
    self.m_showBtnTab = nil;
end

--[[
    -- {name="技能進階",btnId = 504,img = "mbutton_c_skillevo.png",x = 0.65+0.075,y = 0.65},
    -- {name="能晶摘除",btnId = 510,img = "mbutton_c_cycout.png",x = 0.80,y = 0.35},
    -- {name="任務",btnId = 303,img = "mbutton_f_quest.png",x = 0.5,y = 0.65},
]]
local functionTab = {
        partner = {title = "Đồng đội",item = {
                    {name="元素突破",btnId = 500,img = "m_button_element.png",x = 0.3,y = 0.25, InReviewId = 224,openFlag = true},
                    {name="Huấn luyện đồng đội",btnId = 225,img = "mbutton_rune.png",x = 0.3,y = 0.25, InReviewId = 225,openFlag = true},
                    {name="超进化",btnId = 123,img = "mbutton_m_chaojinhua.png",x = 0.5,y = 0.25,InReviewId = 147},--, InReviewId = 147},
                    {name="Huấn luyện đồng đội",btnId = 501,img = "mbutton_2_1.png",x = 0.3,y = 0.25, InReviewId = 17},
                    {name="Nâng cấp kĩ năng",btnId = 503,img = "mbutton_2_2.png",x = 0.4,y = 0.25, InReviewId = 18},
                    {name="Tiến hóa đồng đội",btnId = 502,img = "mbutton_2_3.png",x = 0.5,y = 0.25, InReviewId = 19},
                    {name="Cải tạo thuộc tính",btnId = 509,img = "mbutton_2_4.png",x = 0.6,y = 0.25, InReviewId = 20},
                    {name="Đồng đội chuyển thế",btnId = 510,img = "m_hero_zhuanshi.png",x = 0.8,y = 0.25, InReviewId = 172,openFlag = true},
                    {name="Đổi đồng đội",btnId = 100002,img = "mbutton_b_huoban.png",x = 0.2,y = 0.25, InReviewId = 21, openFlag = true},
                    {name="Chuyển sinh đồng đội",btnId = 112,img = "mbutton_c_tubo.png",x = 0.2,y = 0.25, InReviewId = 44, openFlag = false},
                    {name="Xem đồng đội",btnId = 505,img = "mbutton_2_5.png",x = 0.7,y = 0.25, openFlag = true},
                    },tempSprName = "mbutton_m_2.png"},
        backpack = {title = "Túi",item = {             
                    {name="装备附魔",btnId = 120,img = "mbutton_c_enchant.png",x = 0.3,y = 0.25, openFlag = false, InReviewId = 131},             
                    {name="Cường hóa trang bị",btnId = 602,img = "mbutton_3_1.png",x = 0.3,y = 0.25, InReviewId = 22},
                    {name="Tiến hóa trang bị",btnId = 603,img = "mbutton_3_2.png",x = 0.4,y = 0.25, InReviewId = 23},
                    {name="Tinh luyện trang bị",btnId = 608,img = "mbutton_2_st.png",x = 0.5,y = 0.25, InReviewId = 24, openFlag = false},
                    {name="Xem trang bị",btnId = 601,img = "mbutton_3_4.png",x = 0.8,y = 0.25},
                    {name="血石赋能",btnId = 610,img = "baoshifuneng_rukou.png",x = 0.5,y = 0.25,InReviewId = 226, openFlag = true},
                    {name="装备洗练",btnId = 609,img = "mbutton_m_succinct.png",x = 0.5,y = 0.25, InReviewId = 148, openFlag = true},
                    -- {name="查看道具",btnId = 604,img = "mbutton_3_5.png",x = 0.7,y = 0.25,openFlag = true},
                    {name="装备绑定",btnId = 136,img = "mbutton_m_fateEquip.png",x = 0.6,y = 0.25, openFlag = true,InReviewId = 182},
                    {name="装备锻造",btnId = 135,img = "mbutton_m_forge.png",x = 0.6,y = 0.25, openFlag = true,InReviewId = 167},
                    {name="装备打造",btnId = 955401,img = "m_button_eqbuilding.png",x = 0.8,y = 0.25, openFlag = true,InReviewId = 208},
                    -- {name="法宝修炼",btnId = 9504,img = "mbutton_magic_02.png",x = 0.8,y = 0.25, openFlag = true,InReviewId = 201},
                    -- {name="法宝",btnId = 9505,img = "mbutton_magic_01.png",x = 0.8,y = 0.25, openFlag = true,InReviewId = 201},
                    {name="法宝修炼",btnId = 9504,img = "mbutton_magic_02.png",x = 0.8,y = 0.25, openFlag = true,InReviewId = 201},
                    {name="法宝",btnId = 9505,img = "mbutton_magic_01.png",x = 0.8,y = 0.25, openFlag = true,InReviewId = 201},
                    {name="Tiến giai Huy Hiệu",btnId = 9510,img = "mbutton_6_6.png",x = 0.8,y = 0.25, openFlag = true,InReviewId = 229},
                    },tempSprName = "mbutton_m_3.png"},
        social = {title = "Xã giao",item = {
                    -- {name="Mã kích hoạt",btnId = 305,img = "mbutton_b_duihuan.png",x = 0.3,y = 0.25, InReviewId = 37,openFlag = true},
                    -- {name="Mã mời",btnId = 100009,img = "mbutton_6_3.png",x = 0.4,y = 0.25, InReviewId = 41,openFlag = true},
                    {name="Bạn bè",btnId = 301,img = "mbutton_4_1.png",x = 0.5,y = 0.25, InReviewId = 27,openFlag = true},
                    {name="Liên minh",btnId = 700,img = "mbutton_4_2.png",x = 0.6,y = 0.25, InReviewId = 13,openFlag = true},
                    {name="Thông tin",btnId = 302,img = "mbutton_4_3.png",x = 0.7,y = 0.25, InReviewId = 28,openFlag = true},
                    {name="家园",btnId = 701,img = "mbutton_4_4.png",x = 0.6,y = 0.25, InReviewId = 206,openFlag = true},
                    },tempSprName = "mbutton_m_4.png"},
        shop = {title = "Cửa hàng",item = {
                    {name="Nạp tiền",btnId = 403,img = "mbutton_6_2.png",x = 0.3,y = 0.25, InReviewId = 29,openFlag = true},
                    -- {name="招募",btnId = 401,img = "mbutton_5_1.png",x = 0.3,y = 0.25,openFlag = true},
                    {name="Cửa hàng Xu",btnId = 402,img = "mbutton_5_2.png",x = 0.4,y = 0.25, InReviewId = 30,openFlag = true},
                    {name="Cửa hàng siêu năng",btnId = 307,img = "mbutton_5_3.png",x = 0.5,y = 0.25, InReviewId = 31},
                    {name="Phân giải đồng đội",btnId = 507,img = "mbutton_5_4.png",x = 0.6,y = 0.25, InReviewId = 32},
                    {name="Kế thừa đồng đội",btnId = 506,img = "mbutton_5_5.png",x = 0.7,y = 0.25, InReviewId = 33},
                    {name="伙伴合成",btnId = 122,img = "m_button_melting.png",x = 0.7,y = 0.25, InReviewId = 133, openFlag = false},
                    {name="Tái sinh đồng đội",btnId = 117,img = "mbutton_c_chongsheng.png",x = 0.7,y = 0.25, InReviewId = 128, openFlag = false},
                    {name="Cửa hàng khuyến mãi",btnId = 100007,img = "mbutton_4_xiangou.png",x = 0.8,y = 0.25, InReviewId = 34,openFlag = true},
                    {name="碎片分解",btnId = 2001,img = "mbutton_fenjie.png",x = 0.6,y = 0.25, InReviewId = 230, openFlag = true},
                    },tempSprName = "mbutton_m_5.png"},
        func = {title = "Chức năng",item = {
                    -- {name="英雄技能",btnId = 605,img = "mbutton_6_1.png",x = 0.3+0.05,y = 0.25},
                    -- {name="充值",btnId = 403,img = "mbutton_6_2.png",x = 0.4+0.05,y = 0.25,openFlag = true},
                    -- {name="萬能兌換",btnId = 100011,img = "mbutton_s_duihuanzhongxin.png",x = 0.2,y = 0.25, InReviewId = 122,openFlag = true},
                    {name="Thư viện đồng đội",btnId = 100001,img = "mbutton_b_tujian.png",x = 0.3,y = 0.25, InReviewId = 35,openFlag = true},
                    {name="Thư viện trang bị",btnId = 100010,img = "mbutton_b_zhuangbeitujian.png",x = 0.4,y = 0.25, InReviewId = 35,openFlag = true},
                    {name="Anh Hồn",btnId = 134,img = "mbutton_soul.png",x = 0.2,y = 0.25,InReviewId = 166,openFlag = false},--soul
                    {name="Đổi trang bị",btnId = 508,img = "mbutton_b_equip.png",x = 0.7,y = 0.25, InReviewId = 26, openFlag = true},
                    -- {name="激活碼",btnId = 305,img = "mbutton_b_duihuan.png",x = 0.5+0.05,y = 0.25,openFlag = true},
                    -- {name="邀請碼",btnId = 100009,img = "mbutton_6_3.png",x = 0.6+0.05,y = 0.25,openFlag = true},
                    -- {name="Giúp đỡ",btnId = 304,img = "mbutton_6_4.png",x = 0.5,y = 0.25, InReviewId = 36,openFlag = true},
                    {name="名人堂",btnId = 9554,img = "fame_my_btn.png",x = 0.5,y = 0.25, InReviewId = 205,openFlag = true},
                    {name="Thiên Phú Bạn Bè",btnId = 100006,img = "mbutton_m_talent.png",x = 0.2,y = 0.25, InReviewId = 195, openFlag = true},
                    {name="NV anh hùng",btnId = 100004,img = "mbutton_m_dispatch.png",x = 0.2,y = 0.25, InReviewId = 194, openFlag = true},
                    {name="勋章图鉴",btnId = 131,img = "mbutton_m_medal_charts.png",x = 0.2,y = 0.25,InReviewId = 161,openFlag = false},
                    {name="Tách trang bị",btnId = 607,img = "mbutton_2_split.png",x = 0.6,y = 0.25, InReviewId = 25, openFlag = false},
                    {name="Thiết lập",btnId = 306,img = "mbutton_6_5.png",x = 0.6,y = 0.25, InReviewId = 38,openFlag = true},
                    },tempSprName = "mbutton_m_6.png"},
        heroInfo = {title = "Thông tin anh hùng",item = {
                    {name="Thông tin anh hùng",btnId = 100003,img = "mbutton_yxxi.png",x = 0.4+0.05,y = 0.25,openFlag = true},
                    {name="Kĩ năng nhân vật chính",btnId = 605,img = "mbutton_6_1.png",x = 0.3+0.05,y = 0.25, InReviewId = 15},
                    {name="超级仓库",btnId = 611,img = "storeHouse_1.png",x = 0.5+0.05,y = 0.25, InReviewId = 228,openFlag = true},
                    {name="Chức năng Thống Soái",btnId = 606,img = "mbutton_tsnl.png",x = 0.3+0.05,y = 0.25, InReviewId = 16,openFlag = false},
                    -- {name="查看道具",btnId = 604,img = "mbutton_3_5.png",x = 0.7+0.05,y = 0.25,openFlag = true},
                    -- {name="排行榜",btnId = 100008,img = "mbutton_b_paihangbang.png",x = 0.7+0.05,y = 0.25,openFlag = true},
                    -- {name="宝石进阶",btnId = 118,img = "mbutton_baoshihecheng.png",x = 0.3+0.05,y = 0.25, InReviewId = 130,openFlag = false},
                    -- {name="宝石列表",btnId = 119,img = "mbutton_chakanbaoshi.png",x = 0.3+0.05,y = 0.25, InReviewId = 130,openFlag = false},
                    {name="Ghép đá quý",btnId = 118,img = "mbutton_baoshihecheng.png",x = 0.3+0.05,y = 0.25, InReviewId = 203,openFlag = true},
                    {name="宝石进阶",btnId = 137,img = "mbutton_gem_advanced.png",x = 0.3+0.05,y = 0.25, InReviewId = 203,openFlag = true},
                    {name="Xem thú  nuôi",btnId = 126,img = "m_button_chongwuxinxianniu.png",x = 0.3,y = 0.25,InReviewId = 152, openFlag = false},
                    {name="Trận hình thú  nuôi",btnId = 127,img = "mbutton_m_shoulan.png",x = 0.3,y = 0.25,InReviewId = 153, openFlag = false},
                    {name="Tăng thuộc tính",btnId = 128,img = "mbutton_m_rolePorpertryUp.png",x = 0.3,y = 0.25,InReviewId = 177, openFlag = false},
                    {name="Thần thú",btnId = 129,img = "mbutton_m_shenshou.png",x = 0.3,y = 0.25,InReviewId = 178, openFlag = false},
                    },tempSprName = "mbutton_yx.png"},
        accelerate = {title = "加速器",item = {  
                    {name="帮助",btnId = 801,img = "mbutton_6_4.png",x = 0.5,y = 0.25, InReviewId = 801,openFlag = true},
                    {name="开启",btnId = 802,img = "mbutton_7_2.png",x = 0.7,y = 0.25, InReviewId = 802,openFlag = true},
                    {name="关闭",btnId = 803,img = "mbutton_7_3.png",x = 0.6,y = 0.25, InReviewId = 803,openFlag = true},
                    },tempSprName = "mbutton_7_1.png"}
    }



function setFunctionState( viewID, lei, pos )
     -- print("ckeck  setFunctionState   ", lei)
    if game_data:isViewOpenByID(viewID) then 
        return
    end
    -- print("run  setFunctionState   ", lei)
    local count = #functionTab[lei].item
    -- print("pos count", pos, count)
    if pos < count then
        for i=pos,count - 1 do
            local temp = nil
            temp = functionTab[lei].item[i]
            functionTab[lei].item[i] =  functionTab[lei].item[i + 1]
            functionTab[lei].item[i + 1] = temp
            functionTab[lei].item[i + 1].x = functionTab[lei].item[i].x
            functionTab[lei].item[i].x = temp.x
        end
    end
    -- print_lua_table(functionTab[lei].item, 5)
    functionTab[lei].item[count] = nil
end

function initFunTab( functionBtnTab )
    print("************************ start reset inreview *************************")
    for k,v in pairs(functionBtnTab) do
        -- print("============================================================")
        if type(v) == "table" and v.item and type(v.item) == "table" then
            local number = #v.item
            for i=1,number do
                local item = v.item[number - i + 1]
                if item.InReviewId and type(item.InReviewId) == "number" then
                    -- print(" check item is inreview == ", "part key ", k, " item name ", item.name, " InReviewId ", item.InReviewId, " item pos", number - i + 1)
                    -- setFunctionState(functionBtnTab, item.InReviewId, k, number - i + 1)
                    local pos = number - i + 1
                    local lei = k
                    if not game_data:isViewOpenByID(item.InReviewId) then
                        -- cclog2(item.InReviewId, "item.InReviewId   =======    ")
                        local count = #functionBtnTab[lei].item
                        -- print("pos count", pos, count)
                        if pos < count then
                            for i=pos,count - 1 do
                                local temp = nil
                                temp = functionBtnTab[lei].item[i]
                                functionBtnTab[lei].item[i] =  functionBtnTab[lei].item[i + 1]
                                functionBtnTab[lei].item[i + 1] = temp
                                functionBtnTab[lei].item[i + 1].x = functionBtnTab[lei].item[i].x
                                functionBtnTab[lei].item[i].x = temp.x
                            end
                        end
                        -- print_lua_table(functionBtnTab[lei].item, 5)
                        functionBtnTab[lei].item[count] = nil
                    end
                end
            end
        end
        -- print("============================================================")
    end
    return functionBtnTab
end





-- end

--[[--
    返回
]]
function game_function_pop.back(self,type)
 --    if self.m_popUi then
 --        self.m_popUi:removeFromParentAndCleanup(true);
 --        self.m_popUi = nil;
 --    end
    -- self:destroy();
    game_scene:removePopByName("game_function_pop");
end

--[[--
    按鈕點擊
]]
function game_function_pop.btnOnClickFunc(self,btnTag)
    cclog("btnOnClickFunc ================ btnTag = " .. btnTag)
    if btnTag == 505 then--查看夥伴
        game_scene:enterGameUi("game_hero_list",{gameData = nil});
        self:destroy();
    elseif btnTag == 126 then   -- 查看寵物
        game_scene:enterGameUi("game_pet_list_scene",{gameData = nil});
    elseif btnTag == 127 then   -- 寵物陣型
        -- game_scene:enterGameUi("game_pet_adjustment_scene",{gameData = nil});
        game_scene:enterGameUi("game_pet_adjustment_scene_new",{gameData = nil});
    elseif btnTag == 128 then   -- 主角属性加成
        game_scene:enterGameUi("ui_role_propertryUp",{gameData = nil});
    elseif btnTag == 129 then   -- 召唤神兽
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_combiner_main",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("combiner_index"), http_request_method.GET, nil,"combiner_index")     
    elseif btnTag == 501 then--夥伴訓練9*
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_school_new",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("school_open"), http_request_method.GET, nil,"school_open")
    elseif btnTag == 503 then--技能升級
        game_scene:enterGameUi("skills_strengthen_scene",{gameData = nil});
        self:destroy();
    -- elseif btnTag == 504 then--技能進階
        -- game_scene:enterGameUi("skills_inheritance_scene",{gameData = nil});
        -- self:destroy();
    elseif btnTag == 225 then--命运符文*
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_fate_rune",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_fate_rune_index"), http_request_method.GET, nil,"cards_fate_rune_index")
    elseif btnTag == 502 then--夥伴進階
        game_scene:enterGameUi("game_hero_advanced_sure",{gameData = nil});
        self:destroy();
    elseif btnTag == 506 then--夥伴傳承
        game_scene:enterGameUi("game_hero_inherit");
        self:destroy();
    elseif btnTag == 507 then--夥伴分解
        game_scene:enterGameUi("game_card_split");
        self:destroy();
    elseif btnTag == 2001 then  --碎片分解
        game_scene:enterGameUi("game_card_split_new");
        self:destroy();
    elseif btnTag == 509 then--屬性改造
        game_scene:enterGameUi("game_hero_culture_scene",{gameData = gameData});
        self:destroy();
    -- elseif btnTag == 510 then--能晶摘除
    --     game_scene:enterGameUi("removal_crystal_scene",{gameData = nil});
    --     self:destroy();
    elseif btnTag == 402 then--購買
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_buy_item_scene",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("shop_open"), http_request_method.GET, {},"shop_open")
    elseif btnTag == 307 then--超能商店
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_card_split_shop",{gameData = gameData,openType = "game_function_pop"})
            self:destroy()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_open_dirt_shop"), http_request_method.GET, nil,"cards_open_dirt_shop")
    elseif btnTag == 700 then--聯盟
        -- game_util:addMoveTips({text = "暫未開放！"});
        
        game_scene:setVisibleBroadcastNode(false);
        local association_id = game_data:getUserStatusDataByKey("association_id");
        if association_id == 0 then
            require("like_oo.oo_controlBase"):openView("guild_join");
        else
            require("like_oo.oo_controlBase"):openView("guild");
        end
    elseif btnTag == 301 then--好友
        self:back();
        -- game_scene:addPop("game_friend_pop",{})
        game_scene:enterGameUi("game_friend_scene");
    elseif btnTag == 500 then--元素突破*
        game_scene:enterGameUi("game_element_tupo",{gameData = nil});
    elseif btnTag == 701 then -- 家园
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_homeLand_main",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("homeland_index"), http_request_method.GET, nil,"homeland_index") 
    elseif btnTag == 302 then--消息
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_notify_message_scene",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("notify_messages"), http_request_method.GET, {},"notify_messages")
    elseif btnTag == 306 then--設置
        self:back();
        game_scene:addPop("game_setting_pop",nil)
    elseif btnTag == 305 then--激活碼
        self:back();
        -- game_scene:enterGameUi("game_activation",{gameData = nil});
        game_scene:addPop("game_activation_pop");
    elseif btnTag == 304 then--幫助
        if not game_button_open:getOpenFlagByBtnId(111) then return end
        self:back();
        game_scene:addPop("ui_secretary_pop")
        -- game_scene:addPop("game_announcement_pop",{typeName = "help"});
    elseif btnTag == 510 then   --转世
        -- game_scene:enterGameUi("game_pet_adjustment_scene",{gameData = nil});
        -- game_scene:enterGameUi("game_hero_zhuanshi",{gameData = nil});
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_hero_zhuanshi",{gameData = nil,dispatch_data = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("offline_dispatch_index"), http_request_method.GET, nil,"offline_dispatch_index")

    elseif btnTag == 601 then--查看裝備
        game_scene:enterGameUi("equipment_list",{gameData = nil,openType = "game_function_pop"});
        self:destroy();
    elseif btnTag == 604 then--查看道具
        game_scene:enterGameUi("items_scene",{gameData = nil});
        self:destroy();
    elseif btnTag == 602 then--裝備強化
        game_scene:enterGameUi("equipment_strengthen",{gameData = nil});
        self:destroy();
    elseif btnTag == 603 then--裝備進階
        game_scene:enterGameUi("equip_evolution",{gameData = nil});
        self:destroy();
    elseif btnTag == 120 then -- 装备附魔
        cclog("btnTag == 120")
        game_scene:enterGameUi("equip_enchanting",{gameData = nil})
        self:destroy();
    elseif btnTag == 955401 then -- 装备打造
        game_scene:enterGameUi("game_equip_build_main",{gameData = gameData});    
    elseif btnTag == 605 then--戰爭科技
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("skills_practice_scene",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("leader_skill_open"), http_request_method.GET, nil,"leader_skill_open")
    elseif  btnTag == 611 then -- 超级仓库
        game_scene:enterGameUi("storeHouse",{gameData = nil});
        -- game_scene:enterGameUi("game_super_warehouse",{gameData = nil})
        -- self:destroy()
    elseif btnTag == 135 then--查看锻造
       
        game_scene:enterGameUi("game_equip_forge",{gameData = nil})
        self:destroy()
    elseif btnTag == 136 then--查看装备绑定
        game_scene:addPop("game_equip_fateUpRefresh_pop",{gameData = nil,callBack = callBack,openType = "mainScene"})
    elseif btnTag == 508 then--裝備兌換
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_exchange_scene",{gameData = gameData,openType = 2})
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("item_view"), http_request_method.GET, {},"item_view");
    elseif btnTag == 401 then--招募
        -- local function responseMethod(tag,gameData)
        --     game_scene:enterGameUi("game_gacha_scene",{gameData = gameData});
        --     self:destroy();
        -- end
        -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("gacha_get_all_gacha"), http_request_method.GET, nil,"gacha_get_all_gacha")
    elseif btnTag == 403 then
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("ui_vip",{gameData = gameData});
            --game_scene:addPop("ui_vip_show_pop");
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("vip_buy_step"), http_request_method.GET, nil,"vip_buy_step")
    elseif btnTag == 100006 then --伙伴天赋
        game_scene:enterGameUi("ui_talent_main")
        self:destroy();
    elseif btnTag == 100004 then --离线派遣
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_dispatch_main",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("offline_dispatch_index"), http_request_method.GET, nil,"offline_dispatch_index")
    elseif btnTag == 100001 then -- 夥伴圖鑒
        print(" to show 夥伴 -------------")
        local function responseMethod(tag,gameData)     
            -- game_scene:enterGameUi("game_lllustrations_scene",{gameData = gameData, showType = "character"});
            game_scene:enterGameUi("game_superillustration_scene",{gameData = gameData, showType = "character"});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("show_character_options"), http_request_method.GET, nil,"show_character_options")
        -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("show_equip_options"), http_request_method.GET, nil,"show_equip_options")
    elseif btnTag == 100010 then -- 裝備圖鑒
        -- print(" to show 裝備圖鑒 -------------")
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_superillustration_scene",{gameData = gameData, showType = "equip"});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("show_equip_options"), http_request_method.GET, nil,"show_equip_options")
        -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("equip_books"), http_request_method.GET, nil,"equip_books")
    elseif btnTag == 100002 then--夥伴碎片
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_exchange_scene",{gameData = gameData,openType = 1})
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("item_view"), http_request_method.GET, {},"item_view");
    elseif btnTag == 100003 then --英雄信息
        self:back();
        game_scene:addPop("player_profile_pop")
    elseif btnTag == 606 then --統帥能力
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_ability_commander",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("commander_index"), http_request_method.GET, nil,"commander_index")
    elseif btnTag == 607 then--裝備拆分
        game_scene:enterGameUi("ui_equip_split");
        self:destroy();
    elseif btnTag == 608 then--裝備精煉
        game_scene:enterGameUi("game_equip_refining",{})
        self:destroy()
    elseif btnTag == 609 then--装备洗练
        game_scene:enterGameUi("game_equip_succinct",{})
        self:destroy()
    elseif btnTag == 610 then -- 血石赋能
        game_scene:enterGameUi("game_bloodStone_index",{})
        self:destroy()
    elseif btnTag == 100007 then --限購商城
        local function responseMethod(tag,gameData)
            self:back();
            -- game_scene:addPop("game_limit_shop_pop",{gameData = gameData});
            game_scene:enterGameUi("game_limit_shop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("shop_outlets_open"), http_request_method.GET, {},"shop_outlets_open");
    elseif btnTag == 100008 then --排行榜
        -- local ui_all_rank = require("game_ui.ui_all_rank")
        -- ui_all_rank.enterAllRankByRankName( "rank_combat" )
        -- local function responseMethod(tag,gameData)
        --     local data = gameData:getNodeWithKey("data")
        --     game_scene:enterGameUi("ui_levelap_rank",{gameData = json.decode(data:getFormatBuffer())})
        -- end
        -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("rank_combat"), http_request_method.GET, {page = 0},"rank_combat")
        function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_new_rank",{gameData = gameData})
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("rank_combat"), http_request_method.GET, {},"rank_combat",true,true)
    elseif btnTag == 100009 then --邀請碼
        local function responseMethod(tag,gameData)
            self:back();
            game_scene:addPop("game_invitation_code_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("user_request_code_index"), http_request_method.GET, nil,"user_request_code_index")
    elseif btnTag == 112 then--夥伴轉生
        game_scene:enterGameUi("game_hero_breakthrough",{gameData = nil});   
    elseif btnTag == 117 then  -- 重生
        game_scene:enterGameUi("ui_chongsheng_scene",{gameData = nil});
        self:destroy();
    elseif btnTag == 100011 then ---萬能兌換 liwen
        -- local function responseMethod(tag,gameData)
        --     self:back();
        --     game_scene:enterGameUi("game_exchange_scene2",{gameData = gameData});
        -- end
        local function responseMethod(tag,gameData)
            -- gameData = gameData:getNodeWithKey("data");
            -- lastcount = gameData:getNodeWithKey("exchange_log");
            -- cclog("selectliwen = " .. lastcount:getFormatBuffer())
            game_scene:enterGameUi("game_exchange_scene2",{typeid = 0 ,gameData = gameData});--0萬能兌換  1 限時兌換
            self:back();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("omni_exchange_lastcount"), http_request_method.GET, nil,"omni_exchange_lastcount")

        --print(game_url.getUrlForKey("get_exchangecenter_list") .. " url-----liwenxue")
        --network.sendHttpRequest(responseMethod,game_url.getUrlForKey("get_exchangecenter_list"),http_request_method.GET,{},"get_exchangecenter_list");
    elseif btnTag == 119 then
        game_scene:enterGameUi("gem_system_list",{})
    elseif btnTag == 100103 then
        game_scene:enterGameUi("gem_system_strengthen_scene",{})
    elseif btnTag == 118 then
        game_scene:enterGameUi("gem_system_synthesis",{})
    elseif btnTag == 137 then
        game_scene:enterGameUi("game_gem_advanced",{})
    elseif btnTag == 100105 then
        game_scene:enterGameUi("gem_explore_scene",{})
    elseif btnTag == 117 then  -- 重生
        game_scene:enterGameUi("ui_chongsheng_scene",{gameData = nil});
        self:destroy();
    elseif btnTag == 123 then--超进化
        game_scene:enterGameUi("game_hero_super_evolution",{gameData = nil});
    elseif btnTag == 122 then -- 合成
        game_scene:enterGameUi("game_card_melting",{})
        self:destroy()
    elseif btnTag == 999 then--勋章
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_medal_list",{gameData = gameData});
            self:back();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("medal_index"), http_request_method.GET, nil,"medal_index")
    elseif btnTag == 131 then--勋章图鉴
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_medal_charts",{gameData = gameData});
            self:back();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("medal_index"), http_request_method.GET, nil,"medal_index")
    elseif btnTag == 132 then--勋章训练
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_medal_train",{gameData = gameData});
            self:back();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("medal_index"), http_request_method.GET, nil,"medal_index")
    elseif btnTag == 134 then--英魂
        local function responseMethod(tag,gameData)
            local data = gameData:getNodeWithKey("data")
            local dataTable = json.decode(data:getFormatBuffer()) or {}
            cclog2("gameData.statue========",gameData.statue)
            game_scene:enterGameUi("game_soul_gacha",{gameData = gameData, statue = dataTable.statue ,soul_rate= dataTable.soul_rate});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("soul_soul_index"), http_request_method.GET, nil,"soul_index")
    elseif btnTag == 801 then   -- 查看宠物
        game_util:addMoveTips({text = "Giá tốc có thể làm lag máy, khởi động lại game là được"})
    elseif btnTag == 802 then   -- 查看宠物
        local s = CCDirector:sharedDirector():getScheduler()
        if s then
            cclog("----success---")
            s:setTimeScale(4)
        end
    elseif btnTag == 803 then   -- 查看宠物
        local s = CCDirector:sharedDirector():getScheduler()
        if s then
            cclog("----success---")
            s:setTimeScale(1)
        end
    elseif btnTag == 9504 then
        game_scene:enterGameUi("game_magic_evolution",{gameData = nil,openType = "game_function_pop"});
        -- game_util:addMoveTips({text = "！！！！ 法宝修炼 ！！！！"})
    elseif btnTag == 9505 then
        game_scene:enterGameUi("game_magic_list",{gameData = nil,openType = "game_function_pop"});
        -- game_util:addMoveTips({text = "！！！！ 法宝 ！！！！"}) 
    elseif btnTag == 9510 then
        game_scene:enterGameUi("game_badge_advanced",{gameData = nil});
    elseif btnTag == 9554 then
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_fame_scene",{gameData = gameData});
            self:destroy();
        end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_famous_index"), http_request_method.GET, {},"cards_famous_index")    
    end
end

--[[--
    讀取ccbi創建ui
]]
function game_function_pop.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        local tempFunciton = self.m_showBtnTab[self.m_typeName];
        if tempFunciton then
            local tempFuncitonItem = tempFunciton.item[btnTag-10]
            if tempFuncitonItem then
                local btnId = tempFuncitonItem.btnId
                if tempFuncitonItem.openFlag == nil or tempFuncitonItem.openFlag == false then
                    if not game_button_open:checkButtonOpen(btnId) then
                        return;
                    end
                end
                self:btnOnClickFunc(btnId);
            end
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);--bind button on click event
    ccbNode:openCCBFile("ccb/ui_function_pop.ccbi");
    self.m_root_layer = ccbNode:layerForName("m_root_layer")
    local m_btn_node = ccbNode:nodeForName("m_btn_node")
    self.m_temp_spri = ccbNode:spriteForName("m_temp_spri")
    self.m_btn_bg = ccbNode:scale9SpriteForName("m_btn_bg")
    self.m_arrow_spri = ccbNode:spriteForName("m_arrow_spri")
    self.m_temp_spri:setVisible(false);
    self.m_btn_bg:setVisible(false);
    self.m_arrow_spri:setVisible(false);

    local childrenCount = m_btn_node:getChildrenCount()
    local m_btn,m_help_btn = nil,nil;
    for i=1,childrenCount do
        local m_btn = ccbNode:controlButtonForName("m_btn_" .. i)
        m_btn:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
        self.m_funcUiTab[i] = {m_btn = m_btn}
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then
            if self.m_animEndStatus == 0 then
                self:back();
            end
            return true;--intercept event
        end
    end
    self.m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY,true);
    self.m_root_layer:setTouchEnabled(true);
    return ccbNode;
end

function game_function_pop.getGuideButtonIndex(self,typeName,btnId)
    local tempIndex = -1;
    local tempFunciton = self.m_showBtnTab[tostring(typeName)];
    if tempFunciton then
        local item = tempFunciton.item or {};
        for k,v in pairs(item) do
            if v.btnId == btnId then
                tempIndex = k;
                break;
            end
        end
    end
    return tempIndex;
end

--[[--
    刷新ui
]]
function game_function_pop.refreshUi(self)
    --local visibleSize = CCDirector:sharedDirector():getWinSize();
    local visibleSize = getWinSizeDesign();
    local X_count = math.floor(visibleSize.width/60)
    local startPos = nil;
    if self.m_posNode then
        local pX,pY = self.m_posNode:getPosition();
        startPos = self.m_posNode:getParent():convertToWorldSpace(ccp(pX,pY));
        startPos.x = startPos.x - display.wt
    end
    if startPos then
        self.m_temp_spri:setPosition(ccp(startPos.x,startPos.y))
        self.m_temp_spri:setVisible(true)
        local tempSize = self.m_arrow_spri:getContentSize()
        self.m_arrow_spri:setPosition(ccp(startPos.x,22 + startPos.y+tempSize.height*0.5));
        -- self.m_arrow_spri:setVisible(true);
        self.m_btn_bg:setPosition(ccp(startPos.x,20 + startPos.y+tempSize.height));
        -- self.m_btn_bg:setVisible(true);
    end
    local tempFunciton = self.m_showBtnTab[self.m_typeName];
    local m_btn,btnId;
    if tempFunciton then
        local tempTab = nil;
        local tempFuncitonItem = nil;
        local btnCount = #tempFunciton.item
        local tempDisplayFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tempFunciton.tempSprName);
        if tempDisplayFrame then
            self.m_temp_spri:setDisplayFrame(tempDisplayFrame);
        end
        local itemWidth = 60
        local realWidth,realHeight
        local Y_count = math.ceil(btnCount/X_count)
        local tempSize = self.m_btn_bg:getPreferredSize();
        if X_count > btnCount then
            realWidth = itemWidth*btnCount;
            realHeight = tempSize.height
        else
            realWidth = itemWidth*X_count;
            realHeight = tempSize.height *( Y_count * 2 - 1 - (Y_count - 1 )*0.5 )
        end

        self.m_btn_bg:setPreferredSize(CCSizeMake(realWidth, realHeight))
        local tempPosX = startPos.x;
        if (startPos.x - realWidth*0.5) < 0 then
            tempPosX = realWidth*0.5 + 10
        elseif (startPos.x + realWidth*0.5) > visibleSize.width then
            tempPosX = visibleSize.width - realWidth*0.5 - 10;
        end
        local startX = 0
        if startPos then
            self.m_btn_bg:setPositionX(tempPosX);
            if X_count > btnCount then
                startX = tempPosX - itemWidth*0.5*(btnCount - 1)
            else
                startX = tempPosX - itemWidth*0.5*(X_count - 1)
            end
        end
        local animIndex = btnCount;
        local function animCallbackFunc(node)
            animIndex = animIndex - 1;
            if animIndex == 0 then
                self.m_arrow_spri:setVisible(true);
                self.m_btn_bg:setVisible(true);
                local id = game_guide_controller:getCurrentId();
                local rongHeId = game_guide_controller:getIdByTeam("7")
                -- rongHeId = 706
                if self.m_typeName == "backpack" and id == 36 then--装备强化
                    local tempIndex = self:getGuideButtonIndex(self.m_typeName,602);
                    local tempTab = self.m_funcUiTab[tempIndex]
                    if tempTab then
                        local m_btn = tempTab.m_btn;
                        m_btn:setEnabled(true);
                        m_btn:setColor(ccc3(255,255,255));
                        game_guide_controller:gameGuide("show","2",37,{tempNode = m_btn})
                    end
                elseif self.m_typeName == "shop" and id == 14 then--gacha
                    local tempIndex = self:getGuideButtonIndex(self.m_typeName,401);
                    local tempTab = self.m_funcUiTab[tempIndex]
                    if tempTab then
                        local m_btn = tempTab.m_btn;
                        m_btn:setEnabled(true);
                        m_btn:setColor(ccc3(255,255,255));
                        game_guide_controller:gameGuide("show","1",14,{tempNode = m_btn})
                    end
                elseif self.m_typeName == "shop" and rongHeId == 706 then
                    local tempIndex = self:getGuideButtonIndex(self.m_typeName,122);
                    local tempTab = self.m_funcUiTab[tempIndex]
                    if tempTab then
                        local m_btn = tempTab.m_btn;
                        m_btn:setEnabled(true);
                        m_btn:setColor(ccc3(255,255,255));
                        game_guide_controller:gameGuide("show","7",706,{tempNode = m_btn})
                        -- game_guide_controller:sendGuideData("7", 707)
                        game_guide_controller:setGuideData("7",707);
                    end
                else
                    if self.m_typeName == "partner" then
                        local id = game_guide_controller:getIdByTeam("3");
                        if id == 302 then -- 技能升級
                            local tempIndex = self:getGuideButtonIndex(self.m_typeName,503);
                            local tempTab = self.m_funcUiTab[tempIndex]
                            if tempTab then
                                local m_btn = tempTab.m_btn;
                                m_btn:setEnabled(true);
                                m_btn:setColor(ccc3(255,255,255));
                                game_guide_controller:gameGuide("show","3",302,{tempNode = m_btn})
                            end
                        else
                            local id2 = game_guide_controller:getIdByTeam("5");
                            if id2 == 502 then -- 碎片兌換
                                local tempIndex = self:getGuideButtonIndex(self.m_typeName,100002);
                                local tempTab = self.m_funcUiTab[tempIndex]
                                if tempTab then
                                    local m_btn = tempTab.m_btn;
                                    m_btn:setEnabled(true);
                                    m_btn:setColor(ccc3(255,255,255));
                                    game_guide_controller:gameGuide("show","5",502,{tempNode = m_btn})
                                end
                            elseif id2 == 505 then -- 夥伴進階
                                local tempIndex = self:getGuideButtonIndex(self.m_typeName,502);
                                local tempTab = self.m_funcUiTab[tempIndex]
                                if tempTab then
                                    local m_btn = tempTab.m_btn;
                                    m_btn:setEnabled(true);
                                    m_btn:setColor(ccc3(255,255,255));
                                    game_guide_controller:gameGuide("show","5",505,{tempNode = m_btn})
                                end
                            else
                                self.m_animEndStatus = 0;
                            end
                        end
                    -- elseif self.m_typeName == "backpack" then
                    --     local id2 = game_guide_controller:getIdByTeam("5");
                    --     if id2 == 502 then -- 碎片兌換
                    --         local tempIndex = self:getGuideButtonIndex(self.m_typeName,100002);
                    --         local tempTab = self.m_funcUiTab[tempIndex]
                    --         if tempTab then
                    --             local m_btn = tempTab.m_btn;
                    --             m_btn:setEnabled(true);
                    --             m_btn:setColor(ccc3(255,255,255));
                    --             game_guide_controller:gameGuide("show","5",502,{tempNode = m_btn})
                    --         end
                    --     else
                    --         self.m_animEndStatus = 0;
                    --     end
                    else
                        self.m_animEndStatus = 0;
                    end
                end
            end
        end
        for i=1,#self.m_funcUiTab do
            tempTab = self.m_funcUiTab[i]
            m_btn = tempTab.m_btn;
            if i <= btnCount then
                tempFuncitonItem = tempFunciton.item[i]
                if tempFuncitonItem then
                    btnId = tempFuncitonItem.btnId
                    cclog("tempFuncitonItem.img === " .. tempFuncitonItem.img)
                    game_util:setCCControlButtonBackground(m_btn,tempFuncitonItem.img)
                    if tempFuncitonItem.openFlag == nil or tempFuncitonItem.openFlag == false then
                        game_button_open:setButtonShow(m_btn,btnId,1);
                    end
                    -- m_btn:setTag(btnId);
                    if startPos then
                        local pX,pY = m_btn:getPosition();
                        m_btn:setPosition(startPos);
                        local animArr = CCArray:create();
                        local x,y
                        local x_index = i%X_count
                        local y_index = math.ceil(i/X_count)
                        if x_index == 0 then
                            x_index = X_count
                        end
                        x = startX + itemWidth*(x_index - 1) 
                        if y_index > 1 then
                            y = visibleSize.height*(tempFuncitonItem.y*(y_index -(0.4*(y_index-1))))+5
                        else
                            y = visibleSize.height*(tempFuncitonItem.y*(y_index))+5
                        end 
                        animArr:addObject(CCMoveTo:create(0.2,ccp(x,y)));
                        animArr:addObject(CCCallFuncN:create(animCallbackFunc));
                        m_btn:runAction(CCSequence:create(animArr));
                        if btnId == 505 then
                            if game_data:getNewCardFlag() then--背包新卡牌
                                game_util:addTipsAnimByType(m_btn,10);
                            end
                        elseif btnId == 601 then
                            if game_data:getNewEquipFlag() then--新裝備
                                game_util:addTipsAnimByType(m_btn,10);
                            end
                        elseif btnId == 508 then--裝備兌換
                            -- if game_data:getAlertsDataByKey("equip_exchange") == true then--兌換
                            --     game_util:addTipsAnimByType(m_btn,9);
                            -- end
                        elseif btnId == 100002 then--夥伴兌換
                            -- if game_data:getAlertsDataByKey("exchange") == true then--兌換
                            --     game_util:addTipsAnimByType(m_btn,9);
                            -- end
                        elseif btnId == 501 then --夥伴訓練
                            if game_data:getAlertsDataByKey("train_finish") == true then
                                game_util:addTipsAnimByType(m_btn,9);
                            end
                        elseif btnId == 302 then--消息
                            if game_data:getAlertsDataByKey("notify") then
                                game_util:addTipsAnimByType(m_btn,9);
                            end
                        elseif btnId == 606 and game_button_open:getOpenFlagByBtnId(606)  then -- 精力已滿 
                                 -- 精力
                            -- local cmdr_energy = game_data:getUserStatusDataByKey("cmdr_energy") or 0
                            -- if cmdr_energy >= 30 and game_data:updateShowTips("cmdr_energy" ) then  -- 精力已滿 30
                            --     game_util:addTipsAnimByType(m_btn,9);
                            -- end
                        elseif btnId ==605 and game_button_open:getOpenFlagByBtnId(605) then  -- 星靈 1000
                            local totalStar = game_data:getUserStatusDataByKey("star") or 0
                            if totalStar >= 1000 and game_data:updateShowTips( "totalStar" ) then  -- 星靈 1000
                                game_util:addTipsAnimByType(m_btn,9);
                            end
                        end
                    end
                end
            else
                m_btn:setVisible(false);
            end
        end
    end
end

--[[--
    初始化
]]
function game_function_pop.init(self,t_params)
    t_params = t_params or {};
    -- body
    self.m_callFunc = t_params.callFunc;
    self.m_typeName = t_params.typeName;
    self.m_posNode = t_params.posNode;
    self.m_animEndStatus = -1;
    self.m_funcUiTab = {};
end

--[[--
    创建ui入口并初始化数据
]]
function game_function_pop.create(self,t_params)
    self.m_showBtnTab = initFunTab( util.table_copy( functionTab )  )
    self:init(t_params);
    self.m_popUi = self:createUi();
    self:refreshUi();
    return self.m_popUi;
end

--[[--
    回调方法
]]
function game_function_pop.callFunc(self,typeName,t_params)
    if self.m_callFunc and type(self.m_callFunc) == "function" then
        self.m_callFunc(typeName,t_params);
    end
end

return game_function_pop; ��