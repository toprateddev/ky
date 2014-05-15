class AreasController < ApplicationController

  before_action :authenticate_user!
  before_action :find_area, only: [ :show, :destroy, :update, :edit ]

  def create
    @area = current_user.areas.new area_params
    respond_to do |format|
      if @area.save
        format.html { redirect_to @area, notice: 'area was successfully created.' }
        format.json { render action: 'show', status: :created, location: @area }
      else
        format.html { render action: 'new' }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end 
  end
  
  def show
  end

  def new
    @area = current_user.areas.new
  end

  def destroy
    @area.destroy
    respond_to do |format|
      format.html { redirect_to areas_url }
      format.json { head :no_content }
    end
  end

  def edit
  end

  def index
    @areas = current_user.areas
  end

  def update
    @area.update_attributes area_params
    respond_to do |format|
      if @area.save
        format.html { redirect_to @area, notice: 'area was successfully created.' }
        format.json { render action: 'show', status: :created, location: @area }
      else
        format.html { render action: 'new' }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_area
    @area = current_user.areas.find area_id
  end

  def area_id
    params.permit(:id)[:id]
  end

  def area_params
    params.require(:area).permit!
  end

end
