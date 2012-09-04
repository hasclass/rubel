require 'spec_helper'

describe 'Rubel::Message' do
  context 'with no arguments - round()' do
    subject { Rubel::Message.new(:round) }
    let(:target) { 1.23456 }

    it 'should run when using call' do
      subject.call(target).should eql(1)
    end

    it 'should run using to_proc' do
      target.instance_exec(&subject).should eql(1)
    end
  end

  context 'with arguments - round(2)' do
    subject { Rubel::Message.new(:round, [2]) }
    let(:target) { 1.23456 }

    it 'should run when using call' do
      subject.call(target).should eql(1.23)
    end

    it 'should run using to_proc' do
      target.instance_exec(&subject).should eql(1.23)
    end
  end
end
