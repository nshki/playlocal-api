class PlaySignal < ApplicationRecord
  belongs_to :user

  validates :message, :lat, :lng, presence: true
  validate :end_time_cannot_be_in_past_on_publish

  def self.all_active
    PlaySignal.includes(user: :identities).where(
      end_time: DateTime.current..Float::INFINITY,
      published: true,
    )
  end

  def active?
    end_time && DateTime.current < end_time && published?
  end

  private

    def end_time_cannot_be_in_past_on_publish
      if published && end_time < DateTime.current
        errors.add(:end_time, "can't be in the past")
      end
    end
end
