class ImportController < ApplicationController
   
 authorize_resource :class => false

  def index

  end

   def new
  	@imports = Import.new
  end

  def create
  	 @imports = Import.new(params[:import], on_duplicate_key_update: {conflict_target: [:id], columns: [:title]})

    if @import.save
      redirect_to console_path
    else
      render :new
    end
  end


end
