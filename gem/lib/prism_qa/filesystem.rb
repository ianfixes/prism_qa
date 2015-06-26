require 'pathname'
require_relative 'exceptions'

# return true if the other_path is deeper than or equal to the base path
# http://stackoverflow.com/a/26878510/2063546
def ancestor?(base, other_path)
  base_parts = File.expand_path(base).split('/')
  path_parts = File.expand_path(other_path).split('/')
  path_parts[0..base_parts.size-1] == base_parts
end

# return the relative path from a document in a web root to a media element, given full paths to each
def web_relative_path(web_root, base_document, child_element)
  c = File.expand_path(child_element)
  r = File.expand_path(web_root)
  unless ancestor?(r, c)
    raise PrismQA::OperationalError, "Child element '#{c}' is not an ancestor of the web root '#{r}'"
  end
  base = Pathname.new (File.dirname(File.expand_path(base_document)))
  elem = Pathname.new c
  (elem.relative_path_from base).to_s
end
