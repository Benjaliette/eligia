# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# if Rails.env.development?
#   Account.destroy_all
#   AccountDocument.destroy_all
#   Category.destroy_all
#   Document.destroy_all
#   Pack.destroy_all
#   User.destroy_all
#   Subcategory.destroy_all
# end

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
Subcategory.create(name: 'Electricite', category: Category.find_by(name: 'Energie'))
Subcategory.create(name: 'Gaz', category: Category.find_by(name: 'Energie'))
puts Subcategory.count == 7 ? "🟩 Sous-catégories créées avec succès" : "🟥 Erreur dans la création des sous-catégories"

puts "👷🏼 Création des accounts"
Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
Account.create(name: 'Orange', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
Account.create(name: 'SFR', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
Account.create(name: 'Bouygues', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
Account.create(name: 'Orange', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
Account.create(name: 'SFR', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
Account.create(name: 'Bouygues', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
Account.create(name: 'Orange', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
Account.create(name: 'SFR', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
Account.create(name: 'Bouygues', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
Account.create(name: 'Le Monde', subcategory: Subcategory.find_by(name: 'Journaux'), status: 'validated')
Account.create(name: 'Libération', subcategory: Subcategory.find_by(name: 'Journaux'), status: 'validated')
Account.create(name: 'Le Nouvel Obs', subcategory: Subcategory.find_by(name: 'Journaux'), status: 'validated')
Account.create(name: 'Le Parisien', subcategory: Subcategory.find_by(name: 'Journaux'), status: 'validated')
Account.create(name: 'Sud Ouest', subcategory: Subcategory.find_by(name: 'Journaux'), status: 'validated')
Account.create(name: 'Ouest France', subcategory: Subcategory.find_by(name: 'Journaux'), status: 'validated')
Account.create(name: "L'Equipe", subcategory: Subcategory.find_by(name: 'Journaux'), status: 'validated')
Account.create(name: "Canal +", subcategory: Subcategory.find_by(name: 'Télévision'), status: 'validated')
Account.create(name: "BeinSport", subcategory: Subcategory.find_by(name: 'Télévision'), status: 'validated')
Account.create(name: "Tele 7 jours", subcategory: Subcategory.find_by(name: 'Télévision'), status: 'validated')
Account.create(name: 'EDF', subcategory: Subcategory.find_by(name: 'Electricite'), status: 'validated')
Account.create(name: 'Engie', subcategory: Subcategory.find_by(name: 'Gaz'), status: 'validated')
puts Account.count == 24 ? "🟩 Accounts créées avec succès" : "🟥 Erreur dans la création des accounts"

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
Pack.create(
  title: 'Forfait initial',
  price: 100, level: 1,
  description: "Le forfait initial vous permet de résilier jusqu'à 7 comptes.
                Il est idéal si le défunt possédait peu de comptes ou si une
                personne tierce s'est déjà occupé de quelques résiliations"
)
Pack.create(
  title: 'Forfait premium',
  price: 160,
  level: 2,
  description: "Le forfait premium inclut la résiliation jusqu'à 15 comptes.
                Il est en général recommandé pour les démarches classiques"
)
Pack.create(
  title: 'Forfait illimité',
  price: 200,
  level: 3,
  description: "Le forfait illimité est un forfait qui vous permet de résilier
                tous les comptes de votre proche, sans compter leur nombre.
                Si ce dernier possédait un très grand nombre d'abonnements, c'est
                bien entendu vers ce forfait que nous vous conseillons d'aller"
)
puts Pack.count == 3 ? "🟩 Packs créées avec succès" : "🟥 Erreur dans la création des Packs"
