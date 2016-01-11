class ProjectTool < ActiveRecord::Base
  belongs_to :project
  has_attached_file :attachment
  validates :attachment, attachment_presence: true
  # not doing any validations for now since this can be any kind of attachment really
  do_not_validate_attachment_file_type :attachment

end
