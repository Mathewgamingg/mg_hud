Config = {}
Config.Framework = 'esx' -- esx, qb
Config.UpdateTick = 250 -- Jak často se HUD aktualizuje (v ms)
Config.ServerLogoURL = "https://cdn.discordapp.com/attachments/1428438518459400214/1457491334159138940/mathew-logo-final.png?ex=695c3214&is=695ae094&hm=486c568162d71674823f8692f02ea7e5b334611d24454c076bb74134d183945d&"
Config.EnableStress = false

Config.Locales = {
    ['hunger_notif'] = "Máš velký hlad, měl by ses najíst!",
    ['thirst_notif'] = "Máš velkou žízeň, měl by ses napít!",
    ['stress_notif'] = "Cítíš se pod velkým tlakem, měl bys zvolnit!",
}

Config.NotificationType = "error"
Config.NotificationTime = 5000

Config.LogoPosition = {
    top = "20px",
    right = "20px",
    bottom = "auto",
    left = "auto",
    width = "120px"
}

Config.Colors = {
    ['hp'] = "#ff4747",
    ['armor'] = "#3498db",
    ['hunger'] = "#e67e22",
    ['water'] = "#2ecc71",
    ['stamina'] = "#f1c40f",
    ['stress'] = "#9b59b6",
    ['oxygen'] = "#1abc9c",
    ['voice'] = "#ffffff",
    ['voiceTalking'] = "#049edaff",
    ['id'] = "#ffffff"
}

Config.Thresholds = {
    hp = 20,
    hunger = 15,
    water = 15
}