module CodeGenerator
  extend ActiveSupport::Concern

  def generate_code(prefix, id)
    "#{prefix[0, prefix.length - id.to_s.length]}#{id}"
  end
end
