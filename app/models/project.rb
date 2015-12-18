class Project < ActiveRecord::Base
  has_many :project_diseases
  has_many :project_countries
  has_many :diseases, through: :project_diseases
  has_many :countries, through: :project_countries
  has_many :indicators

  accepts_nested_attributes_for :diseases
  accepts_nested_attributes_for :countries

  before_destroy :destroy_relations

  def destroy_relations
    ProjectCountry.destroy_all(project_id: self.id)
    ProjectDisease.destroy_all(project_id: self.id)
  end

  def self.projects_by_date(date_params)
    start_date = DateTime.strptime(date_params.split(' - ').first, "%m/%d/%Y")
    end_date = DateTime.strptime(date_params.split(' - ').second, "%m/%d/%Y")
    funding_starts = Project.where(funding_start: start_date..end_date)
    funding_ends = Project.where(funding_end: start_date..end_date)
    # this merge is doing an and, and it should be doing an or
    return funding_starts.merge(funding_ends)
  end

  def self.projects_by_disease(search_projects, id)
    search = Disease.find(id).projects
    if !search.blank?
      return search.where(id: search_projects.ids)
    else
      return search
    end
  end


end
