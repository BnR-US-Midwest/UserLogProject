
PROGRAM _INIT
	(* Insert code here *)
	LogMessage(severity := USERLOG_SEVERITY_SUCCESS, code := 1234, message := 'Hello World!');
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	IF Test THEN
		FOR IndexEntries := 1 TO Entries DO
			Args.i[0] := IndexScans + 1;
			Args.i[1] := IndexEntries;
			LogFormatMessage(1, 1, 'Scan %i entry %i', Args);
		END_FOR
		
		IndexScans := IndexScans + 1;
		IF IndexScans >= Scans THEN
			Test := FALSE;
		END_IF
	ELSE
		IndexScans := 0;
	END_IF
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

