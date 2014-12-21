class ReplaceNameWithSubjectId < ActiveRecord::Migration
  def up
    add_column :pyrite_blocks, :subject_id, :integer
    # Create all subjects base on existings records
    Pyrite::Block.all.each do |block|
      # We are using attributes here, to make sure that we will operate on real
      # database clomuns not defined method from model.
      block_name = block.attributes["name"]
      if block_name.present?
        subject = Pyrite::Subject.where(:name => block_name).first
        block.subject = subject || Pyrite::Subject.new(:name => block_name)
        block.save
      end
    end
    remove_column :pyrite_blocks, :name
  end


  def down
    add_column :pyrite_blocks, :name, :string
    Pyrite::Block.all.each do |block|
      if block.subject_id
        block.update_attributes(:name => block.subject.try(:name))
      end
    end
    remove_column :pyrite_blocks, :subject_id
  end
end
