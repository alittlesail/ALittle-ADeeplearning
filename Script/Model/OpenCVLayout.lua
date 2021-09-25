-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___pairs = pairs
local ___ipairs = ipairs


assert(ALittle.DisplayLayout, " extends class:ALittle.DisplayLayout is nil")
ADeeplearning.OpenCVLayout = Lua.Class(ALittle.DisplayLayout, "ADeeplearning.OpenCVLayout")

function ADeeplearning.OpenCVLayout:TCtor()
	self._image = ALittle.DynamicImage(ADeeplearning.g_Control)
	self._image.width = self._container.width
	self._image.height = self._container.height
	local out_width = ALittle.Math_Floor(self._container.width)
	local out_height = ALittle.Math_Floor(self._container.height)
	self._image:SetSurfaceSize(out_width, out_height, 0)
	self._container:AddChild(self._image)
end

function ADeeplearning.OpenCVLayout:HandleStartClick(event)
	if self._cap ~= nil then
		return
	end
	local out_width = ALittle.Math_Floor(self._image.width)
	local out_height = ALittle.Math_Floor(self._image.height)
	self._cap = carp.CreateCarpVideoCapture()
	if not carp.OpenCarpVideoCamera(self._cap, 0, out_width, out_height, 0) then
		g_AUITool:ShowNotice("错误", "摄像头打开失败")
		carp.FreeCarpVideoCapture(self._cap)
		self._cap = nil
		return
	end
	if self._loop_frame == nil then
		self._loop_frame = ALittle.LoopFrame(Lua.Bind(self.HandleFrame, self))
		self._loop_frame:Start()
	end
	local width = carp.GetCarpVideoCameraWidth(self._cap)
	local height = carp.GetCarpVideoCameraHeight(self._cap)
	if out_width ~= width or out_height ~= height then
		self._grab = carp.CreateCarpSurface(width, height)
	end
end

function ADeeplearning.OpenCVLayout:HandleCloseClick(event)
	if self._grab ~= nil then
		carp.FreeCarpSurface(self._grab)
	end
	self._grab = nil
	if self._loop_frame ~= nil then
		self._loop_frame:Stop()
		self._loop_frame = nil
	end
	if self._cap == nil then
		return
	end
	carp.CloseCarpVideoCamera(self._cap)
	carp.FreeCarpVideoCapture(self._cap)
	self._cap = nil
end

function ADeeplearning.OpenCVLayout:HandleFrame(frame_time)
	if self._model == nil then
		self._model = deeplearning.DeeplearningDarknet()
		local path = ALittle.File_GetCurrentPath() .. "/" .. ADeeplearning.g_ModuleBasePath .. "Other/"
		self._model:Load(path .. "yolov3-tiny.cfg", path .. "yolov3-tiny.weights")
	end
	if self._grab ~= nil then
		local result = carp.GetCarpVideoCameraFrame(self._cap, carp.GetCarpSurfaceAddress(self._grab))
		carp.CutBlitCarpSurface(self._grab, self._image:GetSurface(false), nil, nil)
	else
		carp.GetCarpVideoCameraFrame(self._cap, carp.GetCarpSurfaceAddress(self._image:GetSurface(false)))
	end
	local surface = self._image:GetSurface(true)
	local surface_width = carp.GetCarpSurfaceWidth(surface)
	local surface_height = carp.GetCarpSurfaceHeight(surface)
	local address = carp.GetCarpSurfaceAddress(surface)
	local box_list = self._model:Predict(address)
	if box_list == nil then
		return
	end
	self._quad_container:RemoveAllChild()
	local max_width = self._container.width
	local max_height = self._container.height
	local adjust_width = surface_width
	local adjust_height = surface_height
	if surface_width > max_width or surface_height > max_height then
		local scale_x = max_width / surface_width
		local scale_y = max_height / surface_height
		local max_scale = scale_x
		if max_scale > scale_y then
			max_scale = scale_y
		end
		adjust_width = ALittle.Math_Floor(max_scale * surface_width)
		if adjust_width == 0 then
			adjust_width = 1
		end
		adjust_height = ALittle.Math_Floor(max_scale * surface_height)
		if adjust_height == 0 then
			adjust_height = 1
		end
	end
	local adjust_scale = adjust_width / surface_width
	local adjust_x = (max_width - adjust_width) / 2
	local adjust_y = (max_height - adjust_height) / 2
	for index, range in ___ipairs(box_list) do
		if range.clazz >= 0 then
			local quad = ADeeplearning.g_AUIPluinControl:CreateControl("aui_frame_quad")
			quad.x = range.x * adjust_scale + adjust_x
			quad.y = range.y * adjust_scale + adjust_y
			quad.width = range.w * adjust_scale
			quad.height = range.h * adjust_scale
			self._quad_container:AddChild(quad)
		end
	end
end

end