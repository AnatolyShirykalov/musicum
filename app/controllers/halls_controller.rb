class HallsController < ApplicationController
  require 'mosconsv'
  require 'meloman'
  def invite
   @condition = Condition.new(f_date: Date.today, t_date: Date.today+7)
  end
  def filter
    mc = Mosconsv.new
    kzt = Meloman.new
    @meloman = kzt.parse_dates(conditions)
    @res = []
    (dates[0]..dates[1]).each do |date|
      @res = @res |  mc.parse_date(date,conditions)
    end
  end
  private
    def conditions
      cons = []
      return {:sufficient => cons, :since=> dates[0], :til=> dates[1]} if params[:condition][:sufficients_attributes].nil?
      params[:condition][:sufficients_attributes].each do |k,v|
        if v[:desc][0]=='/' and v[:desc][-1]=='/'
          cons<</#{v[:desc][1..-2]}/
	else
          cons<<v[:desc]
	end
      end
      {:sufficient => cons, :since => dates[0], :til => dates[1]}
    end
    def dates
      cs = params[:condition]
      f = Date.new(cs["f_date(1i)"].to_i,cs["f_date(2i)"].to_i,cs["f_date(3i)"].to_i)
      t = Date.new(cs["t_date(1i)"].to_i,cs["t_date(2i)"].to_i,cs["t_date(3i)"].to_i)
      [f,t]
    end
end
