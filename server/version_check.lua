Citizen.CreateThread(function()
    Citizen.Wait(5000)
    
    local function ToNumber(str)
        if not str then return 0 end
        return tonumber(str:gsub('%.', '')) or 0
    end
    
    local resourceName = GetCurrentResourceName()
    local currentVersion = GetResourceMetadata(resourceName, 'version', 0)
    
    PerformHttpRequest('https://raw.githubusercontent.com/Mathewgamingg/MG_AssetsVersions/master/'..resourceName..'.txt', function(error, result, headers)
        -- Kontrola, zda požadavek proběhl v pořádku (kód 200)
        if error ~= 200 or not result then 
            return print('^1['..resourceName..'] Kontrola verze selhala (GitHub nedostupný nebo soubor nenalezen).^0') 
        end

        -- Bezpečné dekódování JSONu
        local success, data = pcall(json.decode, result)
        
        if success and data and data.version then
            if ToNumber(data.version) > ToNumber(currentVersion) then
                local symbols = '^9'
                for cd = 1, 26+#resourceName do
                    symbols = symbols..'-'
                end
                symbols = symbols..'^0'
                
                print(symbols)
                print('^3['..resourceName..'] - Je k dispozici nová aktualizace!^0')
                print('Současná verze: ^1'..currentVersion..'^0')
                print('Nová verze: ^2'..data.version..'^0')
                print('Novinky: ^2'..(data.news or 'Žádné info')..'^0')
                print('^5Stahujte na: https://github.com/Mathewgamingg/mg_hud^0')
                print(symbols)
            end
        else
            print('^1['..resourceName..'] Nepodařilo se zpracovat data o verzi (neplatný formát JSON).^0')
        end
    end, 'GET')
end)