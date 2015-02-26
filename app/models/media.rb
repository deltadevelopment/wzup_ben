class Media < ActiveRecord::Base

  belongs_to :status

  validates :name, uniqueness: true, presence: true
  validates_format_of :name, :with => /b[0-9a-f]{5,40}/, :message => "must be SHA-1 sum"

  validates :media_type, presence: true, numericality: { only_integer: true, less_than: 2 }

end
