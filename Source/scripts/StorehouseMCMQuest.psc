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
bool property includeFood auto

; MCM option indices
int iHealthPotion
int iMagickaPotion
int iStaminaPotion
int iUtilityPotion
int iPoison
int iArrow
int iLockpick
int iIncludeFood

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
    AddEmptyOption()
    iIncludeFood = AddToggleOption("Include food & drink in potion counts", includeFood)
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
	EndIf
	ForcePageReset()
EndEvent


Event OnOptionSelect (int option)
	if option == iIncludeFood
		includeFood = !includeFood
		SetToggleOptionValue(iIncludeFood, includeFood)
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
	elseif option == iArrow
		SetInfoText("The maximum number of arrows and bolts that the player may carry. Zero means there is no maximum.")
	elseif option == iIncludeFood
		SetInfoText("If true, foods or drinks that restore health, stamina or magicka will be counted as potions.")
	endif
EndEvent


