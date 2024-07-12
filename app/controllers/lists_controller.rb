class ListsController < ApplicationController
  before_action :set_list, only: [:show, :destroy]

  def index
    @lists = List.all
    @first = Movie.first
    @second = Movie.second
    @third = Movie.third
    @fourth = Movie.fourth
    @fifth = Movie.fifth
    @carousel_items = [@first, @second, @third, @fourth, @fifth]
  end

  def show
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.save
    redirect_to @list
  end

  def destroy
    @list.destroy
    redirect_to root_path, status: :see_other
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :photo)
  end
end
