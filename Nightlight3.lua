-- 
-- Nightlight3 (with random set)
-- Script: Blacky_BPG
-- 
-- 1.9.0.4      09.03.2020    add ignoreNight attribute to force light on daylight
-- 1.9.0.3      29.02.2020    remove hour change time and add minute change time, add xml file functionality, add light group functionality
-- 1.9.0.2      05.12.2019    update for new shader based window lights
-- 1.9.0.1      04.12.2019    initial Version for FS19
-- 1.5.3.1      13.04.2018    add UserAttribute for not only nightlight, expand hour chance table
-- 1.4.2.0 A    19.02.2017    add lower chance between 23 and 4 o'clock
-- 1.4.2.0      18.02.2017    add UserAttribute for visibility chance
-- 1.3.1.0      21.01.2017    add hour check for random light on/off
-- 1.3.0.0      02.12.2016    initial Version for FS17
-- 

Nightlight3 = {}
Nightlight3.directory = g_currentModDirectory
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

Nightlight3.version = "1.9.0.4"
Nightlight3.date = "09.03.2020"
local Nightlight3_mt = Class(Nightlight3)
function Nightlight3.onCreate(id)
	g_currentMission:addNonUpdateable(Nightlight3:new(id))
end

function Nightlight3:new(id)
	local self = {}
	setmetatable(self, Nightlight3_mt)
	self.id = id
	self.switchObject = {}
	self.switchObject[1] = id
	local fileName = getUserAttribute(self.id, "xmlFile")
	if fileName ~= nil then
		self.xmlConfig = Utils.getFilename(fileName,Nightlight3.directory)
	end
	self.hourFactors = {}
	for x=0, 23 do
		self.hourFactors[x] = Nightlight3.hourFactor[x]
	end
	local xmlLoader = false
	if self.xmlConfig ~= nil and fileExists(self.xmlConfig) then
		local configName = Utils.getNoNil(getUserAttribute(self.id, "configName"), getName(self.id))
		local xmlFile = loadXMLFile("nightlightXML", self.xmlConfig)
		if xmlFile ~= nil then
			local i = 0
			local key = string.format("nightlights.nightlight(%d)", i)
			while hasXMLProperty(xmlFile, key) do
				if configName == getXMLString(xmlFile, key.."#name") then
					xmlLoader = true
					self.isClassic = Utils.getNoNil(getXMLBool(xmlFile, key..".isClassic"),Utils.getNoNil(getUserAttribute(self.id, "classicLight"), true))
					self.ignoreNight = Utils.getNoNil(getXMLBool(xmlFile, key..".ignoreNight"),Utils.getNoNil(getUserAttribute(self.id, "ignoreNight"), false))
					self.onlyNight = Utils.getNoNil(getXMLBool(xmlFile, key..".onlyNight"),Utils.getNoNil(getUserAttribute(self.id, "onlyNight"), true))
					self.isGroup = Utils.getNoNil(getXMLBool(xmlFile, key..".isGroup"),Utils.getNoNil(getUserAttribute(self.id, "isGroup"), false))
					self.groupAsSingle = Utils.getNoNil(getXMLBool(xmlFile, key..".groupAsSingle"),Utils.getNoNil(getUserAttribute(self.id, "groupAsSingle"), false))
					self.onChance = Utils.getNoNil(getXMLInt(xmlFile, key..".onChance"),Utils.getNoNil(getUserAttribute(self.id, "onChance"), 33))
					self.changeTimer = Utils.getNoNil(getXMLInt(xmlFile, key..".changeTimer"),Utils.getNoNil(getUserAttribute(self.id, "changeTimer"), 60))
					self.lightIntensity = Utils.getNoNil(getXMLFloat(xmlFile, key..".lightIntensity"),Utils.getNoNil(getUserAttribute(self.id, "lightIntensity"), 1.0))
					if hasXMLProperty(xmlFile, key..".hourFactors") then
						for k=0,23 do
							if hasXMLProperty(xmlFile, key..".hourFactors.h"..k) then
								self.hourFactors[k] = Utils.getNoNil(getXMLFloat(xmlFile, key..".hourFactors.h"..k),self.hourFactors[k])
							end
						end
					end
				end
				i = i + 1
				key = string.format("nightlights.nightlight(%d)", i)
			end
			delete(xmlFile)
		end
	end
	if xmlLoader == false then
		self.isClassic = Utils.getNoNil(getUserAttribute(self.id, "classicLight"), true)
		self.isGroup = Utils.getNoNil(getUserAttribute(self.id, "isGroup"), false)
		self.groupAsSingle = Utils.getNoNil(getUserAttribute(self.id, "groupAsSingle"), false)
		self.ignoreNight = Utils.getNoNil(getUserAttribute(self.id, "ignoreNight"), true)
		self.onlyNight = Utils.getNoNil(getUserAttribute(self.id, "onlyNight"), true)
		self.onChance = Utils.getNoNil(getUserAttribute(self.id, "onChance"), 33)
		self.changeTimer = Utils.getNoNil(getUserAttribute(self.id, "changeTimer"), 60)
		self.lightIntensity = Utils.getNoNil(getUserAttribute(self.id, "lightIntensity"), 1.0)
	end

	if self.isGroup then
		local numObjects = getNumOfChildren(self.id)
		if numObjects > 0 then
			for i=1, numObjects do
				self.switchObject[i] = getChildAt(self.id, i-1)
			end
		else
			self.isGroup = false
		end
	end

	self.onChanceBackup = self.onChance
	self.nextMinuteTime = g_currentMission.environment.currentMinute + 1

	for i=1, #self.switchObject do
		if not self.isClassic then
			setShaderParameter(self.switchObject[i], "lightControl", 0, 0, 0, 0, false)
			if getNumOfChildren(self.switchObject[i]) > 0 then
				local lightsId = getChildAt(self.switchObject[i], 0)
				if lightsId ~= nil then
					setVisibility(lightsId, false)
				end
			end
		else
			setVisibility(self.switchObject[i], false)
		end
	end

	g_currentMission.environment:addWeatherChangeListener(self)
	g_currentMission.environment:addMinuteChangeListener(self)
	return self
end

function Nightlight3:delete()
	if g_currentMission.environment ~= nil then
		g_currentMission.environment:removeWeatherChangeListener(self)
		g_currentMission.environment:removeMinuteChangeListener(self)
	end
end

function Nightlight3:minuteChanged()
	self.onChance = self.onChanceBackup
	if self.nextMinuteTime == g_currentMission.environment.currentMinute then
		self.nextMinuteTime = self.nextMinuteTime + self.changeTimer
		if self.nextMinuteTime > 59 then
			self.nextMinuteTime = self.nextMinuteTime - 60
		end
		if g_currentMission.environment ~= nil and self.hourFactors[g_currentMission.environment.currentHour] ~= nil then
			self.onChance = self.onChanceBackup * self.hourFactors[g_currentMission.environment.currentHour]
		end
		self:weatherChanged()
	end
end

function Nightlight3:weatherChanged()
	if g_currentMission ~= nil and g_currentMission.environment ~= nil then
		local lightsChance = math.random(1,100) < self.onChance
		local lightsOn = self.ignoreNight
		if (self.onlyNight == false and g_currentMission.environment.weather:getIsRaining()) or not g_currentMission.environment.isSunOn then
			lightsOn = true
		end

		for i=1, #self.switchObject do
			local lightObject = self.switchObject[i]
			if not self.isClassic then
				lightObject = getChildAt(self.switchObject[i], 0)
			end
			if not self.isClassic then
				if lightsOn and lightsChance then
					setShaderParameter(self.switchObject[i], "lightControl", self.lightIntensity, 0, 0, 0, false)
				else
					setShaderParameter(self.switchObject[i], "lightControl", 0, 0, 0, 0, false)
				end
			end
			setVisibility(lightObject, lightsOn==true and lightsChance==true)
			if not self.groupAsSingle then
				lightsChance = math.random(1,100) < self.onChance
			end
		end
	end
end

g_onCreateUtil.addOnCreateFunction("Nightlight3", Nightlight3.onCreate)

print(" ++ Nightlight 3 "..tostring(Nightlight3.version).." - "..tostring(Nightlight3.date).." (by Blacky_BPG)")
