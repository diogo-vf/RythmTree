"use strict";
var stopDraw = false;
var isRunning = false;
var lastFrameStamp = 0;

var sequence = [];
var currentKeys = {};

var song = new Audio();
var currentSong = false;
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
    selectSong(songs[0]);
    //keys
    document.body.addEventListener("keydown", keyDown);
    document.body.addEventListener("keyup", keyUp);
    //btns
    startBtn.addEventListener("click", start);
    pauseBtn.addEventListener("click", pause);
    resetBtn.addEventListener("click", reset);
    songs.forEach(function(aSong){
        var btn = songSelectorsContainer.addElement("button");
        btn.innerText = aSong.name;
        btn.addEventListener("click", function(evt){
            selectSong(aSong);
        })
    });
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
function selectSong(theSong){
    var playbackRate = song.playbackRate;
    song.src = theSong.src;
    song.playbackRate = playbackRate;
    currentSong = theSong;
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
var drawConsts = {
    CENTER_LINE_WIDTH: 4,
    CENTER_LINE_COLOR: "black",
    CENTER_LINE_WIDTH_VARIATION: 4,
    SCROLL_SPEED: 300,
    SCROLL_LINES_WIDTH: 3
};
var drawParams = {
    centerLineWidth: drawConsts.CENTER_LINE_WIDTH
}
function drawRythm(timeFactor){
    var width = rythmDisplay.clientWidth;
    var height = rythmDisplay.clientHeight;
    //size(resize)
    if(rythmDisplay.width!=width){
        console.log("rythmDisplay width changed");
        rythmDisplay.width = width;
    }
    if(rythmDisplay.height!=height){
        console.log("rythmDisplay height changed");
        rythmDisplay.height = height;
    }
    //clear
    rythmDisplayContext.clear();
    //draw center
    rythmDisplayContext.rect(
        [(width - drawParams.centerLineWidth)/2, 0, drawParams.centerLineWidth, height], 
        drawConsts.CENTER_LINE_COLOR
    );

    //draw rythm lines
    var bps = currentSong.bpm / 60;
    var lineSpacing = drawConsts.SCROLL_SPEED / bps;
    var songTime = getSongTime();
    var rythmScale = 1000/bps;
    var lineCount = Math.ceil(width/lineSpacing);
    var measureIndex = Math.floor(songTime / rythmScale);
    var leftOffset = 
        (width/2)
        - (((measureIndex < (lineCount/2))?measureIndex:Math.floor(lineCount/2))/**/ * lineSpacing)
        + ((currentSong.start_offset/rythmScale) * lineSpacing)
        - ((songTime % rythmScale)/rythmScale * lineSpacing);
    for(var ind = 0; ind < (lineCount); ind++){
        rythmDisplayContext.rect(
            [leftOffset + ind*lineSpacing, 0, drawConsts.SCROLL_LINES_WIDTH, height],
            "grey"
        );
    }
}

function getSongTime(){
    return Math.round(song.currentTime * 1000);
}

function getSecString(msTime){
    return Math.round(msTime/10)/100 + "s";
}