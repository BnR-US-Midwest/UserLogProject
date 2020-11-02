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
	
	GetBufferInfo(Info);

	// Log buffered event entries
	CyclicLogBuffer_0();
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM
