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
ADeeplearning.XorModel = Lua.Class(ADeeplearning.ARobotModel, "ADeeplearning.XorModel")

function ADeeplearning.XorModel:Ctor()
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

function ADeeplearning.XorModel:TrainCountPerFrame()
	return 10
end

function ADeeplearning.XorModel:TrainImpl(index)
	self._session:Reset()
	self._input:Update(self._input_list[index])
	self._output:Update(self._output_list[index])
	local right = ALittle.Math_Abs(self._out:AsScalar() - self._output_list[index][1]) < 0.001
	local loss = self._loss:AsScalar()
	self._session:Train()
	return loss, right
end

function ADeeplearning.XorModel:Output(x1, x2)
	self._input:Update({x1, x2})
	self._session:Reset()
	return self._out:AsScalar()
end

assert(ADeeplearning.CommonTrainLayout, " extends class:ADeeplearning.CommonTrainLayout is nil")
ADeeplearning.XorTrainLayout = Lua.Class(ADeeplearning.CommonTrainLayout, "ADeeplearning.XorTrainLayout")

function ADeeplearning.XorTrainLayout.__getter:model()
	if self._model == nil then
		self._model = ADeeplearning.XorModel()
		self._model_path = ADeeplearning.g_ModuleBasePath .. "Other/xor.model"
	end
	return self._model
end

assert(ALittle.DisplayLayout, " extends class:ALittle.DisplayLayout is nil")
ADeeplearning.XorLayout = Lua.Class(ALittle.DisplayLayout, "ADeeplearning.XorLayout")

function ADeeplearning.XorLayout:TCtor()
	self._train:AddEventListener(___all_struct[958494922], self, self.HandleTrainChanged)
end

function ADeeplearning.XorLayout:HandleTrainChanged(event)
	self:Calc()
end

function ADeeplearning.XorLayout:HandleCalcClick(event)
	self:Calc()
end

function ADeeplearning.XorLayout:Calc()
	local model = self._train.model
	self._result_1.text = ALittle.Math_Floor(model:Output(0.0, 0.0) * 100000) / 100000
	self._result_2.text = ALittle.Math_Floor(model:Output(0.0, 1.0) * 100000) / 100000
	self._result_3.text = ALittle.Math_Floor(model:Output(1.0, 0.0) * 100000) / 100000
	self._result_4.text = ALittle.Math_Floor(model:Output(1.0, 1.0) * 100000) / 100000
end

end