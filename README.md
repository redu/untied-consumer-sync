# Untied::Consumer::Sync

Process the messages comming from your [Untied::Publisher](https://github.com/redu/untied-publisher) and syncs it directly to the database.

## Instalation

Add this line to your Gemfile:
```ruby
gem 'untied-consumer-sync'
```

Execute bundle:
```
$ bundle
```

Or install it yourself:
```
$ gem install untied-consumer-sync
```

## Usage

You will need to mark which model should be syncronized and what attributes you are interested in. So let's see how to do it.

Mark your model as a Zombie, so it can be created without all necessary attributes, but to the application it will be as if it does not even exist. When another Untied message completes this Zombie, it will not be a Zombie anymore and your application can count with it.

**Why this Zombie thing?** It's a good option to syncronize associated models, because Untied does not guarantee the messages order, so you could have an invalid reference (and you don't want it, so zombificate your models!).

```ruby
class User < ActiveRecord::Base
  include Untied::Consumer::Sync::Zombificator::ActsAsZombie
end
```

The next step is specify which attributes you want to store for each model in your application. To do so you need to create a yml file and say to `Untied::Consumer::Sync` where it can find this.

Say to `Untied::Consumer::Sync` where the file is:

```ruby
Untied::Consumer::Sync.configure do |config|
  config.model_data = "#{Rails.root}/config/model_data.yml"
end
```

Inform the attributes:

```yml
User: # Payload's type
  attributes: # Needed attributes
    - id
    - login
    - first_name
    - last_name
  mappings:
    id: core_id # Maps payload's id key to model's core_id column
  name: User # Model name
```

To know more about the options you can add to this yml, checkout this [wiki article](http://).

**Note:** If a `destroy` message comes before the `create` one for the entity, the `destoy` message will be ignored.

## What need to be done?

- Test Zombificator::ActsAsZombie
- Update only the changed attributes in `after_update`
- Limit which callbacks should be listened per model
- Snake case on the yml
- Enable `check_for` to accept more than one attribute for one entity

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


<img src="https://github.com/downloads/redu/redupy/redutech-marca.png" alt="Redu Educational Technologies" width="300">

This project is maintained and funded by [Redu Educational Techologies](http://tech.redu.com.br).

# Copyright

Copyright (c) 2012 Redu Educational Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
