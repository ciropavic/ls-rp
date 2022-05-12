-- Local
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local PlayerData = {}
local CurrentAction = nil
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local times 					= 0
local userProperties = {}
local this_Garage = {}
local bilhete = false
local placa = ""
local vehi = ""
local locktime = false
local podespawn = false
local umavez = 0
local count = 0
local lastvehicle = nil
local onecall = true
local isOut = {}
local _color1={}
local _color2={}
local checkcars = {
	[1] = {value = 0, model = "", plate = "", vehicle = {}},
	[2] = {value = 0, model = "", plate = "", vehicle = {}},
	[3] = {value = 0, model = "", plate = "", vehicle = {}},
	[4] = {value = 0, model = "", plate = "", vehicle = {}},
	[5] = {value = 0, model = "", plate = "", vehicle = {}},
	[6] = {value = 0, model = "", plate = "", vehicle = {}},
	[7] = {value = 0, model = "", plate = "", vehicle = {}},
	[8] = {value = 0, model = "", plate = "", vehicle = {}},
	[9] = {value = 0, model = "", plate = "", vehicle = {}},
	[10] = {value = 0, model = "", plate = "", vehicle = {}},
	[11] = {value = 0, model = "", plate = "", vehicle = {}},
	[12] = {value = 0, model = "", plate = "", vehicle = {}},
	[13] = {value = 0, model = "", plate = "", vehicle = {}},
	[14] = {value = 0, model = "", plate = "", vehicle = {}},
	[15] = {value = 0, model = "", plate = "", vehicle = {}},
	[16] = {value = 0, model = "", plate = "", vehicle = {}},
	[17] = {value = 0, model = "", plate = "", vehicle = {}},
	[18] = {value = 0, model = "", plate = "", vehicle = {}},
	[19] = {value = 0, model = "", plate = "", vehicle = {}},
	[20] = {value = 0, model = "", plate = "", vehicle = {}},
	[21] = {value = 0, model = "", plate = "", vehicle = {}},
	[22] = {value = 0, model = "", plate = "", vehicle = {}},
	[23] = {value = 0, model = "", plate = "", vehicle = {}},
	[24] = {value = 0, model = "", plate = "", vehicle = {}},
	[25] = {value = 0, model = "", plate = "", vehicle = {}},
	[26] = {value = 0, model = "", plate = "", vehicle = {}},
	[27] = {value = 0, model = "", plate = "", vehicle = {}},
	[28] = {value = 0, model = "", plate = "", vehicle = {}},
	[29] = {value = 0, model = "", plate = "", vehicle = {}},
	[30] = {value = 0, model = "", plate = "", vehicle = {}},
	[31] = {value = 0, model = "", plate = "", vehicle = {}},
	[32] = {value = 0, model = "", plate = "", vehicle = {}},
	[33] = {value = 0, model = "", plate = "", vehicle = {}},
	[34] = {value = 0, model = "", plate = "", vehicle = {}},
	[35] = {value = 0, model = "", plate = "", vehicle = {}},
	[36] = {value = 0, model = "", plate = "", vehicle = {}},
	[37] = {value = 0, model = "", plate = "", vehicle = {}},
	[38] = {value = 0, model = "", plate = "", vehicle = {}},
	[39] = {value = 0, model = "", plate = "", vehicle = {}},
	[40] = {value = 0, model = "", plate = "", vehicle = {}},
	[41] = {value = 0, model = "", plate = "", vehicle = {}},
	[42] = {value = 0, model = "", plate = "", vehicle = {}},
	[43] = {value = 0, model = "", plate = "", vehicle = {}},
	[44] = {value = 0, model = "", plate = "", vehicle = {}},
	[45] = {value = 0, model = "", plate = "", vehicle = {}},
	[46] = {value = 0, model = "", plate = "", vehicle = {}},
	[47] = {value = 0, model = "", plate = "", vehicle = {}},
	[48] = {value = 0, model = "", plate = "", vehicle = {}},
	[49] = {value = 0, model = "", plate = "", vehicle = {}},
	[50] = {value = 0, model = "", plate = "", vehicle = {}},
}

-- End Local
-- Initialise ESX

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

-- End ESX Initialisation
--- Generate map blips
