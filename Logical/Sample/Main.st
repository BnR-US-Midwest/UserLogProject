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
	
	IF CmdWrite THEN
		CmdWrite := FALSE;
		
		LogEvent(Severity, Code, Message);
	END_IF

	// Log buffered event entries
	CyclicUserLogBuffer_0();
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM
