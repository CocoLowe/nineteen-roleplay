// file-import.inc by Emmet

#define Aa:Ab:Ax:Ac:Ad:Ae:Ah:Ag:#,|||,|||         "\0"
#define Ab:Ax:Ac:Ad:Ae:Ah:Ag:#%1,%2|||%3,%4|||    Ax:Ac:Ad:Ae:Ah:Ag:#%1,%2|||%3@@%4|||
#define Ax:Ac:Ad:Ae:Ah:Ag:#%1,%2|||%3=%4@@        Ac:Ad:Ae:Ah:Ag:#%1,%2|||%3@@
#define Ac:Ad:Ae:Ah:Ag:#%1,%2|||%3:%			  Ab:Ax:Ac:Ad:Ae:Ah:Ag:#%1f,%2,%4|||
#define Ad:Ae:Ah:Ag:#%1,%2|||%3[%4]@@         	  Ab:Ax:Ac:Ad:Ae:Ah:Ag:#%1s[%4],%2,%3|||
#define Ae:Ah:Ag:#%1,%2|||%4Float:%3@@         	  Ab:Ax:Ac:Ad:Ae:Ah:Ag:#%1f,%2,%3|||
#define Ah:Ag:#%1,%2|||%3@@                	      Ab:Ax:Ac:Ad:Ae:Ah:Ag:#%1d,%2,%3|||
#define Ag:#%1,,%2||||||                    	  Af:#%1,%2
#define Af@%0,)                 				  Af@%0)

#define import%9File(%1,%2) \
	for(new %2,_LF_IN_LOOP=1;_LF_IN_LOOP;_LF_IN_LOOP=0)if(InlineFile(%1,_:Aa:Ab:Ax:Ac:Ad:Ae:Ah:Ag:#,|||%2,|||))

#define export%9File(%1,%2) \
	for(new _LF_IN_LOOP=1;_LF_IN_LOOP;_LF_IN_LOOP=0)if(InlineFile(%1,_:Aa:Ab:Ax:Ac:Ad:Ae:Ah:Ag:#,|||%2,|||))

forward @sscanf_header(); @sscanf_header()
{
	// Fixes a compiler bug regarding SYSREQ.C.

	#if defined _inc_sscanf2
	    sscanf("", "");
	#endif

	return 0;
}

stock InlineFile(filename[], spec[], {Float,_}:...)
{
	new
	    str[256],
	    File:file,
	    pos = -1,
		idx = 0
	;
	if ((file = fopen(filename, io_read)))
	{
	    // Let's determine if there is any delimiter.

	    new
			string[1024],
			delimiter,
			count;

	    if ((fread(file, string) && (!fread(file, str) || str[0] < ' ')))
	    {
			// Search for the first non-alphanumeric character.

			for (new i = 0; string[i] != '\0'; i ++)
			{
				switch (string[i])
				{
					case 'a'..'z', 'A'..'Z', '0'..'9', '-', '.':
					    continue;

					default:
					{
					    if (i > 0 && string[i - 1] == '\\')
					    {
					        i ++;
					        continue;
					    }
					    // Count the instances of the "delimiter".
					    delimiter = string[i];

					    // Check for any other instances and check if the difference > 2 chars.
					    for (i = i + 1; string[i] != '\0'; i ++)
			            {
			                if (string[i] == delimiter && (i - pos) > 2)
							{
								count++;
								pos = i;
							}
	                    }
	                    if (count >= 1)
						{
						    #if defined _inc_sscanf2
								SSCANF_Forward(string, delimiter, spec);
						    #else
								for (i = 0, pos = 0; string[i] != '\0'; i ++)
								{
								    if ((string[i] == delimiter || string[i + 1] == '\0') && (i != 0 && string[i - 1] != '\\'))
								    {
								        strmid(str, string, pos, (string[i + 1] == '\0') ? (strlen(string)) : (i));

								        switch (spec[idx++])
										{
											case 'f':
											    setarg(idx + 1, _, _:floatstr(str));

											case 's':
											{
											    new size = strval(spec[idx + 1]);

											    strdel(spec, idx, strfind(spec, "]", _, idx) + 1);

											    if (!spec[idx])
											        strmid(str, string, pos, strlen(string));

											    for (new j = 0; j < size && str[j]; j ++) {
											        if (str[j] == '\\' && str[j + 1] == delimiter)
											            strdel(str, j, j + 1);

													setarg(idx + 1, j, str[j]);
												}
							    			}
											default:
											    setarg(idx + 1, _, strval(str));
      									}
								        pos = i + 1;
								    }
		                        }
							#endif
	                        fclose(file);
	                        return 1;
						}
						break;
	                }
				}
			}
	    }
	    // We found no common delimiter, so we'll have to reset the file position.
	    fseek(file, 0, seek_start);

	    while (fread(file, str))
	    {
	        if ((str[0] == ';' || (str[0] < ' ' && strlen(str) < 3)) || (pos = strfind(str, "=")) == -1)
	            continue;

			strmid(str, str, pos + 1, strlen(str));

			// Strip leading spaces.
			for (pos = 0; str[pos] == ' ' && str[pos] != '\0'; pos ++)
			    strdel(str, pos, pos + 1);

			// Strip any newlines after the string.
			for (pos = strlen(str) - 5; pos >= 0 && str[pos] != '\0'; pos ++)
				if (str[pos] == '\r' || str[pos] == '\n') str[pos] = '\0';

			if (idx + 1 == numargs())
				break;

			switch (spec[idx++])
			{
				case 'f':
				    setarg(idx + 1, _, _:floatstr(str));

				case 's': {
				    for (new i = 0, size = strval(spec[idx + 1]); i < size && str[i]; i ++)
						setarg(idx + 1, i, str[i]);

					strdel(spec, idx, strfind(spec, "]", _, idx) + 1);
    			}
				default:
				    setarg(idx + 1, _, strval(str));
			}
	    }
	    if ((numargs() - 2) && idx < 1)
		{
		    #if defined INLINE_ERROR_REPORTING
		        printf("\a** Inline File: File reading has failed.");
	        #endif
		}
	    else if (idx < (numargs() - 2))
	    {
	        #if defined INLINE_ERROR_REPORTING
	            printf("\a** Inline File: Too many parameters specified (%d), expected (%d).", numargs() - 2, idx);
	        #endif
	    }
 	    fclose(file);
 	    return 1;
	}
	else
	{
	    #if defined INLINE_ERROR_REPORTING
	    	printf("\a** Inline File: File \"%s\" doesn't exist.", filename);
		#endif
	}
	//return 0;
}

stock static SSCANF_Forward(const data[], const delim, const spec[])
{
	static
		start,
		end,
		args,
		str[32];

    format(str, sizeof(str), "p<%c>%s", delim, spec);

	// Load the number of arguments from the last function.
	#emit LOAD.S.pri 0
	#emit ADD.C 8
	#emit MOVE.alt
	#emit LOAD.I

	// Load the end address of the arguments.
	#emit STOR.pri args
	#emit ADD
	#emit STOR.pri end

	for (start = (end - args) + 8; end > start; end -= 4) {
		// Push the parameters onto the stack.
  		#emit LREF.pri end
    	#emit PUSH.pri
	}
	// Push our specifier string and the file data.
	#emit PUSH.C str
	#emit PUSH.S data
	#emit PUSH args

	// Call the corresponding native.
	#emit SYSREQ.C sscanf

	// Clear the data from the stack.
	#emit LCTRL 5
	#emit SCTRL 4
	#emit RETN

	return 0;
}