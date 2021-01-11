SendSupporterAlert(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[256];

	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if(args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for(end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}

		#emit PUSH.S str
		#emit PUSH.C 256
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] >= 1 && PlayerInfo[i][pSupporterAlert])
  				SendClientMessageEx(i, color, string);
		
		
		return 1;
	}

	foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] >= 1 && PlayerInfo[i][pSupporterAlert])
			SendClientMessageEx(i, color, str);
			
	
	return 1;
}

SoruYollaHelper(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[256];

	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if(args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for(end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}

		#emit PUSH.S str
		#emit PUSH.C 256
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] == 1 || PlayerInfo[i][pAdmin] == 2 || PlayerInfo[i][pAdmin] == 3 && PlayerInfo[i][pSupporterAlert])
  				SendClientMessageEx(i, color, string);
				
		
		return 1;
	}

	foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] == 1 || PlayerInfo[i][pAdmin] == 2 || PlayerInfo[i][pAdmin] == 3 && PlayerInfo[i][pSupporterAlert])
			SendClientMessageEx(i, color, str);

	
	return 1;
}

SendAdminAlert(bool:forcedAlert, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[256];

	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if(args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for(end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}

		#emit PUSH.S str
		#emit PUSH.C 256
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player)
		{
			if(!IsPlayerConnected(i) || !PlayerInfo[i][pLogged] || PlayerInfo[i][pAdmin] < GAMEADMIN1)continue;
			if(!forcedAlert && !PlayerInfo[i][pAdminAlert])continue;

			SendClientMessageEx(i, color, string);
		}
		

		return 1;
	}

	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i) || !PlayerInfo[i][pLogged] || PlayerInfo[i][pAdmin] < GAMEADMIN1)continue;
		if(!forcedAlert && !PlayerInfo[i][pAdminAlert])continue;

		SendClientMessageEx(i, color, str);
	}
	

	return 1;
}

SendAdminHelperAlert(bool:forcedAlert, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[256];

	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if(args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for(end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}

		#emit PUSH.S str
		#emit PUSH.C 256
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player)
		{
			if(!IsPlayerConnected(i) || !PlayerInfo[i][pLogged] || PlayerInfo[i][pAdmin] < SUPPORTER)continue;
			if(!forcedAlert && !PlayerInfo[i][pAdminAlert])continue;

			SendClientMessageEx(i, color, string);
		}
		
		return 1;
	}

	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i) || !PlayerInfo[i][pLogged] || PlayerInfo[i][pAdmin] < SUPPORTER)continue;
		if(!forcedAlert && !PlayerInfo[i][pAdminAlert])continue;

		SendClientMessageEx(i, color, str);
	}
	

	return 1;
}


SendFactionMessage(fid, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[256];

	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if(args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for(end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}

		#emit PUSH.S str
		#emit PUSH.C 256
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == fid && PlayerInfo[i][pFactionDuty])
			if(fid == 0) SendClientMessageEx(i, RENK_LSPD, string);
			else SendClientMessageEx(i, COLOR_LIGHTBLUE, string);

		return 1;
	}

	foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == fid && PlayerInfo[i][pFactionDuty])
		if(fid == 0) SendClientMessageEx(i, RENK_LSPD, str);
		else SendClientMessageEx(i, COLOR_LIGHTBLUE, str);
		
	return 1;
}

SendFactionRadioMessage(fid, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[256];

	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if(args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for(end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}

		#emit PUSH.S str
		#emit PUSH.C 256
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == fid && PlayerInfo[i][pFactionDuty])
			if(fid == 0) SendClientMessageEx(i, COLOR_RADIO, string);
			else SendClientMessageEx(i, COLOR_RADIO, string);
		return 1;
	}

	foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == fid && PlayerInfo[i][pFactionDuty])
		if(fid == 0) SendClientMessageEx(i, COLOR_RADIO, str);
		else SendClientMessageEx(i, COLOR_RADIO, str);
	return 1;
}

SendFactionMessageTR(fid, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[256];

	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if(args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for(end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}

		#emit PUSH.S str
		#emit PUSH.C 256
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == fid)// && PlayerInfo[i][pFactionDuty])
  				SendClientMessageEx(i, RENK_LSFD, string);
		return 1;
	}

	foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == fid)// && PlayerInfo[i][pFactionDuty])
			SendClientMessageEx(i, RENK_LSFD, str);
	return 1;
}

SendJobMessage(jobID, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[256];

	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if(args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for(end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}

		#emit PUSH.S str
		#emit PUSH.C 256
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pJob] == jobID)
  				SendClientMessageEx(i, COLOR_LIGHTBLUE, string);
		return 1;
	}

	foreach(new i : Player) if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && PlayerInfo[i][pJob] == jobID)
			SendClientMessageEx(i, COLOR_LIGHTBLUE, str);
	return 1;
}

SendFormattedMessage(playerid, color, fstring[], {Float, _}:...)
{
    static const
        STATIC_ARGS = 3;

    new n = (numargs() - STATIC_ARGS) * BYTES_PER_CELL;

    if(n)
    {
        new
            message[256],
            arg_start,
            arg_end;

        #emit CONST.alt        fstring
        #emit LCTRL          5
        #emit ADD
        #emit STOR.S.pri        arg_start

        #emit LOAD.S.alt        n
        #emit ADD
        #emit STOR.S.pri        arg_end
        do
        {
            #emit LOAD.I
            #emit PUSH.pri
            arg_end -= BYTES_PER_CELL;
            #emit LOAD.S.pri      arg_end
        }
        while(arg_end > arg_start);

        #emit PUSH.S          fstring
        #emit PUSH.C          210
        #emit PUSH.ADR         message

        n += BYTES_PER_CELL * 3;
        #emit PUSH.S          n
        #emit SYSREQ.C         format

        n += BYTES_PER_CELL;
        #emit LCTRL          4
        #emit LOAD.S.alt        n
        #emit ADD
        #emit SCTRL          4

        return SendClientMessageEx(playerid, color, message);
    }
    else
    {
        return SendClientMessageEx(playerid, color, fstring);
    }
}

SSCANF:m(string[])
{
	if(IsNumeric(string) > 0)
	{
		return strval(string);
	}

	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i) || !PlayerInfo[i][pLogged]) continue;

		if(strfind(ReturnName(i), string, true) != -1)
			return i;

		if(strfind(PlayerInfo[i][pMaskName], string, true) != -1 && PlayerInfo[i][pMasked])
			return i;
	}

	return INVALID_PLAYER_ID;
}
