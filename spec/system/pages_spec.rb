require 'rails_helper'

RSpec.describe "pages", type: :system do
  describe "pages#home" do
    get '/'
  end
end
