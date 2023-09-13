
#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

#include <string.h>
#include <stdbool.h>

void _INIT ProgramInit(void)
{
	UserLogBasic(USERLOG_SEVERITY_SUCCESS, 1234, "Hello World!");
	
	FormatValues.b[0] = false;
	FormatValues.f[0] = 23.1;
	FormatValues.i[0] = -1070586087;
	strcpy(FormatValues.s[0], "Starting");
	UserLogAdvanced(USERLOG_SEVERITY_INFORMATION, 567, "Error=%b, Temperature=%f C, StatusID=%i, State=%s", &FormatValues);
	
	UserLogCreate("Custom", 200000);
	UserLogCustom("Custom", USERLOG_SEVERITY_WARNING, 25, 789, 0, NULL, "This message is written to the Custom logbook", NULL);
	
	UserLogEventText("$arlogusr", USERLOG_EXAMPLE_TEXT_ID, 0, NULL, "This is a description of the log record", NULL);
	
	FormatValues.i[0] = UserLogSetSeverityLevel(USERLOG_SEVERITY_DEBUG);
	FormatValues.i[1] = USERLOG_SEVERITY_DEBUG;
	UserLogAdvanced(USERLOG_SEVERITY_DEBUG, 3, "Default severity level = %i, new severity level = %i", &FormatValues);
	
	UserLogSetSeverityLevel(USERLOG_SEVERITY_WARNING);
	UserLogBasic(USERLOG_SEVERITY_DEBUG, 1, "This is a debug message that will be suppressed");
	UserLogBasic(USERLOG_SEVERITY_WARNING, 2, "This is a warning message that will not be suppressed");
	
	Severity = UserLogGetSeverity(USERLOG_EXAMPLE_TEXT_ID);
	Facility = UserLogGetFacility(USERLOG_EXAMPLE_TEXT_ID);
	Code = UserLogGetCode(USERLOG_EXAMPLE_TEXT_ID);
}

void _CYCLIC ProgramCyclic(void)
{
	
}

void _EXIT ProgramExit(void)
{

}

