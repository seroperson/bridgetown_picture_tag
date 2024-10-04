Bridgetown.configure do |config|
  init :bridgetown_picture_tag do
    config.picture = {
      suppress_warnings: false,
      output: 'generated_dir'
    }
  end
end
