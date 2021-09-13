-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


ADeeplearning.ARobotDuelingDqnDnn = Lua.Class(nil, "ADeeplearning.ARobotDuelingDqnDnn")

function ADeeplearning.ARobotDuelingDqnDnn:Ctor(session, state_count, action_count, hide_dim)
	___rawset(self, "_linear", session:CreateLinear(state_count, hide_dim))
	___rawset(self, "_value", session:CreateLinear(hide_dim, 1))
	___rawset(self, "_advantage", session:CreateLinear(hide_dim, action_count))
end

function ADeeplearning.ARobotDuelingDqnDnn:Copy(value)
	self._linear:Copy(value._linear)
	self._value:Copy(value._value)
	self._advantage:Copy(value._advantage)
end

function ADeeplearning.ARobotDuelingDqnDnn:Calc(input)
	local x = self._linear:Calc(input)
	x = x:Rectify()
	local value = self._value:Calc(x)
	local advantage = self._advantage:Calc(x)
	return advantage:Subtraction(advantage:MeanElements(0)):Addition(value)
end

ADeeplearning.ARobotDuelingDqnDnnModel = Lua.Class(nil, "ADeeplearning.ARobotDuelingDqnDnnModel")

function ADeeplearning.ARobotDuelingDqnDnnModel:Ctor(state_count, action_count, hide_dim, memory_capacity)
	___rawset(self, "_state_count", 0)
	___rawset(self, "_action_count", 0)
	___rawset(self, "_learn_step_counter", 0)
	___rawset(self, "_session", ADeeplearning.ARobotSession())
	___rawset(self, "_state_count", state_count)
	___rawset(self, "_action_count", action_count)
	___rawset(self, "_sum_tree", carp.CarpRobotSumTree(memory_capacity))
	___rawset(self, "_state", self._session:CreateInput({self._state_count}))
	___rawset(self, "_next_state", self._session:CreateInput({self._state_count}))
	___rawset(self, "_reward", self._session:CreateInput({1}))
	___rawset(self, "_target", self._session:CreateInput({1}))
	___rawset(self, "_action", self._session:CreateLabel())
	___rawset(self, "_eval_net", ADeeplearning.ARobotDuelingDqnDnn(self._session, state_count, action_count, hide_dim))
	___rawset(self, "_target_net", ADeeplearning.ARobotDuelingDqnDnn(self._session, state_count, action_count, hide_dim))
	local reward = self._reward:Calc()
	local state = self._state:Calc()
	local target = self._target:Calc()
	local next_state = self._next_state:Calc()
	___rawset(self, "_out", self._eval_net:Calc(state))
	___rawset(self, "_q_eval", self._out:PickElement(self._action, 0))
	___rawset(self, "_q_next", self._target_net:Calc(next_state))
	___rawset(self, "_loss", self._q_eval:Subtraction(target):Square())
end

function ADeeplearning.ARobotDuelingDqnDnnModel:Load(file_path)
	self._session:Load(file_path)
end

function ADeeplearning.ARobotDuelingDqnDnnModel:Save(file_path)
	self._session:Save(file_path)
end

function ADeeplearning.ARobotDuelingDqnDnnModel:Train(count)
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
		local q_target = reward + 0.9 * self._q_next:AsVectorAndMaxValue()
		self._target:Update({q_target})
		local loss = self._loss:AsScalar()
		self._session:Train()
		total_loss = total_loss + (loss)
	end
	return total_loss / index_count
end

function ADeeplearning.ARobotDuelingDqnDnnModel:SaveTransition(state, next_state, action, reward)
	self._session:Reset()
	self._reward:Update({reward})
	self._state:Update(state)
	self._next_state:Update(next_state)
	self._action:Update(action)
	local q_target = reward + 0.9 * self._q_next:AsVectorAndMaxValue()
	self._target:Update({q_target})
	local loss = self._loss:AsScalar()
	self._sum_tree:SaveMemory(state, next_state, action, reward, loss)
end

function ADeeplearning.ARobotDuelingDqnDnnModel:ChooseAction(state)
	self._session:Reset()
	self._state:Update(state)
	return self._out:AsVectorAndArgmax()
end

end