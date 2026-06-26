#include <UnitTest.h>
#include <UserLog.h>
#include <ArEventLog.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#define LOGBOOK_USER "$arlogusr"
#define SAMPLE_EVENT 1611615776
#define SAMPLE_BOOL 1
#define SAMPLE_FLOAT 4.56
#define SAMPLE_INT 7
#define SAMPLE_STRING "Hello World!"

#define GET_IDENT ArEventLogGetIdent_typ get_ident = {{0}}; \
strcpy(get_ident.Name, LOGBOOK_USER); \
get_ident.Execute = true; \
ArEventLogGetIdent(&get_ident); \
if (get_ident.StatusID) \
{ \
    TEST_FAIL("ArEventLogGetIdent error"); \
    TEST_DONE; \
}

_TEST test_event_text_sample(void)
{
    /* Perform test */
    int32_t record;
    UserLogFormatType FormatValues;
    FormatValues.b[0] = SAMPLE_BOOL;
    FormatValues.f[0] = SAMPLE_FLOAT;
    FormatValues.i[0] = SAMPLE_INT;
    strcpy((char*)&FormatValues.s[0], (char*)&SAMPLE_STRING);
    record = UserLogEventText(LOGBOOK_USER, SAMPLE_EVENT, 0, NULL, "%b %f %i %s", &FormatValues);

    /* Read details from logbook synchronously */
    GET_IDENT

    /* Get latest record */
    ArEventLogGetLatestRecordID_typ get_latest_record = {0};
    get_latest_record.Ident = get_ident.Ident;
    get_latest_record.Execute = true;
    ArEventLogGetLatestRecordID(&get_latest_record);
    if (get_latest_record.StatusID)
    {
        TEST_FAIL("ArEventLogGetLatestRecordID error");
        TEST_DONE;
    }

    /* Read record */
    ArEventLogRead_typ read_record = {0};
    read_record.Ident = get_ident.Ident;
    read_record.RecordID = get_latest_record.RecordID;
    read_record.Execute = true;
    ArEventLogRead(&read_record);
    if (read_record.StatusID)
    {
        TEST_FAIL("ArEventLogRead error");
        TEST_DONE;
    }

    /* Read description */
    char message[256] = {0};
    ArEventLogReadDescription_typ read_message = {0};
    read_message.Ident = get_ident.Ident;
    read_message.RecordID = get_latest_record.RecordID;
    read_message.TextBuffer = (UDINT)&message;
    read_message.TextBufferSize = sizeof(message);
    read_message.Execute = true;
    while(!read_message.Done && !read_message.Error){
        ArEventLogReadDescription(&read_message);
        if (read_message.StatusID || read_message.Error)
        {
            TEST_FAIL("ArEventLogReadDescription error");
            TEST_DONE;
        }
    }

    TEST_ASSERT(record > 0);
    TEST_ASSERT_EQUAL_INT(record, get_latest_record.RecordID);
    TEST_ASSERT_EQUAL_INT(SAMPLE_EVENT, read_record.EventID);
    
    /* Check description. Update this if the Sample tmx entry changes!! */
    char resultMessage[256] = {0};
    strcat((char*)&resultMessage, (char*)&"Sample UserLogEventText: ");
    strcat((char*)&resultMessage, (char*)&"TRUE ");
    strcat((char*)&resultMessage, (char*)&"4.560000 ");
    strcat((char*)&resultMessage, (char*)&"7 ");
    strcat((char*)&resultMessage, (char*)&SAMPLE_STRING);
    TEST_ASSERT_EQUAL_STRING(resultMessage, message);

    TEST_DONE;
}

UNITTEST_FIXTURES(fixtures)
{
    new_TestFixture("UserLogEventText success",
                    test_event_text_sample)
};

UNITTEST_CALLER_TEST (even_text_set, "UserLogEventText test set", fixtures);
