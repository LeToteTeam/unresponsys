What is the purpose of this gem? It is an [opinionated](https://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php) wrapper for Responsys email marketing software. It uses the new [REST API](https://docs.oracle.com/cloud/latest/marketingcs_gs/OMCEB.pdf), while existing gems are wrapping the old SOAP API.

# Setup

Initialize your client:

```
client = Unresponsys::Client.new(
  username: 'YOUR_USERNAME',
  password: 'YOUR_PASSWORD'
)
```

# Lists

### Find a list

```
client.lists.find('mylist')
```

Accepts a list name (string). Returns an `Unresponsys::List` instance

### Find list member

```
list = client.lists.find('mylist')
list.members.find('hello@example.com')
```

Accepts an email address. Returns an `Unresponsys::Member` instance

Throws an `Unresponsys::NotFound` if no member exists

### New list member

```
list = client.lists.find('mylist')
list.members.new('hello@example.com')
```

Accepts an email address (string). Returns an `Unresponsys::Member` instance

# Members

Members belong to a particular list and can be instantiated through that list

There are several reserved, immutable fields which become `attr_reader`

- `riid` - the responsys id
- `email_address` - email address
- `mobile_number` - mobile number

You can also create up to 80 custom fields (in the Responsys dashboard) which become `attr_accessor`

### Save a member

```
member = list.members.find('hello@example.com')
member.some_field = 'blablabla'
member.save
```

Create or update a list member. Returns `true` or `false`

# Events

### New event

```
member = list.members.find('hello@example.com')
event = member.events.new('ReferredFriend')
```

Accepts an event name (string)

Custom events must be defined on the account page of the Responsys dashboard before you can start sending them

### Save event

```
event = member.events.new('ReferredFriend')
event.save
```

Returns `true` on success or throws an error

Throws a `Unresponsys::NotFound` if you have not defined the event on the account page of the Responsys dashboard

# Extension Tables

### Find extension table

```
member = list.members.find('hello@example.com')
table = member.extension_tables.find('MyExtensionTable')
```

Extension tables belong to a particular list and are accessed through a list member. Each list member has one corresponding entry in the extension table. Tables need to be created and edited through the dashboard.

Takes a table name (string). Returns an instance of `Unresponsys::ExtensionTable`

### Update extension table

```
member = list.members.find('hello@example.com')
table = member.extension_tables.find('MyExtensionTable')
table.update(favorite_color: 'blue')
```

Returns `true` or `false`

# Supplemental Tables

### Find supplemental table

```
folder  = client.folders.find('MyFolder')
table   = folder.supplemental_tables.find('MyTable')
```

Tables belong to a folder and need to be accessed through it. Tables need to be created and edited through the dashboard.

Takes a table name (string). Returns an instance of `Unresponsys::SupplementalTable`

# Row

This gem assumes that your table has one primary key, called `ID_`, which is an integer. This can be setup through the dashboard.

### Find row

```
table = folder.supplemental_tables.find('MyTable')
table.rows.find(123)
```

Takes an id (integer). Returns an instance of `Unresponsys::Row` or throws an `Unresponsys::NotFound`

### New row

```
table = folder.supplemental_tables.find('MyTable')
table.rows.new(124)
```

Takes an id (integer). Returns an instance of `Unresponsys::Row`

### Save row

```
row = table.rows.find(123)
row.title = 'My Title'
row.save
```

Returns `true` or `false`
