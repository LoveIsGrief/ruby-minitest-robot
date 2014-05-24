# Doc at https://github.com/guard/guard#readme

guard :rspec do
	watch(%r{^src/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
	watch(%r{^spec/(.+)\.rb$}) { |m| "spec/#{m[1]}.rb" }
end