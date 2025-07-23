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
                    title = locale('error.unsupported_inventory_title'),
                    description = locale('error.unsupported_inventory'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = locale('error.unsupported_inventory_title'),
                    message = locale('error.unsupported_inventory'),
                    type = 'error',
                    duration = '5000',
                    position = 'center-right'
                })
            end
        end
    end

    function openLockboxMenu()
        if Config.MenuUI == 'ox' then
            lib.registerContext({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                canClose = true,
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        onSelect = function()
                            openLockboxInventory()
                        end,
                        icon = 'fa-soild fa-lock-open', -- fa-solid fa-unlock
                        iconColor = 'white',
                        description = locale('info.open_vehicle_lockbox_option_description')
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        onSelect = function()
                            lib.hideContext()
                        end,
                        icon = 'fa-solid fa-lock',
                        iconColor = 'white',
                        description = locale('info.close_vehicle_lockbox_option_description')
                    }
                }
            })

            lib.showContext('vehicle_lockbox_menu')
        elseif Config.MenuUI == 'lation' then
            exports.lation_ui:registerMenu({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                canClose = true,
                position = 'offcenter-right',
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        icon = 'fa-soild fa-lock-open',
                        iconColor = 'white',
                        description = locale('info.open_vehicle_lockbox_option_description'),
                        onSelect = function()
                            openLockboxInventory()
                        end
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        icon = 'fa-solid fa-lock',
                        iconColor = 'white',
                        description = locale('info.close_vehicle_lockbox_option_description'),
                        onSelect = function()
                            exports.lation_ui:hideMenu()
                        end
                    }
                }
            })

            exports.lation_ui:showMenu('vehicle_lockbox_menu')
        end
    end

    RegisterNetEvent('stark_lockbox:client:OpenLockbox', function() end)

end

if Config.Framework == 'qbx' then
end