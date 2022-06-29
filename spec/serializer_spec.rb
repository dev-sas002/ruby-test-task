require_relative "spec_helper"
require_relative "../app/serializer"

RSpec.describe Serializer do
  describe ".attribute" do
    let(:base_serializer) do
      Class.new(described_class) do
        attribute :id
      end
    end

    let(:child_serializer) do
      Class.new(base_serializer) do
        attribute :label do
          object.name.upcase
        end
      end
    end

    let(:entity) { Struct.new(:id, :name).new(7, "ruby") }

    it "inherits parent attributes and appends child attributes" do
      expect(child_serializer.new(entity).serialize).to eq({
        id: 7,
        label: "RUBY",
      })
    end

    it "does not mutate parent serializer attributes when child changes" do
      expect(base_serializer.new(entity).serialize).to eq({
        id: 7,
      })
    end
  end

  describe "#serialize" do
    let(:invalid_serializer) do
      Class.new(described_class) do
        attribute :missing_field
      end
    end

    let(:entity) { Struct.new(:id).new(1) }

    it "raises a descriptive error when the object misses an attribute" do
      expect { invalid_serializer.new(entity).serialize }
        .to raise_error(NoMethodError, /Unable to serialize attribute/)
    end
  end
end
