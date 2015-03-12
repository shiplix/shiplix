require 'rails_helper'

describe Shiplix::Node do
  let(:node) do
    buffer = Parser::Source::Buffer.new('(string)')
    buffer.source = source

    builder = Shiplix::Builder.new
    parser = Parser::CurrentRuby.new(builder)
    parser.parse(buffer)
  end

  let(:source) { <<-END }
    module SomeModule
      class SomeClass
        class InnerClass < Application
          include Application::Helpers

          def some_method(param)
          end
        end
      end
    end
  END

  describe '#namespace_name' do
    it { expect(node.namespace).to eq 'SomeModule' }

    it 'returns namespaces for classes' do
      some_class, inner_class = *node.each_descendant(:class)

      expect(some_class.namespace).to eq 'SomeModule::SomeClass'
      expect(inner_class.namespace).to eq 'SomeModule::SomeClass::InnerClass'
    end

    it do
      method_node = node.each_descendant(:def).first
      expect(method_node.namespace).to be_nil
    end
  end
end
