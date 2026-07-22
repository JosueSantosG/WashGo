# washgo SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetUsers
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getUsers().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUsersData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getUsers();
GetUsersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getUsers().ref();
ref.execute();

ref.subscribe(...);
```


### GetCurrentUser
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getCurrentUser().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetCurrentUserData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getCurrentUser();
GetCurrentUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getCurrentUser().ref();
ref.execute();

ref.subscribe(...);
```


### GetBusinessByCode
#### Required Arguments
```dart
String code = ...;
ExampleConnector.instance.getBusinessByCode(
  code: code,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetBusinessByCodeData, GetBusinessByCodeVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getBusinessByCode(
  code: code,
);
GetBusinessByCodeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String code = ...;

final ref = ExampleConnector.instance.getBusinessByCode(
  code: code,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPendingEmployeeRequests
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getPendingEmployeeRequests(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPendingEmployeeRequestsData, GetPendingEmployeeRequestsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPendingEmployeeRequests(
  businessId: businessId,
);
GetPendingEmployeeRequestsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getPendingEmployeeRequests(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetAllBusinesses
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getAllBusinesses().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAllBusinessesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getAllBusinesses();
GetAllBusinessesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getAllBusinesses().ref();
ref.execute();

ref.subscribe(...);
```


### GetClientOrders
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getClientOrders().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetClientOrdersData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getClientOrders();
GetClientOrdersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getClientOrders().ref();
ref.execute();

ref.subscribe(...);
```


### GetBusinessOrders
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getBusinessOrders(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetBusinessOrdersData, GetBusinessOrdersVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getBusinessOrders(
  businessId: businessId,
);
GetBusinessOrdersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getBusinessOrders(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetActiveEmployees
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getActiveEmployees(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetActiveEmployeesData, GetActiveEmployeesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getActiveEmployees(
  businessId: businessId,
);
GetActiveEmployeesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getActiveEmployees(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetEmployeeBranches
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getEmployeeBranches().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetEmployeeBranchesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getEmployeeBranches();
GetEmployeeBranchesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getEmployeeBranches().ref();
ref.execute();

ref.subscribe(...);
```


### GetBusinessServices
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getBusinessServices(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetBusinessServicesData, GetBusinessServicesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getBusinessServices(
  businessId: businessId,
);
GetBusinessServicesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getBusinessServices(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetMyVehicles
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getMyVehicles().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyVehiclesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMyVehicles();
GetMyVehiclesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getMyVehicles().ref();
ref.execute();

ref.subscribe(...);
```


### GetVehicleBrands
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getVehicleBrands().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetVehicleBrandsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getVehicleBrands();
GetVehicleBrandsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getVehicleBrands().ref();
ref.execute();

ref.subscribe(...);
```


### GetVehicleModelsByBrand
#### Required Arguments
```dart
String brandId = ...;
ExampleConnector.instance.getVehicleModelsByBrand(
  brandId: brandId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetVehicleModelsByBrandData, GetVehicleModelsByBrandVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getVehicleModelsByBrand(
  brandId: brandId,
);
GetVehicleModelsByBrandData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String brandId = ...;

final ref = ExampleConnector.instance.getVehicleModelsByBrand(
  brandId: brandId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetActiveBusinessOrders
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getActiveBusinessOrders(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetActiveBusinessOrdersData, GetActiveBusinessOrdersVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getActiveBusinessOrders(
  businessId: businessId,
);
GetActiveBusinessOrdersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getActiveBusinessOrders(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetEmployeeAvailability
#### Required Arguments
```dart
String businessId = ...;
String employeeId = ...;
ExampleConnector.instance.getEmployeeAvailability(
  businessId: businessId,
  employeeId: employeeId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetEmployeeAvailabilityData, GetEmployeeAvailabilityVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getEmployeeAvailability(
  businessId: businessId,
  employeeId: employeeId,
);
GetEmployeeAvailabilityData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String employeeId = ...;

final ref = ExampleConnector.instance.getEmployeeAvailability(
  businessId: businessId,
  employeeId: employeeId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetBusinessHours
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getBusinessHours(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetBusinessHoursData, GetBusinessHoursVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getBusinessHours(
  businessId: businessId,
);
GetBusinessHoursData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getBusinessHours(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### SuperAdminGetBusinesses
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.superAdminGetBusinesses().execute();
```



#### Return Type
`execute()` returns a `QueryResult<SuperAdminGetBusinessesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.superAdminGetBusinesses();
SuperAdminGetBusinessesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.superAdminGetBusinesses().ref();
ref.execute();

ref.subscribe(...);
```


### GetMyBusinesses
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getMyBusinesses().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyBusinessesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMyBusinesses();
GetMyBusinessesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getMyBusinesses().ref();
ref.execute();

ref.subscribe(...);
```


### GetEmployeeHistoryOrdersPaged
#### Required Arguments
```dart
String businessId = ...;
String employeeId = ...;
int limit = ...;
int offset = ...;
ExampleConnector.instance.getEmployeeHistoryOrdersPaged(
  businessId: businessId,
  employeeId: employeeId,
  limit: limit,
  offset: offset,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetEmployeeHistoryOrdersPagedData, GetEmployeeHistoryOrdersPagedVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getEmployeeHistoryOrdersPaged(
  businessId: businessId,
  employeeId: employeeId,
  limit: limit,
  offset: offset,
);
GetEmployeeHistoryOrdersPagedData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String employeeId = ...;
int limit = ...;
int offset = ...;

final ref = ExampleConnector.instance.getEmployeeHistoryOrdersPaged(
  businessId: businessId,
  employeeId: employeeId,
  limit: limit,
  offset: offset,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetClientHistoryOrdersPaged
#### Required Arguments
```dart
int limit = ...;
int offset = ...;
ExampleConnector.instance.getClientHistoryOrdersPaged(
  limit: limit,
  offset: offset,
).execute();
```

#### Optional Arguments
We return a builder for each query. For GetClientHistoryOrdersPaged, we created `GetClientHistoryOrdersPagedBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class GetClientHistoryOrdersPagedVariablesBuilder {
  ...
   GetClientHistoryOrdersPagedVariablesBuilder statuses(List<OrderStatus>? t) {
   _statuses.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.getClientHistoryOrdersPaged(
  limit: limit,
  offset: offset,
)
.statuses(statuses)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<GetClientHistoryOrdersPagedData, GetClientHistoryOrdersPagedVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getClientHistoryOrdersPaged(
  limit: limit,
  offset: offset,
);
GetClientHistoryOrdersPagedData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
int limit = ...;
int offset = ...;

final ref = ExampleConnector.instance.getClientHistoryOrdersPaged(
  limit: limit,
  offset: offset,
).ref();
ref.execute();

ref.subscribe(...);
```


### FindUserByPhone
#### Required Arguments
```dart
String phone = ...;
ExampleConnector.instance.findUserByPhone(
  phone: phone,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<FindUserByPhoneData, FindUserByPhoneVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.findUserByPhone(
  phone: phone,
);
FindUserByPhoneData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String phone = ...;

final ref = ExampleConnector.instance.findUserByPhone(
  phone: phone,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetClientInvoices
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getClientInvoices().execute();
```

#### Optional Arguments
We return a builder for each query. For GetClientInvoices, we created `GetClientInvoicesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class GetClientInvoicesVariablesBuilder {
  ...
 
  GetClientInvoicesVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder offset(int? t) {
   _offset.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder startDate(Timestamp? t) {
   _startDate.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder endDate(Timestamp? t) {
   _endDate.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder paymentMethod(PaymentMethod? t) {
   _paymentMethod.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder status(InvoiceStatus? t) {
   _status.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder searchQuery(String? t) {
   _searchQuery.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.getClientInvoices()
.limit(limit)
.offset(offset)
.startDate(startDate)
.endDate(endDate)
.paymentMethod(paymentMethod)
.status(status)
.searchQuery(searchQuery)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<GetClientInvoicesData, GetClientInvoicesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getClientInvoices();
GetClientInvoicesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getClientInvoices().ref();
ref.execute();

ref.subscribe(...);
```


### GetEmployeeInvoices
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getEmployeeInvoices().execute();
```

#### Optional Arguments
We return a builder for each query. For GetEmployeeInvoices, we created `GetEmployeeInvoicesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class GetEmployeeInvoicesVariablesBuilder {
  ...
 
  GetEmployeeInvoicesVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }
  GetEmployeeInvoicesVariablesBuilder offset(int? t) {
   _offset.value = t;
   return this;
  }
  GetEmployeeInvoicesVariablesBuilder startDate(Timestamp? t) {
   _startDate.value = t;
   return this;
  }
  GetEmployeeInvoicesVariablesBuilder endDate(Timestamp? t) {
   _endDate.value = t;
   return this;
  }
  GetEmployeeInvoicesVariablesBuilder paymentMethod(PaymentMethod? t) {
   _paymentMethod.value = t;
   return this;
  }
  GetEmployeeInvoicesVariablesBuilder status(InvoiceStatus? t) {
   _status.value = t;
   return this;
  }
  GetEmployeeInvoicesVariablesBuilder searchQuery(String? t) {
   _searchQuery.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.getEmployeeInvoices()
.limit(limit)
.offset(offset)
.startDate(startDate)
.endDate(endDate)
.paymentMethod(paymentMethod)
.status(status)
.searchQuery(searchQuery)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<GetEmployeeInvoicesData, GetEmployeeInvoicesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getEmployeeInvoices();
GetEmployeeInvoicesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getEmployeeInvoices().ref();
ref.execute();

ref.subscribe(...);
```


### GetBusinessInvoices
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getBusinessInvoices(
  businessId: businessId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For GetBusinessInvoices, we created `GetBusinessInvoicesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class GetBusinessInvoicesVariablesBuilder {
  ...
   GetBusinessInvoicesVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }
  GetBusinessInvoicesVariablesBuilder offset(int? t) {
   _offset.value = t;
   return this;
  }
  GetBusinessInvoicesVariablesBuilder employeeId(String? t) {
   _employeeId.value = t;
   return this;
  }
  GetBusinessInvoicesVariablesBuilder startDate(Timestamp? t) {
   _startDate.value = t;
   return this;
  }
  GetBusinessInvoicesVariablesBuilder endDate(Timestamp? t) {
   _endDate.value = t;
   return this;
  }
  GetBusinessInvoicesVariablesBuilder paymentMethod(PaymentMethod? t) {
   _paymentMethod.value = t;
   return this;
  }
  GetBusinessInvoicesVariablesBuilder status(InvoiceStatus? t) {
   _status.value = t;
   return this;
  }
  GetBusinessInvoicesVariablesBuilder searchQuery(String? t) {
   _searchQuery.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.getBusinessInvoices(
  businessId: businessId,
)
.limit(limit)
.offset(offset)
.employeeId(employeeId)
.startDate(startDate)
.endDate(endDate)
.paymentMethod(paymentMethod)
.status(status)
.searchQuery(searchQuery)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<GetBusinessInvoicesData, GetBusinessInvoicesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getBusinessInvoices(
  businessId: businessId,
);
GetBusinessInvoicesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getBusinessInvoices(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetInvoiceById
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getInvoiceById(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetInvoiceByIdData, GetInvoiceByIdVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getInvoiceById(
  id: id,
);
GetInvoiceByIdData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getInvoiceById(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetInvoiceByIdAdmin
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getInvoiceByIdAdmin(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetInvoiceByIdAdminData, GetInvoiceByIdAdminVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getInvoiceByIdAdmin(
  id: id,
);
GetInvoiceByIdAdminData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getInvoiceByIdAdmin(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetInvoicesByDateRange
#### Required Arguments
```dart
String businessId = ...;
Timestamp startDate = ...;
Timestamp endDate = ...;
ExampleConnector.instance.getInvoicesByDateRange(
  businessId: businessId,
  startDate: startDate,
  endDate: endDate,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetInvoicesByDateRangeData, GetInvoicesByDateRangeVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getInvoicesByDateRange(
  businessId: businessId,
  startDate: startDate,
  endDate: endDate,
);
GetInvoicesByDateRangeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
Timestamp startDate = ...;
Timestamp endDate = ...;

final ref = ExampleConnector.instance.getInvoicesByDateRange(
  businessId: businessId,
  startDate: startDate,
  endDate: endDate,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetBusinessDetails
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getBusinessDetails(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetBusinessDetailsData, GetBusinessDetailsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getBusinessDetails(
  id: id,
);
GetBusinessDetailsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getBusinessDetails(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetUserNotifications
#### Required Arguments
```dart
String userId = ...;
ExampleConnector.instance.getUserNotifications(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserNotificationsData, GetUserNotificationsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getUserNotifications(
  userId: userId,
);
GetUserNotificationsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = ExampleConnector.instance.getUserNotifications(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPrepaidHistory
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getPrepaidHistory(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPrepaidHistoryData, GetPrepaidHistoryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPrepaidHistory(
  businessId: businessId,
);
GetPrepaidHistoryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getPrepaidHistory(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPrepaidServiceMetrics
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getPrepaidServiceMetrics(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPrepaidServiceMetricsData, GetPrepaidServiceMetricsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPrepaidServiceMetrics(
  businessId: businessId,
);
GetPrepaidServiceMetricsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getPrepaidServiceMetrics(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPrepaidServiceMetricByServiceName
#### Required Arguments
```dart
String businessId = ...;
String serviceName = ...;
ExampleConnector.instance.getPrepaidServiceMetricByServiceName(
  businessId: businessId,
  serviceName: serviceName,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPrepaidServiceMetricByServiceNameData, GetPrepaidServiceMetricByServiceNameVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPrepaidServiceMetricByServiceName(
  businessId: businessId,
  serviceName: serviceName,
);
GetPrepaidServiceMetricByServiceNameData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String serviceName = ...;

final ref = ExampleConnector.instance.getPrepaidServiceMetricByServiceName(
  businessId: businessId,
  serviceName: serviceName,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetOrderById
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getOrderById(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetOrderByIdData, GetOrderByIdVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getOrderById(
  id: id,
);
GetOrderByIdData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getOrderById(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ServerGetOrderById
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.serverGetOrderById(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ServerGetOrderByIdData, ServerGetOrderByIdVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.serverGetOrderById(
  id: id,
);
ServerGetOrderByIdData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.serverGetOrderById(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPrepaidHistoryByOrderId
#### Required Arguments
```dart
String orderId = ...;
ExampleConnector.instance.getPrepaidHistoryByOrderId(
  orderId: orderId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPrepaidHistoryByOrderIdData, GetPrepaidHistoryByOrderIdVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPrepaidHistoryByOrderId(
  orderId: orderId,
);
GetPrepaidHistoryByOrderIdData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;

final ref = ExampleConnector.instance.getPrepaidHistoryByOrderId(
  orderId: orderId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetBusinessReservationConfig
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getBusinessReservationConfig(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetBusinessReservationConfigData, GetBusinessReservationConfigVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getBusinessReservationConfig(
  businessId: businessId,
);
GetBusinessReservationConfigData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getBusinessReservationConfig(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetActiveReservations
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getActiveReservations(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetActiveReservationsData, GetActiveReservationsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getActiveReservations(
  businessId: businessId,
);
GetActiveReservationsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getActiveReservations(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetReservationByOrderId
#### Required Arguments
```dart
String orderId = ...;
ExampleConnector.instance.getReservationByOrderId(
  orderId: orderId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetReservationByOrderIdData, GetReservationByOrderIdVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getReservationByOrderId(
  orderId: orderId,
);
GetReservationByOrderIdData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;

final ref = ExampleConnector.instance.getReservationByOrderId(
  orderId: orderId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetBusinessReviews
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getBusinessReviews(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetBusinessReviewsData, GetBusinessReviewsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getBusinessReviews(
  businessId: businessId,
);
GetBusinessReviewsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getBusinessReviews(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetOrderReview
#### Required Arguments
```dart
String orderId = ...;
ExampleConnector.instance.getOrderReview(
  orderId: orderId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetOrderReviewData, GetOrderReviewVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getOrderReview(
  orderId: orderId,
);
GetOrderReviewData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;

final ref = ExampleConnector.instance.getOrderReview(
  orderId: orderId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetGlobalAppRatings
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getGlobalAppRatings().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetGlobalAppRatingsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getGlobalAppRatings();
GetGlobalAppRatingsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getGlobalAppRatings().ref();
ref.execute();

ref.subscribe(...);
```


### GetOrderDetailsForPayment
#### Required Arguments
```dart
String orderId = ...;
ExampleConnector.instance.getOrderDetailsForPayment(
  orderId: orderId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetOrderDetailsForPaymentData, GetOrderDetailsForPaymentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getOrderDetailsForPayment(
  orderId: orderId,
);
GetOrderDetailsForPaymentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;

final ref = ExampleConnector.instance.getOrderDetailsForPayment(
  orderId: orderId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetInvoiceByOrderId
#### Required Arguments
```dart
String orderId = ...;
ExampleConnector.instance.getInvoiceByOrderId(
  orderId: orderId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetInvoiceByOrderIdData, GetInvoiceByOrderIdVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getInvoiceByOrderId(
  orderId: orderId,
);
GetInvoiceByOrderIdData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;

final ref = ExampleConnector.instance.getInvoiceByOrderId(
  orderId: orderId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetInvoiceDetailsForUrl
#### Required Arguments
```dart
String invoiceId = ...;
ExampleConnector.instance.getInvoiceDetailsForUrl(
  invoiceId: invoiceId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetInvoiceDetailsForUrlData, GetInvoiceDetailsForUrlVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getInvoiceDetailsForUrl(
  invoiceId: invoiceId,
);
GetInvoiceDetailsForUrlData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String invoiceId = ...;

final ref = ExampleConnector.instance.getInvoiceDetailsForUrl(
  invoiceId: invoiceId,
).ref();
ref.execute();

ref.subscribe(...);
```


### CheckBusinessEmployeeAdmin
#### Required Arguments
```dart
String businessId = ...;
String employeeId = ...;
ExampleConnector.instance.checkBusinessEmployeeAdmin(
  businessId: businessId,
  employeeId: employeeId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<CheckBusinessEmployeeAdminData, CheckBusinessEmployeeAdminVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.checkBusinessEmployeeAdmin(
  businessId: businessId,
  employeeId: employeeId,
);
CheckBusinessEmployeeAdminData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String employeeId = ...;

final ref = ExampleConnector.instance.checkBusinessEmployeeAdmin(
  businessId: businessId,
  employeeId: employeeId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPaymentProof
#### Required Arguments
```dart
String orderId = ...;
ExampleConnector.instance.getPaymentProof(
  orderId: orderId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPaymentProofData, GetPaymentProofVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPaymentProof(
  orderId: orderId,
);
GetPaymentProofData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;

final ref = ExampleConnector.instance.getPaymentProof(
  orderId: orderId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPendingTransferOrders
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getPendingTransferOrders(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPendingTransferOrdersData, GetPendingTransferOrdersVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPendingTransferOrders(
  businessId: businessId,
);
GetPendingTransferOrdersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getPendingTransferOrders(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetTransferPaymentStats
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.getTransferPaymentStats(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetTransferPaymentStatsData, GetTransferPaymentStatsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getTransferPaymentStats(
  businessId: businessId,
);
GetTransferPaymentStatsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.getTransferPaymentStats(
  businessId: businessId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetExpiredPendingTransferOrders
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getExpiredPendingTransferOrders().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetExpiredPendingTransferOrdersData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getExpiredPendingTransferOrders();
GetExpiredPendingTransferOrdersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getExpiredPendingTransferOrders().ref();
ref.execute();

ref.subscribe(...);
```


### GetPendingPaymentProofs
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getPendingPaymentProofs().execute();
```

#### Optional Arguments
We return a builder for each query. For GetPendingPaymentProofs, we created `GetPendingPaymentProofsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class GetPendingPaymentProofsVariablesBuilder {
  ...
 
  GetPendingPaymentProofsVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }
  GetPendingPaymentProofsVariablesBuilder offset(int? t) {
   _offset.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.getPendingPaymentProofs()
.limit(limit)
.offset(offset)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<GetPendingPaymentProofsData, GetPendingPaymentProofsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPendingPaymentProofs();
GetPendingPaymentProofsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getPendingPaymentProofs().ref();
ref.execute();

ref.subscribe(...);
```


### GetOrderLogs
#### Required Arguments
```dart
String orderId = ...;
ExampleConnector.instance.getOrderLogs(
  orderId: orderId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetOrderLogsData, GetOrderLogsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getOrderLogs(
  orderId: orderId,
);
GetOrderLogsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;

final ref = ExampleConnector.instance.getOrderLogs(
  orderId: orderId,
).ref();
ref.execute();

ref.subscribe(...);
```


### SuperAdminGetCompletedOrders
#### Required Arguments
```dart
Timestamp startOfMonth = ...;
Timestamp endOfMonth = ...;
ExampleConnector.instance.superAdminGetCompletedOrders(
  startOfMonth: startOfMonth,
  endOfMonth: endOfMonth,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<SuperAdminGetCompletedOrdersData, SuperAdminGetCompletedOrdersVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.superAdminGetCompletedOrders(
  startOfMonth: startOfMonth,
  endOfMonth: endOfMonth,
);
SuperAdminGetCompletedOrdersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
Timestamp startOfMonth = ...;
Timestamp endOfMonth = ...;

final ref = ExampleConnector.instance.superAdminGetCompletedOrders(
  startOfMonth: startOfMonth,
  endOfMonth: endOfMonth,
).ref();
ref.execute();

ref.subscribe(...);
```


### SuperAdminGetCancelledPaidOrders
#### Required Arguments
```dart
Timestamp startOfMonth = ...;
Timestamp endOfMonth = ...;
ExampleConnector.instance.superAdminGetCancelledPaidOrders(
  startOfMonth: startOfMonth,
  endOfMonth: endOfMonth,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<SuperAdminGetCancelledPaidOrdersData, SuperAdminGetCancelledPaidOrdersVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.superAdminGetCancelledPaidOrders(
  startOfMonth: startOfMonth,
  endOfMonth: endOfMonth,
);
SuperAdminGetCancelledPaidOrdersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
Timestamp startOfMonth = ...;
Timestamp endOfMonth = ...;

final ref = ExampleConnector.instance.superAdminGetCancelledPaidOrders(
  startOfMonth: startOfMonth,
  endOfMonth: endOfMonth,
).ref();
ref.execute();

ref.subscribe(...);
```


### SuperAdminGetCancelledOrdersSummary
#### Required Arguments
```dart
Timestamp startOfMonth = ...;
Timestamp endOfMonth = ...;
ExampleConnector.instance.superAdminGetCancelledOrdersSummary(
  startOfMonth: startOfMonth,
  endOfMonth: endOfMonth,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<SuperAdminGetCancelledOrdersSummaryData, SuperAdminGetCancelledOrdersSummaryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.superAdminGetCancelledOrdersSummary(
  startOfMonth: startOfMonth,
  endOfMonth: endOfMonth,
);
SuperAdminGetCancelledOrdersSummaryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
Timestamp startOfMonth = ...;
Timestamp endOfMonth = ...;

final ref = ExampleConnector.instance.superAdminGetCancelledOrdersSummary(
  startOfMonth: startOfMonth,
  endOfMonth: endOfMonth,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPendingElectronicOrders
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getPendingElectronicOrders().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPendingElectronicOrdersData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPendingElectronicOrders();
GetPendingElectronicOrdersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getPendingElectronicOrders().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### UpsertUser
#### Required Arguments
```dart
String email = ...;
String nombreCompleto = ...;
UserRole roles = ...;
ExampleConnector.instance.upsertUser(
  email: email,
  nombreCompleto: nombreCompleto,
  roles: roles,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertUser, we created `UpsertUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertUserVariablesBuilder {
  ...
   UpsertUserVariablesBuilder employeeStatus(EmployeeStatus? t) {
   _employeeStatus.value = t;
   return this;
  }
  UpsertUserVariablesBuilder telefono(String? t) {
   _telefono.value = t;
   return this;
  }
  UpsertUserVariablesBuilder fotoPerfil(String? t) {
   _fotoPerfil.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertUser(
  email: email,
  nombreCompleto: nombreCompleto,
  roles: roles,
)
.employeeStatus(employeeStatus)
.telefono(telefono)
.fotoPerfil(fotoPerfil)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertUserData, UpsertUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertUser(
  email: email,
  nombreCompleto: nombreCompleto,
  roles: roles,
);
UpsertUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String email = ...;
String nombreCompleto = ...;
UserRole roles = ...;

final ref = ExampleConnector.instance.upsertUser(
  email: email,
  nombreCompleto: nombreCompleto,
  roles: roles,
).ref();
ref.execute();
```


### RequestEmployeeAccess
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.requestEmployeeAccess(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RequestEmployeeAccessData, RequestEmployeeAccessVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.requestEmployeeAccess(
  businessId: businessId,
);
RequestEmployeeAccessData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.requestEmployeeAccess(
  businessId: businessId,
).ref();
ref.execute();
```


### ApproveEmployeeRequest
#### Required Arguments
```dart
String requestId = ...;
String employeeId = ...;
String businessId = ...;
ExampleConnector.instance.approveEmployeeRequest(
  requestId: requestId,
  employeeId: employeeId,
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ApproveEmployeeRequestData, ApproveEmployeeRequestVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.approveEmployeeRequest(
  requestId: requestId,
  employeeId: employeeId,
  businessId: businessId,
);
ApproveEmployeeRequestData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String requestId = ...;
String employeeId = ...;
String businessId = ...;

final ref = ExampleConnector.instance.approveEmployeeRequest(
  requestId: requestId,
  employeeId: employeeId,
  businessId: businessId,
).ref();
ref.execute();
```


### DeactivateAllEmployeeShifts
#### Required Arguments
```dart
String employeeId = ...;
ExampleConnector.instance.deactivateAllEmployeeShifts(
  employeeId: employeeId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeactivateAllEmployeeShiftsData, DeactivateAllEmployeeShiftsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deactivateAllEmployeeShifts(
  employeeId: employeeId,
);
DeactivateAllEmployeeShiftsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String employeeId = ...;

final ref = ExampleConnector.instance.deactivateAllEmployeeShifts(
  employeeId: employeeId,
).ref();
ref.execute();
```


### ActivateEmployeeShift
#### Required Arguments
```dart
String businessId = ...;
String employeeId = ...;
ExampleConnector.instance.activateEmployeeShift(
  businessId: businessId,
  employeeId: employeeId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ActivateEmployeeShiftData, ActivateEmployeeShiftVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.activateEmployeeShift(
  businessId: businessId,
  employeeId: employeeId,
);
ActivateEmployeeShiftData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String employeeId = ...;

final ref = ExampleConnector.instance.activateEmployeeShift(
  businessId: businessId,
  employeeId: employeeId,
).ref();
ref.execute();
```


### DeactivateEmployeeShift
#### Required Arguments
```dart
String businessId = ...;
String employeeId = ...;
ExampleConnector.instance.deactivateEmployeeShift(
  businessId: businessId,
  employeeId: employeeId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeactivateEmployeeShiftData, DeactivateEmployeeShiftVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deactivateEmployeeShift(
  businessId: businessId,
  employeeId: employeeId,
);
DeactivateEmployeeShiftData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String employeeId = ...;

final ref = ExampleConnector.instance.deactivateEmployeeShift(
  businessId: businessId,
  employeeId: employeeId,
).ref();
ref.execute();
```


### ToggleEmployeeDisabledByOwner
#### Required Arguments
```dart
String businessId = ...;
String employeeId = ...;
bool isDisabled = ...;
ExampleConnector.instance.toggleEmployeeDisabledByOwner(
  businessId: businessId,
  employeeId: employeeId,
  isDisabled: isDisabled,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ToggleEmployeeDisabledByOwnerData, ToggleEmployeeDisabledByOwnerVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.toggleEmployeeDisabledByOwner(
  businessId: businessId,
  employeeId: employeeId,
  isDisabled: isDisabled,
);
ToggleEmployeeDisabledByOwnerData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String employeeId = ...;
bool isDisabled = ...;

final ref = ExampleConnector.instance.toggleEmployeeDisabledByOwner(
  businessId: businessId,
  employeeId: employeeId,
  isDisabled: isDisabled,
).ref();
ref.execute();
```


### RejectEmployeeRequest
#### Required Arguments
```dart
String requestId = ...;
String employeeId = ...;
ExampleConnector.instance.rejectEmployeeRequest(
  requestId: requestId,
  employeeId: employeeId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RejectEmployeeRequestData, RejectEmployeeRequestVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.rejectEmployeeRequest(
  requestId: requestId,
  employeeId: employeeId,
);
RejectEmployeeRequestData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String requestId = ...;
String employeeId = ...;

final ref = ExampleConnector.instance.rejectEmployeeRequest(
  requestId: requestId,
  employeeId: employeeId,
).ref();
ref.execute();
```


### CreateBusiness
#### Required Arguments
```dart
String id = ...;
String nombre = ...;
String ruc = ...;
String businessCode = ...;
ExampleConnector.instance.createBusiness(
  id: id,
  nombre: nombre,
  ruc: ruc,
  businessCode: businessCode,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateBusiness, we created `CreateBusinessBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateBusinessVariablesBuilder {
  ...
   CreateBusinessVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }
  CreateBusinessVariablesBuilder telefono(String? t) {
   _telefono.value = t;
   return this;
  }
  CreateBusinessVariablesBuilder latitud(double? t) {
   _latitud.value = t;
   return this;
  }
  CreateBusinessVariablesBuilder longitud(double? t) {
   _longitud.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createBusiness(
  id: id,
  nombre: nombre,
  ruc: ruc,
  businessCode: businessCode,
)
.descripcion(descripcion)
.telefono(telefono)
.latitud(latitud)
.longitud(longitud)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateBusinessData, CreateBusinessVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createBusiness(
  id: id,
  nombre: nombre,
  ruc: ruc,
  businessCode: businessCode,
);
CreateBusinessData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nombre = ...;
String ruc = ...;
String businessCode = ...;

final ref = ExampleConnector.instance.createBusiness(
  id: id,
  nombre: nombre,
  ruc: ruc,
  businessCode: businessCode,
).ref();
ref.execute();
```


### UpdateBusiness
#### Required Arguments
```dart
String id = ...;
String nombre = ...;
String ruc = ...;
ExampleConnector.instance.updateBusiness(
  id: id,
  nombre: nombre,
  ruc: ruc,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateBusiness, we created `UpdateBusinessBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateBusinessVariablesBuilder {
  ...
   UpdateBusinessVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }
  UpdateBusinessVariablesBuilder telefono(String? t) {
   _telefono.value = t;
   return this;
  }
  UpdateBusinessVariablesBuilder latitud(double? t) {
   _latitud.value = t;
   return this;
  }
  UpdateBusinessVariablesBuilder longitud(double? t) {
   _longitud.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateBusiness(
  id: id,
  nombre: nombre,
  ruc: ruc,
)
.descripcion(descripcion)
.telefono(telefono)
.latitud(latitud)
.longitud(longitud)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateBusinessData, UpdateBusinessVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateBusiness(
  id: id,
  nombre: nombre,
  ruc: ruc,
);
UpdateBusinessData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nombre = ...;
String ruc = ...;

final ref = ExampleConnector.instance.updateBusiness(
  id: id,
  nombre: nombre,
  ruc: ruc,
).ref();
ref.execute();
```


### OwnerUpdateBusinessStatus
#### Required Arguments
```dart
String id = ...;
BusinessStatus status = ...;
ExampleConnector.instance.ownerUpdateBusinessStatus(
  id: id,
  status: status,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<OwnerUpdateBusinessStatusData, OwnerUpdateBusinessStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.ownerUpdateBusinessStatus(
  id: id,
  status: status,
);
OwnerUpdateBusinessStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
BusinessStatus status = ...;

final ref = ExampleConnector.instance.ownerUpdateBusinessStatus(
  id: id,
  status: status,
).ref();
ref.execute();
```


### CreateOrder
#### Required Arguments
```dart
String businessId = ...;
double price = ...;
double costo = ...;
String serviceName = ...;
OrderType type = ...;
PaymentMethod paymentMethod = ...;
ExampleConnector.instance.createOrder(
  businessId: businessId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateOrder, we created `CreateOrderBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateOrderVariablesBuilder {
  ...
   CreateOrderVariablesBuilder status(OrderStatus t) {
   _status.value = t;
   return this;
  }
  CreateOrderVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createOrder(
  businessId: businessId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
)
.status(status)
.observations(observations)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateOrderData, CreateOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createOrder(
  businessId: businessId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
);
CreateOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
double price = ...;
double costo = ...;
String serviceName = ...;
OrderType type = ...;
PaymentMethod paymentMethod = ...;

final ref = ExampleConnector.instance.createOrder(
  businessId: businessId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
).ref();
ref.execute();
```


### AcceptOrder
#### Required Arguments
```dart
String orderId = ...;
String employeeId = ...;
ExampleConnector.instance.acceptOrder(
  orderId: orderId,
  employeeId: employeeId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AcceptOrderData, AcceptOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.acceptOrder(
  orderId: orderId,
  employeeId: employeeId,
);
AcceptOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String employeeId = ...;

final ref = ExampleConnector.instance.acceptOrder(
  orderId: orderId,
  employeeId: employeeId,
).ref();
ref.execute();
```


### UpdateOrderStatus
#### Required Arguments
```dart
String orderId = ...;
OrderStatus status = ...;
ExampleConnector.instance.updateOrderStatus(
  orderId: orderId,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateOrderStatus, we created `UpdateOrderStatusBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateOrderStatusVariablesBuilder {
  ...
   UpdateOrderStatusVariablesBuilder cancellationReason(String? t) {
   _cancellationReason.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateOrderStatus(
  orderId: orderId,
  status: status,
)
.cancellationReason(cancellationReason)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateOrderStatusData, UpdateOrderStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateOrderStatus(
  orderId: orderId,
  status: status,
);
UpdateOrderStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
OrderStatus status = ...;

final ref = ExampleConnector.instance.updateOrderStatus(
  orderId: orderId,
  status: status,
).ref();
ref.execute();
```


### UpdateOrderPaymentMethodAndStatus
#### Required Arguments
```dart
String orderId = ...;
PaymentMethod paymentMethod = ...;
OrderStatus status = ...;
ExampleConnector.instance.updateOrderPaymentMethodAndStatus(
  orderId: orderId,
  paymentMethod: paymentMethod,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateOrderPaymentMethodAndStatus, we created `UpdateOrderPaymentMethodAndStatusBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateOrderPaymentMethodAndStatusVariablesBuilder {
  ...
   UpdateOrderPaymentMethodAndStatusVariablesBuilder cancellationReason(String? t) {
   _cancellationReason.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateOrderPaymentMethodAndStatus(
  orderId: orderId,
  paymentMethod: paymentMethod,
  status: status,
)
.cancellationReason(cancellationReason)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateOrderPaymentMethodAndStatusData, UpdateOrderPaymentMethodAndStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateOrderPaymentMethodAndStatus(
  orderId: orderId,
  paymentMethod: paymentMethod,
  status: status,
);
UpdateOrderPaymentMethodAndStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
PaymentMethod paymentMethod = ...;
OrderStatus status = ...;

final ref = ExampleConnector.instance.updateOrderPaymentMethodAndStatus(
  orderId: orderId,
  paymentMethod: paymentMethod,
  status: status,
).ref();
ref.execute();
```


### RescheduleOrder
#### Required Arguments
```dart
String orderId = ...;
String observations = ...;
ExampleConnector.instance.rescheduleOrder(
  orderId: orderId,
  observations: observations,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RescheduleOrderData, RescheduleOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.rescheduleOrder(
  orderId: orderId,
  observations: observations,
);
RescheduleOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String observations = ...;

final ref = ExampleConnector.instance.rescheduleOrder(
  orderId: orderId,
  observations: observations,
).ref();
ref.execute();
```


### CreateService
#### Required Arguments
```dart
String businessId = ...;
String nombre = ...;
double precioPequeno = ...;
double precioMediano = ...;
double precioGrande = ...;
double precioMoto = ...;
int duracionMinutos = ...;
ServiceType tipo = ...;
ExampleConnector.instance.createService(
  businessId: businessId,
  nombre: nombre,
  precioPequeno: precioPequeno,
  precioMediano: precioMediano,
  precioGrande: precioGrande,
  precioMoto: precioMoto,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateService, we created `CreateServiceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateServiceVariablesBuilder {
  ...
   CreateServiceVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createService(
  businessId: businessId,
  nombre: nombre,
  precioPequeno: precioPequeno,
  precioMediano: precioMediano,
  precioGrande: precioGrande,
  precioMoto: precioMoto,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
)
.descripcion(descripcion)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateServiceData, CreateServiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createService(
  businessId: businessId,
  nombre: nombre,
  precioPequeno: precioPequeno,
  precioMediano: precioMediano,
  precioGrande: precioGrande,
  precioMoto: precioMoto,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
);
CreateServiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String nombre = ...;
double precioPequeno = ...;
double precioMediano = ...;
double precioGrande = ...;
double precioMoto = ...;
int duracionMinutos = ...;
ServiceType tipo = ...;

final ref = ExampleConnector.instance.createService(
  businessId: businessId,
  nombre: nombre,
  precioPequeno: precioPequeno,
  precioMediano: precioMediano,
  precioGrande: precioGrande,
  precioMoto: precioMoto,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
).ref();
ref.execute();
```


### UpdateService
#### Required Arguments
```dart
String id = ...;
String nombre = ...;
double precioPequeno = ...;
double precioMediano = ...;
double precioGrande = ...;
double precioMoto = ...;
int duracionMinutos = ...;
ServiceType tipo = ...;
ExampleConnector.instance.updateService(
  id: id,
  nombre: nombre,
  precioPequeno: precioPequeno,
  precioMediano: precioMediano,
  precioGrande: precioGrande,
  precioMoto: precioMoto,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateService, we created `UpdateServiceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateServiceVariablesBuilder {
  ...
   UpdateServiceVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateService(
  id: id,
  nombre: nombre,
  precioPequeno: precioPequeno,
  precioMediano: precioMediano,
  precioGrande: precioGrande,
  precioMoto: precioMoto,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
)
.descripcion(descripcion)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateServiceData, UpdateServiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateService(
  id: id,
  nombre: nombre,
  precioPequeno: precioPequeno,
  precioMediano: precioMediano,
  precioGrande: precioGrande,
  precioMoto: precioMoto,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
);
UpdateServiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nombre = ...;
double precioPequeno = ...;
double precioMediano = ...;
double precioGrande = ...;
double precioMoto = ...;
int duracionMinutos = ...;
ServiceType tipo = ...;

final ref = ExampleConnector.instance.updateService(
  id: id,
  nombre: nombre,
  precioPequeno: precioPequeno,
  precioMediano: precioMediano,
  precioGrande: precioGrande,
  precioMoto: precioMoto,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
).ref();
ref.execute();
```


### UpdateServiceDetails
#### Required Arguments
```dart
String id = ...;
String nombre = ...;
int duracionMinutos = ...;
ServiceType tipo = ...;
ExampleConnector.instance.updateServiceDetails(
  id: id,
  nombre: nombre,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateServiceDetails, we created `UpdateServiceDetailsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateServiceDetailsVariablesBuilder {
  ...
   UpdateServiceDetailsVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateServiceDetails(
  id: id,
  nombre: nombre,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
)
.descripcion(descripcion)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateServiceDetailsData, UpdateServiceDetailsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateServiceDetails(
  id: id,
  nombre: nombre,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
);
UpdateServiceDetailsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nombre = ...;
int duracionMinutos = ...;
ServiceType tipo = ...;

final ref = ExampleConnector.instance.updateServiceDetails(
  id: id,
  nombre: nombre,
  duracionMinutos: duracionMinutos,
  tipo: tipo,
).ref();
ref.execute();
```


### SuperAdminApproveServicePrice
#### Required Arguments
```dart
String id = ...;
double precioAprobadoPequeno = ...;
double precioAprobadoMediano = ...;
double precioAprobadoGrande = ...;
double precioAprobadoMoto = ...;
ExampleConnector.instance.superAdminApproveServicePrice(
  id: id,
  precioAprobadoPequeno: precioAprobadoPequeno,
  precioAprobadoMediano: precioAprobadoMediano,
  precioAprobadoGrande: precioAprobadoGrande,
  precioAprobadoMoto: precioAprobadoMoto,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SuperAdminApproveServicePriceData, SuperAdminApproveServicePriceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.superAdminApproveServicePrice(
  id: id,
  precioAprobadoPequeno: precioAprobadoPequeno,
  precioAprobadoMediano: precioAprobadoMediano,
  precioAprobadoGrande: precioAprobadoGrande,
  precioAprobadoMoto: precioAprobadoMoto,
);
SuperAdminApproveServicePriceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
double precioAprobadoPequeno = ...;
double precioAprobadoMediano = ...;
double precioAprobadoGrande = ...;
double precioAprobadoMoto = ...;

final ref = ExampleConnector.instance.superAdminApproveServicePrice(
  id: id,
  precioAprobadoPequeno: precioAprobadoPequeno,
  precioAprobadoMediano: precioAprobadoMediano,
  precioAprobadoGrande: precioAprobadoGrande,
  precioAprobadoMoto: precioAprobadoMoto,
).ref();
ref.execute();
```


### DeleteService
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteService(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteServiceData, DeleteServiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteService(
  id: id,
);
DeleteServiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteService(
  id: id,
).ref();
ref.execute();
```


### ToggleServiceActive
#### Required Arguments
```dart
String id = ...;
bool activo = ...;
ExampleConnector.instance.toggleServiceActive(
  id: id,
  activo: activo,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ToggleServiceActiveData, ToggleServiceActiveVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.toggleServiceActive(
  id: id,
  activo: activo,
);
ToggleServiceActiveData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
bool activo = ...;

final ref = ExampleConnector.instance.toggleServiceActive(
  id: id,
  activo: activo,
).ref();
ref.execute();
```


### CreateBusinessHour
#### Required Arguments
```dart
String businessId = ...;
int diaDeLaSemana = ...;
bool esDiaDescanso = ...;
ExampleConnector.instance.createBusinessHour(
  businessId: businessId,
  diaDeLaSemana: diaDeLaSemana,
  esDiaDescanso: esDiaDescanso,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateBusinessHour, we created `CreateBusinessHourBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateBusinessHourVariablesBuilder {
  ...
   CreateBusinessHourVariablesBuilder horaApertura(String? t) {
   _horaApertura.value = t;
   return this;
  }
  CreateBusinessHourVariablesBuilder horaCierre(String? t) {
   _horaCierre.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createBusinessHour(
  businessId: businessId,
  diaDeLaSemana: diaDeLaSemana,
  esDiaDescanso: esDiaDescanso,
)
.horaApertura(horaApertura)
.horaCierre(horaCierre)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateBusinessHourData, CreateBusinessHourVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createBusinessHour(
  businessId: businessId,
  diaDeLaSemana: diaDeLaSemana,
  esDiaDescanso: esDiaDescanso,
);
CreateBusinessHourData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
int diaDeLaSemana = ...;
bool esDiaDescanso = ...;

final ref = ExampleConnector.instance.createBusinessHour(
  businessId: businessId,
  diaDeLaSemana: diaDeLaSemana,
  esDiaDescanso: esDiaDescanso,
).ref();
ref.execute();
```


### AddVehicle
#### Required Arguments
```dart
String modelId = ...;
ExampleConnector.instance.addVehicle(
  modelId: modelId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AddVehicle, we created `AddVehicleBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddVehicleVariablesBuilder {
  ...
   AddVehicleVariablesBuilder plate(String? t) {
   _plate.value = t;
   return this;
  }
  AddVehicleVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.addVehicle(
  modelId: modelId,
)
.plate(plate)
.category(category)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<AddVehicleData, AddVehicleVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.addVehicle(
  modelId: modelId,
);
AddVehicleData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String modelId = ...;

final ref = ExampleConnector.instance.addVehicle(
  modelId: modelId,
).ref();
ref.execute();
```


### DeleteVehicle
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteVehicle(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteVehicleData, DeleteVehicleVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteVehicle(
  id: id,
);
DeleteVehicleData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteVehicle(
  id: id,
).ref();
ref.execute();
```


### UpdateVehicle
#### Required Arguments
```dart
String id = ...;
String modelId = ...;
ExampleConnector.instance.updateVehicle(
  id: id,
  modelId: modelId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateVehicle, we created `UpdateVehicleBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateVehicleVariablesBuilder {
  ...
   UpdateVehicleVariablesBuilder plate(String? t) {
   _plate.value = t;
   return this;
  }
  UpdateVehicleVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateVehicle(
  id: id,
  modelId: modelId,
)
.plate(plate)
.category(category)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateVehicleData, UpdateVehicleVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateVehicle(
  id: id,
  modelId: modelId,
);
UpdateVehicleData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String modelId = ...;

final ref = ExampleConnector.instance.updateVehicle(
  id: id,
  modelId: modelId,
).ref();
ref.execute();
```


### UpdateEmployeeAvailability
#### Required Arguments
```dart
String id = ...;
bool estadoDisponibilidad = ...;
ExampleConnector.instance.updateEmployeeAvailability(
  id: id,
  estadoDisponibilidad: estadoDisponibilidad,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateEmployeeAvailabilityData, UpdateEmployeeAvailabilityVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateEmployeeAvailability(
  id: id,
  estadoDisponibilidad: estadoDisponibilidad,
);
UpdateEmployeeAvailabilityData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
bool estadoDisponibilidad = ...;

final ref = ExampleConnector.instance.updateEmployeeAvailability(
  id: id,
  estadoDisponibilidad: estadoDisponibilidad,
).ref();
ref.execute();
```


### DeleteBusinessHours
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.deleteBusinessHours(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteBusinessHoursData, DeleteBusinessHoursVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteBusinessHours(
  businessId: businessId,
);
DeleteBusinessHoursData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.deleteBusinessHours(
  businessId: businessId,
).ref();
ref.execute();
```


### SuperAdminUpdateBusinessStatus
#### Required Arguments
```dart
String id = ...;
BusinessStatus status = ...;
ExampleConnector.instance.superAdminUpdateBusinessStatus(
  id: id,
  status: status,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SuperAdminUpdateBusinessStatusData, SuperAdminUpdateBusinessStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.superAdminUpdateBusinessStatus(
  id: id,
  status: status,
);
SuperAdminUpdateBusinessStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
BusinessStatus status = ...;

final ref = ExampleConnector.instance.superAdminUpdateBusinessStatus(
  id: id,
  status: status,
).ref();
ref.execute();
```


### SwitchCurrentBusiness
#### Required Arguments
```dart
String businessId = ...;
ExampleConnector.instance.switchCurrentBusiness(
  businessId: businessId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SwitchCurrentBusinessData, SwitchCurrentBusinessVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.switchCurrentBusiness(
  businessId: businessId,
);
SwitchCurrentBusinessData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;

final ref = ExampleConnector.instance.switchCurrentBusiness(
  businessId: businessId,
).ref();
ref.execute();
```


### CreateWalkInUser
#### Required Arguments
```dart
String id = ...;
String nombreCompleto = ...;
String telefono = ...;
String email = ...;
ExampleConnector.instance.createWalkInUser(
  id: id,
  nombreCompleto: nombreCompleto,
  telefono: telefono,
  email: email,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateWalkInUserData, CreateWalkInUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createWalkInUser(
  id: id,
  nombreCompleto: nombreCompleto,
  telefono: telefono,
  email: email,
);
CreateWalkInUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nombreCompleto = ...;
String telefono = ...;
String email = ...;

final ref = ExampleConnector.instance.createWalkInUser(
  id: id,
  nombreCompleto: nombreCompleto,
  telefono: telefono,
  email: email,
).ref();
ref.execute();
```


### CreateWalkInOrder
#### Required Arguments
```dart
String businessId = ...;
String clientId = ...;
double price = ...;
double costo = ...;
String serviceName = ...;
OrderType type = ...;
PaymentMethod paymentMethod = ...;
ExampleConnector.instance.createWalkInOrder(
  businessId: businessId,
  clientId: clientId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateWalkInOrder, we created `CreateWalkInOrderBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateWalkInOrderVariablesBuilder {
  ...
   CreateWalkInOrderVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createWalkInOrder(
  businessId: businessId,
  clientId: clientId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
)
.observations(observations)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateWalkInOrderData, CreateWalkInOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createWalkInOrder(
  businessId: businessId,
  clientId: clientId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
);
CreateWalkInOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String clientId = ...;
double price = ...;
double costo = ...;
String serviceName = ...;
OrderType type = ...;
PaymentMethod paymentMethod = ...;

final ref = ExampleConnector.instance.createWalkInOrder(
  businessId: businessId,
  clientId: clientId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
).ref();
ref.execute();
```


### UpdateOrderCompletion
#### Required Arguments
```dart
String orderId = ...;
ExampleConnector.instance.updateOrderCompletion(
  orderId: orderId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateOrderCompletion, we created `UpdateOrderCompletionBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateOrderCompletionVariablesBuilder {
  ...
   UpdateOrderCompletionVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  UpdateOrderCompletionVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateOrderCompletion(
  orderId: orderId,
)
.observations(observations)
.invoiceUrl(invoiceUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateOrderCompletionData, UpdateOrderCompletionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateOrderCompletion(
  orderId: orderId,
);
UpdateOrderCompletionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;

final ref = ExampleConnector.instance.updateOrderCompletion(
  orderId: orderId,
).ref();
ref.execute();
```


### CreateInvoice
#### Required Arguments
```dart
String id = ...;
String orderId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;
ExampleConnector.instance.createInvoice(
  id: id,
  orderId: orderId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateInvoice, we created `CreateInvoiceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateInvoiceVariablesBuilder {
  ...
   CreateInvoiceVariablesBuilder pdfUrl(String? t) {
   _pdfUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createInvoice(
  id: id,
  orderId: orderId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
)
.pdfUrl(pdfUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateInvoiceData, CreateInvoiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createInvoice(
  id: id,
  orderId: orderId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
);
CreateInvoiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String orderId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;

final ref = ExampleConnector.instance.createInvoice(
  id: id,
  orderId: orderId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
).ref();
ref.execute();
```


### CreateInvoiceItem
#### Required Arguments
```dart
String invoiceId = ...;
String serviceName = ...;
int quantity = ...;
double unitPrice = ...;
double total = ...;
ExampleConnector.instance.createInvoiceItem(
  invoiceId: invoiceId,
  serviceName: serviceName,
  quantity: quantity,
  unitPrice: unitPrice,
  total: total,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateInvoiceItemData, CreateInvoiceItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createInvoiceItem(
  invoiceId: invoiceId,
  serviceName: serviceName,
  quantity: quantity,
  unitPrice: unitPrice,
  total: total,
);
CreateInvoiceItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String invoiceId = ...;
String serviceName = ...;
int quantity = ...;
double unitPrice = ...;
double total = ...;

final ref = ExampleConnector.instance.createInvoiceItem(
  invoiceId: invoiceId,
  serviceName: serviceName,
  quantity: quantity,
  unitPrice: unitPrice,
  total: total,
).ref();
ref.execute();
```


### UpdateInvoicePdf
#### Required Arguments
```dart
String id = ...;
InvoiceStatus invoiceStatus = ...;
ExampleConnector.instance.updateInvoicePdf(
  id: id,
  invoiceStatus: invoiceStatus,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateInvoicePdf, we created `UpdateInvoicePdfBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateInvoicePdfVariablesBuilder {
  ...
   UpdateInvoicePdfVariablesBuilder pdfUrl(String? t) {
   _pdfUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateInvoicePdf(
  id: id,
  invoiceStatus: invoiceStatus,
)
.pdfUrl(pdfUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateInvoicePdfData, UpdateInvoicePdfVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateInvoicePdf(
  id: id,
  invoiceStatus: invoiceStatus,
);
UpdateInvoicePdfData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
InvoiceStatus invoiceStatus = ...;

final ref = ExampleConnector.instance.updateInvoicePdf(
  id: id,
  invoiceStatus: invoiceStatus,
).ref();
ref.execute();
```


### CreateReview
#### Required Arguments
```dart
String orderId = ...;
String businessId = ...;
int calificacion = ...;
ExampleConnector.instance.createReview(
  orderId: orderId,
  businessId: businessId,
  calificacion: calificacion,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateReview, we created `CreateReviewBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateReviewVariablesBuilder {
  ...
   CreateReviewVariablesBuilder employeeId(String? t) {
   _employeeId.value = t;
   return this;
  }
  CreateReviewVariablesBuilder comentario(String? t) {
   _comentario.value = t;
   return this;
  }
  CreateReviewVariablesBuilder appCalificacion(int? t) {
   _appCalificacion.value = t;
   return this;
  }
  CreateReviewVariablesBuilder appComentario(String? t) {
   _appComentario.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createReview(
  orderId: orderId,
  businessId: businessId,
  calificacion: calificacion,
)
.employeeId(employeeId)
.comentario(comentario)
.appCalificacion(appCalificacion)
.appComentario(appComentario)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateReviewData, CreateReviewVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createReview(
  orderId: orderId,
  businessId: businessId,
  calificacion: calificacion,
);
CreateReviewData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String businessId = ...;
int calificacion = ...;

final ref = ExampleConnector.instance.createReview(
  orderId: orderId,
  businessId: businessId,
  calificacion: calificacion,
).ref();
ref.execute();
```


### UpdateBusinessPrepaidBalance
#### Required Arguments
```dart
String id = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
ExampleConnector.instance.updateBusinessPrepaidBalance(
  id: id,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateBusinessPrepaidBalanceData, UpdateBusinessPrepaidBalanceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateBusinessPrepaidBalance(
  id: id,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
);
UpdateBusinessPrepaidBalanceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;

final ref = ExampleConnector.instance.updateBusinessPrepaidBalance(
  id: id,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
).ref();
ref.execute();
```


### SuperAdminUpdateBusinessPrepaid
#### Required Arguments
```dart
String id = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
ExampleConnector.instance.superAdminUpdateBusinessPrepaid(
  id: id,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SuperAdminUpdateBusinessPrepaidData, SuperAdminUpdateBusinessPrepaidVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.superAdminUpdateBusinessPrepaid(
  id: id,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
);
SuperAdminUpdateBusinessPrepaidData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;

final ref = ExampleConnector.instance.superAdminUpdateBusinessPrepaid(
  id: id,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
).ref();
ref.execute();
```


### CreateNotification
#### Required Arguments
```dart
String userId = ...;
String titulo = ...;
String mensaje = ...;
ExampleConnector.instance.createNotification(
  userId: userId,
  titulo: titulo,
  mensaje: mensaje,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateNotificationData, CreateNotificationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createNotification(
  userId: userId,
  titulo: titulo,
  mensaje: mensaje,
);
CreateNotificationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;
String titulo = ...;
String mensaje = ...;

final ref = ExampleConnector.instance.createNotification(
  userId: userId,
  titulo: titulo,
  mensaje: mensaje,
).ref();
ref.execute();
```


### MarkNotificationAsRead
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.markNotificationAsRead(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<MarkNotificationAsReadData, MarkNotificationAsReadVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.markNotificationAsRead(
  id: id,
);
MarkNotificationAsReadData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.markNotificationAsRead(
  id: id,
).ref();
ref.execute();
```


### CreatePrepaidHistory
#### Required Arguments
```dart
String businessId = ...;
String orderId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;
ExampleConnector.instance.createPrepaidHistory(
  businessId: businessId,
  orderId: orderId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreatePrepaidHistoryData, CreatePrepaidHistoryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createPrepaidHistory(
  businessId: businessId,
  orderId: orderId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
);
CreatePrepaidHistoryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String orderId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;

final ref = ExampleConnector.instance.createPrepaidHistory(
  businessId: businessId,
  orderId: orderId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
).ref();
ref.execute();
```


### CreatePrepaidServiceMetric
#### Required Arguments
```dart
String businessId = ...;
String serviceName = ...;
double costoUnitario = ...;
int cantidad = ...;
double totalConsumido = ...;
ExampleConnector.instance.createPrepaidServiceMetric(
  businessId: businessId,
  serviceName: serviceName,
  costoUnitario: costoUnitario,
  cantidad: cantidad,
  totalConsumido: totalConsumido,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreatePrepaidServiceMetricData, CreatePrepaidServiceMetricVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createPrepaidServiceMetric(
  businessId: businessId,
  serviceName: serviceName,
  costoUnitario: costoUnitario,
  cantidad: cantidad,
  totalConsumido: totalConsumido,
);
CreatePrepaidServiceMetricData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String serviceName = ...;
double costoUnitario = ...;
int cantidad = ...;
double totalConsumido = ...;

final ref = ExampleConnector.instance.createPrepaidServiceMetric(
  businessId: businessId,
  serviceName: serviceName,
  costoUnitario: costoUnitario,
  cantidad: cantidad,
  totalConsumido: totalConsumido,
).ref();
ref.execute();
```


### UpdatePrepaidServiceMetric
#### Required Arguments
```dart
String id = ...;
int cantidad = ...;
double totalConsumido = ...;
ExampleConnector.instance.updatePrepaidServiceMetric(
  id: id,
  cantidad: cantidad,
  totalConsumido: totalConsumido,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdatePrepaidServiceMetricData, UpdatePrepaidServiceMetricVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updatePrepaidServiceMetric(
  id: id,
  cantidad: cantidad,
  totalConsumido: totalConsumido,
);
UpdatePrepaidServiceMetricData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
int cantidad = ...;
double totalConsumido = ...;

final ref = ExampleConnector.instance.updatePrepaidServiceMetric(
  id: id,
  cantidad: cantidad,
  totalConsumido: totalConsumido,
).ref();
ref.execute();
```


### CreateBusinessReservationConfig
#### Required Arguments
```dart
String businessId = ...;
int capacidadSimultanea = ...;
int tiempoAnticipacionMinutos = ...;
bool isConfigured = ...;
ExampleConnector.instance.createBusinessReservationConfig(
  businessId: businessId,
  capacidadSimultanea: capacidadSimultanea,
  tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,
  isConfigured: isConfigured,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateBusinessReservationConfigData, CreateBusinessReservationConfigVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createBusinessReservationConfig(
  businessId: businessId,
  capacidadSimultanea: capacidadSimultanea,
  tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,
  isConfigured: isConfigured,
);
CreateBusinessReservationConfigData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
int capacidadSimultanea = ...;
int tiempoAnticipacionMinutos = ...;
bool isConfigured = ...;

final ref = ExampleConnector.instance.createBusinessReservationConfig(
  businessId: businessId,
  capacidadSimultanea: capacidadSimultanea,
  tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,
  isConfigured: isConfigured,
).ref();
ref.execute();
```


### UpdateBusinessReservationConfig
#### Required Arguments
```dart
String id = ...;
int capacidadSimultanea = ...;
int tiempoAnticipacionMinutos = ...;
bool isConfigured = ...;
ExampleConnector.instance.updateBusinessReservationConfig(
  id: id,
  capacidadSimultanea: capacidadSimultanea,
  tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,
  isConfigured: isConfigured,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateBusinessReservationConfigData, UpdateBusinessReservationConfigVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateBusinessReservationConfig(
  id: id,
  capacidadSimultanea: capacidadSimultanea,
  tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,
  isConfigured: isConfigured,
);
UpdateBusinessReservationConfigData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
int capacidadSimultanea = ...;
int tiempoAnticipacionMinutos = ...;
bool isConfigured = ...;

final ref = ExampleConnector.instance.updateBusinessReservationConfig(
  id: id,
  capacidadSimultanea: capacidadSimultanea,
  tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,
  isConfigured: isConfigured,
).ref();
ref.execute();
```


### CreateOrderReservation
#### Required Arguments
```dart
String orderId = ...;
String businessId = ...;
Timestamp scheduledAt = ...;
int serviceDurationMinutos = ...;
String serviceId = ...;
Timestamp createdAt = ...;
ExampleConnector.instance.createOrderReservation(
  orderId: orderId,
  businessId: businessId,
  scheduledAt: scheduledAt,
  serviceDurationMinutos: serviceDurationMinutos,
  serviceId: serviceId,
  createdAt: createdAt,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateOrderReservationData, CreateOrderReservationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createOrderReservation(
  orderId: orderId,
  businessId: businessId,
  scheduledAt: scheduledAt,
  serviceDurationMinutos: serviceDurationMinutos,
  serviceId: serviceId,
  createdAt: createdAt,
);
CreateOrderReservationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String businessId = ...;
Timestamp scheduledAt = ...;
int serviceDurationMinutos = ...;
String serviceId = ...;
Timestamp createdAt = ...;

final ref = ExampleConnector.instance.createOrderReservation(
  orderId: orderId,
  businessId: businessId,
  scheduledAt: scheduledAt,
  serviceDurationMinutos: serviceDurationMinutos,
  serviceId: serviceId,
  createdAt: createdAt,
).ref();
ref.execute();
```


### DeleteOrderReservation
#### Required Arguments
```dart
String orderId = ...;
ExampleConnector.instance.deleteOrderReservation(
  orderId: orderId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteOrderReservationData, DeleteOrderReservationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteOrderReservation(
  orderId: orderId,
);
DeleteOrderReservationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;

final ref = ExampleConnector.instance.deleteOrderReservation(
  orderId: orderId,
).ref();
ref.execute();
```


### UpsertVehicleBrand
#### Required Arguments
```dart
String id = ...;
String name = ...;
ExampleConnector.instance.upsertVehicleBrand(
  id: id,
  name: name,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpsertVehicleBrandData, UpsertVehicleBrandVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertVehicleBrand(
  id: id,
  name: name,
);
UpsertVehicleBrandData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;

final ref = ExampleConnector.instance.upsertVehicleBrand(
  id: id,
  name: name,
).ref();
ref.execute();
```


### UpsertVehicleModel
#### Required Arguments
```dart
String id = ...;
String brandId = ...;
String name = ...;
String category = ...;
ExampleConnector.instance.upsertVehicleModel(
  id: id,
  brandId: brandId,
  name: name,
  category: category,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpsertVehicleModelData, UpsertVehicleModelVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertVehicleModel(
  id: id,
  brandId: brandId,
  name: name,
  category: category,
);
UpsertVehicleModelData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String brandId = ...;
String name = ...;
String category = ...;

final ref = ExampleConnector.instance.upsertVehicleModel(
  id: id,
  brandId: brandId,
  name: name,
  category: category,
).ref();
ref.execute();
```


### UpdateUserPhone
#### Required Arguments
```dart
String telefono = ...;
ExampleConnector.instance.updateUserPhone(
  telefono: telefono,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateUserPhoneData, UpdateUserPhoneVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateUserPhone(
  telefono: telefono,
);
UpdateUserPhoneData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String telefono = ...;

final ref = ExampleConnector.instance.updateUserPhone(
  telefono: telefono,
).ref();
ref.execute();
```


### DeleteCurrentUser
#### Required Arguments
```dart
String email = ...;
String nombreCompleto = ...;
ExampleConnector.instance.deleteCurrentUser(
  email: email,
  nombreCompleto: nombreCompleto,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteCurrentUserData, DeleteCurrentUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteCurrentUser(
  email: email,
  nombreCompleto: nombreCompleto,
);
DeleteCurrentUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String email = ...;
String nombreCompleto = ...;

final ref = ExampleConnector.instance.deleteCurrentUser(
  email: email,
  nombreCompleto: nombreCompleto,
).ref();
ref.execute();
```


### CompleteOrderWithInvoiceOnly
#### Required Arguments
```dart
String orderId = ...;
String invoiceId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;
ExampleConnector.instance.completeOrderWithInvoiceOnly(
  orderId: orderId,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CompleteOrderWithInvoiceOnly, we created `CompleteOrderWithInvoiceOnlyBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CompleteOrderWithInvoiceOnlyVariablesBuilder {
  ...
   CompleteOrderWithInvoiceOnlyVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  CompleteOrderWithInvoiceOnlyVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.completeOrderWithInvoiceOnly(
  orderId: orderId,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
)
.observations(observations)
.invoiceUrl(invoiceUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CompleteOrderWithInvoiceOnlyData, CompleteOrderWithInvoiceOnlyVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.completeOrderWithInvoiceOnly(
  orderId: orderId,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
);
CompleteOrderWithInvoiceOnlyData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String invoiceId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;

final ref = ExampleConnector.instance.completeOrderWithInvoiceOnly(
  orderId: orderId,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
).ref();
ref.execute();
```


### CompleteOrderWithPrepaidAndUpdateMetric
#### Required Arguments
```dart
String orderId = ...;
String orderIdStr = ...;
String invoiceId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;
String businessId = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
String historyId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;
String metricId = ...;
int metricCantidad = ...;
double metricTotalConsumido = ...;
ExampleConnector.instance.completeOrderWithPrepaidAndUpdateMetric(
  orderId: orderId,
  orderIdStr: orderIdStr,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCantidad: metricCantidad,
  metricTotalConsumido: metricTotalConsumido,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CompleteOrderWithPrepaidAndUpdateMetric, we created `CompleteOrderWithPrepaidAndUpdateMetricBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CompleteOrderWithPrepaidAndUpdateMetricVariablesBuilder {
  ...
   CompleteOrderWithPrepaidAndUpdateMetricVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  CompleteOrderWithPrepaidAndUpdateMetricVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.completeOrderWithPrepaidAndUpdateMetric(
  orderId: orderId,
  orderIdStr: orderIdStr,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCantidad: metricCantidad,
  metricTotalConsumido: metricTotalConsumido,
)
.observations(observations)
.invoiceUrl(invoiceUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CompleteOrderWithPrepaidAndUpdateMetricData, CompleteOrderWithPrepaidAndUpdateMetricVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.completeOrderWithPrepaidAndUpdateMetric(
  orderId: orderId,
  orderIdStr: orderIdStr,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCantidad: metricCantidad,
  metricTotalConsumido: metricTotalConsumido,
);
CompleteOrderWithPrepaidAndUpdateMetricData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String orderIdStr = ...;
String invoiceId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;
String businessId = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
String historyId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;
String metricId = ...;
int metricCantidad = ...;
double metricTotalConsumido = ...;

final ref = ExampleConnector.instance.completeOrderWithPrepaidAndUpdateMetric(
  orderId: orderId,
  orderIdStr: orderIdStr,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCantidad: metricCantidad,
  metricTotalConsumido: metricTotalConsumido,
).ref();
ref.execute();
```


### CompleteOrderWithPrepaidAndCreateMetric
#### Required Arguments
```dart
String orderId = ...;
String orderIdStr = ...;
String invoiceId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;
String businessId = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
String historyId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;
String metricId = ...;
double metricCostoUnitario = ...;
ExampleConnector.instance.completeOrderWithPrepaidAndCreateMetric(
  orderId: orderId,
  orderIdStr: orderIdStr,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCostoUnitario: metricCostoUnitario,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CompleteOrderWithPrepaidAndCreateMetric, we created `CompleteOrderWithPrepaidAndCreateMetricBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CompleteOrderWithPrepaidAndCreateMetricVariablesBuilder {
  ...
   CompleteOrderWithPrepaidAndCreateMetricVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  CompleteOrderWithPrepaidAndCreateMetricVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.completeOrderWithPrepaidAndCreateMetric(
  orderId: orderId,
  orderIdStr: orderIdStr,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCostoUnitario: metricCostoUnitario,
)
.observations(observations)
.invoiceUrl(invoiceUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CompleteOrderWithPrepaidAndCreateMetricData, CompleteOrderWithPrepaidAndCreateMetricVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.completeOrderWithPrepaidAndCreateMetric(
  orderId: orderId,
  orderIdStr: orderIdStr,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCostoUnitario: metricCostoUnitario,
);
CompleteOrderWithPrepaidAndCreateMetricData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String orderIdStr = ...;
String invoiceId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;
String businessId = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
String historyId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;
String metricId = ...;
double metricCostoUnitario = ...;

final ref = ExampleConnector.instance.completeOrderWithPrepaidAndCreateMetric(
  orderId: orderId,
  orderIdStr: orderIdStr,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCostoUnitario: metricCostoUnitario,
).ref();
ref.execute();
```


### ConsumePrepaidAndUpdateMetric
#### Required Arguments
```dart
String businessId = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
String historyId = ...;
String orderId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;
String metricId = ...;
int metricCantidad = ...;
double metricTotalConsumido = ...;
ExampleConnector.instance.consumePrepaidAndUpdateMetric(
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  orderId: orderId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCantidad: metricCantidad,
  metricTotalConsumido: metricTotalConsumido,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ConsumePrepaidAndUpdateMetricData, ConsumePrepaidAndUpdateMetricVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.consumePrepaidAndUpdateMetric(
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  orderId: orderId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCantidad: metricCantidad,
  metricTotalConsumido: metricTotalConsumido,
);
ConsumePrepaidAndUpdateMetricData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
String historyId = ...;
String orderId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;
String metricId = ...;
int metricCantidad = ...;
double metricTotalConsumido = ...;

final ref = ExampleConnector.instance.consumePrepaidAndUpdateMetric(
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  orderId: orderId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCantidad: metricCantidad,
  metricTotalConsumido: metricTotalConsumido,
).ref();
ref.execute();
```


### ConsumePrepaidAndCreateMetric
#### Required Arguments
```dart
String businessId = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
String historyId = ...;
String orderId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;
String metricId = ...;
double metricCostoUnitario = ...;
ExampleConnector.instance.consumePrepaidAndCreateMetric(
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  orderId: orderId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCostoUnitario: metricCostoUnitario,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ConsumePrepaidAndCreateMetricData, ConsumePrepaidAndCreateMetricVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.consumePrepaidAndCreateMetric(
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  orderId: orderId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCostoUnitario: metricCostoUnitario,
);
ConsumePrepaidAndCreateMetricData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
double saldoPrepagoInicial = ...;
double saldoPrepagoConsumido = ...;
String historyId = ...;
String orderId = ...;
String serviceName = ...;
double costoConsumido = ...;
double saldoResultante = ...;
String metricId = ...;
double metricCostoUnitario = ...;

final ref = ExampleConnector.instance.consumePrepaidAndCreateMetric(
  businessId: businessId,
  saldoPrepagoInicial: saldoPrepagoInicial,
  saldoPrepagoConsumido: saldoPrepagoConsumido,
  historyId: historyId,
  orderId: orderId,
  serviceName: serviceName,
  costoConsumido: costoConsumido,
  saldoResultante: saldoResultante,
  metricId: metricId,
  metricCostoUnitario: metricCostoUnitario,
).ref();
ref.execute();
```


### ServerCreateOrderWithPendingPayment
#### Required Arguments
```dart
String businessId = ...;
String clientId = ...;
double price = ...;
double costo = ...;
String serviceName = ...;
OrderType type = ...;
PaymentMethod paymentMethod = ...;
ExampleConnector.instance.serverCreateOrderWithPendingPayment(
  businessId: businessId,
  clientId: clientId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ServerCreateOrderWithPendingPayment, we created `ServerCreateOrderWithPendingPaymentBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ServerCreateOrderWithPendingPaymentVariablesBuilder {
  ...
   ServerCreateOrderWithPendingPaymentVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.serverCreateOrderWithPendingPayment(
  businessId: businessId,
  clientId: clientId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
)
.observations(observations)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ServerCreateOrderWithPendingPaymentData, ServerCreateOrderWithPendingPaymentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.serverCreateOrderWithPendingPayment(
  businessId: businessId,
  clientId: clientId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
);
ServerCreateOrderWithPendingPaymentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String businessId = ...;
String clientId = ...;
double price = ...;
double costo = ...;
String serviceName = ...;
OrderType type = ...;
PaymentMethod paymentMethod = ...;

final ref = ExampleConnector.instance.serverCreateOrderWithPendingPayment(
  businessId: businessId,
  clientId: clientId,
  price: price,
  costo: costo,
  serviceName: serviceName,
  type: type,
  paymentMethod: paymentMethod,
).ref();
ref.execute();
```


### CreatePaymentProof
#### Required Arguments
```dart
String orderId = ...;
String imageUrl = ...;
double declaredAmount = ...;
PaymentAccountType paymentAccountType = ...;
ExampleConnector.instance.createPaymentProof(
  orderId: orderId,
  imageUrl: imageUrl,
  declaredAmount: declaredAmount,
  paymentAccountType: paymentAccountType,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreatePaymentProof, we created `CreatePaymentProofBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreatePaymentProofVariablesBuilder {
  ...
   CreatePaymentProofVariablesBuilder referenceNumber(String? t) {
   _referenceNumber.value = t;
   return this;
  }
  CreatePaymentProofVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createPaymentProof(
  orderId: orderId,
  imageUrl: imageUrl,
  declaredAmount: declaredAmount,
  paymentAccountType: paymentAccountType,
)
.referenceNumber(referenceNumber)
.observations(observations)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreatePaymentProofData, CreatePaymentProofVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createPaymentProof(
  orderId: orderId,
  imageUrl: imageUrl,
  declaredAmount: declaredAmount,
  paymentAccountType: paymentAccountType,
);
CreatePaymentProofData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String imageUrl = ...;
double declaredAmount = ...;
PaymentAccountType paymentAccountType = ...;

final ref = ExampleConnector.instance.createPaymentProof(
  orderId: orderId,
  imageUrl: imageUrl,
  declaredAmount: declaredAmount,
  paymentAccountType: paymentAccountType,
).ref();
ref.execute();
```


### ServerUpdatePaymentProofStatus
#### Required Arguments
```dart
String id = ...;
PaymentProofStatus status = ...;
String reviewedBy = ...;
ExampleConnector.instance.serverUpdatePaymentProofStatus(
  id: id,
  status: status,
  reviewedBy: reviewedBy,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ServerUpdatePaymentProofStatus, we created `ServerUpdatePaymentProofStatusBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ServerUpdatePaymentProofStatusVariablesBuilder {
  ...
   ServerUpdatePaymentProofStatusVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.serverUpdatePaymentProofStatus(
  id: id,
  status: status,
  reviewedBy: reviewedBy,
)
.observations(observations)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ServerUpdatePaymentProofStatusData, ServerUpdatePaymentProofStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.serverUpdatePaymentProofStatus(
  id: id,
  status: status,
  reviewedBy: reviewedBy,
);
ServerUpdatePaymentProofStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
PaymentProofStatus status = ...;
String reviewedBy = ...;

final ref = ExampleConnector.instance.serverUpdatePaymentProofStatus(
  id: id,
  status: status,
  reviewedBy: reviewedBy,
).ref();
ref.execute();
```


### ServerUpdatePaymentProof
#### Required Arguments
```dart
String id = ...;
String imageUrl = ...;
double declaredAmount = ...;
PaymentAccountType paymentAccountType = ...;
ExampleConnector.instance.serverUpdatePaymentProof(
  id: id,
  imageUrl: imageUrl,
  declaredAmount: declaredAmount,
  paymentAccountType: paymentAccountType,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ServerUpdatePaymentProof, we created `ServerUpdatePaymentProofBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ServerUpdatePaymentProofVariablesBuilder {
  ...
   ServerUpdatePaymentProofVariablesBuilder referenceNumber(String? t) {
   _referenceNumber.value = t;
   return this;
  }
  ServerUpdatePaymentProofVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.serverUpdatePaymentProof(
  id: id,
  imageUrl: imageUrl,
  declaredAmount: declaredAmount,
  paymentAccountType: paymentAccountType,
)
.referenceNumber(referenceNumber)
.observations(observations)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ServerUpdatePaymentProofData, ServerUpdatePaymentProofVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.serverUpdatePaymentProof(
  id: id,
  imageUrl: imageUrl,
  declaredAmount: declaredAmount,
  paymentAccountType: paymentAccountType,
);
ServerUpdatePaymentProofData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String imageUrl = ...;
double declaredAmount = ...;
PaymentAccountType paymentAccountType = ...;

final ref = ExampleConnector.instance.serverUpdatePaymentProof(
  id: id,
  imageUrl: imageUrl,
  declaredAmount: declaredAmount,
  paymentAccountType: paymentAccountType,
).ref();
ref.execute();
```


### ServerUpdateOrderStatus
#### Required Arguments
```dart
String orderId = ...;
OrderStatus status = ...;
ExampleConnector.instance.serverUpdateOrderStatus(
  orderId: orderId,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ServerUpdateOrderStatus, we created `ServerUpdateOrderStatusBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ServerUpdateOrderStatusVariablesBuilder {
  ...
   ServerUpdateOrderStatusVariablesBuilder cancellationReason(String? t) {
   _cancellationReason.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.serverUpdateOrderStatus(
  orderId: orderId,
  status: status,
)
.cancellationReason(cancellationReason)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ServerUpdateOrderStatusData, ServerUpdateOrderStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.serverUpdateOrderStatus(
  orderId: orderId,
  status: status,
);
ServerUpdateOrderStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
OrderStatus status = ...;

final ref = ExampleConnector.instance.serverUpdateOrderStatus(
  orderId: orderId,
  status: status,
).ref();
ref.execute();
```


### CreateSystemNotification
#### Required Arguments
```dart
String userId = ...;
String titulo = ...;
String mensaje = ...;
ExampleConnector.instance.createSystemNotification(
  userId: userId,
  titulo: titulo,
  mensaje: mensaje,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateSystemNotificationData, CreateSystemNotificationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createSystemNotification(
  userId: userId,
  titulo: titulo,
  mensaje: mensaje,
);
CreateSystemNotificationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;
String titulo = ...;
String mensaje = ...;

final ref = ExampleConnector.instance.createSystemNotification(
  userId: userId,
  titulo: titulo,
  mensaje: mensaje,
).ref();
ref.execute();
```


### CompleteOrderWithTransferAndInvoice
#### Required Arguments
```dart
String orderId = ...;
String invoiceId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;
ExampleConnector.instance.completeOrderWithTransferAndInvoice(
  orderId: orderId,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CompleteOrderWithTransferAndInvoice, we created `CompleteOrderWithTransferAndInvoiceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CompleteOrderWithTransferAndInvoiceVariablesBuilder {
  ...
   CompleteOrderWithTransferAndInvoiceVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  CompleteOrderWithTransferAndInvoiceVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.completeOrderWithTransferAndInvoice(
  orderId: orderId,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
)
.observations(observations)
.invoiceUrl(invoiceUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CompleteOrderWithTransferAndInvoiceData, CompleteOrderWithTransferAndInvoiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.completeOrderWithTransferAndInvoice(
  orderId: orderId,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
);
CompleteOrderWithTransferAndInvoiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String invoiceId = ...;
String numeroUnico = ...;
double subtotal = ...;
double discount = ...;
double tax = ...;
double total = ...;
PaymentMethod paymentMethod = ...;
InvoiceStatus invoiceStatus = ...;

final ref = ExampleConnector.instance.completeOrderWithTransferAndInvoice(
  orderId: orderId,
  invoiceId: invoiceId,
  numeroUnico: numeroUnico,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
  paymentMethod: paymentMethod,
  invoiceStatus: invoiceStatus,
).ref();
ref.execute();
```


### CreateOrderLog
#### Required Arguments
```dart
String orderId = ...;
String actionType = ...;
ExampleConnector.instance.createOrderLog(
  orderId: orderId,
  actionType: actionType,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateOrderLog, we created `CreateOrderLogBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateOrderLogVariablesBuilder {
  ...
   CreateOrderLogVariablesBuilder previousValue(String? t) {
   _previousValue.value = t;
   return this;
  }
  CreateOrderLogVariablesBuilder newValue(String? t) {
   _newValue.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createOrderLog(
  orderId: orderId,
  actionType: actionType,
)
.previousValue(previousValue)
.newValue(newValue)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateOrderLogData, CreateOrderLogVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createOrderLog(
  orderId: orderId,
  actionType: actionType,
);
CreateOrderLogData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String orderId = ...;
String actionType = ...;

final ref = ExampleConnector.instance.createOrderLog(
  orderId: orderId,
  actionType: actionType,
).ref();
ref.execute();
```

