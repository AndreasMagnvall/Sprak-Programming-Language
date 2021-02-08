require "./sprak"
require 'test/unit'

class Spraktest < Test::Unit::TestCase
    def test_simple

        rd = Sprak.new
        code = File.read("./code")



        assert_equal(90, rd.parse('return 90'))

        assert_equal(10, rd.parse('
            if true
            {
                return 10
            }
            '))

        assert_equal(10, rd.parse('
            if false
            {
                return 20
            }
            else if true
            {
                return 10
            }
            '))
        assert_equal(10, rd.parse('
            if false
            {
                return 20
            }
            else if false
            {
                return 20
            }
            else
            {
                return 10
            }

            '))
        assert_equal(10, rd.parse('
            if true or false
            {
                return 10
            }
            '))
        assert_equal(true, rd.parse('
            if false or false or false or false or true
            {
                return true
            }
            '))
        assert_equal(false, rd.parse('
            if true and true
            {
                return not true
            }
            '))
        assert_equal(true, rd.parse('
            if 10 < 9
            {
                return true
            }
            '))
        assert_equal(10, rd.parse('
            func test()
            {
                return 10
            }
            return test()

            '))
        assert_equal(1337, rd.parse('
            func test(a)
            {
                return a
            }
            return test(1337)

            '))


    end
end
