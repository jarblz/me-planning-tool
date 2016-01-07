class CountriesController < ApplicationController

  # GET /countries/1
  # GET /countries/1.json
  def show
    @country = Country.friendly.select("*, st_asgeojson(polygon) as geo").
      where(slug: params[:id]).first
    if params[:search_disease]
      @projects = @country.projects.projects_by_disease(params['search_disease'])
    elsif params[:search_project]
      # putting this in brackets so it's pluralized like the other cases
      @projects = [@country.projects.find(params['search_project'])]
    else
      @projects = @country.projects
    end
    @country_geometry = Array.new
    @diseases = Disease.all
    @country_indicators = Country.aggregate_indicators(@country.id, search_disease = params[:search_disease], search_project = params[:search_project])
    @search_project = params[:search_project]
    @search_disease = params[:search_disease]
    @search_project_name = Project.where(id: @search_project).first.try(:name)
    @search_disease_name = Disease.where(id: @search_disease).first.try(:name)
    @primary_indicator_name = GlobalIndicator.first.primary_indicator_name
    @secondary_indicator_name = GlobalIndicator.first.secondary_indicator_name
    @country_geometry = {
      type: "Feature",
      geometry: @country.geo,
      properties: {
        name: @country.name,
        id: @country.id,
        country_indicators: @country_indicators,
        root_url: root_url,
        slug: @country.slug
      }
    }
    @country_geometry = @country_geometry.to_json
  end

  def projects
    project_ids = get_project_ids(params)
    redirect_to action: :show, id: params['country_slug'], search_disease: params['disease_id'], search_project: params['project_id'], project_ids: project_ids
  end

  private

    def get_project_ids(params)
      search_projects = Project.all
      if !params['disease_id'].blank?
        search_projects = Project.projects_by_disease(params['disease_id'])
      end
      if !params['project_id'].blank?
        search_projects = search_projects.where(id: params['project_id'])
      end
      project_ids = Array.new
      search_projects.each do |project|
        project_ids << project.id
      end
      return project_ids
    end

end
