require "csv"

class Pitcher < ApplicationRecord
  def self.ingest
    Pitcher.destroy_all

    CSV.foreach("data/razzball.csv", headers: true) do |row|
      opp1, opp2 = row["Opp"].split("/ ")
      Pitcher.create(
        name: row["Name"],
        team: row["Team"],
        opp1: opp1,
        opp2: opp2,
        value: row["$"]
      )
    end
  end

  def self.generate_output
    tables = [
      "<table style='width: 100%;'><thead><tr><th style='width:40%'>Pitcher</th><th style='width:30%'>First Start</th><th style='width:30%'>Second Start</th></tr></thead><tbody>",
      "<table style='width: 100%;'><thead><tr><th style='width:40%'>Pitcher</th><th style='width:30%'>First Start</th><th style='width:30%'>Second Start</th></tr></thead><tbody>",
      "<table style='width: 100%;'><thead><tr><th style='width:40%'>Pitcher</th><th style='width:30%'>First Start</th><th style='width:30%'>Second Start</th></tr></thead><tbody>",
    ]

    Pitcher.all.each do |p|
      tables[p.tier] = "#{tables[p.tier]}<tr><td>#{p.name}, #{p.team}</td><td>#{p.opp1}</td><td>#{p.opp2}</td></tr>"
    end

    tables.each_with_index do |str, idx|
      tables[idx] = "#{tables[idx]}</tbody></table>"
    end

    tables.each do |table|
      puts "\n"
      puts table
      puts "\n"
    end

    true
  end

  def self.main
    Pitcher.ingest
    Pitcher.generate_output
  end

  def tier
    return 0 if value.to_f > 24.99
    return 2 if value.to_f < 10.00
    1
  end

  def val
    ActionController::Base.helpers.number_to_currency(self[:value])
  end
end
