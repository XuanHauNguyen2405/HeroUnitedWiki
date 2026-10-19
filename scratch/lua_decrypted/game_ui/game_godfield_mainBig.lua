local helper = require("lua/game_pop/game_god_escort_helper")
local cosmicMgr = require("game_ui.cosmicMgr")

--神域
local game_godfield_mainBig = {
 	m_back_btn = nil,
 	anim_node = nil,
 	m_shenyu_btn = nil,
 	m_godfield_lab = nil,
 	m_fenzheng_lab = nil,
 	m_godfield_time_lab = nil,
 	m_fenzheng_time_lab = nil,
 	god_field_time_cfg = nil,
 	team_pk_time_cfg = nil,
 	m_godpvp_node = nil,
 	m_godtemple_node = nil,
 	constellation_detail=nil,
 	m_shiergong_lab=nil,
 	m_combat_label = nil,
 	m_combatNumberChangeNode = nil,
}
function game_godfield_mainBig.destroy( self )
	self.m_back_btn = nil;
	self.anim_node = nil;
	self.m_shenyu_btn = nil;
	self.m_godfield_lab = nil;
	self.m_fenzheng_lab = nil;
	self.m_godfield_time_lab = nil;
	self.m_fenzheng_time_lab = nil;
	self.god_field_time_cfg = nil;
 	self.team_pk_time_cfg = nil;
 	self.m_godpvp_node = nil;
 	self.m_godtemple_node = nil;
 	self.constellation_detail=nil;
 	self.m_shiergong_lab=nil;
 	self.m_combat_label = nil;
 	self.m_combatNumberChangeNode = nil;
	-- body
end
function game_godfield_mainBig.back( self )
	game_scene:enterGameUi("game_main_scene");
	-- body
end
function game_godfield_mainBig.createUi( self )
	local ccbNode = luaCCBNode:create();
	local function onMainBtnClick( target,event )
		local tagNode = tolua.cast(target, "CCNode");
		local btnTag = tagNode:getTag();
		cclog2(btnTag,"btnTag === ")
		if btnTag == 1 then
			self:back()
		elseif btnTag == 101 then
			local function responseMethod( tag,gameData )
			    local data = gameData:getNodeWithKey("data");
			    data = json.decode(data:getFormatBuffer()) or {};
			    local is_formation = false
			    is_formation = data.is_formation
			    if is_formation == true then 
			        game_scene:enterGameUi("game_godfield_main",{gameData = gameData})
			    else
			        local function responseMethod(tag,gameData)
			        	if gameData then
			            	local first_time = true
			            	game_scene:enterGameUi("game_god_adjustment",{gameData = gameData,openType="game_godfield_arean",first_time = first_time});
			        	end
			    	end
			    	network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_upload_god_formation"), http_request_method.GET, nil,"god_field_upload_god_formation",true,true)
				end
			end
			network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_index"), http_request_method.GET, {},"god_field_index")
		elseif btnTag == 102 then --坠落之地
			local association_id = game_data:getUserStatusDataByKey("association_id");
			if association_id == 0 then
				return game_util:addMoveTips({text = "Hãy gia nhập công hội trước"})
			end
			function responseMethod( tag,gameData )
				local data = gameData:getNodeWithKey("data");
				data = json.decode(data:getFormatBuffer()) or {};
				game_scene:enterGameUi("game_godfield_guild_high_war_main",{gameData = gameData})
			end
			network.sendHttpRequest(responseMethod,game_url.getUrlForKey("guild_high_war_index"), http_request_method.GET, {},"guild_high_war_index")
			-- local function responseMethod( tag,gameData )
			-- 	local data = gameData:getNodeWithKey("data");
			-- 	data = json.decode(data:getFormatBuffer()) or {};
			-- 	local stage = data.stage
			-- 	if stage == 0 then
			-- 		game_util:addMoveTips({text = "Event vẫn chưa mở"})
			-- 	else
			-- 		game_scene:enterGameUi("game_godfield_fenzheng",{gameData = gameData})
			-- 	end
			-- end
			-- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("team_pk_new_index"), http_request_method.GET, {},"team_pk_new_index")
		elseif btnTag == 103 then
			-- local function responseMethod( tag,gameData )
			-- 	game_scene:enterGameUi("game_godtemple_main",{gameData = gameData})
			-- 	-- body
			-- end
			-- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_temple_index"), http_request_method.GET, {},"god_field_temple_index")
			local function responseMethod( tag,gameData )
				game_scene:enterGameUi("game_godfield_pvp_new",{gameData = gameData})
			end
			network.sendHttpRequest(responseMethod,game_url.getUrlForKey("universe_arena_index"), http_request_method.GET, {},"universe_arena_index")

		 
			-- local function responseMethod( tag,gameData )
			-- 	game_scene:enterGameUi("game_godtemple_main",{gameData = gameData})
			-- 	-- body
			-- end
			-- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_temple_v2_index"), http_request_method.GET, {},"god_field_temple_v2_index")
		elseif btnTag == 104 then 
			local vipLevel = game_data:getUserStatusDataByKey("vip") or 0
			local version = self.m_tGameData.cosmic_war.version
			local cosmic_war = cosmicMgr.cfg.cosmic_war
			cosmic_war = cosmic_war[tonumber(version)]

			if not cosmic_war then
				return game_util:addMoveTips({text = "Tạm chưa Mở"})
			end

			local vip = cosmic_war.vip or 0
			if vipLevel < vip then
				return game_util:addMoveTips({text = cosmicMgr.tx[20]})
			end
				
			-- 次元战场
			local function responseMethod( tag,gameData )
				game_scene:enterGameUi("game_cosmic_preview",{gameData = gameData})
			end
			network.sendHttpRequest(responseMethod,game_url.getUrlForKey("cosmic_war_index"), http_request_method.GET, {},"game_godfield_mainBig_cosmic_war_index")

			--------------- 旧 神域竞技场 代码 s
			-- local function responseMethod( tag,gameData )
			-- 	game_scene:enterGameUi("game_godfield_pvp",{gameData = gameData})
			-- end
			-- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_arena"), http_request_method.GET, {},"god_arena")
			--------------- 旧 神域竞技场 代码 e
		
		
			-- local function responseMethod( tag,gameData )
			-- 	local data = gameData:getNodeWithKey("data")
			-- 	data = json.decode(data:getFormatBuffer())
			-- 	if data.step and data.step == 1 then
			-- 		game_scene:enterGameUi("game_serverGuild_join",{gameData = gameData, from = "game_godfield_mainBig"})
			-- 	else
			-- 		game_scene:enterGameUi("game_server_guildbattle_toBattle",{gameData = gameData, from = "game_godfield_mainBig"})
			-- 	end
			-- end
			-- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("new_guild_fight_new_ui_index"), http_request_method.GET, nil,"new_guild_fight_new_ui_index")
	
		elseif btnTag == 105 then  --神域运镖
			-- local function responseMethod( tag,gameData )
			-- 	game_scene:enterGameUi("game_godfield_dart_main",{gameData = gameData})
			-- end
			-- network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_dart_mian"),http_request_method.GET,nil,"god_dart_mian")
			local function responseMethod( tag,gameData )
				game_scene:enterGameUi("game_god_escort_bet",{gameData = gameData})
			end
			network.sendHttpRequest(responseMethod,game_url.getUrlForKey("highway_index"),http_request_method.GET,nil,"highway_index")

		elseif btnTag == 106 then  --神域十二宫
			local function responseMethod( tag,gameData )
				game_scene:enterGameUi("game_god_pyramid_main",{gameData = gameData})
			end
			network.sendHttpRequest(responseMethod,game_url.getUrlForKey("zodiac_index"),http_request_method.GET,nil,"zodiac_index")
		elseif btnTag == 501 then  -- 阵型
           local function responseMethod(tag,gameData)
                if gameData then
                    game_scene:enterGameUi("game_god_adjustment",{gameData = gameData,openType="game_godfield_mainBig",});
                end
            end
            network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_upload_god_formation"), http_request_method.GET, nil,"god_field_upload_god_formation",true,true)
		elseif  btnTag == 601 then -- 排行
        	function responseMethod(tag,gameData)
	            if gameData then
	            	game_scene:enterGameUi("game_godfield_main_rank",{gameData = gameData,index = 1});
	            end
	        end
	        network.sendHttpRequest(responseMethod,game_url.getUrlForKey("god_field_get_combat_rank"), http_request_method.GET, {page = 0},"god_field_get_combat_rank",true,true)
		end
	end
	ccbNode:registerFunctionWithFuncName("onMainBtnClick",onMainBtnClick);
	ccbNode:openCCBFile("ccb/ui_godfield_mainBig001.ccbi");

	self.ccbNode = ccbNode

	self.godfield_dart_node=ccbNode:nodeForName("godfield_dart_node")
	self.m_back_btn = ccbNode:controlButtonForName("m_back_btn")
	self.anim_node = ccbNode:nodeForName("anim_node")
	self.m_shenyu_btn = ccbNode:controlButtonForName("m_shenyu_btn")
	self.m_godfield_lab = ccbNode:labelTTFForName("m_godfield_lab")
	self.m_fenzheng_lab = ccbNode:labelTTFForName("m_fenzheng_lab")
	self.m_fenzheng_lab:setString("")
	self.m_godfield_time_lab = ccbNode:labelTTFForName("m_godfield_time_lab")
	self.m_fenzheng_time_lab = ccbNode:labelTTFForName("m_fenzheng_time_lab")
	self.m_godpvp_node = ccbNode:nodeForName("m_godpvp_node")
	self.m_godtemple_node = ccbNode:nodeForName("m_godtemple_node")
	self.shiergong_node = ccbNode:nodeForName("godfield_shiergong_node")
	self.m_shiergong_lab = ccbNode:labelTTFForName("m_shiergong_lab")
	self.godfield_dart_node=ccbNode:nodeForName("godfield_dart_node")
	self.shiergong_node:setVisible(game_data:isViewShowByID(190))
	local anim = game_util:createEffectAnim("shenyubg",1,true)
	local m_bg_sprite = ccbNode:spriteForName("m_bg_sprite")
    m_bg_sprite:setScale(resolution_config:getScale())
    
	anim:setScale(2)
	anim:setAnchorPoint(ccp(0.5,0.5));
	self.anim_node:addChild(anim,10,10)

	self.m_combat_label = ccbNode:labelBMFontForName("m_combat_label")
    self.m_combat_label:setVisible(false);
    local pX,pY = self.m_combat_label:getPosition();
    -- self.m_combatNumberChangeNode = game_util:createExtNumberChangeNode({labelType = 2});
    self.m_combatNumberChangeNode = CCLabelBMFont:create("","yellow_image_text.fnt")
    self.m_combatNumberChangeNode:setPosition(ccp(pX, pY));
    self.m_combatNumberChangeNode:setAnchorPoint(ccp(0, 0.5));
    self.m_combat_label:getParent():addChild(self.m_combatNumberChangeNode);
    
	return ccbNode;
	-- body
end
function game_godfield_mainBig.refreshUi( self )
	local highway_time = helper.cfg.highway_time or {}
	local start_time = highway_time[1].ready_time
	local end_time = highway_time[#highway_time].end_time

	-- local fenzheng_week_tab = self.team_pk_time_cfg["1"].time_sort
	-- local fenzheng_week = ""

	-- local fenzheng_time = self.team_pk_time_cfg["1"].select_player .. "-" .. self.team_pk_time_cfg["1"].close_time
	-- for k,v in pairs(fenzheng_week_tab) do
	-- 	fenzheng_week = fenzheng_week ..  "Tuần ".. v .. " "
	-- end
	local Star_palace_time = self.constellation_detail["1"].active_start .. " - " .. self.constellation_detail["1"].active_end

	self.m_shiergong_lab:setString(Star_palace_time)
	-- self.m_fenzheng_lab:setString("Mỗi" .. fenzheng_week)
	self.m_godfield_time_lab:setString(start_time .. "-" .. end_time)
	-- self.m_fenzheng_time_lab:setString(fenzheng_time)
	self.m_fenzheng_time_lab:setString("Thời gian khởi động")
	self.m_godpvp_node:setVisible(game_data:isViewShowByID (175))  --神域争霸赛
	self.m_godtemple_node:setVisible(game_data:isViewShowByID (176))  --神域圣殿
	self.godfield_dart_node:setVisible(game_data:isViewShowByID(189)) --神域运镖
	self.shiergong_node:setVisible(game_data:isViewShowByID (190))  -- 神域星宫

	-- 刷新次元战场当前状态
	local m_jingjichang_lab = self.ccbNode:labelTTFForName("m_jingjichang_lab")
	local m_jingjichang_time_lab = self.ccbNode:labelTTFForName("m_jingjichang_time_lab")
	if self.m_tGameData and self.m_tGameData.cosmic_war then
		local step = self.m_tGameData.cosmic_war.step
		local version = self.m_tGameData.cosmic_war.version
		local cosmic_war = cosmicMgr.cfg.cosmic_war
		local _cosmic_war = cosmic_war[version]

		if not _cosmic_war then
			m_jingjichang_lab:setString("Thời gian Mở")
			m_jingjichang_time_lab:setString("Tạm chưa Mở")
		else
			if step == 0 then
				m_jingjichang_lab:setString("Thời gian Mở")
				m_jingjichang_time_lab:setString("Tạm chưa Mở")
			elseif step == 1 then
				m_jingjichang_lab:setString("Giai đoạn Đăng Ký")
				m_jingjichang_time_lab:setString("Dừng lúc " .. _cosmic_war["register_end_time"])
			elseif step == 2 then
				m_jingjichang_lab:setString("Giai đoạn Chia Nhóm")
				m_jingjichang_time_lab:setString("Dừng lúc " .. _cosmic_war["prepare_time"])
			elseif step == 3 then
				m_jingjichang_lab:setString("Giai đoạn Chuẩn Bị")
				m_jingjichang_time_lab:setString("Dừng lúc " .. _cosmic_war["fight_start_time"])
			elseif step == 4 then
				m_jingjichang_lab:setString("Giai đoạn Chiến Đấu")
				m_jingjichang_time_lab:setString("Dừng lúc " .. _cosmic_war["fight_end_time"])
			elseif step == 5 then
				m_jingjichang_lab:setString("Thời gian Mở")
				m_jingjichang_time_lab:setString("Đã kết thúc")
			else
				m_jingjichang_lab:setString("Thời gian Mở")
				m_jingjichang_time_lab:setString("Tạm chưa Mở")
			end
		end
	else
		m_jingjichang_time_lab:setString("Tạm chưa Mở")
	end
end

function game_godfield_mainBig.refreshCombatLabel(self)
	local god_combat_1 = self.m_tGameData.god_combat_1 or 0
	local god_combat_2 = self.m_tGameData.god_combat_2 or 0
	local god_combat_3 = self.m_tGameData.god_combat_3 or 0
	local total_combat = 0
	local poor_comber = 0
	cclog2(total_combat,"total_combat-------")
	if god_combat_1 > 0 or god_combat_2 > 0 or god_combat_3 > 0 then 
		total_combat = god_combat_1 + god_combat_2 + god_combat_3
		local comber = game_data:getGodfieldComber()
		if comber ~= 0 then
			poor_comber = total_combat - comber
		end
		game_data:setGodfieldComber(total_combat)
	else
		total_combat = game_data:getGodfieldComber()
	end
	self.m_combatNumberChangeNode:setString(tostring(total_combat));
	if poor_comber ~= 0 then 
		game_util:combatChangedValueAnim({combatNode = self.m_combatNumberChangeNode:getParent(),currentValue = total_combat,changeValue = poor_comber});	
	end
end

function game_godfield_mainBig.init( self,t_params )
	local team_pk_time_cfg = getConfig(game_config_field.server_pk_time);
	local god_field_time_cfg = getConfig(game_config_field.god_field_time);

--todo 运镖
	local god_escort_buff = getConfig(game_config_field.god_escort_buff)
	self.god_escort_buff_cfg = json.decode(god_escort_buff:getFormatBuffer()) or {};
	local constellation_detail = getConfig(game_config_field.constellation_detail)
	self.constellation_detail = json.decode(constellation_detail:getFormatBuffer()) or {};
	self.team_pk_time_cfg = json.decode(team_pk_time_cfg:getFormatBuffer()) or {};
	self.god_field_time_cfg = json.decode(god_field_time_cfg:getFormatBuffer()) or {};
	self.guild_high_war_base_cfg = getConfig(game_config_field.guild_high_war_base);
	if t_params and t_params.gameData ~= nil and tolua.type(t_params.gameData) == "util_json" then
        local data = t_params.gameData:getNodeWithKey("data");
        self.m_tGameData = json.decode(data:getFormatBuffer()) or {};
    else
        self.m_tGameData = {};
    end
end
function game_godfield_mainBig.create( self,t_params )
	self:init(t_params)
	local scene = CCScene:create()
	scene = self:createUi()
	self:refreshUi()
	self:refreshCombatLabel()
	-- 展示以太战场的时间
	local function showTime(guild_high_war_version)
		local cfg = self.guild_high_war_base_cfg:getNodeWithKey(guild_high_war_version)
		if cfg then
		    local start_time = cfg:getNodeWithKey("start_time"):toStr()
		    local sub_str1 = string.sub(start_time, 1, 10)
			local end_time = cfg:getNodeWithKey("end_time"):toStr()
			local sub_str2 = string.sub(end_time, 1, 10)
		    self.m_fenzheng_lab:setString(sub_str1.."-"..sub_str2)
		else
		   self.m_fenzheng_lab:setString("Chức năng chưa mở")
		end
	end
	if self.m_tGameData and self.m_tGameData.guild_high_war_version then
		showTime(self.m_tGameData.guild_high_war_version)
	else
		local guild_high_war_version =  game_data:getGuildHighWarVersion()
		if guild_high_war_version then
			showTime(guild_high_war_version)
		end
	end
	return scene
	-- body
end
return game_godfield_mainBig   �>