RSpec.configure do |config|
  config.before do
    begin
      Object.send(:remove_const, :ParserTest)
    rescue NameError
      # do nothing
    end
  end
end
