class SearchSuggestion
  APP_PREFIX = 'job_tracker'.freeze
  DLMTR = ':'.freeze

  # namespaced-parent keys
  @company_names_key = "#{APP_PREFIX}#{DLMTR}company_names"
  @contact_names_key = "#{APP_PREFIX}#{DLMTR}contact_names"

  # class methods

  # Refresh redis keys for Contact names.
  #   Deletes all existing redis keys for contact names.
  #   Then repopulates with the latest information.
  def self.refresh_contact_names
    delete_by(@contact_names_key)
    seed(Contact, :name, @contact_names_key)
  end

  # Refresh redis keys for Company names.
  #   Deletes all existing redis keys for company names.
  #   Then repopulates with the latest information.
  def self.refresh_company_names
    delete_by(@company_names_key)
    seed(Company, :name, @company_names_key)
  end

  # search for a term return the top x search results.
  # by default, will return the top 10 results.
  # @param query [String], the term to search for
  # @param options [Hash], options for your search
  def self.terms_for(query, options = {})
    options[:min] ||= 0
    options[:max] ||= 9
    options[:parent_set] ||= @company_names_key

    set_key_name = make_sub_set_key(options[:parent_set], query.downcase)
    $redis.zrevrange(set_key_name, options[:min], options[:max])
  end

  # Populate a Redis sorted-set
  # @param model [Constant], the model name as a constant
  # @param attribute [String | Symbol], attribute on model
  # @param namespace_key [String], the key of the parent Redis sorted-set
  def self.seed(model, attribute, namespace_key)
    model.find_each do |record|
      record_val = record.public_send(attribute).to_s
      processed_record_val = record_val.downcase.strip
      record_length = processed_record_val.length
      range = (1..record_length)

      range.each do |ind|
        prefix = processed_record_val[0...ind]
        set_key_name = make_sub_set_key(namespace_key, prefix)
        $redis.zadd(set_key_name, 0, record_val)
      end
    end
  end

  # Delete all Redis keys within a particular namespace. Useful for refreshing.
  # @param namespace_key [String], the namespaced-parent key you wish to delete
  def self.delete_by(namespace_key)
    $redis.keys("#{namespace_key}#{DLMTR}*").each { |key| $redis.del(key) }
  end

  def self.make_sub_set_key(key_of_parent_set, term)
    "#{key_of_parent_set}#{DLMTR}#{term}"
  end
end
