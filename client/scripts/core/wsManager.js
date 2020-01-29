function WebsocketManager() {
    var _this = this;
    var MAX_RECONNECTIONS = 4;
    this.status = "new" //new, open, reconnecting, closed
    this.connectionId = false;
    var connection = false;
    var awaitingResponse = {};
    //reconnection
    var reconnectionAttemps = 0;
    var reconnectionInfoBox = false;
    function init() {
        connection = new WebSocket(config.websocketLocation);
        connection.addEventListener("open", () => {
            console.log("websocket connection opened");
            if (_this.status == "reconnecting") {
                reconnectionInfoBox.remove();
                reconnectionInfoBox = false;
                reconnectionAttemps = 0; //reset
            }
            _this.status = "open";
        });
        connection.addEventListener("close", async () => {
            console.log("websocket connection lost, retrying...");
            if (!reconnectionInfoBox) {
                reconnectionInfoBox = Utils.infoBox("server connection lost, reconnecting...", Infinity);
            }
            _this.status = "reconnecting";
            reconnectionAttemps++;
            console.log({ reconnectionAttemps });
            if (reconnectionAttemps > MAX_RECONNECTIONS) {
                console.log("aborting reconnection");
                reconnectionInfoBox.remove();
                Utils.infoBox("Couldn't reconnect. Refresh the page to try again.", Infinity);
                return;
            }
            await async_setTimeout(500);
            init();
        });
        connection.addEventListener("message", function (evt) {
            var response = JSON.parse(evt.data);
            console.log("onmessage", response);
            if (response.action = "respond" && response.requestId) {
                awaitingResponse[response.requestId](response.data);
                delete awaitingResponse[response.requestId];
            }
        });
    }
    this.sendMsg = async function(action, data = false, waitForResponse = false){ //if callback then awaits response
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
        console.log("send message", msgObject);
        connection.send(JSON.stringify(msgObject));
    
        if(waitForResponse) 
            return await promise;
        return
    }
    this.sendRequest = async function(action, data = false){
        return await _this.sendMsg(action, data, true);
    }
    init();
}