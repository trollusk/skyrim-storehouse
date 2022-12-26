Scriptname StorehouseCampfire extends ReferenceAlias  

Actor property player auto
StorehouseQuest property shplayerref auto

Furniture property CampfireModFire1 auto
Furniture property CampfireModFire2 auto
Furniture property CampfireModFire3 auto


Event OnSit(ObjectReference furn)
	Form furnBase = furn.GetBaseObject()
		
	if ((furnBase == CampfireModFire1) || (furnBase == CampfireModFire2) || (furnBase == CampfireModFire3))
        shplayerref.SyncStorehouse()
	endif
EndEvent
