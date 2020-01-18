Element.prototype.addElement = function(type = "div", attributes = {}){
    var elem = document.createElement(type);
    this.appendChild(elem);
    for(var indAttr in attributes){
        elem.setAttribute(indAttr, attributes[indAttr]);
    }
    //special attributes (setters/other)
    if(attributes._innerText) elem.innerText = attributes._innerText;
    if(attributes._innerHTML) elem.innerHTML = attributes._innerHTML;
    
    return elem;
};
CanvasRenderingContext2D.prototype.clear = function(){
    this.clearRect(0, 0, this.canvas.width, this.canvas.height);
}
CanvasRenderingContext2D.prototype.rect = function(rect, style = ""){
    this.fillStyle = style;
    this.fillRect(...rect);
}