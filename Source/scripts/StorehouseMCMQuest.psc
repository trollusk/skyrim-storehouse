Scriptname StorehouseMCMQuest extends SKI_ConfigBase  

StorehouseQuest property shquest auto
StorehouseQuest property shplayerref auto
Actor property player auto
int property healthPotionCap auto
int property magickaPotionCap auto
int property staminaPotionCap auto
int property utilityPotionCap auto
int property poisonCap auto
int property arrowCap auto
int property lockpickCap auto
int property torchCap auto
bool property includeFood auto
bool property freeStorehouseContents auto
bool property givePower auto
Spell property storehousePower auto

; MCM option indices
int iHealthPotion
int iMagickaPotion
int iStaminaPotion
int iUtilityPotion
int iPoison
int iArrow
int iLockpick
int iTorch
int iIncludeFood
int iFreeContents
int iPower

; Event OnConfigInit()
; 	Pages = new string[5]
; 	Pages[0] = "Equipment"
; 	Pages[1] = "Magic"
; 	Pages[2] = "Subterfuge"
; 	Pages[3] = "Society"
; 	Pages[4] = "Misc"
; EndEvent


Event OnPageReset (string page)
    shplayerref.CountItemsInInventory()
	SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("Item Caps")
    AddEmptyOption()
    iHealthPotion = AddSliderOption("Health potions", healthPotionCap)
    iMagickaPotion = AddSliderOption("Magicka potions", magickaPotionCap)
    iStaminaPotion = AddSliderOption("Stamina potions", staminaPotionCap)
    iUtilityPotion = AddSliderOption("Utility potions", utilityPotionCap)
    iPoison = AddSliderOption("Poisons", poisonCap)
    iArrow = AddSliderOption("Ammunition", arrowCap)
    iLockpick = AddSliderOption("Lockpicks", lockpickCap)
    iTorch = AddSliderOption("Torches", torchCap)
    AddEmptyOption()
    iFreeContents = AddToggleOption("Storehouse can be used for general storage", freeStorehouseContents)
    iIncludeFood = AddToggleOption("Include food & drink in potion counts", includeFood)
    iPower = AddToggleOption("Access storehouse using a power", givePower)
    SetCursorPosition(1)
    AddHeaderOption("Debug Info")
    AddEmptyOption()
    AddTextOption("Carried health potions", shplayerref.healthPotionCount, OPTION_FLAG_DISABLED)
    AddTextOption("Carried magicka potions", player.GetItemCount(shplayerref.magickaPotionKeyword), OPTION_FLAG_DISABLED)
    AddTextOption("Carried stamina potions", player.GetItemCount(shplayerref.staminaPotionKeyword), OPTION_FLAG_DISABLED)
    AddTextOption("Carried utility potions", player.GetItemCount(shplayerref.utilityPotionKeyword), OPTION_FLAG_DISABLED)
    AddTextOption("Carried poisons", shplayerref.poisonCount, OPTION_FLAG_DISABLED)
    AddTextOption("Carried ranged ammo", shplayerref.ammoCount, OPTION_FLAG_DISABLED)
    AddTextOption("Carried lockpicks", shplayerref.lockpickCount, OPTION_FLAG_DISABLED)
    AddTextOption("Carried torches", shplayerref.torchCount, OPTION_FLAG_DISABLED)
EndEvent


Event OnOptionSliderOpen (int option)
    SetSliderDialogDefaultValue(0)
    SetSliderDialogRange(0, 100)
    SetSliderDialogInterval(1)
    if (option == iHealthPotion)
		SetSliderDialogStartValue(healthPotionCap)
	elseif (option == iMagickaPotion)
		SetSliderDialogStartValue(magickaPotionCap)
	elseif (option == iStaminaPotion)
		SetSliderDialogStartValue(staminaPotionCap)
	elseif (option == iUtilityPotion)
		SetSliderDialogStartValue(utilityPotionCap)
	elseif (option == iPoison)
		SetSliderDialogStartValue(poisonCap)
	elseif (option == iArrow)
		SetSliderDialogStartValue(arrowCap)
        SetSliderDialogRange(0, 200)
	elseif (option == iLockpick)
		SetSliderDialogStartValue(lockpickCap)
	elseif (option == iTorch)
		SetSliderDialogStartValue(torchCap)
	EndIf
EndEvent


Event OnOptionSliderAccept (int option, float value)
    if (option == iHealthPotion)
        healthPotionCap = value as int
		SetSliderOptionValue(iHealthPotion, healthPotionCap)
	elseif (option == iMagickaPotion)
        magickaPotionCap = value as int
		SetSliderOptionValue(iMagickaPotion, magickaPotionCap)
	elseif (option == iStaminaPotion)
        staminaPotionCap = value as int
		SetSliderOptionValue(iStaminaPotion, staminaPotionCap)
	elseif (option == iUtilityPotion)
        utilityPotionCap = value as int
		SetSliderOptionValue(iUtilityPotion, utilityPotionCap)
	elseif (option == iPoison)
        poisonCap = value as int
		SetSliderOptionValue(iPoison, poisonCap)
	elseif (option == iArrow)
        arrowCap = value as int
		SetSliderOptionValue(iArrow, arrowCap)
	elseif (option == iLockpick)
        lockpickCap = value as int
		SetSliderOptionValue(iLockpick, lockpickCap)
	elseif (option == iTorch)
        torchCap = value as int
		SetSliderOptionValue(iTorch, torchCap)
	EndIf
	ForcePageReset()
EndEvent


Event OnOptionSelect (int option)
	if option == iIncludeFood
		includeFood = !includeFood
		SetToggleOptionValue(iIncludeFood, includeFood)
    elseif option == iFreeContents
        freeStorehouseContents = !freeStorehouseContents
        SetToggleOptionValue(iFreeContents, freeStorehouseContents)
    elseif option == iPower
        givePower = !givePower
        SetToggleOptionValue(iPower, givePower)
        if givePower
            player.AddSpell(storehousePower, false)
        else
            player.RemoveSpell(storehousePower)
        endif
    endif
EndEvent


Event OnOptionHighlight(int option)
	if option == iHealthPotion
		SetInfoText("The maximum number of health potions that the player may carry. Zero means there is no maximum.")
	elseif option == iMagickaPotion
		SetInfoText("The maximum number of magicka potions that the player may carry. Zero means there is no maximum.")
	elseif option == iStaminaPotion
		SetInfoText("The maximum number of stamina potions that the player may carry. Zero means there is no maximum.")
	elseif option == iUtilityPotion
		SetInfoText("The maximum number of utility potions that the player may carry. A utility potion is any potion that does NOT restore health, magicka or stamina. Zero means there is no maximum.")
	elseif option == iPoison
		SetInfoText("The maximum number of poisons that the player may carry. Zero means there is no maximum.")
	elseif option == iLockpick
		SetInfoText("The maximum number of lockpicks that the player may carry. Zero means there is no maximum.")
	elseif option == iTorch
		SetInfoText("The maximum number of torches that the player may carry. Zero means there is no maximum.")
	elseif option == iArrow
		SetInfoText("The maximum number of arrows and bolts that the player may carry. Zero means there is no maximum.")
	elseif option == iIncludeFood
		SetInfoText("If true, foods or drinks that restore health, stamina or magicka will be counted as potions.")
	elseif option == iFreeContents
		SetInfoText("If true, you can store any item in the storehouse container. If false, the container will reject any item that is not a potion, lockpick or ammunition.")
	elseif option == iPower
		SetInfoText("If true, you will receive a Power which you can use to access the storehouse in inns and other safe locations. This may be useful if the safehouse chests are hidden by other mods that modify their cells.")
	endif
EndEvent


