local Economy = {}

local money = 200

function Economy.get_money()
    return money
end

function Economy.add(amount)
    money = money + amount
    msg.post("/systems#event_manager", "trigger-event", {
        event_key = "money_changed",
        amount = money,
        change = amount
    })
end

function Economy.spend(amount)
    if money >= amount then
        money = money - amount
        msg.post("/systems#event_manager", "trigger-event", {
            event_key = "money_changed",
            amount = money,
            change = amount
        })
        return true
    end
    return false
end

return Economy
