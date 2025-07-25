--[[ IMPLEMENT AND TEST OX LIB'S RADIAL MENU FUNCTIONALITY HERE ]]
---@diagnostic disable: lowercase-global

if not lib.checkDependency('ox_lib', '3.30.0', true) then return end

if not Config.Radial == 'ox' then return end -- TESTING CODE

if Config.Framework == 'qb' then

    local function oxAddRadialLockboxOption()
        lib.addRadialItem({
            id = 'open_lock_box',
            icon = 'fa-solid fa-lock',
            label = 'Open Lockbox',
            onSelect = function()
                -- function that calls either opening the menu or opening the inventory
                openLockbox()
            end,
            keepOpen = false
        })
    end

    local function oxUpdateRadial()
        local Player = PlayerPedId()
        if qbCheckValidPoliceJob() or qbCheckValidAmbulanceJob() then
            if IsPedInAnyVehicle(Player, false) then
                local Vehicle = GetVehiclePedIsIn(Player, false)
                local VehicleType = GetVehicleClass(Vehicle)
                if Vehicle == 18 then
                    oxAddRadialLockboxOption()
                else
                    lib.removeRadialItem('open_lock_box')
                end
            else
                lib.removeRadialItem('open_lock_box')
            end
        else
            lib.removeRadialItem('open_lock_box')
        end
    end

    lib.onCache('vehicle', function()
        oxUpdateRadial()
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
                canClose = false,
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        onSelect = function()
                            openLockboxInventory()
                        end,
                        icon = 'fa-solid fa-unlock',
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
                canClose = false,
                position = 'offcenter-right',
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock-open',
                        iconColor = '#FFFFFF',
                        description = locale('info.open_vehicle_lockbox_option_description'),
                        onSelect = function()
                            openLockboxInventory()
                        end
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock',
                        iconColor = '#FFFFFF',
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

    -- Combination Function
    function openLockbox() -- TESTING CODE
        if Config.EnableMenu then
            openLockboxMenu()
        else
            openLockboxInventory()
        end
    end

    RegisterNetEvent('stark_lockbox:client:OpenLockbox', function()
        local Player = PlayerPedId()
        if IsPedInAnyVehicle(Player, false) then
            local Vehicle = GetVehiclePedIsIn(Player, false)
            local VehicleType = GetVehicleClass(Vehicle)
            if VehicleType == 18 then
                if qbCheckValidPoliceJob() or qbCheckValidAmbulanceJob() then
                    if Config.Progress.enabled then
                        if Config.Progress.type == 'ox' then
                            -- Customizable: lib.progressCircle() or lib.progressBar()
                            if lib.progressCircle({
                                    duration = Config.Progress.duration,
                                    position = 'bottom',
                                    label = locale('info.progress_label'),
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        move = true,
                                        car = true,
                                        mouse = false,
                                        combat = true
                                    }
                                }) then
                                -- if Config.EnableMenu then
                                --     openLockboxMenu()
                                -- else
                                --     openLockboxInventory()
                                -- end
                                openLockbox()
                            else
                                if Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    exports.lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        message = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right',
                                    })
                                end
                            end
                        elseif Config.Progress.type == 'lation' then
                            if exports.lation_ui:progressBar({
                                    label = locale('info.progress_label'),
                                    duration = Config.Progress.duration,
                                    icon = 'fas fa-box-open',
                                    iconColor = '#FFFFFF',
                                    color = '#0000FF',
                                    -- steps = {}, -- FEATURE COMING SOON
                                    canCancel = true,
                                    useWhileDead = false,
                                    disable = {
                                        move = true,
                                        sprint = true,
                                        car = true,
                                        combat = true,
                                        mouse = false
                                    }
                                }) then
                                -- if Config.EnableMenu then
                                --     openLockboxMenu()
                                -- else
                                --     openLockboxInventory()
                                -- end
                                openLockbox()
                            else
                                if Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    exports.lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        message = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right',
                                    })
                                end
                            end
                        end
                    else
                        -- Progress Not Enabled
                        -- if Config.EnableMenu then
                        --     openLockboxMenu()
                        -- else
                        --     openLockboxInventory()
                        -- end
                        openLockbox()
                    end
                else
                    -- Fails The Job Check
                    if Config.Notify == 'ox' then
                        lib.notify({
                            title = locale('error.incorrect_job_title'),
                            description = locale('error.incorrect_job_description'),
                            duration = 5000,
                            position = 'center-right',
                            type = 'error'
                        })
                    elseif Config.Notify == 'lation' then
                        exports.lation_ui:notify({
                            title = locale('error.incorrect_job_title'),
                            message = locale('error.incorrect_job_description'),
                            type = 'error',
                            duration = 5000,
                            position = 'center-right'
                        })
                    end
                end
            else
                -- Fails Emergency Vehicle Class Check
                if Config.Notify == 'ox' then
                    lib.notify({
                        title = locale('error.incorrect_vehicle_title'),
                        description = locale('error.incorrect_vehicle_description'),
                        duration = 5000,
                        position = 'center-right',
                        type = 'error'
                    })
                elseif Config.Notify == 'lation' then
                    exports.lation_ui:notify({
                        title = locale('error.incorrect_vehicle_title'),
                        message = locale('error.incorrect_vehicle_description'),
                        type = 'error',
                        duration = 5000,
                        position = 'center-right'
                    })
                end
            end
        else
            -- Player Is Not In A Vehicle
            if Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    description = locale('error.player_not_in_vehicle_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    message = locale('error.player_not_in_vehicle_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            end
        end
    end)
end

if Config.Framework == 'qbx' then
end
