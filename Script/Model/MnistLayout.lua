-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___rawset = rawset
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

assert(ADeeplearning.ARobotModel, " extends class:ADeeplearning.ARobotModel is nil")
ADeeplearning.MinstModel = Lua.Class(ADeeplearning.ARobotModel, "ADeeplearning.MinstModel")

function ADeeplearning.MinstModel:Ctor()
	___rawset(self, "_input_list", {{0, 0}, {0, 1}, {1, 0}, {1, 1}})
	___rawset(self, "_output_list", {{0}, {1}, {1}, {0}})
	___rawset(self, "_total_train_count", ALittle.List_Len(self._input_list))
	___rawset(self, "_input", self._session:CreateInput({2}))
	___rawset(self, "_output", self._session:CreateInput({1}))
	___rawset(self, "_fc1", self._session:CreateLinear(2, 8))
	___rawset(self, "_fc2", self._session:CreateLinear(8, 1))
	local input = self._input:Calc()
	local output = self._output:Calc()
	local x = self._fc1:Calc(input)
	x = x:Sigmoid()
	___rawset(self, "_out", self._fc2:Calc(x))
	___rawset(self, "_loss", self._out:Subtraction(output):Square())
end

function ADeeplearning.MinstModel:SetMnistRoot(root_path)
end

function ADeeplearning.MinstModel:TrainImpl(index)
	self._input:Update(self._input_list[index])
	self._output:Update(self._output_list[index])
	self._session:Reset()
	local right = ALittle.Math_Abs(self._out:AsScalar() - self._output_list[index][1]) < 0.001
	local loss = self._loss:AsScalar()
	self._session:Train()
	return loss, right
end

function ADeeplearning.MinstModel:Output(x1, x2)
	self._input:Update({x1, x2})
	self._session:Reset()
	return self._out:AsScalar()
end

assert(ADeeplearning.CommonTrainLayout, " extends class:ADeeplearning.CommonTrainLayout is nil")
ADeeplearning.MnistTrainLayout = Lua.Class(ADeeplearning.CommonTrainLayout, "ADeeplearning.MnistTrainLayout")

function ADeeplearning.MnistTrainLayout.__getter:model()
	if self._model == nil then
		self._model = ADeeplearning.MinstModel()
		self._model:SetMnistRoot(ADeeplearning.g_ModuleBasePath .. "Data")
	end
	return self._model
end

assert(ALittle.DisplayLayout, " extends class:ALittle.DisplayLayout is nil")
ADeeplearning.MnistLayout = Lua.Class(ALittle.DisplayLayout, "ADeeplearning.MnistLayout")

function ADeeplearning.MnistLayout:Ctor()
	___rawset(self, "_loaded", false)
end

function ADeeplearning.MnistLayout:TCtor()
	self._train:AddEventListener(___all_struct[958494922], self, self.HandleTrainChanged)
	self._model_path = ADeeplearning.g_ModuleBasePath .. "Other/mnist.model"
	self._model = deeplearning.DeeplearningMnistModel()
	self._board:SetPan(5, 0xFFFFFFFF)
	self._board:SetDrawSize(ALittle.Math_Floor(self._board.width), ALittle.Math_Floor(self._board.height), 0xFF000000)
	self._result_text.text = "识别结果"
end

function ADeeplearning.MnistLayout:HandleTrainChanged(event)
	self._model:Load(self._model_path)
end

function ADeeplearning.MnistLayout:HandleDrawChanged(event)
	if not self._loaded then
		self._model:Load(self._model_path)
		self._loaded = true
	end
	local address = carp.GetCarpSurfaceAddress(self._board.surface)
	local result = self._model:Output(address)
	self._result_text.text = "识别结果:" .. result
end

function ADeeplearning.MnistLayout:HandleClearClick(event)
	self._result_text.text = "识别结果"
	self._board:ClearContent(0xFF000000)
end

end