class CountriesController < ApplicationController

  # GET /countries/1
  # GET /countries/1.json
  def show
    @country = Country.friendly.select("*, st_asgeojson(polygon) as geo").
      where(slug: params[:id]).first
    @projects = @country.projects
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
