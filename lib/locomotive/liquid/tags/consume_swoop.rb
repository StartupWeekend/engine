module Locomotive
  module Liquid
    module Tags
      # Extends the `consume` tag to make SWOOP syndication easier
      # to perform
      #
      # Serves as a SWOOP API proxy, handling things like basic auth, base URLs,
      # and query string building
      #
      # Recognizes the following API endpoints:
      #
      # * "events"
      # * "people"
      #
      # Usage:
      #
      # {% consume_swoop events from 'events' city: 'Seattle', since: '2014-01-01' %}
      #   {% for event in events %}
      #   {% endfor %}
      # {% endconsume_swoop %}
      class ConsumeSwoop < Consume

        def initialize(tag_name, markup, tokens, context)
          super
        end

        # If a URL is passed, prepend the SWOOP base URL before passing the value
        # back to the base class
        # def new_prepare_url(token)
        #alias_method :original_prepare_url, :prepare_url
        def prepare_url(token)
          known_endpoints = /events|people/
          if token.match(::Liquid::QuotedString) and token =~ known_endpoints
            # Prepend base URL for URL values passed in
            token = token.gsub(/['"]/, '')

            # Drop leading slash if present
            token = token.slice(1, token.length) if token[0] == "/"

            # Prepend value and wrap in quotes before passing along
            token = "'https://swoop.up.co/#{ token }'"
          end

          # Delegate back to base implementation
          super(token)
        end

      end

      ::Liquid::Template.register_tag('consume_swoop', ConsumeSwoop)
    end
  end
end
