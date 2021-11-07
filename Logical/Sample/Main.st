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
		// If loopMax is greater than USERLOG_MAX_MESSAGES then (loopMax - USERLOG_MAX_MESSAGES) number of entries will be lost
		// This can be observed in the log info structure
		// Increase USERLOG_MAX_MESSAGES if entries are found to be lost
		FOR Index := 1 TO NumOfMessages DO
			// Setup
			SetVerbosityLevel(MyVerbosityLevel);
			MySeverity := (Index - 1) MOD 6;
			MyCode := 1000 + Index;
			// Format
			FormatArgs.i[0] := Index;
			FormatArgs.i[1] := NumOfMessages;
			CASE MySeverity OF
				USERLOG_SEVERITY_CRITICAL: 		FormatArgs.s[0] := 'Critical';
				USERLOG_SEVERITY_ERROR: 		FormatArgs.s[0] := 'Error';
				USERLOG_SEVERITY_WARNING: 		FormatArgs.s[0] := 'Warning';
				USERLOG_SEVERITY_INFORMATION: 	FormatArgs.s[0] := 'Infomration';
				USERLOG_SEVERITY_SUCCESS: 		FormatArgs.s[0] := 'Success';
				USERLOG_SEVERITY_DEBUG: 		FormatArgs.s[0] := 'Debug';
			END_CASE
			IecFormatString(MyMessage, SIZEOF(MyMessage), 'Event: %i of %i Severity: %s', FormatArgs);
			// Log
			LogMessage(MySeverity, MyCode, MyMessage);
		END_FOR
	END_IF
	
	GetUserLogInfo(LogInfo);
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM
