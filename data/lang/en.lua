--[[
    TO TRANSLATORS:
    * Reference document for all enemies, players, levels, etc: (can be outdated)
      https://docs.google.com/document/d/13UntpWqoTXgYnBm5HL0pZmjBDwMStIN8YB1IPdi7hlA
    * To search for added or changed strings, you can use this regex in the search functionality 
      of your text editor: (Ctrl+F then Alt+R on VS Code)
      \[\[((ADDED)|(REMOVED))
    * It is very easy for me to add more glyphs if needed, just tell me and I'll do it.
    * Please notify me if there are any special technical requirements. (e.g. text rendering specifics, etc)
]]

return {
    __meta = {
        -- Do not touch this section.
        menu_padding = 0.18,
        large_mini_font = false,
    },
    language = {
        -- These should be kept untranslated in their original language ("English", "Français", "简体中文", etc)
        en = "English",
        es = "Español",
        fr = "Français",
        zh = "简体中文",
        pl = "Polski",
        pt_BR = "Português Brasileiro",
        ja = "日本語",
    },
    game = {
        demo = "DEMO", -- Chip added to the game logo to indicate that this version is a demo
        fps = "%d FPS",
        congratulations = "CONGRATULATIONS!",
        win_thanks = "Thank you for playing the demo",
        win_wishlist = "Wishlist the game on Steam :)", -- "Wishlist" is a verb
        warning_web_controller = "Some browsers may not have proper controller support",

        combo = "COMBO %d", 
    },
    level = {
        world_prefix = "Department %s",

        -- Department names
        -- I chose to not use articles in english (so instead of "The Factory", it's just "Factory")

        -- Dept 1: This can be any vaguely office-y name (I just chose this in english because of the word play), 
        -- because this department just represents a generic office department.
        world_1 = "Bug Resources", 
        -- Dept 2: This department is a factory themed after bees, with grungy metallic environment
        world_2 = "Factory",
        -- Dept 3: This is a moody, dark and mysterious room filled with endless racks of servers 
        world_3 = "Server Room",
        -- Dept 4: This is the highest department of the bugscraper, filled with lofty gardens and clean, white, modern architecture
        world_4 = "Gardens",

        -- Dept 0: This is an underground secret department below the bugscraper. It contains a huge hangar with a large rocket. 
        world_0 = "Basement",
    },
    gun = {
        -- Gun names
        -- You can be more creative with these, you don't have to stay close to the originals.
        -- Look at google doc for image references
        machinegun = "Pea Gun",
        triple = "Triple Pepper",
        burst = "Pollen Burst",
        shotgun = "Raspberry Shotgun",
        minigun = "Seed Minigun",
        ring = "Big Berry",
        mushroom_cannon = "Mushroom Cannon",

        resignation_letter = "Resignation Letter",
    },
    player = {
        name = {
            -- Player names
            -- If the native name clashes with something specific to the language/culture, please notify me.
            -- You can also use translitations into the language if needed (e.g. Mio -> ミオ)
            mio = "Mio",
            cap = "Cap",
            zia = "Zia",
            tok = "Tok",
            nel = "Nel",
            nob = "Nob",
            amb = "Amb",

            -- These are guest characters from other games so please stay close to the original.
            rico = "Rico", -- From 'The Bullet Hopper'
            yv = "Y.V.", -- From 'Nuclear Throne' / See localized names here: https://docs.google.com/spreadsheets/d/18N1CNxIzSUm4CkIWUw0nbRnlxzAgoRbHpGyX8649Gjw/edit?usp=sharing
            leo = "Leo",
            dodu = "Dodu", 
        },
        abbreviation = "P%d", -- Short appreviation to denote players by their number. Example: in english, "P1" means "Player 1", in french "J1" means "Joueur 1".
    },
    enemy = {
        -- These are the boss names. Please look at the Gdocs for reference.
        -- Feel free to pick interesting names, and you don't have to base them off the english name.

        -- (for example, the french name for "Mr. Dung" is "J. De Bouse", which is a 
        -- play on words with the french word for 'dung' and a famous french humorist. 
        -- "The Webmaster" is a play on words between the theme of the area and spider webs)

        -- A somewhat witty and clownesque exectutive based off a Dung Beetle. 
        boss_1 = "Mr. Dung",

        -- The queen of the Factory, who's also a metal/rock singer.  
        boss_2 = "Her Majesty", 

        -- The guardian of the Server Room, whose design is based off a motherboard and spiders.
        boss_3 = "Webmaster",

        -- A very large green cabbage-like, boulder-like, rolling enemy from the Garden area.   
        -- You're free to be more creative with this one. 
        -- (example: in French, I chose "Grobroco", "gros" (large) + "broco" (diminutive of broccoli))
        boss_4 = "Rollossus",

        -- The CEO of the company, and the final boss. Its name is somewhat ominous-sounding.
        -- Try to avoid ambiguity with the term "boss", which could be confused with the generic term for a video game boss.
        boss_5 = "CEO",
    },
    upgrade = {
        tea = {
            title = "Green Tea",
            description = "+%d extra ❤",
        },
        espresso = {
            title = "Espresso",
            description = "x%d shooting speed for %d floors",
        },
        milk = {
            title = "Milk",
            description = "+%d maximum ❤",
        },
        boba = {
            title = "Boba",
            description = "x%d maximum ammo",
        },
        soda = {
            title = "Soda", -- As in Coca-cola/Pepsi style soda.
            description = "+%d midair jump",
        },
        fizzy_lemonade = {
            title = "Fizzy Lemonade",
            description = "Hold jump to glide",
        },
        apple_juice = {
            title = "Apple Juice",
            description = "Heal +%d ❤",
        },
        hot_sauce = {
            title = "Hot Sauce",
            description = "Deal x%d damage but use x%d ammo", -- First "%d" is the damage, second "%d" is ammo
        },
        coconut_water = {
            title = "Coconut Water",
            description = "Stomping enemies gives back %d%% ammo",
        },
        hot_chocolate = {
            title = "Hot Chocolate",
            description = "Faster reloading speed",
        },
        pomegranate_juice = {
            title = "Pomegranate Juice",
            description = "Create an explosion when taking damage",
        },
        energy_drink = {
            title = "Energy Drink",
            description = "Combo meter decreases more slowly",
        },
    },
    input = {
        prompts = {
            -- All of these are infinitive verbs and may be shown as button prompts 
            -- (i.e., "[X] Shoot", "[C] Jump", etc)

            -- Gameplay Actions
            move = "Move", 
            left = "Left",
            right = "Right",
            up = "Up",
            down = "Down",
            jump = "Jump",
            shoot = "Shoot",
            interact = "Interact",
            leave_game = "Leave",
            open = "Open",         -- As in, "open menu", and NOT for, say, opening chests.
            collect = "Collect",   -- As in, "collect item", "collect gun", etc

            -- UI Actions
            ui_left =  "Left (menu)",
            ui_right = "Right (menu)",
            ui_up = "Up (menu)",
            ui_down = "Down (menu)",
            ui_select = "Confirm",
            ui_back = "Back",
            pause = "Pause",
            join = "Join", -- As, in joining the game, adding a new player to the game.
            -- As in, "Press [key] to split the keyboard". 
            -- Shown on the title screen when one keyboard player has joined. 
            -- Try to keep it as short as possible since space is limited there.
            split_keyboard = "Split keyboard", 

            wall_jump = "Wall jump",
            jetpack = "Jetpack", -- Refers to "jetpacking", a move in the game performed by shooting downwards with a gun.
        },
    },
    menu = {
        see_more = "see more...",
        yes = "YES",
        no = "NO",
        leave_menu = "Leave menu?", -- Generic "leave menu?"
        quit = {
            description = "Are you sure you want to quit?"
        },
        confirm_retry = {
            description = "Retry?",
        },
        pause = {
            title = "PAUSE",
            resume = "RESUME",
            retry = "RETRY",

            -- This correspons to floor 0 in the game. To different cultures, the "ground floor" 
            -- might usually mean "floor 1", so please make sure to avoid ambiguity when translating. 
            -- (You can also translate as "main lobby" or something like it.)   
            return_to_ground_floor = "RETURN TO FLOOR 0", 
            options = "OPTIONS",
            credits = "CREDITS",
            feedback = "FEEDBACK",
            quit = "QUIT",
            website = "OFFICIAL WEBSITE",
            discord = "DISCORD",
            github = "GITHUB",
        },
        options = {
            title = "OPTIONS",

            input = {
                title = "Input",
                input = "INPUT SETTINGS...",
            },
            input_submenu = {
                title = "INPUT SETTINGS",
                reset_controls = "RESET CONTROLS",
                controller_button_style = "BUTTON STYLE", -- The style of the buttons shown in-game. As in, PS4 style buttons, Xbox style buttons...
                controller_button_style_value = {
                    detect = "detect",
                    switch = "Switch",
                    playstation4 = "PlayStation 4",
                    playstation5 = "PlayStation 5",
                    xbox = "Xbox",
                },
                deadzone = "JOYSTICK DEADZONE",
                vibration = "VIBRATION",
                low_deadzone_warning = "Low values may cause issues", -- Warning displayed when the joystick deadzone is very small
                note_deadzone = "Deadzone settings will be applied after leaving this menu",

                gameplay = "Gameplay",
                interface = "Interface",
                global = "Global",
                note_ui_min_button = "At least one binding is required",
                note_global_keyboard = "These bindings are the same for all keyboard players",
                note_global_controller = "These bindings are the same for all controllers",
                -- Shown when navigating to player "%d"'s controller settings while no player of this number has joined yet.
                subtitle_no_player = "[⚠ NO PLAYER %d]", 
                -- Shown in the controller settings while no controller is connected
                subtitle_no_controller = "[⚠ NO CONTROLLER CONNECTED]", 
                no_buttons = "[NO BUTTONS]",
                press_button = "[PRESS BUTTON]", -- Try to keep it as short as possible
                -- When assigning buttons, if the user presses a button that is already bound, it will instead
                -- remove that button.
                press_again_to_remove = "Press an already bound button to remove it", 
                
                keyboard = "Keyboard",
                keyboard_solo = "KEYBOARD (Default)",
                -- "Split" as in, "the 1st split keyboard user"
                keyboard_p1 = "KEYBOARD (Split 1)", 
                keyboard_p2 = "KEYBOARD (Split 2)",

                controller = "Controller",
                controller_p1 = "CONTROLLER (Player 1)",
                controller_p2 = "CONTROLLER (Player 2)",
                controller_p3 = "CONTROLLER (Player 3)",
                controller_p4 = "CONTROLLER (Player 4)",
            },
            audio = {
                title = "Audio",
                sound = "SOUND",
                volume = "VOLUME",
                sfx_volume = "SOUND EFFECT VOLUME", -- Can also be translated as "effects volume" or "SFX volume"
                music_volume = "MUSIC VOLUME",
                music_pause_menu = "MUSIC ON PAUSE MENU", -- Whether music should play on the pause menu
                ambience = "AMBIENCE SOUNDS",
            },
            visuals = {
                title = "Visuals",
                fullscreen = "FULLSCREEN",
                pixel_scale = "PIXEL SCALE", -- How big should every pixel be displayed on-screen (x1, x2, ...)
                pixel_scale_value = {
                    auto = "auto", -- Biggest number possible, whole or not
                    max_whole = "max whole", -- Biggest whole number possible
                },
                vsync = "VSYNC",
                menu_blur = "MENU BACKGROUND BLUR", -- Whether to apply the blurring effect in menu backgrounds
                background_speed = "BACKGROUND SPEED", -- How quickly the background scrolls 
                bullet_lightness = "BULLET BRIGHTNESS", -- How brightly bullets are rendered
            },
            game = {
                title = "Game",
                tutorial = "TUTORIAL...",
                language = "LANGUAGE...",
                timer = "TIMER",
                mouse_visible = "SHOW MOUSE CURSOR",
                pause_on_unfocus = "PAUSE ON LOST FOCUS", -- whether the game should pause when the window loses focus
                screenshake = "SCREENSHAKE",
                skip_boss_intros = "SKIP BOSS INTROS", -- Whether the game should skip the boss intro animations 
                show_fps_warning = "SHOW LOW FRAMERATE WARNING", -- Whether the game should show a warning when its framerate is low

            },
            language = {
                title = "LANGUAGE",
            },
            confirm_language = {
                description = "Restart the game to apply new language?",
            },
        },
        achievements = {
            title = "ACHIEVEMENTS",
        },
        feedback = {
            title = "FEEDBACK",
            bugs = "REPORT A BUG",
            features = "SUGGEST A FEATURE",
        },
        game_over = {
            title = "GAME OVER!",
            kills = "Enemies killed", -- The amount of enemies the player has killed
            deaths = "Deaths",
            time = "Time",            -- The time that the player took to complete the level
            floor = "Floor",          -- Which storey the player was on when they died
            score = "Score",
            max_combo = "Max combo",

            continue = "CONTINUE",
            quick_restart = "QUICK RESTART",
        },
        stats = {
            title = "STATS",

            time_total = "Time played (total)",
            time_ingame = "Time played (in game)",
            runs = "Runs",
            best_run = "Best wave reached", -- The biggest wave number reached on any run
        },
        new_reward = {
            new_skin = "New character!",
            new_upgrade = "New upgrade!",
        },
        win = {
            title = "CONGRATULATIONS!",
            wishlist = "WISHLIST ON STEAM", -- "wishlist" is a verb
            continue = "CONTINUE",
        },
        joystick_removed = {
            title = "CONTROLLER DISCONNECTED",
            description = "Please plug in the following controllers:",
            continue = "CONTINUE ANYWAY",
            item = "Player %d (%s)", -- e.g. "Player 2 (Xbox Controller)"
        },
        credits = {
            title = "CREDITS",
            ninesliced_presents = "Ninesliced presents",
            game_by = "A game by", 
            leo_bernard = "Léo Bernard", -- Please do not touch this
            music = "Music",
            sound_design = "Sound design",
            localization = "Localization",
            additional_art = "Additional art",
            playtesting = "Playtesting",
            special_thanks = "Special thanks",
            trailer = "Trailer",
            asset_creators = "Asset creators",
            tv_slideshow = "TV slideshow contributors", -- Refers to the powerpoint TV slideshow on the title screen, which was contributed by a variety of people 
            licenses = "Asset & library licenses",
            more = "And many more...",                        -- For the people that I might have forgotten in the special thanks section
            thank_you_for_playing = "Thank you for playing!", -- Shown at the end of the credits

            x_by_y = "%s by %s",                              -- "ASSET_NAME by CREATOR". Used to credit assets such as sound effects
            asset_item = "%s by %s / %s",                     -- "ASSET_NAME by CREATOR / LICENCE"
        },
        open_source = {
            title = "Open source libraries",
        },
    },
    achievements = {
        ach_complete_w1 = {
            name = "Bug Resources",
            description = "Complete department 1",
        },
        ach_complete_w2 = {
            name = "Factory",
            description = "Complete department 2",
        },
        ach_complete_w3 = {
            name = "Server Room",
            description = "Complete department 3",
        },
        ach_complete_w4 = {
            name = "Gardens",
            description = "Complete department 4",
        },
        ach_complete_end = {
            name = "Vacations",
            description = "Complete the game",
        },
        ach_death = {
            name = "Perseverance",
            description = "Die 50 times",
        },
        ach_all_upgrades = {
            name = "A Furious Cocktail",
            description = "Unlock all upgrades",
        },
        ach_all_skins = {
            name = "Team Leader",
            description = "Unlock all characters",
        },
        ach_max_hearts = {
            name = "Lover",
            description = "Obtain 7 ❤",
        },
        ach_no_damage_easy = {
            name = "Iron Bug",
            description = "Do not take damage for 20 floors",
        },
        ach_no_damage_full = {
            name = "Golden Bug",
            description = "Do not take damage for a full game",
        },
        ach_no_floor = {
            name = "The Floor Is Lava",
            description = "Do not touch the ground for 10 floors",
        },
        ach_big_combo = {
            name = "Furious",
            description = "Get a 100 combo",
        },
        ach_smash_easter_egg = {
            name = "GAME!", -- This is a reference to what the announcer says at the end of a match in Smash Bros.
            description = "Obtain the secret exit animation", 
        },
    },
    discord = { -- Text used for Discord rich presence
        state = {
            solo = "Playing solo",
            local_multiplayer = "Local multiplayer",
        },
        details = {
            waiting = "In lobby",
            playing = "In game (floor %d/%d)",
            dying = "Defeated (floor %d/%d)",
            win = "Victory screen",
        },
    },
}
