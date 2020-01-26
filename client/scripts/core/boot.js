//constants


//memory
var globalMemory = {};
var elements = {};

//instanciate managers
var pagesManager = new PagesManager();
var wsManager = new WebsocketManager();
var builder = new Builder();
var adapters = new Adapters();
var actions = new Actions();
var dataSources = new DataSources();

document.addEventListener("DOMContentLoaded", function(domEvt){
	actions.onBeforeBoot();
	
	//elements
	elements.pagesContainer = document.querySelector(config.pagesContainerSelector);
	elements.globalLoader = false;
	
	//manage landing page
	pagesManager.manageLanding();
	
	//load views
	if(config.preloadAllViews){
		pagesManager.preloadViews();
	}

	//popstate event for history manipulation
	window.addEventListener("popstate", pagesManager.managePopState);

	actions.onAfterBoot();
});