class StatusController < ApplicationController
 def index
  @tickets =Ticket.where('remedy_date >= ?', 24.hours.ago).where.not(status_id: "CLOSED").where.not(status_id: "CLOSED DIRECTLY").page(params[:page])
      respond_to do |format|
      @query = Ticket.where(status_id: "CLOSED")
      #format.csv { send_data ({},@query) }
      format.csv { send_data @query.to_csv({},@query),filename: "ALLCLOSED-#{Date.today}.csv" }
      format.xls  { send_data @query.to_csv({col_sep: "\t"}, @query) }
      #format.csv {render :text => @tickets.to_csv}
      #format.csv  { send_data(query_to_csv(@tickets, @query, params), :type => 'text/csv; header=present', :filename => 'issues.csv') }
      #format.xls  { send_data Ticket.to_csv({col_sep: "\t"}, @tickets) }
      #format.csv { send_data Product.to_csv({},@products) }
      
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
      #format.tsv { send_data @tickets.to_csv} #(col_sep: "\t"), filename: "ticket-#{Time.zone.now.strftime('%d%m%Y%H%M')}.tsv" }
   
    end

    end


 include PivotTable

def pivot
  data = Ticket.all
  grid = grid(tickets, { :row_name => :region_id, :column_name => :reason_id })
  # do stuff
end

end
