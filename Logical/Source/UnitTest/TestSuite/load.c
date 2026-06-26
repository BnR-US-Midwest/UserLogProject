#include <UnitTest.h>

UNITTEST_TESTSET_DECLARATION basic_set;
UNITTEST_TESTSET_DECLARATION even_text_set;

UNITTEST_TESTSET_FIXTURES (utTestSets)
{
    new_TestSet(basic_set),
    new_TestSet(even_text_set)
};

UNTITTEST_TESTSET_HANDLER();
