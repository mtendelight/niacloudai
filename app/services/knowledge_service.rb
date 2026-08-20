# app/services/knowledge_service.rb

class KnowledgeService
  PRODUCT_LIMIT = 1000
  FAQ_LIMIT     = 250
  SAMPLE_LIMIT  = 250

  def self.products(query)
    scope = Aiproduct.order(:bale_name)

    return scope.limit(PRODUCT_LIMIT) if query.blank?

    terms = query.downcase.split.uniq

    sql = []
    values = {}

    terms.each_with_index do |term, i|
      key = :"q#{i}"
      values[key] = "%#{term}%"

      sql << <<~SQL.squish
        LOWER(bale_name) LIKE :#{key}
        OR LOWER(description) LIKE :#{key}
      SQL
    end

    scope
      .where(sql.map { |s| "(#{s})" }.join(" OR "), values)
      .distinct
      .limit(PRODUCT_LIMIT)
  end

  def self.faqs(query)
    scope = Jfaq.order(:question)

    return scope.limit(FAQ_LIMIT) if query.blank?

    terms = query.downcase.split.uniq

    sql = []
    values = {}

    terms.each_with_index do |term, i|
      key = :"q#{i}"
      values[key] = "%#{term}%"

      sql << <<~SQL.squish
        LOWER(question) LIKE :#{key}
        OR LOWER(answer) LIKE :#{key}
        OR LOWER(category) LIKE :#{key}
      SQL
    end

    scope
      .where(sql.map { |s| "(#{s})" }.join(" OR "), values)
      .distinct
      .limit(FAQ_LIMIT)
  end

  def self.samples(query)
    scope = Jsample.order(:bale_name)

    return scope.limit(SAMPLE_LIMIT) if query.blank?

    terms = query.downcase.split.uniq

    sql = []
    values = {}

    terms.each_with_index do |term, i|
      key = :"q#{i}"
      values[key] = "%#{term}%"

      sql << <<~SQL.squish
        LOWER(bale_name) LIKE :#{key}
        OR LOWER(description) LIKE :#{key}
        OR LOWER(price_range) LIKE :#{key}
        OR LOWER(pieces_range) LIKE :#{key}
      SQL
    end

    scope
      .where(sql.map { |s| "(#{s})" }.join(" OR "), values)
      .distinct
      .limit(SAMPLE_LIMIT)
  end
end