require 'net/http'
require 'uri'
require 'json'
require 'digest'

va = "1179000899"
apiKey = "QbGcoO0Qds9sQFDmY0MWg1Tq.xtuh1"

uri = URI.parse("https://sandbox.ipaymu.com/api/v2/payment")
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

key = 'key'
data = 'The quick brown fox jumps over the lazy dog'
digest = OpenSSL::Digest.new('sha256')

#=> "\xF7\xBC\x83\xF40S\x84$\xB12\x98\xE6\xAAo\xB1C\xEFMY\xA1IF\x17Y\x97G\x9D\xBC-\x1A<\xD8"

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