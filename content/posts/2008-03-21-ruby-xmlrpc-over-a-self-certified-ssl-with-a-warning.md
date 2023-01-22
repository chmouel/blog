---
title: Ruby XMLRPC over a Self Certified SSL with a warning
author: chmouel
date: 2008-03-21T16:56:05+00:00
url: /2008/03/21/ruby-xmlrpc-over-a-self-certified-ssl-with-a-warning/
dsq_thread_id:
  - 252039359
tags:
  - Programming
  - Ruby

---
If you use the XMLRPC client in ruby over a self certified SSL you have this warning :

 _warning: peer certificate won't be verified in this SSL session_ 

You can get override that warning cleanly (i have seen some people who just comment the message in the standard library) like that :


```ruby
require 'xmlrpc/client'

require 'net/https'
require 'openssl'
require 'pp'

module SELF_SSL
  class Net_HTTP < Net::HTTP
    def initialize(*args)
      super
      @ssl_context = OpenSSL::SSL::SSLContext.new
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  class XMLRPC_Client < XMLRPC::Client
    def initialize(*args)
      super
      @http = SELF_SSL::Net_HTTP.new( @host, @port,
                                      @proxy_host,@proxy_port )
      @http.use_ssl = @use_ssl if @use_ssl
      @http.read_timeout = @timeout
      @http.open_timeout = @timeout
    end

  end

end

if __FILE__ == $0
  f = SELF_SSL::XMLRPC_Client.new2("https://url")
  puts f.call("method", 'arg')
end

```
