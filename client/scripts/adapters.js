function Adapters(){
	this.myDataAdapter = function(container, data){
		var elem = container.addElement("p");
		elem.innerText = data.text;
        return elem;
    }
    
	//adapter for when there is no data to display.
	this.noData = function(container, data){
		var box = container.addElement("div", "noDataContainer");
		var text = box.addElement("p");
		text.innerText = config.messageNoData;
		return box;
	};
}