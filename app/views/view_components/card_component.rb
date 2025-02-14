# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  renders_one :footer

  def initialize(title:)
    @title = title
  end
end
