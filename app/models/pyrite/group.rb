module Pyrite
  class Group < ActiveRecord::Base
    has_many :blocks, :through => :blocks_groups
    has_many :blocks_groups, :dependent => :destroy
    belongs_to :studies

    acts_as_taggable_on :categories

    validates :name, :presence => true, :uniqueness => { :scope => [:studies] }

    scope :for_event, ->(event_id) { where(:event_id => event_id) }
    scope :for_studies, ->(studies_id) {
      where(:studies_id => studies_id).order(:name)
    }
    scope :for_studies_like, ->(study_type_id, study_degree_id) {
      includes(:studies).where("studies.study_type_id = ? and studies.study_degree_id = ?", study_type_id, study_degree_id).order(:name)
    }


    # Return a hash with tag id as key and the array of group ids as the value.
    # It is used to produce data-group-ids for optgroups in select box.
    def self.category_aggregate
      categories = joins("LEFT OUTER JOIN taggings
                          ON taggings.taggable_id = pyrite_groups.id")
                     .joins("LEFT OUTER JOIN tags
                             ON taggings.tag_id = tags.id ")
        .select("pyrite_groups.id, tags.name ").order("tags.name")
      result = {}
      categories.each do |element|
        next unless element.name
        if result[element.name]
          result[element.name] << element.id
        else
          result[element.name] = [element.id]
        end
      end
      result
    end

    def self.categories
      ActsAsTaggableOn::Tag.joins("LEFT OUTER JOIN taggings on taggings.context = 'categoriesa'")
        .select("name").map(&:name)
    end

    def pdf_title
      I18n.t("pyrite.pdf.label.timetable_for_group", :name => name)
    end

  end
end
