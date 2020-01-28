var pagesConfig = {
    error: {
        title: "Error"
    },
    login:{
        title: "Login",
        pageName: "Login"
    },
    home:{
        title: "Home",
        pageName: "Accueil"
    },
    options:{
        title: "Options",
        pageName: "Options",
        hideOptionsBtn: true
    },
    new_game:{
        title: "Choix de la partie",
        pageName: "Choix de la partie",
        view: "newgame"
    },
    lobby_host:{
        title: "Création de la partie",
        pageName: "Création de la partie",
        view: "lobby"
    },
    lobby:{
        title: "Création de la partie",
        pageName: "Création de la partie",
        view: "lobby"
    },
    new_level:{
        title: "Create level",
        pageName: "Création de niveau",
        view: "new_level",
        data: [
            {
                source: "music",
                container: "#musicSelector",
                adapter: "levelEditorAdapter"
            }
        ]
    },
    level_editor:{
        title: "Création de rythme",
        pageName: "Création de rythm",
        view: "level_editor"
    },
    levels:{
        title: "Replay",
        data: [
            {
                source: "levels",
                container: "#levelsContainer",
                adapter: "levelAdapter"
            }
        ],
        pageName: "Replay",
        view: "replay_level"
    },
    replays:{
        title: "Replays"
    },
    replay_player:{
        title: "Replay (player)" //as in video player :)
    },
    game:{
        title: "Partie en cours",
        pageName: "Partie en cours",
        view: "game"
    }
};