Webhook = 'YOURWEBHOOK'
LogsPicture = 'YOURLOGO'

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Colors = {
    default = 14423100,
    blue = 255,
    red = 16711680,
    green = 65280,
    white = 16777215,
    black = 0,
    orange = 16744192,
    yellow = 16776960,
    pink = 16761035,
    lightgreen = 65309,
}

function format_int(number)
	local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

function SendWebHook(whLink, color, message)
    local embedMsg = {}
    timestamp = os.date("%c")
    embedMsg = {
        {
            ["color"] = Colors[color],
            ["author"] = {
                name = "5E-Devs | Money Wash",
                icon_url = LogsPicture
            },
            ["title"] = "Money wash has been used",
            ["description"] =  ""..message.."",
            ["footer"] ={
                ["text"] = timestamp.." (Server Time).",
                icon_url = LogsPicture,
            },
        }
    }
    PerformHttpRequest(whLink,
    function(err, text, headers)end, 'POST', json.encode({username = 'Money Wash', avatar_url= LogsPicture ,embeds = embedMsg}), { ['Content-Type']= 'application/json' })
end

ESX.RegisterServerCallback('5e_moneywash:getblackmoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local blackMoney = xPlayer.getAccount('black_money').money
    cb(blackMoney)
end)

ESX.RegisterServerCallback('5e_moneywash:washblackmoney', function(source, cb)
    local src = source
    local result = false
	local xPlayer = ESX.GetPlayerFromId(src)
    local blackMoney = 0
    if xPlayer then
        blackMoney = xPlayer.getAccount('black_money').money
        xPlayer.removeAccountMoney('black_money', blackMoney)
        xPlayer.addAccountMoney('cash', blackMoney)
        SendWebHook(Webhook, 'green', GetPlayerName(src).."("..src..")".." has washed $"..format_int(blackMoney))
        result = true
    end
    cb(result, blackMoney)
end)