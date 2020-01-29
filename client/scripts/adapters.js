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
		const box = container.addElement("div", {class:"col-3 space-bottom align-center common-card wood-texture"});
		const a = box.addElement("a", {href: "/replays", class: "common-text wood center"});
		a.textContent = data.name;
		return box;
	}

	// Level Editor Adapter
	this.levelEditorAdapter = function(container, data) {
		if (!container.innerText) {
			let option = container.addElement("option");
			option.value = "";
			option.selected = true;
			option.hidden = true;
			option.disabled = true;
			option.textContent = "Choisir...";
		}
		const option = container.addElement("option"),
			minTime = (data.duration/60000 < 10 ? "0" : "") + Math.round(data.duration/60000),
			secTime = (data.duration%60000 < 10 ? "0" : "") + Math.round((data.duration%60000)/1000) + (Math.round((data.duration%60000)/1000) === 1 ? "0" : "");
		option.textContent = data.name +" - "+ minTime +":"+secTime;
		option.value = data.src;
	}
}