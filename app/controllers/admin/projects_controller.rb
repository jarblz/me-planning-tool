class Admin::ProjectsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_countries_and_diseases, only: [:new, :edit]
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        ProjectCountry.refresh_all_countries(project_country_params, @project.id)
        ProjectDisease.refresh_all_diseases(project_disease_params, @project.id)
        format.html { redirect_to admin_projects_url, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    ProjectCountry.refresh_all_countries(project_country_params, @project.id)
    ProjectDisease.refresh_all_diseases(project_disease_params, @project.id)

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to admin_projects_url, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to admin_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_countries_and_diseases
    # here we are instantiating objects for the form, we need the selection to exclude
    # existing project_countries and project_diseases, I'm replacing an empty list with [0]
    # to indicate all, as activerecord never assigns the primary id of 0 to a record
    if !@project
      @project = Project.new
    end
    project_ids = @project.countries.ids.blank? ? [0] : @project.countries.ids
    disease_ids = @project.diseases.ids.blank? ? [0] : @project.diseases.ids
    @countries = Country.where("id NOT IN (?)", project_ids)
    @diseases = Disease.where("id NOT IN (?)", disease_ids)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find_by(slug: params[:id])
      @project_countries = ProjectCountry.where(project_id: @project.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(
        :name, :lead, :contact_email,
        :contact_phone, :description,
        :funding_start, :funding_end,
        :primary_indicator_name,:primary_indicator_value,
        :secondary_indicator_name,:secondary_indicator_value,
        :donor
      )
    end

    def project_country_params
      params.require(:project).require(:project_countries).permit(country_ids: [] )[:country_ids]
    end

    def project_disease_params
      params.require(:project).require(:project_diseases).permit(disease_ids: [] )[:disease_ids]
    end

    def authenticate_admin
      if !current_user.admin?
        redirect_to root_url, alert: "You must be an admin to see that page!"
      end
    end

end
