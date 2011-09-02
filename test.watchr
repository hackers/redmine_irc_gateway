# vim: ft=ruby
# Run me with:
#   $ watchr tests.watchr

# --------------------------------------------------
# Rules
# --------------------------------------------------
watch( 'test/test_.*\.rb'      ) { |md| ruby md[0] }
watch( 'lib/(.*)\.rb'          ) { |md| ruby "test/test_#{File.basename(md[1])}.rb" }
watch( '^test/test_helper\.rb' ) { run 'rake rig:test:all' }


# --------------------------------------------------
# Helpers
# --------------------------------------------------
def ruby(*paths)
  run "ruby #{paths.flatten.join(' ')}"
end

def run cmd
  puts cmd
  system cmd
end
