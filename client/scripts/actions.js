"use strict";
function Actions() {
    var _this = this;
    this.level = {
        song: "",
        sequence: [],
        status: 0,
        name: "",
    };
    let currentKeys = {};
    const song = new Audio();
    let currentSong = "";
    let currentSongTime = 0;

    //-------------------------------------------------------------------------------------
    //page actions on load
    //-------------------------------------------------------------------------------------
    this.onPageLoad = {};
    this.onPageLoad.welcome = function(){};
    this.onPageLoad.login = function(){
        loginForm.addEventListener("submit", async function(){
            //login
            Utils.getGlobalLoader().show({withBackground:true});
            console.log("login! (fake)");
            pagesManager.loadView("home");
            await async_setTimeout(1000);
            console.log("logged in! (fake)");
            Utils.getGlobalLoader().hide();
            pagesManager.changePage("home");
        });
    }
    this.onPageLoad.demo = function() {
        var globalMethod;
        var globalAttributs;
        var exist=false;

        /**
         * Player
         */
        createPlayer.addEventListener("click", function(event){
            
            var form = document.querySelector("form");
            form.classList.toggle("d-none");

            if(exist) return;

            var formGroupName = form.addElement("div",{class: "form-group"});
            var labelName = formGroupName.addElement("label",{for: "username"});
            labelName.textContent = "insert a name of player: ";
            var pseudos = ["NoxCaedibux", "Azertycraft", "Tryliom"];
            formGroupName.addElement("input",{
                id: "username", 
                type: "text", 
                class: "form-control", 
                value: pseudos[Math.floor(Math.random()*pseudos.length)]
            });
            form.addElement("input", {type: "submit", value: "create", class: "common-button texture wood"})
            form.action = "#";            
            globalMethod = insertPlayer;
            globalAttributs = {name: username.value}
            exist = true;
        });

        async function insertPlayer()
        {
            var result = await websocket.sendRequest("createPlayer", globalAttributs);
            var content = createPlayer.parentElement.parentElement.querySelector(".content");
            content.textContent = result;
        }

        listPlayer.addEventListener("click", async function(event){
            var result = await websocket.sendRequest("getPlayers");
            var content = listPlayer.parentElement.parentElement.querySelector(".content");
            content.textContent = result;
        });
        
        /**
         * Music
         */
        createMusic.addEventListener("click", function(event){
            
            var form = document.querySelector("form");
            form.classList.toggle("d-none");

            if(exist) return;

            var formGroupMusicName = form.addElement("div",{class: "form-group"});
            var labelName = formGroupMusicName.addElement("label",{for: "musicName"});
            labelName.textContent = "insert a music name: ";
            var musics = ["Route arc-en-ciel M.Wii", "Jump up super star", "light ssbu"];
            formGroupMusicName.addElement("input",{
                id: "musicName", 
                type: "text", 
                class: "form-control", 
                value: musics[Math.floor(Math.random()*musics.length)]
            });

            var formGroupDuration = form.addElement("div",{class: "form-group"});
            var labelDuration = formGroupDuration.addElement("label",{for: "duration"});
            labelDuration.textContent = "duration: ";
            formGroupDuration.addElement("input",{
                id: "duration", 
                type: "number", 
                class: "form-control", 
                value: 180000
            });

            var formGroupSRC = form.addElement("div",{class: "form-group"});
            var labelSRC = formGroupSRC.addElement("label",{for: "src"});
            labelSRC.textContent = "Source: ";
            formGroupSRC.addElement("input",{
                id: "src", 
                type: "text", 
                class: "form-control", 
                value: "/public/songs"
            });

            var formGroupBPM = form.addElement("div",{class: "form-group"});
            var labelBPM = formGroupBPM.addElement("label",{for: "bpm"});
            labelBPM.textContent = "BPM: ";
            formGroupBPM.addElement("input",{
                id: "bpm", 
                type: "number", 
                class: "form-control", 
                value: 65
            });

            var formGroupOffset = form.addElement("div",{class: "form-group"});
            var labelOffset = formGroupOffset.addElement("label",{for: "start_offset"});
            labelOffset.textContent = "start offset: ";
            formGroupOffset.addElement("input",{
                id: "start_offset", 
                type: "number", 
                class: "form-control", 
                value: 2000
            });

            form.addElement("input", {type: "submit", value: "create", class: "common-button texture wood"})
            form.action = "javascript:";            
            globalMethod = insertMusic;
            globalAttributs = {name: musicName.value, duration: duration.value, src: src.value, bpm: bpm.value, start_offset: start_offset.value}
            
            exist = true;
        });

        async function insertMusic()
        {
            var result = await websocket.sendRequest("createMusic", globalAttributs);
            var content = createMusic.parentElement.parentElement.querySelector(".content");
            content.textContent = result;
        }

        listMusic.addEventListener("click", async function(event){
            var result = await websocket.sendRequest("getMusics");
            var content = listMusic.parentElement.parentElement.querySelector(".content");
            content.textContent = result;
        });

        /**
         * Level
         *//*
        createLevel.addEventListener("click", async function(event){
            var form = document.querySelector("form");
            form.classList.toggle("d-none");

            if(exist) return;

            var formGroupLevelName = form.addElement("div",{class: "form-group"});
            var labelName = formGroupLevelName.addElement("label",{for: "levelName"});
            labelName.textContent = "insert a level name: ";
            var levels = ["Rapteur", "kyle", "NOland"];
            formGroupLevelName.addElement("input",{
                id: "levelName", 
                type: "text", 
                class: "form-control", 
                value: levels[Math.floor(Math.random()*levels.length)]
            });

            var formGroupdifficulty= form.addElement("div",{class: "form-group"});
            var labelDifficulty = formGroupdifficulty.addElement("label",{for: "difficulty"});
            labelDifficulty.textContent = "difficulty: (easy, medium, hard) ";
            var difficulties = ["easy", "medium", "hard"];
            formGroupdifficulty.addElement("input",{
                id: "difficulty", 
                type: "text", 
                class: "form-control", 
                value: difficulties[Math.floor(Math.random()*difficulties.length)]
            });

            var formGroupHardcore= form.addElement("div",{class: "form-group"});
            var labelHardcore = formGroupHardcore.addElement("label",{for: "hardcore"});
            labelHardcore.textContent = "hardcore: 0 or 1 ";
            var hardcoreArray = [0,1];
            formGroupHardcore.addElement("input",{
                id: "hardcore", 
                type: "numer", 
                max: 1,
                min: 0,
                step: 1,
                class: "form-control", 
                value: hardcoreArray[Math.floor(Math.random()*hardcoreArray.length)]
            });

            var formGroupMusic= form.addElement("div",{class: "form-group"});
            var labelMusic = formGroupMusic.addElement("label",{for: "music"});
            labelMusic.textContent = "id of once music of database";
            var hardcoreArray = [0,1];
            formGroupMusic.addElement("input",{
                id: "music", 
                type: "text", 
                disabled: true,
                class: "form-control", 
                value: await websocket.sendRequest("getFirstMusic")
            });

            var formGroupCreator= form.addElement("div",{class: "form-group"});
            var labelCreator = formGroupCreator.addElement("label",{for: "creator"});
            labelCreator.textContent = "id of once Player of database";
            var hardcoreArray = [0,1];
            formGroupCreator.addElement("input",{
                id: "creator", 
                type: "text", 
                disabled: true,
                class: "form-control", 
                value: await websocket.sendRequest("getFirstPlayer")
            });

            form.addElement("input", {type: "submit", value: "create", class: "common-button texture wood"})
            form.action = "javascript:";            
            globalMethod = insertLevel;
            globalAttributs = {name: levelName.value, difficulty: difficulty.value, hardcore: hardcore.value, musicID: music.value, creator: creator.value}
            
            exist = true;

        })

        async function insertLevel()
        {
            var result = await websocket.sendRequest("insertLevel", globalAttributs);
            var content = createLevel.parentElement.parentElement.querySelector(".content");
            content.textContent = result;
        }
        
        listLevel.addEventListener("click", async function(event){
            var result = await websocket.sendRequest("getLevels");
            var content = listLevel.parentElement.parentElement.querySelector(".content");
            content.textContent = result;
        });*/
        /**
         * Submit
         */ 
        document.querySelector("form").addEventListener("submit", async function(event){
            globalMethod(globalAttributs);
            var form = document.querySelector("form");
            form.removeChilds();
            form.classList.toggle("d-none");
            exist = false;
        });
    }

    this.onPageLoad.home = function() {
        change_player_left.onclick = function(evt) {
            const currentClass = player_icon.classList[0];
            const name = currentClass.substring(10, 11);
            let newclass = "img-player";
            if (name === "1")
                newclass+="3";
            else
                newclass+=""+(parseInt(name)-1);

            player_icon.classList.replace(currentClass, newclass);
        };

        change_player_right.onclick = function(evt) {
            const currentClass = player_icon.classList[0];
            const name = currentClass.substring(10, 11);
            let newclass = "img-player";
            if (name === "3")
                newclass+="1";
            else
                newclass+=""+(parseInt(name)+1);

            player_icon.classList.replace(currentClass, newclass);
        };
    };
    this.onPageLoad.options = function() {
        pagesManager.pages.options.container.addEventListener("change", function(){
            applyUserOptions({
                leavesAnimation: chkUserOptionsLeaves.checked
            });
        });
    };

    this.onPageLoad.game = function () {
        mainDiv.classList.remove("container");
        mainDiv.classList.add("container-fluid");
        const gameContext = canvasGame.getContext("2d");
        gameInput.focus()
        gameInput.onkeypress = function (evt) {
            let char = evt.key;
            canvasGame.width = canvasGame.clientWidth;
            canvasGame.height = canvasGame.clientHeight;
            gameContext.clearRect(0,0,canvasGame.clientWidth,canvasGame.clientHeight);
            gameContext.font = "30px Arial";
            gameContext.fillStyle = "red";
            gameContext.textAlign = "center";
            gameContext.fillText(char.toUpperCase(), canvasGame.clientWidth/2, canvasGame.clientHeight/2);
        };
        // Focus the field when unfocus to continue to listen key even after a "tab"
        gameInput.addEventListener("focusout", () => {gameInput.focus()});
    };

    this.onPageLoad.level_editor = function () {
        const gameContext = canvasGame.getContext("2d");
        gameInput.focus()
        gameInput.addEventListener("keydown", keyDown);
        gameInput.addEventListener("keyup", keyUp);
        // Focus the field when unfocus to continue to listen key even after a "tab"
        gameInput.addEventListener("focusout", () => {gameInput.focus()});
    };

    function keyDown(evt) {
        if(currentKeys[evt.keyCode]){
            return;
        }
        currentKeys[evt.keyCode] = {
            time: getSongTime()
        };

        let char = evt.key;
        const gameContext = canvasGame.getContext("2d");
        canvasGame.width = canvasGame.clientWidth;
        canvasGame.height = canvasGame.clientHeight;
        gameContext.clearRect(0,0,canvasGame.clientWidth,canvasGame.clientHeight);
        gameContext.font = "30px Arial";
        gameContext.fillStyle = "white";
        gameContext.textAlign = "center";
        gameContext.fillText(char.toUpperCase(), canvasGame.clientWidth/2, canvasGame.clientHeight/2);
    }

    function keyUp(evt) {
        if(!currentKeys[evt.keyCode]){
            console.warn("no prior keydown!");
            return;
        }
        var downObject = currentKeys[evt.keyCode];
        //remove from currentKeys
        currentKeys[evt.keyCode] = false;

        //add to sequence
        _this.level.sequence.push({
            time: downObject.time,
            key: evt.key,
            duration: getSongTime() - downObject.time
        });

        //display
        _this.level.rythm = JSON.stringify(_this.level.sequence);

        let char = evt.key;
        const gameContext = canvasGame.getContext("2d");
        canvasGame.width = canvasGame.clientWidth;
        canvasGame.height = canvasGame.clientHeight;
        gameContext.clearRect(0,0,canvasGame.clientWidth,canvasGame.clientHeight);
        gameContext.font = "30px Arial";
        gameContext.fillStyle = "white";
        gameContext.textAlign = "center";
        gameContext.fillText(char.toUpperCase(), canvasGame.clientWidth/2, canvasGame.clientHeight/2);
    }

    function getSongTime() {
        return Math.round(song.currentTime * 1000);
    }
    
    //-------------------------------------------------------------------------------------
    //page actions on display
    //-------------------------------------------------------------------------------------
    this.onPageDisplay = {};
    this.onPageDisplay.error = function(){
        if(globalMemory.error){
            errorStatusCode.innerText = (globalMemory.error.code || "");
            errorClientMsg.innerText = (globalMemory.error.msg || "");
        }
    };
    //options
    this.onPageDisplay.options = function(){
        var userOptions = getUserOptions();
        chkUserOptionsLeaves.checked = userOptions.leavesAnimation;
    };

    this.onPageDisplay.level_editor = function () {
        mainDiv.classList.remove("container");
        mainDiv.classList.add("container-fluid");
    };
    
    //page action on ANY page display
    this.onAnyPageDisplay = function({pageName = false, pageConfig = false}){
        pageNameDisplay.innerText = (pageConfig.pageName || pageConfig.title || "");
        //options button
        if(pageConfig.hideOptionsBtn){
            userOptionsBtn.classList.add("none");
        } else {
            userOptionsBtn.classList.remove("none");
        }
        // Remove class set by game to be non-fluid
        mainDiv.classList.remove("container-fluid");
        mainDiv.classList.add("container");
    };

    //-------------------------------------------------------------------------------------
    //page actions on data
    //-------------------------------------------------------------------------------------
    this.onPageData = {};
    this.onPageData.replays = function(){};
    
    //-------------------------------------------------------------------------------------
    //page specific methods
    //-------------------------------------------------------------------------------------
    this.pageMethods = {};
    this.pageMethods.replays = function(){};

    //-------------------------------------------------------------------------------------
    //other actions
    //-------------------------------------------------------------------------------------
    this.onBeforeBoot = function(){
        Utils.setDynamicLinks(document.body); //dynamic links on layout
        console.log("server whitelist to copy:", `[nil, "", "${Object.keys(pagesConfig).join('", "')}"]`);
    }
    this.onAfterBoot = function(){
        for(var ind in pagesConfig){
            var link = testTopMenu.addElement("a");
            var btn = link.addElement("button");
            btn.innerText = ind;
            link.href = `/${ind}`;
        }
        applyUserOptions();
        Utils.setDynamicLinks(testTopMenu);
	    console.log("init completed");
    };

    this.switchMenu = (evt) => {
        const classSwitch = "switch-menu";
        const toggleSwitchClass = () => {
            const list = document.getElementsByClassName("common-button");
            for (let i in list) {
                const elem = list[i];
                if (elem.classList !== undefined)
                    elem.classList.toggle(classSwitch);
            }
        }
        toggleSwitchClass();

        const link = evt.target.dataset.redirect;
        setTimeout(() => {
            toggleSwitchClass();
            pagesManager.changePage(link);
        },500);
    };

    this.switchStatus = () => {
      if (this.level.status === 0) {
            this.playMusic();
            infoLevelEditor.innerText = "";
            const p = infoLevelEditor.addElement("p", {class: "common-text"});
            p.textContent = "Chargement de la musique...";
            const inter = setInterval(() => {
                if (0 !== getSongTime()) {
                    clearInterval(inter);
                    infoLevelEditor.innerText = "";
                    const p = infoLevelEditor.addElement("p", {class: "common-text"});
                    p.textContent = "Enregistrement des touches...";
                    this.level.status = 1;
                    this.level.sequence = [];
                }
            },1000);
        }
    };

    this.changeSelectedMusic = (evt) => {
        this.level.song = musicSelector.options[evt.target.selectedIndex].value;
    };

    this.resetKey = () => {
        infoLevelEditor.innerText = "";
        const btn = infoLevelEditor.addElement("button", {class: "common-button texture wood"});
        btn.onclick = _this.switchStatus;
        btn.textContent = "Recommencer";
        this.level.status = 0;
        song.pause();
        currentSong = "";
    }

    this.playMusic = () => {
        if (this.level.song !== "") {
            if (currentSong !== "../"+this.level.song) {
                const playbackRate = song.playbackRate;
                song.src = "../"+this.level.song;
                currentSong = "../"+this.level.song;
                song.playbackRate = playbackRate;
            }
            if (timeSong !== undefined) {
                const inter = setInterval(() => {
                    if (currentSongTime === getSongTime() && 0 !== getSongTime()) {
                        clearInterval(inter);
                        infoLevelEditor.innerText = "";
                        const btn = infoLevelEditor.addElement("button", {class: "common-button texture wood"});
                        btn.onclick = _this.switchStatus;
                        btn.textContent = "Recommencer";
                        this.level.status = 0;
                    }
                    currentSongTime = getSongTime();
                    let minTime = (currentSongTime/60000 < 10 ? "0" : "") + Math.round(currentSongTime/60000),
                        secTime = (currentSongTime%60000 < 10 ? "0" : "") + Math.round((currentSongTime%60000)/1000);
                    timeSong.textContent = "Temps: "+ minTime+":"+secTime;
                },1000);
            }
            songControl.onclick = this.pauseMusic;
            songControl.src = "../images/textures/pause.png"
            song.play();
        }
    };

    this.pauseMusic = () => {
        if (this.level.song !== "") {
            songControl.onclick = this.playMusic;
            songControl.src = "../images/textures/play.png"
            song.pause();
        }
    };

    this.sendLevel = () => {
        // Send it to server
        _this.level.name = levelName.value;
        if (_this.level.sequence !== [] && levelName.value !== "") {
            pagesManager.loadView("home");
        } else {
            alert("Erreur");
        }
    };

    //functions
    function applyUserOptions(userOptions = false){
        var oldUserOptions = getUserOptions();
        if(!userOptions){//bricolage de first load
            userOptions = oldUserOptions;
            oldUserOptions = {};
        }
        
        //apply
        if((oldUserOptions.leavesAnimation != userOptions.leavesAnimation)){
            if(userOptions.leavesAnimation){//yes
                generateLeaves(leaves);
            }else{//no
                leaves.removeChilds();
            }
        }
        //store
        Cookies.set("userOptions", JSON.stringify(userOptions));
    }
    function getUserOptions(){
        var userOptionsStr = Cookies.get("userOptions");
        if(userOptionsStr){
            console.log(userOptionsStr);
            return JSON.parse(userOptionsStr);
        }
        return{ //default
            leavesAnimation: true
        }
    }
    function generateLeaves(container){
        for (let i=0;i<window.innerWidth/8;i++) {
            let delay = Math.random() * 15;
            let leaf = container.addElement("i", {style: `animation-delay: ${delay}s`});
        }
    }
}