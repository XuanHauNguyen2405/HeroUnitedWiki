local MapLayer = class("MapLayer")

local cosmicMgr = require("game_ui.cosmicMgr")

local function safeDecode(field)
    local config = getConfig(field)
    if config and config.getFormatBuffer then
        local tb = json.decode(config:getFormatBuffer() or "") or {}
        local newTb = {}
        for k, v in pairs(tb) do
            v.id = tonumber(k)
            table.insert(newTb, v)
        end
        table.sort(
            newTb,
            function(a, b)
                return a.id < b.id
            end
        )
        return newTb
    end
    return {}
end

function MapLayer:create()
    local layer = MapLayer.new()
    return layer
end

function MapLayer:ctor()
    self.layer = CCLayer:create()
end

function MapLayer:getLayer()
    return self.layer
end

function MapLayer:init(main)
    self.main = main
    self.cfg = {}
    self.cfg.cosmic_war_city = safeDecode(game_config_field.cosmic_war_city)

    local mapCfgs = {}
    for k, v in pairs(self.cfg.cosmic_war_city) do
        v.id = tonumber(k)
        mapCfgs[tostring(v.id)] = v
    end

    self.mapCfgs = mapCfgs
    -- 地图尺寸和图片配置
    self.mapTiles = {
        "ciyuan_022.jpg",
        "ciyuan_022.jpg",
        "ciyuan_022.jpg",
        "ciyuan_022.jpg"
    }
    self.mapBuilds = {}

    self.touchEnabled = true

    local tile = CCSprite:create("ccbResources/ui_cosmic/" .. self.mapTiles[1])

    self.tileWidth = tile:getContentSize().width -- 单张地图宽度
    self.tileHeight = tile:getContentSize().height -- 单张地图高度
    self.mapScale = 1.0 -- 地图缩放比例

    -- 创建地图容器
    self.mapContainer = CCLayer:create()
    self.mapContainer:setContentSize(CCSizeMake(self.tileWidth * 2, self.tileHeight * 2))
    self.layer:addChild(self.mapContainer)

    -- 加载并拼接地图
    self:loadMapTiles()
    -- 加载建筑
    self:loadMapBuilds()
    -- 刷新自己所在位置
    local sp = CCSprite:createWithSpriteFrameName("ciyuan_044.png")
    self.myPosSp = sp
    sp:setVisible(false)
    self.mapContainer:addChild(sp)
    -- 注册触摸事件
    self.layer:registerScriptTouchHandler(
        function(eventType, x, y)
            return self:onTouch(eventType, x, y)
        end,
        false,
        GLOBAL_TOUCH_PRIORITY,
        true
    )
    self.layer:setTouchEnabled(true)

    -- 初始化触摸状态
    self.isTouching = false
    self.lastTouchPos = CCPointMake(0, 0)

    self:updateMapInfo()
end

function MapLayer:loadMapTiles()
    local useBgScale = true
    if useBgScale then
        local tile = CCSprite:create("ccbResources/ui_cosmic/" .. self.mapTiles[1])
        tile:setPosition(ccp(self.mapContainer:getContentSize().width / 2, self.mapContainer:getContentSize().height / 2))
        tile:setScale(2)
        self.mapContainer:addChild(tile, -10)
    else
        for i = 1, #self.mapTiles do
            local tile = CCSprite:createWithSpriteFrameName(self.mapTiles[i])
            if tile then
                -- 设置锚点为 (0, 0)，确保从左上角开始计算位置
                tile:setAnchorPoint(ccp(0, 0))

                -- 计算行列（2x2 网格）
                local row = math.floor((i - 1) / 2) -- 0 或 1
                local col = (i - 1) % 2 -- 0 或 1

                -- 计算位置（Y轴向下排列）
                local posX = col * self.tileWidth
                local posY = (1 - row) * self.tileHeight -- 反转Y轴方向

                tile:setPosition(ccp(posX, posY))
                self.mapContainer:addChild(tile, -10)

                cclog(string.format("Tile %d size: width=%d, height=%d", i, tile:getContentSize().width, tile:getContentSize().height))
            end
        end
    end

    -- 设置地图容器的初始位置（居中）
    local winSize = CCDirector:sharedDirector():getWinSize()
    self.mapContainer:setPosition(ccp(-self.tileWidth, -self.tileHeight))
end

function MapLayer:onTouch(eventType, x, y)
    if eventType == "began" then
        if not self.touchEnabled then
            return false
        end
        self.isTouching = true
        self.lastTouchPos = CCPointMake(x, y)
        self.touchStartPos = CCPointMake(x, y) -- 记录触摸起始位置
        self.hasMoved = false -- 重置移动标记

        -- 将触摸点转换为地图容器坐标系
        -- local touchPos = self.mapContainer:convertToNodeSpace(ccp(x, y))

        -- 检查是否点击了建筑（从后往前遍历，确保上层建筑优先被点击）
        -- for i = #self.mapBuilds, 1, -1 do
        --     local building = self.mapBuilds[i]
        --     local sp = building.buildSp
        --     local touchPos = sp:getParent():convertToNodeSpace(ccp(x, y))
        --     -- 获取建筑的边界框
        --     local buildingRect = sp:boundingBox()

        --     -- 检查触摸点是否在建筑范围内
        --     if buildingRect:containsPoint(touchPos) then
        --         cclog(string.format("点击建筑的位置 x=%d, y=%d", sp:getPositionX(), sp:getPositionY()))
        --         -- 触发建筑点击事件
        --         self:onBuildingClicked(building, i)
        --         return true -- 拦截事件，表示已处理
        --     end
        -- end

        return true
    elseif eventType == "moved" and self.isTouching then
        local delta = CCPointMake(x - self.lastTouchPos.x, y - self.lastTouchPos.y)
        self.lastTouchPos = CCPointMake(x, y)

        -- 判断是否有移动
        local moveDistance = ccpDistance(self.touchStartPos, CCPointMake(x, y))
        if moveDistance > 5 then -- 如果移动距离超过5像素，则认为发生了移动
            self.hasMoved = true
        end

        -- 移动地图容器
        local newPos = CCPointMake(self.mapContainer:getPositionX() + delta.x, self.mapContainer:getPositionY() + delta.y)

        -- -- 边界检查
        local winSize = CCDirector:sharedDirector():getWinSize()

        local minX = -winSize.width / 2
        local minY = -winSize.height / 2
        newPos.x = math.min(newPos.x, minX)
        newPos.y = math.min(newPos.y, minY)

        local maxX = -self.tileWidth * 2 + winSize.width / 2
        local maxY = -self.tileHeight * 2 + winSize.height / 2
        newPos.x = math.max(newPos.x, maxX)
        newPos.y = math.max(newPos.y, maxY)

        self.mapContainer:setPosition(newPos)

        cclog(string.format("Touch moved: x=%d, y=%d", newPos.x, newPos.y))
    elseif eventType == "ended" or eventType == "cancelled" then
        if self.isTouching and not self.hasMoved then
            -- 只有在未移动的情况下才检查建筑点击
            local touchEndPos = CCPointMake(x, y)
            -- 检查是否点击了建筑（从后往前遍历，确保上层建筑优先被点击）
            for i = #self.mapBuilds, 1, -1 do
                local building = self.mapBuilds[i]
                local sp = building.buildSp
                local touchPos = sp:getParent():convertToNodeSpace(touchEndPos)
                -- 获取建筑的边界框
                local buildingRect = sp:boundingBox()

                -- 检查触摸点是否在建筑范围内
                if buildingRect:containsPoint(touchPos) then
                    cclog(string.format("点击建筑的位置 x=%d, y=%d", sp:getPositionX(), sp:getPositionY()))
                    -- 触发建筑点击事件
                    self:onBuildingClicked(building, i)
                    break -- 触发一个建筑点击后就退出循环
                end
            end
        end
        self.isTouching = false
        self.hasMoved = false
    end
    return true
end

-- 添加建筑点击处理函数
function MapLayer:onBuildingClicked(building, index)
    -- 在这里处理建筑点击逻辑
    local id = building.id
    cclog("Building " .. id .. " clicked")
    local sort = cosmicMgr.cfg.cosmic_war_city[id].sort
    if sort <= 3 then
        game_util:addMoveTips({text = cosmicMgr.tx[16]})
        return
    end

    -- 处理建筑被保护情况
    local own_time = building.own_time or 0
    local serverTime = game_data:getVirtualServerTime()
    local all_building = cosmicMgr:getAllBuilding()
    local buildingNetData = all_building[tostring(id)]
    local camp = buildingNetData.camp
    local myCamp = cosmicMgr:getCamp()
    if camp ~= myCamp and math.abs(serverTime - own_time) < 60 then
        game_util:addMoveTips({text = cosmicMgr.tx[19]})
        return
    end
    -- local canMove = false -- 是否可移动
    -- local all_building = cosmicMgr:getAllBuilding()
    -- local buildingNetData = all_building[tostring(id)]
    -- local camp = buildingNetData.camp
    -- local myCamp = cosmicMgr:getCamp()
    -- if camp == 0 or camp == myCamp then -- 直接驻守
    --     local step = cosmicMgr:getCurrentStep()
    --     if step ~= 4 then
    --         return
    --     end

    --     local function responseMethod(tag, gameData)
    --         local data = gameData:getNodeWithKey("data")
    --         gameData = json.decode(data:getFormatBuffer()) or {}

    --         cosmicMgr:updateData(gameData)
    --         self:updateMapInfo()
    --         -- game_scene:addPop("game_cosmic_garrisonLineup", {gameData = gameData})
    --     end
    --     network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_station"), http_request_method.GET, {build_id = id}, "god_arena")
    -- else -- 打开建筑信息
    -- end
    local function responseMethod(tag, gameData)
        game_scene:addPop(
            "game_cosmic_garrisonLineup",
            {
                gameData = gameData,
                moveCb = function(gameData)
                    cosmicMgr:updateData(gameData)
                    self:updateMapInfo()
                    self.main:refreshUi()
                end
            }
        )
    end
    network.sendHttpRequest(responseMethod, game_url.getUrlForKey("cosmic_war_build_info"), http_request_method.GET, {build_id = id}, "cosmic_war_build_info")
end

function MapLayer:setMoveEnable(status)
    -- self.touchEnabled = status
end

function MapLayer:loadMapBuilds()
    for k, v in pairs(self.mapCfgs) do
        local id = v.id -- 地图id
        local sort = v.sort -- 排序
        local effect = v.effect -- 加成数值
        local points = v.points -- 积分数量
        local point = v.point
        local move = v.move
        local icon = v.icon
        local zoom = v.zoom

        local all_building = cosmicMgr:getAllBuilding()
        local buildingNetData = all_building[tostring(id)]

        local building = {}
        building.sort = sort
        building.effect = effect
        building.points = points
        building.point = point
        building.move = move
        building.icon = icon
        building.zoom = zoom
        building.id = id

        local node = CCNode:create()
        -- 定义间隔和整体偏移变量
        local intervalX = 90
        local intervalY = 80
        local offset = 80
        node:setPosition(ccp(point[1] * intervalX + offset, point[2] * intervalY + offset))
        self.mapContainer:addChild(node)
        building.node = node

        -- 底座
        local camp = buildingNetData.camp
        local picNames = {
            [0] = "ciyuan_042.png",
            [1] = "ciyuan_017.png",
            [2] = "ciyuan_015.png",
            [3] = "ciyuan_016.png"
        }
        local name = picNames[camp]
        if sort <= 3 then
            name = picNames[sort]
        end
        local sp = CCSprite:createWithSpriteFrameName(name)
        sp:setScale(1.2)
        building.bgSp = sp
        node:addChild(sp)
        -- 图片
        local sp = CCSprite:createWithSpriteFrameName(icon .. ".png")
        node:addChild(sp)
        building.buildSp = sp
        -- 被占领遮挡 -- 处理建筑被保护情况
        local sp = CCSprite:createWithSpriteFrameName("ciyuan_023.png")
        node:addChild(sp)
        sp:setVisible(false)
        building.mask = sp
        -- maskTime -- 建筑倒计时
        local maskLb = CCLabelTTF:create("", TYPE_FACE_TABLE.Arial_BoldMT, 16)
        node:addChild(maskLb)
        maskLb:setColor(ccc3(255, 0, 0))
        maskLb:setVisible(false)
        building.maskLb = maskLb

        self.mapBuilds[id] = building
    end

    self:initLine()
end

-- 初始化建筑间连线
function MapLayer:initLine()
    -- 绘制建筑间连线
    self:drawConnectionLines()
end

-- 绘制建筑间连接线
function MapLayer:drawConnectionLines()
    -- 清除之前绘制的内容
    -- self.lineNode:clear()

    -- 如果建筑少于2个，则无法绘制连线
    if #self.mapBuilds < 2 then
        return
    end

    -- 设置线条颜色为白色，不透明度为100%
    local lineColor = ccc4(0, 255, 255, 255)
    -- 设置线条宽度
    local lineWidth = 1
    -- 创建一个表来跟踪已绘制的连接
    local drawnConnections = {}

    -- 遍历建筑列表，绘制建筑间的虚线
    for i = 1, #self.mapBuilds - 1 do
        local building = self.mapBuilds[i]
        local id1 = building.id
        local sort = building.sort
        local pos1 = ccp(building.node:getPosition())
        local move = building.move or {}
        for k, v in ipairs(move) do
            local id2 = tonumber(v)
            local isChongDongConnect = sort == 11 and k == #move -- 虫洞直接不能互相连接,sort11,最后一个值
            if not drawnConnections[id1 .. "-" .. id2] and not isChongDongConnect then
                drawnConnections[id1 .. "-" .. id2] = true
                drawnConnections[id2 .. "-" .. id1] = true
                if self.mapBuilds[id2] then
                    local pos2 = ccp(self.mapBuilds[id2].node:getPosition())
                    self:drawDashedLine(pos1, pos2, lineWidth, lineColor, 10, 5)
                else
                    cclog("mapBuilds不包含" .. v)
                end
            end
        end
    end
end

-- 绘制虚线函数
-- 参数: 起点、终点、线宽、颜色、线段长度、间隔长度
function MapLayer:drawDashedLine(startPos, endPos, lineWidth, color, dashLength, gapLength)
    local dx = endPos.x - startPos.x
    local dy = endPos.y - startPos.y
    local distance = math.sqrt(dx * dx + dy * dy)

    -- 如果距离为0则无法绘制
    if distance <= 0 then
        return
    end

    -- 计算单位向量
    local stepX = dx / distance
    local stepY = dy / distance

    local currentPos = 0

    -- 绘制线段部分
    while currentPos < distance do
        -- 计算当前线段的起点
        local startX = startPos.x + stepX * currentPos
        local startY = startPos.y + stepY * currentPos

        -- 计算当前线段的终点
        currentPos = currentPos + dashLength
        -- 确保不超出总长度
        currentPos = math.min(currentPos, distance)

        local endX = startPos.x + stepX * currentPos
        local endY = startPos.y + stepY * currentPos

        -- 使用CCLayerColor创建线条段
        self:drawLineSegment(ccp(startX, startY), ccp(endX, endY), lineWidth, color)

        -- 移动到下一个线段的起点（跳过间隔距离）
        currentPos = currentPos + gapLength
    end
end

-- 使用CCLayerColor绘制线段
function MapLayer:drawLineSegment(startPos, endPos, width, color)
    local dx = endPos.x - startPos.x
    local dy = endPos.y - startPos.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance <= 0 then
        return
    end

    -- 创建一个CCLayerColor作为线段
    local lineSegment = CCLayerColor:create(color)

    -- 设置线段的尺寸和位置
    lineSegment:setContentSize(CCSizeMake(distance, width))
    lineSegment:setAnchorPoint(ccp(0, 0.5))

    -- 计算线段的角度
    local angle = math.atan2(dy, dx)

    -- 设置线段的位置和旋转
    lineSegment:setPosition(startPos)
    lineSegment:setRotation(-math.deg(angle))

    -- 添加到地图容器中
    self.mapContainer:addChild(lineSegment, -4)
end

function MapLayer:updateMapInfo()
    local all_building = cosmicMgr:getAllBuilding()
    local serverTime = game_data:getVirtualServerTime() -- 当前服务器时间

    -- 刷新自己的位置
    local pos = cosmicMgr:getPos()
    local mapBuild = self:getMapBuild(pos)
    if mapBuild then
        local node = mapBuild.node
        self.myPosSp:setPosition(ccp(node:getPosition()))
        self.myPosSp:setVisible(true)
    else
        self.myPosSp:setVisible(false)
    end

    -- 刷新建筑状态
    for k, v in pairs(self.mapCfgs) do
        local id = v.id -- 地图id
        local _mapBuild = self:getMapBuild(id)
        local buildingNetData = all_building[tostring(id)]
        local camp = buildingNetData.camp
        local sort = _mapBuild.sort
        local own_time = buildingNetData.own_time -- 占领时间
        local picNames = {
            [0] = "ciyuan_042.png",
            [1] = "ciyuan_017.png",
            [2] = "ciyuan_015.png",
            [3] = "ciyuan_016.png"
        }
        local name = picNames[camp]
        if sort <= 3 then -- 主城默认颜色,不能更改
            name = picNames[sort]
        end
        local tempFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(name)
        if tempFrame then
            _mapBuild.bgSp:setDisplayFrame(tempFrame)
        end
        ---------- 处理建筑被保护情况
        local show = false
        if own_time and math.abs(serverTime - own_time) < 60 then
            show = true
        end
        -- mask
        local mask = _mapBuild.mask
        mask:setVisible(show)
        -- maskLb
        local maskLb = _mapBuild.maskLb
        maskLb:setVisible(show)
        if show then
            maskLb:setString(math.ceil( 60 - (serverTime - own_time) ))
        end
        
        ---------- 处理建筑被保护情况 end
    end
end

function MapLayer:getMapBuild(id)
    -- 刷新自己的位置
    for k, v in pairs(self.mapBuilds) do
        if tostring(id) == tostring(v.id) then
            return v
        end
    end
end

function MapLayer:moveToPlayerPosition()
    local pos = cosmicMgr:getPos()
    local mapBuild = self:getMapBuild(pos)
    if mapBuild then
        local node = mapBuild.node
        local targetPos = ccp(node:getPosition())

        -- 获取当前地图容器位置
        local containerPos = self.mapContainer:getPosition()

        -- 计算需要移动到的位置，使目标建筑居中
        local winSize = CCDirector:sharedDirector():getWinSize()
        local newX = -targetPos.x
        local newY = -targetPos.y

        -- 边界检查
        local minX = -winSize.width / 2
        local minY = -winSize.height / 2
        newX = math.min(newX, minX)
        newY = math.min(newY, minY)

        local maxX = -self.tileWidth * 2 + winSize.width / 2
        local maxY = -self.tileHeight * 2 + winSize.height / 2
        newX = math.max(newX, maxX)
        newY = math.max(newY, maxY)

        -- 移动地图
        self.mapContainer:setPosition(ccp(newX, newY))
    end
end

return MapLayer
 �J