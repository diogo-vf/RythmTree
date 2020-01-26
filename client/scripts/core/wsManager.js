function WebsocketManager(){
    var _this = this;
    var MAX_RECONNECTIONS = 4;
    this.status = "new" //new, open, reconnecting, closed
    this.connectionId = false;
    var connection = false;
    var awaitingResponses = {};
    //reconnection
    var reconnectionAttemps = 0;
    var reconnectionInfoBox = false;
    function init(){
        connection = new WebSocket(config.websocketLocation);
        connection.addEventListener("open", () => {
            console.log("websocket connection opened");
            if(_this.status == "reconnecting"){
                reconnectionInfoBox.remove();
                reconnectionInfoBox = false;
                reconnectionAttemps = 0; //reset
            }
            _this.status = "open";
        });
        connection.addEventListener("close", async () => {
            console.log("websocket connection lost, retrying...");
            if(!reconnectionInfoBox){
                reconnectionInfoBox = Utils.infoBox("server connection lost, reconnecting...", Infinity);
            }
            _this.status = "reconnecting";
            reconnectionAttemps++;
            console.log({reconnectionAttemps});
            if(reconnectionAttemps > MAX_RECONNECTIONS){
                console.log("aborting reconnection");
                reconnectionInfoBox.remove();
                Utils.infoBox("Couldn't reconnect. Refresh the page to try again.");
                return;
            }
            await async_setTimeout(500);
            init();
        })
    }
    init();
}