--- 遊戲文字配置
--
local string_config = {
    m_name_err = "Tên này đã được dùng",      --姓名已被使用
    m_btn_cancel = "Hủy",
    m_btn_sure = "Xác định",
    m_btn_think = "Ta nghĩ lại thử",
    m_btn_agree = "Đồng ý",
    m_btn_reject = "Từ chối",
    m_btn_use = "Dùng",
    m_btn_open = "Mở",
    m_title_prompt = "Nhắc nhở",
    m_btn_close = "Đóng",
    m_operating_success = "Thao tác thành công!",
    m_sel_hero = "Hãy chọn anh hùng!",
    m_hero_comp_success = "Ghép anh hùng thành công!",
    m_hero_comp_alert_msg = "Anh hùng đang ra trận, không thể dùng làm nguyên liệu!", 
    m_equip_decom_success = "Phân giải trang bị thành công!",
    m_equip_decom_alert_msg = "Trang bị đang dùng, không thể phân giải!",
    m_hero_evo_success = "Tiến hóa anh hùng thành công!",
    m_hero_evo_alert_msg = "Anh hùng này không thể tiến hóa!",
    m_hero_decom_alert_msg = "Anh hùng đang ra trận, không thể phân giải!",
    m_hero_decom_success = "Phân giải anh hùng thành công!",
    m_hero_sell_success = "Bán anh hùng thành công!",
    m_hero_sell_alert_msg = "Anh hùng đang ra trận, không thể bán!",
    m_e_cooling_alert_msg = "Đang đóng băng cường hóa trang bị, không thể cường hóa!",
    m_e_level_alert_msg = "Cấp không đủ, không thể cường hóa!",
    m_e_evo_success = "Cường hóa trang bị thành công!",
    m_net_req_failed = "Mạng xin thất bại, xin thử lại!",
    m_net_no_data = "Không có dữ liệu mạng!",
    m_data_error = "Mạng hiện tại không ổn định, không thể kết nối máy chủ, xin thử lại sau~",
    m_hero_played_in = "Đang ra trận",
    m_equip_use = "Đang dùng",
    m_equip_merge_alert_msg = "Nguyên liệu không đủ không thể ghép!",
    m_equip_merge_success = "Ghép trang bị thành công!",
    m_career_success = "Chuyển chức thành công",
    m_career_buyitems_success = "Mua đạo cụ chuyển chức thành công",
    m_equip_decomposition_auto = "Xác nhận tự động phân giải trang bị 1,2 sao?",
    m_again_http_request = "Xin lại",
    m_clear_cooling_time_success = "Xóa thời gian chờ thành công!",
    m_change_ratio_equip_success = "Thay đổi tỉ lệ cường hóa trang bị thành công!",
    m_notselect_partsid = "Hãy chọn linh kiện muốn cường hóa",
    m_energy_stone = "Năng tinh",
    m_gold_card_item = "Thẻ Vàng",
    m_silver_card_item = "Thẻ Bạc",

    m_input_role_name = "Nhập tên nhân vật",
    m_re_input = "Nhập lại",
    m_no_input_name = "Xin lỗi, hãy nhập tên của bạn!",
    m_random = "Ngẫu nhiên",
   m_firts_opening_story = "Công nguyên năm 2055, 30 năm sau khi vũ trụ cùng cấp phát hiện\n sự phát hiện vũ trụ sức mạnh đã mang đến virus cực kì khủng bố - làn sương xám \n Làn sương xám dẫn đến rất nhiều người biến thành zombie, trật tự xã hội đảo lộn \n Để tìm ra cách giải quyết vấn đề, các vũ trụ đều phái anh hùng siêu cấp vào \n vũ trụ sức mạnh, phát hiện bí mật của virus xong, tranh giành tài ngyên trị liệu nhiều hơn \n chương đại thám hiểm mới từ đó bắt đầu…",
    m_re_donwload = "Tải lại",
    m_download_failed = "Dữ liệu tải thất bại",
    m_re_conn = "Kết nối lại",
    m_download_cfg = "Tải cấu hình",
    m_download_res = "Tải tài nguyên",
    m_fight_cost_tips = "Tổng cộng %d trận chiến, mỗi trận tiêu hao %d",
    m_no_msg = "Không",
    m_map_title_battle_over = "Bản đồ đã đánh xong",
    m_re_battle_lock_msg = "Cấp 10 mở khóa",
    m_explore = "Thám hiểm",
    m_re_explore = "Càn quét",
    m_action_point_tips = "Kiến trúc thu hồi hiện tại tổng công cần tiến hành %d trận chiến, tổng cộng tiêu hao %d điểm thể lực, thể lực hiện tại của bạn không đủ để thu hồi hoàn chỉnh kiến trúc này, xác định muốn tiếp tục không?",
    m_map_title_step = "Hoàn thành %d/%d",
    m_warning = "Cảnh báo",
    m_add_training_card = "Thêm đồng đội huấn luyện",
    m_no_open = "Tạm thời chưa mở",
    m_open_condition = "Đạt cấp %d mở",
    m_stop_training = "Ngừng huấn luyện",
    m_stop_training_tips = "Ngừng huấn luyện chỉ có thể nhận một phần EXP, không trả lại vàng tiêu hao còn dư.",
    m_speed_training = "Hoàn thành ngay",
    m_speed_training_tips = "Hoàn thành ngay lần huấn luyện này sẽ nhận hết EXP ngay, nhưng sẽ tiêu hao %d Xu, xác định chứ?",
    m_speed_training_free = "Số lần tăng tốc miễn phí hôm nay còn lại 1 lần, xác định dùng chứ?",
    m_free_times = "Số lần tăng tốc miễn phí hôm nay: %d",
    m_retreat_warning = "Rút lui xong cần càn quét lại từ đầu, xác định rút lui?",
    m_activity_retreat_warning = "Rút lui xong cần chiến đấu lại từ đầu, xác định rút lui?",
    m_auto_battle_finish = "Càn quét xong!",
    m_action_point_not_enough = "Thể lực không đủ!",
    m_sel_strengthen_equip = "Hãy chọn trang bị cần cường hóa!",
    m_auto_battle_failed = "Càn quét chiến đấu thất bại!",
    m_equip_lv_is_max = "Trang bị đạt cấp độ tối đa!",
    m_combat_is_not_enough = "Càn quét cần %d lực chiến",
    m_low_probability = "Tỉ lệ thấp",
    m_rebattle_count = "Số lần：%d/%d",
    m_normal_chapter = "Chọn chương",
    m_difficult_chapter = "Ải Tinh Anh",
    m_error_tips_title = "Nhắc nhở lỗi",
    m_lock_str = "Khóa định",
    m_unlock_str = "Mở khóa",
    m_metal_not_enough = "Sắt không đủ, cần %d Sắt",
    m_food_not_enough = "Thức ăn không đủ, cần %d thức ăn",
    m_crystal_not_enough = "Năng tinh không đủ, cần %d Năng tinh",
    m_lv_is_max = "Đạt cấp độ tối đa!",
    m_master_is_max = "Số lượng đồng đội chủ chiến đạt giới hạn!",
    m_substitute_is_max = "Số lượng đồng đội thay thế đạt giới hạn",
    m_onclick_team_pos = "Xin nhấp vị trí chọn đồng đội trong trận hình!",
    m_equip_pos_no_open = "Vị trí trang bị chưa mở!",
    m_master_at_least_one = "Có ít nhất một đồng đội chủ chiến!",

    m_vip_1 = "",

    m_team_pos_no_open = "Vị trí biên đội chưa mở",

    m_add_arena_time = "Xác định mua số lần chiến đấu đấu trường?",
    m_open_position = "Bạn xác định dùng %d Xu mở vị trí huấn luyện mới?",
    m_exit_info = "Gạch bỏ xong sẽ thoát ra, xin mở lại game",
    m_session_invalid = "Đăng nhập có vấn đề, xin mở lại game",

    world_boss_push_text = "Người khổng lồ công thành còn 5 phút nữa bắt đầu! Phần thưởng hấp dẫn, không thể bỏ lỡ.",
    action_point_push_text = "Thể lực đã hoàn toàn hồi phục, tiếp tục chiến đấu, đừng ngơi nghỉ nhé!",
    live_push_text = "Vật tư sinh tồn bắt đầu phát rồi! Mau đăng nhập nhận miễn phí, thời gian có hạn không thể bỏ lỡ.",
    tomorow_push_text = "Tin tốt - bây giờ đăng nhập có thể nhận miễn phí thẻ Cam「Songoku」",
    active_live = "Thử Thách Sinh Tồn lại bắt đầu rồi, mau đi xem thử nào!",

    m_open_text = "Khoa học bùng nổ dùng hang bọ du lịch làm biểu tượng đã mang đến thời đại hoàng kim mới, \ncon người cuối cùng đã phát hiện ra sự tồn tại của vũ trụ cùng cấp, \n vẫn còn rất nhiều nền văn minh khác trong nghìn vạn vũ trụ. \n Nhưng nguy cơ cũng theo đó mà đến, một loại virus zombie ở vũ trụ 301 đã\n đột phá giới hạn vũ trụ cùng cấp, lan tỏa trong không gian đa chiều. \n Toàn bộ nền văn minh đối mặt với tai họa tột đỉnh. \n Virus này được đặt tên là “Làn Sương Xám”. \n Bạn, là anh hùng của đợt thứ hai đến vũ trụ 301 tìm đường cứu vớt. ",

    --[[
        排序：進階過的，等級大於10的，藍色以上的
        1-3     出售卡牌
        4-6     技能升級
        7-8     夥伴進階    只考慮進階了和等級大於10的
        9-10    夥伴分解    只考慮進階了和等級大於10的
    ]]
    m_seecial_tips_1 = "%s（LV.%d）là một đồng đội cao cấp tiến hóa đến +%d, trong phân giải đồng đội đổi Bụi cường năng, bạn xác định tiếp tục bán chứ?",
    m_seecial_tips_2 = "%s（LV.%d）là một đồng đội cao cấp, trước khi bán, bạn trong kế thừa đồng đội mang EXP của hắn truyền cho đồng đội khác có thể giảm thiểu tổn thất.",
    m_seecial_tips_3 = "%s（LV.%d）là một thẻ bài phẩm chất %s, trong phân giải đồng đội đổi Bụi cường năng hoặc làm nguyên liệu tiến hóa đồng đội rất có giá trị, bạn xác định tiếp tục bán chứ?",

    m_seecial_tips_4 = "%s（LV.%d）là một đồng đội cao cấp tiến hóa đến +%d, khi làm nguyên liệu nâng cấp hiệu quả giống với đồng đội chưa tiến hóa, nhưng bạn có thể nhận thêm bụi siêu năng và bụi cường năng. Bạn xác định dùng chứ?",
    m_seecial_tips_5 = "%s（LV.%d）là một đồng đội cấp cao, trước khi nâng cấp kĩ năng, bạn trong truyền thừa đồng đội mang EXP của hắn cho đồng đội khác có thể giảm thiểu tổn thất.",
    m_seecial_tips_6 = "%s（LV.%d）là một thẻ bài phẩm chất %s, trong phân giải đồng đội đổi bụi cường năng hoặc làm nguyên liệu tiến hóa đồng đội rất có giá trị, bạn xác định tiếp tục làm nguyên liệu nâng cấp chứ?",

    m_seecial_tips_7 = "%s（LV.%d）là một đồng đội cao cấp tiến hóa đến +%d, khi làm nguyên liệu tiến hóa hiệu quả giống với đồng đội chưa tiến hóa, nhưng bạn có thể nhận thêm bụi siêu năng và bụi cường năng. Bạn xác định dùng chứ?",
    m_seecial_tips_8 = "%s（LV.%d）là một đồng đội cấp cao, trước khi tiến hóa đồng đội, bạn trong truyền thừa đồng đội mang EXP của hắn cho đồng đội khác có thể giảm thiểu tổn thất.",

    m_seecial_tips_9 = "%s（LV.%d）là một đồng đội cao cấp tiến hóa đến +%d, có thể cung cấp lực chiến rất nhiều cho bạn, xác định muốn tiếp tục phân giải chứ?",
    m_seecial_tips_10 = "%s（LV.%d）là một đồng đội cấp cao, trước khi phân giải, bạn trong truyền thừa đồng đội mang EXP của hắn cho đồng đội khác có thể giảm thiểu tổn thất.",
    m_remove_apprentice = "Xác định muốn đá học trò này?",

    pirate_enter_tip = "\t\tTìm báu vật bắt đầu xong không thể sửa trận hình\n\t\tChiến đấu kết thúc xong lượng HP không hồi phục",
    pirate_buff_tip = "Tăng BUFF thành công",
    pirate_box_tip = "Chọn báu vật của bạn!",
    pirate_text_1 = "Hiệu quả",
    pirate_text_2 = "Tỉ lệ nhận được",
    pirate_text_increase = "Tăng",
    pirate_hp = "% HP",
    pirate_patk = "% vật công",
    pirate_matk = "% ma công",
    pirate_def = "% phòng ngự",
    pirate_speed = "% tốc độ",

    topplayer_info1 = "Trải qua một phen khổ chiến, WINER đã thắng LOSER",
    topplayer_info2 = "LOSER bị WINER đánh tơi bời hoa lá",
    topplayer_info3 = "WINER ra đòn dứt điểm, LOSER đánh không lại bỏ chạy",
    topplayer_info4 = "WINER cười lớn ba tiếng, quay người tung cước đá bay LOSER",
    topplayer_info5 = "LOSER kêu lớn「Ta sẽ trở lại！」rồi phi thân bay đi",

    m_topplayer_unnowname = "Người chơi thần bí",
    m_topplayer_noguild = "Không",


    friend_recive_add_friedn_tips = "PLAYER gửi lời mời kết bạn cho bạn",
    friend_send_add_friedn_tips = "Thành công gửi lời mời kết bạn cho PLAYER",
    friend_send_hadadd_friedn_tips = "Bạn đã gửi qua lời mời kết bạn tới PLAYER",
    friend_beAdd_friend = "PLAYER đã đồng ý kết bạn với bạn, hai người đã thành bạn bè, mau nói chuyện thân mật đi?",
    friend_hadbeen_friedn_tips = "Thêm PLAYER thành bạn bè thành công",


    guild_hadjoined__tips = "Bạn đã vào liên minh GUILD",
    guild_send_invite_tips = "Thành công gửi lời mời vào liên minh tới PLAYER",

    -- friend_send_add_friedn_tips = "Thành công gửi lời mời kết bạn cho PLAYER",
    -- friend_send_add_friedn_tips = "Thành công gửi lời mời kết bạn cho PLAYER",
    game_ability_commander_snatch_001 = "Bạn đã mở chức năng bảo vệ, phát động cướp đoạt sẽ hủy chức năng bảo vệ, tiếp tục cướp đoạt chứ?",
    game_lucky_turntable_001 = "Còn lại: %d lần",
    game_lucky_turntable_002 = "%d Xu",    game_lucky_turntable_002 = "%d Xu",    game_lucky_turntable_002 = "%d Xu",
    game_lucky_turntable_003 = "Tạo mới thành công!",
    game_lucky_turntable_004 = "Còn lại: %d",
    game_challange_active1 = "Vui lòng chờ đợi",
    game_challange_active2 = "Cứ điểm bảo vệ tháng 8 chưa mở",
    game_world_reward = "Phần thưởng",  -- 奖励
    game_world_table_refresh = "Kéo xuống tạo mới dữ liệu",  -- 下拉刷新数据
    game_msg_not_send_reward = "Chưa mở thưởng",  -- 尚未开奖
    game_msg_noone_get_reward = "Chưa có người chơi nhận được giải thưởng Xu Chén Lửa",  -- 尚未有玩家获得火焰杯钻石大奖
    game_msg_reward_count = "Mở thưởng còn",  -- 开奖倒计时
    game_msg_fire_count = "FIRE còn",  -- FIRE倒计时

    badge_tx_1 = "Hiện tại nhân vật này không thể trang bị Huy Hiệu2",
    badge_tx_2 = "Vui lòng chọn huy hiệu trước khi thực hiện thao tác khác",
    badge_tx_3 = "Mở khóa thành công",
    badge_tx_4 = "Tinh luyện thành công",
    badge_tx_5 = "Chất lượng Tinh luyện hiện tại là Giai Ban Sức A, bạn có muốn làm mới tiếp không?",
    badge_tx_6 = "Bạn có thể dùng %s Kim Cương và %s Huy Hiệu Đột Phá để mở khóa ô Tinh Luyện Vận Mệnh mới, có muốn mở khóa không?",
}

function string_config.getTextByKey(self,key)
    return self[tostring(key)] or "";
end

function string_config.getTextByKeyAndReplaceOne(self,key, rkey, rvalue)
    local text = self[tostring(key)] or ""
    if  type(rkey) == "string" and type(rvalue) =="string" then
        text = string.gsub(text, rkey, rvalue)
    end
    return text 
end

function string_config.getTextByKeyAndReplace(self,key, ...)
    local args = {...}
    if #args <=2 then return self:getTextByKeyAndReplaceOne(key,args[1], args[2]) end
    local text = self[tostring(key)] or ""
    local patt = nil
    local info = {}
    for i=1, #args - 1, 2 do
        if  type(args[i]) == "string" and type(args[i + 1]) == "string" then
            if not patt then patt = "[" else patt = patt .. "," end
            info[args[i]] = args[i+1]
            patt = patt .. args[i]
        end
    end
    patt = patt and patt .. "]+" 
    if patt then
        text = string.gsub(text, patt, function ( key )
            return info[key] or key
        end)
    end
    return text
end

return string_config;  *>