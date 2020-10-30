(*******************************************************************************
 * Copyright: B&R Industrial Automation
 * Author:    Tyler Matijevich
 * Created:   October 28, 2020/16:30 
********************************************************************************
 * Description: Test logging buffer code
********************************************************************************)

PROGRAM _INIT
	
	SizeOfDataBuffer := SIZEOF(DataBuffer);
	StatusTaskName := GetName(ADR(sTaskName));
	
END_PROGRAM

PROGRAM _CYCLIC
	
	CASE State OF
		// INIT
		0:
			// Prepare the get ident FB
			fbGetIdent.Name := '$$arlogusr';
			fbGetIdent.Execute := TRUE;
			
			// Go to the next state
			State := 10;
			
		10:
			// Wait for compeletion
			IF fbGetIdent.Done THEN
				// Reset the FB
				fbGetIdent.Execute := FALSE;
				
				UserLogIdent := fbGetIdent.Ident;
				
				// Go to the next state
				State := 20;
				
			ELSIF fbGetIdent.Error THEN
				ErrorState := State;
				State := 255;
				
			END_IF
			
		20:
			IF (ReadLogIndex <> WriteLogIndex OR LogBufferFull) AND OverrideRead THEN
				
				// Create the event ID
				EventID := ArEventLogMakeEventID(LogBuffer[ReadLogIndex].LogEntry.Severity, 0, LogBuffer[ReadLogIndex].LogEntry.Code);
				
				// Write to the logbook
				fbWrite.Ident			:= UserLogIdent;
				fbWrite.EventID			:= EventID;
				fbWrite.OriginRecordID	:= 0;
				fbWrite.AddDataFormat	:= arEVENTLOG_ADDFORMAT_TEXT;
				fbWrite.AddDataSize		:= brsstrlen(ADR(LogBuffer[ReadLogIndex].LogEntry.sMessage)) + 1;
				fbWrite.AddData			:= ADR(LogBuffer[ReadLogIndex].LogEntry.sMessage);
				fbWrite.ObjectID		:= LogBuffer[ReadLogIndex].sTaskName;
				fbWrite.Execute			:= TRUE;
				
				ReadLogIndex := Math_WrapUSINT(ReadLogIndex + 1, 0, MAX_LOG_INDEX);
				
				State := 21;
			
			END_IF
				
		
		1:
			IF CmdLog THEN
				CmdLog := FALSE;
				ErrorState := 0;
				
				// Create event ID
				EventID := ArEventLogMakeEventID(0, 1, 1001);
				
				// Initialize the data buffer
				InitBufferReturn := ArEventLogAddDataInit(ADR(DataBuffer), SizeOfDataBuffer, arEVENTLOG_ADDFORMAT_CODED);
				
				// Add string data to the buffer
				AddStringDataReturn := ArEventLogAddDataString(ADR(DataBuffer), SizeOfDataBuffer, ADR(Message));
				
				// Initialize the logbook ident
				fbGetIdent.Name := '$$arlogusr';
				fbGetIdent.Execute := TRUE;
				
				State := 10;
				
			END_IF
		
		11:
			IF fbGetIdent.Done THEN
				// Write to the logbook
				fbWrite.Ident := fbGetIdent.Ident;
				fbWrite.EventID := EventID;
				fbWrite.OriginRecordID := 0;
				fbWrite.AddDataSize := 81;
				fbWrite.AddDataFormat := arEVENTLOG_ADDFORMAT_TEXT;
				fbWrite.AddData := ADR(Message);
				fbWrite.ObjectID := 'Sample';
				fbWrite.Execute := TRUE;
				
				State := 20;
			
			ELSIF fbGetIdent.Error THEN
				ErrorState := State;
				State := 255;
				
			END_IF
		
		21:
			IF fbWrite.Done THEN
				fbWrite.Execute := FALSE;
				
				// If the indexes match, reset the log buffer full flag
				IF ReadLogIndex = WriteLogIndex AND LogBufferFull THEN
					LogBufferFull := FALSE;
				END_IF
				
				State := 20;
				
			ELSIF fbWrite.Error THEN
				ErrorState := State;
				State := 255;
			
			END_IF
			
		255:
	
	END_CASE
	
	// Call function blocks
	fbGetIdent();
	fbWrite();
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM
