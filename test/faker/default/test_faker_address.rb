# frozen_string_literal: true

require_relative '../../test_helper'

class TestFakerAddress < Test::Unit::TestCase
  def setup
    @tester = Faker::Address
  end

  def test_city
    assert_match(/\w+/, @tester.city)
  end

  def test_city_with_state
    assert_match(/\w+,\s\w+/, @tester.city(options: { with_state: true }))
  end

  def test_street_name
    assert_match(/\w+\s\w+/, @tester.street_name)
  end

  def test_street_address
    assert_match(/\d+\s\w+\s\w+/, @tester.street_address)
  end

  def test_secondary_address
    assert_match(/\w+\.?\s\d+/, @tester.secondary_address)
  end

  def test_building_number
    assert_match(/\d+/, @tester.building_number)
  end

  def test_mail_box
    assert_match(/[\w ]+\d+/, @tester.mail_box)
  end

  def test_zip_code
    assert_match(/^\d+-?\d*$/, @tester.zip_code)
  end

  def test_time_zone
    assert_match %r{\w+/\w+}, @tester.time_zone
  end

  def test_street_suffix
    assert_match(/\w+/, @tester.street_suffix)
  end

  def test_city_suffix
    assert_match(/\w+/, @tester.city_suffix)
  end

  def test_city_prefix
    assert_match(/\w+/, @tester.city_prefix)
  end

  def test_state_abbr
    assert_match(/[A-Z]{2}/, @tester.state_abbr)
  end

  def test_state
    assert_match(/\w+/, @tester.state)
  end

  def test_country
    assert_match(/\w+/, @tester.country)
  end

  def test_country_by_code
    assert_match @tester.country_by_code(code: 'NL'), 'Netherlands'
  end

  def test_country_name_to_code
    assert_match @tester.country_name_to_code(name: 'united_states'), 'US'
  end

  def test_country_code
    assert_match(/[A-Z]{2}/, @tester.country_code)
  end

  def test_latitude
    assert_instance_of Float, @tester.latitude
  end

  def test_longitude
    assert_instance_of Float, @tester.longitude
  end

  def test_full_address
    assert_match(/\w*\.?\s?\d*\s?\d+\s\w+\s\w+,\s\w+\s?\w*,\s[A-Z]{2}\s\d+/, @tester.full_address)
  end

  def test_full_address_as_hash
    assert_instance_of Hash, @tester.full_address_as_hash
  end

  def test_full_address_as_hash_by_longitude
    assert_instance_of Float, @tester.full_address_as_hash(:longitude)[:longitude]
  end

  def test_full_address_as_hash_country_fields_are_consistent
    10.times do
      address = @tester.full_address_as_hash(:country, :country_code, :country_by_code, :country_name_to_code)

      assert_equal address[:country_code], address[:country_name_to_code]
      assert_equal address[:country], address[:country_by_code]
      assert_equal address[:country], @tester.country_by_code(code: address[:country_code])
    end
  end

  def test_full_address_as_hash_state_fields_are_consistent
    states = Faker::Base.fetch_all('address.state')
    abbreviations = Faker::Base.fetch_all('address.state_abbr')

    10.times do
      address = @tester.full_address_as_hash(:state, :state_abbr)

      assert_equal address[:state_abbr], abbreviations[states.index(address[:state])]
    end
  end

  def test_full_address_as_hash_zip_code_matches_the_state
    10.times do
      address = @tester.full_address_as_hash(:state, :state_abbr, :zip_code)

      assert_match(/\A\d{5}(-\d{4})?\z/, address[:zip_code])
      assert_match(/\A#{address[:zip_code][0, 3]}/, @tester.zip_code(state_abbreviation: address[:state_abbr]))
    end
  end

  def test_full_address_as_hash_derives_the_state_from_a_pinned_zip_code_state
    address = @tester.full_address_as_hash(:state, :state_abbr, :zip_code, zip_code: { state_abbreviation: 'CO' })

    assert_equal 'Colorado', address[:state]
    assert_equal 'CO', address[:state_abbr]
    assert_match(/\A800\d{2}(-\d{4})?\z/, address[:zip_code])
  end

  def test_full_address_as_hash_derives_country_from_a_pinned_country_code
    address = @tester.full_address_as_hash(:country, :country_code, country_by_code: { code: 'NL' })

    assert_equal 'Netherlands', address[:country]
    assert_equal 'NL', address[:country_code]
  end

  def test_full_address_as_hash_derives_country_from_a_pinned_country_name
    address = @tester.full_address_as_hash(:country, :country_name_to_code, country_name_to_code: { name: 'united_states' })

    assert_equal 'United States', address[:country]
    assert_equal 'US', address[:country_name_to_code]
  end

  def test_full_address_as_hash_does_not_change_single_field_values
    10.times do
      address = @tester.full_address_as_hash(:country, :zip_code)

      assert_instance_of String, address[:country]
      assert_match(/\A\d{5}(-\d{4})?\z/, address[:zip_code])
    end
  end

  def test_full_address_as_hash_keeps_aliases_in_sync
    address = @tester.full_address_as_hash(:zip, :postcode)

    assert_equal address[:zip], address[:postcode]
  end

  def test_full_address_as_hash_accepts_string_attributes
    address = @tester.full_address_as_hash('country', 'country_code')

    assert_equal address[:country], @tester.country_by_code(code: address[:country_code])
  end
end
