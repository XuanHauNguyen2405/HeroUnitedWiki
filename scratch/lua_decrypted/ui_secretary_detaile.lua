--- 活動

local ui_secretary_detaile = {
    m_root_layer = nil,

    m_type = nil,
    m_node_itemsboard = nil,
};



local AllInfo = {}
local huoban = {
         {InReviewId = 12, btnId = 401, isVisible = true,  title = "Chiêu mộ đồng đội mạnh hơn", info = "Rút liên tiếp 10 lần nhất định được đồng đội Cam", btnSpriteName = "mbutton_5_1"},  -- gacha 
         {InReviewId = 17, btnId = 501, isVisible = false,  title ="Tăng nhanh cấp đồng đội",info = "VIP có thể nhận thêm số lần huấn luyện", btnSpriteName = "mbutton_2_1"},  -- 夥伴訓練
         {InReviewId = 18, btnId = 503, isVisible = false,  title = "Tăng uy lực kĩ năng đồng đội", info = "Dùng đồng đội Lục trở xuống làm nguyên liệu sẽ có giá hơn", btnSpriteName = "mbutton_2_2"},  -- 技能升級
         {InReviewId = 19, btnId = 502, isVisible = false,  title = "Tăng kĩ năng mở khóa thuộc tính", info = "+10 có thể khiến tất cả kĩ năng tăng tỉ lệ phát động lên 100%", btnSpriteName = "mbutton_2_3"},  -- 技能升級
         {InReviewId = 20, btnId = 509, isVisible = false,  title = "Tăng thuộc tính đồng đội", info = "Có thể nhận thêm năng tinh ở cửa hàng siêu năng", btnSpriteName = "mbutton_2_4"},   -- 屬性改造
         {InReviewId = 44, btnId = 112, isVisible = false,  title = "Tăng vọt HP", info = "Tăng cường hiệu quả kĩ năng, chuyển sinh 5 lần càng có thuộc tính cường lực", btnSpriteName = "mbutton_c_tubo"}, -- 夥伴轉生
         {InReviewId = 21, btnId = 100002, isVisible = true,  title = "Miễn phí nhận đồng đội cường lực", info = "Có thể nhận Mảnh qua xuất chiến", btnSpriteName = "mbutton_3_3"},   -- 夥伴兌換
         {InReviewId = 33, btnId = 506, isVisible = false,  title = "EXP đồng đội kế thừa", info = "Còn có thể kế thừa cấp cải tạo thuộc tính", btnSpriteName = "mbutton_5_5"},   -- 夥伴傳承
    }

AllInfo["huoban"] = huoban

local equip = {
        {InReviewId = 39, btnId = 800, isVisible = false,  title = "Mỗi ngày càn quét 3 lần", info = "Nhận trang bị cường lực", btnSpriteName = "sjdt_elite_levels_btn", spriteFrames = "ccbResources/ui_map_world_res.plist"},  --  精英關卡
        {InReviewId = 22, btnId = 602, isVisible = false,  title = "Tăng mạnh thuộc tính trang bị", info = "Sắt tiêu hao để cường hóa sẽ trả lại toàn bộ khi bán trang bị", btnSpriteName = "mbutton_3_1"},  -- 裝備強化
        {InReviewId = 23, btnId = 603, isVisible = false,  title = "Tăng phẩm chất trang bị", info = "Tăng mạnh thuộc tính trang bị, trang bị Lam cũng thành trang bị Đỏ", btnSpriteName = "mbutton_3_2"},  -- 裝備進階
        {InReviewId = 25, btnId = 607, isVisible = false,  title = "Không cần lãng phí trang bị cũ", info = "Phân giải có thể nhận Đá Tinh Luyện", btnSpriteName = "mbutton_2_split"},  -- 裝備拆分
        {InReviewId = 24, btnId = 608, isVisible = false,  title = "Tăng thuộc tính cường lực trang bị", info = "Trang bị 10 sao không gì cản nổi", btnSpriteName = "mbutton_2_st"},  -- 裝備精煉
        {InReviewId = 26, btnId = 508, isVisible = true,  title = "Nhận miễn phí trang bị cường lực", info = "Nhận miễn phí trang bị cường lực", btnSpriteName = "mbutton_b_equip"},  -- 裝備兌換
    }
AllInfo["equip"] = equip

local hero = {
        {InReviewId = 16, btnId = 606, isVisible = false,  title = "Đoạt mảnh thống soái", info = "Nhận trang bị cường lực", btnSpriteName = "mbutton_tsnl"},  -- 統帥能力
        {InReviewId = 15, btnId = 605, isVisible = false,  title = "Kĩ năng anh hùng có thể xoay chuyển chiến cục", info = "Hồn Sao có thể nhận ở cửa hàng siêu năng", btnSpriteName = "mbutton_6_1"},  -- 主角技能
        {InReviewId = 13, btnId = 700, isVisible = false,  title = "Cửa hàng liên minh có rất nhiều đồ tốt", info = "Mỗi ngày còn có thể đánh BOSS liên minh", btnSpriteName = "mbutton_4_2"},  -- 聯盟
        {InReviewId = 41, btnId = 100009, isVisible = true,  title = "Mời bạn bè đến trợ chiến", info = "Hai bên đều có thể nhận phần thưởng giá trị", btnSpriteName = "mbutton_6_3"},  -- 邀請碼
    }
AllInfo["hero"] = hero

local active = {
            {InReviewId = nil, btnId = 90001, isVisible = true,  title = "Mỗi ngày trưa và tối phát", info = "Tăng 50 điểm thể lực, tuyệt đối đừng bỏ lỡ", btnSpriteName = "button_active_day", spriteFrames = "ccbResources/activity.plist"},    -- 生存物資
            {InReviewId = nil, btnId = 113, isVisible = true,  title = "Mỗi ngày 13:00 và 20:00 mở", info = "Tham gia sẽ có phần thưởng, xếp hạng càng cao thưởng càng nhiều", btnSpriteName = "button_active_boss", spriteFrames = "ccbResources/activity.plist"},  -- 進擊的巨人
            {InReviewId = nil, btnId = 105, isVisible = false,  title = "Mỗi ngày có thể tham gia 2 lần", info = "Có thể nhận rất nhiều EXP, độ khó càng cao, EXP càng nhiều", btnSpriteName = "button_active_exp", spriteFrames = "ccbResources/activity.plist"},  --  馬上有經驗
            {InReviewId = nil, btnId = 106, isVisible = false,  title = "Mỗi ngày có thể tham gia 2 lần", info = "Có thể nhận rất nhiều tài nguyên, độ khó càng cao, tài nguyên càng nhiều", btnSpriteName = "button_active_resource", spriteFrames = "ccbResources/activity.plist"},  --  資源爭奪戰
            {InReviewId = nil, btnId = 110, isVisible = false,  title = "Có thể nhận rất nhiều thức ăn", info = "Cùng người chơi khác giành tài nguyên, đây là nơi phô bày thực lực", btnSpriteName = "button_active_middle", spriteFrames = "ccbResources/activity.plist"},  -- 無主之地
            {InReviewId = nil, btnId = 108, isVisible = false,  title = "Mỗi ngày có thể tham gia 2 lần", info = "1 tuần 7 ngày đều có hoạt động khác nhau, có tỉ lệ nhận mảnh đồng đội", btnSpriteName = "mbutton_2_4", spriteFrames = "ccbResources/activity.plist"},  -- 每日挑戰
            {InReviewId = nil, btnId = 109, isVisible = false,  title = "Mỗi ngày có thể tham gia 2 lần", info = "1 tuần 7 ngày đều có hoạt động khác nhau, có tỉ lệ nhận mảnh đồng đội cường lực", btnSpriteName = "mbutton_c_tubo", spriteFrames = "ccbResources/activity.plist"},  -- 極限挑戰
            {InReviewId = nil, btnId = 107, isVisible = false,  title = "Thử thách thực lực của bạn", info = "Vượt càng nhiều tầng thì thưởng càng nhiều, mỗi ngày 9:00 và 21:00 tạo mới", btnSpriteName = "button_active_live", spriteFrames = "ccbResources/activity.plist"},  -- 生存大考驗
    }
AllInfo["active"] = active

local shop = {
        {InReviewId = 29, btnId = 403, isVisible = true,  title = "Nạp tiền nhận ngay nhiều loại đặc quyền", info = "Có thêm quà VIP giá trị", btnSpriteName = "mbutton_6_2"},  -- 充值
        {InReviewId = 30, btnId = 402, isVisible = true,  title = "Cung cấp các loại đạo cụ giá trị", info = "Mỗi ngày đồ đạc có số lượng hạn chế mua, đừng bỏ lỡ", btnSpriteName = "mbutton_5_2"},  -- 鑽石商城
        {InReviewId = 31, btnId = 307, isVisible = false,  title = "Có thể đổi rất nhiều vật phẩm giá trị", info = "Cách mỗi 4 tiếng tạo mới 1 lần", btnSpriteName = "mbutton_5_3"},  -- 超能商店
        {InReviewId = 34, btnId = 100007, isVisible = true,  title = "Mỗi ngày 12:00 trưa tạo mới", info = "Khuyến mãi toàn máy chủ, đến trước lấy trước", btnSpriteName = "mbutton_4_xiangou"},  -- 限購商城
        {InReviewId = 7, btnId = 200,  isVisible = false,  title = "Phô bày thực lực mạnh mẽ của bạn", info = "Tổng tích điểm có thể đổi báu vật", btnSpriteName = "mbutton_m_fight"},  -- 競技場
        {InReviewId = 3, btnId = 90003, isVisible = true,  title = "Đạt yêu cầu nhận thưởng ngay", info = "Luôn chú ý đến, đừng bỏ lỡ", btnSpriteName = "mbutton_m_award"},  -- 領獎
        {InReviewId = 5, btnId = 90004, isVisible = true,  title = "Cộng gộp tích điểm nhận thưởng", info = "Nhận nhiệm vụ 5 phút", btnSpriteName = "mbutton_m_quest"},  -- 任務
        {InReviewId = 4, btnId = 90005, isVisible = true,  title = "Mỗi ngày online", info = "Đừng bỏ lỡ mục nào, đạt yêu cầu có thể nhận thưởng", btnSpriteName = "mbutton_m_richang"},  -- 日常
    }
AllInfo["shop"] = shop

do 
    if game_data:getAlertsDataByKey("reward") == nil and game_data:getAlertsDataByKey("diary") == nil then--
        
    end



end



-- function setAllInfoState( viewID, lei, pos )
--      -- print("ckeck  setAllInfoState   ", lei)
--     if game_data:isViewOpenByID(viewID) then 
--         return
--     end
--     -- print("run  setAllInfoState   ", lei)
--     local count = #AllInfo[lei]
--     -- print("pos count", pos, count)
--     if pos < count then
--         for i=pos,count - 1 do
--             local temp = nil
--             temp = AllInfo[lei][i]
--             AllInfo[lei][i] =  AllInfo[lei][i + 1]
--             AllInfo[lei][i + 1] = temp
--             AllInfo[lei][i + 1].x = AllInfo[lei][i].x
--             AllInfo[lei][i].x = temp.x
--         end
--     end
--     -- print_lua_table(functionTab[lei].item, 5)
--     AllInfo[lei][count] = nil
-- end

-- do 
--     -- print("************************ start reset inreview *************************")
--     for k,v in pairs(AllInfo) do
--         -- print("============================================================")
--         if type(v) == "table" then
--             local number = #v
--             for i=1,number do
--                 local item = v[number - i + 1]
--                 if item.InReviewId and type(item.InReviewId) == "number" then
--                     -- print(" check item is inreview == ", "part key ", k, " item name ", item.name, " InReviewId ", item.InReviewId, " item pos", number - i + 1)
--                     setAllInfoState(item.InReviewId, k, number - i + 1)
--                 end
--             end
--         end
--         -- print("============================================================")
--     end
-- end



--[[--
    按鈕點擊
]]
function ui_secretary_detaile.btnOnClickFunc(self,btnTag)
    cclog("btnOnClickFunc ================ btnTag = " .. btnTag)
    if btnTag == 200 then -- 競技場
        if not game_button_open:checkButtonOpen(200) then
            return;
        end
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_arena",{pk_flag = "pk",gameData = json.decode(gameData:getNodeWithKey("data"):getFormatBuffer())});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("arena_index"), http_request_method.GET, {},"arena_index");
    elseif btnTag == 800 then -- 精英關卡
        if not game_button_open:checkButtonOpen(800) then
            return;
        end
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("map_world_scene",{gameData = gameData, chapterSwitchTo = "hard", assign_hard_chapter = ch1});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("private_city_world_map"), http_request_method.GET, nil,"private_city_world_map")
    elseif btnTag == 505 then--查看夥伴
        game_scene:enterGameUi("game_hero_list",{gameData = nil});
        self:destroy();
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
    elseif btnTag == 502 then--夥伴進階
        game_scene:enterGameUi("game_hero_advanced_sure",{gameData = nil});
        self:destroy();
    elseif btnTag == 506 then--夥伴傳承
        game_scene:enterGameUi("game_hero_inherit");
        self:destroy();
    elseif btnTag == 507 then--夥伴分解
        game_scene:enterGameUi("game_card_split");
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
        self:back();
        game_scene:addPop("game_announcement_pop",{typeName = "help"});
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
    elseif btnTag == 605 then--戰爭科技
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("skills_practice_scene",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("leader_skill_open"), http_request_method.GET, nil,"leader_skill_open")
    elseif btnTag == 508 then--裝備兌換
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_exchange_scene",{gameData = gameData,openType = 2})
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("item_view"), http_request_method.GET, {},"item_view");
    elseif btnTag == 401 then--招募
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_gacha_scene",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("gacha_get_all_gacha"), http_request_method.GET, nil,"gacha_get_all_gacha")  
    elseif btnTag == 403 then
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("ui_vip",{gameData = gameData});
            --game_scene:addPop("ui_vip_show_pop");
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("vip_buy_step"), http_request_method.GET, nil,"vip_buy_step")
    elseif btnTag == 100001 then -- 夥伴圖鑒
        print(" to show Đồng đội -------------")
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_lllustrations_scene",{gameData = gameData, showType = "character"});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cards_books"), http_request_method.GET, nil,"cards_books")
    elseif btnTag == 100010 then -- 裝備圖鑒
        -- print(" to show 裝備圖鑒 -------------")
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_lllustrations_scene",{gameData = gameData, showType = "equip"});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("equip_books"), http_request_method.GET, nil,"equip_books")
        self:destroy();
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
        if not game_button_open:checkButtonOpen(606) then
            return
        end
        local function responseMethod(tag,gameData)
            game_scene:enterGameUi("game_ability_commander",{gameData = gameData});
            self:destroy();
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("commander_index"), http_request_method.GET, nil,"commander_index")
    elseif btnTag == 607 then--裝備拆分
        if not game_button_open:checkButtonOpen(607) then
            return
        end
        game_scene:enterGameUi("ui_equip_split");
        self:destroy();
    elseif btnTag == 608 then--裝備精煉
            if not game_button_open:checkButtonOpen(608) then
                return
            end
        game_scene:enterGameUi("game_equip_refining",{})
        self:destroy()
    elseif btnTag == 100007 then --限購商城
        local function responseMethod(tag,gameData)
            self:back();
            game_scene:addPop("game_limit_shop_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("shop_outlets_open"), http_request_method.GET, {},"shop_outlets_open");
    elseif btnTag == 100008 then --排行榜
        -- local ui_all_rank = require("game_ui.ui_all_rank")
        -- ui_all_rank.enterAllRankByRankName( "rank_combat" )
        function responseMethod(tag,gameData)
            if gameData then
                game_scene:enterGameUi("game_new_rank",{gameData = gameData})
            end
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("rank_combat"), http_request_method.GET, {},"rank_combat",true,true)
        -- local function responseMethod(tag,gameData)
        --     local data = gameData:getNodeWithKey("data")
        --     game_scene:enterGameUi("ui_levelap_rank",{gameData = json.decode(data:getFormatBuffer())})
        -- end
        -- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("rank_combat"), http_request_method.GET, {page = 0},"rank_combat")
    elseif btnTag == 100009 then --邀請碼
        local function responseMethod(tag,gameData)
            self:back();
            game_scene:addPop("game_invitation_code_pop",{gameData = gameData});
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("user_request_code_index"), http_request_method.GET, nil,"user_request_code_index")
    elseif btnTag == 100011 then--夥伴轉生
        game_scene:enterGameUi("game_hero_breakthrough",{gameData = nil});   

    elseif btnTag == 105 then  -- 馬上有經驗
        self:goToActivity(7, nil )
    elseif btnTag == 106 then  -- 資源爭奪戰
        self:goToActivity(4, nil )
    elseif btnTag == 107 then  -- 生存大考驗
        self:goToActivity(8, nil )
    elseif btnTag == 108 then  -- 每日挑戰
        local chapter = self:getActivityChapterID(108 - 103)
        self:goToActivity(5, nil )
    elseif btnTag == 109 then  -- 極限挑戰
        local chapter = self:getActivityChapterID(109 - 103)
        self:goToActivity(6, nil )
    elseif btnTag == 110 then  -- 無主之地
        self:goToActivity(3, nil )
    elseif btnTag == 90001 then --   生存物資
        self:goToActivity(1, nil )
    elseif btnTag == 112 then
        if not game_button_open:checkButtonOpen(112) then
            return
        end
        game_scene:enterGameUi("game_hero_breakthrough",{gameData = nil});      
    elseif btnTag == 113 then--  進擊的巨人 
        self:goToActivity(2, nil )
    elseif btnTag == 90003 then-- 獎勵 
        function shopOpenResponseMethod(tag,gameData)
            game_scene:enterGameUi("game_new_reward",{gameData = gameData})
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("reward_once_index"), http_request_method.GET, {},"reward_once_index")
    elseif btnTag == 90004 then-- 任務 
        function shopOpenResponseMethod(tag,gameData)
            game_scene:addPop("game_daily_wanted",{gameData = gameData})
            self:back()
        end
        network.sendHttpRequest(shopOpenResponseMethod,game_url.getUrlForKey("reward_index"), http_request_method.GET, {},"reward_index")
    elseif btnTag == 90005 then-- 日常
        function responseMethod(tag,gameData)
            game_scene:addPop("game_daily_task_pop",{gameData = gameData})self:back()
            self:back()
        end
        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("reward_diary_index"), http_request_method.GET, {},"reward_diary_index")
    end
end

--[[--
    去活動的方法
]]
function ui_secretary_detaile.goToActivity( self, itemIndex, chapterID )
    local function responseMethod(tag,gameData)
    self:back()
    game_scene:enterGameUi("game_activity",{gameData = gameData, chapterID = chapterID, itemIndex = itemIndex});
    end
    network.sendHttpRequest(responseMethod,game_url.getUrlForKey("active_index"), http_request_method.GET, nil,"active_index")
end


--[[-- 
    獲取功能
]]
function ui_secretary_detaile.getAcitveIconInfo( self, bid )
    bid = tonumber(bid) or 1
    if bid == 108 or bid == 109 then
        local myChapterId = self:getActivityChapterID(bid - 103, self.activityData)
        local chapterCfg = getConfig(game_config_field.active_chapter)
        local itemCfg = chapterCfg:getNodeWithKey(tostring(myChapterId))
        active_btn = itemCfg:getNodeWithKey("button"):toStr()
        return active_btn
    else
        return nil
    end
end

--[[--
    獲取活動 chapter id
]]
function ui_secretary_detaile.getActivityChapterID( self , index )
    local m_active_cfg = {}
    local activeCfg = getConfig(game_config_field.active_cfg)
    for i=1,activeCfg:getNodeCount() do
        local itemCfg = activeCfg:getNodeWithKey(tostring(10*i))
        local is_see = itemCfg:getNodeWithKey("is_see"):toInt()
        if is_see == 1 then
            table.insert(m_active_cfg,json.decode(itemCfg:getFormatBuffer()))
        end
    end

    local active_cfg = m_active_cfg[index]

    local chapter_id = active_cfg.active_chapterID[1]
    local myChapterId = -1
    --比較服務器開啟的活動ID 和 配置裡對應位置的ID
    if tolua.type(chapter_id) == "table" then
        for i=1,#chapter_id do
            local cfgChapterId = chapter_id[i]
            for i=1,#self.m_active_data do
                local serverChapterId = self.m_active_data[i]
                if serverChapterId == cfgChapterId then
                    myChapterId = serverChapterId
                    break;
                end
            end
        end
    else
        myChapterId = chapter_id or -1
    end
    return myChapterId
end


--[[--
    銷毀ui
]]
function ui_secretary_detaile.destroy(self)
    -- body
    cclog("-----------------ui_secretary_detaile destroy-----------------");
    self.m_root_layer = nil;

    self.m_node_itemsboard = nil;
    self.m_type = nil;
end
--[[--
    返回
]]
function ui_secretary_detaile.back(self,backType)
    game_scene:removePopByName("ui_secretary_detaile");
end
--[[--
    讀取ccbi創建ui
]]
function ui_secretary_detaile.createUi(self)
    local ccbNode = luaCCBNode:create();
    local function onMainBtnClick( target,event )
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        print("click btn tag === ", btnTag)
        if btnTag == 201 then
            -- 返回
            self:back();
            game_scene:addPop("ui_secretary_pop")
        end
    end
    ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
    ccbNode:openCCBFile("ccb/ui_secretary_detail2.ccbi");

    self.btn_back = ccbNode:controlButtonForName("btn_back");

    self.btn_back:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
    game_util:setControlButtonTitleBMFont(self.btn_back)
    local m_root_layer = ccbNode:layerColorForName("m_root_layer")
    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true;
        end
    end
    m_root_layer:registerScriptTouchHandler(onTouch,false,GLOBAL_TOUCH_PRIORITY,true);
    m_root_layer:setTouchEnabled(true);


    self.m_node_itemsboard = ccbNode:nodeForName("m_node_itemsboard")
    self.m_sprite_title = ccbNode:spriteForName("m_sprite_title")

    self:refreshUi()

    return ccbNode;
end


--[[--
    刷新ui
]]
function ui_secretary_detaile.refreshUi(self)

    local imgNames = {huoban = "ui_xms_huoban", equip = "ui_xms_zhuangbei", hero = "ui_xms_yingxiong", active = "ui_xms_huodong", shop = "ui_xms_gengduo"}
    local tempFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName((imgNames[self.m_type] or "ui_xms_gengduo") ..".png")
    if tempFrame then
        self.m_sprite_title:setDisplayFrame(tempFrame)
    end

    self.m_node_itemsboard:removeAllChildrenWithCleanup(true);
    local tableViewTemp = self:createTableView(self.m_node_itemsboard:getContentSize());


    self.m_node_itemsboard:addChild(tableViewTemp);
end

function ui_secretary_detaile.createTableView(self, viewSize)

     local function onMainBtnClick( event, target)
        local tagNode = tolua.cast(target, "CCNode");
        local btnTag = tagNode:getTag();
        print("click btn tag === ", btnTag)
        self:btnOnClickFunc(btnTag)
    end

    local showTable = AllInfo[self.m_type]
    local params = {};
    params.viewSize = viewSize;
    params.row = 4;--行
    params.column = 2; --列
    -- params.touchPriority = GLOBAL_TOUCH_PRIORITY-6;
    params.totalItem = #showTable;
    params.showPageIndex = self.m_curPage;
    local itemSize = CCSizeMake(viewSize.width/params.column,viewSize.height/params.row);
    -- index = 0
    params.newCell = function(tableView,index) 
        local cell = tableView:dequeueCell()
    -- index = 0
        if cell == nil then
            -- cclog("new index ================================" .. index);
            cell = CCTableViewCell:new()
            cell:autorelease()
            local ccbNode = luaCCBNode:create();
            ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
            ccbNode:openCCBFile("ccb/ui_secretary_item.ccbi");
            ccbNode:setAnchorPoint(ccp(0.5,0.5));
            ccbNode:setPosition(ccp(itemSize.width*0.5,itemSize.height*0.5));
            cell:addChild(ccbNode,10,10);
        end
        if cell then
            local ccbNode = tolua.cast(cell:getChildByTag(10),"luaCCBNode")
            local m_label_title = ccbNode:labelTTFForName("m_label_title")
            for i=1,3 do
                local m_label_title = ccbNode:labelTTFForName("m_label_title" .. i)
                m_label_title:setString(showTable[index + 1].title or "")
            end
            local m_label_showinfo = ccbNode:labelTTFForName("m_label_showinfo")
            m_label_showinfo:setString(showTable[index + 1].info or "")

            if showTable[index + 1].spriteFrames then
                CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(showTable[index + 1].spriteFrames)
            end


            local m_conbtn_sign = ccbNode:controlButtonForName("m_conbtn_sign")
            m_conbtn_sign:setTag(showTable[index + 1].btnId)
            -- m_conbtn_sign:setTouchPriority(GLOBAL_TOUCH_PRIORITY - 1);
            local imgName = showTable[index + 1].btnSpriteName
            if imgName then
                local btnImg = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(imgName..".png");
                if btnImg then
                    local btn = game_util:createCCControlButtonByTable( {text = "", btnImgName = imgName..".png", touchPriority = GLOBAL_TOUCH_PRIORITY - 1,
                     callFunc = onMainBtnClick} )
                    btn:setPosition( m_conbtn_sign:getPosition() )
                    btn:setAnchorPoint( m_conbtn_sign:getAnchorPoint() )
                    btn:setTag(showTable[index + 1].btnId)
                    m_conbtn_sign:getParent():addChild(btn, -1)
                    m_conbtn_sign:setVisible(false)
                    local scale = m_conbtn_sign:getContentSize().width / btn:getContentSize().width
                    print("scale = ====  ", scale)
                    if self.m_type == "active" then scale = 0.85 end
                    btn:setScale( scale )
                    btn:setZoomOnTouchDown(false)
                    m_conbtn_sign = btn
                end
            end

            local m_sprite9_showTxtBoard = ccbNode:scale9SpriteForName("m_sprite9_showTxtBoard")
            if m_sprite9_showTxtBoard then
                m_sprite9_showTxtBoard:getParent():reorderChild(m_sprite9_showTxtBoard, -2)
            end


            local m_srite9_tipsboard = ccbNode:scale9SpriteForName("m_srite9_tipsboard")
            local m_label_tips = ccbNode:labelTTFForName("m_label_tips")
            local m_sprite_notopen = ccbNode:scale9SpriteForName("m_sprite_notopen")
            if showTable[index + 1].isVisible or (showTable[index + 1].btnId and game_button_open:getOpenFlagByBtnId(showTable[index + 1].btnId)) then
                --     m_srite9_tipsboard:setVisible(false)
                --     m_label_tips:setVisible(false)
                    m_sprite_notopen:setVisible(false)
                    m_conbtn_sign:setColor(ccc3(255, 255, 255))
            else
                local lockstr = game_button_open:getOpenGuideLockStrByBtnId( showTable[index + 1].btnId )
                m_label_tips:setString(lockstr or "Không đủ cấp độ")
                m_label_showinfo:setString(lockstr or "Không đủ cấp độ")
                -- m_srite9_tipsboard:setVisible(true)
                -- m_label_tips:setVisible(true)
                m_sprite_notopen:setVisible(true)
                m_conbtn_sign:setColor(ccc3(155, 155, 155))
                m_conbtn_sign:setTouchEnabled(false)
            end
            m_srite9_tipsboard:setVisible(false)
            m_label_tips:setVisible(false)

        end
        return cell;
    end
    params.itemOnClick = function(eventType,index,item)
        -- cclog("eventType = " .. eventType .. ";index = " .. index .. " ;  item = " .. tolua.type(item));
        -- if index >= itemsCount then return end;
        -- if eventType == "ended" and item then
        --     local character_book_item_cfg = character_book_cfg:getNodeAt(index)
        --     local character_id = character_book_item_cfg:getNodeWithKey("character_id"):toStr()
        --     local itemCfg = character_detail_cfg:getNodeWithKey(character_id)
        --     if itemCfg then
        --         local is_see = character_book_item_cfg:getNodeWithKey("is_see"):toInt();
        --         if is_see == 1 then
        --             cclog("c_id ================ " .. itemCfg:getKey())
        --             game_scene:addPop("game_hero_info_pop",{cId = itemCfg:getKey(),openType = 4,lllustrationsOpenFlag = (self.m_ownBookTab[character_id] ~= nil)})
        --         else
        --             game_util:addMoveTips({text = "暫未開放！"});
        --         end
        --     end
        -- end
    end
    params.pageChangedCallFunc = function(totalPage,curPage)
        self.m_curPage = curPage;
    end
    local tableview =  TableViewHelper:createGallery3(params);



    local count = #showTable
    local row = count/2 + count%2
    tableview:setPositionY( tableview:getPositionY() - itemSize.height * 0.5 * ( 4 - row) )



    return tableview 
end

--[[--
    初始化
]]
function ui_secretary_detaile.init(self,t_params)
    t_params = t_params or {};
    self.m_type = t_params.showtype or "huoban"

    if t_params.activeData then
        local data = t_params.activeData:getNodeWithKey("data")
        -- cclog("activity data=="..data:getFormatBuffer())
        local others = data:getNodeWithKey("index");--有的即開啟
        local chapterID_index = {}
        for i=1,others:getNodeCount() do
            local indexItem = others:getNodeAt(i-1)
            local index_key = indexItem:getKey()
            table.insert(chapterID_index,tonumber(index_key))
        end

        self.m_active_data = chapterID_index
        -- 108
        local btn108 = self:getAcitveIconInfo(108)
        AllInfo["active"][6].btnSpriteName = btn108
        -- 109
        local btn109 = self:getAcitveIconInfo(109)
        AllInfo["active"][7].btnSpriteName = btn109
    end
    -- body
end

--[[--
    創建ui入口並初始化數據
]]
function ui_secretary_detaile.create(self,t_params)
    self:init(t_params);
    local scene = CCScene:create();
    scene:addChild(self:createUi());
    self:refreshUi();
    return scene;
end

return ui_secretary_detaile;