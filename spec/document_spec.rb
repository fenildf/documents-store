# coding: utf-8
require "spec_helper"

module DocumentsStore
  describe Document do
    let(:creator_id)     {"1"}
    let(:last_editor_id) {"2"}

    it "综合测试" do
      note = Document.create(
        :title => "title",
        :content => "content",
        :creator_id => creator_id
      )
      note.id.blank?.should == false
      note.title.should == "title"
      note.content.should == "content"
      note.creator_id.should == creator_id
      note.last_editor_id.should == creator_id
      note = Document.find(note.id)
      note.update_attributes(:content => "contentgai", :last_editor_id => last_editor_id)

      note = Document.find(note.id)
      note.content.should == "contentgai"
      note.last_editor_id.should == last_editor_id
      note.version.should == 2
      note.versions.first.version.should == 1
      note.versions.first.content.should == "content"
      note.versions.first.last_editor_id.should == creator_id
      note.editor_ids.should include(creator_id, last_editor_id)
    end
  end
end
