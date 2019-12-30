"use strict";
var stopDraw = false;
var isRunning = false;
var lastFrameStamp = 0;

var sequence = [];
var currentKeys = {};

var song = new Audio();
var songDuration = 0;

var rythmDisplayContext = false;

document.addEventListener("DOMContentLoaded", boot);
function boot(){
    console.log("boot");
    //elems
    rythmDisplayContext = rythmDisplay.getContext('2d');
    //EVENTS
    //audio
    song.addEventListener("ended", songEnded);
    song.addEventListener("loadeddata", songLoaded);
    selectSong("songs/music1.mp3");
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

//EVENTS
function keyDown(evt){
    if(currentKeys[evt.keyCode] || !isRunning){
        return;
    } 
    currentKeys[evt.keyCode] = {
        time: getSongTime()
    };
}
function keyUp(evt){
    if(!currentKeys[evt.keyCode]){
        console.warn("no prior keydown!");
        return;
    }
    var downObject = currentKeys[evt.keyCode];
    //remove from currentKeys
    currentKeys[evt.keyCode] = false;

    if(!isRunning){
        return;
    }

    //add to sequence
    sequence.push({
        time: downObject.time,
        //key: evt.keyCode,
        key: evt.key,
        duration: getSongTime() - downObject.time
    });

    //display
    jsonPreview.innerText = JSON.stringify(sequence);
}
function songLoaded(evt){
    songDuration = song.duration * 1000;
    timeLeftDisplay.innerText = getSecString(songDuration);
}
function songEnded(evt){
    stop();
}
//METHODS
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

    isRunning = true;
}
function pause(evt){
    if(!isRunning){
        return;
    }
    isRunning = false;

    song.pause();

    startBtn.innerText = "Resume";
    pauseBtn.classList.add("none");
    startBtn.classList.remove("none");
}
function reset(evt){
    stop(evt);
    
    //go to begining
    var playbackRate = song.playbackRate;
    song.load();
    song.playbackRate = playbackRate;

    sequence = [];
    currentKeys = {};

    jsonPreview.innerText = "[]"
}
function stop(evt){
    isRunning = false;

    song.pause();

    startBtn.innerText = "Start";
    pauseBtn.classList.add("none");
    startBtn.classList.remove("none");
}
function draw(timeStamp){
    if(stopDraw){
        return;
    }
    var timeFactor = (timeStamp - lastFrameStamp)/1000;
    //fps
    fpsDisplay.innerText = Math.round(1/timeFactor) + "fps";
    lastFrameStamp = timeStamp;
    //global time
    globalTimeDisplay.innerText = getSecString(timeStamp);

    var levelTime = getSongTime();
    //sequenceTime
    timeDisplay.innerText = getSecString(levelTime);
    //timeLeft
    timeLeftDisplay.innerText = getSecString(songDuration - levelTime);

    drawRythm(timeFactor);

    //again
    requestAnimationFrame(draw);
}
function drawRythm(timeFactor){
    var width = rythmDisplay.parentElement.clientWidth;
    var height = rythmDisplay.height;
    //size
    rythmDisplay.width = width;
    //clear
    rythmDisplayContext.clearRect(0, 0, width, height);
    //draw center
}

function getSongTime(){
    return Math.round(song.currentTime * 1000);
}

function getSecString(msTime){
    return Math.round(msTime/10)/100 + "s";
}