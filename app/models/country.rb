class Country < ActiveRecord::Base
  has_many :project_countries
  has_many :projects, through: :project_countries

  extend FriendlyId
  friendly_id :name, use: :slugged

  def self.aggregate_indicators(country_id)
    total_projects = 0
    total_funding = 0.0
    total_treated = 0
    total_trained = 0
    Country.find(country_id).projects.each do |project|
      total_projects += 1
      total_funding += project.total_funding || 0
      total_treated += project.total_treated || 0
      total_trained += project.total_trained || 0
    end
    return { total_projects: total_projects,
      total_funding: total_funding,
      total_treated: total_treated,
      total_trained: total_trained
    }
  end

end
