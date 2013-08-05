require 'omniauth-wordpress'

describe OmniAuth::Strategies::Wordpress do
  before(:all) do
    OmniAuth.config.test_mode = true
  end

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

  describe '#client' do
    it 'should be initialized with symbolized client_options' do
      @options = { :client_options => { 'authorize_url' => 'https://example.com' } }
      subject.client.options[:authorize_url].should == 'https://example.com'
    end

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

  describe '#authorize_params' do
    it 'should include any authorize params passed in the :authorize_params option' do
      @options = { :authorize_params => { :foo => 'bar', :baz => 'zip' } }
      subject.authorize_params['foo'].should eq('bar')
      subject.authorize_params['baz'].should eq('zip')
    end

    it 'should include top-level options that are marked as :authorize_options' do
      @options = { :authorize_options => [:scope, :foo], :scope => 'bar', :foo => 'baz' }
      subject.authorize_params['scope'].should eq('bar')
      subject.authorize_params['foo'].should eq('baz')
    end
  end

  describe '#token_params' do
    it 'should include any authorize params passed in the :authorize_params option' do
      @options = { :token_params => { :foo => 'bar', :baz => 'zip' } }
      subject.token_params['foo'].should eq('bar')
      subject.token_params['baz'].should eq('zip')
    end

    it 'should include top-level options that are marked as :authorize_options' do
      @options = { :token_options => [:scope, :foo], :scope => 'bar', :foo => 'baz' }
      subject.token_params['scope'].should eq('bar')
      subject.token_params['foo'].should eq('baz')
    end
  end

end
