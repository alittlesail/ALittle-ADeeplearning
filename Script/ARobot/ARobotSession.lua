-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


ADeeplearning.ARobotSession = Lua.Class(nil, "ADeeplearning.ARobotSession")

function ADeeplearning.ARobotSession:Ctor()
	___rawset(self, "_model", carp.CarpRobotParameterCollection())
	___rawset(self, "_graph", carp.CarpRobotComputationGraph())
	___rawset(self, "_trainer", carp.CarpRobotAdamTrainer(self._model, 0.001, 0.9, 0.999, 0.00000001))
end

function ADeeplearning.ARobotSession:Reset(clear)
	if clear then
		self._graph:Clear()
		return
	end
	self._graph:Invalidate()
end

function ADeeplearning.ARobotSession:Train()
	self._graph:Backward()
	self._trainer:Update()
end

function ADeeplearning.ARobotSession:Load(file_path)
	self._model:Load(file_path)
end

function ADeeplearning.ARobotSession:Save(file_path)
	self._model:Save(file_path)
end

function ADeeplearning.ARobotSession:CreateInput(dim_list)
	if dim_list[1] == nil then
		dim_list[1] = 0
	end
	if dim_list[2] == nil then
		dim_list[2] = 0
	end
	if dim_list[3] == nil then
		dim_list[3] = 0
	end
	local input = carp.CarpRobotInput(dim_list[1], dim_list[2], dim_list[3])
	input:Build(self._graph)
	return ADeeplearning.ARobotInput(self._graph, input)
end

function ADeeplearning.ARobotSession:CreateLabel()
	local label = carp.CarpRobotLabel()
	return ADeeplearning.ARobotLabel(self._graph, label)
end

function ADeeplearning.ARobotSession:CreateLinear(input_dim, output_dim)
	local linear = carp.CarpRobotLinear(self._model, input_dim, output_dim)
	linear:Build(self._graph)
	return ADeeplearning.ARobotLinear(self._graph, linear)
end

function ADeeplearning.ARobotSession:CreateConv2D(input_dim, output_dim, kernel_width, kernel_height, stride_width, stride_height, padding_type)
	if stride_width == nil then
		stride_width = 1
	end
	if stride_height == nil then
		stride_height = 1
	end
	if padding_type == nil then
		padding_type = true
	end
	local conv2d = carp.CarpRobotConv2D(self._model, input_dim, output_dim, kernel_width, kernel_height, stride_width, stride_height, padding_type)
	conv2d:Build(self._graph)
	return ADeeplearning.ARobotConv2D(self._graph, conv2d)
end

end