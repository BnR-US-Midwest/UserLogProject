
PROGRAM _INIT
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF LogCondition THEN
		LogCondition := FALSE;
		UserLogAdvanced(USERLOG_SEVERITY_INFORMATION, 
						123, 
						'Error=%b, Temperature=%f C, StatusID=%i, State=%s', 
						LogValues);
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM

