flags:tepsilerisil(CMD_iglead);
CMD:tepsilerisil(playerid)
{
	SunucuMesaji(playerid, "Sunucudaki tüm tepsiler silindi.");
	TepsileriTemizle();
	return 1;
}
flags:tepsipasif(CMD_iglead);
CMD:tepsipasif(playerid)
{
    if(!SunucuBilgi[TepsiSistemi])
    {
    	SunucuBilgi[TepsiSistemi] = true;
    	SunucuMesaji(playerid, "Tepsi sistemi aktif edildi.");
    }
    else
    {
        SunucuBilgi[TepsiSistemi] = false;
        SunucuMesaji(playerid, "Tepsi sistemi pasife çekildi.");
	}
	return 1;
}

CMD:tepsi(playerid, params[])
{
	if(PlayerInfo[playerid][pEditingMode])return
        SunucuMesaji(playerid, "Düzenleme yaparken bunu yapamazsýn.");

    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)return
        SunucuMesaji(playerid, "Bu komutu ayakta kullanabilirsin.");

	if(!SunucuBilgi[TepsiSistemi])
	{
	    new id = PlayerInfo[playerid][pMeal];

        if(PlayerInfo[playerid][pMeal] == -1)return
            SunucuMesaji(playerid, "Bir tepsi taþýmýyorsun, tepsi fonksiyonlarý yönetici tarafýndan devredýþý býrakýldý.");

		if(PlayerInfo[playerid][TepsiEdit]) return HataMesajiC(playerid, "Tepsi aksesuarýný düzenlerken bu iþlemi yapamazsýn.");

        RemovePlayerAttachedObject(playerid, 9);
        PlayerAME(playerid, "yemeðini yedikten sonra tepsiyi çöpe atar.");
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

        Meal_Drop(id);
        PlayerInfo[playerid][pMeal] = -1;
        PlayerInfo[playerid][TepsiBiraktim] = false;
        return 1;
	}

	if(isnull(params) || strlen(params) > 20)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "/tepsi [fonksiyon]");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "at {FFFFFF}- Elindeki tepsiyi atmaya yarar.");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "al {FFFFFF}- Yerdeki tepsiyi almaya yarar.");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "birak {FFFFFF}- Tepsiyi yere býrakmaya yarar.");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "pozisyon {FFFFFF}- Elindeki tepsiyi düzenlemeye yarar.");
	    return 1;
	}

    new id = PlayerInfo[playerid][pMeal];

	if(!strcmp(params, "at", true))
    {
        if(PlayerInfo[playerid][pMeal] == -1)return
            SunucuMesaji(playerid, "Bir tepsi taþýmýyorsun.");

		if(PlayerInfo[playerid][TepsiEdit]) return HataMesajiC(playerid, "Tepsi aksesuarýný düzenlerken bu iþlemi yapamazsýn.");

        RemovePlayerAttachedObject(playerid, 9);
        PlayerAME(playerid, "yemeðini yedikten sonra tepsiyi çöpe atar.");
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

        Meal_Drop(id);
        PlayerInfo[playerid][pMeal] = -1;
        PlayerInfo[playerid][TepsiBiraktim] = false;
    }
    else if(!strcmp(params, "al", true))
    {
        if(PlayerInfo[playerid][pMeal] != -1)return
            SunucuMesaji(playerid, "Zaten bir tepsi taþýyorsun.");

		if(PlayerInfo[playerid][TepsiEdit]) return HataMesajiC(playerid, "Tepsi aksesuarýný düzenlerken bu iþlemi yapamazsýn.");

        if(GetNearestMeal(playerid) == -1)return
            SunucuMesaji(playerid, "Bir tepsiye yakýn deðilsin.");

        id = GetNearestMeal(playerid);

        if(MealInfo[id][mEditing] || MealInfo[id][mPlayer] != -1) return
            SunucuMesaji(playerid, "Þu anda bu tepsiyi alamazsýn.");

        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);

        PlayerInfo[playerid][pMeal] = id;
	    SetPlayerAttachedObject(playerid, 9, MealInfo[id][mModel], 1, 0.004999, 0.529999, 0.126999, -83.200004, 115.999961, -31.799890, 0.500000, 0.816000, 0.500000);

        PlayerAME(playerid, "iki eliyle tepsiyi alýr.");

        DestroyDynamicObjectEx(MealInfo[id][mObject]);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

        MealInfo[id][mPosX] = 0.0;
        MealInfo[id][mPosY] = 0.0;
        MealInfo[id][mPosZ] = 0.0;
        MealInfo[id][mPlayer] = playerid;
        PlayerInfo[playerid][TepsiBiraktim] = false;
    }
    else if(!strcmp(params, "birak", true))
    {
		if(SunucuBilgi[AntiDinamikObje])
			return HataMesaji(playerid, "Bu sistem geçici olarak geliþtirici ekip tarafýndan pasife çekildi.");
		
        if(PlayerInfo[playerid][pMeal] == -1)return
            SunucuMesaji(playerid, "Bir tepsi taþýmýyorsun.");

		if(PlayerInfo[playerid][TepsiBiraktim])
			return HataMesajiC(playerid, "Zaten daha önceden tepsi býrakmýþsýnýz.");

		if(PlayerInfo[playerid][TepsiEdit]) return HataMesajiC(playerid, "Tepsi aksesuarýný düzenlerken bu iþlemi yapamazsýn.");

        new Float:playerPosX, Float:playerPosY, Float:playerPosZ;

        GetPlayerPos(playerid, playerPosX, playerPosY, playerPosZ);

        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        //PlayerAME(playerid, "elindeki tepsiyi uygun bir konuma yerleþtirir.");

        MealInfo[id][mPlayer] = -1;
        MealInfo[id][mPosX] = playerPosX;
        MealInfo[id][mPosY] = playerPosY;
        MealInfo[id][mPosZ] = playerPosZ;
        MealInfo[id][mWorld] = GetPlayerVirtualWorld(playerid);
        MealInfo[id][mInterior] = GetPlayerInterior(playerid);
        MealInfo[id][mEditing] = true;

		RemovePlayerAttachedObject(playerid, 9);
        PlayerInfo[playerid][pEditingMode] = 9; // 12
        DestroyDynamicObjectEx(MealInfo[id][mObject]);
        MealInfo[id][mObject] = CreateDynamicObject(MealInfo[id][mModel], playerPosX, playerPosY, playerPosZ, 0.0, 0.0, 0.0, MealInfo[id][mWorld], MealInfo[id][mInterior]);
        EditDynamicObject(playerid, MealInfo[id][mObject]);

        PlayerInfo[playerid][pSelectedItem] = id;
        PlayerInfo[playerid][pMeal] = -1;
        PlayerInfo[playerid][TepsiBiraktim] = true;
    }
    else if(!strcmp(params, "pozisyon", true))
    {
        if(PlayerInfo[playerid][pMeal] == -1)return
            SunucuMesaji(playerid, "Bir tepsi taþýmýyorsun.");

        PlayerInfo[playerid][TepsiEdit] = true;
        EditAttachedObject(playerid, 9);
		BasariMesaji(playerid, "Elindeki tepsi aksesuarýný düzenlemeye baþladýn.");
    }
    else return HataMesajiC(playerid, "Geçersiz parametre.");

    return 1;
}
