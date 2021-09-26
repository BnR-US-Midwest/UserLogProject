(*******************************************************************************
 * File:      Sample\Main.st
 * Author:    Tyler Matijevich
 * Created:   October 20, 2020/20:34 
********************************************************************************
 * Description: Demonstrate the functions and function blocks of the UserLog 
 library
********************************************************************************)

PROGRAM _INIT
	
	// Initalize inputs to the LogMessage function
	Severity	:= USERLOG_SEVERITY_SUCCESS;
	Code 		:= 1001;
	Message 	:= 'This message will be written to the user logbook';
	
	// Set the severity threshold
	fbCyclicLogBuffer.SeverityThreshold := USERLOG_SEVERITY_SUCCESS; // 0 - all messages logged, increase to filter

END_PROGRAM

PROGRAM _CYCLIC
	
	// Write a single event to the user logbook
	IF CmdWrite THEN
		CmdWrite := FALSE;
		LogMessage(Severity, Code, Message);
	END_IF
	
	// Write a burst of events to the user logbook. If it exceeds the buffer size, the events will be lost
	IF Run THEN
		Run := FALSE;
		// If loopMax is greater than USER_LOG_BUFFER_SIZE then (loopMax - USER_LOG_BUFFER_SIZE) number of entries will be lost
		// This can be observed in the buffer info structure
		// Increase USER_LOG_BUFFER_SIZE if entries are found to be lost
		FOR Index := 1 TO NumOfMessages DO
			FormatArgs.i[0] := Index;
			FormatArgs.i[1] := NumOfMessages;
			IecFormatString(MyMessage, SIZEOF(MyMessage), 'Event %i of %i', FormatArgs);
			MySeverity := (Index - 1) MOD 4;
			MyCode := 1000 + Index;
			LogMessage(MySeverity, MyCode, MyMessage);
		END_FOR
	END_IF

	// Log buffered event entries
	fbCyclicLogBuffer();
	
	// Extract information about 
	GetBufferInfo(BufferInfo);
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM
