class Building < ActiveRecord::Base
  has_many :rooms, :dependent => :destroy

  validates :name, :address, :presence => true
  validate :coordinates

  private

    def coordinates
      if self.latitude.blank? or self.longitude.blank?
        errors.add(:base, I18n.t("error_missing_coordinates"))
      end
    end
end
