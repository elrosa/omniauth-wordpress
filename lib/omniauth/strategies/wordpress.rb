require 'omniauth-oauth2'
require 'multi_json'

class OmniAuth::Strategies::Wordpress < OmniAuth::Strategies::OAuth2
  option :name, "wordpress"
  option :client_options, {
      :site => "https://public-api.wordpress.com",
      :authorize_url => 'https://public-api.wordpress.com/oauth2/authorize',
      :token_url => 'https://public-api.wordpress.com/oauth2/token',
      :user_url => '/oauth/me'
  }

  option :token_params, {
      :parse => :json
  }

  uid { access_token.params['blog_id'] }

  info do
    {
        :uid => access_token.params['blog_id'],
        :blog_url => access_token.params['blog_url'],
        :nickname => raw_info['username'],
        :name => raw_info['display_name'],
        :user_id => access_token['ID'],
        :image => raw_info['avatar_URL'],
        :website => raw_info['profile_URL'],
        :email => raw_info['email']
    }
  end

  extra do
    {'raw_info' => raw_info.merge(access_token.params)}
  end

  def raw_info
    response = access_token.get(client.options[:user_url])
    @raw_info ||= MultiJson.decode(response.body)
  rescue MultiJson::ParseError
    error = ::OAuth2::Error.new(response)
    fail(error, "Could not parse response from user url")
  rescue ::Errno::ETIMEDOUT
    raise ::Timeout::Error
  end
end
