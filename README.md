= Capybara MiniTest Spec

Define MiniTest::Spec expectations for Capybara node matchers.

== Description

If you like using Capybara and RSpec, you're used to matchers like:

    page.should have_content('Title')

Now you can have similar functionality while using MiniTest::Spec:

    page.must_have_content('Title')

== Compatibility

In theory, this should work with any version of Capybara, so the runtime dependency is not version specific. At the time of this writing, it was tested with Capybara 1.1.1.

== TODO

* Better failure messages.
