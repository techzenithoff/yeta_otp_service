require 'openssl'
require 'json'
require 'securerandom'

# 1. Génération RSA 2048 bits
key = OpenSSL::PKey::RSA.new(2048)

puts "\n" + "="*50
puts "1. TA CLÉ PRIVÉE (SERVICE_PRIVATE_KEY)"
puts "="*50
# On transforme les sauts de ligne en \n textuels
puts key.to_pem.gsub("\n", "\\n")

puts "\n" + "="*50
puts "2. TA CLÉ PUBLIQUE (À mettre dans un fichier .pub)"
puts "="*50
puts key.public_key.to_pem

puts "\n" + "="*50
puts "ASTUCE : Copie le bloc 2 dans keys/profile-service.pub"
puts "="*50