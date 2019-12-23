-- 
-- Nightlight3 (with random set)
-- Script: Blacky_BPG
-- 
-- 1.9.0.2      05.12.2019    update for new shader based window lights
-- 1.9.0.1      04.12.2019    initial Version for FS19
-- 1.5.3.1      13.04.2018    add UserAttribute for not only nightlight, expand hour chance table
-- 1.4.2.0 A    19.02.2017    add lower chance between 23 and 4 o'clock
-- 1.4.2.0      18.02.2017    add UserAttribute for visibility chance
-- 1.3.1.0      21.01.2017    add hour check for random light on/off
-- 1.3.0.0      02.12.2016    initial Version for FS17
-- 

Nightlight3 = {}
Nightlight3.hourFactor = {}
Nightlight3.hourFactor[0]=0.45
Nightlight3.hourFactor[1]=0.3
Nightlight3.hourFactor[2]=0.1
Nightlight3.hourFactor[3]=0.25
Nightlight3.hourFactor[4]=0.5
Nightlight3.hourFactor[5]=1
Nightlight3.hourFactor[6]=1
Nightlight3.hourFactor[7]=1
Nightlight3.hourFactor[8]=1
Nightlight3.hourFactor[9]=1
Nightlight3.hourFactor[10]=1
Nightlight3.hourFactor[11]=1
Nightlight3.hourFactor[12]=1
Nightlight3.hourFactor[13]=1
Nightlight3.hourFactor[14]=1
Nightlight3.hourFactor[15]=1
Nightlight3.hourFactor[16]=1
Nightlight3.hourFactor[17]=1
Nightlight3.hourFactor[18]=1
Nightlight3.hourFactor[19]=1
Nightlight3.hourFactor[20]=1.5
Nightlight3.hourFactor[21]=1.2
Nightlight3.hourFactor[22]=0.9
Nightlight3.hourFactor[23]=0.6

Nightlight3.version = "1.9.0.2"
Nightlight3.date = "05.12.2019"
local Nightlight3_mt = Class(Nightlight3)
function Nightlight3.onCreate(id)
	g_currentMission:addNonUpdateable(Nightlight3:new(id))
end

function Nightlight3:new(id)
	local self = {}
	setmetatable(self, Nightlight3_mt)
	self.id = id
	self.isClassic = Utils.getNoNil(getUserAttribute(self.id, "classicLight"), true)
	self.onlyNight = Utils.getNoNil(getUserAttribute(self.id, "onlyNight"), true)
	self.onChance = Utils.getNoNil(getUserAttribute(self.id, "onChance"), 33)
	self.lightIntensity = Utils.getNoNil(getUserAttribute(self.id, "lightIntensity"), 1.0)
	self.onChanceBackup = self.onChance

	if not self.isClassic then
		setShaderParameter(self.id, "lightControl", 0, 0, 0, 0, false)
		if getNumOfChildren(self.id) > 0 then
			self.lightsId = getChildAt(self.id, 0)
		end
	else
		setVisibility(self.id, false)
	end

	if self.lightsId ~= nil then
		setVisibility(self.lightsId, false)
	end

	g_currentMission.environment:addWeatherChangeListener(self)
	g_currentMission.environment:addHourChangeListener(self)
	return self
end

function Nightlight3:delete()
	if g_currentMission.environment ~= nil then
		g_currentMission.environment:removeWeatherChangeListener(self)
		g_currentMission.environment:removeHourChangeListener(self)
	end
end

function Nightlight3:hourChanged()
	self.onChance = self.onChanceBackup
	if g_currentMission.environment ~= nil and Nightlight3.hourFactor[g_currentMission.environment.currentHour] ~= nil then
		self.onChance = self.onChanceBackup * Nightlight3.hourFactor[g_currentMission.environment.currentHour]
	end
	self:weatherChanged()
end

function Nightlight3:weatherChanged()
	if g_currentMission ~= nil and g_currentMission.environment ~= nil then
		local lightsChance = math.random(1,100) < self.onChance
		local lightsOn = false
		if (self.onlyNight == false and g_currentMission.environment.weather:getIsRaining()) or not g_currentMission.environment.isSunOn then
			lightsOn = true
		end

		local lightObject = self.id
		if not self.isClassic then
			lightObject = self.lightsId
		end
		if not self.isClassic then
			if lightsOn and lightsChance then
				setShaderParameter(self.id, "lightControl", self.lightIntensity, 0, 0, 0, false)
			else
				setShaderParameter(self.id, "lightControl", 0, 0, 0, 0, false)
			end
		end
		setVisibility(lightObject, lightsOn==true and lightsChance==true)
	end
end

g_onCreateUtil.addOnCreateFunction("Nightlight3", Nightlight3.onCreate)

print(" ++ Nightlight 3 "..tostring(Nightlight3.version).." - "..tostring(Nightlight3.date).." (by Blacky_BPG)")
