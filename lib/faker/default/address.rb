# frozen_string_literal: true

module Faker
  class Address < Base
    flexible :address

    COUNTRY_ATTRIBUTES = %i[country country_code country_by_code country_name_to_code].freeze
    STATE_ATTRIBUTES = %i[state state_abbr].freeze
    POSTCODE_ATTRIBUTES = %i[zip_code zip postcode].freeze

    private_constant :COUNTRY_ATTRIBUTES, :STATE_ATTRIBUTES, :POSTCODE_ATTRIBUTES

    class << self
      ##
      # Produces the name of a city.
      #
      # @param options [Hash]
      # @option with_state [Boolean] Whether to include the state name in the output.
      # @return [String]
      #
      # @example
      #   Faker::Address.city #=> "Imogeneborough"
      #   Faker::Address.city(options: { with_state: true })
      #     #=> "Northfort, California"
      #
      # @faker.version 0.3.0
      def city(options: {})
        parse(options[:with_state] ? 'address.city_with_state' : 'address.city')
      end

      ##
      # Produces a street name.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.street_name #=> "Larkin Fork"
      #
      # @faker.version 0.3.0
      def street_name
        parse('address.street_name')
      end

      ##
      # Produces a street address.
      #
      # @param include_secondary [Boolean] Whether or not to include the secondary address.
      # @return [String]
      #
      # @example
      #   Faker::Address.street_address #=> "282 Kevin Brook"
      #
      # @faker.version 0.3.0
      def street_address(include_secondary: false)
        numerify(parse('address.street_address') + (include_secondary ? " #{secondary_address}" : ''))
      end

      ##
      # Produces a secondary address.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.secondary_address #=> "Apt. 672"
      #
      # @faker.version 0.3.0
      def secondary_address
        bothify(fetch('address.secondary_address'))
      end

      ##
      # Produces a building number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.building_number #=> "7304"
      #
      # @faker.version 0.3.0
      def building_number
        bothify(fetch('address.building_number'))
      end

      ##
      # Produces the name of a community.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.community #=> "University Crossing"
      #
      # @faker.version 1.8.0
      def community
        parse('address.community')
      end

      ##
      #
      # Produces a mail box number.
      # @return [String]
      #
      # @example
      #   Faker::Address.mail_box #=> "PO Box 123"
      #
      # @faker.version 2.9.1
      def mail_box
        bothify(fetch('address.mail_box'))
      end

      ##
      # Produces a Zip Code.
      #
      # @param state_abbreviation [String] an abbreviation for a state where the zip code should be located.
      # @return [String]
      #
      # @example
      #   Faker::Address.zip_code #=> "58517"
      #   Faker::Address.zip_code #=> "23285-4905"
      #   Faker::Address.zip_code(state_abbreviation: 'CO') #=> "80011"
      #
      # @faker.version 0.3.0
      def zip_code(state_abbreviation: '')
        if state_abbreviation.empty?
          letterified_string = letterify(fetch('address.postcode'))
          return numerify(letterified_string, leading_zero: true)
        end

        # provide a zip code that may be valid for the state provided
        # note: zip code may appear in the correct format for the state provided but may not be an actual state zip.
        bothify(fetch("address.postcode_by_state.#{state_abbreviation}"))
      end

      ##
      # Produces the name of a time zone.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.time_zone #=> "Asia/Yakutsk"
      #
      # @faker.version 1.2.0
      def time_zone
        fetch('address.time_zone')
      end

      alias zip zip_code
      alias postcode zip_code

      ##
      # Produces a street suffix.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.street_suffix #=> "Street"
      #
      # @faker.version 0.3.0
      def street_suffix
        fetch('address.street_suffix')
      end

      ##
      # Produces a city suffix.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.city_suffix #=> "fort"
      #
      # @faker.version 0.3.0
      def city_suffix
        fetch('address.city_suffix')
      end

      ##
      # Produces a city prefix.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.city_prefix #=> "Lake"
      #
      # @faker.version 0.3.0
      def city_prefix
        fetch('address.city_prefix')
      end

      ##
      # Produces a state abbreviation.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.state_abbr #=> "AP"
      #
      # @faker.version 0.3.0
      def state_abbr
        fetch('address.state_abbr')
      end

      ##
      # Produces the name of a state.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.state #=> "California"
      #
      # @faker.version 0.3.0
      def state
        fetch('address.state')
      end

      ##
      # Produces the name of a country.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.country #=> "French Guiana"
      #
      # @faker.version 0.3.0
      def country
        fetch('address.country')
      end

      ##
      # Produces a country by ISO country code. See the
      # [List of ISO 3166 country codes](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
      # on Wikipedia for a full list.
      #
      # @param code [String] An ISO country code.
      # @return [String]
      #
      # @example
      #   Faker::Address.country_by_code(code: 'NL') #=> "Netherlands"
      #
      # @faker.version 1.9.2
      def country_by_code(code: 'US')
        fetch("address.country_by_code.#{code}")
      end

      ##
      # Produces an ISO 3166 country code when given a country name.
      #
      # @param name [String] Country name in snake_case format.
      # @return [String]
      #
      # @example
      #   Faker::Address.country_name_to_code(name: 'united_states') #=> "US"
      #
      # @faker.version 1.9.2
      def country_name_to_code(name: 'united_states')
        fetch("address.country_by_name.#{name}")
      end

      ##
      # Produces an ISO 3166 country code.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.country_code #=> "IT"
      #
      # @faker.version 1.4.0
      def country_code
        fetch('address.country_code')
      end

      ##
      # Produces a long (alpha-3) ISO 3166 country code.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.country_code_long #=> "ITA"
      #
      # @faker.version 0.3.0
      def country_code_long
        fetch('address.country_code_long')
      end

      ##
      # Produces a latitude.
      #
      # @return [Float]
      #
      # @example
      #   Faker::Address.latitude #=> -58.17256227443719
      #
      # @faker.version 1.0.0
      def latitude
        ((rand * 180) - 90).to_f
      end

      ##
      # Produces a longitude.
      #
      # @return [Float]
      #
      # @example
      #   Faker::Address.longitude #=> -156.65548382095133
      #
      # @faker.version 1.0.0
      def longitude
        ((rand * 360) - 180).to_f
      end

      ##
      # Produces a full address.
      #
      # @return [String]
      #
      # @example
      #   Faker::Address.full_address
      #     #=> "282 Kevin Brook, Imogeneborough, CA 58517"
      #
      # @faker.version 0.3.0
      def full_address
        parse('address.full_address')
      end

      ##
      # Produces Address hash of required fields.
      #
      # Related fields are drawn from a single address, so that they stay
      # consistent with each other: +country+, +country_code+ and
      # +country_name_to_code+ describe the same country, +state+ and
      # +state_abbr+ describe the same state, and +zip_code+ (as well as its
      # +zip+ and +postcode+ aliases) uses the format of the generated state.
      #
      # Pinning one field also pins the ones it implies. For example, passing
      # +country_name_to_code: { name: 'united_states' } makes +country+ and
      # +country_code+ describe the United States too, and passing
      # +zip_code: { state_abbreviation: 'CO' } makes +state+ and +state_abbr+
      # describe Colorado.
      #
      # @return [Hash]
      #
      # @example
      #   Faker::Address.full_address_as_hash(:longitude,
      #                                       :latitude,
      #                                       :country_name_to_code,
      #                                       country_name_to_code: {name: 'united_states'})
      #     #=> {:longitude=>-101.74428917174603, :latitude=>-37.40056749089944, :country_name_to_code=>"US"}
      #
      #  Faker::Address.full_address_as_hash(:full_address)
      #     #=> {:full_address=>"87635 Rice Street, Lake Brentonton, OR 61896-5968"}
      #
      #  Faker::Address.full_address_as_hash(:city, :time_zone)
      #     #=> {:city=>"East Faustina", :time_zone=>"America/Mexico_City"}
      #
      #  Faker::Address.full_address_as_hash(:street_address, street_address: {include_secondary: true})
      #     #=> {:street_address=>"29423 Kenneth Causeway Suite 563"}
      #
      #  Faker::Address.full_address_as_hash(:country, :country_code, :state, :state_abbr, :zip_code)
      #     #=> {:country=>"Peru", :country_code=>"PE", :state=>"California", :state_abbr=>"CA", :zip_code=>"90073"}
      #
      #  Faker::Address.full_address_as_hash(:state, :state_abbr, :zip_code, zip_code: {state_abbreviation: 'CO'})
      #     #=> {:state=>"Colorado", :state_abbr=>"CO", :zip_code=>"80082"}
      #
      # @faker.version 2.13.0
      def full_address_as_hash(*attrs, **attrs_params)
        attrs.map!(&:to_sym)
        attrs_params.transform_keys!(&:to_sym)

        context = consistent_address_context(attrs, attrs_params)

        attrs.map do |attr|
          value = if attrs_params[attr]
                    send(attr, **attrs_params[attr])
                  elsif context.key?(attr)
                    context[attr]
                  else
                    send(attr)
                  end
          { "#{attr}": value }
        end.reduce({}, :merge)
      end

      private

      # Builds the values of all requested fields that have to agree with each
      # other. Fields whose data is missing in the current locale are left out,
      # so they keep their previous, independent behavior.
      def consistent_address_context(attrs, attrs_params)
        country_fields = attrs & COUNTRY_ATTRIBUTES
        state_fields = attrs & STATE_ATTRIBUTES
        postcode_fields = attrs & POSTCODE_ATTRIBUTES
        pinned_abbr = pinned_state_abbreviation(attrs_params)

        context = {}
        if country_fields.size > 1 || pinned_country?(attrs_params)
          context.merge!(consistent_country(attrs_params))
        end

        if state_fields.size > 1 || (state_fields.any? && postcode_fields.any?)
          context.merge!(consistent_state(pinned_abbr))
        end

        if postcode_fields.size > 1 || (postcode_fields.any? && state_fields.any?)
          context.merge!(consistent_postcode(pinned_abbr || context[:state_abbr]))
        end

        context
      end

      # Whether the caller passed one of the country arguments that the other
      # country fields should be derived from.
      def pinned_country?(attrs_params)
        attrs_params[:country_by_code]&.key?(:code) || attrs_params[:country_name_to_code]&.key?(:name)
      end

      # The state abbreviation the caller pinned through +zip_code+'s
      # +state_abbreviation+ argument, if any.
      def pinned_state_abbreviation(attrs_params)
        pinned = POSTCODE_ATTRIBUTES.filter_map { |attr| attrs_params[attr]&.dig(:state_abbreviation) }
        pinned.reject { |abbr| abbr.to_s.empty? }.first
      end

      # Returns the country name and code of the same country. When the caller
      # pinned a country, that country is used; otherwise one is picked from the
      # country/code mapping that applies to the locale.
      def consistent_country(attrs_params)
        locale = country_mapping_locale
        code = pinned_country_code(attrs_params)

        if code
          code = code.to_s
          name = translate("faker.address.country_by_code.#{code}", locale: locale)
        else
          code, name = sample(translate('faker.address.country_by_code', locale: locale).to_a)
          code = code.to_s
        end

        { country: name, country_code: code, country_by_code: name, country_name_to_code: code }
      end

      # The locale whose country/code mapping is used to keep the country fields
      # consistent. It is the current locale when it has its own mapping, and
      # English otherwise, because the country code always falls back to English
      # when a locale has no mapping of its own. The country name is then taken
      # from the same mapping, so name and code always describe the same place.
      def country_mapping_locale
        locale = Faker::Config.locale
        return locale if locale_translation?('address.country_by_code', locale: locale)

        :en
      end

      def pinned_country_code(attrs_params)
        if attrs_params[:country_by_code]&.key?(:code)
          attrs_params[:country_by_code][:code]
        elsif attrs_params[:country_name_to_code]&.key?(:name)
          country_name_to_code(**attrs_params[:country_name_to_code])
        end
      end

      # Pairs a state name with its abbreviation. Both lists have to describe the
      # same places and line up, so this only pairs them when the locale defines
      # both or when the one it defines is the English list that the other one
      # falls back to. Otherwise the fields keep their previous, independent
      # behavior.
      def consistent_state(pinned_abbr = nil)
        return {} unless same_state_data_source?

        states = Array(translate('faker.address.state'))
        abbreviations = Array(translate('faker.address.state_abbr'))
        return {} unless states.size == abbreviations.size && states.size > 1

        index = pinned_abbr ? abbreviations.index(pinned_abbr) : rand(states.size)
        return {} if index.nil?

        { state: states[index], state_abbr: abbreviations[index] }
      end

      # Whether the state and abbreviation lists come from the same source. A
      # locale that defines one of them gets the other one from the English
      # fallback, which is only the same list when the defined one is English
      # too (as in en-US, which overrides only the abbreviations).
      def same_state_data_source?
        locale = Faker::Config.locale
        own_state = locale_translation?('address.state', locale: locale)
        own_abbr = locale_translation?('address.state_abbr', locale: locale)
        return true if own_state == own_abbr

        defined_key = own_state ? 'address.state' : 'address.state_abbr'
        Array(translate("faker.#{defined_key}")) == Array(translate("faker.#{defined_key}", locale: :en))
      end

      # Uses the postcode format of the generated state when the locale knows
      # one, so that the postcode agrees with the state.
      def consistent_postcode(state_abbr)
        value = if state_abbr && locale_translation?("address.postcode_by_state.#{state_abbr}", locale: Faker::Config.locale)
                  zip_code(state_abbreviation: state_abbr)
                else
                  zip_code
                end

        { zip_code: value, zip: value, postcode: value }
      end

      # Whether the given locale defines the translation itself, rather than
      # inheriting the English one through Faker's fallback.
      def locale_translation?(key, locale: Faker::Config.locale)
        I18n.exists?("faker.#{key}", locale: locale)
      end
    end
  end
end
