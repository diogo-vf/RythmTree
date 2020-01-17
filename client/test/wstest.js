// var ws2 = new WebSocket(`ws://localhost:2345/websocket2`);
// console.log(ws2);
// ws2.onopen = function(ev){
//     console.log("opened2");
//     //alert("opened!2");
//     sendMsg("reset :)");
// }
// ws2.onmessage = function(evt){
//     console.log("msg2", evt);
// }
function sendMsg(msg){
    ws2.send(msg);
}

//var ws = new WebSocket(`ws://${location.host}/websocket`);
var ws = new WebSocket(`ws://localhost:5678/websocket`);
console.log(ws);
ws.onopen = function(ev){
    console.log("opened");
    alert("opened!");
}
ws.onmessage = function(evt){
    console.log("msg", evt);
}