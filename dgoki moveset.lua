-- name: \\#833ab4\\DGoki \\#c02c69\\Moveset \\#fcb045\\v1.0
-- incompatible: moveset
-- description: This is a moveset created by me (\\#833ab4\\D\\#c02c69\\G\\#fd1d1d\\o\\#fd6731\\k\\#fcb045\\i\\#FFFFFF\\)\nIt tries to be advanced while also not removing things like BLJs.\nI was going to keep this private, however many people asked me to release it.\n\nHere a list what the moveset does:\n\\#FFFF00\\\n+ Ground pound jump. (A HOLD OR PRESS)\n+ Slide kick on dive. (A PRESS)\n+ Allows to go up on slopes easier.\n+ Allows you to dive on a ground pound to cancel it. (B PRESS)\n+ Allows you to slide kick on a long jump. (A PRESS WHILE NOT HOLDING Z)\n+ Allows you to dive on a long jump. (B PRESS)\n+ Adds a quadruple jump that causes you to twirl. (A PRESS)\n+ Increases movement speed by like 35% (not accurate since sm64 physics are weird.)\n+ Other small changes.
local dg_moveset = true

-- Used for the death / reset command
local dg_reset_char = false

-- gPlayerSyncTable bullshit | i don't like using this in general because desync exists. :(
for player = 0, MAX_PLAYERS - 1 do gPlayerSyncTable[player].dg_moveset_toggled = true end

local function DG_Die() -- The reset / death command
    dg_reset_char = true
    return true
end

local function death_check(m)
    -- This is the most stupid crash fix that i ever used.
    -- but it works for rare crashes related to deaths.
    -- so i keep this in the code.
    
    -- Deaths.
    if m.action == ACT_DEATH_ON_BACK then return true end
    if m.action == ACT_DEATH_ON_STOMACH then return true end
    if m.action == ACT_WATER_DEATH then return true end
    if m.action == ACT_STANDING_DEATH then return true end
    if m.action == ACT_QUICKSAND_DEATH then return true end
    -- Death exits.
    if m.action == ACT_DEATH_EXIT then return true end
    if m.action == ACT_FALLING_DEATH_EXIT then return true end
    if m.action == ACT_DEATH_EXIT_LAND then return true end
    if m.action == ACT_SPECIAL_DEATH_EXIT then return true end
    -- Bubble because yes.
    if m.action == ACT_BUBBLED then return true end
    return false
end
local function knockback_check(m)
    -- Used for the speed increase.
    -- Since not having this would send you to the moon if pvp is active.
    -- Also cannons and other things like being thrown is also checked here. 
    
    -- Ground KB
    if m.action == ACT_SOFT_BACKWARD_GROUND_KB then return true end
    if m.action == ACT_SOFT_FORWARD_GROUND_KB then return true end
    if m.action == ACT_HARD_FORWARD_GROUND_KB then return true end
    if m.action == ACT_HARD_BACKWARD_GROUND_KB then return true end
    if m.action == ACT_FORWARD_GROUND_KB then return true end
    if m.action == ACT_BACKWARD_GROUND_KB then return true end
    -- Cannon
    if m.action == ACT_SHOT_FROM_CANNON then return true end
    if m.action == ACT_IN_CANNON then return true end
    -- Air KB
    if m.action == ACT_HARD_FORWARD_AIR_KB then return true end
    if m.action == ACT_HARD_BACKWARD_AIR_KB then return true end
    if m.action == ACT_FORWARD_AIR_KB then return true end
    if m.action == ACT_BACKWARD_AIR_KB then return true end
    -- Water KB
    if m.action == ACT_FORWARD_WATER_KB then return true end
    if m.action == ACT_BACKWARD_WATER_KB then return true end
    -- Throws
    if m.action == ACT_THROWN_BACKWARD then return true end
    if m.action == ACT_THROWN_FORWARD then return true end
    return false
end

local A_PRESS = false
local B_PRESS = false
local Z_TRIG_PRESS = false
---@param m MarioState
local function dg_moveset_mario_update(m)
    gPlayerSyncTable[m.playerIndex].dg_moveset_toggled = dg_moveset

    -- this fixes some rare crashes related to the death animation.
    if death_check(m) or gPlayerSyncTable[m.playerIndex].dg_moveset_toggled == false then return end
    ---------------------------------------------------------------------------------------
    -- This is the reset / death command
    -- Used for if the moveset get's somehow desynced or you get OOB trapped in a location.
    ---------------------------------------------------------------------------------------
    if dg_reset_char == true then
        m.health = 0
        m.healCounter = 0
        m.numLives = m.numLives + 1
        dg_reset_char = false
    end
    ---------------------------------------------------------------------------------------
    -- Getting binds because is important.
    ---------------------------------------------------------------------------------------
    A_PRESS = ((m.controller.buttonPressed & A_BUTTON) ~= 0)
    B_PRESS = ((m.controller.buttonPressed & B_BUTTON) ~= 0)
    Z_TRIG_PRESS = ((m.controller.buttonPressed & Z_TRIG) ~= 0)
    
    ---------------------------------------------------------------------------------------
    -- This code is horrible to read and edit, i know, i know what i did here.
    -- but also i am kinda too lazy to fix it right now, so uh, enjoy this mess. :P
    ---------------------------------------------------------------------------------------
    if (m.controller.buttonDown & A_BUTTON) ~= 0 and m.action == ACT_GROUND_POUND_LAND then
	    set_mario_action(m, ACT_LAVA_BOOST, 0)
            m.vel.y = 125
    elseif B_PRESS and (m.action == ACT_TOP_OF_POLE_JUMP or m.action == ACT_LAVA_BOOST) then
	   set_mario_action(m, ACT_DIVE, 0)
    elseif Z_TRIG_PRESS and (m.action == ACT_TOP_OF_POLE_JUMP or m.action == ACT_LAVA_BOOST) then
	   set_mario_action(m, ACT_GROUND_POUND, 0)
    elseif B_PRESS and m.action == ACT_LONG_JUMP then
	   set_mario_action(m, ACT_DIVE, 0)
    elseif A_PRESS and (m.controller.buttonDown & Z_TRIG) == 0 and m.action == ACT_LONG_JUMP then
	    set_mario_action(m, ACT_SLIDE_KICK, 0)
    elseif B_PRESS and m.action == ACT_DIVE_PICKING_UP then
	    set_mario_action(m, ACT_DIVE, 0)
    elseif B_PRESS and m.action == ACT_GROUND_POUND then
	    set_mario_action(m, ACT_DIVE, 0)
            m.vel.y = 50
    elseif A_PRESS and (m.action == ACT_DIVE or m.action == ACT_DIVE_SLIDE) then
	    set_mario_action(m, ACT_SLIDE_KICK, 0)
    elseif B_PRESS and (m.action == ACT_SLIDE_KICK_SLIDE) then
	    set_mario_action(m, ACT_DIVE, 0)
    elseif A_PRESS and m.action == ACT_TRIPLE_JUMP_LAND then
            m.vel.y = 100
	    set_mario_action(m,ACT_TWIRLING, 0)
    elseif B_PRESS and (m.action == ACT_TRIPLE_JUMP or m.action == ACT_SPECIAL_TRIPLE_JUMP) then
            set_mario_action(m,ACT_DIVE, 0)
    elseif Z_TRIG_PRESS and (m.action == ACT_TRIPLE_JUMP or m.action == ACT_SPECIAL_TRIPLE_JUMP) then
            set_mario_action(m,ACT_DIVE, 0)
    elseif B_PRESS and m.action == ACT_TWIRLING then
            set_mario_action(m,ACT_DIVE, 0)
    elseif Z_TRIG_PRESS and m.action == ACT_TWIRLING then
            set_mario_action(m,ACT_GROUND_POUND, 0)
    elseif A_PRESS and m.action == ACT_STOMACH_SLIDE then
            set_mario_action(m,ACT_JUMP, 0)
    elseif (m.action == ACT_STEEP_JUMP) then
            set_mario_action(m,ACT_JUMP, 0)
    elseif (m.action == ACT_WATER_JUMP) then
            m.vel.y = 35
            set_mario_action(m,ACT_TRIPLE_JUMP, 0)
    elseif Z_TRIG_PRESS and m.action == ACT_BACKFLIP then
            set_mario_action(m,ACT_GROUND_POUND, 0)
    elseif B_PRESS and m.action == ACT_BACKFLIP then
            set_mario_action(m,ACT_DIVE, 0)
    end
end

---@param m MarioState
local function dg_moveset_before_phys_step(m)
    if (gPlayerSyncTable[m.playerIndex].dg_moveset_toggled == false) then return end
    if death_check(m) or knockback_check(m) then return end
    -- Increases movement speed since it was too slow for my taste.
    m.vel.x = m.vel.x * 1.35
    m.vel.z = m.vel.z * 1.35
end

hook_event(HOOK_BEFORE_PHYS_STEP, dg_moveset_before_phys_step)
hook_event(HOOK_MARIO_UPDATE, dg_moveset_mario_update)

hook_chat_command("reset", "- kills your local player to reset it.", DG_Die)

local function moveset_toggle()
    if dg_moveset == true then dg_moveset = false else dg_moveset = true end
end

hook_mod_menu_checkbox("Enable Moveset", true, moveset_toggle)
