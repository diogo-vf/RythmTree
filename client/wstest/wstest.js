var ws2 = new WebSocket(`ws://localhost:2345/websocket2`);
console.log(2, ws2);
ws2.onopen = function(ev){
    console.log("opened 2");
    //alert("opened! 2");
}
ws2.onmessage = function(evt){
    console.log("msg 2", evt);
}
function sendMsg2(msg){
    ws2.send(msg);
}

//var ws = new WebSocket(`ws://${location.host}/websocket`);
var ws = new WebSocket(`ws://localhost:5678/websocket`);
console.log(1, ws);
ws.onopen = function(ev){
    console.log("opened 1");
    //alert("opened! 1");
}
ws.onmessage = function(evt){
    console.log("msg 1", evt);
}
function sendMsg(msg){
    ws.send(msg);
}