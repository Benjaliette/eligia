if Rails.env.development?
  Notification.destroy_all
  Order.destroy_all
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
Category.create(name: 'Télécoms')
Category.create(name: 'Médias')
Category.create(name: 'Comptes en ligne')
Category.create(name: 'Énergie')
Category.create(name: 'Divers')
puts Category.count == 5 ? "🟩 Catégories créées avec succès" : "🟥 Erreur dans la création des catégories"

puts "👷🏼 Création des sous-catégories"
Subcategory.create(name: 'Ligne mobile', category: Category.find_by(name: 'Télécoms'))
Subcategory.create(name: 'Ligne fixe', category: Category.find_by(name: 'Télécoms'))
Subcategory.create(name: 'Internet', category: Category.find_by(name: 'Télécoms'))
Subcategory.create(name: 'Journaux/Magazines', category: Category.find_by(name: 'Médias'))
Subcategory.create(name: 'Télévision', category: Category.find_by(name: 'Médias'))
Subcategory.create(name: 'Plateformes de streaming', category: Category.find_by(name: 'Médias'))
Subcategory.create(name: 'Réseaux sociaux', category: Category.find_by(name: 'Comptes en ligne'))
Subcategory.create(name: 'Divers', category: Category.find_by(name: 'Comptes en ligne'))
Subcategory.create(name: 'Électricité', category: Category.find_by(name: 'Énergie'))
Subcategory.create(name: 'Gaz', category: Category.find_by(name: 'Énergie'))
Subcategory.create(name: 'Eau', category: Category.find_by(name: 'Énergie'))
Subcategory.create(name: 'Transports', category: Category.find_by(name: 'Divers'))
Subcategory.create(name: 'Autres', category: Category.find_by(name: 'Divers'))
puts Subcategory.count == 13 ? "🟩 Sous-catégories créées avec succès" : "🟥 Erreur dans la création des sous-catégories"

puts "👷🏼 Création des documents"
acte_deces = Document.create(name: 'Certificat de décès', format: 'pdf')
piece_identite = Document.create(name: "Pièce d'identité (héritier)", format: 'pdf')
justificatif_domicile = Document.create(name: 'Justificatif domicile (défunt)', format: 'pdf')
iban = Document.create(name: 'IBAN', format: 'text')
compteur_gaz = Document.create(name: 'Relevé du compteur de gaz', format: 'text')
compteur_elec = Document.create(name: "Relevé du compteur d'électricité", format: 'text')
compteur_eau = Document.create(name: "Relevé du compteur d'eau", format: 'text')
numero_client = Document.create(name: 'Numéro Client', format: 'text')
numero_telephone_mobile = Document.create(name: 'Numéro de téléphone mobile (défunt)', format: 'text')
numero_telephone_fixe = Document.create(name: 'Numéro de téléphone fixe (défunt)', format: 'text')
mail = Document.create(name: 'Adresse mail (défunt)', format: 'text')
numero_contrat = Document.create(name: 'Numéro de contrat', format: 'text')
numero_contrat_sfr = Document.create(name: 'Numéro de contrat SFR', format: 'text')
numero_contrat_red = Document.create(name: 'Numéro de contrat RED by SFR', format: 'text')
numero_contrat_nordnet = Document.create(name: 'Numéro de contrat Nordnet', format: 'text')
numero_contrat_sosh = Document.create(name: 'Numéro de contrat Sosh', format: 'text')
numero_contrat_bouygues = Document.create(name: 'Numéro de contrat Bouygues', format: 'text')
numero_contrat_sncf = Document.create(name: 'Numéro de contrat SNCF', format: 'text')
numero_contrat_tbm = Document.create(name: 'Numéro de contrat TBM', format: 'text')
numero_contrat_ratp = Document.create(name: 'Numéro de contrat RATP', format: 'text')
numero_contrat_tan = Document.create(name: 'Numéro de contrat TAN', format: 'text')
numero_contrat_tag = Document.create(name: 'Numéro de contrat TAG', format: 'text')
numero_contrat_tcl = Document.create(name: 'Numéro de contrat TCL', format: 'text')
numero_contrat_rtm = Document.create(name: 'Numéro de contrat RTM', format: 'text')
puts Document.count == 24 ? "🟩 Documents créées avec succès" : "🟥 Erreur dans la création des Documents"

puts "👷🏼 Création des accounts"

account = Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_mobile)

account = Account.create(name: 'Orange', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: piece_identite)
AccountDocument.create(account: account, document: numero_telephone_mobile)

account = Account.create(name: 'Sosh', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_mobile)

account = Account.create(name: 'SFR', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_contrat_sfr)
AccountDocument.create(account: account, document: numero_telephone_mobile)

account = Account.create(name: 'RED By SFR', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_mobile)

account = Account.create(name: 'La Poste Mobile', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_mobile)

account = Account.create(name: 'Prixtel', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_mobile)

account = Account.create(name: 'Coriolis', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_mobile)

account = Account.create(name: 'Bouygues Télécom', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_mobile)

account = Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_fixe)

account = Account.create(name: 'Orange', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: piece_identite)
AccountDocument.create(account: account, document: numero_telephone_fixe)

account = Account.create(name: 'Sosh', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_fixe)

account = Account.create(name: 'SFR', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_contrat_sfr)
AccountDocument.create(account: account, document: numero_telephone_fixe)

account = Account.create(name: 'RED By SFR', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_fixe)

account = Account.create(name: 'Coriolis', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_fixe)

account = Account.create(name: 'Bouygues', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')

AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_telephone_fixe)

account = Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)

account = Account.create(name: 'Orange', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: piece_identite)

account = Account.create(name: 'Sosh', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_contrat_sosh)

account = Account.create(name: 'SFR', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_contrat_sfr)

account = Account.create(name: 'RED By SFR', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_contrat_red)

account = Account.create(name: 'Bouygues', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_contrat_bouygues)

account = Account.create(name: 'Nordnet', subcategory: Subcategory.find_by(name: 'Internet'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: numero_contrat_nordnet)

account = Account.create(name: 'Le Monde', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: 'Le Figaro', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: 'Libération', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: 'Le Nouvel Obs', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: 'Le Parisien', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: 'Sud Ouest', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: 'Ouest France', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "L'Equipe", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Les échos", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "La croix", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "L'humanité", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "L'opinion", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "L'est républicain", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Le dauphiné libéré", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "DNA", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "La provence", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Nice matin", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "La dépêche du Midi", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Ouest-France", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "TV Magazine", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Fémina", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télé 7 jours", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télé Z", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télé star", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télé loisirs", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Paris Match", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Femme Actuelle", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télérama", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télécable Sat Hebdo", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Madame Figaro", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Le Figaro Magazine", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télé Poche", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Le canard enchaîné", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Elle", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Le Point", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Auto Plus", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "L'Obs", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Voici", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "L'express", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Closer", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Challenges", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Gala", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Courrier international", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Journal du dimanche", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Public", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télé Magazine", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Marianne", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Grazia", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Valeurs actuelles", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "France Football", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Charlie Hebdo", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Midi Olympique", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Les inrockuptibles", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télé 2 Semaines", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Notre Temps", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Santé magazine", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Marie Claire", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Top Santé", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Cosmopolitan", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Prima", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Sciences & Avenir", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Le chasseur français", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Ça m'intéresse", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Biba", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Science et vie", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Capital", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Géo", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Le monde diplomatique", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Auto Moto", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Télé 7 jeux", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Vogue", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Première", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Vanity Fair", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "GQ", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "So Foot", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
AccountDocument.create(account: account, document: numero_abonne)

account = Account.create(name: "Canal +", subcategory: Subcategory.find_by(name: 'Télévision'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "BeinSport", subcategory: Subcategory.find_by(name: 'Télévision'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Canalsat", subcategory: Subcategory.find_by(name: 'Télévision'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "OCS", subcategory: Subcategory.find_by(name: 'Télévision'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Fransat", subcategory: Subcategory.find_by(name: 'Télévision'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Canalsat", subcategory: Subcategory.find_by(name: 'Télévision'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Netflix", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Amazon Prime Vidéo", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Disney plus", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Apple TV", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Filmo", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Salto", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: iban)

account = Account.create(name: "Facebook", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)

account = Account.create(name: "Twitter", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)

account = Account.create(name: "Instagram", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)

account = Account.create(name: "Snapchat", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)

account = Account.create(name: "Tik Tok", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)

account = Account.create(name: "Twitch", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)

account = Account.create(name: "Google", subcategory: Subcategory.find_by(name: 'Divers'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)

account = Account.create(name: "Amazon", subcategory: Subcategory.find_by(name: 'Divers'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)

account = Account.create(name: "CDiscount", subcategory: Subcategory.find_by(name: 'Divers'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)

account = Account.create(name: 'EDF', subcategory: Subcategory.find_by(name: 'Électricité'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_elec)

account = Account.create(name: 'TotalEnergies', subcategory: Subcategory.find_by(name: 'Électricité'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_elec)

account = Account.create(name: 'Cdiscount énergie', subcategory: Subcategory.find_by(name: 'Électricité'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_elec)

account = Account.create(name: 'Happ-e', subcategory: Subcategory.find_by(name: 'Électricité'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_elec)

account = Account.create(name: 'Sowee', subcategory: Subcategory.find_by(name: 'Électricité'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_elec)

account = Account.create(name: 'GEG', subcategory: Subcategory.find_by(name: 'Électricité'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_elec)

account = Account.create(name: 'Engie', subcategory: Subcategory.find_by(name: 'Gaz'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_gaz)

account = Account.create(name: 'eni', subcategory: Subcategory.find_by(name: 'Gaz'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_gaz)

account = Account.create(name: 'Happ-e', subcategory: Subcategory.find_by(name: 'Gaz'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_gaz)

account = Account.create(name: 'Butagaz', subcategory: Subcategory.find_by(name: 'Gaz'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_gaz)

account = Account.create(name: 'GEG', subcategory: Subcategory.find_by(name: 'Gaz'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_gaz)

account = Account.create(name: 'Gaz de Bordeaux', subcategory: Subcategory.find_by(name: 'Gaz'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_gaz)

account = Account.create(name: 'Suez', subcategory: Subcategory.find_by(name: 'Eau'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_eau)

account = Account.create(name: 'Véolia', subcategory: Subcategory.find_by(name: 'Eau'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_eau)

account = Account.create(name: 'Eau de Paris', subcategory: Subcategory.find_by(name: 'Eau'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: compteur_eau)

account = Account.create(name: 'SNCF', subcategory: Subcategory.find_by(name: 'Transports'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: numero_contrat_sncf)

account = Account.create(name: 'TBM', subcategory: Subcategory.find_by(name: 'Transports'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: numero_contrat_tbm)

account = Account.create(name: 'RATP', subcategory: Subcategory.find_by(name: 'Transports'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: numero_contrat_ratp)

account = Account.create(name: 'Tan', subcategory: Subcategory.find_by(name: 'Transports'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: numero_contrat_tan)

account = Account.create(name: 'TCL', subcategory: Subcategory.find_by(name: 'Transports'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: numero_contrat_tcl)

account = Account.create(name: 'Tag', subcategory: Subcategory.find_by(name: 'Transports'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: numero_contrat_tag)

account = Account.create(name: 'RTM', subcategory: Subcategory.find_by(name: 'Transports'), status: 'validated')
AccountDocument.create(account: account, document: acte_deces)
AccountDocument.create(account: account, document: mail)
AccountDocument.create(account: account, document: numero_contrat_rtm)

puts Account.count == 141 ? "🟩 Accounts créées avec succès" : "🟥 Erreur dans la création des accounts"

puts "👷🏼 Création des Packs"
Pack.create(
  title: 'Initial',
  price: 100,
  level: 1,
  quantity_text: "Jusqu'à 7 contrats",
  description: "Idéal pour un nombre de contrats limité"
)
Pack.create(
  title: 'Premium',
  price: 160,
  level: 2,
  quantity_text: "Jusqu'à 12 contrats",
  description: "La solution abordable, pour le plus grand nombre !"
)
Pack.create(
  title: 'Illimité',
  price: 200,
  level: 3,
  quantity_text: "Au-delà de 12 contrats",
  description: "Pour traiter un maximum de contrats, l'esprit tranquille"
)
puts Pack.count == 3 ? "🟩 Packs créées avec succès" : "🟥 Erreur dans la création des Packs"
