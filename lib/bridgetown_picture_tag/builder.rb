module BridgetownPictureTag
  class Builder < Bridgetown::Builder
    Context = Struct.new(:registers)

    def build
      helper 'picture', :generate_picture_tag
    end

    def generate_picture_tag(*args)
      @context = Context.new({ site: site, page: helpers.view.page })

      setup(@context, args)

      if PictureTag.disabled? || PictureTag.raw_params.empty?
        PictureTag::Utils.warning 'You have called JPT without any arguments.'
        ''
      else
        html = PictureTag.output_class.new.to_s
        html.respond_to?(:html_safe) ? html.html_safe : html
      end
    end

    def setup(context, args)
      PictureTag.clear_instructions
      PictureTag.context = context
      PictureTag.raw_params = args

      # We need to explicitly prevent jekyll from overwriting our generated
      # image files:
      PictureTag::Utils.keep_files
    end

    private

    def metadata
      @metadata ||= site.data['site_metadata']
    end
  end
end
