# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Rails.env.development?
  Account.destroy_all
  AccountDocument.destroy_all
  Category.destroy_all
  Document.destroy_all
  Pack.destroy_all
  User.destroy_all
  Subcategory.destroy_all
end

puts "👷🏼 Création des Users"
User.create(first_name: 'Marc', last_name: 'Delesalle', email: 'marc.delesalle@eligia.fr', password: '123456', admin: 'true')
User.create(first_name: 'Benjamin', last_name: 'Liet', email: 'benjamin.liet@eligia.fr', password: '123456', admin: 'true')
User.create(first_name: 'jane', last_name: 'doe', email: 'jane.doe@eligia.fr', password: '123456')
puts User.count == 3 ? "🟩 Users créées avec succès" : "🟥 Erreur dans la création des Users"


puts "👷🏼 Création des catégories"
Category.create(name: 'Telecom')
Category.create(name: 'Media')
Category.create(name: 'Energie')
puts Category.count == 3 ? "🟩 Catégories créées avec succès" : "🟥 Erreur dans la création des catégories"

puts "👷🏼 Création des sous-catégories"
Subcategory.create(name: 'Ligne mobile', category: Category.find_by(name: 'Telecom'))
Subcategory.create(name: 'Ligne fixe', category: Category.find_by(name: 'Telecom'))
Subcategory.create(name: 'Internet', category: Category.find_by(name: 'Telecom'))
Subcategory.create(name: 'Journaux', category: Category.find_by(name: 'Media'))
Subcategory.create(name: 'Télévision', category: Category.find_by(name: 'Media'))
puts Subcategory.count == 5 ? "🟩 Sous-catégories créées avec succès" : "🟥 Erreur dans la création des sous-catégories"

puts "👷🏼 Création des accounts"
Account.create(name: 'Free', category: Category.find_by(name: 'Telecom'), status: 'validated')
Account.create(name: 'Orange', category: Category.find_by(name: 'Telecom'), status: 'validated')
Account.create(name: 'SFR', category: Category.find_by(name: 'Telecom'), status: 'validated')
Account.create(name: 'Bouygues', category: Category.find_by(name: 'Telecom'), status: 'validated')
Account.create(name: 'Le Monde', category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: 'Libération', category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: 'Le Nouvel Obs', category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: 'Le Parisien', category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: 'Sud Ouest', category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: 'Ouest France', category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: "L'Equipe", category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: "Canal +", category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: "BeinSport", category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: "Tele 7 jours", category: Category.find_by(name: 'Media'), status: 'validated')
Account.create(name: 'EDF', category: Category.find_by(name: 'Energie'), status: 'validated')
Account.create(name: 'Engie', category: Category.find_by(name: 'Energie'), status: 'validated')
puts Account.count == 16 ? "🟩 Accounts créées avec succès" : "🟥 Erreur dans la création des accounts"

puts "👷🏼 Création des documents"
Document.create(name: 'Certificat de décès', format: 'pdf')
Document.create(name: 'Pièce identité', format: 'pdf')
Document.create(name: 'Justificatif domicile', format: 'pdf')
Document.create(name: 'IBAN', format: 'text')
Document.create(name: 'Relevé compteurs', format: 'text')
Document.create(name: 'Numéro Client', format: 'text')
Document.create(name: 'Adresse mail', format: 'text')
puts Document.count == 7 ? "🟩 Documents créées avec succès" : "🟥 Erreur dans la création des Documents"

puts "👷🏼 Création des AccountDocuments"
Account.all.each do |account|
  docsamples = Document.all.sample(rand(1..5))
  docsamples.each do |document|
    ad = AccountDocument.new(account: account, document: document)
    print "." if ad.save
  end
end
puts ""
puts "🟧 AccountDocuments done"

puts "👷🏼 Création des Packs"
Pack.create(title: 'Basic pack', price_cents: 10_000)
Pack.create(title: 'Premium pack', price_cents: 15_000)
Pack.create(title: 'Unlimited pack', price_cents: 20_000)
puts Pack.count == 3 ? "🟩 Packs créées avec succès" : "🟥 Erreur dans la création des Packs"
