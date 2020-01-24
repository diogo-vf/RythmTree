function Adapters(){
	//adapter for when there is no data to display.
	this.noData = function(container, data){
		var box = container.addElement("div", {class:"noDataContainer"});
		var text = box.addElement("p");
		text.innerText = config.messageNoData;
		return box;
	};

	//level
	this.levelAdapter = function(container, data) {
		var box = container.addElement("div", {class:"level"});//example
		box.textContent = data.name;
		return box;
	}
}