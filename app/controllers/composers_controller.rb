class ComposersController < ApplicationController
  def new
    @composer = Composer.new
  end
  def show
    @composer = Composer.find(params[:id])
  end
  def create
    @composer = Composer.create( composer_params )
    redirect_to @composer
  end
  def tt
  end
  private
  def composer_params
    params.require(:composer).permit(:avatar,:name)
  end
end
