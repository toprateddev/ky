class CategoriesController < ApplicationController

  before_action :authenticate_user!
  before_action :find_category, only: [ :show, :edit, :destroy, :update ]
  before_action :find_parent, only: [:edit, :show, :new]

  def show
  end

  def edit
  end

  def destroy
    @category.destroy
  end

  def index
    @categories = current_user.categories
  end

  def new
    @category = current_user.categories.new
  end

  def create
    @category = current_user.categories.new category_params
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @category.update_attributes category_params
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def category_params
    params.require(:category).permit!
  end

  def find_category
    begin
      @category = current_user.categories.find(params[:id])
    rescue Mongoid::Errors::DocumentNotFound
      render :status => '404'
    end
  end

  def find_parent
    begin
      @parent_category = Category.find params[:format]
    rescue
      @parent_category = nil
    end
  end

end
