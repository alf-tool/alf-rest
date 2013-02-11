require "rspec/core/rake_task"

desc "Run unit tests"
RSpec::Core::RakeTask.new(:"test:unit") do |t|
  t.ruby_opts  = ["-I spec/unit"]
  t.rspec_opts = ["--color", "--backtrace"]
  t.pattern    = "spec/unit/**/test_*.rb"
end

desc "Run integration tests"
RSpec::Core::RakeTask.new(:"test:integration") do |t|
  t.ruby_opts  = ["-Ilib", "-I spec/integration"]
  t.rspec_opts = ["--color", "--backtrace"]
  t.pattern    = "spec/integration/**/test_*.rb"
end

task :test => [:"test:unit", :"test:integration"]
