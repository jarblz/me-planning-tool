class Country < ActiveRecord::Base
  has_many :project_countries
  has_many :projects, through: :project_countries

  extend FriendlyId
  friendly_id :name, use: :slugged

  def self.aggregate_indicators(country_id, search_disease, search_project)
    @total_projects = 0
    @total_funding = 0.0
    @total_treated = 0
    @total_trained = 0
    Country.find(country_id).projects.each do |project|
      if !search_disease && !search_project
        iterate_indicators(project)
      elsif project.name == search_project
        iterate_indicators(project)
      elsif project.diseases.collect(&:id).include? search_disease.to_i
        iterate_indicators(project)
      end
    end
    return { total_projects: @total_projects,
      total_funding: @total_funding,
      total_treated: @total_treated,
      total_trained: @total_trained
    }
  end

  def self.iterate_indicators(project)
    @total_projects += 1
    @total_funding += project.total_funding || 0
    @total_treated += project.total_treated || 0
    @total_trained += project.total_trained || 0
  end

end
