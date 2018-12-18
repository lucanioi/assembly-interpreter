require 'pathname'

module Assembly
  extend self

  def root_path
    Pathname.new(File.expand_path(__dir__ + '/..'))
  end

  def lib_path
    root_path + 'lib'
  end

  def setup_load_paths
    $LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include? root_path
    $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include? lib_path
  end

  def setup_requires
    Pathname.glob('lib/assembly/**/*.rb') do |path|
      require path
    end
  end

  setup_load_paths
  setup_requires
end
