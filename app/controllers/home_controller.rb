class HomeController < ApplicationController
  before_action :setup_home, only: :index

  def index
  end

  def countries
    country_ids = get_country_ids(params)
    redirect_to action: :index, search_disease: params['disease_id'], search_project: params['project_id'], country_ids: country_ids.flatten
  end

  private

    def get_country_ids params
      search_projects = Project.all
      if !params['disease_id'].blank?
        search_projects = Project.projects_by_disease(search_projects, params['disease_id'])
      end
      if !params['project_id'].blank?
        search_projects = search_projects.where(id: params['project_id'])
      end
      country_ids = Array.new
      search_projects.each do |project|
        country_ids = country_ids + project.countries.collect(&:id)
      end
      return country_ids
    end

    def setup_home
      @diseases = Disease.all
      @projects = Project.all
      @geometries = Array.new
      if params['country_ids'].blank?
        @country_ids = get_country_ids(params)
      else
        @country_ids = params['country_ids']
      end
      @search_project = params['search_project']
      @search_disease = params['search_disease']

      @country_geometries = Array.new
      @countries = Country.find(@country_ids)
      setup_geometries
    end

    def setup_geometries
      Country.select("*, st_asgeojson(polygon) as geo").
      where(id: @country_ids).each do |result|
        @country_geometries << {
          type: "Feature",
          geometry: result.geo,
          properties: {
            name: result.name,
            id: result.id,
            country_indicators: Country.aggregate_indicators(result.id),
            root_url: root_url,
            slug: result.slug
          }
        }
      end
      @country_geometries = @country_geometries.to_json
    end

end
