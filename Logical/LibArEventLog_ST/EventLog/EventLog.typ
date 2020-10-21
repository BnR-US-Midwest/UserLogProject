(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: EventLog
 * File: EventLog.typ
 * Author: Bernecker + Rainer
 * Created: June, 2015
 ********************************************************************
 * Local data types of program EventLog
 ********************************************************************)

TYPE
	EventLog_typ : 	STRUCT  (*Event handling.*)
		Commands : EventLog_Commands_typ; (*Event handling user commands.*)
		Data : EventLog_Data_typ; (*Event handling data for state machine.*)
		Event : EventLog_Event_typ; (*Event handling event description.*)
		FunctionBlocks : EventLog_FunctionBlocks_typ; (*Event handling used functionblocks.*)
	END_STRUCT;
	EventLog_Commands_typ : 	STRUCT 
		CreateUserLog : BOOL; (*Creates the user logbook "UsrEvLog" in USERROM.*)
		DeleteUserLog : BOOL; (*Deletes the user logbook "UsrEvLog".*)
		WriteUserEvent : BOOL; (*Writes a user event into the user logbook "UsrEvLog". *)
		ReadLatestEvent : BOOL; (*Reads the latest event of the user logbook "UsrEvLog".*)
		ReadPreviousEvent : BOOL; (*Reads the previous event (of the given record id) of the user logbook "UserEvLog".*)
	END_STRUCT;
	EventLog_Data_typ : 	STRUCT 
		Step : EventLogSteps; (*Current step. STEP_ERROR must be manually reset (STEP_WAIT_FOR_INPUT).*)
		Ident : ArEventLogIdentType; (*Ident of the logbook "UsrEvLog".*)
		StatusID : DINT; (*Status information for STEP_ERROR.*)
		GetIdentOkNextStep : EventLogSteps; (*Internal helper for state machine.*)
		GetIdentFailNextStep : EventLogSteps; (*Internal helper for state machine.*)
	END_STRUCT;
	EventLog_Event_typ : 	STRUCT 
		Severity : USINT; (*Severity of the last event (read).*)
		Customer : BOOL; (*Customer bit of the last event (read).*)
		Facility : UINT; (*Facility of the last event (read).*)
		Code : UINT; (*Code of the last event (read).*)
		EventID : DINT; (*EventID for write event (write - is not set by reading an event).*)
		ErrorNumber : UDINT; (*Error number of the event- set when the read event is no event id event (read).*)
		EnteredBy : STRING[36]; (*User/object identification (read/write - optional).*)
		OriginID : ArEventLogRecordIDType; (*Record id of the origin record (read/write - optional).*)
		RecordID : ArEventLogRecordIDType; (*Record id of the event to read (read - set automatically).*)
		TimeStamp : ArEventLogTimeStampType;
		AdditionalDataSize : UDINT; (*Size of the additional data (read/write - optional)*)
		AdditionalDataFormat : USINT; (*Format of the additional data (read/write)*)
		AdditionalData : ARRAY[0..128]OF USINT; (*Additional data (read/write)*)
	END_STRUCT;
	EventLog_FunctionBlocks_typ : 	STRUCT 
		ArEventLogCreate_0 : ArEventLogCreate;
		ArEventLogDelete_0 : ArEventLogDelete;
		ArEventLogGetIdent_0 : ArEventLogGetIdent;
		ArEventLogGetLatestRecordID_0 : ArEventLogGetLatestRecordID;
		ArEventLogGetPreviousRecordID_0 : ArEventLogGetPreviousRecordID;
		ArEventLogWrite_0 : ArEventLogWrite;
		ArEventLogRead_0 : ArEventLogRead;
		ArEventLogReadErrorNumber_0 : ArEventLogReadErrorNumber;
		ArEventLogReadAddData_0 : ArEventLogReadAddData;
		ArEventLogReadObjectID_0 : ArEventLogReadObjectID;
	END_STRUCT;
	EventLogSteps : 
		(
		STEP_WAIT_FOR_INPUT := 0,
		STEP_CREATE_LOGBOOK := 1,
		STEP_DELETE_LOGBOOK := 2,
		STEP_GET_LOGBOOK_IDENT := 3,
		STEP_WRITE_EVENT := 4,
		STEP_READ_EVENT := 5,
		STEP_READ_ERROR_NUMBER := 6,
		STEP_READ_ADDITIONAL_DATA := 7,
		STEP_READ_OBJECT_ID := 8,
		STEP_GET_LATEST_RECORD_ID := 9,
		STEP_GET_PREVIOUS_RECORD_ID := 10,
		STEP_ERROR := 255
		);
END_TYPE
