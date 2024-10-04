module PictureTag
  module Parsers
    # Global config (big picture). loads bridgetown data/config files, and the b-p-t
    # defaults from included yml files.
    class Configuration
      # returns bridgetown's configuration (picture is a subset)
      def [](key)
        content[key]
      end

      private

      def content
        @content ||= setting_merge(DEFAULT_CONFIG, PictureTag.site.config)
      end

      def setting_merge(default, bridgetown)
        bridgetown.merge default do |_key, config_setting, default_setting|
          if default_setting.respond_to? :merge
            setting_merge(default_setting, config_setting)
          else
            config_setting
          end
        end
      end
    end
  end
end
