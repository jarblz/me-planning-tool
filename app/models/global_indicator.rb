class GlobalIndicator < ActiveRecord::Base
  validates :primary_indicator_name, presence: true
  validates :secondary_indicator_name, presence: true
end
