class CountriesController < ApplicationController

  # GET /countries/1
  # GET /countries/1.json
  def show
    @country = Country.friendly.select("*, st_asgeojson(polygon) as geo").
      where(slug: params[:id]).first
    if !params['project_ids']
      @projects = @country.projects
    else
      @projects = Project.find(params['project_ids'])
    end
    @country_geometry = Array.new
    @diseases = Disease.all
    @country_indicators = Country.aggregate_indicators(@country.id, search_disease = nil, search_project = nil)
    @search_project = params[:search_project]
    @search_disease = params[:search_disease]
    @country_geometry = {
      type: "Feature",
      geometry: @country.geo,
      properties: {
        name: @country.name,
        id: @country.id,
        country_indicators: @country_indicators,
        root_url: root_url
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
        search_projects = Project.projects_by_disease(search_projects, params['disease_id'])
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
