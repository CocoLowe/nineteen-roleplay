flags:meslekayril(CMD_USER);
CMD:meslekayril(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == -1)return
        SunucuMesaji(playerid, "Bir iþte deðilsin.");

    PlayerInfo[playerid][pJob] = -1;

    SunucuMesaji(playerid, "Ýþten ayrýldýn.");

    return 1;
}

flags:meslekisbasi(CMD_USER);
CMD:meslekisbasi(playerid, params[])
{
    if(PlayerInfo[playerid][pFactionDuty])return
        SunucuMesaji(playerid, "Zaten oluþum iþbaþýndasýn.");

    if(PlayerInfo[playerid][pJob] == 2 || PlayerInfo[playerid][pJob] == 1)
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if(!IsTaxi(vehicleid) && PlayerInfo[playerid][pJob] == 2)return
            SunucuMesaji(playerid, "Takside deðilsin.");

        if(!InTowTruck(playerid) && PlayerInfo[playerid][pJob] == 1)return
            SunucuMesaji(playerid, "Tow Truck'ýn içerisinde deðilsin.");

        PlayerInfo[playerid][pJobDuty] = !PlayerInfo[playerid][pJobDuty];
        //PlayerInfo[playerid][pJobTime] = gettime() + (60 * 25);

        SendClientMessageEx(playerid, COLOR_GREEN, (PlayerInfo[playerid][pJobDuty]) ? ("Ýþbaþýna geçtin.") : ("Ýþbaþýndan çýktýn."));
    }
    else return
        SunucuMesaji(playerid, "Tamirci veya taksici deðilsin.");

    return 1;
}

CMD:tamiret(playerid, params[])
{
    new price, vehicleid = GetPlayerVehicleID(playerid), repairType, id;

    if(PlayerInfo[playerid][pJob] != 1)return
        HataMesajiC(playerid, "Tamirci deðilsin.");

    if(InTowTruck(playerid) <= 0)return
        HataMesajiC(playerid, "Tow Truck'ýn içerisinde deðilsin.");

    if(sscanf(params, "k<m>dd", id, repairType, price))
    {
        KullanimMesajiC(playerid, "/tamiret [id/isim] [servistipi] [fiyat]");
        SendClientMessage(playerid, COLOR_GREY, "[Servisler] 1: Motor Tamiri - 2: Dýþ Tamir - 3: Motor Ömrü - 4: Akü Ömrü");
        SendClientMessage(playerid, COLOR_ERROR, "Motor Tamiri (1): {AFAFAF}Aracýn HP'sini yeniler. (4 parça)");
        SendClientMessage(playerid, COLOR_ERROR, "Dýþ tamir (2): {AFAFAF}Aracýn dýþ görünüþünü yeniler. (4 parça)");
        SendClientMessage(playerid, COLOR_ERROR, "Motor Ömrü (3): {AFAFAF}Aracýn motor ömrünü 1000 olarak ayarlar. (100 parça)");
        SendClientMessage(playerid, COLOR_ERROR, "Akü Ömrü (4): {AFAFAF}Aracýn akü ömrünü 1000 olarak ayarlar. (100 parça)");
	}

    if(repairType < 1 || repairType > 4)return
        HataMesajiC(playerid, "Servis tipi 1 ile 4 arasýnda olmalýdýr, aksi tipler kullanýlamaz.");

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
		return HataMesaji(playerid, "Aracý tamir etmek için yeterli parça bulunmuyor. (%d)", parcasayi);

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesajiC(playerid, "Geçersiz ID.");

    if(!ProxDetectorS(20.0, playerid, id) || GetPlayerState(id) != PLAYER_STATE_DRIVER)return
        HataMesajiC(playerid, "Oyuncu sizden uzakta veya bir araçta deðil.");

	if(Vehicle_IsOwner(id, GetPlayerVehicleID(id), false) == 0)
		return HataMesajiC(playerid, "Ýstek göndermek istediðiniz oyuncu araç veya anahtar sahibi deðil.");

    if(price < 1 || price > 5000)return
        HataMesajiC(playerid, "Geçersiz tutar. ($1 - $5000)");

    if(PlayerInfo[id][pCash] < price)return
        HataMesaji(playerid, "Bu oyuncunun yeterli parasý yok. ($%d)", price);

    if(PlayerInfo[id][pRequestRepair] == playerid) return
        HataMesajiC(playerid, "Bir kullanýcýya tamir isteði gönderdin, /tamiriptal komutuyla onu iptal etmelisin.");

    PlayerInfo[id][pRequestRepair] = playerid;
    PlayerInfo[id][pRepairType] = repairType;
    PlayerInfo[id][pRepairPrice] = price;

    new yazi[60];
    switch(repairType)
	{
        case 1: format(yazi, sizeof(yazi), "iç tamir iþlemi");
		case 2: format(yazi, sizeof(yazi), "dýþ tamir iþlemi");
        case 3: format(yazi, sizeof(yazi), "motor ömrünü yükseltmek");
        case 4: format(yazi, sizeof(yazi), "akü ömrünü yükseltmek");
    }
    SunucuMesaji(id, "%s adlý tamirci $%d karþýlýðýnda %s için izin istiyor. (/kabulet tamir)", ReturnRoleplayName(playerid), price, yazi);
    SunucuMesaji(playerid, "Tamir isteðiniz %s kiþisine $%d olarak gönderildi.", ReturnRoleplayName(id), price);
    return 1;
}

CMD:parcaalani(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");

    if(PlayerInfo[playerid][pJob] != 1)return
        SunucuMesaji(playerid, "Tamirci deðilsin.");

    if(!InTowTruck(playerid))return
        SunucuMesaji(playerid, "Tow Truck'ýn içerisinde deðilsin.");

    new industryID = Pickup_Nearest(playerid, ELEMENT_COMPANY);

    if(industryID == -1 || CompanyInfo[industryID][cBuyType] != VEHICLE_PART)
    {
        AC_SetPlayerCheckpoint(playerid, CompanyInfo[11][cBuyPosX], CompanyInfo[11][cBuyPosY], CompanyInfo[11][cBuyPosZ], 2.0);
        return HataMesajiC(playerid, "Tamirciler için parça alma alanýnda deðilsin. Konumu haritanda iþaretlendi.");
    }

    pc_cmd_koli(playerid, "satinal");

    return 1;
}

CMD:meslekduyuru(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	new slot = Inventory_HasItem(playerid, "Cep Telefonu", ITEM_PHONE);
    if(slot == -1) return HataMesajiC(playerid, "Cep telefonun yok, reklam vermek için telefona ihtiyacýn var.");

	if(sscanf(params, "d", slot)) return KullanimMesajiC(playerid, "/meslekduyuru [telefon slot id]");

	slot--;

	new listid = PlayerInfo[playerid][pInvList][slot];

	if(InventoryObjects[listid][invType] != ITEM_PHONE)return HataMesajiC(playerid, "Seçtiðiniz envanter slotunda cep telefonu yok.");

	if(!PlayerInfo[playerid][pInvExtra][slot]) return HataMesajiC(playerid, "Cep telefonun kapalýyken reklam veremezsin.");

	if(PlayerInfo[playerid][pFactionDuty]) return SunucuMesajiC(playerid, "Oluþum iþ baþýndayken bu komutu kullanamazsýn.");
	if(PlayerInfo[playerid][pJobTime] - gettime() > 0) return HataMesaji(playerid, "Bu komutu kulanmak için %d saniye bekleyin.", PlayerInfo[playerid][pJobTime] - gettime());
	if(PlayerInfo[playerid][pJob] != 2 && PlayerInfo[playerid][pJob] != 1) return HataMesajiC(playerid, "Bu komutu kullanamazsýn.");
	if(!InTowTruck(playerid) && !IsTaxi(vehicleid)) return HataMesajiC(playerid, "Meslek aracýnda deðilsin.");

	foreach(new j : Player)
	{
		if(!IsPlayerConnected(j) || !PlayerInfo[j][pNews])continue;
		if(PlayerInfo[playerid][pJob] == 2) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s adlý taksici iþbaþýnda. (Ýletiþim: %d)", ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
        if(PlayerInfo[playerid][pJob] == 1) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s adlý tamirci iþbaþýnda. (Ýletiþim: %d)", ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
	}
	PlayerInfo[playerid][pJobTime] = gettime() + (60 * 15);
	return 1;
}

// Taxi Driver Job

flags:taksimetre(CMD_USER);
CMD:taksimetre(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");

    new price, id,
        vehicleid = GetPlayerVehicleID(playerid);
		
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return HataMesajiC(playerid, "Araçta sürücü deðilsiniz.");

    if(!IsPlayerInAnyVehicle(playerid) || !IsTaxi(vehicleid))return
        SunucuMesaji(playerid, "Taksi içerisinde deðilsin.");

    if(PlayerInfo[playerid][tPassenger] != -1)return EndTaxi(playerid, PlayerInfo[playerid][tPassenger]);

    if(sscanf(params, "k<m>d", id, price))return
        KullanimMesajiC(playerid, "/taksimetre [id] [ücret/km]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesajiC(playerid, "Geçersiz ID.");

    if(GetPlayerVehicleID(id) != vehicleid)return
        SunucuMesaji(playerid, "Bu oyuncu senin taksinde deðil.");

    if(price < 0 || price > 6)return
        SunucuMesaji(playerid, "Geçersiz tutar. ($0 - $6)");

    PlayerInfo[id][pTaxPrice] = price;
    PlayerInfo[id][pTaxRequest] = playerid;

    BasariMesaji(id, "%s sana $%d / km vermen karþýlýðýnda yolcusu olabileceðini söylüyor. Eðer istiyorsan /kabulet taksi kullan.", ReturnRoleplayName(playerid), price);
    SunucuMesaji(playerid, "%s kiþisine $%d / km karþýlýðýnda yolculuk teklifi yolladýn.", ReturnRoleplayName(id), price);

    return 1;
}


// Fishing Job

flags:baliktut(CMD_USER);
flags:baliksat(CMD_USER);
flags:balikyemal(CMD_USER);

CMD:balik(playerid,params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");
	new secenek[14], slot, oyuncuid;
	if(sscanf(params, "s[14]D(-1)U(-1)", secenek, slot, oyuncuid)) return KullanimMesaji(playerid, "/balik [tut/sat/durum/hepsinisat/birak/hepsinibirak/pisir/liste/ye]& /balikyemal");
	if(isnull(params)) return KullanimMesajiC(playerid, "/balik [tut/sat/durum] & /balikyemal");

	if (!strcmp(secenek, "tut"))
	{
		return pc_cmd_baliktut(playerid, "");
	}

	else if (!strcmp(secenek, "sat"))
	{
		if(slot == -1) return KullanimMesaji(playerid, "/balik sat [slot] Listeyi görmek için /balik liste yazabilirsin.");
		if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");

	    if(!IsPlayerInAnyVehicle(playerid)) pc_cmd_animdurdur(playerid, NULL);
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid, 8);
		
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 375.116790, -2055.140136, 8.015625) && PlayerInfo[playerid][pBalik] > 0)
		{
			if(!BalikVarMi(playerid))return
				SunucuMesaji(playerid, "Satýlacak balýk bulunmuyor.");
				
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
					SunucuMesaji(playerid, "Beþ dakikada bir balýk satabilirsin.");

				SendClientMessageEx(playerid, COLOR_WHITE, "Yüzde kýrk zararla balýðýný Star Fish'de ya da kayýp yaþamadan Ocean Docks'da satabilirsin.");

				return 1;// AC_SetPlayerCheckpoint(playerid, SELL_X, SELL_Y, SELL_Z, 2.0);
			}

			if(!BalikVarMi(playerid))return
				SunucuMesaji(playerid, "Satýlacak balýk bulunmuyor.");
				
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
	    if(slot == -1) return KullanimMesaji(playerid, "/balik birak [slot] Listeyi görmek için /balik liste yazabilirsin.");
	    new sonuc = BalikCikar(playerid, slot);
	    if(sonuc) {
	        PlayerAME(playerid, "balýk atar.");
	        SunucuMesaji(playerid, "%d slotundaki balýðý attýn.", slot);
	    } else return HataMesaji(playerid, "Belirttiðin slotta zaten bir balýk yok.");
	}
	else if (!strcmp(secenek, "hepsinibirak")) {
	    if(!BalikVarMi(playerid)) return HataMesaji(playerid, "Zaten balýðýn yok.");
	    TumBaliklariCikar(playerid);
	    PlayerAME(playerid, "tüm balýklarýný atar.");
	    SunucuMesaji(playerid, "Tüm balýklarýný attýn.");
	}
	else if (!strcmp(secenek, "pisir")) {
	    if(!BalikVarMi(playerid)) return HataMesaji(playerid, "Zaten balýðýn yok.");
	    if(slot == -1) return KullanimMesaji(playerid, "/balik pisir [slot] Listeyi görmek için /balik liste yazabilirsin.");
		SetPVarInt(playerid, "BalikSlot", slot);
		SetPVarInt(playerid, "BalikPisirecek", 1);
		SelectObject(playerid);
		SunucuMesaji(playerid, "Üstünde piþirmek istediðiniz kamp ateþini fare yardýmýyla seçin.");
	}
	else if (!strcmp(secenek, "liste")) {
	    if(PlayerInfo[playerid][pBalikListe] != 0) return HataMesaji(playerid, "Listeye 20 saniyede bir bakabilirsin.");
		if(!BalikVarMi(playerid)) return HataMesaji(playerid, "Balýðýn yok.");
		BalikListeGoster(playerid);
		PlayerInfo[playerid][pBalikListe] = 20;
	}
	else if (!strcmp(secenek, "ye")) {
		SetPVarInt(playerid, "BalikYiyecek", 1);
	    SelectObject(playerid);
	    SunucuMesaji(playerid, "Balýk yemek istediðiniz kamp ateþini fare yardýmýyla seçin.");
	}
	else HataMesajiC(playerid, "Hatalý ya da geçersiz bir iþlem belirttiniz.");
	return 1;
}

CMD:balikdurum(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");

	new satis = BalikUcret(playerid);
	SunucuMesaji(playerid, "Balýkçýlýk > Balýk[%i] - Balýk Yemi[%i] - Kazanacaðýnýz Ücret[$%i]", KacBalikVar(playerid), PlayerInfo[playerid][pBalikYemi], satis);
	return 1;
}

flags:agal(CMD_USER);
CMD:agal(playerid) {
    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");
	if(!IsPlayerInRangeOfPoint(playerid, 1.0, 359.916290, -2032.155029, 7.835937))
	   	return HataMesajiC(playerid, "Að satýn alma noktasýnda deðilsiniz.");

	if(PlayerInfo[playerid][pBalikAgi]) return HataMesaji(playerid, "Zaten aðýnýz var.");
	
	if(1000 > PlayerInfo[playerid][pCash])
		return HataMesaji(playerid, "Að satýn almak için üzerinizde en az $1000 bulunmalýdýr.");

	PlayerInfo[playerid][pBalikAgi] = 1;
	OAC_GivePlayerMoney(playerid, -1000);
	BasariMesaji(playerid, "Balýk aðý aldýnýz ve satýcýya $1000 para verdiniz.");
	return 1;
}

CMD:yemal(playerid, params[])return pc_cmd_balikyemal(playerid, "");
CMD:balikyemal(playerid, params[])
{
	if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");
	if(!IsPlayerInRangeOfPoint(playerid, 1.0, 359.916290, -2032.155029, 7.835937))
	   	return HataMesajiC(playerid, "Yem satýn alma noktasýnda deðilsiniz.");

	new yemucret, yemadet;

	if(sscanf(params, "d", yemadet))
	    return KullanimMesajiC(playerid, "/balik yem [miktar] (Yem baþýna $1 / Max: 5000 yem)");

	if(PlayerInfo[playerid][pBalikYemi] >= 5001)
	{
	    PlayerInfo[playerid][pBalikYemi] = 5000;
		HataMesajiC(playerid, "Üzerinizde bulunan fazla yemlere sistem tarafýndan el koyuldu.");
	}
	if(PlayerInfo[playerid][pBalikYemi] == 5000)
	{
		return HataMesajiC(playerid, "Üzerinizde en fazla 5000 tane balýk yemi bulunabilir.");
	}

	if(yemadet <= 0) return HataMesajiC(playerid, "Geçersiz deðer girdin.");

	if(yemadet > 5000) return HataMesajiC(playerid, "Geçersiz deðer giriþi.");

	yemucret = yemadet * 1;

	if(yemucret > PlayerInfo[playerid][pCash])
		return HataMesaji(playerid, "Yem satýn almak için üzerinizde en az $%i bulunmalýdýr.", yemucret);

	PlayerInfo[playerid][pBalikYemi] += yemadet;
	OAC_GivePlayerMoney(playerid, -yemucret);
	BasariMesaji(playerid, "%d adet balýk yemi aldýnýz ve satýcýya $%d para verdiniz.", yemadet, yemucret);
	return 1;
}

flags:agat(CMD_USER);
CMD:agat(playerid) {
    if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT || Faction_GetType(PlayerInfo[playerid][pFaction]) == LSNN)return
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");

    new fishZone = GetFishingZone(playerid, true);
    new pointZone = GetFishingZone(playerid, false);

    if(pointZone == -1 && fishZone == -1)return
        SunucuMesaji(playerid, "Burada balýk tutamazsýn. Star Fish iskelesindeki oltalara gitmelisin.");

    if(PlayerInfo[playerid][pBalikTutuyor]) return
        SunucuMesaji(playerid, "Lütfen bekleyin, balýk tutma iþleminiz devam ediyor.");

	if(PlayerInfo[playerid][pBalikAgi] == 0)
			return HataMesajiC(playerid, "Üzerinizde að bulunmuyor.");

    new Float:X, Float:Y, Float:Z;
    new vid = GetPlayerVehicleID(playerid);
	if(vid == -1 || GetMaxFishes(playerid, VehicleInfo[vid][vModel]) == 0) return HataMesaji(playerid, "Að atabileceðiniz bir botta deðilsiniz.");
	
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
            SunucuMesaji(playerid, "Balýk tutmak için Star Fish'e gidip komutu tekrar kullanýn.");

        if(PlayerInfo[playerid][pZone][fishZone] >= 50)return
            SunucuMesaji(playerid, "Ayný yerde fazla balýk tutamazsýn, kýrmýzý noktaya git.");

        AC_DisablePlayerCheckpoint(playerid);
        PlayerInfo[playerid][pZone][fishZone]++;
    }

	new ayaktabalik = FISHES_FOOT;
	if(PlayerInfo[playerid][pPremium] == 4) ayaktabalik += 10;
	if(PlayerInfo[playerid][pPremium] == 5) ayaktabalik += 20;
    new maxTotalFish = (pointZone != -1 && fishZone != -1) ? ayaktabalik : GetMaxFishes(playerid, VehicleInfo[vid][vModel]);

    if(KacBalikVar(playerid) >= maxTotalFish)return
        HataMesaji(playerid, "%d'den fazla balýk taþýyamazsýn.", maxTotalFish);

    PlayerAME(playerid, "aðýný denize býrakýr.");
    SunucuMesaji(playerid, "Balýk tutuluyor, lütfen bekleyin.");
    
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
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");

    new fishZone = GetFishingZone(playerid, true);
    new pointZone = GetFishingZone(playerid, false);

    if(pointZone == -1 && fishZone == -1)return
        SunucuMesaji(playerid, "Burada balýk tutamazsýn. Star Fish iskelesindeki oltalara gitmelisin.");

    if(PlayerInfo[playerid][pBalikTutuyor]) return
        SunucuMesaji(playerid, "Lütfen bekleyin, balýk tutma iþleminiz devam ediyor.");

	if(PlayerInfo[playerid][pBalikYemi] == 0)
			return HataMesajiC(playerid, "Üzerinizde balýk yemi bulunmuyor.");

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
            SunucuMesaji(playerid, "Balýk tutmak için Star Fish'e gidip komutu tekrar kullanýn.");

        if(PlayerInfo[playerid][pZone][fishZone] >= 50)return
            SunucuMesaji(playerid, "Ayný yerde fazla balýk tutamazsýn, kýrmýzý noktaya git.");

        AC_DisablePlayerCheckpoint(playerid);
        PlayerInfo[playerid][pZone][fishZone]++;
    }

	new ayaktabalik = FISHES_FOOT;
	if(PlayerInfo[playerid][pPremium] == 4) ayaktabalik += 10;
	if(PlayerInfo[playerid][pPremium] == 5) ayaktabalik += 20;
    new maxTotalFish = (pointZone != -1 && fishZone != -1) ? ayaktabalik : GetMaxFishes(playerid, VehicleInfo[vid][vModel]);

    if(KacBalikVar(playerid) >= maxTotalFish)return
        HataMesaji(playerid, "%d'den fazla balýk taþýyamazsýn.", maxTotalFish);

    if(PlayerObjects_HasObject(playerid, "Olta") == 0) return HataMesajiC(playerid, "Elinde bir olta yok, /aksesuar ile eline alabilirsin. Eðer oltaya sahip deðilsen bir kýyafet dükkanýna git.");

    PlayerAME(playerid, "oltasýný denize sallar.");
    SunucuMesaji(playerid, "Balýk tutuluyor, lütfen bekleyin.");
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
 		SunucuMesaji(playerid, "Bulunduðun faction bu komutu kullanmaný desteklemiyor.");

    if(!IsPlayerInAnyVehicle(playerid)) pc_cmd_animdurdur(playerid, NULL);
    if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid, 8);
	
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 375.116790, -2055.140136, 8.015625) && PlayerInfo[playerid][pBalik] > 0)
	{
		if(!BalikVarMi(playerid))return
			SunucuMesaji(playerid, "Satýlacak balýk bulunmuyor.");

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
				SunucuMesaji(playerid, "Beþ dakikada bir balýk satabilirsin.");

			SendClientMessageEx(playerid, COLOR_WHITE, "Yüzde kýrk zararla balýðýný Star Fish'de ya da kayýp yaþamadan Ocean Docks'da satabilirsin.");

			return 1;//AC_SetPlayerCheckpoint(playerid, SELL_X, SELL_Y, SELL_Z, 2.0);
		}

		if(!BalikVarMi(playerid))return
			SunucuMesaji(playerid, "Satýlacak balýk bulunmuyor.");

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
