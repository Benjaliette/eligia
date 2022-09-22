class TemplatePdf
  include Prawn::View

  def resiliation_pdf(args)
    # stroke_axis
    bounding_box([0, 715], width: 150, height: 100) do
      # stroke_bounds
      text "ELIGIA SARL,"
      text "6 rue Flornoy, 33000 Bordeaux"
      text "Au nom de #{args[:order_account].order.deceased_first_name} #{args[:order_account].order.deceased_last_name}"
    end
    bounding_box([350, 670], width: 200, height: 100) do
      # stroke_bounds
      text "A l'attention de"
      text "ADRESSE D'EXPEDITION"
    end
    bounding_box([0, 550], width: 550, height: 550) do
      # stroke_bounds
      text "Bonjour"
      move_down 10
      text "Nous sommes au regret de vous informer du décès de votre client #{args[:order_account].order.deceased_first_name} #{args[:order_account].order.deceased_last_name}. Ainsi, nous vous demandons par ce courier la résiliation imédiate de sa/ ses souscription(s) auprès de votre entreprise."
      move_down 10
      text "Vous trouverez joint toutes les informations nécessaires à la résiliation du contrat."
      text "Pour toute requête ou si des informations manquent, veuillez contacter ELIGIA : 6 rue Flornoy, 33000 Bordeaux, contact@eligia.fr, 0627997323."
      move_down 10
      text "En l'absence de nouvelle de votre part sous 5 jours ouvrés suite à réception de ce courier, le contrat sera considéré de notre côté comme résilié."
      move_down 10
      text "Merci"
      move_down 50
      move_down 30
      text "Informations nécessaires à la résiliation :"
      move_down 20
      args[:order_account].order_documents.select { |order_document| order_document.document.format == "text" }.each do |order_document|
        text "#{order_document.document.name} : #{order_document.document_input}"
      end
    end

    args[:order_account].order_documents.select { |order_document| order_document.document_file.attached? && !order_document.pdf? }.each do |order_document|
      text "#{order_document.document.name} :"
      move_down 10
      image StringIO.open(order_document.document_file.download), height: 300
    end

    fill_color '8FCC9B'
    fill_rectangle [0, 100], 540, 100

    image "#{Rails.root}/app/assets/images/eligia-sans-fond.png", height: 80, at: [10, 90]
  end
end
