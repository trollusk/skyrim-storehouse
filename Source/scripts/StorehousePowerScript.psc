Scriptname StorehousePowerScript extends ActiveMagicEffect

Actor property player auto
StorehouseQuest property shplayerref auto

Event OnEffectStart(Actor target, Actor caster)
    if caster == player
        ; if in safe location, open inventory
        ; otherwise error message
        if shplayerref.SafeLocation(player.GetCurrentLocation())
            shplayerref.StorehouseContainer.Activate(player)
        else
            debug.Notification("You may only access the storehouse when in a player house, inn, or certain other places of refuge.")
        endif
    endif
EndEvent

