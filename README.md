documents-store
===============

为文档资源提供 MongoDB 下的持久化保存
=======

## Installation

Add this line to your application's Gemfile:

    gem 'documents-store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install documents-store

## Usage

In your project's Gemfile, add following:

```ruby
gem "mongoid-versioning", :github => "simi/mongoid-versioning"
gem "documents-store",    :github => "mindpin/documents-store"
```

While creating new record, pass creator_id:

```ruby
attrs = {..., :creator_id => "some_id",...}

DocumentsStore::Document.create(attrs)
```

While updating existing record, pass last_editor_id:

```ruby
attrs = {..., :last_editor_id => "some_id",...}

document = DocumentsStore::Document.find("doc_id")
document.update_attributes(attrs)
document.save
```

Getting participant ids:

```ruby
document = DocumentsStore::Document.find("doc_id")
document.editor_ids
```

Getting existing versions:

```ruby
document = DocumentsStore::Document.find("doc_id")
document.versions
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/documents-store/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
