# app/services/trend_fetcher.rb
require "httparty"
require "nokogiri"

class TrendFetcher
  include HTTParty

  PLATFORM_WEIGHTS = {
    "google" => 5,
    "x" => 4,
    "tiktok" => 3,
    "instagram" => 2,
    "facebook" => 1
  }

  def self.call
    new.call
  end

  def call
    Rails.logger.info("🔥 Fetching trends...")

    fetch_x_trends
    fetch_google_trends
    fetch_tiktok_trends
    fetch_instagram_trends
    fetch_facebook_trends

    boost_cross_platform

    Rails.logger.info("✅ Done fetching trends")
  end

  # 🐦 X
  def fetch_x_trends
    url = "https://trends24.in/kenya/"
    res = HTTParty.get(url)

    doc = Nokogiri::HTML(res.body)

    doc.css(".trend-card__list li").first(20).each do |li|
      name = li.text.strip.gsub(/\d+K? tweets?/i, "")
      save_trend(name, "x")
    end

  rescue => e
    Rails.logger.error("❌ X fetch failed: #{e.message}")
  end

  # 🌍 Google
  def fetch_google_trends
    url = "https://trends.google.com/trends/trendingsearches/daily/rss?geo=KE"

    res = HTTParty.get(url, headers: {
      "User-Agent" => "Mozilla/5.0",
      "Accept" => "application/rss+xml"
    })

    return if res.body.blank?

    doc = Nokogiri::XML(res.body)

    doc.xpath("//item/title").each do |node|
      name = node.text.strip.gsub(/ - .*/, "")
      save_trend(name, "google")
    end

  rescue => e
    Rails.logger.error("❌ Google fetch failed: #{e.message}")
  end

  # 🎵 TikTok (fallback)
  def fetch_tiktok_trends
    [
      "Nairobi Street Interviews",
      "Amapiano Dance Challenge",
      "Gen Z POV Kenya",
      "Hustle Stories KE",
      "Relationship Talk Kenya",
      "Campus Life KE",
      "Outfit Transition Kenya"
    ].each { |name| save_trend(name, "tiktok") }
  end

  # 📸 Instagram
  def fetch_instagram_trends
    [
      "Outfit of the Day KE",
      "Soft Life Kenya",
      "Gym Transformation",
      "Travel Kenya Reels"
    ].each { |name| save_trend(name, "instagram") }
  end

  # 📘 Facebook
  def fetch_facebook_trends
    [
      "Nairobi Gossip Stories",
      "Relationship Advice KE",
      "Business Hustle Stories",
      "Funny Kenyan Videos"
    ].each { |name| save_trend(name, "facebook") }
  end

  # 🔥 Normalize
  def normalize(name)
    name.downcase
        .gsub(/[#@]/, "")
        .gsub(/kenya|nairobi|ke/, "")
        .strip
  end

  # 💾 Smart Save
  def save_trend(name, platform)
    return if name.blank?

    clean = normalize(name)

    trend = Trend.where("name LIKE ?", "%#{clean}%").first

    if trend
      trend.frequency ||= 0
      trend.source_count ||= 0
      trend.score ||= 0

      trend.frequency += 1
      trend.source_count += 1
      trend.score += PLATFORM_WEIGHTS[platform] || 1
    else
      trend = Trend.new(
        name: clean,
        platform: platform,
        frequency: 1,
        source_count: 1,
        score: PLATFORM_WEIGHTS[platform] || 1
      )
    end

    trend.last_seen_at = Time.current
    trend.save!

    Rails.logger.info("🔥 #{clean} | score: #{trend.score}")

  rescue => e
    Rails.logger.error("❌ Save failed: #{e.message}")
  end

  # 🚀 Boost multi-platform trends
  def boost_cross_platform
    Trend.group(:name)
         .having("COUNT(DISTINCT platform) > 1")
         .pluck(:name)
         .each do |name|
      Trend.where(name: name).update_all("score = score + 5")
    end
  end
end