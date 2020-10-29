(*******************************************************************************
 * Copyright: B&R Industrial Automation
 * Author:    Tyler Matijevich
 * Created:   October 28, 2020/16:30 
********************************************************************************
 * Description: Test logging buffer code
********************************************************************************)

PROGRAM _INIT
	
	SizeOfDataBuffer := SIZEOF(DataBuffer);
	Message := 'Hello world! My name is Tyler.';
	
END_PROGRAM

PROGRAM _CYCLIC
	
	CASE State OF
	
		0:
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
		
		10:
			IF fbGetIdent.Done THEN
				// Write to the logbook
				fbWrite.Ident := fbGetIdent.Ident;
				fbWrite.EventID := EventID;
				fbWrite.OriginRecordID := 0;
				fbWrite.AddDataSize := brsstrlen(ADR(Message));
				fbWrite.AddDataFormat := arEVENTLOG_ADDFORMAT_TEXT;
				fbWrite.AddData := ADR(Message);
				fbWrite.ObjectID := 'Sample';
				fbWrite.Execute := TRUE;
				
				State := 20;
			
			ELSIF fbGetIdent.Error THEN
				ErrorState := State;
				State := 255;
				
			END_IF
		
		20:
			IF fbWrite.Done THEN
				
				State := 0;
				
			ELSIF fbWrite.Error THEN
				ErrorState := State;
				State := 255;
			
			END_IF
			
		30:
	
	END_CASE
	
	// Call function blocks
	fbGetIdent();
	fbWrite();
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM
