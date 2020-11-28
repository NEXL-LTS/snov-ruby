[![Build Status](https://travis-ci.org/NEXL-LTS/snov-ruby.svg?branch=main)](https://travis-ci.org/NEXL-LTS/snov-ruby)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snov'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install snov

## Usage

set `SNOV_USER_ID` and `SNOV_SECRET` environment variables

### GetProspectList

see https://snov.io/api#FindProspectbyEmail

```ruby
  prospects = Snov::GetProspectsByEmail.new(email: "gavin.vanrooyen@octagon.com")
  prospects.each do |prospect|
    puts prospect.id
    puts prospect.name
    puts prospect.first_name
    puts prospect.last_name
    puts prospect.industry
    puts prospect.country
    puts prospect.locality
    prospect.social.each do |social_info|
      puts social.link
      puts social.type
    end
    # etc
  end
```

### GetUserLists

see https://snov.io/api#UserLists 

```ruby
  lists = Snov::GetUserLists.new
  lists.each do |list|
    puts list.id
    puts list.name
    puts list.is_deleted
    puts list.contacts
    puts list.creation_date.date
    puts list.deletion_date.date
  end
```

### GetProspectList

see https://snov.io/api#ViewProspectsInList

```ruby
  prospects = Snov::GetProspectList.new(list_id: 1, page: 1, per_page: 100)
  prospects.each do |prospect|
    puts prospect.id
    puts prospect.name
    puts prospect.first_name
    puts prospect.last_name
    puts prospect.source
    prospect.emails.each do |email_info|
      puts email_info.email
      puts email_info.is_verified
      puts email_info.job_status
      # etc
    end
  end
```

### GetAllProspectsFromList

convenience wrapper for `GetProspectList` to get all the prospects on all the pages

see https://snov.io/api#ViewProspectsInList

```ruby
  prospects = Snov::GetAllProspectsFromList.new(list_id: 1)
  prospects.each do |prospect|
    puts prospect.id
    puts prospect.name
    puts prospect.first_name
    puts prospect.last_name
    puts prospect.source
    prospect.emails.each do |email_info|
      puts email_info.email
      puts email_info.is_verified
      puts email_info.job_status
      # etc
    end
  end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/snov.

