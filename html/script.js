window.addEventListener('message', function(event) {
    let data = event.data;

    // 1. PŘEPÍNÁNÍ VIDITELNOSTI (Příkaz /hud a Cinematic mode)
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

    // 2. AKTUALIZACE DAT
    if (data.type === "updateHUD") {
        // Skrytí HUDu v pauze (ESC menu)
        document.body.style.display = data.isPaused ? "none" : "block";

        // LOGO SERVERU
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

        // STATUSY VLEVO (Obvod 113.1 pro R=18 zůstává)
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

        // ============================================================
        // TACHOMETR (VPRAVO DOLE) - NOVÉ OBVODY PRO VELKÉ KROUŽKY
        // ============================================================
        const speedHud = document.getElementById("stat-speed");
        if (data.inVehicle) {
            speedHud.style.display = "flex";
            document.getElementById("speed-val").innerText = Math.floor(data.speed);

            // Rychlost: Max 240 KM/H, Obvod 295.3 (pro nové R=47)
            let speedPercent = Math.min((data.speed / 240) * 100, 100);
            updateStat("speed", speedPercent, 295.3);
            
            // Palivo: Obvod 238.7 (pro nové R=38)
            if (data.fuel !== undefined) {
                updateStat("fuel", data.fuel, 238.7);
                
                const fuelIcon = document.getElementById("fuel-icon");
                const fuelBar = document.getElementById("bar-fuel");

                if (data.fuel <= 20) {
                    if (fuelIcon) fuelIcon.classList.add("fuel-low");
                    if (fuelBar) fuelBar.style.stroke = "#ff4747";
                } else {
                    if (fuelIcon) fuelIcon.classList.remove("fuel-low");
                    if (fuelBar) fuelBar.style.stroke = "#f1c40f";
                }
            }

            if (data.colors && data.colors.speed) {
                document.getElementById("bar-speed").style.stroke = data.colors.speed;
            }
        } else {
            speedHud.style.display = "none";
        }

        // OSTATNÍ PODMÍNKY ZOBRAZENÍ
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

/**
 * Univerzální funkce pro aktualizaci kruhového progress baru
 */
function updateStat(id, percent, circumference) {
    const bar = document.getElementById(`bar-${id}`);
    if (!bar) return;
    
    // Nastavení dasharray, aby odpovídalo geometrii v HTML/CSS
    bar.style.strokeDasharray = circumference;
    
    // Výpočet offsetu (kolik z obvodu se má "skrýt")
    const offset = circumference - (percent / 100) * circumference;
    bar.style.strokeDashoffset = offset;
}