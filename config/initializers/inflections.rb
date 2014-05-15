# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

#irb(main):001:0> "meta".pluralize
#=> "metas"
#irb(main):002:0> "metas".singularize

#Rails3.0.5から"meta"の複数形単数形の扱いが変わった
ActiveSupport::Inflector.inflections do |inflect|
   inflect.plural "meta", "metas"
   inflect.singular 'metas', 'meta'
end

