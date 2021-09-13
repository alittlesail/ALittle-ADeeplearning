-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


ADeeplearning.ARobotExpression = Lua.Class(nil, "ADeeplearning.ARobotExpression")

function ADeeplearning.ARobotExpression:Ctor(graph, index)
	___rawset(self, "_graph", graph)
	___rawset(self, "_index", index)
end

function ADeeplearning.ARobotExpression:AsScalar()
	return self._graph:AsScalar(self._index)
end

function ADeeplearning.ARobotExpression:Negate()
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Negate(self._index))
end

function ADeeplearning.ARobotExpression:Addition(value)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Addition(self._index, value._index))
end

function ADeeplearning.ARobotExpression:Plus(value)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Plus(self._index, value))
end

function ADeeplearning.ARobotExpression:Subtraction(value)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Subtraction(self._index, value._index))
end

function ADeeplearning.ARobotExpression:Minus(value)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Minus(self._index, value))
end

function ADeeplearning.ARobotExpression:Multiplication(value)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Multiplication(self._index, value._index))
end

function ADeeplearning.ARobotExpression:Multiply(value)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Multiply(self._index, value))
end

function ADeeplearning.ARobotExpression:Division(value)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Division(self._index, value._index))
end

function ADeeplearning.ARobotExpression:Divide(value)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Divide(self._index, value))
end

function ADeeplearning.ARobotExpression:Square()
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Square(self._index))
end

function ADeeplearning.ARobotExpression:PickNegLogSoftmax(v)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:PickNegLogSoftmax(self._index, v))
end

function ADeeplearning.ARobotExpression:BinaryLogLoss()
	return ADeeplearning.ARobotExpression(self._graph, self._graph:BinaryLogLoss(self._index))
end

function ADeeplearning.ARobotExpression:Sigmoid()
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Sigmoid(self._index))
end

function ADeeplearning.ARobotExpression:Rectify()
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Rectify(self._index))
end

function ADeeplearning.ARobotExpression:Softmax()
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Softmax(self._index))
end

function ADeeplearning.ARobotExpression:LogSoftmax()
	return ADeeplearning.ARobotExpression(self._graph, self._graph:LogSoftmax(self._index))
end

function ADeeplearning.ARobotExpression:Dropout(rate)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Dropout(self._index, rate))
end

function ADeeplearning.ARobotExpression:Conv2D(kernel, stride_width, stride_height, padding_type)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Conv2D(self._index, kernel._index, stride_width, stride_height, padding_type))
end

function ADeeplearning.ARobotExpression:MaxPooling2D(kernel_width, kernel_height, stride_width, stride_height, padding_type)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:MaxPooling2D(self._index, kernel_width, kernel_height, stride_width, stride_height, padding_type))
end

function ADeeplearning.ARobotExpression:Reshape(dim_list)
	if dim_list[1] == nil then
		dim_list[1] = 0
	end
	if dim_list[2] == nil then
		dim_list[2] = 0
	end
	if dim_list[3] == nil then
		dim_list[3] = 0
	end
	return ADeeplearning.ARobotExpression(self._graph, self._graph:Reshape(self._index, dim_list[1], dim_list[2], dim_list[3]))
end

function ADeeplearning.ARobotExpression:PickElement(value, dim)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:PickElement(self._index, value, dim))
end

function ADeeplearning.ARobotExpression:MeanElements(dim)
	return ADeeplearning.ARobotExpression(self._graph, self._graph:MeanElements(self._index, dim))
end

ADeeplearning.ARobotInputExpression = Lua.Class(nil, "ADeeplearning.ARobotInputExpression")

function ADeeplearning.ARobotInputExpression:Ctor(graph, input)
	___rawset(self, "_graph", graph)
	___rawset(self, "_input", input)
end

function ADeeplearning.ARobotInputExpression:Update(data, offset)
	if offset == nil then
		offset = 0
	end
	self._input:Update(offset, data)
end

function ADeeplearning.ARobotInputExpression:Calc()
	return ADeeplearning.ARobotExpression(self._graph, self._input:Calc(self._graph))
end

ADeeplearning.ARobotLinearExpression = Lua.Class(nil, "ADeeplearning.ARobotLinearExpression")

function ADeeplearning.ARobotLinearExpression:Ctor(graph, linear)
	___rawset(self, "_graph", graph)
	___rawset(self, "_linear", linear)
end

function ADeeplearning.ARobotLinearExpression:Calc(input)
	return ADeeplearning.ARobotExpression(self._graph, self._linear:Calc(self._graph, input._index))
end

ADeeplearning.ARobotSession = Lua.Class(nil, "ADeeplearning.ARobotSession")

function ADeeplearning.ARobotSession:Ctor()
	___rawset(self, "_model", carp.CarpRobotParameterCollection())
	___rawset(self, "_graph", carp.CarpRobotComputationGraph())
	___rawset(self, "_trainer", carp.CarpRobotAdamTrainer(self._model, 0.001, 0.9, 0.999, 0.00000001))
end

function ADeeplearning.ARobotSession:Init(clear)
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
	return ADeeplearning.ARobotInputExpression(self._graph, input)
end

function ADeeplearning.ARobotSession:CreateLinear(input_dim, output_dim)
	local linear = carp.CarpRobotLinear(self._model, input_dim, output_dim)
	linear:Build(self._graph)
	return ADeeplearning.ARobotLinearExpression(self._graph, linear)
end

end