# Oauth2China

Weibo OAuth2 API Ruby wrapper. 
Currently support Sina and Tencent Weibo APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'oauth2_china'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oauth2_china

## Usage

Oauth2China::Sina.new("ACCESS_TOKEN").statuses_update "hello world"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
