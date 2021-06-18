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

### DomainSearch

see https://snov.io/api#DomainSearch2

```ruby
results = Snov::DomainSearch.new(domain: "octagon.com", type: "personal", limit: 10)
results.last_id
results.each do |result|
  puts result.email
  puts result.first_name
  puts result.last_name
  puts result.position
  puts result.source_page
  puts result.company_name
  puts result.type
  puts result.status
end
```

### GetProfileByEmail

see https://snov.io/api#GetProfileByEmail

```ruby
  prospect = Snov::GetProfileByEmail.new(email: "gavin.vanrooyen@octagon.com")

  puts prospect.success
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
  prospect.current_jobs.each do |social_info|
    puts social.company_name
    puts social.position
    # etc
  end
  # etc
```

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

### GetEmailsBySocialUrl

convenience wrapper for `GetEmailsFromUrl` to get a prospect with social url e.g. linkedin profile url

see https://snov.io/api#GetEmailsFromUrl

```ruby
  prospect = Snov::GetEmailsBySocialUrl.new(url: "https://www.linkedin.com/in/john-doe-123456/").prospect
  
  prospect.data.emails.each do |value|
    puts value.email
    puts value.status
  end

  prospect.data.previous_jobs.each do |value|
    puts value.company_name
    puts value.company_type
    puts value.position
    puts value.country
    puts value.start_date
    puts value.industry
    puts value.size
  end

  prospect.data.current_jobs.each do |value|
    puts value.company_name
    puts value.company_type
    puts value.position
    puts value.country
    puts value.start_date
    puts value.industry
    puts value.size
  end
```

### GetEmailsFromName

convenience wrapper for `GetEmailsFromName` to get a prospect with name

see https://snov.io/api#EmailFinder

```ruby
  prospect = Snov::GetEmailsFromName.new(first_name: "gavin", last_name: "vanrooyen", domain: "octagon.com").prospect
  
  prospect.data.emails.each do |value|
    puts value.email
    puts value.email_status
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/snov.

