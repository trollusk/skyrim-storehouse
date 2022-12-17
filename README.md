# Nioh Storehouse - Limit Carried Items

### Requirements ###

* SkyUI
* SKSE
* [Powerofthree's Papyrus Extender](https://www.nexusmods.com/skyrimspecialedition/mods/22854)
* [Rest By Campfire](https://www.nexusmods.com/skyrimspecialedition/mods/41271)
* [Rest By Campfire - Souls-like Bonfire Menu](https://www.nexusmods.com/skyrimspecialedition/mods/42755)

### What does this mod do? ###

* Place per-category limits on how many consumable items the player can carry (potions, poisons, lockpicks and ammunition). 
* When you pick up excess items, they are sent to a universal stash which is accessible when resting at campfires.
* When resting at a campfire, your consumables will be replenished from your stash, if possible.

### Explanation ###

There are several existing mods which place limits on how many consumable items the player can carry. The motivation behind these mods, and my mod, is to increase challenge by limiting player resources. 

The existing mods mainly differ in how they deal with excess items:

1. **Hard limit**: picking up excess items is either prevented, or the player immediately drops the item again. [Potions and Lockpicks Limiter](https://www.nexusmods.com/skyrimspecialedition/mods/42703), [RAB Inventory Limits](https://www.nexusmods.com/skyrimspecialedition/mods/23396).
2. **Soft limit**: while carrying excess items, the player suffers from some sort of debuff such as reduced stamina regeneration, or increased encumbrance. [Hardcore Capacity](https://www.nexusmods.com/skyrimspecialedition/mods/26486), [Carry That Weight](https://www.nexusmods.com/skyrimspecialedition/mods/50144).

Problems with the above approaches:

* It's not fun to have to constantly interrupt gameplay to micromanage inventory, or to trek back and forth between an adventuring location and a storage chest. The "hard limit" approach leads to more of this type of un-fun (for me) in-game activity.
* Debuffs that are insufficiently troublesome will end up being ignored by the player.
* Debuffs that are too troublesome are effectively "hard limits" - see above.
* Forced dropping of items can be a problem if you don't notice that the item was dropped, or if it falls into a chasm.

#### My solution:

The Soulslike games [Nioh](https://store.steampowered.com/app/485510/Nioh_Complete_Edition/) and [Nioh 2](https://store.steampowered.com/app/1325200/Nioh_2__The_Complete_Edition/) have a system called the "storehouse". This is similar to the "bottomless box" from Dark Souls - a storage container or stash that is accessible from numerous safe locations throughout the world. The player is able to carry only limited numbers of healing potions and ranged ammunition. When the player finds extra ammunition or healing potions while exploring, they can still pick them up, but any items that would exceed the allowed limit are teleported to the stash. 

When the player interacts with a safe location (shrine), their stock of healing potions and ammunition is replenished from the stash, if possible. They can also directly access the contents of the stash at a shrine.

This seems like an elegant way to limit player resources, while avoiding the problems discussed above. Resources are limited, but flow of gameplay is never interrupted by inventory management.

#### How this mod works:

In the MCM, you can set separate limits for: 

* restore health potions
* restore magicka potions
* restore stamina potions
* poisons
* ammunition (arrows and bolts)
* lockpicks

You can also choose whether foods that restore attributes should count as potions. If any of these limits are set to zero, that means the item category is not limited.

When you acquire items that would put your carried item count over the limit, the excess items are sent to the Bottomless Box.

When you rest at a campfire, your carried item totals are calculated for each category. Any excess items will be sent to the Bottomless Box. However if you are carrying fewer items than the limit, items will be automatically moved from the Bottomless Box back to your inventory to make up the shortfall.

While still resting at the campfire, you can interact with the campfire a second time to bring up the menu from the Soulslike Bonfire Menu mod. This menu allows you to access the Bottomless Box directly, where you can store or retrieve any item, including adjusting which health potions, ammunition etc you are carrying.

### My other mods ###

* [Respawn - Soulslike Edition](https://www.nexusmods.com/skyrimspecialedition/mods/69267) - when you are killed, drop your gold or valuables in a grave and respawn at the last campfire or bed.
* [Gold Is Souls](https://www.nexusmods.com/skyrimspecialedition/mods/69892) - Soulslike leveling system for Skyrim, using gold as "souls".
* [Constraints](https://www.nexusmods.com/skyrimspecialedition/mods/71014) - impose various voluntary constraints on your character, to enhance roleplay.


