require "rubygems"
require "rake/testtask"
require "rake/clean"
require "rake/gempackagetask"

CLEAN.include("pkg")

spec = Gem::Specification.new do |s|
  s.name = "bloodymines"
  s.version = "0.1.2"
  s.summary = "A minesweeper-like game."
  s.description = %{Play a minesweeper-like game in your terminal}
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] + Dir['bin/*']
  s.author = "Ömür Özkir"
  s.email = "darkoem@gmal.com"
  s.homepage = "http://darkno.de"
  s.executables = ["bloodymines"]
end

task :default => [:clean, :package]

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*.rb']
    t.verbose = true
end

Rake::GemPackageTask.new(spec) {}
