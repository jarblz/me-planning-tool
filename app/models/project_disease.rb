class ProjectDisease < ActiveRecord::Base
  belongs_to :project
  belongs_to :disease

  def self.refresh_all_diseases(disease_ids, project_id)
    disease_ids.each do |disease_id|
      if !disease_id.blank?
        ProjectDisease.create(disease_id: disease_id, project_id: project_id)
      end
    end
  end

end
