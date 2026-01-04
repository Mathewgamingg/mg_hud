window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.type === "toggleHUD") {
        const hud = document.getElementById("hud-container");
        const logo = document.getElementById("server-info");
        const cTop = document.getElementById("cinematic-top");
        const cBottom = document.getElementById("cinematic-bottom");

        if (data.show) {
            hud.style.display = "flex";
            if (logo) logo.style.display = "block";
            cTop.style.height = "0%";
            cBottom.style.height = "0%";
        } else {
            hud.style.display = "none";
            if (logo) logo.style.display = "none";
            cTop.style.height = "12%";
            cBottom.style.height = "12%";
        }
        return;
    }

    if (data.type === "updateHUD") {
        document.body.style.display = data.isPaused ? "none" : "block";

        const logoImg = document.getElementById("server-logo");
        const logoCont = document.getElementById("server-info");
        if (data.logoURL && logoImg) {
            if (logoImg.src !== data.logoURL) logoImg.src = data.logoURL;
            logoImg.style.display = "block";
            logoCont.style.display = "block";
            
            if (data.logoPos) {
                logoCont.style.top = data.logoPos.top;
                logoCont.style.right = data.logoPos.right;
                logoCont.style.bottom = data.logoPos.bottom;
                logoCont.style.left = data.logoPos.left;
                logoImg.style.width = data.logoPos.width;
            }
        }

        const stats = ["hp", "armor", "hunger", "water", "stamina", "stress", "oxygen", "voice", "id"];
        stats.forEach(stat => {
            let val = (stat === "voice") ? data.voiceLevel : (stat === "id") ? 100 : data[stat];
            updateStat(stat, val, 113.1);
            
            const bar = document.getElementById(`bar-${stat}`);
            if (bar && data.colors && data.colors[stat]) {
                if (stat === "voice" && data.isTalking) {
                    bar.style.stroke = "#ffffff";
                    bar.style.filter = "drop-shadow(0 0 3px #fff)";
                } else {
                    bar.style.stroke = data.colors[stat];
                    bar.style.filter = "none";
                }
            }
        });

        if (document.getElementById("player-id-text")) {
            document.getElementById("player-id-text").innerText = data.playerId;
        }

        if (document.getElementById("stat-armor")) 
            document.getElementById("stat-armor").style.display = (data.armor > 0) ? "flex" : "none";
        
        if (document.getElementById("stat-oxygen"))
            document.getElementById("stat-oxygen").style.display = (data.inWater) ? "flex" : "none";
        
        if (document.getElementById("stat-stress"))
            document.getElementById("stat-stress").style.display = (data.enableStress && data.stress > 0) ? "flex" : "none";
    }
});

function updateStat(id, percent, circumference) {
    const bar = document.getElementById(`bar-${id}`);
    if (!bar) return;
    
    bar.style.strokeDasharray = circumference;
    const offset = circumference - (percent / 100) * circumference;
    bar.style.strokeDashoffset = offset;
}