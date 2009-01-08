require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

require 'rails_generator'

class TestQadminGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    bare_setup
    base_files.each do |file|
      full_path = File.join(APP_ROOT, file)
      FileUtils.mkdir_p(File.dirname(full_path))
      File.open(full_path, 'w') {|f| f << '' }
    end
  end

  def teardown
    bare_teardown
  end

  def test_generator_with_model_without_options
    name = 'Item'
    run_generator('qadmin', [name], sources, :destination => APP_ROOT)
    assert_generated_class('app/controllers/items_controller') do |body|
      assert_match(/qadmin/, body)
    end
    assert_generated_class('test/functional/items_controller_test')
    assert_directory_exists('app/views/items')
    assert_generated_file('app/views/items/_form.html.erb')
    assert_generated_file('app/views/layouts/admin.html.erb')
    assert_directory_exists('public/images/admin/')
  end

  private
  def sources
    [RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..", generator_path))
    ]
  end

  def generator_path
    "rails_generators"
  end
  
  def base_files
    [ 
      'public/stylesheets/style.css',
      'app/views/layouts/main.html.erb',
      'config/routes.rb'
    ]
  end
  
  def silence_generator
    logger_original = Rails::Generator::Base.logger
    myout = StringIO.new
    Rails::Generator::Base.logger = Rails::Generator::SimpleLogger.new(myout)
    yield if block_given?
    Rails::Generator::Base.logger = logger_original
    myout.string
  end
  
end
