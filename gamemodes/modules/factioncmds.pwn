// Genel

CMD:fkov(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1 || PlayerInfo[playerid][pRank] > 3)
        return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    new name[MAX_PLAYER_NAME];
    new fid = PlayerInfo[playerid][pFaction];

    if(sscanf(params, "s[24]", name))return
        KullanimMesajiC(playerid, "/fkov [isim]");

    mysql_format(ourConnection, queryx, sizeof(queryx), "SELECT char_name, id, faction_rank_id FROM characters WHERE char_name = '%e' AND banned = 0 AND faction_id = '%d' AND deleted = 0 AND deleted_at IS NULL", name, fid);
    mysql_tquery(ourConnection, queryx, "OnFKickPlayerSearch", "dds", playerid, fid, name);

    return 1;
}

CMD:fdavet(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1 || PlayerInfo[playerid][pRank] > 3)
        return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    new id;

    if(sscanf(params, "k<m>", id))return
        KullanimMesajiC(playerid, "/fdavet [id/isim]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesajiC(playerid, "Bir olu�uma kendini davet edemezsin.");

    if(PlayerInfo[id][pFaction] != -1)return
        SunucuMesajiC(playerid, "Bu oyuncu zaten ba�ka bir olu�umda.");

    PlayerInfo[id][pRequesterFaction] = playerid;

    BasariMesaji(id, "%s seni %s olu�umuna davet etti. /kabulet olusum kullanarak olu�uma dahil olabilirsin.", ReturnRoleplayName(playerid), FactionInfo[PlayerInfo[playerid][pFaction]][fName]);
    BasariMesaji(playerid, "%s ki�isini olu�uma davet ettin.", ReturnRoleplayName(id));

    return 1;
}

CMD:fbirim(playerid, params[])
{
    if(PlayerInfo[playerid][pRank] > 3)
        return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE) {
        static const divisionsName[5][84] = {"Dedektif B�ro", "SWAT", "Lisans", "ASD", "Trafik"};

        new id, division;

        if(!sscanf(params, "k<m>d", id, division))
        {
            if(PlayerInfo[id][pFaction] != PlayerInfo[playerid][pFaction])return
                SunucuMesajiC(playerid, "Bu ki�i sizin olu�umunuzda de�il.");

            if(division < 1 || division > 5)return
                SunucuMesaji(playerid, "Birim bulunamad�. (1 - 3)");

            division--;

            PlayerInfo[id][pDivision][division] = !PlayerInfo[id][pDivision][division];

            if(PlayerInfo[id][pDivision][division])
            {
                BasariMesaji(playerid, "%s ki�isini %s birimine ald�n.", ReturnRoleplayName(id), divisionsName[division]);
                BasariMesaji(id, "%s ki�isi seni %s birimine ald�.", ReturnRoleplayName(playerid), divisionsName[division]);
            }
            else
            {
                BasariMesaji(playerid, "%s ki�isini %s biriminden ��kartt�n.", ReturnRoleplayName(id), divisionsName[division]);
                BasariMesaji(id, "%s ki�isi seni %s biriminden ��kartt�.", ReturnRoleplayName(playerid), divisionsName[division]);
            }
        }
        else return
            KullanimMesajiC(playerid, "/fbirim [id/isim] [1: DB - 2: SWAT - 3: Lisans - 4: ASD - 5: Trafik]");
    } else {
        static const divisionsName[84] = {"Lisans"};

        new id, division;

        if(!sscanf(params, "k<m>d", id, division))
        {
            if(PlayerInfo[id][pFaction] != PlayerInfo[playerid][pFaction])return
                SunucuMesajiC(playerid, "Bu ki�i sizin olu�umunuzda de�il.");

            if(division != 1)return
                SunucuMesaji(playerid, "Birim bulunamad�. (Sadece 1 yazabilirsiniz)");

            division--;

            PlayerInfo[id][pDivision][division] = !PlayerInfo[id][pDivision][division];

            if(PlayerInfo[id][pDivision][division])
            {
                BasariMesaji(playerid, "%s ki�isini %s birimine ald�n.", ReturnRoleplayName(id), divisionsName);
                BasariMesaji(id, "%s ki�isi seni %s birimine ald�.", ReturnRoleplayName(playerid), divisionsName);
            }
            else
            {
                BasariMesaji(playerid, "%s ki�isini %s biriminden ��kartt�n.", ReturnRoleplayName(id), divisionsName);
                BasariMesaji(id, "%s ki�isi seni %s biriminden ��kartt�.", ReturnRoleplayName(playerid), divisionsName);
            }
        }
        else return
            KullanimMesajiC(playerid, "/fbirim [id/isim] [1: Lisans]");
    }

    return 1;
}
CMD:frutbe(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1 || PlayerInfo[playerid][pRank] > 3)
        return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    new id, rank, fid = PlayerInfo[playerid][pFaction];

    if(sscanf(params, "k<m>d", id, rank))return
        KullanimMesajiC(playerid, "/frutbe [id/isim] [r�tbe]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesajiC(playerid, "Hatal� ID giri�i tespit edildi.");

    if(rank < 1 || rank > MAX_FACTION_RANKS)return
        HataMesaji(playerid, "Ge�ersiz r�tbe. (1 - %d)", MAX_FACTION_RANKS);

    if(PlayerInfo[id][pFaction] != PlayerInfo[playerid][pFaction])return
        SunucuMesajiC(playerid, "Bu ki�i sizin olu�umunuzda de�il.");
    
    foreach(new x : Player) if(IsPlayerConnected(x) && PlayerInfo[x][pFaction] == PlayerInfo[playerid][pFaction] && PlayerInfo[x][pFactionOOC])
    {
        if(PlayerInfo[playerid][pFaction] == 0) SendFormattedMessage(x, RENK_LSPD, "(( %s, %s adl� �yenin r�tbesini %s yapt�. ))", ReturnRoleplayName(playerid), ReturnRoleplayName(id), fRanks[fid][rank - 1]);
        else if(PlayerInfo[playerid][pFaction] == 1) SendFormattedMessage(x, RENK_LSFD, "(( %s, %s adl� �yenin r�tbesini %s yapt�. ))", ReturnRoleplayName(playerid), ReturnRoleplayName(id), fRanks[fid][rank - 1]);
        else SendFormattedMessage(x, COLOR_LIGHTBLUE, "(( %s, %s adl� �yenin r�tbesini %s yapt�. ))", ReturnRoleplayName(playerid), ReturnRoleplayName(id), fRanks[fid][rank - 1]);
    }

    PlayerInfo[id][pRank] = rank;

    LogYaz(playerid, "/frutbe", id, rank);

    return 1;
}
CMD:forutbe(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1 || PlayerInfo[playerid][pRank] > 2)
        return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    new name[MAX_PLAYER_NAME], rank, fid = PlayerInfo[playerid][pFaction];

    if(sscanf(params, "s[24]d", name, rank))return
        KullanimMesajiC(playerid, "/frutbe [id/isim] [r�tbe]");

    if(rank < 1 || rank > MAX_FACTION_RANKS)return
        HataMesaji(playerid, "Ge�ersiz r�tbe. (1 - %d)", MAX_FACTION_RANKS);

    if(strlen(name) < 3)
        return HataMesaji(playerid, "Bu isimde karakter bulunamad�.");

    mysql_format(ourConnection, queryx, sizeof(queryx), "SELECT * FROM characters WHERE char_name = '%e' AND banned = '0'", name);
    mysql_tquery(ourConnection, queryx, "FactionRutbeGuncelle", "ddds", playerid, rank, fid, name);
    return 1;
}
FactionRutbeGuncelle(playerid, rank, fid, name[MAX_PLAYER_NAME]); public FactionRutbeGuncelle(playerid, rank, fid, name[MAX_PLAYER_NAME])
{
    static rows, fields;
    cache_get_row_count(rows);
    cache_get_field_count(fields);

    if(!rows)
        return HataMesajiC(playerid, "Bu isimde karakter bulunamad�.");
        
    if(rows)
    {
        new factionid, tmpid; //, factionrankid;
        cache_get_value_int(0, "id", tmpid);
        cache_get_value_int(0, "faction_id", factionid);
        //cache_get_value_int(0, "faction_rank_id", factionrankid);
        
        if(factionid != fid)
            return SunucuMesajiC(playerid, "Bu ki�i sizin olu�umunuzda de�il.");

        mysql_format(ourConnection, queryx, sizeof(queryx), "UPDATE characters SET faction_rank_id = '%d' WHERE id = '%d'", rank, tmpid);
        mysql_tquery(ourConnection, queryx);        
        
        foreach(new x : Player) if(IsPlayerConnected(x) && PlayerInfo[x][pFaction] == PlayerInfo[playerid][pFaction] && PlayerInfo[x][pFactionOOC])
        {
            if(PlayerInfo[playerid][pFaction] == 0) SendFormattedMessage(x, RENK_LSPD, "(( %s, %s adl� �yenin r�tbesini %s yapt�. ))", ReturnRoleplayName(playerid), name, fRanks[fid][rank - 1]);
            else if(PlayerInfo[playerid][pFaction] == 1) SendFormattedMessage(x, RENK_LSFD, "(( %s, %s adl� �yenin r�tbesini %s yapt�. ))", ReturnRoleplayName(playerid), name, fRanks[fid][rank - 1]);
            else SendFormattedMessage(x, COLOR_LIGHTBLUE, "(( %s, %s adl� �yenin r�tbesini %s yapt�. ))", ReturnRoleplayName(playerid), name, fRanks[fid][rank - 1]);
        }
    }
    return 1;
}

CMD:birlikaktif(playerid, params[])return pc_cmd_fuyeler(playerid, params);
CMD:fuyeler(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1)
        return HataMesajiC(playerid, "Bu komutu kullanmak i�in bir olu�umda olmal�s�n.");

    new fid = PlayerInfo[playerid][pFaction];

    mysql_format(ourConnection, queryx, sizeof(queryx), "SELECT * FROM characters WHERE faction_id = '%d' AND banned = 0 AND deleted = 0 AND deleted_at IS NULL", PlayerInfo[playerid][pFaction]);
    mysql_tquery(ourConnection, queryx, "OnFListSearch", "dd", playerid, fid);

    return 1;
}

CMD:fisbasindakiler(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1)
        return HataMesajiC(playerid, "Bu komutu kullanmak i�in bir olu�umda olmal�s�n.");

    static const statusMsg[2][10] = {"Hay�r", "Evet"};

    foreach(new j : Player) if(IsPlayerConnected(j) && PlayerInfo[j][pLogged] && PlayerInfo[j][pFaction] == PlayerInfo[playerid][pFaction])
        SendFormattedMessage(playerid, (PlayerInfo[j][pFactionDuty]) ? COLOR_GREEN : COLOR_GREY, "%s (ID: %d) - ��ba��: %s", ReturnRoleplayName(j), j, statusMsg[PlayerInfo[j][pFactionDuty]]);
    return 1;
}

CMD:isbasi(playerid, params[])
{
    if(PlayerInfo[playerid][pJobDuty])return
        SunucuMesaji(playerid, "Zaten i�ba��ndas�n.");

    if(PlayerInfo[playerid][pFaction] == -1 || Faction_GetType(PlayerInfo[playerid][pFaction]) > LSNN)return 1;
    new yapabilir = 0;
    new fid = PlayerInfo[playerid][pFaction];
    new bid = GetPlayerBuilding(playerid, true);
    new Float:pX, Float:pY, Float:pZ;
    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE) {
        for(new i; i < Iter_Count(Vehicles); i++) {
            GetVehiclePos(i, pX, pY, pZ);
            if(IsPlayerInRangeOfPoint(playerid, 5.0, pX, pY, pZ)) {
                if(Faction_GetType(VehicleInfo[i][vFaction]) == POLICE) {
                    yapabilir = 1;
                    break;
                }
            }
        }
    }
    else if(Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL) {
        for(new i; i < Iter_Count(Vehicles); i++) {
            GetVehiclePos(i, pX, pY, pZ);
            if(IsPlayerInRangeOfPoint(playerid, 5.0, pX, pY, pZ)) {
                if(Faction_GetType(VehicleInfo[i][vFaction]) == MEDICAL) {
                    yapabilir = 1;
                    break;
                }
            }
        }
    }
    else if(Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT)
        yapabilir = 1;

    if((bid != -1 && BuildingInfo[bid][bFaction] == PlayerInfo[playerid][pFaction]) || yapabilir == 1 )
    {
        if(!PlayerInfo[playerid][pFactionDuty])
        {
            PlayerInfo[playerid][pFactionDuty] = 1;

            PlayerInfo[playerid][pToggleArmour] = 0;

            if(fid != 1) SendFactionMessage(fid, "** HQ: %s %s �u anda i�ba��nda.", fRanks[fid][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid));
            else SendFactionMessageTR(fid, "** HQ: %s %s �u anda i�ba��nda.", fRanks[fid][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid));
        }
        else {
            if(fid != 1) SendFactionMessage(fid, "** HQ: %s %s art�k i�ba��nda de�il.", fRanks[fid][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid));
            else SendFactionMessageTR(fid, "** HQ: %s %s art�k i�ba��nda de�il.", fRanks[fid][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid));
            Faction_OffDuty(playerid);
        }
    }
    else return HataMesajiC(playerid, "Olu�um alan�nda de�ilsin.");

    return 1;
}

flags:elm(CMD_PDFDGOV);
CMD:elm(playerid) {
    if(IsPlayerInAnyVehicle(playerid)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(Faction_GetType(VehicleInfo[vehicleid][vFaction]) == POLICE || Faction_GetType(VehicleInfo[vehicleid][vFaction]) == MEDICAL || Faction_GetType(VehicleInfo[vehicleid][vFaction]) == GOVERNMENT) {
            if(VehicleInfo[vehicleid][vELM] == false) {
                VehicleInfo[vehicleid][vELM] = true;
                new engine, lights, alarm, doors, bonnet, boot, objective;
                GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                SetVehicleParamsEx(vehicleid, engine, 1, alarm, doors, bonnet, boot, objective);
                ELMOncesiIsik[vehicleid] = lights;
                new panels, doorsh, lightsh, tires;
                GetVehicleDamageStatus(vehicleid, panels, doorsh, lightsh, tires);
                ELMOncesiIsikHasar[vehicleid] = lightsh;
                Flash[vehicleid] = 0;
                ELMTimer[vehicleid] = SetTimerEx("ELMZaman", 150, true, "d", vehicleid);
                BasariMesaji(playerid, "ELM sistemi {00ff00}aktif{C8C8C8}.");
            } else {
                VehicleInfo[vehicleid][vELM] = false;
                KillTimer(ELMTimer[vehicleid]);
                Flash[vehicleid] = 0;
                BasariMesaji(playerid, "ELM sistemi {ff0000}deaktif{C8C8C8}.");
                new engine, lights, alarm, doors, bonnet, boot, objective;
                GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                SetVehicleParamsEx(vehicleid, engine, ELMOncesiIsik[vehicleid], alarm, doors, bonnet, boot, objective);
                new panels, doorsh, lightsh, tires;
                GetVehicleDamageStatus(vehicleid, panels, doorsh, lightsh, tires);
                UpdateVehicleDamageStatus(vehicleid, panels, doors, ELMOncesiIsikHasar[vehicleid], tires);
            }
        } else return HataMesajiC(playerid, "Bu komutu kullanmak i�in bir faction arac�nda olmal�s�n.");
    } else return HataMesajiC(playerid, "Bu komutu kullanmak i�in bir faction arac�nda olmal�s�n.");
    return 1;
}


CMD:amkrufio(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:vX, Float:vY, Float:vZ;
    GetVehiclePos(vehicleid, vX, vY, vZ);
    SetVehicleZAngle(vehicleid, 0.0);
    new tmpobj = CreateDynamicObject(2912, vX, vY, vZ, 0.0, 0.0, 0.0);
    EditDynamicObject(playerid, tmpobj);
    SetPVarInt(playerid, "SilBeniRufio", 1);
    return 1;
}

flags:siren(CMD_PDFDGOV);
CMD:siren(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(!IsPlayerInAnyVehicle(playerid))
        return HataMesajiC(playerid, "Herhangi bir ara�ta de�ilsin.");

    if(Faction_GetType(VehicleInfo[vehicleid][vFaction]) != MEDICAL && Faction_GetType(VehicleInfo[vehicleid][vFaction]) != POLICE  && Faction_GetType(VehicleInfo[vehicleid][vFaction]) != GOVERNMENT)
        return HataMesajiC(playerid, "Bu ara�ta bu komutu kullanamazs�n�z.");

    new id;

    if(sscanf(params, "d", id)) return
        KullanimMesajiC(playerid, "/siren [0(kapat�r)/1/2/3(kendiniz ayarlamak i�in)]");

    if(id < 0 || id > 3) return
        KullanimMesajiC(playerid, "/siren [0(kapat�r)/1/2/3(kendiniz ayarlamak i�in)]");

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

// Los Santos Polis Departman�

flags:lisansuyari(CMD_LSPD);
CMD:lisansuyari(playerid, params[])
{
    new id;

    if(sscanf(params, "k<m>", id))return
        KullanimMesajiC(playerid, "/lisansuyari [id/isim]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(!PlayerInfo[id][pLicenses][0])return
        HataMesajiC(playerid, "Bu kullan�c�n�n ehliyeti yok.");

    PlayerInfo[id][pLicenseWarn]++;

    if(PlayerInfo[id][pLicenseWarn] >= 3)
    {
        PlayerInfo[id][pLicenses][0] = 0;
        PlayerInfo[id][pLicenseWarn] = 0;
        BasariMesaji(id, "%s lisans�n�za ���nc� uyar�y� ekleyip el koydu.",  ReturnRoleplayName(playerid));
        PlayerMEPlayer(playerid, id, "ki�isine uyar� ekleyip lisans�na el koyar");
    }
    else
    {
        BasariMesaji(id, "%s lisans�n�za uyar� ekledi.", ReturnRoleplayName(playerid));
        PlayerMEPlayer(playerid, id, "ki�isinin lisans�na uyar� ekler");
    }
    SaveCharacter(id);

    return 1;
}

flags:lisanselkoy(CMD_LSPD);
CMD:lisanselkoy(playerid, params[])
{
    new id, days;

    if(sscanf(params, "k<m>d", id, days))return
        KullanimMesajiC(playerid, "/lisanelkoy [id/isim] [g�n] (S�r�c� lisans� s�reli el koyma, bilin�siz kullan�m� yasak!)");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Ge�ersiz ID.");
        
    if(!days || days < 0)
        return HataMesajiC(playerid, "S�r�c� lisans� ceza s�resini g�n format�nda girin.");

    if(PlayerInfo[id][pLicenses][0])
    {
        PlayerInfo[id][pLicenses][0] = 0;
        PlayerInfo[id][pLicenseWarn] = 0;
        PlayerInfo[id][pLisansCeza] = (!days) ? gettime() : gettime() + (60 * 60 * 24 * days);
        BasariMesaji(id, "%s lisans�n�za s�reli olarak el koydu. (%d g�n)",  ReturnRoleplayName(playerid), days);
        PlayerMEPlayer(playerid, id, "ki�isinin lisans�na el koyar");
    }
    else
    {
        PlayerInfo[id][pLisansCeza] = (!days) ? gettime() : gettime() + (60 * 60 * 24 * days);
        BasariMesaji(id, "%s lisans�n�za s�reli olarak el koydu. (%d g�n)",  ReturnRoleplayName(playerid), days);
        PlayerMEPlayer(playerid, id, "ki�isinin lisans�na el koyar");
    }
    SaveCharacter(id);

    return 1;
}

flags:civikoy(CMD_LSPD);
CMD:civikoy(playerid) {
    if(SunucuBilgi[AntiDinamikObje])
        return HataMesaji(playerid, "Bu sistem ge�ici olarak geli�tirici ekip taraf�ndan pasife �ekildi.");
        
    if(GetPlayerInterior(playerid) > 0 && GetPlayerVirtualWorld(playerid) > 0)
        return HataMesajiC(playerid, "Bu komutu sadece d�� d�nyada kullanabilirsiniz.");

    if(Iter_Count(RoadBlocks) < MAX_ROADBLOCKS) {
        new i = Iter_Free(RoadBlocks),
            location[MAX_ZONE_NAME],
            Float:pX,
            Float:pY,
            Float:pZ,
            Float:pAngle;

        GetPlayerPos(playerid, pX, pY, pZ);
        GetPlayerFacingAngle(playerid, pAngle);

        RoadBlockInfo[i][rbModelID] = 2899;
        RoadBlockInfo[i][rbExists] = 1;
        RoadBlockInfo[i][rbType] = 2;

        GetXYInFrontOfPlayer(playerid, pX, pY, 2.5);
        RoadBlockInfo[i][rbPosX] = pX;
        RoadBlockInfo[i][rbPosY] = pY;
        RoadBlockInfo[i][rbPosZ] = pZ-0.85;

        RoadBlockInfo[i][rbObject] = CreateDynamicObject(RoadBlockInfo[i][rbModelID], RoadBlockInfo[i][rbPosX], RoadBlockInfo[i][rbPosY], RoadBlockInfo[i][rbPosZ], 0.0, 0.0, pAngle, 0, 0);
        format(RoadBlockInfo[i][rOwner], MAX_PLAYER_NAME, ReturnRoleplayName(playerid));
        RoadBlockInfo[i][rbFaction] = PlayerInfo[playerid][pFaction];

        GetCoords2DZone(pX, pY, location, MAX_ZONE_NAME);
        PlayerME(playerid, "bir barikat yerle�tirir.");
        Streamer_Update(playerid);
        if(PlayerInfo[playerid][pFaction] != 1) SendFactionMessage(PlayerInfo[playerid][pFaction], "** HQ: %s, %s alan�na bir �ivi yerle�tirdi.", ReturnRoleplayName(playerid), location);
        else SendFactionMessageTR(PlayerInfo[playerid][pFaction], "** HQ: %s, %s alan�na bir �ivi yerle�tirdi.", ReturnRoleplayName(playerid), location);
        Iter_Add(RoadBlocks, i);
    } else return HataMesajiC(playerid, "Sunucu barikat limitine ula��lm��.");
    return 1;
}

flags:civisil(CMD_LSPD);
CMD:civisil(playerid) {
    new id = YakindakiBarikatiBul(playerid);
    if(id == -1) return HataMesajiC(playerid, "Yak�n�n�zda �ivi bulunmamaktad�r.");
    if(RoadBlockInfo[id][rbType] != 2) return HataMesajiC(playerid, "Yak�n�n�zda �ivi bulunmamaktad�r.");
    new location[MAX_ZONE_NAME];
    RoadBlockInfo[id][rbExists] = 0;
    RoadBlockInfo[id][rbType] = 0;
    GetCoords2DZone(RoadBlockInfo[id][rbPosX], RoadBlockInfo[id][rbPosY], location, MAX_ZONE_NAME);

    DestroyDynamicObjectEx(RoadBlockInfo[id][rbObject]);

    if(PlayerInfo[playerid][pFaction] != 1) SendFactionMessage(PlayerInfo[playerid][pFaction], "** HQ: %s, %s lokasyonundaki barikat� kald�rd�.", ReturnRoleplayName(playerid), location);
    else SendFactionMessageTR(PlayerInfo[playerid][pFaction], "** HQ: %s, %s lokasyonundaki barikat� kald�rd�.", ReturnRoleplayName(playerid), location);

    Iter_Remove(RoadBlocks, id);
    return 1;
}

CMD:konikoy(playerid) {
    if(SunucuBilgi[AntiDinamikObje])
        return HataMesaji(playerid, "Bu sistem ge�ici olarak geli�tirici ekip taraf�ndan pasife �ekildi.");
        
    if(GetPlayerInterior(playerid) > 0 && GetPlayerVirtualWorld(playerid) > 0)
        return HataMesajiC(playerid, "Bu komutu sadece d�� d�nyada kullanabilirsiniz.");

    if(Iter_Count(RoadBlocks) < MAX_ROADBLOCKS) {
        new i = Iter_Free(RoadBlocks),
            location[MAX_ZONE_NAME],
            Float:pX,
            Float:pY,
            Float:pZ,
            Float:pAngle;

        GetPlayerPos(playerid, pX, pY, pZ);
        GetPlayerFacingAngle(playerid, pAngle);

        RoadBlockInfo[i][rbModelID] = 1238;
        RoadBlockInfo[i][rbExists] = 1;
        RoadBlockInfo[i][rbType] = 1;

        RoadBlockInfo[i][rbPosX] = pX;
        RoadBlockInfo[i][rbPosY] = pY;
        RoadBlockInfo[i][rbPosZ] = pZ-0.65;

        RoadBlockInfo[i][rbObject] = CreateDynamicObject(RoadBlockInfo[i][rbModelID], RoadBlockInfo[i][rbPosX], RoadBlockInfo[i][rbPosY], RoadBlockInfo[i][rbPosZ], 0.0, 0.0, pAngle + 90.0, 0, 0);
        format(RoadBlockInfo[i][rOwner], MAX_PLAYER_NAME, ReturnRoleplayName(playerid));
        RoadBlockInfo[i][rbFaction] = PlayerInfo[playerid][pFaction];

        GetCoords2DZone(pX, pY, location, MAX_ZONE_NAME);

        PlayerME(playerid, "bir barikat yerle�tirir.");
        Streamer_Update(playerid);
        if(PlayerInfo[playerid][pFaction] != 1) SendFactionMessage(PlayerInfo[playerid][pFaction], "** HQ: %s, %s alan�na bir koni yerle�tirdi.", ReturnRoleplayName(playerid), location);
        else SendFactionMessageTR(PlayerInfo[playerid][pFaction], "** HQ: %s, %s alan�na bir koni yerle�tirdi.", ReturnRoleplayName(playerid), location);
        Iter_Add(RoadBlocks, i);
    } else return HataMesajiC(playerid, "Sunucu barikat limitine ula��lm��.");
    return 1;
}


// Government

flags:isyerivergi(CMD_GOV);
CMD:isyerivergi(playerid, params[]) {
    new id, vergic;
    if(sscanf(params, "dd", id, vergic)) return KullanimMesajiC(playerid, "/isyerivergi <i�yeri ID> <vergi miktar�>");
    if(!PlayerInfo[playerid][pDivision][0]) return HataMesajiC(playerid, "Bu komutu kullanmak i�in Licensing Department �yesi olmal�s�n�z.");
    if(!BuildingInfo[id][bExists]) return HataMesajiC(playerid, "��letme bulunamad�.");
    if(BuildingInfo[id][bPrice] < 500) return HataMesajiC(playerid, "Bu i�letmede bu komutu kullanamazs�n.");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, BuildingInfo[id][bPosX], BuildingInfo[id][bPosY], BuildingInfo[id][bPosZ])) return HataMesajiC(playerid, "Bu komutu kullanmak i�in i�letmenin giri�inin �n�nde olmal�s�n�z.");
    PlayerAME(playerid, "i�letmeye vergi yazar.");
    BuildingInfo[id][bVergi] += vergic;
    SunucuMesaji(playerid, "%d ID'li i�letmeye $%d vergi yazd�n.", id, vergic);
    return 1;
}

flags:isyericeza(CMD_GOV);
CMD:isyericeza(playerid, params[]) {
    new id, vergic;
    if(sscanf(params, "dd", id, vergic)) return KullanimMesajiC(playerid, "/isyericeza <i�yeri ID> <ceza miktar�>");
    if(!PlayerInfo[playerid][pDivision][0]) return HataMesajiC(playerid, "Bu komutu kullanmak i�in Licensing Department �yesi olmal�s�n�z.");
    if(!BuildingInfo[id][bExists]) return HataMesajiC(playerid, "��letme bulunamad�.");
    if(BuildingInfo[id][bPrice] < 500) return HataMesajiC(playerid, "Bu i�letmede bu komutu kullanamazs�n.");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, BuildingInfo[id][bPosX], BuildingInfo[id][bPosY], BuildingInfo[id][bPosZ])) return HataMesajiC(playerid, "Bu komutu kullanmak i�in i�letmenin giri�inin �n�nde olmal�s�n�z.");
    PlayerAME(playerid, "i�letmeye ceza yazar.");
    BuildingInfo[id][bCeza] += vergic;
    SunucuMesaji(playerid, "%d ID'li i�letmeye $%d ceza yazd�n.", id, vergic);
    return 1;
}

flags:muhurle(CMD_GOV);
CMD:muhurle(playerid, params[]) {
    new id;
    if(sscanf(params, "d", id)) return KullanimMesajiC(playerid, "/muhurle <i�yeri ID>");
    if(!BuildingInfo[id][bExists]) return HataMesajiC(playerid, "��letme bulunamad�.");
    if(!PlayerInfo[playerid][pDivision][0]) return HataMesajiC(playerid, "Bu komutu kullanmak i�in Licensing Department �yesi olmal�s�n�z.");
    if(BuildingInfo[id][bExists] == 0) return HataMesajiC(playerid, "��letme bulunamad�.");
    if(BuildingInfo[id][bPrice] < 500) return HataMesajiC(playerid, "Bu i�letmede bu komutu kullanamazs�n.");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, BuildingInfo[id][bPosX], BuildingInfo[id][bPosY], BuildingInfo[id][bPosZ])) return HataMesajiC(playerid, "Bu komutu kullanmak i�in i�letmenin giri�inin �n�nde olmal�s�n�z.");
    if(!BuildingInfo[id][bMuhurlu]) {
        Pickup_Destroy(BuildingInfo[id][bPickup]);
        BuildingInfo[id][bMuhurlu] = 1;
        PlayerAME(playerid, "i�letmeyi m�h�rler.");
        SunucuMesaji(playerid, "%d ID'li i�letmeyi m�h�rledin.", id);
        BuildingInfo[id][bPickup] = Pickup_Create(ELEMENT_BUILDING, id, 19522, 23, BuildingInfo[id][bPosX], BuildingInfo[id][bPosY], BuildingInfo[id][bPosZ], BuildingInfo[id][bPosWorld], BuildingInfo[id][bPosInterior]);
    }
    else {
        Pickup_Destroy(BuildingInfo[id][bPickup]);
        BuildingInfo[id][bMuhurlu] = 0;
        PlayerAME(playerid, "i�letmenin m�hr�n� a�ar.");
        SunucuMesaji(playerid, "%d ID'li i�letmenin m�hr�n� a�t�n.", id);
        BuildingInfo[id][bPickup] = Pickup_Create(ELEMENT_BUILDING, id, (BuildingInfo[id][bType] == COMPLEX) ? 1314 : 1239, 23, BuildingInfo[id][bPosX], BuildingInfo[id][bPosY], BuildingInfo[id][bPosZ], BuildingInfo[id][bPosWorld], BuildingInfo[id][bPosInterior]);
    }
    return 1;
}

flags:gbankakontrol(CMD_GOV);
CMD:gbankakontrol(playerid, params[])
{
    if(PlayerInfo[playerid][pRank] > 2)return
        SunucuMesaji(playerid, "Bunu kullanman i�in r�tben yetmiyor.");

    // new query[256];

    if(isnull(params) || strlen(params) > 24)return
        KullanimMesajiC(playerid, "/gbankakontrol [isim_soyisim]");

    mysql_format(ourConnection, queryx, sizeof(queryx), "SELECT char_name, cash_bank, savings FROM characters WHERE char_name = '%e' AND deleted = 0 AND banned = 0 AND deleted_at IS NULL", params);
    mysql_tquery(ourConnection, queryx, "OnSearchPlayerBankInfo", "d", playerid);

    return 1;
}

OnSearchPlayerBankInfo(playerid); public OnSearchPlayerBankInfo(playerid)
{
    static rows, fields;
    cache_get_row_count(rows);
    cache_get_field_count(fields);

    if(!rows)return
        SunucuMesaji(playerid, "Vatanda� bulunamad�.");

    new cash_bank, savings;
    cache_get_value_int(0, "cash_bank", cash_bank);
    cache_get_value_int(0, "savings", savings);
    new char_name[MAX_PLAYER_NAME]; cache_get_value(0, "char_name", char_name, MAX_PLAYER_NAME);

    SunucuMesaji(playerid, "%s adl� vatanda��n banka hesab�: $%d.", char_name, cash_bank);
    SunucuMesaji(playerid, "%s adl� vatanda��n mevduat hesab�: $%d.", char_name, savings);

    return 1;
}

flags:vergi(CMD_GOV);
CMD:vergi(playerid, params[])
{
    new id, amount, reason[64];

    if(sscanf(params, "k<m>ds[64]", id, amount, reason))return
        KullanimMesajiC(playerid, "/vergi [id/isim] [miktar] [sebep]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(!ProxDetectorS(5.0, playerid, id))return
        SunucuMesajiC(playerid, "Oyuncuya yak�n de�ilsin.");

    if(amount < 10)return
        SunucuMesaji(playerid, "Ge�ersiz de�er. ($10+)");

    mysql_format(ourConnection, queryx, sizeof(queryx), "INSERT INTO police_fine_records (created_at, officer, target, amount, reason) VALUES (NOW(), '%e', '%e', '%d', '%e')", ReturnRoleplayName(playerid), ReturnRoleplayName(id), amount, reason);
    mysql_tquery(ourConnection, queryx);

    mysql_format(ourConnection, queryx, sizeof(queryx), "INSERT INTO police_arrest_records (officer, created_at, target) VALUES ('%e', NOW(), '%e')", ReturnRoleplayName(playerid), ReturnRoleplayName(id));
    mysql_tquery(ourConnection, queryx, "OnFineInsert", "ds", playerid, reason);

    BasariMesaji(id, "%s sana %s sebebiyle vergi cezas� kesti.", ReturnRoleplayName(playerid), reason);
    BasariMesaji(id, "Vergi: $%d. (Vergiyi �demek i�in: /cezalarim)", amount);

    PlayerMEPlayer(playerid, id, "ki�isine ceza makbuzunu uzat�r");

    return 1;
}

CMD:telefontakip(playerid, params[])
{
    if(PlayerInfo[playerid][pRank] > 5 && !PlayerInfo[playerid][pDivision][0]) return
        SunucuMesajiC(playerid, "Bu komutu kullanmak i�in yetkiniz bulunmuyor.");

    new number, id = -1, phoneid, payphoneid;

    if(sscanf(params, "d", number))return
        KullanimMesajiC(playerid, "/telefontakip [numara]");

    foreach(new j : Player)
    {
        if(!IsPlayerConnected(j) || j == playerid)continue;

        phoneid = Inventory_HasPhone(j, number);
        payphoneid = PlayerInfo[j][pUsingPP];

        if(payphoneid == -1 && phoneid == -1)continue;
        if(phoneid != -1 && !PlayerInfo[j][pInvExtra][phoneid])continue;
        if(payphoneid != -1 && PayPhoneInfo[payphoneid][cNumber] != number)continue;

        id = j; break;
    }

    if(id == -1)return
        SunucuMesaji(playerid, "Bu numara �u anda bulunam�yor. Kullan�lm�yor ya da �u anda kapal�.");

    new location[MAX_ZONE_NAME], Float:X, Float:Y, Float:Z;

    GetDynamicPlayerPos(id, X, Y, Z);
    GetCoords2DZone(X, Y, location, MAX_ZONE_NAME);
    GangZoneDestroy(PlayerInfo[playerid][pGangZone]);

    if(PlayerInfo[id][pMobile] == -1)
    {
        PlayerInfo[playerid][pGangZone] = GangZoneCreate(X - 50.0, Y - 50.0, X + 50.0, Y + 50.0);

        GangZoneShowForPlayer(playerid, PlayerInfo[playerid][pGangZone], COLOR_YELLOW);
        GangZoneFlashForPlayer(playerid, PlayerInfo[playerid][pGangZone], COLOR_YELLOW);

        BasariMesaji(playerid, "Kullan�c�n�n son g�r�ld��� yer %s, konumu haritan�zda i�aretlendi.", location);
        SendClientMessageEx(playerid, COLOR_YELLOW, "Checkpoint 15 saniye sonra kaybolacakt�r.");
    }
    else
    {
        AC_SetPlayerCheckpoint(playerid, X, Y, Z, 5.0);

        BasariMesaji(playerid, "Kullan�c�n�n son g�r�ld��� yer %s, konumu haritan�zda i�aretlendi.", location);
        SendClientMessageEx(playerid, COLOR_YELLOW, "Checkpoint 15 saniye sonra kaybolacakt�r.");
    }

    PlayerInfo[playerid][pTracing] = true;
    SetTimerEx("StopTrace", 15000, false, "d", playerid);

    return 1;
}
CMD:canliyayin(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1 || Faction_GetType(PlayerInfo[playerid][pFaction]) != LSNN)return
        SunucuMesaji(playerid, "Bu olu�umu kullanmak i�in televizyon kanal�nda �al��mal�s�n.");

    if(!PlayerInfo[playerid][pFactionDuty])return
        SunucuMesajiC(playerid, "��ba��nda de�ilsin.");

    new id;

    if(PlayerInfo[playerid][pTalkingLive] == -1)
    {
        if(sscanf(params, "k<m>", id))return
            KullanimMesajiC(playerid, "/canliyayin [id/isim]");

        if(!IsPlayerConnected(id) || id == playerid)return
            HataMesajiC(playerid, "Kendi kendini canl� yay�na alamazs�n.");

        if(!ProxDetectorS(5.0, playerid, id))return
            SunucuMesaji(playerid, "Bu oyuncuya yak�n de�ilsin.");

        PlayerInfo[id][pRequestLive] = playerid;

        SendFormattedMessage(id, COLOR_LIGHTGREEN, "%s sana canl� yay�n iste�i g�nderdi. /kabulet canli komutuyla kabul edebilirsin.", ReturnRoleplayName(playerid));
        SendFormattedMessage(playerid, COLOR_LIGHTGREEN, "%s ki�isine canl� yay�n iste�i g�nderildi.", ReturnRoleplayName(id));
    }
    else
    {
        id = PlayerInfo[playerid][pTalkingLive];

        SendFormattedMessage(id, COLOR_LIGHTGREEN, "%s ki�isiyle yapt���n�z canl� yay�n sona erdi.", ReturnRoleplayName(playerid));
        SendFormattedMessage(playerid, COLOR_LIGHTGREEN, "%s ki�isiyle yapt���n�z canl� yay�n sona erdi.", ReturnRoleplayName(id));

        PlayerInfo[id][pTalkingLive] = -1;
        PlayerInfo[playerid][pTalkingLive] = -1;
    }

    return 1;
}

Storage_ShowItemsPD(playerid, houseid)
{
    new string[700];
    for(new x; x < MAX_STORAGE_ITEMS; x++)
        format(string,sizeof(string), "%sSlot %d: %s\n", string, x + 1, Inventory_ReturnString(houseid, ENTITY_TYPE_HOUSE, x));

    if(PlayerInfo[playerid][pFaction] != -1 && Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE && PlayerInfo[playerid][pFactionDuty])
    {
        PlayerInfo[playerid][pRevokeItem] = houseid;
        Dialog_Show(playerid, DialogRevokeStorage, DIALOG_STYLE_LIST, "Envanter", string, "�leri", "�ptal");
    }
    else Dialog_Show(playerid, DialogHouseStorage, DIALOG_STYLE_LIST, "Envanter", string, "�leri", "�ptal");

    return 1;
}

flags:evara(CMD_LSPD);
CMD:evara(playerid, params[])
{
    new hid = GetPlayerHouse(playerid, true);

    if(hid == -1)return
        SunucuMesaji(playerid, "Evin yak�n�nda veya i�erisinde de�ilsin.");

    Storage_ShowItemsPD(playerid, hid);

    return 1;
}


flags:operator(CMD_PDFD);
CMD:operator(playerid, params[])
{
    if(PlayerInfo[playerid][pRank] > 11) return HataMesaji(playerid, "Bu komutu kullanmak i�in yetkiniz yok.");
    if(isnull(params))
    {
        return KullanimMesaji(playerid, "/operator [yaz�]");
    }
    if(PlayerInfo[playerid][pFaction] != 1) SendFactionRadioMessage(PlayerInfo[playerid][pFaction], "[OPERATOR] %s", params); // PD
    else SendFactionMessageTR(PlayerInfo[playerid][pFaction], "[O((%s))] %s", ReturnRoleplayName(playerid), params); //FD
    printf("[OPERATOR] %s: %s", ReturnRoleplayName(playerid), params);
    return 1;
}

flags:yt(CMD_PDFDGOV);
flags:r2(CMD_PDFDGOV);
CMD:r2(playerid, params[]) return pc_cmd_yt(playerid, params);
CMD:yt(playerid, params[])
{
    if(!PlayerInfo[playerid][pRadyo]) return HataMesaji(playerid, "/r komutunu kapatt���n�z i�in bu komutu kullanamazs�n�z. (/kapat radyo)");
    if(isnull(params))
    {
        return KullanimMesaji(playerid, "/yt [yaz�]");
    }

    new string[256];

    format(string, sizeof(string), "%s (yak�n telsiz): %s", ReturnRoleplayName(playerid, true), params);
    ProxDetector(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, .exceptPlayer = true);

    new Float:ppos[3];
    GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
    foreach(Player, i)
    {
        if(IsPlayerInRangeOfPoint(i, 100.0, ppos[0], ppos[1], ppos[2]) && PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && PlayerInfo[i][pRadyo]) //&& !PlayerInfo[i][pToggleRadio])
        {
            SendFormattedMessage(i, COLOR_RADIO, "** [CH: 911, S: 3] %s: %s", ReturnRoleplayName(playerid), params);
        }
    }
    printf("[YT] %s: %s", ReturnRoleplayName(playerid), params);
    return 1;
}

flags:dyt(CMD_PDFDGOV);
CMD:dyt(playerid, params[])
{
    if(isnull(params))
    {
        return KullanimMesaji(playerid, "/dyt [yaz�]");
    }

    new string[256];

    format(string, sizeof(string), "%s (yak�n telsiz): %s", ReturnRoleplayName(playerid, true), params);
    ProxDetector(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, .exceptPlayer = true);

    new Float:ppos[3];
    GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
    foreach(Player, i)
    {
        if(IsPlayerInRangeOfPoint(i, 100.0, ppos[0], ppos[1], ppos[2]))
        {
            if(Faction_GetType(PlayerInfo[i][pFaction]) == POLICE && PlayerInfo[i][pFactionDuty] || PlayerInfo[i][pFactionDuty] && Faction_GetType(PlayerInfo[i][pFaction]) == MEDICAL || PlayerInfo[i][pFactionDuty] && Faction_GetType(PlayerInfo[i][pFaction]) == GOVERNMENT && PlayerInfo[i][pRadyo])
                SendFormattedMessage(i, COLOR_RADIO, "** [CH: 911, S: 4] %s: %s", ReturnRoleplayName(playerid), params);
        }
    }
    printf("[DYT] %s: %s", ReturnRoleplayName(playerid), params);
    return 1;
}
flags:r(CMD_PDFDGOV);
CMD:r(playerid, params[])
{
    if(!PlayerInfo[playerid][pRadyo]) return HataMesaji(playerid, "/r komutunu kapatt���n�z i�in bu komutu kullanamazs�n�z. (/kapat radyo)");

    new message[256];

    if(sscanf(params, "s[256]", message) || strlen(message) > 256) return
        KullanimMesaji(playerid, "/r [yaz�]");

    new string[256];

    format(string, sizeof(string), "%s(telsiz): %s", ReturnRoleplayName(playerid, true), message);
    ProxDetector(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, .exceptPlayer = true);
    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE) {
        foreach(Player, i)
        {
            if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && PlayerInfo[i][pRadyo]) //&& !PlayerInfo[i][pToggleRadio])
            {
                SendFormattedMessage(i, COLOR_RADIO, "** [CH: 911, S: 1] %s: %s", ReturnRoleplayName(playerid, true), params);
            }
        }
    } else {
        foreach(Player, i)
        {
            if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]  && PlayerInfo[i][pRadyo]) //&& !PlayerInfo[i][pToggleRadio])
            {
                SendFormattedMessage(i, COLOR_RADIO, "** [CH: 911, S: 1] %s: %s", ReturnRoleplayName(playerid, true), params);
            }
        }
    }
    printf("[R] %s: %s", ReturnRoleplayName(playerid), params);
    return 1;
}

flags:hr(CMD_LSNN);
CMD:hr(playerid, params[])
{
//  if(PlayerInfo[playerid][pTVActor] != -1)
    //  return HataMesaji(playerid, "Bu i�lemi yapamazs�n�z.");

    new message[256];
    new fid = PlayerInfo[playerid][pFaction];

    if(sscanf(params, "s[256]", message) || strlen(message) > 256) return
        KullanimMesaji(playerid, "/hr [yaz�]");

    new string[256];

    format(string, sizeof(string), "%s (telsiz): %s", ReturnRoleplayName(playerid, true), message);
    ProxDetector(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, .exceptPlayer = true);

    foreach(Player, i)
    {
        if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) //&& !PlayerInfo[i][pToggleRadio])
        {
            SendFormattedMessage(i, COLOR_GREEN, "* %s %s: %s", fRanks[fid][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid, true), params);
        }
    }
    printf("[R] %s: %s", ReturnRoleplayName(playerid), params);
    return 1;
}
flags:rlow(CMD_PDFDGOV);
CMD:rlow(playerid, params[])
{
    if(!PlayerInfo[playerid][pRadyo]) return HataMesaji(playerid, "/r komutunu kapatt���n�z i�in bu komutu kullanamazs�n�z. (/kapat radyo)");
//  if(PlayerInfo[playerid][pTVActor] != -1)
    //  return HataMesaji(playerid, "Bu i�lemi yapamazs�n�z.");

    new message[256];

    if(sscanf(params, "s[256]", message) || strlen(message) > 256) return
        KullanimMesaji(playerid, "/rlow [yaz�]");

    new string[256];

    format(string, sizeof(string), "%s(telsiz): %s", ReturnRoleplayName(playerid, true), message);
    ProxDetector(5.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, .exceptPlayer = true);

    foreach(Player, i)
    {
        if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]  && PlayerInfo[i][pRadyo]) //&& !PlayerInfo[i][pToggleRadio])
        {
            SendFormattedMessage(i, COLOR_RADIO, "** [CH: 911, S: 1] %s: %s", ReturnRoleplayName(playerid), params);
        }
    }
    printf("[RLOW] %s: %s", ReturnRoleplayName(playerid), params);
    return 1;
}

flags:hq(CMD_PDFD);
CMD:hq(playerid, params[])
{
    if(PlayerInfo[playerid][pRank] > 3 && PlayerInfo[playerid][pFaction] == 0 || PlayerInfo[playerid][pRank] > 6 && PlayerInfo[playerid][pFaction] == 1) return HataMesaji(playerid, "Bu komutu kullanmak i�in yetkiniz yok.");
    if(isnull(params))
    {
        return KullanimMesaji(playerid, "/hq [yaz�]");
    }
    if(PlayerInfo[playerid][pFaction] != 1) SendFactionMessage(PlayerInfo[playerid][pFaction], "** HQ: %s", params);
    else SendFactionMessageTR(PlayerInfo[playerid][pFaction], "** HQ: %s", params);
    printf("[HQ] %s: %s", ReturnRoleplayName(playerid), params);
    return 1;
}

flags:tackle(CMD_PDGOV);
CMD:tackle(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))return HataMesaji(playerid, "Ara�ta bu komutu kullanamazs�n�z.");
    PlayerInfo[playerid][pTackleMode] = !PlayerInfo[playerid][pTackleMode];
    SendFormattedMessage(playerid, COLOR_WHITE, (PlayerInfo[playerid][pTackleMode]) ? ("Tackle modu {00ff00}AKT�FLE�T�R�LD�{ffffff}.") : ("Tackle modu {ff0000}KAPATILDI{ffffff}."));
    return 1;
}

flags:tazer(CMD_PDGOV);
flags:taser(CMD_PDGOV);
CMD:tazer(playerid,params[])return pc_cmd_taser(playerid, params);
CMD:taser(playerid, params[])
{
    if(GetTickCount() - PlayerInfo[playerid][pPoliceTick] < 1500)return 1;

    PlayerInfo[playerid][pPoliceTick] = GetTickCount();

    if(!PlayerInfo[playerid][pTaser])
    {
        PlayerInfo[playerid][pTaser] = 1;

        PlayerAME(playerid, "taser silah�n� te�hizat kemerindeki k�l�f�ndan ��kart�r.");

        GetPlayerWeaponData(playerid, 2, PlayerInfo[playerid][pWeapons][2], PlayerInfo[playerid][pAmmo][2]);
        AC_RemovePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][2]);
        AC_GivePlayerWeapon(playerid, 23, 3);
    }
    else
    {
        PlayerInfo[playerid][pTaser] = 0;

        PlayerAME(playerid, "taser silah�n� te�hizat kemerindeki k�l�f�na geri yerle�tirir.");

        AC_RemovePlayerWeapon(playerid, 23);
        AC_GivePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][2], PlayerInfo[playerid][pAmmo][2]);
        PlayerInfo[playerid][pWeapons][2] = 0;
        PlayerInfo[playerid][pAmmo][2] = 0;

        SetPlayerArmedWeapon(playerid, PlayerInfo[playerid][pWeapons][2]);
    }

    return 1;
}

flags:govfinans(CMD_GOV);
CMD:govfinans(playerid, params[])
{
    if(PlayerInfo[playerid][pRank] > 1)
        return 1;

    new buildingid = GetPlayerBuilding(playerid, true);

    if(buildingid != -1 && BuildingInfo[buildingid][bType] == BANK)
    {
        new fname[32];
        new amount;
        new fid = PlayerInfo[playerid][pFaction];

        if(sscanf(params, "ds[32]", amount, fname))return
            KullanimMesaji(playerid, "/govfinans [miktar] [olu�um ad�]");

        if(FactionInfo[fid][fCash] < amount)return
            SunucuMesaji(playerid, "Bu paraya sahip de�ilsin.");

        foreach(new j : Factions)
        {
            if(strcmp(FactionInfo[j][fName], fname, false) || !FactionInfo[j][fExists])continue;

            if(Faction_GetType(j) == SADECEUYUSTURUCU || Faction_GetType(j) == ONAYLIFACT)return
                SunucuMesaji(playerid, "Bu olu�uma para yat�ramazs�n.");

            FactionInfo[j][fCash] += amount;
            FactionInfo[fid][fCash] -= amount;

            SunucuMesaji(playerid, "%s olu�umunun kasas�na $%d yat�rd�n.", FactionInfo[j][fName], amount);

            SaveFaction(j);
            SaveFaction(fid);

            LogYaz(playerid, "/govfinans", -1, j, amount);

            return 1;
        }

        HataMesaji(playerid, "Bu isimde olu�um yok.");
    }
    else return
        HataMesaji(playerid, "Bankada de�ilsin.");

    return 1;
}

CMD:factionyardim(playerid, params[])
{
    new type = Faction_GetType(PlayerInfo[playerid][pFaction]);

    if(PlayerInfo[playerid][pFaction] == -1)return
        SunucuMesaji(playerid, "Bir olu�umda de�ilsin.");

    KullanimMesajiC(playerid, "/lideryardim (Rank 1-2-3) - /f - /olusumdancik - /fisbasindakiler - /fuyeler liste");

    switch(type)
    {
        case POLICE:
        {
            KullanimMesajiC(playerid, "/isbasi - /taser - /beanbag - /d(epartman) - /yt - /m(egafon) - /mdc");
            KullanimMesaji(playerid, "/tutukla - /cs - /cezakes - /acezakes - /aracara - /senaryoekle - /cesettorbasi - /civi");
            KullanimMesaji(playerid, "/kelepce - /kelepceal - /kelepcever - /siren - /ustundenal - /barikat - /evara - /tackle");
            KullanimMesaji(playerid, "/gisedurum (PO2+) - /kapiyikir (PO3+) | [TFC] /araccek - /hizkamerasi - /ustara");
            KullanimMesajiC(playerid, "[SWAT] /snakecam | [FLD] /ccwlisansi - /ocwlisansi - /guvenliksertifikasi");
            KullanimMesaji(playerid, "[DET] /bocekyerlestir - /bocekkaldir - /mulkbul - /telefontakip - /bocek - /telefondinle");
        }
        case MEDICAL:
        {
            KullanimMesajiC(playerid, "/isbasi - /olusumdancik - /m - /d - /tedaviet - /barikat - /cs - /kapiyikir");
            KullanimMesajiC(playerid, "/siren - /fkapikilit - /cesettorbasi");
        }
        case LSNN: KullanimMesajiC(playerid, "/isbasi - /basinkarti - /haber - /canliyayin - /cs - /senaryoekle - /senaryokaldir");
        case GOVERNMENT: KullanimMesajiC(playerid, "/isbasi - /olusumdancik  - /gov - /govfinans - /cs - /gbankakontrol");
    }

    return 1;
}

flags:fkanalkapat(CMD_USER);
CMD:fkanalkapat(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1 || PlayerInfo[playerid][pRank] > 3)
        return 1;

    new fid = PlayerInfo[playerid][pFaction];

    FactionInfo[fid][fOOC] = !FactionInfo[fid][fOOC];

    foreach(new x : Player) if(IsPlayerConnected(x) && PlayerInfo[x][pFaction] == PlayerInfo[playerid][pFaction] && PlayerInfo[x][pFactionOOC])
        SendFormattedMessage(x, COLOR_LIGHTBLUE, (!FactionInfo[fid][fOOC]) ? ("OOC faction chati %s taraf�ndan devre d��� b�rak�ld�.") : ("OOC faction chati %s taraf�ndan aktif edildi."), ReturnRoleplayName(playerid));

    return 1;
}

CMD:f(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1)return
        SunucuMesaji(playerid, "Bir olu�umda de�ilsin.");

    new fid = PlayerInfo[playerid][pFaction];

    if(!FactionInfo[fid][fOOC] && PlayerInfo[playerid][pRank] > 3)return
        SunucuMesaji(playerid, "OOC olu�um kanal� lider taraf�dan devre d��� b�rak�ld�.");

    if(!PlayerInfo[playerid][pFactionOOC])return
        SunucuMesaji(playerid, "OOC kanal devre d��� b�rak�ld��� i�in kullanamazs�n.");

    if(isnull(params) || strlen(params) > 256)return
        SendClientMessageEx(playerid, COLOR_GREY, "(/f) [yaz�]");

    foreach(new x : Player) if(IsPlayerConnected(x) && PlayerInfo[x][pFaction] == PlayerInfo[playerid][pFaction] && PlayerInfo[x][pFactionOOC])
    {
        if(PlayerInfo[playerid][pFaction] == 0) SendFormattedMessage(x, RENK_LSPD, "(( %s %s: %s ))", fRanks[fid][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid), params);
        else if(PlayerInfo[playerid][pFaction] == 1) SendFormattedMessage(x, RENK_LSFD, "(( %s %s: %s ))", fRanks[fid][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid), params);
        else SendFormattedMessage(x, COLOR_LIGHTBLUE, "(( %s %s: %s ))", fRanks[fid][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid), params);
    }
    printf("(fchat) %s: %s", ReturnRoleplayName(playerid), params);
    return 1;
}

CMD:pdaksesuar(playerid, params[])
{
    new id = YakindakiDolabiBul(playerid);
    if(id != -1) {
        new count;
        new slotid;
        new p_slots[MAX_PLAYER_OBJECTS] = {-1, ...};
        new attach_object_slot;

        sscanf(params, "a<d>[20]", p_slots);

        for(new i; i < MAX_PLAYER_OBJECTS; i++)
        {
            if(p_slots[i] == -1)continue;

            slotid = p_slots[i]; if(slotid < 0 || slotid >= MAX_PLAYER_OBJECTS)continue;

            if(PlayerInfo[playerid][pObjectWearing][slotid] != -1)
            {
                attach_object_slot = PlayerInfo[playerid][pObjectWearing][slotid];

                SunucuMesaji(playerid, "Belirtilen aksesuar kald�r�ld�.");
                RemovePlayerAttachedObject(playerid, attach_object_slot);
                PlayerInfo[playerid][pObjectSlotOccupied][attach_object_slot] = 0;
                PlayerInfo[playerid][pObjectWearing][slotid] = -1;
                PlayerInfo[playerid][pObjectWearingVar][slotid] = -1;
            }
            else PlayerObjects_CheckWear(playerid, slotid);

            count++;
        }

        if(!count)
        {
            new string[512];

            for(new i; i < MAX_PLAYER_OBJECTS; i++) format(string, sizeof(string), "%s%s\t%d\n", string, PlayerObjects_GetName(playerid, i), i);

            Dialog_Show(playerid, DialogPDAksesuarIndex, DIALOG_STYLE_TABLIST_HEADERS, "Aksesuar", "Aksesuar\tSlot\n%s", "Se�", "�ptal", string);
        }
    } else return HataMesaji(playerid, "Ekipman dolab�na yak�n de�ilsin.");
    return 1;
}

flags:govaksesuar(CMD_GOV);
CMD:govaksesuar(playerid, params[]) {
    new id = YakindakiDolabiBul(playerid);
    if(id != -1) {
        new count;
        new slotid;
        new p_slots[MAX_PLAYER_OBJECTS] = {-1, ...};
        new attach_object_slot;

        sscanf(params, "a<d>[20]", p_slots);

        for(new i; i < MAX_PLAYER_OBJECTS; i++)
        {
            if(p_slots[i] == -1)continue;

            slotid = p_slots[i]; if(slotid < 0 || slotid >= MAX_PLAYER_OBJECTS)continue;

            if(PlayerInfo[playerid][pObjectWearing][slotid] != -1)
            {
                attach_object_slot = PlayerInfo[playerid][pObjectWearing][slotid];

                SunucuMesaji(playerid, "Belirtilen aksesuar kald�r�ld�.");
                RemovePlayerAttachedObject(playerid, attach_object_slot);
                PlayerInfo[playerid][pObjectSlotOccupied][attach_object_slot] = 0;
                PlayerInfo[playerid][pObjectWearing][slotid] = -1;
                PlayerInfo[playerid][pObjectWearingVar][slotid] = -1;
            }
            else PlayerObjects_CheckWear(playerid, slotid);

            count++;
        }

        if(!count)
        {
            new string[512];

            for(new i; i < MAX_PLAYER_OBJECTS; i++) format(string, sizeof(string), "%s%s\t%d\n", string, PlayerObjects_GetName(playerid, i), i);

            Dialog_Show(playerid, DialogGovAksesuarIndex, DIALOG_STYLE_TABLIST_HEADERS, "Aksesuar", "Aksesuar\tSlot\n%s", "Se�", "�ptal", string);
        }
    } else return HataMesaji(playerid, "Ekipman dolab�na yak�n de�ilsin.");
    return 1;
}

flags:kelepce(CMD_PDGOV);
CMD:kelepce(playerid, params[])
{
    new id;

    if(sscanf(params, "k<m>", id))return
        KullanimMesaji(playerid, "/kelepce [id/isim]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesaji(playerid, "Ge�ersiz ID.");

    if(!ProxDetectorS(9.0, playerid, id))return
        SunucuMesaji(playerid, "Bu oyuncuya yak�n de�ilsin.");

    if(!PlayerInfo[playerid][pKelepceSayisi] && !PlayerInfo[id][pCuffed])return
        HataMesaji(playerid, "Kelep�eniz kalmam��. Merkezden kelep�e alabilir ya da birinden kelep�e isteyebilirsiniz.");
        
    PlayerInfo[id][pCuffed] = !PlayerInfo[id][pCuffed];
    
    StopAnim(id);

    if(PlayerInfo[id][pCuffed])
    {
        if(PlayerInfo[id][pMobile] != -1) {
            Phone_HangupCall(id);
            SendClientMessageEx(id, COLOR_GREY, "Kelep�elendi�iniz i�in telefon g�r��meniz sonland�r�ld�.");
        }
        if(PlayerInfo[playerid][pKelepceSayisi] <= 2)
            PlayerMEPlayer(playerid, id, "ki�isini kelep�eler");
        else
            PlayerMEPlayer(playerid, id, "ki�isinin ellerini zip ties ile ba�lar.");
        SetPlayerSpecialAction(id, SPECIAL_ACTION_CUFFED);
        PlayerInfo[playerid][pKelepceSayisi]--;
        SetPlayerAttachedObject(id, 9, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);
    }
    else
    {
        if(!PlayerInfo[playerid][pSWAT]) {
            if(PlayerInfo[playerid][pKelepceSayisi] < 2)
                PlayerInfo[playerid][pKelepceSayisi]++;
        }
        else {
            if(PlayerInfo[playerid][pKelepceSayisi] < 10)
                PlayerInfo[playerid][pKelepceSayisi]++;
        }
        PlayerMEPlayer(playerid, id, "ki�isinin kelep�elerini ��kart�r");
        SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);
        RemovePlayerAttachedObject(id, 9);
    }

    return 1;
}

flags:kelepcever(CMD_LSPD);
CMD:kelepcever(playerid, params[])
{
    new id;
    if(sscanf(params, "u", id)) return KullanimMesaji(playerid, "/kelepcever [id/isim]");
    if(!PlayerInfo[playerid][pKelepceSayisi]) return HataMesaji(playerid, "Kelep�eniz kalmam��. Merkezden kelep�e alabilir ya da birinden kelep�e isteyebilirsiniz..");
    if(!PlayerInfo[playerid][pSWAT] && PlayerInfo[id][pKelepceSayisi] >= 2) return HataMesaji(playerid, "Ki�ide zaten 2 kelep�e var, ki�i daha fazla kelep�e ta��yamaz.");
    if(PlayerInfo[playerid][pSWAT] && PlayerInfo[id][pKelepceSayisi] >= 10) return HataMesaji(playerid, "Ki�ide zaten 10 kelep�e var, ki�i daha fazla kelep�e ta��yamaz.");
    PlayerInfo[playerid][pKelepceSayisi]--;
    PlayerInfo[id][pKelepceSayisi]++;
    PlayerMEPlayer(playerid, id, "ki�isine kelep�e verir");
    return 1;
}

flags:kelepceal(CMD_LSPD);
CMD:kelepceal(playerid) {
    new bid = GetPlayerBuilding(playerid, true);
    if(PlayerInfo[playerid][pKelepceSayisi] == 2) return HataMesaji(playerid, "Daha fazla kelep�e ta��yamazs�n�z.");
    if(bid != -1 && BuildingInfo[bid][bFaction] == PlayerInfo[playerid][pFaction]) {
        PlayerInfo[playerid][pKelepceSayisi] = 2;
        PlayerAME(playerid, "dolaptan kelep�e al�r.");
    }
    return 1;
}

flags:beanbag(CMD_LSPD);
CMD:beanbag(playerid, params[])
{
    if(GetTickCount() - PlayerInfo[playerid][pPoliceTick] < 2500)return 1;

    PlayerInfo[playerid][pPoliceTick] = GetTickCount();
    new silah = GetPlayerWeapon(playerid);
    if(silah == 25) {
        if(!PlayerInfo[playerid][pBeanBag])
        {
            PlayerAME(playerid, "pompal� t�fe�ine beanbag mermileri y�kler.");
            PlayerInfo[playerid][pBeanBag] = 1;
            SendClientMessageEx(playerid, COLOR_YELLOW, "Beanbag mermileri {00FF00}AKTIF.");
        }
        else
        {
            PlayerAME(playerid, "pompal� t�fe�ine normal mermilerini y�kler.");
            PlayerInfo[playerid][pBeanBag] = 0;
            SendClientMessageEx(playerid, COLOR_YELLOW, "Beanbag mermileri {FF0000}DEAKTIF.");
        }
    }
    else {
        new vid = GetNearestVehicle(playerid);
        if(IsValidVehicle(vid)) {
            if(Faction_GetType(VehicleInfo[GetPlayerVehicleID(playerid)][vFaction]) == POLICE) {
                if(!PlayerInfo[playerid][pBeanBag])
                {
                    PlayerAME(playerid, "pompal� t�fe�ine beanbag mermileri y�kler.");
                    PlayerInfo[playerid][pBeanBag] = 1;
                    SendClientMessageEx(playerid, COLOR_YELLOW, "Beanbag mermileri {00FF00}AKTIF.");
                    AC_GivePlayerWeapon(playerid, 25, 50);
                }
                else
                {
                    PlayerAME(playerid, "pompal� t�fe�ine normal mermilerini y�kler.");
                    PlayerInfo[playerid][pBeanBag] = 0;
                    SendClientMessageEx(playerid, COLOR_YELLOW, "Beanbag mermileri {FF0000}DEAKTIF.");
                }
            } else return HataMesaji(playerid, "Yak�n�n�zda bir polis arac� yok.");
        } else return HataMesaji(playerid, "Beanbag komutunu kullanmak i�in elinizde Shotgun olmas� ya da polis arac�na yak�n olman�z gerekiyor.");
    }
    return 1;
}

flags:gov(CMD_PDFDGOV);
CMD:gov(playerid, params[])
{
    if(PlayerInfo[playerid][pRank] > 2) return
        SunucuMesaji(playerid, "Bunu kullanman i�in r�tben yetmiyor.");

    if(isnull(params) || strlen(params) > 256)return
        KullanimMesaji(playerid, "/gov [yaz�]");

    foreach(new j : Player)
    {
        if(!IsPlayerConnected(j) || !PlayerInfo[j][pLogged])continue;
        SendFormattedMessage(j, COLOR_TURQUOISE, "[H�k�met Duyurusu]: %s", params);
    }

    return 1;
}

flags:d(CMD_PDFDGOV);
CMD:d(playerid, params[])return pc_cmd_departman(playerid, params);
flags:departman(CMD_PDFD);
CMD:departman(playerid, params[])
{
    if(isnull(params) || strlen(params) > 256)return
        SendClientMessageEx(playerid, COLOR_GREY, "(/d)epartman [yaz�]");

    new fid = PlayerInfo[playerid][pFaction];

    foreach(new j : Player)
    {
        if(!IsPlayerConnected(j) || PlayerInfo[j][pFaction] == -1)continue;

        if(Faction_GetType(PlayerInfo[j][pFaction]) == POLICE || Faction_GetType(PlayerInfo[j][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[j][pFaction]) == POLICE || Faction_GetType(PlayerInfo[j][pFaction]) == GOVERNMENT)
            SendFormattedMessage(j, 0xf07a7aAA, "[%s] %s %s: %s", FactionInfo[fid][fShortName], fRanks[fid][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid), params);
    }
    return 1;
}

flags:m(CMD_PDFDGOV);
flags:megafon(CMD_PDFDGOV);
CMD:m(playerid, params[])return pc_cmd_megafon(playerid, params);
CMD:megafon(playerid, params[])
{
//  if(PlayerInfo[playerid][pTVActor] != -1)
    //  return HataMesaji(playerid, "Bu i�lemi yapamazs�n�z.");

    new string[128];
    if(!IsPlayerInAnyVehicle(playerid)) {
        new vid = GetNearestVehicle(playerid);
        if(IsValidVehicle(vid)) {
            if(Faction_GetType(VehicleInfo[vid][vFaction]) == POLICE || Faction_GetType(VehicleInfo[vid][vFaction]) == MEDICAL || Faction_GetType(VehicleInfo[vid][vFaction]) == GOVERNMENT) {
                if(isnull(params) || strlen(params) > 256)return
                    SendClientMessageEx(playerid, COLOR_GREY, "(/m)egafon [yaz�]");

                format(string, sizeof(string), "[ %s:o< %s ]", ReturnRoleplayName(playerid), params);
                printf(string);
                ProxDetector(40.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
            } else return HataMesaji(playerid, "Yak�n�n�zdaki ara� polis ya da FD arac� de�il.");
        } else return HataMesaji(playerid, "Yak�n�n�zda bir polis,FD ya da city hall arac� yok ve bir arac�n i�inde de�ilsiniz.");
    } else {
        new vehid = GetPlayerVehicleID(playerid);
        if(Faction_GetType(VehicleInfo[vehid][vFaction]) == POLICE || Faction_GetType(VehicleInfo[vehid][vFaction]) == MEDICAL  || Faction_GetType(VehicleInfo[vehid][vFaction]) == GOVERNMENT) {
            if(isnull(params) || strlen(params) > 256)return
                SendClientMessageEx(playerid, COLOR_GREY, "(/m)egafon [yaz�]");

            format(string, sizeof(string), "[ %s:o< %s ]", ReturnRoleplayName(playerid, true), params);
            printf(string);
            ProxDetector(40.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
        } else return HataMesaji(playerid, "Yak�n�n�zda bir polis,FD ya da city hall arac� yok ve bir arac�n i�inde de�ilsiniz.");
    }
    return 1;
}
flags:pdkisayol(CMD_LSPD);
CMD:pdkisayol(playerid, params[])
{
    SendClientMessage(playerid, COLOR_FADE1, "(( {33AA33}_______________(KISAYOL KOMUTLARI)_______________ {E6E6E6}))");
    SendClientMessage(playerid, COLOR_GREEN, "(( {FFFFFF}/m1: Teslim ol, etraf�n sar�ld�! (Give up, you're surrounded!){33AA33} ))");
    SendClientMessage(playerid, COLOR_GREEN, "(( {FFFFFF}/m2: Hey sen! Dur polis! (Hey you, police. Stop!){33AA33} ))");
    SendClientMessage(playerid, COLOR_GREEN, "(( {FFFFFF}/m3: Los Santos Polis Departman�, oldu�un yerde kal! (This is LSPD, stay where you're){33AA33} ))");
    SendClientMessage(playerid, COLOR_GREEN, "(( {FFFFFF}/m4: Oldu�un yerde kal, yoksa ate� a�aca��z! (Freeze, or we'll open fire!){33AA33} ))");
    SendClientMessage(playerid, COLOR_GREEN, "(( {FFFFFF}/m5: Polis KIPIRDAMA! (Police, don't move!){33AA33} ))");
    SendClientMessage(playerid, COLOR_GREEN, "(( {FFFFFF}/m6: Ellerin ba��n�n �st�nde kalacak �ekilde ara�tan in! (Get outta the car with your hands in the air!){33AA33} ))");
    SendClientMessage(playerid, COLOR_GREEN, "(( {FFFFFF}/m7: LSPD, kenara �eki-.. sen deli misin?! Hepimizi �ld�r�yordun! (LSPD stop right-.. are you insane? You'll kill us all){33AA33} ))");

    return 1;
}

flags:m1(CMD_LSPD);
CMD:m1(playerid, params[])
{
    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    new string[256];
    format(string,sizeof(string), "%s(ba��rarak): Teslim ol, etraf�n sar�ld�!", ReturnRoleplayName(playerid, true));
    ProxDetector(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, true);
    PlaySoundEx(9605, pX, pY, pZ, 30);
    return 1;
}
flags:m2(CMD_LSPD);
CMD:m2(playerid, params[])
{
    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    new string[256];
    format(string,sizeof(string), "%s(ba��rarak): Hey sen! Dur polis!", ReturnRoleplayName(playerid, true));
    ProxDetector(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, true);
    PlaySoundEx(10200, pX, pY, pZ, 30);
    return 1;
}
flags:m3(CMD_LSPD);
CMD:m3(playerid, params[])
{
    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    new string[256];
    format(string, sizeof(string), "[ %s:o< Los Santos Polis Departman�, oldu�un yerde kal! ]", ReturnRoleplayName(playerid));
    ProxDetector(40.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
    PlaySoundEx(15800, pX, pY, pZ, 40);
    return 1;
}
flags:m4(CMD_LSPD);
CMD:m4(playerid, params[])
{
    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    new string[256];
    format(string,sizeof(string), "%s(ba��rarak): Oldu�un yerde kal, yoksa ate� a�aca��z!", ReturnRoleplayName(playerid, true));
    ProxDetector(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, true);
    PlaySoundEx(15801, pX, pY, pZ, 30);
    return 1;
}
flags:m5(CMD_LSPD);
CMD:m5(playerid, params[])
{
    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    new string[256];
    format(string,sizeof(string), "%s(ba��rarak): Polis KIPIRDAMA!", ReturnRoleplayName(playerid, true));
    ProxDetector(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, true);
    PlaySoundEx(34402, pX, pY, pZ, 30);
    return 1;
}
flags:m6(CMD_LSPD);
CMD:m6(playerid, params[])
{
    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    new string[256];
    format(string,sizeof(string), "%s(ba��rarak): Ellerin ba��n�n �st�nde kalacak �ekilde ara�tan in!", ReturnRoleplayName(playerid, true));
    ProxDetector(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, true);
    PlaySoundEx(34403, pX, pY, pZ, 30);
    return 1;
}
flags:m7(CMD_LSPD);
CMD:m7(playerid, params[])
{
    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    new string[256];
    format(string, sizeof(string), "[ %s:o< LSPD, kenara �eki-.. sen deli misin?! Hepimizi �ld�r�yordun!]", ReturnRoleplayName(playerid));
    ProxDetector(40.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
    PlaySoundEx(15825, pX, pY, pZ, 40);
    return 1;
}
// Olu�um Kasas� (Genel)

CMD:fkasa(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1 || PlayerInfo[playerid][pRank] > 2 || Faction_GetType(PlayerInfo[playerid][pFaction]) == SADECEUYUSTURUCU || Faction_GetType(PlayerInfo[playerid][pFaction]) == ONAYLIFACT)
        return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    new buildingid = GetPlayerBuilding(playerid, true);

    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT && PlayerInfo[playerid][pRank] >= 2) return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    if(buildingid != -1 && BuildingInfo[buildingid][bType] == BANK)
    {
        new id = PlayerInfo[playerid][pFaction];

        SunucuMesaji(playerid, "Olu�um kasas�nda $%d bulunuyor.", FactionInfo[id][fCash]);
    }
    else return
        SunucuMesajiC(playerid, "Bankada de�ilsin.");

    return 1;
}

flags:fparacek(CMD_USER);
flags:fparayatir(CMD_USER);
CMD:fparacek(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1 || PlayerInfo[playerid][pRank] > 2 || Faction_GetType(PlayerInfo[playerid][pFaction]) == SADECEUYUSTURUCU || Faction_GetType(PlayerInfo[playerid][pFaction]) == ONAYLIFACT)
        return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT && PlayerInfo[playerid][pRank] >= 2) return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    new buildingid = GetPlayerBuilding(playerid, true);

    if(buildingid != -1 && BuildingInfo[buildingid][bType] == BANK)
    {
        new amount;
        new id = PlayerInfo[playerid][pFaction];

        if(sscanf(params, "d", amount))return
            KullanimMesajiC(playerid, "/fparacek [miktar]");

        if(amount < 1 || amount > FactionInfo[id][fCash])return
            SunucuMesaji(playerid, "Olu�um kasas�nda bu kadar para yok.");

        FactionInfo[id][fCash] -= amount;
        AC_GivePlayerMoney(playerid, amount, "/fparacek");

        SunucuMesaji(playerid, "Olu�um kasas�ndan $%d ald�n.", amount);

        LogYaz(playerid, "/fparacek", -1, id, amount);

        SaveFaction(id);
    }
    else return
        SunucuMesajiC(playerid, "Bankada de�ilsin.");

    return 1;
}
CMD:fparayatir(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] == -1 || Faction_GetType(PlayerInfo[playerid][pFaction]) == SADECEUYUSTURUCU || Faction_GetType(PlayerInfo[playerid][pFaction]) == ONAYLIFACT)
        return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    new buildingid = GetPlayerBuilding(playerid, true);

    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT && PlayerInfo[playerid][pRank] >= 2) return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");

    if(buildingid != -1 && BuildingInfo[buildingid][bType] == BANK)
    {
        new amount;
        new id = PlayerInfo[playerid][pFaction];

        if(sscanf(params, "d", amount))return
            KullanimMesajiC(playerid, "/fparayatir [miktar]");

        if(amount < 1 || amount > PlayerInfo[playerid][pCash])return
            HataMesaji(playerid, "Yeterli paran yok. ($%d)", amount);

        FactionInfo[id][fCash] += amount;
        AC_GivePlayerMoney(playerid, -amount, "/fparayatir");

        SunucuMesaji(playerid, "Olu�um kasas�na $%d koydun.", amount);

        LogYaz(playerid, "/fparayatir", -1, id, amount);

        SaveFaction(id);
    }
    else return
        SunucuMesajiC(playerid, "Bankada de�ilsin.");

    return 1;
}
