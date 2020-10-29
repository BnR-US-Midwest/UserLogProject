
TYPE
	LogEntryType : 	STRUCT 
		Severity : USINT;
		Code : UINT;
		sMessage : STRING[80];
	END_STRUCT;
	BufferEntryType : 	STRUCT 
		LogEntry : LogEntryType;
		sTaskName : STRING[10];
	END_STRUCT;
END_TYPE
