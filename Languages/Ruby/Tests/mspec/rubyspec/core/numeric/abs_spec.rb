require File.dirname(__FILE__) + '/shared/abs'

describe "Numeric#abs" do
  it_behaves_like(:numeric_abs, :abs)
end