@IsTest
private class FieldSetMemberListFactoryTest {
    @IsTest
    static void test() {
        // Test data setup
        FieldSetMemberListFactory.setMock(
            new List<Schema.SObjectField>{ Schema.Account.Name }
        );

        // Actual test
        Test.startTest();
        Schema.SObjectType sot = Schema.Account.SObjectType;
        Map<String, Schema.FieldSet> fieldSetsByName = sot.getDescribe()
            .fieldSets.getMap();

        List<IFieldSetMember> result = FieldSetMemberListFactory.construct(
            fieldSetsByName.get('some arbitrary fs name')
        );
        Test.stopTest();

        // Asserts
        Assert.isNotNull(result, 'Should have a result');
        Assert.areEqual(1, result.size(), 'Should have two members');
        Assert.areEqual(
            Schema.Account.Name,
            result.get(0).getSObjectField(),
            'Should have returned the account name field'
        );
    }
}
