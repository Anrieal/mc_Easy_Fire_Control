local monitor = peripheral.find("monitor")
local cannons = {peripheral.find("cbc_cannon_mount")}  -- 获取所有炮台

if not monitor then
    print("未找到高级显示器")
    return
end

if #cannons == 0 then
    print("未找到炮台")
    return
end

monitor.setTextScale(0.5)

-- 使用第一个炮台的角度初始化跟踪值
local trackedYaw = cannons[1].getYaw()
local trackedPitch = cannons[1].getPitch()

local function drawUI()
    monitor.clear()
    -- 显示第一个炮台的真实值
    monitor.setCursorPos(1, 1)
    monitor.write("Yaw: " .. string.format("%.3f", cannons[1].getYaw()))
    
    monitor.setCursorPos(1, 2)
    monitor.write("+++ +++")
    
    monitor.setCursorPos(1, 3)
    monitor.write(string.format("%07.3f", trackedYaw))
    
    monitor.setCursorPos(1, 4)
    monitor.write("--- ---")
    
    monitor.setCursorPos(1, 5)
    monitor.write("")
    
    monitor.setCursorPos(1, 6)
    monitor.write("Pitch: " .. string.format("%.3f", cannons[1].getPitch()))
    
    monitor.setCursorPos(1, 7)
    monitor.write(" +++++")
    
    monitor.setCursorPos(1, 8)
    monitor.write(string.format("%+07.3f", trackedPitch))
    
    monitor.setCursorPos(1, 9)
    monitor.write(" -----")
end

-- 更新所有炮台
local function updateCannons()
    for _, cannon in ipairs(cannons) do
        cannon.setYaw(trackedYaw)
        cannon.setPitch(trackedPitch)
    end
end

while true do
    drawUI()
    local event, side, x, y = os.pullEvent("monitor_touch")

    -- Yaw增加
    if y == 2 then
        if x == 1 then trackedYaw = (trackedYaw + 100) % 360
        elseif x == 2 then trackedYaw = (trackedYaw + 10) % 360
        elseif x == 3 then trackedYaw = (trackedYaw + 1) % 360
        elseif x == 5 then trackedYaw = (trackedYaw + 0.1) % 360
        elseif x == 6 then trackedYaw = (trackedYaw + 0.01) % 360
        else trackedYaw = (trackedYaw + 0.001) % 360
        end
        updateCannons()
    end

    -- Yaw减少
    if y == 4 then
        if x == 1 then trackedYaw = (trackedYaw - 100) % 360
        elseif x == 2 then trackedYaw = (trackedYaw - 10) % 360
        elseif x == 3 then trackedYaw = (trackedYaw - 1) % 360
        elseif x == 5 then trackedYaw = (trackedYaw - 0.1) % 360
        elseif x == 6 then trackedYaw = (trackedYaw - 0.01) % 360
        else trackedYaw = (trackedYaw - 0.001) % 360
        end
        updateCannons()
    end

    -- Pitch增加
    if y == 7 then
        if x == 2 then trackedPitch = math.min(trackedPitch + 10, 85)
        elseif x == 3 then trackedPitch = math.min(trackedPitch + 1, 85)
        elseif x == 4 then trackedPitch = math.min(trackedPitch + 0.1, 85)
        elseif x == 5 then trackedPitch = math.min(trackedPitch + 0.01, 85)
        else trackedPitch = math.min(trackedPitch + 0.001, 85)
        end
        updateCannons()
    end

    -- Pitch减少
    if y == 9 then
        if x == 2 then trackedPitch = math.max(trackedPitch - 10, -10)
        elseif x == 3 then trackedPitch = math.max(trackedPitch - 1, -10)
        elseif x == 4 then trackedPitch = math.max(trackedPitch - 0.1, -10)
        elseif x == 5 then trackedPitch = math.max(trackedPitch - 0.01, -10)
        else trackedPitch = math.max(trackedPitch - 0.001, -10)
        end
        updateCannons()
    end
end