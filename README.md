# Multipassify
Shopify Multipass module for Ruby

[Shopify](http://shopify.com) provides a mechanism for single sign-on known as Multipass.  Multipass uses an AES encrypted JSON hash and multipassify provides functions for generating tokens

More details on Multipass with Shopify can be found [here](http://docs.shopify.com/api/tutorials/multipass-login).

## Installation
<pre>
    gem install multipassify
</pre>

## Usage

To use Multipass an Enterprise / Plus plan is required. The Multipass secret can be found in your shop Admin (Settings > Checkout > Customer Accounts).
Make sure "Accounts are required" or "Accounts are optional" is selected and Multipass is enabled.

``` ruby
  require('multipassify');

  # Construct the Multipassify encoder
  multipassify = Multipassify.new("SHOPIFY MULTIPASS SECRET");

  # Create your customer data hash
  customer_data = { email: 'test@example.com', remote_ip:'USERS IP ADDRESS', return_to:"http://some.url"};

  # Encode a Multipass token
  token = multipassify.encode(customer_data);

  # Generate a Shopify multipass URL to your shop
  url = multipassify.generate_url(customer_data, "yourstorename.myshopify.com");

  # Generates a URL like:  https://yourstorename.myshopify.com/account/login/multipass/<MULTIPASS-TOKEN>
```

## Information & Credits
This is a Ruby Port from [GitHub - beaucoo/multipassify: Shopify Multipass module for Node.js](https://github.com/beaucoo/multipassify).
Credits to @beaucoo and Shopify Multipass documentation!
