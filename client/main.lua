---@diagnostic disable: lowercase-global

if not lib.checkDependency('ox_lib', '3.30.0', true) then return end

if Config.Framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()

    local function addRadialLockboxOption()
        local Player = PlayerPedId()
        MenuItemId = exports['qb-radialmenu']:AddOption({
            id = 'open_lock_box',
            title = 'Open Lockbox',
            icon = 'lock',
            type = 'client',
            event = 'stark_lockbox:client:OpenLockbox',
            shouldClose = true,
        }, MenuItemId)
    end

    local function updateRadial()
        local Player = PlayerPedId()
        if qbCheckValidPoliceJob() or qbCheckValidAmbulanceJob() then
            if IsPedInAnyVehicle(Player, false) then
                local Vehicle = GetVehiclePedIsIn(Player, false)
                local VehicleType = GetVehicleClass(Vehicle)
                if VehicleType == 18 then
                    addRadialLockboxOption()
                elseif MenuItemId ~= nil then
                    exports['qb-radialmenu']:RemoveOption(MenuItemId)
                    MenuItemId = nil
                end
            elseif MenuItemId ~= nil then
                exports['qb-radialmenu']:RemoveOption(MenuItemId)
                MenuItemId = nil
            end
        elseif MenuItemId ~= nil then
            exports['qb-radialmenu']:RemoveOption(MenuItemId)
            MenuItemId = nil
        end
    end

    RegisterNetEvent('qb-radialmenu:client:onRadialmenuOpen', function()
        updateRadial()
    end)

    function openLockboxInventory()
        local Player = PlayerPedId()
        local Vehicle = GetVehiclePedIsIn(Player, false)
        local id = GetVehicleNumberPlateText(Vehicle)

        if Config.Inventory == 'qb' then
            local stashLabel = 'Vehicle Lockbox ' .. id
            TriggerServerEvent('stark_lockbox:server:OpenLockbox', stashLabel)
        elseif Config.Inventory == 'ps' then
            TriggerServerEvent('ps-inventory:server:OpenInventory', 'stash', 'Vehicle Lockbox ' .. id, {
                maxweight = Config.LockboxWeight,
                slots = Config.LockboxSlots
            })
            TriggerEvent('ps-inventory:client:SetCurrentStash', 'Vehicle Lockbox ' .. id)
        elseif Config.Inventory == 'ox' then
            local ox_inventory = exports.ox_inventory
            ox_inventory:openInventory('stash', 'vehicle_lockbox')
        else
            if Config.Notify == 'ox' then
                lib.notify({
                    title = 'Unsupported Inventory',
                    description = locale('error.unsupported_inventory'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = 'Unsupported Inventory',
                    message = locale('error.unsupported_inventory'),
                    type = 'error',
                    duration = '5000',
                    position = 'center-right'
                })
            end
        end
    end
end

if Config.Framework == 'qbx' then
end