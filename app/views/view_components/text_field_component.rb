# frozen_string_literal: true

class TextFieldComponent < ViewComponent::Base
  def initialize(f:, name:, label:, errors: nil, required: false)
    @f = f
    @name = name
    @label = label
    @required = required
    @errors = errors
  end
end
