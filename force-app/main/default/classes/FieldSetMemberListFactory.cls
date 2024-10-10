public class FieldSetMemberListFactory {
    private static List<IFieldSetMember> mockFieldSetMemberList;

    /**
     * Constructs a IFieldSetMember list based on the given field set
     **/
    public static List<IFieldSetMember> construct(Schema.FieldSet fieldSet) {
        // Return the mock response?
        if (Test.isRunningTest() && mockFieldSetMemberList != null) {
            return mockFieldSetMemberList;
        }

        // Return the actual response from an actual FieldSet resolved at runtime
        List<IFieldSetMember> fieldSetMemberList = new List<IFieldSetMember>();

        for (Schema.FieldSetMember member : fieldSet.getFields()) {
            fieldSetMemberList.add(new RuntimeContextImpl(member));
        }

        return fieldSetMemberList;
    }

    /**
     * Provides a mock response to the 'construct' method during a test context
     **/
    @TestVisible
    private static void setMock(List<SObjectField> mockFields) {
        // Mocks the list of fields via a list of SObjectField's
        mockFieldSetMemberList = new List<IFieldSetMember>();

        for (SObjectField field : mockFields) {
            mockFieldSetMemberList.add(new TestContextImpl(field));
        }
    }

    private class RuntimeContextImpl implements IFieldSetMember {
        private Schema.SObjectField field;

        public RuntimeContextImpl(Schema.FieldSetMember member) {
            this.field = member.getSObjectField();
        }

        public Schema.SObjectField getSObjectField() {
            return this.field;
        }
    }

    private class TestContextImpl implements IFieldSetMember {
        private Schema.SObjectField field;

        public TestContextImpl(Schema.SObjectField field) {
            this.field = field;
        }

        public Schema.SObjectField getSObjectField() {
            return this.field;
        }
    }
}
