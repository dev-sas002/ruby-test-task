require "date"
require_relative "spec_helper"
require_relative "../app/comment"
require_relative "../app/comment_serializer"

RSpec.describe CommentSerializer do
  subject { described_class.new(comment) }

  let(:comment) do
    Comment.new(1, "2020 is the year of Ruby!")
  end

  it "serializes object" do
    expect(subject.serialize).to eq({
      id: 1,
      body: "2020 is the year of Ruby!",
    })
  end

  it "does not serialize unknown attributes" do
    expect(subject.serialize).not_to have_key(:title)
  end
end
