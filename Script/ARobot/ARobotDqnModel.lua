-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


ADeeplearning.IARobotDqn = Lua.Class(nil, "ADeeplearning.IARobotDqn")

function ADeeplearning.IARobotDqn:Copy(dnn)
end

function ADeeplearning.IARobotDqn:Calc(input)
	return nil
end

ADeeplearning.ARobotDqnTypes = {
	NORMAL = 1,
	DUELING = 2,
	DOUBLE = 3,
}

ADeeplearning.ARobotDqnModel = Lua.Class(nil, "ADeeplearning.ARobotDqnModel")

function ADeeplearning.ARobotDqnModel:Ctor()
	___rawset(self, "_learn_step_counter", 0)
end

function ADeeplearning.ARobotDqnModel:InitGraph(action_count, memory_capacity)
	self._sum_tree = carp.CarpRobotSumTree(memory_capacity)
	self._reward = self._session:CreateInput({1})
	self._target = self._session:CreateInput({1})
	self._action = self._session:CreateLabel()
	local reward = self._reward:Calc()
	local state = self._state:Calc()
	local target = self._target:Calc()
	local next_state = self._next_state:Calc()
	self._out = self._eval_net:Calc(state)
	self._q_eval = self._out:PickElement(self._action, 0)
	self._target_q_next = self._target_net:Calc(next_state)
	if self._model_type == 3 then
		self._q_next = self._eval_net:Calc(next_state)
	end
	self._loss = self._q_eval:Subtraction(target):Square()
end

function ADeeplearning.ARobotDqnModel:Load(file_path)
	self._session:Load(file_path)
end

function ADeeplearning.ARobotDqnModel:Save(file_path)
	self._session:Save(file_path)
end

function ADeeplearning.ARobotDqnModel:Train(count)
	local index_list = self._sum_tree:SelectMemory(count)
	local index_count = ALittle.List_Len(index_list)
	if index_count == 0 then
		return 0
	end
	local total_loss = 0
	for _, index in ___ipairs(index_list) do
		self._session:Reset()
		if self._learn_step_counter % 100 == 0 then
			self._target_net:Copy(self._eval_net)
		end
		self._learn_step_counter = self._learn_step_counter + (1)
		local reward = self._sum_tree:GetReward(index, self._reward:GetInput())
		self._sum_tree:GetState(index, self._state:GetInput())
		self._sum_tree:GetNextState(index, self._next_state:GetInput())
		local action = self._sum_tree:GetAction(index, self._action:GetLabel())
		if self._model_type == 3 then
			local next_action = self._target_q_next:AsVectorAndArgmax()
			local q_target = reward + 0.9 * self._q_next:AsVectorAndGetValue(next_action)
			self._target:Update({q_target})
		else
			local q_target = reward + 0.9 * self._target_q_next:AsVectorAndMaxValue()
			self._target:Update({q_target})
		end
		local loss = self._loss:AsScalar()
		self._session:Train()
		total_loss = total_loss + (loss)
	end
	return total_loss / index_count
end

function ADeeplearning.ARobotDqnModel:SaveTransition(state, next_state, action, reward)
	self._session:Reset()
	self._reward:Update({reward})
	self._state:Update(state)
	self._next_state:Update(next_state)
	self._action:Update(action)
	if self._model_type == 3 then
		local next_action = self._target_q_next:AsVectorAndArgmax()
		local q_target = reward + 0.9 * self._q_next:AsVectorAndGetValue(next_action)
		self._target:Update({q_target})
	else
		local q_target = reward + 0.9 * self._target_q_next:AsVectorAndMaxValue()
		self._target:Update({q_target})
	end
	local loss = self._loss:AsScalar()
	return self._sum_tree:SaveMemory(state, next_state, action, reward, loss)
end

function ADeeplearning.ARobotDqnModel:ChooseAction(state)
	self._session:Reset()
	self._state:Update(state)
	return self._out:AsVectorAndArgmax()
end

assert(ADeeplearning.IARobotDqn, " extends class:ADeeplearning.IARobotDqn is nil")
ADeeplearning.ARobotDuelingDqnDnn = Lua.Class(ADeeplearning.IARobotDqn, "ADeeplearning.ARobotDuelingDqnDnn")

function ADeeplearning.ARobotDuelingDqnDnn:Ctor(session, state_count, action_count, hide_dim)
	___rawset(self, "_linear", session:CreateLinear(state_count, hide_dim))
	___rawset(self, "_value", session:CreateLinear(hide_dim, 1))
	___rawset(self, "_advantage", session:CreateLinear(hide_dim, action_count))
end

function ADeeplearning.ARobotDuelingDqnDnn:Copy(dnn)
	local value = ALittle.Cast(ADeeplearning.ARobotDuelingDqnDnn, ADeeplearning.IARobotDqn, dnn)
	self._linear:Copy(value._linear)
	self._value:Copy(value._value)
	self._advantage:Copy(value._advantage)
end

function ADeeplearning.ARobotDuelingDqnDnn:Calc(input)
	local x = self._linear:Calc(input):Rectify()
	local value = self._value:Calc(x)
	local advantage = self._advantage:Calc(x)
	return advantage:Subtraction(advantage:MeanElements(0)):Addition(value)
end

assert(ADeeplearning.IARobotDqn, " extends class:ADeeplearning.IARobotDqn is nil")
ADeeplearning.ARobotDqnDnn = Lua.Class(ADeeplearning.IARobotDqn, "ADeeplearning.ARobotDqnDnn")

function ADeeplearning.ARobotDqnDnn:Ctor(session, state_count, action_count, hide_dim)
	___rawset(self, "_fc1", session:CreateLinear(state_count, hide_dim))
	___rawset(self, "_fc2", session:CreateLinear(hide_dim, action_count))
end

function ADeeplearning.ARobotDqnDnn:Copy(dnn)
	local value = ALittle.Cast(ADeeplearning.ARobotDqnDnn, ADeeplearning.IARobotDqn, dnn)
	self._fc1:Copy(value._fc1)
	self._fc2:Copy(value._fc2)
end

function ADeeplearning.ARobotDqnDnn:Calc(input)
	local x = self._fc1:Calc(input):Rectify()
	return self._fc2:Calc(x)
end

assert(ADeeplearning.ARobotDqnModel, " extends class:ADeeplearning.ARobotDqnModel is nil")
ADeeplearning.ARobotDqnDnnModel = Lua.Class(ADeeplearning.ARobotDqnModel, "ADeeplearning.ARobotDqnDnnModel")

function ADeeplearning.ARobotDqnDnnModel:Ctor(state_count, action_count, hide_dim, memory_capacity, type)
	___rawset(self, "_model_type", type)
	___rawset(self, "_session", ADeeplearning.ARobotSession())
	___rawset(self, "_state", self._session:CreateInput({state_count}))
	___rawset(self, "_next_state", self._session:CreateInput({state_count}))
	if type == 2 then
		___rawset(self, "_eval_net", ADeeplearning.ARobotDuelingDqnDnn(self._session, state_count, action_count, hide_dim))
		___rawset(self, "_target_net", ADeeplearning.ARobotDuelingDqnDnn(self._session, state_count, action_count, hide_dim))
	else
		___rawset(self, "_eval_net", ADeeplearning.ARobotDqnDnn(self._session, state_count, action_count, hide_dim))
		___rawset(self, "_target_net", ADeeplearning.ARobotDqnDnn(self._session, state_count, action_count, hide_dim))
	end
	self:InitGraph(action_count, memory_capacity)
end

assert(ADeeplearning.IARobotDqn, " extends class:ADeeplearning.IARobotDqn is nil")
ADeeplearning.ARobotDuelingDqnCnn = Lua.Class(ADeeplearning.IARobotDqn, "ADeeplearning.ARobotDuelingDqnCnn")

function ADeeplearning.ARobotDuelingDqnCnn:Ctor(session, input_width, input_height, action_count, conv2d_dim_list, linear_dim)
	___rawset(self, "_reshapre", 0)
	___rawset(self, "_conv2d_list", {})
	local last_input_dim = 1
	for index, dim in ___ipairs(conv2d_dim_list) do
		local conv2d = session:CreateConv2D(last_input_dim, dim, 3, 3, 1, 1, false)
		self._conv2d_list[index] = conv2d
		last_input_dim = dim
	end
	___rawset(self, "_reshapre", last_input_dim * input_width * input_height)
	___rawset(self, "_linear", session:CreateLinear(self._reshapre, linear_dim))
	___rawset(self, "_value", session:CreateLinear(linear_dim, 1))
	___rawset(self, "_advantage", session:CreateLinear(linear_dim, action_count))
end

function ADeeplearning.ARobotDuelingDqnCnn:Copy(cnn)
	local value = ALittle.Cast(ADeeplearning.ARobotDuelingDqnCnn, ADeeplearning.IARobotDqn, cnn)
	for index, conv2d in ___ipairs(self._conv2d_list) do
		self._conv2d_list[index]:Copy(value._conv2d_list[index])
	end
	self._linear:Copy(value._linear)
	self._value:Copy(value._value)
	self._advantage:Copy(value._advantage)
end

function ADeeplearning.ARobotDuelingDqnCnn:Calc(input)
	local x = input
	for index, conv2d in ___ipairs(self._conv2d_list) do
		x = conv2d:Calc(x):Rectify()
	end
	x = x:Reshape({self._reshapre})
	x = self._linear:Calc(x):Rectify()
	local value = self._value:Calc(x)
	local advantage = self._advantage:Calc(x)
	return advantage:Subtraction(advantage:MeanElements(0)):Addition(value)
end

assert(ADeeplearning.IARobotDqn, " extends class:ADeeplearning.IARobotDqn is nil")
ADeeplearning.ARobotDqnCnn = Lua.Class(ADeeplearning.IARobotDqn, "ADeeplearning.ARobotDqnCnn")

function ADeeplearning.ARobotDqnCnn:Ctor(session, input_width, input_height, action_count, conv2d_dim_list, linear_dim)
	___rawset(self, "_reshapre", 0)
	___rawset(self, "_conv2d_list", {})
	local last_input_dim = 1
	for index, dim in ___ipairs(conv2d_dim_list) do
		local conv2d = session:CreateConv2D(last_input_dim, dim, 3, 3, 1, 1, false)
		self._conv2d_list[index] = conv2d
		last_input_dim = dim
	end
	___rawset(self, "_reshapre", last_input_dim * input_width * input_height)
	___rawset(self, "_fc_1", session:CreateLinear(self._reshapre, linear_dim))
	___rawset(self, "_fc_2", session:CreateLinear(linear_dim, action_count))
end

function ADeeplearning.ARobotDqnCnn:Copy(cnn)
	local value = ALittle.Cast(ADeeplearning.ARobotDqnCnn, ADeeplearning.IARobotDqn, cnn)
	for index, conv2d in ___ipairs(self._conv2d_list) do
		self._conv2d_list[index]:Copy(value._conv2d_list[index])
	end
	self._fc_1:Copy(value._fc_1)
	self._fc_2:Copy(value._fc_2)
end

function ADeeplearning.ARobotDqnCnn:Calc(input)
	local x = input
	for index, conv2d in ___ipairs(self._conv2d_list) do
		x = conv2d:Calc(x):Rectify()
	end
	x = x:Reshape({self._reshapre})
	x = self._fc_1:Calc(x):Rectify()
	return self._fc_2:Calc(x)
end

assert(ADeeplearning.ARobotDqnModel, " extends class:ADeeplearning.ARobotDqnModel is nil")
ADeeplearning.ARobotDqnCnnModel = Lua.Class(ADeeplearning.ARobotDqnModel, "ADeeplearning.ARobotDqnCnnModel")

function ADeeplearning.ARobotDqnCnnModel:Ctor(input_width, input_height, action_count, conv2d_dim_list, linear_dim, memory_capacity, type)
	___rawset(self, "_model_type", type)
	___rawset(self, "_session", ADeeplearning.ARobotSession())
	___rawset(self, "_state", self._session:CreateInput({input_width, input_height, 1}))
	___rawset(self, "_next_state", self._session:CreateInput({input_width, input_height, 1}))
	if type == 2 then
		___rawset(self, "_eval_net", ADeeplearning.ARobotDuelingDqnCnn(self._session, input_width, input_height, action_count, conv2d_dim_list, linear_dim))
		___rawset(self, "_target_net", ADeeplearning.ARobotDuelingDqnCnn(self._session, input_width, input_height, action_count, conv2d_dim_list, linear_dim))
	else
		___rawset(self, "_eval_net", ADeeplearning.ARobotDqnCnn(self._session, input_width, input_height, action_count, conv2d_dim_list, linear_dim))
		___rawset(self, "_target_net", ADeeplearning.ARobotDqnCnn(self._session, input_width, input_height, action_count, conv2d_dim_list, linear_dim))
	end
	self:InitGraph(action_count, memory_capacity)
end

end