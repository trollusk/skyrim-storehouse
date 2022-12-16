Scriptname StorehouseQuest extends ReferenceAlias  

StorehouseMCMQuest property mcm auto
Actor property player auto
Furniture property RBCModFire1 auto
Furniture property RBCModFire2 auto
ObjectReference Property BottomlessBox  Auto  
MiscObject property lockpickBase auto

int TYPE_POTION = 46
int TYPE_AMMO = 42

FormList Property HealthPotionFormList  Auto  
FormList Property MagickaPotionFormList  Auto  
FormList Property StaminaPotionFormList  Auto  

int property healthPotionCount auto
int property staminaPotionCount auto
int property magickaPotionCount auto
int property poisonCount auto
int property ammoCount auto
int property lockpickCount auto

Keyword property healthKeyword auto
Keyword property staminaKeyword auto
Keyword property magickaKeyword auto
Keyword property poisonKeyword auto
Keyword property ammoKeyword auto


; TODO on init, formlist.AddForm(base) for each health potion etc
; TODO BB should remove all excess items as well as replenishing

Event OnInit()
    InitStorehouse()
EndEvent


Event OnPlayerLoadGame()
    InitStorehouse()
EndEvent


Function InitStorehouse()
    Form[] potionList = PO3_SKSEFunctions.GetAllForms(TYPE_POTION)
    Form[] ammoList = PO3_SKSEFunctions.GetAllForms(TYPE_AMMO)
    int index = 0
    while index < potionList.Length
        Potion pot = potionList[index] as Potion
        if pot
            if pot.IsPoison() 
                AddInventoryEventFilter(pot)
            endif
        endif
        index += 1
    endwhile

    index = 0
    while index < ammoList.Length
        AddInventoryEventFilter(ammoList[index])
        index += 1
    endwhile

    AddInventoryEventFilter(lockpickBase)
    AddInventoryEventFilter(HealthPotionFormList)
    AddInventoryEventFilter(MagickaPotionFormList)
    AddInventoryEventFilter(StaminaPotionFormList)
    CountItemsInInventory()
EndFunction


Function AddPotionsToFormLists()
    Form[] potionList = PO3_SKSEFunctions.GetAllForms(TYPE_POTION)
    int index = 0
    while index < potionList.Length
        Potion pot = potionList[index] as Potion
        MagicEffect[] mgefs = pot.GetMagicEffects()
        if !pot.IsFood()
            int midx = 0
            while midx < mgefs.Length
                if mgefs[midx].HasKeyword(healthKeyword)
                    HealthPotionFormList.AddForm(pot)
                endif
                if mgefs[midx].HasKeyword(magickaKeyword)
                    MagickaPotionFormList.AddForm(pot)
                endif
                if mgefs[midx].HasKeyword(staminaKeyword)
                    StaminaPotionFormList.AddForm(pot)
                endif
                midx += 1
            endwhile
        endif
        index += 1
    endwhile
EndFunction


Function CountItemsInInventory()
    lockpickCount = player.GetItemCount(lockpickBase)
    healthPotionCount = player.GetItemCount(HealthPotionFormList)
    magickaPotionCount = player.GetItemCount(MagickaPotionFormList)
    staminaPotionCount = player.GetItemCount(StaminaPotionFormList)
    ammoCount = player.GetItemCount(ammoKeyword)
    poisonCount = player.GetItemCount(poisonKeyword)
EndFunction


Event OnItemAdded(Form base, int count, ObjectReference itemref, ObjectReference source)
    string itemName = "items"
    int toStore = 0

	if PO3_SKSEFunctions.IsQuestItem(itemref)
		return
	endif

    if mcm.lockpickCap > 0 && base == lockpickBase
        itemName = "lockpicks"
        lockpickCount = player.GetItemCount(lockpickBase)
        toStore = Max(0, lockpickCount - mcm.lockpickCap)
        debug.Notification("Acquired " + count + " lockpicks (count now " + lockpickCount + ", cap " + mcm.lockpickCap + ")")
    elseif mcm.poisonCap > 0 && (base as Potion).IsPoison()
        itemName = "poisons"
        poisonCount = player.GetItemCount(poisonKeyword)
        toStore = Max(0, poisonCount - mcm.poisonCap)
        debug.Notification("Acquired " + count + " poisons (count now " + poisonCount + ", cap " + mcm.poisonCap + ")")
    elseif mcm.arrowCap > 0 && (base as Ammo)
        itemName = "arrows"
        ammoCount = player.GetItemCount(ammoKeyword)
        toStore = Max(0, ammoCount - mcm.arrowCap)
        debug.Notification("Acquired " + count + " arrows (prior count " + ammoCount + ", cap " + mcm.arrowCap + ")")
    elseif mcm.healthPotionCap > 0 && IsHealthPotion(base)
        itemName = "health potions"
        healthPotionCount = player.GetItemCount(HealthPotionFormList)
        toStore = Max(0, healthPotionCount - mcm.healthPotionCap)
        debug.Notification("Acquired " + count + " health potions (count now " + healthPotionCount + ", cap " + mcm.healthPotionCap + ")")
    elseif mcm.magickaPotionCap > 0 && IsMagickaPotion(base)
        itemName = "magicka potions"
        magickaPotionCount = player.GetItemCount(MagickaPotionFormList)
        toStore = Max(0, magickaPotionCount - mcm.magickaPotionCap)
        debug.Notification("Acquired " + count + " magicka potions (count now " + magickaPotionCount + ", cap " + mcm.magickaPotionCap + ")")
    elseif mcm.staminaPotionCap > 0 && IsStaminaPotion(base)
        staminaPotionCount = player.GetItemCount(StaminaPotionFormList)
        toStore = Max(0, staminaPotionCount - mcm.staminaPotionCap)
        itemName = "stamina potions"
        debug.Notification("Acquired " + count + " stamina potions (count now " + staminaPotionCount + ", cap " + mcm.staminaPotionCap + ")")
    endif

    if toStore > 0
        debug.Notification("Sending " + Min(toStore, count) + " excess " + itemName + " to storehouse...")
        player.RemoveItem(base, Min(toStore, count), false, BottomlessBox)
    endif
EndEvent


; ; TODO don't really need this
; Event OnItemRemoved(Form base, int count, ObjectReference itemref, ObjectReference dest)
;     if mcm.lockpickCap > 0 && base == lockpickBase
;         debug.Notification("Lost " + count + " lockpicks (prior count " + lockpickCount + ", cap " + mcm.lockpickCap + ")")
;         lockpickCount = player.GetItemCount(lockpickBase)
;     elseif mcm.arrowCap > 0 && (base as Ammo)
;         debug.Notification("Lost " + count + " ammo (prior count " + ammoCount + ", cap " + mcm.arrowCap + ")")
;         ammoCount = player.GetItemCount(ammoKeyword)
;     elseif mcm.poisonCap > 0 && (base as Potion).IsPoison()
;         debug.Notification("Lost " + count + " poisons (prior count " + poisonCount + ", cap " + mcm.poisonCap + ")")
;         poisonCount = player.GetItemCount(poisonKeyword)
;     elseif mcm.healthPotionCap > 0 && IsHealthPotion(base)
;         debug.Notification("Lost " + count + " health potions (prior count " + healthPotionCount + ", cap " + mcm.healthPotionCap + ")")
;         healthPotionCount = player.GetItemCount(HealthPotionFormList)
;     elseif mcm.magickaPotionCap > 0 && IsMagickaPotion(base)
;         debug.Notification("Lost " + count + " magicka potions (prior count " + magickaPotionCount + ", cap " + mcm.magickaPotionCap + ")")
;         magickaPotionCount = player.GetItemCount(MagickaPotionFormList)
;     elseif mcm.staminaPotionCap > 0 && IsStaminaPotion(base)
;         debug.Notification("Lost " + count + " stamina potions (prior count " + staminaPotionCount + ", cap " + mcm.staminaPotionCap + ")")
;         staminaPotionCount = player.GetItemCount(StaminaPotionFormList)
;     endif
; EndEvent


Event OnSit(ObjectReference furn)
	Form furnBase = furn.GetBaseObject()
	;debug.Notification("(RBC) Sitting on base =" + furnBase + "  " + furnBase.GetFormID() + "  " + furnBase.GetName())
		
	if ((furnBase == RBCModFire1) || (furnBase == RBCModFire2))
		;debug.Notification("Sitting at campfire! (Rest By Campfire.esp)")
		SyncBottomlessBox()
		return
	endif
	
	;debug.Notification("(RBC) No campfire detected")
EndEvent


function SyncBottomlessBox()
    int toMove = 0
    debug.Notification("Syncing bottomless box!")
    ; todo
    ; - count number of lockpicks in player inventory
    ; - if lockpickCount < lockpickCap
    ;   - find all lockpicks in player inventory
    ;   - move (cap - count) picks to player inventory
    CountItemsInInventory()
    int lockpickStored = BottomlessBox.GetItemCount(lockpickBase)
    int healthPotionStored = BottomlessBox.GetItemCount(HealthPotionFormList)
    int magickaPotionStored = BottomlessBox.GetItemCount(MagickaPotionFormList)
    int staminaPotionStored = BottomlessBox.GetItemCount(StaminaPotionFormList)
    int ammoStored = BottomlessBox.GetItemCount(ammoKeyword)
    int poisonStored = BottomlessBox.GetItemCount(poisonKeyword)
    debug.Notification("(Box/player) Lockpicks " + lockpickStored + "/" + lockpickCount + ", health potions " + healthPotionStored + "/" + healthPotionCount + ", magicka " + magickaPotionStored + "/" + magickaPotionCount)
    debug.Notification("(Box/player) Stamina " + staminaPotionStored + "/" + staminaPotionCount + ", poisons " + poisonStored + "/" + poisonCount + ", ammo " + ammoStored + "/" + ammoCount)

    if mcm.lockpickCap > 0 
        if lockpickCount > mcm.lockpickCap
            player.RemoveItem(lockpickBase, lockpickCount - mcm.lockpickCap, false, BottomlessBox)
            debug.Notification("Sent " + (lockpickCount - mcm.lockpickCap) + " lockpicks to storehouse.")
        elseif lockpickCount < mcm.lockpickCap && lockpickStored > 0
            toMove = Min(lockpickStored, mcm.lockpickCap - lockpickCount)
            BottomlessBox.RemoveItem(lockpickBase, toMove, false, player)
            debug.Notification("Fetched " + toMove + " lockpicks from storehouse.")
            lockpickCount -= toMove
        endif
    endif

    if mcm.poisonCap > 0 
        if poisonCount > mcm.poisonCap
            toMove = poisonCount - mcm.poisonCap
            int index = 0
            while index < player.GetNumItems() && toMove > 0
                Form item = player.GetNthForm(index)
                if item as Potion && (item as Potion).IsPoison()
                    int count = player.GetItemCount(item)
                    player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
                    toMove -= Min(count, toMove)
                endif
                index += 1
            endwhile
            debug.Notification("Sent " + toMove + " poisons to storehouse.")
        elseif poisonCount < mcm.poisonCap && poisonStored > 0
            toMove = Min(poisonStored, mcm.poisonCap - poisonCount)
            int index = 0
            int toMoveAim = toMove
            while index < BottomlessBox.GetNumItems() && toMove > 0
                Form item = BottomlessBox.GetNthForm(index)
                if item as Potion && (item as Potion).IsPoison()
                    int count = BottomlessBox.GetItemCount(item)
                    BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
                    toMove -= Min(count, toMove)
                endif
                index += 1
            endwhile
            debug.Notification("Fetched " + (toMoveAim - toMove) + " poisons from storehouse.")
        endif
    endif

    if mcm.arrowCap > 0 
        SyncAmmo(ammoStored)
    endif

    if mcm.healthPotionCap > 0 
        if healthPotionCount > mcm.healthPotionCap
            toMove = healthPotionCount - mcm.healthPotionCap
            int index = 0
            while index < player.GetNumItems() && toMove > 0
                Form item = player.GetNthForm(index)
                if IsHealthPotion(item)
                    int count = player.GetItemCount(item)
                    player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
                    toMove -= Min(count, toMove)
                endif
                index += 1
            endwhile
            debug.Notification("Sent " + toMove + " health potions to storehouse.")
        elseif healthPotionCount < mcm.healthPotionCap && healthPotionStored > 0
            toMove = Min(healthPotionStored, mcm.healthPotionCap - healthPotionCount)
            int index = 0
            int toMoveAim = toMove
            while index < BottomlessBox.GetNumItems() && toMove > 0
                Form item = BottomlessBox.GetNthForm(index)
                if IsHealthPotion(item)
                    int count = BottomlessBox.GetItemCount(item)
                    BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
                    toMove -= Min(count, toMove)
                endif
                index += 1
            endwhile
            debug.Notification("Fetched " + (toMoveAim - toMove) + " health potions from storehouse.")
        endif
    endif

    if mcm.magickaPotionCap > 0 
        if magickaPotionCount > mcm.magickaPotionCap
            toMove = magickaPotionCount - mcm.magickaPotionCap
            int index = 0
            while index < player.GetNumItems() && toMove > 0
                Form item = player.GetNthForm(index)
                if IsMagickaPotion(item)
                    int count = player.GetItemCount(item)
                    player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
                    toMove -= Min(count, toMove)
                endif
                index += 1
            endwhile
            debug.Notification("Sent " + toMove + " magicka potions to storehouse.")
        elseif magickaPotionCount < mcm.magickaPotionCap && magickaPotionStored > 0
            toMove = Min(magickaPotionStored, mcm.magickaPotionCap - magickaPotionCount)
            int index = 0
            int toMoveAim = toMove
            while index < BottomlessBox.GetNumItems() && toMove > 0
                Form item = BottomlessBox.GetNthForm(index)
                if IsMagickaPotion(item)
                    int count = BottomlessBox.GetItemCount(item)
                    BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
                    toMove -= Min(count, toMove)
                endif
                index += 1
            endwhile
            debug.Notification("Fetched " + (toMoveAim - toMove) + " magicka potions from storehouse.")
        endif
    endif

    if mcm.staminaPotionCap > 0
        if staminaPotionCount > mcm.staminaPotionCap 
            toMove = staminaPotionCount - mcm.staminaPotionCap
            int index = 0
            while index < player.GetNumItems() && toMove > 0
                Form item = player.GetNthForm(index)
                if IsStaminaPotion(item)
                    int count = player.GetItemCount(item)
                    player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
                    toMove -= Min(count, toMove)
                endif
                index += 1
            endwhile
            debug.Notification("Sent " + toMove + " stamina potions to storehouse.")
        elseif staminaPotionCount < mcm.staminaPotionCap && staminaPotionStored > 0
            toMove = Min(staminaPotionStored, mcm.staminaPotionCap - staminaPotionCount)
            int index = 0
            int toMoveAim = toMove
            while index < BottomlessBox.GetNumItems() && toMove > 0
                Form item = BottomlessBox.GetNthForm(index)
                if IsStaminaPotion(item)
                    int count = BottomlessBox.GetItemCount(item)
                    BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
                    toMove -= Min(count, toMove)
                endif
                index += 1
            endwhile
            debug.Notification("Fetched " + (toMoveAim - toMove) + " stamina potions from storehouse.")
        endif
    endif
endfunction


Function SyncAmmo(int ammoStored)
    int toMove = 0
    int index = 0
    int toMoveAim = 0
    Ammo equippedAmmo = PO3_SKSEFunctions.GetEquippedAmmo(player)
    bool usingBolts = equippedAmmo && equippedAmmo.IsBolt()

    if ammoCount > mcm.arrowCap
        ; Carrying too many arrows/bolts, so send some to storehouse
        ; First send ammo of type we're not using
        ; Then ammo of type we are using
        ; Lastly send ammo we have equipped
        index = 0
        toMove = ammoCount - mcm.arrowCap
        toMoveAim = toMove
        while index < player.GetNumItems() && toMove > 0
            Ammo item = player.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() != usingBolts
                int count = player.GetItemCount(item)
                player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile

        index = 0
        while index < player.GetNumItems() && toMove > 0
            Ammo item = player.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() == usingBolts
                int count = player.GetItemCount(item)
                player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile

        if toMove > 0 && equippedAmmo
            int count = player.GetItemCount(equippedAmmo)
            player.RemoveItem(equippedAmmo, Min(count, toMove), false, BottomlessBox)
            toMove -= Min(count, toMove)
        endif
        debug.Notification("Sent " + (toMoveAim - toMove) + " arrows and bolts to storehouse.")
    elseif ammoCount < mcm.arrowCap && ammoStored > 0
        toMove = Min(ammoStored, mcm.arrowCap - ammoCount)
        toMoveAim = toMove
        ; Need to fetch some ammo from storehouse
        ; First get ammo of the same type we have equipped
        ; Then get ammo of type we are using (arrows vs bolts)
        ; Then ammo of type we are not using
        if toMove > 0 && equippedAmmo
            int count = BottomlessBox.GetItemCount(equippedAmmo)
            BottomlessBox.RemoveItem(equippedAmmo, Min(count, toMove), false, player)
            toMove -= Min(count, toMove)
        endif

        index = 0
        while index < BottomlessBox.GetNumItems() && toMove > 0
            Ammo item = BottomlessBox.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() == usingBolts
                int count = BottomlessBox.GetItemCount(item)
                BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile

        index = 0
        while index < BottomlessBox.GetNumItems() && toMove > 0
            Ammo item = BottomlessBox.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() != usingBolts
                int count = BottomlessBox.GetItemCount(item)
                BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile
        debug.Notification("Fetched " + (toMoveAim - toMove) + " arrows and bolts from storehouse.")
    endif
EndFunction


bool Function IsHealthPotion(Form base)
    return HealthPotionFormList.Find(base) >= 0
EndFunction


bool Function IsMagickaPotion(Form base)
    return MagickaPotionFormList.Find(base) >= 0
EndFunction


bool Function IsStaminaPotion(Form base)
    return StaminaPotionFormList.Find(base) >= 0
EndFunction


int Function Min(int a, int b)
    if a < b
        return a
    else
        return b 
    endif
EndFunction


int Function Max(int a, int b)
    if a > b
        return a
    else
        return b 
    endif
EndFunction

