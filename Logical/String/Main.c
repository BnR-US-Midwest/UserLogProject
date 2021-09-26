
#include <bur/plctypes.h>
#include <string.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

void _INIT ProgramInit(void)
{
	strcpy(str2, "abcdefghijkl");
	memset(str1, 1, sizeof(str1));
	strncpy(str1, str2, sizeof(str1) - 1);
	memset(str1 + sizeof(str1) - 1, 0, 1);
	memcpy(mem1, str1, sizeof(mem1));
	memcpy(mem2, str2, sizeof(mem2));
	
	LogMessage(USERLOG_SEVERITY_SUCCESS, 1234, "Hello World!");
}

void _CYCLIC ProgramCyclic(void)
{
	
}

void _EXIT ProgramExit(void)
{

}

