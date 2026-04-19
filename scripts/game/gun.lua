require "scripts.util"
local Class = require "scripts.meta.class"
local Bullet = require "scripts.actor.bullet"
local sounds = require "data.sounds"
local images = require "data.images"

local Gun = Class:inherit()

function Gun:init_gun(user)
	self.display_name = Text:text_params("gun."..self.name, { fallback = self.name } )
	self.color = COL_LIGHT_YELLOW

	self.spr = images.gun_machinegun
	self.x, self.y = -100, -100
	self.ox, self.oy = 0, 0
	self.rot = 0
	
	self.is_lootable = true
	self.user = user -- The actor using the gun
	
	self.is_auto = true
	
	-- Bullet
	self.bul_w = 12
	self.bul_h = 12
	
	self.bullet_speed = 600
	self.bullet_number = 1
	self.bullet_spread = 0.2
	self.bullet_friction = 1
	self.bullet_life = 5
	self.random_angle_offset = 0.1
	self.random_speed_offset = 40
	self.random_friction_offset = 0
	self.bullet_target_type = "default"
	self.destroy_bullet_on_damage = true
	
	self.shoot_offset_x = nil

	self.knockback = 500
	
	self.speed_floor = 3 -- min speed before bullet despawn
	
	-- Damage
	self.damage = 2
	self.harmless_time = 0 
	self.boss_damage = 2 -- Boss dealth to bosses by bullet
	
	-- Ammo
	self.max_ammo = 100
	self.ammo = math.huge
	self.is_reloading = false
	self.reload_timer = 0
	self.max_reload_timer = 1
	
	-- Cooldown
	self.cooldown = 0.3
	self.cooldown_timer = 0
	
	-- Burst
	self.is_burst = false
	self.burst_count = 1
	self.burst_delay = 0
	
	self.burst_counter = 0
	self.burst_delay_timer = 0

	self.natural_recharge_progress = 0
	self.original_natural_recharge_ammo = self.max_ammo
	self.natural_recharge_time = 2.0
	self.natural_recharge_delay = 0.5
	self.natural_recharge_delay_timer = 0.0
	
	-- Jetpack
	self.default_jetpack_force = 340
	self.jetpack_force = self.default_jetpack_force

	-- Sounds
	self.play_sfx = true
	self.sfx = "shot1"
	self.sfx_pitch_var = 1.15
	self.sfx_pitch = 1
	
	-- VFX
	self.do_particles = true
	self.screenshake = 0

	-- 3D
	self.bullet_model = nil
	self.object_3d_rot_speed = 0
	self.object_3d_scale = 1
	
	-- Misc
	self.is_explosion = false
	self.show_hud = true
end

function Gun:update(dt)
	if not self.recoil_force then self.recoil_force = self.default_jetpack_force*0.25 end

	self.dt = dt
	self.cooldown_timer = max(self.cooldown_timer - dt, 0)
	self:do_reloading(dt)

	self.ammo = clamp(self.ammo, 0, self:get_max_ammo())

	self:do_natural_recharge(dt)

	-- Burst
	self.burst_delay_timer = max(0, self.burst_delay_timer - dt)

	if self.is_burst and self.burst_counter > 0 and self.burst_delay_timer <= 0 then
		self.burst_delay_timer = self.burst_delay

		-- Force shoot
		if self.user then
			self.user:shoot(dt, true)
		end
	end
end

function Gun:draw(flip_x, flip_y, rot)
	local ox, oy = floor(self.spr:getWidth()/2), floor(self.spr:getHeight()/2)
	flip_x, flip_y = bool_to_dir(flip_x), bool_to_dir(flip_y)

	love.graphics.draw(self.spr, floor(self.x), floor(self.y), self.rot, flip_x, flip_y, ox, oy)
end

function Gun:get_gun_tip_position(x, y, ang)
	local gunw = self.shoot_offset_x or max(0, self.spr:getWidth())
	local new_x = floor(x + cos(ang) * gunw)
	local new_y = floor(y + sin(ang) * gunw)
	return new_x, new_y
end

function Gun:shoot(dt, player, x, y, dx, dy, is_burst)
	dx = dx or 0
	dy = dy or 0
	-- Normalize direction vector
	local d = dist(dx, dy)
	dx = dx/d
	dy = dy/d
	local ang = atan2(dy, dx)
	local is_first_fire = not is_burst

	local visual_x, visual_y = self:get_gun_tip_position(x, y, ang)

	-- Sanity checks
	-- + reloading
	if self.ammo <= 0 then
		return false, "no_ammo"
	end

	-- If first shot but cooldown too big, escape
	if is_first_fire and self.cooldown_timer > 0 then    return false    end
	if is_first_fire and self.reload_timer > 0 then    return false    end

	-- If first fire, reset burst timer & cooldown
	if is_first_fire and self.is_burst then
		self.burst_counter = self.burst_count
	end
	
	-- Now, FIRE!!
	-- SFX & Particles
	if self.play_sfx then
		Audio:play_var(self.sfx, 0.2, 1.2, {pitch=self.sfx_pitch, x=x, y=y})
		if self.sfx2 then
			Audio:play_var(self.sfx2, 0.2, 1.2, {pitch=self.sfx_pitch, x=x, y=y})
		end
	end
	if self.do_particles then
		Particles:image(visual_x, visual_y, 1, images.bullet_casing, 4, nil, nil, nil, {
			vx1 = -dx * 40,
			vx2 = -dx * 100,

			vy1 = -40,
			vy2 = -80,
		})
	end

	if is_first_fire then 
		local m = 1
		if player and player.is_player then
			m = player:get_gun_cooldown_multiplier()
		end
		self.cooldown_timer = self.cooldown * m
	end
	self.ammo = math.max(self.ammo - 1 * (player.ammo_usage_multiplier or 1), 0)
	-- self.ammo = self.ammo - self.bullet_number

	self.natural_recharge_delay_timer = self.natural_recharge_delay
	self.natural_recharge_progress = 0
	self.original_natural_recharge_ammo = self.ammo

	-- Update Burst
	self:update_burst(dt, player, x, y, dx, dy, ang)

	self:on_shoot(player)

	-- Reload if ammo is 0
	if self.ammo <= 0 and not self.is_reloading then
		self:reload()
	end

	return true
end
function Gun:on_shoot(player)
end

function Gun:update_burst(dt, player, x, y, dx, dy, ang)
	if self.is_burst then
		self.burst_counter = self.burst_counter - 1
	end

	local visual_x, visual_y = self:get_gun_tip_position(x, y, ang)
		
	if self.bullet_number == 1 then
		-- If only fire 1 bullet 
		local ang = ang + random_neighbor(self.random_angle_offset)
		dx, dy = cos(ang), sin(ang)
		if self.do_particles then
			Particles:flash(visual_x, visual_y)
		end
		self:fire_bullet(dt, player, x, y, self.bul_w, self.bul_h, dx, dy)
	else
		-- If fire multiple bullets
		local step = (self.bullet_spread*2) / (self.bullet_number-1)
		for i = 0, self.bullet_number-1 do
			-- Compute fire angle
			local rand_o = random_neighbor(self.random_angle_offset)
			local a = ang-self.bullet_spread + i*step + rand_o
			local dx = cos(a)
			local dy = sin(a)
			if self.do_particles then
				Particles:flash(visual_x, visual_y)
			end
			self:fire_bullet(dt, player, x, y, self.bul_w, self.bul_h, dx, dy)
		end
	end
end

function Gun:get_max_ammo()
	local m = (self.user and self.user.get_max_ammo_multiplier and self.user:get_max_ammo_multiplier()) or 1
	return self.max_ammo * m
end

function Gun:do_reloading(dt)
	local reload_delta = dt/self.max_reload_timer
	if self.user.gun_reload_speed_multiplier then
		reload_delta = reload_delta * self.user.gun_reload_speed_multiplier	
	end

	self.reload_timer = max(self.reload_timer - reload_delta, 0)
	if self.reload_timer <= 0 and self.is_reloading then
		self.is_reloading = false
		self.ammo = self:get_max_ammo()
	end
end

function Gun:do_natural_recharge(dt)
	if self.is_reloading then   return   end

	local charge_delta = dt --/ self.user:get_gun_cooldown_multiplier()
	self.natural_recharge_delay_timer = math.max(0.0, self.natural_recharge_delay_timer - charge_delta)
	if self.natural_recharge_delay_timer > 0.0 then   return   end
	
	local mult = 1.0 
	if self.user and self.user.gun_natural_recharge_speed_multiplier then
		mult = self.user.gun_natural_recharge_speed_multiplier
	end
	self.natural_recharge_progress = math.min(1.0, self.natural_recharge_progress + mult*dt/self.natural_recharge_time)
	local natural_recharge_amount = math.floor(self.original_natural_recharge_ammo + self.natural_recharge_progress * self:get_max_ammo())
	self.ammo = math.max(self.ammo, math.min(self:get_max_ammo(), natural_recharge_amount))
end

function Gun:reload()
	self.is_reloading = true
	self.reload_timer = self.max_reload_timer

	self.burst_counter = 0
end

function Gun:fire_bullet(dt, user, x, y, bul_w, bul_h, dx, dy)
	local spd = self.bullet_speed + random_neighbor(self.random_speed_offset)
	local spd_x = dx * spd
	local spd_y = dy * spd 
	local rot_3d_speed = self.object_3d_rot_speed
	if type(rot_3d_speed) == "table" and #rot_3d_speed >= 2 then
		rot_3d_speed = random_range(rot_3d_speed[1], rot_3d_speed[2])
	end

	local ang = atan2(dy, dx)
	local tip_x, tip_y = self:get_gun_tip_position(x, y, ang)

	local bullet = Bullet:new(self, user, self:get_damage(user), x, y, bul_w, bul_h, spd_x, spd_y, {
		life = self.bullet_life,
		range = self.bullet_range,
		do_particles = self.do_particles,
		play_sfx = self.play_sfx,
		target_type = ternary(self.bullet_target_type == "default", nil, self.bullet_target_type),
		override_enemy_damage = self.override_enemy_damage,
		boss_damage = self:get_boss_damage(user),
		is_explosion = self.is_explosion,
		bullet_model = self.bullet_model,
		object_3d_rot_speed = rot_3d_speed,
		object_3d_scale = self.object_3d_scale,
		destroy_on_damage = self.destroy_bullet_on_damage,
		hide_radius = dist(x, y, tip_x, tip_y)
	})
	game:new_actor(bullet)
end

function Gun:get_damage_multiplier(user)
	local value = 1
	if user and user.get_total_gun_damage_multiplier then
		value = value * user:get_total_gun_damage_multiplier()
	end
	return value
end

function Gun:get_damage(user)
	return self.damage * self:get_damage_multiplier()
end

function Gun:get_boss_damage(user)
	return (self.boss_damage or self.damage) * self:get_damage_multiplier()
end

function Gun:add_ammo(quantity)
	local overflow = self:get_max_ammo() - (self.ammo + quantity)
	if overflow >= 0 then
		self.ammo = self.ammo + quantity
		return true
	else
		self.ammo = self:get_max_ammo()
		return false, -overflow
	end
end

return Gun