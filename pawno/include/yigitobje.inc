// AddRemoveBuilding(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, groupid=-1, bool:hide=true)
// ShowRemoveBuilding(index)
// ShowAllRemoveBuilding()
// ShowRemoveBuildingGroup(groupid)
// HideRemoveBulding(index)
// HideAllRemoveBuilding()
// HideRemoveBuldingGroup(groupid)

#include <foreach>
#include <streamer>

#define         MAX_REMOVED_BUILDINGS           1000

new Iterator:RemovedBuildings<MAX_REMOVED_BUILDINGS>;

enum RBINFO
{
    RB_ObjectID,
    RB_ModelID,
    RB_GroupID,
    bool:RB_Shown,
    Float:RB_X,
    Float:RB_Y,
    Float:RB_Z,
    Float:RB_RX,
    Float:RB_RY,
    Float:RB_RZ,
}

static RBData[MAX_REMOVED_BUILDINGS][RBINFO];

// Remove all buildings when a player connects
stock OnPlayerConnectEx(playerid)
{
    foreach(new i : RemovedBuildings)
    {
        RemoveBuildingForPlayer(playerid,  RBData[i][RB_ModelID],  RBData[i][RB_X], RBData[i][RB_Y], RBData[i][RB_Z], 0.25);
    }
    return 1;
}

// Show a specific building
stock ShowRemoveBuilding(slot)
{
    if(Iter_Contains(RemovedBuildings, slot))
    {
        if(RBData[slot][RB_Shown] == false)
        {
            RBData[slot][RB_ObjectID] = CreateDynamicObject(RBData[slot][RB_ModelID], RBData[slot][RB_X], RBData[slot][RB_Y], RBData[slot][RB_Z], RBData[slot][RB_RX], RBData[slot][RB_RY], RBData[slot][RB_RZ], -1, -1, -1, 300.0, 300.0);
            RBData[slot][RB_Shown] = true;
            return 1;
        }
        printf("Error::ShowRemoveBuilding::Building is already shown::Index:%i", slot);
        return 0;
    }
    printf("Error::ShowRemoveBuilding::Index is invalid::Index:%i", slot);
    return 0;
}

// Show all removed buildings
stock ShowAllRemoveBuilding()
{
    foreach(new i : RemovedBuildings)
    {
        if(RBData[i][RB_Shown] == false)
        {
            RBData[i][RB_ObjectID] = CreateDynamicObject(RBData[i][RB_ModelID], RBData[i][RB_X], RBData[i][RB_Y], RBData[i][RB_Z], RBData[i][RB_RX], RBData[i][RB_RY], RBData[i][RB_RZ], -1, -1, -1, 300.0, 300.0);
            RBData[i][RB_Shown] = true;
        }
    }
    return 1;
}

// Show only a group of remove buildings
stock ShowRemoveBuildingGroup(groupid)
{
    foreach(new i : RemovedBuildings)
    {
        if(RBData[i][RB_Shown] == false && RBData[i][RB_GroupID] == groupid)
        {
            RBData[i][RB_ObjectID] = CreateDynamicObject(RBData[i][RB_ModelID], RBData[i][RB_X], RBData[i][RB_Y], RBData[i][RB_Z], RBData[i][RB_RX], RBData[i][RB_RY], RBData[i][RB_RZ], -1, -1, -1, 300.0, 300.0);
            RBData[i][RB_Shown] = true;
        }
    }
    return 1;
}

// Hide a specific building
stock HideRemoveBulding(slot)
{
    if(Iter_Contains(RemovedBuildings, slot))
    {
        if(RBData[slot][RB_Shown] == true)
        {
            DestroyDynamicObject(RBData[slot][RB_ObjectID]);
            RBData[slot][RB_Shown] = false;
            return 1;
        }
        printf("Error::HideRemoveBulding::Building is already hidden::Index:%i", slot);
        return 0;
    }
    printf("Error::HideRemoveBulding::Index is invalid::Index:%i", slot);
    return 0;
}

// Hide all removed buildings
stock HideAllRemoveBuilding()
{
    foreach(new i : RemovedBuildings)
    {
        if(RBData[i][RB_Shown] == true BData[i][RB_GroupID] == groupid)
        {
            DestroyDynamicObject(RBData[i][RB_ObjectID]);
            RBData[i][RB_Shown] = false;
        }
    }
    return 1;
}

// Hide a group of removed buildings
stock HideRemoveBuldingGroup(groupid)
{
    foreach(new i : RemovedBuildings)
    {
        if(RBData[i][RB_Shown] == true && )
        {
            DestroyDynamicObject(RBData[i][RB_ObjectID]);
            RBData[i][RB_Shown] = false;
        }
    }
    return 1;
}

// Add a new remove building
stock AddRemoveBuilding(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, groupid=-1)
{
	new found, ida;
	foreach(new i: RemovedBuildings) {
		if(RBData[i][RB_ModelID] == modelid)continue;
		if(RBData[i][RB_X] == x && RBData[i][RB_Y] == y && RBData[i][RB_Z] == z)continue;
		if(RBData[i][RB_RX] == rx && RBData[i][RB_RY] == ry && RBData[i][RB_RZ] == rz) {
			found = 1;
			ida = i;
			break;
		}
	}
	if(found == 0) {
	    new slot = Iter_Free(RemovedBuildings);
	    if(slot > -1)
	    {
	        Iter_Add(RemovedBuildings, slot);

	        RBData[slot][RB_ModelID] = modelid;
	        RBData[slot][RB_X] = x;
	        RBData[slot][RB_Y] = y;
	        RBData[slot][RB_Z] = z;
	        RBData[slot][RB_RX] = rx;
	        RBData[slot][RB_RY] = ry;
	        RBData[slot][RB_RZ] = rz;
	        RBData[slot][RB_Shown] = false;
	        RBData[slot][RB_GroupID] = groupid;
	        
	        foreach(new i : Player)
	        {
	            RemoveBuildingForPlayer(i, modelid, x, y, z, 0.25);
	        }
	        
	        if(RBData[slot][RB_Shown]) RBData[slot][RB_ObjectID] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, -1, -1, -1, 300.0, 300.0);
	        return slot;
	    }
	    else return printf("Hata::AddRemoveBuilding::Bu kadar remove kullanamazsiniz");
	} else {
		HideRemoveBulding(ida);
	}
    return 0;
}