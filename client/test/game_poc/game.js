document.addEventListener("DOMContentLoaded", (evt) => {
    var game = new Game();
});
class Game {
    constructor(){
        this.draw();
    }
    draw(frameTime) {
        console.log(frameTime);
        requestAnimationFrame(this.draw);
    }
}
