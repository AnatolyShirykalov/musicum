class ComposersController < ApplicationController
  def new
    @composer = Composer.new
  end
  def show
    @composer = Composer.find(params[:id])
  end
  def create
    @composer = Composer.create( composer_params )
    #render plain: params[:composer].inspect
    if composer_pieces
      composer_pieces.each do |key,value|
        @composer.pieces.create(name: value[:name])
      end
    end
    @pieces = @composer.pieces
    #redirect_to @composer
  end
  def index
  end
  private
  def composer_params
    params.require(:composer).permit(:avatar,:name)
  end
  def composer_pieces
    params[:composer][:pieces_attributes]
  end
end
