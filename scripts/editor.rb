# Edit each blog post to include the 'kind' and 'created_at' attributes.
# Usage: `ruby ./scripts/editor.rb content/blog`

require 'yaml'
require 'time'

Dir.glob(ARGV[0] + '/*.md') do |file|
  # Open the file.
  s = File.open(file, 'r+')
  filename = File.basename(file, '.md')

  # Split the file by the '---' separator.
  puts "Processing #{file}..."
  split = s.read.split(/-{3}\s*/)
  yaml = YAML.load(split[1])

  # Create a hash to store the YAML front formatter. Include the 'kind' and
  # 'layout' attributes.
  hash = {
    'kind' => 'article',
    'layout' => 'post',
    'excerpt' => '',
  }

  # Get the 'title' from the YAML formatter.
  hash['title'] = yaml['title']

  # Get the 'created' from the YAML front formatter and add 'created_at' if it's
  # available. If not, create the 'created_at' attribute based on the filename.
  # Convert timestamp to the format 'Aug 24 2010' too.
  if yaml.has_key?('created')
    hash['created_at'] = Time.at(yaml['created']).strftime('%b %-d %Y')
  else
    date = /^(\d{4})-(\d{2})-(\d{2})/.match(filename)
    hash['created_at'] = Time.parse(date.to_s).strftime('%b %-d %Y')
  end

  # Get the 'tags' from the YAML front formatter.
  hash['tags'] = yaml['tags']

  # Substitute '{% highlight [language] %}...{% endhighlight %}' with
  # '~~~ [language]...~~~'.
  content = split[2].strip.gsub(/\{% highlight (\w*) %\}(.*?)\{% endhighlight %\}/m, '~~~ \1\2~~~')

  # Delete the current file.
  File.delete(file)

  # Write the content to a new file. New filenames will have no dates in 'em.
  new_file = File.open(File.dirname(file) + "/" + filename[11..-1] + '.md', 'w+')
  new_file.write("#{hash.to_yaml}---\n#{content}")
end
