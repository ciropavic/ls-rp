Config = {}

Config.Debug = false

Config.Webhook = 'https://discord.com/api/webhooks/882596632682700800/W0Zyq7ovvo2fPBNlLSot6CRzpKGdSduoHTnE5tMWJ2Q-6T9e70lqmTpWmFaQ1jhzF3bS'
Config.ServerName = '로스 산토스 역할 연기 서버'

Config.MessageId = '882596786986971148' --Copy messageid from deployed message and restart script!

Config.UpdateTime = 1000*60*1 -- 1 minute
Config.Use24hClock = true -- false = 12h clock
Config.JoinLink = 'https://cfx.re/join/' -- Make sure that JoinLink is URL, like: https://cfx.re/join/xp34mg, currenlty does not support Redm

Config.EmbedColor = 3158326

Config.Locale = 'en'

Config.Locales = {
    ['fi'] = {
        ['date'] = 'Päivä',
        ['time'] = 'Aika',
        ['players'] = 'Pelaajia',
        ['connect'] = 'Yhdistä palvelimelle',
    },
    ['en'] = {
        ['date'] = 'Date',
        ['time'] = 'Time',
        ['players'] = 'Players',
        ['connect'] = 'Connect to server',
    }
}
