--- 網絡請求url

-- service_url = "http://dev.kaiqigu.net/genesis";--測試地址
-- battle_royale_service_url = "http://pub.kaiqigu.net/genesis";--測試地址

-- local domain ="http://pub.kaiqigu.net/genesis"
-- local service_url = domain.."/api";--測試地址
-- local login_service_url = domain.."/login";--測試地址
-- local battle_royale_service_url = domain.."/dataosha";--測試地址
-- local config_service_url = domain.."/config";

-- local service_url = "http://localhost:8888/api"
local device_mark = tostring(util_system:macAddres()); -- mac 地址
local platform_channel = tostring(util_system:getPlatformChannel()); -- 平台渠道號
user_token = ""; -- 測試用
mark_user_login_mk = "";
device_platform = "";
rand_str = ""

-- local domain ="http://pub.kaiqigu.net/genesis"
-- local service_url = domain.."/api";--測試地址
-- local login_service_url = domain.."/login";--測試地址
-- local battle_royale_service_url = domain.."/dataosha";--測試地址
-- local config_service_url = domain.."/config";

--[[--
    game_url:
        遊戲邏輯接口，訪問的是各個應用服務器，沒有固定域名和ip
    dataosha_url_config:1
        訪問團戰服務器，沒固定域名和ip
    login_url_config:
        用於登錄的服務器，域名和ip基本不變（不保證
        sdk的登錄和付費都放在login_url_config表中
]]

local game_url = {
    --越南里要走api服务器，台湾的要走master服务器
    pay_kubi = "/api/?method=payment.pay",--蘋果支付

    private_city_open = "/api/?method=private_city.open",--city=101
    test_battle = "/api/?method=battle.start",          -- 测试 
    config_all_config = "/api/?method=config.all_config", --配置接口 config_name=map  参数config_name可缺省
    private_city_recapture = "/api/?method=private_city.recapture", -- 收复建筑接口 &city=101&buiding=101004&step_n=1
    user_loading = "/api/?method=user.loading",--
    cards_open = "/api/?method=cards.open",--背包
    cards_set_alignment = "/api/?method=cards.set_alignment",--更改阵型  align_1=1_2&align_2=3_4
    user_main_page = "/api/?method=user.main_page",--主界面接口
    cards_set_formation = "/api/?method=cards.set_formation",--改变阵型&formation=1

    leader_skill_open = "/api/?method=leader_skill.open",--避难所技能
    leader_skill_train = "/api/?method=leader_skill.train",--避难所技能学习skill=101   接口满级：is_max=1
    leader_skill_add_tree_point = "/api/?method=leader_skill.add_tree_point", --技能树加点儿 tree=1
    leader_skill_wash_down = "/api/?method=leader_skill.wash_down", --主角技洗白 tree=1
    harbor_set_skill = "/api/?method=leader_skill.set_skill",--避难所技能替换skill_1=101&skill_2=102&skill_3=103
    harbor_train_force = "/api/?method=leader_skill.train_force",--技能升级加速 -- harbor.train_force&stove_name=stove_1

    user_havest = "/api/?method=user.havest",--资源收取
    cards_card_skill_levelup = "/api/?method=cards.card_skill_levelup",--技能强化 -- major=100&metal=101&
    laboratory_open = "/api/?method=laboratory.open",--研究所
    laboratory_finish = "/api/?method=laboratory.finish",--研究所  领取 stove_key=stove_1
    laboratory_level_up_force = "/api/?method=laboratory.level_up_force",--研究所   加速 stove_key=stove_1
    laboratory_level_up = "/api/?method=laboratory.level_up",--研究所  card_id=1&type=def
    laboratory_cancle = "/api/?method=laboratory.cancle",--研究所  取消培养 stove_key=stove_1
    laboratory_wash_down = "/api/?method=laboratory.wash_down",--研究所  能晶摘除 card_id=1
    school_open = "/api/?method=school.open",--学校
    school_train = "/api/?method=school.train",--学校训练  stove_key=stove_1&train_type=1&train_time=1&card_id=2
    school_get_exp = "/api/?method=school.get_exp",--学校领取经验  stove_key=stove_1
    school_get_exp_force = "/api/?method=school.get_exp_force",--学校加速领取经验  stove_key=stove_1
    gift_curt_city_gift = "/api/?method=gift.curt_city_gift",--宝箱 city=
    gift_receiving_gift = "/api/?method=gift.receiving_gift",--领取宝箱gift=101
    school_eat_card = "/api/?method=school.eat_card",-- 技能传承 majoy=1&food=2&skill=s_1  majoy: 主卡id  food: 被吃卡id  skill: 要进化的技能id（s_1, s_2, s_3)
    cards_card_strong = "/api/?method=cards.card_strong",--卡牌进阶(升星)  major=主卡id&metal=材料卡id
    cards_active_skill = "/api/?method=cards.active_skill",--卡牌技能激活 skill_key=s_2&card_id=1
    cards_wash_skill = "/api/?method=cards.wash_skill",--卡牌技能重置 skill_1=1&skill_2=1&skill_3=1&card_id=1&eat_card_id_1=2&eat_card_id_2=3
    equip_all_equip = "/api/?method=equip.all_equip",--装备背包
    factory_factory_all = "/api/?method=factory.factory_all",--工厂
    factory_equip_make = "/api/?method=factory.equip_make",--装备制造  & metal_1=背包id & metal_2=背包id & metal_3=背包id & site=格子id & magor = 要制造装备的配置id
    factory_equip_levelup = "/api/?method=factory.equip_levelup",--升级装备 factory.equip_levelup&magor=升级装备背包id
    factory_completion_equip = "/api/?method=factory.completion_equip",--收取已经制造好的装备 site=制造位id

    factory_cancel_make = "/api/?method=factory.cancel_make",--装备撤销 site=制造位id
    factory_quick_make = "/api/?method=factory.quick_make",--装备加速 site=制造位id

    gacha_get_gacha = "/api/?method=gacha.get_gacha",--gacha  gacha_type=gacha_id
    gacha_get_all_gacha = "/api/?method=gacha.get_all_gacha",--gacha

    equip_gacha_get_all_gacha = "/api/?method=equip_gacha.get_all_gacha",--抽装备
    equip_gacha_get_gacha = "/api/?method=equip_gacha.get_gacha",-- 抽    gacha_type=gacha_id
    public_city_open = "/api/?method=public_city.open",--公共地图，打开城市 city_id=10001
    public_city_building_info = "/api/?method=public_city.building_info",--建筑信息 city_id=10001&building_id=1001
    public_city_attack = "/api/?method=public_city.attack",--攻击接口 city_id=10001&building_id=1001

    association_guild_all = "/api/?method=association.guild_all",--公会列表
    association_guild_create = "/api/?method=association.guild_create",--创建公会  name = 工会名&icon ＝ 图标
    association_guild_detail = "/api/?method=association.guild_detail",--工会详情  guild_id = 工会id
    association_add_notice = "/api/?method=association.add_notice",--编辑公会公告  notice=hihihi
    association_get_player_detail = "/api/?method=association.get_player_detail",-- 工会中的玩家信息  user_id＝玩家id
    association_guild_join = "/api/?method=association.guild_join",-- 申请加入工会  guild_id ＝ 工会id
    association_guild_agree = "/api/?method=association.guild_agree",-- 同意申请    user_id ＝ 玩家id
    association_guild_not_agree = "/api/?method=association.guild_not_agree",-- 拒绝申请    user_id ＝ 玩家id
    association_appoint_player = "/api/?method=association.appoint_player",-- 任命职务   position ＝ 0,1,2（0,解除职务会长不能解除自己，1,任命为会长，2,任命为副会长最多两个）  user_id ＝ 玩家id
    association_remove_player = "/api/?method=association.remove_player",-- 移除玩家    user_id ＝ 玩家id
    association_guild_destroy = "/api/?method=association.guild_destroy",-- 移除公会
    association_set_default = "/api/?method=association.set_default",-- 设置默认科技 science_id＝科技名
    association_develop_science = "/api/?method=association.develop_science",-- 开发科技 food＝钻石数
    association_buy_commodity = "/api/?method=association.buy_commodity",-- 兑换物品 commodity_id＝商品id
    association_shop = "/api/?method=association.shop",     -- 公会商店
    association_dedicate = "/api/?method=association.dedicate",     -- 公会捐献 &type=捐献类型（food, energy, metal, war_flag）&amount=100
    association_levelup = "/api/?method=association.levelup",       -- 公会科技升级 &flag=(guild_lv,shop_lv,map_lv,boss_lv,gvg_player_lv,gvg_monster_lv,gvg_home_lv)
    association_guild_quit = "/api/?method=association.guild_quit",--退出公会
    association_guild_search = "/api/?method=association.guild_search",--搜索公会  name = 
    association_rename = "/api/?method=association.rename",--联盟改名  name = 
    association_add_msg = "/api/?method=association.add_msg", --添加留言   msg = “消息”  
    association_flush_msg = "/api/?method=association.flush_msg", --刷新留言

    guild_fight_reward = "/api/?method=association.guild_fight_reward",--公会战捐献奖励   reward_id

    association_game_list = "/dataosha/?method=game_list",          -- 公会战列表
    association_join_war = "/dataosha/?method=join_game",           -- 加入一个公会战 &game_id=(1,2,3,4)
    association_war_active = "/dataosha/?method=attack",            -- 公会战中行动消息 round_id=回合数 x=坐标x y=坐标y game_id=战场id
    association_flag_rank = "/dataosha/?method=rank",               -- 获得捐旗子排名 game_id=(1,2,3,4)
    association_con_flag = "/dataosha/?method=donate",              -- 公会长捐献旗子 game_id=(1,2,3,4) flag=要捐献的数量
    association_start_battle = "/dataosha/?method=open_battle_test",-- 临时接口开始公会战 game_id


    daily_award_all_reward = "/api/?method=daily_award.all_reward",-- 全部礼包
    daily_award_get_reward = "/api/?method=daily_award.get_reward",-- 获得礼包  reward＝礼包id（可多个）


    all_config = "/config/?method=all_config",--

    item_view = "/api/?method=item.view",
    item_exchange = "/api/?method=item.exchange",--碎片弹出框  change_id =  count = 1默认是1
    item_use = "/api/?method=item.use",
    item_sell = "/api/?method=item.sell",
    private_city_world_map = "/api/?method=private_city.world_map",

    arena_index = "/api/?method=arena.index", --竞技场数据
    arena_exchange = "/api/?method=arena.exchange", -- 竞技场兑换物品
    arena_battle = "/api/?method=arena.battle",  --竞技场挑战     target=uid&rank=100
    arena_log = "/api/?method=arena.log",    -- 战报
    arena_replay = "/api/?method=arena.replay",   -- 战报回放
    arena_top = "/api/?method=arena.top", -- 竞技场排行榜     page=1

    shop_buy = "/api/?method=shop.buy", -- shop_id=1
    shop_open = "/api/?method=shop.open", -- 
    user_guide = "/api/?method=user.guide", -- guide_team=1&guide_id=5
    user_rename = "/api/?method=user.rename", -- show_name=名字
    user_change_name = "/api/?method=user.change_name", -- name=名字

    friend_send_message = "/api/?method=friend.send_message", -- 给好友发消息 target_id=test1&content=dddd
    friend_del_message = "/api/?method=friend.del_message", -- 删除消息 message_id=43
    friend_battle = "/api/?method=friend.battle", -- 向好友发起挑战 target_id=test1
    friend_search = "/api/?method=friend.search", -- 搜索 target_id=test1
    pay_kubi = "/api/?method=payment.pay",
    
    qiku_pay = "/api/?method=payment.qiku_pay",
    get_qiku_balance = "/api/?method=payment.get_qiku_balance",

    reward_index = "/api/?method=reward.index",--任务列表
    reward_daily_award = "/api/?method=reward.daily_award",--每日任务奖励 award_id = 1
    reward_once_award = "/api/?method=reward.once_award",--主线任务奖励  award_id = 1     ---现在变成领奖接口了
    grow_gift_index = "/api/?method=active.grow_gift_index", -- 成长计划 主页 active.grow_gift_receive
    grow_gift_receive = "/api/?method=active.grow_gift_receive", -- 领取成长计划奖励   参数: lv grow_gift配置中得id
    reward_once_index = "/api/?method=reward.once_index", --进入成就
    code_index = "/api/?method=code.index",--激活码
    code_use_code = "/api/?method=code.use_code",--激活码使用 code = ssdsda
    user_info = "/api/?method=user.info", -- 玩家信息 uid=test
    cards_release_card = "/api/?method=cards.release_card", -- card_id= 释放锁
    cards_lock_card = "/api/?method=cards.lock_card", -- card_id= 锁卡
    cards_butcher = "/api/?method=cards.butcher", -- card_id= 卖卡

    active_index = "/api/?method=active.index", --active首页
    active_fight = "/api/?method=active.fight", --做活动 chapter=1&active_id=1&step_n=1
    active_kfhd_index = "/api/?method=reward.opening_index",  -- 开服活动首页
    active_kfhd_getreward = "/api/?method=reward.opening_award", -- 开服奖励领取奖励
    clear_fight_log = "/api/?method=active.clear_fight_log",--放弃当前活动
    equip_sell = "/api/?method=equip.sell", --卖装备 equip=1
    private_city_auto_recapture = "/api/?method=private_city.auto_recapture", --自动扫荡 city=101&building=101002

    vip_guide_isbuy = "/api/?method=shop.vip_guide_step", -- 消费计划 物品项被购买多少次
    vip_guide_buy = "/api/?method=shop.vip_guide_buy",  -- 消费项目
    level_gift_buy = "/api/?method=user.level_award", -- 等级礼包购买

    buy_cmdr_energy = "/api/?method=vip.buy_cmdr_energy",--购买精力
    buy_commbander_protect = "/api/?method=vip.buy_commbander_protect",--买保护罩

    cards_exchange = "/api/?method=cards.exchange", --卡牌分解 card_id=3801-1390744710-sBcv5T   
    cards_inherit = "/api/?method=cards.inherit",--伙伴传承 master=901-1390745387-RdIyhh&student=70300-1392366806-kWk7CI  加了参数use_exp_ball=1    传承和被传承的英雄Id
    cards_open_dirt_shop = "/api/?method=cards.open_dirt_shop",--卡牌商店 
    cards_refresh_dirt_shop = "/api/?method=cards.refresh_dirt_shop",--卡牌商店刷新
    cards_dirt_shop_buy = "/api/?method=cards.dirt_shop_buy",--购买卡牌   shop_id=3
    world_boss_index = "/api/?method=world_boss.index",--世界Boss
    public_city_index = "/api/?method=public_city.index",--中立地图列表
    world_boss_fight = "/api/?method=world_boss.fight",--打世界Boss    boss_id = 1
    pay_award_index = "/api/?method=pay_award.index",--周充值、月充值奖励  nil 

    guildboss_index = "/api/?method=association.guildboss_index",--公会boss
    guildboss_fight = "/api/?method=association.guildboss_fight",--打公会boss
    guildboss_revive = "/api/?method=association.guildboss_revive",--公会boss复活

    user_online_award = "/api/?method=user.online_award",--领取在线奖励 nil 
    reward_gift_award = "/api/?method=reward.gift_award",--领取物资  award_id = 1
    equip_evolution = "/api/?method=equip.evolution",--装备进阶  equip_id=22
    notify_messages = "/api/?method=notify.messages",--获取消息
    notify_messages_auto_read = "/api/?method=notify.auto_read",-- 一键领取
    notify_read = "/api/?method=notify.read",--阅读消息  message_id=1392972040_0

    rank_combat = "/api/?method=user.top_combat",  -- 战力排行榜
    rank_level = "/api/?method=user.top_level",   -- 等级排行榜
    rank_boss = "/api/?method=user.top_world_boss_hurt",   -- boss排行
    
    reward_index = "/api/?method=reward.index",--查看wantend
    wanted_award = "/api/?method=reward.wanted_award",--领取wanted奖励  arard_id = 1

    inactivate_daily_task = "/api/?method=reward.inactivate_daily_task",--放弃每日悬赏任务 award_id = 9
    refresh_daily_task = "/api/?method=reward.refresh_daily_task",--刷新每日悬赏
    activate_daily_task = "/api/?method=reward.activate_daily_task",--激活（接受）每日悬赏 award_id = 9
    daily_score_award = "/api/?method=reward.daily_score_award",--领取daily score     score=50    5,10,15,25

    get_award = "/api/?method=pay_award.get_award",--领取周/月礼包
  
    forever_fight = "/api/?method=active.forever_fight",--生存大挑战 战斗   level=1
    auto_forever_fight = "/api/?method=active.auto_forever_fight",--生存大挑战 突进  
    cards_melting = "/api/?method=cards.cards_exchange",--卡牌合成 参数  exchange_id=1&card_ids='51'&card_ids='51'&card_ids='51'&card_ids='51'&card_ids='51'

    --Vip相关接口
    buy_fight_times = "/api/?method=active.buy_fight_times",--购买活动次数        chapter=1
    clear_sweep_log = "/api/?method=private_city.clear_sweep_log",--重置 扫荡记录  city=101&building=101002
    world_boss_revive = "/api/?method=world_boss.revive",--world_boss 快速复活
    fast_finish_daily_award = "/api/?method=reward.fast_finish_daily_award",--快速完成每日任务
    vip_open_stove = "/api/?method=school.vip_open_stove",--vip 开启 训练位置      stove_key=stove_3
    arena_buy_count = "/api/?method=arena.buy_count",--购买竞技场战斗次数
    shop_vip_buy = "/api/?method=shop.vip_buy",--vip特权礼包    shop_id=4   nil 是进入的
    cards_card_evolution = "/api/?method=cards.card_evolution",  --卡牌进阶 major=主卡id&metal=材料卡id
    buy_point = "/api/?method=vip.buy_point",--购买行动力

    vip_buy_step = "/api/?method=shop.vip_buy_step", --查看vip礼包买到第几个了
    -- 刷新用户基础信息请求
    user_refresh = "/api/?method=user.refresh",
    reward_diary_index = "/api/?method=reward.diary_index",--每日任务 
    reward_diary_score_award = "/api/?method=reward.diary_score_award",--每日领奖 score=

    -- 小伙伴
    cards_activate_assistant = "/api/?method=cards.activate_assistant",     -- 小伙伴开格子 {position=0}

    commander_index = "/api/?method=commander.index",--统帅首页
    commander_synthesis = "/api/?method=commander.synthesis",--配方合成  recipe=1
    commander_search = "/api/?method=commander.search",--查看可抢夺的对手  item_id=6531
    commander_rob = "/api/?method=commander.rob",--抢夺 target_uid=robot_100&item_id=6101
    commander_protect = "/api/?method=commander.protect",--保护
    commander_quick_rob = "/api/?method=commander.quick_rob",--快速抢夺npc  &target_uid=robot_100&item_id=6101

    active_top = "/api/?method=active.top",--生存大考验 排行榜
    equip_st_levelup = "/api/?method=equip.st_levelup",--装备精炼 equip_id=1  sort=0 0或不传默认普通精炼，1高级精炼
    equip_exchange = "/api/?method=equip.exchange",--装备分解 equip_id=193&equip_id=193&
    
    shop_outlets_open = "/api/?method=shop.outlets_open",--限量商城
    shop_outlets_buy = "/api/?method=shop.outlets_buy",--shop_id=1
    daily_award_coin_award = "/api/?method=daily_award.coin_award",--充值领奖
    
    user_watch_pay_award = "/api/?method=user.watch_pay_award",--内测充值查看
    user_get_pay_award = "/api/?method=user.get_pay_award",--内测充值领取奖励
    public_city_rob_log = "/api/?method=public_city.rob_log",--中立地图战报

--离线派遣
    offline_dispatch_index = "/api/?method=offline_dispatch.index",
    offline_dispatch_set_alignment = "/api/?method=offline_dispatch.set_alignment", -- 设置派遣的卡牌boss_id: 1 选择的boss align: 9100-1-1_9100-1-1 派遣的卡
    offline_dispatch_expand_store = "/api/?method=offline_dispatch.expand_store", --扩充仓库
    offline_dispatch_receive_store = "/api/?method=offline_dispatch.receive_store", --一键收取
    offline_dispatch_fight = "/api/?method=offline_dispatch.fight", --战斗 参数 boss_id: 1 选择的boss degree: 1 难度
    offline_dispatch_cancel_fight = "/api/?method=offline_dispatch.cancel_fight", --结束战斗 boss_id: 1 选择的boss

    talentskill_index = "/api/?method=talent_skill.index", --伙伴天赋
    talentskill_traincardtalent = "/api/?method=talent_skill.train_card_talent", --天赋升级  参数  1为升级五次   无参数 为升级一次


    all_equip_levelup_auto = "/api/?method=equip.all_equip_levelup_auto",--装备一键强化
    search_treasure_st_open = "/api/?method=search_treasure.st_open",--开启罗杰的宝藏地图  treasure = 1
    search_treasure_recapture = "/api/?method=search_treasure.recapture",--罗杰的宝藏打NPC 打人也是   treasure=1&city=1&building=1&step_n=1
    search_treasure_open_building = "/api/?method=search_treasure.open_building",--打开人物信息   building=510006&city=1&treasure=1
    search_treasure_open_building_gifts = "/api/?method=search_treasure.open_building_gifts",--打开宝物信息 treasure=1&city=10001&building=510024
    search_treasure_open_building_buff = "/api/?method=search_treasure.open_building_buff",--打开buff信息 treasure=1&city=10001&building=510024
    search_treasure_add_gifts = "/api/?method=search_treasure.add_gifts",--获得宝物  treasure=1&city=10001&building=510024&gift_idx=0&gift_idx=2
    search_treasure_add_buff = "/api/?method=search_treasure.add_buff",--增加buff  treasure=1&city=10001&building=510024
    search_treasure_recover_hp = "/api/?method=search_treasure.recover_hp",--罗杰恢复血量 treasure=1
    search_treasure_map_fight_and_enemy = "/api/?method=search_treasure.map_fight_and_enemy",--查看NPC的 building=510006&city=1&treasure=1
    search_treasure_recover_times = "/api/?method=search_treasure.recover_times",--罗杰的宝藏购买次数 
    association_rescue_index = "/api/?method=association.rescue_index",--救援界面
    search_treasure_help_treasure = "/api/?method=search_treasure.help_treasure",--死亡后求助
    search_treasure_help_recapture = "/api/?method=search_treasure.help_recapture",--救援进入战斗 help_uid=h17247506&help_time=help_time&step_n=0
    battle_challenge_info = "/api/?method=battle.challenge_info",--宝藏入口

    new_user = "/login/?method=new_user",--用户注册 role=1  account ＝ 
    mark_user_login = "/login/?method=mark_user_login",--

    user_request_code_index = "/api/?method=user.request_code_index",--邀请码 首页
    user_search_master = "/api/?method=user.search_master",-- 拜师  master=h19709641 
    user_request_code_gift = "/api/?method=user.request_code_gift",-- 领取奖励 tp=master&slave=h1993  tp :  master/slave  # 师傅奖励/徒弟奖励  slave: 如果tp为slave  需传递徒弟uid
    top_gacha_score = "/api/?method=user.top_gacha_score",--gacha 排行 page=0
    top_world_boss_hurt = "/api/?method=user.top_world_boss_hurt",--boss排行榜 page=0
    get_reward_gacha = "/api/?method=gacha.get_reward_gacha",--限时神卡 进入
    do_reward_gacha = "/api/?method=gacha.do_reward_gacha",--限时神卡   抽卡    reward_gacha_id=1
    integration_index = "/api/?method=active.integration_index",--限时积分   进入
    private_city_hard_open = "/api/?method=private_city.hard_open",  -- 精英关卡进入接口
    city_hard_recapture = "/api/?method=private_city.hard_recapture",  -- 精英关卡收复接口
    integration_shop = "/api/?method=active.integration_shop", -- 积分商城入口
    integration_exchange = "/api/?method=active.integration_exchange", -- 积分商城入口  &shop_id=1     # 积分兑换
    private_city_get_world_reward = "/api/?method=private_city.get_world_reward", -- 世界积分领奖 level=1
    private_city_world_score = "/api/?method=private_city.world_score",-- 世界积分

    active_active_show = "/api/?method=active.active_show",--充值活动
    active_consume_receive = "/api/?method=active.active_consume_receive",--消耗活动  active_id = 1
    active_recharge_receive = "/api/?method=active.active_recharge_receive",--充值活动领取奖励 active_id = 1
    super_active_index = "/api/?method=super_active.index",--超级赛亚人归来
    super_active_get_all_reward = "/api/?method=super_active.get_all_reward",--赛亚人阶段奖励 step = 1
    super_active_get_rich_reward = "/api/?method=super_active.get_rich_reward",--tp: 类型  reward_12|reward_21|reward_24 赛亚人奖励

    server_super_active_index = "/api/?method=server_super_active.index",--超级赛亚人归来
    server_super_active_get_all_reward = "/api/?method=server_super_active.get_all_reward",--赛亚人阶段奖励 step = 1
    server_super_active_get_rich_reward = "/api/?method=server_super_active.get_rich_reward",--tp: 类型  reward_12|reward_21|reward_24 赛亚人奖励
     
    private_city_auto_sweep_building ="/api/?method=private_city.auto_sweep_building", --获取可自动战斗的建筑列表
    guildboss_open = "/api/?method=association.guildboss_open",--开启公会boss  try_open=0   1是开启，0是查看
    private_city_get_world_reward = "/api/?method=private_city.get_world_reward", -- 世界积分领奖
    hard_giveup = "/api/?method=private_city.hard_giveup", -- 重新开始
    equip_books = "/api/?method=equip.books",  -- 装备信息
    cards_books = "/api/?method=cards.books",--图鉴
    cards_card_break = "/api/?method=cards.card_break", -- 伙伴突破  card_id=2100-1400929451-jw1JSL
    buy_done_times = "/api/?method=private_city.buy_done_times",
    user_remove_slave = "/api/?method=user.remove_slave",-- 移除徒弟 uid = 

    association_guild_one = "/api/?method=association.guild_one",--搜索公会     ass_id=1
    loading = "/login/?method=loading",--
    loading_for_test = "/login/?method=loading_for_test",
    get_exchangecenter_list = "/api？method=omni_exchange.transform",
    omni_exchange_lastcount = "/api/?method=omni_exchange.show_omni_exchange_options",
    omni_exchange = "/api/?method=omni_exchange.omni_exchange",
    private_city_map_fight_and_enemy = "/api/?method=private_city.map_fight_and_enemy",--获取战斗相关配置 city = ,building = 
    active_map_fight_and_enemy = "/api/?method=active.map_fight_and_enemy",--获取战斗相关配置 chapter = ,active_id = step_n =

    
    playerboss_index = "/api/?method=arena.playerboss_index",  --             玩家BOSS 页面
    playerboss_fight = "/api/?method=arena.playerboss_fight",  --             玩家BOSS 战斗
    playerboss_award = "/api/?method=arena.playerboss_award",  -- &award_id=1    玩家BOSS 领奖
    playerboss_log ="/api/?method=arena.playerboss_log", -- 挑战日志
    commander_enemies = "/api/?method=commander.enemies",  -- 仇人列表
    server_limit_hero_index = "/api/?method=server_limit_hero.get_reward_gacha",--开服活动-----限时伙伴 index
    server_limit_hero_do = "/api/?method=server_limit_hero.do_reward_gacha",--开服 限时伙伴抽卡  reward_gacha_id=18

    friend_friends = "/api/?method=friend.friends", -- 好友列表friend_add_friend
    friend_add_friend = "/api/?method=friend.apply_friend", -- 添加好友 target_id=test1  message_id=111
    friend_remove_friend = "/api/?method=friend.remove_friend", -- 删除好友 target_id=test1 , message_all: bool值， 删除全部信息时传递
    friend_messages = "/api/?method=friend.messages", -- 好友消息列表
    friend_send_gift = "/api/?method=friend.send_gift", --好友赠送体力
    friend_apply_friend = "/api/?method=friend.apply_friend", --好友赠送体力
    friend_read_message = "/api/?method=friend.read_message",

    guild_invite = "/api/?method=friend.guild_invite", -- &target_id=xxx  -- 公会邀请
    roulette_index = "/api/?method=roulette.index", -- 转盘入口
    roulette_refresh = "/api/?method=roulette.refresh", -- 转盘刷新
    roulette_open_roulette = "/api/?method=roulette.open_roulette", -- 开启转盘
    roulette_open_roulette10 = "/api/?method=roulette.open_roulette10", -- 开启十次转盘
    server_roulette_index = "/api/?method=server_roulette.index", -- 转盘入口
    server_roulette_refresh = "/api/?method=server_roulette.refresh", -- 转盘刷新
    server_roulette_open_roulette = "/api/?method=server_roulette.open_roulette", -- 开启转盘
    server_roulette_open_roulette10 = "/api/?method=server_roulette.open_roulette10", -- 开启十次转盘

    book_equip_exchange = "/api/?method=book_exchange.equip_exchange",  -- 图鉴兑换
    show_equip_options = "/api/?method=book_exchange.show_equip_options", -- 装备兑换入口 装备兑换信息

    sacrifice_index = "/api/?method=sacrifice.index",--献祭入口
    sacrifice_open_sacrifice = "/api/?method=sacrifice.open_sacrifice",--献祭开启
    sacrifice_con_sacrifice = "/api/?method=sacrifice.con_sacrifice",--献祭继续
    sacrifice_high_sacrifice = "/api/?method=sacrifice.high_sacrifice",--高级献祭
    sacrifice_one_key_full = "/api/?method=sacrifice.one_key_full",--献祭一键全满
    sacrifice_harvest_grace = "/api/?method=sacrifice.harvest_grace",--收取
    sacrifice_one_key_sacrifice = "/api/?method=sacrifice.one_key_sacrifice",--一键献祭  times: 献祭次数  mode: 献祭方式 1 2 3 4
    sacrifice_open_shop = "/api/?method=sacrifice.open_shop",--兑换入口
    sacrifice_grace_exchange = "/api/?method=sacrifice.grace_exchange",--神恩兑换  shop_id 商店id  count  购买数量

    book_character_exchange = "/api/?method=book_exchange.character_exchange",  -- 卡牌图鉴兑换
    show_character_options = "/api/?method=book_exchange.show_character_options", -- 卡牌兑换入口 卡牌兑换信息
    super_active_index = "/api/?method=super_active.index", -- 神龙
    super_active_get_all_reward = "/api/?method=super_active.get_all_reward", -- 神龙领奖 step=1

    user_top_rank = "/api/?method=user.top_rank",--新排行榜  sort=purple_card&page=0   --紫/橙卡、收复度、统率、点赞、装备
    user_open_like = "/api/?method=user.open_like",--点赞 sort= rank_key=
    user_rank_one_cards_info = "/api/?method=user.rank_one_cards_info",-- 查看卡牌 sort= rank_key= uid=
    active_hero_star_reward = "/api/?method=active.hero_star_reward", --reward_id 英雄之路领奖
    bandit_index = "/api/?method=bandit.index", --满天星
    bandit_get_reward = "/api/?method=bandit.get_reward", --满天星 reward_id
    server_bandit_index = "/api/?method=server_bandit.index", --满天星
    server_bandit_get_reward = "/api/?method=server_bandit.get_reward", --满天星 reward_id

    --公会战接口
    guild_gvg_index = "/api/?method=guild_gvg.index",--进入公会战 根据返回的sort来判断进入哪个阶段
    guild_gvg_donate_flag = "/api/?method=guild_gvg.donate_flag",--战前捐献战旗 count=100
    guild_gvg_join_battle = "/api/?method=guild_gvg.join_battle",--其他公会加入公会战
    guild_gvg_battle_info = "/api/?method=guild_gvg.battle_info",--工会战斗详情
    guild_gvg_attack = "/api/?method=guild_gvg.attack",--公会战，战斗  building_id=2006
    guild_gvg_open_building = "/api/?method=guild_gvg.open_building",--建筑详细 building_id=2006
    guild_gvg_embattle_doing = "/api/?method=guild_gvg.embattle_doing",--战前准备布阵阶段
    guild_gvg_select_building = "/api/?method=guild_gvg.select_building",--公会布阵选择地块 building_id: 1 建筑物id force: 0  是否强制, 0不强制, 1强制
    guild_gvg_remove_building = "/api/?method=guild_gvg.remove_building",--会长踢人  building_id = 1
    guild_gvg_attack = "/api/?method=guild_gvg.attack",--公会战战斗building_id: 1    建筑物id
    guild_gvg_buy_time = "/api/?method=guild_gvg.buy_time",--购买时间
    guild_gvg_buy_times = "/api/?method=guild_gvg.buy_times",--购买次数
    guild_gvg_show_log = "/api/?method=guild_gvg.show_log",--战争中显示log
    guild_gvg_buy_player_morale = "/api/?method=guild_gvg.buy_player_morale",--购买玩家的士气
    guild_gvg_buy_guild_morale = "/api/?method=guild_gvg.buy_guild_morale",--购买联盟士气
    association_reward_index = "/api/?method=association.reward_index",--公会战分配奖励  index
    association_reward_distribution = "/api/?method=association.reward_distribution",--分配奖励  参数: reward_id=1, target_uid=1
    guild_gvg_top_rank = "/api/?method=guild_gvg.top_rank",--参数:sort类型, page页数   sort =attacker | defender  
    guild_gvg_give_up_building = "/api/?method=guild_gvg.give_up_building",--building_id = 1 放弃
    card_shop_open = "/api/?method=shop.card_shop_open", -- 月卡商店首页
    card_shop_buy = "/api/?method=shop.card_shop_buy", -- 月卡商店购买  -- 参数 shop_id=14 购买项

    active_group_index = "/api/?method=active.group_index",--团购首页
    active_group_active_index = "/api/?method=active.group_active_index",--团购活动接口
    active_group_active_buy = "/api/?method=active.group_active_buy",--购买接口  count=
    active_group_rank = "/api/?method=active.group_rank",--排名接口

    server_group_index = "/api/?method=server_group.group_index",--团购首页    开服
    server_group_active_index = "/api/?method=server_group.group_active_index",--团购活动接口  开服
    server_group_active_buy = "/api/?method=server_group.group_active_buy",--购买接口  count=   开服
    server_group_rank = "/api/?method=server_group.group_rank",--排名接口  开服

    statistics_add_step = "/api/?method=user.add_step", -- 统计用户的步数   user_token=h11234567&step=1
    mine_index = "/api/?method=mine.index",-- 矿山
    mine_bidding = "/api/?method=mine.bidding", -- 出价   --参数 mid=1 & price=2101
    mine_mining =  "/api/?method=mine.mining", -- 采矿  -- 参数 mid=1
    mine_mining_quick = "/api/?method=mine.mining_quick", -- 加速 花钻石
    mine_miner_add_coin = "/api/?method=mine.miner_add_coin", -- 追加投资 参数 mid = 1

    get_xmw2_order = "/api/?method=payment.get_xmw2_order",  --熊猫玩支付数据请求接口
  
        --公会雇佣
    association_employ_ground = "/api/?method=association.employ_ground",--公会雇佣index
    association_dispatch_card = "/api/?method=association.dispatch_card", --派遣佣兵
    association_retreat_card = "/api/?method=association.retreat_card", --撤回佣兵
    association_employ_boss_fight = "/api/?method=association.employ_boss_fight",--公会副本战斗
    association_employ_boss_index = "/api/?method=association.employ_boss_index",
    association_buy_time="/api/?method=association.buy_fight_times",--购买次数

    foundation_show_available_funds = "/api/?method=foundation.show_available_funds",--看可够买基金
    foundation_activate = "/api/?method=foundation.activate",--激活基金  id=
    foundation_withdraw = "/api/?method=foundation.withdraw",--提取基金   id=

    server_active_recharge_index = "/api/?method=active.server_active_recharge_index",--开服充值活动
    server_active_recharge_receive = "/api/?method=active.server_active_recharge_receive",  --主动充值领取      参数 active_id         和active.active_recharge_receive一样
    server_foundation_show_available_funds = "/api/?method=server_foundation.show_available_funds",--看可够买基金
    server_foundation_activate = "/api/?method=server_foundation.activate",--激活基金  id=
    server_foundation_withdraw = "/api/?method=server_foundation.withdraw",--提取基金   id=

    wanted_wanted_ui = "/api/?method=wanted.wanted_ui",  -- 通缉进入接口
    wanted_wanted_fight = "/api/?method=wanted.wanted_fight",  -- 通缉战斗接口 Enemy_id
    wanted_help_fight = "/api/?method=wanted.help_fight",  -- 通缉协助战斗接口 'uid': 'enemy_id' 'help_time'
    wanted_wanted_award = "/api/?method=wanted.wanted_award",  -- 通缉领奖接口 'award_id' = 1
    wanted_wanted_help = "/api/?method=wanted.wanted_help",  -- 通缉领奖接口 'award_id' = 1
    gem_synthesis = "/api/?method=gem.synthesis", -- 宝石合成  参数 gem_id= gem_num=
    gem_upgrade = "/api/?method=gem.upgrade", -- 宝石升级  参数 gem_id    element_id=&element_id=&element_id=
    gem_resolve = "/api/?method=gem.resolve",--宝石分解 参数 gems  格式 gems=101_10&gems=102_20&gems=103_30    101是配置id   10为数量
    equip_enchant = "/api/?method=equip.enchant", -- 装备附魔接口， 参数： equip_id ，temp
    equip_save_init_enchant = "/api/?method=equip.save_init_enchant", -- 装备附魔保留接口，参数：equip_id ，is_enchant
    equip_remove_enchant = "/api/?method=equip.remove_enchant",--移除附魔 equip_id
    card_rebirth = "/api/?method=cards.card_rebirth",  -- 卡牌重生  -card_id  卡牌id
    server_shop_show = "/api/?method=shop.server_shop_show", -- 新服商城进入接口 
    server_shop_buy = "/api/?method=shop.server_shop_buy",    -- 新服商城购买接口 参数 shop_id
    server_exchange = "/api/?method=server_exchange.server_exchange",  -- 新服兑换活动进入接口
    show_server_exchange_options = "/api/?method=server_exchange.show_server_exchange_options", -- 新服兑换活动兑换接口
    -- 擂台战
    serverpk_team_battle = "/api/?method=servers_fight.team_battle",               -- 小组赛日界面
    serverpk_check_enemy_list = "/api/?method=servers_fight.check_enemy_list",           -- 查看对手列表
    serverpk_group_combat_log = "/api/?method=servers_fight.group_combat_log",          -- 小组赛查看战斗记录
    serverpk_group_replay = "/api/?method=servers_fight.group_replay",               -- 小组赛战斗记录回放
    serverpk_team_battle_rank = "/api/?method=servers_fight.team_battle_rank",           -- 小组赛排行榜
    serverpk_team_final_battle_rank = "/api/?method=servers_fight.final_battle_rank",            -- 决赛服务器排行榜
    serverpk_team_final_combat_log =  "/api/?method=servers_fight.final_combat_log",            -- 决赛查看战斗记录
    serverpk_team_final_replay = "/api/?method=servers_fight.final_replay",                 -- 决赛战斗回放

    --押镖
    escort_index = "/api/?method=escort.index",--押镖入口
    escort_shop_index = "/api/?method=escort.shop_index",--镖局商店
    escort_my_goods = "/api/?method=escort.my_goods",--货仓
    escort_shop_fresh = "/api/?method=escort.shop_fresh",--刷新商店  免费
    escort_coin_shop_fresh = "/api/?method=escort.coin_shop_fresh",--钻石刷新
    escort_team_index = "/api/?method=escort.team_index",--队伍列表
    escort_join_goods_team = "/api/?method=escort.join_goods_team",--加入队伍    goods_id= &captain_uid=
    escort_employ = "/api/?method=escort.employ",--雇佣NPC
    escort_create_goods_team = "/api/?method=escort.create_goods_team",--创建队伍   goods_id=    buff_sort=
    escort_quit_goods_team = "/api/?method=escort.quit_goods_team",--队员退出队伍
    escort_disband_goods_team = "/api/?method=escort.disband_goods_team",--队长解散队伍
    escort_buy_goods = "/api/?method=escort.buy_goods",--买物品     goods_id=
    escort_check_other_team = "/api/?method=escort.check_other_team",--查看其他队伍  captain_uid=
    escort_check_my_team = "/api/?method=escort.check_my_team",--查看我的队伍
    escort_kick_goods_team = "/api/?method=escort.kick_goods_team",--队长踢人  team_uid=
    escort_start_sail = "/api/?method=escort.start_sail",--开始运货
    escort_map_index = "/api/?method=escort.map_index",--开始运货
    escort_point_shop = "/api/?method=escort.point_shop",--押镖积分商店
    escort_point_buy = "/api/?method=escort.point_buy",--积分商店购买
    escort_upgrade_vehicle_buff = "/api/?method=escort.upgrade_vehicle_buff",--升级货船 item_id=
    escort_open_map = "/api/?method=escort.open_map",--打开地图  map_id
    escort_auto_start_sail = "/api/?method=escort.auto_start_sail",--自动起航 auto_start_sail= 自动1，不自动 0 
    escort_rob_index = "/api/?method=escort.rob_index",--抢劫界面
    escort_create_rob_team = "/api/?method=escort.create_rob_team",--创建抢劫队伍
    escort_join_rob_team = "/api/?method=escort.join_rob_team",--加入抢劫队伍    captain_uid =
    escort_kick_rob_team = "/api/?method=escort.kick_rob_team",--队长T人        team_uid = 
    escort_quit_rob_team = "/api/?method=escort.quit_rob_team",--退出抢劫队伍
    escort_disband_rob_team = "/api/?method=escort.disband_rob_team",--解散抢劫队伍
    escort_check_my_rob_team = "/api/?method=escort.check_my_rob_team",--查看我的打劫队伍
    escort_rob = "/api/?method=escort.rob",--抢劫  vehicle_captain_uid =
    escort_world_message = "/api/?method=escort.world_message",--消息
    escort_battle_message = "/api/?method=escort.battle_message",--战报消息
    escort_battle_log = "/api/?method=escort.battle_log",--3v3战报列表 key=
    escort_battle_replay = "/api/?method=escort.battle_replay",--战斗回放  battle_log=

    escort_quick_join = "/api/?method=escort.quick_join",--快速加入     goods_id = 
    escort_refresh_buff = "/api/?method=escort.refresh_buff",--刷新镖车      captain_uid=
    escort_refresh_vehicle_buff = "/api/?method=escort.refresh_vehicle_buff",--刷新镖车属性
    escort_arrive = "/api/?method=escort.arrive",--货物到达
    escort_vehicle_ready = "/api/?method=escort.vehicle_ready",--准备
    escort_cancel_vehicle_ready = "/api/?method=escort.cancel_vehicle_ready",--取消准备
    

    one_piece_index = "/api/?method=one_piece.index", -- 海贼王首页
    one_piece_open_roulette = "/api/?method=one_piece.open_roulette", -- 海贼王探索一次
    one_piece_open_roulette10 = "/api/?method=one_piece.open_roulette10", -- 海贼王探索十次
    one_piece_info = "/api/?method=one_piece.info", -- 海贼王擂台信息
    one_piece_exchange = "/api/?method=one_piece.exchange", -- 海贼王兑换接口  id=1
    one_piece_exchange_index = "/api/?method=one_piece.exchange_index", -- 海贼王兑换首页
    one_piece_step_reward = "/api/?method=one_piece.step_reward", -- 海贼王阶段领奖  step=1

    server_one_piece_index = "/api/?method=server_one_piece.index", -- 海贼王首页
    server_one_piece_open_roulette = "/api/?method=server_one_piece.open_roulette", -- 海贼王探索一次
    server_one_piece_open_roulette10 = "/api/?method=server_one_piece.open_roulette10", -- 海贼王探索十次
    server_one_piece_info = "/api/?method=server_one_piece.info", -- 海贼王擂台信息
    server_one_piece_exchange = "/api/?method=server_one_piece.exchange", -- 海贼王兑换接口  id=1
    server_one_piece_exchange_index = "/api/?method=server_one_piece.exchange_index", -- 海贼王兑换首页
    server_one_piece_step_reward = "/api/?method=server_one_piece.step_reward", -- 海贼王阶段领奖  step=1

    active_hero_road_buy_times = "/api/?method=active.hero_road_buy_times", -- 英雄之路购买次数  chapter=
    open_door_index = "/api/?method=open_door.index", --开门活动
    open_door_open = "/api/?method=open_door.open", --开门活动
    maze_index = "/api/?method=maze.index", --回廊活动
    maze_start = "/api/?method=maze.start", -- 回廊开始接口
    maze_open_next_layer = "/api/?method=maze.open_next_layer", -- sort == 1  进入下一层 参数: stage_id
    maze_open_stage = "/api/?method=maze.open_stage", -- sort == 2  攻打stage  参数: stage_id
    maze_open_shop = "/api/?method=maze.open_shop", -- sort == 3  获取shop   参数: stage_id  pos: 0, 第一个奖励, 1, 第二个, 2, 第三个
    maze_use_item = "/api/?method=maze.use_item", --使用道具  参数: item_id
    maze_map_fight_and_enemy = "/api/?method=maze.map_fight_and_enemy",--获取怪物  参数: stage_id
    maze_battle_replay = "/api/?method=maze.battle_replay",--回廊回放  layer = index = 
    maze_get_user_info = "/api/?method=maze.get_user_info",--查看回廊玩家信息 uid = layer =
    
    magic_school_index = "/api/?method=magic_school.index",  --  火焰杯 主页
    magic_school_open_contract = "/api/?method=magic_school.open_contract",    -- 签订契约 contract_id = 1
    magic_school_point_reward = "/api/?method=magic_school.point_reward",   -- 契约积分领奖  reward_id = 1-4

    server_magic_school_index = "/api/?method=server_magic_school.index",  --  火焰杯 主页
    server_magic_school_open_contract = "/api/?method=server_magic_school.open_contract",    -- 签订契约 contract_id = 1
    server_magic_school_point_reward = "/api/?method=server_magic_school.point_reward",   -- 契约积分领奖  reward_id = 1-4
    
    pyramid_index = "/api/?method=pyramid.index",   -- 金字塔主页
    pyramid_get_up_morale = "/api/?method=pyramid.get_up_morale",   -- 鼓舞士气
    pyramid_buy_challenge_times = "/api/?method=pyramid.buy_challenge_times",  -- 购买攻击次数
    pyramid_go_fight = "/api/?method=pyramid.go_fight",  -- 去战斗  floor 层数
    pyramid_pyramid_battle = "/api/?method=pyramid.pyramid_battle",  -- 去战斗  floor 层数  pos 位置
    pyramid_user_info = "/api/?method=pyramid.user_info", -- 查看玩家信息
    pyramid_battle_log = "/api/?method=pyramid.pyramid_battle_log", -- 查看金字塔日志
    pyramid_battle_replay = "/api/?method=pyramid.pyramid_battle_replay", -- 查看金字塔日志回放  key == 
    pyramid_quick_floor =  "/api/?method=pyramid.pyramid_quick_floor", -- 查看金字塔日志回放  key == 
    pyramid_wanted_index = "/api/?method=pyramid.pyramid_wanted_index",   -- 金字塔悬赏主页
    refresh_pyramid_wanted = "/api/?method=pyramid.refresh_pyramid_wanted",   -- 金字塔悬赏 任务刷新
    get_wanted_reward = "/api/?method=pyramid.get_wanted_reward",   -- 金字塔悬赏 领奖的接口 参数为wanted_id

    enemy_show_enemys = "/api/?method=enemy.show_enemys", -- 仇人列表
    enemy_give_up_enemy = "/api/?method=enemy.give_up_enemy", -- 删除仇人  enemy_id=h19092412
    enemy_care_enemy = "/api/?method=enemy.care_enemy", -- 关注仇人  enemy_id=h19092412

    magic_school_lucky_contract = "/api/?method=magic_school.lucky_contract", -- 幸运契约信息
    magic_school_get_back_sort_num = "/api/?method=magic_school.get_back_sort_num", -- 我的契约信息 (前100条)
    magic_school_get_page_num = "/api/?method=magic_school.get_page_num", -- 获取契约信息 (前100条)

    server_magic_school_lucky_contract = "/api/?method=server_magic_school.lucky_contract", -- 幸运契约信息
    server_magic_school_get_back_sort_num = "/api/?method=server_magic_school.get_back_sort_num", -- 我的契约信息 (前100条)
    server_magic_school_get_page_num = "/api/?method=server_magic_school.get_page_num", -- 获取契约信息 (前100条)

    open_door_rank = "/api/?method=open_door.rank",--参数sort 值为combat: 战斗力, pyramid:金字塔, escort: 运镖, maze:回廊     参数page
    open_door_battle = "/api/?method=open_door.battle",--星际穿越的第一场战斗
    king_find_caller = "/api/?method=king.find_caller", -- 查找邀请人信息  tid = 
    king_add_caller = "/api/?method=king.add_caller", -- 添加邀请人信息  tid =
    king_get_king_reward = "/api/?method=king.get_king_reward", -- 接受自己的老玩家回归奖励 
    king_show_reward_interface = "/api/?method=king.show_reward_interface", -- 邀请者的所有奖励
    king_show_reward_single = "/api/?method=king.show_reward_single", -- 查询我邀请的某个老玩家可领的奖励
    king_get_reward_single = "/api/?method=king.get_reward_single", -- 领我邀请的某个老玩家可领的奖励
    king_show_reward_total = "/api/?method=king.show_reward_total", -- 总积分奖励列表
    king_get_reward_total = "/api/?method=king.get_reward_total", -- 领总积分奖励

    shop_open_metal_shop = "/api/?method=shop.open_metal_shop", -- 精炼石
    shop_buy_metal_shop = "/api/?method=shop.buy_metal_shop", -- 精炼石  shop_id=1&count=1
    cards_activate_destiny = "/api/?method=cards.activate_destiny",--阵型命运解锁  position
    cards_activate_assistant_effect = "/api/?method=cards.activate_assistant_effect",--阵型助威激活  position
    cards_refresh_assistant_effect = "/api/?method=cards.refresh_assistant_effect",--阵型助威属性刷新 参数: lock值为'ability1'基础, 'ability2'升级后, 'card'卡牌     pos位置    retain保存为1 刷新为0
    cards_assistant_effect_uplevel = "/api/?method=cards.assistant_effect_uplevel",--助威升级接口  参数: pos: 0-9
    public_land_index = "/api/?method=public_land.index",-- 新无主之地首页
    public_land_sow_seed = "/api/?method=public_land.sow_seed",-- 种植的接口 map_id=3&seed_id=1，参数map_id是地块的id
    public_land_refresh_worker = "/api/?method=public_land.refresh_worker",-- 刷新工人的接口 map_id=1
    public_land_cancel_sow_seed = "/api/?method=public_land.cancel_sow_seed",-- 取消种植 map_id=1
    public_land_get_harvest_reward = "/api/?method=public_land.get_harvest_reward",-- 收获接口 map_id=1
    public_land_visit_one_friend = "/api/?method=public_land.visit_one_friend",-- 去拜访的接口 uid=
    public_land_visit_friend_list = "/api/?method=public_land.visit_friend_list",-- 去拜访的接口 uid=
    public_land_send_blessing = "/api/?method=public_land.send_blessing",-- 送祝福 uid=&map_id=
    public_land_go_rob_index = "/api/?method=public_land.go_rob_index",-- 掠夺
    public_land_go_steal_rob = "/api/?method=public_land.go_steal_rob",-- 掠夺 uid&map_id&type=1  1 偷取 2 抢夺
    public_land_go_revenge = "/api/?method=public_land.go_revenge",-- 复仇 uid&index
    public_land_get_battle_log = "/api/?method=public_land.get_battle_log",-- log
    cards_super_evolution = "/api/?method=cards.super_evolution",-- 卡牌超进化
    cards_make_soul = "/api/?method=cards.make_soul",-- 卡牌超进化 铸魂  参数major&metal   辅助卡传的形式metal1_-3_metal2
    user_set_pre_battle = "/api/?method=user.set_pre_battle",-- 战前技  toggle=0/1

    public_land_refresh_map_info = "/api/?method=public_land.refresh_map_info",--  uid
    diamond_wheel_index = "/api/?method=diamond_wheel.index",-- 钻石摩天轮 
    diamond_wheel_refresh_diamond_wheel_reward = "/api/?method=diamond_wheel.refresh_diamond_wheel_reward",-- 刷新接口
    diamond_wheel_open_diamond_wheel = "/api/?method=diamond_wheel.open_diamond_wheel",-- 启动 type：1表示外圈 2表示里圈
    diamond_wheel_open_diamond_wheel10 = "/api/?method=diamond_wheel.open_diamond_wheel10",-- 启动 type：1表示外圈 2表示里圈
    server_diamond_wheel_open_diamond_wheel10 = "/api/?method=server_diamond_wheel.open_diamond_wheel10",-- 启动 type：1表示外圈 2表示里圈
    
    server_diamond_wheel_index = "/api/?method=server_diamond_wheel.index",-- 钻石摩天轮 
    server_diamond_wheel_refresh_diamond_wheel_reward = "/api/?method=server_diamond_wheel.refresh_diamond_wheel_reward",-- 刷新接口
    server_diamond_wheel_open_diamond_wheel = "/api/?method=server_diamond_wheel.open_diamond_wheel",-- 启动 type：1表示外圈 2表示里圈

    bounty_order_index = "/api/?method=bounty_order.index",--赏金令
    bounty_order_task_index = "/api/?method=bounty_order.task_index",--任务详情    type = 1
    bounty_order_is_accept_task = "/api/?method=bounty_order.is_accept_task",--领取任务 type = 1
    refresh_bounty_order_child_task = "/api/?method=bounty_order.refresh_child_task",--刷新任务  type = 1  child_type = 1
    bounty_order_is_give_up_task = "/api/?method=bounty_order.is_give_up_task",--放弃 type = 1
    get_reward_bounty_order_child_task = "/api/?method=bounty_order.get_reward_child_task",--type = 1 child_type = 1 领取子任务奖励接口
    bounty_order_get_big_reward = "/api/?method=bounty_order.get_big_reward",--type = 1

    server_bounty_order_index = "/api/?method=server_bounty_order.index",--赏金令
    server_bounty_order_task_index = "/api/?method=server_bounty_order.task_index",--任务详情    type = 1
    server_bounty_order_is_accept_task = "/api/?method=server_bounty_order.is_accept_task",--领取任务 type = 1
    server_refresh_bounty_order_child_task = "/api/?method=server_bounty_order.refresh_child_task",--刷新任务  type = 1  child_type = 1
    server_bounty_order_is_give_up_task = "/api/?method=server_bounty_order.is_give_up_task",--放弃 type = 1
    server_get_reward_bounty_order_child_task = "/api/?method=server_bounty_order.get_reward_child_task",--type = 1 child_type = 1 领取子任务奖励接口
    server_bounty_order_get_big_reward = "/api/?method=server_bounty_order.get_big_reward",--type = 1

    equip_equip_refine = "/api/?method=equip.equip_refine",--洗练&equip_id = 1 &sort = 1，5，10 type = 1,2,3 is_save = 1 0 

    daily_score_index = "/api/?method=reward.daily_score_index",--新悬赏任务
    get_daily_reward = "/api/?method=reward.get_daily_reward",--新任务领奖 &daily_id = 1
    get_score_reward = "/api/?method=reward.get_score_reward",--领取积分奖 &score_id = 1
    get_guild_level_reward = "/api/?method=association.get_guild_level_reward",--联盟领取奖励
    guild_level_reward_index = "/api/?method=association.guild_level_reward_index",--

    --寵物
    set_pet_formation = "/api/?method=pets.set_pet_formation",--更改陣型  align_1=1_2&align_2=3_4
    pets_activate_pos = "/api/?method=pets.activate_pos",--激活陣型   pos = 0~8
    pets_pet_culture = "/api/?method=pets.pet_culture",--培養寵物  pet_id = 
    pets_pet_evolution = "/api/?method=pets.pet_evolution",--寵物進化 pet_id = item = 
    pets_pet_strengthen = "/api/?method=pets.pet_strengthen",--寵物強化,  pet_id = type = 
    pets_pet_skill_levelup = "/api/?method=pets.pet_skill_levelup",--寵物技能升級 pet_id =  skill_id =
    
    activate_pet_follow_pos = "/api/?method=pets.activate_pet_follow_pos",--激活宠物跟随位置   pos=0
    set_pet_follow_formation = "/api/?method=pets.set_pet_follow_formation",--设置宠物位置    formation=900-1440559038-2rC2x0_700-1440559038-svf4xv_-1_-1_-1_-1_-1_-1
    pet_rebirth = "/api/?method=pets.pet_rebirth",--宠物重生 pet_id =
    refresh_pet_follow = "/api/?method=pets.refresh_pet_follow", --宠物跟随刷新属性

    mining_task_index = "/api/?method=mining.task_index",--新挖矿
    mining_enter_stage = "/api/?method=mining.enter_stage",--进入挖矿
    mining_click_stage = "/api/?method=mining.click_stage",--点击地图接口 参数值为pos=1到30 
    mining_get_score_rank = "/api/?method=mining.get_score_rank",--排行榜
    mining_reward_exchange = "/api/?method=mining.reward_exchange",--奖励兑换 exchange_id
    mining_vip_pay_nums = "/api/?method=mining.vip_pay_nums",--vip购买次数（无参数）

    team_boss_index = "/api/?method=team_boss.index",--组队boss  捐献首页 
    team_boss_donation = "/api/?method=team_boss.donation",--捐献    &num = 100
    team_boss_see_team_info = "/api/?method=team_boss.see_team_info",--查看队伍的信息    &team_id = 1
    team_boss_create_team = "/api/?method=team_boss.create_team",--创建队伍
    team_boss_refresh_group_team = "/api/?method=team_boss.refresh_group_team",--刷新
    team_boss_see_team_info = "/api/?method=team_boss.see_team_info",--查看队伍信息    &team_id = 1
    team_boss_join_team = "/api/?method=team_boss.join_team",--加入队伍  &team_id=1
    team_boss_exit_team = "/api/?method=team_boss.exit_team",--退出队伍  
    team_boss_destroy_team = "/api/?method=team_boss.destroy_team",--队长解散队伍
    team_boss_exchange_player = "/api/?method=team_boss.exchange_player",--交换队伍角色   &pos=1&exchange_pos=2  从1换到2
    team_boss_battle = "/api/?method=team_boss.team_boss_battle",--sort = 2 &team_id = 1
    team_relive_time = "/api/?method=team_boss.team_relive_time",--买活    
    team_attack_time = "/api/?method=team_boss.team_attack_time",--买行动力
    team_boss_remove_player = "/api/?method=team_boss.remove_player",--T人  &pos = 1
    team_boss_per_point_exchange = "/api/?method=team_boss.per_point_exchange",--兑换  sort = 1
    team_boss_exchange_index = "/api/?method=team_boss.exchange_index",--兑换index

    normal_exchange_index = "/api/?method=normal_exchange.index",--常规兑换
    normal_exchange_normal_exchange = "/api/?method=normal_exchange.normal_exchange",--常规兑换 奖励  

    redpacket_index = "/api/?method=redpacket.index",--红包  
    redpacket_reward = "/api/?method=redpacket.reward",--领取红包 red_id = 1

    redpacket_server_index = "/api/?method=redpacket.server_index",--新服红包  
    redpacket_server_reward = "/api/?method=redpacket.server_reward",--新服领取红包 red_id = 1

    --过年红包
    red_bag_index = "/api/?method=red_bag.index", --红包首页
    red_bag_open_red_bag = "/api/?method=red_bag.open_red_bag",--抢红包 参数 key
    red_bag_refresh_red_bag = "/api/?method=red_bag.refresh_red_bag",

    world_one_index = "/api/?method=world_one.index",--天下第一武道会
    world_one_enroll = "/api/?method=world_one.enroll",--武道会报名
    world_one_syn_user_info = "/api/?method=world_one.syn_user_info",--同步用户数据
    world_one_remove_syn_time = "/api/?method=world_one.remove_syn_time",--消除同步的时间
    world_one_get_team_rank = "/api/?method=world_one.get_team_rank",--page = 1 排行榜
    world_one_enter_game = "/api/?method=world_one.enter_game",--进入战场
    world_one_refresh_player = "/api/?method=world_one.refresh_player",--刷新敌人
    world_one_battle = "/api/?method=world_one.world_one_battle",--挑战  uid = 
    world_one_see_player_info = "/api/?method=world_one.see_player_info",--查看玩家数据  uid = 
    world_one_exchange_index = "/api/?method=world_one.exchange_index",--兑换
    world_one_exchange_exchange = "/api/?method=world_one.exchange",--兑换   sort = 
    world_one_remove_win_time = "/api/?method=world_one.remove_win_time",--消除换一批时间
    world_one_battle_log = "/api/?method=world_one.world_one_battle_log",--战报
    world_one_battle_replay = "/api/?method=world_one.world_one_battle_replay",--战报回放  key =
    world_one_buy_challenge_times = "/api/?method=world_one.buy_challenge_times",--买次数

    soul_soul_index = "/api/?method=soul.soul_index",--祈魂首页
    soul_all_soul = "/api/?method=soul.all_soul", --得到全部物品背包
    soul_soul_gacha10 = "/api/?method=soul.soul_gacha10", --十抽
    soul_eat_soul = "/api/?method=soul.eat_soul", --噬魂   major = &metal = 1 & metal = 
    soul_soul_gacha="/api/?method=soul.soul_gacha",--单抽
    soul_increase_rate="/api/?method=soul.increase_rate",--紫色同步
    soul_set_alignment = "/api/?method=card.set_alignment", --附魂
    soul_book = "/api/?method=soul.soul_book",--英魂图鉴
    soul_sell_soul = "/api/?method=soul.sell_soul",--英魂出手  metal=&metal=

    large_roulette_index = "/api/?method=large_roulette.index",--跨服轮盘
    large_roulette_refresh = "/api/?method=large_roulette.refresh",--跨服轮盘刷新
    large_roulette_open_roulette = "/api/?method=large_roulette.open_roulette",--跨服轮盘   转一次
    large_roulette_open_open_roulette10 = "/api/?method=large_roulette.open_roulette10",--跨服轮盘   转10次
    large_roulette_open_open_reward_log = "/api/?method=large_roulette.reward_log",--跨服轮盘   奖励名单

    large_super_all_index = "/api/?method=large_super_all.index",--全服消耗的首页接口
    large_super_all_get_score_reward = "/api/?method=large_super_all.get_score_reward",--# 全服消耗领取积分奖励   id=1
    large_super_all_first_complete_reward = "/api/?method=large_super_all.first_complete_reward",--# 第一个完成的服务器   id=1
    large_super_rich_index = "/api/?method=large_super_rich.index",--# 全服消耗的活动

    --克隆诡巷
    clone_lane_index = "/api/?method=clone_lane.index",--首页
    clone_lane_refresh_team= "/api/?method=clone_lane.refresh_team",--刷新卡组
    clone_lane_refresh_secret = "/api/?method=clone_lane.refresh_secret",--刷新神秘奖励
    clone_lane_draw = "/api/?method=clone_lane.draw",--翻拍  参数 sort=1
    clone_lane_pack = "/api/?method=clone_lane.pack",--打包
    clone_lane_get_notice = "/api/?method=clone_lane.get_notice",--查看全服信息
    clone_lane_clean_data = "/api/?method=clone_lane.clean_data", 
    
    auto_evolution = "/api/?method=cards.auto_evolution",--卡牌一键进阶 sort=1&is_save=1
    auto_enchant = "/api/?method=equip.auto_enchant",--一键附魔  equip_id=1&sort=1   


    --命运装备升级
    fate_equip_bind = "/api/?method=equip.fate_equip_bind",--绑定装备 参数：equip_id：唯一id card_id：唯一id
    fate_equip_unbind = "/api/?method=equip.fate_equip_unbind", --解绑 参数： equip_id
    fate_equip_levelup = "/api/?method=equip.fate_equip_levelup", --解绑 参数： equip_id
    auto_fate_equip_levelup = "/api/?method=equip.auto_fate_equip_levelup", --解绑 参数： equip_id

     --卡牌转世
    cards_card_world = "/api/?method=cards.new_card_world",--卡牌转世 参数 major 卡牌id
    active_card_world_fight = "/api/?method=active.card_world_fight",--转世任务一 参数 chapter 关卡id maior 卡牌id
    active_card_world_fight_2 = "/api/?method=active.card_world_fight_2",--转世任务一 参数 chapter 关卡id maior 卡牌id
    private_city_recapture = "/api/?method=private_city.recapture", --旧的参数：city旧的参数：building新加的参数sort传2表示转世任务  参数step_n 
    cards_add_after_world_point = "/api/?method=cards.add_after_world_point",--卡牌转世能量 参数 major 卡牌id 分解的装备id


    --神域
    god_field_index = "/api/?method=god_field.index" ,--域界战争
    god_field_set_god_field = "/api/?method=god_field.set_god_field", --更换阵型
    god_field_upload_god_formation = "/api/?method=god_field.upload_god_formation", --查看阵型
    god_field_see_enemy_info = "/api/?method=god_field.see_enemy_info" ,--查看敌人信息
    god_field_god_field_battle = "/api/?method=god_field.god_field_battle" ,--战斗
    god_field_exchange_index = "/api/?method=god_field.exchange_index", --兑换首页
    god_field_exchange = "/api/?method=god_field.exchange", --点击兑换
    god_field_back_battle = "/api/?method=god_field.back_battle",--战斗回放
    god_field_see_god_field_log = "/api/?method=god_field.see_god_field_log", --查看神域战报
    god_field_see_final_log = "/api/?method=god_field.see_final_log",--周日的战报
    god_field_buy_ship_ticket = "/api/?method=god_field.buy_ship_ticket",--购买船票
    god_field_final_battle_log = "/api/?method=god_field.final_battle_log",
    god_field_get_own_logs = "/api/?method=god_field.get_own_logs", --战斗战报
    god_field_update_battle_order = "/api/?method=god_field.update_battle_order", --调整阵型 参数 formation = 1_2_3

    --神域内的纷争峡谷
    team_pk_new_index = "/api/?method=team_pk_new.index",--首页
    team_pk_new_select_position = "/api/?method=team_pk_new.select_position",--选位置
    team_pk_new_battle_boss = "/api/?method=team_pk_new.battle_boss",--打boss伤害测试
    team_pk_new_team_pk_formation = "/api/?method=team_pk_new.team_pk_formation",--换阵型formation = 1_2_3
    team_pk_new_select_change_line = "/api/?method=team_pk_new.select_change_line",--换线  （自己换）line_id=1，（队长换）+ uid=h11996895
    team_pk_new_team_pk_boss_battle = "/api/?method=team_pk_new.team_pk_boss_battle",--真正的boss
    team_pk_new_see_team_pk_log = "/api/?method=team_pk_new.see_team_pk_log",--战报
    team_pk_exchange_index = "/api/?method=team_pk_new.exchange_index",--兑换首页
    team_pk_exchange = "/api/?method=team_pk_new.exchange",--兑换  sort=1
    team_pk_see_team_pk_log = "/api/?method=team_pk.see_team_pk_log",--查看自己的战报
    team_pk_back_battle_pk_log = "/api/?method=team_pk_new.back_battle_pk_log",--回放战报 key=models.team_pk||TeamPkLog||team_pk_log||1_1_1_1_143774412005
    team_pk_new_team_attack_time = "/api/?method=team_pk_new.team_attack_time",--新的组队pk 购买打位置的cd时间
    team_pk_new_team_relive_time = "/api/?method=team_pk_new.team_relive_time",--新的组队PK 打boss购买cd时间
    reward_receive_version_reward = "/api/?method=reward.receive_version_reward",
    team_pk_boss_battle_v3 = "/api/?method=team_pk_new.team_pk_boss_battle_v3",--foothold_id : 攻打的位置id，一方是1~15 一方是101~115boss 是－1
    team_pk_new_foothold_info = "/api/?method=team_pk_new.foothold_info",
    team_pk_new_cool_down_boss_battle_attack = "/api/?method=team_pk_new.cool_down_boss_battle_attack",
    team_pk_new_recover_morale = "/api/?method=team_pk_new.recover_morale",--够买士气
    
    --神域竞技场
    god_arena = "/api/?method=god_arena.index", --主页/竞技匹配
    god_arena_leisure_match = "/api/?method=god_arena.leisure_match", --休闲匹配
    god_arena_receive_stage_up_reward = "/api/?method=god_arena.receive_stage_up_reward", --领取进阶奖励
    god_arena_battle = "/api/?method=god_arena.battle", --战斗
    god_arena_shop_index = "/api/?method=god_arena.shop_index", --商城首页
    god_arena_exchange = "/api/?method=god_arena.exchange", --商店兑换
    god_arena_get_own_logs = "/api/?method=god_arena.get_own_logs", --战报
    god_arena_top = "/api/?method=god_arena.top", --排行榜
    god_arena_stage_up_battle = "/api/?method=god_arena.stage_up_battle", --晋级挑战
    god_arena_show_stage_up_enemy = "/api/?method=god_arena.show_stage_up_enemy", -- 晋级
    god_arena_buy_count = "/api/?method=god_arena.buy_count", -- 购买次数
    god_arena_show_enemy_detail = "/api/?method=god_arena.show_enemy_detail", --战斗前展示

     --神域运镖
    god_dart_mian = "/api/?method=god_field_escort.index", --运镖主页
    god_field_escort_all_map ="/api/?method=god_field_escort.all_map",
    god_field_escort_map_index = "/api/?method=god_field_escort.map_index", --运镖地图
    god_field_escort_shop_index = "/api/?method=god_field_escort.shop_index", --运镖商店
    god_field_escort_buy_goods = "/api/?method=god_field_escort.buy_goods", -- 买货
    god_field_choice_escort = "/api/?method=god_field_escort.choice_escort", -- 选择飞船
    god_field_escort_my_goods = "/api/?method=god_field_escort.my_goods", -- 查看商品
    god_field_escort_employ_ground = "/api/?method=god_field_escort.employ_ground",  --神域雇佣
    god_field_escort_coin_shop_fresh = "/api/?method=god_field_escort.coin_shop_fresh", -- 刷新
    god_field_escort_check_other_team = "/api/?method=god_field_escort.check_other_team", -- 查看镖车
    god_field_escort_start_sail = "/api/?method=god_field_escort.start_sail", -- 运镖开始
    god_field_escort_rob = "/api/?method=god_field_escort.rob", -- 抢劫
    god_field_escort_battle_message = "/api/?method=god_field_escort.battle_message", --用户消息
    god_field_escort_battle_log = "/api/?method=god_field_escort.battle_log", --用户消息
    god_field_escort_battle_replay = "/api/?method=god_field_escort.battle_replay",  --战斗回放

     --神域星宫
    zodiac_index = "/api/?method=zodiac.index",    --星宫首页      
    zodiac_go_fight = "/api/?method=zodiac.go_fight",    --宫殿页面     floor  进入的宫殿   1—12
    zodiac_user_info = "/api/?method=zodiac.user_info",   --查看宫殿位置信息   floor、pos、uid（敌人uid）
    zodiac_battle = "/api/?method=zodiac.zodiac_battle",  --战斗接口    floor、pos、team（自己所用神域队伍1、2、3）
    zodiac_buy_challenge_times = "/api/?method=zodiac.buy_challenge_times",  --购买挑战次数
    zodiac_god_field_ids = "/api/?method=zodiac.god_field_ids",  
    zodiac_remove_floor_pos = "/api/?method=zodiac.remove_floor_pos", -- 撤销队伍
    zodiac_remove_floor_pos2 = "/api/?method=zodiac.remove_floor_pos2", -- 撤销队伍   floor  pos
    zodiac_battle_log = "/api/?method=zodiac.zodiac_battle_log", -- 战斗信息
    zodiac_battle_replay = "/api/?method=zodiac.zodiac_battle_replay",  --战斗回放
    zodiac_employ_ground = "/api/?method=zodiac.employ_ground",  --星宫雇佣
    zodiac_fight_boss = "/api/?method=zodiac.fight_boss",  --boss战斗
    zodiac_wanted_index = "/api/?method=zodiac.zodiac_wanted_index",   --每日任务
    refresh_zodiac_wanted = "/api/?method=zodiac.refresh_zodiac_wanted",   --任务刷新  奖励领取（参数 wanted_id）
    zodiac_get_wanted_reward = "/api/?method=zodiac.get_wanted_reward",   -- 奖励领取（参数 wanted_id）
    enemy_index = "/api/?method=zodiac.enemy_index", --星宫仇人
    enemy_info = "/api/?method=zodiac.enemy_info", --星宫仇人
    zodiac_get_adjustment = "/api/?method=zodiac.upload_god_formation",   
    zodiac_set_adjustment = "/api/?method=zodiac.update_field", 




    --神域圣殿
    god_field_temple_index = "/api/?method=god_field_temple.index",--首页
    god_field_temple_set_farmer_team_formation = "/api/?method=god_field_temple.set_farmer_team_formation",--调整队伍 参数 farmers_formation=cid_cid_cid team_index
    god_field_temple_select_enemies = "/api/?method=god_field_temple.select_enemies",--选择敌人  采集队伍id  team_index=1 采集圣殿号 temple_level=1 is_refresh=1是否刷新敌人
    god_field_temple_contend_temple = "/api/?method=god_field_temple.contend_temple",--挑战敌人 参数 enemy_id="uid" 敌人在该圣殿中的队伍号, 机器人置为0 enemy_team=1 若战胜对手,我方进行采集的队伍号 user_team=1 圣殿号temple_level=1 
    god_field_temple_leave_temple = "/api/?method=god_field_temple.leave_temple",--结束采集，获得奖励 team_index=1

    --装备锻造
    equip_forge_level = "/api/?method=equip.equip_forge_level",--装备锻造的升级         equip_id=1&=1_1_1
    equip_forge_index = "/api/?method=equip.equip_forge_index",--装备的属性的展示 参数  equip_id
    equip_forge_refresh = "/api/?method=equip.equip_forge_refresh",--装备属性的刷新 equip_id sort  0表示普通锻造  1表示高级锻造 2 表示超级锻造 is_save 是否保留 0 不保留， 1表示保留

    equip_equip_refine = "/api/?method=equip.equip_refine",--洗练&equip_id = 1 &sort = 1，5，10 type = 1,2,3 is_save = 1 0 
    equip_auto_refine = "/api/?method=equip.auto_refine",--快速洗练
    
    --装备打造 zyz
    equip_building = "/api/?method=equip.equip_building", --装备打造   build_id:1  equip_cid:11301
    equip_building_old = "/api/?method=equip.equip_building_old", --旧装备打造   build_id:1  equip_id:11301
    equip_building_up = "/api/?method=equip.equip_building_up", --装备升级   fresh_stone: 101_102_0_0
    equip_building_again = "/api/?method=equip.equip_building_again", --装备妇联   fresh_stone: 101_102_0_0

    --主题英雄志
    rocker_machine_index = "/api/?method=new_rocker.index" ,--主题英雄转首页
    open_rocker_machine = "/api/?method=new_rocker.open_new_rocker" ,--开启转动按钮
    rocker_machine_exchange_subject = "/api/?method=new_rocker.exchange_subject" ,--更换主题 参数 subject=1 sort=1

    active_recall_active_show = "/api/?method=active.recall_active_show",--累计充值首页
    active_recall_active_recharge_receive = "/api/?method=active.recall_active_recharge_receive",--累计充值按钮接口

    --老玩家回归
    king_recall_index = "/api/?method=king.recall_index" ,--老玩家回归活动首页
    king_get_seven_reward = "/api/?method=king.get_daily_reward", -- 领取7天登陆奖励
    king_get_normal_reward =  "/api/?method=king.get_normal_reward", -- 领取每天奖励
    king_get_rebate_coin = "/api/?method=king.get_rebate_coin", -- 领取七天钻石奖励
    king_add_caller = "/api/?method=king.add_caller", -- 添加邀请者
    recall_reward_index = "/api/?method=recall_reward.daily_score_index",--任务列表
    recall_reward_daily_award = "/api/?method=recall_reward.get_daily_reward", --回归任务的领取奖励接口

    medal_index = "/api/?method=medal.index",--勋章index
    medal_synthesis_medal = "/api/?method=medal.synthesis_medal",--勋章合成  medal_id=1 & num = 1
    medal_exchange_material = "/api/?method=medal.exchange_material",--材料卡的转变 exchange_id：要变成的勋章材料，material_id：自己存在的勋章材料，sort：变卡的类型，num：变卡的数量 
    medal_train_material = "/api/?method=medal.train_material",--材料合成训练接口 material_id：要训练的勋章材料，pos：训练的位置，sort：1 代表训练 2 代表加速 3 代表停止 4 代表领取
    medal_synthesis_material = "/api/?method=medal.synthesis_material",--合成材料   material_id = 1
    
    gringotts_index = "/api/?method=gringotts.index",--古灵阁首页
    gringotts_refresh = "/api/?method=gringotts.refresh",--刷新
    gringotts_investing = "/api/?method=gringotts.investing", --投资 time_long = 3 
    gringotts_get_reward = "/api/?method=gringotts.get_reward",--手动领取奖励 time_long = 3 sort = 1
    gringotts_quickly_reward = "/api/?method=gringotts.quickly_reward",--加速领取 time_long = 3 sort = 1
    gringotts_get_big_reward = "/api/?method=gringotts.get_big_reward", --建设奖励

    --主角属性加成
    cards_role_attri_level_up = "/api/?method=cards.role_attri_level_up",--首页

    --远征
    new_fight_forever_index = "/api/?method=new_fight_forever.index",--首页
    new_fight_forever_fight = "/api/?method=new_fight_forever.fight",--战斗 chapter : 要打的关卡号 fast_fight : 是否是扫荡, 扫荡没有战斗过程
    new_fight_forever_fast_fight = "/api/?method=new_fight_forever.fast_fight",--战斗 
    new_fight_forever_reset = "/api/?method=new_fight_forever.reset",--重置次数 
    new_fight_forever_back_battle = "/api/?method=new_fight_forever.back_battle",--战斗回放
    new_fight_forever_reward = "/api/?method=new_fight_forever.reward",--参数：chapter 领取奖励的关卡号
    -- 噩梦之塔
    nightmare_tower_index = "/api/?method=nightmare_tower.index",--首页
    nightmare_tower_fight = "/api/?method=nightmare_tower.fight",
    nightmare_tower_fight_back_battle = "/api/?method=nightmare_tower.back_battle",--战斗回放

    --大富翁
    super_tycoon_active_index = "/api/?method=super_tycoon_active.index",
    super_tycoon_active_roll = "/api/?method=super_tycoon_active.roll",--roll 点
    super_tycoon_active_fight = "/api/?method=super_tycoon_active.fight",--战斗 fight_type : 1打人 2打怪
    super_tycoon_active_buy = "/api/?method=super_tycoon_active.buy",--购买 shop_type : 1钻石商店， 2勋章换购商店
    super_tycoon_active_clear = "/api/?method=super_tycoon_active.clear", --调试用
    super_tycoon_active_round_reward = "/api/?method=super_tycoon_active.round_reward",--领取圈数奖励 参数 round

    --命运符文
    cards_fate_rune_index = "/api/?method=cards.fate_rune_index",    --首页
    fate_rune_get_cards = "/api/?method=cards.get_fate_rune_cards",    --获取所有命运符文可上阵卡牌
    fate_rune_set_cards = "/api/?method=cards.set_fate_rune_cards",        --上阵/更换命运符文卡牌
    cards_fate_rune_query = "/api/?method=cards.query_fate_rune_attrs",        --符文查询
    cards_refresh_fate_rune = "/api/?method=cards.refresh_fate_rune",        --刷新符文
    cards_lock_fate_rune = "/api/?method=cards.lock_fate_rune",        --锁定符文


    --新世界之树
    world_tree_new_index = "/api/?method=world_tree_new.index",
    world_tree_new_bless = "/api/?method=world_tree_new.bless",
    world_tree_new_get_level_reward = "/api/?method=world_tree_new.get_level_reward",
    world_tree_new_get_final_reward = "/api/?method=world_tree_new.get_final_reward",
    
    --开服众神殿 
    server_clone_lane_index = "/api/?method=server_clone_lane.index",
    server_clone_lane_refresh_team= "/api/?method=server_clone_lane.refresh_team",--刷新卡组
    server_clone_lane_refresh_secret = "/api/?method=server_clone_lane.refresh_secret",--刷新神秘奖励
    server_clone_lane_draw = "/api/?method=server_clone_lane.draw",--翻拍  参数 sort=1
    server_clone_lane_pack = "/api/?method=server_clone_lane.pack",--打包
    server_clone_lane_get_notice = "/api/?method=server_clone_lane.get_notice",--查看全服信息
    server_clone_lane_clean_data = "/api/?method=server_clone_lane.clean_data",

    
    --召唤兽
    combiner_index = "/api/?method=fable_beast.index", --召唤兽的基本信息
    combiner_open_fable_beast = "/api/?method=fable_beast.open_fable_beast", --召唤神兽
    combiner_up_beast_god = "/api/?method=fable_beast.up_beast_god", --进阶神兽相关的神将
    combiner_up_beast_quality = "/api/?method=fable_beast.up_beast_quality", --进阶神兽
    combiner_add_beast_exp = "/api/?method=fable_beast.add_beast_exp", --增加神兽经验进行升级
    combiner_update_fight_beast = "/api/?method=fable_beast.update_fight_beast", --更改出战神兽和技能位置
    combiner_rebirth="/api/?method=fable_beast.fable_beast_rebirth",

    --一元夺宝
    raiders_index = "/api/?method=raiders.index",
    raiders_open_raiders = "/api/?method=raiders.open_raiders",--抽奖
    raiders_raiders_detail = "/api/?method=raiders.raiders_detail",--详情
    raiders_refresh_index = "/api/?method=raiders.refresh_index",--刷新
    raiders_buy = "/api/?method=raiders.buy",--购买
    raiders_buy_overdue_raiders = "/api/?method=raiders.buy_overdue_raiders",--购买没中奖的商品

     --一元夺宝转盘
    raiders_roulette_index="/api/?method=raiders.raiders_roulette_index" ,--首页请求
    refresh_raiders_roulette="/api/?method=raiders.refresh_raiders_roulette", --刷新页面
    open_raiders_roulette="/api/?method=raiders.open_raiders_roulette",--单抽
    open_raiders_roulette_10="/api/?method=raiders.open_raiders_roulette_10",--10抽

    --卡牌集换
    card_collection_index = "/api/?method=card_collection.index",
    card_colection_exchange = "/api/?method=card_collection.exchange",--参数：exchange_id: 1
    universe_hero_index = "/api/?method=universe_hero.index", --宇宙最强
    universe_hero_exchange = "/api/?method=universe_hero.exchange", --捐献 参数 exchange_id
    universe_hero_get_reward = "/api/?method=universe_hero.get_reward",--参数 reward_idbuy
    universe_hero_buy = "/api/?method=universe_hero.buy",--参数 reward_id

     --超值签到
    pay_sign_index = "/api/?method=pay_sign.index",
    pay_sign_get_reward = "/api/?method=pay_sign.get_reward", --领奖 reward_id: game_config.value_sign 里的配置id
    pay_sign_replenish_sign = "/api/?method=pay_sign.replenish_sign",--补签  reward_id: game_config.value_sign 里的配置id
    pay_sign_get_month_reward = "/api/?method=pay_sign.get_month_reward", -- 月度奖励

    --卡牌技能切换
    cards_select_skill_index = "/api/?method=cards.select_skill_index", --首页  参数 card_id: 9900-1473601711-fUd7F7
    cards_set_battle_skill = "/api/?method=cards.set_battle_skill",  --设置上阵技能 参数 card_id: 9900-1473601711-fUd7F7 skill_ids: 3_4_5
    cards_unlock_skill = "/api/?method=cards.unlock_skill", --解锁技能 参数 card_id: 9900-1473601711-fUd7F7 skill_ids: 3_4_5

    cards_get_skill_animation = "/api/?method=cards.get_skill_animation",--大招动画 参数 card_id: 9900-1473601711-fUd7F7 skill_id: 910 技能配置id
    fire_chess_index = "/api/?method=fire_chess.index", --火焰棋盘首页
    fire_chess_shuffle_shop = "/api/?method=fire_chess.shuffle_shop",  --火焰棋盘洗牌
    fire_chess_refresh_shop = "/api/?method=fire_chess.refresh_shop",  --火焰棋盘刷新
    fire_chess_choice_reward = "/api/?method=fire_chess.choice_reward",  --火焰棋盘购买   购买id: choice_num  (1~60)
    fire_chess_all_choice_reward = "/api/?method=fire_chess.all_choice_reward",  --火焰棋盘购买
    fire_chess_rank_achievement = "/api/?method=fire_chess.rank_achievement",  --棋盘排名/成就
    fire_chess_get_achievement = "/api/?method=fire_chess.get_achievement",  --领取成就   参数:achievement_id
    new_guild_fight_index = "/api/?method=new_guild_fight.index", --新全服公会战首页
    new_guild_fight_donation = "/api/?method=new_guild_fight.donation",--捐献战旗 参数 num = 1
    new_guild_fight_formation_info = "/api/?method=new_guild_fight.formation_info",--查看自己阵型信息
    new_guild_fight_battlefield_overview  = "/api/?method=new_guild_fight.battlefield_overview",--预览对阵建筑信息
    new_guild_fight_building_info  = "/api/?method=new_guild_fight.building_info",--查看据点信息 building_id: 据点id
    new_guild_fight_battle  = "/api/?method=new_guild_fight.battle",--挑战或占领据点 building_id: 据点id formation_id 用来挑战的阵型id
    new_guild_fight_select_building  = "/api/?method=new_guild_fight.select_building",--部署据点 building_id: 据点id formation_id 用来挑战的阵型id force: 如果阵型已部署在别处，是否强制部署至当前建筑 1|0
    new_guild_fight_give_up_building  = "/api/?method=new_guild_fight.give_up_building",--自己撤回 formation_id
    new_guild_fight_remove_building  = "/api/?method=new_guild_fight.remove_building",--会长踢人 building_id: 需要操作的的地块 idowner_id: 需要删除的owner
    new_guild_fight_clear_cd  = "/api/?method=new_guild_fight.clear_cd",--减cd
    new_guild_fight_see_user_buff = "/api/?method=new_guild_fight.see_user_buff",--看自己的buff
    new_guild_fight_buy_buff = "/api/?method=new_guild_fight.buy_buff",--买自己的buff 参数 tp: buff类型 hp|phsc|mgc|dfs|speed 五维
    new_guild_fight_clear_user_buff = "/api/?method=new_guild_fight.clear_user_buff",--重置个人buff 参数 tp: buff类型 hp|phsc|mgc|dfs|speed 五维
    new_guild_fight_get_battle_log = "/api/?method=new_guild_fight.get_battle_log",--买自己的buff 参数 tp: buff类型 hp|phsc|mgc|dfs|speed 五维
    new_guild_fight_sections = "/api/?method=new_guild_fight.sections",--查看赛程
    -- 公会副本 战斗记录
    association_boss_fight_notice = "/api/?method=association.boss_fight_notice",--参数 ：boss_id=1

    --命运联协刷新
    cards_set_fate="/api/?method=cards.set_fate",
    cards_reset_fate="/api/?method=cards.reset_fate",

    --月初基金
    month_foundation_index="/api/?method=month_foundation.index_foundation",--首页
    month_foundation_activate="/api/?method=month_foundation.activate",--激活
    month_foundation_withdraw="/api/?method=month_foundation.withdraw",--激活


    --vipReward
    vip_reward_sign_index = "/api/?method=vip_reward.sign_index",--奖励首页
    vip_reward_vip_sign = "/api/?method=vip_reward.vip_sign",--七天的奖励 参数 vip 如有代表领取比自己的的vip奖励，没有代表自己vip的奖励
    vip_reward_every_day = "/api/?method=vip_reward.every_day",--每日的奖励

    --新阵法
    cards_activate_bonus_formation = "/api/?method=cards.activate_bonus_formation", --开启位置 参数 pos = 0 - 9
    cards_set_bonus_formation = "/api/?method=cards.set_bonus_formation",-- 设置新助威阵型 参数 formation = 2-1472204437-AbrPfN_0_0_0_0_0_0_0_0 下划线 _ 拼接的9位阵型信息
    cards_set_formation_bonus_addition = "/api/?method=cards.set_formation_bonus_addition",--设置阵法 pos: 0 阵位位置下标 从0开始计数 cards: 3-1472206060-1phuYe_5-1472206368-EouF8d 下划线 _ 拼接的最多8个阵法信息

    --圣石
    god_stone_synthesis="/api/?method=god_stone.synthesis",
    -->>>>>>>>>>ZWJ 圣石合成修复
    god_stone_alignment="/api/?method=god_stone.set_alignment",
    up_load_set_god_field="/api/?method=god_field.up_load_set_god_field",
    --<<<<<<<<<<ZWJ 圣石合成修复

    -- 法宝   zyz
    talisman_level_up_talisman = "/api/?method=talisman.level_up_talisman", -- talisman_id   is_buy  
    talisman_talisman_break = "/api/?method=talisman.talisman_break", -- talisman_id 
    talisman_sell = "/api/?method=talisman.sell", -- talisman_id  

    --宝石进阶
    gem_evolution = "/api/?method=gem.evolution",--宝石进阶 user_token  gem_id super_evo 0|1 是否超进阶 

        --霸王餐    ljx
    free_dinner="/api/?method=overlord_meal.index",--参数 price   6  30
    free_dinner_my_reward="/api/?method=overlord_meal.ownner",

    god_field_god_integration_rank = "/api/?method=god_field.god_integration_rank", --新加排名接口  zyz

    monopoly_index = "/api/?method=monopoly.index", -- 新大富翁
    monopoly_slot = "/api/?method=monopoly.slot", -- 投掷色子
    monopoly_formation_info = "/api/?method=monopoly.formation_info", -- 查看自己的阵容信息
    monopoly_battle = "/api/?method=monopoly.battle", -- 战斗  参数 formation_id=1
    monopoly_use_puzzle = "/api/?method=monopoly.use_puzzle", -- 使用拼图碎片  参数 puzzle_id=1
    monopoly_get_puzzle_reward = "/api/?method=monopoly.get_puzzle_reward", -- 领取拼图奖励
    monopoly_finger_guessing = "/api/?method=monopoly.finger_guessing", -- 赌场猜拳 参数num: 玩家出拳数字 1|2|3
    monopoly_give_up_guessing = "/api/?method=monopoly.give_up_guessing", -- 放弃赌场猜拳
    monopoly_building_info = "/api/?method=monopoly.building_info", -- 查看建筑信息 building_id: 据点id
    monopoly_join_prison = "/api/?method=monopoly.join_prison", -- 蹲监狱 formation_id: 队伍id
    monopoly_buy = "/api/?method=monopoly.buy", -- 购买 num=1
    monopoly_retreat = "/api/?method=monopoly.retreat", -- 撤退 formation_id=1
    monopoly_join_boss_field = "/api/?method=monopoly.join_boss_field", -- 蹲boss formation_id=1
    monopoly_boss_index = "/api/?method=monopoly.boss_index", -- boss页面啊 formation_id=1
    monopoly_boss_fight = "/api/?method=monopoly.boss_fight", -- boss战斗
    monopoly_send_puzzle = "/api/?method=monopoly.send_puzzle", -- 赠送好友碎片 参数 target_id: 好友id  puzzle: 碎片id
    monopoly_top = "/api/?method=monopoly.top", -- 赠送好友碎片 参数 tp: 排行榜类型 energy|slots|prison
    monopoly_donation = "/api/?method=monopoly.donation", -- 占领地块捐献
    monopoly_donation_reawrd_log = "/api/?method=monopoly.donation_reawrd_log", -- 占领地块捐献记录
    monopoly_slot_battle = "/api/?method=monopoly.slot_battle", -- 投三个色子比大小

     --开服霸王餐    ljx
    server_free_dinner="/api/?method=server_overlord_meal.index",--参数 price   6  30
    server_free_dinner_my_reward="/api/?method=server_overlord_meal.ownner",
    --超级大玩家
    super_player_index = "/api/?method=super_player.index",  -- 超级大玩家主界面
    super_player_buy_goods = "/api/?method=super_player.buy_goods",  -- 购买商品   sort_id   good_id
    super_player_get_reward = "/api/?method=super_player.get_reward",  -- 领取奖励  step_id
    super_player_grab_bag = "/api/?method=super_player.grab_bag",  -- 抢红包     bag_code
    super_player_get_rank_info = "/api/?method=super_player.get_rank_info",  -- 排名详情
    super_player_get_bag_code = "/api/?method=super_player.get_bag_code",  -- 抢红包     bag_code
    
    --开服大富翁   zyz
    server_super_tycoon_active_index = "/api/?method=server_richman.index",
    server_super_tycoon_active_roll = "/api/?method=server_richman.roll",--roll 点
    server_super_tycoon_active_fight = "/api/?method=server_richman.fight",--战斗 fight_type : 1打人 2打怪
    server_super_tycoon_active_buy = "/api/?method=server_richman.buy",--购买 shop_type : 1钻石商店， 2勋章换购商店
    server_super_tycoon_active_clear = "/api/?method=server_richman.clear", --调试用
    server_super_tycoon_active_round_reward = "/api/?method=server_richman.round_reward",--领取圈数奖励 参数 round

     --聚宝盆
    bowl_index = "/api/?method=bowl.index",--聚宝盆首页
    bowl_choice = "/api/?method=bowl.choice",--聚宝盆首页 sort抽奖种类 1:普通 2:豪华 3:至尊   num 次数 1 10
    blacklist_index = "/api/?method=user.blacklist_index", 
    blacklist_add = "/api/?method=user.blacklist_add",  --添加黑名单 :  参数： user_id  返回一个 [ ] ； 如果满人 返回一个 {'is_full': 1}
    blacklist_delete = "/api/?method=user.blacklist_delete", -- 删除黑名单: 参数 ： user_id 返回一个 [ ]

    --开服充值   
    server_active_show = "/api/?method=active.server_active_show",
    active_server_active_consume_index = "/api/?method=active.server_active_consume_index",
    active_server_active_consume_receive = "/api/?method=active.server_active_consume_receive",
    active_server_active_recharge_receive = "/api/?method=active.server_active_recharge_receive",

     -- 新转盘
    new_roulette_index = "/api/?method=new_roulette.index",  --首页
    new_roulette_open_new_roulette = "/api/?method=new_roulette.open_new_roulette" , --抽奖
    new_roulette_refresh_new_roulette = "/api/?method=new_roulette.refresh_new_roulette" ,   --刷新奖池

     --家园
    homeland_index = "/api/?method=homeland.index",--家园首页
    homeland_watering = "/api/?method=homeland.watering",--帮好友浇水 farm_id: 1 地块idfriend_uid: h11234568 好友uid
    homeland_get_reward = "/api/?method=homeland.get_reward",--家园领取自己家园奖励 reward_id: 2 奖励id
    homeland_rob_reward = "/api/?method=homeland.rob_reward",--抢夺好友家园奖励 reward_id: 2 奖励id friend_uid: h11234568 好友uid
    homeland_sowing = "/api/?method=homeland.sowing",--家园种植 farm_id: 1 地块id c_id: 2 种植项id
    homeland_havest = "/api/?method=homeland.havest",--家园收获 farm_id: 1 地块id
    homeland_auto_havest = "/api/?method=homeland.auto_havest",--家园一键收获  
    homeland_steal_havest = "/api/?method=homeland.steal_havest",--家园偷取好友收获 farm_id: 1 地块idfriend_uid: h11234568 好友uid
    homeland_cancel_adorn = "/api/?method=homeland.cancel_adorn",--家园取消选用装饰 adorn_id: 1 装饰id
    homeland_use_adorn = "/api/?method=homeland.use_adorn",--家园选用装饰  adorn_id: 1 装饰id
    homeland_store_index = "/api/?method=homeland.store_index",--家园仓库
    homeland_shop_buy = "/api/?method=homeland.shop_buy",--家园商店购买  shop_id: 1 商品id,homeland_shop配置的id is_use: 0 是否购买后直接使用, 0:不使用, 1:使用, 不传默认为0
    homeland_level_up = "/api/?method=homeland.level_up",--建筑升级
    homeland_help = "/api/?method=homeland.help",--家园 帮助好友friend_uid: 帮助的好友uid
    homeland_visit = "/api/?method=homeland.visit",--拜访好友 friend_uid: 好友uid
    homeland_random_users = "/api/?method=homeland.random_users",--全服农场列表
    homeland_friends = "/api/?method=homeland.friends",--好友列表
    hoemland_roulette_index = "/api/?method=homeland.roulette_index",
    hoemland_roulette_refresh = "/api/?method=homeland.roulette_refresh",
    hoemland_open_roulette = "/api/?method=homeland.open_roulette",
    hoemland_open_roulette10 = "/api/?method=homeland.open_roulette10",
    homeland_finger_guessing = "/api/?method=homeland.finger_guessing",
    --  雪人相关   
    snow_index = "/api/?method=snowman.index",  -- 雪人主界面 
    snow_make_snowman = "/api/?method=snowman.make_snowman", -- 堆雪人  snow_id:雪人id,ball_id:雪球id,num:数量
    snow_rank_info = "/api/?method=snowman.rank_info", -- 排行榜 
    snow_score_exchange = "/api/?method=snowman.score_exchange", -- 兑换  id :兑换id
    snow_snowman_photo = "/api/?method=snowman.snowman_photo",  -- 雪人图鉴
    snow_get_photo_reward = "/api/?method=snowman.get_photo_reward", -- 领取雪人图鉴奖励  
    snow_get_reward = "/api/?method=snowman.get_reward", -- 奖励领取  step_id:奖励id
    --星域竞技场  
    universe_arena_index = "/api/?method=universe_arena.index", --主页
    universe_arena_team_index = "/api/?method=universe_arena.team_index", --单个小队页面信息  参数 team_id:1
    universe_arena_upload_god_formation = "/api/?method=universe_arena.upload_god_formation", --加载神域阵型
    universe_arena_universe_arena_battle = "/api/?method=universe_arena.universe_arena_battle", --战斗  参数 team_id:1
    universe_arena_get_battle_tips = "/api/?method=universe_arena.get_battle_tips", --战斗记录   参数 team_id:1
    universe_arena_get_rank_info = "/api/?method=universe_arena.get_rank_info", --获取排名信息   参数 team_id:1
    universe_arena_shop_index = "/api/?method=universe_arena.shop_index", --商店首页   参数 team_id:1
    universe_arena_buy_goods = "/api/?method=universe_arena.buy_goods", --购买商品   参数 team_id:1    goods_id:1
    universe_arena_secore_reward_index = "/api/?method=universe_arena.secore_reward_index", --积分奖励   参数 team_id:1
    universe_arena_get_reward = "/api/?method=universe_arena.get_reward", --领取积分奖励   参数 team_id:1    reward_id:1
    universe_arena_set_god_field = "/api/?method=universe_arena.set_god_field", --设置阵型   
    universe_arena_hero_rank = "/api/?method=universe_arena.hero_rank", --英雄榜   
    universe_arena_get_battle_logs ="/api/?method=universe_arena.get_battle_logs",--战斗回放
     --卡牌培养
    trainning_index = "/api/?method=card_develop.card_develop_index",
    trainning_reward = "/api/?method=card_develop.training_reward", -- training_type  setp 进阶 bre 转生 super_step 超进化
    trainning_select  = "/api/?method=card_develop.select_card_index",
    trainning_get_reward ="/api/?method=card_develop.get_reward_training",
        --名人堂
    cards_famous_index = "/api/?method=cards.famous_index", --主页
    cards_famous_set = "/api/?method=cards.famous_set", --设置主卡   参数  famous_id   card_id
    cards_famous_bonus = "/api/?method=cards.famous_bonus", --设置八门    参数  famous_id   gates(八门)    attrs(属性加成)
    cards_strengthen = "/api/?method=cards.strengthen", --设置技能点加成     参数 famous_id: 1 #名人堂id  strengthen: 0_0_0_1_0 # 五维属性 分别对应 'patk', 'matk', 'def', 'speed', 'hp'
    cards_famous_bonus_get = "/api/?method=cards.famous_bonus_get", --查看主卡     参数  famous_id
    cards_famous_like = "/api/?method=cards.famous_like", --点赞    参数  famous_id   uid
    cards_famous_one_card_info = "/api/?method=cards.famous_one_card_info", --卡牌信息  参数  famous_id   uid


    -- 组队副本
    team_fight_index = "/api/?method=team_fight.team_fight_index",                       -- 主页
    team_fight_get_reward = "/api/?method=team_fight.get_reward",                        -- 领取奖励
    team_fight_team_own = "/api/?method=team_fight.team_own",                            -- 查看自己队伍
    team_fight_team_index = "/api/?method=team_fight.teams_index",                        -- 特定boss特定难度的所有队伍   参数    boss_id：1    boss_level：1
    team_fight_team_data = "/api/?method=team_fight.team_data",                          -- 队伍信息  参数   team_i：""
    team_fight_cards_for_team_creat = "/api/?method=team_fight.cards_for_team_creat",    -- 创建队伍   参数    boss_id：1    boss_level：1
    team_fight_creat_team = "/api/?method=team_fight.creat_team",                        -- 创建队伍    参数    boss_id：1    boss_level：1  cards_id :""  
    team_fight_cards_for_join_team = "/api/?method=team_fight.cards_for_join_team",      --  加入队伍首页   参数  team_id：""
    team_fight_join_team = "/api/?method=team_fight.join_team",                          -- 加入队伍    参数    team_id：""  cards_id :""
    team_fight_set_aligment = "/api/?method=team_fight.set_aligment",                    -- 设置阵型     参数：   team_id      align_1
    team_fight_battle = "/api/?method=team_fight.battle",                                -- 战斗  cards_id    team_id
    team_fight_invit_friend_index = "/api/?method=team_fight.invit_friend_index",        -- 邀请  cards_id    team_id
    team_fight_invit_friend = "/api/?method=team_fight.invit_friend",                    -- 发送邀请邮件  f_uid    team_id
    team_fight_accept_invitation = "/api/?method=team_fight.accept_invitation",          -- 接受邀请  message_id    team_id
    team_fight_refuse_invitation = "/api/?method=team_fight.refuse_invitation",          -- 拒接邀请  message_id    
    team_fight_team_fight_messages = "/api/?method=team_fight.team_fight_messages",      -- 邀请组队邮件  cards_id    team_id
    --皮肤
    cards_buy_skin = "/api/?method=cards.buy_skin", --购买卡牌皮肤 参数 skin_id = 1111
    cards_use_skin = "/api/?method=cards.use_skin", --购买卡牌皮肤 参数 skin_ids = 1111

    new_guild_fight_new_ui_index = "/api/?method=new_guild_fight.new_ui_index",--第三版公会战 首页接口
    new_guild_fight_guild_sign_up = "/api/?method=new_guild_fight.guild_sign_up",--第三版公会战 报名接口
    new_guild_fight_battlefield_overview  = "/api/?method=new_guild_fight.battlefield_overview",--预览对阵建筑信息
    new_guild_fight_register="/api/?method=new_guild_fight.register",--报名
    new_guild_fight_log_out="/api/?method=new_guild_fight.log_out", --退出
    new_guild_fight_integral_index="/api/?method=new_guild_fight.integral_index",--工会战排行
    new_guild_fight_battle_list = "/api/?method=new_guild_fight.battle_list",--对战列表
    new_guild_fight_employ_pub_ed = "/api/?method=new_guild_fight.employ_pub_ed",--玩家挑选公会发布信息展示页  参数 tp   第几页
    new_guild_fight_pub_employ_message_index = "/api/?method=new_guild_fight.pub_employ_message_index",--玩家阵型信息  参数uid
    new_guild_fight_week_reward_index = "/api/?method=new_guild_fight.week_reward_index",--周奖励界面


    --羊驼快跑  ljx
    yato_running_index = "/api/?method=race.index",--主页
    yato_running_apply = "/api/?method=race.apply",--报名 sort  1 2 3
    yato_running_affect = "/api/?method=race.affect",--加油 干扰   参数type 1,-1   sort 1 2 3
    yato_running_buy_lottery = "/api/?method=race.buy_lottery",--购买竞猜卷

    -- new_guild_fight_ui_index="/api/?method=new_guild_fight.ui_index", --工会战主页
    -- new_guild_fight_detail_index="/api/?method=new_guild_fight.detail_index", --详情
    -- new_guild_fight_convention_overview="/api/?method=new_guild_fight.convention_overview",--匹配信息
    -- new_guild_fight_index = "/api/?method=new_guild_fight.index", --新全服公会战首页
    -- new_guild_fight_donation = "/api/?method=new_guild_fight.donation",--捐献战旗 参数 num = 1
    -- new_guild_fight_formation_info = "/api/?method=new_guild_fight.formation_info",--查看自己阵型信息
    -- new_guild_fight_pub_employ_message = "/api/?method=new_guild_fight.pub_employ_message",--发布雇佣信息参数 coin 钻石 num 雇佣人数
    -- new_guild_fight_sign_up_employ = "/api/?method=new_guild_fight.sign_up_employ",--雇佣  参数   ass_id  工会id
    -- new_guild_fight_give_up_sign_up_employ = "/api/?method=new_guild_fight.give_up_sign_up_employ",--放弃报名 参数 公会id
    -- new_guild_fight_employ_ground = "/api/?method=new_guild_fight.employ_ground",--公会挑选玩家信息列表 
    -- new_guild_fight_employ_user = "/api/?method=new_guild_fight.employ_user",--公会挑选佣兵 参数 uid 玩家uid
    -- new_guild_fight_users_info = "/api/?method=new_guild_fight.users_info",--玩家阵型信息  参数uid

    -- new_guild_fight_unlock_pos = "/api/?method=new_guild_fight.unlock_pos",--解锁招募位置   
    -- new_guild_fight_index_loop = "/api/?method=new_guild_fight.index_loop",--循环赛阶段首页   
    -- new_guild_fight_buy_user_hot = "/api/?method=new_guild_fight.buy_user_hot",--鼓舞
    -- new_guild_fight_emeploy_list = "/api/?method=new_guild_fight.emeploy_list",--雇佣记录

    -- new_guild_fight_get_week_reward = "/api/?method=new_guild_fight.get_week_reward",--领奖 参数 reward_id 奖励id tp 类型 周奖励  week 月奖励  month

     --砸金蛋。 
    egg_index = "/api/?method=egg.egg_index",
    open_egg = "/api/?method=egg.open_egg",--参数。egg_type 1金蛋 2彩蛋   is_super  1使用道具 0不使用道具
    refresh_egg = "/api/?method=egg.refresh_egg",--。egg_type 1金蛋 2彩蛋
    --命运宝石合成  
    gem_fate_synthesis_gem_fate = "/api/?method=gem_fate.synthesis_gem_fate",--合成 gem_id : 401 需要合成的命运宝石id gem_num : 1 合成的数量
    gem_fate_using_gem_fate = "/api/?method=gem_fate.using_gem_fate",--镶嵌 参数 major : 5 镶嵌命运宝石的装备id gem_fates : 101_205_105_105 镶嵌的宝石id
    gem_fate_remove_gem_fate = "/api/?method=gem_fate.remove_gem_fate",--移除宝石 参数 major : 51 移除命运宝石的装备id gem_fates: 101_0_0_0 移除的宝石id
    -- 幸运彩票
    lottery_index = "/api/?method=luck_lottery.index",    -- 主页面
    lottery_betting = "/api/?method=luck_lottery.betting",    -- 投注
    lottery_get_join_reward = "/api/?method=luck_lottery.get_join_reward",    -- 累计奖励
    lottery_get_betting_number = "/api/?method=luck_lottery.get_betting_number",    -- 投注记录

    --累计充值
    recharge_index = "/api/?method=recharge_package.package_index",
    recharge_get = "/api/?method=recharge_package.get_reward",

 -- 星系霸主 
    guild_robbery_index = "/api/?method=guild_robbery.index",                            -- 主页
    guild_robbery_go_mountain = "/api/?method=guild_robbery.go_mountain",                -- 进入星球      参数 mountain_id
    guild_robbery_pos_info = "/api/?method=guild_robbery.pos_info",                      -- 查看坑位信息   参数  mountain_id  pos
    guild_robbery_battle = "/api/?method=guild_robbery.battle",                          -- battle       参数  mountain   pos   team_id
    guild_robbery_back_battle = "/api/?method=guild_robbery.back_battle",                -- 回放战斗
    guild_robbery_user_item = "/api/?method=guild_robbery.user_item",                    -- 使用道具       参数  item_id   team_id    mountain_id    pos
    guild_robbery_notice_index = "/api/?method=guild_robbery.notice_index",              -- 公告
    guild_robbery_set_notice = "/api/?method=guild_robbery.set_notice",                  -- 写公告         参数  notice
    guild_robbery_formation_info = "/api/?method=guild_robbery.formation_info",          -- 阵型        
    guild_robbery_see_reward = "/api/?method=guild_robbery.see_reward",                  -- 预览        
    guild_robbery_get_rank = "/api/?method=guild_robbery.get_rank_for_guild",            -- 预览        
    guild_robbery_see_reward_for_persion = "/api/?method=guild_robbery.see_reward_for_persion",            -- 预览        
    guild_robbery_shop_buy = "/api/?method=guild_robbery.shop_buy",            -- 预览  
    guild_robbery_user_item = "/api/?method=guild_robbery.user_item",            -- 预览  
    guild_robbery_get_logs = "/api/?method=guild_robbery.get_logs",            -- 预览 

-- 抓娃娃
    toy_toy_index = "/api/?method=toy.toy_index",                     -- 抓娃娃主页
    toy_get_toy = "/api/?method=toy.get_toy",                     -- 判断娃娃
    toy_get_rank = "/api/?method=toy.get_rank",                     -- 抓娃娃排行    
     -- 玲珑宝塔
    pagoda_pagoda_index =  "/api/?method=pagoda.pagoda_index",      -- 宝塔主页
    pagoda_lantern =  "/api/?method=pagoda.lantern",      -- 宝塔点灯
    pagoda_get_floor_reward =  "/api/?method=pagoda.get_floor_reward",      -- 宝塔领奖 

    --新大富翁深渊boss
    depth_boss_index = "/api/?method=monopoly.depth_boss_index",
    depth_boss_fight = "/api/?method=monopoly.depth_boss_fight",
    depth_select_skill_index = "/api/?method=monopoly.select_skill_index",

    --世界杯集国旗
    world_cup_flag_index = "/api/?method=world_cup_flag.index",  --主页
    world_cup_flag_use_flag = "/api/?method=world_cup_flag.use_flag",   --点亮国旗
    world_cup_flag_choose_heart = "/api/?method=world_cup_flag.choose_heart",    --点亮心
    world_cup_flag_send_friend = "/api/?method=world_cup_flag.send_friend",    --赠送好友
    world_cup_flag_get_reward = "/api/?method=world_cup_flag.get_reward",    --领取点心奖励
    world_cup_flag_get_big_reward = "/api/?method=world_cup_flag.get_big_reward",    --领取大奖
        --足球竞猜
    world_cup_guess_index = "/api/?method=world_cup_guess.index",
    world_cup_guess_guess_result = "/api/?method=world_cup_guess.guess_result",
    world_cup_guess_exchange_refresh = "/api/?method=world_cup_guess.exchange_refresh",
    world_cup_guess_exchange_item = "/api/?method=world_cup_guess.exchange_item",
    world_cup_guess_get_achievement = "/api/?method=world_cup_guess.get_achievement",

     -- 偶像英雄祭
    idol_festival_index = "/api/?method=idol_festival.index",   --主界面
    idol_festival_hit_call = "/api/?method=idol_festival.hit_call",   
    idol_festival_get_persion_award = "/api/?method=idol_festival.get_persion_award",   
    idol_festival_get_all_server_awardit_call = "/api/?method=idol_festival.get_all_server_award",   

    -- 法宝淬炼
    talisman_forging = "/api/?method=talisman.talisman_forging", -- 技能 
    talisman_forging_effect = "/api/?method=talisman.talisman_forging_effect", -- 特效 
    talisman_skill_save = "/api/?method=talisman.talisman_skill_save", -- 通用保留

    --元素突破
    element_break = "/api/?method=cards.element_break",   
    element_query = "/api/?method=cards.element_query", --元素查询

    --宇宙神射
    god_shot_index = "/api/?method=god_shot.god_shot_index",  --主页
    god_shot_add_score = "/api/?method=god_shot.god_shot_add_score",
    god_shot_shop_index = "/api/?method=god_shot.god_shot_shop_index",
    god_shot_shop_exchange = "/api/?method=god_shot.god_shot_shop_exchange",
    god_shot_exchange = "/api/?method=god_shot.exchange", -- 新增购买次数

     --拼图大作战
    jigsaw_jigsaw_index = "/api/?method=jigsaw.jigsaw_index",       --首页
    jigsaw_finish_jigsaw = "/api/?method=jigsaw.finish_jigsaw",       --合成拼图
    jigsaw_get_jigsaw_reward = "/api/?method=jigsaw.get_jigsaw_reward",       --领取拼图奖励
    jigsaw_my_jigsaw_index = "/api/?method=jigsaw.my_jigsaw_index",       --我的拼图首页
    jigsaw_my_use_jigsaw = "/api/?method=jigsaw.use_my_jigsaw",       --使用拼图


    --盛典狂欢
    celebration_show = "/api/?method=celebration.cb_show",       --首页
    celebration_red_packet_index = "/api/?method=celebration.cb_red_packet_index",   --盛典每日登陆红包首页
    celebration_red_packet_receive = "/api/?method=celebration.cb_red_packet_receive",      --盛典每日登陆红包领奖

    celebration_recharge_index = "/api/?method=celebration.cb_recharge_index",       --盛典每日(累计)充值首页
    celebration_recharge_receive = "/api/?method=celebration.cb_recharge_receive",   --盛典每日(累计)充值奖励领取

    celebration_consume_index = "/api/?method=celebration.cb_consume_index",      --盛典累计消费首页
    celebration_consume_receive = "/api/?method=celebration.cb_consume_receive",  --盛典累计消费奖励领取

    celebration_daily_recharge_index = "/api/?method=celebration.cb_daily_recharge_index",      --盛典连续充值首页
    celebration_daily_recharge_receive = "/api/?method=celebration.cb_daily_recharge_receive",  --盛典连续充值奖励领取

    celebration_task_index = "/api/?method=celebration.cb_task_index",      --盛典任务首页
    celebration_task_receive = "/api/?method=celebration.cb_task_receive",  --盛典任务奖励领取
    celebration_task_score_receive = "/api/?method=celebration.cb_task_score_receive",  --盛典任务积分奖励领取

    --我是大富翁
    super_luck_index = "/api/?method=super_luck.index",    --首页
    super_luck_throw_dice = "/api/?method=super_luck.throw_dice",    --投掷骰子
    super_luck_walk_in_luck_unit = "/api/?method=super_luck.walk_in_luck_unit",    --走到运气格
    super_luck_luck_return_start = "/api/?method=super_luck.luck_return_start",    --运气格结果为直接过圈到达起点时
    super_luck_shop_index = "/api/?method=super_luck.shop_index",    --商店首页
    super_luck_shop_exchange = "/api/?method=super_luck.shop_exchange",    --商店兑换
    super_luck_close_limit_time_shop = "/api/?method=super_luck.close_limit_time_shop",    --商店兑换

    --限时远征
    limit_time_war_index = "/api/?method=limit_time_war.index" ,      --首页
    limit_time_war_choose_task = "/api/?method=limit_time_war.choose_task",   --选择指定任务
    limit_time_war_start_task = "/api/?method=limit_time_war.start_task",       --出征
    limit_time_war_get_reward = "/api/?method=limit_time_war.get_task_reward",       --领取出征奖励
    limit_time_war_finish_task = "/api/?method=limit_time_war.immediately_finish_task",       --立即完成指定任务

    --命运符文
    cards_fate_rune_index = "/api/?method=cards.fate_rune_index",    --首页
    fate_rune_get_cards = "/api/?method=cards.get_fate_rune_cards",    --获取所有命运符文可上阵卡牌
    fate_rune_set_cards = "/api/?method=cards.set_fate_rune_cards",        --上阵/更换命运符文卡牌
    -- [血石赋能] 
    gem_fate_empowering = "/api/?method=gem_fate.empowering",
    gem_fate_printing = "/api/?method=gem_fate.printing",
    gem_fate_transfer = "/api/?method=gem_fate.transfer",
    cards_fate_rune_query = "/api/?method=cards.query_fate_rune_attrs",        --符文查询
    cards_refresh_fate_rune = "/api/?method=cards.refresh_fate_rune",        --刷新符文
    cards_lock_fate_rune = "/api/?method=cards.lock_fate_rune",        --锁定符文

    --超级返利
    bigholiday_get_reward = "/api/?method=bigholiday.get_reward",-- 返利活动领取奖励
    bigholiday_index = "/api/?method=bigholiday.index",-- 返利活动首页

    -- 团队副本
    team_raid_index = "/api/?method=team_raid.team_raid_index",                     -- 首页
    team_raid_sign_up = "/api/?method=team_raid.sign_up",                           --报名     type  1 # 1为个人 2为公会
    team_raid_cards_for_team = "/api/?method=team_raid.cards_for_team",             -- 获取所有符合条件卡牌
    team_raid_create_group = "/api/?method=team_raid.create_group",                 -- 创建团 type   choose_card
    team_raid_persion_raid_index = "/api/?method=team_raid.persion_raid_index",     -- 攻坚团首页 raid_id
    team_raid_apply_for_raid = "/api/?method=team_raid.apply_for_raid",             -- 申请参团  raid_id   cards_ids   
    team_raid_apply_index = "/api/?method=team_raid.apply_index",                   -- 申请列表 page   raid_id 
    team_raid_adopt_apply = "/api/?method=team_raid.adopt_apply",                   -- 同意申请 player_id cards_id    page
    team_raid_refuse_apply = "/api/?method=team_raid.refuse_apply",                 -- 拒绝申请 player_id   
    team_raid_get_out_raid = "/api/?method=team_raid.get_out_raid",                 -- 团队踢人 player_id
    team_raid_select_team = "/api/?method=team_raid.select_team",                   -- 编队 team_1  h11234567_0_0_0_0 #一直到team_12                     
    team_raid_start_raid = "/api/?method=team_raid.start_raid",                    -- 开始攻坚
    team_raid_get_aligment = "/api/?method=team_raid.get_aligment",                 -- 获取阵型 raid_id
    team_raid_set_aligment = "/api/?method=team_raid.set_aligment",                 -- 设置阵型 align_1    raid_id
    team_raid_fight_stage_1_1 = "/api/?method=team_raid.fight_stage_1_1",           -- 1_1阶段战斗 position   raid_id
    team_raid_fight_stage_1_2 = "/api/?method=team_raid.fight_stage_1_2",           -- 1_2阶段战斗 position   raid_id
    team_raid_fight_stage_2_1 = "/api/?method=team_raid.fight_stage_2_1",           -- 2_1阶段战斗 position   raid_id
    team_raid_fight_stage_2_2 = "/api/?method=team_raid.fight_stage_2_2",           -- 2_2阶段战斗 position   raid_id
    team_raid_fight_stage_3 = "/api/?method=team_raid.fight_stage_3",               -- 第三阶段战斗    position   raid_id
    team_raid_search_raid_index =  "/api/?method=team_raid.search_raid_index",      -- 攻坚队列表     type    page
    team_raid_dismiss_raid =  "/api/?method=team_raid.dismiss_raid",                -- 解散列表     raid_id
    team_raid_quit_raid =  "/api/?method=team_raid.quit_raid",                      -- 退出攻坚队     raid_id
    team_raid_search_one_raid =  "/api/?method=team_raid.search_one_raid",          -- 搜索攻坚队     owner_uid
    
    -- 虫洞   
    wormholes_index = "/api/?method=wormholes_field.wormholes_index",           -- 首页
    wormholes_get_rank = "/api/?method=wormholes_field.get_rank",               -- 排行
    wormholes_get_sort_cards = "/api/?method=wormholes_field.get_sort_cards",   -- 
    wormholes_set_sort_field = "/api/?method=wormholes_field.set_sort_field",   -- POST
    wormholes_go_map = "/api/?method=wormholes_field.go_map",                   -- &sort
    wormholes_go_fight = "/api/?method=wormholes_field.fight",                  -- &sort
    wormholes_get_user_info = "/api/?method=wormholes_field.get_user_info",     -- &sort
    wormholes_buy_point = "/api/?method=wormholes_field.buy_point",             -- &sort
    
    -- 赋能大赛
    funeng_task_index = "/api/?method=funeng.task_index",
    funeng_task_gift = "/api/?method=funeng.task_gift",
    funeng_rank_index = "/api/?method=funeng.rank_index",
    funeng_rank_list = "/api/?method=funeng.rank_list",
    funeng_gacha_index = "/api/?method=funeng.gacha_index",
    funeng_get_gacha = "/api/?method=funeng.get_gacha",

    --使用称号
    user_use_title = "/api/?method=user.use_title",
    user_title_index = "/api/?method=user.title_index",

    -- 坠落之地
    guild_high_war_index = "/api/?method=guild_high_war.index",--首页
    guild_high_war_declare_war = "/api/?method=guild_high_war.declare_war",--宣战
    guild_high_war_stationed = "/api/?method=guild_high_war.stationed",--驻守
    guild_high_war_set_first_alignment = "/api/?method=guild_high_war.set_first_alignment",--置顶队伍 set_type 0 防守 1 进攻
    guild_high_war_set_fight_alignment = "/api/?method=guild_high_war.set_fight_alignment",--设置进攻队伍
    guild_high_war_alignment_info = "/api/?method=guild_high_war.alignment_info",--队伍信息
    guild_high_war_explore_index = "/api/?method=guild_high_war.explore_index",-- 探索首页
    guild_high_war_stationed_fate = "/api/?method=guild_high_war.stationed_fate",-- 驻扎探索之地
    guild_high_war_down_alignment_fate = "/api/?method=guild_high_war.down_alignment_fate",-- 下阵探索 -- t_uid=h11234569&alignment=1&city_id=1001
    guild_high_war_explore = "/api/?method=guild_high_war.explore",-- 探索
    guild_high_war_get_fate_reward = "/api/?method=guild_high_war.get_fate_reward",-- 领取探索奖励
    guild_high_war_shop_index = "/api/?method=guild_high_war.shop_index",-- 商店首页
    guild_high_war_buy = "/api/?method=guild_high_war.buy",-- 购买商品
    guild_high_war_contribute = "/api/?method=guild_high_war.contribute",-- 贡献科技 contribute_type 1 免费, 2付费
    guild_high_war_get_rank = "/api/?method=guild_high_war.get_rank",-- 查看排行1 公会排行, 0 个人排行
    guild_high_war_dolike = "/api/?method=guild_high_war.dolike",-- 点赞 -- t_uid
    guild_high_war_war_index = "/api/?method=guild_high_war.war_index",-- 战令奖励
    guild_high_war_get_war_reward = "/api/?method=guild_high_war.get_war_reward",-- 领取战令奖励 reward_type 1 付费 0 免费  reward_id
    guild_high_war_auto_get_war_reward = "/api/?method=guild_high_war.auto_get_war_reward",-- 一键领取战令奖励 reward_type 1 付费 0 免费  
    guild_high_war_send_war_card = "/api/?method=guild_high_war.send_war_card",-- 送战令
    guild_high_war_player_index = "/api/?method=guild_high_war.player_index",-- 赠送战令名单
    guild_high_war_select_reward = "/api/?method=guild_high_war.select_reward",-- 选宝箱
    guild_high_war_stationed_source = "/api/?method=guild_high_war.stationed_source",-- 驻守资源地
    guild_high_war_declare_war_source = "/api/?method=guild_high_war.declare_war_source",-- 抢夺资源地
    guild_high_war_down_alignment_source = "/api/?method=guild_high_war.down_alignment_source",-- 下阵资源 -- t_uid=h11234569&alignment=1&city_id=1001&block_id=1
    guild_high_war_map_index = "/api/?method=guild_high_war.map_index",-- 地图首页
    guild_high_war_city_info = "/api/?method=guild_high_war.city_info",-- 城市信息
    guild_high_war_box_index = "/api/?method=guild_high_war.box_index",-- 奖励首页
    guild_high_war_science_index = "/api/?method=guild_high_war.science_index",-- 科技首页
    guild_high_war_record = "/api/?method=guild_high_war.record",-- 回放 -- att_uid=111&def_uid=222&city_id=1001
    guild_high_war_get_guild_record = "/api/?method=guild_high_war.get_guild_record",-- 所有城市记录 
    guild_high_war_get_city_record = "/api/?method=guild_high_war.get_city_record",-- 一个城市战斗记录 -- city_id=1001
    guild_high_war_science_rank = "/api/?method=guild_high_war.science_rank",-- 科技排行
    guild_high_war_get_science_star = "/api/?method=guild_high_war.get_science_star",-- 领取科技里程碑奖励

    -- 雇佣兵
    guild_high_war_employ_index = "/api/?method=guild_high_war.employ_index", --  雇佣兵-首页
    guild_high_war_employ_join = "/api/?method=guild_high_war.employ_join", --  雇佣兵-申请加入
    guild_high_war_employ_agree = "/api/?method=guild_high_war.employ_agree", --  雇佣兵-同意加入
    guild_high_war_employ_quit = "/api/?method=guild_high_war.employ_quit", --  雇佣兵-离开
    guild_high_war_employ_remove = "/api/?method=guild_high_war.employ_remove", --  雇佣兵-解雇
    guild_high_war_employ_guild_index = "/api/?method=guild_high_war.employ_guild_index", --  雇佣兵-申请界面
    guild_high_war_employ_refuse = "/api/?method=guild_high_war.employ_refuse", --  雇佣兵-拒绝

    yunxin_get_accid = "/api/?method=yunxin.get_accid", -- 云信聊天获取accid
    yunxin_get_chatroom = "/api/?method=yunxin.get_chatroom", -- 云信聊天获取世界聊天室
    yunxin_get_team = "/api/?method=yunxin.get_team", -- 云信聊天获取
    yunxin_chat_info = "/api/?method=yunxin.chat_info",
    yunxin_friend_list = "/api/?method=yunxin.friend_list",  --可聊天的好友列表
    yunxin_send_log = "/api/?method=yunxin.send_log",  --时间发言限制
    yunxin_user_limit = "/api/?method=yunxin.user_limit",

    --使用代金券
    payment_use_ticket = "/api/?method=payment.use_ticket",
    -- 超级仓库
    storehouse_store_card = "/api/?method=storehouse.store_card", --  仓库-存卡
    storehouse_del_card = "/api/?method=storehouse.del_card", --  仓库-取卡
    storehouse_store_item = "/api/?method=storehouse.store_item", --  仓库-存道具
    storehouse_del_item = "/api/?method=storehouse.del_item", --  仓库-取道具
    storehouse_store_equip = "/api/?method=storehouse.store_equip", --  仓库-存装备
    storehouse_del_equip = "/api/?method=storehouse.del_equip", --  仓库-取装备
    storehouse_store_talisman = "/api/?method=storehouse.store_talisman", --  仓库-存法宝
    storehouse_del_talisman = "/api/?method=storehouse.del_talisman", --  仓库-取法宝

    -- 神域押镖
    highway_index = "/api/?method=highway.index", --  神域押镖-首页
    highway_task_index = "/api/?method=highway.task_index", --  神域押镖-任务列表
    highway_all_area_index = "/api/?method=highway.all_area_index", --  神域押镖-所有区域
    highway_shop_index = "/api/?method=highway.shop_index", --  神域押镖-商店
    highway_buy = "/api/?method=highway.buy", --  神域押镖-购买
    highway_refresh_shop = "/api/?method=highway.refresh_shop", --  神域押镖-刷新商店
    highway_trans = "/api/?method=highway.trans", -- 神域押镖-转换
    highway_trans_index = "/api/?method=highway.trans_index", -- 神域押镖-转换
    highway_all_area_index = "/api/?method=highway.all_area_index", -- 神域押镖-所有区域
    highway_area_index = "/api/?method=highway.area_index", -- 神域押镖-区域
    highway_betting = "/api/?method=highway.betting", -- 神域押镖-押注
    highway_add_buff = "/api/?method=highway.add_buff", -- 神域押镖-buff
    highway_add_power = "/api/?method=highway.add_power", -- 神域押镖-增加体力
    highway_rank_index = "/api/?method=highway.rank_index", -- 神域押镖-排行榜
    highway_week_rank_index = "/api/?method=highway.week_rank_index", -- 神域押镖-周排行榜
    highway_get_score_reward = "/api/?method=highway.get_score_reward", -- 神域押镖-领取宝箱奖励
    highway_get_task_reward = "/api/?method=highway.get_task_reward", -- 神域押镖-领取任务奖励
    highway_refresh_trans_items = "/api/?method=highway.refresh_trans_items",
    highway_income_index = "/api/?method=highway.income_index",
    highway_milestone_index = "/api/?method=highway.milestone_index",
    highway_reward_index = "/api/?method=highway.reward_index",

    --开服集换   zyz
    server_card_collection_index = "/api/?method=server_card_collection.index",
    server_card_colection_exchange = "/api/?method=server_card_collection.exchange",--参数：exchange_id: 1

    crowdfunding_index = "/api/?method=crowdfunding.index",--首页
    crowdfunding_add_lucky_num = "/api/?method=crowdfunding.add_lucky_num",--增加幸运数字

    --神域排行榜
    god_field_get_combat_rank_guild = "/api/?method=god_field.get_combat_rank_guild", --公会排行
    god_field_get_combat_rank = "/api/?method=god_field.get_combat_rank", -- 个人排行
};
--[[--
    game_url:
        遊戲邏輯接口，訪問的是各個應用服務器，沒有固定域名和ip
    dataosha_url_config:
        訪問團戰服務器，沒固定域名和ip
    login_url_config:
        用於登錄的服務器，域名和ip基本不變（不保證
        sdk的登錄和付費都放在login_url_config表中
]]
local dataosha_url_config = {
    battle_royale_join_game = "/?method=join_game", -- 大逃殺報名
    battle_royale_attack = "/?method=attack", -- 大逃殺 game_id=1001&round_id=2&forward=3
    battle_royale_start = "/?method=start", -- 大逃殺
}
--[[--
    game_url:
        遊戲邏輯接口，訪問的是各個應用服務器，沒有固定域名和ip
    dataosha_url_config:
        訪問團戰服務器，沒固定域名和ip
    login_url_config:
        用於登錄的服務器，域名和ip基本不變（不保證
        sdk的登錄和付費都放在login_url_config表中
]]
local login_url_config = {  -- 走master服務器的配置
    new_account = "/login/?method=new_account", -- 如果用戶沒有賬戶，給他一個臨時的
    user_login = "/login/?method=login",--用戶註冊 user_name=ddd&password=123
    user_server_list = "/login/?method=get_user_server_list",--前端通過保存的account，獲得用戶的server_list數據
    user_server_list_huawei = "/login/?method=get_user_server_list_huawei",--前端通過保存的account，獲得用戶的server_list數據
    user_register = "/login/?method=register",--用戶註冊 role=1&show_name=
    -- loading = "/login/?method=loading",--
    -- loading_for_test = "/login/?method=loading_for_test",

    --一下url只能放在login_url_config裡

    get_vivo_order_id = "/pay/?method=get_vivo_order",--為vivo使用，去服務端取訂單號的接口
    get_query_order = "/pay/?method=query_vivo_order",--為vivo使用，去服務端查詢訂單是否成功的接口
    get_jinli_order = "/pay/?method=get_jinli_order",--金立獨家專享
    get_user_id = "/login/?method=platform_access",--通過code取userID，app_type 0:1 channel:cmge
    pay_respon_url = "/pay/?method=get_notify_urls",

    -- 邀请码
    invite_code_index = "/api/?method=invite_code.index", -- 首页
    invite_code_add_invite_code = "/api/?method=invite_code.add_invite_code", -- 提交

    }
--[[--
    獲得完整的url
]]
function game_url.getUrlForKey(key)
    --每个请求后加一个随机数
    local random = math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local randomNum = math.random(1,10000)--从里面随机取一个
    local url = nil;
    print( game_url[key], key)
    if game_url[key] then
        url = service_url .. game_url[key];
    elseif login_url_config[key] then
        url = master_url .. login_url_config[key];
    elseif dataosha_url_config[key] then
        url = dataosha_url .. dataosha_url_config[key];
    end
    if url ~= nil then
        url = url .. "&user_token=" .. user_token .. "&mk=" .. mark_user_login_mk .. "&rand=" .. randomNum;
        -- url = url .. "&user_token=" .. "vn73834155" .. "&frontwindow=72540eeeb8f8e9343e71f281"--vnt185324969
        url = url .. "&version=" .. CLIENT_VERSION.."&rans=" .. rand_str;
        url = url .. "&pt=" .. device_platform .. "&device_mark=" .. device_mark .. "&platform_channel=" .. platform_channel .. "&device_mem=" .. tostring(util_system:getTotalMemory())
    end
    return url;
end

return game_url;
