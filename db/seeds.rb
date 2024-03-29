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
  Rgpd.destroy_all
  Cgs.destroy_all

  puts "📄 Rédaction des RGPD"
  Rgpd.create(text: "<h2>La protection de vos données est importante pour nous. À cette fin, Eligia applique des procédures strictes, conformes aux dernières directives RGPD.</h2> <br> <br> <p>Sur la base légale du consentement, la société ELIGIA SARL récolte les données nécessaires à la mise à disposition de son service. Ces données peuvent être séparées en deux catégories : les données du demandeur ainsi que les données du défunt. La récolte des données est directe : Eligia ne récolte que les données que vous spécifiez dans les champs des divers formulaires d’inscription, de création de dossier ou de paiement.</p> <br><br> <h3>Pourquoi récolter des données ?</h3> <br><br> <ul> <li>Les données du demandeur sont utilisées à des fin de répression des fraudes, de facturation et de contact pour le suivi des dossiers. Note : vos données bancaires sont sécurisées <em>via</em> la plateforme de paiement Stripe.com, elle ne sont pas et ne peuvent en aucun cas être récoltées par ELIGIA SARL.</li> <li> Suite à leur récolte, les données du défunt sont stockées sur un serveur externe sécurisé. Ces données sont ensuite transmises aux entreprises concessionnaires des contrats pour leur résiliation via des canaux sécurisés (lettres recommandées avec accusé de réception). Eligia s’engage à ne récolter que les données suffisantes et nécessaires à la résiliation des contrats. </li> </ul> <br> <p>Toutes les données du dossier d’un défunt sont supprimées définitivement des serveurs dans la durée légale de 3 mois après la clôture du dossier.</p> <p>Pour toute question concernant le traitement ou la suppression de vos données personnelles, contactez-nous à l’adresse email suivante : contact@eligia.fr. Nous nous engageons à vous répondre dans un délai de 2 jours ouvrés après réception du courriel.</p>")

  puts "📄 Rédaction des CGS"
  Cgs.create(
    text: "
      <h1>Conditions générales de service</h1>

      <h3>Article 1 : Objet et champ d'application</h3>
      <p>
        Les présentes conditions générales de vente (CGV) constituent le socle de la négociation commerciale.

        Les conditions générales de vente décrites ci-après détaillent les droits et obligations de la société
        ELIGIA, société à responsabilité limitée au capital de 2 000 euros, et inscrite au registre du commerce de Bordeaux sous le numéro de SIREN 920 048 725 (ci-après 'ELIGIA SARL'),
        et de son client dans le cadre de la vente de prestations suivantes : service de résiliations de contrats.

        Tout paiement pour ce service implique l'adhésion sans réserve de l'acheteur aux présentes conditions générales de service.
      </p>

      <h3>Article 2 : Prix</h3>
      <p>
        Les prix des services vendus sont ceux en vigueur au jour de la prise de commande. Ils sont libellés en euros et calculés hors taxes. Par voie de conséquence, ils seront majorés du taux de TVA applicables au jour de la commande.

        La société ELIGIA SARL s'accorde le droit de modifier ses tarifs à tout moment. Toutefois, elle s'engage à facturer les services achetés aux prix indiqués lors de l'enregistrement de la commande.
      </p>

      <h3>Article 3 : Modalités de paiement</h3>
      <p>
        Le règlement des commandes se fait par carte bancaire (VISA, CB, Mastercard).

        Les règlements seront effectués à l'aide de la plateforme de paiement en ligne Payplug et seront immédiats.
      </p>

      <h3>Article 4 : Livraison</h3>
      <p>
        La livraison est effectuée après réalisation des démarches de résiliation des contrats souhaités.

        Le délai de livraison estimé entre deux semaines et un mois n'est donné qu'à titre indicatif et n'est aucunement garanti.

        Par voie de conséquence, tout retard raisonnable dans la livraison des services ne pourra pas donner lieu au profit de l'acheteur à :

        - l'allocation de dommages et intérêts ;
        - l'annulation de la commande.
      </p>

      <h3>Article 5 : Force majeure</h3>
      <p>
        La responsabilité de la société ELIGIA SARL ne pourra pas être mise en oeuvre si la non-exécution ou le retard dans l'exécution de l'une de ses obligations décrites dans les présentes conditions générales de service découle d'un cas de force majeure. À ce titre, la force majeure s'entend de tout événement extérieur, imprévisible et irrésistible au sens de l'article 1148 du Code civil.
      </p>

      <h3>Article 6 : Tribunal compétent</h3>
      <p>
        Tout litige relatif à l'interprétation et à l'exécution des présentes conditions générales de service est soumis au droit français.

        À défaut de résolution amiable, le litige sera porté devant le Tribunal de Commerce de Bordeaux.
      </p>
    "
  )

  puts "👷🏼 Création des Users"
  User.create(first_name: 'Marc', last_name: 'Delesalle', email: 'marc.delesalle@eligia.fr', password: '123456', admin: 'true', accepted_rgpd: true, accepted_cgs: true, birthdate: Date.today - 20.year)
  User.create(first_name: 'Benjamin', last_name: 'Liet', email: 'benjamin.liet@eligia.fr', password: '123456', admin: 'true', accepted_rgpd: true, accepted_cgs: true, birthdate: Date.today - 20.year)
  User.create(first_name: 'jane', last_name: 'doe', email: 'jane.doe@eligia.fr', password: '123456', accepted_rgpd: true, accepted_cgs: true, birthdate: Date.today - 20.year)
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
  acte_deces = Document.create(name: 'Certificat de décès', format: 'file')
  piece_identite = Document.create(name: "Pièce d'identité (héritier)", format: 'file')
  justificatif_domicile = Document.create(name: 'Justificatif domicile (défunt)', format: 'file')
  iban = Document.create(name: 'IBAN', format: 'text', file_type: 'iban')
  compteur_gaz = Document.create(name: 'Relevé du compteur de gaz', format: 'text', file_type: 'compteur_gaz')
  compteur_elec = Document.create(name: "Relevé du compteur d'électricité", format: 'text', file_type: 'compteur_elec')
  compteur_eau = Document.create(name: "Relevé du compteur d'eau", format: 'text', file_type: 'compteur_eau')
  numero_client = Document.create(name: 'Numéro Client', format: 'text')
  numero_telephone_mobile = Document.create(name: 'Numéro de téléphone mobile (défunt)', format: 'text', file_type: 'telephone_mobile')
  numero_telephone_fixe = Document.create(name: 'Numéro de téléphone fixe (défunt)', format: 'text', file_type: 'telephone_fixe')
  mail = Document.create(name: 'Adresse mail (défunt)', format: 'text', file_type: 'email')
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

  account = Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Ligne mobile'), aasm_state: 'validated', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Free_logo.svg/langfr-2880px-Free_logo.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_mobile)

  account = Account.create(name: 'Orange', subcategory: Subcategory.find_by(name: 'Ligne mobile'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Orange_logo.svg/langfr-300px-Orange_logo.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: piece_identite)
  AccountDocument.create(account: account, document: numero_telephone_mobile)

  account = Account.create(name: 'Sosh', subcategory: Subcategory.find_by(name: 'Ligne mobile'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/7/7d/Sosh_%28logo_bleu%29.svg/langfr-560px-Sosh_%28logo_bleu%29.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_mobile)

  account = Account.create(name: 'SFR', subcategory: Subcategory.find_by(name: 'Ligne mobile'), aasm_state: 'validated', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/SFR_2022.svg/langfr-300px-SFR_2022.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_contrat_sfr)
  AccountDocument.create(account: account, document: numero_telephone_mobile)

  account = Account.create(name: 'RED By SFR', subcategory: Subcategory.find_by(name: 'Ligne mobile'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/6/6f/Logo_Red_By_SFR_2016.svg/langfr-560px-Logo_Red_By_SFR_2016.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_mobile)

  account = Account.create(name: 'La Poste Mobile', subcategory: Subcategory.find_by(name: 'Ligne mobile'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/f/f3/Logo_La_Poste_Mobile_-_2019.svg/langfr-280px-Logo_La_Poste_Mobile_-_2019.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_mobile)

  account = Account.create(name: 'Prixtel', subcategory: Subcategory.find_by(name: 'Ligne mobile'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/8/8b/Logo_Prixtel.png/350px-Logo_Prixtel.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_mobile)

  account = Account.create(name: 'Coriolis', subcategory: Subcategory.find_by(name: 'Ligne mobile'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/e/e6/Logo_Coriolis_Telecom.svg/langfr-560px-Logo_Coriolis_Telecom.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_mobile)

  account = Account.create(name: 'Bouygues Télécom', subcategory: Subcategory.find_by(name: 'Ligne mobile'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/2/2b/Bouygues_T%C3%A9l%C3%A9com.png/560px-Bouygues_T%C3%A9l%C3%A9com.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_mobile)

  account = Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Ligne fixe'), aasm_state: 'validated', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Free_logo.svg/langfr-2880px-Free_logo.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_fixe)

  account = Account.create(name: 'Orange', subcategory: Subcategory.find_by(name: 'Ligne fixe'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Orange_logo.svg/langfr-300px-Orange_logo.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: piece_identite)
  AccountDocument.create(account: account, document: numero_telephone_fixe)

  account = Account.create(name: 'Sosh', subcategory: Subcategory.find_by(name: 'Ligne fixe'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/7/7d/Sosh_%28logo_bleu%29.svg/langfr-560px-Sosh_%28logo_bleu%29.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_fixe)

  account = Account.create(name: 'SFR', subcategory: Subcategory.find_by(name: 'Ligne fixe'), aasm_state: 'validated', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/SFR_2022.svg/langfr-300px-SFR_2022.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_contrat_sfr)
  AccountDocument.create(account: account, document: numero_telephone_fixe)

  account = Account.create(name: 'RED By SFR', subcategory: Subcategory.find_by(name: 'Ligne fixe'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/6/6f/Logo_Red_By_SFR_2016.svg/langfr-560px-Logo_Red_By_SFR_2016.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_fixe)

  account = Account.create(name: 'Coriolis', subcategory: Subcategory.find_by(name: 'Ligne fixe'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/e/e6/Logo_Coriolis_Telecom.svg/langfr-560px-Logo_Coriolis_Telecom.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_fixe)

  account = Account.create(name: 'Bouygues', subcategory: Subcategory.find_by(name: 'Ligne fixe'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/2/2b/Bouygues_T%C3%A9l%C3%A9com.png/560px-Bouygues_T%C3%A9l%C3%A9com.png')

  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_telephone_fixe)

  account = Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Internet'), aasm_state: 'validated', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Free_logo.svg/langfr-2880px-Free_logo.svg.png')
  AccountDocument.create(account: account, document: acte_deces)

  account = Account.create(name: 'Orange', subcategory: Subcategory.find_by(name: 'Internet'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Orange_logo.svg/langfr-300px-Orange_logo.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: piece_identite)

  account = Account.create(name: 'Sosh', subcategory: Subcategory.find_by(name: 'Internet'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/7/7d/Sosh_%28logo_bleu%29.svg/langfr-560px-Sosh_%28logo_bleu%29.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_contrat_sosh)

  account = Account.create(name: 'SFR', subcategory: Subcategory.find_by(name: 'Internet'), aasm_state: 'validated', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/SFR_2022.svg/langfr-300px-SFR_2022.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_contrat_sfr)

  account = Account.create(name: 'RED By SFR', subcategory: Subcategory.find_by(name: 'Internet'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/6/6f/Logo_Red_By_SFR_2016.svg/langfr-560px-Logo_Red_By_SFR_2016.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_contrat_red)

  account = Account.create(name: 'Bouygues', subcategory: Subcategory.find_by(name: 'Internet'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/2/2b/Bouygues_T%C3%A9l%C3%A9com.png/560px-Bouygues_T%C3%A9l%C3%A9com.png')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_contrat_bouygues)

  account = Account.create(name: 'Nordnet', subcategory: Subcategory.find_by(name: 'Internet'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: numero_contrat_nordnet)

  account = Account.create(name: 'Le Monde', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: 'Le Figaro', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: 'Libération', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: 'Le Nouvel Obs', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: 'Le Parisien', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: 'Sud Ouest', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: 'Ouest France', subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "L'Equipe", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Les échos", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "La croix", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "L'humanité", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "L'opinion", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "L'est républicain", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Le dauphiné libéré", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Logo_Journal_Le_Dauphin%C3%A9_Lib%C3%A9r%C3%A9_-_2022.svg/langfr-500px-Logo_Journal_Le_Dauphin%C3%A9_Lib%C3%A9r%C3%A9_-_2022.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "DNA", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Logo-dna-2022.svg/langfr-340px-Logo-dna-2022.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "La provence", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Nice matin", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "La dépêche du Midi", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "TV Magazine", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Fémina", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/6/65/Logo_Version_Femina.png')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télé 7 jours", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télé Z", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télé star", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télé loisirs", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Paris Match", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Femme Actuelle", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télérama", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télécable Sat Hebdo", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Madame Figaro", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/f/f8/Le_Figaro_logo.svg/400px-Le_Figaro_logo.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Le Figaro Magazine", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télé Poche", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Le canard enchaîné", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Elle", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Le Point", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Auto Plus", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "L'Obs", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Voici", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "L'express", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Closer", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Challenges", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Gala", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Courrier international", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/fr/thumb/0/0b/Courrier_international_2012_logo.png/560px-Courrier_international_2012_logo.png')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Journal du dimanche", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Public", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télé Magazine", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Marianne", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Grazia", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Valeurs actuelles", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "France Football", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Charlie Hebdo", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated', logo_url:'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Charlie_Hebdo_logo.svg/langfr-560px-Charlie_Hebdo_logo.svg.png')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Midi Olympique", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Les inrockuptibles", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télé 2 Semaines", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Notre Temps", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Santé magazine", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Marie Claire", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Top Santé", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Cosmopolitan", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Prima", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Sciences & Avenir", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Le chasseur français", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Ça m'intéresse", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Biba", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Science et vie", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Capital", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Géo", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Le monde diplomatique", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Auto Moto", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Télé 7 jeux", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Vogue", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Première", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Vanity Fair", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "GQ", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "So Foot", subcategory: Subcategory.find_by(name: 'Journaux/Magazines'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  numero_abonne = Document.create(name: "Numéro d'Abonné #{account.name}", format: 'text')
  AccountDocument.create(account: account, document: numero_abonne)

  account = Account.create(name: "Canal +", subcategory: Subcategory.find_by(name: 'Télévision'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "BeinSport", subcategory: Subcategory.find_by(name: 'Télévision'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Canalsat", subcategory: Subcategory.find_by(name: 'Télévision'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "OCS", subcategory: Subcategory.find_by(name: 'Télévision'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Fransat", subcategory: Subcategory.find_by(name: 'Télévision'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Canalsat", subcategory: Subcategory.find_by(name: 'Télévision'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Netflix", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Amazon Prime Vidéo", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Disney plus", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Apple TV", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Filmo", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Salto", subcategory: Subcategory.find_by(name: 'Plateformes de streaming'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: iban)

  account = Account.create(name: "Facebook", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)

  account = Account.create(name: "Twitter", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)

  account = Account.create(name: "Instagram", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)

  account = Account.create(name: "Snapchat", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)

  account = Account.create(name: "Tik Tok", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)

  account = Account.create(name: "Twitch", subcategory: Subcategory.find_by(name: 'Réseaux sociaux'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)

  account = Account.create(name: "Google", subcategory: Subcategory.find_by(name: 'Divers'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)

  account = Account.create(name: "Amazon", subcategory: Subcategory.find_by(name: 'Divers'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)

  account = Account.create(name: "CDiscount", subcategory: Subcategory.find_by(name: 'Divers'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)

  account = Account.create(name: 'EDF', subcategory: Subcategory.find_by(name: 'Électricité'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_elec)

  account = Account.create(name: 'TotalEnergies', subcategory: Subcategory.find_by(name: 'Électricité'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_elec)

  account = Account.create(name: 'Cdiscount énergie', subcategory: Subcategory.find_by(name: 'Électricité'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_elec)

  account = Account.create(name: 'Happ-e', subcategory: Subcategory.find_by(name: 'Électricité'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_elec)

  account = Account.create(name: 'Sowee', subcategory: Subcategory.find_by(name: 'Électricité'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_elec)

  account = Account.create(name: 'GEG', subcategory: Subcategory.find_by(name: 'Électricité'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_elec)

  account = Account.create(name: 'Engie', subcategory: Subcategory.find_by(name: 'Gaz'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_gaz)

  account = Account.create(name: 'eni', subcategory: Subcategory.find_by(name: 'Gaz'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_gaz)

  account = Account.create(name: 'Happ-e', subcategory: Subcategory.find_by(name: 'Gaz'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_gaz)

  account = Account.create(name: 'Butagaz', subcategory: Subcategory.find_by(name: 'Gaz'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_gaz)

  account = Account.create(name: 'GEG', subcategory: Subcategory.find_by(name: 'Gaz'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_gaz)

  account = Account.create(name: 'Gaz de Bordeaux', subcategory: Subcategory.find_by(name: 'Gaz'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_gaz)

  account = Account.create(name: 'Suez', subcategory: Subcategory.find_by(name: 'Eau'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_eau)

  account = Account.create(name: 'Véolia', subcategory: Subcategory.find_by(name: 'Eau'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_eau)

  account = Account.create(name: 'Eau de Paris', subcategory: Subcategory.find_by(name: 'Eau'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: compteur_eau)

  account = Account.create(name: 'SNCF', subcategory: Subcategory.find_by(name: 'Transports'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: numero_contrat_sncf)

  account = Account.create(name: 'TBM', subcategory: Subcategory.find_by(name: 'Transports'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: numero_contrat_tbm)

  account = Account.create(name: 'RATP', subcategory: Subcategory.find_by(name: 'Transports'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: numero_contrat_ratp)

  account = Account.create(name: 'Tan', subcategory: Subcategory.find_by(name: 'Transports'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: numero_contrat_tan)

  account = Account.create(name: 'TCL', subcategory: Subcategory.find_by(name: 'Transports'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: numero_contrat_tcl)

  account = Account.create(name: 'Tag', subcategory: Subcategory.find_by(name: 'Transports'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: numero_contrat_tag)

  account = Account.create(name: 'RTM', subcategory: Subcategory.find_by(name: 'Transports'), aasm_state: 'validated')
  AccountDocument.create(account: account, document: acte_deces)
  AccountDocument.create(account: account, document: mail)
  AccountDocument.create(account: account, document: numero_contrat_rtm)

  Account.all.each do |acc|
    address = Address.create(street: '10 rue du test', zip: '75000', city: 'Paris', state: 'France')
    acc.update(address: address)
  end

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
end
