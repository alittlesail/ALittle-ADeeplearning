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
ADeeplearning.MnistModel = Lua.Class(ADeeplearning.ARobotModel, "ADeeplearning.MnistModel")

function ADeeplearning.MnistModel:Ctor()
	___rawset(self, "_mnist", carp.CarpRobotMnist())
	___rawset(self, "_surface", carp.CarpRobotSurface())
	___rawset(self, "_input", self._session:CreateInput({28, 28, 1}))
	___rawset(self, "_output", self._session:CreateLabel())
	___rawset(self, "_dropout", self._session:CreateLabel())
	___rawset(self, "_conv1", self._session:CreateConv2D(1, 64, 5, 5))
	___rawset(self, "_conv2", self._session:CreateConv2D(64, 128, 5, 5))
	___rawset(self, "_fc1", self._session:CreateLinear(4 * 4 * 128, 1024))
	___rawset(self, "_fc2", self._session:CreateLinear(1024, 10))
	local input = self._input:Calc()
	local x = self._conv1:Calc(input)
	x = x:MaxPooling2D(2, 2, 2, 2)
	x = x:Rectify()
	x = self._conv2:Calc(x)
	x = x:MaxPooling2D(2, 2, 2, 2)
	x = x:Rectify()
	x = x:Reshape({4 * 4 * 128})
	x = self._fc1:Calc(x)
	x = x:Rectify()
	x = x:Dropout(0.5, self._dropout)
	x = self._fc2:Calc(x)
	___rawset(self, "_out", x:LogSoftmax())
	___rawset(self, "_loss", self._out:PickNegLogSoftmax(self._output))
end

function ADeeplearning.MnistModel:SetMnistRoot(root_path)
	local result = self._mnist:Load(root_path)
	self._total_train_count = self._mnist:GetCount()
	return result
end

function ADeeplearning.MnistModel:TrainImpl(index)
	self._session:Reset()
	self._mnist:GetImage(index - 1, self._input:GetInput())
	local label = self._mnist:GetLabel(index - 1)
	self._dropout:Update(1)
	self._output:Update(label)
	local right = self._out:AsVectorAndArgmax() == label
	local loss = self._loss:AsScalar()
	self._session:Train()
	return loss, right
end

function ADeeplearning.MnistModel:Output(surface_address)
	self._session:Reset()
	self._dropout:Update(0)
	self._surface:SetImage(surface_address, 28, 28)
	self._surface:GetImage(self._input:GetInput())
	return self._out:AsVectorAndArgmax()
end

assert(ADeeplearning.CommonTrainLayout, " extends class:ADeeplearning.CommonTrainLayout is nil")
ADeeplearning.MnistTrainLayout = Lua.Class(ADeeplearning.CommonTrainLayout, "ADeeplearning.MnistTrainLayout")

function ADeeplearning.MnistTrainLayout.__getter:model()
	if self._model == nil then
		self._model = ADeeplearning.MnistModel()
		self._model:SetMnistRoot(ADeeplearning.g_ModuleBasePath .. "Data")
		self._model:Load(ADeeplearning.g_ModuleBasePath .. "Other/mnist.model")
	end
	return self._model
end

assert(ALittle.DisplayLayout, " extends class:ALittle.DisplayLayout is nil")
ADeeplearning.MnistLayout = Lua.Class(ALittle.DisplayLayout, "ADeeplearning.MnistLayout")

function ADeeplearning.MnistLayout:TCtor()
	self._train:AddEventListener(___all_struct[958494922], self, self.HandleTrainChanged)
	self._board:SetPan(5, 0xFFFFFFFF)
	self._board:SetDrawSize(ALittle.Math_Floor(self._board.width), ALittle.Math_Floor(self._board.height), 0xFF000000)
	self._result_text.text = "识别结果"
end

function ADeeplearning.MnistLayout:HandleTrainChanged(event)
end

function ADeeplearning.MnistLayout:HandleDrawChanged(event)
	local model = self._train.model
	local address = carp.GetCarpSurfaceAddress(self._board.surface)
	local result = model:Output(address)
	self._result_text.text = "识别结果:" .. result
end

function ADeeplearning.MnistLayout:HandleClearClick(event)
	self._result_text.text = "识别结果"
	self._board:ClearContent(0xFF000000)
end

end