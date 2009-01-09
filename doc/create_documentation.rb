#
# This will generate documentation for all snippets in the library
#
# Ruby, Rails and RHTML snippets for the gedit Snippets plugin
# http://github.com/colszowka/gedit-snippets/
#
# gedit-snippets is Copyright (c) 2009 Christoph Olszowka, http://blog.olszowka.de

require 'xmlsimple'
require 'cgi'
require 'haml'
require 'sass'
require 'coderay'

#
# Basic snippet class
#
class Snippet
  attr_accessor :tag, :description, :text
  
  def initialize(options)
    @tag = options[:tag]
    @description = options[:description]
    @text = options[:text]
  end
end

# Initalize snippets collection
snippets = {}

# Go through all xml files in parent directory
Dir.entries(File.join(File.dirname(__FILE__), '..', 'snippets/')) .each do |filename|
  # For each file parse the xml and feed data into the output array
  if filename =~ /\.xml$/
    # Add current filename to the snippets collection hash
    current_snippets = snippets[filename.gsub('.xml', '').gsub("_", ' ').split(" ").map {|w| w.capitalize}.join(' ')] = []
    data = XmlSimple.xml_in(File.join(File.dirname(__FILE__), '..', 'snippets/', filename))
    data["snippet"].each do |snippet|
      current_snippets << Snippet.new(:tag => snippet["tag"].to_s,
                                      :description => snippet["description"].to_s,
                                      :text => snippet["text"].to_s)
    end
  end
end

# Generate the HTML with a little help from haml and sass
File.open(File.join(File.dirname(__FILE__), '..', 'cheatsheet.html'), "w+") do |file|
  haml = Haml::Engine.new(File.read(File.join(File.dirname(__FILE__), 'documentation_template.haml')))
  css = Sass::Engine.new(File.read(File.join(File.dirname(__FILE__), 'documentation_stylesheet.sass')))
  file.puts haml.render(Object.new, :snippets => snippets, :css => css.render)
end
