function Actions(){
    var _this = this;

    //-------------------------------------------------------------------------------------
    //page actions on load
    //-------------------------------------------------------------------------------------
    this.onPageLoad = {};
    this.onPageLoad.welcome = function(){};
    this.onPageLoad.login = function(){
        loginForm.addEventListener("submit", async function(){
            //login
            utils.getGlobalLoader().show({withBackground:true});
            console.log("login! (fake)");
            pagesManager.loadView("home");
            await async_setTimeout(1000);
            console.log("logged in! (fake)");
            utils.getGlobalLoader().hide();
            pagesManager.changePage("home");
        });
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
    
    //page action on ANY page display
    this.onAnyPageDisplay = function({pageName = false, pageConfig = false}){
        pageNameDisplay.innerText = (pageConfig.pageName || "");
    }

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
        utils.setDynamicLinks(document.body); //dynamic links on layout
        console.log("server whitelist to copy:", `[nil, "", "${Object.keys(pagesConfig).join('", "')}"]`);
    }
    this.onAfterBoot = function(){
        for(var ind in pagesConfig){
            var link = testTopMenu.addElement("a");
            var btn = link.addElement("button");
            btn.innerText = ind;
            link.href = `/${ind}`;
        }
        for (let i=0;i<window.innerWidth/8;i++) {
            leaves.addElement("i");
        }
        utils.setDynamicLinks(testTopMenu);
	    console.log("init completed");
    }
}