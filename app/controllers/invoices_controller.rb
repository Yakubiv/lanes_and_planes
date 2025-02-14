class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save!
      redirect_to @invoice
    else
      render 'new'
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update(invoice_update_params)
      respond_to do |format|
        format.turbo_stream do
          flash[:notice] = "#{@invoice.filename} was marked as invalid"
          render turbo_stream: [turbo_stream.action(:redirect, invoices_path),
                                turbo_stream.replace("flash-messages", partial: "shared/flash_messages")]

        end
      end
    else
      render 'edit'
    end
  end

  private

  def invoice_update_params
    params.require(:invoice).permit(:status)
  end

  def invoice_params
    params.require(:invoice).permit(:pdf)
  end
end