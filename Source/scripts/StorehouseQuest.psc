Scriptname StorehouseQuest extends ReferenceAlias  

StorehouseMCMQuest property mcm auto
Actor property player auto
Furniture property RBCModFire1 auto
Furniture property RBCModFire2 auto
ObjectReference Property BottomlessBox  Auto  
FormList Property SBMEstusFlaskFormList  Auto   ; Soulslike Bonfire Menu list of "estus flask" potions
ObjectReference property DefaultStorehouseContainer auto    ; alternative to SBM container, not currently used
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

int lockpickStored
int ammoStored 
int healthPotionStored 
int magickaPotionStored 
int staminaPotionStored 
int poisonStored 

Keyword property healthKeyword auto
Keyword property staminaKeyword auto
Keyword property magickaKeyword auto
Keyword property healthPotionKeyword auto
Keyword property staminaPotionKeyword auto
Keyword property magickaPotionKeyword auto
Keyword property poisonKeyword auto
Keyword property ammoKeyword auto


; TODO on init, formlist.AddForm(base) for each health potion etc
; TODO BB should remove all excess items as well as replenishing

Event OnInit()
    InitStorehouse()
EndEvent


Event OnPlayerLoadGame()
    ;RemoveAllInventoryEventFilters()
    InitStorehouse()
EndEvent


Function InitStorehouse()
    ; iterate through player and BB
    ; ensure all relevant potions/poisons are in flists

    int index = 0
    Form[] potions = PO3_SKSEFunctions.GetAllForms(TYPE_POTION)

    index = 0
    debug.Notification("Ensuring all potions have correct keywords...")
    while index < potions.Length
        Potion pot = potions[index] as Potion
        if pot.IsPoison()
            ;
        elseif !pot.IsFood() || mcm.includeFood
            IsHealthPotion(pot)        ; called for side effect of adding keyword
            IsMagickaPotion(pot)
            IsStaminaPotion(pot)
        endif
        index += 1
    endwhile

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

    debug.Notification("Searching player inventory for unrecognised potions...")
    index = 0
    while index < player.GetNumItems()
        Form item = player.GetNthForm(index)
        if item as Potion && PO3_SKSEFunctions.IsGeneratedForm(item)
            IsHealthPotion(item)        ; called for side effect of adding to formlist
            IsMagickaPotion(item)
            IsStaminaPotion(item)
        endif
        index += 1
    endwhile

    index = 0
    debug.Notification("Searching storehouse for unrecognised potions...")
    while index < BottomlessBox.GetNumItems()
        Form item = BottomlessBox.GetNthForm(index)
        if item as Potion && PO3_SKSEFunctions.IsGeneratedForm(item)
            IsHealthPotion(item)        ; called for side effect of adding to formlist
            IsMagickaPotion(item)
            IsStaminaPotion(item)
        endif
        index += 1
    endwhile
    debug.Notification("Finished initialising storehouse.")
EndFunction


int IT_ALL = 0
int IT_HEALTH_POTION = 1
int IT_MAGICKA_POTION = 2
int IT_STAMINA_POTION = 3
int IT_POISON = 4
int IT_AMMO = 5
int IT_LOCKPICK = 6


int Function CountItemsInInventory(int itemType = 0, bool storehouse = false)
    Form[] potArray
    int index = 0

    if storehouse
        if itemType == IT_LOCKPICK || itemType == IT_ALL
            lockpickStored = BottomlessBox.GetItemCount(lockpickBase)
        endif
        if itemType == IT_AMMO || itemType == IT_ALL
            ammoStored = BottomlessBox.GetItemCount(ammoKeyword)
        endif
        if itemType == IT_HEALTH_POTION || itemType == IT_ALL
            ; healthPotionStored = BottomlessBox.GetItemCount(HealthPotionFormList)
            healthPotionStored = BottomlessBox.GetItemCount(healthPotionKeyword)
        endif
        if itemType == IT_MAGICKA_POTION || itemType == IT_ALL
            magickaPotionStored = BottomlessBox.GetItemCount(magickaPotionKeyword)
        endif
        if itemType == IT_STAMINA_POTION || itemType == IT_ALL
            staminaPotionStored = BottomlessBox.GetItemCount(staminaPotionKeyword)
        endif
        if itemType == IT_POISON || itemType == IT_ALL
            poisonStored = BottomlessBox.GetItemCount(poisonKeyword)
        endif
    else
        if itemType == IT_LOCKPICK || itemType == IT_ALL
            lockpickCount = player.GetItemCount(lockpickBase)
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
        elseif itemType == IT_POISON
            return poisonStored
        elseif itemType == IT_AMMO
            return ammoStored
        elseif itemType == IT_LOCKPICK
            return lockpickStored
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
        elseif itemType == IT_POISON
            return poisonCount
        elseif itemType == IT_AMMO
            return ammoCount
        elseif itemType == IT_LOCKPICK
            return lockpickCount
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

    consoleutil.PrintMessage("ItemAdded ref name:" + itemref.GetDisplayName() + ", base:" + base + " / " + PO3_SKSEFunctions.GetFormEditorID(base) + " / " + base.GetName())
    consoleutil.PrintMessage("  IsHealthPotion:" + IsHealthPotion(base) + ", formlist:" + HealthPotionFormList.Find(base))
    ConsoleUtil.PrintMessage("  health potions now in inventory (not counting this): " + CountItemsInInventory(IT_HEALTH_POTION) + ", count of this item in inventory:" + player.GetItemCount(base))
    ConsoleUtil.PrintMessage("  keyword[0]: " + base.GetNthKeyword(0) + ", keyword[1]: " + base.GetNthKeyword(1))
    if mcm.lockpickCap > 0 && base == lockpickBase
        itemName = "lockpick"
        itemNamePlural = "lockpicks"
        lockpickCount = player.GetItemCount(lockpickBase)
        toStore = Max(0, lockpickCount - mcm.lockpickCap)
        ;consoleutil.PrintMessage("Acquired " + count + " lockpicks (count now " + lockpickCount + ", cap " + mcm.lockpickCap + ")")
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
        consoleutil.PrintMessage("ref name:" + itemref.GetDisplayName() + ", base:" + base + " / " + PO3_SKSEFunctions.GetFormEditorID(base) + " / " + base.GetName())
        consoleutil.PrintMessage("base generated:" + PO3_SKSEFunctions.IsGeneratedForm(base) + "IsHealthPotion:" + IsHealthPotion(base) + ", formlist:" + HealthPotionFormList.Find(base))
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
    endif

    if Min(toStore, count) > 0
        debug.Notification("Sent " + Min(toStore, count) + " " + strif(Min(toStore, count)==1, itemName, itemNamePlural) + " to storehouse...")
        player.RemoveItem(base, Min(toStore, count), true, BottomlessBox)
    endif
EndEvent


Event OnSit(ObjectReference furn)
	Form furnBase = furn.GetBaseObject()
	;consoleutil.PrintMessage("(RBC) Sitting on base =" + furnBase + "  " + furnBase.GetFormID() + "  " + furnBase.GetName())
		
	if ((furnBase == RBCModFire1) || (furnBase == RBCModFire2))
		;consoleutil.PrintMessage("Sitting at campfire! (Rest By Campfire.esp)")
		SyncBottomlessBox()
		return
	endif
	
	;consoleutil.PrintMessage("(RBC) No campfire detected")
EndEvent


function SyncBottomlessBox()
    int toMove = 0
    int index = 0
    Form[] potStoredArray
    Form[] poisonsStoredArray
    Form[] healthStoredArray
    Form[] magickaStoredArray
    Form[] staminaStoredArray

    CountItemsInInventory(IT_ALL)            ; player inventory
    CountItemsInInventory(IT_ALL, true)      ; storehouse

    ; crafted potions/poisons have arbitrary base forms that are created on the fly. 
    ; potStoredArray = PO3_SKSEFunctions.AddItemsOfTypeToArray(BottomlessBox, TYPE_POTION, true,false,true)
    ; while index < potStoredArray.Length
    ;     Potion pot = potStoredArray[index] as Potion
    ;     if mcm.poisonCap > 0 && pot.IsPoison()
    ;         poisonStored += BottomlessBox.GetItemCount(pot)
    ;     Else
    ;         if mcm.healthPotionCap > 0 && IsHealthPotion(pot)
    ;             healthPotionStored += BottomlessBox.GetItemCount(pot)
    ;         endif
    ;         if mcm.magickaPotionCap > 0 && IsMagickaPotion(pot)
    ;             magickaPotionStored += BottomlessBox.GetItemCount(pot)
    ;         endif
    ;         if mcm.staminaPotionCap > 0 && IsStaminaPotion(pot)
    ;             staminaPotionStored += BottomlessBox.GetItemCount(pot)
    ;         endif
    ;     endif
    ;     index += 1
    ; endwhile
    ;consoleutil.PrintMessage("(Box/player) Lockpicks " + lockpickStored + "/" + lockpickCount + ", health potions " + healthPotionStored + "/" + healthPotionCount + ", magicka " + magickaPotionStored + "/" + magickaPotionCount)
    ;consoleutil.PrintMessage("(Box/player) Stamina " + staminaPotionStored + "/" + staminaPotionCount + ", poisons " + poisonStored + "/" + poisonCount + ", ammo " + ammoStored + "/" + ammoCount)

    if mcm.lockpickCap > 0 
        if lockpickCount > mcm.lockpickCap
            toMove = lockpickCount - mcm.lockpickCap
            player.RemoveItem(lockpickBase, toMove, true, BottomlessBox)
            debug.Notification("Sent " + toMove + " " + strif(toMove==1,"lockpick", "lockpicks") + " to the storehouse.")
        elseif lockpickCount < mcm.lockpickCap && lockpickStored > 0
            toMove = Min(lockpickStored, mcm.lockpickCap - lockpickCount)
            BottomlessBox.RemoveItem(lockpickBase, toMove, true, player)
            debug.Notification("Fetched " + toMove + " " + strif(toMove==1,"lockpick", "lockpicks") + " from the storehouse.")
            lockpickCount -= toMove
        endif
    endif

    ; if mcm.poisonCap > 0 
    ;     if poisonCount > mcm.poisonCap
    ;         toMove = poisonCount - mcm.poisonCap
    ;         index = 0
    ;         int toMoveAim = toMove
    ;         while index < player.GetNumItems() && toMove > 0
    ;             Form item = player.GetNthForm(index)
    ;             if item as Potion && (item as Potion).IsPoison()
    ;                 int count = player.GetItemCount(item)
    ;                 player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
    ;                 toMove -= Min(count, toMove)
    ;             endif
    ;             index += 1
    ;         endwhile
    ;         debug.Notification("Sent " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"poison", "poisons") + " to the storehouse.")
    ;     elseif poisonCount < mcm.poisonCap && poisonStored > 0
    ;         toMove = Min(poisonStored, mcm.poisonCap - poisonCount)
    ;         index = 0
    ;         int toMoveAim = toMove
    ;         while index < BottomlessBox.GetNumItems() && toMove > 0
    ;             Form item = BottomlessBox.GetNthForm(index)
    ;             if item as Potion && (item as Potion).IsPoison()
    ;                 int count = BottomlessBox.GetItemCount(item)
    ;                 BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
    ;                 toMove -= Min(count, toMove)
    ;             endif
    ;             index += 1
    ;         endwhile
    ;         debug.Notification("Fetched " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"poison", "poisons") + " from the storehouse.")
    ;     endif
    ; endif

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

    ; if mcm.healthPotionCap > 0 
    ;     if healthPotionCount > mcm.healthPotionCap
    ;         toMove = healthPotionCount - mcm.healthPotionCap
    ;         index = 0
    ;         int toMoveAim = toMove
    ;         while index < player.GetNumItems() && toMove > 0
    ;             Form item = player.GetNthForm(index)
    ;             if IsHealthPotion(item)
    ;                 int count = player.GetItemCount(item)
    ;                 player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
    ;                 toMove -= Min(count, toMove)
    ;             endif
    ;             index += 1
    ;         endwhile
    ;         debug.Notification("Sent " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"health potion", "health potions") + " to the storehouse.")
    ;     elseif healthPotionCount < mcm.healthPotionCap && healthPotionStored > 0
    ;         toMove = Min(healthPotionStored, mcm.healthPotionCap - healthPotionCount)
    ;         index = 0
    ;         int toMoveAim = toMove
    ;         while index < BottomlessBox.GetNumItems() && toMove > 0
    ;             Form item = BottomlessBox.GetNthForm(index)
    ;             if IsHealthPotion(item)
    ;                 int count = BottomlessBox.GetItemCount(item)
    ;                 BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
    ;                 toMove -= Min(count, toMove)
    ;             endif
    ;             index += 1
    ;         endwhile
    ;         debug.Notification("Fetched " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"health potion", "health potions") + " from the storehouse.")
    ;     endif
    ; endif

    ; if mcm.magickaPotionCap > 0 
    ;     if magickaPotionCount > mcm.magickaPotionCap
    ;         toMove = magickaPotionCount - mcm.magickaPotionCap
    ;         index = 0
    ;         int toMoveAim = toMove
    ;         while index < player.GetNumItems() && toMove > 0
    ;             Form item = player.GetNthForm(index)
    ;             if IsMagickaPotion(item)
    ;                 int count = player.GetItemCount(item)
    ;                 player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
    ;                 toMove -= Min(count, toMove)
    ;             endif
    ;             index += 1
    ;         endwhile
    ;         debug.Notification("Sent " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"magicka potion", "magicka potions") + " to the storehouse.")
    ;     elseif magickaPotionCount < mcm.magickaPotionCap && magickaPotionStored > 0
    ;         toMove = Min(magickaPotionStored, mcm.magickaPotionCap - magickaPotionCount)
    ;         index = 0
    ;         int toMoveAim = toMove
    ;         while index < BottomlessBox.GetNumItems() && toMove > 0
    ;             Form item = BottomlessBox.GetNthForm(index)
    ;             if IsMagickaPotion(item)
    ;                 int count = BottomlessBox.GetItemCount(item)
    ;                 BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
    ;                 toMove -= Min(count, toMove)
    ;             endif
    ;             index += 1
    ;         endwhile
    ;         debug.Notification("Fetched " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"magicka potion", "magicka potions") + " from the storehouse.")
    ;     endif
    ; endif

    ; if mcm.staminaPotionCap > 0
    ;     if staminaPotionCount > mcm.staminaPotionCap 
    ;         toMove = staminaPotionCount - mcm.staminaPotionCap
    ;         index = 0
    ;         int toMoveAim = toMove
    ;         while index < player.GetNumItems() && toMove > 0
    ;             Form item = player.GetNthForm(index)
    ;             if IsStaminaPotion(item)
    ;                 int count = player.GetItemCount(item)
    ;                 player.RemoveItem(item, Min(count, toMove), false, BottomlessBox)
    ;                 toMove -= Min(count, toMove)
    ;             endif
    ;             index += 1
    ;         endwhile
    ;         debug.Notification("Sent " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"stamina potion", "stamina potions") + " to the storehouse.")
    ;     elseif staminaPotionCount < mcm.staminaPotionCap && staminaPotionStored > 0
    ;         toMove = Min(staminaPotionStored, mcm.staminaPotionCap - staminaPotionCount)
    ;         index = 0
    ;         int toMoveAim = toMove
    ;         while index < BottomlessBox.GetNumItems() && toMove > 0
    ;             Form item = BottomlessBox.GetNthForm(index)
    ;             if IsStaminaPotion(item)
    ;                 int count = BottomlessBox.GetItemCount(item)
    ;                 BottomlessBox.RemoveItem(item, Min(count, toMove), false, player)
    ;                 toMove -= Min(count, toMove)
    ;             endif
    ;             index += 1
    ;         endwhile
    ;         debug.Notification("Fetched " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"stamina potion", "stamina potions") + " from the storehouse.")
    ;     endif
    ; endif
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
                elseif (kwd==poisonKeyword && item.IsPoison()) || (kwd==healthPotionKeyword && IsHealthPotion(item)) || (kwd==magickaPotionKeyword && IsMagickaPotion(item)) || (kwd==staminaPotionKeyword && IsStaminaPotion(item))
                    int count = player.GetItemCount(item)
                    player.RemoveItem(item, Min(count, toMove), true, BottomlessBox)
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
            while index < BottomlessBox.GetNumItems() && toMove > 0
                Potion item = BottomlessBox.GetNthForm(index) as Potion
                if !item
                    ;
                elseif (kwd==poisonKeyword && item.IsPoison()) || (kwd==healthPotionKeyword && IsHealthPotion(item)) || (kwd==magickaPotionKeyword && IsMagickaPotion(item)) || (kwd==staminaPotionKeyword && IsStaminaPotion(item))
                    if player.GetItemCount(item) > 0        ; only want potions that match what the player already has
                        int count = BottomlessBox.GetItemCount(item)
                        BottomlessBox.RemoveItem(item, Min(count, toMove), true, player)
                        toMove -= Min(count, toMove)
                    endif
                endif
                index += 1
            endwhile
            ; second pass - accept potions that are unlike the potions carried by the player
            index = 0
            while index < BottomlessBox.GetNumItems() && toMove > 0
                Potion item = BottomlessBox.GetNthForm(index) as Potion
                if !item
                    ;
                elseif (kwd==poisonKeyword && item.IsPoison()) || (kwd==healthPotionKeyword && IsHealthPotion(item)) || (kwd==magickaPotionKeyword && IsMagickaPotion(item)) || (kwd==staminaPotionKeyword && IsStaminaPotion(item))
                    if player.GetItemCount(item) == 0        ; we aren't already carrying this type of potion
                        int count = BottomlessBox.GetItemCount(item)
                        BottomlessBox.RemoveItem(item, Min(count, toMove), true, player)
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
                player.RemoveItem(item, Min(count, toMove), true, BottomlessBox)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile

        index = 0
        while index < player.GetNumItems() && toMove > 0
            Ammo item = player.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() == usingBolts
                int count = player.GetItemCount(item)
                player.RemoveItem(item, Min(count, toMove), true, BottomlessBox)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile

        if toMove > 0 && equippedAmmo
            int count = player.GetItemCount(equippedAmmo)
            player.RemoveItem(equippedAmmo, Min(count, toMove), true, BottomlessBox)
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
            int count = BottomlessBox.GetItemCount(equippedAmmo)
            BottomlessBox.RemoveItem(equippedAmmo, Min(count, toMove), true, player)
            toMove -= Min(count, toMove)
        endif

        index = 0
        while index < BottomlessBox.GetNumItems() && toMove > 0
            Ammo item = BottomlessBox.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() == usingBolts
                int count = BottomlessBox.GetItemCount(item)
                BottomlessBox.RemoveItem(item, Min(count, toMove), true, player)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile

        index = 0
        while index < BottomlessBox.GetNumItems() && toMove > 0
            Ammo item = BottomlessBox.GetNthForm(index) as Ammo
            if item && item != equippedAmmo && item.IsBolt() != usingBolts
                int count = BottomlessBox.GetItemCount(item)
                BottomlessBox.RemoveItem(item, Min(count, toMove), true, player)
                toMove -= Min(count, toMove)
            endif
            index += 1
        endwhile
        debug.Notification("Fetched " + (toMoveAim - toMove) + " " + strif((toMoveAim - toMove)==1,"arrow/bolt", "arrows/bolts") + " from the storehouse.")
    endif
EndFunction


bool Function IsPotionType(Form base, Keyword effectKeyword)
    Keyword kwd
    if effectKeyword == healthKeyword
        kwd = healthPotionKeyword
    elseif effectKeyword == magickaKeyword
        kwd = magickaPotionKeyword
    elseif effectKeyword == staminaKeyword 
        kwd = staminaPotionKeyword
    else
        return false
    endif
    if base.HasKeyword(kwd)
        return true
    elseif base as Potion
        ; could be a crafted potion
        Potion pot = base as Potion
        MagicEffect[] mgefs = pot.GetMagicEffects()
        if !pot.IsFood() || mcm.includeFood
            int index = 0
            while index < mgefs.Length
                if mgefs[index].HasKeyword(effectKeyword)
                    ;flist.AddForm(base)
                    if effectKeyword == healthKeyword
                        PO3_SKSEFunctions.AddKeywordToForm(base, healthPotionKeyword)
                    elseif effectKeyword == magickaKeyword
                        PO3_SKSEFunctions.AddKeywordToForm(base, magickaPotionKeyword)
                    elseif effectKeyword == staminaKeyword 
                        PO3_SKSEFunctions.AddKeywordToForm(base, staminaPotionKeyword)
                    endif
                    return true
                endif
                index += 1
            endwhile
        endif
        return false
    else
        return false
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

