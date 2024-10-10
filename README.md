# Apex Records "Is Changed" from Field Set

This repository contains some Apex classes that help with detecting changes in fields that are in one or more field sets.

## Usage

First deploy the classes in this repository, and then in your code you may call the `isAnyFieldFromFieldSetsChanged` methods from the `RecordFieldChanges` class.

For example:

```java
// use the field set names you want to check, and the records list and their
// previous values
RecordFieldChanges.isAnyFieldFromFieldSetsChanged(
    new List<String>{ 'some field set name' },
    new Map<Id, SObject>{ record1, record2, ... },
    new Map<Id, SObject>{ record1, record2, ... }
)

// in a trigger context, you can omit the two extra params because we'll read
// from Trigger.newMap and Trigger.oldMap
RecordFieldChanges.isAnyFieldFromFieldSetsChanged(
    'some field set name'
)
```