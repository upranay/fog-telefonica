require "test_helper"

describe "when microversion" do
  before do
    @microversion_tester = TestMicroVersion.new
  end

  describe "is nil" do
    it "should not appear in headers" do
      merged_headers = @microversion_tester.headers({})
      merged_headers.key?("X-Test-Header").must_equal false
    end
  end

  describe "is set with a value" do
    it "should appear in headers with proper value" do
      @microversion_tester.instance_variable_set(:@microversion, "2.15")
      @microversion_tester.instance_variable_set(:@microversion_key, "X-Test-Header")
      merged_headers = @microversion_tester.headers({})
      merged_headers.key?("X-Test-Header").must_equal true
      merged_headers["X-Test-Header"].must_equal "2.15"
    end
  end

  describe "is empty" do
    it "should not appear in headers" do
      @microversion_tester.instance_variable_set(:@microversion, "")
      @microversion_tester.instance_variable_set(:@microversion_key, "X-Test-Header")
      merged_headers = @microversion_tester.headers({})
      merged_headers.key?("X-Test-Header").must_equal false
    end
  end

  class TestMicroVersion
    include Fog::Telefonica::Core
    public :headers
  end
end
