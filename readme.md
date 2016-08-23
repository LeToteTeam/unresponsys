What is the purpose of this gem? It is an [opinionated](https://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php) wrapper for Responsys email marketing software. It uses the new [REST API](https://docs.oracle.com/cloud/latest/marketingcs_gs/OMCEB.pdf), while existing gems are wrapping the old SOAP API.

# Contents

1. [Setup](#setup)
2. [Lists](#lists)
3. [Members](#members)
4. [Messages](#messages)
5. [Events](#events)
6. [Extension Tables](#extension-tables)
7. [Supplemental Tables](#supplemental-tables)

## Setup

Initialize your client:

```ruby
client = Unresponsys::Client.new(
  username: 'YOUR_USERNAME',
  password: 'YOUR_PASSWORD',
  interact: 2||5
)
```

The `interact` option is optional, and can be either 2 or 5. If omitted, it will default to 2.

## Lists

From the documentation:

>Lists are used to store audience database records—members of your audience might be leads, prospects, customers, contacts, consumers, or visitors, depending on your terminology. The standard set of fields in a list includes:
- Recipient ID (RIID), an internalOracle Responsys-assigned identifier that allows the behavior of individual recipients to be tracked over time.
- Email address, mobile number, postal address, which are standard contact channel fields
- Permission/Opt-in status fields for the various marketing channels (email, mobile, postal)
- Email format preference (HTML or text)
- Derived fields for ISP and domain
- Last modified and created timestamps
In addition, lists can have a number of custom, user-defined fields that you use to maintain a rich audience profile for targeting and personalization purposes.

### Find a list

```ruby
client.lists.find('mylist')
```

Accepts a list name (string). Returns an `Unresponsys::List` instance

### Find list member

```ruby
list = client.lists.find('mylist')
list.members.find('hello@example.com')
```

Accepts an email address. Returns an `Unresponsys::Member` instance

Throws an `Unresponsys::NotFound` if no member exists

### New list member

```ruby
list = client.lists.find('mylist')
list.members.new('hello@example.com')
```

Accepts an email address (string). Returns an `Unresponsys::Member` instance

## Members

Members belong to a particular list and can be instantiated through that list

There are several reserved, immutable fields which become `attr_reader`

- `riid` - the responsys id
- `email_address` - email address
- `mobile_number` - mobile number

You can also create up to 80 custom fields (in the Responsys dashboard) which become `attr_accessor`

### Save a member

```ruby
member = list.members.find('hello@example.com')
member.some_field = 'blablabla'
member.save
```

Create or update a list member. Returns `true` or `false`

## Messages

### New Message

```ruby
member = list.members.find('hello@example.com')
message = member.messages.new('ReferredFriend', referral_code: '123456')
```

Accepts an campaign name (string) and a hash of key-value properties (optional) which can be used to personalize the email

### Save Message

```ruby
message = member.messages.new('ReferredFriend', referral_code: '123456')
message.save
```

Returns `true` on success or throws an error

Sends the message

## Events

### New event

```ruby
member = list.members.find('hello@example.com')
event = member.events.new('ReferredFriend')
```

Accepts an event name (string)

Custom events must be defined on the account page of the Responsys dashboard before you can start sending them

### Save event

```ruby
event = member.events.new('ReferredFriend')
event.save
```

Returns `true` on success or throws an error

Throws a `Unresponsys::NotFound` if you have not defined the event on the account page of the Responsys dashboard

## Extension Tables

From the documentation:

> One or more Profile Extension Tables can be associated with a Profile List. There must be a one-to-one relationship between a record in a Profile Extension Table and its parent Profile List. Profile Extension Tables provide an attractive and efficient way to organize and process audience data. Similar to data in Profile Lists, audience data in Profile Extension Tables can be used for segmentation and targeting in Filters as well as Programs

### Find extension table

```ruby
member = list.members.find('hello@example.com')
table = member.extension_tables.find('MyExtensionTable')
```

Extension tables belong to a particular list and are accessed through a list member. Each list member has one corresponding entry in the extension table. Tables need to be created and edited through the dashboard.

Takes a table name (string). Returns an instance of `Unresponsys::ExtensionTable`

### Update extension table

```ruby
member = list.members.find('hello@example.com')
table = member.extension_tables.find('MyExtensionTable')
table.update(favorite_color: 'blue')
```

Returns `true` or `false`

## Supplemental Tables

From the documentation:

> As its name indicates, a supplemental table is a collection of database records that supplements a list with additional related information. The connections between a table and a list is made via a data extraction key, or key field, that is present in both the table and the list. Because you define the schema for any tables you create, you can use them for a wide variety of purposes, ranging from message personalization and dynamic content to storing form responses and campaign events.

### Find supplemental table

```ruby
folder  = client.folders.find('MyFolder')
table   = folder.supplemental_tables.find('MyTable')
```

Tables belong to a folder and need to be accessed through it. Tables need to be created and edited through the dashboard. This gem assumes that your table has one primary key, called `ID_`, which is an integer. This can be setup through the dashboard.

Takes a table name (string). Returns an instance of `Unresponsys::SupplementalTable`


### Find row

```ruby
table = folder.supplemental_tables.find('MyTable')
table.rows.find(123)
```

Takes an id (integer). Returns an instance of `Unresponsys::Row` or throws an `Unresponsys::NotFound`

### New row

```ruby
table = folder.supplemental_tables.find('MyTable')
table.rows.new(124)
```

Takes an id (integer). Returns an instance of `Unresponsys::Row`

### Save row

```ruby
row = table.rows.find(123)
row.title = 'My Title'
row.save
```

Returns `true` or `false`

### Destroy row

```ruby
row = table.rows.find(123)
row.destroy
```

Returns `true` or `false`
