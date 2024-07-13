# config/initializers/openssl.rb
OpenSSL::SSL::SSLContext::DEFAULT_CERT_STORE.add_file('/etc/ssl/certs/ca-certificates.crt')
