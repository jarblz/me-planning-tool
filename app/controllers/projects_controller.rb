class ProjectsController < ApplicationController

  # GET /projects/1
  # GET /projects/1.json
  def show
    @country = Country.select("*, st_asgeojson(polygon) as geo").
      where(id: params[:country_id]).first
    @project = Project.find(params[:project_id])
    @country_geometry = Array.new
    @country_indicators = Country.aggregate_indicators(@country.id)
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



  private

end
