(*******************************************************************************
 * Copyright: B&R Industrial Automation
 * Author:    Tyler Matijevich
 * Created:   October 29, 2020/15:57 
********************************************************************************
 * Description: A short description 
********************************************************************************)

PROGRAM _INIT
	
	Message := 'Test';
	Severity := 1;
	Code := 1001;

END_PROGRAM

PROGRAM _CYCLIC
	
	IF CmdWrite THEN
		CmdWrite := FALSE;
		
		IF LogBufferFull = FALSE THEN
		
			sConstructMessage := 'This is the log number %i';
			MessageArguments.i[0] := WriteCounter;
			IecFormatString(ADR(Message), 80, ADR(sConstructMessage), ADR(MessageArguments));
			WriteCounter := WriteCounter + 1;
			
			LogBuffer[WriteLogIndex].LogEntry.Severity 	:= Severity;
			LogBuffer[WriteLogIndex].LogEntry.Code		:= Code;
			LogBuffer[WriteLogIndex].LogEntry.sMessage 	:= Message;
			
			StatusTaskName := ST_name(0, ADR(LogBuffer[WriteLogIndex].sTaskName), 0);
			
			// Update write index
			WriteLogIndex := Math_WrapUSINT(WriteLogIndex + 1, 0, MAX_LOG_INDEX);
			IF WriteLogIndex = ReadLogIndex THEN
				LogBufferFull := TRUE;
			END_IF
		
		END_IF
		
	END_IF
	
	
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM
