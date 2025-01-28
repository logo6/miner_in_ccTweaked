local modem = peripheral.find("modem")
modem.open(1)

function sendMoveCommand(blocks)
    local message = {command = "move", direction = "forward", blocks = blocks}
    modem.transmit(1, 1, message)
end

function sendTurnCommand(direction)
    local message = {command = "turn", direction = direction}
    modem.transmit(1, 1, message)
end

local args = {...}

if #args < 1 then
    print("usage: back <blocks> | turn <left|right>")
    return
end

if args[1] == "turn" then
    if args[2] == "left" or args[2] == "right" then
        sendTurnCommand(args[2])
    else
        print("Error: direction must be 'left' or 'right'")
    end
else
    local blocks = tonumber(args[1])
    if blocks == nil then
        print("Error: arguments must be numbers")
        return
    end
    sendMoveCommand(blocks)
end

--"nameProgramm" <count of blocks>
--"nameProgramm" turn <left|right>
