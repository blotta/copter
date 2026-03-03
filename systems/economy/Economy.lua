local Economy = {}

local money = 2000

function Economy.get_money()
    return money
end

function Economy.add(amount)
    money = money + amount
    if amount ~= 0 then
        msg.post("/event_manager", "trigger-event", {
            event_key = "money_changed",
            amount = money,
            change = amount
        })
    end
end

function Economy.spend(amount)
    Economy.add(-amount)
end

return Economy
