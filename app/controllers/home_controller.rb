class HomeController < ApplicationController
  def index
    @diseases = Disease.all
    @projects = Project.all
    @search_params = params['search_params']
    @geometries = Array.new
    if !params['country_ids'].blank?
    @country_geometries = Array.new
      @countries = Country.find(params['country_ids'])
      Country.select("*, st_asgeojson(polygon) as geo").
      where(id: params['country_ids']).each do |result|
        @country_geometries << {
          type: "Feature",
          geometry: result.geo,
          properties: {
            name: result.name,
            id: result.id,
            country_indicators: Country.aggregate_indicators(result.id),
            root_url: root_url
          }
        }
      end
      else
      # setting nil here because I am calling .html_safe in the view, which complains
      # if the target is nil or []
      @country_geometries = ""
    end
    @country_geometries = @country_geometries.to_json
  end

  def countries
    search_projects = Project.projects_by_date(params['date_range'])
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
    redirect_to action: :index, search_params: params, country_ids: country_ids.flatten
  end

end
