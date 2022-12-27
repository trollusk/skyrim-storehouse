Scriptname StorehouseContainerScript extends ObjectReference

StorehouseMCMQuest property mcm auto
MiscObject property lockpickBase auto

Event OnItemAdded(Form base, int count, ObjectReference itemRef, ObjectReference source)
    ObjectReference player = Game.GetPlayer()
    if source == player
        ;debug.notification("Item added to player inventory from grave")
        if !mcm.freeStorehouseContents
            if base as Potion
            elseif base as Ammo
            elseif base == lockpickBase
            else    
                debug.Notification("The storehouse may only contain potions, poisons, lockpicks and ammunition.")
                self.RemoveItem(base, count, true, player)
            endif
        endif
    endif
EndEvent


