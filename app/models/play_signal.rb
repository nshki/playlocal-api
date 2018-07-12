class PlaySignal < ApplicationRecord
  belongs_to :user

  validates :message, :lat, :lng, presence: true

  def active?
    DateTime.current < end_time && published?
  end
end
