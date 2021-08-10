-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___pairs = pairs
local ___ipairs = ipairs
local ___all_struct = ALittle.GetAllStruct()

ALittle.RegStruct(-1479093282, "ALittle.UIEvent", {
name = "ALittle.UIEvent", ns_name = "ALittle", rl_name = "UIEvent", hash_code = -1479093282,
name_list = {"target"},
type_list = {"ALittle.DisplayObject"},
option_map = {}
})
ALittle.RegStruct(958494922, "ALittle.UIChangedEvent", {
name = "ALittle.UIChangedEvent", ns_name = "ALittle", rl_name = "UIChangedEvent", hash_code = 958494922,
name_list = {"target"},
type_list = {"ALittle.DisplayObject"},
option_map = {}
})

assert(ADeeplearning.CommonTrainLayout, " extends class:ADeeplearning.CommonTrainLayout is nil")
ADeeplearning.G2048TrainLayout = Lua.Class(ADeeplearning.CommonTrainLayout, "ADeeplearning.G2048TrainLayout")

function ADeeplearning.G2048TrainLayout.__getter:model()
	if self._model == nil then
		self._model = deeplearning.Deeplearning2048Model(4, 4, 2000)
		self._model_path = ADeeplearning.g_ModuleBasePath .. "Other/g2048.model"
	end
	return self._model
end

assert(ALittle.DisplayLayout, " extends class:ALittle.DisplayLayout is nil")
ADeeplearning.G2048Layout = Lua.Class(ALittle.DisplayLayout, "ADeeplearning.G2048Layout")

function ADeeplearning.G2048Layout:TCtor()
	self._train:AddEventListener(___all_struct[958494922], self, self.HandleTrainChanged)
	self._model_path = ADeeplearning.g_ModuleBasePath .. "Other/g2048.model"
	self._model = deeplearning.Deeplearning2048Model(4, 4, 2000)
	self._model:Load(self._model_path)
	self._model:Restart2048()
	self:UpdateText()
end

function ADeeplearning.G2048Layout:HandleTrainChanged(event)
	self._model:Load(self._model_path)
end

function ADeeplearning.G2048Layout:HandleCalcAIClick(event)
	self._model:Play2048(self._model:PlayAI())
	self:UpdateText()
end

function ADeeplearning.G2048Layout:HandleCalcLeftClick(event)
	self._model:Play2048(2)
	self:UpdateText()
end

function ADeeplearning.G2048Layout:HandleCalcRightClick(event)
	self._model:Play2048(1)
	self:UpdateText()
end

function ADeeplearning.G2048Layout:HandleCalcUpClick(event)
	self._model:Play2048(3)
	self:UpdateText()
end

function ADeeplearning.G2048Layout:HandleCalcDownClick(event)
	self._model:Play2048(0)
	self:UpdateText()
end

function ADeeplearning.G2048Layout:HandleRestartClick(event)
	self._model:Restart2048()
	self:UpdateText()
end

function ADeeplearning.G2048Layout:UpdateText()
	local row = 0
	while true do
		if not(row < 4) then break end
		local col = 0
		while true do
			if not(col < 4) then break end
			local text = self["_2048_" .. row .. "_" .. col]
			local value = self._model:Get2048(row, col)
			text.text = value
			if value == 0 then
				text.text = "-"
			end
			col = col+(1)
		end
		row = row+(1)
	end
end

end