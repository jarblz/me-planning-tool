class ProjectCountry < ActiveRecord::Base
  belongs_to :project
  belongs_to :country

  def self.refresh_all_countries(country_ids, project_id)
    country_ids.each do |country_id|
      if !country_id.blank?
        ProjectCountry.create(country_id: country_id, project_id: project_id)
      end
    end
  end

end
