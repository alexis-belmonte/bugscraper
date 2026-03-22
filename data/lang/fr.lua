--[[
    TO TRANSLATORS:
    * Reference document for all enemies, players, levels, etc: 
      https://docs.google.com/document/d/13UntpWqoTXgYnBm5HL0pZmjBDwMStIN8YB1IPdi7hlA
    * Even though my target audience is people who already play games, since the game supports 
      local co-op and has very simple, accessible controls, it's not absurd to think that more 
      occasional gamers would try their hand at the game.
    * It is very easy for me to add more glyphs if needed, just tell me and I'll do it.
    * Please notify me if there are any special technical requirements. (e.g. text rendering specifics, etc) 
]]

return {
    __meta = {
        menu_padding = 0.18,
        large_mini_font = false,
    },
    language = {
        -- These should be kept untranslated in their original language ("english", "français", "中文", etc)
        en = "English",
        es = "Español",
        fr = "Français",
        zh = "简体中文",
        pl = "Polski",
        pt_BR = "Português Brasileiro",
        ja = "日本語",
    },
    steam = {
        --[[TODO]]
        short_description =
        [[Bienvenue dans le bugscraper. Gravissez les étages de cette tour remplie de parasites dans ce jeu de plateforme et de tir 2D, et combattez des vagues d'ennemis à chaque étage alors qu'ils viennent pour votre peau (ou plutôt votre exosquelette).]],
        description =
        [[Bienvenue dans le bugscraper. Ici, des parasites du monde entier viennent se rassembler. Votre mission : les arrêter avant qu'il ne soit trop tard ! 🐜 Dans ce jeu de tir et de plateforme, vous incarnez Mio, une fourmi courageuse, essayant d'empêcher les employés d'un gratte-ciel rempli de parasites de corrompre le monde avec un champignon mortel. 🐛 Vous affronterez des vagues d'ennemis dans un ascenseur, alors qu'ils cherchent à atteindre votre peau (ou plutôt votre exosquelette) à chaque étage. 🐝 Utilisez une grande variété d'armes et d'améliorations pour les éliminer et préparez-vous à combattre pour l'étage suivant ! 🐞 Jouez en solo ou avec jusqu'à 4 amis en coopération locale.]]
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
    game = {
        demo = "DEMO", -- Chip added to the game logo to indicate that this version is a demo
        fps = "%d FPS",
        congratulations = "FÉLICITATIONS !",
        win_thanks = "Merci d'avoir joué à la démo",
        win_wishlist = "Ajoutez à votre liste de souhaits Steam :)", -- "Wishlist" is a verb
        warning_web_controller = "Certains navigateurs ne supportent pas correctement les manettes",

        combo = "COMBO %d !",
    },
    level = {
        world_prefix = "Département %s",

        -- Noms des mondes
        world_1 = "Ressources parasites",
        world_2 = "Chambre de production",
        world_3 = "Salle des serveurs",
        world_4 = "Jardins",
        world_5 = "Éxécutif",
        
        world_0 = "Sous-sol",
    },
    gun = {
        -- Noms des armes
        machinegun = "Petit Pois",
        triple = "Pikpikpik",
        burst = "Pollinisateur",
        shotgun = "Fusil Framboise",
        minigun = "Ensemenceur",
        ring = "Boum Baie",
        mushroom_cannon = "Champicanon",

        resignation_letter = "Lettre de Démission" 
    },
    player = {
        name = {
            -- Player names
            -- No reason to change these during translation, except if:
            --  * it's more appropriate to use a transliteration, or to use the script 
            --    of the concerned language (e.g. Leo -> Léo in French, or, say, using Kanji instead of roman letters)
            --  * they clash with something specific to the language/culture (please notify me if it is the case)
            mio = "Mio",
            cap = "Cap",
            zia = "Zia",
            tok = "Tok",
            nel = "Nel",
            nob = "Nob",
            amb = "Amb", --ADDED
            rico = "Rico",
            leo = "Léo",
            dodu = "Dodu",
            yv = "Y.V.",
        },
        -- Short appreviation to denote players by their number.
        -- Example: in english, "P1" means "Player 1", in french "J1" means "Joueur 1".
        abbreviation = "J%d",
    },
    enemy = {
        boss_1 = "M. De Bouse",
        boss_2 = "Sa Majesté",
        boss_3 = "Webmaster",
        
        -- A very large cabbage-like, boulder-like, rolling enemy from the Garden area.   
        boss_4 = "Grobroco",

        -- The CEO of the company, and the final boss. Its name is somewhat ominous-sounding.
        boss_5 = "Patron", -- ADDED
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
            title = "Soda",
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
            description = "Faire x%d dégâts mais utiliser x%d munitions", 
        },
        coconut_water = {
            title = "Eau de coco",
            description = "Écraser des ennemis donne %d%% de munitions",
        },
        hot_chocolate = {
            title = "Chocolat chaud",
            description = "Vitesse de recharge plus rapide",
        },
        pomegranate_juice = {
            title = "Jus de grenadine",
            description = "Créer une explosion en cas de dégâts",
        },
        energy_drink = {
            title = "Boisson énergisante", -- ADDED
            description = "La barre de combo décroit plus lentement", -- ADDED
        },
    },
    input = {
        prompts = {
            move = "Bouger",
            left = "Gauche",
            right = "Droite",
            up = "Haut",
            down = "Bas",
            jump = "Sauter",
            shoot = "Tirer",
            interact = "Intéragir",
            leave_game = "Quitter",
            open = "Ouvrir", -- As in, "open menu", and NOT for, say, opening chests.
            collect = "Collecter", -- As in, "collect item", "collect gun", etc

            ui_left = "Gauche (menu)",
            ui_right = "Droite (menu)",
            ui_up = "Haut (menu)",
            ui_down = "Bas (menu)",
            ui_select = "Confirmer",
            ui_back = "Retour",
            pause = "Pause",

            join = "Rejoindre",
            split_keyboard = "Partager clavier", -- Try to keep short

            wall_jump = "Saut mural",
            jetpack = "Jetpack",
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
            -- Here refers to going back to the main menu to try another run, NOT restarting the game
            description = "Réessayer?", 
        },
        pause = {
            title = "PAUSE",
            resume = "REPRENDRE",
            retry = "RECOMMENCER",
            return_to_ground_floor = "RETOURNER AU REZ-DE-CHAUSSÉE", --ADDED
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
                controller_button_style = "STYLE DES BOUTONS",
                controller_button_style_value = {
                    detect = "détecter",
                    switch = "Switch",
                    playstation4 = "PlayStation 4",
                    playstation5 = "PlayStation 5",
                    xbox = "Xbox",
                },
                deadzone = "ZONE MORTE DU JOYSTICK",
                vibration = "VIBRATION",
                low_deadzone_warning = "Des valeurs faibles peuvent causer des problèmes",
                note_deadzone = "Les paramètres de zone morte seront appliqués en quittant ce menu",

                gameplay = "Gameplay",
                interface = "Interface",
                global = "Global",
                note_ui_min_button = "Au moins une attribution est requise",
                note_global_keyboard = "Ces paramètres sont communs à tous les joueurs clavier",
                note_global_controller = "Ces paramètres sont communs à tous les joueurs manette",
                subtitle_no_player = "[⚠ PAS DE JOUEUR %d]",
                subtitle_no_controller = "[⚠ AUCUNE MANETTE CONNECTÉE]",
                no_buttons = "[AUCUN BOUTON]",
                press_button = "[APPUYER BOUTON]",
                press_again_to_remove = "Appuyez de nouveau sur un bouton attribué pour le supprimer",

                keyboard = "Clavier",
                keyboard_solo = "CLAVIER (Par défaut)",
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
                sfx_volume = "VOLUME DES EFFETS SONORES",
                music_volume = "VOLUME DE LA MUSIQUE",
                music_pause_menu = "MUSIQUE DANS LE MENU DE PAUSE",
                ambience = "SONS D'AMBIANCE", 
            },
            visuals = {
                title = "Visuels",
                fullscreen = "PLEIN ÉCRAN",
                pixel_scale = "ÉCHELLE DES PIXELS",
                pixel_scale_value = {
                    auto = "auto",
                    max_whole = "max entier",
                },
                vsync = "VSYNC",
                menu_blur = "FLOU DU FOND DES MENUS",
                background_speed = "VITESSE DE L'ARRIÈRE PLAN",
                bullet_lightness = "LUMINOSITÉ DES BALLES",
            },
            game = {
                title = "Jeu",
                tutorial = "TUTORIEL...",
                language = "LANGUE...",
                timer = "CHRONOMÈTRE",
                mouse_visible = "AFFICHER LE CURSEUR",
                pause_on_unfocus = "PAUSE EN CAS DE PERTE DE FOCUS",
                screenshake = "TREMBLEMENT D'ÉCRAN",
                skip_boss_intros = "PASSER LES INTROS DE BOSS",
                show_fps_warning = "AFFICHER AVERTISSEMENT DE FPS BAS",
            },
            language = {
                title = "LANGUE",
            },
            confirm_language = {
                description = "Redémarrer le jeu pour appliquer la nouvelle langue ?",
            },
        },
        feedback = {
            title = "RETOURS",
            bugs = "SIGNALER UN BUG",
            features = "SUGGÉRER UNE FONCTIONNALITÉ",
        },
        game_over = {
            title = "GAME OVER!",
            kills = "Ennemis tués",
            time = "Temps",
            floor = "Étage",
            score = "Score",
            max_combo = "Combo max",

            continue = "CONTINUER",
            quick_restart = "REDÉMARRAGE RAPIDE",
        },
        new_reward = {
            new_skin = "Nouveau personnage !", -- ADDED
            new_upgrade = "Nouvelle amélioration !", -- ADDED
        },
        win = {
            title = "FÉLICITATIONS !",
            wishlist = "AJOUTER À LA LISTE DE SOUHAITS STEAM",
            continue = "CONTINUER",
        },
        joystick_removed = {
            title = "MANETTE DÉCONNECTÉE",
            description = "Veuillez connecter les manettes suivantes :",
            continue = "CONTINUER QUAND MÊME",
            item = "Joueur %d (%s)",
        },
        credits = {
            title = "CRÉDITS",
            ninesliced_presents = "Ninesliced présente", -- Ninesliced with a capital letter ONLY on the N
            game_by = "Un jeu par", -- As in, "A game by / John". If it is not possible to have the name *after* this, translate as "Creator" ("Creator / John")
            leo_bernard = "Léo Bernard", -- Please do not touch this 
            music = "Musique",
            sound_design = "Sound design",
            localization = "Localisation",
            additional_art = "Art supplémentaire",
            playtesting = "Playtesting",
            special_thanks = "Remerciements",
            trailer = "Bande-annonce",
            asset_creators = "Créateur·rices d'assets",
            tv_slideshow = "Contributeur·rices diaporama TV", 
            licenses = "Licences des assets & bibliothèques",
            more = "Et bien plus...", -- For the people that I might have forgotten in the special thanks section
            thank_you_for_playing = "Merci pour avoir joué ! ❤", -- ADDED / Shown at the end of the credits

            x_by_y =     "%s par %s", -- "ASSET_NAME by CREATOR". Used to credit assets such as sound effects
            asset_item = "%s par %s / %s", -- "ASSET_NAME by CREATOR / LICENCE". Used to credit assets such as sound effects
        },
        open_source = {
            title = "Bibliothèques open source",
        },
    },
}
