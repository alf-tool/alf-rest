require "rspec/core/rake_task"

desc "Run tests"
RSpec::Core::RakeTask.new("test:unit".to_sym) do |t|
  t.ruby_opts  = ["-I spec/unit"]
  t.rspec_opts = ["--color", "--backtrace"]
  t.pattern    = "spec/unit/**/test_*.rb"
  t.rspec_opts = ["--color"]
end
