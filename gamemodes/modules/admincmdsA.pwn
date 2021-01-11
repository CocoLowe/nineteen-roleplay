// Namussuz

flags:eolotroll(CMD_EoloPlus);
CMD:eolotroll(playerid, params[])
{
    new vehicleid, derece;

    if (sscanf(params, "dd", vehicleid, derece))
        return KullanimMesajiC(playerid, "/eolotroll [Ara� ID] [derece]");

    if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
        return HataMesajiC(playerid, "Ge�ersiz ara� ID'si belirttin.");

    SetVehicleZAngle(vehicleid, derece);
    return 1;
}

flags:saveall(CMD_iglead);
CMD:saveall(playerid, params[])
{
    foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged])
        SaveCharacter(i);

    foreach(new v : Vehicles) if(IsValidVehicle(v) && !VehicleInfo[v][vTemporary])
        SaveVehicle(v);

    foreach(new h : Houses) if(HouseInfo[h][hExists])
        SaveHouse(h);

    foreach(new b : Buildings) if(BuildingInfo[b][bExists])
        SaveBuilding(b);

    foreach(new f : Factions) if(FactionInfo[f][fExists])
        SaveFaction(f);

   	foreach(new c : Companies) if(CompanyInfo[c][cReference])
	    SaveCompany(c);

    foreach(new l : Lab) if(LabInfo[l][lExists])
        SaveLab(l);

	foreach(new uid : EkilenUyusturucular) if(EUBilgi[uid][euStatus])
		SaveEU(uid);

    foreach(new i : Ihbarlar) if(IhbarInfo[i][ihbarExists])
	    IhbarKaydet(i);

	foreach(new i : Calintilar) if(CalintiInfo[i][caExists])
	    CalintiKaydet(i);

	Taxes_Update();

    foreach(new j : Player)
    {
        if(IsPlayerConnected(j) && PlayerInfo[j][pLogged])
        {
            SendFormattedMessage(j, COLOR_ADMIN, "%s sunucu verilerini kaydetti.", ReturnRoleplayName(playerid));
        }
    }
    return 1;
}

// Basic
flags:afklistesi(CMD_GAME2);
CMD:afklistesi(playerid) {
	SendClientMessage(playerid, COLOR_GREEN, "AFK Listesi:");
	foreach(new i: Player) {
	    if(!PlayerInfo[i][pLogged] || i == playerid)continue;
	    if(PlayerInfo[i][pAFKTime] / 60 > 5)
    		SunucuMesaji(playerid, "%s (%s) - %d dakika", ReturnRoleplayName(i), PlayerInfo[i][pUsername], PlayerInfo[i][pAFKTime]/60);
	}
	return 1;
}

flags:level1(CMD_SUPPORTER);
CMD:level1(playerid) {
	SendClientMessage(playerid, COLOR_GREEN, "Seviye 1 Listesi:");
	foreach(new i: Player) {
	    if(!PlayerInfo[i][pLogged] || i == playerid)continue;
	    if(PlayerInfo[i][pLevel] == 1)
    		SunucuMesaji(playerid, "%s", ReturnRoleplayName(i));
	}
	return 1;
}

flags:settime(CMD_GAME2);
CMD:settime(playerid, params[])
{
    new timeid;

    if(sscanf(params, "d", timeid)) return
        KullanimMesajiC(playerid, "/settime <0-23>");

    SunucuBilgi[CurrentHour] = timeid;
    SetWorldTime(SunucuBilgi[CurrentHour]);

    foreach(new pid : Player) if(IsPlayerConnected(pid) && PlayerInfo[pid][pLogged] && GetPlayerVirtualWorld(pid) >= HOUSE_WORLD)
        OnPlayerVirtualWorldChange(pid, GetPlayerVirtualWorld(pid));

    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s zaman� de�i�tirdi.", ReturnRoleplayName(playerid));

    return 1;
}

flags:listen(CMD_GAME1);
CMD:listen(playerid)
{
	if(PlayerInfo[playerid][pListen])
	{
	    PlayerInfo[playerid][pListen] = 0;
	    audience -= 1;
	    BasariMesaji(playerid, "Dinleme modu pasife �ekildi.");
	}
	else
	{
	    PlayerInfo[playerid][pListen] = 1;
	    audience += 1;
		BasariMesaji(playerid, "Dinleme modu aktif hale getirildi.");
	}
	return 1;
}

flags:atutukla(CMD_GAME1);
CMD:atutukla(playerid, params[])
{
    new buildingid = GetPlayerBuilding(playerid, true);
    new id, time;
    new target_name[MAX_PLAYER_NAME];

    if(buildingid == -1 || (buildingid != -1 && BuildingInfo[buildingid][bFaction] != 0) || PlayerInfo[playerid][pRank] > MAX_FACTION_RANKS)return
        HataMesajiC(playerid, "Bu komutu burada kullanamazs�n.");

    if(sscanf(params, "k<m>d", id, time))return
        KullanimMesajiC(playerid, "/atutukla [id/isim] [dakika]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesajiC(playerid, "Kendi kendini tutuklayamazs�n.");

	for(new j; j < MAX_INVENTORY_ITEMS; j++)
	{
	    new listid = PlayerInfo[id][pInvList][j]; if(!listid || InventoryObjects[listid][invType] != ITEM_PHONE || !PlayerInfo[id][pInvExtra][j])continue;
		PlayerInfo[id][pInvExtra][j] = !PlayerInfo[id][pInvExtra][j];
	}

    if(time < 0)return
        HataMesajiC(playerid, "0 dakikadan az giremezsin.");

    PlayerTextDrawShow(id, PlayerInfo[id][pTextdraws][0]);

    SetCameraBehindPlayer(id);

    SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(id, 8);
    PlayerInfo[id][pCuffed] = 0;

    ClearAnimations(id);
    Faction_OffDuty(id);

    PlayerInfo[id][pJailTime] = time * 60;
    PlayerInfo[id][pJailC] = 1;
    SetPlayerToJailPos(id);

    if(PlayerInfo[id][pCuffed])
    {
        SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);
        RemovePlayerAttachedObject(id, 8);
    }

    BasariMesaji(id, "%s taraf�ndan %d dakikal���na tutukland�n.", ReturnRoleplayName(playerid), time);
	SendAdminAlert(false, COLOR_ADMIN, "[IC JAIL] %s adl� yetkili %s adl� karakteri %d dakika hapse att�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), time);

    LogYaz(playerid, "/atutukla", id, time * 60);

    strmid(target_name, ReturnRoleplayName(id), 0, MAX_PLAYER_NAME);
    format(PlayerInfo[playerid][pTargetName], MAX_PLAYER_NAME, target_name);
    return 1;
}

flags:asiren(CMD_GAME2);
CMD:asiren(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(!IsPlayerInAnyVehicle(playerid))
		return HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    new id;

    if(sscanf(params, "d", id)) return
        KullanimMesajiC(playerid, "/asiren [0(kapat�r)/1/2/3(kendiniz ayarlamak i�in)]");

    if(id < 0 || id > 3) return
        KullanimMesajiC(playerid, "/asiren [0(kapat�r)/1/2/3(kendiniz ayarlamak i�in)]");

	if(id == 3 && Faction_GetType(VehicleInfo[vehicleid][vFaction]) != POLICE) return HataMesajiC(playerid, "Bu siren t�r�n� sadece polis kullanabilir.");

    if(!id)
    {
        if(!VehicleInfo[vehicleid][vSirenOn]) return HataMesajiC(playerid, "Siren zaten kapal�.");

        VehicleInfo[vehicleid][vSirenOn] = false;
        DestroyDynamicObjectEx(VehicleInfo[vehicleid][vSirenObject]);

        Player_Info(playerid, "Siren ~r~deaktif~w~.");

        return 1;
    }

    if(VehicleInfo[vehicleid][vSirenOn] && id != 3) return
        SunucuMesaji(playerid, "Siren zaten yan�yor.");

    new Float:fSize[3], Float:fSeat[3];

    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, fSize[0], fSize[1], fSize[2]);
    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, fSeat[0], fSeat[1], fSeat[2]);

    switch(id)
    {
        case 1: {
            VehicleInfo[vehicleid][vSirenObject] = CreateDynamicObject(18646, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vSirenObject], vehicleid, -fSeat[0], fSeat[1], fSize[2] / 2.0, 0.0, 0.0, 0.0);
			VehicleInfo[vehicleid][vSirenOn] = true;
		}
        case 2: {
            VehicleInfo[vehicleid][vSirenObject] = CreateDynamicObject(18646, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vSirenObject], vehicleid, 0.0, 0.75, 0.275, 0.0, 0.1, 0.0);
			VehicleInfo[vehicleid][vSirenOn] = true;
		}
        case 3: {
            if(!VehicleInfo[vehicleid][vSirenOn]) {
				if(PlayerInfo[playerid][pSirenCustomYapti]) {
				    VehicleInfo[vehicleid][vSirenObject] = CreateDynamicObject(18646, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0);
					AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vSirenObject], vehicleid, PlayerInfo[playerid][pSirenCustom][0], PlayerInfo[playerid][pSirenCustom][1], PlayerInfo[playerid][pSirenCustom][2], PlayerInfo[playerid][pSirenCustom][3], PlayerInfo[playerid][pSirenCustom][4], PlayerInfo[playerid][pSirenCustom][5]);
					VehicleInfo[vehicleid][vSirenOn] = true;
				}
				else {
					if(IsPlayerInRangeOfPoint(playerid, 2.0, -1773.5259,2593.0930,22.3893)) {
					    new Float:vX, Float:vY, Float:vZ, Float:vA;
					    GetVehiclePos(vehicleid, vX, vY, vZ);
					    GetVehicleZAngle(vehicleid, vA);
					    SetPVarFloat(playerid, "SirenAngle", vA);
					    SetVehicleZAngle(vehicleid, 0.0);
					    VehicleInfo[vehicleid][vSirenObject] = CreateDynamicObject(18646, vX, vY, vZ, 0.0, 0.0, 0.0);
		   				EditDynamicObject(playerid, VehicleInfo[vehicleid][vSirenObject]);
		   				SetPVarInt(playerid, "SirenEditliyor", 1);
		   				SetPVarInt(playerid, "SirenArac", vehicleid);
		   			} else return HataMesajiC(playerid, "Siren ayarlama noktas�nda de�ilsiniz.");
				}
			} else {
				if(IsPlayerInRangeOfPoint(playerid, 2.0, -1773.5259,2593.0930,22.3893)) {
				    PlayerInfo[playerid][pSirenCustomYapti] = false;
				    VehicleInfo[vehicleid][vSirenOn] = false;
				    DestroyDynamicObjectEx(VehicleInfo[vehicleid][vSirenObject]);
				    new Float:vX, Float:vY, Float:vZ, Float:vA;
				    GetVehiclePos(vehicleid, vX, vY, vZ);
				    GetVehicleZAngle(vehicleid, vA);
				    SetPVarFloat(playerid, "SirenAngle", vA);
				    SetVehicleZAngle(vehicleid, 0.0);
				    VehicleInfo[vehicleid][vSirenObject] = CreateDynamicObject(18646, vX, vY, vZ, 0.0, 0.0, 0.0);
	   				EditDynamicObject(playerid, VehicleInfo[vehicleid][vSirenObject]);
	   				SetPVarInt(playerid, "SirenEditliyor", 1);
	   				SetPVarInt(playerid, "SirenArac", vehicleid);
	   			} else return HataMesajiC(playerid, "Siren ayarlama noktas�nda de�ilsiniz.");
			}
		}
    }

    Player_Info(playerid, "Siren ~g~aktif~w~.");

    return 1;
}

flags:acs(CMD_GAME2);
CMD:acs(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(!IsPlayerInAnyVehicle(playerid))return
        HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    if(VehicleInfo[vehicleid][vCallSign] == true)
    {
        DestroyDynamic3DTextLabelEx(VehicleInfo[vehicleid][vSignText]);
        VehicleInfo[vehicleid][vCallSign] = false;
    }
    else
    {
        new text[32];
        new pos;

        if(sscanf(params, "ds[32]", pos, text))return
            KullanimMesajiC(playerid, "/acs [pos(0 - 2)] [yaz�]");

        if(pos < 0 || pos > 2)return
            SunucuMesaji(playerid, "Ara� etiketi 0 ve 2 aras�nda de�er alabilir.");

        new model = VehicleInfo[vehicleid][vModel];
        new Float:x, Float:y, Float:z, Float:un;

        GetVehicleModelInfo(model, VEHICLE_MODEL_INFO_WHEELSREAR, x, un, un);
        GetVehicleModelInfo(model, VEHICLE_MODEL_INFO_SIZE, un, y, un); y /= -2.0;
        GetVehicleModelInfo(model, VEHICLE_MODEL_INFO_REAR_BUMPER_Z, un, un, z);

        if(z <= -5.0 || z >= 5.0) z = 0.0;
        x += -0.2;
        y += 0.3;
        z += 0.0;

        switch(pos)
        {
            case 1: x = -x;
            case 2: x = 0.0;
        }

        VehicleInfo[vehicleid][vSignText] = CreateDynamic3DTextLabel(text, COLOR_WHITE, x, y, z, 20.0, INVALID_PLAYER_ID, vehicleid, 1);
        VehicleInfo[vehicleid][vCallSign] = true;
        Streamer_Update(playerid);
    }

    return 1;
}

flags:objectgoto(CMD_GAME1);
CMD:objectgoto(playerid, params[])
{

    new id;

    if(sscanf(params, "d", id))return
        KullanimMesajiC(playerid, "/objectgoto [obje id]");

    if(id < 1 || !IsValidDynamicObject(id))return
        SunucuMesaji(playerid, "Ge�ersiz obje.");

    new Float:pos[3];

    GetDynamicObjectPos(id, pos[0], pos[1], pos[2]);
    SetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    return 1;
}

flags:meslektenat(CMD_GAME1);
CMD:meslektenat(playerid, params[])
{
    new id;

    if(sscanf(params, "u", id))return
        KullanimMesajiC(playerid, "/meslektenat [id/isim]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(PlayerInfo[id][pJob] == -1)return
        SunucuMesajiC(playerid, "Oyuncu zaten bir mesle�e ait de�il.");

    PlayerInfo[id][pJob] = -1;
    PlayerInfo[id][pJobDuty] = 0;
    SetPlayerColor(id, COLOR_WHITE);

    BasariMesaji(id, "%s seni i�inden ��kartt�.", ReturnRoleplayName(playerid));
    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s %s ki�isini mesle�inden ��kartt�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id));

    return 1;
}

CMD:setpremium(playerid, params[])
{
    new id, premium;

    if(sscanf(params, "udd", id, premium))return
        KullanimMesajiC(playerid, "/setpremium [id] <0: Yok - 1: Bronze - 2: Silver - 3: Gold - 4: Platinum [tip]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(premium < 0 || premium > 5)return
        SunucuMesajiC(playerid, "Ge�ersiz veri giri�i. > Premium (0 - 3)");

    static const premium_name[6][90] = {"normal", "bronze", "silver", "gold", "platinum", "diamond"};

    PlayerInfo[id][pPremium] = premium;

    BasariMesaji(id, "%s donator seviyeni %s olarak ayarlad�.", ReturnRoleplayName(playerid), premium_name[premium]);
    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s ki�isi %s ki�isinin donator�n� %s olarak ayarlad�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), premium_name[premium]);

    LogYaz(playerid, "/setpremium", id, premium);

    return 1;
}

flags:aisbasi(CMD_GAME2);
CMD:aisbasi(playerid, params[])
{
	new targetid, fid;

	if(sscanf(params, "u", targetid)) return KullanimMesajiC(playerid, "/aisbasi [id]");

	if(targetid == -1 || !IsPlayerConnected(targetid)) return HataMesajiC(playerid, "Ge�ersiz ID");

    if(PlayerInfo[targetid][pJobDuty])return
        SunucuMesaji(playerid, "Bu kullan�c� zaten olu�um i�ba�� durumunda.");

	fid = PlayerInfo[targetid][pFaction];

    if(PlayerInfo[playerid][pAdmin] > 1)
	{
        if(!PlayerInfo[targetid][pFactionDuty])
        {
            PlayerInfo[targetid][pFactionDuty] = 1;

            PlayerInfo[targetid][pToggleArmour] = 0;

            if(fid != 1) SendFactionMessage(fid, "** HQ: %s %s �u anda i�ba��nda.", fRanks[fid][PlayerInfo[targetid][pRank] - 1], ReturnRoleplayName(targetid));
			else SendFactionMessageTR(fid, "** HQ: %s %s �u anda i�ba��nda.", fRanks[fid][PlayerInfo[targetid][pRank] - 1], ReturnRoleplayName(targetid));
		}
        else
		{
            if(fid != 1) SendFactionMessage(fid, "** HQ: %s %s art�k i�ba��nda de�il.", fRanks[fid][PlayerInfo[targetid][pRank] - 1], ReturnRoleplayName(targetid));
   			else SendFactionMessageTR(fid, "** HQ: %s %s art�k i�ba��nda de�il.", fRanks[fid][PlayerInfo[targetid][pRank] - 1], ReturnRoleplayName(targetid));
			Faction_OffDuty(targetid);
        }
		SunucuMesaji(targetid, "Administrator taraf�ndan i�ba�� durumunuz de�i�tirildi.");

    }
    BasariMesaji(playerid, "%s adl� oyuncunun i�ba�� durumunu de�i�tirdiniz.", ReturnRoleplayName(targetid));

    return 1;
}

flags:antidekorasyonsilme(CMD_Eolo);
CMD:antidekorasyonsilme(playerid)
{
    if(!SunucuBilgi[AntiDekorasyonSilme])
    {
    	SunucuBilgi[AntiDekorasyonSilme] = 1 ;
    	SunucuMesaji(playerid, "Dekorasyon silme olay� pasife �ekildi.");
    }
    else
    {
        SunucuBilgi[AntiDekorasyonSilme] = 0;
        SunucuMesaji(playerid, "Dekorasyon silme olay� yeniden aktif edildi.");
	}
	return 1;
}

flags:antidinamikobje(CMD_Eolo);
CMD:antidinamikobje(playerid)
{
    if(!SunucuBilgi[AntiDinamikObje])
    {
    	SunucuBilgi[AntiDinamikObje] = 1 ;
    	SunucuMesaji(playerid, "Dinamik obje sistemleri pasife �ekildi.");
    }
    else
    {
        SunucuBilgi[AntiDinamikObje] = 0;
        SunucuMesaji(playerid, "Dinamik obje sistemleri yeniden aktif edildi.");
	}
	return 1;
}

flags:antispam(CMD_Eolo);
CMD:antispam(playerid)
{
    if(!SunucuBilgi[AntiSpam])
    {
    	SunucuBilgi[AntiSpam] = 1;
    	SunucuMesaji(playerid, "Spam korumas� aktif edildi.");
    }
    else
    {
        SunucuBilgi[AntiSpam] = 0;

        foreach(new i : Player)
        {
			if(IsPlayerConnected(i) && PlayerInfo[i][pLogged])
			{
			    PlayerInfo[i][pAntiSpamer] = 0;
				PlayerInfo[i][pAntiSpam] = 0;
			}
		}
        SunucuMesaji(playerid, "Spam korumas� pasife �ekildi.");
	}
	return 1;
}

flags:aevara(CMD_GAME2);
CMD:aevara(playerid, params[])
{
    new hid = GetPlayerHouse(playerid, true);

    if(hid == -1)return
        SunucuMesajiC(playerid, "Evin yak�n�nda veya i�erisinde de�ilsin.");

    Storage_ShowItemsPD(playerid, hid);

    return 1;
}

CMD:revive(playerid, params[])
{
    new id;
    if(sscanf(params, "u", id)) return KullanimMesajiC(playerid, "/revive [id/isim]");
    if(!IsPlayerConnected(id)) return SendClientMessageEx(playerid, COLOR_GREY, "Belirtti�iniz oyuncu �evrimi�i de�il.");
    if(!PlayerInfo[id][pLogged]) return SendClientMessageEx(playerid, COLOR_GREY, "Belirtti�iniz oyuncu giri� yapmam��.");
    if(PlayerInfo[id][pDeath] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Belirtti�iniz oyuncu �lmemi�.");
    TogglePlayerControllable(id, true);
    PlayerInfo[id][pFreezed] = 0;
    PlayerInfo[id][pDeath] = 0;
    AC_SetPlayerHealth(id, 100);
    ExecuteShots[id] = 0;
    DestroyDynamic3DTextLabelEx(PlayerInfo[id][pNameTag]);
    SetCameraBehindPlayer(id);
    DeletePVar(id, "OyuncuOlduren");
    DeletePVar(id, "OyuncuOlu");
    PlayerInfo[id][pDeathTime] = 0;
    SendClientMessageEx(id, COLOR_ADMIN, "Administrator taraf�ndan canland�r�ld�n�z.");
    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s adl� oyuncu %s adl� y�netici taraf�ndan canland�r�ld�.", ReturnRoleplayName(id), ReturnRoleplayName(playerid));
    ClearAnimations(id, 1);
    Damages_Reset(id);
    PlayerInfo[id][pLegHit] = 0;
    ApplyAnimation(id, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
    SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);
    PlayerInfo[id][pLoopAnim] = false;
    PlayerInfo[id][pTedaviSure] = 0;
    PlayerInfo[id][pAgirYarali] = 0;
    PlayerTextDrawHide(id, PlayerInfo[playerid][pTextdraws][0]);
    return 1;
}

flags:legfix(CMD_GAME1);
CMD:legfix(playerid, params[])
{
    new id;
    if(sscanf(params, "u", id)) return KullanimMesajiC(playerid, "/revive [id/isim]");
    if(!IsPlayerConnected(id)) return SendClientMessageEx(playerid, COLOR_GREY, "Belirtti�iniz oyuncu �evrimi�i de�il.");
    if(!PlayerInfo[id][pLogged]) return SendClientMessageEx(playerid, COLOR_GREY, "Belirtti�iniz oyuncu giri� yapmam��.");
    if(PlayerInfo[id][pLegHit] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Belirtti�iniz oyuncunun baca�� k�r�k de�il.");
    PlayerInfo[id][pLegHit] = 0;
	ClearAnimations(id);
	SunucuMesaji(playerid, "%s adl� oyuncuyu canland�rd�n.", ReturnRoleplayName(id));
    return 1;
}
flags:aozellik(CMD_GAME1);
CMD:aozellik(playerid, params[])
{
	new targetid, ozellik[124];
    if(sscanf(params, "k<m>s[124]", targetid, ozellik)) return KullanimMesajiC(playerid, "/aozellik [oyuncuid] [metin]");

	format(PlayerInfo[targetid][pOzellik], sizeof(ozellik), "%s", ozellik);
	BasariMesaji(targetid, "Administrator taraf�ndan karakter �zellikleriniz d�zenlendi.");
	BasariMesaji(playerid, "'** %s %s' olarak d�zenlediniz.", ReturnRoleplayName(targetid), ozellik);
	return 1;
}

flags:kasagit(CMD_EoloPlus);
CMD:kasagit(playerid, params[])
{
    new houseid = GetPlayerHouse(playerid, true);

    if(houseid == -1)return
        SendClientMessageEx(playerid, COLOR_ERROR, "Bu komutu bir evin i�erisinde kullanabilirsin.");

	SetPlayerPos(playerid, HouseInfo[houseid][hInvPosX], HouseInfo[houseid][hInvPosY], HouseInfo[houseid][hInvPosZ]);
	SunucuMesaji(playerid, "%d nolu evin kasas�na ���nland�n.", houseid);
	return 1;
}

flags:amaske(CMD_GAME2);
CMD:amaske(playerid, params[])
{
	new targetid;

    if(sscanf(params, "u", targetid))return
        KullanimMesajiC(playerid, "/amaske [id/isim]");
        
    switch(PlayerInfo[targetid][pMasked])
    {
        case 0:
        {
            foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged])
            {
                if(PlayerInfo[i][pAdminDuty])
                {
                    SetPlayerMarkerForPlayer(i, targetid, COLOR_YELLOW); continue;
                }
                ShowPlayerNameTagForPlayer(i, targetid, false);
            }

            new randomid = random(100);
            new mask_number[12];

            if(PlayerInfo[targetid][pID] < 10 && randomid < 10)
                format(PlayerInfo[targetid][pMaskName], MAX_PLAYER_NAME , "Maske%d_%d", randomid, PlayerInfo[targetid][pID]);

            else if(PlayerInfo[targetid][pID] < 10 && randomid > 10 && randomid < 100)
                format(PlayerInfo[targetid][pMaskName], MAX_PLAYER_NAME, "Maske00%d_%d", randomid, PlayerInfo[targetid][pID]);

            else if(PlayerInfo[targetid][pID] < 10 && randomid > 100 && randomid < 1000)
                format(PlayerInfo[targetid][pMaskName], MAX_PLAYER_NAME, "Maske0%d_%d", randomid, PlayerInfo[targetid][pID]);

            else if(PlayerInfo[targetid][pID] < 10 && randomid > 1000)
                format(PlayerInfo[targetid][pMaskName], MAX_PLAYER_NAME, "Maske%d_%d", randomid, PlayerInfo[targetid][pID]);

            if(PlayerInfo[targetid][pID] > 10 && randomid < 10)
                format(PlayerInfo[targetid][pMaskName], MAX_PLAYER_NAME, "Maske000%d_%d", randomid, PlayerInfo[targetid][pID]);

            else if(PlayerInfo[targetid][pID] > 10 && randomid > 10 && randomid < 100)
                format(PlayerInfo[targetid][pMaskName], MAX_PLAYER_NAME, "Maske00%d_%d", randomid, PlayerInfo[targetid][pID]);

            else if(PlayerInfo[targetid][pID] > 10 && randomid > 100 && randomid < 1000)
                format(PlayerInfo[targetid][pMaskName], MAX_PLAYER_NAME, "Maske0%d_%d", randomid, PlayerInfo[targetid][pID]);

            else if(PlayerInfo[targetid][pID] > 10 && randomid > 1000)
                format(PlayerInfo[targetid][pMaskName], MAX_PLAYER_NAME, "Maske%d_%d", randomid, PlayerInfo[targetid][pID]);

            else format(PlayerInfo[targetid][pMaskName], MAX_PLAYER_NAME, "Maske%d_%d", randomid, PlayerInfo[targetid][pID]);

            PlayerInfo[targetid][pMasked] = 1;
            strmid(mask_number, PlayerInfo[targetid][pMaskName], 11, 24);

            /*new yazi[64];
            format(yazi, sizeof(yazi), "%s", PlayerInfo[targetid][pMaskName]);
	    	DestroyDynamic3DTextLabelEx(PlayerInfo[targetid][pNameTag]);
	    	PlayerInfo[targetid][pNameTag] = CreateDynamic3DTextLabel(yazi, COLOR_WHITE, 0, 0, 0.1, 20.0, targetid, INVALID_VEHICLE_ID, 1, -1, -1, -1, 100.0);
			*/
		    if(PlayerInfo[targetid][pBoxShowed] == true)
		    {
		    	PlayerTextDrawHide(targetid, PlayerInfo[targetid][pTextdraws][1]);
		    	PlayerInfo[targetid][pBoxShowed] = false;
            }
            Player_Info(targetid, "Maskeni ~y~taktin~w~.");
        }
        case 1: ToggleMask(targetid);
    }

    return 1;
}

// Bireysel

flags:setmyweather(CMD_iglead);
CMD:setmyweather(playerid, params[])
{
	new id;

	if(sscanf(params, "d", id)) return KullanimMesajiC(playerid, "/setmyweather [weatherid]");

	SetPlayerWeather(playerid, id);
	return 1;
}

flags:crashax(CMD_EoloPlus);
CMD:crashax(playerid, params[])
{
    new id;

    if(sscanf(params, "u", id))return
        KullanimMesajiC(playerid, "/crashax [id/isim]");

    if(PlayerInfo[id][pAdmin] >= PlayerInfo[playerid][pAdmin])
        return HataMesajiC(playerid, "mesaj loglara kaydedildi, kafan k�r�lacak");

    CrashPlayer(id);
    SendFormattedMessage(playerid, COLOR_ADMIN, "%s (%d) ki�isine crash verdirdin.", ReturnRoleplayName(id), id);

    return 1;
}

/*
// Yang�n Sistemi

flags:ayanginolustur(CMD_GAME1);
flags:ayanginkaldir(CMD_GAME1);
flags:ayanginlarikaldir(CMD_GAME1);
CMD:ayanginolustur(playerid, params[])
{
    if(Iter_Count(Yanginlar) >= MAX_YANGIN) return HataMesajiC(playerid, "Maksimum yang�n say�s�na ula��ld�.");
    new Float:hp;
    if(sscanf(params, "f", hp)) return KullanimMesajiC(playerid, "/ayanginolustur [hp]");
    YanginOlustur(playerid, hp);
    return 1;
}

CMD:ayanginkaldir(playerid, params[])
{
    new id;
    if(sscanf(params, "d", id)) return KullanimMesajiC(playerid, "/ayanginkaldir [id]");
    if(YanginInfo[id][yID] == -1) return HataMesajiC(playerid, "Belirtti�iniz yang�n ID'si bulunamad�.");
    YanginSil(id);
    SendFormattedMessage(playerid, COLOR_ADMIN, "%d ID'li yang�n� sildiniz.", id);
    return 1;
}

CMD:ayanginlarikaldir(playerid, params[])
{
    TumYanginlariSil();
    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s isimli y�netici t�m yang�nlar� kald�rd�.", ReturnRoleplayName(playerid));
    return 1;
}

flags:yanginalarmi(CMD_GAME2);
CMD:yanginalarmi(playerid, params[])
{
    foreach(new j : Player)
    {
        if(!IsPlayerConnected(j))continue;

        if(IsPlayerInRangeOfPoint(j, 50.0, 1253.383178, -1258.122558, 13.871937) || IsPlayerInRangeOfPoint(j, 100.0, 1382.911621, -800.009033, 1085.878051) && GetPlayerInterior(j) == 1 && GetPlayerVirtualWorld(j) == 5455)
        {
            SendFormattedMessage(j, COLOR_EMOTE, "** Yang�n alarm� �al�yor. **");
        	PlayerPlaySound(j, 3401, 0.0, 0.0, 0.0);
        	SetTimerEx("AlarmSustur", 30000, false, "d", j);
		}
	}
	return 1;
}

AlarmSustur(j); public AlarmSustur(j)
{
	PlayerPlaySound(j, 0, 0.0, 0.0, 0.0);
	return 1;
}
flags:alarmsustur(CMD_GAME2);
CMD:alarmsustur(playerid, params[])
{
    foreach(new j : Player)
    {
        if(!IsPlayerConnected(j))continue;

        if(IsPlayerInRangeOfPoint(j, 50.0, 1253.383178, -1258.122558, 13.871937) || IsPlayerInRangeOfPoint(j, 50.0, 1382.911621, -800.009033, 1085.878051) && GetPlayerInterior(j) == 1 && GetPlayerVirtualWorld(j) == 5455)
        {
        	PlayerPlaySound(j, 0, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}
*/
// Ara�lar

flags:aracvw(CMD_GAME1);
flags:aracinterior(CMD_GAME1);

CMD:aracvw(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))return
        SunucuMesajiC(playerid, "Ara�ta de�ilsin.");

    new vid = GetPlayerVehicleID(playerid),
        world;

    if(sscanf(params, "d", world))return
        KullanimMesajiC(playerid, "/aracvw [virtual world]");

    if(world < 0)return
        SunucuMesajiC(playerid, "Ge�ersiz de�er.");

    VehicleInfo[vid][vWorld] = world;
    SetVehicleVirtualWorld(vid, world);

    if(!VehicleInfo[vid][vTemporary])SaveVehicle(vid);
    return 1;
}

CMD:aracinterior(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))return
        HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    new vid = GetPlayerVehicleID(playerid),
        interior;

    if(sscanf(params, "d", interior))return
        KullanimMesajiC(playerid, "/aracinterior [interior]");

    if(interior < 0)return
        SunucuMesajiC(playerid, "Ge�ersiz de�er.");

    VehicleInfo[vid][vInterior] = interior;
    LinkVehicleToInterior(vid, interior);

    if(!VehicleInfo[vid][vTemporary])SaveVehicle(vid);

    return 1;
}

flags:aracbilgi(CMD_GAME1);
CMD:aracbilgi(playerid, params[])
{
	new vid = GetNearestVehicle(playerid);

    if(vid == -1 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)return 1;
    if(Vehicle_IsOwnerLead(playerid, vid, false) == 0)return 1;

    BasariMesaji(playerid, "_________________[%s | ID: %d]______________", GetVehicleModelName(VehicleInfo[vid][vModel]), vid);
    SunucuMesaji(playerid, "Motor �mr�: %.1f% | Ak� �mr�: %.1f% | Kap�n�n �mr�: %.1f% | KM: %d", VehicleInfo[vid][vEngineHealth], VehicleInfo[vid][vBatteryHealth], VehicleInfo[vid][vDoorHealth], VehicleInfo[vid][vKMGosteren]);
    SunucuMesaji(playerid, "Birinci ara� rengi: #%d | �kinci ara� rengi: #%d | Plaka: %s", VehicleInfo[vid][vFirstColor], VehicleInfo[vid][vSecondColor], VehicleInfo[vid][vPlate]);

    if(VehicleInfo[vid][vModel] == 525)
        SunucuMesaji(playerid, "Tamir Par�alar�: %d", VehicleInfo[vid][vComponents]);

    SendClientMessageEx(playerid, COLOR_GREEN, "____________________________________________");
    return 1;
}

// Ara�lar Biti�

flags:tduty(CMD_SUPPORTER);
flags:awork(CMD_GAME1);
flags:awork2(CMD_GAME1);
flags:awork3(CMD_GAME1);
CMD:tduty(playerid, params[])
{
    PlayerInfo[playerid][pSupporterDuty] = !PlayerInfo[playerid][pSupporterDuty];

    SetPlayerColor(playerid, (PlayerInfo[playerid][pSupporterDuty]) ? COLOR_SUPPORTERNICK : COLOR_WHITE);

    SoruYollaHelper(COLOR_SUPPORTER, (!PlayerInfo[playerid][pSupporterDuty]) ? ("%s adl� helper m�sait durumdan ��kt�.") : ("%s adl� helper m�sait duruma ge�ti."), ReturnRoleplayName(playerid));
    return 1;
}

CMD:awork(playerid, params[])
{
	PlayerInfo[playerid][pAdminDuty] = !PlayerInfo[playerid][pAdminDuty];

	AC_SetPlayerHealth(playerid, (PlayerInfo[playerid][pAdminDuty]) ? 99999 : 100);

 	SetPlayerColor(playerid,(PlayerInfo[playerid][pAdminDuty]) ? COLOR_BREEZEADMIN : COLOR_WHITE);

	foreach(new j : Player) if(IsPlayerConnected(j) && PlayerInfo[j][pLogged])
	{
		if(PlayerInfo[j][pMasked])
		{
			if(PlayerInfo[playerid][pAdminDuty])
			{
				SetPlayerMarkerForPlayer(playerid, j, (PlayerInfo[playerid][pAdminDuty]) ? COLOR_YELLOW : COLOR_WHITE);
				ShowPlayerNameTagForPlayer(playerid, j, true);
			}
			else ShowPlayerNameTagForPlayer(playerid, j, false);
		}
		else ShowPlayerNameTagForPlayer(playerid, j, true);
	}

	SendAworkAlert(false, COLOR_ADMIN, (!PlayerInfo[playerid][pAdminDuty]) ? ("AdmCmd: %s adl� yetkili i�ba��ndan ��kt�.") : ("AdmCmd: %s adl� yetkili i�ba��na ge�ti."), PlayerInfo[playerid][pUsername]);

	return 1;
}

CMD:awork2(playerid, params[])
{
	PlayerInfo[playerid][pAdminDuty] = !PlayerInfo[playerid][pAdminDuty];

 	SetPlayerColor(playerid,(PlayerInfo[playerid][pAdminDuty]) ? COLOR_BREEZEADMIN : COLOR_WHITE);

	foreach(new j : Player) if(IsPlayerConnected(j) && PlayerInfo[j][pLogged])
	{
		if(PlayerInfo[j][pMasked])
		{
			if(PlayerInfo[playerid][pAdminDuty])
			{
				SetPlayerMarkerForPlayer(playerid, j, (PlayerInfo[playerid][pAdminDuty]) ? COLOR_YELLOW : COLOR_WHITE);
				ShowPlayerNameTagForPlayer(playerid, j, true);
			}
			else ShowPlayerNameTagForPlayer(playerid, j, false);
		}
		else ShowPlayerNameTagForPlayer(playerid, j, true);
	}

	SendAworkAlert(false, COLOR_ADMIN, (!PlayerInfo[playerid][pAdminDuty]) ? ("AdmCmd: %s adl� yetkili i�ba��ndan ��kt�.") : ("AdmCmd: %s adl� yetkili i�ba��na ge�ti."), PlayerInfo[playerid][pUsername]);

	return 1;
}

CMD:awork3(playerid, params[])
{
	PlayerInfo[playerid][pAdminDuty] = !PlayerInfo[playerid][pAdminDuty];

	foreach(new j : Player) if(IsPlayerConnected(j) && PlayerInfo[j][pLogged])
	{
		if(PlayerInfo[j][pMasked])
		{
			if(PlayerInfo[playerid][pAdminDuty])
			{
				SetPlayerMarkerForPlayer(playerid, j, (PlayerInfo[playerid][pAdminDuty]) ? COLOR_YELLOW : COLOR_WHITE);
				ShowPlayerNameTagForPlayer(playerid, j, true);
			}
			else ShowPlayerNameTagForPlayer(playerid, j, false);
		}
		else ShowPlayerNameTagForPlayer(playerid, j, true);
	}

	SendAworkAlert(false, COLOR_ADMIN, (!PlayerInfo[playerid][pAdminDuty]) ? ("AdmCmd: %s adl� yetkili i�ba��ndan ��kt�.") : ("AdmCmd: %s adl� yetkili i�ba��na ge�ti."), PlayerInfo[playerid][pUsername]);

	return 1;
}

flags:givenos(CMD_GAME3);
CMD:givenos(playerid, params[])
{
    new vehicleid;

    if(IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);

    if(!vehicleid && sscanf(params, "d",vehicleid))return
        KullanimMesajiC(playerid, "/givenos [id]");

    if(!IsValidVehicle(vehicleid))return
        SunucuMesajiC(playerid, "Varolmayan ara�.");

    AddVehicleComponent(vehicleid, 1010);
	SaveVehicle(vehicleid);
	SunucuMesajiC(playerid, "Bulundu�un araca ba�ar�yla 10x nitro ekledin.");

    return 1;
}

flags:vcolors(CMD_GAME1);
CMD:vcolors(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))return
        HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    new color[2],
        vid = GetPlayerVehicleID(playerid);

    if(sscanf(params, "dd", color[0], color[1]))return
        KullanimMesajiC(playerid, "/vcolors [birinci renk] [ikinci renk]");

    VehicleInfo[vid][vFirstColor] = color[0];
    VehicleInfo[vid][vSecondColor] = color[1];
    ChangeVehicleColor(vid, color[0], color[1]);

    if(!VehicleInfo[vid][vTemporary])SaveVehicle(vid);

    return 1;
}

flags:givetogpm(CMD_iglead);
flags:givetogooc(CMD_iglead);
CMD:givetogpm(playerid, params[])
{
    new id;

    if(sscanf(params, "u", id))return
        KullanimMesajiC(playerid, "/givetogpm [id] ");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(PlayerInfo[id][pTogPMPremium])
    {
        PlayerInfo[id][pTogPMPremium] = 0;
        BasariMesaji(id, "%s senin PM kapatma iznini kald�rd�.", ReturnRoleplayName(playerid));
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s %s ki�isinin PM kapatma iznini kald�rd�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id));
    }
    else
    {
        PlayerInfo[id][pTogPMPremium] = 1;
        BasariMesaji(id, "%s sana PM kapatma izni verdi.", ReturnRoleplayName(playerid));
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s %s ki�isine PM kapatma izni verdi.", ReturnRoleplayName(playerid), ReturnRoleplayName(id));
    }

    return 1;
}
CMD:givetogooc(playerid, params[])
{
    new id;

    if(sscanf(params, "u", id))return
        KullanimMesajiC(playerid, "/givetogooc [id] ");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(PlayerInfo[id][pTogOOCPremium])
    {
        PlayerInfo[id][pTogOOCPremium] = 0;
        BasariMesaji(id, "%s senin OOC kanal susturma iznini kald�rd�.", ReturnRoleplayName(playerid));
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s %s ki�isinin OOC kanal susturma iznini kald�rd�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id));
    }
    else
    {
        PlayerInfo[id][pTogOOCPremium] = 1;
        BasariMesaji(id, "%s sana OOC kanal susturma izni verdi.", ReturnRoleplayName(playerid));
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s %s ki�isine OOC kanal susturma izni verdi.", ReturnRoleplayName(playerid), ReturnRoleplayName(id));
    }

    return 1;
}

CMD:stokyenile(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 1)
	{
		foreach(new k: Companies) if(CompanyInfo[k][cValid])
		{
			if(CompanyInfo[k][sirketid] == 1)
				CompanyInfo[k][stok] = 0;

			else if(CompanyInfo[k][sirketid] != 1)
				CompanyInfo[k][stok] = CompanyInfo[k][mstok] - 50;
				
            if(CompanyInfo[k][stok] < 0) CompanyInfo[k][stok] = 0;
            if(CompanyInfo[k][mstok] < 0) CompanyInfo[k][mstok] = 0;

			Company_RefreshText(k);
		}
		SunucuMesajiC(playerid, "Stoklar usul�ne uygun olarak yenilendi.");
	}
	else HataMesajiC(playerid, "Bu komutu kullanmak i�in yetkiniz yok.");
	return 1;
}

flags:tpgit(CMD_GAME1);
CMD:tpgit(playerid, params[])
{
    new tid;

    if(sscanf(params, "d", tid))return
        KullanimMesajiC(playerid, "/tpgit [id]");

    if(tid < 0 || tid >= MAX_TELEPORTS || !TeleportInfo[tid][teleportID])return
        SunucuMesajiC(playerid, "I��nlanam�yorsun.");

    if(IsPlayerInAnyVehicle(playerid))
    {
        SetVehiclePos(GetPlayerVehicleID(playerid), TeleportInfo[tid][teleportX], TeleportInfo[tid][teleportY], TeleportInfo[tid][teleportZ]);
        LinkVehicleToInterior(GetPlayerVehicleID(playerid), TeleportInfo[tid][teleportInterior]);
        SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), TeleportInfo[tid][teleportWorld]);
    }
    else SetPlayerPos(playerid, TeleportInfo[tid][teleportX], TeleportInfo[tid][teleportY], TeleportInfo[tid][teleportZ]);

    AC_SetPlayerVirtualWorld(playerid, TeleportInfo[tid][teleportWorld]);
    SetPlayerInterior(playerid, TeleportInfo[tid][teleportInterior]);

    return 1;
}
flags:tedit(CMD_iglead);
flags:tdelete(CMD_iglead);
flags:tcreate(CMD_iglead);
CMD:tedit(playerid, params[])
{
    new option[20], tid, Float:x, Float:y, Float:z, Float:a, factionid;// query[256], factionid;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    if(sscanf(params, "ds[20]D(-1)", tid, option, factionid))return
        KullanimMesajiC(playerid, "/tedit [id] [pozisyon - interior - olusum - sahip]");

    if(tid < 0 || tid > MAX_TELEPORTS || !TeleportInfo[tid][teleportID]) return
        SunucuMesajiC(playerid, "I��nlanam�yorsun.");

    if(!strcmp(option, "pozisyon", true))
    {
        TeleportInfo[tid][teleportX] = x;
        TeleportInfo[tid][teleportY] = y;
        TeleportInfo[tid][teleportZ] = z;
        TeleportInfo[tid][teleportA] = a;
        TeleportInfo[tid][teleportWorld] = GetPlayerVirtualWorld(playerid);
        TeleportInfo[tid][teleportInterior] = GetPlayerInterior(playerid);

        Pickup_Destroy(TeleportInfo[tid][teleportPickup]);
        TeleportInfo[tid][teleportPickup] = Pickup_Create(ELEMENT_TELEPORT, tid, 1239, 23, x, y, z, TeleportInfo[tid][teleportWorld], TeleportInfo[tid][teleportInterior]);

        mysql_format(ourConnection, queryx, sizeof(queryx), "UPDATE teleports SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', pos_world = '%d', pos_interior = '%d' WHERE id = '%d'", x, y, z, a, TeleportInfo[tid][teleportWorld], TeleportInfo[tid][teleportInterior], TeleportInfo[tid][teleportID]);
        mysql_tquery(ourConnection, queryx);
    }
    else if(!strcmp(option, "interior", true))
    {
        TeleportInfo[tid][teleportGX] = x;
        TeleportInfo[tid][teleportGY] = y;
        TeleportInfo[tid][teleportGZ] = z;
        TeleportInfo[tid][teleportGA] = a;
        TeleportInfo[tid][teleportGWorld] = GetPlayerVirtualWorld(playerid);
        TeleportInfo[tid][teleportGInterior] = GetPlayerInterior(playerid);

        Pickup_Destroy(TeleportInfo[tid][teleportGPickup]);
        TeleportInfo[tid][teleportGPickup] = Pickup_Create(ELEMENT_TELEPORT, tid, 1239, 23, x, y, z, TeleportInfo[tid][teleportGWorld], TeleportInfo[tid][teleportGInterior]);

        mysql_format(ourConnection, queryx, sizeof(queryx), "UPDATE teleports SET goto_x = '%f', goto_y = '%f', goto_z = '%f', goto_a = '%f', goto_world = '%d', goto_interior = '%d' WHERE id = '%d'", x, y, z, a, TeleportInfo[tid][teleportGWorld], TeleportInfo[tid][teleportGInterior], TeleportInfo[tid][teleportID]);
        mysql_tquery(ourConnection, queryx);
    }
    else if(!strcmp(option, "olusum", true))
    {
        if(factionid == -1)return
            SendFormattedMessage(playerid, COLOR_GREY, "/tedit [%d] [olu�um] [olusum id]", tid);

        if(factionid < 0 || factionid > MAX_FACTIONS || !FactionInfo[factionid][fExists])return
            SunucuMesajiC(playerid, "Olu�um bulunamad�.");

        TeleportInfo[tid][teleportFaction] = factionid;

        mysql_format(ourConnection, queryx, sizeof(queryx), "UPDATE teleports SET faction_id = '%d' WHERE id = '%d'", factionid, TeleportInfo[tid][teleportID]);
        mysql_tquery(ourConnection, queryx);
    }
    else if(!strcmp(option, "sahip", true)) {
        if(factionid == -1)return SendFormattedMessage(playerid, COLOR_GREY, "/tedit [%d] [sahip] [oyuncu ID]", tid);
        
        if(IsPlayerConnected(factionid) && PlayerInfo[factionid][pLogged]) {
            TeleportInfo[tid][tSahip] = PlayerInfo[factionid][pID];
            mysql_format(ourConnection, queryx, sizeof(queryx), "UPDATE teleports SET sahip = '%d' WHERE id = '%d'", TeleportInfo[tid][tSahip], TeleportInfo[tid][teleportID]);
        	mysql_tquery(ourConnection, queryx);
        	PlayerInfo[factionid][pTeleportNoktasi] = TeleportInfo[tid][teleportID];
        } else return HataMesajiC(playerid, "Hatal� oyuncu ID");
    }
    else return
        HataMesajiC(playerid, "Ge�ersiz parametre.");

    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s %d ID'li teleport noktas�n� d�zenledi. Se�im: \"%s\".", ReturnRoleplayName(playerid), tid, option);
    return 1;
}

CMD:tdelete(playerid, params[])
{
	new tid;

    if(sscanf(params, "d", tid))return
        KullanimMesajiC(playerid, "/tdelete [id]");

    if(tid < 0 || tid >= MAX_TELEPORTS || !TeleportInfo[tid][teleportID])return
        SunucuMesajiC(playerid, "I��nlanam�yorsun.");

    mysql_format(ourConnection, queryx, sizeof(queryx), "DELETE FROM teleports WHERE id = '%d'", TeleportInfo[tid][teleportID]);
    mysql_tquery(ourConnection, queryx);

    Pickup_Destroy(TeleportInfo[tid][teleportPickup]);
    Pickup_Destroy(TeleportInfo[tid][teleportGPickup]);
    TeleportInfo[tid][teleportID] = 0;
	TeleportInfo[tid][tExists] = 0;
	Iter_Remove(Teleports, tid);

    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s %d ID'li teleport noktas�n� sildi.", ReturnRoleplayName(playerid), tid);
    return 1;
}

CMD:tcreate(playerid, params[])
{
    if(Iter_Free(Teleports) >= MAX_TELEPORTS)return
        SunucuMesajiC(playerid, "Maksimum teleport s�n�r�na ula��ld�.");

    new Float:x, Float:y, Float:z, Float:a;//;//, query[256];
    new vw = GetPlayerVirtualWorld(playerid);
    new interior = GetPlayerInterior(playerid);
    new vehicleid = GetPlayerVehicleID(playerid);

    GetPlayerPos(playerid, x, y, z);

    if(!vehicleid) GetPlayerFacingAngle(playerid, a);
    else GetVehicleZAngle(vehicleid, a);

    new tid = Iter_Free(Teleports);

	TeleportInfo[tid][tExists] = 1;
    TeleportInfo[tid][teleportX] = x;
    TeleportInfo[tid][teleportY] = y;
    TeleportInfo[tid][teleportZ] = z;
    TeleportInfo[tid][teleportA] = a;
    TeleportInfo[tid][teleportWorld] = vw;
    TeleportInfo[tid][teleportInterior] = interior;
    TeleportInfo[tid][teleportFaction] = -1;
	TeleportInfo[tid][tSahip] = -1;
	TeleportInfo[tid][tKilitli] = 0;
	format(TeleportInfo[tid][tSifre], 8, "-1");
    TeleportInfo[tid][teleportPickup] = Pickup_Create(ELEMENT_TELEPORT, tid, 1239, 23, x, y, z, vw, interior);

    Iter_Add(Teleports, tid);

    mysql_format(ourConnection, queryx, sizeof(queryx), "INSERT INTO teleports (faction_id, pos_x, pos_y, pos_z, pos_a, pos_world, pos_interior) VALUES ('%d', '%f', '%f', '%f', '%f', '%d', '%d')", -1, x, y, z, a, vw, interior);
    mysql_tquery(ourConnection, queryx, "OnQueryFinished", "dd", tid, THREAD_CREATE_TELEPORT);

    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s %d ID'li teleport noktas�n� olu�turdu.", ReturnRoleplayName(playerid), tid);

//    LogYaz(playerid, "/tcreate", -1, tid);

    return 1;
}



flags:ahelp(CMD_GAME1);
CMD:ahelp(playerid, params[])
{
    pc_cmd_thelp(playerid, params);

    if(PlayerInfo[playerid][pAdmin] >= GAMEADMIN1)
    {
        SunucuMesajiC(playerid, "[Game Admin 1] /a - /awork - /gotocar - /getcar /sethp - /kick - /slap - /belt - /revive");
        SunucuMesaji(playerid, "[Game Admin 1] /fixleg - /unjail - /ajail - /setskin - /gonderls - /gonderlv - /gondersf - /mark - /gotomark");
        SunucuMesaji(playerid, "[Game Admin 1] /ckban - /unckban - /specoff - /spec - /jobrespawn - /freeze - /unfreeze - /apm - /aracbilgi");
        SunucuMesaji(playerid, "[Game Admin 1] /asunucubilgi - /maskid - /envantercheck - /check - /ipconflict - /refuelveh - /rtc - /rtc2");
        SunucuMesaji(playerid, "[Game Admin 1] /ayangincmds - /senaryokaldir - /senaryolarisil - /ceset(leri)kaldir - /krizfix - /drugfix");
        SunucuMesaji(playerid, "[Game Admin 1] /kulubekontrol - /ocheck - /oenvantercheck - /meslektenat - /notekle - /anote - /isinlanmakomutlari");
        SunucuMesaji(playerid, "[Game Admin 1] /unban - /ban - /vpark - /gotochoords - /silahbilgi - /disarm - /removegun - /hpdata - /setjob");
		SunucuMesaji(playerid, "[Game Admin 1] /sorukontrol - /truckeryenile - /bagliaraclar - /x - /xx - /y - /yy - /z - /zz - /apm - /listmasks");
		SunucuMesaji(playerid, "[Game Admin 1] /aracvw - /aracinterior - /acinsiyet - /interiorgit - /setarmor - /o - /yonetimduyurusu");
    }
    if(PlayerInfo[playerid][pAdmin] >= GAMEADMIN2)
    {
        SunucuMesajiC(playerid, "[Supporter] /apayphonecmds - /settime - /setweather - /respawncars");
    }
    if(PlayerInfo[playerid][pAdmin] >= GAMEADMIN3)
    {
        SunucuMesajiC(playerid, "[Game Admin 3]  - /abuildingcmds - /ahousecmds - /agatecmds - /aatmcmds - /createfreq");
        SunucuMesajiC(playerid, "[Game Admin 3] /inactivelist");
        }
    if(PlayerInfo[playerid][pAdmin] >= GAMEADMIN4)
    {
        SunucuMesaji(playerid, "[Game Admin 4] /avehiclecmds - /agamecmds - /saveall - /afactioncmds - /alabcmds - /ateleportcmds - /adealercmds");
        SunucuMesaji(playerid, "[Game Admin 4] /acompanycmds - /giveitem - /setstat - /ccall - /freezeall - /unfreezeall - /kickall");
        SunucuMesaji(playerid, "[Game Admin 4] /dolapolustur - /dolapsil - /sirketolustur - /sirketsil");
    }
    if(PlayerInfo[playerid][pAdmin] >= OWNER)
    {
        SunucuMesaji(playerid, "[Lead Admin] /aindustrycmds - /givemoney - /resetcash - /jetpack - /objectdelete - /objectgoto - /placeobject");
    }
    if(PlayerInfo[playerid][pAdmin] >= LEVEL10)
    {
        SunucuMesajiC(playerid, "[Lead Admin+] /cesetolusturadmin - /acheatkick - /stopalerts - /setadmin - /adeprembaslat");
        SunucuMesajiC(playerid, "[Lead Admin+] /graffiticmds - /ekonomi - /agizliol - /gizliadminler");
    }
    if(IsPlayerAdmin(playerid))
    {
        SunucuMesajiC(playerid, "[Rcon] /setadming ve /crash");
    }

    return 1;
}

flags:give19p(CMD_EoloPlus);
flags:set19p(CMD_EoloPlus);
CMD:give19p(playerid, params[])
{
    new id, amount;

    if(sscanf(params, "ud", id, amount))return
        KullanimMesajiC(playerid, "/give19p [id/isim] [de�er/miktar]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(amount < 0) return
        SunucuMesajiC(playerid, "Ge�ersiz de�er.");

	LogYaz(playerid, "gEski19PMiktari", id, PlayerInfo[id][pCoyn]);

    PlayerInfo[id][pCoyn] += amount;

	LogYaz(playerid, "/give19p", id, amount);

    BasariMesaji(id, "%s sana %d adet 19P verdi. �u anda %d kadar 19 pointe sahipsin.", ReturnRoleplayName(playerid), amount, PlayerInfo[id][pCoyn]);
    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s %d kadar 19pointi %s ki�isine verdi. (Oyuncunun �zerindeki 19p: %d)", ReturnRoleplayName(playerid), amount, ReturnRoleplayName(id), PlayerInfo[id][pCoyn]);

    return 1;
}
CMD:set19p(playerid, params[])
{
    new id, amount;

    if(sscanf(params, "ud", id, amount))return
        KullanimMesajiC(playerid, "/set19p [id/isim] [de�er/miktar]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(amount < 0) return
        SunucuMesajiC(playerid, "Ge�ersiz de�er.");

	LogYaz(playerid, "Eski19PMiktari", id, PlayerInfo[id][pCoyn]);

    PlayerInfo[id][pCoyn] = amount;

	LogYaz(playerid, "/set19p", id, amount);

    BasariMesaji(id, "%s 19pointini %d olarak ayarlad�.", ReturnRoleplayName(playerid), amount);
    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s %s ki�isinin 19P'lerini %d olarak ayarlad�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), amount);


    return 1;
}

flags:hpdata(CMD_GAME1);
flags:apdata(CMD_GAME1);
CMD:hpdata(playerid, params[])
{
    new Float:hp, Float:s_hp, id;

    GetPlayerHealth(playerid, hp);
    AC_GetPlayerHealth(playerid, s_hp);

    if(sscanf(params, "u", id)) id = playerid;

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return 1;

    BasariMesaji(playerid, "[DEBUG] HP IG: %1.f | HP server-side: %1.f", hp, s_hp);

    return 1;
}
CMD:apdata(playerid, params[])
{
    new Float:ap, Float:s_ap, id;

    GetPlayerArmour(playerid, ap);
    AC_GetPlayerArmour(playerid, s_ap);

    if(sscanf(params, "u", id)) id = playerid;

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return 1;

    BasariMesaji(playerid, "[DEBUG] AP IG: %1.f | AP server-side: %1.f", ap, s_ap);

    return 1;
}

flags:dolapsil(CMD_iglead);
CMD:dolapsil(playerid, params[])
{
    new id;
    if(sscanf(params, "d", id)) return KullanimMesajiC(playerid, "/dolapsil [dolapid]");
    if(DolapInfo[id][doID] == -1) return HataMesajiC(playerid, "Belirtti�iniz dolap bulunamad�.");
    DolapSil(id);
    SendFormattedMessage(playerid, COLOR_ADMIN, "%d ID'li dolab� sildiniz.", id);
    return 1;
}

flags:ahousecmds(CMD_GAME3);
CMD:ahousecmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Evler] /evyarat - /evedit - /evsil - /evsahip - /evsifirla");

flags:abuildingcmds(CMD_GAME3);
CMD:abuildingcmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Yap�lar] /bcreate - /bedit - /bdelete - /isletmesahip - /isletmesifirla");

flags:aatmcmds(CMD_GAME3);
CMD:aatmcmds(playerid, params[])return
	SendClientMessageEx(playerid, COLOR_WHITE, "[ATM] /atmolustur - /atmiptal - /atmsil - /atmlerisil - /yakinimdakiatm");

flags:ayangincmds(CMD_GAME1);
CMD:ayangincmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Yang�nlar] /ayanginolustur - /ayanginkaldir - /ayanginlarikaldir");

flags:isinlanmakomutlari(CMD_GAME1);
CMD:isinlanmakomutlari(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_WHITE, "[TP] /mapgit - /tpliste - /tpgit - /evgit - /isyerigit - /kulubegit - /tvgit - /kumargit");
    return SendClientMessageEx(playerid, COLOR_WHITE, "[TP] /galerigit - /gotoi - /labgit - /chopgit - /gotoc - /gotols - /gotolv - /gotosf");
}

flags:agatecmds(CMD_GAME3);
CMD:agatecmds(playerid, params[])return
	SendClientMessageEx(playerid, COLOR_WHITE, "[Gate] /gateolustur - /agate - /gatesil - /gateduzenle - /gatenear");

flags:apayphonecmds(CMD_GAME2);
CMD:apayphonecmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Kul�beler] /pcreate - /pedit - /pdelete");
	
flags:pcreate(CMD_GAME2);
flags:pedit(CMD_GAME2);
flags:pdelete(CMD_GAME2);

CMD:pcreate(playerid, params[])
{
    if(PlayerInfo[playerid][pEditingMode])return
        SunucuMesajiC(playerid, "D�zenleme yaparken bunu yapamazs�n.");

    if(Iter_Free(PayPhones) >= MAX_PAYPHONES)return
        SunucuMesajiC(playerid, "Maksimum telefon kul�besi say�s�na ula��ld�.");

    new Float:x,
        Float:y,
        Float:z;

    GetPlayerPos(playerid, x, y, z);

    PlayerInfo[playerid][pSelectedItem] = CreateDynamicObject(1216, x+0.1, y+0.1, z+0.2, 0, 0, 0);
    PlayerInfo[playerid][pEditingMode] = 3;
    EditDynamicObject(playerid, PlayerInfo[playerid][pSelectedItem]);

    SunucuMesajiC(playerid, "�ptal etmek i�in ESC veya bo�luk tu�una bas�n, kaydetmek i�in diskete t�klay�n.");

    return 1;
}
CMD:pdelete(playerid, params[])
{
    if(PlayerInfo[playerid][pEditingMode])return
        SunucuMesajiC(playerid, "D�zenleme yaparken bunu yapamazs�n.");

    if(GetNearestPayPhone(playerid) == -1)return
        SunucuMesajiC(playerid, "Telefon kul�besine yak�n de�ilsin.");

    new id = GetNearestPayPhone(playerid);

    if(PayPhoneInfo[id][cDialing]) {
        DestroyDynamicPickup(PayPhoneInfo[id][cDialObject]);
        PayPhoneInfo[id][cDialing] = 0;
    }
    PayPhoneInfo[id][cPosX] = 0;
    PayPhoneInfo[id][cPosY] = 0;
    PayPhoneInfo[id][cPosZ] = 0;
    PayPhoneInfo[id][cRotX] = 0;
    PayPhoneInfo[id][cRotY] = 0;
    PayPhoneInfo[id][cRotZ] = 0;
    PayPhoneInfo[id][cNumber] = 0;
    PayPhoneInfo[id][cExists] = 0;

    DestroyDynamicObjectEx(PayPhoneInfo[id][cObject]);
    DestroyDynamic3DTextLabelEx(PayPhoneInfo[id][KulubeLabel]);
    mysql_format(ourConnection, queryx, sizeof(queryx), "DELETE FROM payphones WHERE id = '%d'", PayPhoneInfo[id][cID]);
    mysql_tquery(ourConnection, queryx);

    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s %d ID'li telefon kul�besini sildi.", ReturnRoleplayName(playerid), id);

    LogYaz(playerid, "/pdelete", -1, id);

    Iter_Remove(PayPhones, id);

    return 1;
}

flags:ateleportcmds(CMD_iglead);
CMD:ateleportcmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Teleports] /tcreate - /tedit - /tdelete");

flags:afactioncmds(CMD_iglead);
CMD:afactioncmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Factions] /fyarat - /fedit - /freset - /setfaction - /factionkick");

flags:adealercmds(CMD_iglead);
CMD:adealercmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Galeriler] /dcreate - /dedit - /ddelete");

flags:acompanycmds(CMD_iglead);
CMD:acompanycmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Trucker] /ccreate - /cedit - /cdelete");

flags:agamecmds(CMD_iglead);
CMD:agamecmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Kumar] /kumaryarat - /kumarsil");

flags:alabcmds(CMD_iglead);
CMD:alabcmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Laboratuvar] /lcreate - /ledit - /ldelete");

flags:aindustrycmds(CMD_Eolo);
CMD:aindustrycmds(playerid, params[])return
    SendClientMessageEx(playerid, COLOR_WHITE, "[Illegal End�stri] /icreate - /iedit - /idelete");

flags:agraffiticmds(CMD_EoloPlus);
CMD:agraffiticmds(playerid, params[]) return SendClientMessageEx(playerid, COLOR_WHITE, "[Grafiti] /gcreate - /gedit - /gdelete");

flags:avehiclecmds(CMD_iglead);
CMD:avehiclecmds(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_WHITE, "[Ara�lar] /aracsahip - /yarac - /vcolors - /vfaction - /aracmeslek - /vpark - /vdelete - /aracomuryenile");
    return SendClientMessageEx(playerid, COLOR_WHITE, "[Ara�lar] /vplate - /aracvw - /aracinterior - /vfuel - /vspawn - /vveritabanikayit - /vhp - /yaracmenu");
}

flags:thelp(CMD_SUPPORTER);
CMD:thelp(playerid, params[])
{
    SunucuMesajiC(playerid, "[Seviye 1] /h - /tduty - /raporkabul(/ar) - /raporred - /sorular - /stf - /reklamlar");
	SunucuMesajiC(playerid, "[Seviye 2] /setvw - /setinterior - /gonderls");
	SunucuMesajiC(playerid, "[Seviye 3] /kick - /freeze - /goto - /gethere - /gotocar - /getcar - /hban - /hjail");
	return 1;
}
Dialog:DialogYonetimPaneli(playerid, response, listitem, inputtext[])
{
	if(!response)return 0;

    switch(listitem)
    {
        case 0: pc_cmd_leadbakim(playerid, NULL);
        case 1: pc_cmd_gamebakim(playerid, NULL);
        case 2: pc_cmd_helperbakim(playerid, NULL);
        case 3: pc_cmd_restartmodu(playerid, NULL);
        case 4: pc_cmd_sunucuacmamodu(playerid, NULL);
    }

    return 1;
}

flags:serveryonetim(CMD_EoloPlus);
flags:leadbakim(CMD_iglead);
flags:gamebakim(CMD_iglead);
flags:helperbakim(CMD_iglead);
flags:restartmodu(CMD_iglead);
flags:sunucuacmamodu(CMD_iglead);
CMD:serveryonetim(playerid, params[])
{
	Dialog_Show(playerid, DialogYonetimPaneli, DIALOG_STYLE_LIST, "Sunucu Y�netimi", "Bak�m (Developer+)\nBak�m (Game Admin+)\nBak�m (Helper+)\nBak�m (Restart �ncesi)\nNormal Sunucu\nA��l��tan �nce Kullan�lacak", "�leri", "�ptal");
	return 1;
}

CMD:leadbakim(playerid, params[])
{
    SendRconCommand("password leaddevelopers1921");
    SendRconCommand("hostname [BAKIM] 19 Roleplay | nineteen-roleplay.com");

    pc_cmd_kickall(playerid, "Bak�m Modu");
    pc_cmd_saveall(playerid, params);
    SunucuMesajiC(playerid, "Sunucu �ifresini leaddevelopers1921 yapt�n.");

    return 1;
}
CMD:gamebakim(playerid, params[])
{
    SendRconCommand("password gameadminlericinsadece");
    SendRconCommand("hostname [BAKIM] 19 Roleplay | nineteen-roleplay.com");

    pc_cmd_kickall(playerid, "Bak�m Modu");
    pc_cmd_saveall(playerid, params);
	SunucuMesajiC(playerid, "Sunucu �ifresini gameadminlericinsadece yapt�n.");
    return 1;
}
CMD:helperbakim(playerid, params[])
{
    SendRconCommand("password helperlargirebilir19");
    SendRconCommand("hostname [BAKIM] 19 Roleplay | nineteen-roleplay.com");

    pc_cmd_kickall(playerid, "Bak�m Modu");
    pc_cmd_saveall(playerid, params);
	SunucuMesajiC(playerid, "Sunucu �ifresini helperlargirebilir19 yapt�n.");
    return 1;
}
CMD:restartmodu(playerid, params[])
{
    SendRconCommand("password restartoncesisessizlik");
    SendRconCommand("hostname [Restart] 19 Roleplay | nineteen-roleplay.com");

    pc_cmd_kickall(playerid, "restart at�lacak");
    pc_cmd_saveall(playerid, params);
	SunucuMesajiC(playerid, "Sunucu �ifresini restartoncesisessizlik yapt�n.");
    return 1;
}
CMD:sunucuacmamodu(playerid, params[])
{
    SendRconCommand("password 0");
    SendRconCommand("hostname 19 Roleplay | nineteen-roleplay.com");

    pc_cmd_kickall(playerid, "restart at�lacak");
    pc_cmd_saveall(playerid, params);
	SunucuMesajiC(playerid, "Sunucu �ifresini kald�rd�n.");
    return 1;
}

CMD:chattemizle(playerid, params[])
{
	ClearChat(playerid, 25);
	SunucuMesajiC(playerid, "Sohbet ekran�n�z ba�ar�yla temizlendi.");
	return 1;
}
CMD:ccme(playerid, params[])
{
	ClearChat(playerid, 25);
	SunucuMesajiC(playerid, "Sohbet ekran�n�z ba�ar�yla temizlendi.");
	return 1;
}

flags:jetpack(CMD_Eolo);
CMD:jetpack(playerid, params[])
{
    new id;

    if(sscanf(params, "u", id)) id = playerid;

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    PlayerInfo[id][pLoopAnim] = !PlayerInfo[id][pLoopAnim];
    SetPlayerSpecialAction(id, (GetPlayerSpecialAction(id) == SPECIAL_ACTION_USEJETPACK) ? SPECIAL_ACTION_NONE : SPECIAL_ACTION_USEJETPACK);
    SendFormattedMessage(playerid, COLOR_ADMIN, (GetPlayerSpecialAction(id) == SPECIAL_ACTION_USEJETPACK) ? ("%s ki�isinin jetpackini ��kartt�n.") : ("%s ki�isi art�k bir jetpack sahibi."), ReturnRoleplayName(id));

    return 1;
}
flags:o(CMD_GAME1);
CMD:o(playerid, params[])
{
    if(isnull(params) || strlen(params) > 256)return
        SunucuMesajiC(playerid, "/o [yaz�]");

    foreach(new j : Player)
    {
        if(IsPlayerConnected(j) && PlayerInfo[j][pLogged])
        {
            SendFormattedMessage(j, COLOR_LIGHTBLUE, "[OOC] %s(%s): %s", ReturnRoleplayName(playerid), PlayerInfo[playerid][pUsername], params);
        }
    }
    return 1;
}
flags:yonetimduyurusu(CMD_GAME1);
CMD:yonetimduyurusu(playerid, params[])
{
    if(isnull(params) || strlen(params) > 256)return
        SunucuMesajiC(playerid, "/o [yaz�]");

    foreach(new j : Player)
    {
        if(IsPlayerConnected(j) && PlayerInfo[j][pLogged])
        {
            SendFormattedMessage(j, COLOR_ORANGE, "Y�NET�M DUYURUSU: %s", params);
        }
    }
    return 1;
}
flags:a(CMD_GAME1);
CMD:a(playerid, params[])
{
    if(isnull(params) || strlen(params) > 256)return
        KullanimMesajiC(playerid, "/a [yaz�]");

    foreach(new j : Player) if(IsPlayerConnected(j) && PlayerInfo[j][pLogged] && PlayerInfo[j][pAdmin] >= GAMEADMIN1 && PlayerInfo[j][pACH])
        SendFormattedMessage(j, COLOR_YELLOW, "* Admin [%d] %s: %s", PlayerInfo[playerid][pAdmin] - 3, ReturnRoleplayName(playerid), params);

    return 1;
}
flags:la(CMD_Eolo);
CMD:la(playerid, params[])
{
    if(isnull(params) || strlen(params) > 256)return
        KullanimMesajiC(playerid, "/la [yaz�]");

    foreach(new j : Player) if(IsPlayerConnected(j) && PlayerInfo[j][pLogged] && PlayerInfo[j][pAdmin] >= LEVEL20 && PlayerInfo[j][pLACH])
        SendFormattedMessage(j, COLOR_YELLOW, "* (L) %s: %s", ReturnRoleplayName(playerid), params);

    return 1;
}

flags:setweather(CMD_GAME3);
CMD:setweather(playerid, params[])
{
    new weather;

    if(sscanf(params, "d", weather))return
        KullanimMesajiC(playerid, "/setweather [id]");

    if(weather < 0 || weather > MAX_WEATHERS)return
        HataMesaji(playerid, "Ge�ersiz hava. (0 -  %d)", MAX_WEATHERS);

    SetWeather(weather);
    SunucuBilgi[CurrentWeather] = weather;

    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s havay� ayarlad�.", ReturnRoleplayName(playerid));

    return 1;
}

flags:isyerigit(CMD_GAME1);
CMD:isyerigit(playerid, params[])
{
    new buildingid;

    if(sscanf(params, "d", buildingid))return
        KullanimMesajiC(playerid, "/isyerigit [id]");

    if(buildingid < 0 || buildingid >= MAX_BUILDINGS || !BuildingInfo[buildingid][bExists])return
        SunucuMesajiC(playerid, "Varolmayan bina.");

    SetPlayerPos(playerid, BuildingInfo[buildingid][bPosX],BuildingInfo[buildingid][bPosY],BuildingInfo[buildingid][bPosZ]);
    SetPlayerInterior(playerid, BuildingInfo[buildingid][bPosInterior]);
    SetPlayerFacingAngle(playerid, BuildingInfo[buildingid][bPosA]);
    AC_SetPlayerVirtualWorld(playerid, BuildingInfo[buildingid][bPosWorld]);

    return 1;
}
flags:kumargit(CMD_GAME1);
CMD:kumargit(playerid, params[])
{
    new id;

    if(sscanf(params, "d", id))return
        KullanimMesajiC(playerid, "/kumargit [id]");

    if(id < 0 || id > MAX_GAMES || !GameInfo[id][gameExists])return
        SunucuMesajiC(playerid, "Oyun bulunamad�.");

    SetPlayerPos(playerid, GameInfo[id][gameX], GameInfo[id][gameY], GameInfo[id][gameZ]);
    AC_SetPlayerVirtualWorld(playerid, GameInfo[id][gameWorld]);
    SetPlayerInterior(playerid, GameInfo[id][gameInterior]);

    return 1;
}

flags:h(CMD_SUPPORTER);
CMD:h(playerid, params[])
{
    if(isnull(params) || strlen(params) > 256)return
        KullanimMesajiC(playerid, "/h [yaz�]");

    if(PlayerInfo[playerid][pAdmin] == SUPPORTER) SendSupporterAlert(COLOR_ACIKMAVI, "* Helper (1) %s: %s", ReturnRoleplayName(playerid), params);
    if(PlayerInfo[playerid][pAdmin] == SUPPORTER2) SendSupporterAlert(COLOR_ACIKMAVI, "* Helper (2) %s: %s", ReturnRoleplayName(playerid), params);
    if(PlayerInfo[playerid][pAdmin] == SUPPORTER3) SendSupporterAlert(COLOR_ACIKMAVI, "* Helper (3) %s: %s", ReturnRoleplayName(playerid), params);
    if(PlayerInfo[playerid][pAdmin] >= GAMEADMIN1) return SendSupporterAlert(COLOR_ACIKMAVI, "* Admin %s: %s", ReturnRoleplayName(playerid), params);
    return 1;
}

flags:19payday(CMD_EoloPlus);
CMD:19payday(playerid, params[])
{
    foreach(new i: Player)
	{
        if(PlayerInfo[i][pLogged])
		{
			PlayerInfo[i][pCoynPayday]++;
			BasariMesaji(i, "Tebrikler! Administrator taraf�ndan 1 adet 19-Point Payday puan� kazand�n�z.");
			if(PlayerInfo[i][pCoynPayday] >= SunucuBilgi[NPPayday])
			{
			    PlayerInfo[i][pCoyn]++;
			    PlayerInfo[i][pCoynPayday] = 0;
			    BasariMesaji(i, "Tebrikler! 1 adet 19-Point kazand�n�z. Art�k %d adet 19-Point'e sahipsiniz.", PlayerInfo[i][pCoyn]);
			}
		}
 	}
 	SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s isimli y�netici 19point payday (+1 kalan zaman azaltmas�) yapt�.", ReturnRoleplayName(playerid));
	return 1;
}

flags:giveall19p(CMD_EoloPlus);
CMD:giveall19p(playerid, params[])
{
    new amount;

    if(sscanf(params, "d", amount))return
        KullanimMesajiC(playerid, "/giveall19p [de�er/miktar]");

    if(amount < 0) return
        SunucuMesajiC(playerid, "Ge�ersiz de�er.");

    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s herkese %d 19P g�nderdi.", ReturnRoleplayName(playerid), amount);

    foreach(new i: Player)
	{
        if(PlayerInfo[i][pLogged])
		{
		    PlayerInfo[i][pCoyn] += amount;
		    BasariMesaji(i, "%s sana %d adet 19P verdi. �u anda %d kadar 19 pointe sahipsin.", ReturnRoleplayName(playerid), amount, PlayerInfo[i][pCoyn]);
		}
 	}
 	return 1;
}

flags:krizpayday(CMD_EoloPlus);
CMD:krizpayday(playerid, params[])
{
    foreach(new i: Player)
	{
        if(PlayerInfo[i][pLogged])
		{
			if(PlayerInfo[i][pDrugRemainingTime] == 1)
			{
			    PlayerInfo[i][pDrugCrisis] = 1;
			    PlayerInfo[i][pDrugRemainingTime] = 0;
			}
	        if(PlayerInfo[i][pDrugRemainingTime] > 0 && PlayerInfo[i][pDrugster])
	        {
	        	if(!PlayerInfo[i][pDrugCrisis])
	        	{
					PlayerInfo[i][pDrugRemainingTime]--;
				}
			}
		}
 	}
 	SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s isimli y�netici kriz payday yapt�.", ReturnRoleplayName(playerid));
	return 1;
}

CMD:gizliadminler(playerid, params[])
{
    static const statusMsg[2][10] = {"Hay�r", "Evet"};
    SendClientMessage(playerid, COLOR_GREEN, "Online Gizli Y�neticiler:");

	foreach(new j : Player) if(IsPlayerConnected(j) && PlayerInfo[j][pLogged] && PlayerInfo[j][pAdmin] > SUPPORTER && PlayerInfo[j][pGizliAdmin])
	    if(PlayerInfo[j][pAccountID] == 267 || PlayerInfo[j][pAccountID] == 994)
        SendFormattedMessage(playerid, (PlayerInfo[j][pAdminDuty]) ? COLOR_GREEN : COLOR_GREY, "(Developer) %s (%s) (ID: %d) - ��ba��: %s", ReturnRoleplayName(j), PlayerInfo[j][pUsername], j, statusMsg[PlayerInfo[j][pAdminDuty]]);
        else
        SendFormattedMessage(playerid, (PlayerInfo[j][pAdminDuty]) ? COLOR_GREEN : COLOR_GREY, "(Seviye: %d) %s (%s) (ID: %d) - ��ba��: %s", PlayerInfo[j][pAdmin] - 3, ReturnRoleplayName(j), PlayerInfo[j][pUsername], j, statusMsg[PlayerInfo[j][pAdminDuty]]);

    return 1;
}

flags:listmasks(CMD_GAME1);
CMD:listmasks(playerid, params[])
{
    new string[600], maskecount;
    string = "Karakter ad�\tMaske ad�\n";
    maskecount = 0;
    foreach(new i : Player) if(PlayerInfo[i][pMasked] == 1)
    {
        maskecount++;
        format(string, sizeof(string), "%s(%d) %s\t%s\n", string, i, ReturnRoleplayName(i), PlayerInfo[i][pMaskName]);
    }
	if(maskecount == 0) Dialog_Show(playerid, DialogMaskeliler, DIALOG_STYLE_MSGBOX, "Maskeliler", "Sunucuda maskeli kimse bulunmuyor.", "Kapat", "");
	else Dialog_Show(playerid, DialogMaskeliler, DIALOG_STYLE_TABLIST_HEADERS, "Maskeliler", string, "Kapat", "");
	return 1;
}

flags:maskid(CMD_GAME1);
CMD:maskid(playerid, params[])
{
    new maskid;

    if(sscanf(params, "d", maskid))return
        KullanimMesajiC(playerid, "/maskid [sqlid]");

    if(maskid < 1)return
        SunucuMesajiC(playerid, "Ge�ersiz de�er.");

    mysql_format(ourConnection, queryx, sizeof(queryx), "SELECT char_name FROM characters WHERE id = '%d'", maskid);
    mysql_tquery(ourConnection, queryx, "OnMaskCharacterSearch", "dd", playerid, maskid);

    return 1;
}

flags:factionkick(CMD_iglead);
CMD:factionkick(playerid, params[])
{
    new id;

    if(sscanf(params, "u", id))return
        KullanimMesajiC(playerid, "/factionkick [id/isim]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    new fid = PlayerInfo[id][pFaction];

    if(fid == -1)return
        SunucuMesajiC(playerid, "Kullan�c� olu�umda de�il.");

    PlayerInfo[id][pFaction] = -1;
    PlayerInfo[id][pRank] = 0;

    for(new x; x < 8; x++)
    {
        if(!PlayerInfo[id][pRadioSlot][x]) continue;

        new channel = PlayerInfo[id][pRadioSlot][x];

        if(channel == -1 || channel >= MAX_FREQUENCES || !FrequenceInfo[channel][rExists] || FrequenceInfo[channel][rFaction] != fid)continue;

        PlayerInfo[id][pAuthorized][channel] = false;
        PlayerInfo[id][pRadioSlot][x] = 0;
    }

    FactionInfo[fid][fMembersCount]--;

    BasariMesaji(id, "%s seni %s olu�umundan att�.", ReturnRoleplayName(playerid), FactionInfo[fid][fName]);
    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s ki�isini %s olu�umundan att�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), FactionInfo[fid][fName]);

    Faction_OffDuty(id);

    LogYaz(playerid, "/factionkick", id, fid);

    return 1;
}

flags:setadmin(CMD_EoloPlus);
CMD:setadmin(playerid, params[])
{
    new id;
    new level;

    if(sscanf(params, "ud", id, level))return
        KullanimMesajiC(playerid, "/setadmin [id/isim] [seviye]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(level < 0 || level > 150)return
        SunucuMesajiC(playerid, "Ge�ersiz seviye. (0 - 150)");

    if(!level && PlayerInfo[id][pAdminDuty])
        pc_cmd_awork(id, "");

    if(PlayerInfo[id][pSupporterDuty])
        pc_cmd_tduty(id, NULL);

	if(level != 0) {
    	PlayerInfo[id][pAdmin] = level + 3;
	}
	else if(level == 0){
	    PlayerInfo[id][pAdmin] = 0;
	}

    SaveCharacter(id);
    if(PlayerInfo[id][pAdmin] >= 1) {
        BasariMesaji(id, "Yetki seviyen %d olarak de�i�tirildi.", level);
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s isimli oyuncunun yetkisini %d olarak ayarlad�.", PlayerInfo[playerid][pUsername], PlayerInfo[id][pUsername], level);
    }
    else {
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s isimli yetkiliyi oyuncu yapt�.", PlayerInfo[playerid][pUsername], PlayerInfo[id][pUsername]);
        SendClientMessageEx(id, COLOR_ADMIN, "Yetki seviyen oyuncu olarak de�i�tirildi.");
    }
    return 1;
}

// ATM Komutlar�

flags:atmolustur(CMD_GAME3);
flags:atmiptal(CMD_GAME3);
flags:atmsil(CMD_GAME3);
flags:atmlerisil(CMD_GAME3);
flags:yakinimdakiatm(CMD_GAME3);

CMD:atmolustur(playerid) {
	if(Iter_Count(ATMler) >= MAX_ATM) return HataMesajiC(playerid, "Sunucu max ATM limitine ula��ld�, l�tfen bir ATM silin.");
	if(GetPVarInt(playerid, "ATMOlusturuyor")) return HataMesajiC(playerid, "Zaten bir ATM olu�turuyorsunuz.");
	if(!GetPVarInt(playerid, "ATMPickup"))
		Dialog_Show(playerid, DialogATMOlusturSecenek, DIALOG_STYLE_MSGBOX, "Y�netici ATM Olu�turma Paneli", "Nineteen Roleplay ATM Olu�turma men�s�ne ho�geldiniz.\nL�tfen a�a��dan objesiz ATM mi yoksa objeli ATM mi olu�turmak istedi�inizi se�in.", "Objeli", "Objesiz");
	else {
		new id = GetPVarInt(playerid, "ATMID");
		if(ATMInfo[id][atmExists]) {
			GetPlayerPos(playerid, ATMInfo[id][atmPickupX], ATMInfo[id][atmPickupY], ATMInfo[id][atmPickupZ]);
			Pickup_Destroy(ATMInfo[id][atmPickupID]);
			ATMInfo[id][atmPickupID] = Pickup_Create(ELEMENT_ATM, id, 1274, 1, ATMInfo[id][atmPickupX], ATMInfo[id][atmPickupY], ATMInfo[id][atmPickupZ], ATMInfo[id][atmVW], ATMInfo[id][atmInterior]);
			DeletePVar(playerid, "ATMPickup");
			DeletePVar(playerid, "ATMID");
			SunucuMesaji(playerid, "ATM yaratma i�lemi bitti.");
			atmyarat(id);
		} else {
			DeletePVar(playerid, "ATMPickup");
			DeletePVar(playerid, "ATMID");
			HataMesajiC(playerid, "Yaratt���n�z ATM silinmi�.");
		}
	}
	return 1;
}

CMD:atmiptal(playerid) {
	if(!GetPVarInt(playerid, "ATMPickup")) return HataMesajiC(playerid, "Zaten bir ATM'nin pickup'�n� yerle�tirmiyorsunuz.");
	new atmid = GetPVarInt(playerid, "ATMID");
	atmyarat(atmid);
	DeletePVar(playerid, "ATMPickup");
	DeletePVar(playerid, "ATMID");
	SunucuMesaji(playerid, "ATM Pickup'� yerle�tirme i�lemini iptal ettiniz.");
	return 1;
}

CMD:atmsil(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return KullanimMesajiC(playerid, "/atmsil [atm ID]");
	new exists = ATMSil(id);
	if(!exists) return HataMesajiC(playerid, "Belirtti�iniz ID'de ATM yok.");
	return 1;
}

CMD:atmlerisil(playerid) {
	new count = TumATMleriSil();
	SendFormattedMessage(playerid, COLOR_ADMIN, "%d adet atm sildiniz.", count);
    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s adl� y�netici t�m ATM'leri kald�rd�.", ReturnRoleplayName(playerid));
   	mysql_format(ourConnection, queryx, sizeof(queryx), "TRUNCATE TABLE atmler");
	mysql_tquery(ourConnection, queryx);
    return 1;
}

CMD:yakinimdakiatm(playerid) {
	new atm = YakindakiATMBul(playerid);
	if(atm != -1)
		SunucuMesaji(playerid, "Yak�n�n�zdaki ATM'nin ID'si %d.", atm);
	else
		HataMesajiC(playerid, "Yak�n�n�zda ATM yok.");
	return 1;
}

// Y�NET�C� ARA� KOMUTLARI

flags:vfaction(CMD_iglead);
CMD:vfaction(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))return
        HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    new vid = GetPlayerVehicleID(playerid),
        factionid;

    if(sscanf(params, "d", factionid))return
        KullanimMesajiC(playerid, "/vfaction [id]");

    if(factionid < 0 || factionid >= MAX_FACTIONS || !FactionInfo[factionid][fExists])return
        SunucuMesaji(playerid, "Olu�um bulunamad�.");

    VehicleInfo[vid][vFaction] = factionid;
    VehicleInfo[vid][vOwner] = -1;
    
    mysql_format(ourConnection, queryx, sizeof(queryx), "UPDATE vehicles SET owner_id = '-1' WHERE id = '%d'", VehicleInfo[vid][vID]);
    mysql_tquery(ourConnection, queryx);

    if(!VehicleInfo[vid][vTemporary])SaveVehicle(vid);

    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %d ID'li arac�n olu�umunu \"%d\" ID'li olu�um olarak de�i�tirdi.", ReturnRoleplayName(playerid), vid, factionid);

    LogYaz(playerid, "/vfaction", -1, vid, factionid);

    return 1;
}
flags:vfuel(CMD_iglead);
CMD:vfuel(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))return
        HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    new vid = GetPlayerVehicleID(playerid);
    new fuel;

    if(sscanf(params, "d", fuel))return
        KullanimMesajiC(playerid, "/vfuel [benzin]");

    if(fuel < 0 || fuel > 100) return HataMesajiC(playerid, "Ge�ersiz de�er. (0 - 100)");

    VehicleInfo[vid][vFuel] = fuel;
    return 1;
}
flags:vhp(CMD_iglead);
CMD:vhp(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))return
        HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    new vid = GetPlayerVehicleID(playerid);
    new Float:hp;

    if(sscanf(params, "f", hp))return
        KullanimMesajiC(playerid, "/vhp [hp]");

    if(floatround(hp) < 500.0 || floatround(hp) > 10000.0) return HataMesajiC(playerid, "HP invalidi (500-10000).");

    VehicleInfo[vid][vMaxHealth] = hp;
    VehicleInfo[vid][vRespraying] = 3;
    SetVehicleHealth(vid, hp);

    if(!VehicleInfo[vid][vTemporary]) SaveVehicle(vid);

    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s, %d ID'li arac�n HP limitini \"%1.f\" olarak ayarlad�.", ReturnRoleplayName(playerid), vid, hp);

    LogYaz(playerid, "/vhp", -1, vid);

    return 1;
}
flags:vspawn(CMD_GAME1);
CMD:vspawn(playerid, params[])
{
    new id;

    if(sscanf(params, "d", id))return
        KullanimMesajiC(playerid, "/vspawn [database id]");

    if(id < 1)return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    mysql_format(ourConnection, queryx, sizeof(queryx), "SELECT * FROM vehicles WHERE id = '%d'", id);
    mysql_tquery(ourConnection, queryx, "OnAVSpawnSearch", "dd", playerid, id);

    return 1;
}

flags:aracsahip(CMD_iglead);
CMD:aracsahip(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))return
        HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    new vid = GetPlayerVehicleID(playerid),
        id;

    if(sscanf(params, "u", id))return
        KullanimMesajiC(playerid, "/aracsahip [id/isim]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    VehicleInfo[vid][vOwner] = PlayerInfo[id][pID];

    if(!VehicleInfo[vid][vTemporary])SaveVehicle(vid);

    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s, %d ID'li arac�n sahibini %s olarak ayarlad�.", ReturnRoleplayName(playerid), vid, ReturnRoleplayName(id));

    LogYaz(playerid, "/aracsahip", id, vid);

    return 1;
}

flags:aracmeslek(CMD_iglead);
CMD:aracmeslek(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))return
        HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    new vid = GetPlayerVehicleID(playerid),
        jobid;

    if(sscanf(params, "d", jobid))return
        KullanimMesajiC(playerid, "/aracmeslek [id]");

    if(jobid < 0 || jobid > 3)return
        SunucuMesaji(playerid, "Meslek bulunamad�.");

    VehicleInfo[vid][vJob] = jobid;
    VehicleInfo[vid][vOwner] = -1;

    if(!VehicleInfo[vid][vTemporary])SaveVehicle(vid);

    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %d ID'li arac�n mesle�ini de�i�tirdi. Meslek: \"%d\".", ReturnRoleplayName(playerid), vid, jobid);

    return 1;
}

flags:vplate(CMD_iglead);
CMD:vplate(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))return
        HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    new vid = GetPlayerVehicleID(playerid),
        plate[13];

    if(sscanf(params, "s[13]", plate))return
        KullanimMesajiC(playerid, "/vplate [plaka]");

    mysql_format(ourConnection, queryx, sizeof(queryx), "SELECT plate FROM vehicles WHERE plate = '%e'", plate);
    mysql_tquery(ourConnection, queryx, "OnVPlateSearch", "dds", playerid, vid, plate);

    return 1;
}

flags:refuelveh(CMD_GAME1);
CMD:refuelveh(playerid, params[])
{
    new vehicleid;

    if(IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);

    if(!vehicleid && sscanf(params, "d",vehicleid))return
        KullanimMesajiC(playerid, "/refuelveh [id]");

    if(!IsValidVehicle(vehicleid))return
        SunucuMesajiC(playerid, "Varolmayan ara�.");

    VehicleInfo[vehicleid][vFuel] = 100;

    return 1;
}

flags:aracomuryenile(CMD_iglead);
CMD:aracomuryenile(playerid, params[])
{
    new vehicleid;

    if(IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);

    if(!vehicleid && sscanf(params, "d",vehicleid))return
        KullanimMesajiC(playerid, "/aracomuryenile [id]");

    if(!IsValidVehicle(vehicleid))return
        SunucuMesaji(playerid, "Varolmayan ara�.");

    VehicleInfo[vehicleid][vEngineHealth] = 1000.0;
    VehicleInfo[vehicleid][vBatteryHealth] = 1000.0;
    SunucuMesaji(playerid, "%d ID'li arac�n ak� ve motor �mr�n� yeniledin.", vehicleid);

    return 1;
}

flags:aaracara(CMD_GAME2);
CMD:aaracara(playerid, params[])
{
    new vid = GetNearestVehicle(playerid);

    if(vid == -1)return
        SunucuMesajiC(playerid, "Arac�n yak�n�nda veya i�erisinde de�ilsin.");

    Trunk_ShowItems(playerid, vid);

    PlayerME(playerid, "arac� aramaya ba�lar.");

    return 1;
}

// Trucker

flags:truckeryenile(CMD_GAME1);
CMD:truckeryenile(playerid, params[])
{
	foreach(new k: Companies)
	{
		if(CompanyInfo[k][cValid])
		{
			switch(CompanyInfo[k][sirketid])
			{
				case 0: CompanyInfo[k][stok] = 0;
				default: CompanyInfo[k][stok] = CompanyInfo[k][mstok];
			}
		}
		Company_RefreshText(k);
	}
 	SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, adl� yetkili trucker noktalar�n� yeniledi.", ReturnRoleplayName(playerid));
	return 1;
}

CMD:cdelete(playerid, params[])
{
    new companyid;

    if(sscanf(params, "d", companyid))return
        KullanimMesajiC(playerid, "/cdelete [id]");

    if(companyid < 0 || companyid >= MAX_COMPANIES || !CompanyInfo[companyid][cValid])return
        SunucuMesajiC(playerid, "Ge�ersiz trucker.");

    // new query[256];

    mysql_format(ourConnection, queryx, sizeof(queryx), "DELETE FROM companies WHERE id = '%d'", CompanyInfo[companyid][cReference]);
    mysql_tquery(ourConnection, queryx);

    Pickup_Destroy(CompanyInfo[companyid][cPoint]);
    DestroyDynamic3DTextLabelEx(CompanyInfo[companyid][cText]);

    CompanyInfo[companyid][cBuyPosX] = 0;
    CompanyInfo[companyid][cBuyPosY] = 0;
    CompanyInfo[companyid][cBuyPosZ] = 0;

    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s %d ID'li trucker� yok etti.", ReturnRoleplayName(playerid), companyid);

    Iter_Remove(Companies, companyid);

    LogYaz(playerid, "/cdelete", -1, companyid);

    return 1;
}

CMD:bedit(playerid, params[])
{
    new buildingid,
        option[20],
        amount,
        name[32];

    if(sscanf(params, "ds[20]D(-1)S()[32]", buildingid, option, amount, name))return
        KullanimMesajiC(playerid, "/bedit [id] [interior - pozisyon - kilit - fiyat - sifirla - girisucreti - isim - tip - olusum - urun]");

    if(buildingid < 0 || buildingid >= MAX_BUILDINGS || !BuildingInfo[buildingid][bExists])return
        SunucuMesaji(playerid, "Varolmayan bina.");

    if(!strcmp(option, "interior", true))
    {
        new Float:x,
            Float:y,
            Float:z;

        GetPlayerPos(playerid, x, y, z);

        BuildingInfo[buildingid][bPosIntX] = x;
        BuildingInfo[buildingid][bPosIntY] = y;
        BuildingInfo[buildingid][bPosIntZ] = z;
        BuildingInfo[buildingid][bInterior] = GetPlayerInterior(playerid);

        AC_SetPlayerVirtualWorld(playerid, BuildingInfo[buildingid][bWorld]);

        LogYaz(playerid, "/bedit interior", -1, buildingid);

        SaveBuilding(buildingid);
    }
    else if(!strcmp(option, "pozisyon", true))
    {
        new Float:x,
            Float:y,
            Float:z,
            Float:a;

        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        BuildingInfo[buildingid][bPosX] = x;
        BuildingInfo[buildingid][bPosY] = y;
        BuildingInfo[buildingid][bPosZ] = z;
        BuildingInfo[buildingid][bPosA] = a;
        BuildingInfo[buildingid][bPosWorld] = GetPlayerVirtualWorld(playerid);
        BuildingInfo[buildingid][bPosInterior] = GetPlayerInterior(playerid);

        Pickup_Destroy(BuildingInfo[buildingid][bPickup]);
        DestroyDynamic3DTextLabelEx(BuildingInfo[buildingid][bLabel]);

        BuildingInfo[buildingid][bPickup] = Pickup_Create(ELEMENT_BUILDING, buildingid, (BuildingInfo[buildingid][bType] == COMPLEX) ? 1314 : 1239, 23, BuildingInfo[buildingid][bPosX], BuildingInfo[buildingid][bPosY], BuildingInfo[buildingid][bPosZ], BuildingInfo[buildingid][bPosWorld], BuildingInfo[buildingid][bPosInterior]);
        BuildingInfo[buildingid][bLabel] = CreateDynamic3DTextLabel(BuildingInfo[buildingid][bName], COLOR_WHITE, BuildingInfo[buildingid][bPosX], BuildingInfo[buildingid][bPosY], BuildingInfo[buildingid][bPosZ]+0.4, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, BuildingInfo[buildingid][bPosWorld], BuildingInfo[buildingid][bPosInterior], -1);

        LogYaz(playerid, "/bedit pozisyon", -1, buildingid);

        SaveBuilding(buildingid);
    }
    else if(!strcmp(option, "fiyat", true))
    {
        if(amount == -1)return
            KullanimMesajiC(playerid, "/bedit [id] [fiyat] [de�er/miktar]");

        if(amount < 1 || amount > 999999)return
            SunucuMesaji(playerid, "Ge�ersiz de�er. ($1 - $999999)");

        BuildingInfo[buildingid][bPrice] = amount;

        LogYaz(playerid, "/bedit fiyat", -1, buildingid, amount);

        SaveBuilding(buildingid);
    }
    else if(!strcmp(option, "kilit", true))
    {
        BuildingInfo[buildingid][bLocked] = !BuildingInfo[buildingid][bLocked];

        SaveBuilding(buildingid);
    }
    else if(!strcmp(option, "sifirla", true))
    {
        Building_Reset(buildingid);

        LogYaz(playerid, "/bedit sifirla", -1, buildingid);
    }
    else if(!strcmp(option, "girisucreti", true))
    {
        if(amount == -1)return
            KullanimMesajiC(playerid, "/bedit [id] <entrata> [de�er/miktar]");

        if(amount < 0 || amount > 500)return
            SunucuMesaji(playerid, "Ge�ersiz de�er. ($0 - $500)");

        BuildingInfo[buildingid][bEntrance] = amount;

        LogYaz(playerid, "/bedit girisucreti", -1, buildingid, amount);

        SaveBuilding(buildingid);
    }
    else if(!strcmp(option, "isim", true))
    {
        if(!strlen(name) || strlen(name) > 32)return
            KullanimMesajiC(playerid, "/bedit [id] [isim] <-1> [yaz�]");

        format(BuildingInfo[buildingid][bName], 32, name);

        UpdateDynamic3DTextLabelText(BuildingInfo[buildingid][bLabel], COLOR_WHITE, BuildingInfo[buildingid][bName]);

        LogYaz(playerid, "/bedit isim", -1, buildingid);

        SaveBuilding(buildingid);
    }
    else if(!strcmp(option, "tip", true))
    {
        if(amount == -1)return
            KullanimMesajiC(playerid, "/bedit [id] [tip] [numara]");

        if(amount < 0 || amount >= MAX_TYPES)return
            HataMesaji(playerid, "Ge�ersiz se�enek. (0 - %d)", MAX_TYPES-1);

        BuildingInfo[buildingid][bType] = amount;

        LogYaz(playerid, "/bedit tip", -1, buildingid, amount);

        SaveBuilding(buildingid);
    }
    else if(!strcmp(option, "olusum", true))
    {
        if(amount == -1)return
            KullanimMesajiC(playerid, "/bedit [id] [olu�um] [id]");

        if(amount < 0 || amount >= MAX_FACTIONS || !FactionInfo[amount][fExists])return
            SunucuMesaji(playerid, "Ge�ersiz olu�um.");

        BuildingInfo[buildingid][bFaction] = amount;

        LogYaz(playerid, "/bedit olusum", -1, buildingid, amount);

        SaveBuilding(buildingid);
    }
    else if(!strcmp(option, "urun", true))
    {
        if(amount == -1)return
            KullanimMesajiC(playerid, "/bedit [id] [�r�n] [miktar]");

        if(amount < 0)return
            SunucuMesajiC(playerid, "Envanterde bo� yer yok.");

        BuildingInfo[buildingid][bProducts] = amount;

        LogYaz(playerid, "/bedit urun", -1, buildingid, amount);

        SaveBuilding(buildingid);
    }
    else return
        HataMesajiC(playerid, "Ge�ersiz parametre.");

    SendAdminAlert(false, COLOR_ADMIN, "AdmCmd: %s, %d ID'li yap�y� d�zenledi. Se�im: \"%s\" - de�i�tirilen de�er: \"%d\".", ReturnRoleplayName(playerid), buildingid, option, amount);

    return 1;
}

// Setstat Diyaloglar�

flags:setstat(CMD_GAME2);
CMD:setstat(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id)) return KullanimMesajiC(playerid, "/setstat [id/isim]");
	if(!IsPlayerConnected(id)) return HataMesajiC(playerid, "Oyuncu oyunda de�il.");
	if(!PlayerInfo[id][pLogged]) return HataMesajiC(playerid, "Oyuncu giri� yapmam��.");
	PlayerInfo[playerid][pSetStatID] = id;
	new string[75];
	format(string, sizeof string, "%s - De�i�im Men�s�", ReturnRoleplayName(id));
	Dialog_Show(playerid, DialogSetStat, DIALOG_STYLE_LIST, string, "Seviye\nCinsiyet\nYa�\nOlu�um ayarla\nMeslek ayarla\nTecr�be ayarla\nOynama saati ayarla\nPlaka de�i�im hakk�\n�sim de�i�ikli�i hakk�\nTelefon Numaras� De�i�ikli�i Hakk�\nOOC kanal kapatma izni\nPM izni\nTen rengi\nAra� Ehliyeti\nDeniz Ehliyeti\nU�ak Ehliyeti", "Se�", "�ptal", ReturnRoleplayName(id));
	return 1;
}

Dialog:DialogIrkAdmin(playerid, response, listitem, inputtext[])
{
    new id = PlayerInfo[playerid][pSetStatID];

    if(response)
	{
        PlayerInfo[id][pTenRengi] = 0;
        BasariMesajiC(id, "Administrator taraf�ndan ten renginiz beyaz olarak i�aretlendi.");
		SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s adl� oyuncunun ten rengini beyaz yapt�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id));
    }
	else
	{
        PlayerInfo[id][pTenRengi] = 1;
        BasariMesajiC(id, "Administrator taraf�ndan ten renginiz siyah olarak i�aretlendi.");
		SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s adl� oyuncunun ten rengini siyah yapt�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id));
    }
    return 1;
}

Dialog:DialogSetStatLevel(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(!isnull(inputtext)) {
			if(IsNumeric(inputtext)) {
				if(strval(inputtext) > 0) {
					new id = PlayerInfo[playerid][pSetStatID];
					if(IsPlayerConnected(id) && PlayerInfo[id][pLogged]) {
						PlayerInfo[id][pLevel] = strval(inputtext);
						PlayerInfo[id][pExperience] = 0;
						BasariMesaji(id, "Y�netici %s taraf�ndan seviyeniz %d yap�ld�.", ReturnRoleplayName(playerid), strval(inputtext));
						SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s adl� oyuncunun seviyesini %d yapt�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), strval(inputtext));
						SetPlayerScore(id, PlayerInfo[id][pLevel]);
					} else return HataMesajiC(playerid, "Oyuncu �evrimi�i de�il ya da giri� yapmam��.");
				} else return HataMesajiC(playerid, "Seviye 0'dan b�y�k olmal�.");
			} else return HataMesajiC(playerid, "Seviye say�sal de�er olmal�.");
		} else return HataMesajiC(playerid, "Kutu bo� b�rak�lamaz.");
	}
	return 1;
}

Dialog:DialogSetStatCinsiyet(playerid, response, listitem, inputtext[]) {
	if(response) {
		new id = PlayerInfo[playerid][pSetStatID];
		PlayerInfo[id][pSex] = 0;
		BasariMesaji(id, "Y�netici %s taraf�ndan cinsiyetiniz Erkek yap�ld�.", ReturnRoleplayName(playerid));
		SendAworkAlert(false, COLOR_ADMIN, "%s, %s adl� oyuncunun cinsiyetini erkek yapt�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id));
	} else {
		new id = PlayerInfo[playerid][pSetStatID];
		PlayerInfo[id][pSex] = 1;
		BasariMesaji(id, "Y�netici %s taraf�ndan cinsiyetiniz Kad�n yap�ld�.", ReturnRoleplayName(playerid));
		SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s adl� oyuncunun cinsiyetini kad�n yapt�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id));
	}
	return 1;
}

Dialog:DialogSetStatYas(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(!isnull(inputtext)) {
			if(IsNumeric(inputtext)) {
				if(strval(inputtext) >= 16 && strval(inputtext) <= 70) {
					new id = PlayerInfo[playerid][pSetStatID];
					if(IsPlayerConnected(id) && PlayerInfo[id][pLogged]) {
						PlayerInfo[id][pAge] = strval(inputtext);
						BasariMesaji(id, "Y�netici %s taraf�ndan ya��n�z %d yap�ld�.", ReturnRoleplayName(playerid), strval(inputtext));
					} else return HataMesajiC(playerid, "Oyuncu �evrimi�i de�il ya da giri� yapmam��.");
				} else return HataMesajiC(playerid, "Ya� en az 16 en fazla 70 olmal�.");
			} else return HataMesajiC(playerid, "Ya� say�sal de�er olmal�.");
		} else return HataMesajiC(playerid, "Kutu bo� b�rak�lamaz.");
	}
	return 1;
}

Dialog:DialogSetStatOlusum(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(!isnull(inputtext)) {
			new faction, rutbe;
			sscanf(inputtext, "dd", faction, rutbe);
			if(faction >= 0 && faction < MAX_FACTIONS) {
				if(rutbe >= 0 && rutbe < MAX_FACTION_RANKS) {
					new id = PlayerInfo[playerid][pSetStatID];
					if(IsPlayerConnected(id) && PlayerInfo[id][pLogged]) {
						PlayerInfo[id][pFaction] = faction;
					    PlayerInfo[id][pRank] = rutbe;

					    FactionInfo[faction][fMembersCount]++;

					    BasariMesaji(id, "%s seni %s olu�umuna ald�. (%s)", ReturnRoleplayName(playerid), FactionInfo[faction][fName], fRanks[faction][rutbe-1]);
					    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s ki�isini %s (%s) olu�umuna ald�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), FactionInfo[faction][fName], fRanks[faction][rutbe-1]);

					    LogYaz(playerid, "/setfaction", id, faction, rutbe);
					} else return HataMesajiC(playerid, "Oyuncu �evrimi�i de�il ya da giri� yapmam��.");
				} else return HataMesajiC(playerid, "Ge�ersiz faction r�tbesi.");
			} else return HataMesajiC(playerid, "Ge�ersiz faction ID.");
		} else return HataMesajiC(playerid, "Kutu bo� b�rak�lamaz.");
	}
	return 1;
}

Dialog:DialogSetStatTecrube(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(!isnull(inputtext)) {
			if(IsNumeric(inputtext)) {
				if(strval(inputtext) >= 0) {
					new id = PlayerInfo[playerid][pSetStatID];
					if(IsPlayerConnected(id) && PlayerInfo[id][pLogged]) {
						PlayerInfo[id][pExperience] = strval(inputtext);
						BasariMesaji(id, "Y�netici %s taraf�ndan tecr�be puan�n�z %d yap�ld�.", ReturnRoleplayName(playerid), strval(inputtext));
						SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s adl� oyuncunun tecr�be puan�n� %d yapt�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), strval(inputtext));
						do {
							if(PlayerInfo[id][pExperience] >= PlayerInfo[id][pLevel] * 4) {
								PlayerInfo[id][pExperience] -= PlayerInfo[id][pLevel] * 4;
								PlayerInfo[id][pLevel]++;
								//PlayerInfo[id][pUpgradePoints] += 2;
							}
						} while(PlayerInfo[id][pExperience] >= PlayerInfo[id][pLevel] * 4);
						SetPlayerScore(id, PlayerInfo[id][pLevel]);
						BasariMesaji(id, "Seviye atlad�n. Art�k %d seviyesindesin.", PlayerInfo[id][pLevel]);
					} else return HataMesajiC(playerid, "Oyuncu �evrimi�i de�il ya da giri� yapmam��.");
				} else return HataMesajiC(playerid, "Tecr�be en az 0 olmal�.");
			} else return HataMesajiC(playerid, "Tecr�be say�sal de�er olmal�.");
		} else return HataMesajiC(playerid, "Kutu bo� b�rak�lamaz.");
	}
	return 1;
}

Dialog:DialogSetStatSaat(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(!isnull(inputtext)) {
			if(IsNumeric(inputtext)) {
				if(strval(inputtext) >= 0) {
					new id = PlayerInfo[playerid][pSetStatID];
					if(IsPlayerConnected(id) && PlayerInfo[id][pLogged]) {
						PlayerInfo[id][pPlayingHours] = strval(inputtext);
						BasariMesaji(id, "Y�netici %s taraf�ndan oynama saatiniz %d yap�ld�.", ReturnRoleplayName(playerid), strval(inputtext));
						SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s adl� oyuncunun oynama saatini %d yapt�.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), strval(inputtext));
					} else return HataMesajiC(playerid, "Oyuncu �evrimi�i de�il ya da giri� yapmam��.");
				} else return HataMesajiC(playerid, "Oynama saati en az 0 olmal�.");
			} else return HataMesajiC(playerid, "Oynama saati say�sal de�er olmal�.");
		} else return HataMesajiC(playerid, "Kutu bo� b�rak�lamaz.");
	}
	return 1;
}



// Y�ksek Seviye Y�neticiler

CMD:setadming(playerid, params[])
{
    new id;
    new level;

//    if(!IsPlayerAdmin(playerid)) return 1;

	if(PlayerInfo[playerid][pAccountID] != 288 && PlayerInfo[playerid][pAccountID] != 267 && PlayerInfo[playerid][pAccountID] != 255 && PlayerInfo[playerid][pAccountID] != 289 && PlayerInfo[playerid][pAccountID] != 994 && PlayerInfo[playerid][pAccountID] != 271 && PlayerInfo[playerid][pAccountID] != 260 && PlayerInfo[playerid][pAccountID] != 261 && PlayerInfo[playerid][pAccountID] != 257)
		return HataMesajiC(playerid, "Bu i�lemi yapamazs�n.");

    if(sscanf(params, "ud", id, level))return
        KullanimMesajiC(playerid, "/setadmin [id/isim] [seviye]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(level < 0 || level > 150)return
        SunucuMesajiC(playerid, "Ge�ersiz seviye. (0 - 150)");

    if(!level && PlayerInfo[id][pAdminDuty])
        pc_cmd_awork(id, "");

    if(PlayerInfo[id][pSupporterDuty])
        pc_cmd_tduty(id, NULL);

	if(level != 0) {
    	PlayerInfo[id][pAdmin] = level + 3;
	}
	else if(level == 0){
	    PlayerInfo[id][pAdmin] = 0;
	}

    SaveCharacter(id);
    SaveCharacter(id);
    if(PlayerInfo[id][pAdmin] >= 1) {
        BasariMesaji(id, "Yetki seviyen %d olarak de�i�tirildi.", level);
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s isimli oyuncunun yetkisini %d olarak ayarlad�.", PlayerInfo[playerid][pUsername], PlayerInfo[id][pUsername], level);
    }
    else {
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s isimli yetkiliyi oyuncu yapt�.", PlayerInfo[playerid][pUsername], PlayerInfo[id][pUsername]);
        SendClientMessageEx(id, COLOR_ADMIN, "Yetki seviyen oyuncu olarak de�i�tirildi.");
    }
    return 1;
}

CMD:sethelper(playerid, params[])
{
    new id;
    new level;

    if(sscanf(params, "ud", id, level))return
        KullanimMesajiC(playerid, "/setadmin [id/isim] [seviye]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(level < 0 || level > 3)return
        SunucuMesajiC(playerid, "Ge�ersiz seviye. (0 - 3)");

    if(!level && PlayerInfo[id][pAdminDuty])
        pc_cmd_awork(id, "");

    if(PlayerInfo[id][pSupporterDuty])
        pc_cmd_tduty(id, NULL);
        
    PlayerInfo[id][pAdmin] = level;

    SaveCharacter(id);
    if(PlayerInfo[id][pAdmin] >= 1) {
        BasariMesaji(id, "Yetki seviyen %d olarak de�i�tirildi.", level);
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s isimli oyuncunun yetkisini %d olarak ayarlad�.", PlayerInfo[playerid][pUsername], PlayerInfo[id][pUsername], level);
    }
    else {
        SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s, %s isimli yetkiliyi oyuncu yapt�.", PlayerInfo[playerid][pUsername], PlayerInfo[id][pUsername]);
        SendClientMessageEx(id, COLOR_ADMIN, "Yetki seviyen oyuncu olarak de�i�tirildi.");
    }
    return 1;
}
