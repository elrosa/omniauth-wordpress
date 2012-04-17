require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Wordpress < OmniAuth::Strategies::OAuth2
      option :name, "wordpress"

      option :client_options, {
        :site => 'https://public-api.wordpress.com',
        :authorize_url => '/oauth2/authorize',
        :token_url => '/oauth2/access_token'
      }

      uid{ raw_info['id'] }

      info do
        {
          :id => raw_info['id'],
          :display_name => raw_info['display_name'],
          :username => raw_info['username'],
          :profile_image_url => raw_info['avatar_URL'],
          :profile_url => raw_info['profile_URL']
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get("/me").body)
      end

    end

  end
end


OmniAuth.config.add_camelization 'wordpress', 'Wordpress'

