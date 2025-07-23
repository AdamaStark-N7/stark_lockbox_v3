if GetResourceState('qbx_core') ~= 'started' or GetResourceState('qb-core') == 'started' then return end

if not lib.checkDependency('ox_lib', '3.30.0', true) then return end

local oxInvState = GetResourceState('ox_inventory')

local ox_inventory = exports.ox_inventory

if oxInvState == 'started' and GetCurrentResourceName() then
    local lockbox = {
        id = 'vehicle_lockbox',
        label = 'Vehicle Lockbox',
        slots = Config.LockboxSlots,
        weight = Config.LockboxWeight,
        owner = true
    }

    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
            ox_inventory:RegisterStash(lockbox.id, lockbox.label, lockbox.slots, lockbox.weight, lockbox.owner)
        end
    end)
end

lib.addCommand('lockbox', {
    help = 'Opens The Secured Vehicle Lockbox',
    restricted = false,
}, function(source)
    TriggerClientEvent('stark_lockbox:client:OpenLockbox', source)
end)