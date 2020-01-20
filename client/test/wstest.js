"use strict";
var awaitingResponse = {};

var ws = new WebSocket(`ws://${location.host}/websocket`);
console.log(1, ws);
ws.onopen = function(ev){
    console.log("opened 1");
}
ws.onmessage = function(evt){
    var response = JSON.parse(evt.data);
    console.log("onmessage", response);
    if(response.action = "respond" && response.requestId){
        awaitingResponse[response.requestId](response.data);
        delete awaitingResponse[response.requestId];
    }
}
async function sendMsg(action, data = false, waitForResponse = false){ //if callback then awaits response
    var msgObject = {
        action,
        data
    }
    if(waitForResponse){
        var requestId = generateUUID();
        msgObject.requestId = requestId
        var promise = new Promise(function(resolve, reject) {
            awaitingResponse[requestId] = resolve;
        });
    }
    ws.send(JSON.stringify(msgObject));
    //fakeSend(JSON.stringify(msgObject));

    if(waitForResponse) 
        return await promise;
    return
}
async function sendRequest(action, data = false){
    return await sendMsg(action, data, true);
}
async function register(userName){
    var result = await sendRequest("register", {userName});
    console.log("auth result", result);
}
function bytesSend(count){
    var str = "";
    for(var ind = 0; ind < count; ind++){
        str += "j"
    }
    ws.send(str);
}
async function fakeSend(objstr){
    var obj = JSON.parse(objstr);
    await async_setTimeout(500);
    console.log("[server] on message", obj);
    await async_setTimeout(500);
    ws.onmessage({ data: JSON.stringify({requestId: obj.requestId, data:{connectionId: "12344321", player:{id: "717171", userName: obj.userName}}})});
}
//2
if(false){
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
}
