function refuel()
    if turtle.getFuelLevel() < 5 then
        while (not turtle.refuel(1)) do
            os.sleep(5)
        end
    end
end

steps = 1
function tMove()
    while (not turtle.forward()) do
        turtle.dig()
    end
    steps = steps + 1
end

function percent()
    term.clear()
    print("______________________")
    print(width, length, depth)
    print(steps,"/",size)
    print("______________________")
end

temp1 = 1
function rotate(z)
    if z == length then
        turtle.turnLeft()
        turtle.turnLeft()
    else
        if temp1 % 2 == 0 then
            if z % 2 == 0 then
                turtle.turnRight()
                tMove()
                turtle.turnRight()
            else
                turtle.turnLeft()
                tMove()
                turtle.turnLeft()
            end
        else
            if z % 2 == 0 then
                turtle.turnLeft()
                tMove()
                turtle.turnLeft()
            else
                turtle.turnRight()
                tMove()
                turtle.turnRight()
            end
        end
    end
end

function handleModemMessage()
    local modem = peripheral.find("modem")
    modem.open(1)

    while true do
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        if message.command == "move" and message.direction == "forward" then
            for i = 1, message.blocks do
                tMove()
            end
        elseif message.command == "turn" then
            if message.direction == "left" then
                turtle.turnLeft()
            elseif message.direction == "right" then
                turtle.turnRight()
            end
        end
    end
end



function boxMine(width, length, depth, upOrDown) 
    width = width - 1
    for y = 1, depth do
        refuel()
        percent()
        for z = 1, length do
            refuel()
            for x = 1, width do
                refuel()
                percent()
                tMove()
            end
            percent()
            rotate(z)
        end
        if upOrDown == 1 then
            turtle.digDown()
            turtle.down()
            steps = steps + 1
        else
            turtle.digUp()
            turtle.up()
            steps = steps + 1
        end
        if length % 2 == 0 then
            temp1 = temp1 + 1
        end
    end
    handleModemMessage()
end

local args = {...}

if #args ~= 4 then
    print("usage: mine <width> <length> <depth> <1(down)/0(up)>")
    return
end

width = tonumber(args[1])
length = tonumber(args[2])
depth = tonumber(args[3])
upOrDown = tonumber(args[4])

size = width * length * depth

if width == nil or length == nil or depth == nil then
    print("Error: arguments must be numbers")
    return
end

boxMine(width, length, depth, upOrDown)
