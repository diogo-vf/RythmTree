Element.prototype.addElement = function(type = "div", attributes = []){
    var elem = document.createElement(type);
    this.appendChild(elem);
    for(var indAttr in attributes){
        elem.setAttribute(indAttr, attributes[indAttr]);
    }
    return elem;
};