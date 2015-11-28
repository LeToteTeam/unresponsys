What is the purpose of this gem? It is an [opinionated](https://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php) wrapper for Responsys email marketing software. It uses the new [REST API](https://docs.oracle.com/cloud/latest/marketingcs_gs/OMCEB.pdf), while existing gems are wrapping the old SOAP API.

Some helpful, but unpublished information: rate limit is 500 calls per minute.

# Setup

Add an `unresponsys.rb` file under `config/initializers` (if you're using Rails).

```
Unresponsys::Client.new(
  username: 'YOUR_USERNAME',
  password: 'YOUR_PASSWORD'
)
```

# Lists

Lists cannot be created or changed through the API, they must be setup with the Responsys dashboard.

### Find a list

```
Unresponsys::List.find('mylist')
```

Accepts a list name (string)

Returns an `Unresponsys::List` instance

### Find list member

```
list = Unresponsys::List.find('mylist')
list.members.find('hello@example.com')
```

Accepts an email address

Returns an `Unresponsys::Member` instance

Throws an `Unresponsys::NotFoundError` if no member exists

### New list member

```
list = Unresponsys::List.find('mylist')
list.members.new('hello@example.com')
```

Accepts an email address

Returns an `Unresponsys::Member` instance

# Members

Members belong to a particular list and can be instantiated through that list

There are several reserved, immutable fields which become `attr_reader`

- `riid` - the responsys id
- `email_address` - email address
- `mobile_number` - mobile number

You can also create up to 80 custom fields (in the Responsys dashboard) which become `attr_accessor`

There are a couple of other methods on the member

- `deleted?` whether the member is receiving emails or not (cannot actually remove from table)
- `list` returns the name of the list the member belongs to

### Save a member

```
member = list.members.find('hello@example.com')
member.some_field = 'blablabla'
member.save
```

Create or update a list member

Returns `true` or `false`

### Delete a member

```
member = list.members.find('hello@example.com')
member.delete
```

Remove a member from the list (they remain on the table but stop getting emails). This is a shorthand for setting the opt-out property

Returns `true` or `false`

You can also use `deleted?` to see if a member is receiving emails or not

# Events

### New event

```
member = list.members.find('hello@example.com')
event = member.events.new('ReferredFriend', friend_id: 1234)
```

Accepts an event name (string) and optional properties hash

Custom events must be defined on the account page of the Responsys dashboard before you can start sending them

### Save event

```
event = member.events.new('ReferredFriend')
event.save
```

Returns `true` on success or throws an error

Throws a `Unresponsys::NotFoundError` if you have not defined the event on the account page of the Responsys dashboard

# Tables

### Find table

```
folder  = Unresponsys::Folder.find('MyFolder')
table   = folder.tables.find('MyTable')
```

Tables belong to a folder and need to be accessed through it. Tables need to be created and edited through the dashboard.

Takes a table name (string)

Returns an instance of `Unresponsys::Table`

# Row

This gem assumes that your table has one primary key, called `ID_`, which is an integer. This can be setup through the dashboard.

### Find row

```
table = folder.tables.find('MyTable')
table.rows.find(123)
```

Takes an id (integer)

Returns an instance of `Unresponsys::Row` or throws an `Unresponsys::NotFoundError`

### New row

```
table = folder.tables.find('MyTable')
table.rows.new(124)
```

Takes an id (integer)

Returns an instance of `Unresponsys::Row`

### Save row

```
row = table.rows.find(123)
row.title = 'My Title'
row.save
```

Returns `true` or `false`
