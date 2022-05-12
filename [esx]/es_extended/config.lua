Config = {}
Config.Locale = 'en'

Config.Accounts = {
	bank = _U('account_bank'),
	black_money = _U('account_black_money'),
	money = _U('account_money')
}

Config.StartingAccountMoney = {money = 100000, bank = 0}

Config.EnableSocietyPayouts = false -- pay from the society account that the player is employed at? Requirement: esx_society
Config.EnableHud            = true -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.MaxWeight            = 2400   -- the max inventory weight without backpack
Config.PaycheckInterval     = 1 * 3600000 -- how often to recieve pay checks in milliseconds -- 조정해야함 ㅇㅇ 
Config.EnableDebug          = false


-- 세금 계산 ㅇㅇ 

-- Bank Tax Brackets
Config.HoboClassLimit  =  2000
Config.PoorClassLimit  =  10000
Config.LowerClassLimit  =  20000
Config.LowerMiddleClassLimit = 50000
Config.MiddleClassLimit = 100000
Config.UpperMiddleClassLimit = 250000
Config.LowerHigherClassLimit =  500000
Config.HigherClassLimit =  800000

-- Bank Tax Deductions (Multiplier)
Config.HoboClassTax  =  2
Config.PoorClassTax  =  2
Config.LowerClassTax  =  2
Config.LowerMiddleClassTax = 2
Config.MiddleClassTax =  2
Config.UpperMiddleClassTax =  2
Config.LowerHigherClassTax = 2
Config.HigherClassTax =  2
Config.UpperHigherClassTax = 2

-- Car Tax Deductions - i.e $250 tax for each car
Config.CarTax = 30

-- Property Tax Deductions - i.e $350 tax for each property
Config.PropertyTax = 350

-- Tax Interval
Config.TaxInterval = 1 * 60000 -- i.e every 30 minutes
-- 1 * 60 *

-- Society Account
Config.SocietyAccount = "society_police" -- esx_tax does not currently check that this is valid, using an invalid name may cause script errors. You have been warned.
