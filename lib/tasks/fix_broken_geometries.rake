require "net/http"
require 'rake'
require 'pry'
require 'georuby'
require 'geo_ruby/kml'        # KML data
require 'geo_ruby/georss'     # GeoRSS
require 'geo_ruby/geojson'    # GeoJSON
require 'rgeo'

task :fix_broken_geometries => :environment do
  url = 'https://www.googleapis.com/fusiontables/v1/query?'
  url.insert(-1,'sql=')
  # query = "SELECT name, wkt_4326 FROM 1foc3xO9DyfSIF6ofvN0kp2bxSfSeKog5FbdWdQ WHERE name IN ('Morocco','Antarctica','Chile', 'United States', 'South Africa', 'Canada')"
  # query_secondary = "SELECT name, wkt_4326 FROM 1foc3xO9DyfSIF6ofvN0kp2bxSfSeKog5FbdWdQ"
  broken_records = Country.where(polygon: nil)
  broken_string = ""
  broken_countries = broken_records.map {|country| broken_string.insert(-1, "'#{country.name}',")}
  broken_string.chomp!(',')
  query = "SELECT name, wkt_4326 FROM 1uKyspg-HkChMIntZ0N376lMpRzduIjr85UYPpQ WHERE name IN (#{broken_string})"
  url.insert(-1, query)
  url.insert(-1, '&key=AIzaSyAm9yWCV7JPCTHCJut8whOjARd7pwROFDQ')
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body
	result = JSON.parse(data)
  api_countries = result['rows']
  for country in api_countries do
    broke_country = Country.where(name: country[0]).first
    puts country[1]
    STDOUT.puts "******* enter new value for #{country[0]} **********"
    # broke_country.update(polygon: new_country_poly)
    binding.pry
    if broke_country.polygon.nil?
      puts "polygon still nil ;( try again later"
    end
  end
end
