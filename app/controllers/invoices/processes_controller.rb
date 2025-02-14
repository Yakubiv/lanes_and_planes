module Invoices
  class ProcessesController < ApplicationController
    before_action :load_step, :load_invoice
    before_action :set_next_and_previous_step, only: %i[update show]
    STEPS = %w[connect_booking verify_booking details].freeze

    def show
      @form = form_for_step(@step).new(invoice: @invoice)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def update
      @form = form_for_step(@step).new(send("#{@step}_params").merge(invoice: @invoice))
      if @form.submit
        if @next_step
          @next_form = load_next_form
        else
          @invoice.update(status: :processed)

          respond_to do |format|
            format.turbo_stream do
              flash[:notice] = "#{@invoice.filename} was successfully processed"
              render turbo_stream: [turbo_stream.action(:redirect, invoices_path),
                                    turbo_stream.replace("flash-messages", partial: "shared/flash_messages")]

            end
          end
        end
      else
        render :show
      end
    end

    private

    def set_next_and_previous_step
      @next_step, @previous_step = next_step(@step), previous_step(@step)
    end

    def load_next_form
      form_for_step(@next_step).new(invoice: @invoice)
    end

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
      params.require(:invoice).permit(:vat_id, :country, :company_name, :invoice_date, :invoice_number, :street, :street_number, :postal_code, :city, :invoice_has_word_invoice,
                                      line_items_attributes: [:id, :traveler_name, :start_date, :end_date, :description, :category, :quantity, :unit_price, :_destroy])
    end

    def next_step(current)
      index = STEPS.index(current)
      STEPS[index + 1]
    end

    def previous_step(current)
      index = STEPS.index(current)
      return nil if index.zero?

      STEPS[index - 1]
    end
  end
end
