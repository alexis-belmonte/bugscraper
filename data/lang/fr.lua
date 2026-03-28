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
        congratulations = "FÉLICITATIONS !",
        win_thanks = "Merci d'avoir joué à la démo",
        win_wishlist = "Ajoutez à votre liste de souhaits :)", -- "Wishlist" is a verb
        warning_web_controller = "Certains navigateurs ne supportent pas correctement les manettes",

        combo = "COMBO %d !", 
    },
    level = {
        world_prefix = "Département %s",

        -- Department names
        -- I chose to not use articles in english (so instead of "The Factory", it's just "Factory")

        -- Dept 1: This can be any vaguely office-y name (I just chose this in english because of the word play), 
        -- because this department just represents a generic office department.
        world_1 = "Ressources parasites", 
        -- Dept 2: This department is a factory themed after bees, with grungy metallic environment
        world_2 = "Chambre de production",
        -- Dept 3: This is a moody, dark and mysterious room filled with endless racks of servers 
        world_3 = "Salle des serveurs",
        -- Dept 4: This is the highest department of the bugscraper, filled with lofty gardens and clean, white, modern architecture
        world_4 = "Jardins",

        -- Dept 0: This is an underground secret department below the bugscraper. It contains a huge hangar with a large rocket. 
        world_0 = "Sous-sol",
    },
    gun = {
        -- Gun names
        -- You can be more creative with these, you don't have to stay close to the originals.
        -- Look at google doc for image references
        machinegun = "Petit Pois",
        triple = "Pikpikpik",
        burst = "Pollinisateur",
        shotgun = "Fusil Framboise",
        minigun = "Ensemenceur",
        ring = "Boum Baie",
        mushroom_cannon = "Champicanon",

        resignation_letter = "Lettre de Démission",
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
            leo = "Léo",
            dodu = "Dodu", 
        },
        abbreviation = "J%d", -- Short appreviation to denote players by their number. Example: in english, "P1" means "Player 1", in french "J1" means "Joueur 1".
    },
    enemy = {
        -- These are the boss names. Please look at the Gdocs for reference.
        -- Feel free to pick interesting names, and you don't have to base them off the english name.

        -- (for example, the french name for "Mr. Dung" is "J. De Bouse", which is a 
        -- play on words with the french word for 'dung' and a famous french humorist. 
        -- "The Webmaster" is a play on words between the theme of the area and spider webs)

        -- A somewhat witty and clownesque exectutive based off a Dung Beetle. 
        boss_1 = "M. De Bouse",

        -- The queen of the Factory, who's also a metal/rock singer.  
        boss_2 = "Sa Majesté", 

        -- The guardian of the Server Room, whose design is based off a motherboard and spiders.
        boss_3 = "Webmaster",

        -- A very large green cabbage-like, boulder-like, rolling enemy from the Garden area.   
        -- You're free to be more creative with this one. 
        -- (example: in French, I chose "Grobroco", "gros" (large) + "broco" (diminutive of broccoli))
        boss_4 = "Grobroco",

        -- The CEO of the company, and the final boss. Its name is somewhat ominous-sounding.
        -- Try to avoid ambiguity with the term "boss", which could be confused with the generic term for a video game boss.
        boss_5 = "Patron",
    },
    upgrade = {
        tea = {
            title = "Thé vert",
            description = "+%d ❤ extra",
        },
        espresso = {
            title = "Espresso",
            description = "x%d vitesse de tir pendant %d étages",
        },
        milk = {
            title = "Lait",
            description = "+%d maximum ❤",
        },
        boba = {
            title = "Bubble tea",
            description = "x%d munitions maximum",
        },
        soda = {
            title = "Soda", -- As in Coca-cola/Pepsi style soda.
            description = "+%d saut dans les airs",
        },
        fizzy_lemonade = {
            title = "Limonade pétillante",
            description = "Maintenir saut pour planer",
        },
        apple_juice = {
            title = "Jus de pomme",
            description = "Soigne +%d ❤",
        },
        hot_sauce = {
            title = "Sauce piquante",
            description = "Faire x%d dégâts mais utiliser x%d munitions", -- First "%d" is the damage, second "%d" is ammo
        },
        coconut_water = {
            title = "Eau de coco",
            description = "Écraser des ennemis donne %d%% de munitions",
        },
        hot_chocolate = {
            title = "Chocolat chaud",
            description = "Recharge plus rapide",
        },
        pomegranate_juice = {
            title = "Jus de grenade",
            description = "Créer une explosion en cas de dégâts",
        },
        energy_drink = {
            title = "Boisson énergisante",
            description = "La barre de combo décroit plus lentement",
        },
    },
    input = {
        prompts = {
            -- All of these are infinitive verbs and may be shown as button prompts 
            -- (i.e., "[X] Shoot", "[C] Jump", etc)

            -- Gameplay Actions
            move = "Bouger", 
            left = "Gauche",
            right = "Droite",
            up = "Haut",
            down = "Bas",
            jump = "Sauter",
            shoot = "Tirer",
            interact = "Interagir",
            leave_game = "Quitter",
            open = "Ouvrir",         -- As in, "open menu", and NOT for, say, opening chests.
            collect = "Collecter",   -- As in, "collect item", "collect gun", etc

            -- UI Actions
            ui_left = "Gauche (menu)",
            ui_right = "Droite (menu)",
            ui_up = "Haut (menu)",
            ui_down = "Bas (menu)",
            ui_select = "Confirmer",
            ui_back = "Retour",
            pause = "Pause",
            join = "Rejoindre", -- As, in joining the game, adding a new player to the game.
            -- As in, "Press [key] to split the keyboard". 
            -- Shown on the title screen when one keyboard player has joined. 
            -- Try to keep it as short as possible since space is limited there.
            split_keyboard = "Partager clavier", 

            wall_jump = "Saut mural",
            jetpack = "Jetpack", -- Refers to "jetpacking", a move in the game performed by shooting downwards with a gun.
        },
    },
    menu = {
        see_more = "plus d'infos...",
        yes = "OUI",
        no = "NON",
        leave_menu = "Quitter le menu ?", -- Generic "leave menu?"
        quit = {
            description = "Êtes-vous sûr de vouloir quitter ?"
        },
        confirm_retry = {
            description = "Réessayer?",
        },
        pause = {
            title = "PAUSE",
            resume = "REPRENDRE",
            retry = "RECOMMENCER",

            -- This correspons to floor 0 in the game. To different cultures, the "ground floor" 
            -- might usually mean "floor 1", so please make sure to avoid ambiguity when translating. 
            -- (You can also translate as "main lobby" or something like it.)   
            return_to_ground_floor = "RETOURNER AU REZ-DE-CHAUSSÉE", 
            options = "OPTIONS",
            credits = "CRÉDITS",
            feedback = "RETOURS",
            quit = "QUITTER",
            website = "SITE OFFICIEL",
            discord = "DISCORD",
            github = "GITHUB",
        },
        options = {
            title = "OPTIONS",

            input = {
                title = "Contrôles",
                input = "PARAMÈTRES DES CONTRÔLES...",
            },
            input_submenu = {
                title = "PARAMÈTRES DES CONTRÔLES",
                reset_controls = "RÉINITIALISER LES CONTRÔLES",
                controller_button_style = "STYLE DES BOUTONS", -- The style of the buttons shown in-game. As in, PS4 style buttons, Xbox style buttons...
                controller_button_style_value = {
                    detect = "détecter",
                    switch = "Switch",
                    playstation4 = "PlayStation 4",
                    playstation5 = "PlayStation 5",
                    xbox = "Xbox",
                },
                deadzone = "ZONE MORTE DU JOYSTICK",
                vibration = "VIBRATION",
                low_deadzone_warning = "Des valeurs faibles peuvent causer des problèmes", -- Warning displayed when the joystick deadzone is very small
                note_deadzone = "Les paramètres de zone morte seront appliqués en quittant ce menu",

                gameplay = "Gameplay",
                interface = "Interface",
                global = "Global",
                note_ui_min_button = "Au moins une attribution est requise",
                note_global_keyboard = "Ces paramètres sont communs à tous les joueurs clavier",
                note_global_controller = "Ces paramètres sont communs à tous les joueurs manette",
                -- Shown when navigating to player "%d"'s controller settings while no player of this number has joined yet.
                subtitle_no_player = "[⚠ PAS DE JOUEUR %d]", 
                -- Shown in the controller settings while no controller is connected
                subtitle_no_controller = "[⚠ AUCUNE MANETTE CONNECTÉE]", 
                no_buttons = "[AUCUN BOUTON]",
                press_button = "[APPUYEZ SUR UN BOUTON]", -- Try to keep it as short as possible
                -- When assigning buttons, if the user presses a button that is already bound, it will instead
                -- remove that button.
                press_again_to_remove = "Appuyez de nouveau sur un bouton déjà attribué pour le supprimer", 
                
                keyboard = "Clavier",
                keyboard_solo = "CLAVIER (Par défaut)",
                -- "Split" as in, "the 1st split keyboard user"
                keyboard_p1 = "CLAVIER (Partagé 1)", 
                keyboard_p2 = "CLAVIER (Partagé 2)",

                controller = "Manette",
                controller_p1 = "MANETTE (Joueur 1)",
                controller_p2 = "MANETTE (Joueur 2)",
                controller_p3 = "MANETTE (Joueur 3)",
                controller_p4 = "MANETTE (Joueur 4)",
            },
            audio = {
                title = "Audio",
                sound = "SON",
                volume = "VOLUME",
                sfx_volume = "VOLUME DES EFFETS SONORES", -- Can also be translated as "effects volume" or "SFX volume"
                music_volume = "VOLUME DE LA MUSIQUE",
                music_pause_menu = "MUSIQUE DANS LE MENU DE PAUSE", -- Whether music should play on the pause menu
                ambience = "SONS D'AMBIANCE",
            },
            visuals = {
                title = "Visuels",
                fullscreen = "PLEIN ÉCRAN",
                pixel_scale = "ÉCHELLE DES PIXELS", -- How big should every pixel be displayed on-screen (x1, x2, ...)
                pixel_scale_value = {
                    auto = "auto",
                    max_whole = "max entier", -- Biggest whole number possible
                },
                vsync = "VSYNC",
                menu_blur = "FLOU SUR L'ARRIÈRE PLAN DES MENUS", -- Whether to apply the blurring effect in menu backgrounds
                background_speed = "VITESSE DE L'ARRIÈRE PLAN", -- How quickly the background scrolls 
                bullet_lightness = "LUMINOSITÉ DES BALLES", -- How brightly bullets are rendered
            },
            game = {
                title = "Jeu",
                tutorial = "TUTORIEL...",
                language = "LANGUE...",
                timer = "CHRONOMÈTRE",
                mouse_visible = "AFFICHER LE CURSEUR",
                pause_on_unfocus = "PAUSE EN CAS DE PERTE DE FOCUS", -- whether the game should pause when the window loses focus
                screenshake = "TREMBLEMENT D'ÉCRAN",
                skip_boss_intros = "PASSER LES INTROS DE BOSS", -- Whether the game should skip the boss intro animations 
                show_fps_warning = "AFFICHER AVERTISSEMENT DE FPS BAS", -- Whether the game should show a warning when its framerate is low

            },
            language = {
                title = "LANGUE",
            },
            confirm_language = {
                description = "Redémarrer le jeu pour appliquer la nouvelle langue ?",
            },
        },
        achievements = {
            title = "SUCCÈS",
        },
        feedback = {
            title = "RETOURS",
            bugs = "SIGNALER UN BUG",
            features = "SUGGÉRER UNE FONCTIONNALITÉ",
        },
        game_over = {
            title = "GAME OVER!",
            kills = "Ennemis tués", -- The amount of enemies the player has killed
            deaths = "Morts",
            time = "Temps",            -- The time that the player took to complete the level
            floor = "Étage",          -- Which storey the player was on when they died
            score = "Score",
            max_combo = "Combo max",

            continue = "CONTINUER",
            quick_restart = "REDÉMARRAGE RAPIDE",
        },
        stats = {
            title = "STATISTIQUES",

            time_total = "Temps passé (total)",
            time_ingame = "Temps passé (en jeu)",
            runs = "Parties",
            best_run = "Meilleure vague atteinte", -- The biggest wave number reached on any run
        },
        new_reward = {
            new_skin = "Nouveau personnage !",
            new_upgrade = "Nouvelle amélioration !",
        },
        win = {
            title = "FÉLICITATIONS !",
            wishlist = "AJOUTER À VOTRE LISTE DE SOUHAITS", -- "wishlist" is a verb
            continue = "CONTINUER",
        },
        joystick_removed = {
            title = "MANETTE DÉCONNECTÉE",
            description = "Veuillez connecter les manettes suivantes :",
            continue = "CONTINUER QUAND MÊME",
            item = "Joueur %d (%s)", -- e.g. "Player 2 (Xbox Controller)"
        },
        credits = {
            title = "CRÉDITS",
            ninesliced_presents = "Ninesliced présente",
            game_by = "Un jeu par", 
            leo_bernard = "Léo Bernard", -- Please do not touch this
            music = "Musique",
            sound_design = "Sound design",
            localization = "Localisation",
            additional_art = "Art supplémentaire",
            playtesting = "Playtesting",
            special_thanks = "Remerciements",
            trailer = "Bande-annonce",
            asset_creators = "Créateur·rices d'assets",
            tv_slideshow = "Contributeur·rices diaporama TV", -- Refers to the powerpoint TV slideshow on the title screen, which was contributed by a variety of people 
            licenses = "Licences des assets & bibliothèques",
            more = "Et bien plus...",                        -- For the people that I might have forgotten in the special thanks section
            thank_you_for_playing = "Merci d'avoir joué ! ❤", -- Shown at the end of the credits

            x_by_y = "%s par %s",                              -- "ASSET_NAME by CREATOR". Used to credit assets such as sound effects
            asset_item = "%s par %s / %s",                     -- "ASSET_NAME by CREATOR / LICENCE"
        },
        open_source = {
            title = "Bibliothèques open source",
        },
    },
    achievements = {
        ach_complete_w1 = {
            name = "Ressources parasites", 
            description = "Finir le département 1",
        },
        ach_complete_w2 = {
            name = "Chambre de production",
            description = "Finir le département 2",
        },
        ach_complete_w3 = {
            name = "Salle des serveurs",
            description = "Finir le département 3",
        },
        ach_complete_w4 = {
            name = "Jardins",
            description = "Finir le département 4",
        },
        ach_complete_end = {
            name = "Vacances",
            description = "Finir le jeu",
        },
        ach_death = {
            name = "Persévérant",
            description = "Mourir 50 fois",
        },
        ach_all_upgrades = {
            name = "Une soif insatiable",
            description = "Débloquer toutes les améliorations",
        },
        ach_all_skins = {
            name = "Bain de foule",
            description = "Débloquer tous les personnages",
        },
        ach_max_hearts = {
            name = "Romantique",
            description = "Obtenir 7 ❤",
        },
        ach_no_damage_easy = {
            name = "Insecte métalleux",
            description = "Ne pas prendre de dégâts pendant 20 vagues",
        },
        ach_no_damage_full = {
            name = "Insecte doré",
            description = "Ne pas prendre de dégâts pendant une partie entière",
        },
        ach_no_floor = {
            name = "Sur des coquilles d'œufs",
            description = "Ne pas toucher le sol pendant 10 vagues",
        },
        ach_big_combo = {
            name = "Furieux",
            description = "Obtenir un combo 100",
        },
        ach_smash_easter_egg = {
            name = "FINI !", -- This is a reference to what the announcer says at the end of a match in Smash Bros.
            description = "Obtenir l'animation de sortie secrète", 
        },
    },
    discord = { -- Text used for Discord rich presence
        state = {
            solo = "Solo",
            local_multiplayer = "Multijoueur local",
        },
        details = {
            waiting = "Dans le lobby",
            playing = "En jeu (étage %d/%d)",
            dying = "Vaincu (étage %d/%d)",
            win = "Écran de victoire",
        },
    },
}
