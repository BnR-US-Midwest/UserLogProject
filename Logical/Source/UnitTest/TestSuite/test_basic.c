#include <UnitTest.h>
#include <UserLog.h>
#include <ArEventLog.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

_TEST test_basic_pass(void)
{
    TEST_ASSERT_EQUAL_INT(1, 1);

    TEST_DONE;
}

_TEST test_basic_fail(void)
{
    TEST_ASSERT_EQUAL_INT(1, 0);

    TEST_DONE;
}

_TEST test_basic_severity_success(void)
{
    /* Perform test */
    UserLogBasic(USERLOG_SEVERITY_SUCCESS, 1234, "Hello World!");

    /* Read details from logbook synchronously */
    /* Get logbook identifier */
    ArEventLogGetIdent_typ get_ident;
    memset(&get_ident, 0, sizeof(get_ident));
    strcpy(get_ident.Name, "$arlogusr");
    get_ident.Execute = true;
    ArEventLogGetIdent(&get_ident);
    if (get_ident.StatusID) {
        TEST_FAIL("ArEventLogGetIdent error");
        TEST_DONE;
    }

    /* Get latest record */
    ArEventLogGetLatestRecordID_typ get_latest_record;
    memset(&get_latest_record, 0, sizeof(get_latest_record));
    get_latest_record.Ident = get_ident.Ident;
    get_latest_record.Execute = true;
    ArEventLogGetLatestRecordID(&get_latest_record);
    if (get_latest_record.StatusID) {
        TEST_FAIL("ArEventLogGetLatestRecordID error");
        TEST_DONE;
    }

    /* Read record */
    ArEventLogRead_typ read_record;
    memset(&read_record, 0, sizeof(read_record));
    read_record.Ident = get_ident.Ident;
    read_record.RecordID = get_latest_record.RecordID;
    read_record.Execute = true;
    ArEventLogRead(&read_record);
    if (read_record.StatusID) {
        TEST_FAIL("ArEventLogRead error");
        TEST_DONE;
    }

    /* Read additional data */
    char message[256];
    memset(&message, 0, sizeof(message));
    ArEventLogReadAddData_typ read_data;
    memset(&read_data, 0, sizeof(read_data));
    read_data.Ident = get_ident.Ident;
    read_data.RecordID = get_latest_record.RecordID;
    read_data.AddData = (uint32_t)&message;
    read_data.BytesToRead = read_record.AddDataSize;
    read_data.Execute = true;
    ArEventLogReadAddData(&read_data);
    if (read_data.StatusID) {
        TEST_FAIL("ArEventLogReadAddData error");
        TEST_DONE;
    }

    TEST_ASSERT_EQUAL_STRING("Hello World!", message);

    TEST_DONE;
}

UNITTEST_FIXTURES(fixtures)
{
    new_TestFixture("UserLogBasic pass", test_basic_pass),
    new_TestFixture("UserLogBasic fail", test_basic_fail),
    new_TestFixture("UserLogBasic severity success",
                    test_basic_severity_success)
};

UNITTEST_CALLER_TEST (basic_set, "UserLogBasic test set", fixtures);
