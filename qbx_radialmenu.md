## Qbox Radial Menu
Add The Following Snippet Of Code To Your qbx_radialmenu\config\client.lua in both the police and ambulance tables under jobItems:

```lua
            {
                id = 'Open Lockbox',
                icon = 'lock',
                label = 'Open Lockbox',
                event = 'stark_lockbox:client:OpenLockbox',
            },
```

Depending upon your configuration, this should be placed right around line 236 and line 353.