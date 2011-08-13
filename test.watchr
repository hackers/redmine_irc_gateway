watch('test/test_.*\.rb' ) { |md| system 'rake rig:test:all' }
watch('lib/(.*)\.rb' ) { |md| system 'rake rig:test:all' }
