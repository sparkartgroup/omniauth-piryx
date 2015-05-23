require 'spec_helper'

describe OmniAuth::Strategies::Piryx do
  let(:request) { double('Request', params: {}, cookies: {}, env: {}) }
  let(:app) {
    lambda do
      [200, {}, ["Hello World"]]
    end
  }

  subject do
    OmniAuth::Strategies::Piryx.new(app, 'appid', 'secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe 'client_options' do
    context 'when sandbox is true' do
      before { subject.options[:sandbox] = true }

      it 'has correct site' do
        expect(subject.client.site).to eq('https://sandbox-api.piryx.com')
      end
    end

    context 'when sandbox is false' do
      before { subject.options[:sandbox] = false }

      it 'has correct site' do
        expect(subject.client.site).to eq('https://api.piryx.com')
      end
    end

    it 'has correct authorize_url' do
      expect(subject.client.options[:authorize_url]).to eq('/oauth/authorize')
    end

    it 'has correct token_url' do
      expect(subject.client.options[:token_url]).to eq('/oauth/access_token')
    end
  end

  describe "authorize_params" do
    it 'should support persist authorized parameters' do
      @options = {
        response_type: "response_type", client_id: "client_id",
        redirect_uri: "redirect_uri", scope: "scope", invalid: "invalid"
      }

      expect(subject.authorize_params['response_type']).to eq('response_type')
      expect(subject.authorize_params['redirect_uri']).to eq('redirect_uri')
      expect(subject.authorize_params['scope']).to eq('scope')
      expect(subject.authorize_params['invalid']).to eq(nil)
    end
  end

  describe 'extra' do
    let(:client) do
      OAuth2::Client.new('abc', 'def') do |builder|
        builder.request :url_encoded
        builder.adapter :test do |stub|
          stub.get('/api/accounts/me') do |env|
            [
              200,
              {'content-type' => 'application/json'},
              '{"Account": {"Name": "George", "Biography": "None", "Location": "Heaven", "WebsiteUrl": "http://www.example.com"}}'
            ]
          end
        end
      end
    end

    let(:access_token) { OAuth2::AccessToken.from_hash(client, {}) }
    before { allow(subject).to receive(:access_token).and_return(access_token) }

    describe 'info' do
      it 'should populate info' do
        expect(subject.info[:name]).to eq("George")
        expect(subject.info[:biography]).to eq("None")
        expect(subject.info[:location]).to eq("Heaven")
        expect(subject.info[:website_url]).to eq("http://www.example.com")
      end
    end

    describe 'raw_info' do
      context 'when skip_info is true' do
        before { subject.options[:skip_info] = true }

        it 'should not include raw_info' do
          expect(subject.extra).not_to have_key(:raw_info)
        end
      end

      context 'when skip_info is false' do
        before { subject.options[:skip_info] = false }

        it 'should include raw_info' do
          expect(subject.extra[:raw_info]).to eq({"Account"=>{"Name"=>"George", "Biography"=>"None", "Location"=>"Heaven", "WebsiteUrl"=>"http://www.example.com"}})
        end
      end
    end
  end
end