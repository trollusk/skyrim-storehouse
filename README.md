# Storehouse - Shared Stash and Limits to Carried Consumables

### Requirements ###

* SkyUI
* SKSE
* [Powerofthree's Papyrus Extender](https://www.nexusmods.com/skyrimspecialedition/mods/22854)
* (Optional) [Rest By Campfire](https://www.nexusmods.com/skyrimspecialedition/mods/41271)

### What does this mod do? ###

* Adds a chest to all inns, player houses, and other "player base" locations. All of these chests access a single shared container, similar to the "stash" in the Diablo series or The Witcher 3, or the "bank" in an MMO.
* Allows you to place per-category limits on how many consumable items the player can carry (potions, poisons, lockpicks and ammunition). 
* When you pick up excess items, they are sent to the storehouse.
* When you enter an inn or player house, your consumables will be automatically replenished from your storehouse, if possible.
* Optionally, your consumables can be replenished whenever you rest at a campfire.


### Explanation ###

There are several existing mods which place limits on how many consumable items the player can carry. The motivation behind these mods, and my mod, is to increase challenge by limiting player resources. 

The existing mods mainly differ in how they deal with excess items:

1. **Hard limit**: picking up excess items is either completely prevented, or the player immediately drops the item again. [Potions and Lockpicks Limiter](https://www.nexusmods.com/skyrimspecialedition/mods/42703), [RAB Inventory Limits](https://www.nexusmods.com/skyrimspecialedition/mods/23396).
2. **Soft limit**: while carrying excess items, the player suffers from some sort of debuff such as reduced stamina regeneration, or increased encumbrance. [Hardcore Capacity](https://www.nexusmods.com/skyrimspecialedition/mods/26486), [Carry That Weight](https://www.nexusmods.com/skyrimspecialedition/mods/50144).

Problems with the above approaches:

* It's not fun to have to constantly interrupt gameplay to micromanage inventory, or to trek back and forth between an adventuring location and a storage chest. The "hard limit" approach leads to more of this type of un-fun (for me) in-game activity.
* Debuffs that are insufficiently troublesome will end up being ignored by the player.
* Debuffs that are too troublesome are effectively "hard limits" - see above.
* Forced dropping of items can be a problem if you don't notice that the item was dropped, or if it falls somewhere unreachable.

#### My solution:

The Soulslike games [Nioh](https://store.steampowered.com/app/485510/Nioh_Complete_Edition/) and [Nioh 2](https://store.steampowered.com/app/1325200/Nioh_2__The_Complete_Edition/) have a system called the "storehouse". This is similar to the "bottomless box" from Dark Souls, or the Diablo "stash" - a shared storage container that is accessible from numerous safe locations throughout the world. The player is able to carry only limited numbers of healing potions and ranged ammunition. When the player finds extra ammunition or healing potions while exploring, they can still pick them up, but any items that would exceed the allowed limit are teleported to the storehouse. 

When the player reaches a safe location (shrine), their stock of healing potions and ammunition is replenished from the storehouse, if possible. They can also directly access the contents of the storehouse while at a shrine, in order to store or retrieve other items.

This seems like an elegant way to limit player resources, while avoiding the problems discussed above. Resources are limited, but flow of gameplay is never interrupted by inventory management.

#### How this mod works:

In the MCM, you can set separate limits for: 

* restore health potions
* restore magicka potions
* restore stamina potions
* utility potions (any potion that doesn't fit into the above categories)
* poisons
* ammunition (arrows and bolts)
* lockpicks

If any of these limits are set to zero, that means the item category is ignored (not limited).

You can also choose whether foods that restore attributes should count as potions, and whether the storehouse is restricted to only being able to hold the above item types, rather than all items.

When you acquire items that would put your carried item count over the limit, the excess items are sent to the storehouse.

When you enter an inn or other safe location, your carried item totals are calculated for each category. Any excess items will be sent to the storehouse. However if you are carrying fewer items than the limit, items will be automatically moved from the storehouse back to your inventory to make up the shortfall.

If you have ammo equipped, matching ammo will be preferentially pulled from the storehouse. Similarly, potions and poisons that match what you are already carrying will be preferred.

If you find the storehouse chest (usually near a bed), you can interact with it to adjust what items you are carrying. You can also store or retrieve other items (unless you have chosen to disallow this in the MCM).

### Locations with storehouse chests ###

All player houses (excluding Hearthfire player-built houses)
All inns
The Drunken Huntsman (Whiterun)
The Stumbling Sabrecat (Fort Dunstad, south of Dawnstar)
The Ragged Flagon (Riften sewers)
Dark Brotherhood Sanctuary
Jorrvaskr sleeping quarters
Hall of Attainment and Hall of Countenance (Winterhold College)
Sky Haven Temple
Fort Dawnguard

### My other mods ###

* [Respawn - Soulslike Edition](https://www.nexusmods.com/skyrimspecialedition/mods/69267) - when you are killed, drop your gold or valuables in a grave and respawn at the last campfire or bed.
* [Gold Is Souls](https://www.nexusmods.com/skyrimspecialedition/mods/69892) - Soulslike leveling system for Skyrim, using gold as "souls".
* [Constraints](https://www.nexusmods.com/skyrimspecialedition/mods/71014) - impose various voluntary constraints on your character, to enhance roleplay.


