class TemplatePdf
  include Prawn::View

  def initialize(args)
    @args = args
  end

  def resiliation_pdf(args)
    stroke_axis
    stroke_circle [0, 0], 10
    bounding_box([10, 715], width: 150, height: 100) do
      stroke_bounds
      text "#{@args[:sender_first_name]} #{@args[:sender_last_name]}"
      text "\nVia Eligia,"
      text "107 Cours de Balguerie- Stuttenberg, 33000 Bordeaux"
    end
    bounding_box([350, 600], width: 200, height: 100) do
      stroke_bounds
      text "A l'attention de"
      text "sender name + address"
    end
    bounding_box([20, 450], width: 520, height: 300) do
      stroke_bounds
      text "Bonjour"
      move_down 10
      text "Par ce courier nous demandons la résiliation du compte de #{@args[:sender_first_name]} #{@args[:sender_last_name]}."
      move_down 10
      text "Merci"
    end
    fill_color '8FCC9B'
    fill_rectangle [0, 100], 540, 100
  end
end
