//constants


//memory
var globalMemory = {};
var elements = {};

//instanciate managers
var pagesManager = new PagesManager();
var apiManager = new ApiManager();
var builder = new Builder();
var adapters = new Adapters();
var actions = new Actions();
var dataSources = new DataSources();

document.addEventListener("DOMContentLoaded", function(domEvt){
	//elements
	elements.pagesContainer = document.getElementById("pagesContainer");
	elements.globalLoader = false;

	//other init

	
	//manage landing page
	pagesManager.manageLanding();
	
	//load views
	pagesManager.preloadViews();

	//popstate event for history manipulation
	window.addEventListener("popstate", pagesManager.managePopState);

	console.log("init completed");
});