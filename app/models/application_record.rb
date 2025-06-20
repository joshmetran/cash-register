class ApplicationRecord < ActiveRecord::Base
  include CodeGenerator
  primary_abstract_class
end
