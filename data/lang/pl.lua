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
        congratulations = "GRATULACJE!",
        win_thanks = "Dziękujemy za zagranie w werje demo",
        win_wishlist = "Dodaj grę do listy życzeń na Steam :)", -- "Wishlist" is a verb
        warning_web_controller = "Niektóre przeglądarki mogą nie obsługiwać kontrolerów",

        combo = "COMBO %d", 
    },
    level = {
        world_prefix = "Dział %s",

        -- Department names
        -- I chose to not use articles in english (so instead of "The Factory", it's just "Factory")

        -- Dept 1: This can be any vaguely office-y name (I just chose this in english because of the word play), 
        -- because this department just represents a generic office department.
        world_1 = "Korporobale", 
        -- Dept 2: This department is a factory themed after bees, with grungy metallic environment
        world_2 = "Pasieka Metalu",
        -- Dept 3: This is a moody, dark and mysterious room filled with endless racks of servers 
        world_3 = "Serwerowy Piekielnik",
        -- Dept 4: This is the highest department of the bugscraper, filled with lofty gardens and clean, white, modern architecture
        world_4 = "Ogrody",

        -- Dept 0: This is an underground secret department below the bugscraper. It contains a huge hangar with a large rocket. 
        world_0 = "Piwnica",
    },
    gun = {
        -- Gun names
        -- You can be more creative with these, you don't have to stay close to the originals.
        -- Look at google doc for image references
        machinegun = "Grosznik",        -- hard to translate to english, kinda a mix beween pea and gun
        triple = "Paprypak",            -- it's a mix of two words pepper and pack the idea is that peppers are commonly sold in packs so it's a pack of peppers
        burst = "Seriopyłek",           -- mix between pollen and burst
        shotgun = "Malinada",           -- mix of raspberry and lemonade
        minigun = "Pestkotron",         -- not even sure how to translate it to english :D it's a word made up that mixes the 'seed' (pestka) into the name
        ring = "Jagodynator",           -- hard to translate it's a made up word that mixes berry(jagody) and word nator which I'm not even sure how to translate back to what it would mean in english
        mushroom_cannon = "Grzybomor",  -- hard to translate it back to english, in polish it's just a person who is very much into collecting mushrooms :P
        resignation_letter = "Wypowiedzenie", -- direct translation
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
            yv = "M.W.", -- From 'Nuclear Throne' / See localized names here: https://docs.google.com/spreadsheets/d/18N1CNxIzSUm4CkIWUw0nbRnlxzAgoRbHpGyX8649Gjw/edit?usp=sharing
            leo = "Leo",
            dodu = "Dodu", 
        },
        abbreviation = "G%d", -- Short appreviation to denote players by their number. Example: in english, "P1" means "Player 1", in french "J1" means "Joueur 1".
    },
    enemy = {
        -- These are the boss names. Please look at the Gdocs for reference.
        -- Feel free to pick interesting names, and you don't have to base them off the english name.

        -- (for example, the french name for "Mr. Dung" is "J. De Bouse", which is a 
        -- play on words with the french word for 'dung' and a famous french humorist. 
        -- "The Webmaster" is a play on words between the theme of the area and spider webs)

        -- A somewhat witty and clownesque exectutive based off a Dung Beetle. 
        boss_1 = "Pan Odchodek",

        -- The queen of the Factory, who's also a metal/rock singer.  
        boss_2 = "Jej Metaliczność", 

        -- The guardian of the Server Room, whose design is based off a motherboard and spiders.
        boss_3 = "Rdzenny Pająk",

        -- A very large green cabbage-like, boulder-like, rolling enemy from the Garden area.   
        -- You're free to be more creative with this one. 
        -- (example: in French, I chose "Grobroco", "gros" (large) + "broco" (diminutive of broccoli))
        boss_4 = "Zgniłogłaz",

        -- The CEO of the company, and the final boss. Its name is somewhat ominous-sounding.
        -- Try to avoid ambiguity with the term "boss", which could be confused with the generic term for a video game boss.
        boss_5 = "Szef",
    },
    upgrade = {
        tea = {
            title = "Herbata",
            description = "+%d ekstra ❤",
        },
        espresso = {
            title = "Espresso",
            description = "x%d prędkość strzelania przez %d poziomów",
        },
        milk = {
            title = "Mleko",
            description = "+%d do limitu ❤",
        },
        boba = {
            title = "Boba",
            description = "x%d limit amunicji",
        },
        soda = {
            title = "Cola", -- As in Coca-cola/Pepsi style soda.
            description = "+%d skoków w powietrzu",
        },
        fizzy_lemonade = {
            title = "Gazowana Lemoniada",
            description = "Przytrzymaj skok aby szybować",
        },
        apple_juice = {
            title = "Sok Jabłkowy",
            description = "Ulecz +%d ❤",
        },
        hot_sauce = {
            title = "Ostry Sos",
            description = "Zadaj x%d obrażeń używając x%d amunicji", -- First "%d" is the damage, second "%d" is ammo
        },
        coconut_water = {
            title = "Woda Kokosowa",
            description = "Deptanie wrogów przywraca %d%% amunicji",
        },
        hot_chocolate = {
            title = "Gorąca Czekolada",
            description = "Szybsze przeładowanie broni",
        },
        pomegranate_juice = {
            title = "Sok z Granatu",
            description = "Stwórz eksplozję gdy otrzymasz obrażenia",
        },
        energy_drink = {
            title = "Energetyk",
            description = "Dłuższy czas combo",
        },
    },
    input = {
        prompts = {
            -- All of these are infinitive verbs and may be shown as button prompts 
            -- (i.e., "[X] Shoot", "[C] Jump", etc)

            -- Gameplay Actions
            move = "Poruszanie", 
            left = "Lewo",
            right = "Prawo",
            up = "Góra",
            down = "Dół",
            jump = "Skok",
            shoot = "Strzał",
            interact = "Interakcja",
            leave_game = "Wyjdź",
            open = "Otwórz",         -- As in, "open menu", and NOT for, say, opening chests.
            collect = "Podnieś",   -- As in, "collect item", "collect gun", etc

            -- UI Actions
            ui_left = "Lewo (Menu)",
            ui_right = "Prawo (Menu)",
            ui_up = "Góra (Menu)",
            ui_down = "Dół (Menu)",
            ui_select = "Zatwierdź",
            ui_back = "Wstecz",
            pause = "Pauza",
            join = "Dołącz", -- As, in joining the game, adding a new player to the game.
            -- As in, "Press [key] to split the keyboard". 
            -- Shown on the title screen when one keyboard player has joined. 
            -- Try to keep it as short as possible since space is limited there.
            split_keyboard = "Podziel klawiature", 

            wall_jump = "Skok od ściany",
            jetpack = "Plecak Odrzutowy", -- Refers to "jetpacking", a move in the game performed by shooting downwards with a gun.
        },
    },
    menu = {
        see_more = "zobacz wiecej...",
        yes = "TAK",
        no = "NIE",
        leave_menu = "Opuścić menu?", -- Generic "leave menu?"
        quit = {
            description = "Czy aby napewno chcesz wyjść?"
        },
        confirm_retry = {
            description = "Spróbuj ponownie?",
        },
        pause = {
            title = "PAUZA",
            resume = "WZNÓW",
            retry = "SPRÓBUJ PONOWNIE",

            -- This correspons to floor 0 in the game. To different cultures, the "ground floor" 
            -- might usually mean "floor 1", so please make sure to avoid ambiguity when translating. 
            -- (You can also translate as "main lobby" or something like it.)   
            return_to_ground_floor = "WRÓĆ DO LOBBY", 
            options = "OPCJE",
            credits = "TWÓRCY",
            feedback = "ZOSTAW OPINIE",
            quit = "WYJDŹ",
            website = "OFICJALNA STRONA",
            discord = "DISCORD",
            github = "GITHUB",
        },
        options = {
            title = "OPCJE",

            input = {
                title = "Sterowanie",
                input = "USTAWIENIA STEROWANIA...",
            },
            input_submenu = {
                title = "USTAWIENIA STEROWANIA",
                reset_controls = "ZRESETUJ STEROWANIE",
                controller_button_style = "STYL PRZYCISKÓW", -- The style of the buttons shown in-game. As in, PS4 style buttons, Xbox style buttons...
                controller_button_style_value = {
                    detect = "wykryj",
                    switch = "Switch",
                    playstation4 = "PlayStation 4",
                    playstation5 = "PlayStation 5",
                    xbox = "Xbox",
                },
                deadzone = "MARTWA STREFA JOYSTICKA",
                vibration = "WIBRACJE",
                low_deadzone_warning = "Niskie wartości mogą powodować problemy", -- Warning displayed when the joystick deadzone is very small
                note_deadzone = "Ustawienia martwej strefy zostaną zastosowane po opuszczeniu tego menu",

                gameplay = "Rozgrywka",
                interface = "Interfejs",
                global = "Globalne",
                note_ui_min_button = "Co najmniej jedno przypisanie wymagane",
                note_global_keyboard = "Te przypisania sa takie same dla wszystkich klawiatur",
                note_global_controller = "Te przypisania sa takie same dla wszystkich kontrolerów",
                -- Shown when navigating to player "%d"'s controller settings while no player of this number has joined yet.
                subtitle_no_player = "[⚠ BRAK GRACZA %d]", 
                -- Shown in the controller settings while no controller is connected
                subtitle_no_controller = "[⚠ BRAK PODŁĄCZONEGO KONTROLERA]", 
                no_buttons = "[BRAK PRZYCISKÓW]",
                press_button = "[WCIŚNIJ PRZYCISK]", -- Try to keep it as short as possible
                -- When assigning buttons, if the user presses a button that is already bound, it will instead
                -- remove that button.
                press_again_to_remove = "Naciśnij już przypisany przycisk, aby go usunąć", 
                
                keyboard = "Klawiatura",
                keyboard_solo = "KLAWIATURA (Standard)",
                -- "Split" as in, "the 1st split keyboard user"
                keyboard_p1 = "KLAWIATURA (Podział 1)", 
                keyboard_p2 = "KLAWIATURA (Podział 2)",

                controller = "Kontroler",
                controller_p1 = "KONTROLER (Gracz 1)",
                controller_p2 = "KONTROLER (Gracz 2)",
                controller_p3 = "KONTROLER (Gracz 3)",
                controller_p4 = "KONTROLER (Gracz 4)",
            },
            audio = {
                title = "Dźwięk",
                sound = "DŹWIĘK",
                volume = "GŁOŚNOŚĆ",
                sfx_volume = "EFEKTY DŹWIĘKOWE", -- Can also be translated as "effects volume" or "SFX volume"
                music_volume = "MUZYKA",
                music_pause_menu = "MUZYKA W MENU PAUZY", -- Whether music should play on the pause menu
                ambience = "DŹWIĘKI OTOCZENIA",
            },
            visuals = {
                title = "Elementy wizualne",
                fullscreen = "PEŁEN EKRAN",
                pixel_scale = "SKALA PIXELI", -- How big should every pixel be displayed on-screen (x1, x2, ...)
                pixel_scale_value = {
                    auto = "automatyczna",
                    max_whole = "maksymalnie cała", -- Biggest whole number possible
                },
                vsync = "SYNCHR. PIONOWA",
                menu_blur = "ROZMYCIE TŁA MENU", -- Whether to apply the blurring effect in menu backgrounds
                background_speed = "PRĘDKOŚĆ TŁA", -- How quickly the background scrolls 
                bullet_lightness = "JASNOŚĆ POCISKÓW", -- How brightly bullets are rendered
            },
            game = {
                title = "Gra",
                tutorial = "PORADNIK...",
                language = "JĘZYK...",
                timer = "LICZNIK CZASU",
                mouse_visible = "POKAŻ KURSOR",
                pause_on_unfocus = "PAUZA PRZY UTRACIE OKNA", -- whether the game should pause when the window loses focus
                screenshake = "TRZĘSIENIE EKRANU",
                skip_boss_intros = "POMIŃ INTRA BOSSÓW", -- Whether the game should skip the boss intro animations 
                show_fps_warning = "OSTRZEŻENIE O NISKIEJ LICZBIE FPS", -- Whether the game should show a warning when its framerate is low

            },
            language = {
                title = "JĘZYK",
            },
            confirm_language = {
                description = "Czy uruchomić grę ponownie, aby zastosować nowy język?",
            },
        },
        achievements = {
            title = "OSIĄGNIĘCIA",
        },
        feedback = {
            title = "ZOSTAW OPINIE",
            bugs = "ZGŁOŚ BŁĄD",
            features = "ZGŁOŚ POMYSŁ",
        },
        game_over = {
            title = "KONIEC GRY!",
            kills = "Zabici wrogowie", -- The amount of enemies the player has killed
            deaths = "Zgony",
            time = "Czas",            -- The time that the player took to complete the level
            floor = "Piętro",          -- Which storey the player was on when they died
            score = "Wynik",
            max_combo = "Maks combo",

            continue = "KONTYNUUJ",
            quick_restart = "POWTÓRZ",
        },
        stats = {
            title = "STATYSTYKI",

            time_total = "Czas w grze",
            time_ingame = "Czas grania",
            runs = "Podejścia",
            best_run = "Najwyższe piętro", -- The biggest wave number reached on any run
        },
        new_reward = {
            new_skin = "Nowa postać!",
            new_upgrade = "Nowe ulepszenie!",
        },
        win = {
            title = "GRATULACJE!",
            wishlist = "DODAJ DO LISTY ŻYCZEŃ NA STEAM", -- "wishlist" is a verb
            continue = "KONTYNUUJ",
        },
        joystick_removed = {
            title = "KONTROLER ODŁĄCZONY",
            description = "Podłącz następujące kontrolery:",
            continue = "IGNORUJ",
            item = "Gracz %d (%s)", -- e.g. "Player 2 (Xbox Controller)"
        },
        credits = {
            title = "TWÓRCY",
            ninesliced_presents = "Ninesliced prezentuje",
            game_by = "Gra autorstwa", 
            leo_bernard = "Léo Bernard", -- Please do not touch this
            music = "Muzyka",
            sound_design = "Dźwięk",
            localization = "Lokalizacja",
            additional_art = "Dodatkowa grafika",
            playtesting = "Testerzy",
            special_thanks = "Specjalne podziękowania",
            trailer = "Trailer",
            asset_creators = "Autorzy zasobów",
            tv_slideshow = "Twórcy slajdów TV", -- Refers to the powerpoint TV slideshow on the title screen, which was contributed by a variety of people 
            licenses = "Licencje na zasoby i biblioteki",
            more = "I wiele innych...",                        -- For the people that I might have forgotten in the special thanks section
            thank_you_for_playing = "Dziękujemy za grę!", -- Shown at the end of the credits

            x_by_y = "%s przez %s",                              -- "ASSET_NAME by CREATOR". Used to credit assets such as sound effects
            asset_item = "%s przez %s / %s",                     -- "ASSET_NAME by CREATOR / LICENCE"
        },
        open_source = {
            title = "Biblioteki otwartoźródłowe",
        },
    },
    achievements = {
        ach_complete_w1 = {
            name = "Korporobale",
            description = "Ukończ dział 1",
        },
        ach_complete_w2 = {
            name = "Pasieka Metalu",
            description = "Ukończ dział 2",
        },
        ach_complete_w3 = {
            name = "Serwerowy Piekielnik",
            description = "Ukończ dział 3",
        },
        ach_complete_w4 = {
            name = "Ogrody",
            description = "Ukończ dział 4",
        },
        ach_complete_end = {
            name = "Wakacje",
            description = "Ukończ gre",
        },
        ach_death = {
            name = "Wytrwałość",
            description = "Zgiń 50 razy",
        },
        ach_all_upgrades = {
            name = "Wściekły Koktajl",
            description = "Odblokuj wszystkie ulepszenia",
        },
        ach_all_skins = {
            name = "Lider Zespołu",
            description = "Odblokuj wszystkie postacie",
        },
        ach_max_hearts = {
            name = "Lover",
            description = "Uzyskaj 7 ❤",
        },
        ach_no_damage_easy = {
            name = "Żelazny Robal",
            description = "Nie odnieś obrażeń przez 20 pięter",
        },
        ach_no_damage_full = {
            name = "Złoty Robal",
            description = "Nie odnieś obrażeń przez całą gre",
        },
        ach_no_floor = {
            name = "Podłoga to Lawa",
            description = "Nie dotknij podłogi przez 10 pięter",
        },
        ach_big_combo = {
            name = "Wściekły",
            description = "Zdobądz 100 combo",
        },
        ach_smash_easter_egg = {
            name = "GAME!", -- This is a reference to what the announcer says at the end of a match in Smash Bros.
            description = "Znajdź tajne wyjście",
        },
    },
    discord = { -- Text used for Discord rich presence
        state = {
            solo = "Gra jednoosobowa",
            local_multiplayer = "Lokalna gra wieloosobowa",
        },
        details = {
            waiting = "W lobby",
            playing = "W grze (piętro %d/%d)",
            dying = "Umiera (piętro %d/%d)",
            win = "Ekran zwycięstwa",
        },
    },
}
