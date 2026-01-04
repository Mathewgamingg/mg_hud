Config = {}
Config.Framework = 'esx' -- esx, qb
Config.UpdateTick = 200
Config.ServerLogoURL = "https://cdn.discordapp.com/avatars/324539170188165120/996db60a903bfabd95fc49cab69cd9eb.webp?size=1024"
Config.EnableStress = false

Config.Locales = {
    ['hunger_notif'] = "Máš velký hlad, měl by ses najíst!",
    ['thirst_notif'] = "Máš velkou žízeň, měl by ses napít!",
    ['stress_notif'] = "Cítíš se pod velkým tlakem, měl bys zvolnit!", -- Pro budoucí využití
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
    ['id'] = "#ffffff",
    ['speed'] = "#ffa500"
}

Config.Thresholds = {
    hp = 20,
    hunger = 15,
    water = 15
}