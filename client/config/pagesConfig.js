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
        title: "New game"
    },
    lobby_host:{
        title: "Lobby (host)",
        view: "lobby"
    },
    lobby:{
        title: "Lobby"
    },
    new_level:{
        title: "Create level"
    },
    level_editor:{
        title: "Create level (editor)"
    },
    levels:{
        title: "Levels",
        data: [
            {
                source: "levels",
                container: "#levelsContainer",
                adapter: "levelAdapter"
            }
        ]
    },
    replays:{
        title: "Replays"
    },
    replay_player:{
        title: "Replay (player)" //as in video player :)
    },
    game:{
        title: "Game"
    }
};