-- ALittle Generate Lua And Do Not Edit This Line!
do
if _G.ADeeplearning == nil then _G.ADeeplearning = {} end
local ADeeplearning = ADeeplearning
local Lua = Lua
local ALittle = ALittle
local ___pairs = pairs
local ___ipairs = ipairs


assert(ALittle.DisplayLayout, " extends class:ALittle.DisplayLayout is nil")
ADeeplearning.DarknetLayout = Lua.Class(ALittle.DisplayLayout, "ADeeplearning.DarknetLayout")

function ADeeplearning.DarknetLayout:HandleDropFile(event)
	self:Do(event.path)
end

function ADeeplearning.DarknetLayout:HandleSelectFileClick(event)
	self:Do(event.path)
end

function ADeeplearning.DarknetLayout:Do(file_path)
	if self._model == nil then
		self._model = deeplearning.DeeplearningDarknet()
		local path = ALittle.File_GetCurrentPath() .. "/" .. ADeeplearning.g_ModuleBasePath .. "Other/"
		self._model:Load(path .. "yolov3-tiny.cfg", path .. "yolov3-tiny.weights")
	end
	local surface = carp.LoadCarpSurface(file_path)
	if surface == nil then
		g_AUITool:ShowNotice("错误", "图片加载失败")
		return
	end
	local surface_width = carp.GetCarpSurfaceWidth(surface)
	local surface_height = carp.GetCarpSurfaceHeight(surface)
	local address = carp.GetCarpSurfaceAddress(surface)
	local box_list = self._model:Predict(address)
	if box_list == nil then
		g_AUITool:ShowNotice("错误", "图片识别失败")
		return
	end
	self._container:RemoveAllChild()
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
	local image = ALittle.Image(ADeeplearning.g_Control)
	image:SetTextureCut(file_path, ALittle.Math_Floor(max_width), ALittle.Math_Floor(max_height), false)
	image.width = adjust_width
	image.height = adjust_height
	image.x = adjust_x
	image.y = adjust_y
	self._container:AddChild(image)
	for index, range in ___ipairs(box_list) do
		if range.clazz >= 0 then
			local quad = ADeeplearning.g_AUIPluinControl:CreateControl("aui_frame_quad")
			quad.x = range.x * adjust_scale + adjust_x
			quad.y = range.y * adjust_scale + adjust_y
			quad.width = range.w * adjust_scale
			quad.height = range.h * adjust_scale
			self._container:AddChild(quad)
		end
	end
end

end