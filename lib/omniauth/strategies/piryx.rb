require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Piryx < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "create_payment,payment_details"
      PRODUCTION_API = 'https://api.piryx.com'
      OLD_PRODUCTION_API = 'https://secure.piryx.com'
      SANDBOX_API = 'https://sandbox-api.piryx.com'
      OLD_SANDBOX_API = 'http://demo.secure.piryx.com'

      option :name, 'piryx'

      option :client_options, {
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/access_token'
      }

      option :authorize_options, [:response_type, :client_id, :redirect_uri, :scope]

      option :auth_token_params, {
        header_format: "OAuth %s",
        mode: :header,
        param_name: "oauth_token"
      }

      option :sandbox, false

      def client
        options.client_options[:site] ||= options.sandbox ? SANDBOX_API : PRODUCTION_API
        ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
      end

      def authorize_params
        super.tap do |params|
          options.authorize_options.each do |k|
            params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
          end

          raw_scope = params[:scope] || DEFAULT_SCOPE
          scope_list = raw_scope.split(" ").map {|item| item.split(",")}.flatten
          params[:scope] = scope_list.join(" ")
        end
      end

      uid { raw_info['Account']['Id'] }

      info do
        {
          name: raw_info['Account']['Name'],
          biography: raw_info['Account']['Biography'],
          location: raw_info['Account']['Location'],
          website_url: raw_info['Account']['WebsiteUrl']
        }
      end

      extra do
        hash = {}
        hash[:id_token] = access_token.token
        hash[:raw_info] = raw_info unless skip_info?
        hash
      end

      def raw_info
        api = options.sandbox ? OLD_SANDBOX_API : OLD_PRODUCTION_API
        @raw_info ||= access_token.get(File.join(api, "api/accounts/me")).parsed
      end
    end
  end
end