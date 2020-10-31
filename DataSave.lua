--Int services--
local Players = game:GetService("Players")
local DSS = game:GetService("DataStoreService")
local DataStore = DSS:GetDataStore("GameSave1")

--Int vars--
local tries = 2
local DataLoaded = false

--This function saves the player data--
local function Set(plr)
	
	if DataLoaded then
		local key = "plr_" .. plr.UserId
		
		local count = 0 
		
		local data = {
			["Coins"] = plr.leaderstats.Coins.Value
		}
		
		local success, err
		
		repeat
			success, err = pcall(function()
				DataStore:SetAsync(key, data)
			end)
		until count >= tries or success 
		
		if not success then
			warn("failed to set data. Error Code:" .. tostring(err))
			
			return
		end
	else
		return
	end
end

--This function GETS the player data--
local function Get(plr)
	
	local key = "plr_" .. plr.UserId
	local count = 0
	
	local data 
	
	local success, err	
	
	repeat
		success, err = pcall(function() 
			data = DataStore:GetAsync(key)
		end)
		
		count = count + 1
	until count >= tries or success
	
	if not success then
	
	warn("There was a Problem!| error code:" .. tostring(err))
	
	plr:Kick("im Sorry but you have been kick so we can save your data. =)")
	
		return
	end
	
	if success then 
		if data then 
			return data
		else
			return {
				["Coins"] = 150
			}
		end	
	end
end

--Creates the leaderborads and displays the players money--
local function leaderstats(plr)
	
	local value = Get(plr)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local Coins = Instance.new("IntValue")
	Coins.Name = "Coins"
	Coins.Parent = leaderstats
	
	Coins.Value = value.Coins
	
	 DataLoaded = true
end

Players.PlayerRemoving:Connect(Set)
Players.PlayerAdded:Connect(leaderstats)  

--This saves player data if the game stops for no reason--
game:BindToClose(function()
	for i, v in next, game.Players:GetChildren() do 
		if v then 
			Set(v)
		end
	end 
end)
