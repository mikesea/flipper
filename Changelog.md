## 0.10.0

* Added feature check context (https://github.com/jnunemaker/flipper/pull/158)
* Do not use mass assignment for active record adapter (https://github.com/jnunemaker/flipper/pull/171)
* Several documentation improvements
* Make Flipper::UI.app.inspect return a String (https://github.com/jnunemaker/flipper/pull/176)
* changes boolean gate route to api/v1/features/boolean (https://github.com/jnunemaker/flipper/pull/175)
* add api v1 percentage_of_actors endpoint (https://github.com/jnunemaker/flipper/pull/179)
* add api v1 percentage_of_time endpoint (https://github.com/jnunemaker/flipper/pull/180)
* add api v1 actors gate endpoint  (https://github.com/jnunemaker/flipper/pull/181)
* wait for activesupport to tell us when active record is loaded for active record adapter (https://github.com/jnunemaker/flipper/pull/192)

## 0.9.2

* GET /api/v1/features
* POST /api/v1/features - add feature endpoint
* rack-protection 2.0.0 support
* pretty rake output

## 0.9.1

* bump flipper-active_record to officially support rails 5

## 0.9.0

* Moves SharedAdapterTests module to Flipper::Test::SharedAdapterTests to avoid clobbering anything top level in apps that use Flipper
* Memoizable, Instrumented and OperationLogger now delegate any missing methods to the original adapter. This was lost with the removal of the official decorator in 0.8, but is actually useful functionality for these "wrapping" adapters.
* Instrumenting adapters is now off by default. Use Flipper::Adapters::Instrumented.new(adapter) to instrument adapters and maintain the old functionality.
* Added dalli cache adapter (https://github.com/jnunemaker/flipper/pull/132)

## 0.8

* removed Flipper::Decorator and Flipper::Adapters::Decorator in favor of just calling methods on wrapped adapter
* fix bug where certain versions of AR left off quotes for key column which caused issues with MySQL https://github.com/jnunemaker/flipper/issues/120
* fix bug where AR would store multiple gate values for percentage gates for each enable/disable and then nondeterministically pick one on read (https://github.com/jnunemaker/flipper/pull/122 and https://github.com/jnunemaker/flipper/pull/124)
* added readonly adapter (https://github.com/jnunemaker/flipper/pull/111)
* flipper groups now match for truthy values rather than explicitly only true (https://github.com/jnunemaker/flipper/issues/110)
* removed gate operation instrumentation (https://github.com/jnunemaker/flipper/commit/32f14ed1fb25c64961b23c6be3dc6773143a06c8); I don't think it was useful and never found myself instrumenting it in reality
* initial implementation of flipper api - very limited functionality right now (get/delete feature, boolean gate for feature) but more is on the way
* made it easy to remove a feature (https://github.com/jnunemaker/flipper/pull/126)
* add minitest shared tests for adapters that work the same as the shared specs for rspec (https://github.com/jnunemaker/flipper/pull/127)

## 0.7.5

* support for rails 5 beta/ rack 2 alpha
* fix uninitialized constant in rails generators
* fix adapter test for clear to ensure that feature is not deleted, only gates

## 0.7.4

* Add missing migration file to gemspec for flipper-active_record

## 0.7.3

* Add Flipper ActiveRecord adapter

## 0.7.2

* Add Flipper::UI.application_breadcrumb_href for setting breadcrumb back to original app from Flipper UI

## 0.7.1

* Fix bug where features with names that match static file routes were incorrectly routing to the file action (https://github.com/jnunemaker/flipper/issues/80)

## 0.7

* Added Flipper.groups and Flipper.group_names
* Changed percentage_of_random to percentage_of_time
* Added enable/disable convenience methods for all gates (ie: enable_group, enable_actor, enable_percentage_of_actors, enable_percentage_of_time)
* Added value convenience methods (ie: boolean_value, groups_value, actors_value, etc.)
* Added Feature#gate_values for getting typecast adapter gate values
* Added Feature#enabled_gates and #disabled_gates for getting the gates that are enabled/disabled for the feature
* Remove Feature#description
* Added Flipper::Adapters::PStore
* Moved memoizable decorator to instance variable storage from class level thread local stuff. Now not thread safe, but we can make a thread safe version later.

UI

* Totally new. Works like a charm.

Mongo

* Updated to latest driver (~> 2.0)

## 0.6.3

* Minor bug fixes

## 0.6.2

* Added Flipper.group_exists?

## 0.6.1

* Added statsd support for instrumentation.

## 0.4.0

* No longer use #id for detecting actors. You must now define #flipper_id on
  anything that you would like to behave as an actor.
* Strings are now used instead of Integers for Actor identifiers. More flexible
  and the only reason I used Integers was to do modulo for percentage of actors.
  Since percentage of actors now uses hashing, integer is no longer needed.
* Easy integration of instrumentation with AS::Notifications or anything similar.
* A bunch of stuff around inspecting and getting names/descriptions out of
  things to more easily figure out what is going on.
* Percentage of actors hash is now also seeded with feature name so the same
  actors don't get all features instantly.
