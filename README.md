CapybaraMiniTestSpec
====================

[![Build Status](https://secure.travis-ci.org/ordinaryzelig/capybara_minitest_spec.png?branch=master)](http://travis-ci.org/ordinaryzelig/capybara_minitest_spec)

## Description

If you've used [Capybara](https://github.com/jnicklas/capybara) and RSpec, you've probably used matchers like:

```ruby
page.should have_content('Title')
```

With CapybaraMiniTestSpec you can have similar functionality while using MiniTest::Spec:

```ruby
page.must_have_content('Title')
```

You can also use the TestUnit style assertions:

```ruby
assert_page_has_content page, 'Title'
```

But if you really want to be simple with MiniTest::Unit, you don't need this gem.
You can do the following without this gem:

```ruby
assert page.has_content?('Title'), 'Your custom failure message'
```

However, if you choose to use this gem, you get Capybara's failure messages as if you were using RSpec matchers.

```ruby
assert_page_has_content?('<h1>Content</h1>', 'No such Text')
# fails with 'expected there to be text "No such Text" in "Content"'
```

You can see all the available matchers [here] (https://github.com/jnicklas/capybara/blob/master/lib/capybara/rspec/matchers.rb).
CapybaraMiniTestSpec iterates through those "have_x" methods and creates corresponding MiniTest assertions/expectations.

## Install

```ruby
# Gemfile
gem 'capybara_minitest_spec'
```

NOTE: If after installing the Capybara gem, Nokogiri isn't installed, it's a known bug (https://github.com/jnicklas/capybara/issues/882).

### Rails

* [My blog] (http://redningja.com/dev/minitest-spec-setup-with-capybara-in-rails-3-1/)
* [Railscast (pro episode)] (http://railscasts.com/episodes/327-minitest-with-rails)

If you choose to use Rails's default ActionDispatch::IntegrationTest, just extend Minitest::Spec::DSL. E.g.

```ruby
# Maybe in a helper or something.
ActionDispatch::IntegrationTest.extend Minitest::Spec::DSL
```

Otherwise you may see this exception:
`NoMethodError: undefined method 'assert_page_has_content' for nil:NilClass`.

## Compatibility

### Capybara

  In theory, this should work with Capybara >= 2. The latest version it was tested with was Capybara 2.4.1.

  For Capybara < 2 support, use a version of this gem < 1.0.

### Minitest

Supports Minitest >= 4.
It may work for earlier versions, I just haven't tested it.
If you need it to support an earlier version, let me know and I'll see what I can do.

### Ruby

Check .travis.yml.

### Cucumber

Cucumber is not officially supported. See [#10](https://github.com/ordinaryzelig/capybara_minitest_spec/issues/10#issuecomment-152404532) for a possible workaround.

## Testing

This gem was tested by basically copying the Capybara spec located in 'spec/rspec/matchers_spec.rb' and [altering the test to run with MiniTest](https://gist.github.com/4297afa19edd44885248).

A tutorial on [how to perform integration tests on Ruby on Rails with Minitest and Capybara](https://semaphoreci.com/community/tutorials/integration-testing-ruby-on-rails-with-minitest-and-capybara)

