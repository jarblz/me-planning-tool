class Admin::IndicatorsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_project, only: [:index, :new, :edit]
  before_action :set_indicator, only: [:show, :edit, :update, :destroy]

  # GET /indicators
  # GET /indicators.json
  def index
    @indicators = Indicator.where(project_id: @project.id)
  end

  # GET /indicators/1
  # GET /indicators/1.json
  def show
  end

  # GET /indicators/new
  def new
    @indicator = Indicator.new(project_id: @project.id)
  end

  # GET /indicators/1/edit
  def edit

  end

  # POST /indicators
  # POST /indicators.json
  def create
    @indicator = Indicator.new(indicator_params)

    respond_to do |format|
      if @indicator.save
        format.html { redirect_to admin_project_indicators_url, notice: 'Indicator was successfully created.' }
        format.json { render :show, status: :created, location: @indicator }
      else
        format.html { render :new }
        format.json { render json: @indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indicators/1
  # PATCH/PUT /indicators/1.json
  def update
    respond_to do |format|
      if @indicator.update(indicator_params)
        format.html { redirect_to admin_project_indicators_url, notice: 'Indicator was successfully updated.' }
        format.json { render :show, status: :ok, location: @indicator }
      else
        format.html { render :edit }
        format.json { render json: @indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_global
    # we only want one record for global indicator
    if GlobalIndicator.first.blank?
      @global_indicators = GlobalIndicator.new
    else
      @global_indicators = GlobalIndicator.first
    end
  end

  def save_global
    @global_indicator = GlobalIndicator.find(params[:id])
    respond_to do |format|
      if @global_indicator.update(global_indicator_params)
        format.html { redirect_to global_indicators_url, notice: 'Global Indicator names updated.' }
      else
        format.html { render :edit_global }
        format.json { render json: @global_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indicators/1
  # DELETE /indicators/1.json
  def destroy
    @indicator.destroy
    respond_to do |format|
      format.html { redirect_to admin_project_indicators_url, notice: 'Indicator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_indicator
      @indicator = Indicator.find(params[:id])
    end

    def set_project
      @project = Project.find_by(slug: params[:project_id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def indicator_params
      params.require(:indicator).permit(:indicator_name, :indicator_value, :project_id)
    end

    def global_indicator_params
      params.require(:global_indicator).permit(:primary_indicator_name, :secondary_indicator_name)
    end

    def authenticate_admin
      if !current_user.admin?
        redirect_to root_url, alert: "You must be an admin to see that page!"
      end
    end
end
