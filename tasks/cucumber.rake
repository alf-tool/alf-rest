require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber => :fixtures) do |t|
  t.cucumber_opts = %w{--format progress}
end
task :test => [:unit, :cucumber]