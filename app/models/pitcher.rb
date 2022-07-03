require "csv"

class Pitcher < ApplicationRecord
  TIER_1_MIN = 20.00
  TIER_3_MAX = 7.50
  TIER_1_HL_MIN = 30.00
  TIER_2_HL_MIN = 15.00
  TIER_3_HL_MAX = 0.00

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
      "<h2>The Top Shelf</h2>\n\n<table style='width: 100%;'><thead><tr><th style='width:40%'>Pitcher</th><th style='width:30%'>First Start</th><th style='width:30%'>Second Start</th></tr></thead><tbody>",
      "<h2>The Well</h2>\n\n<table style='width: 100%;'><thead><tr><th style='width:40%'>Pitcher</th><th style='width:30%'>First Start</th><th style='width:30%'>Second Start</th></tr></thead><tbody>",
      "<h2>The Bar Mat</h2>\n\n<table style='width: 100%;'><thead><tr><th style='width:40%'>Pitcher</th><th style='width:30%'>First Start</th><th style='width:30%'>Second Start</th></tr></thead><tbody>",
    ]

    Pitcher.all.each do |p|
      tables[p.tier] = "#{tables[p.tier]}<tr#{" style='font-weight: bold;'" if p.highlight?}><td>#{p.name}, #{p.team}</td><td>#{p.opp1}</td><td>#{p.opp2}</td></tr>"
    end

    tables.each_with_index do |str, idx|
      tables[idx] = "#{tables[idx]}</tbody></table>\n\n<h3>Notes</h3>\n<ul>\n<li></li>\n</ul>\n\n&nbsp;"
    end

    puts "\n\n"
    puts "--------------- BEGIN OUTPUT ---------------"
    puts "\n\n"
    puts "Intro."
    puts "\n"
    puts "&nbsp;"
    puts "\n"
    puts "<em>The bold pitchers below are the most extreme version of each section. The best of the Top Shelf, the safest of the Well, the worst of the Bar Mat.</em>"

    tables.each do |table|
      puts table
      puts "\n"
    end
    puts "\n"
    puts "---------------- END OUTPUT ----------------"
    puts "\n\n"

    true
  end

  def self.call
    Pitcher.ingest
    Pitcher.generate_output
  end

  def tier
    return 0 if value.to_f >= TIER_1_MIN
    return 2 if value.to_f < TIER_3_MAX
    1
  end

  def highlight?
    case self.tier
    when 0
      value.to_f >= TIER_1_HL_MIN ? true : false
    when 1
      value.to_f >= TIER_2_HL_MIN ? true : false
    when 2
      value.to_f < TIER_3_HL_MAX ? true : false
    else
      false
    end
  end

  def val
    ActionController::Base.helpers.number_to_currency(self[:value])
  end
end
