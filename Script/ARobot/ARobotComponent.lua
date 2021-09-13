-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


ADeeplearning.ARobotInput = Lua.Class(nil, "ADeeplearning.ARobotInput")

function ADeeplearning.ARobotInput:Ctor(graph, input)
	___rawset(self, "_graph", graph)
	___rawset(self, "_input", input)
end

function ADeeplearning.ARobotInput:GetInput()
	return self._input
end

function ADeeplearning.ARobotInput:Update(data, offset)
	if offset == nil then
		offset = 0
	end
	self._input:Update(offset, data)
end

function ADeeplearning.ARobotInput:Calc()
	return ADeeplearning.ARobotExpression(self._graph, self._input:Calc(self._graph))
end

ADeeplearning.ARobotLinear = Lua.Class(nil, "ADeeplearning.ARobotLinear")

function ADeeplearning.ARobotLinear:Ctor(graph, linear)
	___rawset(self, "_graph", graph)
	___rawset(self, "_linear", linear)
end

function ADeeplearning.ARobotLinear:Calc(input)
	return ADeeplearning.ARobotExpression(self._graph, self._linear:Calc(self._graph, input._index))
end

ADeeplearning.ARobotConv2D = Lua.Class(nil, "ADeeplearning.ARobotConv2D")

function ADeeplearning.ARobotConv2D:Ctor(graph, conv2d)
	___rawset(self, "_graph", graph)
	___rawset(self, "_conv2d", conv2d)
end

function ADeeplearning.ARobotConv2D:Calc(input)
	return ADeeplearning.ARobotExpression(self._graph, self._conv2d:Calc(self._graph, input._index))
end

end