class PlaySignal < ApplicationRecord
  belongs_to :user

  validates :message, :lat, :lng, presence: true

  def self.all_active
    PlaySignal.all.select { |signal| signal.active? }
  end

  def active?
    end_time && DateTime.current < end_time && published?
  end
end
