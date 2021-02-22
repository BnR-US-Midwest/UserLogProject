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
	Severity	:= USER_LOG_SEVERITY_SUCCESS;
	Code 		:= 1001;
	Message 	:= 'This message will be written to the user logbook';
	
	// Initialize # of messages written in one cycle for the burst sample (line 31)
	loopMax		:= 12;
	
	// Set the severity threshold
	CyclicLogBuffer_0.SeverityThreshold := USER_LOG_SEVERITY_SUCCESS; // 0 - all messages logged, increase to filter

END_PROGRAM

PROGRAM _CYCLIC
	
	// Write a single event to the user logbook
	IF CmdWrite THEN
		CmdWrite := FALSE;
		LogMessage(Severity, Code, Message);
	END_IF
	
	// Write a burst of events to the user logbook. If it exceeds the buffer size, the events will be lost
	IF CmdBurst THEN
		CmdBurst := FALSE;
		// If loopMax is greater than USER_LOG_BUFFER_SIZE then (loopMax - USER_LOG_BUFFER_SIZE) number of entries will be lost
		// This can be observed in the buffer info structure
		// Increase USER_LOG_BUFFER_SIZE if entries are found to be lost
		FOR loop := 1 TO loopMax DO
			ConstructBurstMessage := 'Event %i of %i';
			BurstMessageArguments.i[0] := loop;
			BurstMessageArguments.i[1] := loopMax;
			IecFormatString(ADR(FormattedBurstMessage), SIZEOF(FormattedBurstMessage), ADR(ConstructBurstMessage), ADR(BurstMessageArguments));
			BurstSeverity 	:= (loop - 1) MOD 4;
			BurstCode		:= 1001 + loop;
			LogMessage(BurstSeverity, BurstCode, FormattedBurstMessage);
		END_FOR
	END_IF

	// Log buffered event entries
	CyclicLogBuffer_0();
	
	// Extract information about 
	GetBufferInfo(BufferInfo);
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM
