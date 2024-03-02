#include <UnitTest.h>
#include <UserLog.h>
#include <stdint.h>
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

UNITTEST_FIXTURES(fixtures)
{
    new_TestFixture("UserLogBasic pass", test_basic_pass),
    new_TestFixture("UserLogBasic fail", test_basic_fail)
};

UNITTEST_CALLER_TEST (basic_set, "UserLogBasic test set", fixtures);
