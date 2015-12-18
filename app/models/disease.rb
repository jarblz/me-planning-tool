class Disease < ActiveRecord::Base
  has_many :project_diseases
  has_many :projects, through: :project_diseases
end
