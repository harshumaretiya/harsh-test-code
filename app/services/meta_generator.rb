# frozen_string_literal: true
class MetaGenerator
  attr_reader :meta_key
  
  def generate!(object)
    return meta_key = {
        current_page: object.current_page,
        next_page: (object.next_page || 0) ,
        total_pages: object.total_pages,
        total_count: object.total_entries
      }
  end
end
