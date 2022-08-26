
#include <bur/plctypes.h>
#include <string.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

void _INIT ProgramInit(void)
{
	UserLogMessage("$arlogusr", 
		USERLOG_SEVERITY_DEBUG,
		12,
		1234, 
		0,
		NULL,
		"Hello world!",
		NULL);
}

void _CYCLIC ProgramCyclic(void)
{
	
}

void _EXIT ProgramExit(void)
{

}

