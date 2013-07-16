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

## Install

```ruby
# Gemfile
gem 'capybara_minitest_spec'
```

NOTE: If after installing the Capybara gem, Nokogiri isn't installed, it's a known bug (https://github.com/jnicklas/capybara/issues/882).


## Matchers


```ruby
page.must_have_css('h1')
page.must_have_css('h1  ', :count => 1)

page.should have_xpath('//h1')
page.must_have_xpath("//h1[@id='foo']")

page.must_have_selector('//h1')
page.must_have_selector('//h1', :text => 'Hello World')
page.must_have_selector("//h1[@id='foo']")

page.must_have_content('Hello World')  # String matching
page.must_have_content(/Hello */)  # Regexp matching

page.must_have_text('Hello World') # String matching
page.must_have_text(/Hello */) # Regexp matching

page.must_have_link('About Us')  # Find a link with the inner text

page.must_have_button('Ok')  # Find a button with the text

page.must_have_select('Choose An Item')  # Select box with label

page.must_have_field('foo')  # Find an input field with the label
page.must_have_checked_field('foo')
page.must_have_unchecked_field('foo')

page.must_have_table('My Chart')  # Table with caption
```

Each matcher also has a "wont" matcher such as:


```ruby
page.wont_have_css('h1')
```

## Compatibility

In theory, this should work with Capybara >= 2. At the time of this writing, it was tested with Capybara 2.0.1.

For Capybara < 2 support, use a version of this gem < 1.0.

## Testing

This gem was tested by basically copying the Capybara spec located in 'spec/rspec/matchers_spec.rb' and [altering the test to run with MiniTest](https://gist.github.com/4297afa19edd44885248).
