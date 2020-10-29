(*******************************************************************************
 * Copyright: B&R Industrial Automation
 * Author:    Tyler Matijevich
 * Created:   October 20, 2020/20:34 
********************************************************************************
 * Description: A short description 
********************************************************************************)

PROGRAM _INIT
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF CmdGetInfo THEN
		CmdGetInfo := FALSE;
		GetLogBufferInfo(LogBufferInfo);
	END_IF
	
	IF CmdCyclic THEN
		CmdCyclic := FALSE;
		CyclicLogBufferedEntries();
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM
