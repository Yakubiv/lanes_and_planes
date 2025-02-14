module ApplicationHelper
  ALL_STEPS = %w[connect_booking verify_booking verify_cost_coverage details connect_charges]
  INACTIVE_STEPS = %w[verify_cost_coverage connect_charges]

  def invoice_processing_steps(current_step)
    past_bg, current_bg, future_bg = 'bg-success', 'bg-primary', ' bg-secondary'

    ALL_STEPS.map.with_index do |step, index|
      index_label = index + 1
      step_settings = if index < ALL_STEPS.index(current_step)
                        { bg: past_bg, icon: '<i class="bi bi-check"></i>', disabled: step.in?(INACTIVE_STEPS) }
                      elsif index == ALL_STEPS.index(current_step)
                        { bg: current_bg, icon: "<span class='px-1'>#{index_label.to_s}</span>", disabled: step.in?(INACTIVE_STEPS) }
                      else
                        { bg: future_bg, icon: "<span class='px-1'>#{index_label.to_s}</span>", disabled: step.in?(INACTIVE_STEPS) }
                      end

      [step, step_settings]
    end.to_h
  end

end
