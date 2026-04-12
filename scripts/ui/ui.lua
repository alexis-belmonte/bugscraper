require "scripts.util"
local Class = require "scripts.meta.class"
local images= require "data.images"

local UI = Class:inherit()

function UI:init(x,y)
end

function UI:draw_half_icon_bar(x, y, val, max_val, img_full, img_half, img_empty, margin)
	-- Draw a bar in this style:
	-- ⚫︎ ⚫︎ ⚫︎ ◐ 〇 〇 〇
	margin = margin or 0
	local iy = floor(y)
	local img_w = img_full:getWidth() + margin
	local full_w = floor(max_val/2 - 1) * img_w + margin
	local x1 = x - full_w *.5

	for i=0, max_val-1, 2 do
		local img = img_empty
		if i < val then     img = img_full    end
		if i+1 == val then    img = img_half     end 

		local ix = floor(x1 + img_w*(i/2))
		love.graphics.draw(img, ix, iy)
		love.graphics.flrprint(i, ix, iy+8)
	end
end

function UI:draw_icon_bar(x, y, val, max_val, val_extra, img_full, img_empty, img_extra, margin)
	-- Draw a bar in this style:
	-- ♥️ ♥️ ♥️ ♥️ ♡ ♡ ♡ 
	margin = margin or 0
	val_extra = val_extra or 0
	-- img_full = img_full or images.empty
	-- img_empty = img_empty or images.empty
	img_extra = img_extra or images.empty

	local total = math.max(val + val_extra, max_val)

	local iy = floor(y)
	local img_w = img_full:getWidth() + margin
	local full_w = total * img_w + margin
	local x1 = x - full_w/2
	for i=0, total-1 do
		local img = img_empty
		if i < val then
			img = img_full 
		elseif i < val + val_extra then
			img = img_extra
		end 

		local ix = floor(x1 + img_w*i)
		local oy = math.max(0, img:getHeight() - img_empty:getHeight())
		love.graphics.draw(img, ix, iy - oy)
	end
end


function UI:draw_icon_bar_stacked(x, y, chunks, max_val, img_empty, margin)
	-- Draw a bar in this style:
	-- ♥️ ♥️ ♥️ ♥️ ♡ ♡ ♡ 
	margin = margin or 0

	local sum = 0
	local width = 0
	for i=1, #chunks do
		sum = sum + math.max(0, chunks[i].value)
		width = width + math.max(0, chunks[i].value) * (chunks[i].img:getWidth() + margin)
	end
	
	local real_max = math.max(sum, max_val)
	local overflow = math.max(0.0, real_max - sum)
	width = width + overflow * (img_empty:getWidth() + margin)
	
	local iy = floor(y)
	local x1 = x - width/2
	
	local ix = x1
	for i_chunk = 1, #chunks + 1 do
		local current_chunk = chunks[i_chunk] or {
			value = math.max(0.0, max_val - sum),
			img = img_empty
		}

		for i=1, current_chunk.value do
			local img = current_chunk.img

			local oy = math.max(0, img:getHeight() - img_empty:getHeight())
			love.graphics.draw(img, math.floor(ix), math.floor(iy - oy))

			ix = ix + img:getWidth() + margin
		end
	end
end

function UI:draw_progress_bar(x, y, w, h, val, max_val, col_fill, col_out, col_fill_shadow, text, text_col, font)
	x = floor(x)
	y = floor(y)
	w = floor(w)
	h = floor(h)
	rect_color(col_out, "fill", x, y, w, h)

	val = math.min(val, max_val)

	local prog_w = floor( (w-2) * (val/max_val) )
	rect_color(col_fill,        "fill", x+1, y+1,   prog_w, h-2)
	rect_color(col_fill_shadow, "fill", x+1, y+h-2, prog_w, 1)

	text = text or ""
	text_col = text_col or COL_WHITE 
	font = font or FONT_MINI
	local old_font = love.graphics.getFont()
	love.graphics.setFont(font)
	print_color(COL_WHITE, text, x+1, y-2)
	love.graphics.setFont(old_font)
end

function UI:draw_sawtooth_border(height_top, height_bottom, scroll, params)
	params = params or {}
	local loop_threshold = param(params.loop_threshold, 14)
	local color = param(params.color, COL_BLACK_BLUE)
	local image_height = param(params.image_height, 8)
	local image_top = param(params.image_top, images.sawtooth_separator)
	local image_bottom = param(params.image_bottom, images.sawtooth_separator)
	
	scroll = scroll % loop_threshold
	local x = round(-loop_threshold + scroll)

	exec_color(color, function()
		love.graphics.draw(image_top, x, round(height_top), 0, 1, -1)
	end)
	rect_color(color, "fill", 0, 0, CANVAS_WIDTH, round(height_top) - image_height)
	
	local bot_y = CANVAS_HEIGHT - height_bottom
	exec_color(color, function()
		love.graphics.draw(image_bottom, x, bot_y)
	end)
	rect_color(color, "fill", 0, bot_y + image_height, CANVAS_WIDTH, CANVAS_HEIGHT - bot_y)
end

return UI:new()