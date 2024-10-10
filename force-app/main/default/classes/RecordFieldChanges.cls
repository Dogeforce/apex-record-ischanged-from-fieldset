public without sharing class RecordFieldChanges {
    /**
     * Returns a map of record ids to field changes for the given field sets.
     *
     * @param fieldSets the name of the field sets to check
     * @return a map of record ids to field changes
     */
    public static Map<Id, RecordFieldChanges.FieldChange> isAnyFieldFromFieldSetsChanged(
        List<String> fieldSets
    ) {
        return isAnyFieldFromFieldSetsChanged(
            fieldSets,
            Trigger.newMap,
            Trigger.oldMap
        );
    }

    /**
     * Returns a map of record ids to field changes for the given field sets.
     *
     * @param fieldSets the name of the field sets to check
     * @param records the new records
     * @param previousRecords the old records
     * @return a map of record ids to field changes
     */
    public static Map<Id, RecordFieldChanges.FieldChange> isAnyFieldFromFieldSetsChanged(
        List<String> fieldSets,
        Map<Id, SObject> records,
        Map<Id, SObject> previousRecords
    ) {
        if (records.getSObjectType() != previousRecords.getSObjectType()) {
            throw new UnsupportedOperationException(
                'It is not possible to compare two different SObject types.'
            );
        }

        Schema.SObjectType sot = records.getSObjectType();
        Map<Id, RecordFieldChanges.FieldChange> changes = new Map<Id, RecordFieldChanges.FieldChange>();
        Map<String, Schema.FieldSet> fieldSetsByName = sot.getDescribe()
            .fieldSets.getMap();

        for (String fsName : fieldSets) {
            if (!fieldSetsByName.containsKey(fsName) && !Test.isRunningTest()) {
                continue;
            }

            for (
                IFieldSetMember fsm : FieldSetMemberListFactory.construct(
                    fieldSetsByName.get(fsName)
                )
            ) {
                Schema.SObjectField field = fsm.getSObjectField();

                for (
                    Id recordId : getChangesOnField(
                        field,
                        records,
                        previousRecords
                    )
                ) {
                    if (!changes.containsKey(recordId)) {
                        changes.put(
                            recordId,
                            new RecordFieldChanges.FieldChange(
                                recordId,
                                records.get(recordId).get(field),
                                previousRecords.get(recordId).get(field)
                            )
                        );
                    }

                    changes.get(recordId).addField(field);
                }
            }
        }

        return changes;
    }

    private static Set<Id> getChangesOnField(
        Schema.SObjectField field,
        Map<Id, SObject> records,
        Map<Id, SObject> previousRecords
    ) {
        Set<Id> result = new Set<Id>();

        for (SObject record : records.values()) {
            if (!previousRecords.containsKey(record.Id)) {
                continue;
            }

            if (
                previousRecords.get(record.Id).get(field) != record.get(field)
            ) {
                result.add(record.Id);
            }
        }

        return result;
    }

    public class FieldChange {
        public Id recordId;
        public List<Schema.SObjectField> fields;
        public Object newValue;
        public Object previousValue;

        @SuppressWarnings('PMD.ExcessiveParameterList')
        public FieldChange(Id recordId, Object newValue, Object previousValue) {
            this.recordId = recordId;
            this.fields = new List<Schema.SObjectField>();
            this.newValue = newValue;
            this.previousValue = previousValue;
        }

        public void addField(Schema.SObjectField field) {
            this.fields.add(field);
        }

        public List<Schema.SObjectField> getFields() {
            return this.fields;
        }
    }
}
