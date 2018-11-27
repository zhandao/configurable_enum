# ConfigurableEnum

Make ActiveRecord `enum` configurable: store the mapping in database instead of hard code

**Only Support `Integer` Value Currently**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'configurable_enum'
```

And then execute:

    $ bundle

## Usage

1. Setup: Generate mapping model and migration:  
   `rails g configurable_enum:setup <model_column>`  
   For example, you want to make `Book`'s column `category` to be enum: `rails g configurable_enum:setup book_category`  
   It will Generate a model `BookCategroyMapping`
   
2. `rails db:migrate`
   
3. Declare in the model, like:
    ```ruby
    class Book < ActiveRecord
      configurable_enum :category
    end
    ```
    
4. You may want to init the enum mapping data, use:
    ```ruby
    hash = { science: 1 } # or { science: [1, 'remarks'] }
    Book.set_categories(hash)
    ```

That's all!

Other methods:

1. `Book.categories`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/configurable_enum. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ConfigurableEnum project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/configurable_enum/blob/master/CODE_OF_CONDUCT.md).
