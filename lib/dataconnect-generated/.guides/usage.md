# Basic Usage

```dart
ExampleConnector.instance.UpsertUser(upsertUserVariables).execute();
ExampleConnector.instance.RequestEmployeeAccess(requestEmployeeAccessVariables).execute();
ExampleConnector.instance.ApproveEmployeeRequest(approveEmployeeRequestVariables).execute();
ExampleConnector.instance.DeactivateAllEmployeeShifts(deactivateAllEmployeeShiftsVariables).execute();
ExampleConnector.instance.ActivateEmployeeShift(activateEmployeeShiftVariables).execute();
ExampleConnector.instance.DeactivateEmployeeShift(deactivateEmployeeShiftVariables).execute();
ExampleConnector.instance.ToggleEmployeeDisabledByOwner(toggleEmployeeDisabledByOwnerVariables).execute();
ExampleConnector.instance.RejectEmployeeRequest(rejectEmployeeRequestVariables).execute();
ExampleConnector.instance.CreateBusiness(createBusinessVariables).execute();
ExampleConnector.instance.UpdateBusiness(updateBusinessVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await ExampleConnector.instance.GetPendingPaymentProofs({ ... })
.limit(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

