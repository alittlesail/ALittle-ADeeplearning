-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___rawset = rawset
local ___pairs = pairs
local ___ipairs = ipairs


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
	___rawset(self, "_pole_length", 5)
	___rawset(self, "_polemass_length", 0)
	___rawset(self, "_force_mag", 10.0)
	___rawset(self, "_action", 0)
	___rawset(self, "_cart_x", 0)
	___rawset(self, "_cart_x_dot", 0)
	___rawset(self, "_pole_theta", 0)
	___rawset(self, "_pole_theta_dot", 0)
	___rawset(self, "_theta_threshold_radians", 1.570796325)
	___rawset(self, "_learn_theta_threshold_radians", 1.570796325)
	___rawset(self, "_x_threshold", 5)
end

function ADeeplearning.CartPoleLayout:TCtor()
	self._model_path = ADeeplearning.g_ModuleBasePath .. "Other/cartpole.model"
	self._model = deeplearning.DeeplearningDQNModel(4, 2, 100, 2000)
	self._learn_theta_threshold_radians = 12 * 2 * 3.14159265 / 360
	self._total_mass = self._masscart + self._masspole
	self._polemass_length = self._masspole * self._polemass_length
	self:GameInit(0)
end

function ADeeplearning.CartPoleLayout:HandleStartGameClick(event)
	if not self._loaded then
		self._model:Load(self._model_path)
		self._loaded = true
	end
	self:GameInit(0)
	if self._loop_frame ~= nil then
		self._loop_frame:Stop()
	end
	self._loop_frame = ALittle.LoopFrame(Lua.Bind(self.HandleFrame, self))
	self._loop_frame:Start()
	self._start_button.disabled = true
end

function ADeeplearning.CartPoleLayout:HandleStopGameClick(event)
	if self._loaded then
		self._model:Save(self._model_path)
	end
	self:GameInit(0)
	if self._loop_frame ~= nil then
		self._loop_frame:Stop()
		self._loop_frame = nil
	end
	self._start_button.disabled = false
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
	local state = {}
	state[1] = self._cart_x
	state[2] = self._cart_x_dot
	state[3] = self._pole_theta
	state[4] = self._pole_theta_dot
	local action = self._action
	if self._self_play.selected then
		if A_UISystem.sym_map[1073741904] ~= nil then
			action = 0
		elseif A_UISystem.sym_map[1073741903] ~= nil then
			action = 1
		end
	else
		action = self._model:ChooseAction(state, 9)
	end
	local done = self:GameRun(action, frame_time)
	local next_state = {}
	next_state[1] = self._cart_x
	next_state[2] = self._cart_x_dot
	next_state[3] = self._pole_theta
	next_state[4] = self._pole_theta_dot
	local r1 = (self._x_threshold - ALittle.Math_Abs(self._cart_x)) / self._x_threshold - 0.8
	local r2 = (self._learn_theta_threshold_radians - ALittle.Math_Abs(self._pole_theta)) / self._learn_theta_threshold_radians - 0.5
	local reward = r1 + r2
	self._model:SaveTransition(state, action, reward, next_state)
	local i = 1
	while true do
		if not(i <= 32) then break end
		self._model:Learn()
		i = i+(1)
	end
	if done then
		if self._loop_frame ~= nil then
			self._loop_frame:Stop()
			self._loop_frame = nil
		end
		self:GameInit(0)
		if self._loop_frame ~= nil then
			self._loop_frame:Stop()
		end
		self._loop_frame = ALittle.LoopFrame(Lua.Bind(self.HandleFrame, self))
		self._loop_frame:Start()
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
	local done = x < -self._x_threshold or x > self._x_threshold or theta < -self._theta_threshold_radians or theta > self._theta_threshold_radians
	self._cart_x = x
	self._cart_x_dot = x_dot
	self._pole_theta = theta
	self._pole_theta_dot = theta_dot
	self:GameRender()
	return done
end

function ADeeplearning.CartPoleLayout:GameRender()
	local real_x = self._cart_x * self._cart_pole_cart.width
	self._cart_pole_cart.x = real_x + self._cart_pole_container.width / 2 - self._cart_pole_cart.width / 2
	self._cart_pole_pole.x = real_x + self._cart_pole_container.width / 2 - self._cart_pole_pole.width / 2
	self._cart_pole_pole.angle = self._pole_theta / 3.14159265 * 180
end

end