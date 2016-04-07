require 'spec_helper'

describe server(:gw_jp) do
  describe firewall(server(:gw_uk)) do
    it { is_expected.to be_reachable }
  end
end
