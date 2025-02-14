module Invoices
  class LineItemsController < ApplicationController
    before_action :setup_invoice
    def create

    end

    def destroy
    end

    private

    def setup_invoice
      @invoice = Invoice.find(params[:invoice_id] || params[:id])
      @new_invoice = Invoice.new(line_items: [LineItem.new])
    end
  end
end