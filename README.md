Capybara MiniTest Spec
======================

Define MiniTest::Spec expectations for Capybara node matchers.

Description
-----------

If you like using Capybara and RSpec, you're used to matchers like:

    page.should have_content('Title')

Now you can have similar functionality while using MiniTest::Spec:

    page.must_have_content('Title')

Install
-------

    gem install caypbara_minitest_spec

Compatibility
-------------

In theory, this should work with any version of Capybara, so the runtime dependency is not version specific. At the time of this writing, it was tested with Capybara 1.1.1.


Testing
-------

This gem was tested by basically copying the Capybara spec located in 'spec/rspec/matchers_spec.rb' and altering the test to run with MiniTest.
Capybara uses xpath as a submodule of the git repository. When adding this gem to gemtesters (http://test.rubygems.org/gems/capybara_minitest_spec), it sounded like too much trouble to check out the submodule, so I just used the regular gem.
