-----------------------------------------------------------------------------------------------
-- Client Lua Script for EGPlates
-- oh lord this is terribly commented right now please forgive me
-- use next(tableName) on a valid tableName to determine if empty (will be nil) 
-----------------------------------------------------------------------------------------------
 
require "Window"
require "GameLib"
require "GroupLib"
require "Unit"
require "ChatSystemLib"

-----------------------------------------------------------------------------------------------
-- EGPlates Module Definition
-----------------------------------------------------------------------------------------------
local EGPlates = {} 
 
-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
--vvv THIS IS FOR MAKING LOADING NOT ALL ONE MASSIVE LAG AT ONCE, DEFAULT OF 50
local kvRestrictor					= 50
--^^^ IF YOU ARE NOT HAVING ISSUES ADJUST THE NUMBER HIGHER, ELSE ADJUST LOWER AND ABOVE 10
local ktConColors =  {
	[-4] 							= ApolloColor.new("ConTrivial"),
	[-3] 							= ApolloColor.new("ConInferior"),
	[-2] 							= ApolloColor.new("ConMinor"),
	[-1] 							= ApolloColor.new("ConEasy"),
	[0] 							= ApolloColor.new("ConAverage"),
	[1] 							= ApolloColor.new("ConModerate"),
	[2] 							= ApolloColor.new("ConTough"),
	[3] 							= ApolloColor.new("ConHard"),
	[4] 							= ApolloColor.new("ConImpossible"),
}
ktDispositionColors = {
	[Unit.CodeEnumDisposition.Hostile] 		= "DispositionHostile",
	[Unit.CodeEnumDisposition.Neutral] 		= "DispositionNeutral",
	[Unit.CodeEnumDisposition.Friendly] 	= "DispositionFriendly",
}
ktCustomColor = {
	[0] = "DispositionHostile",			--default hostile
	[1] = "DispositionNeutral",			--default neutral
	[2] = "DispositionFriendlyUnflagged",	--default group
	[3] = "DispositionGuildmateUnflagged",	--default guild
	[4] = "DispositionFriendly",			--default ally
	[5] = "cyan",
	[6] = "magenta",
	[7] = "white",
	[8] = "black",
	[9] = "gray",
	[10] = "darkgray",
	[11] = "blue",
	[12] = "xkcdAmber",
	[13] = "xkcdAmethyst",
	[14] = "xkcdApple",
	[15] = "xkcdAqua",
	[16] = "xkcdAquaGreen",
	[17] = "xkcdAquamarine",
	[18] = "xkcdAubergine",
	[19] = "xkcdBabyGreen",
	[20] = "xkcdBabyPink",
	[21] = "xkcdBabyPurple",
	[22] = "xkcdBanana",
	[23] = "xkcdBarbiePink",
	[24] = "xkcdBattleshipGrey",
	[25] = "xkcdBeige",
	[26] = "xkcdBerry",
	[27] = "xkcdBurgundy",
	[28] = "xkcdBlueberry",
	[29] = "xkcdBluegreen",
	[30] = "xkcdBlush",
	[31] = "xkcdBrick",
	[32] = "xkcdBronze",
	[33] = "xkcdBrown",
	[34] = "xkcdBubblegum",
	[35] = "xkcdBuff",
	[36] = "xkcdCamo",
	[37] = "xkcdGold",
	[38] = "xkcdOrange",
	[39] = "xkcdPurple",
	[40] = "xkcdSilver",
	[41] = "xkcdTurquoise",
	[42] = "xkcdTeal",
	[43] = "xkcdTwilight",
	[44] = "xkcdViolet",
	[45] = "xkcdDusk",
	[46] = "xkcdDesert",
	[47] = "xkcdWeirdGreen",
	[48] = "xkcdWheat",
	[49] = "xkcdWisteria",
	[50] = "xkcdRose",
}
local ktPathSprite = {
	[PlayerPathLib.PlayerPathType_Soldier] 	= "CRB_MinimapSprites:sprMM_SmallIconSoldier",
	[PlayerPathLib.PlayerPathType_Settler] 	= "CRB_MinimapSprites:sprMM_SmallIconSettler",
	[PlayerPathLib.PlayerPathType_Scientist] 	= "CRB_MinimapSprites:sprMM_SmallIconScientist",
	[PlayerPathLib.PlayerPathType_Explorer] 	= "CRB_MinimapSprites:sprMM_SmallIconExplorer",
}
local ktClassSprite = {
	[GameLib.CodeEnumClass.Spellslinger] 	= "CRB_Raid:sprRaid_Icon_Class_Spellslinger",
	[GameLib.CodeEnumClass.Warrior] 		= "CRB_Raid:sprRaid_Icon_Class_Warrior",
	[GameLib.CodeEnumClass.Stalker] 		= "CRB_Raid:sprRaid_Icon_Class_Stalker",
	[GameLib.CodeEnumClass.Engineer] 		= "CRB_Raid:sprRaid_Icon_Class_Engineer",
	[GameLib.CodeEnumClass.Esper] 		= "CRB_Raid:sprRaid_Icon_Class_Esper",
	[GameLib.CodeEnumClass.Medic] 		= "CRB_Raid:sprRaid_Icon_Class_Medic",
}
local ktClassResource = {
	[GameLib.CodeEnumClass.Spellslinger] 	= 4,
	[GameLib.CodeEnumClass.Warrior] 		= 1,
	[GameLib.CodeEnumClass.Stalker] 		= 3,
	[GameLib.CodeEnumClass.Engineer] 		= 1,
	[GameLib.CodeEnumClass.Esper] 		= 1,
	[GameLib.CodeEnumClass.Medic] 		= 1,
}
local ktRankSprite = {
	[Unit.CodeEnumRank.Elite] 			= "spr_TargetFrame_ClassIcon_Elite",
	[Unit.CodeEnumRank.Superior] 			= "spr_TargetFrame_ClassIcon_Superior",
	[Unit.CodeEnumRank.Champion] 			= "spr_TargetFrame_ClassIcon_Champion",
	[Unit.CodeEnumRank.Standard] 			= "spr_TargetFrame_ClassIcon_Standard",
	[Unit.CodeEnumRank.Minion] 			= "spr_TargetFrame_ClassIcon_Minion",
	[Unit.CodeEnumRank.Fodder] 			= "spr_TargetFrame_ClassIcon_Fodder",
}
local ktRankText = {
	[Unit.CodeEnumRank.Elite] 			= "E",
	[Unit.CodeEnumRank.Superior] 			= "S",
	[Unit.CodeEnumRank.Champion] 			= "C",
	[Unit.CodeEnumRank.Standard] 			= "g",
	[Unit.CodeEnumRank.Minion] 			= "m",
	[Unit.CodeEnumRank.Fodder] 			= "f",
}

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
-- new
function EGPlates:new(o)
	o = o or {}
	setmetatable(o, self) 
	self.__index = self 

	-- initialize variables here
	o.tPreloadUnits = {}
	o.tUnloadedUnits = {}
	o.tUnits = {}
	o.vRestrictor = true
	o.vMaxPerFrame = 1
	o.tQueue = Queue:new()
	o.vRestrictedLoad = kvRestrictor
	o.tGroupMember = {}
	return o
end

-- init
function EGPlates:Init()
	local bHasConfigureFunction = true
	local strConfigureButtonText = "EGPlates"
	local tDependencies = {
		"Tooltips",
		"RewardIcons",
	}
	Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end

-- dependency requires error handler 
function EGPlates:OnDependencyError(strDependency, strError)
	return true
end

--save addon status
function EGPlates:OnSave(eLevel)
	if (eLevel ~= GameLib.CodeEnumAddonSaveLevel.Account) then 
		return 
	end 

	return {
		plate = self.bArcPlate,
		allycombat = self.bShowAC,
		allypeace = self.bShowAP,
		enemycombat = self.bShowEC,
		enemypeace = self.bShowEP,
		neutralcombat = self.bShowNC,
		neutralpeace = self.bShowNP,
		selfcombat = self.bShowSC,
		selfpeace = self.bShowSP,
		targetcombat = self.bShowTC,
		targetpeace = self.bShowTP,
		guild = self.bShowGuild,
		title = self.bShowTitle,
		level = self.bShowLevel,
		simple = self.bShowSimple,
		collect = self.bShowCollect,
		harvest = self.bShowHarvest,
		numbers = self.bShowNumbers,
		percent = self.bShowPercent,
		castbars = self.fCastBars,
		healthbars = self.fHealthBars,
		distance = self.fFilterDistance,
		npcs = self.bShowFriendlyNPCs,
		restrict = self.vRestrictedLoad,
		alwayslevel = self.bAlwaysLevel,
		alwaysia = self.bAlwaysIA,
		allycast = self.bAllyCast,
		resource = self.bShowResource,
		allyresource = self.bAllyResource,
		scaling = self.fScaling,
		text = self.bShowText,
		allycolor = self.crAlly,
		enemycolor = self.crEnemy,
		neutralcolor = self.crNeutral,
		groupcolor = self.crGroup,
		guildcolor = self.crGuild,
	}
end

--restore addon status
function EGPlates:OnRestore(eLevel,tSavedData) 
	self:LoadDefaults()
	if (eLevel ~= GameLib.CodeEnumAddonSaveLevel.Account) then 
		return 
	end

	if tSavedData.plate ~= nil then
		self.bArcPlate = tSavedData.plate 
	end
	if tSavedData.allycombat ~= nil then
		self.bShowAC = tSavedData.allycombat 
	end
	if tSavedData.allypeace ~= nil then
		self.bShowAP = tSavedData.allypeace 
	end
	if tSavedData.enemycombat ~= nil then
		self.bShowEC = tSavedData.enemycombat 
	end
	if tSavedData.enemypeace ~= nil then
		self.bShowEP = tSavedData.enemypeace 
	end
	if tSavedData.neutralcombat ~= nil then
		self.bShowNC = tSavedData.neutralcombat 
	end
	if tSavedData.neutralpeace ~= nil then
		self.bShowNP = tSavedData.neutralpeace 
	end
	if tSavedData.selfcombat ~= nil then
		self.bShowSC = tSavedData.selfcombat 
	end
	if tSavedData.selfpeace ~= nil then
		self.bShowSP = tSavedData.selfpeace 
	end
	if tSavedData.targetcombat ~= nil then
		self.bShowTC = tSavedData.targetcombat 
	end
	if tSavedData.targetpeace ~= nil then
		self.bShowTP = tSavedData.targetpeace 
	end
	if tSavedData.guild ~= nil then
		self.bShowGuild = tSavedData.guild 
	end
	if tSavedData.title ~= nil then
		self.bShowTitle = tSavedData.title 
	end
	if tSavedData.level ~= nil then
		self.bShowLevel = tSavedData.level 
	end
	if tSavedData.harvest ~= nil then
		self.bShowHarvest = tSavedData.harvest
	end
	if tSavedData.simple ~= nil then
		self.bShowSimple = tSavedData.simple 
	end
	if tSavedData.collect ~= nil then
		self.bShowCollect = tSavedData.collect 
	end
	if tSavedData.numbers ~= nil then
		self.bShowNumbers = tSavedData.numbers
	end
	if tSavedData.percent ~= nil then
		self.bShowPercent = tSavedData.percent
	end
	if tSavedData.castbars ~= nil then
		self.fCastBars = tSavedData.castbars
	end
	if tSavedData.healthbars ~= nil then
		self.fHealthBars = tSavedData.healthbars
	end
	if tSavedData.distance ~= nil then
		self.fFilterDistance = tSavedData.distance
	end
	if tSavedData.npcs ~= nil then
		self.bShowFriendlyNPCs = tSavedData.npcs
	end
	if tSavedData.restrict ~= nil then
		self.vRestrictedLoad = tSavedData.restrict
	end
	if tSavedData.alwayslevel  ~= nil then
		self.bAlwaysLevel = tSavedData.alwayslevel
	end
	if tSavedData.alwaysia ~= nil then
		self.bAlwaysIA = tSavedData.alwaysia
	end
	if tSavedData.allycast ~= nil then
		self.bAllyCast = tSavedData.allycast
	end
	if tSavedData.resource ~= nil then
		self.bShowResource = tSavedData.resource
	end
	if tSavedData.allyresource ~= nil then
		self.bAllyResource = tSavedData.allyresource
	end
	if tSavedData.scaling ~= nil then
		self.fScaling = tSavedData.scaling
	end
	if tSavedData.text ~= nil then
		self.bShowText = tSavedData.text
	end
	if tSavedData.allycolor  ~= nil then
		self.crAlly = tSavedData.allycolor
	end
	if tSavedData.enemycolor  ~= nil then
		self.crEnemy = tSavedData.enemycolor
	end
	if tSavedData.neutralcolor  ~= nil then
		self.crNeutral = tSavedData.neutralcolor
	end
	if tSavedData.groupcolor  ~= nil then
		self.crGroup = tSavedData.groupcolor
	end
	if tSavedData.guildcolor  ~= nil then
		self.crGuild = tSavedData.guildcolor
	end

end 

function EGPlates:LoadDefaults()
	self.bArcPlate = true
	self.bShowAC = true 
	self.bShowAP = true 
	self.bShowEC = true
	self.bShowEP = true 
	self.bShowNC = true
	self.bShowNP = true
	self.bShowSC = true
	self.bShowSP = true
	self.bShowTC = true
	self.bShowTP = true
	self.bShowGuild = true 
	self.bShowTitle = true
	self.bShowLevel = true
	self.bShowHarvest = true
	self.bShowSimple = true
	self.bShowCollect = true 
	self.bShowNumbers = true 
	self.bShowPercent = true 
	self.fCastBars = 0.75
	self.fHealthBars = 0.5
	self.fFilterDistance = nil
	self.bShowFriendlyNPCs = true
	self.bAlwaysLevel = false
	self.bAlwaysIA = false
	self.bAllyCast = false
	self.bShowResource = true
	self.bAllyResource = false
	self.fScaling = 100
	self.crAlly = 4
	self.crEnemy = 0
	self.crNeutral = 1
	self.crGroup = 2
	self.crGuild = 3
end

-----------------------------------------------------------------------------------------------
-- EGPlates OnLoad
-----------------------------------------------------------------------------------------------
function EGPlates:OnLoad()
	Apollo.RegisterEventHandler("UnitCreated", "OnPreloadUnitCreated", self)
	-- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("EGPlates.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
end

function EGPlates:OnPreloadUnitCreated(unit)
	local unitId = unit:GetId()
	if self.tPreloadUnits and unit and unitId then
		self.tPreloadUnits[unitId] = unit
	end
end

function EGPlates:CreateUnitsFromPreload()
	if self.tPreloadUnits then
		for id, unit in pairs(self.tPreloadUnits) do
			self:OnUnitCreated(unit)
		end
		self.tPreloadUnits = {}
	end
end

-----------------------------------------------------------------------------------------------
-- EGPlates OnDocLoaded
-----------------------------------------------------------------------------------------------
function EGPlates:OnDocLoaded()
	Apollo.RemoveEventHandler("UnitCreated", self)

	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
		local wnd = nil
		if self.bArcPlate then
			self:OnArc()
			wnd = Apollo.LoadForm(self.xmlDoc, "NameplateArc", nil, self)
		else
			self:OnStd()
			wnd = Apollo.LoadForm(self.xmlDoc, "NameplateStd", nil, self)
		end
		local l,t,r,b = wnd:FindChild("BarContainer:CastBar"):GetAnchorOffsets()
		self.tAnchorPoints = { l = l, t = t, r = r, b = b }
		wnd = nil

		self.wndMain = Apollo.LoadForm(self.xmlDoc, "EGPlatesOptions:MainForm", nil, self)
		if self.wndMain == nil then
			Apollo.AddAddonErrorText(self, "Could not load the Main window for some reason.")
			return
		end
		self.wndDistance = Apollo.LoadForm(self.xmlDoc, "EGPlatesOptions:DistanceForm", nil, self)
		if self.wndDistance == nil then
			Apollo.AddAddonErrorText(self, "Could not load Distance window for some reason.")
			return
		end
		self.wndNumbers = Apollo.LoadForm(self.xmlDoc, "EGPlatesOptions:NumbersForm", nil, self)
		if self.wndNumbers == nil then
			Apollo.AddAddonErrorText(self, "Could not load Numbers window for some reason.")
			return
		end
		self.wndReload = Apollo.LoadForm(self.xmlDoc, "EGPlatesOptions:ReloadForm", nil, self)
		if self.wndReload == nil then
			Apollo.AddAddonErrorText(self, "Could not load Reload window for some reason.")
			return
		end
		self.wndLevel = Apollo.LoadForm(self.xmlDoc, "EGPlatesOptions:LevelForm", nil, self)
		if self.wndLevel == nil then
			Apollo.AddAddonErrorText(self, "Could not load Level window for some reason.")
			return
		end
		self.wndResource = Apollo.LoadForm(self.xmlDoc, "EGPlatesOptions:ResourceForm", nil, self)
		if self.wndResource == nil then
			Apollo.AddAddonErrorText(self, "Could not load Resource window for some reason.")
			return
		end
		self.wndColor = Apollo.LoadForm(self.xmlDoc, "EGPlatesOptions:ColorForm", nil, self)
		if self.wndColor == nil then
			Apollo.AddAddonErrorText(self, "Could not load Color window for some reason.")
			return
		end
		self.wndEnemyColor = self.wndColor:FindChild("txtEnemyColor")
		self.wndNeutralColor = self.wndColor:FindChild("txtNeutralColor")
		self.wndGroupColor = self.wndColor:FindChild("txtGroupColor")
		self.wndGuildColor = self.wndColor:FindChild("txtGuildColor")
		self.wndAllyColor = self.wndColor:FindChild("txtAllyColor")
		self.wndTextDistance = self.wndDistance:FindChild("txtDistance")
		self.wndTextScale = self.wndMain:FindChild("txtScale")
		self.wndSliderDistance = self.wndDistance:FindChild("slbDistance")
		self.wndHealthBars = self.wndMain:FindChild("txtHealthBars")
		self.wndCastBars = self.wndMain:FindChild("txtCastBars")
		self.wndMain:Show(false, true)
		self.wndDistance:Show(false, true)
		self.wndNumbers:Show(false, true)
		self.wndReload:Show(false, true)
		self.wndLevel:Show(false, true)
		self.wndResource:Show(false, true)
		self.wndColor:Show(false, true)
		self.wndLoad = self.wndMain:FindChild("txtLoading")
		local str = string.format("%d%s",self.vRestrictedLoad,"%")
		self.wndLoad:SetText(str)
		-----------------------------------------------------------------------------------
		-- variables (some may need to be before handlers)
		--self.tUnits = {}
		--self.tUnloadedUnits = {}
		-- Register handlers for events, slash commands and timer, etc.
		-----------------------------------------------------------------------------------
		-- Slash commands
		Apollo.RegisterSlashCommand("egplates", "OnConfigure", self)

		-----------------------------------------------------------------------------------
		-- Event handlers
		Apollo.RegisterEventHandler("EGPlatesOptions", "OnConfigure", self)
		Apollo.RegisterEventHandler("UnitCreated", "OnUnitCreated", self)
		Apollo.RegisterEventHandler("UnitDestroyed", "OnUnitDestroyed", self)
		Apollo.RegisterEventHandler("VarChange_FrameCount", "OnFrame", self)
		Apollo.RegisterEventHandler("VarChange_ZoneName", "OnChangeZoneName", self)
		Apollo.RegisterEventHandler("UnitNameChanged", "OnUnitNameChanged", self)
		Apollo.RegisterEventHandler("UnitTitleChanged",	"OnUnitNameChanged", self)
		Apollo.RegisterEventHandler("PlayerTitleChange", "OnPlayerTitleChanged", self)
		Apollo.RegisterEventHandler("UnitLevelChanged", "OnUnitLevelChanged", self)
		Apollo.RegisterEventHandler("UnitEnteredCombat", "OnUnitEnteredCombat", self)
		Apollo.RegisterEventHandler("TargetUnitChanged", "OnTargetUnitChanged", self)
		Apollo.RegisterEventHandler("Group_Join", "OnGroupChanged", self)				-- ()
		Apollo.RegisterEventHandler("Group_Add", "OnGroupChanged", self)				-- ( name )
		Apollo.RegisterEventHandler("Group_Remove", "OnGroupChanged", self)				-- ( name, reason )
		Apollo.RegisterEventHandler("Group_Left", "OnGroupChanged", self)				-- ( reason )
		Apollo.RegisterEventHandler("InterfaceMenuListHasLoaded", "OnInterfaceMenuListHasLoaded", self)
		local tRewardUpdateEvents = {
			"QuestObjectiveUpdated", "QuestStateChanged", "ChallengeAbandon", "ChallengeLeftArea",
			"ChallengeFailTime", "ChallengeFailArea", "ChallengeActivate", "ChallengeCompleted",
			"ChallengeFailGeneric", "PublicEventObjectiveUpdate", "PublicEventUnitUpdate",
			"PlayerPathMissionUpdate"
		}
	
		for i, str in pairs(tRewardUpdateEvents) do
			Apollo.RegisterEventHandler(str, "OnRewardUpdated", self)
		end

		-----------------------------------------------------------------------------------
		-- Timers
		Apollo.RegisterTimerHandler("EGRefreshTimer", "OnTimer", self)
		Apollo.CreateTimer("EGRefreshTimer", 1 / self.vRestrictedLoad, true)
		Apollo.RegisterTimerHandler("GroupCheckTimer", "OnGroupCheckTimer", self)
		Apollo.CreateTimer("GroupCheckTimer", 1, false)
		Apollo.StopTimer("GroupCheckTimer")

		-- Do additional Addon initialization here
		self.unitPlayer = GameLib.GetPlayerUnit()
		self.challenges = ChallengesLib.GetActiveChallengeList()

		self.wndMain:FindChild("chkLevel"):SetCheck(self.bShowLevel)
		self.wndMain:FindChild("chkGuild"):SetCheck(self.bShowGuild)
		self.wndMain:FindChild("chkTitle"):SetCheck(self.bShowTitle)
		self.wndMain:FindChild("chkCombatAlly"):SetCheck(self.bShowAC)
		self.wndMain:FindChild("chkPeaceAlly"):SetCheck(self.bShowAP)
		self.wndMain:FindChild("chkCombatEnemy"):SetCheck(self.bShowEC)
		self.wndMain:FindChild("chkPeaceEnemy"):SetCheck(self.bShowEP)
		self.wndMain:FindChild("chkCombatNeutral"):SetCheck(self.bShowNC)
		self.wndMain:FindChild("chkPeaceNeutral"):SetCheck(self.bShowNP)
		self.wndMain:FindChild("chkCombatPet"):SetCheck(self.bShowTC)
		self.wndMain:FindChild("chkPeacePet"):SetCheck(self.bShowTP)
		self.wndMain:FindChild("chkCombatSelf"):SetCheck(self.bShowSC)
		self.wndMain:FindChild("chkPeaceSelf"):SetCheck(self.bShowSP)
		self.wndMain:FindChild("chkCollect"):SetCheck(self.bShowCollect)
		self.wndMain:FindChild("chkSimple"):SetCheck(self.bShowSimple)
		self.wndMain:FindChild("chkHarvest"):SetCheck(self.bShowHarvest)
		self.wndMain:FindChild("chkNumbers"):SetCheck(self.bShowNumbers)
		self.wndMain:FindChild("chkFriendlyNPC"):SetCheck(self.bShowFriendlyNPCs)
		self.wndMain:FindChild("chkAlwaysIA"):SetCheck(self.bAlwaysIA)
		self.wndMain:FindChild("chkAllyCast"):SetCheck(self.bAllyCast)
		self.wndMain:FindChild("chkResource"):SetCheck(self.bShowResource)
		self.wndMain:FindChild("slbLoading"):SetValue(self.vRestrictedLoad)

		self.wndMain:FindChild("slbCast"):SetValue(self.fCastBars)
		str = string.format("%d",self.fCastBars*100) .. "%"
		self.wndCastBars:SetText(str)

		self.wndMain:FindChild("slbHealth"):SetValue(self.fHealthBars)
		str = string.format("%d",self.fHealthBars*100) .. "%"
		self.wndHealthBars:SetText(str)

		self.wndMain:FindChild("slbScaling"):SetValue(self.fScaling)
		str = string.format("%d%s",self.fScaling,"%")
		self.wndTextScale:SetText(str)

		self.wndEnemyColor:SetTextColor(ktCustomColor[self.crEnemy])
		self.wndColor:FindChild("slbEnemyColor"):SetValue(self.crEnemy)
		self.wndNeutralColor:SetTextColor(ktCustomColor[self.crNeutral])
		self.wndColor:FindChild("slbNeutralColor"):SetValue(self.crNeutral)
		self.wndGroupColor:SetTextColor(ktCustomColor[self.crGroup])
		self.wndColor:FindChild("slbGroupColor"):SetValue(self.crGroup)
		self.wndGuildColor:SetTextColor(ktCustomColor[self.crGuild])
		self.wndColor:FindChild("slbGuildColor"):SetValue(self.crGuild)
		self.wndAllyColor:SetTextColor(ktCustomColor[self.crAlly])
		self.wndColor:FindChild("slbAllyColor"):SetValue(self.crAlly)
	
		self:ChangeNameplateSize(self.fScaling)

		self.wndResource:FindChild("chkAllyResource"):SetCheck(self.bAllyResource)

		self.wndLevel:FindChild("chkAlwaysLevel"):SetCheck(self.bAlwaysLevel)

		self.wndNumbers:FindChild("chkPercent"):SetCheck(self.bShowPercent)

		if self.fFilterDistance and self.fFilterDistance < 150 then
			self.wndDistance:FindChild("slbDistance"):SetValue(self.fFilterDistance)
			str = string.format("%dm",self.fFilterDistance)
			self.wndTextDistance:SetText(str)
		else
			self.fFilterDistance = nil
		end

		self:CreateUnitsFromPreload()
	end
end

-----------------------------------------------------------------------------------------------
-- EGPlates Slash Command Functions
-----------------------------------------------------------------------------------------------
function EGPlates:OnConfigure()
	if self.fFilterDistance and self.fFilterDistance < 150 then
		self.wndMain:FindChild("chkDistance"):SetCheck(true)
		self.wndDistance:Show(true)
	else
		self.wndMain:FindChild("chkDistance"):SetCheck(false)
		self.wndDistance:Show(false)
		self.fFilterDistance = nil
	end
	self.wndNumbers:Show(self.bShowNumbers)
	self.wndLevel:Show(self.bShowLevel)
	self.wndResource:Show(self.bShowResource)
	self.wndMain:Show(true) -- show the window
end

function EGPlates:OnInterfaceMenuListHasLoaded()
	Event_FireGenericEvent("InterfaceMenuList_NewAddOn", "EGPlates",
		{"EGPlatesOptions", "", nil})
	--self:UpdateInterfaceMenuAlerts()
end

--function EGPlates:UpdateInterfaceMenuAlerts()
--	local nPoints = GameLib.GetAbilityPoints() + AbilityBook.GetAvailablePower()
--	Event_FireGenericEvent("InterfaceMenuList_AlertAddOn", "EGPlates",{nPoints > 0, nil, nPoints})
--end

-----------------------------------------------------------------------------------------------
-- EGPlates Event Handler Functions
-----------------------------------------------------------------------------------------------
-- Unit created, return true if handled or false if not handled
function EGPlates:OnUnitCreated(unit)
	if not self.unitPlayer then
		self:OnPreloadUnitCreated(unit)	
		return true
	end
	
	self.tQueue:Push(unit)

	return true
end

-- Unit destroyed
function EGPlates:OnUnitDestroyed(unit)
	local id = unit:GetId()
	self:DestroyUnit(id)
end

function EGPlates:OnFrame()
	for idx, tNameplate in pairs(self.tUnits) do
		self:DrawNameplate(tNameplate)
	end
end

--zone change handler
function EGPlates:OnChangeZoneName(oVar, strNewZone)
	--local eCurrentZonePvPRules = GameLib.GetCurrentZonePvpRules()
	if strNewZone == nil then
		return
	end

	self.unitPlayer = GameLib.GetPlayerUnit()
	self:CreateUnitsFromPreload()
end

function EGPlates:OnRewardUpdated()
	self.challenges = ChallengesLib.GetActiveChallengeList()
	self:CreateUnitsFromUnloaded()
	for id, tNameplate in pairs(self.tUnits) do
		if tNameplate.unit then
			if not tNameplate.bIsPlayer then
				local showReward = self:UpdateReward(tNameplate.unit:GetRewardInfo())
				if tNameplate.bRewardOnly and not showReward then
					self:UnloadedUnitCreated(tNameplate.unit)
					self:DestroyUnit(tNameplate.unitId)
				else
					tNameplate.wndRefs.bShowReward = showReward
					tNameplate.wndRefs.reward:Show(showReward)
					if tNameplate.disposition and tNameplate.disposition == Unit.CodeEnumDisposition.Friendly then
						tNameplate.bShowPeace = showReward or (self.bShowFriendlyNPCs and self.bShowAP) 
						tNameplate.bShowCombat = showReward or (self.bShowFriendlyNPCs and self.bShowAC)
					end
					tNameplate.bUpdated = true
				end
			end
		end
	end
end

function EGPlates:OnUnitNameChanged(unit, strNewName)
	local tNameplate = self.tUnits[unit:GetId()]
	if tNameplate ~= nil then
		tNameplate.wndRefs.name:SetText(self.bShowTitle and unit:GetTitleOrName() or unit:GetName())
		tNameplate.bUpdated = true
	end
end

function EGPlates:OnPlayerTitleChanged()
	if not self.unitPlayer then
		return
	end
	local tNameplate = self.tUnits[self.unitPlayer:GetId()]
	if tNameplate ~= nil then
		tNameplate.wndRefs.name:SetText(self.bShowTitle and self.unitPlayer:GetTitleOrName() or self.unitPlayer:GetName())
		tNameplate.bUpdated = true
	end
end

function EGPlates:OnUnitLevelChanged(unit)
	local tNameplate = self.tUnits[unit:GetId()]
	if tNameplate ~= nil and not tNameplate.bSimple then
		if tNameplate.wndRefs.level then
			tNameplate.wndRefs.level:SetText(unit:GetLevel() or "")
		end
		tNameplate.bUpdated = true
	end
end

function EGPlates:OnUnitEnteredCombat(unit, bInCombat)
	local tNameplate = self.tUnits[unit:GetId()]
	if tNameplate then
		local disposition = unit:GetDispositionTo(self.unitPlayer)
--		if disposition and tNameplate.disposition and disposition ~= tNameplate.disposition then
		if disposition ~= tNameplate.disposition then
			tNameplate.disposition = disposition
			local wnd = tNameplate.wndNameplate
			local crNameColor = ApolloColor.new(self:GetColor(unit, false))
			if crNameColor and not tNameplate.bSimple then
				if not tNameplate.bShowReward then
					tNameplate.wndRefs.rank:Show(true)
				end
				--tNameplate.wndRefs.name:SetTextColor(crNameColor)
				if self.bArcPlate then
					tNameplate.wndRefs.health:SetBGColor(crNameColor)
				else
					--ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Command, unit:GetName(), "" )
					tNameplate.wndRefs.health:SetBarColor(crNameColor)
				end
			end

		end
		tNameplate.bInCombat = bInCombat
		tNameplate.bUpdated = true
	end
end

function EGPlates:OnTargetUnitChanged(unit) 
	if self.myTarget and self.tUnits[self.myTarget] then
		if self.tUnits[self.myTarget].wndRefs.target then
			self.tUnits[self.myTarget].wndRefs.target:Show(false)
		end
		self.tUnits[self.myTarget].bShowBars = self.tUnits[self.myTarget].unit:IsInYourGroup()
		self.tUnits[self.myTarget].bUpdated = true
	end
	if unit and GameLib.GetTargetUnit() == unit then
		self.myTarget = unit:GetId()
		if self.tUnits[self.myTarget] then
			if self.tUnits[self.myTarget].wndRefs.target then
				self.tUnits[self.myTarget].wndRefs.target:Show(true)
			end
			self.tUnits[self.myTarget].bShowBars = true
			self.tUnits[self.myTarget].bUpdated = true
		end
		--unit:Inspect()
	else
		self.myTarget = nil
	end
end

function EGPlates:OnGroupChanged()
	--[[for idx, unitId in pairs (self.tGroupMember) do
		local tNameplate = self.tUnits[unitId]
		if tNameplate then
			if tNameplate.unit:IsInYourGroup() then
				tNameplate.bShowBars = true
			else
				self:RemoveGroupMember(unitId)
				tNameplate.bShowBars = tNameplate.unit:IsInYourGroup() or self.myTarget == tNameplate.unitId
			end
		else
			self:RemoveGroupMember(unitId)
		end
	end
	local i = 0
	while i < GroupLib.GetMemberCount() do 
		local unit = GroupLib:GetUnitforGroupMember(i)
		if unit then
			self:AddGroupMember(unit:GetId())
		end
	end]]--
	Apollo.StartTimer("GroupCheckTimer")

end
-----------------------------------------------------------------------------------------------
-- EGPlates Timer Handler Functions
-----------------------------------------------------------------------------------------------
-- on timer
function EGPlates:OnTimer()
--ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Command, self.vMaxPerFrame, "" )
	self.vRestrictor = not self.vRestrictor
	if self.vRestrictor then
		self.vMaxPerFrame = GameLib.GetFrameRate() * self.vRestrictedLoad * 0.01
	else
		if self.tQueue:Empty() then
			return
		end
		local i = 0
		--while i < 10 do 
		--if not self.tQueue:Empty() then
			--ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Command, self.tQueue:GetSize() .. ">" .. self.vMaxPerFrame, "" )
		--end
		while i < self.vMaxPerFrame do 
			if self.tQueue:Empty() then
				return
			end
			if self:SetupUnit(self.tQueue:Pop()) then
				i = i + 1
			end
		end
	end
end

function EGPlates:OnGroupCheckTimer()
	for id, tNameplate in pairs(self.tUnits) do
		if tNameplate.bIsPlayer then
			local inGroup = tNameplate.unit:IsInYourGroup()
			tNameplate.bShowBars = inGroup or self.myTarget == tNameplate.unitId
			--if tNameplate.bShowBars then
			--	ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Command, tNameplate.unit:GetName(), "" )
			--end
			local crNameColor = ApolloColor.new(self:GetColor(tNameplate.unit, true))
			tNameplate.wndRefs.guild:SetTextColor(crNameColor)
			tNameplate.wndRefs.name:SetTextColor(crNameColor)
			if not inGroup then
				crNameColor = ApolloColor.new(self:GetColor(tNameplate.unit, false))
			end
			if self.bArcPlate then
				tNameplate.wndRefs.health:SetBGColor(crNameColor)
			else
				tNameplate.wndRefs.health:SetBarColor(crNameColor)
			end
			tNameplate.wndRefs.target:SetBGColor(crNameColor)
			tNameplate.bUpdated = true
		end
	end
end
-----------------------------------------------------------------------------------------------
-- EGPlates General Functions
-----------------------------------------------------------------------------------------------
function EGPlates:DrawNameplate(tNameplate)
	if not tNameplate.wndNameplate:IsOnScreen() 
	or tNameplate.wndNameplate:IsOccluded() 
	then
		if tNameplate.wndNameplate:IsShown() then
			tNameplate.wndNameplate:Show(false)
			tNameplate.bUpdated = true
		end
		return
	end

	if self.fFilterDistance and not tNameplate.bShowBars then
		if self:FilterUnitByDistance(tNameplate.unit) then
			if tNameplate.wndNameplate:IsShown() then
				tNameplate.wndNameplate:Show(false)
				tNameplate.bUpdated = true
			end
			return
		end
	end
	if tNameplate.unit:IsDead() then
		if tNameplate.wndNameplate:IsShown() then
			tNameplate.wndNameplate:Show(false)
			tNameplate.bUpdated = true
		end
		--self:DestroyUnit(tNameplate.unitId)
		return
	end
	--reduces performance by a bit... see about fixing that
	local overheadpos = tNameplate.unit:GetOverheadAnchor()
	if overheadpos and overheadpos.y < 0 then
		if tNameplate.bAnchorAbove then
			tNameplate.wndNameplate:SetUnit(tNameplate.unit, 0)
			tNameplate.bAnchorAbove = false
		end
	else
		if not tNameplate.bAnchorAbove then
			tNameplate.wndNameplate:SetUnit(tNameplate.unit, 1)
			tNameplate.bAnchorAbove = true
		end
	end
	if not tNameplate.bUpdated then
		return
	end
	tNameplate.bUpdated = false

	if tNameplate.bSimple then
		tNameplate.wndNameplate:Show(tNameplate.bShowPeace or (tNameplate.bShowCombat and tNameplate.bInCombat))
		return
	end

	if not (tNameplate.bShowPeace or tNameplate.bShowBars 
	or (tNameplate.bShowCombat and tNameplate.bInCombat)) then
		if tNameplate.wndNameplate:IsShown() then
			tNameplate.wndNameplate:Show(false)
			tNameplate.bUpdated = true
		end
		return
	end

	local wndHealth = tNameplate.wndRefs.health
	local wndHealthText = tNameplate.wndRefs.healthtxt
	local wndShield = tNameplate.wndRefs.shield
	local wndShieldText = tNameplate.wndRefs.shieldtxt
	local wndAbsorb = tNameplate.wndRefs.absorb
	local wndCast = tNameplate.wndRefs.cast
	local wndVuln = tNameplate.wndRefs.vuln
	local wndResource = tNameplate.wndRefs.resource
	local wndArmor = tNameplate.wndRefs.armor
	local wndLevel = tNameplate.wndRefs.level
	local wndAggro = tNameplate.wndRefs.aggro
	local wndReward = tNameplate.wndRefs.reward
	local wndGuild = tNameplate.wndRefs.guild

	if not tNameplate.bInCombat and not tNameplate.bShowBars then
		wndHealth:Show(false)
		wndShield:Show(false)
		wndAbsorb:Show(false)
		wndCast:Show(false)
		wndVuln:Show(false)
		wndHealthText:Show(false)
		wndShieldText:Show(false)
		wndArmor:Show(tNameplate.bShouldShowIA)
		wndLevel:Show(self.bAlwaysLevel)
		wndAggro:Show(false)
		if tNameplate.bIsPlayer then
			wndReward:Show(false)
			wndResource:Show(false)
		else
			wndGuild:Show(self.bShowText)
		end
		tNameplate.wndNameplate:Show(true)
		return
	end

	local maxHealth = tNameplate.unit:GetMaxHealth()
	local maxShield = 0
	local maxAbsorb = 0
	local maxCast = 0
	local maxVuln = 0
	local maxResource = 0
	local curHealth = 0
	local curShield = 0
	local curAbsorb = 0
	local curCast = 0
	local curVuln = 0
	local curResource = 0

	if maxHealth and maxHealth > 0
	and (tNameplate.bShowCombat and tNameplate.bInCombat
	or tNameplate.bShowBars) then
		curHealth = tNameplate.unit:GetHealth()

		local value = tNameplate.unit:GetInterruptArmorValue()
		maxShield = tNameplate.unit:GetShieldCapacityMax()
		maxAbsorb = tNameplate.unit:GetAbsorptionMax()
		if maxAbsorb and maxAbsorb > 0 then
			curAbsorb = tNameplate.unit:GetAbsorptionValue()
		end
		if maxShield and maxShield > 0 then
			curShield =	tNameplate.unit:GetShieldCapacity()
		end
		if value > 0 then
			tNameplate.bShouldShowIA = self.bAlwaysIA
			if not wndArmor:IsShown() then
				wndArmor:Show(true)
			end
			wndArmor:SetText(value or 0)
		else
			if wndArmor:IsShown() then
				wndArmor:Show(false)
			end
		end
		if tNameplate.unit:ShouldShowCastBar() and not (tNameplate.bIsAlly and not self.bAllyCast) then
			local castName = tNameplate.unit:GetCastName()
			if castName then
				wndCast:SetText(castName)
			end
			maxCast = tNameplate.unit:GetCastDuration()
			curCast = tNameplate.unit:GetCastElapsed()
		end
		local nVulnerable = tNameplate.unit:GetCCStateTimeRemaining(Unit.CodeEnumCCState.Vulnerability)
		if nVulnerable and nVulnerable > 0 then
			if not tNameplate.nVulnerableTime then
				tNameplate.nVulnerableTime = nVulnerable
				--ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Command, unit:GetName(), "" )
			end
			wndVuln:SetText(string.format("%.1f", nVulnerable))
			maxVuln = tNameplate.nVulnerableTime
			curVuln = nVulnerable

		else
			tNameplate.nVulnerableTime = nil
		end
		local aggro = self.unitPlayer == tNameplate.unit:GetTarget()
		if aggro then
			if not wndAggro:IsShown() then
				wndAggro:Show(true)
			end
		else
			if wndAggro:IsShown() then
				wndAggro:Show(false)
			end
		end

		tNameplate.bUpdated = true
	end

	self:SetBarValue(wndHealth, 0, curHealth, maxHealth)
	self:SetBarValue(wndShield, 0, curShield, maxShield)
	self:SetBarValue(wndAbsorb, 0, curAbsorb, maxAbsorb)
	self:SetBarValue(wndCast, 0, curCast, maxCast)
	self:SetBarValue(wndVuln, 0, curVuln, maxVuln)
	self:SetBarText(wndHealthText, curHealth, maxHealth)
	self:SetBarText(wndShieldText, curShield, maxShield)
	if tNameplate.bIsPlayer then
		wndReward:Show(true)
		if self.bShowResource and tNameplate.unit:IsThePlayer() or self.bAllyResource then
			curResource = tNameplate.unit:GetResource(tNameplate.iResource)
			maxResource = tNameplate.unit:GetMaxResource(tNameplate.iResource)
		end
		self:SetBarValue(wndResource, 0, curResource, maxResource)
	else
		wndGuild:Show(false)
	end
	wndLevel:Show(self.bShowLevel)

	if not tNameplate.wndNameplate:IsShown() then
		tNameplate.wndNameplate:Show(true)
	end
end

function EGPlates:FilterUnitByDistance(unit)
	if self.fFilterDistance > 0 then
		local posA = self.unitPlayer:GetPosition()
		local posB = unit:GetPosition()
		local nDeltaX = posA.x - posB.x
		local nDeltaZ = posA.z - posB.z
		local nDeltaY = posA.y - posB.y
		local nDistance = (nDeltaX * nDeltaX) + (nDeltaY * nDeltaY) + (nDeltaZ * nDeltaZ)
		return (nDistance > (self.fFilterDistance * self.fFilterDistance))
	else
		return true
	end
	return false
end


function EGPlates:SetBarValue(wndBar, fMin, fValue, fMax)
	local isShown = fValue > 0
	if wndBar:IsShown() ~= isShown then
		wndBar:Show(isShown)
	end
	if isShown then
		wndBar:Show(fValue > 0)
		wndBar:SetMax(fMax)
		wndBar:SetFloor(fMin)
		wndBar:SetProgress(fValue)
	end
end

function EGPlates:SetBarText(wndTxt, fValue, fMax)
	local txt = nil 
	if not self.bShowNumbers or not fMax or not fValue or fMax == 0 then
		wndTxt:Show(false)
		return
	elseif fMax > fValue then
		if self.bShowPercent then
			local value = fValue / fMax * 100
			txt = string.format("%d%c", value, 37)
		else
			local nth = ""
			if fValue > 1000000 then
				fValue = fValue / 1000000
				nth = "m"
			elseif fValue > 1000 then
				fValue = fValue / 1000
				nth = "k"
			end
			txt = string.format("%d%s",fValue,nth)
			if fMax > 1000000 then
				fMax = fMax / 1000000
				nth = "m"
			elseif fMax > 1000 then
				fMax = fMax / 1000
				nth = "k"
			end
			txt = string.format("%s/%d%s",txt,fMax,nth)
		end
	elseif self.bShowPercent then
		txt = "100%"
	else
		local nth = ""
		if fMax > 1000000 then
			fMax = fMax / 1000000
			nth = "m"
		elseif fMax > 1000 then
			fMax = fMax / 1000
			nth = "k"
		end
		txt = string.format("%d%s",fMax,nth)
	end
	wndTxt:SetText(txt)
	wndTxt:Show(fValue > 0)
end

function EGPlates:DestroyUnit(id)
	if self.tUnits[id] then
		if self.tUnits[id].wndNameplate then
			--self.tUnits[id].wndNameplate:Show(false, true)
			--self.tUnits[id].wndNameplate:SetUnit(nil)
			self.tUnits[id].wndNameplate:Destroy()
		end
		self.tUnits[id] = nil		
	end
	if self.tUnloadedUnits[id] then
		self.tUnloadedUnits[id] = nil		
	end
end

function EGPlates:UpdateReward(rewardInfo)
	if (rewardInfo == nil) then
		return false
	end
	for idx, temp in pairs(rewardInfo) do
		if self.challenges[rewardInfo[idx].idChallenge] then
			if self.challenges[rewardInfo[idx].idChallenge]:IsActivated() then
				return true
			end
		else
			return true
		end
	end
	return false
end

function EGPlates:GetColor(unit, bCheckGuild)
	if unit:IsInYourGroup() then
		return ktCustomColor[self.crGroup]
	end
	local guild = unit:GetAffiliationName()
	local myGuild = self.unitPlayer:GetGuildName()
	if bCheckGuild and self.unitPlayer and self.unitPlayer == unit and guild then
	--	return "DispositionGuildmateUnflagged"
		return ktCustomColor[self.crGuild]
	end
	if bCheckGuild and guild and myGuild and myGuild == guild then
	--	return "DispositionGuildmateUnflagged"
		return ktCustomColor[self.crGuild]
	end
	--return unit:GetNameplateColor() or ktDispositionColors[unit:GetDispositionTo(self.unitPlayer)]
	local disposition = unit:GetDispositionTo(self.unitPlayer)
	if disposition == Unit.CodeEnumDisposition.Hostile then
		return ktCustomColor[self.crEnemy]
	elseif disposition == Unit.CodeEnumDisposition.Friendly then
		return ktCustomColor[self.crAlly]
	end
	return ktCustomColor[self.crNeutral]
end

function EGPlates:ChangeDisplayType(strType, bIsShown, bInCombat)
	if bIsShown then
		self:CreateUnitsFromUnloaded()
	end

	if bInCombat then
		for idx, tNameplate in pairs(self.tUnits) do
			if tNameplate.strType == strType then
				tNameplate.bShowCombat = bIsShown
				tNameplate.bUpdated = true
			end
		end
	else
		for idx, tNameplate in pairs(self.tUnits) do
			if tNameplate.strType == strType then
				tNameplate.bShowPeace = bIsShown
				tNameplate.bUpdated = true
			end
		end
	end
end

function EGPlates:ChangeDisplayDisposition(disposition, bIsShown, bInCombat, strFilter)
	if bInCombat then
		for idx, tNameplate in pairs(self.tUnits) do
			if tNameplate.disposition == disposition 
			and tNameplate.strType ~= "Pet" and tNameplate.strType ~= strFilter then
				tNameplate.bShowCombat = bIsShown
				tNameplate.bUpdated = true
			end
		end
	else
		for idx, tNameplate in pairs(self.tUnits) do
			if tNameplate.disposition == disposition 
			and tNameplate.strType ~= "Pet" and tNameplate.strType ~= strFilter then
				tNameplate.bShowPeace = bIsShown
				tNameplate.bUpdated = true
			end
		end
	end
end

function EGPlates:ChangeDisplaySelf(bIsShown, bInCombat)
	if self.unitPlayer then
		local id = self.unitPlayer:GetId()
		tNameplate = self.tUnits[id]
		if tNameplate then
			if bInCombat then
				tNameplate.bShowCombat = bIsShown
			else
				tNameplate.bShowPeace = bIsShown
			end
			tNameplate.bUpdated = true
		end
	end
end

function EGPlates:ChangeHealthBars(fValue)
	for id, tNameplate in pairs(self.tUnits) do
		if tNameplate.wndRefs then
			if tNameplate.wndRefs.health then
				tNameplate.wndRefs.health:SetOpacity(fValue)
			end
			if tNameplate.wndRefs.shield then
				tNameplate.wndRefs.shield:SetOpacity(fValue)
			end
			if tNameplate.wndRefs.absorb then
				tNameplate.wndRefs.absorb:SetOpacity(fValue)
			end
			tNameplate.bUpdated = true
		end
	end
	self.fHealthBars = fValue
end

function EGPlates:ChangeNameplateSize(fValue)
	local scale = fValue / 100
	self.tAnchorPoints.l = math.floor(self.tAnchorPoints.l * scale)
	--self.tAnchorPoints.t = math.floor(self.tAnchorPoints.t * scale)
	self.tAnchorPoints.r = math.floor(self.tAnchorPoints.r * scale)
	--self.tAnchorPoints.b = math.floor(self.tAnchorPoints.b * scale)
end

function EGPlates:ChangeCastBars(fValue)
	for id, tNameplate in pairs(self.tUnits) do
		if tNameplate.wndRefs then
			if tNameplate.wndRefs.cast then
				tNameplate.wndRefs.cast:SetOpacity(fValue)
			end
			if tNameplate.wndRefs.vuln then
				tNameplate.wndRefs.vuln:SetOpacity(fValue)
			end
			tNameplate.bUpdated = true
		end
	end
	self.fCastBars = fValue
end

function EGPlates:ChangeDisplay()
	for id, tNameplate in pairs(self.tUnits) do
		tNameplate.bUpdated = true
	end
end

function EGPlates:ChangeDisplayGuild()
	for id, tNameplate in pairs(self.tUnits) do
		if tNameplate.wndRefs.guild then
			tNameplate.wndRefs.guild:Show(self.bShowGuild and tNameplate.bIsPlayer or self.bShowText)
			tNameplate.bUpdated = true
		end
	end
end

function EGPlates:ChangeDisplayTitle()
	for id, tNameplate in pairs(self.tUnits) do
		if tNameplate.unit then
			tNameplate.wndRefs.name:SetText(self.bShowTitle and tNameplate.unit:GetTitleOrName()
				or tNameplate.unit:GetName())
			tNameplate.bUpdated = true
		end
	end
end

function EGPlates:UnloadedUnitCreated(unit)
	if self.tUnloadedUnits and unit then
		self.tUnloadedUnits[unit:GetId()] = unit
	end
end

function EGPlates:CreateUnitsFromUnloaded()
	if self.tUnloadedUnits then
		for id, unit in pairs(self.tUnloadedUnits) do
			--local temp = unit
			--unit = nil
			self:OnUnitCreated(unit)
		end
	end
end

function EGPlates:FilterActivationState(unit)
	return false
end

function EGPlates:SetupUnit(unit)
	if unit == nil then
		return false
	end

	local playerId = self.unitPlayer:GetId()
	if not playerId then
		self:OnPreloadUnitCreated(unit)	
		return true
	end

	local id = unit:GetId()
	if id == nil or self.tUnits[id] ~= nil then
		--debug
		--ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Command, id, "" )
		return true
	end

	--ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Command, strType .. unit:GetName(), "" )
	if unit:IsACharacter() then -- it's a player
		return self:SetupPlayerUnit(self:NewNameplate(unit, id, playerId))
	elseif unit:GetUnitOwner() then -- it's a pet
		return self:SetupPetUnit(self:NewNameplate(unit, id, playerId))
	elseif unit:CanBeHarvestedBy(self.unitPlayer) then --harvest
		return self:SetupHarvestUnit(self:NewNameplate(unit, id, playerId))
	end

	local act = unit:GetActivationState()
	if unit:ShouldShowNamePlate() then -- it's an npc
		return self:SetupNonplayerUnit(self:NewNameplate(unit, id, playerId), act)
	elseif act and next(act) then --this gets collectible, teleporters, etc.
	--	return self:SetupCollectibleUnit(self:NewNameplate(unit, id, playerId))
		return self:SetupOtherUnit(self:NewNameplate(unit, id, playerId))
	else
		return self:SetupSimpleUnit(self:NewNameplate(unit, id, playerId), act)
	end

	return false
end

function EGPlates:NewNameplate(unit, id, playerId)
	local tNameplate = {
		playerId = playerId,
		unit = unit,
		unitId = id,
		bShowPeace = true,
		bShowCombat = true,
		bRewardOnly = false,
		bShowReward = false,
		strType = "Simple",
		disposition = nil,
		bInCombat = false,
		bUpdated = true,
		bShowBars = false,
		bAnchorAbove = true,
		wndRefs = nil,
	}
	return tNameplate
end

function EGPlates:SetupSimpleUnit(tNameplate, tActivation)
	--local showReward = self:UpdateReward(tNameplate.unit:GetRewardInfo())
	local showReward = false
	if tActivation then
		showReward = tActivation.QuestTarget or tActivation.QuestReceiving or tActivation.QuestNew
				or tActivation.QuestReward or tActivation.QuestNewMain
				or self:UpdateReward(tNameplate.unit:GetRewardInfo())
	end
	--if not (self.bShowSimple or showReward or tNameplate.unit:GetActivationState() ~= nil) then
	if not (self.bShowSimple or showReward) then
		self:UnloadedUnitCreated(tNameplate.unit)
		return true
	end
	
	tNameplate.bRewardOnly = true
	tNameplate.bShowReward = showReward,

	self:SetupSimpleNameplate(tNameplate)
	return true
end

function EGPlates:SetupOtherUnit(tNameplate)
	if not self.bShowCollect then
		self:UnloadedUnitCreated(tNameplate.unit)
		return true
	end

	tNameplate.bShowReward = self:UpdateReward(tNameplate.unit:GetRewardInfo()) or false
	tNameplate.strType = "Other"
	self:SetupSimpleNameplate(tNameplate)
	return true
end

function EGPlates:SetupNonplayerUnit(tNameplate, tActivation)
	--local test = self.unitPlayer:GetLevelDifferential(tNameplate.unit)
	--if test then
	--	ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Command, test .. tNameplate.unit:GetName(), "" )
	--end
	--local maxHealth = tNameplate.unit:GetMaxHealth()
	--if not maxHealth then
	--	return self:SetupSimpleUnit(tNameplate)
	--end
	if tNameplate.unit:GetType() == "Mount" then
		return false
	end

	--showReward = self:FilterActivationState(tNameplate.unit)
	--local showReward = self:UpdateReward(tNameplate.unit:GetRewardInfo())
	local showReward = false
	if tActivation then
		showReward = tActivation.QuestTarget or tActivation.QuestReceiving or tActivation.QuestNew
				or tActivation.QuestReward or tActivation.QuestNewMain
				or self:UpdateReward(tNameplate.unit:GetRewardInfo())
	end
	local	disposition = tNameplate.unit:GetDispositionTo(self.unitPlayer)
	local showPeace = false
	local showCombat = false
	local showRank = false
	local isAlly = false

	if disposition == Unit.CodeEnumDisposition.Friendly then
		showPeace = showReward or (self.bShowAP and self.bShowFriendlyNPCs)
		showCombat = showReward or (self.bShowAC and self.bShowFriendlyNPCs)
		isAlly = true
	elseif disposition == Unit.CodeEnumDisposition.Hostile then
		showPeace = showReward or self.bShowEP
		showCombat = showReward or self.bShowEC
		showRank = true
	else
		showPeace = showReward or self.bShowNP
		showCombat = showReward or self.bShowNC
		showRank = true
	end

	tNameplate.bShowPeace = showPeace
	tNameplate.bShowCombat = showCombat
	tNameplate.bShowReward = showReward
	tNameplate.strType = "Nonplayer"
	tNameplate.disposition = disposition
	tNameplate.bIsAlly = isAlly
	tNameplate.bInCombat = tNameplate.unit:IsInCombat() or false

	self:SetupCharacterNameplate(tNameplate, showRank, false)
	return true
end

function EGPlates:SetupPlayerUnit(tNameplate)
	local showCombat = false
	local showPeace = false
	local disposition = nil
	local isAlly = false
	
	if tNameplate.unit:IsThePlayer() then
		showPeace = self.bShowSP
		showCombat = self.bShowSC
	else
		disposition = tNameplate.unit:GetDispositionTo(self.unitPlayer)
		if disposition == Unit.CodeEnumDisposition.Friendly then
			showPeace = self.bShowAP
			showCombat = self.bShowAC
			isAlly = true
			tNameplate.bShowBars = tNameplate.unit:IsInYourGroup()
		elseif disposition == Unit.CodeEnumDisposition.Hostile then
			showPeace = self.bShowEP
			showCombat = self.bShowEC
		else
			showPeace = self.bShowNP
			showCombat = self.bShowNC
		end
	end

	tNameplate.bShowPeace = showPeace
	tNameplate.bShowCombat = showCombat
	tNameplate.bShowReward = true
	tNameplate.strType = "Player"
	tNameplate.bIsPlayer = true
	tNameplate.disposition = disposition
	tNameplate.bIsAlly = isAlly
	tNameplate.bInCombat = tNameplate.unit:IsInCombat() or false

	self:SetupCharacterNameplate(tNameplate, false, true)
	return true
end

function EGPlates:SetupHarvestUnit(tNameplate)
	if not self.bShowHarvest then
		self:UnloadedUnitCreated(tNameplate.unit)
		return true
	end

	--tNameplate.bShowReward = self:UpdateReward(tNameplate.unit:GetRewardInfo()) or false
	tNameplate.strType = "Harvest"

	self:SetupSimpleNameplate(tNameplate)
	return true
end

function EGPlates:SetupCollectibleUnit(tNameplate)
	if not self.bShowCollect then
		self:UnloadedUnitCreated(tNameplate.unit)
		return true
	end

	tNameplate.bShowReward = self:UpdateReward(tNameplate.unit:GetRewardInfo()) or false
	tNameplate.strType = "Collectible"

	self:SetupSimpleNameplate(tNameplate)
	return true
end

function EGPlates:SetupPetUnit(tNameplate)
	tNameplate.bShowPeace = self.bShowTP
	tNameplate.bShowCombat = self.bShowTC
	tNameplate.strType = "Pet"
	tNameplate.disposition = tNameplate.unit:GetDispositionTo(self.unitPlayer)
	tNameplate.bInCombat = tNameplate.unit:IsInCombat() or false

	self:SetupCharacterNameplate(tNameplate, false, false)
	return true
end

function EGPlates:SetupSimpleNameplate(tNameplate)
	local wnd = Apollo.LoadForm(self.xmlDoc, "NameplateSimple", "InWorldHudStratum", self)

	tNameplate.wndNameplate = wnd
	tNameplate.bSimple = true
	tNameplate.wndRefs = {
		name = wnd:FindChild("Name"),
		reward = wnd:FindChild("BarContainer:Reward"),
	}

	tNameplate.wndRefs.name:SetText(self.bShowTitle and tNameplate.unit:GetTitleOrName() or tNameplate.unit:GetName())
	tNameplate.wndRefs.reward:Show(tNameplate.bShowReward)

	tNameplate.wndNameplate:Show(false, true)
	tNameplate.wndNameplate:SetUnit(tNameplate.unit, 1)
	self.tUnits[tNameplate.unitId] = tNameplate
end

function EGPlates:SetupCharacterNameplate(tNameplate, showRank, isPlayer)
	local wnd = Apollo.LoadForm(self.xmlDoc, self.wndPlate, "InWorldHudStratum", self)
	--wnd:SetAnchorOffsets(self.tAnchorPoints.l, self.tAnchorPoints.t, self.tAnchorPoints.r, self.tAnchorPoints.b)
	
	tNameplate.wndNameplate = wnd
	tNameplate.wndRefs = {
		name = wnd:FindChild("Name"),
		reward = wnd:FindChild("BarContainer:Reward"),
		healthtxt = wnd:FindChild("BarContainer:Health"),
		health = wnd:FindChild("BarContainer:HealthBar"),
		shieldtxt = wnd:FindChild("BarContainer:Shield"),
		shield = wnd:FindChild("BarContainer:ShieldBar"),
		absorb = wnd:FindChild("BarContainer:AbsorbBar"),
		level = wnd:FindChild("BarContainer:Level"),
		armor = wnd:FindChild("BarContainer:Armor"),
		cast = wnd:FindChild("BarContainer:CastBar"),
		vuln = wnd:FindChild("BarContainer:VulnBar"),
		target = wnd:FindChild("Target"),
		aggro = wnd:FindChild("BarContainer:Aggro"),
		rank = wnd:FindChild("Rank"),
		guild = wnd:FindChild("Guild"),
	}
	local level = tNameplate.unit:GetLevel() or ""
	tNameplate.wndRefs.name:SetText(self.bShowTitle and tNameplate.unit:GetTitleOrName() or tNameplate.unit:GetName())
	local crNameColor = ApolloColor.new(self:GetColor(tNameplate.unit, true)) or nil
	tNameplate.wndRefs.cast:SetAnchorOffsets(self.tAnchorPoints.l, self.tAnchorPoints.t, self.tAnchorPoints.r, self.tAnchorPoints.b)
	tNameplate.wndRefs.vuln:SetAnchorOffsets(self.tAnchorPoints.l, self.tAnchorPoints.t, self.tAnchorPoints.r, self.tAnchorPoints.b)
	if isPlayer then
		local	guild = tNameplate.unit:GetGuildName()
		if guild then
			tNameplate.wndRefs.guild:SetText(guild)
			tNameplate.wndRefs.guild:SetTextColor(crNameColor)
			tNameplate.wndRefs.guild:Show(self.bShowGuild)
		end
		local classId = tNameplate.unit:GetClassId()
		tNameplate.iResource = ktClassResource[classId] 
		tNameplate.wndRefs.resource = wnd:FindChild("ResourceBar")
		self:SetBarValue(tNameplate.wndRefs.resource, 0,
			 tNameplate.unit:GetResource(tNameplate.iResource), tNameplate.unit:GetMaxResource(tNameplate.iResource))
		local l,t,r,b = tNameplate.wndRefs.resource:GetAnchorOffsets()
		tNameplate.wndRefs.resource:SetAnchorOffsets(self.tAnchorPoints.l, t, self.tAnchorPoints.r, b)
		tNameplate.wndRefs.resource:Show(self.bShowResource and tNameplate.unit:IsThePlayer() or self.bAllyResource)
		tNameplate.wndRefs.reward:SetSprite(ktClassSprite[classId])
		local ia = tNameplate.unit:GetInterruptArmorValue()
		if ia and ia > 0 then
			tNameplate.bShouldShowIA = self.bAlwaysIA
			tNameplate.wndRefs.armor:SetText(ia or 0)
		end
	else
		local textDesc = level
		local rank = tNameplate.unit:GetRank()
		local textRank = ""
		if rank and ktRankSprite[rank] then
			textRank = " (" .. ktRankText[rank] .. ")"
			local value = tNameplate.unit:GetGroupValue()
			if value > 0 then
				tNameplate.wndRefs.rank:SetText(value)
				textRank = "(P)"
			end
			tNameplate.wndRefs.rank:SetSprite(ktRankSprite[rank])
		end
		local ia = tNameplate.unit:GetInterruptArmorValue()
		if ia and ia > 0 then
			textDesc = textDesc .. "[" .. ia .. "]"
			tNameplate.bShouldShowIA = self.bAlwaysIA
			tNameplate.wndRefs.armor:SetText(ia or 0)
		end
		textDesc = textDesc .. textRank
		tNameplate.wndRefs.guild:SetText(textDesc)
		tNameplate.wndRefs.guild:Show(self.bShowText)
	end

	tNameplate.wndRefs.reward:Show(tNameplate.bShowReward)
	tNameplate.wndRefs.rank:Show(showRank)
	tNameplate.wndRefs.cast:Show(self.bAllyCast or not tNameplate.bIsAlly)

	if crNameColor then
		tNameplate.wndRefs.name:SetTextColor(crNameColor)
		crNameColor = ApolloColor.new(self:GetColor(tNameplate.unit, false))
		
		if self.bArcPlate then
			tNameplate.wndRefs.health:SetBGColor(crNameColor)
		else
			tNameplate.wndRefs.health:SetBarColor(crNameColor)
		end
		tNameplate.wndRefs.target:SetBGColor(crNameColor)
	end

	tNameplate.wndRefs.level:SetText(level)
	local diff = self.unitPlayer:GetLevelDifferential(tNameplate.unit) or 0
	if diff < 0 then
		tNameplate.wndRefs.level:SetTextColor(ktConColors[diff] or ktConColors[-4])
	else
		tNameplate.wndRefs.level:SetTextColor(ktConColors[diff] or ktConColors[4])
	end

	tNameplate.wndRefs.level:Show(self.bShowLevel)
	tNameplate.wndRefs.health:SetOpacity(self.fHealthBars)
	tNameplate.wndRefs.shield:SetOpacity(self.fHealthBars)
	tNameplate.wndRefs.absorb:SetOpacity(self.fHealthBars)
	tNameplate.wndRefs.cast:SetOpacity(self.fCastBars)
	tNameplate.wndRefs.vuln:SetOpacity(self.fCastBars)

	tNameplate.wndNameplate:Show(false, true)
	tNameplate.wndNameplate:SetUnit(tNameplate.unit, 1)

	self.tUnits[tNameplate.unitId] = tNameplate
end

function EGPlates:ReloadUnits()
	for id, tNameplate in pairs(self.tUnits) do
		self:DestroyUnit(tNameplate.unitId)
		self:OnUnitCreated(tNameplate.unit)
	end
end

function EGPlates:AddGroupMember(unitId)
	if unitId then
		self.tGroupMember[unitId] = unitId
	end
end

function EGPlates:IsGroupMember(unitId)
	return self.tGroupMember[unitId] ~= nil 
end

function EGPlates:RemoveGroupMember(unitId)
	if unitId then
		self.tGroupMember[unitId] = nil
	end
end
-----------------------------------------------------------------------------------------------
-- EGPlatesForm Functions
-----------------------------------------------------------------------------------------------
-- when the OK button is clicked
function EGPlates:OnArc()
	self.wndPlate = "NameplateArc"
	self.bArcPlate = true
	self:ReloadUnits()
end

-- when the Cancel button is clicked
function EGPlates:OnCancel()
	self.wndMain:Close() -- hide the window
	self.wndDistance:Close()
	self.wndNumbers:Close()
	self.wndReload:Close()
	self.wndLevel:Close()
	self.wndResource:Close()
	self.wndColor:Close()
end


function EGPlates:OnStd()
	self.wndPlate = "NameplateStd"
	self.bArcPlate = false
	self:ReloadUnits()
end

function EGPlates:OnText()
	self.bShowText = not self.bShowText
	self:ChangeDisplay()
end

function EGPlates:OnColor()
	if self.wndColor then
		if self.wndColor:IsShown() then
			self.wndColor:Show(false)
			self:ReloadUnits()
		else
			self.wndColor:Show(true)
		end
	end
end

function EGPlates:OnFont()
end

function EGPlates:OnToggleCombatSelf( wndHandler, wndControl, eMouseButton )
	self.bShowSC = not self.bShowSC
	self:ChangeDisplaySelf(self.bShowSC, true)
end

function EGPlates:OnToggleCombatPet( wndHandler, wndControl, eMouseButton )
	self.bShowTC = not self.bShowTC
	self:ChangeDisplayType("Pet", self.bShowTC, true)
end

function EGPlates:OnToggleCombatEnemy( wndHandler, wndControl, eMouseButton )
	self.bShowEC = not self.bShowEC
	self:ChangeDisplayDisposition(Unit.CodeEnumDisposition.Hostile, self.bShowEC, true, nil)
end

function EGPlates:OnToggleCombatAlly( wndHandler, wndControl, eMouseButton )
	self.bShowAC = not self.bShowAC
	self:ChangeDisplayDisposition(Unit.CodeEnumDisposition.Friendly, self.bShowAC, true, nil)
end

function EGPlates:OnToggleCombatNeutral( wndHandler, wndControl, eMouseButton )
	self.bShowNC = not self.bShowNC
	self:ChangeDisplayDisposition(Unit.CodeEnumDisposition.Neutral, self.bShowNC, true, nil)
end

function EGPlates:OnTogglePeaceSelf( wndHandler, wndControl, eMouseButton )
	self.bShowSP = not self.bShowSP
	self:ChangeDisplaySelf(self.bShowSP, false)
end

function EGPlates:OnTogglePeacePet( wndHandler, wndControl, eMouseButton )
	self.bShowTP = not self.bShowTP
	self:ChangeDisplayType("Pet", self.bShowTP, false)
end

function EGPlates:OnTogglePeaceEnemy( wndHandler, wndControl, eMouseButton )
	self.bShowEP = not self.bShowEP
	self:ChangeDisplayDisposition(Unit.CodeEnumDisposition.Hostile, self.bShowEP, false, nil)
end

function EGPlates:OnTogglePeaceAlly( wndHandler, wndControl, eMouseButton )
	self.bShowAP = not self.bShowAP
	self:ChangeDisplayDisposition(Unit.CodeEnumDisposition.Friendly, self.bShowAP, false, nil)
end

function EGPlates:OnTogglePeaceNeutral( wndHandler, wndControl, eMouseButton )
	self.bShowNP = not self.bShowNP
	self:ChangeDisplayDisposition(Unit.CodeEnumDisposition.Neutral, self.bShowNP, false, nil)
end

function EGPlates:OnToggleGuild( wndHandler, wndControl, eMouseButton )
	self.bShowGuild = not self.bShowGuild
	self:ChangeDisplayGuild()
end

function EGPlates:OnToggleTitle( wndHandler, wndControl, eMouseButton )
	self.bShowTitle = not self.bShowTitle
	self:ChangeDisplayTitle()
end

function EGPlates:OnToggleLevel( wndHandler, wndControl, eMouseButton )
	self.bShowLevel = not self.bShowLevel
	self:ChangeDisplay()
	if self.wndLevel then
		self.wndLevel:Show(self.bShowLevel)
	end
end

function EGPlates:OnToggleHarvest( wndHandler, wndControl, eMouseButton )
	self.bShowHarvest = not self.bShowHarvest
	self:ChangeDisplayType("Harvest", self.bShowHarvest, true)
	self:ChangeDisplayType("Harvest", self.bShowHarvest, false)
end

function EGPlates:OnToggleCollect( wndHandler, wndControl, eMouseButton )
	self.bShowCollect = not self.bShowCollect
	self:ChangeDisplayType("Other", self.bShowCollect, true)
	self:ChangeDisplayType("Other", self.bShowCollect, false)
end

function EGPlates:OnToggleSimple( wndHandler, wndControl, eMouseButton )
	self.bShowSimple = not self.bShowSimple
	self:ChangeDisplayType("Simple", self.bShowSimple, true)
	self:ChangeDisplayType("Simple", self.bShowSimple, false)
end

function EGPlates:OnToggleNumbers( wndHandler, wndControl, eMouseButton )
	self.bShowNumbers = not self.bShowNumbers
	if self.wndNumbers then
		self.wndNumbers:Show(self.bShowNumbers)
	end
end

function EGPlates:OnTogglePercent( wndHandler, wndControl, eMouseButton )
	self.bShowPercent = not self.bShowPercent
end

function EGPlates:OnSliderBarChangedHealth( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndHealthBars then
		local str = string.format("%d",fNewValue*100) .. "%"
		self.wndHealthBars:SetText(str)
		self:ChangeHealthBars(fNewValue)
	end
end

function EGPlates:OnSliderBarChangedCast( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndCastBars then
		local str = string.format("%d",fNewValue*100) .. "%"
		self.wndCastBars:SetText(str)
		self:ChangeCastBars(fNewValue)
	end
end

function EGPlates:OnSliderBarChangedDist( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndTextDistance then
		local str = string.format("%dm",fNewValue)
		self.wndTextDistance:SetText(str)
		if fNewValue < 150 then 
			self.fFilterDistance = fNewValue
		else
			self.fFilterDistance = nil
		end
		self:ChangeDisplay()
	end
end

function EGPlates:OnSliderBarChangedLoad( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndLoad then
		self.vRestrictedLoad = fNewValue
		local str = string.format("%d%s",self.vRestrictedLoad,"%")
		self.wndLoad:SetText(str)
		self.wndReload:Show(true)
	end
end

function EGPlates:ReloadUI()
	ChatSystemLib.Command("/reloadui")
end

function EGPlates:OnToggleDistance( wndHandler, wndControl, eMouseButton )
	if self.fFilterDistance then
		self.wndDistance:Show(false)
		self.fFilterDistance = nil
	else
		self.fFilterDistance = 150
		self.wndSliderDistance:SetValue(self.fFilterDistance) 
		local str = string.format("%dm",self.fFilterDistance)
		self.wndTextDistance:SetText(str)
		self.wndDistance:Show(true)
	end
end

function EGPlates:OnToggleFriendlyNPC( wndHandler, wndControl, eMouseButton )
	self.bShowFriendlyNPCs = not self.bShowFriendlyNPCs
	self:ChangeDisplayDisposition(Unit.CodeEnumDisposition.Friendly, 
		self.bShowFriendlyNPCs and self.bShowAP, false, "Player")
	self:ChangeDisplayDisposition(Unit.CodeEnumDisposition.Friendly, 
		self.bShowFriendlyNPCs and self.bShowAC, true, "Player")
end

function EGPlates:OnToggleAlwaysIA( wndHandler, wndControl, eMouseButton )
	self.bAlwaysIA = not self.bAlwaysIA
	self:ReloadUnits()
end

function EGPlates:OnToggleAlwaysLevel( wndHandler, wndControl, eMouseButton )
	self.bAlwaysLevel = not self.bAlwaysLevel
	self:ChangeDisplay()
end

function EGPlates:OnToggleAllyCast( wndHandler, wndControl, eMouseButton )
	self.bAllyCast = not self.bAllyCast
	self:ChangeDisplay()
end

function EGPlates:OnToggleResource( wndHandler, wndControl, eMouseButton )
	self.bShowResource = not self.bShowResource
	self:ChangeDisplay()
	if self.wndResource then
		self.wndResource:Show(self.bShowResource)
	end
end

function EGPlates:OnToggleAllyResource( wndHandler, wndControl, eMouseButton )
	self.bAllyResource = not self.bAllyResource
	self:ChangeDisplay()
end

function EGPlates:OnSliderBarChangedScale( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndTextScale then
		self.fScaling = fNewValue
		local str = string.format("%d%s",fNewValue,"%")
		self.wndTextScale:SetText(str)
		self:ChangeNameplateSize(fNewValue)
		self.wndReload:Show(true)
	end
end

function EGPlates:OnSliderBarChangedEnemyColor( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndEnemyColor then
		local value = math.floor(fNewValue)
		self.wndEnemyColor:SetTextColor(ktCustomColor[value])
		self.crEnemy = value
	end
end

function EGPlates:OnSliderBarChangedNeutralColor( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndNeutralColor then
		local value = math.floor(fNewValue)
		self.wndNeutralColor:SetTextColor(ktCustomColor[value])
		self.crNeutral = value
	end
end

function EGPlates:OnSliderBarChangedGroupColor( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndGroupColor then
		local value = math.floor(fNewValue)
		self.wndGroupColor:SetTextColor(ktCustomColor[value])
		self.crGroup = value
	end
end

function EGPlates:OnSliderBarChangedGuildColor( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndGuildColor then
		local value = math.floor(fNewValue)
		self.wndGuildColor:SetTextColor(ktCustomColor[value])
		self.crGuild = value
	end
end

function EGPlates:OnSliderBarChangedAllyColor( wndHandler, wndControl, fNewValue, fOldValue )
	if self.wndAllyColor then
		local value = math.floor(fNewValue)
		self.wndAllyColor:SetTextColor(ktCustomColor[value])
		self.crAlly = value
	end
end
-----------------------------------------------------------------------------------------------
-- EGPlates Instance
-----------------------------------------------------------------------------------------------
local EGPlatesInst = EGPlates:new()
EGPlatesInst:Init()
