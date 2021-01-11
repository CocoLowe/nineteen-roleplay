// Oyuncu Komutlarý

CMD:soru(playerid, params[]) return pc_cmd_sorusor(playerid, params);
CMD:newbie(playerid, params[])return pc_cmd_sorusor(playerid, params);
CMD:n(playerid, params[])return pc_cmd_sorusor(playerid, params);
CMD:sorusor(playerid, params[])
{
    if(PlayerInfo[playerid][pRequestCount] >= MAX_REQUESTS_FOR_PLAYER)return
        HataMesaji(playerid, "Yanýtlanmamýþ bir talebin varken soru gönderemezsin. (/talepiptal)");

    if(isnull(params) || strlen(params) > 128)return
        KullanimMesajiC(playerid, "/sorusor [yazý]");

    format(PlayerInfo[playerid][pTmpText], 256, params);

    new string[1024] = "Bu soruyu göndermek istediðinden emin misin?\n\
    Sistemlerle alakalý sorularýnýzýn yanýtýný Forum > Sistem Tanýtýmlarý bölümünde bulabilirsiniz.\n\
    Kurallarla alakalý sorularýnýzýn yanýtýný Forum > Kural & Kural Güncellemeleri bölümünde bulabilirsiniz.\n\
	{FF6347}Bir bug durumunda olduðunuzu düþünüyorsanýz: {FFFFFF}/bugkurtar{FF6347} komutunu kullanarak kurtulabilirsiniz.\n\
    {FF6347}Aþaðýdaki soruyu göndermek istediðinizden emin misiniz? (Uygunsuz mesajýn / sorunun cezalandýrýlabileceðini unutmayýn)\n";

    format(string, sizeof(string), "{FFFFFF}%sGönderilen soru: %s", string, PlayerInfo[playerid][pTmpText]);
    Dialog_Show(playerid, DialogConfirmSoru, DIALOG_STYLE_MSGBOX, "Soru Gönderme Politikasý", string, "Gönder", "Ýptal");
    return 1;
}

CMD:saat(playerid, params[])
{
    new string[90], date[6];

    getdate(date[2], date[1], date[0]);
    gettime(date[3], date[4], date[5]);

    static const Months[][12] = {"OCAK", "SUBAT", "MART", "NISAN", "MAYIS", "HAZIRAN", "TEMMUZ", "AGUSTOS", "EYLUL", "EKIM", "KASIM", "ARALIK"};

    format(string, sizeof(string), "~b~%02d %s %d~n~~w~%02d:%02d:%02d", date[0], Months[date[1] - 1], date[2], date[3], date[4], date[5]);
    GameTextForPlayer(playerid, string, 4000, 1);

    PlayerAME(playerid, "saatine bakar.");

    return 1;
}

CMD:kimlikgoster(playerid, params[])
{
    new id;

    if(sscanf(params, "k<m>", id)) id = playerid;

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesajiC(playerid, "Geçersiz ID.");

    if(!ProxDetectorS(5.0, playerid, id))return
        SunucuMesaji(playerid, "Bu oyuncuya yakýn deðilsin.");

    SendFormattedMessage(id, COLOR_GREEN, "_________________[Kimlik Kartý]_________________", ReturnRoleplayName(playerid));
    SendFormattedMessage(id, COLOR_GREY, "Ad Soyad: %s", ReturnRoleplayName(playerid));
    SendFormattedMessage(id, COLOR_GREY, "Cinsiyet: %s", PlayerInfo[playerid][pSex] ? ("Kadýn") : ("Erkek"));
    SendFormattedMessage(id, COLOR_GREY, "Yaþ: %d", PlayerInfo[playerid][pAge]);

    if(playerid != id) PlayerMEPlayer(playerid, id, "kiþisine kimliðini gösterir");

    return 1;
}

CMD:zar(playerid, params[])
{
	if(Inventory_HasItem(playerid, "Zar", ITEM_BIZ) == -1)return
        SunucuMesaji(playerid, "Zar atmak için önce zar satýn almalýsýnýz.");

 	new r = random(6) + 1;
  	new string[90];

	format(string, sizeof(string), "** %s zar atar. (%d)", ReturnRoleplayName(playerid, true), r);
 	ProxDetector(7.0, playerid, string, COLOR_EMOTE, COLOR_EMOTE, COLOR_EMOTE, COLOR_EMOTE, COLOR_EMOTE);
    return 1;
}

flags:sigara(CMD_USER);
CMD:sigara(playerid, params[])
{
    if(Inventory_HasItem(playerid, "Sigara", ITEM_BIZ) == -1)return
        SunucuMesaji(playerid, "Sigara paketin bitmiþ veya sigaraya sahip deðilsin.");
		
	if(PlayerInfo[playerid][pJailTime] > 1) return HataMesajiC(playerid, "Bu komutu hapiste kullanmazsýn.");

    if(PlayerInfo[playerid][pSmoking]) return 1;
    RemovePlayerAttachedObject(playerid, 7);
    RemovePlayerAttachedObject(playerid, 6);
    SetPlayerAttachedObject(playerid, 6, 3027, 6, 0.0852, 0.0303, 0.0194, 88.7970, 53.3082, 162.5791);
    SetPlayerAttachedObject(playerid, 7, 18673, 6, 0.1570, -0.0588, -1.6079, 0.0000, 0.0000, 0.0000, 1.0000, 1.0000, 1.0000);

    ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 0);
    PlayerAME(playerid, "çakmaðýyla sigarasýný yakar.");
    Inventory_DecraseAmount(playerid, Inventory_HasItem(playerid, "Sigara", ITEM_BIZ));
    SunucuMesaji(playerid, "Sigara - Y: Sigara içme, N: Konum deðiþtirme, H: Yere atma.");

    PlayerInfo[playerid][pSmoking] = 1;
    PlayerInfo[playerid][pSmokingThrows] = 8;
    PlayerInfo[playerid][pSmokingType] = SMOKING_TYPE_CIGARETTE;

    return 1;
}

CMD:id(playerid, params[])
{
    new id;

    if(isnull(params)) return KullanimMesaji(playerid, "/id [id/isim]");

    if(IsNumeric(params))
    {
        sscanf(params, "d", id);

        if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
            HataMesaji(playerid, "Geçersiz ID.");

        SunucuMesaji(playerid, "%s (%d) - Seviye: %d.", ReturnRoleplayName(id), id, PlayerInfo[id][pLevel]);
    }
    else
    {
        if(strlen(params) < 3 || strlen(params) > MAX_PLAYER_NAME)return
            HataMesaji(playerid, "3 ile %d arasýnda karakter girmelisin.", MAX_PLAYER_NAME);

        new count;

        foreach(new i : Player) if(strfind(ReturnName(i), params, true) != -1)
        {
            SendFormattedMessage(playerid, COLOR_WHITE, "%s (%d) - Seviye: %d.", ReturnRoleplayName(i), i, PlayerInfo[i][pLevel]);
            count++;
        }

        if(!count)return
            SunucuMesaji(playerid, "Oyuncu bulunamadý.");
    }

    return 1;
}


CMD:me(playerid, params[])
{
	//if(PlayerInfo[playerid][pTVActor] != -1)
		//return HataMesaji(playerid, "Bu iþlemi yapamazsýnýz.");

    if(isnull(params) || strlen(params) > 256)return
        KullanimMesaji(playerid, "/me [yazý]");

	printf("* %s %s", ReturnRoleplayName(playerid), params);
    return PlayerME(playerid, params);
}

CMD:melow(playerid, params[])
{
	//if(PlayerInfo[playerid][pTVActor] != -1)
		//return HataMesaji(playerid, "Bu iþlemi yapamazsýnýz.");

    if(isnull(params) || strlen(params) > 256)return
        KullanimMesaji(playerid, "/melow [yazý]");

    printf("* %s %s", ReturnRoleplayName(playerid), params);
    return PlayerME(playerid, params, 3.5);
}
CMD:do(playerid, params[])
{
	//if(PlayerInfo[playerid][pTVActor] != -1)
		//return HataMesaji(playerid, "Bu iþlemi yapamazsýnýz.");

    if(isnull(params) || strlen(params) > 256)return
        KullanimMesaji(playerid, "/do [yazý]");

    printf("* %s (( %s ))", params, ReturnRoleplayName(playerid));
    return PlayerDO(playerid, params);
}
CMD:dolow(playerid, params[])
{
	//if(PlayerInfo[playerid][pTVActor] != -1)
		//return HataMesaji(playerid, "Bu iþlemi yapamazsýnýz.");

    if(isnull(params) || strlen(params) > 256)return
        KullanimMesaji(playerid, "/dolow [yazý]");

    return PlayerDO(playerid, params, 3.5);
}
CMD:low(playerid, params[])
{
	//if(PlayerInfo[playerid][pTVActor] != -1)
		//return HataMesaji(playerid, "Bu iþlemi yapamazsýnýz.");

    new string[256];

    if(isnull(params) || strlen(params) > 256)return
        KullanimMesaji(playerid, "/l [yazý]");

    format(string,sizeof(string), "%s(kýsýk ses): %s", ReturnRoleplayName(playerid, true), params);
    ProxDetector(3.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, true);
 	printf("[LOW] %s: %s", ReturnRoleplayName(playerid), params);

    return 1;
}
CMD:l(playerid, params[])return pc_cmd_low(playerid,params);
CMD:c(playerid, params[])return pc_cmd_low(playerid,params);
CMD:b(playerid, params[]) return SendOOCMessage(playerid, params);
CMD:blow(playerid, params[]) return SendOOCMessage(playerid, params, 3.5);
CMD:bagir(playerid, params[])
{
	//if(PlayerInfo[playerid][pTVActor] != -1)
		//return HataMesaji(playerid, "Bu iþlemi yapamazsýnýz.");

    new string[256];

    if(isnull(params) || strlen(params) > 256)return
        KullanimMesaji(playerid, "/s [mesaj]");

    format(string,sizeof(string), "%s(baðýrarak): %s", ReturnRoleplayName(playerid, true), params);
    ProxDetector(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, true);
 	printf("[BAGIR] %s: %s", ReturnRoleplayName(playerid), params);

    return 1;
}
CMD:s(playerid, params[]) return pc_cmd_bagir(playerid, params);

CMD:yazitura(playerid, params[])
{
    new r = random(2);
    new string[90];

    static const coynString[2][10] = {"yazý", "tura"};

    format(string, sizeof(string), "** %s havaya para atar ve %s gelir.", ReturnRoleplayName(playerid, true), coynString[r]);
 	ProxDetector(7.0, playerid, string, COLOR_EMOTE, COLOR_EMOTE, COLOR_EMOTE, COLOR_EMOTE, COLOR_EMOTE);

    return 1;
}
CMD:dene(playerid, params[])
{
    new r = random(3);
    new string[124];

    static const coynString[3][32] = {"Baþarýlý", "Baþarýsýz", "Baþarýsýz"};

    format(string, sizeof(string), "** %s. (( %s ))", coynString[r], ReturnRoleplayName(playerid, true));
 	ProxDetector(7.1, playerid, string, COLOR_EMOTE, COLOR_EMOTE, COLOR_EMOTE, COLOR_EMOTE, COLOR_EMOTE);

    return 1;
}

CMD:fisilda(playerid, params[])
{
    new id, text[256], string[250];

    if(sscanf(params, "k<m>s[256]", id, text))return
        KullanimMesaji(playerid, "/w [id/isim] [yazý]");

    if(!IsPlayerConnected(id) || id == playerid)return
        HataMesaji(playerid, "Geçersiz ID.");

    if(!ProxDetectorS(2.0, playerid, id))return
        SunucuMesaji(playerid, "Oyuncuya yakýn deðilsin.");

    SendFormattedMessage(id, COLOR_YELLOW, "%s sana fýsýldadý: %s", ReturnRoleplayName(playerid, true), text);
    SendFormattedMessage(playerid, COLOR_YELLOW, "%s adlý oyuncuya fýsýldadýn: %s", ReturnRoleplayName(id, true), text);
 	printf("[FISILDAMA] %s > %s: %s", ReturnRoleplayName(playerid), ReturnRoleplayName(id), params);

    foreach(new j : Player)
    {
        if(!IsPlayerConnected(j) || !PlayerInfo[j][pLogged] || PlayerInfo[j][pAdmin] < GAMEADMIN1)continue;
        if(PlayerInfo[j][pInRecon] != playerid)continue;

        SendFormattedMessage(j, COLOR_YELLOW, "%s > FISILDAMA > %s: %s", ReturnRoleplayName(playerid, true), ReturnRoleplayName(id, true), text);
	}

    foreach(new j : Player)
    {
        if(!IsPlayerConnected(j) || !PlayerInfo[j][pLogged] || PlayerInfo[j][pAdmin] < GAMEADMIN1)continue;
        if(PlayerInfo[j][pInRecon] != id)continue;

        SendFormattedMessage(j, COLOR_YELLOW, "%s > FISILDAMA > %s: %s", ReturnRoleplayName(playerid, true), ReturnRoleplayName(id, true), text);
	}

    format(string, sizeof(string),"%s'e yaklaþýr ve bir þeyler fýsýldar.", ReturnRoleplayName(id, true));
    PlayerAME(playerid, string);

    return 1;
}
CMD:w(playerid, params[]) return pc_cmd_fisilda(playerid, params);

CMD:ame(playerid, params[])
{
	//if(PlayerInfo[playerid][pTVActor] != -1)
		//return HataMesaji(playerid, "Bu iþlemi yapamazsýnýz.");

    if(isnull(params) || strlen(params) > 256)return
        KullanimMesaji(playerid, "/ame [yazý]");

 	printf("> %s: %s", ReturnRoleplayName(playerid), params);

    return PlayerAME(playerid, params);
}

CMD:oldcar(playerid)
{
    if(OldCar[playerid] != -1)
        SendFormattedMessage(playerid, COLOR_ADMIN, "Son bindiðiniz aracýn ID'si %d.", OldCar[playerid]);
    else return SendClientMessage(playerid, COLOR_GREY, "Henüz bir araca binmemiþsiniz.");
    return 1;
}

CMD:admins(playerid, params[])
{
    static const statusMsg[2][10] = {"Hayýr", "Evet"};
    SendClientMessage(playerid, COLOR_GREEN, "Online Yöneticiler:");

	foreach(new j : Player) if(IsPlayerConnected(j) && PlayerInfo[j][pLogged] && PlayerInfo[j][pAdmin] > SUPPORTER3 && !PlayerInfo[j][pGizliAdmin])
	    if(PlayerInfo[j][pAccountID] == 267 || PlayerInfo[j][pAccountID] == 994 || PlayerInfo[j][pAccountID] == 288)
        SendFormattedMessage(playerid, (PlayerInfo[j][pAdminDuty]) ? COLOR_GREEN : COLOR_GREY, "(Developer) %s (%s) (ID: %d) - Ýþbaþý: %s", ReturnRoleplayName(j), PlayerInfo[j][pUsername], j, statusMsg[PlayerInfo[j][pAdminDuty]]);
        else
        SendFormattedMessage(playerid, (PlayerInfo[j][pAdminDuty]) ? COLOR_GREEN : COLOR_GREY, "(Seviye: %d) %s (%s) (ID: %d) - Ýþbaþý: %s", PlayerInfo[j][pAdmin] - 3, ReturnRoleplayName(j), PlayerInfo[j][pUsername], j, statusMsg[PlayerInfo[j][pAdminDuty]]);

    return 1;
}

// Admin Komutlarý

flags:flipcar(CMD_GAME1);
CMD:flipcar(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid)) return HataMesaji(playerid, "Bu komutu kullanmak için bir araçta olmalýsýnýz.");
    new veh = GetPlayerVehicleID(playerid);
    new Float:angle;
    GetVehicleZAngle(veh, angle);
    SetVehicleZAngle(veh, angle);
    return 1;
}

flags:gotochoords(CMD_GAME1);
CMD:gotochoords(playerid, params[])
{
    new Float:x,
        Float:y,
        Float:z,
        interior,
        world;

    if(sscanf(params, "fffdd", x, y, z, interior, world))return
        KullanimMesaji(playerid, "/gotochoords <x> <y> <z> [interior] [virtual world]");

    SetPlayerPos(playerid, x, y, z);
    SetPlayerInterior(playerid, interior);
    AC_SetPlayerVirtualWorld(playerid, world);

    if(IsPlayerInAnyVehicle(playerid))
    {
        SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
        LinkVehicleToInterior(GetPlayerVehicleID(playerid), interior);
    }

    return 1;
}

flags:x(CMD_GAME1);
CMD:x(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;

	if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "KULLANIM: /x [Cordinate]");
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x+npos, y, z);
	return 1;
}
flags:xx(CMD_GAME1);
CMD:xx(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;

	if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "KULLANIM: /x [Cordinate]");
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, npos, y, z);
	return 1;
}
flags:y(CMD_GAME1);
CMD:y(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;

	if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "KULLANIM: /y [Cordinate]");
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y+npos, z);
	return 1;
}
flags:yy(CMD_GAME1);
CMD:yy(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;

	if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "KULLANIM: /y [Cordinate]");
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, npos, z);
	return 1;
}
flags:z(CMD_GAME1);
CMD:z(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;

	if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "KULLANIM: /z [Cordinate]");
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z+npos);
	return 1;
}
flags:zz(CMD_GAME1);
CMD:zz(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;

	if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "KULLANIM: /z [Cordinate]");
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, npos);
	return 1;
}

flags:setskin(CMD_GAME1);
CMD:setskin(playerid, params[])
{
    new id,
        skinid;

    if(sscanf(params, "ud", id, skinid))return
        KullanimMesaji(playerid, "/setskin [id/isim] [id]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    PlayerInfo[id][pSkin] = skinid;
    SetPlayerSkinEx(id, skinid);
    return 1;
}

flags:goto(CMD_SUPPORTER3);
CMD:goto(playerid, params[])
{
    new id,
        Float:x,
        Float:y,
        Float:z;

    if(sscanf(params, "u", id))return
        KullanimMesaji(playerid, "/goto [id/isim]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged] || id == playerid)return
        HataMesaji(playerid, "Geçersiz ID.");

	if(GetPlayerState(id) == PLAYER_STATE_SPECTATING) return HataMesaji(playerid, "Iþýnlanmaya çalýþtýðýnýz oyuncu spec modunda.");

    GetPlayerPos(id,x,y,z);

    if(IsPlayerInAnyVehicle(playerid))
    {
        SetVehiclePos(GetPlayerVehicleID(playerid), x, y + 2, z);
        LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(id));
        SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetPlayerVirtualWorld(id));
    }
    else
	{
		SetPlayerPos(playerid, x + 1, y, z);
	}

	SunucuMesaji(playerid, "%s adlý oyuncunun yanýna ýþýnlandýn.", ReturnRoleplayName(id));
    SetPlayerInterior(playerid, GetPlayerInterior(id));
    AC_SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));

    return 1;
}
flags:gethere(CMD_SUPPORTER3);
CMD:gethere(playerid, params[])
{
    new id,
        Float:x,
        Float:y,
        Float:z;

    if(sscanf(params, "u", id))return
        KullanimMesaji(playerid, "/gethere [id/isim]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged] || id == playerid)return
        HataMesaji(playerid, "Geçersiz ID.");

    if(PlayerInfo[playerid][pAdmin] != LEVEL20 && PlayerInfo[id][pAdmin] >= LEVEL20)
        return HataMesaji(playerid, "Lider yöneticileri yanýna çekemezsin.");

    GetPlayerPos(playerid,x,y,z);

    if(IsPlayerInAnyVehicle(id))
    {
        SetVehiclePos(GetPlayerVehicleID(id), x, y + 2, z);
        LinkVehicleToInterior(GetPlayerVehicleID(id), GetPlayerInterior(playerid));
    }
    else SetPlayerPos(id, x + 1, y, z);

    SunucuMesaji(playerid, "%s adlý oyuncuyu yanýna çektin.", ReturnRoleplayName(id));
    SunucuMesaji(id, "%s adlý yönetici seni yanýna çekti.", ReturnRoleplayName(playerid));
    SetPlayerInterior(id, GetPlayerInterior(playerid));
    AC_SetPlayerVirtualWorld(id, GetPlayerVirtualWorld(playerid));

    return 1;
}
flags:slap(CMD_GAME1);
CMD:slap(playerid, params[])
{
    new id;

    if(sscanf(params, "u", id))return
        KullanimMesaji(playerid, "/slap [id/isim]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(PlayerInfo[id][pAdmin] > PlayerInfo[playerid][pAdmin] && id != playerid)return
        SunucuMesaji(playerid, "Senden yüksek kiþilere bunu yapamazsýn.");

    if(PlayerInfo[playerid][pAdmin] != LEVEL20 && PlayerInfo[id][pAdmin] >= LEVEL20)
        return HataMesaji(playerid, "Lider yöneticilere bunu yapamazsýn.");

    SendClientMessageEx(playerid, COLOR_ADMIN, "Belirttiðiniz kiþiyi slapladýn.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(id, x, y, z);
    SetPlayerPos(id, x, y, z + 4);

    return 1;
}
flags:belt(CMD_GAME1);
CMD:belt(playerid, params[])
{
    new id;

    if(sscanf(params, "u", id))return
        KullanimMesaji(playerid, "/belt [id/isim]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(PlayerInfo[id][pAdmin] > PlayerInfo[playerid][pAdmin] && id != playerid)return
        SunucuMesaji(playerid, "Senden yüksek kiþilere bunu yapamazsýn.");

    if(PlayerInfo[playerid][pAdmin] != LEVEL20 && PlayerInfo[id][pAdmin] >= LEVEL20)
        return HataMesaji(playerid, "Lider yöneticilere bunu yapamazsýn.");

    SendClientMessageEx(playerid, COLOR_ADMIN, "Belirttiðiniz kiþiyi beltlediniz.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(id, x, y, z);
    SetPlayerPos(id, x, y, z - 4);

    return 1;
}
flags:sethp(CMD_GAME1);
CMD:sethp(playerid, params[])
{
    new id,
        Float:health;

    if(sscanf(params, "uf", id, health))return
        KullanimMesaji(playerid, "/sethp [id/isim] [hp]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(health < 0 || health > 200)return
        SunucuMesaji(playerid, "Geçersiz deðer. (0 - 200)");

    AC_SetPlayerHealth(id, health);

    LogYaz(playerid, "/sethp", id, floatround(health));

	if(!PlayerInfo[playerid][pGizliAdmin])
	        BasariMesaji(id, "%s kiþisi HP'ni %.0f olarak ayarladý.", ReturnRoleplayName(playerid), health);
	    else
	        BasariMesaji(id, "Administrator HP'ni %.0f olarak ayarladý.", health);
    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s kiþisi %s kiþisinin HP'sini %.0f HP olarak ayarladý.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), health);

    return 1;
}
flags:setarmor(CMD_GAME1);
CMD:setarmor(playerid, params[])
{
    new id,
        Float:armour;

    if(sscanf(params, "uf", id, armour))return
        KullanimMesaji(playerid, "/setarmor [id/isim] [zýrh]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(armour < 0 || armour > 100)return
        SunucuMesaji(playerid, "Geçersiz deðer. (0 - 100)");

    AC_SetPlayerArmour(id, armour);

	if(!PlayerInfo[playerid][pGizliAdmin])
        BasariMesaji(id, "%s kiþisi zýrhýný %.0f olarak ayarladý.", ReturnRoleplayName(playerid), armour);
    else
        BasariMesaji(id, "Administrator zýrhýný %.0f olarak ayarladý.", armour);

    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s kiþisi %s kiþisinin zýrhýný %.0f olarak ayarladý.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), armour);

    return 1;
}

flags:setarmor2(CMD_GAME3);
CMD:setarmor2(playerid, params[])
{
    new id,
        Float:armour;

    if(sscanf(params, "uf", id, armour))return
        KullanimMesaji(playerid, "/setarmor [id/isim] [zýrh]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(armour < 0 || armour > 200)return
        SunucuMesaji(playerid, "Geçersiz deðer. (0 - 200)");

    AC_SetPlayerArmour(id, armour);

	if(!PlayerInfo[playerid][pGizliAdmin])
        BasariMesaji(id, "%s kiþisi zýrhýný %.0f olarak ayarladý.", ReturnRoleplayName(playerid), armour);
    else
        BasariMesaji(id, "Administrator zýrhýný %.0f olarak ayarladý.", armour);

    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s kiþisi %s kiþisinin zýrhýný %.0f olarak ayarladý.", ReturnRoleplayName(playerid), ReturnRoleplayName(id), armour);

    return 1;
}

flags:gonderls(CMD_SUPPORTER2);
flags:gonderlv(CMD_GAME1);
flags:gondersf(CMD_GAME1);
CMD:gonderls(playerid, params[])
{
    new id;
    if(sscanf(params, "u", id)) return KullanimMesaji(playerid, "/gonderls [id/isim]");
    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged]) return HataMesaji(playerid, "Geçersiz ID.");
    if(PlayerInfo[id][pJailTime] > 1)
		return SunucuMesaji(playerid, "Hapisteki oyuncuyu ýþýnlayamazsýn.");
    if(IsPlayerInAnyVehicle(id)) {
        new veh = GetPlayerVehicleID(id);
        if(GetPlayerState(id) == PLAYER_STATE_DRIVER) {
            SetVehiclePos(veh, 1520.3328,-1679.4402,13.5469);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(id, 0);
            AC_SetPlayerVirtualWorld(id, 0);
            PutPlayerInVehicle(id, veh, 0);
        }
        else {
            SetVehiclePos(veh, 1520.3328,-1679.4402,13.5469);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(id, 0);
            AC_SetPlayerVirtualWorld(id, 0);
            PutPlayerInVehicle(id, veh, 1);
        }
    } else {
        SetPlayerPos(id, 1520.3328,-1679.4402,13.5469);
        SetPlayerInterior(id, 0);
        AC_SetPlayerVirtualWorld(id, 0);
    }
    return 1;
}

CMD:gonderlv(playerid, params[])
{
    new id;
    if(sscanf(params, "u", id)) return KullanimMesaji(playerid, "/gonderlv [id/isim]");
    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged]) return HataMesaji(playerid, "Geçersiz ID.");
    if(IsPlayerInAnyVehicle(id)) {
        new veh = GetPlayerVehicleID(id);
        if(GetPlayerState(id) == PLAYER_STATE_DRIVER) {
            SetVehiclePos(veh, 1692.9183,1445.7848,10.7645);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(id, 0);
            AC_SetPlayerVirtualWorld(id, 0);
            PutPlayerInVehicle(id, veh, 0);
        }
        else {
            SetVehiclePos(veh, 1692.9183,1445.7848,10.7645);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(id, 0);
            AC_SetPlayerVirtualWorld(id, 0);
            PutPlayerInVehicle(id, veh, 1);
        }
    } else {
        SetPlayerPos(id, 1692.9183,1445.7848,10.7645);
        SetPlayerInterior(id, 0);
        AC_SetPlayerVirtualWorld(id, 0);
    }
    return 1;
}

CMD:gondersf(playerid, params[])
{
    new id;
    if(sscanf(params, "u", id)) return KullanimMesaji(playerid, "/gondersf [id/isim]");
    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged]) return HataMesaji(playerid, "Geçersiz ID.");
    if(IsPlayerInAnyVehicle(id)) {
        new veh = GetPlayerVehicleID(id);
        if(GetPlayerState(id) == PLAYER_STATE_DRIVER) {
            SetVehiclePos(veh, -1404.3580,-320.8462,14.0000);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(id, 0);
            AC_SetPlayerVirtualWorld(id, 0);
            PutPlayerInVehicle(id, veh, 0);
        }
        else {
            SetVehiclePos(veh, -1404.3580,-320.8462,14.0000);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(id, 0);
            AC_SetPlayerVirtualWorld(id, 0);
            PutPlayerInVehicle(id, veh, 1);
        }
    } else {
        SetPlayerPos(id, -1404.3580,-320.8462,14.0000);
        SetPlayerInterior(id, 0);
        AC_SetPlayerVirtualWorld(id, 0);
    }
    return 1;
}

flags:gotols(CMD_GAME1);
flags:gotolv(CMD_GAME1);
flags:gotosf(CMD_GAME1);

CMD:gotols(playerid)
{
    if(IsPlayerInAnyVehicle(playerid)) {
        new veh = GetPlayerVehicleID(playerid);
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
            SendClientMessageEx(playerid, COLOR_ADMIN, "Los Santos'a ýþýnlandýn.");
            SetVehiclePos(veh, 1529.4974,-1676.6726,13.3828);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(playerid, 0);
            AC_SetPlayerVirtualWorld(playerid, 0);
            PutPlayerInVehicle(playerid, veh, 0);
        }
        else {
            SendClientMessageEx(playerid, COLOR_ADMIN, "Los Santos'a ýþýnlandýn.");
            SetVehiclePos(veh, 1529.4974,-1676.6726,13.3828);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(playerid, 0);
            AC_SetPlayerVirtualWorld(playerid, 0);
            PutPlayerInVehicle(playerid, veh, 1);
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_ADMIN, "Los Santos'a ýþýnlandýn.");
        SetPlayerPos(playerid, 1529.4974,-1676.6726,13.3828);
        SetPlayerInterior(playerid, 0);
        AC_SetPlayerVirtualWorld(playerid, 0);
    }
    return 1;
}

CMD:gotosf(playerid)
{
    if(IsPlayerInAnyVehicle(playerid)) {
        new veh = GetPlayerVehicleID(playerid);
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
            SendClientMessageEx(playerid, COLOR_ADMIN, "San Fierro'ya ýþýnlandýn.");
            SetVehiclePos(veh, -1404.3580,-320.8462,14.0000);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(playerid, 0);
            AC_SetPlayerVirtualWorld(playerid, 0);
            PutPlayerInVehicle(playerid, veh, 0);
        }
        else {
            SendClientMessageEx(playerid, COLOR_ADMIN, "San Fierro'ya ýþýnlandýn.");
            SetVehiclePos(veh, -1404.3580,-320.8462,14.0000);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(playerid, 0);
            AC_SetPlayerVirtualWorld(playerid, 0);
            PutPlayerInVehicle(playerid, veh, 1);
        }
    } else {
        SendClientMessageEx(playerid, COLOR_ADMIN, "San Fierro'ya ýþýnlandýn.");
        SetPlayerPos(playerid, -1404.3580,-320.8462,14.0000);
        SetPlayerInterior(playerid, 0);
        AC_SetPlayerVirtualWorld(playerid, 0);
    }
    return 1;
}

CMD:gotolv(playerid)
{
    if(IsPlayerInAnyVehicle(playerid)) {
        new veh = GetPlayerVehicleID(playerid);
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
            SendClientMessageEx(playerid, COLOR_ADMIN, "Las Venturas'a ýþýnlandýn.");
            SetVehiclePos(veh, 1692.9183,1445.7848,10.7645);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(playerid, 0);
            AC_SetPlayerVirtualWorld(playerid, 0);
            PutPlayerInVehicle(playerid, veh, 0);
        }
        else {
            SendClientMessageEx(playerid, COLOR_ADMIN, "Las Venturas'a ýþýnlandýn.");
            SetVehiclePos(veh, 1692.9183,1445.7848,10.7645);
            LinkVehicleToInterior(veh, 0);
            SetVehicleVirtualWorld(veh, 0);
            SetPlayerInterior(playerid, 0);
            AC_SetPlayerVirtualWorld(playerid, 0);
            PutPlayerInVehicle(playerid, veh, 1);
        }
    } else {
        SendClientMessageEx(playerid, COLOR_ADMIN, "Las Venturas'a ýþýnlandýn.");
        SetPlayerPos(playerid, 1692.9183,1445.7848,10.7645);
        SetPlayerInterior(playerid, 0);
        AC_SetPlayerVirtualWorld(playerid, 0);
    }
    return 1;
}

flags:setinterior(CMD_SUPPORTER2);
CMD:setinterior(playerid, params[])
{
    new id,
        interiorid;

    if(sscanf(params, "ud", id, interiorid))return
        KullanimMesaji(playerid, "/setinterior [id/isim] [interior]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(interiorid < 0)return
        SunucuMesaji(playerid, "Interior Geçersiz ID.");

    if(GetPlayerInterior(id) == interiorid)return
        SunucuMesaji(playerid, "Bu oyuncunun interioru zaten öyle.");

    SetPlayerInterior(id, interiorid);

    return 1;
}
flags:setvw(CMD_SUPPORTER2);
CMD:setvw(playerid, params[])
{
    new id,
        worldid;

    if(sscanf(params, "ud", id, worldid))return
        KullanimMesaji(playerid, "/setvw [id/isim] [virtual world]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(worldid < 0 || worldid >= HOUSE_WORLD)
        SunucuMesaji(playerid, "UYARI: Bu sanal dünya ev dünyasý, buraya dinamik bir þey falan eklemeyin.");

    if(GetPlayerVirtualWorld(id) == worldid)return
        SunucuMesaji(playerid, "Kiþi zaten bu VW'de.");

    AC_SetPlayerVirtualWorld(id, worldid);

    return 1;
}

flags:freezeall(CMD_iglead);
flags:unfreezeall(CMD_iglead);
CMD:freezeall(playerid, params[])
{
    foreach (new i : Player)
    {
        PlayerInfo[i][pFreezed] = 1;
        TogglePlayerControllable(i, false);
		SendFormattedMessage(i, COLOR_ADMIN, "Lider yönetici %s herkesi dondurdu.", ReturnRoleplayName(playerid));
    }
    return 1;
}

CMD:unfreezeall(playerid, params[])
{
    foreach (new i : Player)
    {
        PlayerInfo[i][pFreezed] = 0;
    	TogglePlayerControllable(i, true);

		SendFormattedMessage(i, COLOR_ADMIN, "Lider yönetici %s herkesin donmasýný kaldýrdý.", ReturnRoleplayName(playerid));
    }
    return 1;
}

flags:freeze(CMD_SUPPORTER3);
CMD:freeze(playerid, params[])
{
    new id;

    if(sscanf(params, "u", id))return
        SendClientMessageEx(playerid, COLOR_GREY, "(/un)freeze [id/isim]");

    if(!IsPlayerConnected(id) || !PlayerInfo[id][pLogged])return
        HataMesaji(playerid, "Geçersiz ID.");

    if(PlayerInfo[playerid][pAdmin] != LEVEL20 && PlayerInfo[id][pAdmin] >= LEVEL20)
        return HataMesaji(playerid, "Lider yöneticileri donduramazsýn.");

    PlayerInfo[id][pFreezed] = !PlayerInfo[id][pFreezed];
    TogglePlayerControllable(id,(PlayerInfo[id][pFreezed]) ? false : true);
	BasariMesaji(playerid, "%s adlý oyuncuyu seni %s.", ReturnRoleplayName(id), (PlayerInfo[id][pFreezed]) ? ("dondurdun") : ("çözdün"));

	if(!PlayerInfo[playerid][pGizliAdmin])
        BasariMesaji(id, "%s adlý yetkili seni %s.", ReturnRoleplayName(playerid), (PlayerInfo[id][pFreezed]) ? ("dondurdu") : ("çözdü"));
    else
        BasariMesaji(id, "Administrator seni %s.", (PlayerInfo[id][pFreezed]) ? ("dondurdu") : ("çözdü"));
    SendAworkAlert(false, COLOR_ADMIN, "AdmCmd: %s kiþisi %s iþlemini %s kiþisinde uyguladý.", ReturnRoleplayName(playerid), (PlayerInfo[id][pFreezed]) ? ("dondurma") : ("çözme"), ReturnRoleplayName(id));

    return 1;
}
flags:unfreeze(CMD_SUPPORTER3);
CMD:unfreeze(playerid, params[])return pc_cmd_freeze(playerid,params);

flags:fixcar(CMD_GAME1);
CMD:fixcar(playerid, params[])
{
    new vehicleid;

    if(IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);

    if(!vehicleid && sscanf(params, "d",vehicleid))return
        KullanimMesaji(playerid, "/fixcar [id]");

    if(!IsValidVehicle(vehicleid))return
        SunucuMesaji(playerid, "Varolmayan araç.");

    Vehicle_Respray2(vehicleid);

    return 1;
}

flags:gotocar(CMD_SUPPORTER3);
CMD:gotocar(playerid, params[])
{
    new vehicleid,
        Float:x,
        Float:y,
        Float:z;

    if(sscanf(params, "d", vehicleid))return
        KullanimMesaji(playerid, "/gotocar [aracid]");

    if(vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))return
        SunucuMesaji(playerid, "Varolmayan araç.");

    GetVehiclePos(vehicleid,x,y,z);
    SetPlayerPos(playerid, x, y-2, z+2);

    if(GetVehicleDriver(vehicleid) == -1)
        PutPlayerInVehicle(playerid,vehicleid,0);

    SetPlayerInterior(playerid, 0);
    AC_SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(vehicleid));

    return 1;
}

flags:getcar(CMD_SUPPORTER3);
CMD:getcar(playerid, params[])
{
    new vehicleid,
        Float:x,
        Float:y,
        Float:z;

    if(sscanf(params, "d", vehicleid))return
        KullanimMesaji(playerid, "/getcar ID");

    if(vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))return
        SunucuMesaji(playerid, "Varolmayan araç.");

    if(IsPlayerInAnyVehicle(playerid))return
        SunucuMesaji(playerid, "Zaten bir araçtasýn.");

    if(GetVehicleDriver(vehicleid) != -1)return
        SunucuMesaji(playerid, "Aracýn bir sürücüsü var.");

    GetPlayerPos(playerid,x,y,z);
    SetVehiclePos(vehicleid, x, y-2, z+2);

    if(GetVehicleDriver(vehicleid) == -1)
        PutPlayerInVehicle(playerid,vehicleid,0);

    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

    return 1;
}

flags:apm(CMD_GAME1);
CMD:apm(playerid, params[])
{
    new id, text[256];

    if(sscanf(params, "k<m>s[256]", id, text))return
        KullanimMesaji(playerid, "/apm [id/isim] [yazý]");

    SendFormattedMessage(id, COLOR_YELLOW, "Yönetici: %s", text);
    SendFormattedMessage(playerid, COLOR_YELLOW, "%s adlý oyuncuya mesaj gönderdin: %s", ReturnRoleplayName(id, true), text);

	return 1;
}

static renklistesi[][666] =
{
    "{000000}000 {F5F5F5}001 {2A77A1}002 {840410}003 {263739}004 {86446E}005 {D78E10}006 {4C75B7}007 {BDBEC6}008 {5E7072}009\n",
    "{46597A}010 {656A79}011 {5D7E8D}012 {58595A}013 {D6DAD6}014 {9CA1A3}015 {335F3F}016 {730E1A}017 {7B0A2A}018 {9F9D94}019\n",
    "{3B4E78}020 {732E3E}021 {691E3B}022 {96918C}023 {515459}024 {3F3E45}025 {A5A9A7}026 {635C5A}027 {3D4A68}028 {979592}029\n",
    "{421F21}030 {5F272B}031 {8494AB}032 {767B7C}033 {646464}034 {5A5752}035 {252527}036 {2D3A35}037 {93A396}038 {6D7A88}039\n",
    "{221918}040 {6F675F}041 {7C1C2A}042 {5F0A15}043 {193826}044 {5D1B20}045 {9D9872}046 {7A7560}047 {989586}048 {ADB0B0}049\n",
    "{848988}050 {304F45}051 {4D6268}052 {162248}053 {272F4B}054 {7D6256}055 {9EA4AB}056 {9C8D71}057 {6D1822}058 {4E6881}059\n",
    "{9C9C98}060 {917347}061 {661C26}062 {949D9F}063 {A4A7A5}064 {8E8C46}065 {341A1E}066 {6A7A8C}067 {AAAD8E}068 {AB988F}069\n",
    "{851F2E}070 {6F8297}071 {585853}072 {9AA790}073 {601A23}074 {20202C}075 {A4A096}076 {AA9D84}077 {78222B}078 {0E316D}079\n",
    "{722A3F}080 {7B715E}081 {741D28}082 {1E2E32}083 {4D322F}084 {7C1B44}085 {2E5B20}086 {395A83}087 {6D2837}088 {A7A28F}089\n",
    "{AFB1B1}090 {364155}091 {6D6C6E}092 {0F6A89}093 {204B6B}094 {2B3E57}095 {9B9F9D}096 {6C8495}097 {4D8495}098 {AE9B7F}099\n",
    "{406C8F}100 {1F253B}101 {AB9276}102 {134573}103 {96816C}104 {64686A}105 {105082}106 {A19983}107 {385694}108 {525661}109\n",
    "{7F6956}110 {8C929A}111 {596E87}112 {473532}113 {44624F}114 {730A27}115 {223457}116 {640D1B}117 {A3ADC6}118 {695853}119\n",
    "{9B8B80}120 {620B1C}121 {5B5D5E}122 {624428}123 {731827}124 {1B376D}125 {EC6AAE}126 {000000}127 {177517}128 {210606}129\n",
    "{125478}130 {452A0D}131 {571E1E}132 {010701}133 {25225A}134 {2C89AA}135 {8A4DBD}136 {35963A}137 {B7B7B7}138 {464C8D}139\n",
    "{84888C}140 {817867}141 {817A26}142 {6A506F}143 {583E6F}144 {8CB972}145 {824F78}146 {6D276A}147 {1E1D13}148 {1E1306}149\n",
    "{1F2518}150 {2C4531}151 {1E4C99}152 {2E5F43}153 {1E9948}154 {1E9999}155 {999976}156 {7C8499}157 {992E1E}158 {2C1E08}159\n",
    "{142407}160 {993E4D}161 {1E4C99}162 {198181}163 {1A292A}164 {16616F}165 {1B6687}166 {6C3F99}167 {481A0E}168 {7A7399}169\n",
    "{746D99}170 {53387E}171 {222407}172 {3E190C}173 {46210E}174 {991E1E}175 {8D4C8D}176 {805B80}177 {7B3E7E}178 {3C1737}179\n",
    "{733517}180 {781818}181 {83341A}182 {8E2F1C}183 {7E3E53}184 {7C6D7C}185 {020C02}186 {072407}187 {163012}188 {16301B}189\n",
    "{642B4F}190 {368452}191 {999590}192 {818D96}193 {99991E}194 {7F994C}195 {839292}196 {788222}197 {2B3C99}198 {3A3A0B}199\n",
    "{8A794E}200 {0E1F49}201 {15371C}202 {15273A}203 {375775}204 {060820}205 {071326}206 {20394B}207 {2C5089}208 {15426C}209\n",
    "{103250}210 {241663}211 {692015}212 {8C8D94}213 {516013}214 {090F02}215 {8C573A}216 {52888E}217 {995C52}218 {99581E}219\n",
    "{993A63}220 {998F4E}221 {99311E}222 {0D1842}223 {521E1E}224 {42420D}225 {4C991E}226 {082A1D}227 {96821D}228 {197F19}229\n",
    "{3B141F}230 {745217}231 {893F8D}232 {7E1A6C}233 {0B370B}234 {27450D}235 {071F24}236 {784573}237 {8A653A}238 {732617}239\n",
    "{319490}240 {56941D}241 {59163D}242 {1B8A2F}243 {38160B}244 {041804}245 {355D8E}246 {2E3F5B}247 {561A28}248 {4E0E27}249\n",
    "{706C67}250 {3B3E42}251 {2E2D33}252 {7B7E7D}253 {4A4442}254 {28344E}255\n"
};

CMD:renkler(playerid, params[])
{
	new test2 = GetPVarInt(playerid, "renktick");
	if(GetTickCount() - test2 < 10000)
	{
		DeletePVar(playerid, "renktick");
		return HataMesaji(playerid, "Bu komutu 10 saniyede bir kullanabilirsiniz.");
	}

	new string[3148];
    for(new i = 0; i < sizeof(renklistesi); i++)
	{
		format(string, sizeof(string), "%s%s", string, renklistesi[i]);
	}
	Dialog_Show(playerid, DialogNull, DIALOG_STYLE_MSGBOX, "SA:MP ARAÇ RENKLERI", string, "Tamam", "");

	new test = GetTickCount();
	SetPVarInt(playerid, "renktick", test);
	return 1;
}
