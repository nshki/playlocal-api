class PlaySignal < ApplicationRecord
  belongs_to :user

  validates :message, :lat, :lng, presence: true

  def self.all_active
    PlaySignal.includes(user: :identities).where(
      end_time: DateTime.current..Float::INFINITY,
      published: true,
    )
  end

  def active?
    end_time && DateTime.current < end_time && published?
  end
end
