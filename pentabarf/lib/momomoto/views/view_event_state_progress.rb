module Momomoto
  class View_event_state_progress < Base
    def initialize
      super
      @domain = 'valuelist'
      @fields = {
        :event_state_progress_id => Datatype::Integer.new( {} ),
        :event_state_id => Datatype::Integer.new( {} ),
        :language_id => Datatype::Integer.new( {} ),
        :tag => Datatype::Varchar.new( {:length=>32} ),
        :name => Datatype::Varchar.new( {} ),
        :rank => Datatype::Integer.new( {} ),
        :language_tag => Datatype::Varchar.new( {:length=>32} )
      }
    end
  end
end
