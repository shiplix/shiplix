module Lib
  module Test
    class FirstTestClass

      def initialize
        @test = []
      end

      # Public: test method
      #
      # Returns nothing
      def test_method
        @test << 1
        @test << 2

        internal_method
      end

      private

      def internal_method
        puts 'hello'
      end
    end

    class SecondTestClass
      def test_method
        puts 'test'
      end
    end
  end
end
