require 'omniauth-oauth2'
require 'multi_json'


module OmniAuth
  module Strategies
    class Wordpress < OmniAuth::Strategies::OAuth2

      option :client_options, {
        :site => 'https://public-api.wordpress.com',
        :authorize_url => '/oauth2/authorize',
        :token_url => '/oauth2/access_token'
      }
      option :access_token_options, {
        :header_format => 'OAuth %s',
        :param_name => 'access_token'
      }

      uid { raw_info['id'] }

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

      credentials do
        {
          'expires' => access_token.expires?,
          'expires_at' => access_token.expires_at
        }
      end

      def build_access_token
        super.tap do |token|
          token.options.merge!(access_token_options)
        end
      end

      def access_token_options
        options.access_token_options.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
      end

      def raw_info
        @raw_info ||= access_token.get("/me").parsed
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      def request_phase
        options[:authorize_params] = client_params.merge(options[:authorize_params])
        super
      end

      def auth_hash
        OmniAuth::Utils.deep_merge(super, client_params.merge({
          :grant_type => 'authorization_code'}))
      end

      private

      def client_params
        {:client_id => options[:client_id], :redirect_uri => callback_url ,:response_type => "code"}
      end

    end

  end
end


OmniAuth.config.add_camelization 'wordpress', 'Wordpress'

