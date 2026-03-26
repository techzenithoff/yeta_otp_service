require 'json'

KEYS_DIRECTORY = "./keys"

def generate_catalog
  unless Dir.exist?(KEYS_DIRECTORY)
    puts "Erreur : Le dossier #{KEYS_DIRECTORY} n'existe pas."
    return
  end

  catalog = {}

  Dir.glob("#{KEYS_DIRECTORY}/*.pub").each do |file_path|
    service_name = File.basename(file_path, ".pub")
    # On lit le contenu et on s'assure que c'est une seule ligne avec \n
    key_content = File.read(file_path).strip.gsub("\n", "\\n")
    catalog[service_name] = key_content
  end

  puts "\n" + "="*60
  puts "COPIE CETTE LIGNE DANS TON .ENV (PUBLIC_KEYS_JSON)"
  puts "="*60
  # On utilise le format single quote pour protéger le JSON dans le shell
  puts "PUBLIC_KEYS_JSON='#{catalog.to_json}'"
end

generate_catalog