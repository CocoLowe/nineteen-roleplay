flags:meslekayril(CMD_USER);
CMD:meslekayril(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == -1)return
        SunucuMesaji(playerid, "Bir i�te de�ilsin.");

    PlayerInfo[playerid][pJob] = -1;

    SunucuMesaji(playerid, "��ten ayr�ld�n.");

    return 1;
}

flags:meslekisbasi(CMD_USER);
CMD:meslekisbasi(playerid, params[])
{
    if(PlayerInfo[playerid][pFactionDuty])return
        SunucuMesaji(playerid, "Zaten olu�um i�ba��ndas�n.");

    if(PlayerInfo[playerid][pJob] == 2 || PlayerInfo[playerid][pJob] == 1)
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if(!IsTaxi(vehicleid) && PlayerInfo[playerid][pJob] == 2)return
            SunucuMesaji(playerid, "Takside de�ilsin.");

        if(!InTowTruck(playerid) && PlayerInfo[playerid][pJob] == 1)return
            SunucuMesaji(playerid, "Tow Truck'�n i�erisinde de�ilsin.");

        PlayerInfo[playerid][pJobDuty] = !PlayerInfo[playerid][pJobDuty];
        //PlayerInfo[playerid][pJobTime] = gettime() + (60 * 25);

        SendClientMessageEx(playerid, COLOR_GREEN, (PlayerInfo[playerid][pJobDuty]) ? ("��ba��na ge�tin.") : ("��ba��ndan ��kt�n."));
    }
    else return
        SunucuMesaji(playerid, "Tamirci veya taksici de�ilsin.");

    return 1;
}

CMD:tamiret(playerid, params[])
{
    new price, vehicleid = GetPlayerVehicleID(playerid), repairType, id;

    if(PlayerInfo[playerid][pJob] != 1)return
        HataMesajiC(playerid, "Tamirci de�ilsin.");

    if(InTowTruck(playerid) <= 0)return
        HataMesajiC(playerid, "Tow Truck'�n i�erisinde de�ilsin.");

    if(sscanf(params, "k<m>dd", id, repairType, price))
    {
        KullanimMesajiC(playerid, "/tamiret [id/isim] [servistipi] [fiyat]");
        SendClientMessage(playerid, COLOR_GREY, "[Servisler] 1: Motor Tamiri - 2: D�� Tamir - 3: Motor �mr� - 4: Ak� �mr�");
        SendClientMessage(playerid, COLOR_ERROR, "Motor Tamiri (1): {AFAFAF}Arac�n HP'sini yeniler. (4 par�a)");
        SendClientMessage(playerid, COLOR_ERROR, "D�� tamir (2): {AFAFAF}Arac�n d�� g�r�n���n� yeniler. (4 par�a)");
        SendClientMessage(playerid, COLOR_ERROR, "Motor �mr� (3): {AFAFAF}Arac�n motor �mr�n� 1000 olarak ayarlar. (100 par�a)");
        SendClientMessage(playerid, COLOR_ERROR, "Ak� �mr� (4): {AFAFAF}Arac�n ak� �mr�n� 1000 olarak ayarlar. (100 par�a)");
	}

    if(repairType < 1 || repairType > 4)return
        HataMesajiC(playerid, "Servis tipi 1 ile 4 aras�nda olmal�d�r, aksi tipler kullan�lamaz.");

	new parcasayi;
	switch(repairType)
	{
	    case 1: parcasayi = 4;
	    case 2: parcasayi = 4;
	    case 3: parcasayi = 100;
	    case 4: parcasayi = 100;
	}
	new mevcutparca = VehicleInfo[vehicleid][vComponents];
    if(mevcutparca < parcasayi)
		return HataMesaji(playerid, "Arac� tamir etmek i�in yeterli par�a bulunmuyor. (%d)", parcasayi);

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(!ProxDetectorS(20.0, playerid, id) || GetPlayerState(id) != PLAYER_STATE_DRIVER)return
        HataMesajiC(playerid, "Oyuncu sizden uzakta veya bir ara�ta de�il.");

	if(Vehicle_IsOwner(id, GetPlayerVehicleID(id), false) == 0)
		return HataMesajiC(playerid, "�stek g�ndermek istedi�iniz oyuncu ara� veya anahtar sahibi de�il.");

    if(price < 1 || price > 5000)return
        HataMesajiC(playerid, "Ge�ersiz tutar. ($1 - $5000)");

    if(PlayerInfo[id][pCash] < price)return
        HataMesaji(playerid, "Bu oyuncunun yeterli paras� yok. ($%d)", price);

    if(PlayerInfo[id][pRequestRepair] == playerid) return
        HataMesajiC(playerid, "Bir kullan�c�ya tamir iste�i g�nderdin, /tamiriptal komutuyla onu iptal etmelisin.");

    PlayerInfo[id][pRequestRepair] = playerid;
    PlayerInfo[id][pRepairType] = repairType;
    PlayerInfo[id][pRepairPrice] = price;

    new yazi[60];
    switch(repairType)
	{
        case 1: format(yazi, sizeof(yazi), "i� tamir i�lemi");
		case 2: format(yazi, sizeof(yazi), "d�� tamir i�lemi");
        case 3: format(yazi, sizeof(yazi), "motor �mr�n� y�kseltmek");
        case 4: format(yazi, sizeof(yazi), "ak� �mr�n� y�kseltmek");
    }
    SunucuMesaji(id, "%s adl� tamirci $%d kar��l���nda %s i�in izin istiyor. (/kabulet tamir)", ReturnRoleplayName(playerid), price, yazi);
    SunucuMesaji(playerid, "Tamir iste�iniz %s ki�isine $%d olarak g�nderildi.", ReturnRoleplayName(id), price);
    return 1;
}

CMD:parcaalani(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");

    if(PlayerInfo[playerid][pJob] != 1)return
        SunucuMesaji(playerid, "Tamirci de�ilsin.");

    if(!InTowTruck(playerid))return
        SunucuMesaji(playerid, "Tow Truck'�n i�erisinde de�ilsin.");

    new industryID = Pickup_Nearest(playerid, ELEMENT_COMPANY);

    if(industryID == -1 || CompanyInfo[industryID][cBuyType] != VEHICLE_PART)
    {
        AC_SetPlayerCheckpoint(playerid, CompanyInfo[11][cBuyPosX], CompanyInfo[11][cBuyPosY], CompanyInfo[11][cBuyPosZ], 2.0);
        return HataMesajiC(playerid, "Tamirciler i�in par�a alma alan�nda de�ilsin. Konumu haritanda i�aretlendi.");
    }

    pc_cmd_koli(playerid, "satinal");

    return 1;
}

CMD:meslekduyuru(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	new slot = Inventory_HasItem(playerid, "Cep Telefonu", ITEM_PHONE);
    if(slot == -1) return HataMesajiC(playerid, "Cep telefonun yok, reklam vermek i�in telefona ihtiyac�n var.");

	if(sscanf(params, "d", slot)) return KullanimMesajiC(playerid, "/meslekduyuru [telefon slot id]");

	slot--;

	new listid = PlayerInfo[playerid][pInvList][slot];

	if(InventoryObjects[listid][invType] != ITEM_PHONE)return HataMesajiC(playerid, "Se�ti�iniz envanter slotunda cep telefonu yok.");

	if(!PlayerInfo[playerid][pInvExtra][slot]) return HataMesajiC(playerid, "Cep telefonun kapal�yken reklam veremezsin.");

	if(PlayerInfo[playerid][pFactionDuty]) return SunucuMesajiC(playerid, "Olu�um i� ba��ndayken bu komutu kullanamazs�n.");
	if(PlayerInfo[playerid][pJobTime] - gettime() > 0) return HataMesaji(playerid, "Bu komutu kulanmak i�in %d saniye bekleyin.", PlayerInfo[playerid][pJobTime] - gettime());
	if(PlayerInfo[playerid][pJob] != 2 && PlayerInfo[playerid][pJob] != 1) return HataMesajiC(playerid, "Bu komutu kullanamazs�n.");
	if(!InTowTruck(playerid) && !IsTaxi(vehicleid)) return HataMesajiC(playerid, "Meslek arac�nda de�ilsin.");

	foreach(new j : Player)
	{
		if(!IsPlayerConnected(j) || !PlayerInfo[j][pNews])continue;
		if(PlayerInfo[playerid][pJob] == 2) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s adl� taksici i�ba��nda. (�leti�im: %d)", ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
        if(PlayerInfo[playerid][pJob] == 1) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s adl� tamirci i�ba��nda. (�leti�im: %d)", ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
	}
	PlayerInfo[playerid][pJobTime] = gettime() + (60 * 15);
	return 1;
}

// Taxi Driver Job

flags:taksimetre(CMD_USER);
CMD:taksimetre(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");

    new price, id,
        vehicleid = GetPlayerVehicleID(playerid);
		
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return HataMesajiC(playerid, "Ara�ta s�r�c� de�ilsiniz.");

    if(!IsPlayerInAnyVehicle(playerid) || !IsTaxi(vehicleid))return
        SunucuMesaji(playerid, "Taksi i�erisinde de�ilsin.");

    if(PlayerInfo[playerid][tPassenger] != -1)return EndTaxi(playerid, PlayerInfo[playerid][tPassenger]);

    if(sscanf(params, "k<m>d", id, price))return
        KullanimMesajiC(playerid, "/taksimetre [id] [�cret/km]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesajiC(playerid, "Ge�ersiz ID.");

    if(GetPlayerVehicleID(id) != vehicleid)return
        SunucuMesaji(playerid, "Bu oyuncu senin taksinde de�il.");

    if(price < 0 || price > 6)return
        SunucuMesaji(playerid, "Ge�ersiz tutar. ($0 - $6)");

    PlayerInfo[id][pTaxPrice] = price;
    PlayerInfo[id][pTaxRequest] = playerid;

    BasariMesaji(id, "%s sana $%d / km vermen kar��l���nda yolcusu olabilece�ini s�yl�yor. E�er istiyorsan /kabulet taksi kullan.", ReturnRoleplayName(playerid), price);
    SunucuMesaji(playerid, "%s ki�isine $%d / km kar��l���nda yolculuk teklifi yollad�n.", ReturnRoleplayName(id), price);

    return 1;
}


// Fishing Job

flags:baliktut(CMD_USER);
flags:baliksat(CMD_USER);
flags:balikyemal(CMD_USER);

CMD:balik(playerid,params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");
	new secenek[14], slot, oyuncuid;
	if(sscanf(params, "s[14]D(-1)U(-1)", secenek, slot, oyuncuid)) return KullanimMesaji(playerid, "/balik [tut/sat/durum/hepsinisat/birak/hepsinibirak/pisir/liste/ye]& /balikyemal");
	if(isnull(params)) return KullanimMesajiC(playerid, "/balik [tut/sat/durum] & /balikyemal");

	if (!strcmp(secenek, "tut"))
	{
		return pc_cmd_baliktut(playerid, "");
	}

	else if (!strcmp(secenek, "sat"))
	{
		if(slot == -1) return KullanimMesaji(playerid, "/balik sat [slot] Listeyi g�rmek i�in /balik liste yazabilirsin.");
		if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");

	    if(!IsPlayerInAnyVehicle(playerid)) pc_cmd_animdurdur(playerid, NULL);
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid, 8);
		
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 375.116790, -2055.140136, 8.015625) && PlayerInfo[playerid][pBalik] > 0)
		{
			if(!BalikVarMi(playerid))return
				SunucuMesaji(playerid, "Sat�lacak bal�k bulunmuyor.");
				
			BalikSat2(playerid, slot);
			PlayerInfo[playerid][pZone][0] = 0;
			PlayerInfo[playerid][pZone][1] = 0;
			PlayerInfo[playerid][pFishTime] = 0;
			PlayerInfo[playerid][pSellFish] = GetTickCount();
		}
		else
		{
			if(!IsPlayerInRangeOfPoint(playerid, 5.0, SELL_X, SELL_Y, SELL_Z) && PlayerInfo[playerid][pBalik] > 0)
			{
				if(GetTickCount() - PlayerInfo[playerid][pSellFish] < 300000)return
					SunucuMesaji(playerid, "Be� dakikada bir bal�k satabilirsin.");

				SendClientMessageEx(playerid, COLOR_WHITE, "Y�zde k�rk zararla bal���n� Star Fish'de ya da kay�p ya�amadan Ocean Docks'da satabilirsin.");

				return 1;// AC_SetPlayerCheckpoint(playerid, SELL_X, SELL_Y, SELL_Z, 2.0);
			}

			if(!BalikVarMi(playerid))return
				SunucuMesaji(playerid, "Sat�lacak bal�k bulunmuyor.");
				
			BalikSat(playerid, slot);
			PlayerInfo[playerid][pZone][0] = 0;
			PlayerInfo[playerid][pZone][1] = 0;
			PlayerInfo[playerid][pFishTime] = 0;
			PlayerInfo[playerid][pSellFish] = GetTickCount();
		}
	}

	else if (!strcmp(secenek, "durum"))
	{
		return pc_cmd_balikdurum(playerid, "");
	}
	else if (!strcmp(secenek, "hepsinisat")) {
	    return pc_cmd_baliksat(playerid, "");
	}
	else if (!strcmp(secenek, "birak")) {
	    if(slot == -1) return KullanimMesaji(playerid, "/balik birak [slot] Listeyi g�rmek i�in /balik liste yazabilirsin.");
	    new sonuc = BalikCikar(playerid, slot);
	    if(sonuc) {
	        PlayerAME(playerid, "bal�k atar.");
	        SunucuMesaji(playerid, "%d slotundaki bal��� att�n.", slot);
	    } else return HataMesaji(playerid, "Belirtti�in slotta zaten bir bal�k yok.");
	}
	else if (!strcmp(secenek, "hepsinibirak")) {
	    if(!BalikVarMi(playerid)) return HataMesaji(playerid, "Zaten bal���n yok.");
	    TumBaliklariCikar(playerid);
	    PlayerAME(playerid, "t�m bal�klar�n� atar.");
	    SunucuMesaji(playerid, "T�m bal�klar�n� att�n.");
	}
	else if (!strcmp(secenek, "pisir")) {
	    if(!BalikVarMi(playerid)) return HataMesaji(playerid, "Zaten bal���n yok.");
	    if(slot == -1) return KullanimMesaji(playerid, "/balik pisir [slot] Listeyi g�rmek i�in /balik liste yazabilirsin.");
		SetPVarInt(playerid, "BalikSlot", slot);
		SetPVarInt(playerid, "BalikPisirecek", 1);
		SelectObject(playerid);
		SunucuMesaji(playerid, "�st�nde pi�irmek istedi�iniz kamp ate�ini fare yard�m�yla se�in.");
	}
	else if (!strcmp(secenek, "liste")) {
	    if(PlayerInfo[playerid][pBalikListe] != 0) return HataMesaji(playerid, "Listeye 20 saniyede bir bakabilirsin.");
		if(!BalikVarMi(playerid)) return HataMesaji(playerid, "Bal���n yok.");
		BalikListeGoster(playerid);
		PlayerInfo[playerid][pBalikListe] = 20;
	}
	else if (!strcmp(secenek, "ye")) {
		SetPVarInt(playerid, "BalikYiyecek", 1);
	    SelectObject(playerid);
	    SunucuMesaji(playerid, "Bal�k yemek istedi�iniz kamp ate�ini fare yard�m�yla se�in.");
	}
	else HataMesajiC(playerid, "Hatal� ya da ge�ersiz bir i�lem belirttiniz.");
	return 1;
}

CMD:balikdurum(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");

	new satis = BalikUcret(playerid);
	SunucuMesaji(playerid, "Bal�k��l�k > Bal�k[%i] - Bal�k Yemi[%i] - Kazanaca��n�z �cret[$%i]", KacBalikVar(playerid), PlayerInfo[playerid][pBalikYemi], satis);
	return 1;
}

flags:agal(CMD_USER);
CMD:agal(playerid) {
    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");
	if(!IsPlayerInRangeOfPoint(playerid, 1.0, 359.916290, -2032.155029, 7.835937))
	   	return HataMesajiC(playerid, "A� sat�n alma noktas�nda de�ilsiniz.");

	if(PlayerInfo[playerid][pBalikAgi]) return HataMesaji(playerid, "Zaten a��n�z var.");
	
	if(1000 > PlayerInfo[playerid][pCash])
		return HataMesaji(playerid, "A� sat�n almak i�in �zerinizde en az $1000 bulunmal�d�r.");

	PlayerInfo[playerid][pBalikAgi] = 1;
	OAC_GivePlayerMoney(playerid, -1000);
	BasariMesaji(playerid, "Bal�k a�� ald�n�z ve sat�c�ya $1000 para verdiniz.");
	return 1;
}

CMD:yemal(playerid, params[])return pc_cmd_balikyemal(playerid, "");
CMD:balikyemal(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");
	if(!IsPlayerInRangeOfPoint(playerid, 1.0, 359.916290, -2032.155029, 7.835937))
	   	return HataMesajiC(playerid, "Yem sat�n alma noktas�nda de�ilsiniz.");

	new yemucret, yemadet;

	if(sscanf(params, "d", yemadet))
	    return KullanimMesajiC(playerid, "/balik yem [miktar] (Yem ba��na $1 / Max: 5000 yem)");

	if(PlayerInfo[playerid][pBalikYemi] >= 5001)
	{
	    PlayerInfo[playerid][pBalikYemi] = 5000;
		HataMesajiC(playerid, "�zerinizde bulunan fazla yemlere sistem taraf�ndan el koyuldu.");
	}
	if(PlayerInfo[playerid][pBalikYemi] == 5000)
	{
		return HataMesajiC(playerid, "�zerinizde en fazla 5000 tane bal�k yemi bulunabilir.");
	}

	if(yemadet <= 0) return HataMesajiC(playerid, "Ge�ersiz de�er girdin.");

	if(yemadet > 5000) return HataMesajiC(playerid, "Ge�ersiz de�er giri�i.");

	yemucret = yemadet * 1;

	if(yemucret > PlayerInfo[playerid][pCash])
		return HataMesaji(playerid, "Yem sat�n almak i�in �zerinizde en az $%i bulunmal�d�r.", yemucret);

	PlayerInfo[playerid][pBalikYemi] += yemadet;
	OAC_GivePlayerMoney(playerid, -yemucret);
	BasariMesaji(playerid, "%d adet bal�k yemi ald�n�z ve sat�c�ya $%d para verdiniz.", yemadet, yemucret);
	return 1;
}

flags:agat(CMD_USER);
CMD:agat(playerid) {
    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");

    new fishZone = GetFishingZone(playerid, true);
    new pointZone = GetFishingZone(playerid, false);

    if(pointZone == -1 && fishZone == -1)return
        SunucuMesaji(playerid, "Burada bal�k tutamazs�n. Star Fish iskelesindeki oltalara gitmelisin.");

    if(PlayerInfo[playerid][pBalikTutuyor]) return
        SunucuMesaji(playerid, "L�tfen bekleyin, bal�k tutma i�leminiz devam ediyor.");

	if(PlayerInfo[playerid][pBalikAgi] == 0)
			return HataMesajiC(playerid, "�zerinizde a� bulunmuyor.");

    new Float:X, Float:Y, Float:Z;
    new vid = GetPlayerVehicleID(playerid);
	if(vid == -1 || GetMaxFishes(playerid, VehicleInfo[vid][vModel]) == 0) return HataMesaji(playerid, "A� atabilece�iniz bir botta de�ilsiniz.");
	
    if(pointZone == -1)
    {
        if(PlayerInfo[playerid][CheckpointEnabled] == false)
        {
            fishZone = !fishZone;
            Generate_FishingCP(fishZone, X, Y, Z);
            AC_SetPlayerCheckpoint(playerid, X, Y, Z, 5.0);
            fishZone = !fishZone;
        }

        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || (vid && FishingBoat(vid) == 0) || fishZone == -1)return
            SunucuMesaji(playerid, "Bal�k tutmak i�in Star Fish'e gidip komutu tekrar kullan�n.");

        if(PlayerInfo[playerid][pZone][fishZone] >= 50)return
            SunucuMesaji(playerid, "Ayn� yerde fazla bal�k tutamazs�n, k�rm�z� noktaya git.");

        AC_DisablePlayerCheckpoint(playerid);
        PlayerInfo[playerid][pZone][fishZone]++;
    }

	new ayaktabalik = FISHES_FOOT;
	if(PlayerInfo[playerid][pPremium] == 4) ayaktabalik += 10;
	if(PlayerInfo[playerid][pPremium] == 5) ayaktabalik += 20;
    new maxTotalFish = (pointZone != -1 && fishZone != -1) ? ayaktabalik : GetMaxFishes(playerid, VehicleInfo[vid][vModel]);

    if(KacBalikVar(playerid) >= maxTotalFish)return
        HataMesaji(playerid, "%d'den fazla bal�k ta��yamazs�n.", maxTotalFish);

    PlayerAME(playerid, "a��n� denize b�rak�r.");
    SunucuMesaji(playerid, "Bal�k tutuluyor, l�tfen bekleyin.");
    
	new balikBekleme = 60;
    PlayerInfo[playerid][pFishTime] = balikBekleme;
    SetPVarInt(playerid, "BalikAg", 1);
	PlayerInfo[playerid][pBalikTutuyor] = true;

    TogglePlayerControllable(playerid, false);
    PlayerInfo[playerid][pFreezed] = 1;
	return 1;
}

CMD:baliktut(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");

    new fishZone = GetFishingZone(playerid, true);
    new pointZone = GetFishingZone(playerid, false);

    if(pointZone == -1 && fishZone == -1)return
        SunucuMesaji(playerid, "Burada bal�k tutamazs�n. Star Fish iskelesindeki oltalara gitmelisin.");

    if(PlayerInfo[playerid][pBalikTutuyor]) return
        SunucuMesaji(playerid, "L�tfen bekleyin, bal�k tutma i�leminiz devam ediyor.");

	if(PlayerInfo[playerid][pBalikYemi] == 0)
			return HataMesajiC(playerid, "�zerinizde bal�k yemi bulunmuyor.");

    new Float:X, Float:Y, Float:Z;
    new vid = GetPlayerVehicleID(playerid);

    if(pointZone == -1)
    {
        if(PlayerInfo[playerid][CheckpointEnabled] == false)
        {
            fishZone = !fishZone;
            Generate_FishingCP(fishZone, X, Y, Z);
            AC_SetPlayerCheckpoint(playerid, X, Y, Z, 5.0);
            fishZone = !fishZone;
        }

        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || (vid && FishingBoat(vid) == 0) || fishZone == -1)return
            SunucuMesaji(playerid, "Bal�k tutmak i�in Star Fish'e gidip komutu tekrar kullan�n.");

        if(PlayerInfo[playerid][pZone][fishZone] >= 50)return
            SunucuMesaji(playerid, "Ayn� yerde fazla bal�k tutamazs�n, k�rm�z� noktaya git.");

        AC_DisablePlayerCheckpoint(playerid);
        PlayerInfo[playerid][pZone][fishZone]++;
    }

	new ayaktabalik = FISHES_FOOT;
	if(PlayerInfo[playerid][pPremium] == 4) ayaktabalik += 10;
	if(PlayerInfo[playerid][pPremium] == 5) ayaktabalik += 20;
    new maxTotalFish = (pointZone != -1 && fishZone != -1) ? ayaktabalik : GetMaxFishes(playerid, VehicleInfo[vid][vModel]);

    if(KacBalikVar(playerid) >= maxTotalFish)return
        HataMesaji(playerid, "%d'den fazla bal�k ta��yamazs�n.", maxTotalFish);

    if(PlayerObjects_HasObject(playerid, "Olta") == 0) return HataMesajiC(playerid, "Elinde bir olta yok, /aksesuar ile eline alabilirsin. E�er oltaya sahip de�ilsen bir k�yafet d�kkan�na git.");

    PlayerAME(playerid, "oltas�n� denize sallar.");
    SunucuMesaji(playerid, "Bal�k tutuluyor, l�tfen bekleyin.");
    new BALIKBEKLEME;
	if(vid == -1 || GetMaxFishes(playerid, VehicleInfo[vid][vModel]) == 0)
		BALIKBEKLEME = 15;
	else
		BALIKBEKLEME = 10;
	new balikRandom = BALIKBEKLEME + random(5);
    PlayerInfo[playerid][pFishTime] = balikRandom;
	PlayerInfo[playerid][pBalikTutuyor] = true;
    ApplyAnimation(playerid, "SWORD", "sword_block", 50.0, 0, 1, 0, 1, 1);

    TogglePlayerControllable(playerid, false);
    PlayerInfo[playerid][pFreezed] = 1;
    PlayerInfo[playerid][pBalikYemi]--;
    return 1;
}

CMD:baliksat(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulundu�un faction bu komutu kullanman� desteklemiyor.");

    if(!IsPlayerInAnyVehicle(playerid)) pc_cmd_animdurdur(playerid, NULL);
    if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid, 8);
	
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 375.116790, -2055.140136, 8.015625) && PlayerInfo[playerid][pBalik] > 0)
	{
		if(!BalikVarMi(playerid))return
			SunucuMesaji(playerid, "Sat�lacak bal�k bulunmuyor.");

		BaliklariSat2(playerid);
		PlayerInfo[playerid][pZone][0] = 0;
		PlayerInfo[playerid][pZone][1] = 0;
		PlayerInfo[playerid][pFishTime] = 0;
		PlayerInfo[playerid][pSellFish] = GetTickCount();
	}
	else
	{
		if(!IsPlayerInRangeOfPoint(playerid, 2.0, SELL_X, SELL_Y, SELL_Z) && PlayerInfo[playerid][pBalik] > 0)
		{
			if(GetTickCount() - PlayerInfo[playerid][pSellFish] < 300000)return
				SunucuMesaji(playerid, "Be� dakikada bir bal�k satabilirsin.");

			SendClientMessageEx(playerid, COLOR_WHITE, "Y�zde k�rk zararla bal���n� Star Fish'de ya da kay�p ya�amadan Ocean Docks'da satabilirsin.");

			return 1;//AC_SetPlayerCheckpoint(playerid, SELL_X, SELL_Y, SELL_Z, 2.0);
		}

		if(!BalikVarMi(playerid))return
			SunucuMesaji(playerid, "Sat�lacak bal�k bulunmuyor.");

		BaliklariSat(playerid);
		PlayerInfo[playerid][pZone][0] = 0;
		PlayerInfo[playerid][pZone][1] = 0;
		PlayerInfo[playerid][pFishTime] = 0;
		PlayerInfo[playerid][pSellFish] = GetTickCount();
	}

    return 1;
}

GetMaxFishes(playerid, modelid)
{
    if(PlayerInfo[playerid][pPremium] <= 3) 
	{
        switch(modelid)
        {
            case 446, 452: return 20;
            case 453, 454: return 20;
            case 472: return 20;
            case 473: return 20;
            case 484, 595: return 20;
            case 493: return 20;
        }
    } 
	else if(PlayerInfo[playerid][pPremium] == 4) 
	{
        switch(modelid)
        {
            case 446, 452: return 30;
            case 453, 454: return 30;
            case 472: return 30;
            case 473: return 30;
            case 484, 595: return 30;
            case 493: return 30;
        }
    }
	else if(PlayerInfo[playerid][pPremium] == 5) 
	{
        switch(modelid)
        {
            case 446, 452: return 50;
            case 453, 454: return 50;
            case 472: return 50;
            case 473: return 50;
            case 484, 595: return 50;
            case 493: return 50;
        }
    }
    return 0;
}
