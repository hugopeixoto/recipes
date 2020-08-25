#!/usr/bin/env ruby

require 'microformats'
require 'mustache'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'microformats'
  gem 'mustache'
end

articles = Dir["src/assets/*.html"]
  .reject { |x| x == "src/assets/index.html" }
  .map do |filename|
    {
      path: "./#{File.basename(filename)}",
      name: Microformats.parse(File.read(filename)).recipe&.name,
    }
  end

FileUtils.mkdir_p("public")
File.write("public/index.html", Mustache.render(File.read("src/index.mustache"), { articles: articles }))

Dir["src/assets/*"].each do |filename|
  FileUtils.cp(filename, "public/")
end
