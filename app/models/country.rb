class Country < ActiveRecord::Base
  has_many :project_countries
  has_many :projects, through: :project_countries

  extend FriendlyId
  friendly_id :name, use: :slugged

  def self.aggregate_indicators(country_id, search_disease, search_project)
    @total_projects = 0
    @primary_indicator = 0
    @secondary_indicator = 0
    Country.find(country_id).projects.each do |project|
      if !search_disease && !search_project
        iterate_indicators(project)
      elsif project.id == search_project.to_i
        iterate_indicators(project)
      elsif project.diseases.collect(&:id).include? search_disease.to_i
        iterate_indicators(project)
      end
    end
    return {
      total_projects: @total_projects,
      primary_indicator: @primary_indicator,
      secondary_indicator: @secondary_indicator
    }
  end

  def self.iterate_indicators(project)
    @total_projects += 1
    @primary_indicator += project.primary_indicator_value || 0
    @secondary_indicator += project.secondary_indicator_value || 0
  end

end
