"use strict";
function PagesManager(){
    var _this = this;
    this.pages = {};
    this.currentPage = false;
    var viewsCache = {};
    this.changePage = function(pageName, {pushToHistory=true, query=false, path=false} = {}){
        console.log("change page to " + pageName, arguments[1]);
		
        //page already displayed
        if(_this.currentPage == pageName){
            console.log("page already shown");
            return;
        }

        //page doesnt exist
        if(!pagesConfig[pageName]){
            globalMemory.error = {
                code: "404",
                msg: "Page not found"
            }
            _this.changePage("error");
            return;
        }
		
		//page config
		var pageConfig = pagesConfig[pageName];

        //page not built
        if(!_this.pages[pageName]){
            _this.pages[pageName] = {
                isLoaded: false,
                container: false,
                data: {},
                memory: {}
            };
            //build container
            _this.pages[pageName].container = elements.pagesContainer.addElement('div', `pageContainer ${pageName}PageContainer none`);
        }

        //display page
        if(_this.currentPage){
            _this.pages[_this.currentPage].container.classList.add('none');
        }
        _this.pages[pageName].container.classList.remove('none');
        _this.currentPage = pageName;

		//query
		var queryUrl = "";
		if(query){
			queryUrl = "?" + utils.encodeQuery(query);	
		}
        
        //path
        var pathUrl = `/${pageName}`;
        if(path){
            for(var indPath=0; indPath < path.length; indPath++){
                queryUrl += `/${path[indPath]}`
            }
        }
        
		//title
		var documentTitle = config.pageTitlePrefix + (pageConfig.title || pageName);
        document.title = documentTitle;

        //location
        var stateSaveObject = {pageName, query, path};
        _this.pages[_this.currentPage].location = stateSaveObject;

        //push to history
        if(pushToHistory){
            history.pushState(stateSaveObject, documentTitle, pathUrl + queryUrl);
        } else {
            history.replaceState(stateSaveObject, documentTitle, pathUrl + queryUrl);
        }

        //any page display action
        actions.onAnyPageDisplay({pageName, pageConfig});

        //already loaded
        if(this.pages[pageName].isLoaded){
			if(pageConfig.refreshDataOnDisplay){ //reload data
                _this.manageData(pageName);
			}
            if(actions.onPageDisplay[pageName]){
                actions.onPageDisplay[pageName]();
            }
            return;
        }

        //page not loaded -> load page
        //show loader
        utils.getGlobalLoader().show();
        //load view
        _this.loadView(pageName, function(error, view){
            utils.getGlobalLoader().hide();
            if(error){
                console.warn("view couldn't be loaded.", error);
                utils.infoBox(config.messageErrorPageLoad);
                return;
            }
            //view ref
            _this.pages[pageName].view = view;
            //set content
            _this.pages[pageName].container.innerHTML = view.htmlString;
            //loaded
            _this.pages[pageName].isLoaded = true;
			//add dynamic links
			utils.setDynamicLinks(_this.pages[pageName].container);
			//apply data / show data
			_this.manageData(pageName);
            //evt
            if(actions.onPageLoad[pageName]){
                actions.onPageLoad[pageName]();
            }
            if(actions.onPageDisplay[pageName]){
                actions.onPageDisplay[pageName]();
            }
        });
    }

    this.manageLanding = function(){
        var pageToShow = config.landingPage;
        var pageOptions = {};
        pageOptions.pushToHistory = false;

        if(window.location.pathname != "/"){
            var fullPathArray = window.location.pathname.split("/");

            //page to show
            pageToShow = fullPathArray[1]; //only gets fist path entry, so the page name

            //path
            pageOptions.path = fullPathArray.slice(2); //only get the path after the page name
        }

        //search
        if(window.location.search){
            pageOptions.query = utils.decodeQuery(window.location.search);
        }

        //display page
        pagesManager.changePage(pageToShow, pageOptions);
    };
    this.managePopState = function(evt){
        if(!evt.state || !evt.state.pageName){
            console.warn("no pop state defined");
            return;
        }
        var pageOptions = evt.state;
        pageOptions.pushToHistory = false;
        pagesManager.changePage(evt.state.pageName, pageOptions);		
    };
    this.manageData = function(pageName){
		if(!pagesConfig[pageName] || !pagesConfig[pageName].data){
			return;
		}
		var allDataConfigs = pagesConfig[pageName].data;
		for(var indDataConfig = 0; indDataConfig < allDataConfigs.length; indDataConfig++){
            var dataConfig = allDataConfigs[indDataConfig];
            _this.applyDataConfig(dataConfig, pageName);
		}
    };
    this.applyDataConfig = function(dataConfig, pageName){
        //data source
        if(!dataSources[dataConfig.source]){
			console.warn(`data source ${dataConfig.source} doesn't exist`);
			return;
		}
        var dataSource = dataSources[dataConfig.source];

        //data adapter check
        var adapter = false;
        var adaptersContainer = false;
        if(adapters[dataConfig.adapter]){
            adapter = adapters[dataConfig.adapter];
            adaptersContainer = _this.pages[pageName].container.querySelector(dataConfig.container);
            if(!adaptersContainer){
                console.warn(`data container for ${dataConfig.container} selector, doesn't exist`);
                return;
            }
            //remove all content from container
            while(adaptersContainer.firstChild) {
                adaptersContainer.removeChild(adaptersContainer.firstChild);
            }
            //add loader
            var contentLoader = builder.addContentLoader(adaptersContainer);
        }

        //data name + data reset
        var dataName = false;
        if(dataConfig.dataName){
            dataName = dataConfig.dataName;
            //clear data
            _this.pages[pageName].data[dataName] = false;
        }

        //data params (path template)
        var dataParams = false;
        if(dataConfig.pathTemplate){
            dataParams = {};

            //extract param name and values from url
            var pathEntities = dataConfig.pathTemplate.split("/").slice(1);
            var pathArray = _this.pages[pageName].location.path;
            for (let indPath = 0; indPath < pathEntities.length; indPath++) {
                var templateEntity = pathEntities[indPath];
                var paramValue = pathArray[indPath];
                if(!pathArray[indPath]){
                    console.warn("missing parameter in url");
                    return;
                }
                if(!templateEntity.includes("{{") || !templateEntity.includes("}}")){
                    //template doesn't correspond to url
                    if(templateEntity !== paramValue){
                        console.warn("url path doesnt apply to template. aborting.", {templateEntity, paramValue});
                        return;
                    }
                    continue;
                }
                //extract param name and set value
                var paramName = templateEntity.split("{{")[1].split("}}")[0];
                dataParams[paramName] = paramValue;
            }
        }

        dataSource(dataParams)
		.then(function(data){
            if(adapter){ //adapter data
                builder.applyDataAdapter({
                    container: adaptersContainer, 
                    adapter, data, contentLoader
                });
            }
            //get dataName
            if(dataName){
                //add to page data
                _this.pages[pageName].data[dataName] = data;
            }
            //onData callBack
            if(actions.onPageData[pageName]){
                actions.onPageData[pageName](data, dataName);
            }
        });
        
    };

    this.refreshCurrentPage = function(){
		_this.manageData(_this.currentPage);
	};
	this.preloadViews = async function(priority = false){
        //load priority view
        if(priority){ 
            await new Promise(resolve => {
                _this.loadView(priority, resolve)
            });
        }
        //load other views
        for(var viewName in pagesConfig){
            _this.loadView(viewName, function(){});
        }
    }
    this.loadView = async function(view, callBack){
        //get view name from page config
        var viewName = view;
        if(pagesConfig[view].view){
            viewName = pagesConfig[view].view;
        }
        //check load state
        if(!viewsCache[viewName]){
            viewsCache[viewName] = {
                isLoading: false,
                isLoaded: false,
                onload: [],
                htmlString: false                
            }
        }
        if(viewsCache[viewName].isLoaded){
            console.log("page already loaded");
            callBack(false, viewsCache[viewName]);
            return;
        }
        viewsCache[viewName].onload.push(callBack);
        if(viewsCache[viewName].isLoading){
            //DEBUG: console.log("page already loading");
            return;
        }

        //load
        viewsCache[viewName].isLoading = true;
        var url = `${config.viewsLocation}/${viewName}${config.viewsExtension}`;
        
        var response = await fetch(url);
        viewsCache[viewName].isLoading = false;
        if(!response.ok){
            //DEBUG: console.warn("view download failed", response);

            //onload event
            for(var indEvt = 0; indEvt < viewsCache[viewName].onload.length; indEvt++){
                viewsCache[viewName].onload[indEvt]({clientMsg:"view download failed"});
            }
            viewsCache[viewName].onload = [];
            return;
        }
        
        var textData = await response.text();
        viewsCache[viewName].htmlString = textData;
        viewsCache[viewName].isLoaded = true;

        //onload event
        for(var indEvt = 0; indEvt < viewsCache[viewName].onload.length; indEvt++){
            viewsCache[viewName].onload[indEvt](false, viewsCache[viewName]);
        }
        viewsCache[viewName].onload = [];
        return;
    };
}