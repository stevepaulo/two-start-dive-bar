class App
  def self.call
    Pitcher.ingest
    Pitcher.generate_output
  end
end
