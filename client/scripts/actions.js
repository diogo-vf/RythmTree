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
        document.body.removeEventListener("keydown", keyDown);
        document.body.removeEventListener("keyup", keyUp);
        document.body.addEventListener("keydown", keyDown);
        document.body.addEventListener("keyup", keyUp);
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
        if (song) {
            song.pause();
            currentSong = "";
        }
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
    };

    this.playMusic = () => {
        if (this.level.song !== "") {
            if (currentSong !== "../"+this.level.song) {
                const playbackRate = song.playbackRate;
                song.src = "../"+this.level.song;
                currentSong = "../"+this.level.song;
                song.playbackRate = playbackRate;
            }
            if (window.timeSong) {
                const inter = setInterval(() => {
                    if (currentSongTime === getSongTime() && 0 !== getSongTime()) {
                        clearInterval(inter);
                        infoLevelEditor.innerText = "";
                        const btn = infoLevelEditor.addElement("button", {class: "common-button texture wood"});
                        btn.onclick = _this.switchStatus;
                        btn.textContent = "Recommencer";
                        this.level.status = 0;
                    }
                    currentSongTime = Math.floor(getSongTime()/1000);
                    let minTime = (currentSongTime/60 < 10 ? "0" : "") + Math.floor(currentSongTime/60),
                        secTime = (currentSongTime%60 < 10 ? "0" : "") + Math.floor(currentSongTime%60);
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