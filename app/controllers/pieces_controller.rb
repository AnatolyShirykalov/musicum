class PiecesController < ApplicationController
  def index
  end

  def show
    @composer = Composer.find(params[:composer_id])
    @piece = @composer.pieces.find(params[:id])
  end

  def edit
  end
  
  def create
  end

  def destroy
    @composer = Composer.find(params[:composer_id])
    @piece = @composer.pieces.find(params[:id])
    @piece.destroy
    redirect_to composer_path(@composer)
  end
end
