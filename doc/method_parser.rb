#
# Simple helper that will parse the given method names into a skeleton for snippets
#
methods = %w{should_assign_to   should_filter_params   should_not_assign_to   should_not_set_the_flash   should_redirect_to   should_render_template   should_render_with_layout   should_render_without_layout   should_respond_with   should_respond_with_content_type   should_return_from_session   should_route   should_set_session   should_set_the_flash_to}

snippet_template = '<snippet>
  <text><![CDATA[__TEXT__]]></text>
  <tag>__TAG__</tag>
  <description>__DESC__</description>
</snippet>'

methods.each do |m|
  name = m.strip.chomp.to_s
  # Generate the tag from method name
  tag = name.split('_').map { |w| w[0..0] }.join('')
  
  # Process the snippet template
  snippet = snippet_template.clone
  snippet.gsub!('__TEXT__', "#{name} ${1:attribute}$0")
  snippet.gsub!('__TAG__', "#{tag}")
  snippet.gsub!('__DESC__', "#{name} ...")
  
  puts snippet
end
