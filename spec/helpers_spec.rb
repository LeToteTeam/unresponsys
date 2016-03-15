require 'spec_helper'

describe 'Monkey patches' do
  describe Object do
    it 'converts to responsys' do
      obj = Object.new
      expect(obj.to_responsys).to eq obj.to_s
    end
  end

  describe String do
    it 'converts to int' do
      expect('123'.to_ruby).to eq 123
    end

    it 'doesnt convert hex strings to int' do
      expect('1e9993'.to_ruby).to eq '1e9993'
    end

    it 'converts to float' do
      expect('1.23'.to_ruby).to eq 1.23
    end

    it 'doesnt convert hex strings to float' do
      expect('1e9993'.to_ruby).to eq '1e9993'
    end
  end
end
