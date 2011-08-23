# vim: ft=ruby

def run_tests
  system 'rake rig:test:all'
end

watch 'test/test_.*\.rb' do |md|
  system "ruby #{md[0]}"
end

watch('lib/(.*)\.rb') do |md|
  system "ruby test/test_#{File.basename(md[1])}.rb"
end
