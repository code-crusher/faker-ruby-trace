# frozen_string_literal: true

require_relative 'test_helper'

# Issue #2720: Faker previously fell back to the +Random+ module, whose
# global state is shared with +Kernel#rand+, +srand+, +Array#sample+, etc.
# The values a test received therefore depended on how many random calls
# every preceding test in the process happened to make -- a hidden global
# counter creating order dependencies between tests and pathological data
# for "rspec --bisect".
#
# The fallback is now a dedicated Random instance, private to Faker: global
# RNG activity cannot shift Faker's output, and Faker cannot shift the
# global RNG.
class TestFakerConfigRandom < Test::Unit::TestCase
  def teardown
    Faker::Config.random = nil
  end

  def test_fallback_random_is_an_instance_not_the_random_module
    Faker::Config.random = nil

    assert_instance_of Random, Faker::Config.random
    assert_not_same Random, Faker::Config.random
  end

  def test_fallback_random_is_stable_across_calls
    Faker::Config.random = nil

    assert_same Faker::Config.random, Faker::Config.random
  end

  def test_faker_does_not_advance_the_global_prng
    srand(42)
    expected = Random.rand(100)

    srand(42)
    25.times { Faker::Number.digit }
    actual = Random.rand(100)

    assert_equal expected, actual,
                 'Faker advanced Ruby\'s global PRNG state'
  end

  def test_global_prng_activity_does_not_shift_faker_random
    Faker::Config.random = nil
    fallback = Faker::Config.random

    srand(1234)
    100.times { rand }
    Array.new(100) { |i| i }.sample
    Array.new(100) { |i| i }.shuffle

    assert_same fallback, Faker::Config.random
  end

  def test_setting_random_still_takes_precedence_over_the_fallback
    random = Random.new(1234)
    Faker::Config.random = random

    assert_same random, Faker::Config.random
  end
end
