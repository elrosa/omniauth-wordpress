require 'spec_helper'
require 'omniauth-wordpress'

describe OmniAuth::Strategies::Wordpress do
  before :each do
    @request = double('Request')
    @request.stub(:params) { {} }
    @request.stub(:cookies) { {} }
    @request.stub(:env) { {} }

    @client_id = '123'
    @client_secret = '53cr3tz'
  end

  subject do
    args = [@client_id, @client_secret, @options].compact
    OmniAuth::Strategies::Wordpress.new(nil, *args).tap do |strategy|
      strategy.stub(:request) { @request }
    end
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'has correct Wordpress site' do
      subject.client.site.should eq('https://public-api.wordpress.com')
    end

    it 'has correct authorize url' do
      subject.client.options[:authorize_url].should eq('https://public-api.wordpress.com/oauth2/authorize')
    end

    it 'has correct token url' do
      subject.client.options[:token_url].should eq('https://public-api.wordpress.com/oauth2/token')
    end
  end

end
