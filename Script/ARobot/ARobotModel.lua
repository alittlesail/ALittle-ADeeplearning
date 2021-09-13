-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


ADeeplearning.ARobotModel = Lua.Class(nil, "ADeeplearning.ARobotModel")

function ADeeplearning.ARobotModel:Ctor()
	___rawset(self, "_total_train_count", 0)
	___rawset(self, "_cur_train_count", 0)
	___rawset(self, "_cur_right_count", 0)
	___rawset(self, "_train_round", 0)
	___rawset(self, "_session", ADeeplearning.ARobotSession())
end

function ADeeplearning.ARobotModel:Load(file_path)
	self._session:Load(file_path)
end

function ADeeplearning.ARobotModel:Save(file_path)
	self._session:Save(file_path)
end

function ADeeplearning.ARobotModel:GetTotalTrainCount()
	return self._total_train_count
end

function ADeeplearning.ARobotModel:GetCurTrainCount()
	return self._cur_train_count
end

function ADeeplearning.ARobotModel:GetTrainRound()
	return self._train_round
end

function ADeeplearning.ARobotModel:GetCurRightCount()
	return self._cur_right_count
end

function ADeeplearning.ARobotModel:TrainCountPerFrame()
	return 1
end

function ADeeplearning.ARobotModel:Train()
	if self._cur_train_count >= self._total_train_count then
		self._cur_train_count = 0
		self._cur_right_count = 0
		self._train_round = self._train_round + (1)
	end
	local loss, right = self:TrainImpl(self._cur_train_count + 1)
	self._cur_train_count = self._cur_train_count + (1)
	if right then
		self._cur_right_count = self._cur_right_count + (1)
	end
	return loss, right
end

function ADeeplearning.ARobotModel:TrainImpl(index)
	return 0, false
end

end