class TemplatePdf
  include Prawn::View

  def resiliation_pdf(args)
    # stroke_axis
    bounding_box([10, 715], width: 150, height: 100) do
      # stroke_bounds
      text "#{args[:order_account].order.deceased_first_name} #{args[:order_account].order.deceased_last_name}"
      text "\nVia Eligia,"
      text "107 Cours de Balguerie- Stuttenberg, 33000 Bordeaux"
    end
    bounding_box([350, 600], width: 200, height: 100) do
      # stroke_bounds
      text "A l'attention de"
      text "sender name + address"
    end
    bounding_box([20, 450], width: 520, height: 300) do
      # stroke_bounds
      text "Bonjour"
      move_down 10
      text "Par ce courier nous demandons la résiliation du compte de #{args[:order_account].order.deceased_first_name} #{args[:order_account].order.deceased_last_name}."
      move_down 10
      text "Merci"
    end
    move_down 30
    text "Informations nécessaires:"
    move_down 20
    args[:order_account].order_documents.select{ |order_document| order_document.document.format == "text" }.each do |order_document|
      text "#{order_document.document.name} : #{order_document.document_input}"
    end
    args[:order_account].order_documents.select{ |order_document| order_document.document_file.attached? }.each do |order_document|
      move_down 20
      image StringIO.open(order_document.document_file.download), height: 300
    end
    fill_color '8FCC9B'
    fill_rectangle [0, 100], 540, 100

    image "#{Rails.root}/app/assets/images/eligia-sans-fond.png", height: 80, at: [10, 90]
  end
end
