flags:tepsilerisil(CMD_iglead);
CMD:tepsilerisil(playerid)
{
	SunucuMesaji(playerid, "Sunucudaki t�m tepsiler silindi.");
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
        SunucuMesaji(playerid, "Tepsi sistemi pasife �ekildi.");
	}
	return 1;
}

CMD:tepsi(playerid, params[])
{
	if(PlayerInfo[playerid][pEditingMode])return
        SunucuMesaji(playerid, "D�zenleme yaparken bunu yapamazs�n.");

    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)return
        SunucuMesaji(playerid, "Bu komutu ayakta kullanabilirsin.");

	if(!SunucuBilgi[TepsiSistemi])
	{
	    new id = PlayerInfo[playerid][pMeal];

        if(PlayerInfo[playerid][pMeal] == -1)return
            SunucuMesaji(playerid, "Bir tepsi ta��m�yorsun, tepsi fonksiyonlar� y�netici taraf�ndan devred��� b�rak�ld�.");

		if(PlayerInfo[playerid][TepsiEdit]) return HataMesajiC(playerid, "Tepsi aksesuar�n� d�zenlerken bu i�lemi yapamazs�n.");

        RemovePlayerAttachedObject(playerid, 9);
        PlayerAME(playerid, "yeme�ini yedikten sonra tepsiyi ��pe atar.");
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
	    SendClientMessage(playerid, COLOR_LIGHTRED, "birak {FFFFFF}- Tepsiyi yere b�rakmaya yarar.");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "pozisyon {FFFFFF}- Elindeki tepsiyi d�zenlemeye yarar.");
	    return 1;
	}

    new id = PlayerInfo[playerid][pMeal];

	if(!strcmp(params, "at", true))
    {
        if(PlayerInfo[playerid][pMeal] == -1)return
            SunucuMesaji(playerid, "Bir tepsi ta��m�yorsun.");

		if(PlayerInfo[playerid][TepsiEdit]) return HataMesajiC(playerid, "Tepsi aksesuar�n� d�zenlerken bu i�lemi yapamazs�n.");

        RemovePlayerAttachedObject(playerid, 9);
        PlayerAME(playerid, "yeme�ini yedikten sonra tepsiyi ��pe atar.");
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

        Meal_Drop(id);
        PlayerInfo[playerid][pMeal] = -1;
        PlayerInfo[playerid][TepsiBiraktim] = false;
    }
    else if(!strcmp(params, "al", true))
    {
        if(PlayerInfo[playerid][pMeal] != -1)return
            SunucuMesaji(playerid, "Zaten bir tepsi ta��yorsun.");

		if(PlayerInfo[playerid][TepsiEdit]) return HataMesajiC(playerid, "Tepsi aksesuar�n� d�zenlerken bu i�lemi yapamazs�n.");

        if(GetNearestMeal(playerid) == -1)return
            SunucuMesaji(playerid, "Bir tepsiye yak�n de�ilsin.");

        id = GetNearestMeal(playerid);

        if(MealInfo[id][mEditing] || MealInfo[id][mPlayer] != -1) return
            SunucuMesaji(playerid, "�u anda bu tepsiyi alamazs�n.");

        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);

        PlayerInfo[playerid][pMeal] = id;
	    SetPlayerAttachedObject(playerid, 9, MealInfo[id][mModel], 1, 0.004999, 0.529999, 0.126999, -83.200004, 115.999961, -31.799890, 0.500000, 0.816000, 0.500000);

        PlayerAME(playerid, "iki eliyle tepsiyi al�r.");

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
			return HataMesaji(playerid, "Bu sistem ge�ici olarak geli�tirici ekip taraf�ndan pasife �ekildi.");
		
        if(PlayerInfo[playerid][pMeal] == -1)return
            SunucuMesaji(playerid, "Bir tepsi ta��m�yorsun.");

		if(PlayerInfo[playerid][TepsiBiraktim])
			return HataMesajiC(playerid, "Zaten daha �nceden tepsi b�rakm��s�n�z.");

		if(PlayerInfo[playerid][TepsiEdit]) return HataMesajiC(playerid, "Tepsi aksesuar�n� d�zenlerken bu i�lemi yapamazs�n.");

        new Float:playerPosX, Float:playerPosY, Float:playerPosZ;

        GetPlayerPos(playerid, playerPosX, playerPosY, playerPosZ);

        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        //PlayerAME(playerid, "elindeki tepsiyi uygun bir konuma yerle�tirir.");

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
            SunucuMesaji(playerid, "Bir tepsi ta��m�yorsun.");

        PlayerInfo[playerid][TepsiEdit] = true;
        EditAttachedObject(playerid, 9);
		BasariMesaji(playerid, "Elindeki tepsi aksesuar�n� d�zenlemeye ba�lad�n.");
    }
    else return HataMesajiC(playerid, "Ge�ersiz parametre.");

    return 1;
}
