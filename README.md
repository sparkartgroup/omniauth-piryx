# Omniauth Automatic Strategy

[![Build Status](https://travis-ci.org/SparkartGroupInc/omniauth-google-oauth2.png)](https://travis-ci.org/SparkartGroupInc/omniauth-google-oauth2)

[Piryx](http://www.piryx.com) [`omniauth`](http://rubygems.org/gems/omniauth) OAuth2 strategy.

## Installation

```
gem 'omniauth-piryx'
bundle
```

## Usage

Sign up for Piryx and [create an application](http://www.piryx.com/developers/). Once you have the client id and client secret associate them with the OmniAuth strategy.


### Example Integration

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :piryx, ENV["PIRYX_CLIENT_ID"], ENV["PIRYX_CLIENT_SECRET"], scope: "never_expire,create_payment,payment_details,payment_summary", sandbox: !Rails.env.production?
end
```

If a value for sandbox is not passed in the production API will always be used instead.

### Scopes

You can change the permissions by selecting from the [scopes available](http://dev.piryx.com/docs/oauth.html) and passing them into the configuration above. The default scopes set by this middleware are `create_payment` and `payment_details.`