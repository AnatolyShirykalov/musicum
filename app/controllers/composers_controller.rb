class ComposersController < ApplicationController
  def new
    @composer = Composer.new
  end
  def show
    @composer = Composer.find(params[:id])
    @pieces = @composer.pieces
  end
  def create
    #@composer = Composer.create( composer_params )
    render plain: composer_params.inspect
    #if composer_pieces
    #  composer_pieces.each do |key,value|
    #    @composer.pieces.create(name: value[:name])
    #  end
    #end
    #@pieces = @composer.pieces
    #redirect_to @composer
  end
  def index
    @composers = Composer.all
  end
  def destroy
    @composer = Composer.find(params[:id])
    @composer.destroy
    redirect_to composers_path
  end
  private
  def composer_params
    params.require(:composer).permit(:avatar,:co_url,:name)
  end
  def composer_pieces
    params[:composer][:pieces_attributes]
  end
  def composer_from_url
    url = composer_params[:co_url]
    in_base = Composer.find_by(co_url: url)
    return in_base if in_base
    html = open(composer_params[:co_url]).read
    h1 = doc.at_css('div[id="vse"]')>('div[class="cnt"]')>('div[class="cat"]')>('div[class="data-case"]')>('div[class="data"]')>('h1')
    name = (h1.inner_text.split("\n")[0]).gsub(/ \z/,'')
    return Composer.new(name: name)
  end
end
