Scriptname StorehouseQuest extends ReferenceAlias  

StorehouseMCMQuest property mcm auto
Actor property player auto
Furniture property RBCModFire1 auto
Furniture property RBCModFire2 auto
ObjectReference Property BottomlessBox  Auto  
Form property lockpickBase auto

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


Event OnInit()
    InitStorehouse()
EndEvent


Event OnPlayerLoadGame()
    InitStorehouse()
EndEvent


Function InitStorehouse()
    ; "MagicAlchRestoreMagicka" "MagicAlchRestoreStamina" "VendorItemPoison"
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
        toStore = Max(0, (lockpickCount + count) - mcm.lockpickCap)
        ; lockpickCount = Min(lockpickCount + count, lockpickCap)
        itemName = "lockpicks"
        debug.Notification("Acquired " + count + " lockpicks (prior count " + lockpickCount + ", cap " + mcm.lockpickCap + ")")
        lockpickCount += Max(0, count - toStore)
    elseif mcm.poisonCap > 0 && (base as Potion).IsPoison()
        itemName = "poisons"
        debug.Notification("Acquired " + count + " poisons (prior count " + poisonCount + ", cap " + mcm.poisonCap + ")")
        poisonCount += Max(0, count - toStore)
    elseif mcm.arrowCap > 0 && (base as Ammo)
        itemName = "arrows"
        debug.Notification("Acquired " + count + " arrows (prior count " + ammoCount + ", cap " + mcm.arrowCap + ")")
        ammoCount += Max(0, count - toStore)
    elseif mcm.healthPotionCap > 0 && IsHealthPotion(base)
        toStore = Max(0, (healthPotionCount + count) - mcm.healthPotionCap)
        itemName = "health potions"
        debug.Notification("Acquired " + count + " health potions (prior count " + healthPotionCount + ", cap " + mcm.healthPotionCap + ")")
        healthPotionCount += Max(0, count - toStore)
    elseif mcm.magickaPotionCap > 0 && IsMagickaPotion(base)
        toStore = Max(0, (magickaPotionCount + count) - mcm.magickaPotionCap)
        itemName = "magicka potions"
        debug.Notification("Acquired " + count + " magicka potions (prior count " + magickaPotionCount + ", cap " + mcm.magickaPotionCap + ")")
        magickaPotionCount += Max(0, count - toStore)
    elseif mcm.staminaPotionCap > 0 && IsStaminaPotion(base)
        toStore = Max(0, (staminaPotionCount + count) - mcm.staminaPotionCap)
        itemName = "stamina potions"
        debug.Notification("Acquired " + count + " stamina potions (prior count " + staminaPotionCount + ", cap " + mcm.staminaPotionCap + ")")
        staminaPotionCount += Max(0, count - toStore)
    endif

    if toStore > 0
        debug.Notification("Sending " + Min(toStore, count) + " excess " + itemName + " to storehouse...")
        player.RemoveItem(base, Min(toStore, count), false, BottomlessBox)
    endif
EndEvent


Event OnItemRemoved(Form base, int count, ObjectReference itemref, ObjectReference dest)
    if mcm.lockpickCap > 0 && base == lockpickBase
        debug.Notification("Lost " + count + " lockpicks (prior count " + lockpickCount + ", cap " + mcm.lockpickCap + ")")
        lockpickCount = Max(0, lockpickCount - count)
    elseif mcm.arrowCap > 0 && (base as Ammo)
        debug.Notification("Lost " + count + " ammo (prior count " + ammoCount + ", cap " + mcm.arrowCap + ")")
        ammoCount = Max(0, ammoCount - count)
    elseif mcm.poisonCap > 0 && (base as Potion).IsPoison()
        debug.Notification("Lost " + count + " poisons (prior count " + poisonCount + ", cap " + mcm.poisonCap + ")")
        poisonCount = Max(0, poisonCount - count)
    elseif mcm.healthPotionCap > 0 && IsHealthPotion(base)
        debug.Notification("Lost " + count + " health potions (prior count " + healthPotionCount + ", cap " + mcm.healthPotionCap + ")")
        healthPotionCount = Max(0, healthPotionCount - count)
    elseif mcm.magickaPotionCap > 0 && IsMagickaPotion(base)
        debug.Notification("Lost " + count + " magicka potions (prior count " + magickaPotionCount + ", cap " + mcm.magickaPotionCap + ")")
        magickaPotionCount = Max(0, magickaPotionCount - count)
    elseif mcm.staminaPotionCap > 0 && IsStaminaPotion(base)
        debug.Notification("Lost " + count + " stamina potions (prior count " + staminaPotionCount + ", cap " + mcm.staminaPotionCap + ")")
        staminaPotionCount = Max(0, staminaPotionCount - count)
    endif
EndEvent


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
    debug.Notification("Syncing bottomless box!")
    ; todo
    ; - count number of lockpicks in player inventory
    ; - if lockpickCount < lockpickCap
    ;   - find all lockpicks in player inventory
    ;   - move (cap - count) picks to player inventory
    int lockpickStored = BottomlessBox.GetItemCount(lockpickBase)
    int healthPotionStored = BottomlessBox.GetItemCount(HealthPotionFormList)
    int magickaPotionStored = BottomlessBox.GetItemCount(MagickaPotionFormList)
    int staminaPotionStored = BottomlessBox.GetItemCount(StaminaPotionFormList)
    int ammoStored = BottomlessBox.GetItemCount(ammoKeyword)
    int poisonStored = BottomlessBox.GetItemCount(poisonKeyword)
    debug.Notification("Box: lockpicks " + lockpickStored + ", health potions " + healthPotionStored + ", magicka " + magickaPotionStored)
    debug.Notification("Box: stamina " + staminaPotionStored + ", poisons " + poisonStored + ", ammo " + ammoStored)

    if lockpickCount < mcm.lockpickCap && lockpickStored > 0
        int toMove = Min(lockpickStored, mcm.lockpickCap - lockpickCount)
        BottomlessBox.RemoveItem(lockpickBase, toMove, false, player)
        lockpickCount -= toMove
    endif
endfunction


bool Function IsHealthPotion(Form base)
    Potion pot = base as Potion
    MagicEffect mgef = pot.GetNthEffectMagicEffect(pot.GetCostliestEffectIndex())
    if pot
        ;debug.Notification("potion " + base.GetName() + " has health keyword=" + mgef.HasKeyword(healthKeyword))
    endif
    return mgef.HasKeyword(healthKeyword)
EndFunction


bool Function IsMagickaPotion(Form base)
    Potion pot = base as Potion
    MagicEffect mgef = pot.GetNthEffectMagicEffect(pot.GetCostliestEffectIndex())
    if pot
        ;debug.Notification("potion " + base.GetName() + " has magicka keyword=" + mgef.HasKeyword(magickaKeyword))
    endif
    return mgef.HasKeyword(magickaKeyword)
EndFunction


bool Function IsStaminaPotion(Form base)
    Potion pot = base as Potion
    MagicEffect mgef = pot.GetNthEffectMagicEffect(pot.GetCostliestEffectIndex())
    if pot
        ;debug.Notification("potion " + base.GetName() + " has stamina keyword=" + mgef.HasKeyword(staminaKeyword))
    endif
    return mgef.HasKeyword(staminaKeyword)
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

