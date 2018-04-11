path = File.join(::Middleman::Application.root, 'lib', 'extensions', '*.rb')
Dir.glob(path).each do |file|
  filename = File.basename(file)
  require_relative "extensions/#{filename}"

  extension_name = File.basename(file, '.*')
  extension_class = extension_name.camelize.constantize
  ::Middleman::Extensions.register(extension_name.to_sym, extension_class)
end
