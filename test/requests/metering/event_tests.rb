require "test_helper"

describe "Fog::Metering[:telefonica] | event requests" do
  before do
    @metering = Fog::Metering[:telefonica]
    @event_format = {
      'message_id' => String,
      'event_type' => String
    }
  end

  describe "success" do
    it "#list_events" do
      @metering.list_events.body.
        must_match_schema([@event_format])
    end

    it "#get_event" do
      @metering.get_event('test').body.
        must_match_schema(@event_format)
    end
  end
end
