class Serializer
  class << self
    def attribute(name, &block)
      attributes[name.to_sym] = block || name.to_sym
    end

    def attributes
      @attributes ||= inherited_attributes.dup
    end

    private

    def inherited_attributes
      return {} unless superclass.respond_to?(:attributes)

      superclass.attributes
    end
  end

  def initialize(object)
    @object = object
  end

  def serialize
    self.class.attributes.each_with_object({}) do |(name, extractor), payload|
      payload[name] = extract_value(extractor)
    end
  end

  private

  attr_reader :object

  def extract_value(extractor)
    return instance_exec(&extractor) if extractor.is_a?(Proc)

    object.public_send(extractor)
  rescue NoMethodError => e
    raise NoMethodError, "Unable to serialize attribute for #{self.class}: #{e.message}"
  end
end
