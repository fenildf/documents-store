module DocumentsStore
  class Document
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Versioning

    field :title,          :type => String
    field :content,        :type => String
    field :last_editor_id, :type => String
    field :creator_id,     :type => String
    field :editor_ids,     :type => Array, :default => []

    before_create do |doc|
      doc.last_editor_id = doc.creator_id
      doc.editor_ids << doc.creator_id
    end

    before_save do |doc|
      id = doc.last_editor_id

      if id.present? && !doc.editor_ids.include?(id)
        doc.editor_ids << id
      end
    end

    def html_content
      markdown = Redcarpet::Markdown.new(HTMLwithPygments, fenced_code_blocks: true)
      markdown.render(content).html_safe
    end

    class HTMLwithPygments < Redcarpet::Render::HTML
      def block_code(code, language)
        Pygments.highlight(code, lexer: language)
      end
    end
  end
end
