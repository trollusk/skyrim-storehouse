Scriptname StorehouseQuest extends ReferenceAlias  

; TODO
; place chests in inns
; all chests link to StorehouseContainer

StorehouseMCMQuest property mcm auto
Actor property player auto
ObjectReference Property BottomlessBox  Auto  
;FormList Property SBMEstusFlaskFormList  Auto   ; Soulslike Bonfire Menu list of "estus flask" potions
ObjectReference property DefaultStorehouseContainer auto    ; alternative to SBM container, not currently used
MiscObject property lockpickBase auto
Light property torchBase auto

int TYPE_POTION = 46
int TYPE_AMMO = 42

FormList Property HealthPotionFormList  Auto  
FormList Property MagickaPotionFormList  Auto  
FormList Property StaminaPotionFormList  Auto  

int property healthPotionCount auto
int property staminaPotionCount auto
int property magickaPotionCount auto
int property utilityPotionCount auto
int property poisonCount auto
int property ammoCount auto
int property lockpickCount auto
int property torchCount auto

int lockpickStored
int torchStored
int ammoStored 
int healthPotionStored 
int magickaPotionStored 
int staminaPotionStored 
int utilityPotionStored 
int poisonStored 

ObjectReference property StorehouseContainer auto

Keyword property healthKeyword auto
Keyword property staminaKeyword auto
Keyword property magickaKeyword auto
Keyword property healthPotionKeyword auto
Keyword property staminaPotionKeyword auto
Keyword property magickaPotionKeyword auto
Keyword property utilityPotionKeyword auto
Keyword property poisonKeyword auto
Keyword property ammoKeyword auto
Keyword Property innLocationKeyword  Auto  
Keyword Property houseLocationKeyword  Auto     ; player home
Keyword Property safeLocationKeyword  Auto      ; other safe location eg Dark Brotherhood Sanctuary

; TODO on init, formlist.AddForm(base) for each health potion etc
; TODO BB should remove all excess items as well as replenishing

Event OnInit()
    ;StorehouseContainer = BottomlessBox
    StorehouseContainer = DefaultStorehouseContainer
    if mcm.givePower
        player.AddSpell(mcm.storehousePower, false)
    endif
    InitStorehouse()
EndEvent


Event OnPlayerLoadGame()
    ;RemoveAllInventoryEventFilters()
    ;StorehouseContainer = BottomlessBox
    StorehouseContainer = DefaultStorehouseContainer
    if mcm.givePower
        player.AddSpell(mcm.storehousePower, false)
    endif
    InitStorehouse()
EndEvent


Function InitStorehouse()
    ; iterate through player and BB
    ; ensure all relevant potions/poisons are in flists

    int index = 0
    Form[] potions

    ; index = 0
    ; while index < StaminaPotionFormList.GetSize()
    ;     Form pot = StaminaPotionFormList.GetAt(index)
    ;     if !(pot.HasKeyword(staminaPotionKeyword))
    ;         PO3_SKSEFunctions.AddKeywordToForm(pot, staminaPotionKeyword)
    ;     endif
    ;     index += 1
    ; endwhile

    ; index = 0
    ; while index < MagickaPotionFormList.GetSize()
    ;     Form pot = MagickaPotionFormList.GetAt(index)
    ;     if !(pot.HasKeyword(magickaPotionKeyword))
    ;         PO3_SKSEFunctions.AddKeywordToForm(pot, magickaPotionKeyword)
    ;     endif
    ;     index += 1
    ; endwhile

    debug.Notification("Storehouse: checking player inventory for unrecognised potions.")
    index = 0
    while index < player.GetNumItems()
        Form item = player.GetNthForm(index)
        if item as Potion && PO3_SKSEFunctions.IsGeneratedForm(item)
            PO3_SKSEFunctions.RemoveKeywordOnForm(item, utilityPotionKeyword)
            AddKeywordsToPotion(item as Potion)
        endif
        index += 1
    endwhile

    index = 0
    debug.Notification("Storehouse: checking storehouse for unrecognised potions.")
    while index < StorehouseContainer.GetNumItems()
        Form item = StorehouseContainer.GetNthForm(index)
        if item as Potion && PO3_SKSEFunctions.IsGeneratedForm(item)
            PO3_SKSEFunctions.RemoveKeywordOnForm(item, utilityPotionKeyword)
            AddKeywordsToPotion(item as Potion)
        endif
        index += 1
    endwhile

    potions = PO3_SKSEFunctions.GetAllForms(TYPE_POTION)
    index = 0
    ;debug.Notification("Storehouse (1/3) Ensuring all potions have correct keywords...")
    ; it doesn't matter how long this takes, or if it is interrupted, so we do it silently and last
    while index < potions.Length
        Potion pot = potions[index] as Potion
        if pot.IsPoison()
            ;
        elseif !pot.IsFood() || mcm.includeFood
            PO3_SKSEFunctions.RemoveKeywordOnForm(pot, utilityPotionKeyword)
            AddKeywordsToPotion(pot)
        endif
        index += 1
    endwhile
EndFunction


int IT_ALL = 0
int IT_HEALTH_POTION = 1
int IT_MAGICKA_POTION = 2
int IT_STAMINA_POTION = 3
int IT_UTILITY_POTION = 4
int IT_POISON = 5
int IT_AMMO = 6
int IT_LOCKPICK = 7
int IT_TORCH = 8


int Function CountItemsInInventory(int itemType = 0, bool storehouse = false)
    Form[] potArray
    int index = 0

    if storehouse
        if itemType == IT_LOCKPICK || itemType == IT_ALL
            lockpickStored = StorehouseContainer.GetItemCount(lockpickBase)
        endif
        if itemType == IT_TORCH || itemType == IT_ALL
            torchStored = StorehouseContainer.GetItemCount(torchBase)
        endif
        if itemType == IT_AMMO || itemType == IT_ALL
            ammoStored = StorehouseContainer.GetItemCount(ammoKeyword)
        endif
        if itemType == IT_HEALTH_POTION || itemType == IT_ALL
            ; healthPotionStored = StorehouseContainer.GetItemCount(HealthPotionFormList)
            healthPotionStored = StorehouseContainer.GetItemCount(healthPotionKeyword)
        endif
        if itemType == IT_MAGICKA_POTION || itemType == IT_ALL
            magickaPotionStored = StorehouseContainer.GetItemCount(magickaPotionKeyword)
        endif
        if itemType == IT_STAMINA_POTION || itemType == IT_ALL
            staminaPotionStored = StorehouseContainer.GetItemCount(staminaPotionKeyword)
        endif
        if itemType == IT_UTILITY_POTION || itemType == IT_ALL
            utilityPotionStored = StorehouseContainer.GetItemCount(utilityPotionKeyword)
        endif
        if itemType == IT_POISON || itemType == IT_ALL
            poisonStored = StorehouseContainer.GetItemCount(poisonKeyword)
        endif
    else
        if itemType == IT_LOCKPICK || itemType == IT_ALL
            lockpickCount = player.GetItemCount(lockpickBase)
        endif
        if itemType == IT_TORCH || itemType == IT_ALL
            torchCount = player.GetItemCount(torchBase)
        endif
        if itemType == IT_AMMO || itemType == IT_ALL
            ammoCount = player.GetItemCount(ammoKeyword)
        endif
        if itemType == IT_HEALTH_POTION || itemType == IT_ALL
            healthPotionCount = player.GetItemCount(healthPotionKeyword)
        endif
        if itemType == IT_MAGICKA_POTION || itemType == IT_ALL
            magickaPotionCount = player.GetItemCount(magickaPotionKeyword)
        endif
        if itemType == IT_STAMINA_POTION || itemType == IT_ALL
            staminaPotionCount = player.GetItemCount(staminaPotionKeyword)
        endif
        if itemType == IT_UTILITY_POTION || itemType == IT_ALL
            utilityPotionCount = player.GetItemCount(utilityPotionKeyword)
        endif
        if itemType == IT_POISON || itemType == IT_ALL
            poisonCount = player.GetItemCount(poisonKeyword)
        endif
    endif


    ; healthPotionCount = 0
    ; magickaPotionCount = 0
    ; staminaPotionCount = 0
    ; poisonCount = 0

    ; if itemType <= 4        ; all items, or potion/poison
    ;     potArray = PO3_SKSEFunctions.AddItemsOfTypeToArray(player, TYPE_POTION, true,false,true)
    ;     while index < potArray.Length
    ;         Potion pot = potArray[index] as Potion
    ;         if mcm.poisonCap > 0 && pot.IsPoison()
    ;             poisonCount += player.GetItemCount(pot)
    ;         Else
    ;             if mcm.healthPotionCap > 0 && IsHealthPotion(pot)
    ;                 healthPotionCount += player.GetItemCount(pot)
    ;             endif
    ;             if mcm.magickaPotionCap > 0 && IsMagickaPotion(pot)
    ;                 magickaPotionCount += player.GetItemCount(pot)
    ;             endif
    ;             if mcm.staminaPotionCap > 0 && IsStaminaPotion(pot)
    ;                 staminaPotionCount += player.GetItemCount(pot)
    ;             endif
    ;         endif
    ;         index += 1
    ;     endwhile
    ; endif

    if storehouse
        if itemType == IT_ALL
            return 0
        elseif itemType == IT_HEALTH_POTION
            return healthPotionStored
        elseif itemType == IT_MAGICKA_POTION
            return magickaPotionStored
        elseif itemType == IT_STAMINA_POTION
            return staminaPotionStored
        elseif itemType == IT_UTILITY_POTION
            return utilityPotionStored
        elseif itemType == IT_POISON
            return poisonStored
        elseif itemType == IT_AMMO
            return ammoStored
        elseif itemType == IT_LOCKPICK
            return lockpickStored
        elseif itemType == IT_TORCH
            return torchStored
        Else
            return 0
        endif
    else
        if itemType == 0
            return 0
        elseif itemType == IT_HEALTH_POTION
            return healthPotionCount
        elseif itemType == IT_MAGICKA_POTION
            return magickaPotionCount
        elseif itemType == IT_STAMINA_POTION
            return staminaPotionCount
        elseif itemType == IT_UTILITY_POTION
            return utilityPotionCount
        elseif itemType == IT_POISON
            return poisonCount
        elseif itemType == IT_AMMO
            return ammoCount
        elseif itemType == IT_LOCKPICK
            return lockpickCount
        elseif itemType == IT_TORCH
            return torchCount
        Else
            return 0
        endif
    endif
EndFunction


Event OnItemAdded(Form base, int count, ObjectReference itemref, ObjectReference source)
    string itemName = "item"
    string itemNamePlural = "items"
    int toStore = 0

	if PO3_SKSEFunctions.IsQuestItem(itemref)
		return
	endif

    ;consoleutil.PrintMessage("ItemAdded ref name:" + itemref.GetDisplayName() + ", base:" + base + " / " + PO3_SKSEFunctions.GetFormEditorID(base) + " / " + base.GetName())
    ;consoleutil.PrintMessage("  GetOwner:" + GetOwner(itemref, source) + ", parent cell:" + itemref.GetParentCell() + ", actor owner:" + itemref.GetActorOwner() + ", faction owner:" + itemref.GetFactionOwner())
    
    if mcm.lockpickCap > 0 && base == lockpickBase
        itemName = "lockpick"
        itemNamePlural = "lockpicks"
        lockpickCount = player.GetItemCount(lockpickBase)
        toStore = Max(0, lockpickCount - mcm.lockpickCap)
    elseif mcm.torchCap > 0 && base == torchBase
        itemName = "torch"
        itemNamePlural = "torches"
        torchCount = player.GetItemCount(torchBase)
        toStore = Max(0, torchCount - mcm.torchCap)
    elseif mcm.poisonCap > 0 && (base as Potion).IsPoison()
        itemName = "poison"
        itemNamePlural = "poisons"
        poisonCount = CountItemsInInventory(IT_POISON)
        toStore = Max(0, poisonCount - mcm.poisonCap)
        ;consoleutil.PrintMessage("Acquired " + count + " poisons (count now " + poisonCount + ", cap " + mcm.poisonCap + ")")
    elseif mcm.arrowCap > 0 && (base as Ammo)
        if (base as Ammo).IsBolt()
            itemName = "bolt"
            itemNamePlural = "bolts"
        else
            itemName = "arrow"
            itemNamePlural = "arrows"
        endif
        ammoCount = player.GetItemCount(ammoKeyword)
        toStore = Max(0, ammoCount - mcm.arrowCap)
        ;consoleutil.PrintMessage("Acquired " + count + " arrows (prior count " + ammoCount + ", cap " + mcm.arrowCap + ")")
    elseif mcm.healthPotionCap > 0 && IsHealthPotion(base)
        itemName = "health potion"
        itemNamePlural = "health potions"
        healthPotionCount = CountItemsInInventory(IT_HEALTH_POTION)
        ;consoleutil.PrintMessage("ref name:" + itemref.GetDisplayName() + ", base:" + base + " / " + PO3_SKSEFunctions.GetFormEditorID(base) + " / " + base.GetName())
        ;consoleutil.PrintMessage("base generated:" + PO3_SKSEFunctions.IsGeneratedForm(base) + "IsHealthPotion:" + IsHealthPotion(base) + ", formlist:" + HealthPotionFormList.Find(base))
        toStore = Max(0, healthPotionCount - mcm.healthPotionCap)
    elseif mcm.magickaPotionCap > 0 && IsMagickaPotion(base)
        itemName = "magicka potion"
        itemNamePlural = "magicka potions"
        magickaPotionCount = CountItemsInInventory(IT_MAGICKA_POTION)
        toStore = Max(0, magickaPotionCount - mcm.magickaPotionCap)
    elseif mcm.staminaPotionCap > 0 && IsStaminaPotion(base)
        staminaPotionCount = CountItemsInInventory(IT_STAMINA_POTION)
        toStore = Max(0, staminaPotionCount - mcm.staminaPotionCap)
        itemName = "stamina potion"
        itemNamePlural = "stamina potions"
    elseif mcm.utilityPotionCap > 0 && IsUtilityPotion(base)
        utilityPotionCount = CountItemsInInventory(IT_UTILITY_POTION)
        toStore = Max(0, utilityPotionCount - mcm.utilityPotionCap)
        itemName = "utility potion"
        itemNamePlural = "utility potions"
    endif

    if Min(toStore, count) > 0
        player.RemoveItem(base, Min(toStore, count), true, StorehouseContainer)
        debug.Notification("Sent " + Min(toStore, count) + " " + strif(Min(toStore, count)==1, itemName, itemNamePlural) + " to storehouse...")
    endif
EndEvent



Event OnLocationChange (Location oldloc, Location newloc)
	if SafeLocation(newloc) && !SafeLocation(oldloc)
        SyncStorehouse()
	endif
EndEvent


bool Function SafeLocation(Location loc)
    if loc.HasKeyword(innLocationKeyword) || loc.HasKeyword(houseLocationKeyword) || loc.HasKeyword(safeLocationKeyword)
        return true
    else
        return false
    endif
EndFunction


function SyncStorehouse()
    int toMove = 0
    int index = 0
    Form[] potStoredArray
    Form[] poisonsStoredArray
    Form[] healthStoredArray
    Form[] magickaStoredArray
    Form[] staminaStoredArray

    CountItemsInInventory(IT_ALL)            ; player inventory
    CountItemsInInventory(IT_ALL, true)      ; storehouse

    if mcm.lockpickCap > 0 
        if lockpickCount > mcm.lockpickCap
            toMove = lockpickCount - mcm.lockpickCap
            player.RemoveItem(lockpickBase, toMove, true, StorehouseContainer)
            debug.Notification("Sent " + toMove + " " + strif(toMove==1,"lockpick", "lockpicks") + " to the storehouse.")
        elseif lockpickCount < mcm.lockpickCap && lockpickStored > 0
            toMove = Min(lockpickStored, mcm.lockpickCap - lockpickCount)
            StorehouseContainer.RemoveItem(lockpickBase, toMove, true, player)
            debug.Notification("Fetched " + toMove + " " + strif(toMove==1,"lockpick", "lockpicks") + " from the storehouse.")
            lockpickCount -= toMove
        endif
    endif

    if mcm.torchCap > 0 
        if torchCount > mcm.torchCap
            toMove = torchCount - mcm.torchCap
            player.RemoveItem(torchBase, toMove, true, StorehouseContainer)
            debug.Notification("Sent " + toMove + " " + strif(toMove==1,"torch", "torches") + " to the storehouse.")
        elseif torchCount < mcm.torchCap && torchStored > 0
            toMove = Min(torchStored, mcm.torchCap - torchCount)
            StorehouseContainer.RemoveItem(torchBase, toMove, true, player)
            debug.Notification("Fetched " + toMove + " " + strif(toMove==1,"torch", "torches") + " from the storehouse.")
            torchCount -= toMove
        endif
    endif

    if mcm.arrowCap > 0 
        SyncAmmo()
    endif

    if mcm.poisonCap > 0
        SyncPotions(poisonKeyword, poisonCount, poisonStored, mcm.poisonCap)
    endif

    if mcm.healthPotionCap > 0
        SyncPotions(healthPotionKeyword, healthPotionCount, healthPotionStored, mcm.healthPotionCap)
    endif

    if mcm.magickaPotionCap > 0
        SyncPotions(magickaPotionKeyword, magickaPotionCount, magickaPotionStored, mcm.magickaPotionCap)
    endif

    if mcm.staminaPotionCap > 0
        SyncPotions(staminaPotionKeyword, staminaPotionCount, staminaPotionStored, mcm.staminaPotionCap)
    endif

    if mcm.utilityPotionCap > 0
        SyncPotions(utilityPotionKeyword, utilityPotionCount, utilityPotionStored, mcm.utilityPotionCap)
    endif
endfunction


Function SyncPotions(Keyword kwd, int carriedCount, int stored, int cap)
    int toMove
    int toMoveAim
    int index
    string potionSingular
    string potionPlural
    if kwd == healthPotionKeyword
        potionSingular = " health potion"
        potionPlural = " health potions"
    elseif kwd == magickaPotionKeyword
        potionSingular = " magicka potion"
        potionPlural = " magicka potions"
    elseif kwd == staminaPotionKeyword
        potionSingular = " stamina potion"
        potionPlural = " stamina potions"
    elseif kwd == utilityPotionKeyword
        potionSingular = " utility potion"
        potionPlural = " utility potions"
    elseif kwd == poisonKeyword
        potionSingular = " poison"
        potionPlural = " poisons"
    endif

    if cap > 0 
        if carriedCount > cap
            toMove = carriedCount - cap
            index = 0
            toMoveAim = toMove
            while index < player.GetNumItems() && toMove > 0
                Potion item = player.GetNthForm(index) as Potion
                if !item
                    ;
                elseif (kwd==poisonKeyword && item.IsPoison()) || (kwd==healthPotionKeyword && IsHealthPotion(item)) || (kwd==magickaPotionKeyword && IsMagickaPotion(item)) || (kwd==staminaPotionKeyword && IsStaminaPotion(item)) || (kwd==utilityPotionKeyword && IsUtilityPotion(item))
                    int count = player.GetItemCount(item)
                    player.RemoveItem(item, Min(count, toMove), true, StorehouseContainer)
                    toMove -= Min(count, toMove)
                endif
                index += 1
            endwhile
            debug.Notification("Sent " + (toMoveAim - toMove) + strif((toMoveAim - toMove)==1,potionSingular, potionPlural) + " to the storehouse.")
        elseif carriedCount < cap && stored > 0
            toMove = Min(stored, cap - carriedCount)
            toMoveAim = toMove
            ; first pass - try to fetch items that are the same as what we are carrying
            index = 0
            while index < StorehouseContainer.GetNumItems() && toMove > 0
                Potion item = StorehouseContainer.GetNthForm(index) as Potion
                if !item
                    ;
                elseif (kwd==poisonKeyword && item.IsPoison()) || (kwd==healthPotionKeyword && IsHealthPotion(item)) || (kwd==magickaPotionKeyword && IsMagickaPotion(item)) || (kwd==staminaPotionKeyword && IsStaminaPotion(item)) || (kwd==utilityPotionKeyword && IsUtilityPotion(item))
                    if player.GetItemCount(item) > 0        ; only want potions that match what the player already has
                        int count = StorehouseContainer.GetItemCount(item)
                        StorehouseContainer.RemoveItem(item, Min(count, toMove), true, player)
                        toMove -= Min(count, toMove)
                    endif
                endif
                index += 1
            endwhile
            ; second pass - accept potions that are unlike the potions carried by the player
            index = 0
            while index < StorehouseContainer.GetNumItems() && toMove > 0
                Potion item = StorehouseContainer.GetNthForm(index) as Potion
                if !item
                    ;
                elseif (kwd==poisonKeyword && item.IsPoison()) || (kwd==healthPotionKeyword && IsHealthPotion(item)) || (kwd==magickaPotionKeyword && IsMagickaPotion(item)) || (kwd==staminaPotionKeyword && IsStaminaPotion(item)) || (kwd==utilityPotionKeyword && IsUtilityPotion(item))
                    if player.GetItemCount(item) == 0        ; we aren't already carrying this type of potion
                        int count = StorehouseContainer.GetItemCount(item)
                        StorehouseContainer.RemoveItem(item, Min(count, toMove), true, player)
                        toMove -= Min(count, toMove)
                    endif
                endif
                index += 1
            endwhile
            debug.Notification("Fetched " + (toMoveAim - toMove) + strif((toMoveAim - toMove)==1,potionSingular, potionPlural) + " from the storehouse.")
        endif
    endif
EndFunction


Function SyncAmmo()
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
                player.RemoveItem(item, Min(count, toMove), true, StorehouseContainer)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile

        index = 0
        while index < player.GetNumItems() && toMove > 0
            Ammo item = player.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() == usingBolts
                int count = player.GetItemCount(item)
                player.RemoveItem(item, Min(count, toMove), true, StorehouseContainer)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile

        if toMove > 0 && equippedAmmo
            int count = player.GetItemCount(equippedAmmo)
            player.RemoveItem(equippedAmmo, Min(count, toMove), true, StorehouseContainer)
            toMove -= Min(count, toMove)
        endif
        debug.Notification("Sent " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"arrow/bolt", "arrows/bolts") + " to the storehouse.")
    elseif ammoCount < mcm.arrowCap && ammoStored > 0
        toMove = Min(ammoStored, mcm.arrowCap - ammoCount)
        toMoveAim = toMove
        ; Need to fetch some ammo from storehouse
        ; First get ammo of the same type we have equipped
        ; Then get ammo of type we are using (arrows vs bolts)
        ; Then ammo of type we are not using
        if toMove > 0 && equippedAmmo
            int count = StorehouseContainer.GetItemCount(equippedAmmo)
            StorehouseContainer.RemoveItem(equippedAmmo, Min(count, toMove), true, player)
            toMove -= Min(count, toMove)
        endif

        index = 0
        while index < StorehouseContainer.GetNumItems() && toMove > 0
            Ammo item = StorehouseContainer.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() == usingBolts
                int count = StorehouseContainer.GetItemCount(item)
                StorehouseContainer.RemoveItem(item, Min(count, toMove), true, player)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile

        index = 0
        while index < StorehouseContainer.GetNumItems() && toMove > 0
            Ammo item = StorehouseContainer.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() != usingBolts
                int count = StorehouseContainer.GetItemCount(item)
                StorehouseContainer.RemoveItem(item, Min(count, toMove), true, player)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile
        debug.Notification("Fetched " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"arrow/bolt", "arrows/bolts") + " from the storehouse.")
    endif
EndFunction


bool Function IsPotionType(Form base, Keyword magicEffectKeyword)
    Keyword kwd
    Potion pot = base as Potion

    if magicEffectKeyword == healthKeyword
        kwd = healthPotionKeyword
    elseif magicEffectKeyword == magickaKeyword
        kwd = magickaPotionKeyword
    elseif magicEffectKeyword == staminaKeyword 
        kwd = staminaPotionKeyword
    elseif magicEffectKeyword == utilityPotionKeyword 
        kwd = utilityPotionKeyword
    endif

    if !pot
        return false
    elseif pot.IsPoison()
        return false
    elseif pot.HasKeyword(kwd)
        return true
    else
        ; could be a crafted potion
        MagicEffect[] mgefs = pot.GetMagicEffects()
        if !pot.IsFood() || mcm.includeFood
            int index = 0
            bool utilityPot = true
            while index < mgefs.Length
                if mgefs[index].HasKeyword(magicEffectKeyword)
                    ;flist.AddForm(base)
                    if magicEffectKeyword == healthKeyword
                        PO3_SKSEFunctions.AddKeywordToForm(base, healthPotionKeyword)
                    elseif magicEffectKeyword == magickaKeyword
                        PO3_SKSEFunctions.AddKeywordToForm(base, magickaPotionKeyword)
                    elseif magicEffectKeyword == staminaKeyword 
                        PO3_SKSEFunctions.AddKeywordToForm(base, staminaPotionKeyword)
                    endif
                    return true
                endif
                if mgefs[index].HasKeyword(healthKeyword) || mgefs[index].HasKeyword(magickaKeyword) || mgefs[index].HasKeyword(staminaKeyword)
                    utilityPot = false
                    index = 999    ; break out of while loop
                endif
                index += 1
            endwhile
            if utilityPot
                PO3_SKSEFunctions.AddKeywordToForm(base, utilityPotionKeyword)
                if magicEffectKeyword == utilityPotionKeyword
                    return true
                endif
            endif
        endif
        return false
    endif
EndFunction


Function AddKeywordsToPotion(Potion pot)
    MagicEffect[] mgefs = pot.GetMagicEffects()
    int index = 0
    bool utilityPot = true

    if pot.IsPoison()
        return
    elseif !pot.IsFood() || mcm.includeFood
        while index < mgefs.Length
            if mgefs[index].HasKeyword(healthKeyword)
                PO3_SKSEFunctions.AddKeywordToForm(pot, healthPotionKeyword)
                utilityPot = false
            elseif mgefs[index].HasKeyword(magickaKeyword)
                PO3_SKSEFunctions.AddKeywordToForm(pot, magickaPotionKeyword)
                utilityPot = false
            elseif mgefs[index].HasKeyword(staminaKeyword)
                PO3_SKSEFunctions.AddKeywordToForm(pot, staminaPotionKeyword)
                utilityPot = false
            endif
            index += 1
        endwhile
        if utilityPot
            PO3_SKSEFunctions.AddKeywordToForm(pot, utilityPotionKeyword)
        endif
    endif
EndFunction


; bool Function IsPotionType(Form base, Keyword effectKeyword)
;     FormList flist
;     if effectKeyword == healthKeyword
;         flist = HealthPotionFormList
;     elseif effectKeyword == magickaKeyword
;         flist = MagickaPotionFormList
;     elseif effectKeyword == staminaKeyword 
;         flist = StaminaPotionFormList
;     else
;         return false
;     endif
;     if flist.Find(base) >= 0
;         return true
;     elseif base as Potion
;         ; could be a crafted potion
;         Potion pot = base as Potion
;         MagicEffect[] mgefs = pot.GetMagicEffects()
;         if !pot.IsFood() || mcm.includeFood
;             int index = 0
;             while index < mgefs.Length
;                 if mgefs[index].HasKeyword(effectKeyword)
;                     flist.AddForm(base)
;                     if effectKeyword == healthKeyword
;                         PO3_SKSEFunctions.AddKeywordToForm(base, healthPotionKeyword)
;                     elseif effectKeyword == magickaKeyword
;                         PO3_SKSEFunctions.AddKeywordToForm(base, magickaPotionKeyword)
;                     elseif effectKeyword == staminaKeyword 
;                         PO3_SKSEFunctions.AddKeywordToForm(base, staminaPotionKeyword)
;                     endif
;                     return true
;                 endif
;                 index += 1
;             endwhile
;         endif
;         return false
;     else
;         return false
;     endif
; EndFunction


bool Function IsHealthPotion(Form base)
    return IsPotionType(base, healthKeyword)
EndFunction


bool Function IsMagickaPotion(Form base)
    return IsPotionType(base, magickaKeyword)
EndFunction


bool Function IsStaminaPotion(Form base)
    return IsPotionType(base, staminaKeyword)
EndFunction

bool Function IsUtilityPotion(Form base)
    return IsPotionType(base, utilityPotionKeyword)
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


string function strif(bool test, string trueStr, string falseStr)
    if test
        return trueStr
    else
        return falseStr
    endif
endfunction


; Try to get an item's direct or indirect owner (if such an owner is found, the item is stolen, or
; will be stolen if the player picks it up)
; problem - if player drops an item, then picks it up again, in a "faction-owned" cell, this function
; will think the item must be "faction-owned" as well
Form function GetOwner(ObjectReference item, ObjectReference sourceContainer = none)
    if item.GetActorOwner()
        return item.GetActorOwner()
    elseif item.GetFactionOwner()
        return item.GetFactionOwner()
    elseif sourceContainer && sourceContainer.GetActorOwner()
        return sourceContainer.GetActorOwner()
    elseif sourceContainer && sourceContainer.GetFactionOwner()
        return sourceContainer.GetFactionOwner()
    else
        Cell myCell = player.GetParentCell()
        if !myCell
            return none
        elseif myCell.GetActorOwner()
            return myCell.GetActorOwner()
        elseif myCell.GetFactionOwner()
            return myCell.GetFactionOwner()
        else
            return none
        endif
    endif
endfunction


