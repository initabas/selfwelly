class MedicinesController < ApplicationController
  before_action :set_medicine, only: [:show, :edit, :update, :destroy, :add_review]
  before_action :get_medicines, only: [:index, :filter]
  include Filterable
  
  respond_to :html

  def index
    @groups = Group.all
    respond_with(@medicines)
  end

  def show
    respond_with(@medicine)
  end

  def new
    @medicine = Medicine.new
    respond_with(@medicine)
  end

  def edit
  end

  def create
    @medicine = Medicine.new(medicine_params)
    @medicine.save
    respond_with(@medicine)
  end
  
  def filter
    respond_to do |format|
      format.js
    end
  end
  
  def add_review
    @review = Review.new
    respond_to do |format|
      format.js
    end
  end

  def update
    @medicine.update(medicine_params)
    respond_with(@medicine)
  end

  def destroy
    @medicine.destroy
    respond_with(@medicine)
  end

  private
    
    def get_medicines
      @medicines = Medicine.filter(params.slice(:forms, :groups))
    end
  
    def set_medicine
      @medicine = Medicine.find(params[:id])
    end

    def medicine_params
      params.require(:medicine).permit(:name, :description)
    end
end
