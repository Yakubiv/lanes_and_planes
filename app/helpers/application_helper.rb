module ApplicationHelper
  ALL_STEPS = %w[connect_booking verify_booking verify_cost_coverage details connect_charges]
  INACTIVE_STEPS = %w[verify_cost_coverage connect_charges]

  def invoice_processing_steps(invoice, current_step)
    past_bg, current_bg, future_bg = 'bg-success', 'bg-primary', ' bg-secondary'

    ALL_STEPS.map.with_index do |step, index|
      index_label = index + 1
      step_settings = if index < ALL_STEPS.index(current_step)
                        { bg: past_bg, icon: '<i class="bi bi-check"></i>', disabled: !step_available?(invoice, step) }
                      elsif index == ALL_STEPS.index(current_step)
                        { bg: current_bg, icon: "<span class='px-1'>#{index_label.to_s}</span>", disabled: !step_available?(invoice, step) }
                      else
                        { bg: future_bg, icon: "<span class='px-1'>#{index_label.to_s}</span>", disabled: !step_available?(invoice, step) }
                      end

      [step, step_settings]
    end.to_h
  end

  def step_available?(invoice, step)
    {
      'connect_booking' => true,
      'verify_booking' => invoice.booking.present?,
      'details' => invoice.receiving_company_verified?
    }[step] || false
  end
end
