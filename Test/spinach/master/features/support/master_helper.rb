require 'capybara/dsl'
require 'capybara/rspec'
include Capybara::DSL
include Capybara::RSpecMatchers
Spinach::FeatureSteps.send(:include, RSpec::Matchers)

class NewImage
  
    def get_path_to_image_for_current_test_of_type(img_type)
          new_path = new_file_path(img_type)
          make_new_image(img_type, new_path)
          format_path_for_os(new_path)
    end
  
  
      def get_base_name_for_new_image(img_type)
        @current_image_name = get_uniq_time_string + "." + img_type.to_s
        def current_image_name
          @current_image_name
        end
        current_image_name
      end
end