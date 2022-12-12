int property lockpickCap auto
int property healthPotionCap auto

int property lockpickCount auto
int property healthPotionCount auto

Form property lockpickBase auto
Form[] property healthPotionList

Keyword[] healthPotionKeywords
int FORMTYPE_POTION = 46


Event OnPlayerLoadGame()
    healthPotionKeywords = new Keyword[10]
    healthPotionKeywords[0] = SKSE.GetKeyword("healing")
    healthPotionList = PO3.GetAllForms(FORMTYPE_POTION, healthPotionKeywords)
    AddInventoryEventFilter(healthPotionList)
    AddInventoryEventFilter(lockpickBase)
EndEvent


Event OnItemAdded(Form base, int count, ObjectReference itemref, ObjectReference source)
    string itemName = "items"
    if base == lockpickBase
        toStore = Max(0, (lockpickCount + count) - lockpickCap)
        ; lockpickCount = Min(lockpickCount + count, lockpickCap)
        itemName = "lockpicks"
    elseif healthPotionList.Find(base) > 0
        toStore = Max(0, (healthPotionCount + count) - healthPotionCap)
        itemName = "health potions"
    endif

    if toStore > 0
    debug.Notification("Sending " + Min(toStore, count) + " excess " + itemName + " to storehouse...")
        player.RemoveItem(itemref, Min(toStore, count), false, BottomlessBox)
    endif
EndEvent


Event OnItemRemoved(Form base, int count, ObjectReference itemref, ObjectReference dest)
    if base == lockpickBase
        lockpickCount = Max(0, lockpickCount - count)
    elseif healthPotionList.Find(base) > 0
        healthPotionCount = Max(0, healthPotionCount - count)
    endif
EndEvent


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
