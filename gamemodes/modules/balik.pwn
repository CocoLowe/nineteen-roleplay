// BALIK SÝSTEMÝ RUFÝO

BalikSlotAl(playerid) {
	new slot = -1;
	for(new i = 0; i < 50; i++) {
		if(PlayerInfo[playerid][pBalikAgirlik][i] != 0)continue;
		slot = i;
		break;
	}
	return slot;
}

BalikEkle(playerid, slot, balik, agirlik) {
	if(PlayerInfo[playerid][pBalikAgirlik][slot] == 0) {
		PlayerInfo[playerid][pBalik][slot] = balik;
		PlayerInfo[playerid][pBalikAgirlik][slot] = agirlik;
		PlayerInfo[playerid][pBalikUcret] += agirlik * BalikIsimleri[balik][bAgirlikPara];
		PlayerInfo[playerid][pBalikCount]++;
		return 1;
	}
	return 0;
}

BalikCikar(playerid, slot) {
	if(PlayerInfo[playerid][pBalikAgirlik][slot] != 0) {
		PlayerInfo[playerid][pBalikUcret] -=  PlayerInfo[playerid][pBalikAgirlik][slot] * BalikIsimleri[PlayerInfo[playerid][pBalik][slot]][bAgirlikPara];
		PlayerInfo[playerid][pBalikAgirlik][slot] = 0;
		PlayerInfo[playerid][pBalikCount]--;
		return 1;
	}
	return 0;
}

TumBaliklariCikar(playerid) {
	for(new i = 0; i < 50; i++) {
		if(PlayerInfo[playerid][pBalikAgirlik][i] == 0)continue;
		PlayerInfo[playerid][pBalikAgirlik][i] = 0;
	}
	PlayerInfo[playerid][pBalikUcret] = 0;
	PlayerInfo[playerid][pBalikCount] = 0;
}

BaliklariSat(playerid) {
	if(!BalikVarMi(playerid)) return HataMesaji(playerid, "Zaten balýðýn yok.");
	AC_GivePlayerMoney(playerid, PlayerInfo[playerid][pBalikUcret], "/balik sat");
	SunucuMesaji(playerid, "Tüm balýklarýný sattýn ve $%d kazanç elde ettin.", PlayerInfo[playerid][pBalikUcret]);
	TumBaliklariCikar(playerid);
	return 1;
}

BalikSat(playerid, slot) {
	if(PlayerInfo[playerid][pBalikAgirlik][slot] != 0) {
		new ucret = PlayerInfo[playerid][pBalikAgirlik][slot] * BalikIsimleri[PlayerInfo[playerid][pBalik][slot]][bAgirlikPara];
		AC_GivePlayerMoney(playerid, ucret, "/balik sat");
		SunucuMesaji(playerid, "%d kilo bir %s sattýn ve $%d kazanç elde ettin.", PlayerInfo[playerid][pBalikAgirlik][slot], BalikIsimleri[PlayerInfo[playerid][pBalik][slot]][bIsim], ucret);
		BalikCikar(playerid, slot);
	} else return HataMesaji(playerid, "Bu slotta balýk yok!");
	return 0;
}

BaliklariSat2(playerid) {
	if(!BalikVarMi(playerid)) return HataMesaji(playerid, "Zaten balýðýn yok.");
	AC_GivePlayerMoney(playerid, PlayerInfo[playerid][pBalikUcret] / 2, "/balik sat");
	SunucuMesaji(playerid, "Tüm balýklarýný sattýn ve $%d kazanç elde ettin.", PlayerInfo[playerid][pBalikUcret] / 2);
	TumBaliklariCikar(playerid);
	return 1;
}

BalikSat2(playerid, slot) {
	if(PlayerInfo[playerid][pBalikAgirlik][slot] != 0) {
		new ucret = PlayerInfo[playerid][pBalikAgirlik][slot] * BalikIsimleri[PlayerInfo[playerid][pBalik][slot]][bAgirlikPara];
		AC_GivePlayerMoney(playerid, ucret / 2, "/balik sat");
		SunucuMesaji(playerid, "%d kilo bir %s sattýn ve $%d kazanç elde ettin.", PlayerInfo[playerid][pBalikAgirlik][slot], BalikIsimleri[PlayerInfo[playerid][pBalik][slot]][bIsim], ucret / 2);
		BalikCikar(playerid, slot);
	} else return HataMesaji(playerid, "Bu slotta balýk yok!");
	return 0;
}


BalikVarMi(playerid) {
	new found;
	for(new i = 0; i < 50; i++) {
		if(PlayerInfo[playerid][pBalikAgirlik][i] == 0)continue;
		found = 1;
		break;
	}
	return found;
}

BalikListeGoster(playerid) {
	BasariMesaji(playerid, "Balýk Listesi:");
	for(new i; i < 50; i++) {
		if(PlayerInfo[playerid][pBalikAgirlik][i] == 0) continue;
		SunucuMesaji(playerid, "#%d. %s - %d KG - $%d", i, BalikIsimleri[PlayerInfo[playerid][pBalik][i]][bIsim], PlayerInfo[playerid][pBalikAgirlik][i], BalikIsimleri[PlayerInfo[playerid][pBalik][i]][bAgirlikPara] * PlayerInfo[playerid][pBalikAgirlik][i]);
	}
	BasariMesaji(playerid, "Toplam Gelir: $%d", PlayerInfo[playerid][pBalikUcret]);
}

BalikUcret(playerid) return PlayerInfo[playerid][pBalikUcret];

KacBalikVar(playerid) return PlayerInfo[playerid][pBalikCount];

// BALIK SANDIK SÝSTEMÝ RUFÝO

SandigiAracaBagla(playerid, vehicleid, sandikid) {
	if(PlayerInfo[playerid][pTasidigiSandik] == -1) return HataMesajiC(playerid, "Bir sandýk taþýmýyorsun.");
	if(VehicleInfo[vehicleid][vSandik] != -1) return HataMesajiC(playerid, "Sadece 1 sandýk yerleþtirebilirsin.");
	if(SandikInfo[sandikid][sandikAracaBagli]) return HataMesajiC(playerid, "Bu sandýk zaten bir araca baðlý.");
	if(!SandikInfo[sandikid][sandikExists]) return HataMesajiC(playerid, "Sandýk silinmiþ.");
	SandikInfo[sandikid][sandikAracID] = vehicleid;
	SandikInfo[sandikid][sandikAracaBagli] = true;
	VehicleInfo[vehicleid][vSandik] = sandikid;
	SandikInfo[sandikid][sandikKapasite] = SandikKapasiteHesapla(vehicleid);
	PlayerInfo[playerid][pTasidigiSandik] = -1;
	format(SandikInfo[sandikid][sandikLabelText], 128, "[Balýk Sandýðý]\n{dd5a3f}%d {ffffff}kilo balýk var.", SandikInfo[sandikid][sandikAgirlik]);
	new Float:vX, Float:vY, Float:vZ;
	GetVehiclePos(SandikInfo[sandikid][sandikAracID], vX, vY, vZ);
	SandikInfo[sandikid][sandikLabel] = CreateDynamic3DTextLabel(SandikInfo[sandikid][sandikLabelText], COLOR_WHITE, vX, vY, vZ, 30.0, INVALID_PLAYER_ID, vehicleid);
	PlayerAME(playerid, "aracýna sandýk koyar.");
	return 1;
}

SandikOlustur(playerid) {
	if(PlayerInfo[playerid][pTasidigiSandik] != -1) return HataMesajiC(playerid, "Zaten bir sandýk taþýyorsun.");
	if(Iter_Free(Sandik) == -1) return HataMesajiC(playerid, "Maksimum sandýk limitine ulaþýlmýþ.");
	if(PlayerInfo[playerid][pCash] < 200) return HataMesajiC(playerid, "Paran yetmiyor. ($200)");
	if(!IsPlayerInRangeOfPoint(playerid, 2.0, 359.916290, -2032.155029, 7.835937)) return HataMesajiC(playerid, "Sandýk satýn alma noktasýnda deðilsiniz.");
	new id = Iter_Free(Sandik);
	Iter_Add(Sandik, id);
	PlayerInfo[playerid][pTasidigiSandik] = id;
	SandikInfo[id][sandikID] = playerid;
	SandikInfo[id][sandikExists] = 1;
	SandikInfo[id][sandikAracID] = -1;
	SandikInfo[id][sandikAgirlik] = 0;
	SandikInfo[id][sandikFiyat] = 0;
	SandikInfo[id][sandikKapasite] = 0;
	SandikInfo[id][sandikAracaBagli] = false;
	if(IsValidDynamic3DTextLabel(SandikInfo[id][sandikLabel]))
		DestroyDynamic3DTextLabelEx(SandikInfo[id][sandikLabel]);
	format(SandikInfo[id][sandikLabelText], 128, "");
	AC_GivePlayerMoney(playerid, -200, "sandik aldi");
	SunucuMesaji(playerid, "Bir sandýk aldýnýz, gemiye /baliksandigi komutu ile yerleþtirebilirsin.");
	SunucuMesaji(playerid, "Eðer sandýk üstündeyken oyundan çýkarsan sandýk silinir.");
	SunucuMesaji(playerid, "Sandýk araçtayken araç silinmediði ya da saklanmadýðý sürece sandýk silinmez.");
	SunucuMesaji(playerid, "Sandýklar tek kullanýmlýktýr, 1 kez kullandýktan sonra yok olur.");
	return 1;
}

SandikSil(sandikid) {
	if(SandikInfo[sandikid][sandikExists]) {
		if(SandikInfo[sandikid][sandikAracID] != -1) {
			VehicleInfo[SandikInfo[sandikid][sandikAracID]][vSandik] = -1;
		}
		foreach(new i: Player) {
			if(!PlayerInfo[i][pLogged])continue;
			if(PlayerInfo[i][pTasidigiSandik] == sandikid) {
				PlayerInfo[i][pTasidigiSandik] = -1;
				SunucuMesaji(i, "Elindeki sandýk silindi.");
				break;
			}
		}
		Iter_Remove(Sandik, sandikid);
		SandikInfo[sandikid][sandikID] = -1;
		SandikInfo[sandikid][sandikExists] = 0;
		SandikInfo[sandikid][sandikAracID] = -1;
		SandikInfo[sandikid][sandikAgirlik] = 0;
		SandikInfo[sandikid][sandikFiyat] = 0;
		SandikInfo[sandikid][sandikKapasite] = 0;
		SandikInfo[sandikid][sandikAracaBagli] = false;
		if(IsValidDynamic3DTextLabel(SandikInfo[sandikid][sandikLabel]))
			DestroyDynamic3DTextLabelEx(SandikInfo[sandikid][sandikLabel]);
		format(SandikInfo[sandikid][sandikLabelText], 128, "");
		return 1;
	}
	return 0;
}

SandikAractanAl(playerid) {
	new aracID = GetNearestVehicle(playerid);
	if(aracID == -1) return HataMesajiC(playerid, "Yakýnýnýzda sandýk yok.");
	if(VehicleInfo[aracID][vSandik] == -1) return HataMesajiC(playerid, "Yakýnýnýzda sandýk yok.");
	new sandikid = VehicleInfo[aracID][vSandik];
	SandikInfo[sandikid][sandikAracaBagli] = false;
	SandikInfo[sandikid][sandikAracID] = -1;
	VehicleInfo[aracID][vSandik] = -1;
	PlayerInfo[playerid][pTasidigiSandik] = sandikid;
	if(IsValidDynamic3DTextLabel(SandikInfo[sandikid][sandikLabel]))
		DestroyDynamic3DTextLabelEx(SandikInfo[sandikid][sandikLabel]);
	format(SandikInfo[sandikid][sandikLabelText], 128, "");
	PlayerAME(playerid, "araçtan bir sandýk alýr.");
	SunucuMesajiC(playerid, "Araçtan bir sandýk aldýn, satýþ noktasýnda bu sandýðý satabilir, sandýðý geri koyabilirsin.");
	SunucuMesajiC(playerid, "Ek olarak sandýðý istediðin baþka bir uyumlu deniz taþýtýna da koyabilirsin.");
	return 1;
}

SandikBalikEkle(playerid, balikSlot, agirlik, tumBalik = 0) {
	new aracID = GetNearestVehicle(playerid);
	if(aracID == -1) return HataMesajiC(playerid, "Yakýnýnýzda sandýk yok.");
	if(VehicleInfo[aracID][vSandik] == -1) return HataMesajiC(playerid, "Yakýnýnýzda sandýk yok.");
	if(PlayerInfo[playerid][pBalikAgirlik][balikSlot] == 0) return HataMesajiC(playerid, "Belirttiðiniz slotta balýk yok.");
	new sandikid = VehicleInfo[aracID][vSandik];
	new ucret = agirlik * BalikIsimleri[PlayerInfo[playerid][pBalik][balikSlot]][bAgirlikPara];
	if(SandikInfo[sandikid][sandikAgirlik] + agirlik > SandikKapasiteHesapla(aracID)) {
		HataMesajiC(playerid, "Bu balýðý sandýða koyarsanýz aðýrlýk limitini aþýyorsunuz.");
		return 0;
	}
	SandikInfo[sandikid][sandikAgirlik] += agirlik;
	SandikInfo[sandikid][sandikFiyat] += ucret;
	BalikCikar(playerid, balikSlot);
	PlayerAME(playerid, "sandýða balýk atar.");
	if(tumBalik == 0) {
		SandikTextLabelGuncelle(sandikid);
	}
	return 1;
}

SandikTumBaliklariEkle(playerid) {
	new aracID = GetNearestVehicle(playerid);
	if(aracID == -1) return HataMesajiC(playerid, "Yakýnýnýzda sandýk yok.");
	if(VehicleInfo[aracID][vSandik] == -1) return HataMesajiC(playerid, "Yakýnýnýzda sandýk yok.");
	new sandikid = VehicleInfo[aracID][vSandik];
	new agirlik, sonuc;
	for(new i = 0; i < 50; i++) {
		if(PlayerInfo[playerid][pBalikAgirlik][i] == 0)continue;
		agirlik = PlayerInfo[playerid][pBalikAgirlik][i];
		sonuc = SandikBalikEkle(playerid, i, agirlik, 1);
		if(sonuc == 0) break;
	}
	PlayerAME(playerid, "tüm balýklarýný sandýða atar.");
	SandikTextLabelGuncelle(sandikid);
	return 1;
}

SandikTextLabelGuncelle(sandikid) {
	if(IsValidDynamic3DTextLabel(SandikInfo[sandikid][sandikLabel]) && SandikInfo[sandikid][sandikAracID] != -1) {
		DestroyDynamic3DTextLabelEx(SandikInfo[sandikid][sandikLabel]);
		format(SandikInfo[sandikid][sandikLabelText], 128, "[Balýk Sandýðý]\n{dd5a3f}%d {ffffff}kilo balýk var.", SandikInfo[sandikid][sandikAgirlik]);
		new Float:vX, Float:vY, Float:vZ;
		GetVehiclePos(SandikInfo[sandikid][sandikAracID], vX, vY, vZ);
		SandikInfo[sandikid][sandikLabel] = CreateDynamic3DTextLabel(SandikInfo[sandikid][sandikLabelText], COLOR_WHITE, vX, vY, vZ, 30.0, INVALID_PLAYER_ID, SandikInfo[sandikid][sandikAracID]);
	}
	return 1;
}

SandikSat(playerid) {
	if(PlayerInfo[playerid][pTasidigiSandik] == -1) return HataMesajiC(playerid, "Bir sandýk taþýmýyorsun.");
	if(!IsPlayerInRangeOfPoint(playerid, 2.0, SELL_X, SELL_Y, SELL_Z)) return HataMesajiC(playerid, "Sandýk satma noktasýnda deðilsiniz.");
	
	if(SandikInfo[PlayerInfo[playerid][pTasidigiSandik]][sandikExists] == 0) return HataMesajiC(playerid, "Bir sandýk taþýmýyorsun.");
	new sandikid = PlayerInfo[playerid][pTasidigiSandik], ucret = SandikInfo[sandikid][sandikFiyat], agirlik = SandikInfo[sandikid][sandikAgirlik];
	SandikSil(sandikid);
	AC_GivePlayerMoney(playerid, ucret, "balik sandigi satti");
	SunucuMesaji(playerid, "Elindeki sandýðý $%d'den sattýn.", ucret);
	SunucuMesaji(playerid, "Sandýkta %d kilo balýk vardý.", agirlik);
	PlayerAME(playerid, "sandýk satar.");
	return 1;
}

SandikKapasiteHesapla(vehicleid) {
	new model = GetVehicleModel(vehicleid);
	switch(model) {
		case 446, 452: return 1600;
        case 453, 454: return 4000;
        case 472: return 1400;
        case 473: return 1000;
        case 484, 595: return 2400;
        case 493: return 1200;
	}
	return 0;
}