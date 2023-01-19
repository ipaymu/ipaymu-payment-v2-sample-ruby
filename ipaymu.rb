require 'net/http'
require 'uri'
require 'json'
require 'digest'

va = "1179000899"
apiKey = "QbGcoO0Qds9sQFDmY0MWg1Tq.xtuh1"

uri = URI.parse("https://sandbox.ipaymu.com/api/v2/payment")
# uri = URI.parse("https://my.ipaymu.com/api/v2/payment")

request = Net::HTTP::Post.new(uri)


body = JSON.dump({
  "username" => "xyz",
  "password" => "xyz"
})

body = JSON.dump({
  "product" => [
    "T-Shirt",
    "Jacket"
  ],
  "qty" => [
    "2",
    "1"
  ],
  "price" => [
    "50000",
    "100000"
  ],
  "description" => [
    "Size M",
    "Size L"
  ],
  "returnUrl" => "https://your-website.com/thank-you-page",
  "cancelUrl" => "https://your-website.com/cancel-payment-page",
  "notifyUrl" => "https://your-website.com/callback-url",
  "referenceId" => "1234",
  "buyerName" => "Putu",
  "buyerEmail" => "putu@test.com",
  "buyerPhone" => "08123456789",
})

bodyHash   = Digest::SHA256.hexdigest(body)
bodyHash   = bodyHash.downcase

stringToSign = "POST:" + va + ":" + bodyHash + ":" + apiKey

digest = OpenSSL::Digest.new('sha256')


signature = OpenSSL::HMAC.hexdigest(digest, apiKey, stringToSign)

request.content_type = "application/json"
request["Accept-Charset"] = "application/json"
request["va"] = va
request["signature"] = signature

request.body = body
req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)

end

puts response.body

# response.code
# response.body
