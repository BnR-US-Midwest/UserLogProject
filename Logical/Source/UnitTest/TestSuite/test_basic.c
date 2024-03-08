#include <UnitTest.h>
#include <UserLog.h>
#include <ArEventLog.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#define SAMPLE_CODE 12345
#define SAMPLE_MESSAGE "Hello World!"
#define LOGBOOK_USER "$arlogusr"

_TEST test_basic_severity_success(void)
{
    /* Perform test */
    int32_t record;
    record = UserLogBasic(USERLOG_SEVERITY_SUCCESS, SAMPLE_CODE, 
                          SAMPLE_MESSAGE);

    /* Read details from logbook synchronously */
    /* Get logbook identifier */
    ArEventLogGetIdent_typ get_ident = {{0}};
    strcpy(get_ident.Name, LOGBOOK_USER);
    get_ident.Execute = true;
    ArEventLogGetIdent(&get_ident);
    if (get_ident.StatusID)
    {
        TEST_FAIL("ArEventLogGetIdent error");
        TEST_DONE;
    }

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

    /* Read additional data */
    char message[256] = {0};
    ArEventLogReadAddData_typ read_data = {0};
    read_data.Ident = get_ident.Ident;
    read_data.RecordID = get_latest_record.RecordID;
    read_data.AddData = (uint32_t)message;
    read_data.BytesToRead = read_record.AddDataSize;
    read_data.Execute = true;
    ArEventLogReadAddData(&read_data);
    if (read_data.StatusID)
    {
        TEST_FAIL("ArEventLogReadAddData error");
        TEST_DONE;
    }

    TEST_ASSERT(record > 0);
    TEST_ASSERT_EQUAL_INT(record, get_latest_record.RecordID);
    int32_t event_ID = ArEventLogMakeEventID(arEVENTLOG_SEVERITY_SUCCESS,
                                             USERLOG_FACILITY,
                                             SAMPLE_CODE);
    TEST_ASSERT_EQUAL_INT(event_ID, read_record.EventID);
    TEST_ASSERT_EQUAL_STRING(SAMPLE_MESSAGE, message);

    TEST_DONE;
}

UNITTEST_FIXTURES(fixtures)
{
    new_TestFixture("UserLogBasic severity success",
                    test_basic_severity_success)
};

UNITTEST_CALLER_TEST (basic_set, "UserLogBasic test set", fixtures);
