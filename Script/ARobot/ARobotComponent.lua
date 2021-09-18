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

ADeeplearning.ARobotLabel = Lua.Class(nil, "ADeeplearning.ARobotLabel")

function ADeeplearning.ARobotLabel:Ctor(graph, label)
	___rawset(self, "_graph", graph)
	___rawset(self, "_label", label)
end

function ADeeplearning.ARobotLabel:GetLabel()
	return self._label
end

function ADeeplearning.ARobotLabel:Update(label)
	self._label:Update(label)
end

ADeeplearning.ARobotLinear = Lua.Class(nil, "ADeeplearning.ARobotLinear")

function ADeeplearning.ARobotLinear:Ctor(graph, linear)
	___rawset(self, "_graph", graph)
	___rawset(self, "_linear", linear)
end

function ADeeplearning.ARobotLinear:Copy(linear)
	self._linear:Copy(linear._linear)
end

function ADeeplearning.ARobotLinear:Calc(input)
	return ADeeplearning.ARobotExpression(self._graph, self._linear:Calc(self._graph, input._index))
end

ADeeplearning.ARobotConv2D = Lua.Class(nil, "ADeeplearning.ARobotConv2D")

function ADeeplearning.ARobotConv2D:Ctor(graph, conv2d)
	___rawset(self, "_graph", graph)
	___rawset(self, "_conv2d", conv2d)
end

function ADeeplearning.ARobotConv2D:Copy(conv2d)
	self._conv2d:Copy(conv2d._conv2d)
end

function ADeeplearning.ARobotConv2D:Calc(input)
	return ADeeplearning.ARobotExpression(self._graph, self._conv2d:Calc(self._graph, input._index))
end

ADeeplearning.ARobotLstm = Lua.Class(nil, "ADeeplearning.ARobotLstm")

function ADeeplearning.ARobotLstm:Ctor(graph, lstm)
	___rawset(self, "_graph", graph)
	___rawset(self, "_lstm", lstm)
end

function ADeeplearning.ARobotLstm:Build(update)
	self._lstm:Build(self._graph, update)
end

function ADeeplearning.ARobotLstm:SetDropoutRate(value)
	self._lstm:SetDropoutRate(value)
end

function ADeeplearning.ARobotLstm:SetDropoutRateH(value)
	self._lstm:SetDropoutRateH(value)
end

function ADeeplearning.ARobotLstm:AddInput(input)
	return ADeeplearning.ARobotExpression(self._graph, self._lstm:AddInput(self._graph, input._index))
end

ADeeplearning.ARobotBiLstm = Lua.Class(nil, "ADeeplearning.ARobotBiLstm")

function ADeeplearning.ARobotBiLstm:Ctor(graph, l2r_lstm, r2l_lstm)
	___rawset(self, "_graph", graph)
	___rawset(self, "_l2r_lstm", l2r_lstm)
	___rawset(self, "_r2l_lstm", r2l_lstm)
end

function ADeeplearning.ARobotBiLstm:Build(update)
	self._l2r_lstm:Build(self._graph, update)
	self._r2l_lstm:Build(self._graph, update)
end

function ADeeplearning.ARobotBiLstm:SetDropoutRate(value)
	self._l2r_lstm:SetDropoutRate(value)
	self._r2l_lstm:SetDropoutRate(value)
end

function ADeeplearning.ARobotBiLstm:SetDropoutRateH(value)
	self._l2r_lstm:SetDropoutRateH(value)
	self._r2l_lstm:SetDropoutRateH(value)
end

function ADeeplearning.ARobotBiLstm:FullLstm(input_list)
	local input_len = ALittle.List_Len(input_list)
	local l2r_output = {}
	local r2l_output = {}
	local out_list = {}
	local i = 1
	while true do
		if not(i <= input_len) then break end
		l2r_output[i] = ADeeplearning.ARobotExpression(self._graph, self._l2r_lstm:AddInput(self._graph, input_list[i]._index))
		r2l_output[input_len - i + 1] = ADeeplearning.ARobotExpression(self._graph, self._r2l_lstm:AddInput(self._graph, input_list[input_len - i + 1]._index))
		i = i+(1)
	end
	local i = 1
	while true do
		if not(i <= input_len) then break end
		ALittle.List_Push(out_list, l2r_output[i]:Concatenate({r2l_output[i]}))
		i = i+(1)
	end
	return out_list
end

function ADeeplearning.ARobotBiLstm:EmbeddingLstm(input_list)
	local input_len = ALittle.List_Len(input_list)
	local l2r
	local r2l
	local i = 1
	while true do
		if not(i <= input_len) then break end
		l2r = ADeeplearning.ARobotExpression(self._graph, self._l2r_lstm:AddInput(self._graph, input_list[i]._index))
		r2l = ADeeplearning.ARobotExpression(self._graph, self._r2l_lstm:AddInput(self._graph, input_list[input_len - i + 1]._index))
		i = i+(1)
	end
	return l2r:Concatenate({r2l})
end

end