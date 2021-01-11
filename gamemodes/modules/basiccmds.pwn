enum swearenum
{
	xisim[64]
};

new swear[][swearenum] =
{
	{"orospu"},
	{"piç"},
	{"kaltak"},
	{"deagle"},
	{"m4"},
	{"ak47"},
	{"ak-47"},
	{"deagle"},
	{"mp5"},
	{"mp-5"},
	{"shotgun"},
	{"trisha"},
	{"okcity"},
	{"rascalov"},
	{"daniels"},
	{"vercetti"},
	{"rapid"},
	{"chum"},
	{"tipini sikiyim aq bebesi"},
	{"escapist"},
	{"loansharkrolla"},
	{"donelly"},
	{"tereddütümyok"},
	{"winger"},
	{"pistolero"},
	{"oç"},
	{"amk"},
	{"allah"},
	{"amin"},
	{"calderon"},
	{"gelmiþinizi geçmiþinizi"},
	{"sikiyim"},
	{"sikerler"},
	{"sikik"},
	{"fuck"},
	{"sacountyrp"},
	{"vendetta"},
	{"rina"},
	{"wonderland"},
	{"eroin"},
	{"kokain"},
	{"ectasy"},
	{"lsd"},
	{"pcp"},
	{"crack"},
	{"amfetamin"},
	{"purple drank"},
	{"metamfetamin"},
	{"uyuþturucu"},
	{"silah"},
	{"oyuncak tabanca"},
	{"su tabancasý"},
	{"köpeðim kayboldu"},
	{"amcýk"},
	{"kodein"},
	{"siker"},
	{"promethazine"},
	{"lsrp"},
	{"habibi"},
	{"ekber"},
	{"pak kol"},
	{"uluonder allah"},
	{"keldani"},
	{"porno"},
	{"þerefsiz"},
	{"ahlaksýz"},
	{"cibiliyetsiz"},
	{"yarrak"},
	{"roleplay"},
	{"yarak"},
	{"cihad"},
	{"trolling"},
	{"aq"},
	{"amq"},
	{"sikim"},
	{"orusbu"},
	{"orosbu"},
	{"server"},
	{"tayyip"},
	{"atatürk"},
	{"inþallah"},
	{"eyvallah"},
	{"cohen"},
	{"cohentroll"},
	{"caparol"},
	{"evilpimp"},
	{"hakan"},
	{"ddos"},
	{"çakýr mafyasý"},
	{"yavþak"},
	{"salak"},
	{"aptal"},
	{"gerizekalý"},
	{"pezo"},
	{"pezevenk"},
	{"abbas"},
	{"yanbasan"},
	{"gavat"},
	{"eolo"},
	{"kaanolo"},
	{"kaan"},
	{"bayrakdar"},
	{"dduck"},
	{"koli kapasitesi"},
	{"selamun aleyküm"},
	{"aleyküm selam"},
	{"nitro"},
	{"nitröz"},
	{"nos"},
	{"güçlendirici"},
	{"ananisikerim"},
	{"ananýsýkerým"},
	{"ananýsikerim"}
};

CMD:vwduzelt(playerid, params[])return pc_cmd_bugkurtar(playerid, params);
CMD:intduzelt(playerid, params[])return pc_cmd_bugkurtar(playerid, params);
CMD:vwsifirla(playerid, params[])return pc_cmd_bugkurtar(playerid, params);
CMD:intsifirla(playerid, params[])return pc_cmd_bugkurtar(playerid, params);
CMD:vwkurtar(playerid, params[])return pc_cmd_bugkurtar(playerid, params);
CMD:intkurtar(playerid, params[])return pc_cmd_bugkurtar(playerid, params);
CMD:bugkurtar(playerid, params[])
{
    if(PlayerInfo[playerid][pJailTime] > 1 && !PlayerInfo[playerid][pJailC])
		return SunucuMesaji(playerid, "Hapisteyken bu sistemden yararlanamazsýn.");

	new houseid = GetPlayerHouse(playerid, true);
	new buildingid = GetPlayerBuilding(playerid, true);
	new Float:pX, Float:pY, Float:pZ;
	GetPlayerPos(playerid, pX, pY, pZ);

	if(PlayerInfo[playerid][pJailTime] > 1 && GetPVarInt(playerid, "JailBugKurtar") < 1)
	{
		SetPlayerToJailPos(playerid);
		SetPVarInt(playerid, "JailBugKurtar", 1);
		SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s hapisteyken /bugkurtar komutunu kullandý.", ReturnRoleplayName(playerid));
		BasariMesaji(playerid, "Bulunduðunuz bug durumundan kurtuldunuz.");
	}
    else if(GetPlayerHouse(playerid, true) != -1 && houseid != -1 && !IsPlayerInRangeOfPoint(playerid, 100.0, HouseInfo[houseid][hPosIntX], HouseInfo[houseid][hPosIntY], HouseInfo[houseid][hPosIntZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[houseid][hWorld] && GetPlayerInterior(playerid) == HouseInfo[houseid][hInterior])
    {
		if(PlayerInfo[playerid][pJailTime] > 1) return HataMesajiC(playerid, "Bu komutu kullanamazsýn.");
		SetFreezePos(playerid, HouseInfo[houseid][hPosIntX], HouseInfo[houseid][hPosIntY], HouseInfo[houseid][hPosIntZ]);
		SetPlayerInterior(playerid, HouseInfo[houseid][hInterior]);
		AC_SetPlayerVirtualWorld(playerid, HouseInfo[houseid][hWorld]);
		LogYaz(playerid, "/evkurtar", -1);
		printf("%s /evkurtar yapti.", ReturnRoleplayName(playerid));
		SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s adlý oyuncu /evkurtar komutunu kullandý.", ReturnRoleplayName(playerid));
    }
    else if(GetPlayerBuilding(playerid, true) != -1 && buildingid != -1 && !IsPlayerInRangeOfPoint(playerid, 100.0, BuildingInfo[buildingid][bPosIntX], BuildingInfo[buildingid][bPosIntY], BuildingInfo[buildingid][bPosIntZ]) && GetPlayerVirtualWorld(playerid) == BuildingInfo[buildingid][bWorld] && GetPlayerInterior(playerid) == BuildingInfo[buildingid][bInterior])
	{
		if(PlayerInfo[playerid][pJailTime] > 1) return HataMesajiC(playerid, "Bu komutu kullanamazsýn.");
		SetFreezePos(playerid, BuildingInfo[buildingid][bPosIntX], BuildingInfo[buildingid][bPosIntY], BuildingInfo[buildingid][bPosIntZ]);
		SetPlayerInterior(playerid, BuildingInfo[buildingid][bInterior]);
		AC_SetPlayerVirtualWorld(playerid, BuildingInfo[buildingid][bWorld]);
		LogYaz(playerid, "/isletmekurtar", -1);
		printf("%s /isletmekurtar yapti.", ReturnRoleplayName(playerid));
		SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s adlý oyuncu /isletmekurtar komutunu kullandý.", ReturnRoleplayName(playerid));
	}
	else if(GetPlayerVirtualWorld(playerid) != 0 && GetPlayerInterior(playerid) == 0 && !YasakliBolgeler(playerid) && pZ < 200.0)
	{
		if(PlayerInfo[playerid][pJailTime] > 1) return HataMesajiC(playerid, "Bu komutu kullanamazsýn.");
	    SendClientMessageEx(playerid, COLOR_ADMIN, "VW deðeriniz sýfýrlandý.");
		AC_SetPlayerVirtualWorld(playerid, 0);
		LogYaz(playerid, "/vwsifirla", -1);
		printf("%s VW sifirladi.", ReturnRoleplayName(playerid));
		SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s adlý oyuncu /vwsifirla komutunu kullandý.", ReturnRoleplayName(playerid));
	}
	else if(GetPlayerVirtualWorld(playerid) != 0 && GetPlayerInterior(playerid) == 0 && !YasakliBolgeler(playerid) && pZ >= 200.0)
	{
		if(PlayerInfo[playerid][pJailTime] > 1) return HataMesajiC(playerid, "Bu komutu kullanamazsýn.");
		SendClientMessageEx(playerid, COLOR_ADMIN, "VW deðerini sýfýrlamak için Los Santos'a ýþýnlandýn.");
		SetPlayerPos(playerid, 1529.4974,-1676.6726,13.3828);
		SetPlayerInterior(playerid, 0);
		AC_SetPlayerVirtualWorld(playerid, 0);
		printf("%s VW kurtardi.", ReturnRoleplayName(playerid));
		LogYaz(playerid, "/vwkurtar", -1);
		SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s adlý oyuncu /vwkurtar komutunu kullandý.", ReturnRoleplayName(playerid));
	}
	else if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) != 0 && !YasakliBolgeler(playerid) && pZ >= 200.0)
	{
		if(PlayerInfo[playerid][pJailTime] > 1) return HataMesajiC(playerid, "Bu komutu kullanamazsýn.");
		SendClientMessageEx(playerid, COLOR_ADMIN, "Interior deðerini sýfýrlamak için Los Santos'a ýþýnlandýn.");
		SetPlayerPos(playerid, 1529.4974,-1676.6726,13.3828);
		SetPlayerInterior(playerid, 0);
		AC_SetPlayerVirtualWorld(playerid, 0);
		printf("%s INT kurtardi.", ReturnRoleplayName(playerid));
		LogYaz(playerid, "/intkurtar", -1);
		SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s adlý oyuncu /intkurtar komutunu kullandý.", ReturnRoleplayName(playerid));
	}
	else if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) != 0 && !YasakliBolgeler(playerid) && pZ < 200.0)
	{
		if(PlayerInfo[playerid][pJailTime] > 1) return HataMesajiC(playerid, "Bu komutu kullanamazsýn.");
	    SendClientMessageEx(playerid, COLOR_ADMIN, "Interior deðeriniz sýfýrlandý.");
		SetPlayerInterior(playerid, 0);
		LogYaz(playerid, "/intsifirla", -1);
		printf("%s INT sifirladi.", ReturnRoleplayName(playerid));
		SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s adlý oyuncu /intsifirla komutunu kullandý.", ReturnRoleplayName(playerid));
	}
	else if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0 && !YasakliBolgeler(playerid) && pZ > 950.0)
	{
		if(PlayerInfo[playerid][pJailTime] > 1) return HataMesajiC(playerid, "Bu komutu kullanamazsýn.");
	    SendClientMessageEx(playerid, COLOR_ADMIN, "Bulunduðun bug durumundan kurtuldun.");
		SetPlayerPos(playerid, 1529.4974,-1676.6726,13.3828);
		SetPlayerInterior(playerid, 0);
		AC_SetPlayerVirtualWorld(playerid, 0);
		LogYaz(playerid, "/intsifirla", -1);
		printf("%s INT sifirladi.", ReturnRoleplayName(playerid));
		SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s adlý oyuncu /vwintkurtar komutunu kullandý.", ReturnRoleplayName(playerid));
	}
	else return HataMesaji(playerid, "Bu komutu þu anda kullanamazsýn, daha sonra tekrar deneyin.");
	
	if(PlayerInfo[playerid][pDeath] > 0)
	{
		TogglePlayerControllable(playerid, true);
		PlayerInfo[playerid][pFreezed] = 0;
		PlayerInfo[playerid][pDeath] = 0;
		AC_SetPlayerHealth(playerid, 100);
		ExecuteShots[playerid] = 0;
		DestroyDynamic3DTextLabelEx(PlayerInfo[playerid][pNameTag]);
		SetCameraBehindPlayer(playerid);
		DeletePVar(playerid, "OyuncuOlduren");
		DeletePVar(playerid, "OyuncuOlu");
		PlayerInfo[playerid][pDeathTime] = 0;
		ClearAnimations(playerid, 1);
		//Damages_Reset(playerid);
		PlayerInfo[playerid][pLegHit] = 0;
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		PlayerInfo[playerid][pLoopAnim] = false;
		PlayerInfo[playerid][pTedaviSure] = 0;
		PlayerInfo[playerid][pAgirYarali] = 0;
		PlayerTextDrawHide(playerid, PlayerInfo[playerid][pTextdraws][0]);
	}
	return 1;
}


CMD:bugkurtar2(playerid) {
	if(PlayerInfo[playerid][pBugKurtar])return HataMesajiC(playerid, "Sonraki paydaye kadar ya da relog atana kadar bu komutu tekrar kullanamazsýn.");
	new Float:oX, Float:oY, Float:oZ;
	GetPlayerPos(playerid, oX, oY, oZ);
	SetPlayerPos(playerid, oX, oY, oZ + 2.0);
	LogYaz(playerid, "/bugkurtar2", -1);
	printf("%s /bugkurtar2 yapti.", ReturnRoleplayName(playerid));
	PlayerInfo[playerid][pBugKurtar] = 1;
	SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s adlý oyuncu /bugkurtar2 (slap) komutunu kullandý.", ReturnRoleplayName(playerid));
	return 1;
}

CMD:bugkurtar3(playerid) {
	if(PlayerInfo[playerid][pBugKurtar])return HataMesajiC(playerid, "Sonraki paydaye kadar ya da relog atana kadar bu komutu tekrar kullanamazsýn.");
	new Float:oX, Float:oY, Float:oZ;
	GetPlayerPos(playerid, oX, oY, oZ);
	SetPlayerPos(playerid, oX, oY, oZ - 2.0);
	LogYaz(playerid, "/bugkurtar2", -1);
	printf("%s /bugkurtar2 yapti.", ReturnRoleplayName(playerid));
	PlayerInfo[playerid][pBugKurtar] = 1;
	SendAdminAlert(true, COLOR_ADMIN, "AdmWarn: %s adlý oyuncu /bugkurtar3 (belt) komutunu kullandý.", ReturnRoleplayName(playerid));
	return 1;
}

//

CMD:bagis(playerid, params[])
{
    new amount;

    if(sscanf(params, "k<m>", amount))return
        KullanimMesajiC(playerid, "/bagis [miktar]");

    if(amount < 1 || amount > PlayerInfo[playerid][pCash])return
        SunucuMesaji(playerid, "Yeterli paran yok.");
		
    OAC_GivePlayerMoney(playerid, -amount);
	Faction_GovernmentCash(amount);

    BasariMesaji(playerid, "%s, hükümet kasasýna $%d baðýþýn eklendi. (Tarih: %s)", ReturnRoleplayName(playerid), amount, ReturnDate());
    return 1;
}


CMD:lspdbagis(playerid, params[])
{
    new amount;

    if(sscanf(params, "k<m>", amount))return
        KullanimMesajiC(playerid, "/lspdbagis [miktar]");

    if(amount < 1 || amount > PlayerInfo[playerid][pCash])return
        SunucuMesaji(playerid, "Yeterli paran yok.");
    new factionid = -1;
	for(new f; f < MAX_FACTIONS; f++)
    {
    	if(Faction_GetType(f) == POLICE) {
    		factionid = f;
    		break;
    	}
    }	
    if(factionid == -1) return HataMesajiC(playerid, "Bir hata oluþtu, lütfen Developer ekibiyle iletiþime geçin.");
    OAC_GivePlayerMoney(playerid, -amount);
	FactionInfo[factionid][fCash] += amount;

    BasariMesaji(playerid, "%s, LSPD kasasýna $%d baðýþýn eklendi. (Tarih: %s)", ReturnRoleplayName(playerid), amount, ReturnDate());
    return 1;
}

CMD:lsfdbagis(playerid, params[])
{
    new amount;

    if(sscanf(params, "k<m>", amount))return
        KullanimMesajiC(playerid, "/lsfdbagis [miktar]");

    if(amount < 1 || amount > PlayerInfo[playerid][pCash])return
        SunucuMesaji(playerid, "Yeterli paran yok.");
		
    new factionid = -1;
	for(new f; f < MAX_FACTIONS; f++)
    {
    	if(Faction_GetType(f) == MEDICAL) {
    		factionid = f;
    		break;
    	}
    }	
    if(factionid == -1) return HataMesajiC(playerid, "Bir hata oluþtu, lütfen Developer ekibiyle iletiþime geçin.");
    OAC_GivePlayerMoney(playerid, -amount);
	FactionInfo[factionid][fCash] += amount;

    BasariMesaji(playerid, "%s, LSFD kasasýna $%d baðýþýn eklendi. (Tarih: %s)", ReturnRoleplayName(playerid), amount, ReturnDate());
    return 1;
}

CMD:paraver(playerid, params[])
{
    new id, amount;

    if(sscanf(params, "k<m>d", id, amount))return
        KullanimMesajiC(playerid, "/paraver [id/isim] [miktar]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesajiC(playerid, "Geçersiz ID.");

    if(!ProxDetectorS(5.0, playerid, id))return
        SunucuMesajiC(playerid, "Oyuncuya yakýn deðilsin.");

    if(amount < 1 || amount > PlayerInfo[playerid][pCash])return
        SunucuMesaji(playerid, "Yeterli paran yok.");

    OAC_GivePlayerMoney(id, amount);
    OAC_GivePlayerMoney(playerid, -amount);

    BasariMesaji(id, "%s sana $%d verdi.", ReturnRoleplayName(playerid, true), amount);
    SunucuMesaji(playerid, "$%d miktarda parayý %s kiþisine verdin.", amount, ReturnRoleplayName(id, true));

    PlayerMEPlayer(playerid, id, "kiþisine para verdi");

	if(amount > 3000)
	{
	    LogYaz(playerid, "/paraver", id, amount);
	}

	if(amount > 7000)
	{
    	SendAdminAlert(false, COLOR_YELLOW, "AdmWarn: %s kiþisi $%d miktarda parayý %s kiþisine verdi.", ReturnRoleplayName(playerid), amount, ReturnRoleplayName(id));
	}

    return 1;
}

// Ev Hýrsýzlýðý

flags:evkontrol(CMD_USER);
CMD:evkontrol(playerid, params[])
{
	//if(PlayerInfo[playerid][pFaction] == -1)
		//return HataMesaji(playerid, "Bu sistemden yararlanamazsýnýz.");
		
	if(GetTickCount() - PlayerInfo[playerid][pSendedCare] < 3000)
		return HataMesajiC(playerid, "Spam korumasý devrede, bu komutu bu kadar sýk kullanmayýn.");
		
    PlayerInfo[playerid][pSendedCare] = GetTickCount();

    new houseid = GetPlayerHouse(playerid, true);

	if(PlayerInfo[playerid][pLevel] < 6) return
		SunucuMesaji(playerid, "Seviye 6 ve üstü kullanýcýlar bunu yapabilirler.");

    if(houseid == -1)return
        SendClientMessageEx(playerid, COLOR_ERROR, "Bu komutu bir evin içerisinde kullanabilirsin.");

    if(HouseInfo[houseid][hOwner] == PlayerInfo[playerid][pID] || PlayerInfo[playerid][pHouse] == houseid)return 1;

    Storage_ShowItems(playerid, houseid);
    //LogYaz(playerid, "/evsoy evenvanter", -1, houseid);
    return 1;
}

CMD:helpers(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN, "Online Helperlar:");
    foreach(new i : Player)
	{
		if(PlayerInfo[i][pAdmin] > 0)
		{
			if(PlayerInfo[i][pAdmin] < 4)
				SendFormattedMessage(playerid, (PlayerInfo[i][pSupporterDuty]) ? COLOR_GREEN : COLOR_GREY, "(Seviye %d) %s (%s) (ID: %d)", PlayerInfo[i][pAdmin], ReturnRoleplayName(i), PlayerInfo[i][pUsername], i);
		}
	}
	return 1;
}

// Özellik ve Bakmak

flags:ozellik(CMD_USER);
flags:ozelliksifirla(CMD_USER);
flags:bak(CMD_USER);

CMD:ozelliksifirla(playerid, params[])
{
	format(PlayerInfo[playerid][pOzellik], 124, "");
	BasariMesaji(playerid, "Karakter özelliklerinizi sildiniz.", params);
	return 1;
}
CMD:bak(playerid, params[])
{
	new targetid, interior, vw;
	if(sscanf(params, "k<m>", targetid)) return KullanimMesajiC(playerid, "/bak [oyuncu id/isim]");

	if(!ProxDetectorS(5.0, playerid, targetid)) return HataMesaji(playerid, "Belirtilen oyuncuya yakýn deðilsin.");
	if(PlayerInfo[targetid][pOzellikGosteriyor]) return 1;
//	GetPlayerPos(targetid, x, y, z);
	interior = GetPlayerInterior(targetid);
	vw = GetPlayerVirtualWorld(targetid);
	new mesaj[200];
    format(mesaj, sizeof(mesaj), "** %s %s", ReturnRoleplayName(targetid, true), PlayerInfo[targetid][pOzellik]);
	PlayerInfo[targetid][pOzellikGosteriyor] = true;
	PlayerInfo[targetid][pOzellikLabel] = CreateDynamic3DTextLabel(mesaj, COLOR_EMOTE, 0, 0, 0.3, 10.0, targetid, INVALID_VEHICLE_ID, 1, vw, interior, playerid);
    SetTimerEx("LabelSil", 10000, false, "d", targetid);
	
	if(IsPlayerInAnyVehicle(targetid))
		SunucuMesaji(playerid, "%s adlý kullanýcý emniyet kemeri %s.", ReturnRoleplayName(targetid), PlayerInfo[targetid][pEmniyetKemeri] ? "takýyor" : "takmýyor");
	
    Streamer_Update(playerid);
	return 1;
}
CMD:ozellik(playerid, params[])
{
    if(isnull(params) || strlen(params) > 124)return
        KullanimMesajiC(playerid, "/ozellik [maks. 124 karakter içeren metin giriþi yapýn]");

	format(PlayerInfo[playerid][pOzellik], 124, "%s", params);
	BasariMesaji(playerid, "Karakter özelliklerinizi '%s' olarak ayarladýnýz.", params);
	return 1;
}

// Konum Göndermek

Dialog:Konum_Gonder(playerid, response, listitem, inputtext[]) /* Wiggy tarafýndan yapýldý.*/
{
	new id = GetPVarInt(playerid, "konum_gonderen");
	if(!response) return SunucuMesaji(playerid, "Konum paylaþma isteðini reddettin."), SunucuMesaji(id, "%s senin konum paylaþma isteðini reddetti.", ReturnRoleplayName(playerid)), DeletePVar(playerid, "konum_gonderen");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(id, x, y, z);
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
	{
	    AC_SetPlayerCheckpoint(playerid, x, y, z, 1.0);
    	SunucuMesaji(playerid, "%s adlý kiþinin konum paylaþma isteðini kabul ettin, haritanda iþaretlendi.", ReturnRoleplayName(id));
		SunucuMesaji(id, "%s senin konum paylaþma isteðini kabul etti, haritasýnda iþaret belirlendi.", ReturnRoleplayName(playerid));
	}
	DeletePVar(playerid, "konum_gonderen");
	return 1;
}

flags:konumgonder(CMD_USER);
CMD:konumgonder(playerid, params[]) /* Wiggy tarafýndan yapýldý.*/
{
	HataMesaji(playerid, "Konum gönderme iþlemi cep telefonu menüsü üzerinden yapýlmaktadýr.");
	return 1;
}

// Bitiþ

CMD:gorevde(playerid, params[]) return pc_cmd_isbasindakiler(playerid, params);
CMD:isbasindakiler(playerid, params[])
{
    new policeCount = Faction_GetOnlineMCount(POLICE);
    new medicalCount = Faction_GetOnlineMCount(MEDICAL);
    new governmentCount = Faction_GetOnlineMCount(GOVERNMENT);
    new yayinciCount = Faction_GetOnlineMCount(LSNN);
    new mechanicCount;
    new taxiCount;

    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || PlayerInfo[i][pJob] == -1 || !PlayerInfo[i][pLogged])continue;

        if(PlayerInfo[i][pJobDuty])
        {
            if(PlayerInfo[i][pJob] == 1) mechanicCount++;
            if(PlayerInfo[i][pJob] == 2) taxiCount++;
        }
        else continue;
    }

    SunucuMesaji(playerid, "LSPD: %d | LSFD: %d | LSGOV: %d | TV: %d | Taksi: %d | Tamirci: %d", policeCount, medicalCount, governmentCount, yayinciCount, taxiCount, mechanicCount);

    return 1;
}

CMD:ddo(playerid, params[]) /* Wiggy tarafýndan yapýldý.*/
{
    if(isnull(params) || strlen(params) > 256)return
        KullanimMesajiC(playerid, "/ddo [yazý]");

    new id, string[300];

    if(GetPlayerBuilding(playerid, true) != -1)
    {
        id = GetPlayerBuilding(playerid, true);

        foreach(new x : Player) if(IsPlayerInRangeOfPoint(x, 5.0, BuildingInfo[id][bPosX], BuildingInfo[id][bPosY], BuildingInfo[id][bPosZ]) && GetPlayerVirtualWorld(x) == BuildingInfo[id][bPosWorld] && GetPlayerInterior(x) == BuildingInfo[id][bPosInterior])
            SendFormattedMessage(x, 0xD0AEEBFF, "%s (( Bina içi ))", params);
    }
    else if(GetPlayerBuilding(playerid, false) != -1)
    {
        id = GetPlayerBuilding(playerid, false);

        foreach(new x : Player) if(GetPlayerVirtualWorld(x) == BuildingInfo[id][bWorld])
            SendFormattedMessage(x, 0xD0AEEBFF, "%s (( Bina dýþý ))", params);
    }
    else if(GetPlayerHouse(playerid, true) != -1)
    {
        id = GetPlayerHouse(playerid, true);

        foreach(new x : Player) if(IsPlayerInRangeOfPoint(x, 5.0, HouseInfo[id][hPosX], HouseInfo[id][hPosY], HouseInfo[id][hPosZ]) && GetPlayerVirtualWorld(x) == HouseInfo[id][hPosWorld] && GetPlayerInterior(x) == HouseInfo[id][hPosInterior])
            SendFormattedMessage(x, 0xD0AEEBFF, "%s (( Ev içi ))", params);
    }
    else if(GetPlayerHouse(playerid, false) != -1)
    {
        id = GetPlayerHouse(playerid, false);

        foreach(new x : Player) if(GetPlayerVirtualWorld(x) == HouseInfo[id][hWorld])
            SendFormattedMessage(x, 0xD0AEEBFF, "%s (( Ev dýþý ))", params);
    }
    else return HataMesaji(playerid, "Bir evin/binanýn içinde-dýþýnda deðilsin.");

    format(string, sizeof(string), "%s (( Ev dýþý )) ", params);
	ProxDetector(15.0, playerid, string, 0xD0AEEBFF, 0xD0AEEBFF, 0xD0AEEBFF, 0xD0AEEBFF, 0xD0AEEBFF);
    return 1;
}

flags:cpsifirla(CMD_USER);
CMD:gpskapat(playerid,params[])return AC_DisablePlayerCheckpoint(playerid), SunucuMesaji(playerid, "Checkpoint kaldýrýldý.");
CMD:cpsifirla(playerid, params[])return AC_DisablePlayerCheckpoint(playerid), SunucuMesaji(playerid, "Checkpoint kaldýrýldý.");

CMD:kapat(playerid, params[])
{
    if(isnull(params) || strlen(params) > 20)return
        SendClientMessageEx(playerid, RENK_KULLANIM, (PlayerInfo[playerid][pAdmin] > SUPPORTER) ? ("[19] {C8C8C8}/kapat <fchat - aracgosterge  - news - admin - log - helper - radyo - reklam>") : ("[19] {C8C8C8}/kapat <aracgosterge - fchat - news - radyo - reklam>"));

    if(!strcmp(params, "zirhcikar", true))
    {
        new Float:ap;
        AC_GetPlayerArmour(playerid, ap);

        if(ap <= 0)return
            SunucuMesaji(playerid, "Zýrhýn yok.");

        AC_SetPlayerArmour(playerid, 0);
        SendClientMessageEx(playerid, COLOR_GREEN, "Zýrhýný çýkarttýn.");
        PlayerInfo[playerid][pToggleArmour] = 1;
    }
    else if(!strcmp(params, "aracgosterge", true))
    {
        PlayerInfo[playerid][pVehicleHud] = !PlayerInfo[playerid][pVehicleHud];

        if(IsPlayerInAnyVehicle(playerid) && PlayerInfo[playerid][pVehicleHud])
        {
            PlayerTextDrawShow(playerid, VehicleSpeed[playerid]);
            PlayerTextDrawShow(playerid, VehicleFuel[playerid]);
            TextDrawShowForPlayer(playerid, KMH);
        }
        else if(IsPlayerInAnyVehicle(playerid) && !PlayerInfo[playerid][pVehicleHud])
        {
            PlayerTextDrawHide(playerid, VehicleSpeed[playerid]);
            PlayerTextDrawHide(playerid, VehicleFuel[playerid]);
            TextDrawHideForPlayer(playerid, KMH);
        }
    }
    else if(!strcmp(params, "fchat", true))
    {
        if(PlayerInfo[playerid][pFaction] == -1)return 1;

        PlayerInfo[playerid][pFactionOOC] = !PlayerInfo[playerid][pFactionOOC];

        SendClientMessageEx(playerid, COLOR_WHITE, (!PlayerInfo[playerid][pFactionOOC]) ? ("Oluþum OOC chatini kapattýn.") :
        ("Oluþum OOC chatini açtýn."));
    }
    else if(!strcmp(params, "admin", true))
    {
        if(PlayerInfo[playerid][pAdmin] < GAMEADMIN1)return 1;

        PlayerInfo[playerid][pAdminAlert] = !PlayerInfo[playerid][pAdminAlert];

        SendClientMessageEx(playerid, COLOR_WHITE, (!PlayerInfo[playerid][pAdminAlert]) ? ("AdmCMD uyarýlarýnýn gelmesini durdurdun.") :
        ("AdmCmd uyarýlarýný aktif ettin."));
    }
    else if(!strcmp(params, "akanal", true))
    {
        if(PlayerInfo[playerid][pAdmin] < GAMEADMIN1)return 1;

        PlayerInfo[playerid][pACH] = !PlayerInfo[playerid][pACH];

        SendClientMessageEx(playerid, COLOR_WHITE, (!PlayerInfo[playerid][pACH]) ? ("Admin sohbetinin gelmesini durdurdun.") :
        ("Admin sohbetini aktif ettin."));
    }
    else if(!strcmp(params, "lkanal", true))
    {
        if(PlayerInfo[playerid][pAdmin] < 10)return 1;

        PlayerInfo[playerid][pLACH] = !PlayerInfo[playerid][pLACH];

        SendClientMessageEx(playerid, COLOR_WHITE, (!PlayerInfo[playerid][pLACH]) ? ("Lead Admin yazýlarýnýn gelmesini durdurdun.") :
        ("Lead Admin kanalýný aktif ettin."));
    }
    else if(!strcmp(params, "log", true))
    {
        if(PlayerInfo[playerid][pAdmin] < GAMEADMIN1)return 1;

        PlayerInfo[playerid][pAdminLog] = !PlayerInfo[playerid][pAdminLog];

        SendClientMessageEx(playerid, COLOR_WHITE, (!PlayerInfo[playerid][pAdminLog]) ? ("Giriþ/çýkýþ mesajlarýný durdurdun.") :
        ("Giriþ/çýkýþ mesajlarýný aktif ettin."));
    }
    else if(!strcmp(params, "helper", true))
    {
		if(PlayerInfo[playerid][pAdmin] == 0) return HataMesaji(playerid, "Bu komutu kullanamazsýn.");
		if(PlayerInfo[playerid][pAdmin] == 1) return HataMesaji(playerid, "Bu komutu kullanamazsýn.");
		if(PlayerInfo[playerid][pAdmin] == 2) return HataMesaji(playerid, "Bu komutu kullanamazsýn.");
		if(PlayerInfo[playerid][pAdmin] == 3) return HataMesaji(playerid, "Bu komutu kullanamazsýn.");
        PlayerInfo[playerid][pSupporterAlert] = !PlayerInfo[playerid][pSupporterAlert];

        SendClientMessageEx(playerid, COLOR_WHITE, (!PlayerInfo[playerid][pSupporterAlert]) ? ("Soru ve helper chat kanalýný deaktif hale getirdin. (sürekli kapalý tutmamalýsýn)") :
        ("Soru ve helper chat kanalýný aktif hale getirdin."));
    }
    else if(!strcmp(params, "news", true))
    {
        PlayerInfo[playerid][pNews] = !PlayerInfo[playerid][pNews];

        SendClientMessageEx(playerid, COLOR_WHITE, (!PlayerInfo[playerid][pNews]) ? ("Televizyon kanalýný pasif hale getirdin.") :
        ("Televizyon kanalýný aktif hale getirdin."));
    }
    else if(!strcmp(params, "hud", true))
    {
        PlayerInfo[playerid][pHud] = !PlayerInfo[playerid][pHud];
		
		if(PlayerInfo[playerid][pHud])
		{
			ShowPlayerHud(playerid);
		}
		else
		{
			if(PlayerInfo[playerid][pNotifications][0] || PlayerInfo[playerid][pNotifications][1])
				ParaTDGizle(playerid);
			
			HidePlayerHud(playerid);
		}

        SendClientMessageEx(playerid, COLOR_WHITE, (!PlayerInfo[playerid][pHud]) ? ("Sunucu HUD'unu deaktif ettin.") : ("Sunucu HUD'unu aktif ettin."));
    }
    else if(!strcmp(params, "radyo", true)) {
        if(Faction_GetType(PlayerInfo[playerid][pFaction]) == POLICE || Faction_GetType(PlayerInfo[playerid][pFaction]) == MEDICAL || Faction_GetType(PlayerInfo[playerid][pFaction]) == GOVERNMENT) {
	        PlayerInfo[playerid][pRadyo] = !PlayerInfo[playerid][pRadyo];
	        SendClientMessageEx(playerid, COLOR_WHITE, (PlayerInfo[playerid][pRadyo]) ?  ("/r komutunu açtýn.") : ("/r komutunu kapattýn."));
		} else return HataMesaji(playerid, "Bu komutu kullanamazsýn.");
    }
    else if(!strcmp(params, "reklam", true)) {
        PlayerInfo[playerid][pReklam] = !PlayerInfo[playerid][pReklam];
        SendClientMessageEx(playerid, COLOR_WHITE, (!PlayerInfo[playerid][pReklam]) ?  ("Reklam kanalýný açtýn.") : ("Reklam kanalýný kapattýn."));
    }
    else return
        HataMesaji(playerid, "Geçersiz parametre.");

    return 1;
}
CMD:meslekyardim(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == -1)return
        SunucuMesaji(playerid, "Herhangi bir meslekte deðilsin. Bir mesleðe girmek için /meslekgir kullan.");

    switch(PlayerInfo[playerid][pJob])
    {
        case 0:
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "[Kamyoncu] {AFAFAF}/kamyoncu: Teslimat noktalarý hakkýnda bilgi verir. (Bu komut için uygun araçta olmalýsýn.)");
			SendClientMessageEx(playerid, COLOR_WHITE, "[Kamyoncu] {AFAFAF}/koli satinal: Koli satýn almaya yarýyor. Ayrýntýlý bilgi için /koli kullanýn.");
			SendClientMessageEx(playerid, COLOR_GREY, "Açýklama: LSPD, GOV, LSFD ve televizyon kuruluþlarý bu mesleðin komutlarýný kullanamazlar.");
			SendClientMessageEx(playerid, COLOR_GREY, "Trucker Geliri 103.000'e ulaþan kiþiler, meslek üzerinden yüzde 70 daha az gelir elde edecekler.");
		}
        case 1:
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "[Tamirci] {AFAFAF}/tamiret: Bir oyuncunun arabasýna tamir iþlemi uygulamaya yarar.");
			SendClientMessageEx(playerid, COLOR_WHITE, "[Tamirci] {AFAFAF}/aracboya: Bir oyuncunun arabasýný boyamaya yarar. (10 parça)");
			SendClientMessageEx(playerid, COLOR_WHITE, "[Tamirci] {AFAFAF}/cagrikabul: Gelen tamirci talep çaðrýsýný kabul etmeye yarar.");
			SendClientMessageEx(playerid, COLOR_WHITE, "[Tamirci] {AFAFAF}/meslekisbasi: Tamir çaðrýlarý almanýz için meslek iþbaþý olanýza yarar.");
			SendClientMessageEx(playerid, COLOR_WHITE, "[Tamirci] {AFAFAF}/parcaalani: Tamir parçasý satýn alýnan noktayý göstermeyi yarar.");
		}
        case 2:
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "[Taksici] {AFAFAF}/meslekisbasi: Mesleðe baþlamanýzda büyük rol oynar, bunu yazmadan mesleðe baþlamayýn.");
			SendClientMessageEx(playerid, COLOR_WHITE, "[Taksici] {AFAFAF}/taksimetre: Taksinin taksimetresini ayarlamaya yarar.");
			SendClientMessageEx(playerid, COLOR_WHITE, "[Taksici] {AFAFAF}/cagrikabul: Gelen çaðrýyý kabul etmeye yarar.");
		}
		case 3: {
			SendClientMessageEx(playerid, COLOR_WHITE, "[Pizza Kuryesi] {AFAFAF}/pizza: Pizza komutlarýný içerir.");
		}
    }

    return 1;
}

flags:tokalas(CMD_USER);
CMD:tokalas(playerid, params[])
{
    new id, type;

    if(sscanf(params, "k<m>d", id, type))return
        KullanimMesajiC(playerid, "/tokalas [id/isim] [tip]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesaji(playerid, "Geçersiz ID.");

    if(type < 1 || type > 6) return
        SunucuMesaji(playerid, "Geçersiz seçenek. (1 - 6)");

    if(!ProxDetectorS(5.0, playerid, id))return
        SunucuMesaji(playerid, "Oyuncuya yakýn deðilsin.");

    PlayerInfo[id][pShakeOffer] = playerid;
    PlayerInfo[id][pShakeType] = type;

    BasariMesaji(id, "%s sana tokalaþma isteði gönderdi. \"/kabulet tokalas\" komutuyla kabul edebilirsin.", ReturnRoleplayName(playerid));
    SunucuMesaji(playerid, "%s kiþisine tokalaþma isteði gönderdin.", ReturnRoleplayName(id));

    return 1;
}

CMD:ds(playerid, params[])return pc_cmd_kapiyadogru(playerid,params);
CMD:kapiyadogru(playerid, params[])
{
    if(isnull(params) || strlen(params) > 256)return
        KullanimMesajiC(playerid, "/kapiyadogru [yazý]");

    new id, string[300];

    if(GetPlayerBuilding(playerid, true) != -1)
    {
        id = GetPlayerBuilding(playerid, true);

        foreach(new x : Player) if(IsPlayerInRangeOfPoint(x, 5.0, BuildingInfo[id][bPosX], BuildingInfo[id][bPosY], BuildingInfo[id][bPosZ]) && GetPlayerVirtualWorld(x) == BuildingInfo[id][bPosWorld] && GetPlayerInterior(x) == BuildingInfo[id][bPosInterior])
            SendFormattedMessage(x, COLOR_GREY, "[Binadan gelen ses] %s", params);
    }
    else if(GetPlayerBuilding(playerid, false) != -1)
    {
        id = GetPlayerBuilding(playerid, false);

        foreach(new x : Player) if(GetPlayerVirtualWorld(x) == BuildingInfo[id][bWorld])
            SendFormattedMessage(x, COLOR_GREY, "[Binanýn dýþýndan gelen ses] %s", params);
    }
    else if(GetPlayerHouse(playerid, true) != -1)
    {
        id = GetPlayerHouse(playerid, true);

        foreach(new x : Player) if(IsPlayerInRangeOfPoint(x, 5.0, HouseInfo[id][hPosX], HouseInfo[id][hPosY], HouseInfo[id][hPosZ]) && GetPlayerVirtualWorld(x) == HouseInfo[id][hPosWorld] && GetPlayerInterior(x) == HouseInfo[id][hPosInterior])
            SendFormattedMessage(x, COLOR_WHITE, "[Ev içinden gelen ses] %s", params);
    }
    else if(GetPlayerHouse(playerid, false) != -1)
    {
        id = GetPlayerHouse(playerid, false);

        foreach(new x : Player) if(GetPlayerVirtualWorld(x) == HouseInfo[id][hWorld])
            SendFormattedMessage(x, COLOR_WHITE, "[Evin dýþýndan gelen ses] %s", params);
    }
    else return HataMesaji(playerid, "Bir evin/binanýn içinde-dýþýnda deðilsin.");

    format(string, sizeof(string), "[Kapýya Doðru] %s: %s", ReturnRoleplayName(playerid, true), params);
    ProxDetector(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

    return 1;
}

CMD:reklam(playerid, params[])return pc_cmd_reklamver(playerid,params);
CMD:reklamver(playerid, params[])
{
	if(SunucuBilgi[ReklamVerildi] >= 2 && !PlayerInfo[playerid][pAdmin])
		return HataMesaji(playerid, "1 dakika içerisinde %d adet reklam verildi, 1 dakika sonra tekrar deneyin.", SunucuBilgi[ReklamVerildi]);

    new buildingid = GetPlayerBuilding(playerid, true);
    new message[124];
	new slot = Inventory_HasItem(playerid, "Cep Telefonu", ITEM_PHONE);
    if(slot == -1) return HataMesaji(playerid, "Cep telefonun yok, reklam vermek için telefona ihtiyacýn var.");
	new count_admin;
	
	foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] >= 1 && !PlayerInfo[i][pAFKTime])
		count_admin++;

    if(buildingid != -1 && BuildingInfo[buildingid][bType] == ADVERTISEMENT)
    {
        if(sscanf(params, "ds[124]", slot, message))return
            KullanimMesajiC(playerid, "/reklamver [telefon slot id] [reklam metni]");
			
		for(new i; i < sizeof(swear); ++i) if(strfind(message, swear[i][xisim], true) != -1) return HataMesaji(playerid, "Bu reklam yasaklý kelime içeriyor.");

        slot--;

		new listid = PlayerInfo[playerid][pInvList][slot];

	    if(InventoryObjects[listid][invType] != ITEM_PHONE)return HataMesaji(playerid, "Seçtiðiniz envanter slotunda cep telefonu yok.");

	    if(!PlayerInfo[playerid][pInvExtra][slot]) return HataMesaji(playerid, "Cep telefonun kapalýyken reklam veremezsin.");

		new price;
        if(PlayerInfo[playerid][pFaction] != -1 && Faction_GetType(PlayerInfo[playerid][pFaction]) == OTHER)
        {
		    price = 150;
		}
		else price = strlen(message) * 5;

        if(PlayerInfo[playerid][pCash] < price)return
            HataMesaji(playerid, "Yeterli paran yok. ($%d)", price);

		if(PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pPremium] >= 3 || PlayerInfo[playerid][pLevel] >= 3 || count_admin == 0)
		{
		    foreach(new j : Player) 
			{
	            if(PlayerInfo[j][pReklam] || !PlayerInfo[j][pLogged])continue;
				if(PlayerInfo[playerid][pLevel] < 4) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (%s - %d)", message, ReturnRoleplayName(playerid, true), PlayerInfo[playerid][pInvAmount][slot]);
				else if(count_admin == 0) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (%s - %d)", message, ReturnRoleplayName(playerid, true), PlayerInfo[playerid][pInvAmount][slot]);
				else SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (Ýletiþim: %d)", message, PlayerInfo[playerid][pInvAmount][slot]);
			}
			if(PlayerInfo[playerid][pLevel] > 3)
				SendAworkAlert(false, COLOR_ADMIN, "Reklam veren kullanýcý: %s (Telefon: %d)", ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
		
			printf("%s tarihinde %s reklam verdi. (Telefon: %d)", ReturnDate(), ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);

			OAC_GivePlayerMoney(playerid, -price);
//			Faction_SANCash(price * 8);
	        BasariMesaji(playerid, "$%d karþýlýðýnda reklam verdin.", price);
			SunucuBilgi[ReklamVerildi] += 1;
	        return 1;
		}
		if(PlayerInfo[playerid][pVerdigiReklam] != -1) return HataMesaji(playerid, "Zaten bir reklam vermiþsiniz, lütfen cevap bekleyin.");
        if(PlayerInfo[playerid][pAdmin] < 1)
		{
			new count = 0;
			foreach(new adm : Player)
			{
			    if(!PlayerInfo[adm][pLogged])continue;
			    if(!PlayerInfo[adm][pAdmin])continue;
			    count++;
			}
			if(count >= 3) ReklamEkle(playerid, message, PlayerInfo[playerid][pInvAmount][slot]);
			else
			{
			    foreach(new j : Player)
				{
		            if(PlayerInfo[j][pReklam] || !PlayerInfo[j][pLogged])continue;
					if(PlayerInfo[playerid][pLevel] < 4) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (%s - %d)", message, ReturnRoleplayName(playerid, true), PlayerInfo[playerid][pInvAmount][slot]);
					else if(count_admin == 0) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (%s - %d)", message, ReturnRoleplayName(playerid, true), PlayerInfo[playerid][pInvAmount][slot]);
					else SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (Ýletiþim: %d)", message, PlayerInfo[playerid][pInvAmount][slot]);
				}
				if(PlayerInfo[playerid][pLevel] > 3)
					SendAworkAlert(false, COLOR_ADMIN, "Reklam veren kullanýcý: %s (Telefon: %d)", ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
			
				printf("%s tarihinde %s reklam verdi. (Telefon: %d)", ReturnDate(), ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
			}
		}
        OAC_GivePlayerMoney(playerid, -price);
        BasariMesaji(playerid, "$%d karþýlýðýnda reklam verdin.", price);
		SunucuBilgi[ReklamVerildi] += 1;
	}
	else
	{
        if(sscanf(params, "ds[124]", slot, message))return
            KullanimMesajiC(playerid, "/reklamver [telefon slot id] [reklam metni]");
			
		for(new i; i < sizeof(swear); ++i) if(strfind(message, swear[i][xisim], true) != -1) return HataMesaji(playerid, "Bu reklam yasaklý kelime içeriyor.");

        slot--;

		new listid = PlayerInfo[playerid][pInvList][slot];

	    if(InventoryObjects[listid][invType] != ITEM_PHONE)return HataMesaji(playerid, "Seçtiðiniz envanter slotunda cep telefonu yok.");

	    if(!PlayerInfo[playerid][pInvExtra][slot]) return HataMesaji(playerid, "Cep telefonun kapalýyken reklam veremezsin.");

		new price;
        if(PlayerInfo[playerid][pFaction] != -1 && Faction_GetType(PlayerInfo[playerid][pFaction]) == OTHER)
        {
		    price = 150;
		}
		else price = strlen(message) * 5;

        if(PlayerInfo[playerid][pCash] < price)return
            HataMesaji(playerid, "Yeterli paran yok. ($%d)", price);

        if(PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pPremium] >= 3 || PlayerInfo[playerid][pLevel] >= 3 || count_admin == 0)
		{
		    foreach(new j : Player)
			{
	            if(PlayerInfo[j][pReklam] || !PlayerInfo[j][pLogged])continue;
				if(PlayerInfo[playerid][pLevel] < 4) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (%s - %d)", message, ReturnRoleplayName(playerid, true), PlayerInfo[playerid][pInvAmount][slot]);
				else if(count_admin == 0) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (%s - %d)", message, ReturnRoleplayName(playerid, true), PlayerInfo[playerid][pInvAmount][slot]);
				else SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (Ýletiþim: %d)", message, PlayerInfo[playerid][pInvAmount][slot]);
			}
			if(PlayerInfo[playerid][pLevel] > 3)
				SendAworkAlert(false, COLOR_ADMIN, "Reklam veren kullanýcý: %s (Telefon: %d)", ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
			
			printf("%s tarihinde %s reklam verdi. (Telefon: %d)", ReturnDate(), ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
			
			OAC_GivePlayerMoney(playerid, -price);
	        BasariMesaji(playerid, "$%d karþýlýðýnda reklam verdin.", price);
			SunucuBilgi[ReklamVerildi] += 1;
	        return 1;
		}
		if(PlayerInfo[playerid][pVerdigiReklam] != -1) return HataMesaji(playerid, "Zaten bir reklam vermiþsiniz, lütfen cevap bekleyin.");
        if(PlayerInfo[playerid][pAdmin] < 1)
		{
			new count = 0;
			foreach(new adm : Player)
			{
			    if(!PlayerInfo[adm][pLogged])continue;
			    if(!PlayerInfo[adm][pAdmin])continue;
			    count++;
			}
			if(count >= 3)
            	ReklamEkle(playerid, message, PlayerInfo[playerid][pInvAmount][slot]);
			else
			{
			    foreach(new j : Player)
				{
					if(PlayerInfo[j][pReklam] || !PlayerInfo[j][pLogged])continue;
					if(PlayerInfo[playerid][pLevel] < 4) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (%s - %d)", message, ReturnRoleplayName(playerid, true), PlayerInfo[playerid][pInvAmount][slot]);
					else if(count_admin == 0) SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (%s - %d)", message, ReturnRoleplayName(playerid, true), PlayerInfo[playerid][pInvAmount][slot]);
					else SendFormattedMessage(j, COLOR_GREEN, "[Reklam] %s (Ýletiþim: %d)", message, PlayerInfo[playerid][pInvAmount][slot]);
				}
				if(PlayerInfo[playerid][pLevel] > 3)
					SendAworkAlert(false, COLOR_ADMIN, "Reklam veren kullanýcý: %s (Telefon: %d)", ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
				
				printf("%s tarihinde %s reklam verdi. (Telefon: %d)", ReturnDate(), ReturnRoleplayName(playerid), PlayerInfo[playerid][pInvAmount][slot]);
			}
		}
        OAC_GivePlayerMoney(playerid, -price);
        BasariMesaji(playerid, "$%d karþýlýðýnda reklam verdin.", price);
		SunucuBilgi[ReklamVerildi] += 1;
	}
    return 1;
}

CMD:reklamiptal(playerid) {
	if(PlayerInfo[playerid][pVerdigiReklam] == -1) return HataMesajiC(playerid, "Zaten bir reklam vermemiþsiniz.");
	ReklamSil(PlayerInfo[playerid][pVerdigiReklam]);
	PlayerInfo[playerid][pVerdigiReklam] = -1;
	BasariMesaji(playerid, "Verdiðiniz reklam baþarýyla silindi.");
	return 1;
}

CMD:yardim(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "____________________________________[YARDIM]_____________________________________");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[KARAKTER]:{C8C8C8} /karakter - /ssmod - /dovusstili - /konusmastili - /kapat - /19p");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[DESTEK]:{C8C8C8} /sorusor - /rapor - /taleplerim - /helpers - /admins");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[DESTEK]:{C8C8C8} /factionyardim - /telsizyardim - /bankayardim - /balikyardim - /evyardim");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[DESTEK]:{C8C8C8} /isletmeyardim - /meslekyardim - /telefonyardim - /dekorasyonyardim - /donatoryardim");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[DESTEK]:{C8C8C8} /kisayolaktif - /animlist - /harita - /tanitim - /ozellik - /bak");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[ENVANTER]:{C8C8C8} /envanter - /envanteryardim - /yerdenal - /ustara - /paraver - /lisansgoster - /ver");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[ENVANTER]:{C8C8C8} /maske - /zar - /sigara - /yazitura - /anahtar - /tepsi - /aksesuar");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[MESAJ]:{C8C8C8} /b - /cw - /low - /me - /melow - /ame - /do - /dolow - /w - /s - /f - /pm - /kapiyadogru");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[ARAÇ]:{C8C8C8} /arac - /kilitkir - /duzkontak - /motor - /kilit - /cezalarim - /asilahkullan - /araccikart - /cb");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[DÝÐER]:{C8C8C8} /gir - /cik - /id - /kabulet - /satinal - /gise - /cpsifirla");
    SendClientMessage(playerid, COLOR_GREEN, "{BF3B2C}[DÝÐER]:{C8C8C8} /casino - /olusumdancik - /isbasindakiler - /saat");
    SendClientMessage(playerid, COLOR_GREEN, "____________________________________[YARDIM]_____________________________________");

    return 1;
}

CMD:lideryardim(playerid, params[])
{
    SunucuMesaji(playerid, "[Lider] /fbirim - /fdavet - /fkov - /frutbe");
    return HataMesaji(playerid, "[Lider] /fduzenle - /fkanalkapat - /fparacek - /fparayatir - /fkasa");
}

CMD:bankayardim(playerid, params[])
	return SunucuMesaji(playerid, "Banka> /parayatir - /paracek - /transfer - /mevduat");

CMD:telefonyardim(playerid, params[])
{
    SunucuMesaji(playerid, "Telefon> /telefon - /hoparlor - /ara - /sms - /rehber - /cevapla - /tkap - /kulube");
    SunucuMesaji(playerid, "Polis/Saðlýk/Ýtfaiye: 911 - Tamirci: 555 - Taksi: 444");
	return 1;
}

CMD:telsizyardim(playerid, params[])return
    SunucuMesaji(playerid, "Telsiz> /frekans - /slot - /telsizgiris - (/t)elsiz - /ara %d", RENTER_NUMBER);

CMD:donatoryardim(playerid, params[])return
    SunucuMesaji(playerid, "Donator> /bdurum - /pmdurum - /pmodak - /pmodakbitir");

CMD:balikyardim(playerid, params[])return
    SunucuMesaji(playerid, "Balýk> /baliktut - /baliksat - /balikyemal - /balikdurum");

CMD:evyardim(playerid, params[])return
    SunucuMesaji(playerid, "Ev> /ev - /evsatinal - /kapiyavur");

CMD:isletmeyardim(playerid, params[])return
    SunucuMesaji(playerid, "Ýþletme> /isletme - /isletmesatinal");

CMD:dekorasyonyardim(playerid, params[])return
    SunucuMesaji(playerid, "Dekorasyon> /dekorasyon - /dekorasyonid - /kapi - /frot - /dekorsec");

CMD:envanteryardim(playerid, params[])
{
    KullanimMesajiC(playerid, "/envanter komutu ile genel olarak envanterini yönetebilirsin.");
    return KullanimMesajiC(playerid, "/envanteryerlestir ile de elindeki silahý envanterine koyabilirsin.");
}
CMD:animasyonlar(playerid, params[]) return pc_cmd_animlist(playerid, params);
CMD:animler(playerid, params[]) return pc_cmd_animlist(playerid, params);
CMD:anims(playerid, params[]) return pc_cmd_animlist(playerid, params);
CMD:animlist(playerid, params[])
{
    SendClientMessage(playerid, COLOR_YELLOW, "__________________________________[ANIMASYONLAR]___________________________________");
    SendClientMessage(playerid, COLOR_GREY, "/tokalas - /dance - /handsup - /bat - /bar - /wash - /lay - /gym - /blowjob - /bomb");
    SendClientMessage(playerid, COLOR_GREY, "/carry - /crack - /sleep - /jump - /deal - /eating - /vomit - /gsign - /chat - /crouch");
    SendClientMessage(playerid, COLOR_GREY, "/goggles - /throw - /swipe - /office - /kiss - /knife - /cpr - /scratch - /aim");
    SendClientMessage(playerid, COLOR_GREY, "/cheer - /wave - /strip - /smoke - /reload - /taichi - /wank - /hide - /drunk");
    SendClientMessage(playerid, COLOR_GREY, "/cry - /tired - /sit - /crossarms - /fucku - /walk - /piss - /fall - /lean - /facepalm");
    SendClientMessage(playerid, COLOR_GREY, "/giver - /face - /hike - /rap - /cop - /caract - /what - /laugh");
    SendClientMessage(playerid, COLOR_GREY, "Animasyonlarý sýfýrlamak için /animdurdur veya boþluk tuþunu kullanýn.");
    SendClientMessage(playerid, COLOR_YELLOW, "__________________________________[ANIMASYONLAR]___________________________________");
    return 1;
}

CMD:skate(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

	new type;
    if(sscanf(params, "d", type))return KullanimMesajiC(playerid, "/skate [1 - 2]");

    if(type < 1 || type > 2)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "SKATE", "skate_idle", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "SKATE", "skate_run", 4.1, 1, 1, 1, 1, 1, 1);
    }

    return 1;
}

CMD:caract(playerid, params[])
{
    new type;

	if(!IsPlayerInAnyVehicle(playerid)) return
        SunucuMesaji(playerid, "Araçta deðilsin.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/caract [1 - 22]");

    if(type < 1 || type > 22)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {

		case 1: ApplyAnimation(playerid,"CAR_CHAT", "carfone_in", 4.1, 1, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid,"CAR_CHAT", "carfone_loopA", 4.1, 1, 0, 0, 0, 0);
        case 3: ApplyAnimation(playerid,"CAR_CHAT", "carfone_loopA_to_B", 4.1, 1, 0, 0, 0, 0);
        case 4: ApplyAnimation(playerid,"CAR_CHAT", "carfone_loopB", 4.1, 1, 0, 0, 0, 0);
        case 5: ApplyAnimation(playerid,"CAR_CHAT", "carfone_loopB_to_A", 4.1, 1, 0, 0, 0, 0);
        case 6: ApplyAnimation(playerid,"CAR_CHAT", "carfone_out", 4.1, 1, 0, 0, 0, 0);
        case 7: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc1_BL", 4.1, 1, 0, 0, 0, 0);
        case 8: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc1_BR", 4.1, 1, 0, 0, 0, 0);
        case 9: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc1_FL", 4.1, 1, 0, 0, 0, 0);
        case 10: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc1_FR", 4.1, 1, 0, 0, 0, 0);
        case 11: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc2_FL", 4.1, 1, 0, 0, 0, 0);
        case 12: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc3_BR", 4.1, 1, 0, 0, 0, 0);
        case 13: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc3_FL", 4.1, 1, 0, 0, 0, 0);
        case 14: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc3_FR", 4.1, 1, 0, 0, 0, 0);
        case 15: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc4_BL", 4.1, 1, 0, 0, 0, 0);
        case 16: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc4_BR", 4.1, 1, 0, 0, 0, 0);
        case 17: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc4_FL", 4.1, 1, 0, 0, 0, 0);
        case 18: ApplyAnimation(playerid,"CAR_CHAT", "CAR_Sc4_FR", 4.1, 1, 0, 0, 0, 0);
        case 19: ApplyAnimation(playerid,"CAR_CHAT", "car_talkm_in", 4.1, 1, 0, 0, 0, 0);
        case 20: ApplyAnimation(playerid,"CAR_CHAT", "car_talkm_loop", 4.1, 1, 0, 0, 0, 0);
        case 21: ApplyAnimation(playerid,"CAR_CHAT", "car_talkm_out", 4.1, 1, 0, 0, 0, 0);
        case 22: ApplyAnimation(playerid,"CAR", "Sit_relaxed", 4.1, 1, 0, 0, 0, 0);
    }

    return 1;
}

CMD:dans(playerid, params[]) return pc_cmd_dance(playerid, params);
CMD:dance(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/dance [1 - 15]");

    if(type < 1 || type > 15)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
        case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
        case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
        case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
        case 5: ApplyAnimationEx(playerid, "DANCING", "dance_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimationEx(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 7: ApplyAnimationEx(playerid, "DANCING", "DAN_Right_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 8: ApplyAnimationEx(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 9: ApplyAnimationEx(playerid, "DANCING", "DAN_Up_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 10: ApplyAnimationEx(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 11: ApplyAnimationEx(playerid, "DANCING", "dnce_M_a", 4.1, 1, 0, 0, 0, 0, 1);
        case 12: ApplyAnimationEx(playerid, "DANCING", "dnce_M_e", 4.1, 1, 0, 0, 0, 0, 1);
        case 13: ApplyAnimationEx(playerid, "DANCING", "dnce_M_b", 4.1, 1, 0, 0, 0, 0, 1);
        case 15: ApplyAnimationEx(playerid, "DANCING", "dnce_M_c", 4.1, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:handsup(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);

    return 1;
}

CMD:piss(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_PISSING);
    ApplyAnimation(playerid, "PAULNMAC", "Piss_in", 3.0, 0, 0, 0, 0, 0); // 21-01-2019 tarihinde eklendi

    return 1;
}
CMD:bat(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/bat [1 - 5]");

    if(type < 1 || type > 5)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, 0, 1, 1, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "BASEBALL", "Bat_2", 4.1, 0, 1, 1, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "BASEBALL", "Bat_3", 4.1, 0, 1, 1, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 0, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "BASEBALL", "Bat_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:bar(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/bar [1 - 8]");

    if(type < 1 || type > 8)    return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "BAR", "Barserve_glass", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "BAR", "Barserve_in", 4.1, 0, 0, 0, 0, 0, 1);
        case 5: ApplyAnimation(playerid, "BAR", "Barserve_order", 4.1, 0, 0, 0, 0, 0, 1);
        case 6: ApplyAnimationEx(playerid, "BAR", "BARman_idle", 4.1, 0, 0, 0, 0, 0, 1);
        case 7: ApplyAnimationEx(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0, 1);
        case 8: ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:hediye(playerid, params[])return pc_cmd_giver(playerid, params);
CMD:giver(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/giver [1 - 2]");

    if(type < 1 || type > 2)    return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "KISSING", "gift_give", 3.0, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.1, 0, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:face(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/face [1 - 6]");

    if(type < 1 || type > 6)    return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "PED", "facanger", 3.0, 1, 1, 1, 1, 1, 1);
        case 2: ApplyAnimation(playerid, "PED", "facgum", 3.0, 1, 1, 1, 1, 1, 1);
        case 3: ApplyAnimation(playerid, "PED", "facsurp", 3.0, 1, 1, 1, 1, 1, 1);
        case 4: ApplyAnimation(playerid, "PED", "facsurpm", 3.0, 1, 1, 1, 1, 1, 1);
        case 5: ApplyAnimation(playerid, "PED", "factalk", 3.0, 1, 1, 1, 1, 1, 1);
        case 6: ApplyAnimation(playerid, "PED", "facurios", 3.0, 1, 1, 1, 1, 1, 1);
    }

    return 1;
}
CMD:wash(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);

    return 1;
}

CMD:uzan(playerid, params[]) return pc_cmd_lay(playerid, params);
CMD:lay(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/lay [1 - 5]");

    if(type < 1 || type > 5)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:gym(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/gym [1 - 7]");

    if(type < 1 || type > 7)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "benchpress", "gym_bp_celebrate", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "benchpress", "gym_bp_down", 4.1, 0, 0, 0, 1, 0, 1);
        case 3: ApplyAnimation(playerid, "benchpress", "gym_bp_getoff", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "benchpress", "gym_bp_geton", 4.1, 0, 0, 0, 1, 0, 1);
        case 5: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_A", 4.1, 0, 0, 0, 1, 0, 1);
        case 6: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_B", 4.1, 0, 0, 0, 1, 0, 1);
        case 7: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_smooth", 4.1, 0, 0, 0, 1, 0, 1);
    }

    return 1;
}
CMD:blowjob(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/blowjob [1 - 4]");

    if(type < 1 || type > 4)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:facepalm(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.1, 0, 1, 1, 0, 0, 1);

    return 1;
}
CMD:bomb(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 0, 0, 0, 0, 1);

    return 1;
}
CMD:carry(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/carry [1 - 6]");

    if(type < 1 || type > 6) return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "CARRY", "liftup05", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
        case 5: ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 0, 0, 0, 0, 1);
        case 6: ApplyAnimation(playerid, "CARRY", "putdwn105", 4.1, 0, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:crack(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
            SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
            KullanimMesajiC(playerid, "/crack [1 - 6]");

    if(type < 1 || type > 6)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0, 1);
        case 2: ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "CRACK", "crckdeth3", 4.1, 0, 0, 0, 1, 0, 1);
        case 4: ApplyAnimationEx(playerid, "CRACK", "crckidle1", 4.1, 0, 0, 0, 1, 0, 1);
        case 5: ApplyAnimationEx(playerid, "CRACK", "crckidle2", 4.1, 0, 0, 0, 1, 0, 1);
        case 6: ApplyAnimationEx(playerid, "CRACK", "crckidle3", 4.1, 0, 0, 0, 1, 0, 1);
    }

    return 1;
}
CMD:sleep(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/sleep [1-2]");

    if(type < 1 || type > 2)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
        case 2: ApplyAnimationEx(playerid, "CRACK", "crckidle4", 4.1, 0, 0, 0, 1, 0, 1);
    }

    return 1;
}
CMD:what(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

	ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY", 4.1, 0, 0, 0, 0, 0);
	return 1;
}
CMD:jump(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.1, 0, 1, 1, 0, 0, 1);

    return 1;
}
CMD:deal(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/deal [1 - 6]");

    if(type < 1 || type > 6)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "DEALER", "DRUGS_BUY", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:eating(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/eating [1 - 3]");

    if(type < 1 || type > 3)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, 0, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:vomit(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);

    return 1;
}

CMD:box(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimationEx(playerid,"GYMNASIUM","GYMshadowbox",4.0,1, 1, 1, 1, 0);

    return 1;
}

CMD:hike(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/hike [1 - 3]");

    if(type < 1 || type > 3)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "MISC", "hiker_pose", 4.0, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "MISC", "hiker_pose_l", 4.0, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "PED", "idle_taxi", 3.0, 0, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:cop(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/cop [1 - 6]");

    if(type < 1 || type > 6)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "SWORD", "sword_block", 50.0, 0, 1, 1, 1, 1);
        case 2: ApplyAnimationEx(playerid, "POLICE", "CopTraf_away", 4.0, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "POLICE", "CopTraf_come", 3.0, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "POLICE", "CopTraf_left", 4.0, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "POLICE", "CopTraf_stop", 4.0, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimationEx(playerid, "POLICE", "Cop_move_fwd", 4.0, 1, 1, 1, 1, 1);
    }

    return 1;
}
CMD:rap(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/rap [1 - 2]");

    if(type < 1 || type > 2)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0);
    }

    return 1;
}
CMD:crouch(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/crouch [1 - 2]");

    if(type < 1 || type > 2)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "CAMERA", "camstnd_to_camcrch", 4.1, 0, 1, 1, 1, 0);
        case 2: ApplyAnimationEx(playerid, "CAMERA", "camcrch_cmon", 4.1, 0, 1, 1, 1, 0);
    }

    return 1;
}
CMD:gsign(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/gsign [1 - 15]");

    if(type < 1 || type > 15)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "GHANDS", "gsign1", 4.1, 1, 1, 1, 1, 1, 1);
        case 2: ApplyAnimationEx(playerid, "GHANDS", "gsign1LH", 4.1, 1, 1, 1, 1, 1, 1);
        case 3: ApplyAnimationEx(playerid, "GHANDS", "gsign2", 4.1, 1, 1, 1, 1, 1, 1);
        case 4: ApplyAnimationEx(playerid, "GHANDS", "gsign2LH", 4.1, 1, 1, 1, 1, 1, 1);
        case 5: ApplyAnimationEx(playerid, "GHANDS", "gsign3", 4.1, 1, 1, 1, 1, 1, 1);
        case 6: ApplyAnimationEx(playerid, "GHANDS", "gsign3LH", 4.1, 1, 1, 1, 1, 1, 1);
        case 7: ApplyAnimationEx(playerid, "GHANDS", "gsign4", 4.1, 1, 1, 1, 1, 1, 1);
        case 8: ApplyAnimationEx(playerid, "GHANDS", "gsign4LH", 4.1, 1, 1, 1, 1, 1, 1);
        case 9: ApplyAnimationEx(playerid, "GHANDS", "gsign5", 4.1, 1, 1, 1, 1, 1, 1);
        case 10: ApplyAnimationEx(playerid, "GHANDS", "gsign5", 4.1, 1, 1, 1, 1, 1, 1);
        case 11: ApplyAnimationEx(playerid, "GHANDS", "gsign5LH", 4.1, 1, 1, 1, 1, 1, 1);
        case 12: ApplyAnimationEx(playerid, "GANGS", "Invite_No", 4.1, 1, 1, 1, 1, 1, 1);
        case 13: ApplyAnimationEx(playerid, "GANGS", "Invite_Yes", 4.1, 1, 1, 1, 1, 1, 1);
        case 14: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkD", 4.1, 1, 1, 1, 1, 1, 1);
        case 15: ApplyAnimationEx(playerid, "GANGS", "smkcig_prtl", 4.1, 1, 1, 1, 1, 1, 1);
    }

    return 1;
}
CMD:konus(playerid, params[])return pc_cmd_chat(playerid, params);
CMD:chat(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/chat [1 - 8]");

    if(type < 1 || type > 8)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 3.1,1,1,1,1,1);
        case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 3.1,1,1,1,1,1);
        case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkC", 3.1,1,1,1,1,1);
        case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 3.1,1,1,1,1,1);
        case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 3.1,1,1,1,1,1);
        case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 3.1,1,1,1,1,1);
        case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 3.1,1,1,1,1,1);
        case 8: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 3.1,1,1,1,1,1);
    }

    return 1;
}
CMD:goggles(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);

    return 1;
}
CMD:throw(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.1, 0, 0, 0, 0, 0, 1);

    return 1;
}
CMD:swipe(playerid, params[])
{
    if(!AnimationCheck(playerid))return
            SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);

    return 1;
}
CMD:office(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/office [1 - 6]");

    if(type < 1 || type > 6)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Drink", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Read", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Type_Loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Watch", 4.1, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:kiss(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/kiss [1 - 6]");

    if(type < 1 || type > 6)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
        case 5: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
        case 6: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:knife(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/knife [1 - 8]");

    if(type < 1 || type > 8)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "KNIFE", "knife_1", 4.1, 0, 1, 1, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "KNIFE", "knife_2", 4.1, 0, 1, 1, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 1, 1, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "KNIFE", "knife_4", 4.1, 0, 1, 1, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "KNIFE", "WEAPON_knifeidle", 4.1, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Player", 4.1, 0, 0, 0, 0, 0, 1);
        case 7: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Damage", 4.1, 0, 0, 0, 0, 0, 1);
        case 8: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:cpr(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);

    return 1;
}
CMD:scratch(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/scratch [1 - 5]");

    if(type < 1 || type > 5)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "SCRATCHING", "scdldlp", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "SCRATCHING", "scdlulp", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "SCRATCHING", "scdrdlp", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "SCRATCHING", "scdrulp", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid,"MISC","Scratchballs_01", 4.0, 1, 0, 0, 0, 0);
    }

    return 1;
}

CMD:point(playerid, params[]) return pc_cmd_aim(playerid, params);
CMD:aim(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/aim [1 - 5]");

    if(type < 1 || type > 4)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0, 1);
        case 2: ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "SHOP", "ROB_loop", 4.1, 1, 0, 0, 0, 0);
    }

    return 1;
}

CMD:salute(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimationEx(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:laugh(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

	ApplyAnimationEx(playerid, "RAPPING", "Laugh_01", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:cheer(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/cheer [1 - 9]");

    if(type < 1 || type > 9)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.1, 0, 0, 0, 0, 0, 1);
        case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.1, 0, 0, 0, 0, 0, 1);
        case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.1, 0, 0, 0, 0, 0, 1);
        case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 0, 0, 0, 0, 1);
        case 9: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_loop", 3.0, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}

CMD:strip(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/strip [1 - 7]");

    if(type < 1 || type > 7)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "STRIP", "strip_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "STRIP", "strip_B", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "STRIP", "strip_C", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "STRIP", "strip_D", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "STRIP", "strip_E", 4.1, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimationEx(playerid, "STRIP", "strip_F", 4.1, 1, 0, 0, 0, 0, 1);
        case 7: ApplyAnimationEx(playerid, "STRIP", "strip_G", 4.1, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:wave(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/wave [1 - 3]");

    if(type < 1 || type > 3)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:smoke(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/smoke [1 - 3]");

    if(type < 1 || type > 3)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "SMOKING", "M_smkstnd_loop", 4.1, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:reload(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/reload [1 - 4]");

    if(type < 1 || type > 4)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.1, 0, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:taichi(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);

    return 1;
}
CMD:wank(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/wank [1 - 3]");

    if(type < 1 || type > 3)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "PAULNMAC", "wank_in", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.1, 0, 0, 0, 0, 0, 1);
    }

    return 1;
}
CMD:hide(playerid, params[])
{
    if(!AnimationCheck(playerid))return
    	SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

 	new type;
    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/hide [1 - 2]");

    if(type < 1 || type > 2)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 0, 0, 1, 0, 1);
        case 2: ApplyAnimationEx(playerid, "ON_LOOKERS", "panic_hide", 3.0, 1, 0, 0, 0, 0);
    }
    return 1;
}

CMD:drunk(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1);

    return 1;
}
CMD:cry(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1);

    return 1;
}
CMD:tired(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/tired [1 - 2]");

    if(type < 1 || type > 2)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
    }

    return 1;
}

CMD:otur(playerid, params[]) return pc_cmd_sit(playerid, params);
CMD:sit(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/sit [1 - 6]");

    if(type < 1 || type > 6)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loop", 4.1, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "INT_HOUSE", "LOU_In", 4.1, 0, 0, 0, 1, 0);
        case 3: ApplyAnimationEx(playerid, "MISC", "SEAT_LR", 4.1, 1, 0, 0, 0, 0);
        case 4: ApplyAnimationEx(playerid, "MISC", "Seat_talk_01", 4.1, 1, 0, 0, 0, 0);
        case 5: ApplyAnimationEx(playerid, "MISC", "Seat_talk_02", 4.1, 1, 0, 0, 0, 0);
        case 6: ApplyAnimationEx(playerid, "ped", "SEAT_down", 4.1, 0, 0, 0, 1, 0);
    }

    return 1;
}
CMD:crossarms(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/crossarms [1 - 4]");

    if(type < 1 || type > 4)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 0, 1);
        case 2: ApplyAnimationEx(playerid, "GRAVEYARD", "prst_loopa", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 0, 1);
    }

    return 1;
}
CMD:fucku(playerid, params[])
{
    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

	new type;

 	if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/fucku [1 - 2]");

    if(type < 1 || type > 2)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

	switch(type)
    {
    	case 1: ApplyAnimation(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "RIOT", "RIOT_FUKU" ,2.0, 0, 0, 0, 0, 0);
	}
    return 1;
}
CMD:pedmove(playerid, params[])return pc_cmd_walk(playerid, params);
CMD:yuru(playerid, params[])return pc_cmd_walk(playerid, params);
CMD:walk(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/walk [1 - 21]");

    if(type < 1 || type > 21)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "FAT", "FatWalk", 4.1, 1, 1, 1, 1, 1, 1);
        case 2: ApplyAnimationEx(playerid, "MUSCULAR", "MuscleWalk", 4.1, 1, 1, 1, 1, 1, 1);
        case 3: ApplyAnimationEx(playerid, "PED", "WALK_armed", 4.1, 1, 1, 1, 1, 1, 1);
        case 4: ApplyAnimationEx(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1, 1);
        case 5: ApplyAnimationEx(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1, 1);
        case 6: ApplyAnimationEx(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1, 1);
        case 7: ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1, 1);
        case 8: ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1, 1);
        case 9: ApplyAnimationEx(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1, 1);
        case 10: ApplyAnimationEx(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1, 1);
        case 11: ApplyAnimationEx(playerid, "PED", "WALK_wuzi", 4.1, 1, 1, 1, 1, 1, 1);
        case 12: ApplyAnimationEx(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1, 1);
        case 13: ApplyAnimationEx(playerid, "PED", "WOMAN_walkfatold", 4.1, 1, 1, 1, 1, 1, 1);
        case 14: ApplyAnimationEx(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1, 1);
        case 15: ApplyAnimationEx(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1, 1);
        case 16: ApplyAnimationEx(playerid, "PED", "WOMAN_walkshop", 4.1, 1, 1, 1, 1, 1, 1);
        case 17: SunucuMesaji(playerid, "Bu animasyon /walk 11 komutuna taþýndý, o komutu deneyin.");
        case 18: ApplyAnimationEx(playerid, "WUZI", "Wuzi_walk", 3.0, 1, 1, 1, 1, 1, 1);
        case 19: ApplyAnimationEx(playerid, "POOL", "Pool_walk", 3.0, 1, 1, 1, 1, 1, 1);
        case 20: ApplyAnimationEx(playerid, "PED", "woman_walkold", 3.0, 1, 1, 1, 1, 1, 1);
        case 21: ApplyAnimationEx(playerid, "PED", "woman_walkpro", 3.0, 1, 1, 1, 1, 1, 1);
    }
    return 1;
}

CMD:fall(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/fall [1 - 5]");

    if(type < 1 || type > 5)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
        case 2: ApplyAnimationEx(playerid, "PED", "KO_shot_face", 4.0, 0, 1, 1, 1, 0, 1);
        case 3: ApplyAnimationEx(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0, 1);
        case 4: ApplyAnimationEx(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 1, 0, 1);
        case 5: ApplyAnimationEx(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
    }

    return 1;
}
CMD:lean(playerid, params[])
{
    new type;

    if(!AnimationCheck(playerid))return
        SunucuMesajiC(playerid, "Þu anda bu komutu kullanamazsýn.");

    if(sscanf(params, "d", type))return
        KullanimMesajiC(playerid, "/lean [1 - 2]");

    if(type < 1 || type > 2)return
        SunucuMesajiC(playerid, "Belirli deðerler arasýnda sayý kullanýn.");

    switch(type)
    {
        case 1: ApplyAnimationEx(playerid, "GANGS", "leanIDLE", 4.0, 1, 0, 0, 0, 0);
        case 2: ApplyAnimationEx(playerid, "MISC", "Plyrlean_loop", 4.0, 0, 1, 1, 1,0);
    }

    return 1;
}

flags:basinkarti(CMD_LSNN);
CMD:basinkarti(playerid, params[])
{
    new id;
    new factionID = PlayerInfo[playerid][pFaction];

    if(sscanf(params, "k<m>", id)) id = playerid;

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(!ProxDetectorS(5.0, playerid, id))return
        SunucuMesajiC(playerid, "Bu oyuncuya yakýn deðilsin.");

    SendFormattedMessage(id, COLOR_RADIO, "[BASIN KARTI] %s - %s %s", FactionInfo[factionID][fName], fRanks[factionID][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid));

    if(playerid != id)
        PlayerMEPlayer(playerid, id, "kiþisine basýn kartýný gösterir");

    return 1;
}

CMD:rozetgoster(playerid, params[])
{
    new id;
    new factionID = PlayerInfo[playerid][pFaction];

    if(sscanf(params, "k<m>", id)) id = playerid;

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(!ProxDetectorS(5.0, playerid, id))return
        SunucuMesajiC(playerid, "Bu oyuncuya yakýn deðilsin.");

    SendFormattedMessage(id, COLOR_RADIO, "[ROZET] %s - %s %s", FactionInfo[factionID][fName], fRanks[factionID][PlayerInfo[playerid][pRank] - 1], ReturnRoleplayName(playerid));

    if(playerid != id)
        PlayerMEPlayer(playerid, id, "kiþisine rozetini gösterir");

    return 1;
}

CMD:pos(playerid, params[])
{
	new Float:Pos[3], Float:angle;

	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	GetPlayerFacingAngle(playerid, angle);
    SunucuMesaji(playerid, "POS: %f, %f, %f, %f", Pos[0], Pos[1], Pos[2], angle);
	return 1;
}

SendOOCMessage(playerid, params[], Float:range = 15.0)
{
    new string[256], id_string[12];

    if(isnull(params) || strlen(params) > 256)return
        KullanimMesajiC(playerid, "/b [yazý]");

    if(!PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pSupporterDuty])
    {
    	format(id_string, sizeof(id_string), (PlayerInfo[playerid][pMasked]) ? ("[//]") : ("[%d]"), playerid);

        format(string,sizeof(string), "(( %s %s: %s ))", id_string, ReturnRoleplayName(playerid, true), params);
        ProxDetector(range, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, .togOOC = true);
       	printf("[B-OOC] %s: %s", ReturnRoleplayName(playerid), params);

    }
    else
    {
        if(PlayerInfo[playerid][pTogOOC])return
            SunucuMesajiC(playerid, "Tüm OOC sohbetleri devre dýþý býraktýn. (/bdurum)");

        format(string, sizeof(string), (PlayerInfo[playerid][pAdminDuty]) ? ("(( [%d] {ff9900}%s{FFFFFF}: %s ))") : ("(( [%d] {FFFFFF}%s: %s ))"), playerid, ReturnRoleplayName(playerid), params);
        ProxDetector(range, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE);
//      LogYaz(playerid, string, -1);
 		printf("[B-OOC] %s: %s", ReturnRoleplayName(playerid), params);

    }

    return 1;
}

CMD:sme(playerid, params[])
{
/*    if(PlayerInfo[playerid][pTVActor] != -1)
        return HataMesaji(playerid, "Bu iþlemi yapamazsýnýz.");
*/
    if(sscanf(params, "ds[128]", params[0], params[1]))
        return KullanimMesajiC(playerid, "/sme [süre(10-120)] [yazý]");

    if(params[0] < 10 || params[0] > 120)
        return HataMesaji(playerid, "Süre en az 10, en fazla 120 saniye olabilir.");

    return PlayerSME(playerid, params[0], params[1]);
}

CMD:animdurdur(playerid, params[])
{
    if(!AnimationCheck(playerid))return 1;

    ClearAnimations(playerid);
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

    PlayerInfo[playerid][pLoopAnim] = false;

    return 1;
}

CMD:gir(playerid, params[])
{
    if(PlayerInfo[playerid][pSnakeCamActor] != -1)return
        SunucuMesajiC(playerid, "Snakecam'i kapatman gerekiyor. (Tekrar /snakecam kullan.)");

    if(PlayerInfo[playerid][pEditingMode])return
        SunucuMesajiC(playerid, "Düzenleme yaparken bunu yapamazsýn.");

    CancelEdit(playerid);

    if(Pickup_Nearest(playerid, ELEMENT_OTEL) != -1) { // otel giriþine yakýnsa
    	new otel = Pickup_Nearest(playerid, ELEMENT_OTEL);
    	if(OtelInfo[otel][otelKilitli]) return HataMesajiC(playerid, "Bu otel odasý kilitli.");
    	SetFreezePos(playerid, OtelInfo[otel][otelIntX], OtelInfo[otel][otelIntY], OtelInfo[otel][otelIntZ]);
        SetPlayerInterior(playerid, OtelInfo[otel][otelIntInterior]);
        AC_SetPlayerVirtualWorld(playerid, OtelInfo[otel][otelIntWorld]);
        return 1;
    }
    else if(GetPlayerOtel(playerid) != -1) { // otel çýkýþýna yakýnsa
    	new otel = GetPlayerOtel(playerid);
    	SetFreezePos(playerid, OtelInfo[otel][otelDisX], OtelInfo[otel][otelDisY], OtelInfo[otel][otelDisZ]);
        SetPlayerInterior(playerid, OtelInfo[otel][otelDisInterior]);
        AC_SetPlayerVirtualWorld(playerid, OtelInfo[otel][otelDisWorld]);
    	return 1;
    }

	for(new is = 0; is < sizeof(asansor); is ++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, asansor[is][gX], asansor[is][gY], asansor[is][gZ]))
		{
			new str_long[2048], str[32];
			for(new iss = 0; iss < sizeof(asansor); iss ++)
			{
				format(str, sizeof str, "%s\n", asansor[iss][katad]);
				strcat(str_long, str);
			}
			Dialog_Show(playerid, DIALOG_ASANSOR, DIALOG_STYLE_LIST, "Asansör", str_long, "Bin", "Çýk");
			return 1;
		}
	}
	if(!IsPlayerInAnyVehicle(playerid) && !PlayerInfo[playerid][pGemide]) {
	    new veh = GetNearestVehicle(playerid);
		if(veh != -1) {
		    if(GetVehicleModel(veh) == 454 || GetVehicleModel(veh) == 484) {
		        if(!VehicleInfo[veh][vLocked]) {
			        SetFreezePos(playerid, 2513.0679,-1729.2339,778.6371);
			        SetPlayerFacingAngle(playerid, 90.0);
			        SetPlayerVirtualWorld(playerid, veh);
			        PlayerInfo[playerid][pGemide] = true;
				} else HataMesaji(playerid, "Bu gemi kilitli.");
		    }
		}
	} else if(!IsPlayerInAnyVehicle(playerid) && PlayerInfo[playerid][pGemide] && IsPlayerInRangeOfPoint(playerid, 2.0, 2513.0679,-1729.2339,778.6371)) {
	    new veh = GetPlayerVirtualWorld(playerid), Float:vA;
    	if(!VehicleInfo[veh][vLocked]) {
    	    if(VehicleInfo[veh][vModel] == 454) {
	    	    new Float:tX, Float:tY, Float:tZ;
	    	    GetVehicleZAngle(veh, vA);
	    	    vA += 90.0;
		    	GetPosBehindVehicle(veh, tX, tY, tZ, -5.0);
				PlayerInfo[playerid][pGemide] = false;
		        SetFreezePos(playerid, tX, tY, tZ+1.0);
		        SetPlayerFacingAngle(playerid, vA);
		        SetPlayerVirtualWorld(playerid, 0);
			} else if(VehicleInfo[veh][vModel] == 484) {
			    new Float:tX, Float:tY, Float:tZ;
	    	    GetVehicleZAngle(veh, vA);
	    	    vA += 90.0;
		    	GetPosBehindVehicle(veh, tX, tY, tZ, -11.0);
				PlayerInfo[playerid][pGemide] = false;
		        SetFreezePos(playerid, tX, tY, tZ+2.0);
		        SetPlayerFacingAngle(playerid, vA);
		        SetPlayerVirtualWorld(playerid, 0);
			} else return HataMesaji(playerid, "Buga girdiniz, lütfen /rapor komutunu kullanýn.");
		} else HataMesaji(playerid, "Bu gemi kilitli.");
	}
	if(!IsPlayerInAnyVehicle(playerid) && !PlayerInfo[playerid][pKaravanda]) {
	    new veh = GetNearestVehicle(playerid);
		if(veh != -1) {
		    if(GetVehicleModel(veh) == 508) {
		        if(!VehicleInfo[veh][vLocked]) {
			        SetFreezePos(playerid, 2513.0679,-1729.2339,778.6371);
			        SetPlayerFacingAngle(playerid, 90.0);
			        SetPlayerVirtualWorld(playerid, veh);
			        PlayerInfo[playerid][pKaravanda] = true;
				} else HataMesaji(playerid, "Bu karavan kilitli.");
		    }
		}
	} else if(!IsPlayerInAnyVehicle(playerid) && PlayerInfo[playerid][pKaravanda] && IsPlayerInRangeOfPoint(playerid, 2.0, 2513.0679,-1729.2339,778.6371)) {
	    new veh = GetPlayerVirtualWorld(playerid), Float:vX, Float:vY, Float:vZ, Float:vA;
    	if(!VehicleInfo[veh][vLocked]) {
    	    GetVehiclePos(veh, vX, vY, vZ);
    	    GetVehicleZAngle(veh, vA);
    	    vA += 90.0;
    	    new const Float:UZAKLIK = 3.0;
			new Float:aci = vA - 180.0;
			PlayerInfo[playerid][pKaravanda] = false;
	        SetFreezePos(playerid, vX, vY + UZAKLIK * floatcos(-aci, degrees), vZ);
	        SetPlayerFacingAngle(playerid, vA);
	        SetPlayerVirtualWorld(playerid, 0);
		} else HataMesaji(playerid, "Bu karavan kilitli.");
	}
    if(PlayerInfo[playerid][pFactionDuty] && IsPlayerInRangeOfPoint(playerid, 5.0, 2110.694335, -2143.989501, 13.632812)) return SetPlayerPos(playerid, 2039.716918, -2151.604492, 19.834426);
    else if(PlayerInfo[playerid][pFactionDuty] && IsPlayerInRangeOfPoint(playerid, 5.0, 2039.716918, -2151.604492, 19.834426)) return SetPlayerPos(playerid, 2110.694335, -2143.989501, 13.632812);

    if(GetPlayerHouse(playerid, false) != -1 || GetPlayerHouse(playerid, true) != -1)
    {
        new houseid = (GetPlayerHouse(playerid, false) == -1) ? GetPlayerHouse(playerid, true) : GetPlayerHouse(playerid, false);

        if(IsPlayerInRangeOfPoint(playerid, 1.0, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[houseid][hPosWorld] && GetPlayerInterior(playerid) == HouseInfo[houseid][hPosInterior])
        {
            if(HouseInfo[houseid][hLocked])return
                Player_Info(playerid, "Kilit: ~r~kilitli~w~.");
            if(HouseInfo[houseid][hPosIntX] == 0.0)return SunucuMesajiC(playerid, "Bu evin bir iç tasarýmý yok. Lütfen ev için bir iç tasarým belirleyin.");
            SetFreezePos(playerid, HouseInfo[houseid][hPosIntX], HouseInfo[houseid][hPosIntY], HouseInfo[houseid][hPosIntZ]);
            SetPlayerInterior(playerid, HouseInfo[houseid][hInterior]);
            AC_SetPlayerVirtualWorld(playerid, HouseInfo[houseid][hWorld]);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[houseid][hPosIntX], HouseInfo[houseid][hPosIntY], HouseInfo[houseid][hPosIntZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[houseid][hWorld] && GetPlayerInterior(playerid) == HouseInfo[houseid][hInterior])
        {
            if(HouseInfo[houseid][hLocked])return
                Player_Info(playerid, "Kilit: ~r~kilitli~w~.");

            SetFreezePos(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
            SetPlayerInterior(playerid, HouseInfo[houseid][hPosInterior]);
            AC_SetPlayerVirtualWorld(playerid, HouseInfo[houseid][hPosWorld]);
            SetPlayerTime(playerid, SunucuBilgi[CurrentHour], 0);
        }
        //else return 1;
    }

    if(GetPlayerBuilding(playerid, false) != -1 || GetPlayerBuilding(playerid, true) != -1)
    {
        new buildingid  = (GetPlayerBuilding(playerid, false) == -1) ? GetPlayerBuilding(playerid, true) :  GetPlayerBuilding(playerid, false);

        if(BuildingInfo[buildingid][bType] == PNS || BuildingInfo[buildingid][bType] == FUEL_STATION)return 1;

        if(IsPlayerInRangeOfPoint(playerid, 1.0, BuildingInfo[buildingid][bPosX], BuildingInfo[buildingid][bPosY], BuildingInfo[buildingid][bPosZ]) && GetPlayerVirtualWorld(playerid) == BuildingInfo[buildingid][bPosWorld] && GetPlayerInterior(playerid) == BuildingInfo[buildingid][bPosInterior])
        {
            if(BuildingInfo[buildingid][bLocked])return
                Player_Info(playerid, "Kilit: ~r~kilitli~w~.");
            if(BuildingInfo[buildingid][bPosIntX] == 0.0)return SunucuMesajiC(playerid, "Bu iþletmenin bir iç dizayný yok, /isletme > Interior seçeneði ile bir iç dizayn koymalýsýn");
			if(BuildingInfo[buildingid][bMuhurlu]) return HataMesaji(playerid, "Bu iþyeri mühürlü olduðu için içeriye giremezsin.");

			if(BuildingInfo[buildingid][bOwner] != 49 && BuildingInfo[buildingid][bType] != BLACK_MARKET && BuildingInfo[buildingid][bType] != AMMUNATION && BuildingInfo[buildingid][bType] != BANK &&  BuildingInfo[buildingid][bType] != ADVERTISEMENT && BuildingInfo[buildingid][bType] != COMPLEX && BuildingInfo[buildingid][bType] != GARAJ && BuildingInfo[buildingid][bType] != BUILDING && BuildingInfo[buildingid][bVergi] >= BuildingInfo[buildingid][bPrice] / 2 && BuildingInfo[buildingid][bVergi] != 0 && BuildingInfo[buildingid][bPrice] > 1000)
				return HataMesaji(playerid, "Bu iþletmenin vergi borcu bulunuyor, içeriye giriþ yapamazsýnýz.");

			if(BuildingInfo[buildingid][bType] == KUMARHANE)
			{
				if(PlayerInfo[playerid][pAdmin] > 3 || BuildingInfo[buildingid][bOwner] == PlayerInfo[playerid][pID])
					SunucuMesaji(playerid, "Bu kumarhanenin kasasýnda $%d bulunuyor.", BuildingInfo[buildingid][bCash]);
			}

            if(PlayerInfo[playerid][pID] != BuildingInfo[buildingid][bOwner] && BuildingInfo[buildingid][bEntrance] > 0)
            {
				if(HasPlayerUserKey(playerid, KEY_BUILDING, BuildingInfo[buildingid][bID]) == 0 && PlayerInfo[playerid][pCalistigiIsyeri] != buildingid)
				{
					if(Faction_GetType(PlayerInfo[playerid][pFaction]) != POLICE && Faction_GetType(PlayerInfo[playerid][pFaction]) != MEDICAL && Faction_GetType(PlayerInfo[playerid][pFaction]) != GOVERNMENT) {
						if(PlayerInfo[playerid][pCash] < BuildingInfo[buildingid][bEntrance])return
							Player_Info(playerid, "Yeterli paraniz ~r~yok~y~.");

						AC_GivePlayerMoney(playerid, -BuildingInfo[buildingid][bEntrance], "/gir");
						BuildingInfo[buildingid][bCash] += BuildingInfo[buildingid][bEntrance];
					} else {
						if(!PlayerInfo[playerid][pFactionDuty]) {
							if(PlayerInfo[playerid][pCash] < BuildingInfo[buildingid][bEntrance])return
							Player_Info(playerid, "Yeterli paraniz ~r~yok~y~.");

							AC_GivePlayerMoney(playerid, -BuildingInfo[buildingid][bEntrance], "/gir");
							BuildingInfo[buildingid][bCash] += BuildingInfo[buildingid][bEntrance];
						}
						else {
							SunucuMesajiC(playerid, "Ýþbaþýnda bir devlet memuru olduðunuz için giriþ ücreti ödemediniz.");
						}
					}
				}
            }

			if(BuildingInfo[buildingid][bType] == TAMIRHANE || BuildingInfo[buildingid][bType] == GARAJ)
			{
				TeleportToCoords(playerid, BuildingInfo[buildingid][bPosIntX], BuildingInfo[buildingid][bPosIntY], BuildingInfo[buildingid][bPosIntZ], 90.0,  BuildingInfo[buildingid][bInterior], BuildingInfo[buildingid][bWorld], true, true);
			}
            else
			{
				SetFreezePos(playerid, BuildingInfo[buildingid][bPosIntX], BuildingInfo[buildingid][bPosIntY], BuildingInfo[buildingid][bPosIntZ]);
				SetPlayerInterior(playerid, BuildingInfo[buildingid][bInterior]);
				AC_SetPlayerVirtualWorld(playerid, BuildingInfo[buildingid][bWorld]);
			}

            if(BuildingInfo[buildingid][bStereo])
            {
                StopAudioStreamForPlayer(playerid);
                PlayAudioStreamForPlayer(playerid, BuildingInfo[buildingid][bStereoLink]);
            }

            if(BuildingInfo[buildingid][bType] != COMPLEX && BuildingInfo[buildingid][bType] != BUILDING && BuildingInfo[buildingid][bType] != BANK)
                Player_Info(playerid, "~y~/satinal~w~");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, BuildingInfo[buildingid][bPosIntX], BuildingInfo[buildingid][bPosIntY], BuildingInfo[buildingid][bPosIntZ]) && GetPlayerVirtualWorld(playerid) == BuildingInfo[buildingid][bWorld] && GetPlayerInterior(playerid) == BuildingInfo[buildingid][bInterior])
        {
            if(BuildingInfo[buildingid][bLocked])return
                Player_Info(playerid, "Kilit: ~r~kilitli~w~.");

			if(BuildingInfo[buildingid][bType] == TAMIRHANE || BuildingInfo[buildingid][bType] == GARAJ)
			{
				TeleportToCoords(playerid, BuildingInfo[buildingid][bPosX], BuildingInfo[buildingid][bPosY], BuildingInfo[buildingid][bPosZ], BuildingInfo[buildingid][bPosA], BuildingInfo[buildingid][bPosInterior], BuildingInfo[buildingid][bPosWorld], true, true);
			}
            else
			{
				SetFreezePos(playerid, BuildingInfo[buildingid][bPosX], BuildingInfo[buildingid][bPosY], BuildingInfo[buildingid][bPosZ]);
				SetPlayerInterior(playerid, BuildingInfo[buildingid][bPosInterior]);
				SetPlayerFacingAngle(playerid, BuildingInfo[buildingid][bPosA]);
				AC_SetPlayerVirtualWorld(playerid, BuildingInfo[buildingid][bPosWorld]);
				StopAudioStreamForPlayer(playerid);
				SetPlayerTime(playerid, SunucuBilgi[CurrentHour], 0);
			}
		}
        //else return 1;
    }

    if(GetPlayerTeleport(playerid) != -1)
    {
        new i = GetPlayerTeleport(playerid);

        if(TeleportInfo[i][teleportFaction] != -1 && PlayerInfo[playerid][pFaction] != TeleportInfo[i][teleportFaction])return 1;
		if(!TeleportInfo[i][tExists])return 1;

		if(TeleportInfo[i][tKilitli])
		{
			new sifre[8];
			sscanf(params, "S(-1)[8]", sifre);
			
			if(strcmp(TeleportInfo[i][tSifre], sifre, true) && TeleportInfo[i][tSahip] != PlayerInfo[playerid][pID])
				return Dialog_Show(playerid, DialogTPSifre, DIALOG_STYLE_INPUT, "Kapý Þifresi", "Kapý þifresini girin:", "Giriþ", "Ýptal");
				
			else if(TeleportInfo[i][tSahip] != PlayerInfo[playerid][pID] && !PlayerInfo[playerid][pAdminDuty])
				return Player_Info(playerid, "Kilit: ~r~kilitli~w~.");
		}

        if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) != 0) return
            SunucuMesajiC(playerid, "Bunu yapamazsýnýz.");

        new vehicleid = GetPlayerVehicleID(playerid), seat;
        new playerState = IsPlayerInAnyVehicle(playerid);

        static const Float:teleportRange[] = {1.0, 7.0};

        if(IsPlayerInRangeOfPoint(playerid, teleportRange[playerState], TeleportInfo[i][teleportX], TeleportInfo[i][teleportY], TeleportInfo[i][teleportZ]) && GetPlayerVirtualWorld(playerid) == TeleportInfo[i][teleportWorld] && GetPlayerInterior(playerid) == TeleportInfo[i][teleportInterior])
        {
            if(IsPlayerInAnyVehicle(playerid))
            {
                foreach(new pid : Player) if(playerid != pid && IsPlayerInAnyVehicle(pid) && GetPlayerVehicleID(pid) == vehicleid)
                {
                    AC_SetPlayerVirtualWorld(pid, TeleportInfo[i][teleportGWorld]);
                    SetTimerEx("PutPlayerInVeh", 1500, false, "ddd", pid, vehicleid, seat);
                }
                SetVehiclePos(vehicleid, TeleportInfo[i][teleportGX] + 2.0, TeleportInfo[i][teleportGY], TeleportInfo[i][teleportGZ]);
                SetVehicleZAngle(vehicleid, TeleportInfo[i][teleportGA]);
                SetVehicleVirtualWorld(vehicleid, TeleportInfo[i][teleportGWorld]);
                LinkVehicleToInterior(vehicleid, TeleportInfo[i][teleportGInterior]);
            }
            else SetFreezePos(playerid, TeleportInfo[i][teleportGX], TeleportInfo[i][teleportGY], TeleportInfo[i][teleportGZ]);

            AC_SetPlayerVirtualWorld(playerid, TeleportInfo[i][teleportGWorld]);
            SetPlayerInterior(playerid, TeleportInfo[i][teleportGInterior]);
        }
        else if(IsPlayerInRangeOfPoint(playerid, teleportRange[playerState], TeleportInfo[i][teleportGX], TeleportInfo[i][teleportGY], TeleportInfo[i][teleportGZ]) && GetPlayerVirtualWorld(playerid) == TeleportInfo[i][teleportGWorld] && GetPlayerInterior(playerid) == TeleportInfo[i][teleportGInterior])
        {
            if(IsPlayerInAnyVehicle(playerid))
            {
                foreach(new pid : Player) if(playerid != pid && IsPlayerInAnyVehicle(pid) && GetPlayerVehicleID(pid) == vehicleid)
                {
                    AC_SetPlayerVirtualWorld(pid, TeleportInfo[i][teleportWorld]);
                    SetTimerEx("PutPlayerInVeh", 1500, false, "ddd", pid, vehicleid, seat);
                }
                SetVehiclePos(vehicleid, TeleportInfo[i][teleportX] + 2.0, TeleportInfo[i][teleportY], TeleportInfo[i][teleportZ]);
                SetVehicleVirtualWorld(vehicleid, TeleportInfo[i][teleportWorld]);
                SetVehicleZAngle(vehicleid, TeleportInfo[i][teleportA]);
                LinkVehicleToInterior(vehicleid, TeleportInfo[i][teleportInterior]);
            }
            else SetFreezePos(playerid, TeleportInfo[i][teleportX], TeleportInfo[i][teleportY], TeleportInfo[i][teleportZ]);

            AC_SetPlayerVirtualWorld(playerid, TeleportInfo[i][teleportWorld]);
            SetPlayerInterior(playerid, TeleportInfo[i][teleportInterior]);
        }
    }
    

    return 1;
}
CMD:cikis(playerid, params[])return pc_cmd_gir(playerid, params);
CMD:cik(playerid, params[])return pc_cmd_gir(playerid, params);
CMD:giris(playerid, params[])return pc_cmd_gir(playerid,params);

CMD:kisayolaktif(playerid, params[])
{
    if(!PlayerInfo[playerid][pShortcut])
    {
        PlayerInfo[playerid][pShortcut] = 1;
        SendClientMessageEx(playerid, COLOR_WHITE, "Tuþlarý aktif ettin. Aþaðýda listelenen tuþlarý artýk kullanabileceksin.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "Y: Bir evin, iþletmenin veya binanýn içine girmeye ve motoru açýp kapatmaya yarar.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "2: Aracýn farlarýný açýp kapatmaya yarar, araçtayken çalýþýr.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "N: Animasyon durdurmaya, araç kilidi açýp kapatmaya yarar.");
    }
    else
    {
        PlayerInfo[playerid][pShortcut] = 0;
        SendClientMessageEx(playerid, COLOR_WHITE, "Tuþlarý deaktif ettin. Tuþlarý kullanamýyosun, aþaðýda komutlar listelendi.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "/gir - /cik: Eve, iþletmeye, binalara girmeye yarar.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "/arac motor: Aracýn motorunu açýp kapatmaya yarar.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "/arac far: Aracýn ýþýklarýný açýp kapatmaya yarar.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "/arac kilit: Aracýn kilidini açýp kapatmaya yarar.");
    }
    return 1;
}

// Premium Komutlarý

CMD:bdurum(playerid, params[])
{
    if(!PlayerInfo[playerid][pPremium] && !PlayerInfo[playerid][pTogOOCPremium]) return
        SunucuMesajiC(playerid, "Bu komutu donatorler kullanabilir.");

    if(isnull(params)) return
        KullanimMesajiC(playerid, "/bdurum [id/all]");

    if(!strcmp(params, "all", true))
    {
        PlayerInfo[playerid][pTogOOC] = !PlayerInfo[playerid][pTogOOC];
        SendFormattedMessage(playerid, COLOR_LIGHTRED, (!PlayerInfo[playerid][pTogOOC]) ? ("OOC mesajlar açýldý.") : ("OOC mesajlar kapandý."));
    }
    else
    {
        new id;

        if(sscanf(params, "k<m>", id)) return
            KullanimMesajiC(playerid, "/bdurum [id/all]");

        if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged]) return
            SunucuMesajiC(playerid, "Kullanýcý baðlý deðil.");

        PlayerInfo[playerid][pTogOOCPlayer][id] = !PlayerInfo[playerid][pTogOOCPlayer][id];
        SendFormattedMessage(playerid, COLOR_LIGHTRED, (!PlayerInfo[playerid][pTogOOCPlayer][id]) ? ("%s (%d) için OOC mesajlarý açtýnýz.") : ("%s (%d) kiþisinin OOC mesajlarýný blokladýn."), ReturnRoleplayName(id), id);
    }

    return 1;
}
CMD:pmdurum(playerid, params[])
{
    if(isnull(params)) return
        KullanimMesajiC(playerid, "/pmdurum [id/all/liste]");

    if(!strcmp(params, "all", true) || !strcmp(params, "hepsi", true))
    {
        if(!PlayerInfo[playerid][pPremium] && !PlayerInfo[playerid][pTogPMPremium] && PlayerInfo[playerid][pAdmin] < 2) return
            SunucuMesajiC(playerid, "Bu komutu kullanmak için donator olmalýsýnýz.");

		if(PlayerInfo[playerid][pTogPM]) PlayerInfo[playerid][pTogPM] = 0;
		else PlayerInfo[playerid][pTogPM] = 1;
        SendClientMessageEx(playerid, COLOR_GREEN, (!PlayerInfo[playerid][pTogPM]) ? ("PM almayý açtýnýz.") : ("PM almayý durdurdunuz."));
    }
    else if(!strcmp(params, "liste", true))
	{
	    new string[400];
	    format(string, sizeof(string), "");
	    foreach(new i : Player) if(PlayerInfo[playerid][pTogPMPlayer][i] == 1)
	    {
	        format(string, sizeof(string), "%s%s\tID: %d\n", string, ReturnRoleplayName(i), i);
	    }
	    Dialog_Show(playerid, 0, DIALOG_STYLE_TABLIST, "Engellenen Kiþiler", string, "Kapat", "");
	}
    else
    {
        new id;

        if(!PlayerInfo[playerid][pPremium] && !PlayerInfo[playerid][pTogPMPremium] && PlayerInfo[playerid][pAdmin] < 2) return
            SunucuMesajiC(playerid, "Bu komutu kullanmak için donator olmalýsýnýz.");

        if(sscanf(params, "k<m>", id)) return
            KullanimMesajiC(playerid, "/pmdurum [id]");

        if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged] || id == playerid) return
            SunucuMesajiC(playerid, "Hatalý ID girdiniz veya kullanýcý sunucuya henüz giriþ yapmamýþ.");

        PlayerInfo[playerid][pTogPMPlayer][id] = !PlayerInfo[playerid][pTogPMPlayer][id];
        SendFormattedMessage(playerid, COLOR_LIGHTRED, (!PlayerInfo[playerid][pTogPMPlayer][id]) ? ("%s (%d) kiþisinden PM almayý açtýnýz.") : ("%s (%d) kiþisinden PM almayý engellediniz."), ReturnRoleplayName(id), id);
    }
    return 1;
}
CMD:pmodak(playerid, params[])
{
    if(!PlayerInfo[playerid][pPremium]) return
        SunucuMesajiC(playerid, "Bu komutu donatorler kullanabilir.");

    if(PlayerInfo[playerid][pConvOOC] != -1) return
        SunucuMesajiC(playerid, "Zaten bir kullanýcýyla konuþuyorsun, /pmodakbitir kullan.");

    new id;

    if(sscanf(params, "k<m>", id)) return
        KullanimMesajiC(playerid, "/pmodak [id]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged]) return
        SunucuMesajiC(playerid, "Kullanýcý baðlý deðil.");

    if(id == playerid) return
        SunucuMesajiC(playerid, "Kendinle konuþma baþlatamazsýn.");

    PlayerInfo[playerid][pConvOOC] = id;

    BasariMesaji(playerid, "%s (%d) kiþisine PM ile odaklandýn. Bitirmek için /pmodakbitir kullan.", ReturnRoleplayName(id), id);
    SendClientMessageEx(playerid, COLOR_GREEN, "Sohbet sýrasýnda direkt olarak yazdýðýnýz yazý PM olarak seçtiðiniz kiþiye gidecektir.");

    return 1;
}
CMD:pmodakbitir(playerid, params[])
{
    if(PlayerInfo[playerid][pConvOOC] == -1) return
        SunucuMesajiC(playerid, "Bir kullanýcýyla görüþmüyorsun.");

    new id = PlayerInfo[playerid][pConvOOC];

    BasariMesaji(playerid, "%s(%d) ile yaptýðýn özel mesaj görüþmesini bitirdin.", ReturnRoleplayName(id), id);

    PlayerInfo[playerid][pConvOOC] = -1;

    return 1;
}