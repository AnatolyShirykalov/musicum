class ComposersController < ApplicationController
  def new
    @composer = Composer.new
  end
  def show
    @composer = Composer.find(params[:id])
  end
  def create
    @composer = Composer.new(params[:composer])
    if @composer.save
      redirect_to @composer
    else
      render 'new'
    end
  end
end
