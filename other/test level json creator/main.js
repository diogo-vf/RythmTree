"use strict";
var isRunning = false;
var resumeTimeStamp = 0;
var lastFrameStamp = 0;

var sequence = [];
var startTimeStamp = 0;
var currentKeys = {};

var song = new Audio();
var songDuration = 0;

document.addEventListener("DOMContentLoaded", boot);
function boot(){
    console.log("boot");
    //EVENTS
    //audio
    song.addEventListener("ended", stop);
    song.addEventListener("loadeddata", songLoaded);
    selectSong("songs/music2.mp3");
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
    currentKeys[evt.keyCode] = evt;
}
function keyUp(evt){
    if(!currentKeys[evt.keyCode]){
        console.warn("no prior keydown!");
        return;
    }
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
function songLoaded(evt){
    songDuration = song.duration * 1000;
    timeLeftDisplay.innerText = getSecString(songDuration);
}
function selectSong(songName){
    var playbackRate = song.playbackRate;
    song.src = songName;
    song.playbackRate = playbackRate;
    reset();
}
function selectSpeed(speed){
    song.playbackRate = speed;
}
async function start(evt){
    if(isRunning){
        return;
    }

    pauseBtn.classList.remove("none");
    startBtn.classList.add("none");

    await song.play();

    startTimeStamp = evt.timeStamp - resumeTimeStamp;
    isRunning = true;
}
function pause(evt){
    if(!isRunning){
        return;
    }
    resumeTimeStamp = evt.timeStamp - startTimeStamp;
    isRunning = false;

    song.pause();

    startBtn.innerText = "Resume";
    pauseBtn.classList.add("none");
    startBtn.classList.remove("none");
}
function reset(evt){
    stop(evt);

    resumeTimeStamp = 0;
    sequence = [];
    currentKeys = {};

    timeDisplay.innerText = "0s";
    jsonPreview.innerText = "[]"
    timeLeftDisplay.innerText = getSecString(songDuration);
}
function stop(evt){
    isRunning = false;

    song.pause();
    song.fastSeek(0);

    startBtn.innerText = "Start";
    pauseBtn.classList.add("none");
    startBtn.classList.remove("none");
}
function draw(timeStamp){
    //fps
    fpsDisplay.innerText = Math.round(1000/(timeStamp - lastFrameStamp)) + "fps";
    lastFrameStamp = timeStamp;
    //global time
    globalTimeDisplay.innerText = getSecString(timeStamp);

    if(isRunning){
        var levelTime = timeStamp - startTimeStamp;
        //sequenceTime
        timeDisplay.innerText = getSecString(levelTime);
        //timeLeft
        var timeLeft = songDuration - levelTime;
        timeLeftDisplay.innerText = getSecString((timeLeft > 0)?timeLeft:0);
    }
    //again
    requestAnimationFrame(draw);
}

function getSecString(msTime){
    return Math.floor(msTime/10)/100 + "s";
}