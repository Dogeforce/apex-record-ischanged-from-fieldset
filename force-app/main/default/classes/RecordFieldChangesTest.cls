@IsTest
private class RecordFieldChangesTest {
    @IsTest
    static void test() {
        // Test data setup
        Account record = new Account(Name = 'Account Name');
        Account previousRecord = new Account(Name = 'Old Account Name');

        FieldSetMemberListFactory.setMock(
            new List<Schema.SObjectField>{ Schema.Account.Name }
        );

        // Actual test
        Test.startTest();
        Map<Id, RecordFieldChanges.FieldChange> result = RecordFieldChanges.isAnyFieldFromFieldSetsChanged(
            new List<String>{ 'account fieldset name' },
            new Map<Id, Account>{ null => record },
            new Map<Id, Account>{ null => previousRecord }
        );
        Test.stopTest();

        // Asserts
        Assert.isNotNull(result, 'Should have a result');
        Assert.areEqual(1, result.size(), 'Should have one item');
        Assert.isTrue(
            result.containsKey(record.Id),
            'Should contain the record\'s id'
        );
        Assert.areEqual(
            Schema.Account.Name,
            result.get(null).getFields()[0],
            'Should have returned the account name field'
        );
    }

    @IsTest
    static void testIncompatibleTypes() {
        // test
        Test.startTest();
        try {
            RecordFieldChanges.isAnyFieldFromFieldSetsChanged(
                new List<String>{ 'fs' },
                new Map<Id, Account>(),
                new Map<Id, Contact>()
            );
            Assert.fail('Should throw an exception');
        } catch (UnsupportedOperationException ex) {
            Assert.isTrue(true, 'Should throw an exception');
        }
        Test.stopTest();
    }
}
