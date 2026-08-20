class StockMovementService
  def initialize(batch, params = {})
    @batch = batch
    @items = params[:items]
  end

  def call
    ActiveRecord::Base.transaction do
      save_items
    end
  end

  private

  def save_items
    return unless @items.present?

    @batch.stock_movement_items.destroy_all

    @items.each do |item|
      next if item[:bale_name].blank?

      @batch.stock_movement_items.create!(
        bale_name: item[:bale_name],
        qty: item[:qty],
        unit_price: item[:unit_price]
      )
    end
  end
end