# StorageTables
[![CI](https://github.com/payt/storage_tables/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/payt/storage_tables/actions/workflows/ci.yml)

This is an idea after ActiveStorage from rails. We wanted to use separate models and tables for saving attachments.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "storage_tables"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install storage_tables
```

After installing the gem
Run `bin/rails active_storage:install` to copy over storage_tables migrations.
```bash
$ bin/rails active_storage:install
```


### Table generator

To create a new storage table for a record you can use the generator
```bash
$ bin/rails g storage_tables Attachment --record User
```

This will create a attachment model file and the migrations for the new attachment table,
with a foreign_key to the `User` table


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
