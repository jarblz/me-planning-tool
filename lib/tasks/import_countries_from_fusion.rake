require "net/http"
require 'pry'
require 'georuby'
require 'geo_ruby/kml'        # KML data
require 'geo_ruby/georss'     # GeoRSS
require 'geo_ruby/geojson'    # GeoJSON
require 'rgeo'

task :import_countries_from_fusion => :environment do
  # query = "SELECT name, wkt_4326 FROM 1foc3xO9DyfSIF6ofvN0kp2bxSfSeKog5FbdWdQ WHERE name IN ('Morocco','Antarctica','Chile', 'United States', 'South Africa', 'Canada')"
  query1 = "SELECT name, wkt_4326 FROM 1foc3xO9DyfSIF6ofvN0kp2bxSfSeKog5FbdWdQ"
  query2 = "SELECT name, wkt_4326 FROM 1uKyspg-HkChMIntZ0N376lMpRzduIjr85UYPpQ"
  query_and_save(query1)
  query_and_save(query2)
end

def query_and_save(query)
  url1 = 'https://www.googleapis.com/fusiontables/v1/query?'
  url1.insert(-1,'sql=')
  url1.insert(-1, query)
  url1.insert(-1, '&key=AIzaSyAm9yWCV7JPCTHCJut8whOjARd7pwROFDQ')
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
