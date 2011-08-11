require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Japanese::PosString do
  subject{ Japanese::PosString.new('string') }
  it{ should be_frozen }
  it 'dup of a PosString should be a String' do
    subject.dup.should be_a String
  end
end
