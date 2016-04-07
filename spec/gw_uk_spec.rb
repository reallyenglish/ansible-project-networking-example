require 'spec_helper'

describe server(:gw_uk) do
  describe firewall(server(:gw_jp)) do
    it { is_expected.to be_reachable }
  end
end
