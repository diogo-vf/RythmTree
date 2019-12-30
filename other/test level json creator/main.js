"use strict";
var isRunning = false;
var resumeTimeStamp = 0;
var lastFrameStamp = 0;

var sequence = [];
var startTimeStamp = 0;

var currentKeys = {};

document.addEventListener("DOMContentLoaded", boot);
function boot(){
    console.log("boot");
    //EVENTS
    //keys
    document.body.addEventListener("keydown", keyDown);
    document.body.addEventListener("keyup", keyUp);
    //btns
    startBtn.addEventListener("click", start);
    pauseBtn.addEventListener("click", pause);
    resetBtn.addEventListener("click", reset);
    //draw
    draw();
}
function keyDown(evt){
    if(currentKeys[evt.keyCode] || !isRunning){
        return;
    } 
    console.log(evt);
    currentKeys[evt.keyCode] = evt;
}
function keyUp(evt){
    if(!currentKeys[evt.keyCode]){
        console.warn("no prior keydown!");
        return;
    }
    console.log(evt);
    var downEvent = currentKeys[evt.keyCode];
    //remove from currentKeys
    currentKeys[evt.keyCode] = false;

    if(!isRunning){
        return;
    }

    //add to sequence
    sequence.push({
        time: downEvent.timeStamp - startTimeStamp,
        //key: evt.keyCode,
        key: evt.key,
        duration: evt.timeStamp - downEvent.timeStamp
    });

    //display
    jsonPreview.innerText = JSON.stringify(sequence);
}
function start(evt){
    if(isRunning){
        return;
    }
    startTimeStamp = evt.timeStamp - resumeTimeStamp;
    isRunning = true;

    pauseBtn.classList.remove("none");
    startBtn.classList.add("none");
}
function pause(evt){
    console.log(evt);
    if(!isRunning){
        return;
    }
    resumeTimeStamp = evt.timeStamp - startTimeStamp;
    isRunning = false;
    startBtn.innerText = "Resume";
    pauseBtn.classList.add("none");
    startBtn.classList.remove("none");
}
function reset(evt){
    isRunning = false;
    resumeTimeStamp = 0;
    sequence = [];
    currentKeys = {};

    startBtn.innerText = "Start";
    pauseBtn.classList.add("none");
    startBtn.classList.remove("none");
    timeDisplay.innerText = "0s";
    jsonPreview.innerText = "[]"
}

function draw(timeStamp){
    //fps
    fpsDisplay.innerText = Math.round(1000/(timeStamp - lastFrameStamp)) + "fps";
    lastFrameStamp = timeStamp;
    //global time
    globalTimeDisplay.innerText = Math.floor(timeStamp/10) / 100 + "s"
    //sequenceTime
    if(isRunning){
        timeDisplay.innerText = Math.floor((timeStamp - startTimeStamp)/10)/100 + "s";
    }
    //again
    requestAnimationFrame(draw);
}