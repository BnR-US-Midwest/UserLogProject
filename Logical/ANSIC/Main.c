
#include <bur/plctypes.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

#define MAX(x,y) (((x) > (y)) ? (x) : (y))
#define MIN(x,y) (((x) < (y)) ? (x) : (y))

void _INIT ProgramInit(void)
{
	strcpy(Logbook, "$arlogusr");
	Severity = USERLOG_SEVERITY_DEBUG;
	Facility = 2;
	Code = 1234;
	pObject = (uint32_t)Object;
	strcpy(Message, "Hello World!");
	pMessage = (uint32_t)Message;
	pArguments = (uint32_t)&Arguments;
	Level = USERLOG_SEVERITY_SUCCESS;
	
	UserLogCreate("Test", 200000);
	
	UserLogQuick(USERLOG_SEVERITY_SUCCESS, Code, "Hello World!");
	
	Arguments.i[0] = Code;
	UserLogFormat(USERLOG_SEVERITY_INFORMATION, Code, "My code is %i", &Arguments);
	
	LoopMax = 5;
}

void _CYCLIC ProgramCyclic(void)
{
	if(Test) {
		Test = false;
		ReturnValue = UserLogMessage(Logbook, Severity, Facility, Code, Origin, (char*)pObject, (char*)pMessage, (UserLogFormatType*)pArguments);
	}
	UserLogSetSeverityLevel(Level);
	
	if (TestLoop) 
	{
		TestLoop = false;
		for (Index = 0; Index < LoopMax; Index++) 
		{
			Arguments.i[0] = Index + 1;
			UserLogMessage(Logbook, Severity, Facility, Code, Origin, (char*)pObject, (char*)pMessage, (UserLogFormatType*)pArguments);
		}
	}
	
	EventID = ArEventLogMakeEventID(MIN(arEVENTLOG_SEVERITY_ERROR, MAX(arEVENTLOG_SEVERITY_SUCCESS, Severity)), Facility, Code);
	GetSeverity = UserLogGetSeverity(EventID);
	GetFacility = UserLogGetFacility(EventID);
	GetCode = UserLogGetCode(EventID);
}

void _EXIT ProgramExit(void)
{

}

