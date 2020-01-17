"use strict";
function DataSources(){
	this.allData = async function(){
		return await apiManager.getData("data");
	}
}