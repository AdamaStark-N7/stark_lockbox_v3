Config = Config or {}

Config.VersionCheck = true

Config.Framework = 'qb' -- supported: 'qb' or 'qbx'

Config.Notify = 'ox'    -- supported: 'ox' or 'lation'

Config.Inventory = 'ps' -- supported: 'qb', 'ox', or 'ps'

Config.Radial = 'ox'    -- supported: 'qb' or 'ox' -- TESTING CODE

Config.Progress = {
    enabled = true,
    type = 'ox', -- supported: 'ox' or 'lation'
    duration = 2500
}

Config.LockboxSlots = 5

Config.LockboxWeight = 120000

Config.PoliceJobs = {
    'police',
    'lssd',
    'sast',
    'bcso',
    'sasp',
    -- add your server's police job here as found in qb-core/shared/jobs.lua or qbx_core/shared/jobs.lua
}

Config.AmbulanceJobs = {
    'ambulance',
    -- add your server's ambulance job here as found in qb-core/shared/jobs.lua or qbx_core/shared/jobs.lua
}

Config.EnableMenu = true

Config.MenuUI = 'ox' -- supported: 'ox' or 'lation'