module CustomMenu
  module MenuItemPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :caption, :cm
      end
    end

    module InstanceMethods
      def caption_with_cm(project=nil)
        vl = caption_without_cm(project)
        vl = "<span>#{vl}</span>".html_safe if @caption.is_a?(Symbol)
        vl
      end
    end
  end
end