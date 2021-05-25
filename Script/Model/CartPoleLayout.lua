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

assert(ADeeplearning.CommonTrainLayout, " extends class:ADeeplearning.CommonTrainLayout is nil")
ADeeplearning.CartPoleTrainLayout = Lua.Class(ADeeplearning.CommonTrainLayout, "ADeeplearning.CartPoleTrainLayout")

function ADeeplearning.CartPoleTrainLayout.__getter:model()
	if self._model == nil then
		self._model = deeplearning.DeeplearningDQNModel()
		self._model_path = ADeeplearning.g_ModuleBasePath .. "Other/cartpole.model"
	end
	return self._model
end

ADeeplearning.CartPoleAction = {
	LEFT = 0,
	RIGHT = 1,
}

assert(ALittle.DisplayLayout, " extends class:ALittle.DisplayLayout is nil")
ADeeplearning.CartPoleLayout = Lua.Class(ALittle.DisplayLayout, "ADeeplearning.CartPoleLayout")

function ADeeplearning.CartPoleLayout:Ctor()
	___rawset(self, "_loaded", false)
	___rawset(self, "_gravity", 9.8)
	___rawset(self, "_masscart", 1.0)
	___rawset(self, "_masspole", 0.5)
	___rawset(self, "_total_mass", 0)
	___rawset(self, "_pole_length", 4)
	___rawset(self, "_polemass_length", 0)
	___rawset(self, "_force_mag", 10.0)
	___rawset(self, "_action", 0)
	___rawset(self, "_cart_x", 0)
	___rawset(self, "_cart_x_dot", 0)
	___rawset(self, "_pole_theta", 0)
	___rawset(self, "_pole_theta_dot", 0)
end

function ADeeplearning.CartPoleLayout:TCtor()
	self._train:AddEventListener(___all_struct[958494922], self, self.HandleTrainChanged)
	self._model_path = ADeeplearning.g_ModuleBasePath .. "Other/mnist.model"
	self._model = deeplearning.DeeplearningMnistModel()
	self._total_mass = self._masscart + self._masspole
	self._polemass_length = self._masspole * self._polemass_length
end

function ADeeplearning.CartPoleLayout:HandleTrainChanged(event)
	self._model:Load(self._model_path)
end

function ADeeplearning.CartPoleLayout:HandleStartGameClick(event)
	if not self._loaded then
		self._model:Load(self._model_path)
		self._loaded = true
	end
	self:GameInit(ALittle.Math_RandomDouble(-10, 10))
	if self._loop_frame ~= nil then
		self._loop_frame:Stop()
	end
	self._loop_frame = ALittle.LoopFrame(Lua.Bind(self.HandleFrame, self))
	self._loop_frame:Start()
	self._start_button.disabled = true
end

function ADeeplearning.CartPoleLayout:GameInit(angle)
	self._cart_x = 0
	self._cart_x_dot = 0
	self._pole_theta = 0
	self._pole_theta_dot = 0
	self._action = 0
	self._cart_pole_cart.x = self._cart_pole_container.width / 2 - self._cart_pole_cart.width / 2
	self._cart_pole_pole.x = self._cart_pole_cart.x + self._cart_pole_cart.width / 2 - self._cart_pole_pole.width / 2
	self._cart_pole_pole.angle = angle
end

function ADeeplearning.CartPoleLayout:HandleFrame(frame_time)
	local action = self._action
	if self._self_play.selected then
		if A_UISystem.sym_map[1073741904] ~= nil then
			action = 0
		elseif A_UISystem.sym_map[1073741903] ~= nil then
			action = 1
		end
	else
	end
	local x, degree, done = self:GameRun(action, frame_time)
	if done then
		if self._loop_frame ~= nil then
			self._loop_frame:Stop()
			self._loop_frame = nil
		end
		self._start_button.disabled = false
	end
end

function ADeeplearning.CartPoleLayout:GameRun(action, frame_time)
	self._action = action
	local x = self._cart_x
	local x_dot = self._cart_x_dot
	local theta = self._pole_theta
	local theta_dot = self._pole_theta_dot
	local force = self._force_mag
	if self._action ~= 1 then
		force = -self._force_mag
	end
	local costheta = ALittle.Math_Cos(theta)
	local sintheta = ALittle.Math_Sin(theta)
	local temp = (force + self._polemass_length * theta_dot * theta_dot * sintheta) / self._total_mass
	local thetaacc = (self._gravity * sintheta - costheta * temp) / (self._pole_length * (4.0 / 3.0 - self._masspole * costheta * costheta / self._total_mass))
	local xacc = temp - self._polemass_length * thetaacc * costheta / self._total_mass
	local tau = frame_time / 1000
	x = x + tau * x_dot
	x_dot = x_dot + tau * xacc
	theta = theta + tau * theta_dot
	theta_dot = theta_dot + tau * thetaacc
	local theta_threshold_radians = 90 * 2 * 3.14159265 / 360
	local x_threshold = 3
	local done = x < -x_threshold or x > x_threshold or theta < -theta_threshold_radians or theta > theta_threshold_radians
	self._cart_x = x
	self._cart_x_dot = x_dot
	self._pole_theta = theta
	self._pole_theta_dot = theta_dot
	self:GameRender()
	return self._cart_x, self._pole_theta, done
end

function ADeeplearning.CartPoleLayout:GameRender()
	local real_x = self._cart_x * self._cart_pole_cart.width
	self._cart_pole_cart.x = real_x + self._cart_pole_container.width / 2 - self._cart_pole_cart.width / 2
	self._cart_pole_pole.x = real_x + self._cart_pole_container.width / 2 - self._cart_pole_pole.width / 2
	self._cart_pole_pole.angle = self._pole_theta / 3.14159265 * 180
end

end