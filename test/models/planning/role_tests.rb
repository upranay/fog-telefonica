require "test_helper"

describe "Fog::Telefonica[:planning] | plan" do
  describe "success" do
    before do
      @instance = Fog::Telefonica[:planning].roles.first
      @plan = Fog::Telefonica[:planning].list_plans.body.first
    end

    it "#add_role" do
      @instance.add_to_plan(@plan['uuid']).status.must_equal 201
    end

    it "#remove_role" do
      @instance.remove_from_plan(@plan['uuid']).status.must_equal 200
    end
  end
end
