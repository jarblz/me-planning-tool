require "net/http"
require 'pry'
require 'georuby'
require 'geo_ruby/kml'        # KML data
require 'geo_ruby/georss'     # GeoRSS
require 'geo_ruby/geojson'    # GeoJSON
require 'rgeo'

task :import_countries_from_fusion => :environment do
  url = 'https://www.googleapis.com/fusiontables/v1/query?'
  url.insert(-1,'sql=')
  # query = "SELECT name, wkt_4326 FROM 1foc3xO9DyfSIF6ofvN0kp2bxSfSeKog5FbdWdQ WHERE name IN ('Morocco','Antarctica','Chile', 'United States', 'South Africa', 'Canada')"
  query = "SELECT name, wkt_4326 FROM 1foc3xO9DyfSIF6ofvN0kp2bxSfSeKog5FbdWdQ"
  # query_primary = "SELECT name, wkt_4326 FROM 1uKyspg-HkChMIntZ0N376lMpRzduIjr85UYPpQ"
  url.insert(-1, query)
  url.insert(-1, '&key=AIzaSyAm9yWCV7JPCTHCJut8whOjARd7pwROFDQ')
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body
	result = JSON.parse(data)
  countries = result['rows']
  for country in countries do
    existing_country = Country.where(name: country[0]).first
    if existing_country.blank?
      c = Country.create!(name: country[0], polygon: country[1])
    else
      existing_country.update(polygon: country[1])
    end
  end
end
