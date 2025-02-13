module Invoices
  class ProcessesController < ApplicationController
    before_action :load_step, :load_invoice
    STEPS = %w[connect_booking verify_booking details review].freeze

    def show
      @form = form_for_step(@step).new(invoice: @invoice)
    end

    def update
      @form = form_for_step(@step).new(send("#{@step}_params").merge(invoice: @invoice))
      if @form.submit
        @next_step = next_step(@step)
        @next_form = form_for_step(@next_step)
      else
        render :show
      end
    end

    private

    def load_step
      @step = params[:step] || STEPS.first
    end

    def load_invoice
      @invoice = Invoice.find(params[:invoice_id] || params[:id])
    end

    def form_for_step(step)
      {
        'connect_booking' => Invoices::ConnectBookingForm,
        'verify_booking' => Invoices::VerifyBookingForm,
        'details' => Invoices::DetailsForm
      }[step]
    end

    def connect_booking_params
      params.require(:invoices_connect_booking_form).permit(:booking_id)
    end

    def verify_booking_params
      params.require(:invoices_verify_booking_form).permit(:booking_verified, :receiving_company_verified, :same_country)
    end

    def details_params
      params.require(:invoices_details_form).permit(:booking_id)
    end

    def next_step(current)
      index = STEPS.index(current)
      STEPS[index + 1] || STEPS.last
    end

    def previous_step(current)
      index = STEPS.index(current)
      STEPS[index - 1] || STEPS.first
    end
  end
end
