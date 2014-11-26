class PerformsController < ApplicationController
  def index
  end

  def new
    @group = Group.first
    @groups_for_select = Group.all.collect {|g| [g.name,g.id]}
    @pieces_for_select = Piece.all.collect {|p| [p.name,p.id]}
    @perform = Perform.new(group_id: @group.id)
  end

  def create
    @perform = Perform.new(perform_params)
    if @perform.save
      redirect_to @perform
    else
      render 'new'
    end
  end

  def show
    render plain: "Мама мыла раму"
  end

  def edit
  end

  def update
  end

  def destroy
  end
  private
    def perform_params
      params.require(:perform).permit(:group_id,:piece_id,:concert_id)
    end
end
